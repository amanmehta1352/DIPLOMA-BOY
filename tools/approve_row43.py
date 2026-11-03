"""One-time: approve class_9_10 / 880 (Electricity, row 43) via the existing service-role RPCs (direct table access is 403).
draft_save with the SAME data already stored by step B, status 'approved', checks + human_review. Prints no secrets."""
import json, os, sys, urllib.request, urllib.error
SB = 'https://wobmtlcpszcntczkebtt.supabase.co'; KEY = os.environ['SUPABASE_SECRET_KEY'].strip()
H = {'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Accept-Profile': 'mtb', 'Content-Profile': 'mtb', 'Content-Type': 'application/json'}
os.makedirs('out', exist_ok=True)
def rpc(n, a):
    r = urllib.request.Request(f'{SB}/rest/v1/rpc/{n}', json.dumps(a).encode(), H, method='POST')
    try:
        with urllib.request.urlopen(r, timeout=60) as x: return x.status, json.loads(x.read() or b'null')
    except urllib.error.HTTPError as e: return e.code, e.read().decode()[:300]
def done(res, code):
    json.dump(res, open('out/result.json', 'w'), ensure_ascii=False, indent=1); print(json.dumps(res, ensure_ascii=False)); sys.exit(code)
s, st = rpc('draft_status', {})
if s != 200: done({'result': 'STOP', 'why': f'draft_status HTTP {s}: {st}'}, 1)
mine = [r for r in st if r['level_id'] == 'class_9_10' and r['chapter_id'] == 880]
before = sorted((r['level_id'], r['chapter_id'], r['status']) for r in st if not (r['level_id'] == 'class_9_10' and r['chapter_id'] == 880))
if len(mine) != 1 or mine[0]['status'] != 'draft': done({'result': 'STOP', 'why': f'expected one draft row, got {mine}'}, 1)
p = json.load(open('tools/row43_payload.json'))['p']
assert p['level_id'] == 'class_9_10' and p['chapter_id'] == 880 and p['checks']['job_id'] == '8633a9e97e13bf92' and p['checks']['commit'] == 'ed276fa'
p['status'] = 'approved'
p['checks']['human_review'] = {'reviewer': 'Aman', 'decision': 'APPROVED', 'reviewed_at': '2026-11-03T14:08:00Z',
    'reviewed_at_note': 'owner approval instruction time, IST 19:38', 'job_id': '8633a9e97e13bf92', 'branch': 'chapter-job-electricity-run-4',
    'commit': 'ed276fa', 'hindi_title_source': 'third_party (not verified)', 'copyright_note': '19.22% automatic metric; not legal clearance',
    'applied_by': 'workflow chapter-job-electricity-approve-2 via draft_save'}
s, r = rpc('draft_save', {'p': p})
if s != 200: done({'result': 'FAILED', 'why': f'draft_save HTTP {s}: {r}'}, 1)
s, st2 = rpc('draft_status', {})
after_mine = [x for x in st2 if x['level_id'] == 'class_9_10' and x['chapter_id'] == 880]
after = sorted((x['level_id'], x['chapter_id'], x['status']) for x in st2 if not (x['level_id'] == 'class_9_10' and x['chapter_id'] == 880))
s3, book = rpc('get_chapter_book', {'p_level': 'class_9_10', 'p_chapter': 880})
same = isinstance(book, dict) and book.get('data') == p['data']
done({'result': 'APPROVED' if after_mine and after_mine[0]['status'] == 'approved' else 'NOT_APPROVED', 'row': after_mine,
      'other_rows_unchanged': before == after, 'get_chapter_book_status': book.get('status') if isinstance(book, dict) else None,
      'live_data_equals_reviewed_payload': same}, 0)
