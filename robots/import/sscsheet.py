"""SSC / TCS-iON response-sheet PDF  ->  questions.

One reader for every sheet layout we have seen (2018 browser prints, 2022-2024 candidate sheets).
 * English text comes from the PDF text layer (pdfplumber: keeps fi/fl ligatures, unlike pdftotext).
 * The official answer is the green tick image: exactly 4 marks and exactly 1 tick, else no answer.
 * Page furniture (a banner picture / URL line repeated on every page) is not question content and is dropped.
 * A question that shows a picture, or has a big blank gap, is held back (figure) - never guessed.
 * A question shown in Hindi (broken text layer) gets lang='hi'; its Hindi is read later by OCR.
"""
import re, hashlib, collections, os, subprocess, tempfile

DEVA = re.compile('[ऀ-ॿ]')
FURNITURE_LINE = re.compile(r'^\s*(www\.[a-z0-9.-]+\.[a-z]{2,}|https?://\S+)\s*$', re.I)
MARK_SIZES = ((16, 16), (31, 21))
# coaching / channel watermark text inside the text layer ("RankMitra - https://t.me/..", "www.x.in") is not question content
URL_INLINE = re.compile(r'(?:\b[A-Za-z0-9_]+\s*[-–:]\s*)?(?:https?://|www\.|t\.me/|telegram\.me/)\S*', re.I)
SIDE = re.compile(r'(Question ID|Option (\d) ID|Status|Chosen Option)\s*:\s*(\S+)')


def header_of(txt):
    h = {}
    for k, pat in [('date', r'(?:Exam|Test) Date\s+(\d\d/\d\d/\d{4})'), ('time', r'(?:Exam|Test) Time\s+(.+?)\s*(?:\n|$)'),
                   ('subject', r'Subject\s+(.+?)\s*(?:\n|$)')]:
        m = re.search(pat, txt); h[k] = m.group(1).strip() if m else None
    return h


def shift_of(time_txt):
    m = re.match(r'\s*(\d{1,2}):\d\d\s*([AP]M)', time_txt or '', re.I)
    if not m: return None
    hr = int(m.group(1)) % 12 + (12 if m.group(2).upper() == 'PM' else 0)
    return 1 if hr < 12 else 2 if hr < 16 else 3


def meta_of(h):
    s = h.get('subject') or ''
    y = re.search(r'(20\d\d)', s); b = re.search(r'(Civil|Mechanical|Electrical|Electronics|Computer)', s, re.I)
    p = re.search(r'Paper\s*[-]?\s*(II|I|2|1)\b', s, re.I)
    paper = ('Paper-II' if p.group(1).upper() in ('II', '2') else 'Paper-I') if p else None
    d = h.get('date'); iso = '-'.join(reversed(d.split('/'))) if d else None
    return {'year': int(y.group(1)) if y else None, 'branch': b.group(1).capitalize() if b else None, 'paper': paper,
            'date': iso, 'shift': shift_of(h.get('time'))}


# ---- cleanup of extracted text -------------------------------------------------------------
SUB = str.maketrans('0123456789', '₀₁₂₃₄₅₆₇₈₉')
def fix(s):
    s = s.replace('‍', '').replace('​', '').replace(' ̊', '°').replace('̊', '°')
    s = re.sub(r'(?<![A-Za-z])((?:k?N|kg|m)/)?(mm|cm|km|m|sec|s)([23])(?![0-9A-Za-z])',
               lambda m: (m.group(1) or '') + m.group(2) + '²³'[int(m.group(3)) - 2], s)
    for a in ('H2O', 'CO2', 'NH3', 'C3S', 'C2S', 'C3A', 'C4AF', 'H2SO4', 'HCl'):
        s = re.sub(r'\b' + a + r'\b', re.sub(r'\d', lambda m: m.group(0).translate(SUB), a), s)
    return re.sub(r'[ \t]+', ' ', s).strip()

MARK = re.compile(r'^(\d+\.|\(?[ivxIVX]+[.)]|\([a-dA-D1-4]\)|[A-D][.)]|[a-d]\)|\d\)|Statement|Conclusion|Assertion|Reason|Statements|Conclusions|Note|NOTE|\(NOTE|\()')
def join_lines(t):
    """The PDF breaks long lines; glue them back unless the next line starts a list item / statement."""
    out = []
    for ln in [l.strip() for l in t.split('\n') if l.strip()]:
        if out and len(out[-1]) >= 70 and not MARK.match(ln) and not out[-1].endswith((':', '?')): out[-1] += ' ' + ln
        else: out.append(ln)
    return '\n'.join(out)

