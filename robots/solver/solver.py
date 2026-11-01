"""Solver Robot: writes step-by-step solved questions (the owner's 'masterclass' format) with free Gemini,
checks them, and saves them as DRAFTS. Students only ever see items the owner approved.

   python3 robots/solver/solver.py --count 5 [--level govt_technical] [--chapter 1] [--dry-run]

Per chapter: 1) a plan (fit? topics + 5 question types), 2) one question per type.
Checks: robots/solver/checks.py (structure, both languages, HTML whitelist, same answer in every method, units)
plus a second Gemini model that solves the question without seeing the answer.
Env: GEMINI_API_KEY, SUPABASE_SECRET_KEY (never printed).
"""
import argparse, json, os, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'writer'))
sys.path.insert(0, HERE)
import writer as W          # gemini(), parse_json(), rpc(), hide(), keys
from checks import check_item, same

UNIT_SUBJECTS = ('physics', 'chemistry', 'engineering', 'electrical', 'mechanical', 'civil', 'electronics', 'science')
LEVEL_ORDER = W.LEVEL_ORDER
AUTO_OK = bool(json.load(open(os.path.join(HERE, '..', 'ecosystem', 'config.json'), encoding='utf-8')).get('auto_approve'))


def fill(tpl, **kv):
    for k, v in kv.items(): tpl = tpl.replace('{' + k + '}', str(v))
    return tpl


def need_units(c):
    return any(w in (c['se'] or '').lower() for w in UNIT_SUBJECTS)


SOLVER_CHECK_MODEL = os.environ.get('SOLVER_CHECK_MODEL', 'meta-llama/llama-3.3-70b-instruct')
SOLVER_CHECK_PROVIDER = {'order': ['Groq'], 'allow_fallbacks': True}   # Groq first (fast, Llama family); others if Groq is busy


