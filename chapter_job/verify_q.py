"""Check 4 (owner decision 2026-11-06 08:59 IST): answer-blind solver + fact check on Q19 and Q22 ONLY, max 1 retry, free OpenRouter checker.
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
    txt = [{'assertion': q['assertion'][1], 'reason': q['reason'][1], 'keyed_answer': q['answer'][1],
            'task': 'Assertion-Reason question: is the keyed answer scientifically correct for this assertion and reason?'} for q in qs]
    try:
        ok, why, prov, model = P.fact_check_app({'questions': txt})
    except Exception as e:
        ok, why = None, f'error: {type(e).__name__}: {str(e)[:200]}'
    return {'correct': ok, 'reason': why}


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
        run = {'attempt': attempt, 'blind': res, 'fact': f, 'blind_ok': all(x['ok'] for x in res), 'calls_so_far': P.n_calls}
        runs.append(run); print(attempt, 'blind', [(x['q'], x['seed'], x['key'], x['solver']) for x in res], 'fact', f['correct'], (f['reason'] or '')[:300], flush=True)
        if run['blind_ok'] and f['correct'] is True: break
    last = runs[-1]
    result = {'runs': runs, 'passed': last['blind_ok'] and last['fact']['correct'] is True, 'model': P.or_model, 'calls': P.n_calls, 'max_calls': P.max_calls}
    json.dump(result, open(os.path.join(out, 'verify_q_result.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print('PASSED' if result['passed'] else 'NOT PASSED', 'calls', P.n_calls)


if __name__ == '__main__': main(*sys.argv[1:3])
