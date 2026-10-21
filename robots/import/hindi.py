"""Hindi side of a bilingual paper.

The Hindi response sheet has a broken text layer, so each question is read by OCR (tesseract hin+eng) from a picture of
its own area of the page, with the tick/cross icons painted out. The Hindi never decides the answer.
A Hindi question is attached to an English one only when the numbers / English words / maths in it match strongly
(and the right answer matches too). Anything unsure stays unpaired - it is reported, never guessed.
"""
import re, os, subprocess, tempfile, collections

DEVA = re.compile('[ऀ-ॿ]')
OPT = re.compile(r'^\W{0,3}(?:Ans\W{0,3})?([1-4])\s*[.)]\s*(.*)$')


def have_hindi_ocr():
    try:
        out = subprocess.run(['tesseract', '--list-langs'], capture_output=True, text=True).stdout
        return 'hin' in out.split()
    except Exception:
        return False


def _render(pdf_path, dpi):
    import fitz
    doc = fitz.open(pdf_path)
    for page in doc:
        yield page.rect.width, page.rect.height, page.get_pixmap(dpi=dpi, alpha=False)


def ocr_sheet(pdf_path, sheet, want, workdir, dpi=250, log=print, lang='hin+eng'):
    """OCR the questions of `sheet` whose index is in `want`. Returns {index: {'text','opts':[4 strings or '']}}."""
    from PIL import Image, ImageDraw
    k = dpi / 72
    pages = []
    for i, (w, h, pix) in enumerate(_render(pdf_path, dpi)):
        png = os.path.join(workdir, f'pg{i}.png'); pix.save(png); pages.append((w, h, png))
    marks_by_page = collections.defaultdict(list)
    for q in sheet['questions']:
        for (pi, x0, top, x1, bottom) in q['marks']: marks_by_page[pi].append((x0, top, x1, bottom))
    for pi, (w, h, png) in enumerate(pages):          # paint tick/cross icons white so OCR does not read them
        if marks_by_page.get(pi):
            im = Image.open(png).convert('RGB'); dr = ImageDraw.Draw(im)
            for (x0, t, x1, b) in marks_by_page[pi]: dr.rectangle([x0 * k - 3, t * k - 3, x1 * k + 3, b * k + 3], fill='white')
            im.save(png)
    out = {}
    qs = sheet['questions']
    for idx in sorted(want):
        q = qs[idx]
        (p0, t0), (p1, t1) = q['start'], q['end']
        segs = []
        for p in range(p0, min(p1, len(pages) - 1) + 1):
            top = (t0 - 2) if p == p0 else 0
            bot = (t1 - 2) if p == p1 else pages[p][1]
            if bot - top > 4: segs.append((p, top, bot))
        text = []
        for (p, top, bot) in segs:
            w, h, png = pages[p]
            crop = Image.open(png).crop((0, int(top * k), int(w * 0.60 * k), int(bot * k)))
            cp = os.path.join(workdir, f'c{idx}_{p}.png'); crop.save(cp)
            r = subprocess.run(['tesseract', cp, '-', '-l', lang, '--psm', '6'], capture_output=True, text=True)
            text.append(r.stdout)
            os.remove(cp)
        out[idx] = parse_ocr('\n'.join(text))
    return out


ANS = re.compile(r'^\W{0,3}Ans\b\W{0,3}(.*)$', re.I)
QPREFIX = re.compile(r'^\(?\s*[QqOo0]\s*[.,]\s*\d{1,3}\s*[.:]?\s*')

def parse_ocr(txt):
    """OCR text of one question -> stem + 4 options. 'Ans' starts option 1 (the tick icon next to it is painted out, so its number is often lost)."""
    stem, opts, cur = [], {}, None
    for raw in txt.split('\n'):
        s = raw.strip()
        if not s: continue
        if re.search(r'(Question ID|Option \d ID|Status|Chosen Option)\s*:', s): continue
        if not stem and not opts: s = QPREFIX.sub('', s)
        m = ANS.match(s)
        if m and '1' not in opts:
            m2 = re.match(r'^[1-4]?\s*[.)]?\s*(.*)$', m.group(1)); cur = '1'; opts['1'] = [m2.group(1).strip()]; continue
        m = OPT.match(s)
        if m and m.group(1) not in opts and ((cur is None and m.group(1) == '1' and stem) or (cur is not None and int(m.group(1)) == int(cur) + 1)):
            cur = m.group(1); opts[cur] = [m.group(2).strip()]; continue
        if cur is None: stem.append(s)
        else: opts[cur].append(s)
    return {'text': re.sub(r'\s+', ' ', ' '.join(stem)).strip(),
            'opts': [re.sub(r'\s+', ' ', ' '.join(opts.get(str(i), []))).strip() for i in range(1, 5)]}


