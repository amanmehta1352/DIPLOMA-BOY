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
import job as J, chapter_robot as C, book_render as R, numcheck as NC
from common import ProviderUnavailable, parse_json

VERSION = 'book.v3'
GLOSSARY = json.load(open(os.path.join(HERE, 'path', 'glossary', 'science_hi.json'), encoding='utf-8'))
AR_OPTIONS = [
    ['A और R दोनों सही हैं, और R, A की सही व्याख्या है।', 'Both A and R are true, and R is the correct explanation of A.'],
    ['A और R दोनों सही हैं, पर R, A की सही व्याख्या नहीं है।', 'Both A and R are true, but R is not the correct explanation of A.'],
    ['A सही है, पर R गलत है।', 'A is true, but R is false.'],
    ['A गलत है, पर R सही है।', 'A is false, but R is true.']]
BANNED_OPT = re.compile(r'all of the above|none of the above|उपरोक्त सभी|इनमें से कोई नहीं|उपर्युक्त सभी', re.I)
PATH = json.load(open(os.path.join(HERE, 'path', 'universal_subject_path.json'), encoding='utf-8'))
MIN = {'concepts': 8, 'numericals': 5, 'revision': 8, 'practice': 8, 'formulas': 4, 'notes_words': 900, 'teach_words': 1300,
       'teach_sections': 12, 'diagrams': 2, 'panels': 15}
STYLE = ('Rules: write ORIGINAL explanations (never copy any book or website). Every text field is a pair ["Hindi", "English"]. '
         'Hindi = simple standard NCERT Hindi with the English term in brackets the first time, e.g. प्रतिरोध (resistance). '
         'Maths in plain text: a/b, ×, x^2, sqrt(x); no LaTeX, no HTML. **bold** for key words. Units always. Stay inside the official syllabus. '
         'Hindi terms (use exactly these in Hindi text): ' + '; '.join(f"{t['en']} = {t['hi'][0]}" for t in GLOSSARY['terms']) + '. '
         'Level: {depth}\n')


def pair_ok(x): return isinstance(x, list) and len(x) == 2 and all(isinstance(s, str) and s.strip() for s in x)


def words(html_text): return len(re.sub(r'<[^>]+>', ' ', html_text).split())


