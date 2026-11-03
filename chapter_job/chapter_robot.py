"""Chapter Robot: ONE owner command -> one chapter in the app's own content format, checked, ready for owner review.
Never writes the database; publishing is a separate, owner-approved step.

   python3 chapter_robot.py "Class 10, CBSE 2026-27, Science, Electricity" [--retry]

Stages (each saved; a re-run resumes, finished stages are not redone):
  resolve    official syllabus scope (must be verified) + where the chapter lives in the app (level, catalog chapter id)
  reference  web research (Gemini + Google Search): how textbooks of THIS level organise the chapter: sub-topics,
             formula list, solved-example types, misconceptions, question types. Outline only; no text is copied.
  write_hi   the Writer robot's own prompt (robots/writer/prompt.txt = the app format: notes, teach, formulas, solved,
             practice, mistakes, revision) + the official scope + the reference outline. Up to 3 attempts with feedback.
  checks     local: Writer structure/count rules, Hindi, syllabus coverage (every official item), units, copyright n-gram
             AI (different company from the writer): fact check, all 10 practice questions re-solved (second opinion)
  english    the same chapter in English, same shape (language toggle); numbers and answers must match
  package    data.json (exact app shape for mtb.chapter_drafts.data), preview.html (app tabs), report.md
Final: review_ready | needs_review | blocked | failed.  review_ready is NOT published.
"""
import importlib.util, json, os, re, sys, traceback
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import job as J
from common import ProviderUnavailable, parse_json

WRITER_DIR = os.environ.get('WRITER_DIR', os.path.join(HERE, '..', 'robots', 'writer'))
VERSION = 'robot.v1'
MAX_ATTEMPTS = 3
COPY_LIMIT = 0.20


def load_writer():
    path = os.path.join(WRITER_DIR, 'writer.py')
    if not os.path.exists(path): path = os.path.join(HERE, 'writer_ref.py')
    spec = importlib.util.spec_from_file_location('writer_rules', path); m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
    d = WRITER_DIR if os.path.exists(os.path.join(WRITER_DIR, 'prompt.txt')) else HERE
    tpl = open(os.path.join(d, 'prompt.txt' if d == WRITER_DIR else 'writer_prompt.txt'), encoding='utf-8').read()
    levels = {x['id']: x for x in json.load(open(os.path.join(d, 'levels.json'), encoding='utf-8'))}
    chapters = json.load(open(os.path.join(d, 'chapters.json'), encoding='utf-8'))
    return m, tpl, levels, chapters


W, TPL, LEVELS, CHAPTERS = load_writer()


def flat(x):
    if isinstance(x, str): yield x
    elif isinstance(x, list):
        for y in x: yield from flat(y)
    elif isinstance(x, dict):
        for k, y in x.items():
            if k not in ('id', 'answer') or isinstance(y, str): yield from flat(y)


def text(d, keys=None):
    return ' '.join(flat({k: v for k, v in d.items() if k != 'id' and (keys is None or k in keys)}))


def numbers(d):
    return sorted(re.findall(r'\d+(?:\.\d+)?', text(d)))


def reconcile_answers(d):
    """The worked explanation is the evidence: if its final line's value matches exactly ONE option and the answer index points
    elsewhere, the index is set to that option. The independent solver must still agree later. Returns the changes made."""
    num = lambda t: re.findall(r'\d+(?:\.\d+)?', str(t).replace(',', ''))
    fixed = []
    for i, x in enumerate(d.get('practice') or []):
        if not isinstance(x, dict) or not isinstance(x.get('options'), list) or not isinstance(x.get('answer'), int): continue
        lines = [l for l in str(x.get('explanation') or '').split('\n') if l.strip()]
        if not lines: continue
        last = num(lines[-1].split('=')[-1])
        if not last: continue
        hits = [j for j, o in enumerate(x['options']) if num(o) and num(o) == last[-len(num(o)):]]
        if len(hits) == 1 and hits[0] != x['answer']:
            fixed.append({'practice': i + 1, 'from': x['answer'], 'to': hits[0], 'value': lines[-1][-60:]}); x['answer'] = hits[0]
    return fixed


def check_scope(d, r):
    t = text(d).lower(); out = []
    for it in r['scope_items']:
        hi = it.get('need_any_hi') or [[] for _ in it['need_any']]
        ok = all(any(p.lower() in t for p in list(en) + list(h)) for en, h in zip(it['need_any'], hi))
        out.append({'id': it['id'], 'text': it['text'], 'covered': ok})
    return out


