import json, copy, re, sys
sys.path.insert(0, '.')
from content import NOTES, TEACH, BEATS, NEW_FORMULAS, FORMULA_UNITS, NEW_MISTAKES, NEW_REVISION, NEW_PRACTICE
old = json.load(open('/home/claude/backup/electricity_880_row72_before.json'))['data']
FIG = json.load(open('figs.json'))

def lang(i):  # 0 = hi, 1 = en
    lg = 'hi' if i == 0 else 'en'
    notes = []
    for n in NOTES:
        it = {'title': n['title'][i], 'points': [p[i] for p in n['points']]}
        if n.get('table'): it['table'] = [[c[i] for c in row] for row in n['table']]
        if n.get('fig'): it['fig'] = FIG[lg][n['fig']]
        notes.append(it)
    teach = []
    for t in TEACH:
        it = {'heading': t['heading'][i], 'explain': t['explain'][i], 'example': t['example'][i]}
        if t.get('fig'): it['fig'] = FIG[lg][t['fig']]
        teach.append(it)
    beats = [{'question': q[i], 'steps': [s[i] for s in st], 'answer': a[i]} for q, st, a in BEATS]
    src = old if i == 0 else old['en']
    formulas = []
    for f, (u, nt) in zip(src['formulas'], FORMULA_UNITS):
        g = dict(f); g['units'] = u[i]; g['note'] = nt[i]; formulas.append(g)
    formulas += [{'title': t[i], 'formula': fm, 'units': u[i], 'note': nt[i]} for t, fm, u, nt in NEW_FORMULAS]
    return {
        'notes': notes, 'teach': teach,
        'solved': beats + copy.deepcopy(src['solved']),
        'formulas': formulas,
        'mistakes': copy.deepcopy(src['mistakes']) + [m[i] for m in NEW_MISTAKES],
        'revision': copy.deepcopy(src['revision']) + [r[i] for r in NEW_REVISION],
        'practice': copy.deepcopy(src['practice']) + [{'q': q[i], 'options': [o[i] for o in opts], 'answer': a, 'explanation': e[i]} for q, opts, a, e in NEW_PRACTICE],
    }

hi, en = lang(0), lang(1)
new = dict(hi)
new['id'] = old['id']
new['en'] = en
new['demo'] = {'title': ['विद्युत लैब: 10 इंटरैक्टिव चित्र', 'Electricity lab: 10 interactive figures'], 'html': open('lab.html', encoding='utf-8').read()}
new['source'] = dict(old['source'])
new['source']['revision'] = ('2026-11-07 v2 content redesign (owner request): systematic notes with exam-line definitions, '
    '13 teach lessons with hook questions, 10 predict-first step cards, 5 formulas, 5 mistakes, 3 revision lines, 8 practice MCQs added; '
    'all earlier solved/practice/mistakes/revision kept; earlier notes/teach/demo kept in mtb.chapter_draft_versions. '
    'Design blueprint from DeepSeek (OpenRouter, 4 rounds), text written and checked by Claude. fig fields need renderer support.')
json.dump(new, open('new_data.json', 'w'), ensure_ascii=False)
print({k: (len(v) if isinstance(v, (list, dict, str)) else v) for k, v in new.items()})
print('bytes', len(json.dumps(new, ensure_ascii=False).encode()))
