"""Chapter Writer Robot: writes deep chapter content with a free AI (Gemini), checks it, saves it as a DRAFT.
Nothing it writes is shown in the app until the owner approves it.

   python3 robots/writer/writer.py --count 3 [--level govt_technical] [--dry-run]

Env: GEMINI_API_KEY (never printed), SUPABASE_SECRET_KEY (service role, never printed).
Checks before saving:
  1. structure: every section present, right counts, 4 options, answer index 0-3, no HTML / LaTeX
  2. second opinion: a second Gemini call solves the 10 practice questions without seeing the answers;
     more than 2 disagreements -> rejected
A chapter that fails is saved with status 'rejected' (and its reasons) so it is retried later, never shown.
"""
import argparse, json, os, random, re, sys, time, urllib.request, urllib.error

HERE = os.path.dirname(os.path.abspath(__file__))
SB = os.environ.get('SUPABASE_URL', 'https://wobmtlcpszcntczkebtt.supabase.co').rstrip('/')
SB_KEY = os.environ.get('SUPABASE_SECRET_KEY', '').strip()
GKEY = os.environ.get('GEMINI_API_KEY', '').strip()
WRITE_MODELS = ['gemini-3.5-flash', 'gemini-flash-latest', 'gemini-3.8-flash']
CHECK_MODELS = ['gemini-3.5-flash-lite', 'gemini-flash-lite-latest', 'gemini-3.5-flash']
LEVEL_ORDER = ['govt_technical', 'class_9_10', 'class_11_12_sci', 'govt_basic', 'class_6_8', 'banking', 'govt_defence',
               'engineering', 'medical', 'state_psc', 'upsc_civil', 'class_11_12_com', 'class_11_12_arts',
               'graduation_sci', 'graduation_com', 'graduation_arts', 'law_management', 'advanced_research']


def hide(s):
    s = str(s)
    for k in (GKEY, SB_KEY):
        if k: s = s.replace(k, '[hidden]')
    return s


