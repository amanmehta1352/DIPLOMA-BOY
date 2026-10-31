"""Coverage Planner: how full each level is, against the targets in targets.json.

   python3 robots/planner/planner.py            # prints the report (needs SUPABASE_SECRET_KEY)
   python3 robots/planner/planner.py --offline  # uses only the repo files (chapter list + targets), counts 0 everywhere

Used by the Health Robot (every 2 h): the result goes into status.json under "coverage" and the Control Room draws it.
Counts only, no AI, no secrets in the output.
A chapter counts toward a type only up to its target, so one fat chapter cannot hide an empty one.
"""
import json, os, re, sys, urllib.request, urllib.error

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
SB = os.environ.get('SUPABASE_URL', 'https://wobmtlcpszcntczkebtt.supabase.co').rstrip('/')
KEY = os.environ.get('SUPABASE_SECRET_KEY', '').strip()
TYPES = ('concept', 'formula', 'example', 'mcq', 'solution')


def load_chapters():
    with open(os.path.join(ROOT, 'robots', 'writer', 'chapters.json'), encoding='utf8') as f:
        return [{'l': c['l'], 'c': c['c']} for c in json.load(f)]


def load_targets():
    with open(os.path.join(HERE, 'targets.json'), encoding='utf8') as f:
        t = json.load(f)
    return {'default': t['default'], 'levels': t.get('levels', {})}


def target_for(targets, level):
    base = dict(targets['default']); base.update(targets['levels'].get(level, {}))
    return {k: int(base.get(k, 0)) for k in TYPES}


def coverage(chapters, atoms, solutions, targets):
    """Pure function. atoms: [{level_id, chapter_id, atom_type}] (published, not archived). solutions: [{level_id, chapter_id}] (approved)."""
    have = {}
    for a in atoms:
        have[(a['level_id'], a['chapter_id'], a['atom_type'])] = have.get((a['level_id'], a['chapter_id'], a['atom_type']), 0) + 1
    for s in solutions:
        k = (s['level_id'], s['chapter_id'], 'solution'); have[k] = have.get(k, 0) + 1
    levels = {}
    for ch in chapters:
        lv = levels.setdefault(ch['l'], {'chapters': 0, 'chapters_full': 0, 'target': 0, 'have': 0, 'per_type': {t: {'have': 0, 'target': 0} for t in TYPES}})
        tg = target_for(targets, ch['l'])
        lv['chapters'] += 1
        full = True
        for t in TYPES:
            h = have.get((ch['l'], ch['c'], t), 0)
            lv['per_type'][t]['target'] += tg[t]; lv['per_type'][t]['have'] += min(h, tg[t])
            lv['target'] += tg[t]; lv['have'] += min(h, tg[t])
            if h < tg[t]: full = False
        if full: lv['chapters_full'] += 1
    for lv in levels.values():
        lv['pct'] = round(100 * lv['have'] / lv['target']) if lv['target'] else 0
    total_t = sum(v['target'] for v in levels.values()); total_h = sum(v['have'] for v in levels.values())
    return {'levels': dict(sorted(levels.items())), 'total': {'chapters': sum(v['chapters'] for v in levels.values()),
            'chapters_full': sum(v['chapters_full'] for v in levels.values()), 'pct': round(100 * total_h / total_t) if total_t else 0}}


def _get(path):
    h = {'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Accept-Profile': 'mtb'}
    out, off = [], 0
    while True:
        req = urllib.request.Request(f'{SB}/rest/v1/{path}&limit=1000&offset={off}', headers=h)
        try:
            with urllib.request.urlopen(req, timeout=60) as r:
                rows = json.loads(r.read())
        except urllib.error.HTTPError as e:
            raise RuntimeError(f"{path.split('?')[0]}: HTTP {e.code} {e.read()[:120].decode('utf8', 'ignore')}".replace(KEY, '[hidden]') if KEY else str(e.code))
        out += rows
        if len(rows) < 1000: return out
        off += 1000


