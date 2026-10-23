"""Hindi sample (read-only): picks N English-only live/draft questions, translates the English stem,
writes a JSON file for review. Writes NOTHING to the database. Usage: python3 sample.py OUT.json N
Env: SUPABASE_SECRET_KEY (service role, read only in this script)."""
import json, os, sys, urllib.request
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'import'))
import mt_enhi

SB = os.environ.get('SUPABASE_URL', 'https://wobmtlcpszcntczkebtt.supabase.co').rstrip('/')
KEY = os.environ.get('SUPABASE_SECRET_KEY', '').strip()

def fetch(limit):
    q = f"{SB}/rest/v1/questions?select=id,status,stem&stem->>hi_note=eq.english_only&status=eq.published&order=id&limit={limit}"
    h = {'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Accept-Profile': 'mtb'}
    with urllib.request.urlopen(urllib.request.Request(q, headers=h), timeout=60) as r:
        return json.loads(r.read())

if __name__ == '__main__':
    out, n = sys.argv[1], int(sys.argv[2])
    rows = fetch(n)
    en = [(r['stem'] or {}).get('en') or '' for r in rows]
    hi = mt_enhi.translate(en)
    res = [{'id': r['id'], 'en': e, 'hi_mt': h, 'changed': h != e} for r, e, h in zip(rows, en, hi)]
    json.dump({'mode': 'sample', 'model': mt_enhi.MODEL, 'count': len(res), 'rows': res}, open(out, 'w'), ensure_ascii=False, indent=1)
    print('sample rows', len(res), 'translated', sum(1 for x in res if x['changed']))
