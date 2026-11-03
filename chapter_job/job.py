"""Chapter Job: one command -> a review-ready depth-content package for one chapter. Never writes the database, never publishes.

   python3 job.py "Class 10, CBSE 2026-27, Science, Electricity"          (real AI: needs the route robot's keys)
   python3 job.py "..." --retry        re-run a chapter that ended in needs_review / failed (new attempts, same job)

Stages (each stage's result is saved; a re-run skips finished stages, so a quota stop resumes where it stopped):
  resolve  -> syllabus version + chapter scope (official source required)
  blueprint-> depth standard for the level
  write_en -> English content, up to N attempts; every failed check is fed back to the next attempt
  translate_hi -> Hindi version + Hindi checks
  package  -> en.json, hi.json, checks.json, report.md, preview.html

Final states: review_ready (every check ran and passed) | needs_review (checks ran, something did not pass) |
              blocked (a provider/quota/syllabus prerequisite is missing; re-run resumes) | failed (unexpected crash).
review_ready is NOT published. Model agreement is not proof of correctness: a human review is still required.
"""
import hashlib, html, json, os, re, sys, time, traceback
from datetime import datetime, timezone

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from common import ProviderUnavailable, ProviderRequestError, parse_json, text_of  # one class identity for script and import
JOBS = os.environ.get('CHAPTER_JOBS_DIR', os.path.join(HERE, 'jobs'))
SYLLABUS = os.path.join(HERE, 'syllabus_cbse10_2026_27.json')
BLUEPRINT = os.path.join(HERE, 'blueprint_class_9_10.json')
STAGES = ['resolve', 'blueprint', 'write_en', 'translate_hi', 'package']


class Blocked(Exception):
    pass


def now():
    return datetime.now(timezone.utc).isoformat(timespec='seconds')


# ---------------- request ----------------
def parse_command(text):
    t = text.lower()
    m = re.search(r'class\s*(\d+)', t); cls = int(m.group(1)) if m else None
    board = 'CBSE' if 'cbse' in t else None
    m = re.search(r'(20\d\d)\s*[-–/]\s*(\d\d)', t); session = f'{m.group(1)}-{m.group(2)}' if m else None
    parts = [p.strip() for p in re.split(r'[,;]', text) if p.strip()]
    rest = [p for p in parts if not re.search(r'class\s*\d+|cbse|20\d\d', p, re.I)]
    return {'class': cls, 'board': board, 'session': session, 'subject': rest[0] if rest else None,
            'chapter': rest[1] if len(rest) > 1 else None, 'text': text}


def resolve(req, syl):
    if req['class'] != syl['class'] or (req['board'] or 'CBSE') != syl['board'] or (req['session'] or syl['session']) != syl['session']:
        raise Blocked(f"no syllabus on file for class {req['class']} {req['board']} {req['session']} (have {syl['board']} class {syl['class']} {syl['session']})")
    key = (req['subject'] or '').lower().split('(')[0].strip()
    base = lambda s: s['name_en'].lower().split('(')[0].strip()
    subj = [s for s in syl['subjects'] if key and key in (base(s), s['slug'], s['slug'].split('-', 1)[-1])]   # exact name first
    if not subj: subj = [s for s in syl['subjects'] if key and key in base(s)]
    if len(subj) != 1:
        raise Blocked(f"subject '{req['subject']}' not found or ambiguous")
    s = subj[0]
    want = (req['chapter'] or '').strip().lower()
    num = re.fullmatch(r'(?:chapter|ch)?\s*(\d+)', want)
    chs = [c for c in s['chapters'] if (num and c['no'] == int(num.group(1))) or (not num and want and want in c['name_en'].lower())]
    if len(chs) != 1:
        raise Blocked(f"chapter '{req['chapter']}' not found or ambiguous in {s['slug']}")
    c = chs[0]
    if not s.get('ready_for_db') and not s.get('source'):
        raise Blocked(f"{s['slug']}: no official syllabus source on file ({s.get('blocker', '')})")
    if not c.get('scope_verified'):
        raise Blocked(f"{s['slug']} ch {c['no']} '{c['name_en']}': chapter scope not read from an official source yet")
    return {'subject_slug': s['slug'], 'subject': s['name_en'], 'source': s['source'], 'syllabus_session': syl['session'],
            'chapter_no': c['no'], 'chapter': c['name_en'], 'chapter_hi': c['name_hi'], 'name_hi_status': c['name_hi_status'],
            'unit': c['unit_en'], 'exam_scope': c['exam_scope'], 'note': c.get('note'),
            'scope_items': c['scope_items'], 'units': c.get('units', []), 'avoid': c.get('avoid', ''),
            'practicals': c.get('practicals', []), 'outcomes_note': c.get('outcomes_note', '')}


