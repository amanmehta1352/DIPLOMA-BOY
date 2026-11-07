"""Check 5 (owner "Do it" 2026-11-06 09:14 IST; check 4 format: combined fact text failed): answer-blind solver + fact check on Q19 and Q22 ONLY, max 1 retry, free OpenRouter checker.
Nothing is written or rewritten; no DB. usage: verify_q.py <job_dir> <out_dir>"""
import hashlib, json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import providers
QN = (19, 22)


def perms(seed, n):
    return [sorted(range(4), key=lambda k, i=i: hashlib.sha256(f'{seed}|{i}|{k}'.encode()).hexdigest()) for i in range(n)]


def blind(P, qs, seed):
    pm = perms(seed, len(qs))
    items = [{'q': q['assertion'][1] + ' || REASON: ' + q['reason'][1], 'options': [q['options'][k][1] for k in p], 'answer': p.index(q['answer_index'])} for q, p in zip(qs, pm)]
    got, prov, model = P.solve_all(items)
    mapped = [p[g] if isinstance(g, int) and 0 <= g < 4 else None for p, g in zip(pm, list(got) + [None] * len(qs))]
    return [{'q': n, 'seed': seed, 'key': q['answer_index'], 'solver': m, 'ok': m == q['answer_index']} for n, q, m in zip(QN, qs, mapped)]


def fact(P, qs):
    """One call per item, one plain statement each (a combined multi-item text confused the checker in check 4)."""
    out = []
    for n, q in zip(QN, qs):
        txt = ('Class 10 Science exam item (Assertion-Reason). Assertion (A): ' + q['assertion'][1] + ' Reason (R): ' + q['reason'][1] +
               ' The answer key marks: "' + q['answer'][1] + '" Answer {"correct": true} only if every claim above is scientifically correct for Class 10 and the answer key is the right choice; '
               'otherwise {"correct": false, "reason": "..."}.')
        try:
            ok, why, prov, model = P.fact_check_app({'item': txt})
        except Exception as e:
            ok, why = None, f'error: {type(e).__name__}: {str(e)[:200]}'
        out.append({'q': n, 'correct': ok, 'reason': why})
    return out


def main(src, out):
    os.makedirs(out, exist_ok=True)
    bank = json.load(open(os.path.join(src, 'questions.json'), encoding='utf-8'))
    qs = [bank[n - 1] for n in QN]; assert all(q['type'] == 'assertion_reason' for q in qs)
    P = providers.Real()
    if not P.or_key: raise SystemExit('no OpenRouter key: no AI call made')
    runs = []
    for attempt, seeds in (('initial', (1, 2)), ('retry', (3, 4))):
        res = []
        for s in seeds: res += blind(P, qs, s)
        f = fact(P, qs)
        run = {'attempt': attempt, 'blind': res, 'fact': f, 'blind_ok': all(x['ok'] for x in res), 'fact_ok': all(x['correct'] is True for x in f), 'calls_so_far': P.n_calls}
        runs.append(run); print(attempt, 'blind', [(x['q'], x['seed'], x['key'], x['solver']) for x in res], 'fact', [(x['q'], x['correct']) for x in f], [(x['reason'] or '')[:250] for x in f if x['correct'] is not True], flush=True)
        if run['blind_ok'] and run['fact_ok']: break
    last = runs[-1]
    result = {'runs': runs, 'passed': last['blind_ok'] and last['fact_ok'], 'model': P.or_model, 'calls': P.n_calls, 'max_calls': P.max_calls}
    json.dump(result, open(os.path.join(out, 'verify_q_result.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print('PASSED' if result['passed'] else 'NOT PASSED', 'calls', P.n_calls)


if __name__ == '__main__': main(*sys.argv[1:3])
