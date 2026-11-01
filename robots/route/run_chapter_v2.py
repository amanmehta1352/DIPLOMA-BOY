"""Robot route v2: same chapter, with a fact-checker layer and a better writer prompt. Writes FILES only, never the database.

   python3 robots/route/run_chapter_v2.py            (needs OPENROUTER_API_KEY, CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID, GEMINI_API_KEY)
   python3 robots/route/run_chapter_v2.py --selftest (no keys)

Flow: DeepSeek writes English -> structure + content checks -> Gemini fact-checks concept/formula/example text (different company)
      -> Cloudflare AI solves the MCQs -> Gemini writes simple Hindi -> DeepSeek fact-checks the Hindi (different from the translator).
A fact-check failure sends the reason back to the writer; at most 2 regenerations, then the chapter is flagged for human review.
Also proves the checker works by running it on the known-wrong v1 output. Keys are never printed.
"""
import json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import run_chapter as R   # reuse the proven helpers (http, chat, gemini, parse_json, structure_problems, numbers, hide, verify_mcqs)

OUT = os.path.join(HERE, '..', '..', 'content', 'generated', 'class9-physics-force-v2')
V1_EN = os.path.join(HERE, '..', '..', 'content', 'generated', 'class9-physics-force', 'en.json')
OR_URL = 'https://openrouter.ai/api/v1/chat/completions'
FORMAL_HI = ['निष्कासित', 'सदैव', 'अतः', 'तात्पर्य', 'स्वाभाविक', 'प्रक्षेपित', 'युग्म', 'अत्यधिक', 'व्याख्या करता', 'तृतीय', 'प्रथम नियम', 'द्वितीय नियम']

FACT_PROMPT = ('Is this physics statement correct? Check every claim:\n'
               '- Force, friction, inertia, momentum, acceleration definitions\n'
               "- Newton's laws correctness\n"
               '- Cause-effect relationships (is the cause really the cause? friction is a force that stops a body; inertia is only the tendency to keep moving)\n'
               '- Units and dimensional consistency\n'
               "If any claim is wrong or misleading, answer {\"correct\": false, \"reason\": \"<which claim and why>\"}. "
               "If everything is correct, answer {\"correct\": true, \"reason\": \"\"}.\n"
               'Return only that JSON.\n\nTEXT:\n')


def write_prompt(feedback=''):
    p = (f'Write study content for: {R.TOPIC}. Level: Indian Class 9 board (NCERT style). Language: English. Write original sentences (do not copy a textbook). '
         'Return ONLY JSON with this exact shape: '
         '{"concepts":[{"title":"","body":""} x3], "formulas":[{"title":"","body":""} x2], "examples":[{"title":"","body":""} x2], '
         '"mcqs":[{"question":"","options":["","","",""],"answer_index":0,"difficulty":"easy","explanation":""} x3]}.\n'
         'CONCEPTS (in Newton law order, each ends with one short daily-life example): '
         '1) What is force, with its SI unit newton. '
         '2) First law and inertia; say clearly that MASS IS THE MEASURE OF INERTIA (heavier object resists change more). '
         '3) Third law; say clearly that action and reaction act on DIFFERENT bodies, so they do NOT CANCEL each other. '
         'Do not say friction happens because of inertia: friction is a force that opposes motion; inertia is only the tendency to keep moving.\n'
         'FORMULAS: F = m x a, and p = m x v with F = (change in p) / (change in t). After each formula write the units in brackets, e.g. '
         '"F = m x a (F in newton N, m in kg, a in m/s^2)", define every symbol, and give the dimensional check, e.g. "[F] = [M][L][T^-2]".\n'
         'EXAMPLES: one everyday, one applied. Describe forces correctly (name the force that does each thing).\n'
         'MCQS: exactly 1 easy (one-step recall: unit, definition or formula) and 2 medium (one two-step calculation, one real-life application). '
         'Put the label in "difficulty" ("easy" or "medium"). 4 distinct plausible options. The explanation says why the answer is right and why the others are wrong.\n'
         'Plain text only: no HTML, no LaTeX.')
    if feedback:
        p += f'\n\nA previous attempt was rejected for this reason, do not repeat it: {feedback}'
    return p