# ---------------- prompts ----------------
def p_plan(r, ref, depth, outcomes=None):
    return (STYLE.format(depth=depth) +
            f"Plan one chapter of a school book: Class 10 {r['subject']} — {r['chapter']} ({r['chapter_hi']}).\n"
            'Official syllabus items (id: text):\n' + '\n'.join(f"- {x['id']}: {x['text']}" for x in r['scope_items']) +
            ('\nLearning outcomes the chapter must teach:\n' + '\n'.join(f"- {o['id']}: {o['text'][1]}" for o in outcomes) if outcomes else '') +
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
            'cover different syllabus items; Every numerical ALSO carries "check" for code verification: {"givens": [{"symbol": "V", "value": 12, "unit": "V"}], "formulas": ["ohm"], "unknown": "I", "answer": {"value": 3, "unit": "A"}}. ' + NC.registry_prompt() + '), 10 quick-revision facts (key: value), 10 practice questions with short answers, '
            'and every formula of the chapter (6-12) with name, short meaning and use, grouped into 2-4 topic groups.\n'
            'Return ONLY JSON: {"numericals": [{"title": ["..",".."], "given": ["..",".."], "steps": [["..",".."]], "answer": ["..",".."], "check": {...}}], '
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


def p_outcomes(r, depth, feedback=''):
    return (STYLE.format(depth=depth) + f"Write learning outcomes for Class 10 {r['subject']} — {r['chapter']}.\n"
            'Official syllabus items (id: text):\n' + '\n'.join(f"- {x['id']}: {x['text']}" for x in r['scope_items']) +
            '\nFor EVERY syllabus id write 1 to 3 outcomes: what a student can DO after the lesson, starting with a verb. '
            f"Bloom level of each is one of {', '.join(PATH['bloom'])}; use at least {PATH['blueprint']['min_bloom_levels']} different levels across the chapter.\n"
            'Return ONLY JSON: {"outcomes": [{"id": "o1", "scope_id": "<syllabus id>", "text": ["हिंदी","English"], "bloom": "apply"}]}' + (f'\nFix: {feedback}' if feedback else ''))


def p_questions(r, outcomes, quota, depth, feedback=''):
    return (STYLE.format(depth=depth) + f"Write the question bank for Class 10 {r['subject']} — {r['chapter']}.\n"
            'Outcomes (id: text):\n' + '\n'.join(f"- {o['id']} [{o['bloom']}]: {o['text'][1]}" for o in outcomes) +
            '\nWrite EXACTLY these numbers of questions per type: ' + json.dumps(quota) + '. Spread them over ALL outcomes, easy to hard; every outcome must get at least one question in the whole bank. '
            + 'Bloom mix of the bank: about 50% remember/understand, 30% apply, 20% analyze/evaluate/create; at least half must be competency-based (real situation, data, application). '
            'Rules by type: mcq = 4 options, "answer_index" is the position 0-3 of the correct option (no "answer" field for mcq); true_false/fill_blank/vsa/sa/la = short model answer; numerical = real numbers, final answer with unit, plus "check" (code verification) '
            + 'shaped {"givens": [{"symbol": "V", "value": 12, "unit": "V"}], "formulas": ["ohm"], "unknown": "I", "answer": {"value": 3, "unit": "A"}}; '
            + 'an mcq whose answer is a calculated number ALSO carries "check", and its 4 options are numbers with the unit, distractors from typical mistakes; ' + NC.registry_prompt() + '; '
            'assertion_reason = fields "assertion" and "reason" (pairs) and "answer_index" 0-3 meaning 0: both true and R explains A, 1: both true but R does not explain A, 2: A true R false, 3: A false R true (the standard options are added by code); '
            'case_based = field "case" = [hindi passage, english passage], EACH 5 to 6 full sentences (about 60-100 words; a real-life situation told in several sentences, e.g. a house wiring, a heater, a school lab; it contains every number needed), then "q" and "answer" as pairs, and "check" if the answer is calculated then the question; hots = needs reasoning, not recall. '
            'MCQ options: 4 different options, never "all/none of the above", each wrong option is a typical student mistake; put the correct option at different positions.\n'
            'Return ONLY JSON: {"questions": [{"type": "mcq", "outcome": "o1", "bloom": "apply", "q": ["..",".."], "options": [["..",".."]], "answer": ["..",".."], "answer_index": 0}]} '
            '(options and answer_index only for mcq; everything except mcq and assertion_reason has "answer" as a pair; check only for calculated answers)' + (f'\nFix: {feedback}' if feedback else ''))


# ---------------- runner ----------------
def run(command, P, retry=False, reference_dir=None, repair=None):
    """repair = {"questions": [bank numbers], "tables": [concept keys]}: resume a finished job, regenerate NOTHING; only the listed items,
    the flagged term/number/copied-run pairs and the stale Hinglish sections are rewritten, then all checks run again."""
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
    if not repair and (job.d['final_state'] == 'review_ready' or (job.d['final_state'] in ('needs_review', 'failed') and not retry)):
        return {'final_state': job.d['final_state'], 'job': key, 'dir': job.dir, 'reused': True}
    if retry:
        for s, v in job.d['stages'].items():
            if v.get('status') in ('needs_review', 'failed', 'running'): v['status'] = 'pending'; v['budget_start'] = v.get('attempts', 0)
        ref = job.d['stages'].get('reference')
        if ref and ref.get('status') == 'done' and not ref.get('n_sources'): ref['status'] = 'pending'
    if repair:
        not_done = [s for s in ('outcomes', 'plan', 'concepts', 'extras', 'questions', 'teach', 'hinglish', 'demo') if job.d['stages'].get(s, {}).get('status') != 'done']
        if not_done: return {'final_state': 'blocked', 'reason': 'repair needs a finished job; not done: ' + ', '.join(not_done), 'job': key}
        job.d['repair_scope'] = repair; job.d.setdefault('correction_rounds_before_repair', []).extend(job.d.get('correction_rounds', [])); job.d['correction_rounds'] = []
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
        for name, fn in (('outcomes', st_outcomes), ('plan', st_plan), ('concepts', st_concepts), ('extras', st_extras), ('questions', st_questions), ('teach', st_teach), ('hinglish', st_hinglish), ('demo', st_demo)):
            if job.stage(name)['status'] != 'done':
                s = fn(job, r, P, depth, ref)
                if s == 'partial': job.d['partial_stage'] = name; continue
                if s != 'done': return finish(job, r, s)
        if repair: ROT.reset(); refresh_stale(job, P)
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


class Rot:
    """Quality rotation (owner 4 Nov 2026): a provider whose replies were rejected twice for the current task is skipped for the next try,
    so the next AI in the chain does the work. It is tried again only if every other one failed."""
    def __init__(self): self.reset()
    def reset(self): self.strikes = {}; self.last = None
    def avoid(self): return {p for p, n in self.strikes.items() if n >= 2}
    def strike(self):
        if self.last: self.strikes[self.last] = self.strikes.get(self.last, 0) + 1


ROT = Rot()


def ask(job, P, stage, prompt, role):
    try:
        av = ROT.avoid()
        raw, prov, model = P.write(prompt, avoid=av) if av else P.write(prompt)
        ROT.last = prov
    finally:
        job.log_calls(P)
    job.attribute(stage, role, prov, model)
    st = job.stage(stage); st['calls'] = st.get('calls', 0) + 1
    open(os.path.join(job.dir, f"{stage}_{st['calls']}.raw.txt"), 'w', encoding='utf-8').write(raw or '')
    out = parse_json(raw)
    if not isinstance(out, dict): raise ValueError('reply is not a JSON object')
    return out


def attempt_loop(job, stage, build, validate, tries=3):
    """build(feedback) -> obj; validate(obj) -> list of problems. Saves the accepted object as <stage>.json."""
    st = job.stage(stage); st['status'] = 'running'; job.save(); ROT.reset()
    fb = st.get('last_feedback', '')
    while st.get('attempts', 0) - st.get('budget_start', 0) < tries:
        st['attempts'] = st.get('attempts', 0) + 1
        try:
            obj = build(fb)
        except ValueError as e:
            ROT.strike(); fb = f'reply was not valid JSON ({e})'; st['last_feedback'] = fb; job.save(); continue
        try:
            probs = validate(obj)
        except Exception as e:
            probs = [f'reply has an unexpected shape ({type(e).__name__}: {str(e)[:80]}); follow the JSON format exactly']
        if not probs:
            job.put(f'{stage}.json', obj); st.update(status='done'); job.save(); return 'done'
        ROT.strike(); fb = '; '.join(probs)[:1500]; st['last_feedback'] = fb; job.save()
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
    return attempt_loop(job, 'plan', lambda fb: ask(job, P, 'plan', p_plan(r, ref.get('outline'), depth, job.get('outcomes.json')) + (f'\nFix: {fb}' if fb else ''), 'planner'), v)


def blueprint(r):
    """Step 4: the assessment plan is fixed by code from the path file (level override possible), before any content is written."""
    b = PATH['blueprint']; q = dict(b.get(r['app']['level_id']) or b['default'])
    return {'quota': q, 'total': sum(q.values()), 'min_bloom_levels': b['min_bloom_levels'], 'bands': b.get('bands'),
            'source': b.get('source', 'path default') + ' (PYQ profile not yet connected)'}


def st_outcomes(job, r, P, depth, ref):
    ids = {x['id'] for x in r['scope_items']}
    def v(o):
        p = []; os_ = o.get('outcomes') or []
        seen = set()
        for x in os_:
            if x.get('id') in seen: p.append(f"duplicate outcome id {x.get('id')}")
            seen.add(x.get('id'))
            if x.get('scope_id') not in ids: p.append(f"{x.get('id')}: unknown scope_id {x.get('scope_id')}")
            if not pair_ok(x.get('text')): p.append(f"{x.get('id')}: text must be [hi,en]")
            if x.get('bloom') not in PATH['bloom']: p.append(f"{x.get('id')}: bloom must be one of {PATH['bloom']}")
        if ids - {x.get('scope_id') for x in os_}: p.append('syllabus ids with no outcome: ' + ', '.join(sorted(ids - {x.get('scope_id') for x in os_})))
        if len({x.get('bloom') for x in os_}) < PATH['blueprint']['min_bloom_levels']: p.append(f"use at least {PATH['blueprint']['min_bloom_levels']} Bloom levels")
        return p
    s = attempt_loop(job, 'outcomes', lambda fb: ask(job, P, 'outcomes', p_outcomes(r, depth, fb), 'planner'), v)
    if s == 'done':
        o = job.get('outcomes.json'); job.put('outcomes.json', o['outcomes']); job.put('blueprint.json', blueprint(r))
    return s


def question_problems(qs, quota, outcome_ids):
    """Never raises: a reply of any shape becomes a list of problems."""
    try:
        return _question_problems(qs, quota, outcome_ids)
    except Exception as e:      # a shape the checks did not foresee is a rejected reply, never a crashed job
        return [f'reply has an unexpected shape ({type(e).__name__}: {str(e)[:80]}); follow the JSON format exactly']


def keep_asked(qs, quota):
    """Questions of a type that was not asked in this call are dropped, and surplus of an asked type is cut (first n kept)."""
    seen = {}; out = []
    for q in qs:
        t = q.get('type') if isinstance(q, dict) else None
        if t in quota and seen.get(t, 0) < quota[t]: out.append(q); seen[t] = seen.get(t, 0) + 1
    return out


def _question_problems(qs, quota, outcome_ids):
    normalize_questions(qs); derive_mcq_answer(qs); p = []; count = {}
    for i, q in enumerate(qs):
        t = q.get('type'); count[t] = count.get(t, 0) + 1
        if t not in quota: p.append(f'q{i + 1}: type {t} not asked'); continue
        if q.get('outcome') not in outcome_ids: p.append(f'q{i + 1}: unknown outcome {q.get("outcome")}')
        if q.get('bloom') not in PATH['bloom']: p.append(f'q{i + 1}: bad bloom')
        if not pair_ok(q.get('q')) or not pair_ok(q.get('answer')): p.append(f'q{i + 1}: q/answer must be [hi,en]')
        if t == 'mcq' and not (isinstance(q.get('options'), list) and len(q['options']) == 4 and all(pair_ok(o) for o in q['options'])
                               and q.get('answer_index') in (0, 1, 2, 3)): p.append(f'q{i + 1}: mcq needs 4 option pairs and answer_index 0-3')
        if t == 'numerical' and not re.search(r'\d', ' '.join(q.get('answer') or [])): p.append(f'q{i + 1}: numerical answer needs a number')
        if t == 'numerical' and not isinstance(q.get('check'), dict): p.append(f'q{i + 1}: numerical needs "check"')
        p += [f'q{i + 1}: {x}' for x in mcq_lint(q)]
    for t, n in quota.items():
        if count.get(t, 0) != n: p.append(f'{t}: wrote {count.get(t, 0)}, want exactly {n}')
    return p


def norm(s): return re.sub(r'[\s.,;:।()\[\]"\']+', ' ', str(s)).strip().lower()


def mcq_lint(q):
    """Structural checks without any AI (literature: repeated options, key missing from options, weak AR/case items)."""
    t = q.get('type'); p = []
    if t == 'mcq' and isinstance(q.get('options'), list) and len(q['options']) == 4 and all(pair_ok(o) for o in q['options']):
        for li in (0, 1):
            if len({norm(o[li]) for o in q['options']}) < 4: p.append('mcq options repeat'); break
        if any(BANNED_OPT.search(o[0] + ' ' + o[1]) for o in q['options']): p.append('mcq uses all/none of the above')
        ai = q.get('answer_index')
        if ai in (0, 1, 2, 3) and pair_ok(q.get('answer')):
            k = q['options'][ai]
            if not (norm(k[1]) in norm(q['answer'][1]) or norm(q['answer'][1]) in norm(k[1])): p.append('mcq answer text is not the keyed option')
    if t == 'assertion_reason':
        if not (pair_ok(q.get('assertion')) and pair_ok(q.get('reason')) and q.get('answer_index') in (0, 1, 2, 3)):
            p.append('assertion_reason needs assertion, reason (pairs) and answer_index 0-3')
    if t == 'case_based' and not (pair_ok(q.get('case')) and len(q['case'][1].split()) >= 40): p.append(f'case_based needs a "case" passage of 60-100 English words (yours has {len(str((q.get("case") or ["",""])[1]).split()) if pair_ok(q.get("case")) else 0}); write a real-life situation with every number the question needs')
    return p


def unwrap_pair(x):
    """Real models sometimes wrap a pair one level deeper: [["hi","en"]]. Same text, so it is unwrapped (never invented)."""
    return x[0] if isinstance(x, list) and len(x) == 1 and pair_ok(x[0]) else x


def normalize_questions(qs):
    qs[:] = [q for q in qs if isinstance(q, dict)]
    for q in qs:
        if isinstance(q.get('outcome'), list) and q['outcome'] and all(isinstance(x, str) for x in q['outcome']): q['outcome_all'] = q['outcome']; q['outcome'] = q['outcome'][0]
        if isinstance(q.get('outcome'), dict): q['outcome'] = q['outcome'].get('id')
        for k in ('q', 'answer', 'assertion', 'reason', 'case'):
            if k in q: q[k] = unwrap_pair(q[k])
        if q.get('type') == 'assertion_reason' and pair_ok(q.get('assertion')) and pair_ok(q.get('reason')):      # stem is always derived, so it never goes stale
            q['q'] = [f"अभिकथन (A): {q['assertion'][0]} कारण (R): {q['reason'][0]}", f"Assertion (A): {q['assertion'][1]} Reason (R): {q['reason'][1]}"]
    return qs


def derive_mcq_answer(qs):
    """The AI gives options + answer_index; the answer text is copied from the keyed option by code, so key and text cannot disagree.
    An answer text the AI did write must still match (checked by mcq_lint)."""
    for q in qs:
        if q.get('type') == 'mcq' and not pair_ok(q.get('answer')) and q.get('answer_index') in (0, 1, 2, 3) \
                and isinstance(q.get('options'), list) and len(q['options']) == 4 and pair_ok(q['options'][q['answer_index']]):
            q['answer'] = list(q['options'][q['answer_index']])
        if q.get('type') == 'assertion_reason' and q.get('answer_index') in (0, 1, 2, 3):
            q['answer'] = list(AR_OPTIONS[q['answer_index']]); q['options'] = AR_OPTIONS
    return qs


def balance_keys(bank):
    """Real models put the right answer on option A most of the time (Gemini run 7: 12 of 14). Options are independent, so code moves the keyed
    option to a rotating position 0,1,2,3,... (a swap, nothing else changes) and updates answer_index."""
    i = 0
    for q in bank:
        if q.get('type') == 'mcq' and isinstance(q.get('options'), list) and len(q['options']) == 4 and q.get('answer_index') in (0, 1, 2, 3):
            tgt = i % 4; k = q['answer_index']; o = q['options']
            o[tgt], o[k] = o[k], o[tgt]; q['answer_index'] = tgt; i += 1
    return bank


def finalize_questions(bank):
    """Code adds the standard CBSE assertion-reason options and answer, so the AI cannot get their wording or order wrong."""
    balance_keys(bank)
    for q in bank:
        if q.get('type') == 'assertion_reason' and q.get('answer_index') in (0, 1, 2, 3):
            q['options'] = AR_OPTIONS; q['answer'] = AR_OPTIONS[q['answer_index']]
    return bank


def key_balance(bank):
    ks = [q['answer_index'] for q in bank if q.get('type') == 'mcq' and q.get('answer_index') in (0, 1, 2, 3)]
    share = max((ks.count(i) for i in range(4)), default=0) / max(len(ks), 1)
    return {'positions': [ks.count(i) for i in range(4)], 'max_share': round(share, 3)}


def pairs(x, out=None):
    """Every [hindi, english] text pair inside the content."""
    out = [] if out is None else out
    if pair_ok(x): out.append(x)
    elif isinstance(x, list): [pairs(y, out) for y in x]
    elif isinstance(x, dict): [pairs(v, out) for k, v in x.items() if k not in ('svg', 'script')]
    return out


DEV = str.maketrans('०१२३४५६७८९', '0123456789')


def term_check(prs):
    """CSTT/NCERT term lock: when the English side uses a glossary term, the Hindi side must use an allowed Hindi form and no banned form.
    Hindi and English sides must carry the same numbers."""
    miss, banned, nums, bad = {}, {}, 0, []
    dev = re.compile(r'[\u0900-\u097F]')
    for hi, en in prs:
        if not dev.search(hi) or dev.search(en): continue      # not a real Hindi/English pair (a table row or symbol cell the model gave as two strings)
        why = []
        for t in GLOSSARY['terms']:
            if re.search(r'(?<![a-z])' + re.escape(t['en'].lower()) + r'(?![a-z])', en.lower()) and not (t.get('loose') and len(en.split()) < 8):
                if not any(h in hi for h in t['hi']): miss[t['en']] = miss.get(t['en'], 0) + 1; why.append(f"'{t['en']}' must be '{t['hi'][0]}' in Hindi")
            for b in t.get('not', []):
                if b in hi: banned[b] = banned.get(b, 0) + 1; why.append(f"never write '{b}', write '{t['hi'][0]}'")
        a, b = num_set(hi.translate(DEV)), num_set(en)        # same numbers on both sides (a number repeated in one explanation is not a mismatch)
        if a != b: nums += 1; why.append(f'Hindi and English must carry the same numbers and formulas (Hindi has {sorted(a)}, English has {sorted(b)})')
        if why: bad.append({'pair': [hi, en], 'why': why})
    return {'pairs': len(prs), 'missing_hindi_term': miss, 'banned_form': banned, 'number_mismatch_pairs': nums,
            'glossary_verified': GLOSSARY['verified'], 'bad_pairs': bad}


def table_problems(concepts):
    """A concept table must be head = [[hi, en] per column], rows = [[[hi, en] per column] per row]; English side has no Devanagari.
    Run 12 c6: head was one Hindi-only pair, a row was [hindi label, value] cells (English replaced by the number)."""
    out = []
    for c in concepts:
        tb = c.get('table')
        if not tb: continue
        head, rows = tb.get('head') or [], tb.get('rows') or []
        cells = list(head) + [x for r_ in rows if isinstance(r_, list) for x in r_]
        bad = (not head or not rows or any(not isinstance(r_, list) or len(r_) != len(head) for r_ in rows) or any(not pair_ok(x) for x in cells)
               or any(HI.search(x[1]) for x in cells if pair_ok(x))
               or any(HI.search(x[0]) and not re.search(r'[A-Za-z]{2}', x[1]) and not HI.search(x[1]) and num_set(x[1]) and not num_set(x[0]) for x in cells if pair_ok(x)))
        if bad: out.append(c['key'])
    return out


def table_ok_after(old, new):
    if not isinstance(new, dict): return False
    if table_problems([{'key': 'x', 'table': new}]): return False
    if term_check(pairs(new))['bad_pairs']: return False
    old_nums = set().union(*[num_set(s) for pr in pairs(old) for s in pr]) if pairs(old) else set()
    new_en = set().union(*[num_set(x[1]) for x in pairs(new)]) if pairs(new) else set()
    return old_nums <= new_en                       # every value of the old table is still there


def correct_tables(job, P, keys):
    cs = job.get('concepts.json'); terms = '; '.join(f"{t['en']} = {t['hi'][0]}" for t in GLOSSARY['terms'])
    for i, c in enumerate(cs):
        if c['key'] not in keys: continue
        prompt = ('This table of a Class 10 chapter panel has a wrong JSON shape. Rewrite it with EXACTLY this shape: '
                  '{"table": {"head": [["Hindi column name", "English column name"], ...], "rows": [[["Hindi cell", "English cell"], ...one cell per column...], ...]}}. '
                  'Keep every value, number and unit; a number cell is ["value", "value"]; English cells contain no Hindi. Standard Hindi terms: ' + terms + '.\n'
                  f'Panel: {json.dumps(c.get("title"), ensure_ascii=False)}\nWrong table: {json.dumps(c["table"], ensure_ascii=False)}\nReturn ONLY JSON.')
        for _ in range(2):
            try: got = ask(job, P, 'correction', prompt, 'writer').get('table')
            except ValueError: got = None
            if table_ok_after(c['table'], got): cs[i] = {**c, 'table': got}; break
        else:
            job.d['issues'].append({'at': J.now(), 'kind': 'correction_rejected', 'detail': f"table of {c['key']}: rewrite failed the code shape/number/term check"})
    job.put('concepts.json', cs); job.save()


def num_set(s): return set(re.findall(r'\d+(?:\.\d+)?', s))


def family(provider, model):
    """Model family (company that trained it), so a checker is never the same family as the writer even when served by another host."""
    m = (model or '').lower()
    for key, fam in (('gemini', 'google'), ('gemma', 'google'), ('nemotron', 'nvidia'), ('gpt-oss', 'openai'), ('gpt', 'openai'), ('llama', 'meta'),
                     ('qwen', 'alibaba'), ('deepseek', 'deepseek'), ('mistral', 'mistral'), ('kimi', 'moonshot'), ('mock-solver', 'mock-s'), ('mock-writer', 'mock-w')):
        if key in m: return fam
    return {'gemini': 'google', 'nvidia': 'nvidia'}.get(provider, provider)


def longest_run(plain, ref):
    """Longest run of consecutive reference trigrams = words copied in a row (run of k trigrams = k + 2 words)."""
    if not ref: return None, ''
    w = re.findall(r'[a-z0-9ऀ-ॿ]+', plain.lower()); best = cur = 0; end = 0
    for i in range(len(w) - 2):
        if J.hashlib.sha256(' '.join(w[i:i + 3]).encode()).hexdigest()[:16] in ref:
            cur += 1
            if cur > best: best, end = cur, i
        else: cur = 0
    n = best + 2 if best else 0
    return n, ' '.join(w[end - best + 1:end + 3]) if best else ''


def st_questions(job, r, P, depth, ref):
    outs = job.get('outcomes.json'); bp = job.get('blueprint.json'); ids = {o['id'] for o in outs}
    st = job.stage('questions'); st['status'] = 'running'
    done = job.get('questions.partial.json') if job.has('questions.partial.json') else {}
    failed = []
    for gi, grp in enumerate(PATH['question_groups']):
        if str(gi) in done: continue
        quota = {t: bp['quota'][t] for t in grp if bp['quota'].get(t)}; fb = ''; ok = False; kept = []; ROT.reset()
        for _ in range(3):
            need = {t: n - sum(1 for q in kept if q.get('type') == t) for t, n in quota.items()}; need = {t: n for t, n in need.items() if n > 0}
            try: got = ask(job, P, 'questions', p_questions(r, outs, need, depth, fb), 'writer').get('questions', [])
            except ValueError as e: ROT.strike(); fb = f'invalid JSON ({e})'; continue
            got = keep_asked(got if isinstance(got, list) else [], need); bad = []
            for q in got:                      # each question stands on its own: good ones are kept, only the bad ones are asked for again
                pr = question_problems([q], {q.get('type'): 1}, ids)
                if pr: bad += [f"{q.get('type')}: {x.split(': ', 1)[-1]}" for x in pr]
                else: kept.append(q)
            if len(kept) >= sum(quota.values()) and not question_problems(kept, quota, ids): ok = True; break
            ROT.strike()                       # nothing usable (empty or bad) = a strike
            fb = ('kept already: ' + ', '.join(f'{t} x{sum(1 for q in kept if q.get("type") == t)}' for t in quota) + '. Write ONLY the missing ones. Problems: ' + '; '.join(bad))[:1200]
        if not ok:
            job.d['issues'].append({'at': J.now(), 'kind': 'checks_failed', 'detail': f'questions group {gi} ({", ".join(grp)}): {fb}'[:600]}); failed.append(gi)
            if kept: job.put(f'questions.kept{gi}.json', kept)
            continue
        got = kept
        done[str(gi)] = got; job.put('questions.partial.json', done); job.save()
    bank = finalize_questions([q for gi in sorted(done, key=int) for q in done[gi]])
    job.put('questions.json', bank)
    if failed:
        st['status'] = 'needs_review'; st['missing_groups'] = failed; job.save(); return 'partial'      # later stages still run, so one run shows every problem
    st.pop('missing_groups', None); st['status'] = 'done'; job.save(); return 'done'


def coverage(outcomes, bank, concepts):
    """Step 11: every outcome needs >= 1 question and >= 1 concept panel on its syllabus item; Bloom levels of questions must be spread."""
    qs = {o['id']: sum(1 for q in bank if q.get('outcome') == o['id']) for o in outcomes}
    sc = {i for c in concepts for i in c.get('scope_ids') or []}
    return {'outcomes': [{'id': o['id'], 'questions': qs[o['id']], 'concept': o['scope_id'] in sc} for o in outcomes],
            'bloom_in_questions': sorted({q.get('bloom') for q in bank}), 'types': {t: sum(1 for q in bank if q.get('type') == t) for t in PATH['question_types']},
            'bands': bands(bank)}


def bands(bank):
    n = max(len(bank), 1); B_ = PATH['bloom_bands']; out = {}
    for k, levels in B_['groups'].items(): out[k] = round(sum(1 for q in bank if q.get('bloom') in levels) / n, 3)
    comp = PATH['competency']
    out['competency'] = round(sum(1 for q in bank if q.get('type') in comp['types'] or q.get('bloom') in comp['bloom']) / n, 3)
    return out


def band_problems(b):
    lim = PATH['bloom_bands']['min']; p = [f"{k} questions {b[k]:.0%} (min {v:.0%})" for k, v in lim.items() if b.get(k, 0) < v]
    if b['competency'] < PATH['competency']['min']: p.append(f"competency-based questions {b['competency']:.0%} (min {PATH['competency']['min']:.0%})")
    return p


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
        batch = todo[i:i + 3]; fb = ''; ROT.reset()
        for _ in range(3):
            try:
                got = {c.get('key'): c for c in ask(job, P, 'concepts', p_concepts(r, plan, batch, depth, fb), 'writer').get('concepts', [])}
            except ValueError as e:
                ROT.strike(); fb = f'invalid JSON ({e})'; continue
            try:
                probs = [x for c in batch for x in (concept_problems(got[c['key']]) if c['key'] in got else [f"{c['key']}: missing"])]
            except Exception as e:
                probs = [f'concepts reply has an unexpected shape ({type(e).__name__}); follow the JSON format exactly']
            for c in batch:     # an unsafe or broken diagram is dropped (never shown); the chapter-level diagram count is gated later
                g = got.get(c['key']) or {}
                if g.get('diagram') and not R.safe_svg((g.get('diagram') or {}).get('svg')):
                    g['diagram'] = None; job.d['issues'].append({'at': J.now(), 'kind': 'diagram_dropped', 'detail': f"{c['key']}: SVG failed the safety check"})
            if not probs: break
            ROT.strike(); fb = '; '.join(probs)
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
        batch = lessons[i:i + 4]; fb = ''; got = []; ROT.reset()
        for _ in range(3):
            try:
                got = ask(job, P, 'teach', p_teach(r, batch, depth, fb), 'teacher').get('teach', [])
            except ValueError as e:
                ROT.strike(); fb = f'invalid JSON ({e})'; continue
            got = got if isinstance(got, list) else []
            probs = [] if len(got) == len(batch) else [f'wrote {len(got)} lessons, want {len(batch)}']
            probs += [f'lesson {j + 1}: needs 3+ paragraph pairs' for j, s in enumerate(got) if not isinstance(s, dict) or len(s.get('paras') or []) < 3 or not all(pair_ok(x) for x in s['paras'])]
            if not probs: break
            ROT.strike(); fb = '; '.join(probs)
        if probs:
            job.d['issues'].append({'at': J.now(), 'kind': 'checks_failed', 'detail': 'teach: ' + fb[:500]}); st['status'] = 'needs_review'; job.save(); return 'needs_review'
        out += got; job.put('teach.partial.json', out); job.save()
    job.put('teach.json', out); st['status'] = 'done'; job.save(); return 'done'


def st_hinglish(job, r, P, depth, ref):
    chp = assemble(job)
    secs = R.teach_sections(chp); st = job.stage('hinglish'); st['status'] = 'running'
    out = job.get('hinglish.partial.json') if job.has('hinglish.partial.json') else []
    for i in range(len(out), len(secs), 6):
        batch = secs[i:i + 6]; got = []; ROT.reset()
        for _ in range(3):
            try:
                got = ask(job, P, 'hinglish', p_hinglish(batch), 'transliterator').get('hinglish', [])
            except ValueError:
                got = []
            if isinstance(got, list) and len(got) == len(batch) and all(isinstance(x, dict) for x in got): break
            ROT.strike()
        if not (isinstance(got, list) and len(got) == len(batch)):
            job.d['issues'].append({'at': J.now(), 'kind': 'checks_failed', 'detail': 'hinglish: section count mismatch'}); st['status'] = 'needs_review'; job.save(); return 'needs_review'
        out += got; job.put('hinglish.partial.json', out); job.save()
    job.put('hinglish.json', out); st['status'] = 'done'; job.save(); return 'done'


THREE_NAMES = r'Vector3|Mesh|BoxGeometry|SphereGeometry|CylinderGeometry|BufferGeometry|LineBasicMaterial|Line'
HI = re.compile(r'[\u0900-\u097F]')


def repair_demo(o):
    """Deterministic repairs of two mistakes real models make: bare Vector3/Mesh... without THREE., and [english, hindi] instead of [hindi, english]."""
    if not isinstance(o, dict): return o
    if isinstance(o.get('script'), str):
        s = re.sub(r'\bnew\s+(?!THREE\.)(' + THREE_NAMES + r')\b', r'new THREE.\1', o['script']); o['script'] = s
    for k in ('title', 'hint', 'slider'):
        x = o.get(k)
        if pair_ok(x) and not HI.search(x[0]) and HI.search(x[1]): o[k] = [x[1], x[0]]
    return o


def st_demo(job, r, P, depth, ref):
    plan = job.get('plan.json')
    def v(o):
        repair_demo(o)
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


def split_answer(x):
    """A numerical answer given as [number, unit] (run 11: ["400", "J"]) is not a Hindi/English pair: code joins it to "400 J" on both sides."""
    if pair_ok(x) and not HI.search(x[0] + x[1]) and re.fullmatch(r'-?[\d.,]+(?:\s*[x×]\s*10\^?-?\d+)?', x[0].strip()) and not re.search(r'\d', x[1]) and len(x[1].strip()) <= 8:
        v = f'{x[0].strip()} {x[1].strip()}'; return [v, v]
    return x


def normalize_extras(job):
    ex = job.get('extras.json'); ch_ = False
    for n in ex.get('numericals') or []:
        s = split_answer(n.get('answer'))
        if s is not n.get('answer'): n['answer'] = s; ch_ = True
    if ch_: job.put('extras.json', ex)


def fact_text(html):
    """Notes HTML -> plain text for the fact checker; exponents kept as ^n (10<sup>10</sup> was read as '10 10' and flagged wrong)."""
    return re.sub(r'<[^>]+>', ' ', re.sub(r'<sup>\s*(.*?)\s*</sup>', r'^\1', html))


def st_checks(job, r, P, refset):
    normalize_extras(job)
    ch = assemble(job); ch['bank'] = job.get('questions.json') if job.has('questions.json') else []; job.put('chapter_app_format.json', R.app_format(ch, 'DB|class_9_10|' + str(r['app']['chapter_id']), {'robot': 'book.v2', 'job_id': job.d['job_id']})); row = R.chapter_row(ch, os.environ.get('BOOK_SLUG', 'class10-science'), r['chapter_no'], r['app']['chapter_id'])
    d = row['data']; c = {}
    c['notes_words'] = {k: words(d[f'notes_{k}']) for k in ('hi', 'en')}
    c['teach_words'] = {k: words(d['teach'][k]) for k in ('hindi', 'english')}
    c['panels'] = d['notes_en'].count('class="panel ')
    c['teach_sections'] = d['teach']['hindi'].count('class="teach-sec"')
    c['diagrams'] = d['notes_en'].count('diagram-container')
    plain = re.sub(r'<[^>]+>', ' ', d['notes_hi'] + ' ' + d['notes_en'] + ' ' + d['teach']['hindi'] + ' ' + d['teach']['english'])
    c['scope'] = [{'id': x['id'], 'covered': all(any(p.lower() in plain.lower() for p in list(en) + list(hi))
                                               for en, hi in zip(x['need_any'], x.get('need_any_hi') or [[] for _ in x['need_any']]))} for x in r['scope_items']]
    outs = job.get('outcomes.json'); bank = job.get('questions.json'); c['coverage'] = coverage(outs, bank, ch['concepts'])
    # the 4 assertion-reason options are the fixed CBSE board wording added by code, not AI text: kept out of the copyright scan
    qplain = ' '.join(x for pr in pairs([{k: v for k, v in q.items() if not (q.get('type') == 'assertion_reason' and k in ('options', 'answer'))} for q in bank]) for x in pr)
    ov = C.overlap({'t': plain + ' ' + qplain}, refset); run_n, run_txt = longest_run(plain + ' ' + qplain, refset)
    c['copyright'] = {'overlap': None if ov is None else round(ov, 4), 'threshold': 0.2, 'longest_copied_run_words': run_n, 'run_text': run_txt[:200],
                      'max_run_words': PATH['copyright']['max_run_words'], 'note': 'automatic metric, not legal clearance'}
    c['terms'] = term_check(pairs({k: v for k, v in ch.items() if k not in ('hinglish', 'demo')}) + pairs(bank))
    c['key_balance'] = key_balance(bank)
    # answer-blind solve: the checker never sees the key; options are shuffled two different ways; both passes must land on the key
    objq = [q for q in bank if q.get('type') in ('mcq', 'assertion_reason')]
    c['blind'] = {'n': len(objq), 'passes': [], 'disagree': []}
    if objq:
        for seed in (1, 2):
            perms = [sorted(range(4), key=lambda k, i=i: J.hashlib.sha256(f'{seed}|{i}|{k}'.encode()).hexdigest()) for i in range(len(objq))]
            items = [{'q': ((q['assertion'][1] + ' || REASON: ' + q['reason'][1]) if q['type'] == 'assertion_reason' else q['q'][1]),
                      'options': [q['options'][k][1] for k in pm], 'answer': pm.index(q['answer_index'])} for q, pm in zip(objq, perms)]
            try:
                got, prov, model = P.solve_all(items)
            finally:
                job.log_calls(P)
            job.attribute('checks', 'blind_solver', prov, model)
            mapped = [pm[g] if isinstance(g, int) and 0 <= g < 4 else None for pm, g in zip(perms, list(got) + [None] * len(objq))]
            c['blind']['passes'].append({'provider': prov, 'model': model, 'answered': sum(m is not None for m in mapped)})
            for i, (q, m) in enumerate(zip(objq, mapped)):
                if m != q['answer_index']: c['blind']['disagree'].append({'q': bank.index(q) + 1, 'pass': seed, 'key': q['answer_index'], 'solver': m})
        writers = {family(a['provider'], a['model']) for a in job.d['attribution'] if a['stage'] in ('questions', 'extras')}
        c['blind']['same_provider_as_writer'] = sorted(writers & {family(p_['provider'], p_['model']) for p_ in c['blind']['passes']})
    # numericals re-solved by a different AI: the final number of the stored answer must appear in the solver's answer
    try:
        unit = lambda a: (re.findall(r'\d\s*([A-Za-zΩ°%][A-Za-zΩ°%/·²³^0-9]*)\s*\)?\.?$', a.strip()) or [''])[0]
        bank_num = [q for q in bank if q['type'] == 'numerical']
        allnum = [{'given': n['given'], 'answer': n['answer'], 'check': n.get('check')} for n in ch['numericals']] + \
                 [{'given': q['q'], 'answer': q['answer'], 'check': q.get('check')} for q in bank_num]
        got, prov, model = P.solve_numericals([n['given'][1] + (f" (give the final answer in {unit(n['answer'][1])})" if unit(n['answer'][1]) else '')
                                              for n in allnum])
    finally:
        job.log_calls(P)
    job.attribute('checks', 'numerical_solver', prov, model)
    num = lambda s: re.findall(r'\d+(?:\.\d+)?', str(s).replace(',', ''))
    c['numericals'] = []
    for i, (n, g) in enumerate(zip(allnum, got + [''] * 80)):
        cok, cwhy = NC.verify(n.get('check'))
        c['numericals'].append({'n': i + 1, 'stored': n['answer'][1], 'solver': g, 'agree': bool(num(n['answer'][1])) and num(n['answer'][1])[-1] in num(g),
                                'code': cok, 'code_detail': cwhy, 'givens_in_text': NC.givens_in_text(n.get('check'), n['given'][1])})
    c['mcq_code'] = [{'q': i + 1, 'ok': ok_, 'detail': w} for i, q in enumerate(bank) if q.get('type') == 'mcq' and q.get('check')
                     for ok_, w in [NC.mcq_options_ok(q)]]
    try:
        ok, why, prov, model = P.fact_check_app({'notes': fact_text(d['notes_en'])[:20000]})
    finally:
        job.log_calls(P)
    job.attribute('checks', 'fact_checker', prov, model); c['fact_check'] = {'correct': ok, 'reason': why}
    probs = []
    miss = job.stage('questions').get('missing_groups')
    if miss: probs.append('question groups missing: ' + ', '.join(', '.join(PATH['question_groups'][g]) for g in miss))
    probs += [f"outcome {x['id']}: no question" for x in c['coverage']['outcomes'] if not x['questions']]
    probs += [f"outcome {x['id']}: no concept panel on its syllabus item" for x in c['coverage']['outcomes'] if not x['concept']]
    if len(c['coverage']['bloom_in_questions']) < PATH['blueprint']['min_bloom_levels']: probs.append('questions use too few Bloom levels')
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
    probs += [f"numerical {x['n']}: code check failed: {x['code_detail']}" for x in c['numericals'] if x['code'] is False]
    probs += [f"numerical {x['n']}: not code-verified ({x['code_detail']})" for x in c['numericals'] if x['code'] is None]
    # code (sympy + pint, registry formula) beats an AI solver - but only when every given of the code check is in the question text,
    # i.e. the code solved the question that was asked; then the AI disagreement is shown as a warning, never hidden
    probs += [f"numerical {x['n']}: independent solver got a different answer" for x in c['numericals'] if x['code'] is True and not x['agree'] and not x['givens_in_text']]
    code_over_ai = [x['n'] for x in c['numericals'] if x['code'] is True and not x['agree'] and x['givens_in_text']]
    probs += [f"mcq {x['q']}: {x['detail']}" for x in c['mcq_code'] if x['ok'] is not True]
    probs += [f"mcq {i + 1}: calculated options but no code check" for i, q in enumerate(bank) if calc_mcq(q) and not q.get('check')]
    probs += band_problems(c['coverage']['bands'])
    if run_n is not None and run_n >= PATH['copyright']['max_run_words']: probs.append(f"copyright: {run_n} words in a row match a reference book: '{run_txt[:80]}'")
    for k in sorted({d_['q'] for d_ in c['blind']['disagree']}): probs.append(f'question {k}: answer-blind solver did not reach the key')
    if c['blind'].get('same_provider_as_writer'): probs.append('blind solver is the same provider as the writer: ' + ', '.join(c['blind']['same_provider_as_writer']))
    if c['key_balance']['max_share'] > 0.4: probs.append(f"mcq keys bunched: {c['key_balance']['positions']}")
    if c['terms']['missing_hindi_term']: probs.append('Hindi term not the standard one for: ' + ', '.join(f'{k} ({v})' for k, v in c['terms']['missing_hindi_term'].items()))
    if c['terms']['banned_form']: probs.append('non-standard Hindi form used: ' + ', '.join(c['terms']['banned_form']))
    if c['terms']['number_mismatch_pairs']: probs.append(f"{c['terms']['number_mismatch_pairs']} Hindi/English pairs carry different numbers")
    c['warnings'] = ([f"numerical {n}: AI solver disagreed, code-verified answer kept (all givens are in the question)" for n in code_over_ai]) + \
                    ([] if GLOSSARY['verified'] else ['Hindi glossary checked against official PYQ Hindi usage; line-by-line CSTT check pending'])
    if ok is not True: probs.append('fact check ' + ('inconclusive' if ok is None else 'failed') + f': {why}')
    if not d.get('demo_html'): probs.append('3D model missing')
    for k_ in table_problems(ch['concepts']): probs.append(f'concept {k_}: table has a wrong shape (head/rows must be [Hindi, English] cells)')
    if job.d.get('hinglish_stale'): probs.append(f"hinglish not refreshed after Hindi rewrite: sections {job.d['hinglish_stale']}")
    c['problems'] = probs
    job.put('checks.json', c); job.put('chapter_books_row.json', row); job.save()
    # one bounded correction round: the parts the checkers named are rewritten with the checker's reason, then all checks run again
    rounds = job.d.setdefault('correction_rounds', [])
    left = getattr(P, 'max_calls', 10 ** 6) - getattr(P, 'n_calls', 0)
    if probs and P is not None and len(rounds) < MAX_CORRECTION_ROUNDS and left >= 14:
        return correction_round(job, r, P, refset, ch, bank, c, probs, ok, why, ov, run_n, run_txt)
    if probs:
        job.d['issues'].append({'at': J.now(), 'kind': 'checks_failed', 'detail': 'book checks: ' + '; '.join(probs)[:700]})
        return 'needs_review'
    return 'review_ready'


def correction_round(job, r, P, refset, ch, bank, c, probs, ok, why, ov, run_n, run_txt):
    """One bounded round: every part a checker named is rewritten with the checker's reason, then ALL checks run again (nothing is skipped)."""
    rec = {'at': J.now(), 'problems': probs[:30]}; job.d['correction_rounds'].append(rec); job.save()
    if True:
        fix_c = [x for x in ch['concepts'] if ok is not True and any(t and t.lower() in (why or '').lower() for t in x['title'])]
        if ov is not None and ov > 0.2:      # whole-chapter overlap: rewrite the 4 concepts closest to the reference
            sc = sorted(ch['concepts'], key=lambda x: -(C.overlap({'t': ' '.join(y for pr in pairs(x) for y in pr)}, refset) or 0))
            fix_c += [x for x in sc[:4] if x not in fix_c]
            why = (why or '') + ' The chapter is too close to a reference book: rewrite in completely your own words and sentence structure.'
        fix_n = [x['n'] for x in c['numericals'] if (x['code'] is not True or (not x['agree'] and not x['givens_in_text'])) and x['n'] <= len(ch['numericals'])]
        fix_q = question_fixes(bank, c)
        bad_pairs = pair_fixes(ch, bank, c, refset, run_n, run_txt)
        fix_t = table_problems(ch['concepts'])
        scope = job.d.get('repair_scope')
        if scope:      # repair run: only the owner-named items; nothing else is rewritten
            fix_c, fix_n = [], []
            fix_q = [x for x in fix_q if x[0] + 1 in scope['questions']]
            fix_t = [k_ for k_ in fix_t if k_ in scope.get('tables', fix_t)]
        rec.update({'concepts': [x['key'] for x in fix_c], 'numericals': fix_n, 'questions': [[i + 1, w[:70]] for i, w, _ in fix_q], 'pairs': len(bad_pairs)}); job.save()
        rec['tables'] = fix_t
        if not (fix_c or fix_n or fix_q or bad_pairs or fix_t):      # nothing a rewrite can fix: report, do not spend calls on a useless re-check
            job.d['issues'].append({'at': J.now(), 'kind': 'checks_failed', 'detail': 'book checks: ' + '; '.join(probs)[:700]}); job.save()
            return 'needs_review'
        if fix_c: guard(job, 'concepts', lambda: correct_concepts(job, r, P, fix_c, why))
        if fix_n: guard(job, 'numericals', lambda: correct_numericals(job, r, P, fix_n, c['numericals']))
        if fix_q: guard(job, 'questions', lambda: correct_questions(job, r, P, fix_q, refset))
        if fix_t: guard(job, 'tables', lambda: correct_tables(job, P, fix_t))
        if bad_pairs: guard(job, 'pairs', lambda: correct_pairs(job, r, P, bad_pairs, refset))
        return st_checks(job, r, P, refset)


MAX_CORRECTION_ROUNDS = 2


def guard(job, what, fn):
    """A correction that fails (bad reply, provider down) is logged; the checks still run again and report what is left."""
    try: fn()
    except Exception as e:
        job.d['issues'].append({'at': J.now(), 'kind': 'correction_failed', 'detail': f'{what}: {type(e).__name__}: {str(e)[:200]}'}); job.save()


def question_fixes(bank, c):
    """(bank index, reason, wanted bloom levels or None): questions the blind solver did not answer to the key, plus enough
    plain-recall rewrites to reach the knowledge/understanding minimum (taken only from non-competency types, so competency stays >= min)."""
    out = []; seen = set()
    for d_ in c['blind']['disagree']:
        i = d_['q'] - 1
        if i in seen: continue
        seen.add(i); q = bank[i]
        sol = d_.get('solver'); opt = q['options'][sol][1] if isinstance(sol, int) and q.get('options') and 0 <= sol < 4 else 'no answer'
        out.append((i, f"an independent solver who did not see the key chose '{opt}' but the key is '{q['options'][q['answer_index']][1]}': the question is ambiguous or the key is wrong. "
                       'Rewrite it so exactly ONE option is correct beyond any doubt, every other option is clearly wrong, and the key is that option', None))
    for x in c.get('mcq_code', []):
        if x['ok'] is not True and x['q'] - 1 not in seen:
            seen.add(x['q'] - 1); out.append((x['q'] - 1, f"code check of the options: {x['detail']}; recompute, give a correct \"check\" and exactly one option equal to the code value", None))
    for i, q in enumerate(bank):
        if calc_mcq(q) and not q.get('check') and i not in seen:
            seen.add(i); out.append((i, 'the options are calculated numbers but there is no "check": add a correct code check and make exactly one option equal to it', None))
    n = len(bank); ku = PATH['bloom_bands']['groups']['knowledge_understanding']; lim = PATH['bloom_bands']['min']
    have = sum(1 for q in bank if q.get('bloom') in ku); need = max(0, -(-int(lim['knowledge_understanding'] * n * 1000) // 1000) - have)
    if need:
        need += 1                                  # one spare so a single rejected rewrite does not leave the band short
        G = PATH['bloom_bands']['groups']; cp = PATH['competency']
        sim = [dict(q) for q in bank]; cand = []
        pool = [i for i, q in enumerate(bank) if i not in seen and not q.get('check') and q.get('type') in ('mcq', 'vsa', 'fill_blank', 'true_false', 'sa', 'la', 'assertion_reason')]
        pool.sort(key=lambda i: (bank[i].get('bloom') not in G['application'], bank[i].get('type') == 'assertion_reason'))      # apply first, then higher-order
        for i in pool:
            if len(cand) >= need: break
            if sim[i].get('bloom') in ku: continue
            old = sim[i].get('bloom'); sim[i]['bloom'] = 'understand'; b2 = bands(sim)
            if all(b2[k] >= v + 0.5 / n for k, v in lim.items() if k != 'knowledge_understanding') and b2['competency'] >= cp['min']: cand.append(i)
            else: sim[i]['bloom'] = old
        for i in cand:
            out.append((i, "rewrite it as a knowledge/understanding question (bloom 'understand'): the student explains, compares or identifies a concept of this chapter in words; no calculation", ku))
    return out


NUM_OPT = re.compile(r'^\s*-?\d[\d.,]*\s*(?:[x×]\s*10\^?\s*[-−]?\d+|[x×]\s*10[⁻⁰¹²³⁴⁵⁶⁷⁸⁹]+)?\s*[A-Za-zΩµμ°/·²³^%-]{0,8}\s*$')


def calc_mcq(q):
    """An mcq whose 4 options are numbers with units is a calculation: it must carry a code check that the code confirms."""
    return q.get('type') == 'mcq' and isinstance(q.get('options'), list) and len(q['options']) == 4 and all(pair_ok(o) and NUM_OPT.match(o[1]) for o in q['options'])


def question_ok_after(g, refset):
    """Code gates for a rewritten question (run 12: a rewrite brought in a 16-word textbook sentence, another a wrong numerical key)."""
    prs = pairs({k: v for k, v in g.items() if not (g.get('type') == 'assertion_reason' and k in ('options', 'answer'))})
    if term_check(prs)['bad_pairs']: return False
    for pr in prs:
        n_, _ = longest_run(re.sub(r'<[^>]+>', ' ', pr[0] + ' ' + pr[1]), refset)
        if n_ is not None and n_ >= PATH['copyright']['max_run_words']: return False
    if calc_mcq(g) and (NC.mcq_options_ok(g)[0] is not True or not NC.givens_in_text(g.get('check'), g['q'][1])): return False
    return True


def correct_questions(job, r, P, fixes, refset=None):
    bank = job.get('questions.json'); outs = job.get('outcomes.json'); ids = {o['id'] for o in outs}
    for k in range(0, len(fixes), 6):
        part = fixes[k:k + 6]
        qs = [{kk: v for kk, v in bank[i].items() if kk not in ('options', 'answer') or bank[i].get('type') != 'assertion_reason'} for i, _, _ in part]
        prompt = (STYLE.format(depth=C.LEVELS[r['app']['level_id']]['depth']) + f"Rewrite these Class 10 {r['subject']} questions ({r['chapter']}). Keep each one's type and outcome. "
                  'Same JSON fields as given (mcq: 4 options + answer_index, no "answer"; assertion_reason: assertion, reason, answer_index 0-3 with 0: both true and R explains A, '
                  '1: both true but R does not explain A, 2: A true R false, 3: A false R true). Every text is a pair ["Hindi", "English"]. '
                  'Write every sentence in your own words (never a textbook sentence). An mcq whose options are calculated numbers MUST carry "check" '
                  'shaped {"givens": [...], "formulas": [...], "unknown": "..", "answer": {"value": .., "unit": ".."}}; ' + NC.registry_prompt() + '.\n'
                  + '\n'.join(f'Question {j + 1}: {json.dumps(q, ensure_ascii=False)}\nWhy: {w}' for j, (q, (_, w, _)) in enumerate(zip(qs, part)))
                  + '\nReturn ONLY JSON: {"questions": [ ...same count, same order... ]}')
        got = ask(job, P, 'correction', prompt, 'writer').get('questions', [])
        got = got if isinstance(got, list) else []
        for (i, _, want), g in zip(part, got):
            if not isinstance(g, dict): continue
            g = {**g, 'type': bank[i]['type'], 'outcome': bank[i]['outcome']}
            if want: g['bloom'] = g.get('bloom') if g.get('bloom') in want else None
            else: g['bloom'] = bank[i].get('bloom')          # a key/ambiguity rewrite keeps the Bloom level (bands stay as checked)
            if g.get('bloom') not in PATH['bloom'] or question_problems([g], {g['type']: 1}, ids): continue
            if g['type'] == 'assertion_reason': g['options'] = AR_OPTIONS; g['answer'] = AR_OPTIONS[g['answer_index']]
            if not question_ok_after(g, refset):
                job.d['issues'].append({'at': J.now(), 'kind': 'correction_rejected', 'detail': f'question {i + 1}: rewrite failed a code gate (terms / copied run / calculation key)'}); continue
            bank[i] = g
    job.put('questions.json', bank); job.save()


def pair_fixes(ch, bank, c, refset, run_n, run_txt):
    """Every [Hindi, English] pair with a wrong Hindi term, a banned form, different numbers, or the copied word run, with its reasons."""
    bad = {json.dumps(b_['pair'], ensure_ascii=False): list(b_['why']) for b_ in c['terms']['bad_pairs']}
    if run_n is not None and run_n >= PATH['copyright']['max_run_words']:
        # every pair with a copied run is found (not only the longest run of the chapter), so one round removes them all
        ar_fixed = {json.dumps(x, ensure_ascii=False) for q in bank if q.get('type') == 'assertion_reason' for x in (q.get('options') or [])}
        for pr in pairs({k: v for k, v in ch.items() if k not in ('hinglish', 'demo')}) + pairs(bank):
            if json.dumps(pr, ensure_ascii=False) in ar_fixed: continue          # fixed CBSE assertion-reason wording, added by code
            n_, t_ = longest_run(re.sub(r'<[^>]+>', ' ', pr[0] + ' ' + pr[1]), refset)
            if n_ is not None and n_ >= PATH['copyright']['max_run_words']:
                bad.setdefault(json.dumps(pr, ensure_ascii=False), []).append(f"{n_} words in a row are copied from a reference book ('{t_[:80]}'): say it in completely your own words and sentence structure")
    return [{'pair': json.loads(k), 'why': v} for k, v in bad.items()]


def pair_ok_after(old, new, refset):
    """Code accepts a rewritten pair only if every problem is gone and nothing else broke."""
    if not pair_ok(new): return False
    t = term_check([new])
    if t['bad_pairs']: return False
    if re.findall(r'<[^>]+>', old[1]) and len(re.findall(r'<[^>]+>', new[1])) != len(re.findall(r'<[^>]+>', old[1])): return False
    if num_set(old[1]) - num_set(new[1]): return False                       # no fact (number) of the English text may be lost
    n, _ = longest_run(re.sub(r'<[^>]+>', ' ', new[0] + ' ' + new[1]), refset)
    return not (n is not None and n >= PATH['copyright']['max_run_words'])


CONTENT_FILES = ('plan.json', 'concepts.json', 'extras.json', 'teach.json', 'questions.json')


def correct_pairs(job, r, P, bad, refset):
    terms = '; '.join(f"{t['en']} = {t['hi'][0]}" for t in GLOSSARY['terms'])
    fixed = {}
    for k in range(0, len(bad), 12):
        part = bad[k:k + 12]
        prompt = ('Fix each [Hindi, English] text pair below. Keep the meaning, every fact, number, formula, unit, markdown (**bold**, `code`) and HTML tag. '
                  'Change ONLY what the reason says. Hindi and English must say the same thing with the same numbers. Standard Hindi terms (CSTT/NCERT): ' + terms + '. '
                  'Never write: ' + ', '.join(sorted({b_ for t in GLOSSARY['terms'] for b_ in t.get('not', [])})) + '.\n'
                  + '\n'.join(f'{j + 1}. {json.dumps(x["pair"], ensure_ascii=False)}\n   reason: ' + '; '.join(x['why']) for j, x in enumerate(part))
                  + '\nReturn ONLY JSON: {"pairs": [["Hindi", "English"], ...]} - same count, same order.')
        try: got = ask(job, P, 'correction', prompt, 'writer').get('pairs', [])
        except ValueError: continue
        for x, g in zip(part, got if isinstance(got, list) else []):
            g = unwrap_pair(g)
            if pair_ok_after(x['pair'], g, refset): fixed[json.dumps(x['pair'], ensure_ascii=False)] = g
    if not fixed: return
    before = R.teach_sections(assemble(job))
    def walk(o):
        if pair_ok(o) and json.dumps(o, ensure_ascii=False) in fixed: o[:] = fixed[json.dumps(o, ensure_ascii=False)]; return
        if isinstance(o, list): [walk(y) for y in o]
        elif isinstance(o, dict): [walk(v) for kk, v in o.items() if kk not in ('svg', 'script')]
    for f in CONTENT_FILES:
        if job.has(f):
            o = job.get(f); walk(o)
            if f == 'questions.json': normalize_questions(o)          # assertion-reason stems are rebuilt from the fixed assertion / reason
            job.put(f, o)
    job.d.setdefault('pairs_rewritten', 0); job.d['pairs_rewritten'] += len(fixed); job.save()
    refresh_hinglish(job, P, before)


def refresh_stale(job, P):
    """Repair run: the sections listed in hinglish_stale are transliterated again from the CURRENT Hindi teaching text."""
    idx = sorted(job.d.get('hinglish_stale') or [])
    if not idx or not job.has('hinglish.json'): return
    secs = R.teach_sections(assemble(job)); hg = job.get('hinglish.json')
    for k in range(0, len(idx), 6):
        part = [i for i in idx[k:k + 6] if i < len(secs) and i < len(hg)]; got = None
        for _ in range(2):
            try: got = ask(job, P, 'hinglish', p_hinglish([secs[i] for i in part]), 'transliterator').get('hinglish', [])
            except ValueError: got = None
            if isinstance(got, list) and len(got) == len(part) and all(isinstance(x, dict) for x in got): break
            ROT.strike(); got = None
        if got:
            for i, g in zip(part, got): hg[i] = g
            job.put('hinglish.json', hg); job.d['hinglish_stale'] = [i for i in job.d['hinglish_stale'] if i not in part]; job.save()
        else:
            job.d['issues'].append({'at': J.now(), 'kind': 'checks_failed', 'detail': f'hinglish refresh failed for sections {part}'}); job.save()


def refresh_hinglish(job, P, before):
    """Hinglish is a transliteration of the Hindi teaching text: sections whose Hindi changed are transliterated again (dependent content stays valid)."""
    if not job.has('hinglish.json'): return
    after = R.teach_sections(assemble(job)); hg = job.get('hinglish.json')
    idx = [i for i, (a, b_) in enumerate(zip(before, after)) if json.dumps(a, ensure_ascii=False) != json.dumps(b_, ensure_ascii=False) and i < len(hg)]
    # marked stale BEFORE any call (run 12: a crash here left 7 changed sections with old Hinglish and no flag); cleared only per success
    job.d['hinglish_stale'] = sorted(set(job.d.get('hinglish_stale', [])) | set(idx)); job.save()
    for k in range(0, len(idx), 6):
        part = idx[k:k + 6]; got = None
        for _ in range(2):
            try: got = ask(job, P, 'hinglish', p_hinglish([after[i] for i in part]), 'transliterator').get('hinglish', [])
            except ValueError: got = None
            if isinstance(got, list) and len(got) == len(part) and all(isinstance(x, dict) for x in got): break
            got = None
        if got:
            for i, g in zip(part, got): hg[i] = g
            job.put('hinglish.json', hg); job.d['hinglish_stale'] = [i for i in job.d['hinglish_stale'] if i not in part]; job.save()
        else:
            job.d['issues'].append({'at': J.now(), 'kind': 'checks_failed', 'detail': f'hinglish refresh failed for sections {part}'}); job.save()


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
    fb = '; '.join(f"numerical {x['n']}: your answer '{x['stored']}', code check: {x.get('code_detail')}, an independent solver got '{x['solver']}' - recompute carefully, give a correct \"check\", "
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
    rp = json.loads(os.environ['BOOK_REPAIR']) if '--repair' in sys.argv else None
    out = run(args[0], providers.Real(), retry='--retry' in sys.argv, reference_dir=os.environ.get('COPYRIGHT_FINGERPRINTS'), repair=rp)
    print(json.dumps(out, ensure_ascii=False))
    sys.exit(0 if out['final_state'] in ('review_ready', 'needs_review') else 2)