def job_key(r, bp):
    raw = '|'.join(map(str, ('CBSE', r['syllabus_session'], r['subject_slug'], r['chapter_no'], bp['version'])))
    return hashlib.sha256(raw.encode()).hexdigest()[:16]


# ---------------- prompts ----------------
def write_prompt(r, bp, feedback=''):
    c = bp['counts']
    scope = '; '.join(x['text'] for x in r['scope_items'])
    p = (f"Write study content for: Class 10 {r['subject']} (CBSE {r['syllabus_session']}), chapter {r['chapter_no']}: {r['chapter']}. "
         'Level: Indian Class 10 board (NCERT). Language: English. Write original sentences; do not copy any textbook. '
         f'Cover EVERY item of the official chapter scope: {scope}. Do not go beyond Class 10 scope. '
         'Return ONLY JSON with this exact shape: '
         f'{{"concepts":[{{"title":"","body":""}} x{c["concepts"]}], "formulas":[{{"title":"","body":""}} x{c["formulas"]}], '
         f'"examples":[{{"title":"","body":""}} x{c["examples"]}], '
         f'"mcqs":[{{"question":"","options":["","","",""],"answer_index":0,"difficulty":"easy","explanation":""}} x{c["mcqs"]}]}}.\n'
         'After each formula give the units in brackets and define every symbol. '
         f'COMMON MISTAKES TO AVOID: {r["avoid"]}\n'
         'MCQs: exactly 1 easy (one-step recall) and 2 medium (two real steps). Compute every numerical answer carefully and show the arithmetic in the explanation. '
         'Plain text only: no HTML, no LaTeX.')
    return p + (f'\n\nA previous attempt was rejected for these reasons; fix all of them: {feedback}' if feedback else '')


def hindi_prompt(en):
    return ('Convert this Class 10 content into simple, natural Hindi as a good Hindi-medium teacher would write it, using standard NCERT Hindi terms. '
            'Do not translate word for word. Keep every number, unit, formula, answer_index and difficulty exactly the same, and the same JSON keys and shape. '
            'Plain text only. Return ONLY JSON.\n\n' + json.dumps(en, ensure_ascii=False))


# ---------------- checks (pure code, no AI) ----------------
def check_structure(d, bp):
    p = []
    for k, n in bp['counts'].items():
        if not isinstance(d.get(k), list) or len(d[k]) != n: p.append(f'{k}: need exactly {n}')
    for k in ('concepts', 'formulas', 'examples'):
        for x in d.get(k) or []:
            if not (isinstance(x, dict) and str(x.get('title', '')).strip() and str(x.get('body', '')).strip()): p.append(f'{k}: empty title or body')
    for i, q in enumerate(d.get('mcqs') or []):
        if not isinstance(q, dict) or len(q.get('options') or []) != 4 or q.get('answer_index') not in (0, 1, 2, 3) \
                or not str(q.get('question', '')).strip() or not str(q.get('explanation', '')).strip():
            p.append(f'mcq{i + 1}: bad shape'); continue
        if len({str(o).strip().lower() for o in q['options']}) != 4: p.append(f'mcq{i + 1}: duplicate options')
    if sorted(str(q.get('difficulty')) for q in d.get('mcqs') or [] if isinstance(q, dict)) != sorted(bp['mcq_difficulty']):
        p.append('mcq difficulty must be ' + ' + '.join(bp['mcq_difficulty']))
    if re.search(r'<[a-zA-Z/][^>]*>|\\\(|\\\[|\$\$', json.dumps(d, ensure_ascii=False)): p.append('html or latex found')
    return p


def check_scope(d, r):
    """Syllabus coverage: every official scope item must be present (each 'need_any' group needs one of its phrases)."""
    t = text_of(d).lower()
    cov = []
    for item in r['scope_items']:
        ok = all(any(ph in t for ph in grp) for grp in item['need_any'])
        cov.append({'id': item['id'], 'text': item['text'], 'covered': ok})
    return cov


def check_units(d, r):
    t = text_of(d, ('formulas',))
    return [u for u in r['units'] if not re.search(u, t)]


def hindi_share(d):
    t = text_of(d)
    dev, lat = len(re.findall(r'[ऀ-ॿ]', t)), len(re.findall(r'[A-Za-z]', t))
    return dev / max(1, dev + lat)


def numbers(d):
    return sorted(re.findall(r'\d+(?:\.\d+)?', json.dumps(d, ensure_ascii=False)))


