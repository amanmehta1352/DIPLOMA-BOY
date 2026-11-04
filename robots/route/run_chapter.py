"""Robot route test: one chapter, English (DeepSeek) + Hindi (Gemini), checked by Cloudflare AI. Writes FILES only, never the database.

   python3 robots/route/run_chapter.py            (needs OPENROUTER_API_KEY, CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID, GEMINI_API_KEY)
   python3 robots/route/run_chapter.py --selftest (no keys; tests the checks only)

Policy used: class_9_10, science -> English primary, Hindi secondary; depth 3 concept + 2 formula + 2 example + 3 MCQ per language.
Keys are never printed.
"""
import json, os, re, sys, time, urllib.request, urllib.error

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, '..', '..', 'content', 'generated', 'class9-physics-force')
OR_KEY = os.environ.get('OPENROUTER_API_KEY', '').strip()
OR_MODEL = os.environ.get('OPENROUTER_MODEL', 'deepseek/deepseek-chat')
CF_TOKEN = os.environ.get('CLOUDFLARE_API_TOKEN', '').strip()
CF_ACCOUNT = os.environ.get('CLOUDFLARE_ACCOUNT_ID', '').strip()
CF_MODEL = os.environ.get('CLOUDFLARE_WRITE_MODEL', '@cf/meta/llama-3.3-70b-instruct-fp8-fast')
G_KEY = os.environ.get('GEMINI_API_KEY', '').strip()
G_MODELS = ['gemini-3.5-flash', 'gemini-flash-latest', 'gemini-3.8-flash']
COUNTS = {'concepts': 3, 'formulas': 2, 'examples': 2, 'mcqs': 3}
TOPIC = 'Class 9 Physics (CBSE): Force and Laws of Motion'


def hide(s):
    s = str(s)
    for k in (OR_KEY, CF_TOKEN, G_KEY, CF_ACCOUNT):
        if k:
            s = s.replace(k, '[hidden]')
    return s


def http(url, headers, body, timeout=240):
    req = urllib.request.Request(url, data=body, headers=headers, method='POST')
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status, r.read()
    except urllib.error.HTTPError as e:
        return e.code, e.read()
    except (TimeoutError, urllib.error.URLError, OSError) as e:
        return 504, str(e).encode()


def chat(url, key, model, prompt, timeout=240):
    body = json.dumps({'model': model, 'messages': [{'role': 'user', 'content': prompt}], 'temperature': 0.3, 'max_tokens': 4000}).encode()
    s, b = http(url, {'Authorization': 'Bearer ' + key, 'Content-Type': 'application/json'}, body, timeout)
    if s != 200:
        raise RuntimeError(f'HTTP {s}')       # body is not printed: it may echo account details
    return json.loads(b)['choices'][0]['message']['content'] or ''


def gemini(prompt):
    last = ''
    for m in G_MODELS:
        body = json.dumps({'contents': [{'parts': [{'text': prompt}]}],
                           'generationConfig': {'temperature': 0.3, 'responseMimeType': 'application/json'}}).encode()
        s, b = http(f'https://generativelanguage.googleapis.com/v1beta/models/{m}:generateContent',
                    {'x-goog-api-key': G_KEY, 'Content-Type': 'application/json'}, body)
        if s == 200:
            d = json.loads(b)
            return ''.join(p.get('text', '') for p in d['candidates'][0]['content']['parts']), m
        last = f'{m}: HTTP {s}'
        time.sleep(3)
    raise RuntimeError('Gemini failed: ' + last)


def parse_json(txt):
    txt = txt.strip()
    txt = re.sub(r'^```(?:json)?\s*|\s*```$', '', txt)
    i, j = txt.find('{'), txt.rfind('}')
    return json.loads(txt[i:j + 1])


def structure_problems(d):
    """Counts, 4 options, answer index 0-3, no HTML/LaTeX. Returns a list of problems (empty = ok)."""
    p = []
    for k, n in COUNTS.items():
        if not isinstance(d.get(k), list) or len(d[k]) != n:
            p.append(f'{k}: need {n}')
    for sec in ('concepts', 'formulas', 'examples'):
        for x in d.get(sec) or []:
            if not (isinstance(x, dict) and str(x.get('title', '')).strip() and str(x.get('body', '')).strip()):
                p.append(f'{sec}: empty title or body')
    for q in d.get('mcqs') or []:
        if not isinstance(q, dict) or len(q.get('options') or []) != 4 or q.get('answer_index') not in (0, 1, 2, 3) \
                or not str(q.get('question', '')).strip() or not str(q.get('explanation', '')).strip():
            p.append('mcq: bad shape')
    if re.search(r'<[a-zA-Z/][^>]*>|\\\(|\\\[|\$\$', json.dumps(d, ensure_ascii=False)):
        p.append('html or latex found')
    return p


def numbers(d):
    return sorted(re.findall(r'\d+(?:\.\d+)?', json.dumps(d, ensure_ascii=False)))


def write_prompt():
    return (f'Write study content for: {TOPIC}. Level: Indian Class 9 board (NCERT style). Language: English. '
            'Write original sentences (do not copy a textbook). Return ONLY JSON with this exact shape: '
            '{"concepts":[{"title":"","body":""} x3], "formulas":[{"title":"","body":""} x2], "examples":[{"title":"","body":""} x2], '
            '"mcqs":[{"question":"","options":["","","",""],"answer_index":0,"explanation":""} x3]}. '
            'Concepts: what is force, inertia (first law), action-reaction (third law). Formulas: F = m x a, and momentum p = m x v with F = change in p / change in t. '
            'Examples: one everyday, one applied. MCQs: easy to medium, numerical or conceptual, one correct option each. '
            'Plain text only: no HTML, no LaTeX, write formulas like F = m x a.')


