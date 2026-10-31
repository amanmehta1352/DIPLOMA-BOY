"""Dispatcher Robot: the owner's commands from the Control Room -> the right robot.

   python3 robots/dispatcher/dispatcher.py [--dry-run]

Every run (GitHub Actions, every 15 min):
  1. running commands: find their GitHub run, and when it is finished mark done / failed (+ link)
  2. queued commands: check the robot + inputs against robots.json, start its workflow, mark running
Env: SUPABASE_SECRET_KEY (service role, never printed), GITHUB_TOKEN (actions: write), GITHUB_REPOSITORY.
No AI is used. Unknown robots or bad inputs are refused (status failed + reason), never guessed.
"""
import argparse, json, os, re, sys, urllib.request, urllib.error
from datetime import datetime, timezone, timedelta

HERE = os.path.dirname(os.path.abspath(__file__))
SB = os.environ.get('SUPABASE_URL', 'https://wobmtlcpszcntczkebtt.supabase.co').rstrip('/')
SB_KEY = os.environ.get('SUPABASE_SECRET_KEY', '').strip()
GH = os.environ.get('GITHUB_TOKEN', '').strip()
REPO = os.environ.get('GITHUB_REPOSITORY', 'amanmehta1352/DIPLOMA-BOY')
NO_RUN_LIMIT = timedelta(minutes=60)   # started but GitHub never showed a run -> failed


def load_robots():
    with open(os.path.join(HERE, 'robots.json'), encoding='utf8') as f:
        return json.load(f)['robots']


def now(): return datetime.now(timezone.utc)
def iso(d): return d.strftime('%Y-%m-%dT%H:%M:%SZ')
def parse_t(s): return datetime.fromisoformat(str(s).replace('Z', '+00:00')) if s else None


def hide(s):
    s = str(s)
    for k in (SB_KEY, GH):
        if k: s = s.replace(k, '[hidden]')
    return s


# ---------- pure logic (tested offline) ----------
def build_inputs(spec, args):
    """Returns (inputs_for_github, problems). Only listed inputs pass; every value is checked and turned into a string."""
    out, prob = {}, []
    args = args if isinstance(args, dict) else {}
    for k in args:
        if k not in spec['inputs']: prob.append(f'unknown input {k!r}')
    for k, s in spec['inputs'].items():
        v = args.get(k, s.get('default'))
        t = s['type']
        if t == 'int':
            try: v = int(v)
            except (TypeError, ValueError): prob.append(f'{k} must be a number'); continue
            if v < s.get('min', -10**9) or v > s.get('max', 10**9): prob.append(f'{k} must be {s.get("min")}..{s.get("max")}'); continue
            out[k] = str(v)
        elif t == 'bool':
            if isinstance(v, str): v = v.strip().lower() in ('1', 'true', 'yes', 'हाँ')
            out[k] = 'true' if v else 'false'
        elif t == 'slug':
            v = str(v or '').strip()
            if v and not re.fullmatch(r'[a-z0-9_]{2,40}', v): prob.append(f'{k} is not a valid id'); continue
            out[k] = v
        elif t == 'ids':
            v = re.sub(r'\s+', '', str(v or ''))
            if v and not re.fullmatch(r'\d+(,\d+){0,49}', v): prob.append(f'{k} must be numbers separated by commas'); continue
            out[k] = v
        else:
            prob.append(f'{k}: unsupported type')
    return out, prob


def match_run(runs, dispatched_at, taken):
    """The first workflow_dispatch run created at/after the dispatch time that no other command owns."""
    t0 = dispatched_at - timedelta(seconds=15)
    cands = [r for r in runs if r.get('event') == 'workflow_dispatch' and r['id'] not in taken and parse_t(r['created_at']) >= t0]
    cands.sort(key=lambda r: r['created_at'])
    return cands[0] if cands else None


def run_state(run):
    """GitHub run -> (our status, conclusion) ; None while still running."""
    if run.get('status') != 'completed': return None
    c = run.get('conclusion') or 'unknown'
    return ('done' if c == 'success' else 'failed'), c