def copyright_overlap(d, ref):
    """Share of 3-word sequences found in the hashed NCERT reference. None = reference not loaded (the check did not run)."""
    if not ref: return None
    w = re.findall(r'[a-z0-9ऀ-ॿ]+', text_of(d).lower())
    g = [hashlib.sha256(' '.join(w[i:i + 3]).encode()).hexdigest()[:16] for i in range(len(w) - 2)]
    return (sum(x in ref for x in g) / len(g)) if g else 0.0


def load_reference(dirpath):
    hs, langs = set(), {}
    if not dirpath or not os.path.isdir(dirpath): return hs, langs
    for n in sorted(os.listdir(dirpath)):
        if n.endswith('.json'):
            j = json.load(open(os.path.join(dirpath, n), encoding='utf-8'))
            hs |= set(j['hashes']); langs[j['lang']] = langs.get(j['lang'], 0) + len(j['files'])
    return hs, langs


# ---------------- checkpoints ----------------
CHECKS_CODE_VERSION = 'checks.v2'
EN_CHECKS = lambda bp: ['structure', 'scope', 'units', 'copyright', 'fact_check_en'] + [f'solve_mcq{i + 1}' for i in range(bp['counts']['mcqs'])]
HI_CHECKS = ['local_hi', 'fact_check_hi']


def chash(obj):
    return hashlib.sha256(json.dumps(obj, sort_keys=True, ensure_ascii=False).encode()).hexdigest()[:16]


def checks_version(r, bp, ref_id):
    """Any change in check code, blueprint, threshold, scope or reference set makes earlier check results stale."""
    return chash({'code': CHECKS_CODE_VERSION, 'bp': bp.get('version'), 'thr': bp['copyright_threshold'],
                  'scope': r['scope_items'], 'units': r.get('units'), 'ref': ref_id})


def checkpoint(job, box, name, content_hash, version, fn):
    """Run one check unless a valid result for the same content+version is already saved; save it the moment it exists."""
    old = box.get(name)
    if old and old.get('status') == 'done' and old.get('content_hash') == content_hash and old.get('version') == version:
        return old['result']
    box[name] = {'status': 'running', 'content_hash': content_hash, 'version': version}
    out = fn()
    rec = {'status': 'done', 'content_hash': content_hash, 'version': version, 'at': now()}
    if isinstance(out, tuple):                     # (result, provider, model)
        rec['result'], rec['provider'], rec['model'] = out
    else:
        rec['result'] = out
    box[name] = rec
    job.save()
    return rec['result']


def mark_open(box, names, why):
    for n in names:
        if box.get(n, {}).get('status') != 'done':
            box[n] = {'status': why}


# ---------------- job store ----------------
class Job:
    def __init__(self, key):
        self.dir = os.path.join(JOBS, key); os.makedirs(self.dir, exist_ok=True)
        self.path = os.path.join(self.dir, 'job.json')
        self.d = json.load(open(self.path, encoding='utf-8')) if os.path.exists(self.path) else None

    def save(self):
        tmp = self.path + '.tmp'
        json.dump(self.d, open(tmp, 'w', encoding='utf-8'), ensure_ascii=False, indent=1); os.replace(tmp, self.path)

    def put(self, name, obj):
        tmp = os.path.join(self.dir, name + '.tmp')
        json.dump(obj, open(tmp, 'w', encoding='utf-8'), ensure_ascii=False, indent=1); os.replace(tmp, os.path.join(self.dir, name))

    def get(self, name):
        return json.load(open(os.path.join(self.dir, name), encoding='utf-8'))

    def has(self, name):
        return os.path.exists(os.path.join(self.dir, name))

    def stage(self, name):
        return self.d['stages'].setdefault(name, {'status': 'pending', 'attempts': 0})

    def attribute(self, stage, role, provider, model):
        self.d['attribution'].append({'stage': stage, 'role': role, 'provider': provider, 'model': model, 'at': now()})

    def log_calls(self, P):
        ev = P.drain_events() if hasattr(P, 'drain_events') else []
        if ev:
            self.d.setdefault('provider_calls', []).extend(dict(e, at=now()) for e in ev); self.save()