def check_units(d, r):
    t = text(d, ('formulas',))
    return [u for u in r['units'] if not re.search(u, t)]


def overlap(d, ref):
    if not ref: return None
    w = re.findall(r'[a-z0-9ऀ-ॿ]+', text(d).lower())
    g = [J.hashlib.sha256(' '.join(w[i:i + 3]).encode()).hexdigest()[:16] for i in range(len(w) - 2)]
    return (sum(x in ref for x in g) / len(g)) if g else 0.0


# ---------------- prompts ----------------
RESEARCH = ('Research how standard {lvl} textbooks and well-known reference books in India (NCERT first, then popular board reference books) '
            'teach the chapter "{e}" ({subject}). Use web search. Do NOT copy or quote any sentence from any book or site. '
            'Reply with ONLY a JSON object (no prose outside it): '
            '{{"subtopics": [{{"scope_item": "<one of the official items>", "points": ["short topic names only"]}}], '
            '"formulas": ["standard formula in symbols, e.g. V = I × R"], "example_types": ["kind of solved numerical/question"], '
            '"misconceptions": ["common student mistake"], "question_types": ["board question type"], '
            '"activities": ["textbook activity/experiment name"], "ncert_sections": ["NCERT section number and heading in book order, e.g. 11.1 Electric current and circuit"]}}\n\nOfficial syllabus items: {scope}')


def app_entry(r):
    a = r['app']
    c = [x for x in CHAPTERS if x['l'] == a['level_id'] and x['c'] == a['chapter_id']]
    if len(c) != 1: raise J.Blocked(f"app chapter {a} not in robots/writer/chapters.json")
    return c[0], LEVELS[a['level_id']]


def write_prompt(r, ref_outline, feedback):
    c, L = app_entry(r)
    p = TPL
    for k, v in {'{l}': c['l'], '{c}': str(c['c']), '{lhi}': L['hi'], '{len}': L['en'], '{depth}': L['depth'],
                 '{s}': c['s'], '{se}': c['se'], '{h}': c['h'], '{e}': c['e']}.items():
        p = p.replace(k, v)
    scope = '\n'.join(f"- {x['text']}" for x in r['scope_items'])
    p += ('\n\nआधिकारिक पाठ्यक्रम (CBSE ' + r['syllabus_session'] + '): नीचे का हर बिंदु notes में अलग विषय या साफ़ points के रूप में ज़रूर आए, '
          'और teach, solved, practice में भी इनका संतुलित हिस्सा हो। पाठ्यक्रम से बाहर मत जाओ।\n' + scope +
          '\n\nआम गलतियाँ जिनसे बचना है: ' + r['avoid'] +
          '\n\nसंदर्भ रूपरेखा (इस स्तर की पाठ्यपुस्तकें इस अध्याय को कैसे पढ़ाती हैं; सिर्फ़ विषयों का ढाँचा, इसके शब्द कॉपी मत करो):\n' +
          json.dumps(ref_outline or {}, ensure_ascii=False))
    if feedback: p += '\n\nपिछला उत्तर इन कारणों से अस्वीकार हुआ; सब ठीक करो: ' + feedback
    return p


def english_prompt(hi):
    return ('Convert this Class 10 chapter into clear, natural English as a good CBSE English-medium teacher would write it, using standard NCERT '
            'English terms. Keep the SAME JSON keys, the same number of items, every number, unit, formula and every practice "answer" index '
            'exactly the same. Plain text, no HTML or LaTeX. Return ONLY JSON.\n\n' + json.dumps(hi, ensure_ascii=False))


