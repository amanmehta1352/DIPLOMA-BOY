"""Build ONE complete bilingual paper from two response sheets of the same shift (usually an English-medium and a
Hindi-medium candidate). Both sheets contain the same questions, but in a different order and with options shuffled.

Backbone = every question of the first (English) sheet, in its order -> the paper keeps all its questions.
The second sheet is matched to the backbone one-to-one per section (Hungarian assignment) on:
  * the text in "English space" (Hindi OCR is machine-translated ONLY to find the twin - students see the official Hindi),
  * language-free tokens (numbers, codes, maths) - these must agree.
A matched pair is ACCEPTED only when the official answers agree after mapping the options (for text questions), or the
match is very strong (figure questions, whose options are pictures).
Figure questions are kept as pictures of the question block (tick/cross icons and watermarks painted out).
"""
import os, re, io, json, collections, subprocess, hashlib
import sscsheet as S
import hindi as H

DEVA = re.compile('[ऀ-ॿ]')
LATIN_RUN = re.compile(r'[A-Za-z0-9][A-Za-z0-9.,:/%()\-+×÷=<>^\'’‘"“”@#&*_ ]*[A-Za-z0-9)\'’"”]|[A-Za-z0-9]')


# ------------------------------------------------------------------ pictures of question blocks
class Pages:
    """Page images with tick/cross icons and watermark words painted white."""
    def __init__(self, pdf_path, sheet, dpi, workdir):
        import fitz, pdfplumber
        from PIL import Image, ImageDraw
        self.dpi = dpi; self.k = dpi / 72; self.imgs = []; self.size = []
        self.skip = set(sheet.get('ad_pages') or [])      # advert pages inside a question are never part of its picture
        os.makedirs(workdir, exist_ok=True)
        doc = fitz.open(pdf_path); plum = pdfplumber.open(pdf_path)
        paint = collections.defaultdict(list)
        self.off = [(p.bbox[0], p.bbox[1]) for p in plum.pages]   # pdfplumber measures from the media box, the rendering from the crop box: some sheets differ by ~14 pt
        sides = collections.defaultdict(list)
        for q in sheet['questions']:
            for (pi, x0, top, x1, bottom) in q['marks']: paint[pi].append((x0, top, x1, bottom))
        wm = set(sheet.get('watermark_words', []))
        for i, page in enumerate(doc):
            pix = page.get_pixmap(dpi=dpi, alpha=False)
            im = Image.open(io.BytesIO(pix.tobytes('png'))).convert('RGB')
            dr = ImageDraw.Draw(im); k = self.k
            boxes = list(paint.get(i, []))
            ws = plum.pages[i].extract_words()
            if wm:
                for w in ws:
                    if w['text'] in wm: boxes.append((w['x0'], w['top'], w['x1'], w['bottom']))
            for w in ws:          # the "Q.12" label and "Ans" word are not part of the question
                if re.match(r'Q\.\d+', w['text']) and w['x0'] < 120:
                    m = re.match(r'Q\.\d+', w['text']); frac = len(m.group(0)) / max(1, len(w['text']))
                    boxes.append((w['x0'], w['top'], w['x0'] + (w['x1'] - w['x0']) * frac, w['bottom']))
                if w['text'] == 'Ans' and w['x0'] < 120: boxes.append((w['x0'], w['top'], w['x1'], w['bottom']))
            keys = [w for w in ws if w['x0'] > 200 and re.match(r'^(Question|QuestionID|Option\d?(ID)?|Status|Chosen)', w['text'])]
            if keys:          # the side box (Question ID / Option IDs / Status / Chosen) with its frame is not part of the question
                grp = []
                for kw in sorted(keys, key=lambda w: w['top']):
                    if grp and kw['top'] - grp[-1]['top'] > 40: sides[i].append(grp); grp = []
                    grp.append(kw)
                sides[i].append(grp)
                for g in sides[i]:
                    gl = min(w['x0'] for w in g); gt = min(w['top'] for w in g); gb = max(w['bottom'] for w in g)
                    for w in ws:
                        if gt - 2 <= w['top'] <= gb + 2 and w['x0'] >= gl - 70: gb = max(gb, w['bottom']); gl = min(gl, w['x0'])
                    boxes.append((gl - 70, gt - 14, 2000, gb + 14))
            ox, oy = self.off[i]
            for (x0, t, x1, b) in boxes: dr.rectangle([(x0 - ox) * k - 2, (t - oy) * k - 2, (x1 - ox) * k + 2, (b - oy) * k + 2], fill='white')
            im = self.clean(im)
            self.imgs.append(im); self.size.append((page.rect.width, page.rect.height))

    @staticmethod
    def clean(im):
        """Paint out the pale-pink Adda247 logo that lies under the questions (ticks/crosses/side box are painted above)."""
        import numpy as np
        from PIL import Image
        a = np.asarray(im).astype(int); r, g, b = a[..., 0], a[..., 1], a[..., 2]
        pink = (r >= 215) & (r - g >= 12) & (r - b >= 12) & (g >= 140) & (b >= 140) & (abs(g - b) <= 40)
        a[pink] = 255
        return Image.fromarray(a.astype('uint8'))

    @staticmethod
    def drop_rules(crop):
        """Remove the thin full-width frame lines between questions."""
        import numpy as np
        from PIL import Image
        a = np.asarray(crop.convert('RGB')).copy(); dark = (a.min(axis=2) < 215)
        frac = dark.mean(axis=1); rows = np.where(frac > 0.6)[0]
        if len(rows) and len(rows) <= 12: a[rows] = 255
        cols = np.where(dark.mean(axis=0) > 0.9)[0]
        if len(cols) and len(cols) <= 12: a[:, cols] = 255
        return Image.fromarray(a)

    def block(self, q, x_right):
        """Picture of one question block (may continue on the next page), trimmed of white margins."""
        from PIL import Image, ImageOps
        (p0, t0), (p1, t1) = q['start'], q['end']
        parts = []
        for p in range(p0, min(p1, len(self.imgs) - 1) + 1):
            w, h = self.size[p]; ox, oy = self.off[p]
            top = (t0 - oy - 3) if p == p0 else 40
            bot = (t1 - oy - 14) if p == p1 else h - 40
            if bot - top < 6 or p in self.skip: continue
            crop = self.imgs[p].crop((int(56 * self.k), int(max(0, top) * self.k), int(min(w - 50, x_right) * self.k), int(min(h, bot) * self.k)))
            crop = self.drop_rules(crop)
            bbox = ImageOps.invert(crop.convert('L')).point(lambda v: 255 if v > 40 else 0).getbbox()
            if bbox: parts.append(crop.crop((max(0, bbox[0] - 8), max(0, bbox[1] - 8), min(crop.width, bbox[2] + 8), min(crop.height, bbox[3] + 8))))
        if not parts: return None
        W = max(p.width for p in parts); Hh = sum(p.height for p in parts)
        out = Image.new('RGB', (W, Hh), 'white'); y = 0
        for p in parts: out.paste(p, (0, y)); y += p.height
        buf = io.BytesIO(); out.convert('P', palette=Image.ADAPTIVE, colors=64).save(buf, 'PNG', optimize=True)
        return buf.getvalue()


