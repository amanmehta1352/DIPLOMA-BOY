"""One-time: approve mtb.chapter_drafts row 43 (class_9_10 / 880 Electricity) after guards. Owner-approved 2026-11-03 19:40 IST.
Writes only that row. Prints no secrets. Result -> out/result.json"""
import json, os, sys, urllib.request, urllib.error
SB = 'https://wobmtlcpszcntczkebtt.supabase.co'
KEY = os.environ['SUPABASE_SECRET_KEY'].strip()
H = {'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Accept-Profile': 'mtb', 'Content-Profile': 'mtb', 'Content-Type': 'application/json'}
F = 'id=eq.43&level_id=eq.class_9_10&chapter_id=eq.880'
os.makedirs('out', exist_ok=True)

def req(method, url, body=None, extra=None):
    r = urllib.request.Request(url, data=None if body is None else json.dumps(body).encode(), headers=dict(H, **(extra or {})), method=method)
    try:
        with urllib.request.urlopen(r, timeout=60) as x: return x.status, json.loads(x.read() or b'null')
    except urllib.error.HTTPError as e: return e.code, e.read().decode()[:300]

def done(res, code):
    json.dump(res, open('out/result.json', 'w'), ensure_ascii=False, indent=1); print(json.dumps(res, ensure_ascii=False)); sys.exit(code)

s, rows = req('GET', f'{SB}/rest/v1/chapter_drafts?{F}&select=id,level_id,chapter_id,status,checks')
if s != 200 or not isinstance(rows, list) or len(rows) != 1: done({'result': 'STOP', 'why': f'read failed or not exactly 1 row (HTTP {s})'}, 1)
row = rows[0]; c = row['checks'] or {}
if row['status'] != 'draft': done({'result': 'STOP', 'why': f"status is {row['status']}, not draft"}, 1)
if c.get('job_id') != '8633a9e97e13bf92' or c.get('commit') != 'ed276fa': done({'result': 'STOP', 'why': 'job_id/commit mismatch'}, 1)
c['human_review'] = {'reviewer': 'Aman', 'decision': 'APPROVED', 'reviewed_at': '2026-11-03T14:08:00Z',
                     'reviewed_at_note': 'owner approval instruction time, IST 19:38', 'job_id': '8633a9e97e13bf92',
                     'branch': 'chapter-job-electricity-run-4', 'commit': 'ed276fa', 'hindi_title_source': 'third_party (not verified)',
                     'copyright_note': '19.22% automatic metric; not legal clearance', 'applied_by': 'workflow chapter-job-electricity-approve'}
s, out = req('PATCH', f'{SB}/rest/v1/chapter_drafts?{F}&status=eq.draft', {'status': 'approved', 'checks': c, 'updated_at': __import__('datetime').datetime.now(__import__('datetime').timezone.utc).isoformat()},
             {'Prefer': 'return=representation'})
if s != 200 or not isinstance(out, list) or len(out) != 1: done({'result': 'FAILED', 'why': f'update HTTP {s}: {out}' if not isinstance(out, list) else f'updated {len(out)} rows'}, 1)
s2, book = req('POST', f'{SB}/rest/v1/rpc/get_chapter_book', {'p_level': 'class_9_10', 'p_chapter': 880})
done({'result': 'APPROVED', 'row': {k: out[0][k] for k in ('id', 'level_id', 'chapter_id', 'status')},
      'reviewer': out[0]['checks']['human_review']['reviewer'],
      'get_chapter_book': {'http': s2, 'status': (book or {}).get('status') if isinstance(book, dict) else None,
                           'teach': len(((book or {}).get('data') or {}).get('teach') or []) if isinstance(book, dict) else None}}, 0)
