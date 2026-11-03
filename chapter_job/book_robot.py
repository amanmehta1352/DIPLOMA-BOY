"""Book Robot: one command -> one chapter in the owner's Library book format (mtb.chapter_books, kind chN, see BOOK_FORMAT_SPEC.md).

   python3 book_robot.py "Class 10, CBSE 2026-27, Science, Electricity" [--retry]

Stages (each saved; a rerun continues where it stopped; nothing is redone that passed):
  resolve    official scope (grounded) + app chapter
  reference  web research outline (topics, order, depth, diagrams, question types; no text copied)
  plan       chapter plan: titles, intro, 8-16 concept panels (every syllabus item owned by >= 1 panel), teach lessons
  concepts   each concept panel written in Hindi+English pairs (paras, kv, table, formula, tip, SVG diagram), 3 per AI call
  extras     5 solved numericals, 10 revision facts, 10 practice Q, formula list with groups
  teach      opener + one lesson per plan item (spoken-teacher style), Hindi+English pairs
  hinglish   the Hindi lessons in Roman script
  demo       3D/slider model body for the owner's makeDemoDoc template (tested in node before use)
  checks     depth gates (spec section 5), syllabus coverage, SVG safety, 3D test, numericals re-solved by another AI,
             fact check, copyright n-gram < 20 %
  package    chapter_books row (status draft) + preview
AI writes content only; book_render.py turns it into the owner's exact HTML."""
import json, os, re, sys, traceback
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import job as J, chapter_robot as C, book_render as R
from common import ProviderUnavailable, parse_json

VERSION = 'book.v1'
MIN = {'concepts': 8, 'numericals': 5, 'revision': 8, 'practice': 8, 'formulas': 4, 'notes_words': 900, 'teach_words': 1300,
       'teach_sections': 12, 'diagrams': 2, 'panels': 15}
STYLE = ('Rules: write ORIGINAL explanations (never copy any book or website). Every text field is a pair ["Hindi", "English"]. '
         'Hindi = simple standard NCERT Hindi with the English term in brackets the first time, e.g. प्रतिरोध (resistance). '
         'Maths in plain text: a/b, ×, x^2, sqrt(x); no LaTeX, no HTML. **bold** for key words. Units always. Stay inside the official syllabus. '
         'Level: {depth}\n')


def pair_ok(x): return isinstance(x, list) and len(x) == 2 and all(isinstance(s, str) and s.strip() for s in x)


def words(html_text): return len(re.sub(r'<[^>]+>', ' ', html_text).split())


# ---------------- prompts ----------------
def p_plan(r, ref, depth):
    return (STYLE.format(depth=depth) +
            f"Plan one chapter of a school book: Class 10 {r['subject']} — {r['chapter']} ({r['chapter_hi']}).\n"
            'Official syllabus items (id: text):\n' + '\n'.join(f"- {x['id']}: {x['text']}" for x in r['scope_items']) +
            '\nReference outline from textbooks of this level (use for order and depth only):\n' + json.dumps(ref, ensure_ascii=False)[:6000] +
            '\nReturn ONLY JSON: {"titles": ["11. हिंदी शीर्षक", "11. English title"], "short": ["छोटा", "Short"], '
            '"intro": {"paras": [["..",".."]], "kv": [[["key hi","key en"],["value hi","value en"]]]}, '
            '"concepts": [{"key": "c1", "emoji": "⚡", "title": ["..",".."], "scope_ids": ["<syllabus id>"], "diagram": true, "points": "what this panel must cover"}], '
            '"teach": [{"heading": ["..",".."], "emoji": "🚗", "concept_keys": ["c1"]}]}\n'
            '10 to 14 concepts, in the order a good textbook teaches them; EVERY syllabus id must appear in at least one concept; '
            'teach = an opening story lesson first, then one lesson per concept or pair of concepts (10 to 13 lessons in total).')