def right_edge(sheet):
    """Question block = full width (the side column is painted white in Pages)."""
    return 10000


# ------------------------------------------------------------------ Hindi OCR (official Hindi text)
def repair_latin(ocr_text, layer_text):
    """OCR garbles English codes/numbers inside Hindi sentences; the sheet's text layer keeps them exact.
    Replace the OCR's Latin/digit runs by the layer's runs, in order, when both have the same number of runs."""
    lay = [m.group(0).strip() for m in LATIN_RUN.finditer(re.sub(r'\(cid:\d+\)', ' ', DEVA.sub(' ', layer_text or ''))) if m.group(0).strip()]
    ocr_runs = list(LATIN_RUN.finditer(DEVA.sub(lambda m: '\0', ocr_text)))
    ocr_runs = [m for m in ocr_runs if m.group(0).strip() and '\0' not in m.group(0)]
    if not lay or len(lay) != len(ocr_runs): return ocr_text
    out = []; last = 0
    for m, rep in zip(ocr_runs, lay):
        out.append(ocr_text[last:m.start()]); out.append(rep); last = m.end()
    out.append(ocr_text[last:])
    return ''.join(out)


def hindi_of(sheet, i, ocr):
    q = sheet['questions'][i]; o = ocr.get(i)
    if not o: return None
    text = repair_latin(o['text'], q['text'])
    opts = []
    for k in range(4):
        layer = (q['opts'].get(str(k + 1)) or '').strip()
        if layer and not DEVA.search(layer) and '(cid:' not in layer: opts.append(layer)        # numbers/codes: exact from the layer
        else: opts.append(repair_latin(o['opts'][k], layer) if k < len(o['opts']) else '')
    wm = [w for w in sheet.get('watermark_words', []) if not w.startswith('http')]
    def scrub(t):
        t = S.URL_INLINE.sub('', t or '')
        for w in wm: t = re.sub(r'(?<![A-Za-z])' + re.escape(w) + r'(?![A-Za-z])', '', t)
        return re.sub(r'\s+', ' ', t).strip()
    return {'text': scrub(text), 'opts': [scrub(x) for x in opts]}