# ---------------- runner ----------------
def run(command, P, retry=False, reference_dir=None):
    syl = json.load(open(J.SYLLABUS, encoding='utf-8'))
    try:
        r = J.resolve(J.parse_command(command), syl)
        r['app'] = find_app(syl, r)
        app_entry(r)
    except J.Blocked as e:
        return {'final_state': 'blocked', 'reason': str(e), 'job': None}
    key = J.hashlib.sha256(f"{VERSION}|{r['syllabus_session']}|{r['subject_slug']}|{r['chapter_no']}|{os.environ.get('JOB_CYCLE', '')}".encode()).hexdigest()[:16]
    job = J.Job(key)
    if job.d is None:
        job.d = {'job_id': key, 'robot': VERSION, 'command': command, 'created_at': J.now(), 'stages': {}, 'attribution': [],
                 'issues': [], 'final_state': None, 'runs': 0, 'provider_calls': []}
    if job.d['final_state'] == 'review_ready' or (job.d['final_state'] in ('needs_review', 'failed') and not retry):
        return {'final_state': job.d['final_state'], 'job': key, 'dir': job.dir, 'reused': True}
    if retry and job.d['final_state'] in ('needs_review', 'failed', 'blocked'):
        ref_st = job.d['stages'].get('reference')
        if ref_st and ref_st.get('status') == 'done' and not ref_st.get('n_sources'):
            ref_st['status'] = 'pending'                     # research had no sources: try the web again (the chapter text is kept)
        for s in ('write_hi', 'english'):
            st = job.d['stages'].get(s)
            if st and st.get('status') in ('needs_review', 'failed'):
                st['status'] = 'pending'; st['budget_start'] = st.get('attempts', 0)
    job.d['runs'] += 1; job.d['final_state'] = 'running'; job.save()
    ref, langs = J.load_reference(reference_dir)
    ref = ref if (langs.get('hi') and langs.get('en')) else set()
    try:
        job.put('scope.json', r); job.stage('resolve').update(status='done')
        if job.stage('reference')['status'] != 'done':
            try:
                stage_reference(job, r, P)
            except ProviderUnavailable as e:   # research down: still write from the syllabus, but the result can only be needs_review
                job.d['issues'].append({'at': J.now(), 'kind': 'reference_unavailable', 'provider': e.provider, 'reason': e.kind, 'detail': str(e)[:300]})
                job.put('reference.json', {'outline': {}, 'sources': [], 'note': 'web research unavailable in this run'})
                job.stage('reference').update(status='done', n_sources=0, unavailable=True); job.save()
        if job.stage('write_hi')['status'] != 'done':
            s = stage_write(job, r, P, ref)
            if s != 'done': return finish(job, r, s)
        if job.stage('english')['status'] != 'done':
            s = stage_english(job, P)
            if s != 'done': return finish(job, r, s)
        state = 'review_ready'
        if not job.get('reference.json').get('sources'):
            job.d['issues'].append({'at': J.now(), 'kind': 'reference_unsourced', 'detail': 'web research returned no source links; outline not evidenced'})
            state = 'needs_review'
        return finish(job, r, state)
    except ProviderUnavailable as e:
        job.log_calls(P); job.d['issues'].append({'at': J.now(), 'kind': 'provider_unavailable', 'provider': e.provider, 'reason': e.kind, 'detail': str(e)[:300]})
        return finish(job, r, 'blocked')
    except Exception as e:
        job.log_calls(P); job.d['issues'].append({'at': J.now(), 'kind': 'crash', 'error': type(e).__name__, 'detail': (str(e) + ' ' + traceback.format_exc(limit=2))[:600]})
        return finish(job, r, 'failed')


def find_app(syl, r):
    for s in syl['subjects']:
        if s['slug'] == r['subject_slug']:
            for c in s['chapters']:
                if c['no'] == r['chapter_no']:
                    if not c.get('app'): raise J.Blocked('chapter has no app mapping (level + catalog chapter id) yet')
                    return c['app']
    raise J.Blocked('chapter not found')


def stage_reference(job, r, P):
    st = job.stage('reference'); st['status'] = 'running'; job.save()
    lvl = 'CBSE Class 10'
    try:
        q = [f"Class 10 {r['subject']} {r['chapter']} chapter notes NCERT", f"CBSE class 10 {r['chapter']} chapter explanation topics",
             f"NCERT class 10 science chapter {r['chapter_no']} {r['chapter']}"]
        raw, sources, prov, model = P.research(RESEARCH.format(lvl=lvl, e=r['chapter'], subject=r['subject'],
                                                                 scope='; '.join(x['text'] for x in r['scope_items'])), queries=q)
    finally:
        job.log_calls(P)
    job.attribute('reference', 'researcher', prov, model)
    try: outline = parse_json(raw)
    except ValueError: outline = {}
    job.put('reference.json', {'outline': outline, 'sources': sources, 'note': 'outline only; used as a topic guide, never as text'})
    st.update(status='done', n_sources=len(sources)); job.save()


