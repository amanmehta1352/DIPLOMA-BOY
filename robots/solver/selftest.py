"""Offline self-test for the solver checks (no network)."""
import copy, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from checks import check_item, scan_html
B = lambda e, h: {'en': e, 'hi': h}
step = lambda h: {'en': 'Step.', 'hi': 'कदम।', 'html': h}
good = {
  'topic': {'key': 'election', **B('Election', 'चुनाव')}, 'type': {'key': 'two', **B('2 Candidates', '2 उम्मीदवार')},
  'difficulty': 1, 'q': B('Winner gets 60% and wins by 1200 votes. Total?', 'विजेता को 60% मिले, 1200 से जीता। कुल?'),
  'viz': {'kind': 'pie', 'parts': [{**B('Winner', 'विजेता'), 'pct': 60}, {**B('Loser', 'हारा'), 'pct': 40}]},
  'methods': [
    {'key': 'base100', 'primary': True, 'name': B('Base-100 (Universal)', 'Base-100'),
     'steps': [step('<div class="arr">➔</div> Diff = <span class="rough-line">20%</span>'),
               dict(step('<div class="arr">➔</div> 100% = <span class="rough-circle">6000</span>'), trap=B('⚠️ x', '⚠️ y'))],
     'answer': {**B('6000 votes', '6000 वोट'), 'value': 6000, 'unit': 'votes'}},
    {'key': 'fraction', 'primary': True, 'name': B('Fraction (Fast)', 'भिन्न'),
     'steps': [step('<div class="bar-container"><div class="bar-row"><div class="bar bar-exp" style="width:60%">60</div><div class="bar bar-sav" style="width:40%">40</div></div></div>'),
               step('<div class="arr">➔</div> 5 × 1200 = <span class="rough-circle">6000</span>')],
     'answer': {**B('6000 votes', '6000 वोट'), 'value': '6,000', 'unit': 'votes'}}],
  'quiz': {'q': B('Margin depends on?', 'अंतर किस पर?'), 'options': [B('a', 'क'), B('b', 'ख'), B('c', 'ग')], 'answer': 1, 'explain': B('e', 'ए')},
  'formulas': [B('x% of y', 'y का x%')]}
assert check_item(good) == [], check_item(good)
def bad(fn, word, units=False):
    d = copy.deepcopy(good); fn(d); p = check_item(d, units); assert any(word in x for x in p), (word, p)
bad(lambda d: d['methods'].pop(), 'at least 2')
bad(lambda d: d['methods'][1]['answer'].update(value=5000), 'different answers')
bad(lambda d: d['methods'][0]['steps'][0].update(html='<img src=x onerror=alert(1)>'), 'tag <img>')
bad(lambda d: d['methods'][0]['steps'][0].update(html='<span class="x" onclick="a()">1</span>'), 'attribute onclick')
bad(lambda d: d['methods'][1]['steps'][0].update(html='<div class="bar-row"><div class="bar" style="width:80%">a</div><div class="bar" style="width:40%">b</div></div>'), 'add up')
bad(lambda d: d['methods'][0]['steps'][1].update(html='<div class="arr">➔</div> 6000'), 'circle')
bad(lambda d: d['q'].update(hi=''), 'q: needs')
bad(lambda d: d['quiz'].update(answer=5), 'quiz')
bad(lambda d: None, 'bold', units=True)
bad(lambda d: d['methods'][0]['steps'][0].update(html='<span style="color:red">x</span>'), 'style')
assert scan_html('<span class="frac"><span class="num">1</span><span class="den">5</span></span>').bad == []
print('solver selftest ok')
