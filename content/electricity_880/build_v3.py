import json, re, sys, copy
sys.path.insert(0, '.')
from fix_v3 import SOLVED, PRACTICE, TEACH_END, HINGLISH
d = json.load(open('/tmp/live880.json'))['data']; en = d['en']
new = copy.deepcopy(d)
nums = lambda s: set(re.findall(r'\d+(?:\.\d+)?', s.replace('×10', ' 10')))
for i, (sh, se, ah, ae) in SOLVED.items():
    assert len(new['solved'][i]['steps']) == 1 and len(new['en']['solved'][i]['steps']) == 1, i
    qh, qe = new['solved'][i]['question'], new['en']['solved'][i]['question']
    assert nums(qh) <= nums(qe) | {'2', '1', '10'} or not nums(qh), (i, qh[:60], qe[:60])
    new['solved'][i]['steps'], new['solved'][i]['answer'] = sh, ah
    new['en']['solved'][i]['steps'], new['en']['solved'][i]['answer'] = se, ae
for i, (eh, ee) in PRACTICE.items():
    new['practice'][i]['explanation'] = eh; new['en']['practice'][i]['explanation'] = ee
for t in TEACH_END:
    new['teach'].append({'heading': t['heading'][0], 'explain': t['explain'][0], 'example': t['example'][0]})
    new['en']['teach'].append({'heading': t['heading'][1], 'explain': t['explain'][1], 'example': t['example'][1]})
figs = [t.get('fig') for t in new['teach']]
new['hinglish'] = {'teach': [dict({'heading': h, 'explain': x, 'example': e}, **({'fig': figs[k]} if figs[k] else {})) for k, (h, x, e) in enumerate(HINGLISH)]}
assert len(new['hinglish']['teach']) == len(new['teach']) == len(new['en']['teach'])
new['source']['revision_v3'] = ('2026-11-07 v3 (audit fixes): 37 one-step solved items given full steps (hi+en), 12 practice '
    'explanations rewritten, Exam Tips + Quick Check teach sections, Hinglish teach set (15 sections) in data.hinglish.')
unit_frac = re.compile(r'(\d+(?:\.\d+)?)\s*(V|A|Ω|J|W|C|s)\s*/\s*(\d+(?:\.\d+)?)\s*(V|A|Ω|J|W|C|s)')
fixed = 0
for blk in (new, new['en']):
    for s_ in blk['solved']:
        for k, x in enumerate(s_['steps']):
            y = unit_frac.sub(r'\1 \2 ÷ \3 \4', x)
            if y != x: s_['steps'][k] = y; fixed += 1
print('unit-over-unit steps rewritten as ÷:', fixed)
json.dump(new, open('v3_data.json', 'w'), ensure_ascii=False)
st = [len(s['steps']) for s in new['solved']]
print('one-step solved left', st.count(1), '| weak practice left', sum(len(p['explanation']) < 25 for p in new['practice']), '| teach', len(new['teach']), '| hinglish', len(new['hinglish']['teach']))
