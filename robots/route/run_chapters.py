"""Robot route v3: v2 pipeline for several Class 9 physics chapters. Writes FILES only, never the database.

   python3 robots/route/run_chapters.py [slug ...]     (needs OPENROUTER_API_KEY, CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID, GEMINI_API_KEY)
   python3 robots/route/run_chapters.py --selftest

Same flow as v2 (DeepSeek writes, Gemini fact-checks, Cloudflare solves MCQs, Gemini writes Hindi, DeepSeek fact-checks Hindi), with a
chapter spec per chapter and two prompt fixes: medium MCQs need two real steps, and each chapter lists its common mistakes to avoid.
A failing chapter never stops the others. Keys are never printed.
"""
import json, os, re, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import run_chapter as R
import run_chapter_v2 as V

BASE = os.path.join(HERE, '..', '..', 'content', 'generated')
CHAPTERS = {
    'motion': {
        'title': 'Motion',
        'concepts': 'distance vs displacement; speed vs velocity (speed is a scalar, velocity a vector); acceleration (uniform and non-uniform)',
        'formulas': 'speed = distance / time with average velocity = displacement / time; equations of motion v = u + a t and s = u t + (1/2) a t^2',
        'avoid': 'Do not use speed and velocity as if they were the same; distance is never negative and can be larger than displacement.',
        'must': ['displacement', 'velocity', 'acceleration'],
        'units': [r'm/s\^2', r'm/s']},
    'gravitation': {
        'title': 'Gravitation',
        'concepts': 'universal law of gravitation; free fall and acceleration due to gravity g (about 9.8 m/s^2, same for all masses in free fall); mass vs weight',
        'formulas': 'F = G x m1 x m2 / r^2 (G = 6.67 x 10^-11 N m^2/kg^2) and weight W = m x g',
        'avoid': 'Do not say heavier objects fall faster in vacuum; mass is constant everywhere, weight changes with g; gravitational force is always attractive.',
        'must': ['free fall', 'weight', 'mass'],
        'units': [r'\bN\b', r'kg', r'm/s\^2']},
    'work_energy': {
        'title': 'Work and Energy',
        'concepts': 'work done by a force (force and displacement in the same direction); kinetic energy and potential energy; law of conservation of energy',
        'formulas': 'W = F x s (joule J) and kinetic energy = (1/2) m v^2, potential energy = m g h',
        'avoid': 'Work is zero when there is no displacement or the force is perpendicular to it (carrying a bag horizontally); energy is converted, never created or destroyed.',
        'must': ['kinetic', 'potential', 'conserv'],
        'units': [r'\bJ\b', r'kg', r'm/s']},
    'sound': {
        'title': 'Sound',
        'concepts': 'sound is a longitudinal wave that needs a medium; frequency, wavelength, amplitude, pitch and loudness; reflection of sound and echo',
        'formulas': 'wave speed v = f x lambda (write the Greek letter as the word lambda) and echo distance d = v x t / 2',
        'avoid': 'Sound cannot travel in a vacuum; particles vibrate about their place, they do not travel with the wave; pitch depends on frequency, loudness on amplitude.',
        'must': ['medium', 'frequency', 'echo'],
        'units': [r'Hz', r'm/s', r'\bm\b']},
}
FACT = ('Is this physics text correct? Check every claim: definitions, laws, formulas, cause-effect (is the stated cause the real cause?), '
        'scalar vs vector, units and dimensional consistency, and numerical values. '
        'If any claim is wrong or misleading answer {"correct": false, "reason": "<which claim and why>"}, otherwise {"correct": true, "reason": ""}. '
        'Return only that JSON.\n\nTEXT:\n')


def prompt(spec, feedback=''):
    p = (f'Write study content for: Class 9 Physics (CBSE): {spec["title"]}. Level: Indian Class 9 board (NCERT style). Language: English. '
         'Write original sentences (do not copy a textbook). Return ONLY JSON with this exact shape: '
         '{"concepts":[{"title":"","body":""} x3], "formulas":[{"title":"","body":""} x2], "examples":[{"title":"","body":""} x2], '
         '"mcqs":[{"question":"","options":["","","",""],"answer_index":0,"difficulty":"easy","explanation":""} x3]}.\n'
         f'CONCEPTS (3, each ends with one short daily-life example): {spec["concepts"]}.\n'
         f'FORMULAS (2): {spec["formulas"]}. After each formula write the units in brackets, e.g. "(F in newton N, m in kg, a in m/s^2)", '
         'define every symbol, and say what the formula is used for.\n'
         'EXAMPLES: one everyday, one applied. Name the correct cause in each.\n'
         f'COMMON MISTAKES TO AVOID: {spec["avoid"]}\n'
         'MCQS: exactly 1 easy (one-step recall) and 2 medium. A medium MCQ must need TWO real steps (for example calculate, then compare or convert units, '
         'or apply a concept to a situation and then pick the cause). Do NOT label a one-step substitution as medium. '
         'Put the label in "difficulty" ("easy" or "medium"). 4 distinct plausible options. The explanation says why the answer is right and why the others are wrong.\n'
         'Compute every numerical MCQ carefully before writing the options and put the arithmetic in the explanation; double-check it (for example sqrt(400) = 20, and a one-way echo distance is v x t / 2 only once).\n'
         'Plain text only: no HTML, no LaTeX, write powers like m/s^2.')
    return p + (f'\n\nA previous attempt was rejected for this reason, do not repeat it: {feedback}' if feedback else '')


