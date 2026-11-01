"""Copyright check (basic): share of an atom's 3-word sequences that also appear in reference textbook text.

   python3 robots/copyright/ngram.py --count 10 --level class_9_10 --out out

Reference: NCERT chapter PDFs listed in references.json (Hindi and English), downloaded on the GitHub runner.
Score = (atom trigrams found in the reference) / (atom trigrams). Above THRESHOLD (20%) = flagged for review.
Read-only: writes out/copyright_report.json, never changes the database. Short atoms (< MIN_TRIGRAMS) are skipped, not scored.
Env: SUPABASE_SECRET_KEY (read atoms). Universal facts and formulas (F = m × a) are short and do not drive the score.
"""
import argparse, json, os, re, sys, tempfile, time, urllib.request
HERE = os.path.dirname(os.path.abspath(__file__))
SB = os.environ.get('SUPABASE_URL', 'https://wobmtlcpszcntczkebtt.supabase.co').rstrip('/')
KEY = os.environ.get('SUPABASE_SECRET_KEY', '').strip()
THRESHOLD = 0.20
MIN_TRIGRAMS = 15
WORD = re.compile(r'[ऀ-ॿ]+|[a-z]+')


def words(text):
    """Pure: lowercase Hindi/English words; digits and symbols dropped."""
    return WORD.findall((text or '').lower())


def trigrams(text):
    w = words(text)
    return {tuple(w[i:i + 3]) for i in range(len(w) - 2)}


def score(atom_text, ref_set):
    """Pure: (fraction of the atom's trigrams that are in the reference, number of atom trigrams)."""
    t = trigrams(atom_text)
    if not t: return 0.0, 0
    return len(t & ref_set) / len(t), len(t)


def flatten(x):
    if isinstance(x, str): return x
    if isinstance(x, list): return ' '.join(flatten(i) for i in x)
    if isinstance(x, dict): return ' '.join(flatten(v) for v in x.values())
    return ''


def pdf_text(url):
    import pdfplumber
    last = None
    for attempt in range(3):
        try:
            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0 (diploma-boy-copyright-check)'})
            with urllib.request.urlopen(req, timeout=120) as r: data = r.read()
            with tempfile.NamedTemporaryFile(suffix='.pdf', delete=False) as f:
                f.write(data); name = f.name
            try:
                with pdfplumber.open(name) as p: return '\n'.join((pg.extract_text() or '') for pg in p.pages)
            finally: os.unlink(name)
        except Exception as e:
            last = e
            if attempt < 2: time.sleep(15 * (attempt + 1))
    raise last


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--count', type=int, default=10); ap.add_argument('--level', default='class_9_10'); ap.add_argument('--out', default='out'); a = ap.parse_args()
    refs = json.load(open(os.path.join(HERE, 'references.json'), encoding='utf-8'))['documents']
    ref_set, got, failed = set(), [], []
    for r in refs:
        try:
            t = pdf_text(r['url']); ref_set |= trigrams(t); got.append(r['id'])
        except Exception as e:
            failed.append({'id': r['id'], 'error': type(e).__name__ + ': ' + str(e)[:120]})
    h = {'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Accept-Profile': 'mtb'}
    url = f"{SB}/rest/v1/atoms?select=id,chapter_id,atom_type,body&status=eq.published&archived=eq.false&level_id=eq.{a.level}&atom_type=in.(concept,example)&order=id&limit={a.count}"
    atoms = json.loads(urllib.request.urlopen(urllib.request.Request(url, headers=h), timeout=60).read())
    rows = []
    for x in atoms:
        s, n = score(flatten(x.get('body')), ref_set)
        rows.append({'id': x['id'], 'chapter': x['chapter_id'], 'type': x['atom_type'], 'trigrams': n,
                     'score': round(s, 3), 'flag': (n >= MIN_TRIGRAMS and s > THRESHOLD), 'skipped': n < MIN_TRIGRAMS})
    os.makedirs(a.out, exist_ok=True)
    rep = {'level': a.level, 'threshold': THRESHOLD, 'reference_docs': got, 'reference_failed': failed,
           'reference_trigrams': len(ref_set), 'checked': len(rows), 'flagged': sum(r['flag'] for r in rows), 'atoms': rows}
    json.dump(rep, open(os.path.join(a.out, 'copyright_report.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(f"reference docs {len(got)} (failed {len(failed)}), trigrams {len(ref_set)}; atoms {len(rows)}, flagged {rep['flagged']}")
    if not got: sys.exit('no reference text could be downloaded: scores would be meaningless')


if __name__ == '__main__':
    main()
