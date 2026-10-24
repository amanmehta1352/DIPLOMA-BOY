"""Hindi sample (read-only). Writes NOTHING to the database.
  python3 sample.py fetch rows.json N      (needs SUPABASE_SECRET_KEY: reads N English-only live questions)
  python3 sample.py translate rows.json OUT.json   (NO key in environment: translation only)"""
import json, os, sys, urllib.request
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'import'))

SB = os.environ.get('SUPABASE_URL', 'https://wobmtlcpszcntczkebtt.supabase.co').rstrip('/')

def fetch(limit):
    key = os.environ.get('SUPABASE_SECRET_KEY', '').strip()
    if not key: raise SystemExit('SUPABASE_SECRET_KEY missing')
    q = f"{SB}/rest/v1/questions?select=id,status,stem&stem->>hi_note=eq.english_only&status=eq.published&order=id&limit={int(limit)}"
    h = {'apikey': key, 'Authorization': 'Bearer ' + key, 'Accept-Profile': 'mtb'}
    with urllib.request.urlopen(urllib.request.Request(q, headers=h), timeout=60) as r:
        return json.loads(r.read())

if __name__ == '__main__':
    mode = sys.argv[1]
    if mode == 'fetch':
        rows = fetch(sys.argv[3])
        json.dump([{'id': r['id'], 'en': (r['stem'] or {}).get('en') or ''} for r in rows], open(sys.argv[2], 'w'), ensure_ascii=False)
        print('fetched', len(rows))
    elif mode == 'translate':
        import mt_enhi
        rows = json.load(open(sys.argv[2]))
        hi = mt_enhi.translate([r['en'] for r in rows])
        res = [{'id': r['id'], 'en': r['en'], 'hi_mt': h, 'changed': h != r['en']} for r, h in zip(rows, hi)]
        json.dump({'mode': 'sample', 'model': mt_enhi.MODEL, 'count': len(res), 'rows': res}, open(sys.argv[3], 'w'), ensure_ascii=False, indent=1)
        print('sample rows', len(res), 'translated', sum(1 for x in res if x['changed']))
    else:
        raise SystemExit('mode must be fetch or translate')