def content_problems(d):
    """Extra checks on top of the v1 structure checks. Returns a list of problems (empty = ok)."""
    p = []
    txt = lambda k: ' '.join(x.get('title', '') + ' ' + x.get('body', '') for x in d.get(k) or [] if isinstance(x, dict))
    f = txt('formulas')
    if not (re.search(r'\bkg\b', f) and 'm/s' in f and (re.search(r'\bN\b', f) or 'newton' in f.lower())):
        p.append('formulas: units (N, kg, m/s^2) missing')
    c = txt('concepts').lower()
    if not ('mass' in c and 'inertia' in c and 'measure' in c):
        p.append('concepts: "mass is the measure of inertia" missing')
    if 'cancel' not in c:
        p.append('concepts: "action-reaction do not cancel" missing')
    labels = [q.get('difficulty') for q in d.get('mcqs') or []]
    if sorted(labels) != ['easy', 'medium', 'medium']:
        p.append(f'mcq difficulty must be 1 easy + 2 medium, got {labels}')
    return p


def facts_text(d):
    return '\n'.join(f'{k.upper()}: {x["title"]}. {x["body"]}' for k in ('concepts', 'formulas', 'examples') for x in d[k])


def fact_check(text, via):
    """Returns (correct, reason). via = 'gemini' or 'deepseek'. Anything unreadable counts as NOT correct."""
    try:
        if via == 'gemini':
            raw, _ = R.gemini(FACT_PROMPT + text)
        else:
            raw = R.chat(OR_URL, R.OR_KEY, R.OR_MODEL, FACT_PROMPT + text, 180)
        j = R.parse_json(raw)
        return bool(j.get('correct')) is True, str(j.get('reason', ''))[:400]
    except Exception as e:
        return False, 'fact-checker error: ' + R.hide(e)


def hindi_prompt(en):
    return ('Convert this Class 9 physics content into SIMPLE, natural Hindi that a Class 9 student speaks and reads, the way a good teacher explains in class. '
            'Use everyday words: write "बाहर निकलना" not "निष्कासित", "हमेशा" not "सदैव", "इसलिए" not "अतः", "दूसरा/तीसरा नियम" not "द्वितीय/तृतीय नियम". '
            'Keep science terms students know (बल, जड़त्व, संवेग, त्वरण, द्रव्यमान, न्यूटन). Do NOT translate word for word. '
            'Write formulas with the Hindi words for the parts, e.g. "F = संवेग में बदलाव / समय में बदलाव". '
            'Keep every number, unit, formula, answer_index and difficulty exactly the same, and the same JSON keys and shape. Plain text only. Return ONLY JSON.\n\n'
            + json.dumps(en, ensure_ascii=False))


def formal_hindi(hi):
    t = json.dumps(hi, ensure_ascii=False)
    return [w for w in FORMAL_HI if w in t]


def save(name, obj):
    os.makedirs(OUT, exist_ok=True)
    json.dump(obj, open(os.path.join(OUT, name), 'w'), ensure_ascii=False, indent=1)


def selftest():
    good = {'concepts': [{'title': 'Mass and inertia', 'body': 'Mass is the measure of inertia.'}, {'title': 'x', 'body': 'Action and reaction do not cancel'}, {'title': 'y', 'body': 'z'}],
            'formulas': [{'title': 'F', 'body': 'F = m x a (F in newton N, m in kg, a in m/s^2)'}, {'title': 'p', 'body': 'p = m x v'}],
            'examples': [{'title': 'a', 'body': 'b'}] * 2,
            'mcqs': [{'question': 'q', 'options': ['1', '2', '3', '4'], 'answer_index': 0, 'difficulty': d, 'explanation': 'e'} for d in ('easy', 'medium', 'medium')]}
    assert R.structure_problems(good) == [] and content_problems(good) == [], content_problems(good)
    bad = json.loads(json.dumps(good)); bad['mcqs'][0]['difficulty'] = 'hard'; bad['formulas'][0]['body'] = 'F = m x a'
    assert len(content_problems(bad)) == 2, content_problems(bad)
    assert formal_hindi({'a': 'सदैव'}) == ['सदैव'] and formal_hindi({'a': 'हमेशा'}) == []
    assert 'friction' in write_prompt('x') and 'rejected' in write_prompt('why')
    print('selftest ok')