def stem_valid(hi_text, en_text):
    """The OCR'd Hindi stem must still carry every number and CAPITAL code word of the English stem
    (codes like "LESSON" and numbers are exactly where OCR goes wrong). Otherwise it is rejected."""
    need = re.findall(r'\d+(?:\.\d+)?|\b[A-Z]{2,}\b', en_text or '')
    flat = re.sub(r'\s+', '', hi_text or '').upper()
    return all(re.sub(r'\s+', '', n).upper() in flat for n in need)


def ocr_ok(o):
    """Is this OCR result usable as Hindi text?"""
    if not o or not o['text'] or any(not x for x in o['opts']): return False
    if len(DEVA.findall(o['text'])) < 2 and len(re.findall(r'[A-Za-z]{3,}', o['text'])) < 2: return False
    return True


# ---- pairing Hindi <-> English by the language-free parts (numbers, English words, maths) ----
NOISE = {'cid', 'http', 'https', 'www', 'com', 'org'}
WORD = re.compile(r'[a-z]{2,}|\d+(?:\.\d+)?|[+\-×÷=<>%^]')
NUM = re.compile(r'\d+(?:\.\d+)?')
def toks(t):
    t = re.sub(r'\(cid:\d+\)', ' ', (t or '')).lower().replace('−', '-').replace('–', '-')
    return collections.Counter(x for x in WORD.findall(t) if x not in NOISE)
def contain(a, b):
    """how much of a is found in b"""
    n = sum(a.values())
    return sum((a & b).values()) / n if n else 0.0


def pair(hi_items, en_items):
    """Each item: {'text','opts'[4],'ans'(0-3)} from the sheet text layer (digits / English / maths survive in the Hindi sheet too).
    A Hindi question pairs with an English one when its language-free tokens sit inside the English question, all the numbers of
    the English question appear in the Hindi one, the match is clearly the best, and the official right answer agrees.
    Returns {hi_index: (en_index, option_map hi_opt->en_opt, or None when options cannot be mapped safely)}."""
    res = {}
    es = []
    for e in en_items:
        full = toks(e['text'] + ' ' + ' '.join(e['opts']))
        es.append((full, collections.Counter(NUM.findall((e['text'] + ' ' + ' '.join(e['opts'])).lower())), [toks(o) for o in e['opts']]))
    for hi, h in enumerate(hi_items):
        ht = toks(h['text'] + ' ' + ' '.join(h['opts'])); ho = [toks(o) for o in h['opts']]
        hn = collections.Counter(NUM.findall(re.sub(r'\(cid:\d+\)', ' ', h['text'] + ' ' + ' '.join(h['opts'])).lower()))
        if sum(ht.values()) < 4: continue
        sc = []
        for ei, (et, en_, eo) in enumerate(es):
            s = min(contain(ht, et), contain(en_, hn) if en_ else 1.0)
            sc.append((s, ei))
        sc.sort(reverse=True)
        if not sc or sc[0][0] < 0.9: continue
        if len(sc) > 1 and sc[0][0] - sc[1][0] < 0.15: continue
        ei = sc[0][1]; eo = es[ei][2]
        omap = [None] * 4; used = set()
        for i in range(4):
            c = [j for j in range(4) if j not in used and ho[i] and ho[i] == eo[j]]
            if len(c) == 1: omap[i] = c[0]; used.add(c[0])
        left_h = [i for i in range(4) if omap[i] is None]; left_e = [j for j in range(4) if j not in used]
        if len(left_h) == 1: omap[left_h[0]] = left_e[0]
        if None in omap: omap = None
        if omap is not None:
            if omap[h['ans']] != en_items[ei]['ans']: continue
        else:   # options could not be mapped: stem is still safe only if the right answer's tokens agree where they exist
            if ho[h['ans']] and eo[en_items[ei]['ans']] and ho[h['ans']] != eo[en_items[ei]['ans']]: continue
        res[hi] = (ei, omap)
    seen = collections.Counter(v[0] for v in res.values())
    return {k: v for k, v in res.items() if seen[v[0]] == 1}
