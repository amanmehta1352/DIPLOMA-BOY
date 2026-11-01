"""Backup of draft and hidden questions (and their counts) before any purge. Read-only.

   python3 robots/purge/backup.py --out out

Writes out/questions_all.json.gz (all columns) and out/backup_counts.json.
Env: SUPABASE_SECRET_KEY (never printed). Refuses to continue if the counts do not match the database.
"""
import argparse, gzip, json, os, urllib.request, urllib.error
SB = os.environ.get('SUPABASE_URL', 'https://wobmtlcpszcntczkebtt.supabase.co').rstrip('/')
KEY = os.environ.get('SUPABASE_SECRET_KEY', '').strip()
PAGE = 1000

def get(path):
    h = {'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Accept-Profile': 'mtb', 'Prefer': 'count=exact'}
    req = urllib.request.Request(f'{SB}/rest/v1/{path}', headers=h)
    with urllib.request.urlopen(req, timeout=120) as r:
        return json.loads(r.read()), r.headers.get('Content-Range', '')

def fetch_all(status):
    rows, off = [], 0
    while True:
        data, _ = get(f'questions?select=*&status=eq.{status}&order=id&limit={PAGE}&offset={off}')
        rows += data
        if len(data) < PAGE: return rows
        off += PAGE

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--out', default='out'); a = ap.parse_args()
    if not KEY: raise SystemExit('SUPABASE_SECRET_KEY missing')
    os.makedirs(a.out, exist_ok=True)
    statuses = ('draft', 'hidden', 'published')          # full backup: every question
    rows = {s: fetch_all(s) for s in statuses}
    counts = {s: len(v) for s, v in rows.items()}
    expect = {}
    for s in statuses:
        _, cr = get(f'questions?select=id&status=eq.{s}&limit=1')
        expect[s] = int(cr.split('/')[-1]) if '/' in cr and cr.split('/')[-1].isdigit() else None
    ok = all(expect[s] is None or expect[s] == counts[s] for s in counts)
    allrows = [r for s in statuses for r in rows[s]]
    with gzip.open(os.path.join(a.out, 'questions_all.json.gz'), 'wt', encoding='utf-8') as f:
        json.dump(allrows, f, ensure_ascii=False)
    json.dump({'counts': counts, 'database_counts': expect, 'match': ok}, open(os.path.join(a.out, 'backup_counts.json'), 'w'), indent=1)
    print('backup', counts, 'database', expect, 'match', ok)
    if not ok: raise SystemExit('count mismatch: nothing should be deleted')

if __name__ == '__main__':
    main()