def problems(d, spec):
    p = R.structure_problems(d)
    if p: return p
    ftxt = ' '.join(x['title'] + ' ' + x['body'] for x in d['formulas'])
    p += [f'formulas: unit {u} missing' for u in spec['units'] if not re.search(u, ftxt)]
    ctxt = ' '.join(x['title'] + ' ' + x['body'] for x in d['concepts']).lower()
    p += [f'concepts: "{k}" missing' for k in spec['must'] if k not in ctxt]
    if sorted(q.get('difficulty') for q in d['mcqs']) != ['easy', 'medium', 'medium']:
        p.append('mcq difficulty must be 1 easy + 2 medium')
    return p


def check(text, via):
    """Returns (correct, reason). A busy Gemini (429/503) is retried with waits; a persistent error is reported as an error, not as a wrong text."""
    err = ''
    for n in range(5):
        try:
            raw = R.gemini(FACT + text)[0] if via == 'gemini' else R.chat(V.OR_URL, R.OR_KEY, R.OR_MODEL, FACT + text, 180)
            j = R.parse_json(raw)
            return bool(j.get('correct')) is True, str(j.get('reason', ''))[:400]
        except Exception as e:
            err = R.hide(e); time.sleep(40 * (n + 1))
    return False, 'fact-checker error (after retries): ' + err


def gemini_solve(q):
    """Gemini solves one MCQ with written working (no JSON-only mode, so it can calculate), returns the option index or -1."""
    opts = '\n'.join(f'{i}) {o}' for i, o in enumerate(q['options']))
    body = json.dumps({'contents': [{'parts': [{'text': 'Solve this physics question carefully. Show the arithmetic step by step and double-check it. '
                                                 'Then end with one final line exactly like {"answer_index": N} where N is 0, 1, 2 or 3. If no option equals your result, use {"answer_index": -1}.\n\n'
                                                 + q['question'] + '\n' + opts}]}], 'generationConfig': {'temperature': 0}}).encode()
    for n in range(5):
        for m in R.G_MODELS:
            st, b = R.http(f'https://generativelanguage.googleapis.com/v1beta/models/{m}:generateContent',
                           {'x-goog-api-key': R.G_KEY, 'Content-Type': 'application/json'}, body)
            if st == 200:
                try:
                    txt = ''.join(x.get('text', '') for x in json.loads(b)['candidates'][0]['content']['parts'])
                    hit = re.findall(r'"answer_index"\s*:\s*(-?[0-3])', txt)
                    return int(hit[-1]) if hit else -1
                except Exception:
                    pass
        time.sleep(40 * (n + 1))      # all models busy (429/503): wait and try again
    return None                       # could not get an answer at all: never counted as a real mismatch


def strong_verify(d):
    """Returns (agree, total, details): stored answer vs Gemini's worked solution."""
    agree, det = 0, []
    for i, q in enumerate(d['mcqs']):
        got = gemini_solve(q); ok = got == q['answer_index']; agree += ok
        det.append(f'mcq{i + 1}: stored {q["answer_index"]}, gemini {got}, {"agree" if ok else ("ERROR (no answer)" if got is None else "DISAGREE")}')
    return agree, len(d['mcqs']), det


