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
        os.makedirs(workdir, exist_ok=True)
        doc = fitz.open(pdf_path); plum = pdfplumber.open(pdf_path)
        paint = collections.defaultdict(list)
        for q in sheet['questions']:
            for (pi, x0, top, x1, bottom) in q['marks']: paint[pi].append((x0, top, x1, bottom))
        wm = set(sheet.get('watermark_words', []))
        for i, page in enumerate(doc):
            pix = page.get_pixmap(dpi=dpi, alpha=False)
            im = Image.open(io.BytesIO(pix.tobytes('png'))).convert('RGB')
            dr = ImageDraw.Draw(im); k = self.k
            boxes = list(paint.get(i, []))
            if wm:
                for w in plum.pages[i].extract_words():
                    if w['text'] in wm: boxes.append((w['x0'], w['top'], w['x1'], w['bottom']))
            for w in plum.pages[i].extract_words():          # the "Q.12" label and "Ans" word are not part of the question
                if re.match(r'Q\.\d+', w['text']) and w['x0'] < 120:
                    m = re.match(r'Q\.\d+', w['text']); frac = len(m.group(0)) / max(1, len(w['text']))
                    boxes.append((w['x0'], w['top'], w['x0'] + (w['x1'] - w['x0']) * frac, w['bottom']))
                if w['text'] == 'Ans' and w['x0'] < 120: boxes.append((w['x0'], w['top'], w['x1'], w['bottom']))
            ws = plum.pages[i].extract_words()
            keys = [w for w in ws if w['x0'] > 200 and re.match(r'^(Question|QuestionID|Option\d?(ID)?|Status|Chosen)', w['text'])]
            for kw in keys:          # the side column (Question ID / Option IDs / Status) is not part of the question
                for w in ws:
                    if abs(w['top'] - kw['top']) < 2.5 and w['x0'] >= kw['x0'] - 1: boxes.append((w['x0'], w['top'], w['x1'], w['bottom']))
            for (x0, t, x1, b) in boxes: dr.rectangle([x0 * k - 2, t * k - 2, x1 * k + 2, b * k + 2], fill='white')
            self.imgs.append(im); self.size.append((page.rect.width, page.rect.height))

    def block(self, q, x_right):
        """Picture of one question block (may continue on the next page), trimmed of white margins."""
        from PIL import Image, ImageOps
        (p0, t0), (p1, t1) = q['start'], q['end']
        parts = []
        for p in range(p0, min(p1, len(self.imgs) - 1) + 1):
            w, h = self.size[p]
            top = (t0 - 3) if p == p0 else 40
            bot = (t1 - 3) if p == p1 else h - 40
            if bot - top < 6: continue
            crop = self.imgs[p].crop((int(20 * self.k), int(top * self.k), int(min(w, x_right) * self.k), int(bot * self.k)))
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


def match_sheets(A, B, a_txt, b_txt, log=print):
    """One-to-one matching of questions of sheet A to sheet B, section by section.
    a_txt/b_txt: per-question text in English space. Returns {a_index: (b_index, score)}."""
    import numpy as np
    from sklearn.feature_extraction.text import TfidfVectorizer
    from scipy.optimize import linear_sum_assignment
    out = {}
    secA = collections.defaultdict(list); secB = collections.defaultdict(list)
    for i, q in enumerate(A['questions']): secA[S.norm(q['section'] or '')].append(i)
    for j, q in enumerate(B['questions']): secB[S.norm(q['section'] or '')].append(j)
    for sec, ia in secA.items():
        jb = secB.get(sec)
        if not jb: log(f'section not in other sheet: {sec}'); continue
        docs = [a_txt[i] for i in ia] + [b_txt[j] for j in jb]
        vw = TfidfVectorizer(ngram_range=(1, 2), sublinear_tf=True, min_df=1).fit(docs)
        vc = TfidfVectorizer(analyzer='char_wb', ngram_range=(3, 5), sublinear_tf=True, min_df=1).fit(docs)
        Xa = [vw.transform([a_txt[i] for i in ia]), vc.transform([a_txt[i] for i in ia])]
        Xb = [vw.transform([b_txt[j] for j in jb]), vc.transform([b_txt[j] for j in jb])]
        sim = 0.5 * (Xa[0] @ Xb[0].T).toarray() + 0.5 * (Xa[1] @ Xb[1].T).toarray()
        # language-free tokens: numbers / codes must agree
        la = [langfree(A['questions'][i]['text'] + ' ' + ' '.join(A['questions'][i]['opts'].values())) for i in ia]
        lb = [langfree(B['questions'][j]['text'] + ' ' + ' '.join(B['questions'][j]['opts'].values())) for j in jb]
        for x, ca in enumerate(la):
            for y, cb in enumerate(lb):
                if ca or cb:
                    inter = sum((ca & cb).values()); uni = sum((ca | cb).values())
                    sim[x, y] = 0.6 * sim[x, y] + 0.4 * (inter / uni if uni else 0)
        r, c = linear_sum_assignment(-sim)
        for x, y in zip(r, c):
            # margin: how much better than this row's second best
            row = np.sort(sim[x])[::-1]; second = row[1] if len(row) > 1 else 0
            out[ia[x]] = (jb[y], float(sim[x, y]), float(sim[x, y] - second))
    return out


