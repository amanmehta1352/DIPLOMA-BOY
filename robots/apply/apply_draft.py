"""Write a prepared chapter draft (JSON file) into mtb.chapter_drafts, only after its current version is saved
in mtb.chapter_draft_versions. Never deletes. Never prints the key.
   python3 robots/apply/apply_draft.py --id 72 --file content/electricity_880/v2.json --note "..."
"""
import argparse, hashlib, json, os, sys, urllib.request, datetime
SB = 'https://wobmtlcpszcntczkebtt.supabase.co/rest/v1/'
KEY = os.environ.get('SUPABASE_SECRET_KEY', '').strip() or sys.exit('SUPABASE_SECRET_KEY missing')
H = {'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Accept-Profile': 'mtb', 'Content-Profile': 'mtb', 'Content-Type': 'application/json'}
def call(method, path, body=None, extra=None):
    req = urllib.request.Request(SB + path, method=method, data=None if body is None else json.dumps(body, ensure_ascii=False).encode(), headers={**H, **(extra or {})})
    with urllib.request.urlopen(req, timeout=120) as r: t = r.read(); return json.loads(t) if t else None
md5 = lambda x: hashlib.md5(json.dumps(x, sort_keys=True, ensure_ascii=False).encode()).hexdigest()
ap = argparse.ArgumentParser(); ap.add_argument('--id', type=int, required=True); ap.add_argument('--file', required=True); ap.add_argument('--note', default='')
a = ap.parse_args()
new = json.load(open(a.file, encoding='utf-8'))
cur = call('GET', f'chapter_drafts?id=eq.{a.id}&select=id,level_id,chapter_id,status,data,checks,provider,model')[0]
if md5(cur['data']) == md5(new): print('already applied'); sys.exit(0)
saved = call('GET', f'chapter_draft_versions?draft_id=eq.{a.id}&select=version_id,data')
if not any(md5(v['data']) == md5(cur['data']) for v in saved):
    call('POST', 'chapter_draft_versions', {'draft_id': cur['id'], 'level_id': cur['level_id'], 'chapter_id': cur['chapter_id'], 'status': cur['status'],
         'data': cur['data'], 'checks': cur['checks'], 'provider': cur['provider'], 'model': cur['model'], 'note': 'saved by apply_draft before update'}, {'Prefer': 'return=minimal'})
    print('current version saved')
else: print('current version already saved')
checks = dict(cur.get('checks') or {}); checks['v2'] = a.note
call('PATCH', f'chapter_drafts?id=eq.{a.id}', {'data': new, 'checks': checks, 'model': 'v2: DeepSeek blueprint (OpenRouter) + Claude written/checked',
     'updated_at': datetime.datetime.now(datetime.timezone.utc).isoformat()}, {'Prefer': 'return=minimal'})
after = call('GET', f'chapter_drafts?id=eq.{a.id}&select=data,status')[0]
print('applied:', md5(after['data']) == md5(new), 'status', after['status'], 'bytes', len(json.dumps(after['data'], ensure_ascii=False)))
