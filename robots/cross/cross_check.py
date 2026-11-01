"""Cross-check (read-only): a different AI company solves sample MCQs without seeing the answer.

   python3 robots/cross/cross_check.py --count 5 --out out

Reads random published PYQ MCQs, asks an OpenRouter model for the option number only, compares with the stored answer.
Writes out/cross_check.json. Writes nothing to the database.
Env: OPENROUTER_API_KEY, SUPABASE_SECRET_KEY, optional OPENROUTER_MODEL (default openrouter/auto). Keys never printed.
"""
import argparse, json, os, re, urllib.request, urllib.error
SB = os.environ.get('SUPABASE_URL', 'https://wobmtlcpszcntczkebtt.supabase.co').rstrip('/')
SBKEY = os.environ.get('SUPABASE_SECRET_KEY', '').strip()
ORKEY = os.environ.get('OPENROUTER_API_KEY', '').strip()
MODEL = os.environ.get('OPENROUTER_MODEL', 'openrouter/auto')


def parse_index(text, n):
    """Pure: the option number (1..n) from a reply, or None."""
    t = (text or '').strip()
    m = re.match(r'^\W*([1-9])\b', t) or re.search(r'(?:answer|option|उत्तर)\D{0,12}([1-9])\b', t, re.I) or re.search(r'\b([1-9])\b', t[-40:])
    if not m: return None
    k = int(m.group(1))
    return k if 1 <= k <= n else None


def agree(model_one_based, stored_zero_based):
    """Pure: stored answer is 0-based in the database."""
    return model_one_based is not None and model_one_based - 1 == stored_zero_based


def question_prompt(q):
    opts = '\n'.join(f"{i + 1}. {o.get('en', '')}" for i, o in enumerate(q['options']))
    return f"Answer this exam question. Reply with only the option number.\n\n{q['stem'].get('en', '')}\n{opts}"


def call_openrouter(prompt):
    body = json.dumps({'model': MODEL, 'messages': [{'role': 'user', 'content': prompt}], 'max_tokens': 300}).encode()
    req = urllib.request.Request('https://openrouter.ai/api/v1/chat/completions', body,
                                 {'Authorization': 'Bearer ' + ORKEY, 'Content-Type': 'application/json'})
    with urllib.request.urlopen(req, timeout=90) as r:
        d = json.loads(r.read())
    msg = d['choices'][0]['message']
    return (msg.get('content') or ''), d.get('model', MODEL)


def fetch_sample(n):
    h = {'apikey': SBKEY, 'Authorization': 'Bearer ' + SBKEY, 'Accept-Profile': 'mtb'}
    url = f"{SB}/rest/v1/questions?select=id,stem,options,answer&status=eq.published&kind=eq.pyq&answer=not.is.null&limit={n}&offset={int.from_bytes(os.urandom(2), 'big') % 15000}"
    with urllib.request.urlopen(urllib.request.Request(url, headers=h), timeout=60) as r:
        return json.loads(r.read())


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--count', type=int, default=5); ap.add_argument('--out', default='out'); a = ap.parse_args()
    if not (SBKEY and ORKEY): raise SystemExit('keys missing')
    rows = [q for q in fetch_sample(a.count * 3) if isinstance(q.get('options'), list) and len(q['options']) >= 2 and isinstance(q.get('answer'), int)][:a.count]
    res = []
    for q in rows:
        try:
            txt, model = call_openrouter(question_prompt(q))
            k = parse_index(txt, len(q['options']))
            res.append({'id': q['id'], 'model': model, 'model_answer': k, 'stored_answer': q['answer'] + 1, 'agree': agree(k, q['answer']), 'reply_head': txt[:80]})
        except Exception as e:
            res.append({'id': q['id'], 'error': type(e).__name__ + ': ' + str(e)[:160]})
    os.makedirs(a.out, exist_ok=True)
    json.dump({'checked': len(res), 'agree': sum(1 for r in res if r.get('agree')), 'results': res}, open(os.path.join(a.out, 'cross_check.json'), 'w'), ensure_ascii=False, indent=1)
    print(f"checked {len(res)}, agree {sum(1 for r in res if r.get('agree'))}")


if __name__ == '__main__':
    main()
