import json, sys, copy
sys.path.insert(0, '.')
from book_v4 import BOOK, NOTE_STYLE, CATS, FORMULA_CAT
d = json.load(open('v3_data.json')); new = copy.deepcopy(d)
FIG = json.load(open('figs.json'))
for li, blk in ((0, new), (1, new['en'])):
    lg = 'hi' if li == 0 else 'en'
    blk['book'] = []
    for title, paras, box, fig in BOOK:
        it = {'title': title[li], 'paras': [p[li] for p in paras]}
        if box: it['box'] = box[li]
        if fig: it['fig'] = FIG[lg][fig]
        blk['book'].append(it)
    assert len(blk['notes']) == len(NOTE_STYLE)
    for n, (col, ic) in zip(blk['notes'], NOTE_STYLE): n['color'], n['icon'] = col, ic
    assert len(blk['formulas']) == len(FORMULA_CAT)
    for f, c in zip(blk['formulas'], FORMULA_CAT):
        f['cat'] = c; f['formula'] = f['formula'].replace('rho', 'ρ')
new['formula_cats'] = {k: {'label': v[0], 'color': v[1]} for k, v in CATS.items()}
new['source']['revision_v4'] = '2026-11-07 v4: prose book chapter (12 sections, hi+en), notes panel colours/icons, formula categories.'
json.dump(new, open('v4_data.json', 'w'), ensure_ascii=False)
print('book', len(new['book']), len(new['en']['book']), 'bytes', len(json.dumps(new, ensure_ascii=False).encode()))
