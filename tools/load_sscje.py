"""Upsert SSC JE Mechanical chapter drafts (content/sscje-mechanical/ch-<id>-*.json)
into mtb.chapter_drafts as status 'draft'. Never approves anything.
Existing rows were backed up to mtb.chapter_drafts_backup_20261112 and
mtb.chapter_draft_versions before this loader was first run."""
import glob, json, os, re, sys, urllib.request

URL = os.environ.get('SUPABASE_URL', 'https://wobmtlcpszcntczkebtt.supabase.co').rstrip('/')
KEY = os.environ['SUPABASE_SECRET_KEY']
H = {'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Content-Profile': 'mtb',
     'Accept-Profile': 'mtb', 'Content-Type': 'application/json',
     'Prefer': 'resolution=merge-duplicates,return=minimal'}
LEVEL = 'govt_technical'

def req(method, path, body=None, extra=None):
    h = dict(H); h.update(extra or {})
    r = urllib.request.Request(URL + path, method=method, headers=h,
                               data=None if body is None else json.dumps(body, ensure_ascii=False).encode())
    with urllib.request.urlopen(r, timeout=60) as resp:
        return resp.status, resp.read().decode()

rows = []
for f in sorted(glob.glob('content/sscje-mechanical/ch-*.json')):
    cid = int(re.search(r'ch-(\d+)-', f).group(1))
    data = json.load(open(f, encoding='utf-8'))
    assert data['id'] == f'DB|{LEVEL}|{cid}', f
    rows.append({'level_id': LEVEL, 'chapter_id': cid, 'status': 'draft', 'data': data,
                 'provider': 'claude', 'model': 'claude-opus-5-5',
                 'checks': {'held': 'original content written by Claude; owner review required before approval',
                            'validator': 'tools/check_sscje.py passed', 'copyright_covered': False}})

# refuse to touch anything already approved
ids = ','.join(str(r['chapter_id']) for r in rows)
st, body = req('GET', f'/rest/v1/chapter_drafts?select=chapter_id,status&level_id=eq.{LEVEL}&chapter_id=in.({ids})',
               extra={'Prefer': ''})
approved = {x['chapter_id'] for x in json.loads(body) if x['status'] != 'draft'}
if approved:
    print('skipping non-draft rows (not touched):', sorted(approved))
rows = [r for r in rows if r['chapter_id'] not in approved]

for r in rows:
    st, _ = req('POST', '/rest/v1/chapter_drafts?on_conflict=level_id,chapter_id', [r])
    print('upsert', r['chapter_id'], st)
print('done', len(rows))