GREEK = re.compile('[α-ωΑ-Ωµ]')
FORMULA = re.compile(r'[A-Za-z0-9]+(?:\s*/\s*[A-Za-z0-9]+)+')
def ocr_clean(hi, en, layer):
    """Official Hindi from OCR is used only if it carries no stray English words (OCR noise like 'Ferd'),
    keeps every Greek letter and formula of the English, and does not end in stray marks."""
    en_words = {w.lower() for w in re.findall(r'[A-Za-z]{2,}', (en or '') + ' ' + re.sub(r'\(cid:\d+\)', ' ', layer or ''))}
    for w in re.findall(r'[A-Za-z]{2,}', hi or ''):
        if w.lower() not in en_words: return False
    for g in GREEK.findall(en or ''):
        if g not in (hi or ''): return False
    flat = re.sub(r'\s+', '', hi or '')
    for f in FORMULA.findall(en or ''):
        if re.sub(r'\s+', '', f) not in flat: return False
    if re.search(r'[|]|\s[IlL]\s*$', hi or ''): return False
    return True


# ------------------------------------------------------------------ similarity in English space
NUMTOK = re.compile(r'\d+(?:\.\d+)?|\b[A-Z]{2,}\b')
def langfree(t):
    return collections.Counter(NUMTOK.findall(re.sub(r'\(cid:\d+\)', ' ', t or '')))

class Translator:
    def __init__(self, log=print):
        self.ok = False; self.cache = {}
        try:
            from transformers import MarianMTModel, MarianTokenizer
            import torch
            torch.set_num_threads(max(1, os.cpu_count() or 2))
            name = 'Helsinki-NLP/opus-mt-hi-en'
            self.tok = MarianTokenizer.from_pretrained(name); self.model = MarianMTModel.from_pretrained(name).eval()
            self.torch = torch; self.ok = True
        except Exception as e:
            log(f'translator not available: {e}')

    def __call__(self, texts):
        todo = [t for t in dict.fromkeys(texts) if t and t not in self.cache]
        if self.ok:
            for i in range(0, len(todo), 24):
                batch = [t[:600] for t in todo[i:i + 24]]
                with self.torch.no_grad():
                    enc = self.tok(batch, return_tensors='pt', padding=True, truncation=True, max_length=256)
                    out = self.model.generate(**enc, max_new_tokens=200, num_beams=1)
                for t, o in zip(todo[i:i + 24], self.tok.batch_decode(out, skip_special_tokens=True)): self.cache[t] = o
        return [self.cache.get(t, '') if t else '' for t in texts]


def _sim(a_docs, b_docs, char=(3, 5), word=True):
    from sklearn.feature_extraction.text import TfidfVectorizer
    docs = a_docs + b_docs
    vc = TfidfVectorizer(analyzer='char_wb', ngram_range=char, sublinear_tf=True, min_df=1).fit(docs)
    s = (vc.transform(a_docs) @ vc.transform(b_docs).T).toarray()
    if word:
        vw = TfidfVectorizer(ngram_range=(1, 2), sublinear_tf=True, min_df=1, token_pattern=r'(?u)\b\w\w+\b').fit(docs)
        s = 0.5 * s + 0.5 * (vw.transform(a_docs) @ vw.transform(b_docs).T).toarray()
    return s