# ---------- network ----------
def http(url, headers, body=None, method='GET', timeout=60):
    req = urllib.request.Request(url, data=body, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status, r.read()
    except urllib.error.HTTPError as e:
        return e.code, e.read()


def rpc(name, args):
    h = {'apikey': SB_KEY, 'Authorization': 'Bearer ' + SB_KEY, 'Content-Profile': 'mtb', 'Accept-Profile': 'mtb',
         'Content-Type': 'application/json', 'x-actor': 'dispatcher'}
    s, b = http(f'{SB}/rest/v1/rpc/{name}', h, json.dumps(args).encode(), 'POST')
    if s >= 300: raise RuntimeError(f'{name}: HTTP {s} {hide(b[:200])}')
    return json.loads(b) if b else None


def gh(path, body=None, method='GET'):
    h = {'Accept': 'application/vnd.github+json', 'Authorization': 'Bearer ' + GH, 'User-Agent': 'dispatcher-robot',
         'X-GitHub-Api-Version': '2022-11-28'}
    if body is not None: h['Content-Type'] = 'application/json'
    s, b = http(f'https://api.github.com/repos/{REPO}/{path}', h, json.dumps(body).encode() if body is not None else None, method)
    return s, (json.loads(b) if b and b[:1] in (b'{', b'[') else b)


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--dry-run', action='store_true'); a = ap.parse_args()
    if not SB_KEY or not GH: sys.exit('SUPABASE_SECRET_KEY and GITHUB_TOKEN are needed')
    robots = load_robots()
    cmds = rpc('cmd_open', {}) or []
    print(f'open commands: {len(cmds)}')
    set_ = (lambda i, p: print('DRY', i, p)) if a.dry_run else (lambda i, p: rpc('cmd_set', {'p_id': i, 'p': p}))
    taken = {c['run_id'] for c in cmds if c.get('run_id')}
    runs_cache = {}

    def runs_of(wf):
        if wf not in runs_cache:
            s, d = gh(f'actions/workflows/{wf}/runs?event=workflow_dispatch&per_page=30')
            runs_cache[wf] = d.get('workflow_runs', []) if s == 200 and isinstance(d, dict) else []
        return runs_cache[wf]

    # 1. follow running commands
    for c in [c for c in cmds if c['status'] == 'running']:
        wf, t = c.get('workflow'), parse_t(c.get('dispatched_at'))
        if not wf or not t: set_(c['id'], {'status': 'failed', 'finished_at': iso(now()), 'error': 'no workflow recorded'}); continue
        run = next((r for r in runs_of(wf) if r['id'] == c.get('run_id')), None) if c.get('run_id') else match_run(runs_of(wf), t, taken)
        if not run:
            if now() - t > NO_RUN_LIMIT: set_(c['id'], {'status': 'failed', 'finished_at': iso(now()), 'error': 'GitHub did not start the run'})
            continue
        taken.add(run['id'])
        p = {'run_id': run['id'], 'run_url': run.get('html_url')}
        st = run_state(run)
        if st: p.update(status=st[0], conclusion=st[1], finished_at=iso(now()))
        set_(c['id'], p); print(f"#{c['id']} {c['robot']}: run {run['id']} {st or 'still running'}")

    # 2. start queued commands
    for c in [c for c in cmds if c['status'] == 'queued']:
        spec = robots.get(c['robot'])
        if not spec: set_(c['id'], {'status': 'failed', 'finished_at': iso(now()), 'error': 'unknown robot'}); continue
        inputs, prob = build_inputs(spec, c.get('args'))
        if prob: set_(c['id'], {'status': 'failed', 'finished_at': iso(now()), 'error': '; '.join(prob)}); print(f"#{c['id']} refused: {prob}"); continue
        if spec.get('reports'): inputs['command_id'] = str(c['id'])
        if a.dry_run: print('DRY start', c['id'], spec['workflow'], inputs); continue
        t = now()
        s, d = gh(f"actions/workflows/{spec['workflow']}/dispatches", {'ref': 'main', 'inputs': inputs}, 'POST')
        if s == 204:
            set_(c['id'], {'status': 'running', 'workflow': spec['workflow'], 'dispatched_at': iso(t)}); print(f"#{c['id']} started {spec['workflow']}")
        else:
            set_(c['id'], {'status': 'failed', 'finished_at': iso(now()), 'error': f'GitHub refused: HTTP {s} {hide(str(d)[:200])}'}); print(f"#{c['id']} GitHub HTTP {s}")


if __name__ == '__main__':
    main()
