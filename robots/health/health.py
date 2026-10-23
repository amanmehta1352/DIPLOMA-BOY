"""Health Robot (R12). Collects COUNTS ONLY (repo is public) and writes status.json + history.json.
   python3 robots/health/health.py --out OUT_DIR [--prev-dir DIR] [--offline FIXTURE.json]
Env: SUPABASE_SECRET_KEY (service role, never printed), GITHUB_TOKEN, GITHUB_REPOSITORY, SITE_URL.
Contract: docs/status-contract.md  (schema 1)."""
import json, os, sys, time, urllib.request, urllib.error
from datetime import datetime, timezone

APP = 'diploma-boy'
SB = os.environ.get('SUPABASE_URL', 'https://wobmtlcpszcntczkebtt.supabase.co').rstrip('/')
KEY = os.environ.get('SUPABASE_SECRET_KEY', '').strip()
REPO = os.environ.get('GITHUB_REPOSITORY', 'amanmehta1352/DIPLOMA-BOY')
SITE = os.environ.get('SITE_URL', 'https://amanmehta1352.github.io/DIPLOMA-BOY/')
GH = os.environ.get('GITHUB_TOKEN', '').strip()
ROBOT_WORKFLOWS = {  # workflow name -> (label_hi, what it does)
    'Tests': ('✅ Tests', 'हर बदलाव पर ऐप के सारे tests'),
    'Daily backup': ('💾 Backup', 'रोज़ का backup'),
    'NTPC Import': ('📥 Import', 'PDF से draft सवाल'),
    'NTPC Chapter Tag': ('🏷️ Chapter Tag', 'सवाल chapter में'),
    'NTPC Rule Tag': ('🏷️ Rule Tag', 'keyword से chapter'),
    'NTPC Subject Tag': ('🏷️ Subject Tag', 'सवाल subject में'),
    'Import Robot': ('📥 Import (SSC)', 'SSC JE import'),
    'Pattern rebuild': ('🔁 Pattern', 'एक जैसे सवाल जोड़ना'),
    'Health Robot': ('🩺 Health', 'यह रिपोर्ट'),
}

def http(url, headers=None, body=None, method=None, timeout=40):
    req = urllib.request.Request(url, data=body, headers=headers or {}, method=method)
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.status, r.read()

def now(): return datetime.now(timezone.utc)
def iso(d): return d.strftime('%Y-%m-%dT%H:%M:%S+00:00')

def rpc(name, args=None):
    h = {'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Content-Profile': 'mtb',
         'Content-Type': 'application/json', 'x-actor': 'health-robot'}
    s, b = http(f'{SB}/rest/v1/rpc/{name}', h, json.dumps(args or {}).encode(), 'POST')
    return json.loads(b)

def gh(path):
    h = {'Accept': 'application/vnd.github+json', 'User-Agent': 'diploma-boy-health'}
    if GH: h['Authorization'] = 'Bearer ' + GH
    s, b = http(f'https://api.github.com/repos/{REPO}/{path}', h)
    return json.loads(b)

def collect():
    """Live inputs. Every part is optional: a failing source becomes a red check, never a crash."""
    d = {'errors': {}}
    try:
        t = time.time(); s, b = http(SITE + '?health=' + str(int(t))); d['site'] = {'ok': s == 200, 'bytes': len(b), 'ms': int((time.time() - t) * 1000)}
        s, b = http(SITE + 'sw.js?h=' + str(int(t))); import re; m = re.search(r"VERSION\s*=\s*'([^']+)'", b.decode('utf8', 'ignore')); d['site']['sw'] = m.group(1) if m else None
    except Exception as e: d['site'] = {'ok': False}; d['errors']['site'] = type(e).__name__
    try:
        runs = gh('actions/runs?per_page=60')['workflow_runs']
        d['runs'] = [{'name': r['name'], 'branch': r['head_branch'], 'event': r['event'], 'status': r['status'], 'conclusion': r['conclusion'], 'at': r['created_at']} for r in runs]
        d['branches'] = len(gh('branches?per_page=100'))
    except Exception as e: d['runs'] = None; d['errors']['github'] = type(e).__name__
    try: d['db'] = rpc('health_counts')
    except Exception as e: d['db'] = None; d['errors']['supabase'] = type(e).__name__ + (':' + str(e.code) if hasattr(e, 'code') else '')
    return d

