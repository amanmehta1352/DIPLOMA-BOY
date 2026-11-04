"""Code verifier tests (no AI, no network)."""
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import numcheck as N
R = []
def case(n, f):
    try: f(); R.append((n, True, ''))
    except AssertionError as e: R.append((n, False, str(e)))
    except Exception as e: R.append((n, False, f'{type(e).__name__}: {e}'))
g = lambda s, v, u: {'symbol': s, 'value': v, 'unit': u}
def t1():
    ok, d = N.verify({'givens': [g('V', 12, 'V'), g('R', 4, 'Ω')], 'formulas': ['ohm'], 'unknown': 'I', 'answer': {'value': 3, 'unit': 'A'}}); assert ok is True, d
def t2():
    ok, d = N.verify({'givens': [g('V', 12, 'V'), g('R', 4, 'ohm')], 'formulas': ['ohm'], 'unknown': 'I', 'answer': {'value': 48, 'unit': 'A'}}); assert ok is False and '3' in d, d
def t3():   # unit conversion: 500 mA through 2 kΩ -> 1000 V
    ok, d = N.verify({'givens': [g('I', 500, 'mA'), g('R', 2, 'kΩ')], 'formulas': ['ohm'], 'unknown': 'V', 'answer': {'value': 1, 'unit': 'kV'}}); assert ok is True, d
def t4():   # wrong dimension in answer (ohm stated for power)
    ok, d = N.verify({'givens': [g('V', 220, 'V'), g('I', 5, 'A')], 'formulas': ['power_vi'], 'unknown': 'P', 'answer': {'value': 1100, 'unit': 'ohm'}}); assert ok is None and 'not a watt' in d, d
def t5():   # two steps: parallel then Ohm
    ok, d = N.verify({'givens': [g('R1', 6, 'Ω'), g('R2', 3, 'Ω'), g('V', 6, 'V')], 'formulas': ['parallel2', {'id': 'ohm', 'map': {'R': 'Rp'}}], 'unknown': 'I', 'answer': {'value': 3, 'unit': 'A'}}); assert ok is True, d
    assert N.verify({'givens': [g('R1', 6, 'Ω'), g('R2', 3, 'Ω'), g('V', 6, 'V')], 'formulas': ['parallel2', {'id': 'ohm', 'map': {'R': 'Rp'}}], 'unknown': 'I', 'answer': {'value': 0.67, 'unit': 'A'}})[0] is False  # used series by mistake
def t6():   # formula not in registry / missing givens -> not verifiable (never passes silently)
    assert N.verify({'givens': [g('V', 1, 'V')], 'formulas': ['magic'], 'unknown': 'I', 'answer': {'value': 1, 'unit': 'A'}})[0] is None
    assert N.verify({'givens': [g('V', 1, 'V')], 'formulas': ['ohm'], 'unknown': 'I', 'answer': {'value': 1, 'unit': 'A'}})[0] is None
    assert N.verify(None)[0] is None
def t7():   # energy in kWh: 1000 W for 2 h = 2 kWh
    ok, d = N.verify({'givens': [g('P', 1000, 'W'), g('t', 2, 'h')], 'formulas': ['energy_pt'], 'unknown': 'E', 'answer': {'value': 2, 'unit': 'kWh'}}); assert ok is True, d
def t8():   # resistivity with area in mm^2
    ok, d = N.verify({'givens': [g('rho', 1.7e-8, 'Ω m'), g('L', 10, 'm'), g('A', 1, 'mm^2')], 'formulas': ['resistivity'], 'unknown': 'R', 'answer': {'value': 0.17, 'unit': 'Ω'}}); assert ok is True, d
def t9():   # numerical MCQ: key right, a distractor equal to the answer is caught, key on wrong option caught
    base = {'check': {'givens': [g('V', 12, 'V'), g('R', 4, 'Ω')], 'formulas': ['ohm'], 'unknown': 'I', 'answer': {'value': 3, 'unit': 'A'}}}
    assert N.mcq_options_ok({**base, 'options': [['48 A', '48 A'], ['3 A', '3 A'], ['0.33 A', '0.33 A'], ['16 A', '16 A']], 'answer_index': 1})[0] is True
    assert N.mcq_options_ok({**base, 'options': [['48 A', '48 A'], ['3 A', '3 A'], ['3.0 A', '3.0 A'], ['16 A', '16 A']], 'answer_index': 1})[0] is False
    assert N.mcq_options_ok({**base, 'options': [['48 A', '48 A'], ['3 A', '3 A'], ['0.33 A', '0.33 A'], ['16 A', '16 A']], 'answer_index': 0})[0] is False
def t10():   # options carry their own unit (kWh) while the check answer is in J: still verifiable
    c = {'givens': [g('P', 1000, 'W'), g('t', 216000, 's')], 'formulas': ['energy_pt'], 'unknown': 'E', 'answer': {'value': 216000000, 'unit': 'J'}}
    o = lambda *xs: [[x, x] for x in xs]
    assert N.mcq_options_ok({'check': c, 'options': o('60 kWh', '30 kWh', '120 kWh', '2000 kWh'), 'answer_index': 0})[0] is True
    assert N.mcq_options_ok({'check': c, 'options': o('60 kWh', '30 kWh', '120 kWh', '2000 kWh'), 'answer_index': 1})[0] is False
    assert N.mcq_options_ok({'check': c, 'options': o('60 kWh', '216000000 J', '120 kWh', '2000 kWh'), 'answer_index': 0})[0] is False   # same energy written in J
    d = {'givens': [g('V', 12, 'V'), g('R', 4, 'Ω')], 'formulas': ['ohm'], 'unknown': 'I', 'answer': {'value': 3, 'unit': 'A'}}
    assert N.mcq_options_ok({'check': d, 'options': o('3000 mA', '48 A', '0.33 A', '16 A'), 'answer_index': 0})[0] is True
    assert N.mcq_options_ok({'check': d, 'options': o('3 × 10^0 A', '48 A', '0.33 A', '16 A'), 'answer_index': 0})[0] is True
for i, f in enumerate([t1, t2, t3, t4, t5, t6, t7, t8, t9, t10], 1): case(f'N{i} {f.__name__}', f)
for n, ok, w in R: print(('PASS ' if ok else 'FAIL ') + n + ('' if ok else ' -> ' + w))
print(f'{sum(o for _, o, _ in R)}/{len(R)} passed')