def match_sheets(A, B, spaces, log=print):
    """One-to-one matching of questions of sheet A to sheet B, section by section.
    spaces: list of (a_texts, b_texts, weight, char_range) - the same questions written in a common language.
    Returns {a_index: (b_index, score, margin)}."""
    import numpy as np
    from scipy.optimize import linear_sum_assignment
    out = {}
    secA = collections.defaultdict(list); secB = collections.defaultdict(list)
    for i, q in enumerate(A['questions']): secA[S.norm(q['section'] or '')].append(i)
    for j, q in enumerate(B['questions']): secB[S.norm(q['section'] or '')].append(j)
    for sec, ia in secA.items():
        jb = secB.get(sec)
        if not jb: log(f'section not in other sheet: {sec}'); continue
        sim = np.zeros((len(ia), len(jb))); wsum = 0
        for a_t, b_t, w, cr in spaces:
            sim += w * _sim([a_t[i] or '' for i in ia], [b_t[j] or '' for j in jb], char=cr); wsum += w
        sim /= wsum
        la = [langfree(A['questions'][i]['text'] + ' ' + ' '.join(A['questions'][i]['opts'].values())) for i in ia]
        lb = [langfree(B['questions'][j]['text'] + ' ' + ' '.join(B['questions'][j]['opts'].values())) for j in jb]
        for x, ca in enumerate(la):
            for y, cb in enumerate(lb):
                if ca or cb:
                    inter = sum((ca & cb).values()); uni = sum((ca | cb).values())
                    sim[x, y] = 0.6 * sim[x, y] + 0.4 * (inter / uni if uni else 0)
        r, c = linear_sum_assignment(-sim)
        for x, y in zip(r, c):
            row = np.sort(sim[x])[::-1]; second = row[1] if len(row) > 1 else 0
            col = np.sort(sim[:, y])[::-1]; second_c = col[1] if len(col) > 1 else 0
            out[ia[x]] = (jb[y], float(sim[x, y]), float(sim[x, y] - max(second, second_c)))
    return out


def map_options2(a_en, b_en, a_lay, b_lay, a_hi=None, b_hi=None):
    mp, conf, M = map_options(a_en, b_en, a_lay, b_lay, a_hi, b_hi, full=True)
    cells = []
    for x in range(4):
        y = mp[x]
        rbest = max([M[x, k] for k in range(4) if k != y] or [0]); cbest = max([M[k, y] for k in range(4) if k != x] or [0])
        cells.append(M[x, y] > 0.1 and M[x, y] >= rbest + 0.08 and M[x, y] >= cbest + 0.08)
    return mp, conf, cells, M


def map_options(a_en, b_en, a_lay, b_lay, a_hi=None, b_hi=None, full=False):
    """Which option of B is option k of A? Hungarian on exact language-free tokens + English-space words + Hindi-space characters."""
    import numpy as np
    from scipy.optimize import linear_sum_assignment
    def tok(t): return set(re.findall(r'[a-z]{3,}|\d+(?:\.\d+)?', (t or '').lower()))
    def grams(t):
        t = re.sub(r'\s+', ' ', (t or '').strip()); return {t[i:i + 3] for i in range(max(0, len(t) - 2))}
    M = np.zeros((4, 4))
    for x in range(4):
        for y in range(4):
            la, lb = langfree(a_lay[x]), langfree(b_lay[y])
            exact = 1.0 if (la and la == lb) else 0.0
            ta, tb = tok(a_en[x]), tok(b_en[y])
            j = len(ta & tb) / len(ta | tb) if (ta | tb) else 0.0
            h = 0.0
            if a_hi and b_hi:
                ga, gb = grams(a_hi[x]), grams(b_hi[y])
                h = len(ga & gb) / len(ga | gb) if (ga | gb) else 0.0
            M[x, y] = 2 * exact + j + 1.5 * h + (0.5 if S.norm(a_lay[x]) and S.norm(a_lay[x]) == S.norm(b_lay[y]) else 0)
    r, c = linear_sum_assignment(-M)
    mp = dict(zip(r, c))
    conf = all(M[x, mp[x]] > 0.1 and M[x, mp[x]] >= max(M[x, y] for y in range(4) if y != mp[x]) + 0.08 for x in range(4))
    if full: return [int(mp[x]) for x in range(4)], conf, M
    return [int(mp[x]) for x in range(4)], conf


# ------------------------------------------------------------------ build

