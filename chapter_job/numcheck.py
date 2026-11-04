"""Step 11 code verification of numericals (no AI): units with pint, algebra with sympy, formulas only from path/formulas/*.json.

A numerical carries a structured check written by the AI:
  {"givens": [{"symbol": "V", "value": 12, "unit": "V"}], "formulas": ["ohm"], "unknown": "I", "answer": {"value": 3, "unit": "A"}}
  several steps are linked with a map: "formulas": ["parallel2", {"id": "ohm", "map": {"R": "Rp"}}]
verify(check) -> (ok, detail). ok is True / False / None (None = could not be verified by code; treated as a problem upstream)."""
import json, os, re
import sympy as sp, pint
HERE = os.path.dirname(os.path.abspath(__file__))
U = pint.UnitRegistry(); U.define('kWh_unit = kilowatt * hour')
TOL = 0.01


def load(name='science'):
    return json.load(open(os.path.join(HERE, 'path', 'formulas', f'{name}.json'), encoding='utf-8'))


def unit_of(text):
    s = str(text or '').strip()
    if s in ('', '-', 'none', 'dimensionless'): return U.dimensionless
    s = (s.replace('Ω', 'ohm').replace('µ', 'u').replace('μ', 'u').replace('²', '**2').replace('³', '**3').replace('·', '*')
          .replace('kWh', 'kilowatt*hour').replace('^', '**'))
    s = re.sub(r'\bohm\s+m\b', 'ohm*meter', s); s = re.sub(r'\bohm\s+cm\b', 'ohm*centimeter', s)
    s = re.sub(r'\bk\s*ohm\b', 'kiloohm', s); s = re.sub(r'\bM\s*ohm\b', 'megaohm', s)
    s = re.sub(r'\b(sec|secs|s)\b', 'second', s); s = re.sub(r'\bmin\b', 'minute', s); s = re.sub(r'\b(hr|hrs|h)\b', 'hour', s)
    return U.parse_units(s) if s else U.dimensionless


def to_si(value, unit, symbol, reg):
    q = U.Quantity(float(value), unit_of(unit)); target = U.parse_units(reg['symbols'][symbol])
    if q.dimensionality != (1 * target).dimensionality:
        raise ValueError(f'{symbol}: unit "{unit}" is not a {reg["symbols"][symbol]}')
    return q.to(target).magnitude


def parse_given(g):
    """Run 13: a writer gave givens as text "V1 = 10 V" / "ρ = 1.68 × 10^-8 Ω·m". Parsed into {symbol, value, unit}; the code still verifies all of it."""
    if isinstance(g, dict) or not isinstance(g, str): return g
    m = re.match(r'\s*([A-Za-zρ][A-Za-z0-9₀-₉]*)\s*=\s*(-?\d+(?:\.\d+)?)\s*(?:[x×]\s*10\s*(?:\^\s*\(?\s*([-−]?\d+)\)?|([⁻−]?[⁰¹²³⁴⁵⁶⁷⁸⁹]+)))?\s*(.*?)\s*$', g)
    if not m: raise ValueError(f'given {g!r} is not "symbol = value unit"')
    sym = m.group(1).replace('ρ', 'rho').translate(str.maketrans('₀₁₂₃₄₅₆₇₈₉', '0123456789'))
    v = float(m.group(2)) * (10 ** int((m.group(3) or m.group(4) or '0').translate(SUP)))
    return {'symbol': sym, 'value': v, 'unit': m.group(5) or ''}


def solve(check, reg=None):
    """Returns the code's value of the unknown in its SI unit (float). Raises ValueError with a reason."""
    reg = reg or load(); F = reg['formulas']
    items = [f if isinstance(f, dict) else {'id': f} for f in (check.get('formulas') or [])]
    ids = [f.get('id') for f in items]
    if not ids: raise ValueError('no formula ids')
    bad = [f for f in ids if f not in F]
    if bad: raise ValueError('formula ids not in registry: ' + ', '.join(bad))
    unk = check.get('unknown')
    if unk not in reg['symbols']: raise ValueError(f'unknown symbol {unk!r} not in registry')
    syms = {s: sp.Symbol(s, positive=True) for s in reg['symbols']}
    eqs = []
    for f in items:     # {"id": "ohm", "map": {"R": "Rp"}} links steps: the R of Ohm's law is the Rp found by the previous formula
        l, r = F[f['id']]['expr'].split('=')
        e = sp.Eq(sp.sympify(l, locals=syms), sp.sympify(r, locals=syms))
        m = f.get('map') or {}
        for a, b in m.items():
            if a not in syms or b not in syms or reg['symbols'][a] != reg['symbols'][b]: raise ValueError(f'bad map {a}->{b}')
        eqs.append(e.subs({syms[a]: syms[b] for a, b in m.items()}, simultaneous=True))
    vals = {}
    check = {**check, 'givens': [parse_given(g) for g in check.get('givens') or []]}
    for g in check.get('givens') or []:
        if g.get('symbol') not in reg['symbols']: raise ValueError(f"given symbol {g.get('symbol')!r} not in registry")
        vals[syms[g['symbol']]] = sp.nsimplify(to_si(g['value'], g.get('unit'), g['symbol'], reg))
    eqs = [e.subs(vals) for e in eqs]
    free = set().union(*[e.free_symbols for e in eqs]) if eqs else set()
    if syms[unk] not in free: raise ValueError('unknown does not appear in the formulas')
    sol = sp.solve(eqs, list(free), dict=True)
    got = sorted({float(s[syms[unk]]) for s in sol if syms[unk] in s and s[syms[unk]].is_number})
    if len(got) != 1: raise ValueError(f'formulas do not fix the unknown ({len(got)} solutions; missing givens?)')
    return got[0]