def p_concepts(r, plan, items, depth, feedback=''):
    return (STYLE.format(depth=depth) + f"Chapter: Class 10 {r['subject']} — {r['chapter']}. Write these note panels fully, like a printed textbook "
            'note sheet: 3-5 explanation paragraphs, a key-value list (definitions, units, properties: 4-8 items), a comparison table if useful, '
            'the main formula with a units list if the topic has one, one ⚠ tip (common mistake), and an SVG diagram when "diagram" is true.\n'
            'SVG: <svg viewBox="0 0 340 200" xmlns="http://www.w3.org/2000/svg"> with simple shapes, lines, arrows (marker), text labels in English symbols; '
            'no script, no images, no links, under 6000 characters.\n'
            'Panels to write: ' + json.dumps(items, ensure_ascii=False) +
            '\nReturn ONLY JSON: {"concepts": [{"key": "c1", "emoji": "⚡", "title": ["..",".."], "paras": [["..",".."]], '
            '"kv": [[["..",".."],["..",".."]]], "table": {"head": [["..",".."]], "rows": [[["..",".."]]]} or null, '
            '"formula": {"expr": "V = I × R", "units": [[["..",".."],["..",".."]]]} or null, "tip": ["..",".."] or null, '
            '"diagram": {"svg": "<svg ...>...</svg>", "caption": ["..",".."]} or null}]}' + (f'\nFix these problems from the last try: {feedback}' if feedback else ''))


def p_extras(r, plan, depth, feedback=''):
    return (STYLE.format(depth=depth) + f"Chapter: Class 10 {r['subject']} — {r['chapter']}. Concepts: " +
            json.dumps([c['title'][1] for c in plan['concepts']]) +
            '\nWrite: 5 solved numericals (board level, real numbers, every step one line with the arithmetic, final answer with unit; '
            'cover different syllabus items), 10 quick-revision facts (key: value), 10 practice questions with short answers, '
            'and every formula of the chapter (6-12) with name, short meaning and use, grouped into 2-4 topic groups.\n'
            'Return ONLY JSON: {"numericals": [{"title": ["..",".."], "given": ["..",".."], "steps": [["..",".."]], "answer": ["..",".."]}], '
            '"revision": [[["..",".."],["..",".."]]], "practice": [{"q": ["..",".."], "a": ["..",".."]}], '
            '"formulas": [{"f": "P = V × I", "t": ["..",".."], "s": ["..",".."], "u": ["..",".."], "group": "power"}], '
            '"formula_groups": [["power", "शक्ति", "Power"]]}' + (f'\nFix these problems from the last try: {feedback}' if feedback else ''))


def p_teach(r, lessons, depth, feedback=''):
    return (STYLE.format(depth=depth) + f"You are a friendly teacher taking a class on Class 10 {r['subject']} — {r['chapter']}. "
            'Write these lessons as you would SPEAK them in class: 3-5 paragraphs each (150-220 words per language), everyday examples, '
            'one key formula line if the lesson has one, and one example box ("समझो ऐसे" / "Think of it like this" or "याद रखो" / "Remember").\n'
            'Lessons: ' + json.dumps(lessons, ensure_ascii=False) +
            '\nReturn ONLY JSON: {"teach": [{"emoji": "🚗", "heading": ["..",".."], "paras": [["..",".."]], "formula": "..." or null, '
            '"example": {"label": ["समझो ऐसे","Think of it like this"], "text": ["..",".."]}}]}' + (f'\nFix: {feedback}' if feedback else ''))


def p_hinglish(secs):
    return ('Rewrite each Hindi lesson in Hinglish: the same Hindi sentences written in Roman (Latin) script the way Indian students text '
            '("Work kya hai? Physics mein work tabhi hota hai jab..."). Keep English technical words, numbers and formulas as they are. '
            'Return ONLY JSON: {"hinglish": [{"emoji": "..", "heading": "..", "paras": [".."], "formula": ".." or null, "example": ".." or null}]}\n\n' +
            json.dumps([{'emoji': s.get('emoji'), 'heading': s['heading'][0], 'paras': [p[0] for p in s.get('paras', [])],
                         'formula': s.get('formula'), 'example': (s.get('example') or {}).get('text', [None])[0]} for s in secs], ensure_ascii=False))


