"""Topic sample: writes short, original concept notes for the first N missing topics of one level.

   python3 robots/sample/topic_sample.py --level govt_technical --count 5 --out out

Input: syllabus-state/syllabus_return.json (missing topics per level, from the Syllabus Watcher).
Output: out/topic_sample.json. Nothing is written to the database; this is a review sample.
Env: GEMINI_API_KEY (never printed). No AI judgement is trusted: the output is only for a human to read.
"""
import argparse, json, os, sys, urllib.request
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'writer'))
RETURN_URL = 'https://raw.githubusercontent.com/amanmehta1352/DIPLOMA-BOY/syllabus-state/syllabus_return.json'

PROMPT = """Write a short study note for an Indian competitive-exam student on this topic: "{topic}".
Rules: write your own words (no copied text), facts only, no made-up numbers.
Return only JSON: {{"topic": "...", "concept": "2-3 sentences in simple English", "key_points": ["3 short points"], "formula_or_fact": "one key formula or fact, or empty"}}"""


def build_prompt(topic):
    return PROMPT.format(topic=topic)


def check_note(n):
    """Pure: basic structure checks. Returns a list of problems (empty = passes the structural check only)."""
    p = []
    if not isinstance(n, dict): return ['not an object']
    if not str(n.get('concept', '')).strip(): p.append('no concept')
    kp = n.get('key_points')
    if not isinstance(kp, list) or not 2 <= len(kp) <= 5: p.append('key_points must be 2-5 items')
    if any(ch in str(n) for ch in ('<', '>')): p.append('html in text')
    return p


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--level', default='govt_technical'); ap.add_argument('--count', type=int, default=5); ap.add_argument('--out', default='out'); a = ap.parse_args()
    r = json.loads(urllib.request.urlopen(RETURN_URL + '?t=' + str(int(__import__('time').time())), timeout=60).read())
    missing = [m if isinstance(m, str) else m.get('title', '') for m in (r.get('pages', {}).get(a.level, {}).get('missing') or [])][:a.count]
    if not missing: sys.exit('no missing topics for ' + a.level)
    import writer as W
    notes, problems = [], []
    for t in missing:
        try:
            txt, model = W.gemini(build_prompt(t), W.WRITE_MODELS)
            n = W.parse_json(txt)
            pr = check_note(n)
            notes.append({'topic': t, 'model': model, 'note': n, 'problems': pr})
        except Exception as e:
            notes.append({'topic': t, 'error': W.hide(e)[:200]})
    os.makedirs(a.out, exist_ok=True)
    json.dump({'level': a.level, 'count': len(notes), 'notes': notes}, open(os.path.join(a.out, 'topic_sample.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(f'{len(notes)} notes for {a.level}; passed structure check: {sum(1 for x in notes if x.get("note") and not x.get("problems"))}')


if __name__ == '__main__':
    main()
