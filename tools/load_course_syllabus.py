"""Sync content/course-syllabus/syllabus.json into mtb.course_subjects via rpc course_syllabus_sync (migration 0174).
Each call carries whole courses, so a course in the file is replaced exactly: new subjects added, changed ones updated,
subjects no longer in the file removed (kept in mtb.bk_0173_course_subjects). Courses not in the file are never touched.
Never touches chapter content."""
import json, os, urllib.request
URL = os.environ.get('SUPABASE_URL', 'https://wobmtlcpszcntczkebtt.supabase.co').rstrip('/')
KEY = os.environ['SUPABASE_SECRET_KEY']
rows = json.load(open('content/course-syllabus/syllabus.json', encoding='utf-8'))
H = {'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Content-Profile': 'mtb', 'Content-Type': 'application/json'}
by = {}
for r in rows:
    by.setdefault(r['qual'], []).append(r)
batch, total = [], 0
def send(part):
    r = urllib.request.Request(URL + '/rest/v1/rpc/course_syllabus_sync', method='POST', headers=H,
                               data=json.dumps({'p': part}, ensure_ascii=False).encode())
    with urllib.request.urlopen(r, timeout=60) as resp:
        print(resp.status, resp.read().decode()[:200])
for q, part in by.items():           # never split one course across two calls (the sync would remove the other half)
    if batch and len(batch) + len(part) > 250:
        send(batch); batch = []
    batch += part; total += len(part)
if batch: send(batch)
print('synced', total, 'rows of', len(by), 'courses')