def verify_if_due(d, prev):
    """backup read-back is heavy: run it at most once a day, else carry the last result."""
    last = (prev or {}).get('backup_verify')
    if last and (now() - datetime.fromisoformat(last['checked_at'])).total_seconds() < 86400: return last
    try:
        v = rpc('verify_backup'); return {'checked_at': v.get('checked_at') or iso(now()), 'slot': v.get('slot'), 'backup_rows': v.get('backup_rows'),
                                           'missing_in_live': v.get('missing_in_live'), 'changed_since': v.get('changed_since')}
    except Exception as e: d['errors']['verify'] = type(e).__name__; return last

def chk(id, label, state, count=None, detail='', link=None):
    return {'id': id, 'label_hi': label, 'state': state, 'count': count, 'detail': detail, 'link': link}

def build(d, prev=None, at=None):
    at = at or now(); checks = []; db = d.get('db'); runs = d.get('runs')
    site = d.get('site') or {}
    checks.append(chk('site', '🌐 ऐप खुल रहा है', 'ok' if site.get('ok') else 'bad', None, f"{site.get('ms','?')} ms · sw {site.get('sw')}" if site.get('ok') else 'साइट नहीं खुली', SITE))
    if runs is None: checks.append(chk('tests', '✅ Tests (main)', 'bad', None, 'GitHub से रिपोर्ट नहीं मिली'))
    else:
        tm = [r for r in runs if r['name'] == 'Tests' and r['branch'] == 'main' and r['status'] == 'completed']
        if not tm: checks.append(chk('tests', '✅ Tests (main)', 'warn', None, 'अभी कोई run नहीं'))
        else:
            last = tm[0]; ok = last['conclusion'] == 'success'; n = sum(1 for r in tm[:10] if r['conclusion'] == 'success')
            checks.append(chk('tests', '✅ Tests (main)', 'ok' if ok else 'bad', n, f"आख़िरी: {last['conclusion']} · पिछले {min(10,len(tm))} में {n} पास", f'https://github.com/{REPO}/actions'))
        if d.get('branches') is not None: checks.append(chk('branches', '🌿 पुरानी branches', 'ok' if d['branches'] <= 8 else 'warn', d['branches'], 'ज़्यादा हों तो साफ़ करें'))
    if db is None:
        checks.append(chk('db', '🗄️ Database', 'bad', None, 'counts नहीं मिले: ' + str(d['errors'].get('supabase', ''))))
    else:
        f = db.get('published_failing_lock') or 0; why = db.get('published_failing_reasons') or {}
        checks.append(chk('lock', '🔒 Publish ताले की शर्तें तोड़ने वाले live सवाल', 'ok' if f == 0 else 'warn', f, ' · '.join(f'{k}: {v}' for k, v in sorted(why.items(), key=lambda x: -x[1])) or 'कोई नहीं'))
        pp = db.get('published_picture') or 0
        checks.append(chk('figures', '🖼️ Live picture वाले सवाल (जाँच बाकी)', 'ok' if pp == 0 else 'warn', pp, f"draft figure सवाल: {db.get('draft_figure')}"))
        ib = db.get('published_in_inbox') or 0
        checks.append(chk('inbox', '🏷️ बिना chapter (inbox) live सवाल', 'ok' if ib == 0 else 'warn', ib, 'chapter तय होना बाकी'))
        ro = db.get('reports_7d') or 0
        checks.append(chk('reports', '🚩 Students की reports (पिछले 7 दिन)', 'ok' if ro == 0 else 'warn', ro, 'review करें' if ro else 'कोई नहीं'))
        ba = db.get('backup_last_at')
        if ba:
            age = (at - datetime.fromisoformat(ba)).total_seconds() / 3600
            checks.append(chk('backup', '💾 आख़िरी backup', 'ok' if age < 36 else ('warn' if age < 72 else 'bad'), round(age, 1), f'{round(age,1)} घंटे पहले'))
        else: checks.append(chk('backup', '💾 आख़िरी backup', 'bad', None, 'कोई backup नहीं'))
        bv = d.get('backup_verify'); verr = (d.get('errors') or {}).get('verify')
        if verr:
            checks.append(chk('restore', '♻️ Backup वापस पढ़ा जा सकता है', 'bad', None, 'जाँच fail हुई: ' + str(verr) + (f" · पिछली सफल जाँच {bv.get('checked_at','')[:16]}" if bv else '')))
        elif bv: checks.append(chk('restore', '♻️ Backup वापस पढ़ा जा सकता है', 'ok' if bv.get('missing_in_live') == 0 and bv.get('backup_rows') else 'bad', bv.get('backup_rows'),
                                 f"गायब: {bv.get('missing_in_live')} · backup के बाद बदले: {bv.get('changed_since')} · जाँच {bv.get('checked_at','')[:16]}"))
        else: checks.append(chk('restore', '♻️ Backup वापस पढ़ा जा सकता है', 'warn', None, 'अभी तक जाँच नहीं हुई'))
    order = {'ok': 0, 'warn': 1, 'bad': 2}; overall = max((c['state'] for c in checks), key=lambda s: order[s], default='ok')
    robots = []
    if runs:
        seen = set()
        for r in runs:
            if r['name'] in seen or r['name'] not in ROBOT_WORKFLOWS: continue
            seen.add(r['name']); lab, what = ROBOT_WORKFLOWS[r['name']]
            robots.append({'id': r['name'], 'label_hi': lab, 'what_hi': what, 'last_run': r['at'], 'result': r['conclusion'] or r['status'], 'branch': r['branch']})
    by = (db or {}).get('by_exam', {}); tot = lambda k: sum((v.get(k) or 0) for v in by.values())
    status = {'schema': 1, 'app': APP, 'at': iso(at), 'overall': overall, 'checks': checks, 'robots': robots,
              'numbers': {'published': tot('published'), 'draft': tot('draft'), 'hidden': tot('hidden'), 'by_exam': by, 'total': (db or {}).get('total')},
              'backup_verify': d.get('backup_verify'), 'site': {'url': SITE, **site}, 'errors': d.get('errors', {})}
    return status