def http(url, headers, body=None, method='POST', timeout=180):
    req = urllib.request.Request(url, data=body, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status, r.read()
    except urllib.error.HTTPError as e:
        return e.code, e.read()


# ---------- Gemini ----------
def gemini(prompt, models, json_out=True, temperature=0.4):
    """Returns (text, model). Tries each model; waits and retries on 429/500/503."""
    last = ''
    for m in models:
        for attempt in range(4):
            cfg = {'temperature': temperature}
            if json_out: cfg['responseMimeType'] = 'application/json'
            body = json.dumps({'contents': [{'parts': [{'text': prompt}]}], 'generationConfig': cfg}).encode()
            s, b = http(f'https://generativelanguage.googleapis.com/v1beta/models/{m}:generateContent',
                        {'x-goog-api-key': GKEY, 'Content-Type': 'application/json'}, body)
            if s == 200:
                try:
                    d = json.loads(b)
                    return ''.join(p.get('text', '') for p in d['candidates'][0]['content']['parts']), m
                except Exception as e:
                    last = f'{m}: bad response {e}'; break
            last = f'{m}: HTTP {s} {hide(b[:200])}'
            if s in (429, 500, 502, 503, 504):
                time.sleep(min(60, 8 * (attempt + 1))); continue
            break   # 400/404 etc: try the next model
    raise RuntimeError('Gemini failed: ' + last)


def parse_json(text):
    t = text.strip()
    m = re.search(r'```(?:json)?\s*(.*?)```', t, re.S)
    if m: t = m.group(1)
    a, b = t.find('{'), t.rfind('}')
    return json.loads(t[a:b + 1])


# ---------- checks ----------
BAD = re.compile(r'<\s*/?\s*(div|span|p|br|b|i|sup|sub|table|tr|td|img|svg)\b|\\frac|\\sqrt|\$\$|\\\(|\\\[', re.I)


def strings(x):
    if isinstance(x, str): yield x
    elif isinstance(x, list):
        for y in x: yield from strings(y)
    elif isinstance(x, dict):
        for y in x.values(): yield from strings(y)


def check_structure(d, want_id):
    p = []
    def n(key, lo, hi):
        v = d.get(key)
        if not isinstance(v, list): p.append(f'{key}: missing'); return []
        if not (lo <= len(v) <= hi): p.append(f'{key}: {len(v)} (want {lo}-{hi})')
        return v
    if d.get('id') != want_id: p.append(f'id: {d.get("id")!r} != {want_id}')
    for i, x in enumerate(n('notes', 5, 8)):
        if not isinstance(x, dict) or not x.get('title') or not isinstance(x.get('points'), list) or len(x['points']) < 2:
            p.append(f'notes[{i}]: needs title + points')
    for i, x in enumerate(n('teach', 4, 6)):
        if not isinstance(x, dict) or not x.get('heading') or not x.get('explain'): p.append(f'teach[{i}]: needs heading + explain')
    for i, x in enumerate(n('formulas', 6, 12)):
        if not isinstance(x, dict) or not x.get('title') or not x.get('formula'): p.append(f'formulas[{i}]: needs title + formula')
    for i, x in enumerate(n('solved', 3, 5)):
        if not isinstance(x, dict) or not x.get('question') or not isinstance(x.get('steps'), list) or not x.get('answer'):
            p.append(f'solved[{i}]: needs question + steps + answer')
    for i, x in enumerate(n('practice', 10, 10)):
        ok = isinstance(x, dict) and x.get('q') and isinstance(x.get('options'), list) and len(x['options']) == 4 \
            and all(isinstance(o, str) and o.strip() for o in x['options']) and isinstance(x.get('answer'), int) and 0 <= x['answer'] <= 3
        if not ok: p.append(f'practice[{i}]: needs q, 4 options, answer 0-3')
        elif len({o.strip() for o in x['options']}) < 4: p.append(f'practice[{i}]: duplicate options')
    n('mistakes', 3, 5); n('revision', 6, 10)
    bad = [s for s in strings(d) if BAD.search(s)]
    if bad: p.append(f'HTML/LaTeX found ({len(bad)}): {bad[0][:60]}')
    if sum(len(s) for s in strings(d)) < 6000: p.append('too short')
    return p


def shuffle_options(d, seed):
    """AI models tend to put the right answer in the same place; mix option order (same order every rerun)."""
    rnd = random.Random(seed)
    for x in d.get('practice', []):
        if isinstance(x, dict) and isinstance(x.get('options'), list) and len(x['options']) == 4 and isinstance(x.get('answer'), int) and 0 <= x['answer'] <= 3:
            right = x['options'][x['answer']]; order = list(range(4)); rnd.shuffle(order)
            x['options'] = [x['options'][i] for i in order]; x['answer'] = x['options'].index(right)
    return d


def second_opinion(d):
    qs = [{'n': i, 'q': x['q'], 'options': x['options']} for i, x in enumerate(d.get('practice', []))]
    prompt = ('Solve each multiple-choice question carefully. Reply only with JSON: {"answers": [index, ...]} '
              'where each index is 0, 1, 2 or 3 in the same order as the questions.\n\n' + json.dumps(qs, ensure_ascii=False))
    txt, m = gemini(prompt, CHECK_MODELS, temperature=0)
    got = parse_json(txt).get('answers', [])
    diff = [i for i, x in enumerate(d['practice']) if i >= len(got) or got[i] != x['answer']]
    return diff, m


# ---------- server ----------
def rpc(name, args=None):
    h = {'apikey': SB_KEY, 'Authorization': 'Bearer ' + SB_KEY, 'Content-Profile': 'mtb', 'Accept-Profile': 'mtb',
         'Content-Type': 'application/json', 'x-actor': 'writer-robot'}
    s, b = http(f'{SB}/rest/v1/rpc/{name}', h, json.dumps(args or {}).encode(), timeout=60)
    if s >= 300: raise RuntimeError(f'{name}: HTTP {s} {hide(b[:200])}')
    return json.loads(b) if b else None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--count', type=int, default=3)
    ap.add_argument('--level', default='')
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--only', default='', help='chapter ids (comma separated) to (re)write even if a draft exists; approved drafts are never overwritten')
    ap.add_argument('--report', default='writer-report.md')
    a = ap.parse_args()
    if not GKEY: sys.exit('GEMINI_API_KEY missing')
    if not SB_KEY and not a.dry_run: sys.exit('SUPABASE_SECRET_KEY missing')

    chapters = json.load(open(os.path.join(HERE, 'chapters.json'), encoding='utf-8'))
    levels = {l['id']: l for l in json.load(open(os.path.join(HERE, 'levels.json'), encoding='utf-8'))}
    tpl = open(os.path.join(HERE, 'prompt.txt'), encoding='utf-8').read()
    done = {}
    if SB_KEY:
        done = {(r['level_id'], r['chapter_id']): r for r in rpc('draft_status')}
    # queue: not done yet, or rejected fewer than 3 times; levels in priority order
    order = {l: i for i, l in enumerate(LEVEL_ORDER)}
    queue = [c for c in chapters if (not a.level or c['l'] == a.level)
             and ((c['l'], c['c']) not in done or (done[(c['l'], c['c'])]['status'] == 'rejected' and done[(c['l'], c['c'])]['attempts'] < 3))]
    queue.sort(key=lambda c: (order.get(c['l'], 99), c['c']))
    if a.only:
        ids = {int(x) for x in a.only.split(',') if x.strip()}
        queue = sorted([c for c in chapters if (not a.level or c['l'] == a.level) and c['c'] in ids
                        and done.get((c['l'], c['c']), {}).get('status') != 'approved'], key=lambda c: (order.get(c['l'], 99), c['c']))
    lines = [f'# Writer robot report', f'queue left before this run: {len(queue)}', '']
    for c in queue[:a.count]:
        L = levels[c['l']]
        want = f"DB|{c['l']}|{c['c']}"
        prompt = tpl
        for k, v in {'{l}': c['l'], '{c}': str(c['c']), '{lhi}': L['hi'], '{len}': L['en'], '{depth}': L['depth'],
                     '{s}': c['s'], '{se}': c['se'], '{h}': c['h'], '{e}': c['e']}.items():
            prompt = prompt.replace(k, v)
        status, checks, model, data = 'rejected', {}, None, None
        try:
            txt, model = gemini(prompt, WRITE_MODELS)
            data = shuffle_options(parse_json(txt), want)
            prob = check_structure(data, want)
            checks['structure'] = prob
            if not prob:
                diff, cm = second_opinion(data)
                checks['second_opinion'] = {'model': cm, 'disagree': diff}
                if len(diff) > 2: prob.append(f'second opinion disagrees on {len(diff)} of 10 answers')
            status = 'draft' if not prob else 'rejected'
            checks['problems'] = prob
        except Exception as e:
            checks['error'] = hide(e)[:300]
        size = sum(len(s) for s in strings(data)) if data else 0
        lines.append(f"- {want} {c['h']} ({c['s']}): **{status}** · {model} · {size} chars · {'; '.join(checks.get('problems', [])) or checks.get('error', '') or 'all checks passed'}")
        print(lines[-1], flush=True)
        if data is not None and not a.dry_run:
            rpc('draft_save', {'p': {'level_id': c['l'], 'chapter_id': c['c'], 'status': status, 'data': data,
                                     'provider': 'gemini', 'model': model, 'checks': checks}})
        if a.dry_run and data is not None:
            os.makedirs('writer-out', exist_ok=True)
            json.dump(data, open(f"writer-out/{c['l']}_{c['c']}.json", 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        time.sleep(6)   # stay under the free per-minute limit
    open(a.report, 'w', encoding='utf-8').write('\n'.join(lines) + '\n')


if __name__ == '__main__':
    main()