def close(a, b, tol=TOL): return abs(a - b) <= tol * max(abs(a), abs(b), 1e-12)


def verify(check, reg=None):
    reg = reg or load()
    if not isinstance(check, dict): return None, 'no structured check'
    picked = ''
    try:
        try:
            exp = solve(check, reg)
        except ValueError as e1:
            exp, picked = pick_formula(check, reg, e1)
        a = check.get('answer') or {}
        got = to_si(a.get('value'), a.get('unit'), check['unknown'], reg)
    except (ValueError, TypeError, AttributeError, KeyError, IndexError, pint.errors.PintError, sp.SympifyError) as e:
        return None, f'not verifiable: {e}'[:200]
    if close(exp, got): return True, f'code {exp:.6g} = stated {got:.6g} {reg["symbols"][check["unknown"]]}' + (f' (formula chosen by code: {picked})' if picked else '')
    return False, f'code gives {exp:.6g} {reg["symbols"][check["unknown"]]}, stated answer is {got:.6g}'


def pick_formula(check, reg, err):
    """The writer named a formula that does not fit its own givens (e.g. "ohm" for a V-I graph slope). Code then tries every registry
    formula whose symbols are exactly covered by the givens + unknown. Accepted only if every fitting formula gives the same value."""
    F = reg['formulas']; unk = check.get('unknown'); have = {g.get('symbol') for g in check.get('givens') or []}
    if unk not in reg['symbols'] or not have <= set(reg['symbols']): raise err
    fits = []
    for fid, f in F.items():
        used = set(re.findall(r'[A-Za-z_][A-Za-z_0-9]*', f['expr'])) & set(reg['symbols'])
        if unk in used and used - {unk} and used - {unk} <= have:
            try: fits.append((fid, solve({**check, 'formulas': [fid]}, reg)))
            except ValueError: pass
    if not fits or any(not close(v, fits[0][1]) for _, v in fits): raise err
    return fits[0][1], ','.join(fid for fid, _ in fits)


SUP = str.maketrans('⁰¹²³⁴⁵⁶⁷⁸⁹⁻−', '0123456789--')


def givens_in_text(check, text):
    """Every given value of the code check appears in the question text (directly or as a common unit conversion),
    so the code solved the question that was actually asked."""
    t = str(text).replace(',', ''); nums = []
    sci = r'(\d+(?:\.\d+)?)\s*[x×*]\s*10\s*(?:\^\s*\(?\s*([-−]?\d+)\)?|([⁻−]?[⁰¹²³⁴⁵⁶⁷⁸⁹]+))'
    for a, e1, e2 in re.findall(sci, t): nums.append(float(a) * 10 ** int((e1 or e2).translate(SUP)))
    nums += [float(x) for x in re.findall(r'\d+(?:\.\d+)?', re.sub(sci, ' ', t))]     # unit powers (m²) are not numbers: \d does not match superscripts
    if not isinstance(check, dict) or not check.get('givens'): return False
    for g in check['givens']:
        try: v = float(parse_given(g).get('value'))
        except (TypeError, ValueError, AttributeError): return False
        if not any(close(n * k, v) for n in nums for k in (1, 60, 3600, 1000, 0.001, 0.01, 100, 1e-6)): return False
    return True


def option_value(text, default_unit, symbol, reg):
    """Number in an option, converted to SI. A unit written in the option ("60 kWh") wins over the check's answer unit."""
    t = str(text).replace(',', '')
    m = re.search(r'(-?\d+(?:\.\d+)?(?:[eE]-?\d+)?)\s*(?:[x×]\s*10\^?(-?\d+))?\s*([^\d\s][^\s]*(?:\s+[A-Za-zΩ][A-Za-z]*)?)?', t)
    if not m: raise ValueError(f'no number in option {text!r}')
    val = float(m.group(1)) * (10 ** int(m.group(2)) if m.group(2) else 1)
    unit = (m.group(3) or '').strip(' .,;)') or default_unit
    try:
        return to_si(val, unit, symbol, reg)
    except (ValueError, pint.errors.PintError):
        return to_si(val, default_unit, symbol, reg)


def mcq_options_ok(q, reg=None):
    """Numerical MCQ: the keyed option must equal the code value and no other option may."""
    reg = reg or load(); c = q.get('check') or {}
    try:
        exp = solve(c, reg); unit = (c.get('answer') or {}).get('unit')
        vals = [option_value(o[1], unit, c['unknown'], reg) for o in q['options']]
    except (ValueError, TypeError, IndexError, AttributeError, KeyError, pint.errors.PintError, sp.SympifyError) as e:
        return None, f'not verifiable: {e}'[:200]
    hits = [i for i, v in enumerate(vals) if close(v, exp)]
    if hits != [q.get('answer_index')]: return False, f'code value {exp:.6g} matches options {hits}, key is {q.get("answer_index")}'
    return True, 'key matches code; no distractor equals the answer'


def registry_prompt(reg=None):
    reg = reg or load()
    return ('Formula ids you may cite (symbol units are SI): ' + '; '.join(f"{k}: {v['expr']}" for k, v in reg['formulas'].items()) +
            '. To chain steps rename a symbol, e.g. "formulas": ["parallel2", {"id": "ohm", "map": {"R": "Rp"}}]. Symbols: ' + ', '.join(f'{k} [{v}]' for k, v in reg['symbols'].items()))