def p_demo(r, plan, feedback=''):
    return ('Write a small interactive 3D model for a school chapter, for this template (Three.js r128 already loaded): '
            'the page has a slider (value v) and calls update(v) every time it moves. Inside update you may ONLY use: '
            'THREE (Mesh, BoxGeometry, SphereGeometry, CylinderGeometry, Vector3, Line, BufferGeometry, LineBasicMaterial), '
            'add(obj) to show a mesh, mat(hexColour) for a material, line(fromVec3, toVec3, colour), arrow(fromVec3, toVec3, colour), '
            'info.textContent = "..." to show values, and T("hindi","english") for text. Scene units about -8..8. No loops over 200, no timers.\n'
            f"Chapter: {r['chapter']}. Concepts: " + json.dumps([c['title'][1] for c in plan['concepts']]) +
            '\nPick ONE idea students should play with (e.g. Ohm law: slider = voltage, show current arrow and bulb brightness).\n'
            'Write ONLY the body of update(v) (do not write "function update"); every object must be shown with add(...) or arrow(...), '
            'e.g. add(line(a, b, 0xaaaaaa)); set info.textContent with the live values.\n'
            'Return ONLY JSON: {"title": ["..",".."], "hint": ["..",".."], "slider": ["..",".."], "min": 0, "max": 12, "step": 1, "val": 6, '
            '"script": "const I=v/4; ... info.textContent=..."}' + (f'\nThe last script failed: {feedback}' if feedback else ''))


# ---------------- runner ----------------
def run(command, P, retry=False, reference_dir=None):
    syl = json.load(open(J.SYLLABUS, encoding='utf-8'))
    try:
        r = J.resolve(J.parse_command(command), syl); r['app'] = C.find_app(syl, r)
    except J.Blocked as e:
        return {'final_state': 'blocked', 'reason': str(e), 'job': None}
    depth = C.LEVELS[r['app']['level_id']]['depth']
    key = J.hashlib.sha256(f"{VERSION}|{r['syllabus_session']}|{r['subject_slug']}|{r['chapter_no']}|{os.environ.get('JOB_CYCLE', '')}".encode()).hexdigest()[:16]
    job = J.Job(key)
    if job.d is None:
        job.d = {'job_id': key, 'robot': VERSION, 'command': command, 'created_at': J.now(), 'stages': {}, 'attribution': [],
                 'issues': [], 'final_state': None, 'runs': 0, 'provider_calls': []}
    if job.d['final_state'] == 'review_ready' or (job.d['final_state'] in ('needs_review', 'failed') and not retry):
        return {'final_state': job.d['final_state'], 'job': key, 'dir': job.dir, 'reused': True}
    if retry:
        for s, v in job.d['stages'].items():
            if v.get('status') in ('needs_review', 'failed', 'running'): v['status'] = 'pending'; v['budget_start'] = v.get('attempts', 0)
        ref = job.d['stages'].get('reference')
        if ref and ref.get('status') == 'done' and not ref.get('n_sources'): ref['status'] = 'pending'
    job.d['runs'] += 1; job.d['final_state'] = 'running'; job.save()
    refset, langs = J.load_reference(reference_dir); refset = refset if (langs.get('hi') and langs.get('en')) else set()
    try:
        job.put('scope.json', r); job.stage('resolve').update(status='done')
        if job.stage('reference')['status'] != 'done':
            try:
                C.stage_reference(job, r, P)
            except ProviderUnavailable as e:
                job.d['issues'].append({'at': J.now(), 'kind': 'reference_unavailable', 'detail': str(e)[:300]})
                job.put('reference.json', {'outline': {}, 'sources': [], 'note': 'web research unavailable'}); job.stage('reference').update(status='done', n_sources=0)
        ref = job.get('reference.json')
        for name, fn in (('plan', st_plan), ('concepts', st_concepts), ('extras', st_extras), ('teach', st_teach), ('hinglish', st_hinglish), ('demo', st_demo)):
            if job.stage(name)['status'] != 'done':
                s = fn(job, r, P, depth, ref)
                if s != 'done': return finish(job, r, s)
        state = st_checks(job, r, P, refset)
        if state == 'review_ready' and not ref.get('sources'):
            job.d['issues'].append({'at': J.now(), 'kind': 'reference_unsourced', 'detail': 'no web sources: depth not evidenced'}); state = 'needs_review'
        return finish(job, r, state)
    except ProviderUnavailable as e:
        job.log_calls(P); job.d['issues'].append({'at': J.now(), 'kind': 'provider_unavailable', 'provider': e.provider, 'reason': e.kind, 'detail': str(e)[:300]})
        return finish(job, r, 'blocked')
    except Exception as e:
        job.log_calls(P); job.d['issues'].append({'at': J.now(), 'kind': 'crash', 'error': type(e).__name__, 'detail': (str(e) + ' ' + traceback.format_exc(limit=3))[:800]})
        return finish(job, r, 'failed')


