"""Fast self-test (no PDF, no network): path-independent logic of the import robot."""
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import sscsheet as S, hindi as H

# identity of a question ignores option order, quote/dash style and spacing, but not symbols
a = S.qkey("If ‘+’ means ‘–’ what is 8 ÷ 2?", ['1', '2', '3', '4'])
b = S.qkey("If '+' means '-' what is 8÷2 ?", ['4', '3', '2', '1'])
assert a == b, 'qkey must ignore option order and quote style'
assert S.qkey('x', ['÷ +', '+ ÷', '× ÷', '÷ ×']) != S.qkey('x', ['+ +', '+ ÷', '× ÷', '÷ ×']), 'symbol options must not collapse'

# channel watermarks are not question content
t = S.URL_INLINE.sub('', 'R RankMitra - https://t.me/abc and www.prepp.in more')
assert 'RankMitra' not in t and 'prepp' not in t and 'R' in t and 'more' in t

# OCR text -> stem + 4 options
o = H.parse_ocr('Q.5 एक प्रश्न 8 + 2\n1. आ 10\n2. ब 12\n3. स 14\n4. द 16')
assert o['text'] == 'एक प्रश्न 8 + 2' and o['opts'] == ['आ 10', 'ब 12', 'स 14', 'द 16'], o
assert H.ocr_ok(o)
o2 = H.parse_ocr('Q.2 एक कूट भाषा 8 + 2\nAns .6\n2. ब 12\n3. स 14\n4. द 16')
assert o2['text'] == 'एक कूट भाषा 8 + 2' and o2['opts'][0] == '6' and o2['opts'][3] == 'द 16', o2
assert H.stem_valid('एक कूट LESSON 10', 'In a code LESSON is 10') and not H.stem_valid('एक कूट शछरशा 10', 'In a code LESSON is 10')

# pairing: numbers/maths inside the Hindi question must sit inside the English one, and the right answer must agree
en = [{'text': 'If + means - then 153 × 9 - 5 + 32 ÷ 90 = ?', 'opts': ['143', '155', '150', '160'], 'ans': 0},
      {'text': 'A pump of 30 kW lifts water 12 m', 'opts': ['a', 'b', 'c', 'd'], 'ans': 1}]
hi = [{'text': 'यदि + का अर्थ - है तो 153×9-5+32÷90= ?', 'opts': ['160', '150', '155', '143'], 'ans': 3}]
pr = H.pair(hi, en)
assert pr == {0: (0, [3, 2, 1, 0])}, pr
hi_bad = [{'text': 'यदि + का अर्थ - है तो 153×9-5+32÷90= ?', 'opts': ['160', '150', '155', '143'], 'ans': 0}]   # answer disagrees
assert H.pair(hi_bad, en) == {}
import paper as P
assert not P.ocr_clean('शंकु Ferd के स्थिर (a) घटता', 'cone clutch semi-cone angle (α) decreases', '')
assert P.ocr_clean('ऊर्जा POLISH को 89', 'In a code POLISH is 89', '')
assert not P.ocr_clean('QT का चक्रीय', 'The cyclic integral of Q/T', '')
import robot as R
assert R.clean_body({'a': ['x\u0000y', {'b': 'p\x07q\nr'}], 'n': 3}) == {'a': ['xy', {'b': 'pq\nr'}], 'n': 3}, 'NUL/control chars must be stripped before a DB write'
import ast, inspect, importer as I
assert "ex['id'] is None" in inspect.getsource(I.run), 'a repeated question inside one paper must not PATCH id=None'
import publish as PB
_q = {'answer': 1, 'options': [{'en': 'a', 'hi': 'अ'}] * 4, 'stem': {'en': 'x', 'hi': 'य', 'hi_mt': True, 'checks': {'hindi': 'OCR noise'}}}
assert PB.check(_q) == [], 'machine Hindi that replaced a rejected OCR read must pass'
_q['stem']['hi_mt'] = False
assert PB.check(_q) == ['hindi-check'], 'flagged official Hindi must be held'
# superscripts: small raised glyphs hanging on a full-size glyph become script characters; ordinals and labels stay
class _Pg:
    def __init__(self, cs): self.chars = cs
def _ch(t, x0, size=8.8, top=117.0):
    w = 4.8 if size > 8 else 3.7
    return {'text': t, 'x0': x0, 'x1': x0 + w, 'top': top, 'bottom': top + size, 'size': size, 'doctop': top}
cs = [_ch('4', 10), _ch('7', 14.8), _ch('−', 19.6, 7.3, 114.5), _ch('1', 23.3, 7.3, 114.5), _ch('1', 27.0, 7.3, 114.5),
      _ch('2', 60), _ch('t', 64.8, 7.3, 114.5), _ch('h', 68.5, 7.3, 114.5),
      _ch('H', 100), _ch('2', 104.8, 7.3, 119.8), _ch('O', 108.5)]
S.mark_scripts(_Pg(cs))
assert ''.join(c['text'] for c in cs) == '47⁻¹¹2thH₂O', ''.join(c['text'] for c in cs)
print('selftest ok')