def main():
    missing = [n for n, v in (('OPENROUTER_API_KEY', R.OR_KEY), ('CLOUDFLARE_API_TOKEN', R.CF_TOKEN), ('CLOUDFLARE_ACCOUNT_ID', R.CF_ACCOUNT), ('GEMINI_API_KEY', R.G_KEY)) if not v]
    rep = {'topic': R.TOPIC, 'writer': R.OR_MODEL, 'fact_checker_en': 'gemini', 'fact_checker_hi': 'deepseek (via OpenRouter)', 'verifier': R.CF_MODEL, 'attempts': [], 'status': 'failed'}
    if missing:
        rep['error'] = 'missing secrets: ' + ', '.join(missing); save('report.json', rep); print(rep['error']); return 1
    # 0) prove the checker works: run it on the known-wrong v1 output
    try:
        ok, why = fact_check(facts_text(json.load(open(V1_EN))), 'gemini')
        rep['checker_on_v1'] = {'flagged_wrong': not ok, 'reason': why}
    except Exception as e:
        rep['checker_on_v1'] = {'error': R.hide(e)}
    # 1) write -> checks -> fact-check -> MCQ verify (max 3 tries = 2 regenerations)
    en, feedback, last = None, '', None
    for n in range(1, 4):
        a = {'n': n}
        try:
            cand = R.parse_json(R.chat(OR_URL, R.OR_KEY, R.OR_MODEL, write_prompt(feedback)))
            last = cand
            a['problems'] = R.structure_problems(cand) + content_problems(cand)
            if a['problems']:
                feedback = '; '.join(a['problems'])
            else:
                ok, why = fact_check(facts_text(cand), 'gemini')
                a['fact_check'] = {'correct': ok, 'reason': why}
                if not ok:
                    feedback = why
                else:
                    agree, total, det = R.verify_mcqs(cand)
                    a['mcq_verify'] = {'agree': agree, 'total': total, 'details': det}
                    if agree == total:
                        en = cand
                    else:
                        feedback = 'an MCQ answer was not confirmed by a second model; make the question unambiguous'
        except Exception as e:
            a['error'] = R.hide(e)
        rep['attempts'].append(a)
        if en: break
    if last: save('en_last_attempt.json', last)
    if not en:
        rep['status'] = 'needs_human_review'; rep['error'] = 'English did not pass in 3 tries (2 regenerations)'
        save('report.json', rep); print(rep['error']); return 0
    save('en.json', en)
    # 2) Hindi (Gemini) -> checks -> fact-check by a different company (DeepSeek)
    try:
        raw, gm = R.gemini(hindi_prompt(en)); hi = R.parse_json(raw); rep['translator'] = gm
        hp = R.structure_problems(hi)
        if R.numbers(hi) != R.numbers(en): hp.append('numbers differ from English')
        if [q['answer_index'] for q in hi['mcqs']] != [q['answer_index'] for q in en['mcqs']]: hp.append('answer_index differs')
        if [q.get('difficulty') for q in hi['mcqs']] != [q['difficulty'] for q in en['mcqs']]: hp.append('difficulty labels differ')
        ok, why = fact_check(facts_text(hi), 'deepseek')
        rep['hindi_fact_check'] = {'correct': ok, 'reason': why}
        if not ok: hp.append('hindi fact-check: ' + why)
        rep['hindi_formal_words_found'] = formal_hindi(hi)
        rep['hindi_problems'] = hp
        save('hi.json', hi)
    except Exception as e:
        rep['hindi_problems'] = ['hindi step failed: ' + R.hide(e)]
    rep['status'] = 'ok' if not rep.get('hindi_problems') and not rep.get('hindi_formal_words_found') else 'english_ok_hindi_needs_review'
    save('report.json', rep); print('status:', rep['status']); return 0


if __name__ == '__main__':
    if '--selftest' in sys.argv:
        selftest(); sys.exit(0)
    sys.exit(main())