def second_opinion(d):
    """A second model from a different family (Llama via OpenRouter, Groq first) solves the question and returns only the final answer.
    Without an OpenRouter key it falls back to Gemini, and such items are never auto-approved."""
    prompt = ('Solve this question carefully. Reply only with JSON {"value": <final answer as a plain number without unit '
              'or % sign, or a short text if not numeric>}.\n\nQuestion: ' + d['q']['en'])
    if W.ORKEY:
        txt, m = W.openrouter(prompt, SOLVER_CHECK_MODEL, SOLVER_CHECK_PROVIDER)
    else:
        txt, m = W.gemini(prompt, W.CHECK_MODELS, temperature=0)
    return W.parse_json(txt).get('value'), m


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--count', type=int, default=5, help='questions to write this run')
    ap.add_argument('--level', default='')
    ap.add_argument('--chapter', type=int, default=0)
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--redo', action='store_true', help='rewrite existing drafts of the chosen chapters (approved ones are kept)')
    ap.add_argument('--report', default='solver-report.md')
    a = ap.parse_args()
    if not W.GKEY: sys.exit('GEMINI_API_KEY missing')
    if not W.SB_KEY and not a.dry_run: sys.exit('SUPABASE_SECRET_KEY missing')

    chapters = json.load(open(os.path.join(HERE, '..', 'writer', 'chapters.json'), encoding='utf-8'))
    levels = {l['id']: l for l in json.load(open(os.path.join(HERE, '..', 'writer', 'levels.json'), encoding='utf-8'))}
    plan_tpl = open(os.path.join(HERE, 'plan_prompt.txt'), encoding='utf-8').read()
    item_tpl = open(os.path.join(HERE, 'item_prompt.txt'), encoding='utf-8').read()

    status = {}   # (level, chapter) -> {slot: (status, attempts)} ; presence = plan exists
    if W.SB_KEY:
        for r in W.rpc('solution_status'):
            status.setdefault((r['level_id'], r['chapter_id']), {})
            if r['slot'] is not None: status[(r['level_id'], r['chapter_id'])][r['slot']] = (r['status'], r['attempts'])

    order = {l: i for i, l in enumerate(LEVEL_ORDER)}
    todo = sorted([c for c in chapters if (not a.level or c['l'] == a.level) and (not a.chapter or c['c'] == a.chapter)],
                  key=lambda c: (order.get(c['l'], 99), c['c']))
    lines, written = ['# Solver robot report', ''], 0
    for c in todo:
        if written >= a.count: break
        L, key = levels[c['l']], (c['l'], c['c'])
        ctx = dict(level_en=L['en'], depth=L['depth'], subject_en=c['se'], subject_hi=c['s'], chapter_en=c['e'], chapter_hi=c['h'])
        # 1) plan
        plan = W.rpc('solution_plan_get', {'p_level': c['l'], 'p_chapter': c['c']}) if (W.SB_KEY and key in status) else None
        if plan is None:
            try:
                txt, pm = W.gemini(fill(plan_tpl, **ctx), W.WRITE_MODELS, temperature=0.3)
                plan = W.parse_json(txt)
                types = [t for tp in plan.get('topics', []) for t in tp.get('types', [])]
                if plan.get('fit') and len(types) != 5: raise ValueError(f'plan has {len(types)} types, want 5')
            except Exception as e:
                lines.append(f"- DB|{c['l']}|{c['c']} {c['h']}: plan failed: {W.hide(e)[:150]}"); print(lines[-1], flush=True); continue
            if not a.dry_run: W.rpc('solution_plan_save', {'p': {'level_id': c['l'], 'chapter_id': c['c'], 'plan': plan, 'model': pm}})
            lines.append(f"- DB|{c['l']}|{c['c']} {c['h']} ({c['s']}): plan fit={plan.get('fit')} · {plan.get('reason', '')[:80]}")
            print(lines[-1], flush=True); time.sleep(5)
        if not plan.get('fit'): continue
        slots = [(tp, t) for tp in plan['topics'] for t in tp['types']]
        done = status.get(key, {})
        previous = []
        for slot, (tp, t) in enumerate(slots, start=1):
            if written >= a.count: break
            st = done.get(slot)
            if st and (st[0] == 'approved' or (not a.redo and (st[0] == 'draft' or st[1] >= 3))): continue
            prompt = fill(item_tpl, **ctx, topic_key=tp['key'], topic_en=tp['en'], topic_hi=tp['hi'], type_key=t['key'],
                          type_en=t['en'], type_hi=t['hi'], difficulty=int(t.get('difficulty') or 2),
                          previous=json.dumps(previous, ensure_ascii=False) if previous else 'none')
            for attempt in range(2):
                res, checks, model, d = 'rejected', {}, None, None
                try:
                    txt, model = W.gemini(prompt, W.WRITE_MODELS)
                    d = W.parse_json(txt)
                    prob = check_item(d, need_units(c))
                    if not prob:
                        val, cm = second_opinion(d)
                        want = d['methods'][0]['answer']['value']
                        checks['second_opinion'] = {'model': cm, 'value': val, 'agree': same(val, want)}
                        if not same(val, want): prob.append(f'second opinion got {val!r}, methods say {want!r}')
                    checks['problems'] = prob
                    res = 'draft' if not prob else 'rejected'
                except Exception as e:
                    checks['error'] = W.hide(e)[:300]
                if res == 'draft': break
                time.sleep(8)
            written += 1
            if d and isinstance(d.get('q'), dict): previous.append(d['q'].get('en', '')[:120])
            note = '; '.join(checks.get('problems', [])) or checks.get('error', '') or 'all checks passed'
            lines.append(f"  - slot {slot} {t['en']}: **{res}** · {model} · {note[:200]}"); print(lines[-1], flush=True)
            if d is not None and not a.dry_run:
                W.rpc('solution_save', {'p': {'level_id': c['l'], 'chapter_id': c['c'], 'slot': slot, 'topic_key': tp['key'],
                                              'type_key': t['key'], 'difficulty': int(t.get('difficulty') or 2), 'status': res,
                                              'data': d, 'checks': checks, 'model': model}})
                if res == 'draft' and AUTO_OK and W.ORKEY:
                    r = W.rpc('solution_auto_approve', {'p_level': c['l'], 'p_chapter': c['c'], 'p_slot': slot})
                    lines[-1] += f' · auto: {r}'; print('    auto-approve:', r, flush=True)
            if a.dry_run and d is not None:
                os.makedirs('solver-out', exist_ok=True)
                json.dump(d, open(f"solver-out/{c['l']}_{c['c']}_{slot}.json", 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
            time.sleep(6)
    open(a.report, 'w', encoding='utf-8').write('\n'.join(lines) + '\n')


if __name__ == '__main__':
    main()