_Q = {'‘': "'", '’': "'", '“': '"', '”': '"', '−': '-', '–': '-', '—': '-', ' ': ' '}
def norm(t):
    """Identity form of a text: case, spaces, quote/dash style ignored; letters, digits and maths symbols kept."""
    import unicodedata
    t = unicodedata.normalize('NFKC', t or '')
    for a, b in _Q.items(): t = t.replace(a, b)
    return re.sub(r'[^a-z0-9ऀ-ॿ+\-×÷=<>/%^*]+', '', t.lower())

def qkey(stem_en, opts_en):
    """Order-independent identity of a question (candidates see options in different orders)."""
    return hashlib.sha1((norm(stem_en) + '|' + '|'.join(sorted(norm(o) for o in opts_en))).encode()).hexdigest()[:16]


# ---- reading one sheet ---------------------------------------------------------------------
def parse_text_lines(lines):
    qs = []; section = None; cur = None; mode = None
    for raw in lines:
        s = URL_INLINE.sub('', raw).rstrip()
        if not s.strip() or FURNITURE_LINE.match(s): continue
        m = re.match(r'\s*Section\s*:\s*(.+)', s)
        if m: section = SIDE.split(m.group(1))[0].strip(); continue
        m = re.match(r'\s*Q\.(\d+)\s*(.*)', s)
        if m:
            if cur: qs.append(cur)
            cur = {'section': section, 'qno': int(m.group(1)), 'text': [], 'opts': {}, 'ids': {}, 'last': None}
            rest = m.group(2); side = SIDE.search(rest)
            if side: rest = rest[:side.start()]
            cur['text'].append(rest); mode = 'q'
            if side: _side(cur, side)
            continue
        if cur is None: continue
        side = SIDE.search(s)
        left = s[:side.start()] if side else s
        if side: _side(cur, side)
        m = re.match(r'\s*(Ans\s+)?([1-4])\.\s+(.*)$', left) if mode in ('q', 'o') else None
        if m and (m.group(1) or mode == 'o'):
            mode = 'o'; cur['last'] = m.group(2); cur['opts'][m.group(2)] = [m.group(3).strip()]; continue
        t = left.strip()
        if not t: continue
        if mode == 'q': cur['text'].append(t)
        elif mode == 'o' and not side and not cur['ids'] and cur['last']: cur['opts'][cur['last']].append(t)
    if cur: qs.append(cur)
    for q in qs:
        q['text'] = fix(join_lines('\n'.join(x for x in q['text'] if x.strip())))
        q['opts'] = {k: fix(' '.join(v)) for k, v in q['opts'].items()}
        q.pop('last', None)
    return qs

def _side(cur, side):
    if side.group(1) == 'Question ID': cur['ids']['q'] = side.group(3)
    elif side.group(2): cur['ids']['o' + side.group(2)] = side.group(3)


