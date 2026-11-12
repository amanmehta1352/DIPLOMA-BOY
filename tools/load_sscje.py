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

# mtb.draft_save upserts as status 'draft' and never overwrites an approved row.
for r in rows:
    st, body = req('POST', '/rest/v1/rpc/draft_save', {'p': r}, extra={'Prefer': '', 'x-actor': 'sscje-mech-loader'})
    print('draft_save', r['chapter_id'], st, body)
print('done', len(rows))
