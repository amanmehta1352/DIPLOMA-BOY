"""Syllabus Reader: reads the official syllabus PDF the watcher found, and turns it into units per subject.

   python3 robots/syllabus/reader.py --state STATE.json --out OUT_DIR

Only the PDFs labelled as syllabus are read. Output: syllabus_units.json (subject -> units with title and topic text).
Needs pdfplumber (installed in the workflow). No AI, no secrets.
"""
import argparse, json, os, re, sys, tempfile, urllib.request

SUBJECTS = {'PHYSICS', 'CHEMISTRY', 'BIOLOGY', 'BOTANY', 'ZOOLOGY', 'MATHEMATICS'}
UNIT = re.compile(r'^UNIT\s*-?\s*([0-9IVX]+)\s*[:.\-]\s*(.+)$', re.I)


def parse_units(text):
    """Pure: text of a syllabus PDF -> [{'subject', 'unit', 'title', 'body'}]."""
    out, subject, cur = [], None, None
    for raw in text.splitlines():
        line = raw.strip()
        if not line: continue
        up = line.upper()
        if up in SUBJECTS:
            subject, cur = up, None
            continue
        m = UNIT.match(line)
        if m and subject:
            cur = {'subject': subject, 'unit': m.group(1), 'title': m.group(2).strip(), 'body': ''}
            out.append(cur)
            continue
        if cur is None or re.fullmatch(r'\d+|Page \d+.*', line): continue   # footer / page numbers
        if re.match(r'^(Annexure|PUBLIC NOTICE|Encl|Government|National Medical|Date:)', line): cur = None; continue
        cur['body'] = (cur['body'] + ' ' + line).strip()
    return out


def read_pdf(url):
    import pdfplumber
    req = urllib.request.Request(url, headers={'User-Agent': 'diploma-boy-syllabus-reader/1.0'})
    with urllib.request.urlopen(req, timeout=90) as r: data = r.read()
    with tempfile.NamedTemporaryFile(suffix='.pdf', delete=False) as f: f.write(data); name = f.name
    try:
        with pdfplumber.open(name) as p: return '\n'.join((pg.extract_text() or '') for pg in p.pages)
    finally: os.unlink(name)


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--state', required=True); ap.add_argument('--out', default='out'); a = ap.parse_args()
    st = json.load(open(a.state, encoding='utf-8')) if os.path.exists(a.state) else {}
    docs = []
    for src, items in (st.get('documents') or {}).items():
        for d in items:
            if re.search(r'syllab', d.get('label', ''), re.I) and d['url'].lower().endswith('.pdf'):
                docs.append({'source': src, **d})
    # one current syllabus per source: prefer the document titled "Syllabus for ...", never mix old and new
    preferred = [d for d in docs if re.match(r'syllabus for', d.get('label', ''), re.I)]
    seen, pick = set(), []
    for d in (preferred or docs):
        if d['source'] not in seen: seen.add(d['source']); pick.append(d)
    result = {'schema': 1, 'documents': []}
    for d in pick:
        try:
            units = parse_units(read_pdf(d['url']))
            result['documents'].append({'source': d['source'], 'label': d['label'], 'url': d['url'], 'units': units})
            print(f"read {d['label'][:60]!r}: {len(units)} units")
        except Exception as e:
            result['documents'].append({'source': d['source'], 'label': d['label'], 'url': d['url'], 'error': type(e).__name__ + ': ' + str(e)[:160]})
            print('failed', d['label'][:60], type(e).__name__)
    os.makedirs(a.out, exist_ok=True)
    json.dump(result, open(os.path.join(a.out, 'syllabus_units.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)


if __name__ == '__main__':
    main()