def migrate(job):
    """Bring a job saved by the older code (before checkpoints) to the current shape. Never discards a draft."""
    d = job.d
    d.setdefault('provider_calls', [])
    st = d['stages'].get('write_en')
    if st:
        hist = st.setdefault('history', [])
        known = {h.get('n') for h in hist}
        n = st.get('attempts', 0)
        if n and n not in known and job.has(f'en_attempt_{n}.json'):
            hist.append({'n': n, 'status': 'incomplete', 'content_hash': chash(job.get(f'en_attempt_{n}.json')), 'checks': {},
                         'note': 'recovered: the earlier run stopped inside this attempt before its checks were saved'})
    last = d['issues'][-1] if d['issues'] else {}
    if d.get('final_state') == 'failed' and last.get('kind') == 'crash' and 'ProviderUnavailable' in last.get('detail', ''):
        d['final_state'] = 'blocked'
        if st and st.get('status') == 'running': st['status'] = 'blocked'
        d['issues'].append({'at': now(), 'kind': 'reclassified',
                            'detail': 'earlier final state "failed" was a provider outage misrecorded as a crash (fixed bug); now blocked'})


# ---------------- runner ----------------
def run(command, providers, retry=False, reference_dir=None):
    syl = json.load(open(SYLLABUS, encoding='utf-8')); bp = json.load(open(BLUEPRINT, encoding='utf-8'))
    req = parse_command(command)
    try:
        r = resolve(req, syl)
    except Blocked as e:
        return {'final_state': 'blocked', 'reason': str(e), 'job': None}
    key = job_key(r, bp)
    job = Job(key)
    if job.d is None:
        job.d = {'job_id': key, 'request': req, 'created_at': now(), 'stages': {}, 'attribution': [], 'issues': [],
                 'final_state': None, 'runs': 0, 'provider_calls': []}
    migrate(job)
    if job.d['final_state'] == 'review_ready' or (job.d['final_state'] in ('needs_review', 'failed') and not retry):
        job.save()
        return {'final_state': job.d['final_state'], 'job': key, 'dir': job.dir, 'reused': True}
    if retry and job.d['final_state'] in ('needs_review', 'failed'):
        for s in ('write_en', 'translate_hi', 'package'):
            if job.d['stages'].get(s, {}).get('status') in ('needs_review', 'failed', 'done'):
                job.d['stages'][s]['status'] = 'pending'
                job.d['stages'][s]['budget_start'] = job.d['stages'][s].get('attempts', 0)   # --retry = a fresh attempt budget, history kept
    job.d['runs'] += 1; job.d['final_state'] = 'running'; job.save()
    ref, langs = load_reference(reference_dir)
    ref_id = chash({'langs': langs, 'n': len(ref)})
    try:
        st = job.stage('resolve'); job.put('scope.json', r); st.update(status='done', at=now())
        st = job.stage('blueprint'); job.put('blueprint.json', bp); st.update(status='done', at=now())
        ver = checks_version(r, bp, ref_id)
        if job.stage('write_en')['status'] != 'done':
            state = stage_write_en(job, r, bp, providers, ref if (langs.get('hi') and langs.get('en')) else set(), ver)
            if state != 'done':
                return finish(job, state)
        if job.stage('translate_hi')['status'] != 'done':
            state = stage_translate(job, providers, ver)
            if state != 'done':
                return finish(job, state)
        stage_package(job, r, bp)
        return finish(job, 'review_ready')
    except ProviderUnavailable as e:
        job.log_calls(providers)
        job.d['issues'].append({'at': now(), 'kind': 'provider_unavailable', 'provider': e.provider, 'reason': e.kind, 'detail': str(e)[:300]})
        return finish(job, 'blocked')
    except Exception as e:                                   # code/schema errors, ProviderRequestError
        job.log_calls(providers)
        job.d['issues'].append({'at': now(), 'kind': 'crash', 'error': type(e).__name__, 'detail': (str(e) + ' ' + traceback.format_exc(limit=2))[:600]})
        return finish(job, 'failed')


def finish(job, state):
    for name in ('write_en', 'translate_hi'):
        s = job.d['stages'].get(name)
        if s and s.get('status') == 'running': s['status'] = state
    job.d['final_state'] = state; job.d['finished_at'] = now(); job.save()
    try: stage_package(job, job.get('scope.json'), job.get('blueprint.json'), partial=(state != 'review_ready'))
    except Exception as e:
        job.d['issues'].append({'at': now(), 'kind': 'package_error', 'detail': str(e)[:300]}); job.save()
    return {'final_state': state, 'job': job.d['job_id'], 'dir': job.dir, 'reused': False}


def flat_en(cur):
    """Older flat checks shape used by the report/preview."""
    c = cur['checks']; g = lambda k: c.get(k, {}).get('result')
    out = {'structure': g('structure') or [], 'scope': g('scope') or [], 'units_missing': g('units') or [], 'copyright': g('copyright'),
           'fact_check': g('fact_check_en'), 'mcq_solved': [g(k) for k in sorted(c) if k.startswith('solve_mcq') and g(k)]}
    return out