DEVA_SP1 = re.compile(r'([क-ह]़?ृ) (?=[क-ह])')
DEVA_SP2 = re.compile(r'(^|[ (])((?!के |से |ने |थे |दे |ले |वे |ये |है |पे |हे )[क-ह]़?[ूृेै]) (?=[क-ह])')
def fix_deva_space(t):
    """poppler puts a space after a glyph with an overhang (रामकृ ष्ण, कू ड़े, रे ल): join it back, never after real words (के, से, है ...)."""
    return DEVA_SP2.sub(r'\1\2', DEVA_SP1.sub(r'\1', t or ''))

BROKEN = re.compile(r'(?:^|\s)[\u093e-\u094c\u0901-\u0903\u094d]')
def layer_hindi(pdf_path, sheet, log=print):
    """Some sheets (RRB NTPC) carry a correct Hindi text layer that poppler (pdftotext) reads exactly, while pdfplumber
    scrambles the vowel signs. Read it with pdftotext; use a question only when its Hindi is clean (no vowel sign
    starting a word, no (cid:) glyphs, four options). The official Hindi then needs no OCR at all."""
    try: txt = subprocess.run(['pdftotext', '-layout', pdf_path, '-'], capture_output=True, text=True, timeout=300).stdout
    except Exception as e: log(f'pdftotext failed: {e}'); return {}
    qs = S.parse_text_lines(txt.split('\n'))
    sq = sheet['questions']
    if len(qs) != len(sq) or any(a['qno'] != b['qno'] for a, b in zip(qs, sq)): log(f'layer Hindi: {len(qs)} vs {len(sq)} questions - not used'); return {}
    out = {}
    for j, (q, s) in enumerate(zip(qs, sq)):
        if s['lang'] != 'hi': continue
        opts = [q['opts'].get(str(k + 1)) or '' for k in range(4)]
        t = q['text'] + ' ' + ' '.join(opts)
        if not DEVA.search(q['text']) or '(cid:' in t or BROKEN.search(t) or not all(opts): continue
        toks = [w for w in re.findall(r'\S+', t) if DEVA.search(w)]
        if not toks or sum(1 for w in toks if len(w) == 1) / len(toks) > 0.15: continue          # "व म आ र": letters torn apart
        if sum(1 for ln in q['text'].split('\n') if 0 < len(ln.strip()) <= 3) > 1: continue       # one syllable per line
        wm = [w for w in sheet.get('watermark_words', []) if not w.startswith('http')]
        def scrub(x):
            for w in wm: x = re.sub(r'(?<![A-Za-z])' + re.escape(w) + r'(?![A-Za-z])', '', x)
            return re.sub(r'[ \t]+', ' ', x).strip()
        out[j] = {'text': fix_deva_space(scrub(q['text'])), 'opts': [fix_deva_space(scrub(o)) for o in opts]}
    n_hi = sum(1 for s in sq if s['lang'] == 'hi')
    if n_hi and len(out) < 0.8 * n_hi: log(f'layer Hindi: only {len(out)} of {n_hi} clean - the text layer is not trusted for this sheet'); return {}
    log(f'layer Hindi: {len(out)} of {sum(1 for s in sq if s["lang"] == "hi")} Hindi questions read exactly from the PDF text')
    return out