def map_options(a_opts_en, b_opts_en, a_lay, b_lay):
    """Which option of B is option k of A? Hungarian on text similarity + exact language-free tokens."""
    import numpy as np
    from scipy.optimize import linear_sum_assignment
    def tok(t): return set(re.findall(r'[a-z]{3,}|\d+(?:\.\d+)?', (t or '').lower()))
    M = np.zeros((4, 4))
    for x in range(4):
        for y in range(4):
            la, lb = langfree(a_lay[x]), langfree(b_lay[y])
            exact = 1.0 if (la and la == lb) else 0.0
            ta, tb = tok(a_opts_en[x]), tok(b_opts_en[y])
            j = len(ta & tb) / len(ta | tb) if (ta | tb) else 0.0
            M[x, y] = 2 * exact + j + (0.5 if S.norm(a_lay[x]) and S.norm(a_lay[x]) == S.norm(b_lay[y]) else 0)
    r, c = linear_sum_assignment(-M)
    mp = dict(zip(r, c))
    # confident only if every chosen cell clearly beats the alternatives in its row
    conf = all(M[x, mp[x]] > 0 and M[x, mp[x]] >= max(M[x, y] for y in range(4) if y != mp[x]) + 0.15 for x in range(4))
    return [int(mp[x]) for x in range(4)], conf


# ------------------------------------------------------------------ build
def build(en_pdf, hi_pdf, work, log=print, dpi=150):
    """Returns {'questions': [...], 'report': {...}} for the backbone (English) sheet."""
    os.makedirs(work, exist_ok=True)
    A = S.read_sheet(en_pdf)
    B = S.read_sheet(hi_pdf) if hi_pdf else None
    rep = {'backbone': len(A['questions']), 'other': len(B['questions']) if B else 0}
    is_fig = lambda q: bool(q['figs']) or q['gap'] > 30

    # OCR every Hindi-shown question of both sheets (the text layer of Hindi is broken)
    ocrA = H.ocr_sheet(en_pdf, A, [i for i, q in enumerate(A['questions']) if q['lang'] == 'hi'], os.path.join(work, 'ocrA')) if H.have_hindi_ocr() else {}
    ocrB = H.ocr_sheet(hi_pdf, B, [j for j, q in enumerate(B['questions']) if q['lang'] == 'hi'], os.path.join(work, 'ocrB')) if (B and H.have_hindi_ocr()) else {}
    hiA = {i: hindi_of(A, i, ocrA) for i in ocrA}; hiB = {j: hindi_of(B, j, ocrB) for j in ocrB} if B else {}

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
    pairs = {}
    if B:
        b_txt = en_space(B, hiB)
        pairs = match_sheets(A, B, a_txt, b_txt, log)

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
            strong = m[1] >= 0.35 and m[2] >= 0.05
            if fig:
                ok = m[1] >= 0.45 and m[2] >= 0.08
                if ok:
                    if qb['lang'] == 'hi' and rec['hi'] is None: rec['hi'] = (hiB.get(m[0]) or {}).get('text')
                    if qb['lang'] == 'en' and rec['en'] is None: rec['en'] = qb['text']
                    rec['twin_fig'] = m[0]
                stats['fig_pair_ok' if ok else 'fig_pair_weak'] += 1
            else:
                # map options of B onto A and require the official answers to agree
                a_lay = [qa['opts'].get(str(k + 1)) or '' for k in range(4)]
                b_lay = [qb['opts'].get(str(k + 1)) or '' for k in range(4)]
                a_en = rec['en_opts'] if qa['lang'] == 'en' else tr([x or '' for x in rec['hi_opts']])
                hb = hiB.get(m[0]) if qb['lang'] == 'hi' else None
                b_en = b_lay if qb['lang'] == 'en' else tr([x or '' for x in (hb or {'opts': [''] * 4})['opts']])
                omap, conf = map_options(a_en, b_en, a_lay, b_lay)
                agree = qb['answer_pos'] is not None and qa['answer_pos'] is not None and omap[qa['answer_pos']] == qb['answer_pos']
                if strong and conf and agree:
                    if qb['lang'] == 'hi' and hb and rec['hi'] is None:
                        rec['hi'] = hb['text']; rec['hi_opts'] = [hb['opts'][omap[k]] for k in range(4)]
                    if qb['lang'] == 'en' and rec['en'] is None:
                        rec['en'] = qb['text']; rec['en_opts'] = [qb['opts'].get(str(omap[k] + 1)) for k in range(4)]
                    rec['checks']['twin'] = 'answers agree'
                    stats['pair_verified'] += 1
                else:
                    rec['checks']['twin'] = f'not used (score {m[1]:.2f}, options {"ok" if conf else "unsure"}, answer {"same" if agree else "differs"})'
                    stats['pair_rejected'] += 1
        # --- Hindi sanity: numbers / codes of the English must survive
        if rec['hi'] and rec['en'] and not fig and not H.stem_valid(rec['hi'], rec['en']):
            rec['checks']['hindi'] = 'numbers/codes differ from English'; stats['hindi_rejected'] += 1; rec['hi'] = None; rec['hi_opts'] = [None] * 4
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
        r['complete_hi'] = bool(r['img_hi'] or (r['hi'] and all(r['hi_opts'])) or (r['fig'] and r['img'] and r['hi']))
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
    return {'questions': out, 'report': rep, 'A': A, 'B': B}