def ask(job, P, stage, prompt, role):
    try:
        raw, prov, model = P.write(prompt)
    finally:
        job.log_calls(P)
    job.attribute(stage, role, prov, model)
    st = job.stage(stage); st['calls'] = st.get('calls', 0) + 1
    open(os.path.join(job.dir, f"{stage}_{st['calls']}.raw.txt"), 'w', encoding='utf-8').write(raw or '')
    return parse_json(raw)


def attempt_loop(job, stage, build, validate, tries=3):
    """build(feedback) -> obj; validate(obj) -> list of problems. Saves the accepted object as <stage>.json."""
    st = job.stage(stage); st['status'] = 'running'; job.save()
    fb = st.get('last_feedback', '')
    while st.get('attempts', 0) - st.get('budget_start', 0) < tries:
        st['attempts'] = st.get('attempts', 0) + 1
        try:
            obj = build(fb)
        except ValueError as e:
            fb = f'reply was not valid JSON ({e})'; st['last_feedback'] = fb; job.save(); continue
        probs = validate(obj)
        if not probs:
            job.put(f'{stage}.json', obj); st.update(status='done'); job.save(); return 'done'
        fb = '; '.join(probs)[:1500]; st['last_feedback'] = fb; job.save()
    job.d['issues'].append({'at': J.now(), 'kind': 'checks_failed', 'detail': f'{stage}: {fb}'[:600]}); st['status'] = 'needs_review'; job.save()
    return 'needs_review'


def st_plan(job, r, P, depth, ref):
    def v(o):
        p = []
        if not pair_ok(o.get('titles')): p.append('titles must be ["hi","en"]')
        cs = o.get('concepts') or []
        if not (10 <= len(cs) <= 16): p.append(f'concepts: {len(cs)} (want 10-14)')
        ids = {x['id'] for x in r['scope_items']}; got = {i for c in cs for i in c.get('scope_ids') or []}
        if ids - got: p.append('syllabus ids with no concept: ' + ', '.join(sorted(ids - got)))
        if not (10 <= len(o.get('teach') or []) <= 15): p.append(f"teach lessons: {len(o.get('teach') or [])} (want 10-13)")
        if not (o.get('intro') or {}).get('paras'): p.append('intro missing')
        return p
    return attempt_loop(job, 'plan', lambda fb: ask(job, P, 'plan', p_plan(r, ref.get('outline'), depth) + (f'\nFix: {fb}' if fb else ''), 'planner'), v)


def concept_problems(c):
    p = []
    if not pair_ok(c.get('title')): p.append(f"{c.get('key')}: title")
    if len(c.get('paras') or []) < 3 or not all(pair_ok(x) for x in c['paras']): p.append(f"{c.get('key')}: needs 3+ paragraph pairs")
    if len(R.norm_kv(c.get('kv'))) < 3: p.append(f"{c.get('key')}: needs 3+ key-value items")
    if not c.get('tip'): p.append(f"{c.get('key')}: tip missing")
    return p


def st_concepts(job, r, P, depth, ref):
    plan = job.get('plan.json'); st = job.stage('concepts'); st['status'] = 'running'
    done = {c['key']: c for c in (job.get('concepts.partial.json') if job.has('concepts.partial.json') else [])}
    todo = [c for c in plan['concepts'] if c['key'] not in done]
    for i in range(0, len(todo), 3):
        batch = todo[i:i + 3]; fb = ''
        for _ in range(3):
            try:
                got = {c.get('key'): c for c in ask(job, P, 'concepts', p_concepts(r, plan, batch, depth, fb), 'writer').get('concepts', [])}
            except ValueError as e:
                fb = f'invalid JSON ({e})'; continue
            probs = [x for c in batch for x in (concept_problems(got[c['key']]) if c['key'] in got else [f"{c['key']}: missing"])]
            for c in batch:     # an unsafe or broken diagram is dropped (never shown); the chapter-level diagram count is gated later
                g = got.get(c['key']) or {}
                if g.get('diagram') and not R.safe_svg((g.get('diagram') or {}).get('svg')):
                    g['diagram'] = None; job.d['issues'].append({'at': J.now(), 'kind': 'diagram_dropped', 'detail': f"{c['key']}: SVG failed the safety check"})
            if not probs: break
            fb = '; '.join(probs)
        if probs:
            job.d['issues'].append({'at': J.now(), 'kind': 'checks_failed', 'detail': 'concepts: ' + fb[:500]}); st['status'] = 'needs_review'; job.save(); return 'needs_review'
        for c in batch: done[c['key']] = {**got[c['key']], 'key': c['key'], 'scope_ids': c.get('scope_ids', [])}
        job.put('concepts.partial.json', list(done.values())); job.save()
    job.put('concepts.json', [done[c['key']] for c in plan['concepts']]); st['status'] = 'done'; job.save(); return 'done'


