"""Check that a chemical equation written with Unicode subscripts is balanced (atoms on both sides)."""
import re, collections
SUB = str.maketrans('₀₁₂₃₄₅₆₇₈₉', '0123456789')
def parse_formula(f):
    f = f.translate(SUB).replace('·', '.')
    f = re.sub(r'\((s|l|g|aq)\)', '', f).strip()
    parts = f.split('.'); total = collections.Counter()
    for p in parts:
        m = re.match(r'^(\d*)(.*)$', p); k = int(m.group(1) or 1); s = m.group(2)
        stack = [collections.Counter()]; i = 0
        while i < len(s):
            ch = s[i]
            if ch == '(':
                stack.append(collections.Counter()); i += 1
            elif ch == ')':
                i += 1; n = re.match(r'\d*', s[i:]).group(0); i += len(n)
                top = stack.pop()
                for e, c in top.items(): stack[-1][e] += c * int(n or 1)
            else:
                m2 = re.match(r'([A-Z][a-z]?)(\d*)', s[i:])
                if not m2: raise ValueError('bad formula ' + f)
                stack[-1][m2.group(1)] += int(m2.group(2) or 1); i += len(m2.group(0))
        for e, c in stack[0].items(): total[e] += c * k
    return total
def side(t):
    tot = collections.Counter()
    for term in [x.strip() for x in t.split(' + ') if x.strip() and x.strip().split()[0] not in ('ऊष्मा','ऊर्जा','heat','energy','प्रकाश','light','ऊष्मा)')]:
        m = re.match(r'^(\d+)\s*(.*)$', term); coef = int(m.group(1)) if m else 1; f = m.group(2) if m else term
        for e, c in parse_formula(f).items(): tot[e] += c * coef
    return tot
def balanced(eq):
    l, r = re.split(r'\s*(?:→|=)\s*', eq, maxsplit=1)
    return side(l) == side(r), side(l), side(r)
if __name__ == '__main__':
    for e in ['2Mg + O₂ → 2MgO', '2Pb(NO₃)₂ → 2PbO + 4NO₂ + O₂', '3BaCl₂ + Al₂(SO₄)₃ → 3BaSO₄ + 2AlCl₃', 'Fe + H₂O → Fe₃O₄ + H₂', 'CaO(s) + H₂O(l) → Ca(OH)₂(aq) + ऊष्मा']:
        print(e, balanced(e)[0])