def stage_write(job, r, P, ref):
    st = job.stage('write_hi'); st['status'] = 'running'; hist = st.setdefault('history', []); job.save()
    want = f"DB|{r['app']['level_id']}|{r['app']['chapter_id']}"
    outline = job.get('reference.json').get('outline')
    while st['attempts'] - st.get('budget_start', 0) < MAX_ATTEMPTS:
        try:
            raw, prov, model = P.write(write_prompt(r, outline, st.get('last_feedback', '')))
        finally:
            job.log_calls(P)
        st['attempts'] += 1; n = st['attempts']; job.attribute('write_hi', 'writer', prov, model)
        open(os.path.join(job.dir, f'hi_attempt_{n}.raw.txt'), 'w', encoding='utf-8').write(raw or '')
        rec = {'n': n, 'at': J.now(), 'checks': {}}; hist.append(rec)
        try:
            d = W.shuffle_options(parse_json(raw), want)
            rec['answers_reconciled'] = reconcile_answers(d)
            d = W.tidy_explanations(d)
        except Exception as e:
            rec.update(status='rejected', problems=[f'reply is not valid JSON: {e}']); st['last_feedback'] = rec['problems'][0]; job.save(); continue
        job.put(f'hi_attempt_{n}.json', d)
        probs = local_checks(rec['checks'], d, r, want, ref)
        if not probs:
            job.save()
            probs = ai_checks(job, rec['checks'], d, P)
        rec['problems'] = probs; job.save()
        if not probs:
            rec['status'] = 'accepted'; job.put('hi.json', d); st.update(status='done', accepted_attempt=n); job.save(); return 'done'
        rec['status'] = 'rejected'; st['last_feedback'] = '; '.join(probs)[:1500]; job.save()
    job.d['issues'].append({'at': J.now(), 'kind': 'checks_failed', 'detail': f"Hindi chapter failed after {st['attempts']} attempts: {st.get('last_feedback', '')}"[:600]})
    st['status'] = 'needs_review'; job.save(); return 'needs_review'


def local_checks(c, d, r, want, ref):
    c['structure'] = W.check_structure(d, want)
    c['hindi'] = bool(W.hindi_ok(d))
    c['scope'] = check_scope(d, r)
    c['units_missing'] = check_units(d, r)
    ov = overlap(d, ref)
    c['copyright'] = {'overlap': None if ov is None else round(ov, 4), 'threshold': COPY_LIMIT,
                      'status': 'not_run' if ov is None else ('pass' if ov <= COPY_LIMIT else 'fail'), 'note': 'automatic metric, not legal clearance'}
    p = list(c['structure'])
    if not c['hindi']: p.append('text must be Hindi in every section (English terms only in brackets)')
    p += [f"syllabus item not covered: {x['text']}" for x in c['scope'] if not x['covered']]
    p += [f'formula units missing: {u}' for u in c['units_missing']]
    if c['copyright']['status'] == 'fail': p.append(f"copyright overlap {ov:.0%} above 20%: explain in your own teaching words, keep terms and formulas exact")
    if c['copyright']['status'] == 'not_run': p.append('copyright check could not run (reference fingerprints missing)')
    return p


def ai_checks(job, c, d, P):
    try:
        ok, why, prov, model = P.fact_check_app(d)
    finally:
        job.log_calls(P)
    job.attribute('write_hi', 'fact_checker', prov, model); c['fact_check'] = {'correct': ok, 'reason': why, 'model': model}
    try:
        got, prov2, model2 = P.solve_all(d['practice'])
    finally:
        job.log_calls(P)
    job.attribute('write_hi', 'second_opinion', prov2, model2)
    diff = [i + 1 for i, x in enumerate(d['practice']) if i >= len(got) or got[i] != x['answer']]
    c['second_opinion'] = {'disagree': diff, 'model': model2}
    p = []
    if ok is not True: p.append('fact check ' + ('inconclusive: ' if ok is None else 'failed: ') + why)
    if diff: p.append(f'practice answers not confirmed by an independent solver for questions {diff}; recompute them')
    return p