def st_extras(job, r, P, depth, ref):
    plan = job.get('plan.json')
    def v(o):
        p = []
        if len(o.get('numericals') or []) < MIN['numericals']: p.append(f"numericals: {len(o.get('numericals') or [])} (want 5)")
        for i, n in enumerate(o.get('numericals') or []):
            if not (pair_ok(n.get('given')) and pair_ok(n.get('answer')) and len(n.get('steps') or []) >= 2): p.append(f'numerical {i + 1}: given/steps/answer')
        if len(o.get('revision') or []) < MIN['revision']: p.append('revision: want 10')
        if len(o.get('practice') or []) < MIN['practice']: p.append('practice: want 10')
        if len(o.get('formulas') or []) < 6: p.append('formulas: want 6-12')
        return p
    return attempt_loop(job, 'extras', lambda fb: ask(job, P, 'extras', p_extras(r, plan, depth, fb), 'writer'), v)


def st_teach(job, r, P, depth, ref):
    plan = job.get('plan.json'); concepts = {c['key']: c for c in job.get('concepts.json')}
    lessons = [{'emoji': l.get('emoji'), 'heading': l['heading'], 'covers': [concepts[k]['title'][1] for k in l.get('concept_keys', []) if k in concepts]}
               for l in plan['teach']]
    st = job.stage('teach'); st['status'] = 'running'; out = job.get('teach.partial.json') if job.has('teach.partial.json') else []
    for i in range(len(out), len(lessons), 4):
        batch = lessons[i:i + 4]; fb = ''; got = []
        for _ in range(3):
            try:
                got = ask(job, P, 'teach', p_teach(r, batch, depth, fb), 'teacher').get('teach', [])
            except ValueError as e:
                fb = f'invalid JSON ({e})'; continue
            probs = [] if len(got) == len(batch) else [f'wrote {len(got)} lessons, want {len(batch)}']
            probs += [f'lesson {j + 1}: needs 3+ paragraph pairs' for j, s in enumerate(got) if len(s.get('paras') or []) < 3 or not all(pair_ok(x) for x in s['paras'])]
            if not probs: break
            fb = '; '.join(probs)
        if probs:
            job.d['issues'].append({'at': J.now(), 'kind': 'checks_failed', 'detail': 'teach: ' + fb[:500]}); st['status'] = 'needs_review'; job.save(); return 'needs_review'
        out += got; job.put('teach.partial.json', out); job.save()
    job.put('teach.json', out); st['status'] = 'done'; job.save(); return 'done'


def st_hinglish(job, r, P, depth, ref):
    chp = assemble(job)
    secs = R.teach_sections(chp); st = job.stage('hinglish'); st['status'] = 'running'
    out = job.get('hinglish.partial.json') if job.has('hinglish.partial.json') else []
    for i in range(len(out), len(secs), 6):
        batch = secs[i:i + 6]
        try:
            got = ask(job, P, 'hinglish', p_hinglish(batch), 'transliterator').get('hinglish', [])
        except ValueError:
            got = []
        if len(got) != len(batch):
            job.d['issues'].append({'at': J.now(), 'kind': 'checks_failed', 'detail': 'hinglish: section count mismatch'}); st['status'] = 'needs_review'; job.save(); return 'needs_review'
        out += got; job.put('hinglish.partial.json', out); job.save()
    job.put('hinglish.json', out); st['status'] = 'done'; job.save(); return 'done'


def st_demo(job, r, P, depth, ref):
    plan = job.get('plan.json')
    def v(o):
        if not all(pair_ok(o.get(k)) for k in ('title', 'hint', 'slider')) or not isinstance(o.get('script'), str): return ['title/hint/slider/script']
        ok, err = R.check_demo_script(o)
        return [] if ok else [f'script error: {err}']
    return attempt_loop(job, 'demo', lambda fb: ask(job, P, 'demo', p_demo(r, plan, fb), 'demo_writer'), v)


