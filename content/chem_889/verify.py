import re, sys
sys.path.insert(0, '.')
import content_889 as C
from balance import balanced
F = r'(?:\d*(?:[A-Z][a-z]?|\()[A-Za-z0-9₀-₉()·]*(?:\((?:s|l|g|aq)\))?)'
EQ = re.compile(rf'({F}(?:\s*\+\s*{F})*\s*→\s*{F}(?:\s*\+\s*(?:{F}|ऊष्मा|ऊर्जा|heat|energy))*)')
texts = []
def walk(x):
    if isinstance(x, str): texts.append(x)
    elif isinstance(x, (list, tuple)):
        for y in x: walk(y)
    elif isinstance(x, dict):
        for y in x.values(): walk(y)
for name in ('NOTES', 'TEACH', 'HINGLISH', 'BOOK', 'SOLVED', 'PRACTICE', 'EQUATIONS', 'MISTAKES', 'REVISION'): walk(getattr(C, name))
seen, bad = set(), []
skip_words = ('Mg + O₂ → MgO', 'Fe + H₂O → Fe₃O₄ + H₂', 'H₂ + Cl₂ → HCl', 'BaCl₂ + Al₂(SO₄)₃ → BaSO₄ + AlCl₃', 'KClO₃ → KCl + O₂', 'N₂ + H₂ → NH₃',
              'C₃H₈ + O₂ → CO₂ + H₂O', 'Pb(NO₃)₂ → PbO + NO₂ + O₂', 'Mg + O₂ → 2MgO', '2Mg + 2O₂ → MgO', 'BaSO₄ + xAlCl₃')
for t in texts:
    for m in EQ.finditer(t):
        e = m.group(1).strip().rstrip('।.,;:')
        e = e.lstrip('(')
        if e.count('(') < e.count(')'): e = e[:-1]
        e = re.sub(r'BaSO₄↓', 'BaSO₄', e)
        if e in seen: continue
        seen.add(e)
        if any(e.endswith(s) or e == s for s in skip_words) or 'x' in e: continue
        try:
            ok = balanced(e)[0]
        except Exception as ex:
            ok = f'parse error {ex}'
        if ok is not True: bad.append((e, ok))
print('equations checked', len(seen)); print('NOT balanced / errors:'); [print('  ', b) for b in bad]