def history_row(st):
    n = st['numbers']; f = next((c['count'] for c in st['checks'] if c['id'] == 'lock'), None)
    return {'at': st['at'], 'overall': st['overall'], 'published': n['published'], 'draft': n['draft'], 'hidden': n['hidden'], 'failing_lock': f}

def main():
    a = sys.argv[1:]; out = a[a.index('--out') + 1] if '--out' in a else '.'
    prev_dir = a[a.index('--prev-dir') + 1] if '--prev-dir' in a else out
    prev = hist = None
    try: prev = json.load(open(os.path.join(prev_dir, 'status.json')))
    except Exception: pass
    try: hist = json.load(open(os.path.join(prev_dir, 'history.json')))
    except Exception: hist = []
    d = json.load(open(a[a.index('--offline') + 1])) if '--offline' in a else collect()
    if '--offline' not in a and d.get('db') is not None: d['backup_verify'] = verify_if_due(d, prev)
    st = build(d, prev); hist = (hist + [history_row(st)])[-300:]
    os.makedirs(out, exist_ok=True)
    json.dump(st, open(os.path.join(out, 'status.json'), 'w'), ensure_ascii=False, indent=1)
    json.dump(hist, open(os.path.join(out, 'history.json'), 'w'), ensure_ascii=False)
    print('overall', st['overall'], '|', ' '.join(f"{c['id']}={c['state']}" for c in st['checks']))

if __name__ == '__main__': main()