def read_sheet(pdf_path):
    import pdfplumber
    pdf = pdfplumber.open(pdf_path)
    n_pages = len(pdf.pages)
    # overlay watermarks (channel names stamped on every page at the same place) are not question content: drop those words
    pos = collections.Counter()
    for page in pdf.pages:
        for w in page.extract_words():
            pos[(w['text'], round(w['x0'] / 4), round(w['top'] / 4))] += 1
    need = max(4, len(pdf.pages) // 4)
    wm = {k for k, v in pos.items() if v >= need and not re.fullmatch(r'[\d.()\-:]+', k[0]) and not re.fullmatch(r'(Q\.\d+|Ans|ID|Status|Option|Question|Chosen)', k[0])}
    watermark_words = sorted({k[0] for k in wm})
    lines = []; texts = []
    for page in pdf.pages:
        if wm:
            def keep(o, wm=wm):
                return not (o.get('object_type') == 'char' and any(abs(o['x0'] / 4 - x) < 8 and abs(o['top'] / 4 - y) < 2 and o['text'] in t for (t, x, y) in wm if len(t) <= 40 and abs(o['x0'] / 4 - x) < 8))
            try: page_f = page.filter(keep)
            except Exception: page_f = page
        else: page_f = page
        t = page_f.extract_text() or ''
        texts.append(t); lines.extend(t.split('\n'))
    h = header_of('\n'.join(texts[:2]))
    qs = parse_text_lines(lines)

    # picture census: repeated pictures are page furniture; small 16x16/31x21 are tick/cross marks
    hc = collections.Counter(); mark_hash = collections.Counter()
    for page in pdf.pages:
        for im in page.images:
            sz = tuple(im['srcsize'])
            if sz == (31, 21): mark_hash[hashlib.md5(im['stream'].get_data()).hexdigest()] += 1
            elif sz not in MARK_SIZES and sz != (411, 488): hc[hashlib.md5(im['stream'].get_data()).hexdigest()] += 1
    furniture = {k for k, v in hc.items() if v >= max(5, n_pages // 4)}
    has_small_tick = any(tuple(im['srcsize']) == (16, 16) for p in pdf.pages for im in p.images)
    tick_hash = None
    if not has_small_tick:  # older sheets: tick and cross are both 31x21, told apart by picture content
        one = [k for k, v in mark_hash.items() if v == len(qs)]
        if len(one) == 1 and any(v == 3 * len(qs) for v in mark_hash.values()): tick_hash = one[0]

    marks, figs, starts, rows = [], [], [], []
    for pi, page in enumerate(pdf.pages):
        for im in page.images:
            sz = tuple(im['srcsize'])
            if sz in MARK_SIZES: rows.append((pi, im['top'], im['bottom'], 'm'))
            if sz == (16, 16): marks.append((pi, im['top'], 'tick', im['x0'], im['x1'], im['bottom']))
            elif sz == (31, 21):
                kind = 'tick' if tick_hash and hashlib.md5(im['stream'].get_data()).hexdigest() == tick_hash else 'cross'
                marks.append((pi, im['top'], kind, im['x0'], im['x1'], im['bottom']))
            elif sz == (411, 488): pass
            elif hashlib.md5(im['stream'].get_data()).hexdigest() in furniture: pass
            else: figs.append((pi, im['top']))
        for w in page.extract_words():
            m_ = re.match(r'Q\.(\d+)', w['text'])
            if m_ and w['x0'] < 120: starts.append((pi, w['top'], int(m_.group(1))))
            if w['x0'] < 330: rows.append((pi, w['top'], w['bottom']))
    marks.sort(); starts.sort(); rows.sort(key=lambda r: (r[0], r[1]))
    if len(starts) != len(qs) or any(q['qno'] != s[2] for q, s in zip(qs, starts)):
        raise ValueError(f'layout mismatch: {len(qs)} questions in text, {len(starts)} Q. markers on pages')
    for i, q in enumerate(qs):
        a = starts[i][:2]; end = starts[i + 1][:2] if i + 1 < len(qs) else (n_pages, 0)
        q['start'] = a; q['end'] = end
        q['figs'] = sum(1 for f in figs if a <= f < end)
        grp = [m for m in marks if a <= (m[0], m[1]) < end]
        q['marks'] = [(m[0], m[3], m[1], m[4], m[5]) for m in grp]      # for painting out before OCR
        ticks = [k for k, m in enumerate(grp) if m[2] == 'tick']
        q['answer_pos'] = ticks[0] if len(grp) == 4 and len(ticks) == 1 else None
        ls = [r for r in rows if a <= (r[0], r[1]) < end]
        ls.sort(key=lambda r: (r[0], r[1]))
        mk = [k for k, r in enumerate(ls) if len(r) == 4]
        ls = ls[:mk[-1] + 1] if mk else ls      # blank space after the last option (before the next question) is not a gap
        gap = 0
        for x, y in zip(ls, ls[1:]):
            if x[0] == y[0]: gap = max(gap, y[1] - x[2])
        q['gap'] = round(gap)
        q['lang'] = 'hi' if len(DEVA.findall(q['text'] + ' '.join(q['opts'].values()))) >= 3 else 'en'
    return {'header': h, 'questions': qs, 'pages': n_pages, 'watermark_words': watermark_words}


def hold_reason(q):
    """None = safe to import (in the language this entry is in), else why it is held back."""
    if q['figs']: return 'figure'
    if q['gap'] > 30: return 'figure_gap'
    if q['answer_pos'] is None: return 'no_answer'
    if q['lang'] == 'en':
        if not q['text']: return 'no_text'
        if len(q['opts']) != 4 or any(not v for v in q['opts'].values()): return 'options'
    return None
