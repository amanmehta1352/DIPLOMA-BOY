"""Offline self-test for the writer's checks (no network)."""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import writer as w
good = {'id': 'DB|x|1',
  'notes': [{'title': f'विषय {i}', 'points': ['बिंदु एक ' * 30, 'बिंदु दो ' * 30]} for i in range(6)],
  'teach': [{'heading': f'पाठ {i}', 'explain': 'समझाओ ' * 200, 'example': 'समझो ऐसे'} for i in range(4)],
  'formulas': [{'title': f'सूत्र {i}', 'formula': 'v = s/t', 'units': 'm/s', 'note': ''} for i in range(6)],
  'solved': [{'question': 'सवाल', 'steps': ['a', 'b'], 'answer': '5 m/s'} for i in range(3)],
  'practice': [{'q': f'q{i}', 'options': ['1', '2', '3', '4'], 'answer': i % 4, 'explanation': f'माना x = {i % 4 + 1}\nअतः उत्तर = {i % 4 + 1}'} for i in range(10)],
  'mistakes': ['a', 'b', 'c'], 'revision': list('abcdef')}
assert w.check_structure(good, 'DB|x|1') == [], w.check_structure(good, 'DB|x|1')
bad = dict(good, practice=good['practice'][:9]); assert any('practice' in p for p in w.check_structure(bad, 'DB|x|1'))
bad = dict(good, id='DB|x|2'); assert any('id' in p for p in w.check_structure(bad, 'DB|x|1'))
bad = dict(good, revision=['<div>x</div>'] * 6); assert any('HTML' in p for p in w.check_structure(bad, 'DB|x|1'))
bad = dict(good, practice=[dict(q, answer=4) for q in good['practice']]); assert any('answer 0-3' in p for p in w.check_structure(bad, 'DB|x|1'))
assert w.parse_json('```json\n{"a": 1}\n```') == {'a': 1}
t = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'prompt.txt'), encoding='utf-8').read()
assert '{l}' in t and '${' not in t
import copy
sh = w.shuffle_options(copy.deepcopy(good), 'DB|x|1')
assert all(q['options'][q['answer']] == o['options'][o['answer']] for q, o in zip(sh['practice'], good['practice']))
assert len({q['answer'] for q in sh['practice']}) > 1
bad = copy.deepcopy(good); bad['practice'][0]['explanation'] = 'अतः उत्तर = 9'
assert any('right option' in p for p in w.check_structure(bad, 'DB|x|1'))
bad = copy.deepcopy(good); bad['practice'][0]['explanation'] += ' 2 * 3'
assert any('×' in p for p in w.check_structure(bad, 'DB|x|1'))
print('writer selftest ok')
import writer as WW
assert WW.hindi_ok({'notes': [{'title': 'वेग', 'points': ['वेग (velocity) एक सदिश राशि है।']}]})
assert not WW.hindi_ok({'notes': [{'title': 'Velocity', 'points': ['Velocity is a vector quantity.']}]})
print('hindi check selftest ok')
assert not WW.hindi_ok({'notes': [{'title': 'वेग', 'points': ['वेग']}], 'practice': [{'q': 'What is the speed of light in vacuum in metres per second?', 'explanation': 'The speed of light is three hundred million metres per second in vacuum.'}]})
print('hindi practice selftest ok')