def en_checks(job, cur, cand, r, bp, P, ref, ver):
    """All English checks for one draft. Cheap local gates first; AI checks only when they pass. Returns problems list."""
    box, h = cur['checks'], cur['content_hash']
    names = EN_CHECKS(bp)
    structure = checkpoint(job, box, 'structure', h, ver, lambda: check_structure(cand, bp))
    if structure:
        mark_open(box, names[1:], 'skipped: structure failed'); return list(structure)
    scope = checkpoint(job, box, 'scope', h, ver, lambda: check_scope(cand, r))
    units = checkpoint(job, box, 'units', h, ver, lambda: check_units(cand, r))

    def cr():
        ov = copyright_overlap(cand, ref)
        return {'overlap': None if ov is None else round(ov, 4), 'threshold': bp['copyright_threshold'],
                'status': 'not_run' if ov is None else ('pass' if ov <= bp['copyright_threshold'] else 'fail')}
    copy = checkpoint(job, box, 'copyright', h, ver, cr)
    probs = [f"scope item not covered: {c['text']}" for c in scope if not c['covered']]
    probs += [f'formula units missing: {u}' for u in units]
    if copy['status'] == 'fail':
        probs.append(f"copyright overlap {copy['overlap']:.0%} above the limit; explain each idea afresh in your own teaching words and structure "
                     "(own examples, own sentence order), keep standard terms, laws and formulas exact, and do not just swap words; accuracy comes first")
    if probs:
        mark_open(box, names[4:], 'skipped: local gate failed'); return probs
    for n in names[4:]:
        if box.get(n, {}).get('status') != 'done': box[n] = {'status': 'pending'}
    job.save()

    def fc():
        try:
            ok, why, prov, model = P.fact_check(cand, 'en')
        finally:
            job.log_calls(P)
        job.attribute('write_en', 'fact_checker_en', prov, model)
        return {'correct': ok, 'reason': why}, prov, model
    fact = checkpoint(job, box, 'fact_check_en', h, ver, fc)
    for i, q in enumerate(cand['mcqs']):
        def sv(i=i, q=q):
            try:
                got, prov, model = P.solve(q)
            finally:
                job.log_calls(P)
            job.attribute('write_en', f'solver_mcq{i + 1}', prov, model)
            return {'mcq': i + 1, 'stored': q['answer_index'], 'solved': got, 'agree': got == q['answer_index']}, prov, model
        checkpoint(job, box, f'solve_mcq{i + 1}', h, ver, sv)
    if not fact['correct']: probs.append('fact check: ' + fact['reason'])
    for k in names[5:]:
        s = box[k]['result']
        if not s['agree']: probs.append(f"mcq{s['mcq']}: answer key {s['stored']} not confirmed by a worked solution (got {s['solved']}); recompute it")
    return probs


def stage_write_en(job, r, bp, P, ref, ver):
    st = job.stage('write_en'); st['status'] = 'running'; hist = st.setdefault('history', []); job.save()
    cur = hist[-1] if hist and hist[-1].get('status') in ('incomplete', 'checking') else None
    while True:
        if cur is None:
            if st['attempts'] - st.get('budget_start', 0) >= bp['max_write_attempts']:
                break
            try:
                raw, prov, model = P.write(write_prompt(r, bp, st.get('last_feedback', '')))   # an outage here does not use up an attempt
            finally:
                job.log_calls(P)
            st['attempts'] += 1; n = st['attempts']
            job.attribute('write_en', 'writer', prov, model)
            try:
                cand = parse_json(raw)
            except Exception as e:
                fb = f'reply is not valid JSON: {e}'
                hist.append({'n': n, 'at': now(), 'status': 'rejected', 'problems': [fb]}); st['last_feedback'] = fb; job.save(); continue
            job.put(f'en_attempt_{n}.json', cand)
            cur = {'n': n, 'at': now(), 'status': 'checking', 'content_hash': chash(cand), 'checks': {}}
            hist.append(cur); job.save()
        else:
            cand = job.get(f"en_attempt_{cur['n']}.json")
            h = chash(cand)
            if h != cur['content_hash']:            # the saved draft was changed: earlier checks are not valid for it
                job.d['issues'].append({'at': now(), 'kind': 'checks_invalidated', 'detail': f"draft {cur['n']} changed on disk; all its checks re-run"})
                cur['content_hash'], cur['checks'] = h, {}
            cur['status'] = 'checking'; job.save()
        try:
            probs = en_checks(job, cur, cand, r, bp, P, ref, ver)
        except ProviderUnavailable:
            cur['status'] = 'incomplete'
            mark_open(cur['checks'], EN_CHECKS(bp), 'pending')
            job.save(); raise
        cur['problems'] = probs
        copy = cur['checks'].get('copyright', {}).get('result') or {}
        if not probs and copy.get('status') == 'not_run':
            cur['status'] = 'unverified'
            job.put('en_unverified.json', cand); job.put('checks_en.json', flat_en(cur))
            job.d['issues'].append({'at': now(), 'kind': 'check_not_run', 'detail': 'copyright reference not loaded; the copyright check did not run'})
            st.update(status='needs_review'); job.save(); return 'needs_review'
        if not probs:
            cur['status'] = 'accepted'
            job.put('en.json', cand); job.put('checks_en.json', flat_en(cur))
            st.update(status='done', accepted_attempt=cur['n'], en_hash=cur['content_hash']); job.save(); return 'done'
        cur['status'] = 'rejected'; st['last_feedback'] = '; '.join(probs); job.save(); cur = None
    job.d['issues'].append({'at': now(), 'kind': 'checks_failed', 'detail': f"English failed after {st['attempts']} attempts: {st.get('last_feedback', '')}"[:600]})
    st['status'] = 'needs_review'; job.save(); return 'needs_review'