def verify_mcqs(d):
    """Cloudflare AI solves each MCQ without seeing the answer. Returns (agree, total, details)."""
    agree, det = 0, []
    for i, q in enumerate(d['mcqs']):
        opts = '\n'.join(f'{n}) {o}' for n, o in enumerate(q['options']))
        prompt = f'Answer this physics question. Reply with only the option number (0, 1, 2 or 3).\n\n{q["question"]}\n{opts}'
        try:
            txt = chat(f'https://api.cloudflare.com/client/v4/accounts/{CF_ACCOUNT}/ai/v1/chat/completions', CF_TOKEN, CF_MODEL, prompt, 120)
            m = re.search(r'[0-3]', txt)
            got = int(m.group()) if m else -1
        except Exception as e:
            got = -2
            det.append(f'mcq{i + 1}: verifier error {hide(e)}')
            continue
        ok = got == q['answer_index']
        agree += ok
        det.append(f'mcq{i + 1}: stored {q["answer_index"]}, verifier {got}, {"agree" if ok else "DISAGREE"}')
    return agree, len(d['mcqs']), det


def hindi_prompt(en):
    return ('Convert this Class 9 physics content into natural, textbook-quality Hindi (NCERT Hindi terminology: बल, जड़त्व, संवेग, त्वरण, द्रव्यमान). '
            'Do NOT translate word for word; write it the way a good Hindi teacher would. Keep every number, unit, formula and answer_index exactly the same. '
            'Keep the same JSON shape and keys. Plain text only. Return ONLY JSON.\n\n' + json.dumps(en, ensure_ascii=False))


def selftest():
    good = {'concepts': [{'title': 'a', 'body': 'b'}] * 3, 'formulas': [{'title': 'a', 'body': 'F = m x a'}] * 2,
            'examples': [{'title': 'a', 'body': 'b'}] * 2,
            'mcqs': [{'question': 'q', 'options': ['1', '2', '3', '4'], 'answer_index': 2, 'explanation': 'e'}] * 3}
    assert structure_problems(good) == []
    bad = json.loads(json.dumps(good)); bad['concepts'].pop(); bad['mcqs'][0]['answer_index'] = 7; bad['examples'][0]['body'] = '<b>x</b>'
    assert len(structure_problems(bad)) == 3, structure_problems(bad)
    assert numbers({'a': 'F = 2 x 3 = 6 N'}) == ['2', '3', '6']
    assert parse_json('```json\n{"a": 1}\n```') == {'a': 1}
    print('selftest ok')


def main():
    missing = [n for n, v in (('OPENROUTER_API_KEY', OR_KEY), ('CLOUDFLARE_API_TOKEN', CF_TOKEN), ('CLOUDFLARE_ACCOUNT_ID', CF_ACCOUNT), ('GEMINI_API_KEY', G_KEY)) if not v]
    rep = {'topic': TOPIC, 'policy': 'class_9_10 science: en primary, hi secondary', 'writer': OR_MODEL, 'verifier': CF_MODEL, 'attempts': [], 'status': 'failed'}
    os.makedirs(OUT, exist_ok=True)
    if missing:
        rep['error'] = 'missing secrets: ' + ', '.join(missing)
        json.dump(rep, open(os.path.join(OUT, 'report.json'), 'w'), indent=1)
        print(rep['error']); return 1
    en = None
    for attempt in range(1, 4):                              # mismatch -> regenerate (max 3)
        a = {'n': attempt}
        try:
            en = parse_json(chat('https://openrouter.ai/api/v1/chat/completions', OR_KEY, OR_MODEL, write_prompt()))
            a['structure'] = structure_problems(en)
            if not a['structure']:
                agree, total, det = verify_mcqs(en)
                a['verify'] = {'agree': agree, 'total': total, 'details': det}
                if agree == total:
                    rep['attempts'].append(a); break
            else:
                a['verify'] = 'skipped (structure failed)'
        except Exception as e:
            a['error'] = hide(e)
        rep['attempts'].append(a); en = None
    if en is None:
        rep['error'] = 'English did not pass structure + verifier in 3 attempts'
        json.dump(rep, open(os.path.join(OUT, 'report.json'), 'w'), ensure_ascii=False, indent=1)
        print(rep['error']); return 1
    json.dump(en, open(os.path.join(OUT, 'en.json'), 'w'), ensure_ascii=False, indent=1)
    try:
        txt, gm = gemini(hindi_prompt(en)); hi = parse_json(txt); rep['translator'] = gm
        hp = structure_problems(hi)
        if numbers(hi) != numbers(en): hp.append('numbers differ from English')
        if [q['answer_index'] for q in hi.get('mcqs', [])] != [q['answer_index'] for q in en['mcqs']]: hp.append('answer_index differs')
        rep['hindi_problems'] = hp
        json.dump(hi, open(os.path.join(OUT, 'hi.json'), 'w'), ensure_ascii=False, indent=1)
    except Exception as e:
        rep['hindi_problems'] = ['hindi step failed: ' + hide(e)]
    rep['status'] = 'ok' if not rep['hindi_problems'] else 'english_ok_hindi_needs_review'
    json.dump(rep, open(os.path.join(OUT, 'report.json'), 'w'), ensure_ascii=False, indent=1)
    print('status:', rep['status']); return 0


if __name__ == '__main__':
    if '--selftest' in sys.argv:
        selftest(); sys.exit(0)
    sys.exit(main())
