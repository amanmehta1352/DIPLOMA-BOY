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
    import time
    data, last = None, None
    for attempt in range(3):          # official sites are often slow or drop the first connection
        try:
            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0 (diploma-boy-syllabus-reader)'})
            with urllib.request.urlopen(req, timeout=150) as r: data = r.read()
            break
        except Exception as e:
            last = e
            if attempt < 2: time.sleep(20 * (attempt + 1))   # no wait after the last try
    if data is None: raise last
    with tempfile.NamedTemporaryFile(suffix='.pdf', delete=False) as f:
        f.write(data); name = f.name
    try:
        with pdfplumber.open(name) as p: return '\n'.join((pg.extract_text() or '') for pg in p.pages)
    finally: os.unlink(name)


def html_text(raw):
    """Pure: HTML page -> visible text (scripts, styles and tags removed)."""
    t = re.sub(r'(?is)<(script|style|noscript|nav|footer|header)[^>]*>.*?</\1>', ' ', raw)
    t = re.sub(r'(?i)<br\s*/?>|</(p|li|h[1-6]|tr|div)>', '\n', t)
    t = re.sub(r'(?s)<[^>]+>', ' ', t)
    import html as H
    return H.unescape(t)


def fetch_html(url):
    import time
    last = None
    for attempt in range(3):
        try:
            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0 (diploma-boy-syllabus-reader)'})
            with urllib.request.urlopen(req, timeout=120) as r: return r.read().decode('utf8', 'ignore')
        except Exception as e:
            last = e
            if attempt < 2: time.sleep(15 * (attempt + 1))
    raise last


def text_lines(text, limit=600):
    """Generic: keep meaningful lines (for syllabus documents that are not 'UNIT n' style). Pure."""
    out = []
    for raw in text.splitlines():
        line = re.sub(r'\s+', ' ', raw).strip()
        if len(line) < 12 or re.fullmatch(r'[\d\s.,/-]+', line): continue
        out.append(line)
        if len(out) >= limit: break
    return out


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
    # explicit lists, read every day: official PDFs and third-party syllabus pages
    here = os.path.dirname(os.path.abspath(__file__))
    for fname in ('official_pdfs.json', 'third_party.json'):
        try:
            for o in json.load(open(os.path.join(here, fname), encoding='utf-8'))['documents']:
                pick.append({'source': o['id'], 'label': o['exam'] + ' (' + o.get('year', '') + ')' if o.get('year') else o['exam'], 'url': o['url'], 'parser': o.get('parser', 'text'), 'level': o.get('level')})
        except Exception as e: print(fname, 'not read:', type(e).__name__)
    result = {'schema': 1, 'documents': []}
    for d in pick:
        if d.get('parser') == 'html':
            try:
                lines = text_lines(html_text(fetch_html(d['url'])))
                result['documents'].append({'source': d['source'], 'label': d['label'], 'url': d['url'], 'level': d.get('level'), 'lines': lines})
                print(f"read page {d['label'][:60]!r}: {len(lines)} lines")
            except Exception as e:
                result['documents'].append({'source': d['source'], 'label': d['label'], 'url': d['url'], 'error': type(e).__name__ + ': ' + str(e)[:160]})
                print('failed page', d['label'][:60], type(e).__name__)
            continue
        try:
            txt = read_pdf(d['url'])
            if d.get('parser') == 'text':
                result['documents'].append({'source': d['source'], 'label': d['label'], 'url': d['url'], 'level': d.get('level'), 'lines': text_lines(txt)})
                print(f"read {d['label'][:60]!r}: {len(text_lines(txt))} lines")
            else:
                units = parse_units(txt)
                result['documents'].append({'source': d['source'], 'label': d['label'], 'url': d['url'], 'units': units})
                print(f"read {d['label'][:60]!r}: {len(units)} units")
        except Exception as e:
            result['documents'].append({'source': d['source'], 'label': d['label'], 'url': d['url'], 'error': type(e).__name__ + ': ' + str(e)[:160]})
            print('failed', d['label'][:60], type(e).__name__)
    os.makedirs(a.out, exist_ok=True)
    json.dump(result, open(os.path.join(a.out, 'syllabus_units.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)


if __name__ == '__main__':
    main()
