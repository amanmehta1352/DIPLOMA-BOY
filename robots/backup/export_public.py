"""Daily outside copy of everything students can see + a keep-alive for the free Supabase project.
Uses only the PUBLISHABLE key (already public in index.html), so it needs no secrets and can never read drafts.
Drafts/hidden rows stay in the server's own nightly backup (migration 0005).
Run: python robots/backup/export_public.py [outdir]   -> writes diploma-boy-public-YYYYMMDD.json.gz and prints a summary."""
import gzip, json, sys, time, datetime, urllib.request, urllib.error

URL = 'https://wobmtlcpszcntczkebtt.supabase.co/rest/v1/'
KEY = 'sb_publishable_7ZZEUDULfYaMHSeLIxfluQ_fZWSCi8R'
TABLES = {  # table -> (query, minimum rows that must exist, else the run FAILS and GitHub emails the owner)
    'branches': ('select=*', 1), 'exams': ('select=*', 1), 'exam_branches': ('select=*', 1), 'exam_sections': ('select=*', 1),
    'subjects': ('select=*', 1), 'topics': ('select=*', 1), 'sources': ('select=*', 1),
    'questions': ('select=*&status=eq.published&order=id', 1000)}

def get(path, lo, hi):
    last = None
    for attempt in range(4):
        try:
            req = urllib.request.Request(URL + path, headers={'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Accept-Profile': 'mtb',
                                                              'Range-Unit': 'items', 'Range': f'{lo}-{hi}'})
            with urllib.request.urlopen(req, timeout=60) as r:
                return json.load(r)
        except (urllib.error.URLError, TimeoutError, ConnectionError) as e:
            last = e; time.sleep(3 * (attempt + 1))
    raise SystemExit(f'FAILED reading {path}: {last}')

def main():
    out = sys.argv[1] if len(sys.argv) > 1 else '.'
    data, summary = {}, {}
    for t, (q, least) in TABLES.items():
        rows, lo = [], 0
        while True:
            page = get(f'{t}?{q}', lo, lo + 999)
            rows += page
            if len(page) < 1000: break
            lo += 1000
        if len(rows) < least: raise SystemExit(f'FAILED: {t} has {len(rows)} rows, expected at least {least}')
        data[t] = rows; summary[t] = len(rows)
    name = f"{out}/diploma-boy-public-{datetime.date.today():%Y%m%d}.json.gz"
    with gzip.open(name, 'wt', encoding='utf-8') as f:
        json.dump({'taken_at': datetime.datetime.now(datetime.timezone.utc).isoformat(), 'counts': summary, 'data': data}, f, ensure_ascii=False)
    print(json.dumps({'file': name, 'counts': summary}, ensure_ascii=False))

if __name__ == '__main__':
    main()