def stage_english(job, P):
    st = job.stage('english'); st['status'] = 'running'; job.save()
    hi = job.get('hi.json')
    try:
        raw, prov, model = P.translate(english_prompt(hi))
    finally:
        job.log_calls(P)
    st['attempts'] = st.get('attempts', 0) + 1; job.attribute('english', 'translator', prov, model)
    try: en = parse_json(raw)
    except ValueError as e:
        job.d['issues'].append({'at': J.now(), 'kind': 'checks_failed', 'detail': f'English reply not valid JSON: {e}'}); st['status'] = 'needs_review'; job.save(); return 'needs_review'
    en['id'] = hi['id']
    c = {'structure': W.check_structure(en, hi['id']), 'numbers_match': numbers(en) == numbers(hi),
         'answers_match': [x.get('answer') for x in en.get('practice', [])] == [x['answer'] for x in hi['practice']],
         'counts_match': all(len(en.get(k) or []) == len(hi.get(k) or []) for k in ('notes', 'teach', 'formulas', 'solved', 'practice', 'mistakes', 'revision'))}
    job.put('en.json', en); job.put('checks_en.json', c)
    p = [x for x in c['structure'] if x != 'too short'] + [k + ': NO' for k in ('numbers_match', 'answers_match', 'counts_match') if not c[k]]
    if p:
        job.d['issues'].append({'at': J.now(), 'kind': 'checks_failed', 'detail': 'English: ' + '; '.join(p)[:500]}); st['status'] = 'needs_review'; job.save(); return 'needs_review'
    st['status'] = 'done'; job.save(); return 'done'


# ---------------- package ----------------
def finish(job, r, state):
    job.d['final_state'] = state; job.d['finished_at'] = J.now(); job.save()
    try: package(job, r, state)
    except Exception as e: job.d['issues'].append({'at': J.now(), 'kind': 'package_error', 'detail': str(e)[:300]}); job.save()
    return {'final_state': state, 'job': job.d['job_id'], 'dir': job.dir, 'reused': False}


def package(job, r, state):
    hi = job.get('hi.json') if job.has('hi.json') else None
    en = job.get('en.json') if job.has('en.json') else None
    if hi:
        data = dict(hi); data['en'] = en
        ref = job.get('reference.json') if job.has('reference.json') else {}
        data['book_ref'] = {'ncert_sections': (ref.get('outline') or {}).get('ncert_sections', []), 'sources': ref.get('sources', []),
                            'note': 'NCERT section order is the Book-tab order reference only; no NCERT text is copied'}
        data['source'] = {'robot': VERSION, 'job_id': job.d['job_id'], 'syllabus': f"CBSE {r['syllabus_session']} {r['subject']} ch {r['chapter_no']} {r['chapter']}"}
        job.put('data.json', data)
        hist = job.d['stages']['write_hi']['history']; acc = [h for h in hist if h.get('status') == 'accepted']
        job.put('draft_save_payload.json', {'p': {'level_id': r['app']['level_id'], 'chapter_id': r['app']['chapter_id'], 'status': 'draft',
                 'data': data, 'provider': next((a['provider'] for a in reversed(job.d['attribution']) if a['role'] == 'writer'), None),
                 'model': next((a['model'] for a in reversed(job.d['attribution']) if a['role'] == 'writer'), None),
                 'checks': {'problems': [], 'robot': VERSION, 'job_id': job.d['job_id'], 'final_state': state,
                            'checks': acc[-1]['checks'] if acc else None, 'english': job.get('checks_en.json') if job.has('checks_en.json') else None,
                            'hindi_title_status': r['name_hi_status'], 'human_review': None}}})
    rows = [f"# {r['subject']} · {r['chapter']} ({r['chapter_hi']}) — {state}", '',
            'review_ready = every automatic check passed. NOT published; owner review needed. Copyright score is a metric, not legal clearance.', '',
            f"Syllabus: CBSE {r['syllabus_session']} ({r['source']}) · app: {r['app']}", '', '## Attempts']
    for h in job.d['stages'].get('write_hi', {}).get('history', []):
        c = h.get('checks', {})
        rows.append(f"- attempt {h['n']}: {h.get('status')} | copyright {((c.get('copyright') or {}).get('overlap'))} | problems: {'; '.join(h.get('problems') or [])[:400] or 'none'}")
    ref = job.get('reference.json') if job.has('reference.json') else {}
    rows += ['', f"## Reference research: {len(ref.get('sources') or [])} sources"] + [f"- {s.get('title', '')} {s.get('uri', '')}" for s in (ref.get('sources') or [])[:12]]
    rows += ['', '## Who did what'] + [f"- {a['stage']} / {a['role']}: {a['provider']} {a['model']}" for a in job.d['attribution']]
    if job.d['issues']: rows += ['', '## Issues'] + [f"- {i['kind']}: {i['detail']}" for i in job.d['issues']]
    open(os.path.join(job.dir, 'report.md'), 'w', encoding='utf-8').write('\n'.join(rows) + '\n')
    open(os.path.join(job.dir, 'preview.html'), 'w', encoding='utf-8').write(preview(r, state, hi, en, job.d))


