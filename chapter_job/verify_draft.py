"""Verify-only run for an app draft (owner approval 2026-11-06 07:40 IST: one fact-check + blind-solver AI run, max 1 retry).
No AI writes or rewrites anything here: PROVIDER_MAX_CALLS is kept below the correction-round minimum, and the checkers
are OpenRouter only (a different company from the writers). Nothing is written to the DB.

usage: verify_draft.py <job_dir> <fingerprints_dir> <app_draft.json> <out_dir>
"""
import json, os, re, shutil, sys
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import job as J, book_robot as B, chapter_robot as C, providers

JOB_ID = '3bd19df16b889b65'


def sections(d):
    """App draft (one language) -> named chunks the fact checker reads (what students will see)."""
    prac = [{'q': p['q'], 'correct_answer': p['options'][p['answer']], 'explanation': p.get('explanation', '')} for p in d['practice']]
    return [('notes', {'notes': d['notes']}),
            ('formulas_solved', {'formulas': d['formulas'], 'solved': d['solved']}),
            ('practice', {'practice_questions_with_correct_answer': prac}),
            ('revision_mistakes', {'revision': d['revision'], 'mistakes': d['mistakes']}),
            ('teach', {'teach': d['teach']})]


def main(src, fp, draft_path, out):
    os.makedirs(out, exist_ok=True)
    J.JOBS = os.path.join(out, 'jobs'); shutil.rmtree(J.JOBS, ignore_errors=True); os.makedirs(J.JOBS)
    shutil.copytree(src, os.path.join(J.JOBS, JOB_ID))
    syl = json.load(open(J.SYLLABUS, encoding='utf-8'))
    r = J.resolve(J.parse_command('Class 10, CBSE 2026-27, Science, Electricity'), syl); r['app'] = C.find_app(syl, r)
    job = J.Job(JOB_ID); job.d['hinglish_stale'] = []; job.d['correction_rounds'] = [{'note': 'verify-only run: no rewrite'}] * B.MAX_CORRECTION_ROUNDS
    refset, _ = J.load_reference(fp)
    P = providers.Real()
    if not P.or_key: raise SystemExit('no OpenRouter key: no AI call made')
    state = B.st_checks(job, r, P, refset)          # robot's own checks: blind solve x2, numericals solver, notes fact check, all code checks
    chk = json.load(open(os.path.join(J.JOBS, JOB_ID, 'checks.json'), encoding='utf-8'))
    draft = json.load(open(draft_path, encoding='utf-8'))['data']
    app_fact = []
    for lang, d in (('en', draft['en']), ('hi', draft)):
        for name, part in sections(d):
            try:
                ok, why, prov, model = P.fact_check_app(part)
            except Exception as e:      # provider down / budget: recorded as inconclusive, never as a pass
                ok, why, prov, model = None, f'error: {type(e).__name__}: {str(e)[:200]}', 'openrouter', P.or_model
            app_fact.append({'lang': lang, 'section': name, 'correct': ok, 'reason': why, 'provider': prov, 'model': model})
            print(lang, name, ok, (why or '')[:160], flush=True)
    probs = list(chk['problems'])
    probs += [f"app fact check {x['lang']}/{x['section']}: " + ('inconclusive' if x['correct'] is None else 'failed') + f": {x['reason']}"
              for x in app_fact if x['correct'] is not True]
    res = {'state': state, 'problems': probs, 'warnings': chk.get('warnings', []), 'blind': chk['blind'], 'numericals': chk['numericals'],
           'fact_check_notes': chk['fact_check'], 'app_fact_check': app_fact, 'copyright': chk['copyright'], 'terms': chk['terms'],
           'calls': getattr(P, 'n_calls', None), 'max_calls': getattr(P, 'max_calls', None), 'or_model': P.or_model,
           'attribution': [a for a in job.d.get('attribution', []) if a.get('stage') == 'checks']}
    json.dump(res, open(os.path.join(out, 'verify_result.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print('PROBLEMS', len(probs)); [print(' -', p[:300]) for p in probs]
    print('calls', res['calls'])


if __name__ == '__main__':
    main(*sys.argv[1:5])
