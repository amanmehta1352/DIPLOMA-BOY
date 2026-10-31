"""Checks for one solved question (the owner's step-by-step 'masterclass' format). No network.
check_item(d, need_units) -> list of problems (empty = passed)."""
import re
from html.parser import HTMLParser

ALLOWED_TAGS = {'div', 'span', 'b', 'sub', 'sup', 'br'}
ALLOWED_CLASSES = {'arr', 'arr-down', 'rough-line', 'rough-circle', 'frac', 'num', 'den', 'rough-table',
                   'bar-container', 'bar-row', 'bar', 'bar-inc', 'bar-exp', 'bar-sav',
                   'venn-container', 'venn-circle', 'v-left', 'v-right', 'v-overlap', 'v-label-left', 'v-label-right'}
WIDTH = re.compile(r'^\s*width\s*:\s*(\d+(?:\.\d+)?)%\s*;?\s*$')


class _Html(HTMLParser):
    def __init__(self):
        super().__init__(); self.bad = []; self.rows = []; self.circles = 0; self.bold = 0; self.cur_row = None; self.depth = []

    def handle_starttag(self, tag, attrs):
        if tag not in ALLOWED_TAGS: self.bad.append(f'tag <{tag}>'); return
        cls = (dict(attrs).get('class') or '').split()
        for c in cls:
            if c not in ALLOWED_CLASSES: self.bad.append(f'class {c}')
        if 'bar-row' in cls: self.cur_row = []; self.rows.append(self.cur_row)
        for k, v in attrs:
            if k == 'class': continue
            if k == 'style':
                m = WIDTH.match(v or '')
                if not m or not any(c.startswith('bar') for c in cls): self.bad.append(f'style {v!r}')
                elif self.cur_row is not None and 'bar' in cls: self.cur_row.append(float(m.group(1)))
            else:
                self.bad.append(f'attribute {k}')
        if 'rough-circle' in cls: self.circles += 1
        if tag == 'b': self.bold += 1

    def handle_endtag(self, tag):
        pass


def scan_html(s):
    p = _Html()
    try:
        p.feed(s or ''); p.close()
    except Exception as e:
        p.bad.append(f'html error {e}')
    return p


def _bi(x):
    return isinstance(x, dict) and isinstance(x.get('en'), str) and x['en'].strip() and isinstance(x.get('hi'), str) and x['hi'].strip()


def _num(v):
    if isinstance(v, bool): return None
    if isinstance(v, (int, float)): return float(v)
    if isinstance(v, str):
        m = re.fullmatch(r'\s*-?\d+(?:\.\d+)?\s*', v.replace(',', ''))
        return float(v.replace(',', '')) if m else None
    return None


def same(a, b):
    x, y = _num(a), _num(b)
    if x is not None and y is not None:
        return abs(x - y) <= max(0.01, 0.01 * max(abs(x), abs(y)))
    return str(a).strip().lower() == str(b).strip().lower()


def check_item(d, need_units=False):
    p = []
    if not isinstance(d, dict): return ['not an object']
    for k in ('topic', 'type'):
        if not (isinstance(d.get(k), dict) and d[k].get('key') and _bi(d[k])): p.append(f'{k}: needs key + en + hi')
    if not _bi(d.get('q')): p.append('q: needs en + hi')
    ms = d.get('methods')
    if not isinstance(ms, list) or len(ms) < 2: p.append('methods: need at least 2'); ms = ms if isinstance(ms, list) else []
    if len({str((m or {}).get('key')) for m in ms}) < len(ms): p.append('methods: duplicate keys')
    answers = []
    for i, m in enumerate(ms):
        if not isinstance(m, dict): p.append(f'methods[{i}]: not an object'); continue
        if not _bi(m.get('name')): p.append(f'methods[{i}].name: needs en + hi')
        steps = m.get('steps')
        if not isinstance(steps, list) or not (2 <= len(steps) <= 14): p.append(f'methods[{i}].steps: need 2-14'); steps = steps if isinstance(steps, list) else []
        bold = 0
        for j, s in enumerate(steps):
            if not isinstance(s, dict) or not (isinstance(s.get('en'), str) and s['en'].strip() and isinstance(s.get('hi'), str) and s['hi'].strip()):
                p.append(f'methods[{i}].steps[{j}]: needs en + hi'); continue
            h = scan_html(s.get('html', ''))
            if h.bad: p.append(f'methods[{i}].steps[{j}].html: ' + ', '.join(sorted(set(h.bad)))[:120])
            for r in h.rows:
                if sum(r) > 100.5: p.append(f'methods[{i}].steps[{j}]: bar widths add up to {sum(r):g}%')
            bold += h.bold
            for k in ('why', 'trap'):
                if k in s and s[k] is not None and not _bi(s[k]): p.append(f'methods[{i}].steps[{j}].{k}: needs en + hi')
        if steps and isinstance(steps[-1], dict) and scan_html(steps[-1].get('html', '')).circles < 1:
            p.append(f'methods[{i}]: last step must circle the answer')
        a = m.get('answer')
        if not (_bi(a) and 'value' in a): p.append(f'methods[{i}].answer: needs en + hi + value'); continue
        answers.append(a['value'])
        if need_units:
            if not str(a.get('unit') or '').strip(): p.append(f'methods[{i}].answer.unit: missing (Physics/Chemistry)')
            if bold < 1: p.append(f'methods[{i}]: units must be bold (<b>…</b>)')
    if answers and not all(same(answers[0], x) for x in answers[1:]):
        p.append(f'methods give different answers: {answers}')
    qz = d.get('quiz')
    if not isinstance(qz, dict) or not _bi(qz.get('q')) or not isinstance(qz.get('options'), list) or not (3 <= len(qz['options']) <= 4) \
            or not all(_bi(o) for o in qz['options']) or not isinstance(qz.get('answer'), int) or not (0 <= qz['answer'] < len(qz['options'])):
        p.append('quiz: needs q, 3-4 options (en + hi), answer index')
    for f in d.get('formulas') or []:
        if not _bi(f): p.append('formulas: each needs en + hi'); break
    v = d.get('viz')
    if v not in (None, {}) and not (isinstance(v, dict) and v.get('kind') == 'pie' and isinstance(v.get('parts'), list)
                                    and all(_bi(x) and _num(x.get('pct')) is not None for x in v['parts'])
                                    and sum(_num(x.get('pct')) for x in v['parts']) <= 100.5):
        p.append('viz: only {"kind":"pie","parts":[{en,hi,pct}]} with pct total <= 100')
    return p