def fetch():
    if not KEY: raise RuntimeError('SUPABASE_SECRET_KEY missing')
    atoms = _get('atoms?select=level_id,chapter_id,atom_type&status=eq.published&archived=eq.false&level_id=not.is.null')
    sols = _get('solution_items?select=level_id,chapter_id&status=eq.approved')
    return atoms, sols


def run(offline=False):
    chapters, targets = load_chapters(), load_targets()
    atoms, sols = ([], []) if offline else fetch()
    return coverage(chapters, atoms, sols, targets)


def syllabus_handover(units_path, prev_path, out_dir, level='medical', exam='NEET UG'):
    """Reads the reader's output, compares with the last run, writes syllabus_return.json.
    If the number of missing units changed, a command goes to the Health Robot (visible in the Control Room)."""
    doc = json.load(open(units_path, encoding='utf-8')) if os.path.exists(units_path) else {'documents': []}
    units = [u for d in doc.get('documents', []) if 'units' in d and d.get('level', level) == level for u in d['units']]
    titles = [c['e'] for c in json.load(open(os.path.join(ROOT, 'robots', 'writer', 'chapters.json'), encoding='utf-8')) if c['l'] == level]
    ret = syllabus_return(units, titles)
    ret.update({'level': level, 'exam': exam, 'chapters_in_level': len(titles), 'note': 'word match only; check the list by hand'})
    prev = {}
    if prev_path and os.path.exists(prev_path):
        try: prev = json.load(open(prev_path, encoding='utf-8'))
        except Exception: prev = {}
    os.makedirs(out_dir, exist_ok=True)
    json.dump(ret, open(os.path.join(out_dir, 'syllabus_return.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    changed = prev.get('missing') is not None and len(prev.get('missing', [])) != len(ret['missing'])
    print(f"{exam}: units {ret['units']} · covered {ret['covered']} · missing {len(ret['missing'])}" + (' · changed' if changed else ''))
    if (changed or prev.get('missing') is None) and SB_KEY_ENV():
        import urllib.request as R
        body = json.dumps({'p_robot': 'health', 'p_args': {}, 'p_note': f"Syllabus {exam}: {len(ret['missing'])} units without a chapter (of {ret['units']})"}).encode()
        h = {'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Content-Profile': 'mtb', 'Content-Type': 'application/json'}
        try:
            with R.urlopen(R.Request(f'{SB}/rest/v1/rpc/cmd_enqueue_auto', body, h, method='POST'), timeout=60) as r: print('handover to Health: command', r.read().decode()[:20])
        except Exception as e: print('handover failed:', type(e).__name__)
    return ret


def SB_KEY_ENV():
    return bool(KEY)


def syllabus_return(units, chapter_titles):
    """Pure: which official syllabus units have no matching chapter yet.
    A unit is covered when most of its significant words appear in one chapter title (English)."""
    stop = {'and', 'of', 'the', 'in', 'to', 'a', 'an', 'for', 'with', 'its', 'on', 'by'}
    words = lambda s: {w for w in re.findall(r'[a-z]+', s.lower()) if w not in stop and len(w) > 2}
    titles = [words(t) for t in chapter_titles]
    missing, covered = [], []
    for u in units:
        need = words(u['title'])
        if not need: continue
        best = max((len(need & t) / len(need) for t in titles), default=0)
        (covered if best >= 0.5 else missing).append({'subject': u['subject'], 'unit': u['unit'], 'title': u['title']})
    return {'units': len(units), 'covered': len(covered), 'missing': missing}


if __name__ == '__main__':
    a = sys.argv[1:]
    if '--units' in a:
        syllabus_handover(a[a.index('--units') + 1], a[a.index('--prev') + 1] if '--prev' in a else '', a[a.index('--out') + 1] if '--out' in a else 'out')
    else:
        print(json.dumps(run('--offline' in sys.argv), ensure_ascii=False, indent=1))