def stage_translate(job, P, ver):
    st = job.stage('translate_hi'); st['status'] = 'running'
    en = job.get('en.json'); eh = chash(en)
    box = st.setdefault('checks', {})
    if st.get('en_hash') and st['en_hash'] != eh:      # English changed: the old Hindi and its checks are not valid
        job.d['issues'].append({'at': now(), 'kind': 'checks_invalidated', 'detail': 'English changed after translation; Hindi redone'})
        st.pop('hi_hash', None); box.clear()
    hi = job.get('hi.json') if job.has('hi.json') else None
    if not (hi is not None and st.get('en_hash') == eh and st.get('hi_hash') == chash(hi)):
        try:
            raw, prov, model = P.translate(hindi_prompt(en))
        finally:
            job.log_calls(P)
        st['attempts'] += 1
        job.attribute('translate_hi', 'translator', prov, model)
        try:
            hi = parse_json(raw)
        except Exception as e:
            job.d['issues'].append({'at': now(), 'kind': 'checks_failed', 'detail': f'Hindi reply not valid JSON: {e}'}); st['status'] = 'needs_review'; job.save(); return 'needs_review'
        job.put('hi.json', hi); st['en_hash'], st['hi_hash'] = eh, chash(hi); box.clear(); job.save()
    hh = st['hi_hash']; bp = job.get('blueprint.json')
    c = checkpoint(job, box, 'local_hi', hh, ver, lambda: {
        'structure': check_structure(hi, bp), 'hindi_share': round(hindi_share(hi), 3), 'numbers_match': numbers(hi) == numbers(en),
        'answers_match': [q.get('answer_index') for q in hi.get('mcqs') or []] == [q['answer_index'] for q in en['mcqs']],
        'difficulty_match': [q.get('difficulty') for q in hi.get('mcqs') or []] == [q['difficulty'] for q in en['mcqs']]})

    def fc():
        try:
            ok, why, prov, model = P.fact_check(hi, 'hi')
        finally:
            job.log_calls(P)
        job.attribute('translate_hi', 'fact_checker_hi', prov, model)
        return {'correct': ok, 'reason': why}, prov, model
    try:
        f = checkpoint(job, box, 'fact_check_hi', hh, ver, fc)
    except ProviderUnavailable:
        mark_open(box, HI_CHECKS, 'pending'); job.save(); raise
    job.put('checks_hi.json', dict(c, fact_check=f))
    probs = list(c['structure'])
    if c['hindi_share'] < 0.6: probs.append(f"Hindi text share only {c['hindi_share']:.0%}")
    for k in ('numbers_match', 'answers_match', 'difficulty_match'):
        if not c[k]: probs.append(k.replace('_', ' ') + ': NO')
    if not f['correct']: probs.append('hindi fact check: ' + f['reason'])
    if probs:
        job.d['issues'].append({'at': now(), 'kind': 'checks_failed', 'detail': 'Hindi: ' + '; '.join(probs)}); st['status'] = 'needs_review'; job.save(); return 'needs_review'
    st['status'] = 'done'; job.save(); return 'done'