def run_one(slug, spec):
    out = os.path.join(BASE, f'class9-physics-{slug}')
    os.makedirs(out, exist_ok=True)
    save = lambda n, o: json.dump(o, open(os.path.join(out, n), 'w'), ensure_ascii=False, indent=1)
    rep = {'chapter': spec['title'], 'writer': R.OR_MODEL, 'attempts': [], 'status': 'failed'}
    en, fb, last = None, '', None
    for n in range(1, 4):
        a = {'n': n}
        try:
            cand = R.parse_json(R.chat(V.OR_URL, R.OR_KEY, R.OR_MODEL, prompt(spec, fb))); last = cand
            a['problems'] = problems(cand, spec)
            if a['problems']:
                fb = '; '.join(a['problems'])
            else:
                ok, why = check(V.facts_text(cand), 'gemini'); a['fact_check'] = {'correct': ok, 'reason': why}
                if not ok:
                    fb = why
                else:
                    agree, total, det = R.verify_mcqs(cand); a['mcq_verify'] = {'agree': agree, 'total': total, 'details': det}
                    sa, st, sdet = strong_verify(cand); a['strong_verify'] = {'agree': sa, 'total': st, 'details': sdet}
                    a['cloudflare_advisory'] = 'agrees' if agree == total else 'DISAGREES (weak model, advisory only)'
                    if sa == st: en = cand
                    else: fb = ('an MCQ answer key was not confirmed by a worked solution (' + '; '.join(d for d in sdet if 'agree' not in d or 'DISAGREE' in d)
                                + '); recompute every numerical answer carefully and make sure the explanation arithmetic is right')
        except Exception as e:
            a['error'] = R.hide(e)
        rep['attempts'].append(a)
        if en: break
    if last: save('en_last_attempt.json', last)
    if not en:
        rep['status'] = 'needs_human_review'; save('report.json', rep); return rep
    save('en.json', en)
    try:
        raw, gm = R.gemini(V.hindi_prompt(en)); hi = R.parse_json(raw); rep['translator'] = gm
        hp = R.structure_problems(hi)
        if R.numbers(hi) != R.numbers(en): hp.append('numbers differ from English')
        if [q['answer_index'] for q in hi['mcqs']] != [q['answer_index'] for q in en['mcqs']]: hp.append('answer_index differs')
        if [q.get('difficulty') for q in hi['mcqs']] != [q['difficulty'] for q in en['mcqs']]: hp.append('difficulty labels differ')
        ok, why = check(V.facts_text(hi), 'deepseek'); rep['hindi_fact_check'] = {'correct': ok, 'reason': why}
        if not ok: hp.append('hindi fact-check: ' + why)
        rep['hindi_formal_words_found'] = V.formal_hindi(hi); rep['hindi_problems'] = hp; save('hi.json', hi)
    except Exception as e:
        rep['hindi_problems'] = ['hindi step failed: ' + R.hide(e)]
    rep['status'] = 'ok' if not rep.get('hindi_problems') and not rep.get('hindi_formal_words_found') else 'english_ok_hindi_needs_review'
    save('report.json', rep); return rep


def selftest():
    s = CHAPTERS['sound']
    good = {'concepts': [{'title': 'a', 'body': 'Sound needs a medium'}, {'title': 'b', 'body': 'frequency'}, {'title': 'c', 'body': 'echo'}],
            'formulas': [{'title': 'v', 'body': 'v = f x lambda (v in m/s, f in Hz, lambda in m)'}, {'title': 'd', 'body': 'd = v x t / 2'}],
            'examples': [{'title': 'a', 'body': 'b'}] * 2,
            'mcqs': [{'question': 'q', 'options': ['1', '2', '3', '4'], 'answer_index': 0, 'difficulty': d, 'explanation': 'e'} for d in ('easy', 'medium', 'medium')]}
    assert problems(good, s) == [], problems(good, s)
    bad = json.loads(json.dumps(good)); bad['concepts'][2]['body'] = 'x'; bad['mcqs'][0]['difficulty'] = 'hard'
    assert len(problems(bad, s)) == 2, problems(bad, s)
    assert 'TWO real steps' in prompt(s) and 'rejected' in prompt(s, 'why')
    print('selftest ok')


def recheck():
    """Runs the strong verifier on chapters already generated. Proves it catches the wrong keys."""
    res = {}
    for slug in CHAPTERS:
        f = os.path.join(BASE, f'class9-physics-{slug}', 'en.json')
        if not os.path.exists(f): res[slug] = 'no en.json (chapter was rejected)'; continue
        a, t, det = strong_verify(json.load(open(f))); res[slug] = {'agree': a, 'total': t, 'details': det}
        print(slug, a, '/', t, flush=True)
    json.dump(res, open(os.path.join(BASE, 'recheck_v4.json'), 'w'), indent=1)


def main(slugs):
    miss = [n for n, v in (('OPENROUTER_API_KEY', R.OR_KEY), ('CLOUDFLARE_API_TOKEN', R.CF_TOKEN), ('CLOUDFLARE_ACCOUNT_ID', R.CF_ACCOUNT), ('GEMINI_API_KEY', R.G_KEY)) if not v]
    os.makedirs(BASE, exist_ok=True)
    if miss:
        print('missing secrets: ' + ', '.join(miss)); return 1
    if '--recheck' in sys.argv: recheck()
    summary = {}
    for s in slugs or list(CHAPTERS):
        try: summary[s] = run_one(s, CHAPTERS[s])['status']
        except Exception as e: summary[s] = 'crashed: ' + R.hide(e)
        print(s, summary[s], flush=True)
    json.dump(summary, open(os.path.join(BASE, 'summary_v4.json'), 'w'), indent=1); return 0


if __name__ == '__main__':
    if '--selftest' in sys.argv: selftest(); sys.exit(0)
    sys.exit(main([a for a in sys.argv[1:] if not a.startswith('-')]))