def assemble(job):
    plan = job.get('plan.json'); ex = job.get('extras.json')
    ch = {'titles': plan['titles'], 'short': plan.get('short') or plan['titles'], 'intro': plan['intro'],
          'concepts': job.get('concepts.json'), 'numericals': ex['numericals'], 'revision': ex['revision'], 'practice': ex['practice'],
          'formulas': ex['formulas'], 'formula_groups': ex.get('formula_groups', []), 'teach': job.get('teach.json')}
    if job.has('hinglish.json'): ch['hinglish'] = job.get('hinglish.json')
    if job.has('demo.json'): ch['demo'] = job.get('demo.json')
    return ch


def st_checks(job, r, P, refset):
    ch = assemble(job); row = R.chapter_row(ch, os.environ.get('BOOK_SLUG', 'class10-science'), r['chapter_no'], r['app']['chapter_id'])
    d = row['data']; c = {}
    c['notes_words'] = {k: words(d[f'notes_{k}']) for k in ('hi', 'en')}
    c['teach_words'] = {k: words(d['teach'][k]) for k in ('hindi', 'english')}
    c['panels'] = d['notes_en'].count('class="panel ')
    c['teach_sections'] = d['teach']['hindi'].count('class="teach-sec"')
    c['diagrams'] = d['notes_en'].count('diagram-container')
    plain = re.sub(r'<[^>]+>', ' ', d['notes_hi'] + ' ' + d['notes_en'] + ' ' + d['teach']['hindi'] + ' ' + d['teach']['english'])
    c['scope'] = [{'id': x['id'], 'covered': all(any(p.lower() in plain.lower() for p in list(en) + list(hi))
                                               for en, hi in zip(x['need_any'], x.get('need_any_hi') or [[] for _ in x['need_any']]))} for x in r['scope_items']]
    ov = C.overlap({'t': plain}, refset)
    c['copyright'] = {'overlap': None if ov is None else round(ov, 4), 'threshold': 0.2, 'note': 'automatic metric, not legal clearance'}
    # numericals re-solved by a different AI: the final number of the stored answer must appear in the solver's answer
    try:
        unit = lambda a: (re.findall(r'\d\s*([A-Za-zΩ°%][A-Za-zΩ°%/·²³^0-9]*)\s*\)?\.?$', a.strip()) or [''])[0]
        got, prov, model = P.solve_numericals([n['given'][1] + (f" (give the final answer in {unit(n['answer'][1])})" if unit(n['answer'][1]) else '')
                                              for n in ch['numericals']])
    finally:
        job.log_calls(P)
    job.attribute('checks', 'numerical_solver', prov, model)
    num = lambda s: re.findall(r'\d+(?:\.\d+)?', str(s).replace(',', ''))
    c['numericals'] = [{'n': i + 1, 'stored': n['answer'][1], 'solver': g, 'agree': bool(num(n['answer'][1])) and num(n['answer'][1])[-1] in num(g)}
                       for i, (n, g) in enumerate(zip(ch['numericals'], got + [''] * 10))]
    try:
        ok, why, prov, model = P.fact_check_app({'notes': re.sub(r'<[^>]+>', ' ', d['notes_en'])[:20000]})
    finally:
        job.log_calls(P)
    job.attribute('checks', 'fact_checker', prov, model); c['fact_check'] = {'correct': ok, 'reason': why}
    probs = []
    for k in ('hi', 'en'):
        if c['notes_words'][k] < MIN['notes_words']: probs.append(f"notes_{k} {c['notes_words'][k]} words (min {MIN['notes_words']})")
    for k in ('hindi', 'english'):
        if c['teach_words'][k] < MIN['teach_words']: probs.append(f"teach {k} {c['teach_words'][k]} words (min {MIN['teach_words']})")
    if c['panels'] < MIN['panels']: probs.append(f"panels {c['panels']} (min {MIN['panels']})")
    if c['teach_sections'] < MIN['teach_sections']: probs.append(f"teach sections {c['teach_sections']} (min {MIN['teach_sections']})")
    if c['diagrams'] < MIN['diagrams']: probs.append(f"diagrams {c['diagrams']} (min {MIN['diagrams']})")
    probs += [f"syllabus item {x['id']} not covered" for x in c['scope'] if not x['covered']]
    if ov is None: probs.append('copyright check did not run')
    elif ov > 0.2: probs.append(f'copyright overlap {ov:.0%}')
    probs += [f"numerical {x['n']}: independent solver got a different answer" for x in c['numericals'] if not x['agree']]
    if ok is not True: probs.append('fact check ' + ('inconclusive' if ok is None else 'failed') + f': {why}')
    if not d.get('demo_html'): probs.append('3D model missing')
    c['problems'] = probs
    job.put('checks.json', c); job.put('chapter_books_row.json', row); job.save()
    # one bounded correction round: the parts the checkers named are rewritten with the checker's reason, then all checks run again
    if probs and not job.d.get('corrected') and P is not None:
        fix_c = [x for x in ch['concepts'] if ok is not True and any(t and t.lower() in why.lower() for t in x['title'])]
        fix_n = [x['n'] for x in c['numericals'] if not x['agree']]
        if fix_c or fix_n:
            job.d['corrected'] = {'concepts': [x['key'] for x in fix_c], 'numericals': fix_n, 'at': J.now()}; job.save()
            if fix_c: correct_concepts(job, r, P, fix_c, why)
            if fix_n: correct_numericals(job, r, P, fix_n, c['numericals'])
            return st_checks(job, r, P, refset)
    if probs:
        job.d['issues'].append({'at': J.now(), 'kind': 'checks_failed', 'detail': 'book checks: ' + '; '.join(probs)[:700]})
        return 'needs_review'
    return 'review_ready'


