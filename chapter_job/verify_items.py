"""Check 6 (owner "Do it" 2026-11-06 09:35 IST): ONE fact-check pass on the 38 non-MCQ bank items (not rewritten, no DB). Free OpenRouter checker, one call per item, no retry.
usage: verify_items.py <dir with questions.json> <out_dir>"""
import json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import providers
E_ = lambda x: x[1] if isinstance(x, list) else x
TAIL = ' Answer {"correct": true} only if every statement in the model answer is scientifically correct for CBSE Class 10 and it fully answers the question as asked; otherwise {"correct": false, "reason": "..."} naming the exact error.'


def statement(q):
    t = q['type']
    case = (' Context: ' + E_(q['case'])) if q.get('case') else ''
    if t == 'assertion_reason':
        return ('CBSE Class 10 Science Assertion-Reason item. Assertion (A): ' + E_(q['assertion']) + ' Reason (R): ' + E_(q['reason']) +
                ' Options: ' + ' | '.join(E_(o) for o in q['options']) + ' The key marks: "' + E_(q['answer']) + '"' + TAIL)
    return 'CBSE Class 10 Science (' + t + ') item.' + case + ' Question: ' + E_(q['q']) + ' Model answer: ' + E_(q['answer']) + TAIL


def main(src, out):
    os.makedirs(out, exist_ok=True)
    bank = json.load(open(os.path.join(src, 'questions.json'), encoding='utf-8'))
    P = providers.Real()
    if not P.or_key: raise SystemExit('no OpenRouter key: no AI call made')
    res = []
    for n, q in enumerate(bank, 1):
        if q['type'] in ('mcq', 'numerical'): continue  # MCQs code/AI-checked earlier; numericals code-verified
        try: ok, why, prov, model = P.fact_check_app({'item': statement(q)})
        except Exception as e: ok, why = None, f'error: {type(e).__name__}: {str(e)[:200]}'
        res.append({'n': n, 'type': q['type'], 'correct': ok, 'reason': (why or '')[:600]})
        print(n, q['type'], ok, (why or '')[:200] if ok is not True else '', flush=True)
    bad = [r for r in res if r['correct'] is not True]
    json.dump({'results': res, 'not_true': [r['n'] for r in bad], 'model': P.or_model, 'calls': P.n_calls}, open(os.path.join(out, 'verify_items_result.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print('ALL TRUE' if not bad else f'NOT TRUE: {[r["n"] for r in bad]}', 'calls', P.n_calls)


if __name__ == '__main__': main(*sys.argv[1:3])
