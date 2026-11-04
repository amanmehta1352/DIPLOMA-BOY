"""Syllabus Robot: teaches the chapter robot the official scope of every chapter of a subject, from the official syllabus PDF.

   python3 syllabus_robot.py "Class 10, CBSE 2026-27, Science"   [--catalog catalog.json]

1. downloads the subject's official syllabus PDF (source URL already on file) and reads its text (pdftotext)
2. a free AI lists, per chapter, the syllabus lines EXACTLY as printed + short key phrases (English, and Hindi as a check aid)
3. GROUNDING: every syllabus line and every English key phrase must be found in the PDF text itself; anything not found is dropped.
   A chapter becomes scope_verified only if all of its lines were found. AI agreement alone never verifies anything.
4. app mapping: each chapter is matched to the app catalog chapter (level class_9_10) by name; only a single clear match is kept
Output: an updated syllabus file (SYLLABUS_OUT, default out/syllabus_<class>.json). Never writes the database.
"""
import json, os, re, subprocess, sys, tempfile, unicodedata
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import job as J
from common import ProviderUnavailable, parse_json

PROMPT = ('Below is the text of an official school syllabus PDF for {subject}. For EACH of these chapters: {chapters}\n'
          'list the syllabus lines that the PDF prints for that chapter, copied EXACTLY as printed (same words), split into separate items '
          'where the PDF separates them by commas, semicolons or full stops. For each item also give 1-3 short key phrases (2-4 words each) '
          'copied from that same item, and the same key phrases in standard NCERT Hindi.\n'
          'Reply ONLY with JSON: {{"chapters": [{{"no": 1, "items": [{{"text": "...", "key_phrases": ["..."], "key_phrases_hi": ["..."]}}]}}]}}\n'
          'If the PDF prints nothing for a chapter, give "items": [].\n\nPDF TEXT:\n{pdf}')


def norm(t):
    t = unicodedata.normalize('NFKC', t).lower().replace('’', "'").replace('‘', "'").replace('–', '-').replace('—', '-')
    return re.sub(r'[^a-z0-9ऀ-ॿ]+', ' ', t).strip()


def pdf_text(url, fetch):
    s, b = fetch(url)
    if s != 200 or not b.startswith(b'%PDF'): raise ProviderUnavailable('syllabus_source', 'permanent', f'PDF not readable (HTTP {s})')
    with tempfile.NamedTemporaryFile(suffix='.pdf') as f:
        f.write(b); f.flush()
        r = subprocess.run(['pdftotext', '-layout', f.name, '-'], capture_output=True, text=True, timeout=60)
        t = r.stdout
        if len(t.strip()) < 200:
            try:
                import pypdf
                t = '\n'.join((pg.extract_text() or '') for pg in pypdf.PdfReader(f.name).pages)
            except Exception:
                pass
        if len(t.strip()) < 200:
            raise ProviderUnavailable('syllabus_source', 'permanent', f'PDF has no readable text layer ({len(b)} bytes; pdftotext: {r.stderr[:160]})')
        return t


def name_tokens(t):
    stop = {'and', 'the', 'of', 'its', 'in', 'a', 'an', 'to', 'our'}
    return {w for w in norm(t.replace('&', ' and ')).split() if w not in stop}


def map_to_app(ch, catalog_chapters):
    a = name_tokens(ch['name_en'])
    best = []
    for c in catalog_chapters:
        b = name_tokens(c['en']); k = len(a & b)
        j = k / max(1, min(len(a), len(b))) if (k >= 2 or (k == 1 and min(len(a), len(b)) == 1)) else 0   # one shared word is enough only for one-word names
        best.append((j, c))
    best.sort(key=lambda x: -x[0])
    if best and best[0][0] >= 0.5 and (len(best) == 1 or best[1][0] < best[0][0]):
        c = best[0][1]; return {'level_id': 'class_9_10', 'chapter_id': c['id'], 'catalog_slug': c.get('slug'), 'catalog_en': c['en'], 'match': round(best[0][0], 2)}
    return None


def run(command, P, fetch, catalog, out_path):
    req = J.parse_command(command)
    syl = json.load(open(os.environ.get('SYLLABUS_FILE') or J.SYLLABUS, encoding='utf-8'))
    key = (req['subject'] or '').lower().split('(')[0].strip()
    subs = [s for s in syl['subjects'] if key and key in (s['name_en'].lower().split('(')[0].strip(), s['slug'], s['slug'].split('-', 1)[-1])]
    if len(subs) != 1: return {'state': 'blocked', 'reason': f"subject '{req['subject']}' not found"}
    s = subs[0]
    if not s.get('source'): return {'state': 'blocked', 'reason': f"{s['slug']}: no official syllabus PDF on file"}
    text = pdf_text(s['source'], fetch); nt = norm(text)
    todo = [c for c in s['chapters'] if not c.get('scope_verified')]
    report = {'subject': s['slug'], 'source': s['source'], 'pdf_chars': len(text), 'chapters': []}
    if todo:
        prompt = PROMPT.format(subject=s['name_en'], chapters='; '.join(f"{c['no']}. {c['name_en']}" for c in todo), pdf=text[:30000])
        raw, prov, model = P.extract(prompt)
        report['extractor'] = f'{prov} {model}'
        got = {x.get('no'): x for x in (parse_json(raw).get('chapters') or [])}
        for c in todo:
            items, dropped = [], []
            for i, it in enumerate((got.get(c['no']) or {}).get('items') or []):
                t = str(it.get('text', '')).strip()
                kp = [k for k in it.get('key_phrases') or [] if norm(k) and norm(k) in norm(t) and norm(k) in nt]
                hi = (it.get('key_phrases_hi') or [])[:len(it.get('key_phrases') or [])]
                if t and norm(t) in nt and kp:
                    hi_ok = [hi[(it.get('key_phrases') or []).index(k)] if (it.get('key_phrases') or []).index(k) < len(hi) else '' for k in kp]
                    items.append({'id': f"i{i + 1}", 'text': t, 'need_any': [[k] for k in kp], 'need_any_hi': [[h] if h else [] for h in hi_ok]})
                else:
                    dropped.append(t[:80])
            c['scope_items'] = items
            c['scope_verified'] = bool(items) and not dropped
            c['scope_source'] = s['source']; c['scope_read_on'] = J.now()[:10]; c['scope_read_by'] = 'syllabus robot (grounded in PDF text)'
            c.setdefault('units', []); c.setdefault('avoid', '')
            report['chapters'].append({'no': c['no'], 'name': c['name_en'], 'items': len(items), 'dropped': dropped, 'verified': c['scope_verified']})
    for c in s['chapters']:
        if not c.get('app') and catalog is not None:
            m = map_to_app(c, catalog)
            if m: c['app'] = m
    report['mapped'] = [(c['no'], c['name_en'], (c.get('app') or {}).get('chapter_id')) for c in s['chapters']]
    json.dump(syl, open(out_path, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    report['state'] = 'done'
    return report


if __name__ == '__main__':
    import providers, websearch
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    cat = None
    if '--catalog' in sys.argv:
        raw = json.load(open(sys.argv[sys.argv.index('--catalog') + 1]))
        cat = [ch for subj in raw for ch in subj.get('chapters', [])]
    out = os.environ.get('SYLLABUS_OUT', 'out/syllabus_class10.json'); os.makedirs(os.path.dirname(out) or '.', exist_ok=True)
    rep = run(args[0], providers.Real(), websearch.fetch, cat, out)
    print(json.dumps(rep, ensure_ascii=False, indent=1))