def check_table(job, bp):
    """Every expected check of the latest English attempt and of the Hindi stage, with its state."""
    rows = []
    open_word = 'inconclusive' if job.d.get('final_state') in ('blocked', 'failed') else 'pending'
    hist = job.d['stages'].get('write_en', {}).get('history', [])
    cur = next((h for h in reversed(hist) if 'checks' in h), None)
    for name in EN_CHECKS(bp):
        x = (cur or {}).get('checks', {}).get(name, {})
        rows.append(('en', name, verdict(name, x, open_word), x.get('provider', ''), x.get('model', '')))
    hb = job.d['stages'].get('translate_hi', {}).get('checks', {})
    for name in HI_CHECKS:
        x = hb.get(name, {})
        rows.append(('hi', name, verdict(name, x, open_word), x.get('provider', ''), x.get('model', '')))
    return rows, (cur or {}).get('n')


def verdict(name, x, open_word):
    s = x.get('status')
    if s != 'done':
        return open_word if s in (None, 'pending', 'running') else s
    v = x['result']
    if name == 'structure': return 'pass' if not v else 'fail'
    if name == 'scope': return 'pass' if all(c['covered'] for c in v) else 'fail'
    if name == 'units': return 'pass' if not v else 'fail'
    if name == 'copyright': return {'pass': 'pass', 'fail': f"fail ({v['overlap']:.1%})", 'not_run': 'not_run'}[v['status']]
    if name.startswith('fact_check'): return 'pass' if v['correct'] else 'fail'
    if name.startswith('solve_mcq'): return 'pass' if v['agree'] else 'fail'
    if name == 'local_hi':
        ok = not v['structure'] and v['hindi_share'] >= 0.6 and v['numbers_match'] and v['answers_match'] and v['difficulty_match']
        return 'pass' if ok else 'fail'
    return 'done'


def stage_package(job, r, bp, partial=False):
    d = job.d
    have = lambda n: os.path.exists(os.path.join(job.dir, n))
    en = job.get('en.json') if have('en.json') else (job.get('en_unverified.json') if have('en_unverified.json') else None)
    hi = job.get('hi.json') if have('hi.json') else None
    ce = job.get('checks_en.json') if have('checks_en.json') else {}
    ch = job.get('checks_hi.json') if have('checks_hi.json') else {}
    status = d['final_state'] if partial else 'review_ready'
    rows = []
    rows.append(f"# {r['subject']}: chapter {r['chapter_no']} {r['chapter']}  —  {status}")
    rows.append(f"Job {d['job_id']} · runs {d['runs']} · syllabus CBSE {r['syllabus_session']} · source {r['source']}")
    if any(str(a.get('provider', '')).startswith('mock') for a in d['attribution']):
        rows.append('MOCK RUN: this content is a test fixture. No AI wrote, checked or translated it. Not an AI end-to-end result.')
    rows.append('review_ready means: every automatic check ran and passed. It is NOT published and NOT proof of correctness; a human review is required.')
    rows.append(f"Hindi chapter title status: {r['name_hi_status']}")
    rows.append('\n## Syllabus coverage')
    for c in ce.get('scope', []): rows.append(f"- [{'x' if c['covered'] else ' '}] {c['text']}")
    if r.get('outcomes_note'): rows.append(f"Outcomes: {r['outcomes_note']}")
    rows.append('\n## Checks')
    if ce:
        rows.append(f"- English structure: {'pass' if not ce.get('structure') else ce['structure']}")
        rows.append(f"- Units missing: {ce.get('units_missing')}")
        rows.append(f"- Copyright: {ce.get('copyright')}")
        rows.append(f"- English fact check: {ce.get('fact_check')}")
        rows.append(f"- MCQ worked solutions: {ce.get('mcq_solved')}")
    if ch:
        rows.append(f"- Hindi: structure {'pass' if not ch.get('structure') else ch['structure']}, Hindi share {ch.get('hindi_share')}, numbers match {ch.get('numbers_match')}, answers match {ch.get('answers_match')}, fact check {ch.get('fact_check')}")
    tbl, att_n = check_table(job, bp)
    rows.append(f'\n## Check status (English attempt {att_n}, then Hindi)')
    rows.append('inconclusive = the check did not get a result in this run (job stopped first); skipped = an earlier gate failed.')
    for lang, name, v, pv, mo in tbl: rows.append(f"- {lang} {name}: {v}" + (f" ({pv} {mo})" if pv else ''))
    rows.append('\n## Stages')
    for s in STAGES:
        x = d['stages'].get(s, {}); rows.append(f"- {s}: {x.get('status', 'pending')} (attempts {x.get('attempts', 0)})")
    rows.append('\n## Who did what (as returned by each provider)')
    for a in d['attribution']: rows.append(f"- {a['stage']} / {a['role']}: {a['provider']} {a['model']}")
    pc = d.get('provider_calls', [])
    if pc:
        rows.append('\n## Provider calls (every HTTP try)')
        for c in pc: rows.append(f"- {c['provider']} {c['model']}: HTTP {c['http']} {c['kind']} (try {c['try']}, {c['secs']}s)")
    if d['issues']:
        rows.append('\n## Unresolved issues')
        for i in d['issues']: rows.append(f"- {i['kind']}: {i['detail']}")
    open(os.path.join(job.dir, 'report.md'), 'w', encoding='utf-8').write('\n'.join(rows) + '\n')
    open(os.path.join(job.dir, 'preview.html'), 'w', encoding='utf-8').write(preview(r, status, en, hi, ce, ch, d))
    if not partial: job.stage('package').update(status='done', at=now()); job.save()