def correct_concepts(job, r, P, fix, reason):
    plan = job.get('plan.json'); depth = C.LEVELS[r['app']['level_id']]['depth']
    items = [p for p in plan['concepts'] if p['key'] in {x['key'] for x in fix}]
    got = {c.get('key'): c for c in ask(job, P, 'correction', p_concepts(r, plan, items, depth, 'A fact checker found this error; correct it: ' + reason), 'writer').get('concepts', [])}
    cs = job.get('concepts.json')
    for i, c in enumerate(cs):
        g = got.get(c['key'])
        if g and not concept_problems(g):
            if g.get('diagram') and not R.safe_svg((g['diagram'] or {}).get('svg')): g['diagram'] = c.get('diagram')
            cs[i] = {**g, 'key': c['key'], 'scope_ids': c.get('scope_ids', [])}
    job.put('concepts.json', cs); job.save()


def correct_numericals(job, r, P, fix, results):
    plan = job.get('plan.json'); depth = C.LEVELS[r['app']['level_id']]['depth']; ex = job.get('extras.json')
    fb = '; '.join(f"numerical {x['n']}: your answer '{x['stored']}', an independent solver got '{x['solver']}' - recompute carefully, "
                   'ask for exactly one quantity, and make the final answer state that quantity with its unit' for x in results if x['n'] in fix)
    new = ask(job, P, 'correction', p_extras(r, plan, depth, fb), 'writer')
    if len(new.get('numericals') or []) >= len(ex['numericals']):
        for k in fix: ex['numericals'][k - 1] = new['numericals'][k - 1]
        job.put('extras.json', ex); job.save()


def finish(job, r, state):
    job.d['final_state'] = state; job.d['finished_at'] = J.now(); job.save()
    rows = [f"# {r['chapter']} — {state} (book format)", 'review_ready = all automatic checks passed; NOT published; owner review needed.', '']
    for s, v in job.d['stages'].items(): rows.append(f"- {s}: {v.get('status')} (attempts {v.get('attempts', 0)}, calls {v.get('calls', 0)})")
    if job.has('checks.json'): rows += ['', '## Checks', '```', json.dumps(job.get('checks.json'), ensure_ascii=False, indent=1)[:4000], '```']
    rows += ['', '## Who did what'] + [f"- {a['stage']} / {a['role']}: {a['provider']} {a['model']}" for a in job.d['attribution']]
    if job.d['issues']: rows += ['', '## Issues'] + [f"- {i['kind']}: {i['detail']}" for i in job.d['issues']]
    open(os.path.join(job.dir, 'report.md'), 'w', encoding='utf-8').write('\n'.join(rows) + '\n')
    return {'final_state': state, 'job': job.d['job_id'], 'dir': job.dir, 'reused': False}


if __name__ == '__main__':
    import providers
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    out = run(args[0], providers.Real(), retry='--retry' in sys.argv, reference_dir=os.environ.get('COPYRIGHT_FINGERPRINTS'))
    print(json.dumps(out, ensure_ascii=False))
    sys.exit(0 if out['final_state'] in ('review_ready', 'needs_review') else 2)
