"""Upsert content/course-syllabus/syllabus.json into mtb.course_subjects via rpc course_syllabus_load.
Only names + mapping; never deletes, never touches chapter content."""
import json, os, urllib.request
URL = os.environ.get('SUPABASE_URL', 'https://wobmtlcpszcntczkebtt.supabase.co').rstrip('/')
KEY = os.environ['SUPABASE_SECRET_KEY']
rows = json.load(open('content/course-syllabus/syllabus.json', encoding='utf-8'))
H = {'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Content-Profile': 'mtb', 'Content-Type': 'application/json'}
for i in range(0, len(rows), 200):
    part = rows[i:i + 200]
    r = urllib.request.Request(URL + '/rest/v1/rpc/course_syllabus_load', method='POST', headers=H,
                               data=json.dumps({'p': part}, ensure_ascii=False).encode())
    with urllib.request.urlopen(r, timeout=60) as resp:
        print('chunk', i, resp.status, resp.read().decode()[:200])
print('loaded', len(rows))