def preview(r, status, en, hi, ce, ch, d):
    e = lambda s: html.escape(str(s))
    def col(c, lang):
        if not c: return f'<div class="col"><p class="muted">{lang}: not available</p></div>'
        out = [f'<div class="col" lang="{lang}"><h2>{"English" if lang == "en" else "हिंदी"}</h2>']
        for k, t in (('concepts', 'Concepts'), ('formulas', 'Formulas'), ('examples', 'Examples')):
            out.append(f'<h3>{t}</h3>' + ''.join(f'<div class="card"><b>{e(x.get("title"))}</b><p>{e(x.get("body"))}</p></div>' for x in c.get(k) or []))
        out.append('<h3>MCQs</h3>')
        for q in c.get('mcqs') or []:
            opts = ''.join(f'<li{" class=ok" if i == q.get("answer_index") else ""}>{e(o)}</li>' for i, o in enumerate(q.get('options') or []))
            out.append(f'<div class="card"><b>{e(q.get("question"))}</b> <small>({e(q.get("difficulty"))})</small><ol type="A">{opts}</ol><p class="muted">{e(q.get("explanation"))}</p></div>')
        return ''.join(out) + '</div>'
    badge = {'review_ready': '#0a7d32', 'needs_review': '#b26a00', 'blocked': '#555', 'failed': '#b00020'}.get(status, '#555')
    cov = ''.join(f'<li>{"✅" if c["covered"] else "❌"} {e(c["text"])}</li>' for c in ce.get('scope', []))
    iss = ''.join(f'<li>{e(i["kind"])}: {e(i["detail"])}</li>' for i in d['issues']) or '<li>none</li>'
    att = ''.join(f'<li>{e(a["role"])}: {e(a["provider"])} {e(a["model"])}</li>' for a in d['attribution'])
    return f'''<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>{e(r["chapter"])} · {e(status)}</title><style>body{{font:15px/1.5 system-ui,sans-serif;margin:16px;color:#111}}.b{{display:inline-block;padding:4px 10px;border-radius:12px;color:#fff;background:{badge}}}
.grid{{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:16px}}.card{{border:1px solid #ddd;border-radius:8px;padding:8px 10px;margin:6px 0}}.ok{{font-weight:700;color:#0a7d32}}.muted{{color:#666}}</style></head><body>
<h1>{e(r["subject"])} · Ch {r["chapter_no"]} {e(r["chapter"])} / {e(r["chapter_hi"])}</h1>
{'<p style="background:#fde8e8;color:#8a0010;padding:8px;border-radius:6px"><b>MOCK RUN</b>: test fixture content. No AI wrote, checked or translated it. Not an AI end-to-end result.</p>' if any(str(a.get('provider', '')).startswith('mock') for a in d['attribution']) else ''}
<p><span class="b">{e(status)}</span> Not published. Automatic checks are not proof of correctness; review before release.</p>
<p class="muted">Syllabus CBSE {e(r["syllabus_session"])} · source <a href="{e(r["source"])}">{e(r["source"])}</a> · Hindi title: {e(r["name_hi_status"])}</p>
<h2>Syllabus coverage</h2><ul>{cov}</ul><h2>Unresolved issues</h2><ul>{iss}</ul>
<div class="grid">{col(en, "en")}{col(hi, "hi")}</div><h2>Who did what</h2><ul>{att}</ul></body></html>'''


if __name__ == '__main__':
    sys.path.insert(0, HERE)
    import providers
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    out = run(args[0], providers.Real(), retry='--retry' in sys.argv, reference_dir=os.environ.get('COPYRIGHT_FINGERPRINTS'))
    print(json.dumps(out, ensure_ascii=False))
    sys.exit(0 if out['final_state'] in ('review_ready', 'needs_review') else 2)