def build(en_pdf, hi_pdf, work, log=print, dpi=150):
    """Returns {'questions': [...], 'report': {...}} for the backbone (English) sheet."""
    os.makedirs(work, exist_ok=True)
    A = S.read_sheet(en_pdf)
    B = S.read_sheet(hi_pdf) if hi_pdf else None
    rep = {'backbone': len(A['questions']), 'other': len(B['questions']) if B else 0}
    is_fig = lambda q: bool(q['figs']) or q['gap'] > 30

    # OCR every Hindi-shown question of both sheets (the text layer of Hindi is broken)
    layA = layer_hindi(en_pdf, A, log); layB = layer_hindi(hi_pdf, B, log) if B else {}
    ocrA = H.ocr_sheet(en_pdf, A, [i for i, q in enumerate(A['questions']) if q['lang'] == 'hi' and i not in layA], os.path.join(work, 'ocrA')) if H.have_hindi_ocr() else {}
    ocrB = H.ocr_sheet(hi_pdf, B, [j for j, q in enumerate(B['questions']) if q['lang'] == 'hi' and j not in layB], os.path.join(work, 'ocrB')) if (B and H.have_hindi_ocr()) else {}
    hiA = {i: hindi_of(A, i, ocrA) for i in ocrA}; hiB = {j: hindi_of(B, j, ocrB) for j in ocrB} if B else {}
    hiA.update(layA); hiB.update(layB)
    rep_layer = {'layer_hindi_A': len(layA), 'layer_hindi_B': len(layB)}

    # English-space texts for matching
    tr = Translator(log)
    def en_space(sheet, hmap):
        texts = []; need = []
        for i, q in enumerate(sheet['questions']):
            if q['lang'] == 'en': texts.append(q['text'] + ' ' + ' '.join(q['opts'].values()))
            else:
                h = hmap.get(i) or {'text': '', 'opts': []}
                texts.append(None); need.append((i, h['text'] + ' । ' + ' । '.join(h['opts'])))
        tt = tr([t for _, t in need])
        for (i, _), t in zip(need, tt): texts[i] = t
        return [t or '' for t in texts]
    a_txt = en_space(A, hiA)
    # Hindi-space texts: English questions machine-translated to Hindi (IndicTrans2, codes protected) vs official Hindi OCR
    def hi_space(sheet, hmap):
        stems = [None] * len(sheet['questions']); opts = [None] * len(sheet['questions']); todo = []
        for i, q in enumerate(sheet['questions']):
            if q['lang'] == 'hi':
                h = hmap.get(i) or {'text': '', 'opts': [''] * 4}
                stems[i] = h['text']; opts[i] = list(h['opts'])
            else: todo.append(i)
        if todo:
            try:
                import mt_enhi
                lines = []
                for i in todo:
                    q = sheet['questions'][i]
                    lines.append(re.sub(r'\s*\n\s*', ' ', q['text']))
                    lines += [q['opts'].get(str(k + 1)) or '' for k in range(4)]
                tt = mt_enhi.translate(lines, batch=16, beams=1)
                for n, i in enumerate(todo):
                    stems[i] = tt[5 * n]; opts[i] = tt[5 * n + 1: 5 * n + 5]
            except Exception as e:
                log(f'en->hi translation not available: {e}')
                for i in todo:
                    q = sheet['questions'][i]; stems[i] = q['text']; opts[i] = [q['opts'].get(str(k + 1)) or '' for k in range(4)]
        return stems, opts
    a_hs, a_ho = hi_space(A, hiA)
    pairs = {}; idpairs = {}
    if B:
        b_txt = en_space(B, hiB)
        b_hs, b_ho = hi_space(B, hiB)
        a_h = [(a_hs[i] or '') + ' । ' + ' । '.join(x or '' for x in a_ho[i]) for i in range(len(a_hs))]
        b_h = [(b_hs[j] or '') + ' । ' + ' । '.join(x or '' for x in b_ho[j]) for j in range(len(b_hs))]
        pairs = match_sheets(A, B, [(a_txt, b_txt, 0.3, (3, 5)), (a_h, b_h, 0.7, (2, 4))], log)
        # The English and Hindi sheets of one shift carry the SAME Question IDs (and Option IDs): pair by ID, exactly.
        # Text matching is only the fallback for questions whose ID is not found in the other sheet.
        bq = {(q.get('ids') or {}).get('q'): j for j, q in enumerate(B['questions']) if (q.get('ids') or {}).get('q')}
        for i, q in enumerate(A['questions']):
            qid = (q.get('ids') or {}).get('q')
            if qid and qid in bq: pairs[i] = (bq[qid], 1.0, 1.0); idpairs[i] = bq[qid]
        taken = set(idpairs.values())
        for i in [k for k in pairs if k not in idpairs and pairs[k][0] in taken]: del pairs[i]
        rep['id_paired'] = len(idpairs)

    # pictures
    pagesA = pagesB = None
    figsA = [i for i, q in enumerate(A['questions']) if is_fig(q)]
    if figsA:
        pagesA = Pages(en_pdf, A, dpi, os.path.join(work, 'pgA'))
        if B: pagesB = Pages(hi_pdf, B, dpi, os.path.join(work, 'pgB'))
    xa = right_edge(A); xb = right_edge(B) if B else 360

    out = []; stats = collections.Counter()
    for i, qa in enumerate(A['questions']):
        fig = is_fig(qa)
        m = pairs.get(i); qb = B['questions'][m[0]] if (B and m) else None
        rec = {'section': qa['section'], 'qno': qa['qno'], 'order': i + 1, 'fig': fig, 'answer': qa['answer_pos'],
               'en': None, 'hi': None, 'en_opts': [None] * 4, 'hi_opts': [None] * 4, 'img': None, 'img_hi': None,
               'checks': {}, 'match': (round(m[1], 3), round(m[2], 3)) if m else None}
        if qa['answer_pos'] is None: rec['checks']['answer'] = 'no official answer on sheet'
        # --- side of A
        if qa['lang'] == 'en':
            rec['en'] = qa['text']; rec['en_opts'] = [qa['opts'].get(str(k + 1)) for k in range(4)]
        else:
            h = hiA.get(i)
            if h: rec['hi'] = h['text']; rec['hi_opts'] = h['opts']
        # --- twin from B
        if qb is not None:
            strong = m[1] >= 0.25 and m[2] >= 0.03
            if fig:
                ok = m[1] >= 0.40 and m[2] >= 0.08
                if ok:
                    if qb['lang'] == 'hi' and rec['hi'] is None: rec['hi'] = (hiB.get(m[0]) or {}).get('text')
                    if qb['lang'] == 'en' and rec['en'] is None: rec['en'] = qb['text']
                    rec['twin_fig'] = m[0]
                stats['fig_pair_ok' if ok else 'fig_pair_weak'] += 1
            else:
                # map options of B onto A; the official answers must agree (answer option of A must be closest to the ticked option of B)
                a_lay = [qa['opts'].get(str(k + 1)) or '' for k in range(4)]
                b_lay = [qb['opts'].get(str(k + 1)) or '' for k in range(4)]
                a_en = rec['en_opts'] if qa['lang'] == 'en' else tr([x or '' for x in rec['hi_opts']])
                hb = hiB.get(m[0]) if qb['lang'] == 'hi' else None
                b_en = b_lay if qb['lang'] == 'en' else tr([x or '' for x in (hb or {'opts': [''] * 4})['opts']])
                omap, conf, cells, M = map_options2(a_en, b_en, a_lay, b_lay, a_ho[i], b_ho[m[0]])
                ans = qa['answer_pos']; bans = qb['answer_pos']
                verdict = 'unclear'
                ao_ = [(qa.get('ids') or {}).get(f'o{k + 1}') for k in range(4)]; bo_ = [(qb.get('ids') or {}).get(f'o{k + 1}') for k in range(4)]
                by_id = i in idpairs and all(ao_) and set(ao_) == set(bo_)
                if by_id:     # exact option mapping from the Option IDs
                    omap = [bo_.index(x) for x in ao_]; conf = True; cells = [True] * 4
                    if ans is not None and bans is not None: verdict = 'agree' if omap[ans] == bans else 'disagree'
                elif ans is not None and bans is not None:
                    row = list(M[ans]); best = max(range(4), key=lambda y: row[y]); others = sorted(row, reverse=True)
                    if others[0] - others[1] >= 0.08: verdict = 'agree' if best == bans else 'disagree'
                take = (verdict == 'agree' and m[1] >= 0.2) or (verdict == 'unclear' and m[1] >= 0.45 and m[2] >= 0.1)
                if take:
                    if qb['lang'] == 'hi' and hb and rec['hi'] is None:
                        rec['hi'] = hb['text']
                        rec['hi_opts'] = [hb['opts'][omap[k]] if (cells[k] or (verdict == 'agree' and k == ans)) else None for k in range(4)]
                    if qb['lang'] == 'en' and rec['en'] is None and conf:
                        rec['en'] = qb['text']; rec['en_opts'] = [qb['opts'].get(str(omap[k] + 1)) for k in range(4)]
                    rec['checks']['twin'] = 'answers agree' if verdict == 'agree' else 'strong match'
                    stats['pair_' + verdict] += 1
                else:
                    rec['checks']['twin'] = f'not used (score {m[1]:.2f}, answer {verdict})'
                    stats['pair_rejected_' + verdict] += 1
        # --- Hindi sanity: numbers / codes of the English must survive
        if rec['hi'] and rec['en'] and not fig and not rec.get('hi_mt') and not ocr_clean(rec['hi'], rec['en'], (qb or qa)['text']):
            rec['checks']['hindi'] = 'OCR noise'; stats['hindi_rejected_noise'] += 1; rec['hi'] = None; rec['hi_opts'] = [None] * 4
        if rec['hi'] and rec['en'] and not fig and not H.stem_valid(rec['hi'], rec['en']):
            rec['checks']['hindi'] = 'numbers/codes differ from English'; stats['hindi_rejected'] += 1; rec['hi'] = None; rec['hi_opts'] = [None] * 4
        # --- no official Hindi found: IndicTrans2 Hindi (codes/numbers protected), clearly marked as machine translation
        if not rec['hi'] and rec['en'] and a_hs[i] and DEVA.search(a_hs[i] or ''):
            rec['hi'] = a_hs[i]; rec['hi_mt'] = True; stats['hindi_machine'] += 1
        # figure questions: the Hindi picture carries the Hindi; an OCR'd Hindi text is kept only when it is clean
        if fig and rec['hi'] and not rec.get('hi_mt') and not (rec['en'] and ocr_clean(rec['hi'], rec['en'], (qb or qa)['text'])):
            rec['checks']['hindi'] = 'figure: Hindi text unclear, picture used'; rec['hi'] = None; rec['hi_opts'] = [None] * 4
        if rec['hi'] and not rec.get('hi_mt'):
            rec['hi_src'] = 'layer' if ((qb is not None and qb['lang'] == 'hi' and m and m[0] in layB) or (qa['lang'] == 'hi' and i in layA)) else 'ocr'
        if rec['hi'] and not rec.get('hi_mt'):      # each official option must also be free of OCR noise
            rec['hi_opts'] = [o if (o and ocr_clean(o, rec['en_opts'][k] or '', '')) else None for k, o in enumerate(rec['hi_opts'])]
        if rec['hi'] and rec['en']:
            rec['hi_opts'] = [rec['hi_opts'][k] or (a_ho[i][k] if a_ho[i] and a_ho[i][k] and (DEVA.search(a_ho[i][k]) or a_ho[i][k] == rec['en_opts'][k]) else rec['en_opts'][k]) for k in range(4)]
        # --- pictures for figure questions
        if fig and pagesA:
            png = pagesA.block(qa, xa)
            if png:
                if qa['lang'] == 'en': rec['img'] = png
                else: rec['img_hi'] = png
            if pagesB is not None and rec.get('twin_fig') is not None:
                png2 = pagesB.block(B['questions'][rec['twin_fig']], xb)
                if png2:
                    if B['questions'][rec['twin_fig']]['lang'] == 'en': rec['img'] = rec['img'] or png2
                    else: rec['img_hi'] = rec['img_hi'] or png2
        out.append(rec)
    # completeness flags
    for r in out:
        r['complete_en'] = bool(r['img'] or (r['en'] and all(r['en_opts'])))
        r['complete_hi'] = bool(r['img_hi'] or (r['hi'] and all(r['hi_opts'])) or (r['fig'] and r['img'] and r['hi'] and not r['checks'].get('hindi')))
        stats['hi_official' if (r['hi'] and not r.get('hi_mt')) else ('hi_machine' if r.get('hi_mt') else 'hi_none')] += 1
        stats['en_ok' if r['complete_en'] else 'en_missing'] += 1
        stats['hi_ok' if r['complete_hi'] else 'hi_missing'] += 1
        stats['fig'] += r['fig']
    rep.update(dict(stats)); rep['translator'] = tr.ok
    try:   # debug dump for review: every question of B with its OCR, translation and best match
        dbg = []
        inv = {v[0]: (k, v[1], v[2]) for k, v in pairs.items()}
        for j, q in enumerate(B['questions'] if B else []):
            k = inv.get(j)
            dbg.append({'j': j, 'sec': (q['section'] or '')[:12], 'lang': q['lang'], 'ocr': (hiB.get(j) or {}).get('text', '')[:300],
                        'ocr_opts': (hiB.get(j) or {}).get('opts'), 'tr': b_txt[j][:300], 'a': k[0] if k else None,
                        'a_en': (A['questions'][k[0]]['text'][:200] if k else ''), 'score': k[1] if k else None})
        json.dump(dbg, open(os.path.join(work, '..', 'debug_pairs.json'), 'w'), ensure_ascii=False, indent=1)
    except Exception as e: log(f'debug dump failed {e}')
    rep.update(rep_layer)
    return {'questions': out, 'report': rep, 'A': A, 'B': B}