def preview(r, state, hi, en, d):
    e = lambda s: J.html.escape(str(s))
    def tab(c):
        if not c: return '<p>not available</p>'
        o = ['<h2>नोट्स / Notes</h2>']
        for n in c.get('notes', []):
            o.append(f"<div class=card><b>{e(n.get('title'))}</b><ul>{''.join(f'<li>{e(p)}</li>' for p in n.get('points', []))}</ul>")
            if n.get('table'): o.append('<table>' + ''.join('<tr>' + ''.join(f'<td>{e(x)}</td>' for x in row) + '</tr>' for row in n['table']) + '</table>')
            o.append('</div>')
        o.append('<h2>शिक्षक / Teach</h2>' + ''.join(f"<div class=card><b>{e(t.get('heading'))}</b><p>{e(t.get('explain'))}</p><p class=m>{e(t.get('example', ''))}</p></div>" for t in c.get('teach', [])))
        o.append('<h2>सूत्र / Formula</h2>' + ''.join(f"<div class=card><b>{e(f.get('title'))}</b><pre>{e(f.get('formula'))}</pre><p class=m>{e(f.get('units', ''))} · {e(f.get('note', ''))}</p></div>" for f in c.get('formulas', [])))
        o.append('<h2>हल किए गए प्रश्न / Solved</h2>' + ''.join(f"<div class=card><b>{e(s.get('question'))}</b><ol>{''.join(f'<li>{e(x)}</li>' for x in s.get('steps', []))}</ol><p><b>{e(s.get('answer'))}</b></p></div>" for s in c.get('solved', [])))
        o.append('<h2>अभ्यास / Practice</h2>' + ''.join(f"<div class=card><b>{i + 1}. {e(q.get('q'))}</b><ol type=A>{''.join(f'<li class={chr(34)}{'ok' if j == q.get('answer') else ''}{chr(34)}>{e(x)}</li>' for j, x in enumerate(q.get('options', [])))}</ol><pre class=m>{e(q.get('explanation'))}</pre></div>" for i, q in enumerate(c.get('practice', []))))
        o.append('<h2>आम गलतियाँ / Mistakes</h2><ul>' + ''.join(f'<li>{e(x)}</li>' for x in c.get('mistakes', [])) + '</ul>')
        o.append('<h2>रिवीज़न / Revision</h2><ul>' + ''.join(f'<li>{e(x)}</li>' for x in c.get('revision', [])) + '</ul>')
        return ''.join(o)
    iss = ''.join(f"<li>{e(i['kind'])}: {e(i['detail'])}</li>" for i in d['issues']) or '<li>none</li>'
    att = ''.join(f"<li>{e(a['stage'])} / {e(a['role'])}: {e(a['provider'])} {e(a['model'])}</li>" for a in d['attribution'])
    return ('<!doctype html><html><head><meta charset=utf-8><meta name=viewport content="width=device-width,initial-scale=1">'
            f'<title>{e(r["chapter"])} · {e(state)}</title><style>body{{font:15px/1.6 system-ui,sans-serif;margin:14px;color:#111}}'
            '.card{border:1px solid #ddd;border-radius:8px;padding:8px 10px;margin:8px 0}.ok{font-weight:700;color:#0a7d32}.m{color:#555}'
            'pre{white-space:pre-wrap;font:inherit}td{border:1px solid #ccc;padding:3px 6px}table{border-collapse:collapse}'
            'details{margin:10px 0}summary{font-weight:700;font-size:17px}</style></head><body>'
            f'<h1>{e(r["chapter_hi"])} / {e(r["chapter"])}</h1><p><b>{e(state)}</b> · not published · owner review needed</p>'
            f'<h3>Issues</h3><ul>{iss}</ul><details open><summary>हिंदी</summary>{tab(hi)}</details>'
            f'<details><summary>English</summary>{tab(en)}</details><h3>Who did what</h3><ul>{att}</ul></body></html>')


if __name__ == '__main__':
    import providers
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    out = run(args[0], providers.Real(), retry='--retry' in sys.argv, reference_dir=os.environ.get('COPYRIGHT_FINGERPRINTS'))
    print(json.dumps(out, ensure_ascii=False))
    sys.exit(0 if out['final_state'] in ('review_ready', 'needs_review') else 2)
