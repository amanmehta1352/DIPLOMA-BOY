"""Write a prepared chapter draft (JSON file) into mtb.chapter_drafts through mtb.draft_replace_with_version,
which saves the current version in mtb.chapter_draft_versions first. Never deletes. Never prints the key.
   python3 robots/apply/apply_draft.py --id 72 --file content/electricity_880/v2.json --note "..."
"""
import argparse, json, os, sys, urllib.request
SB = 'https://wobmtlcpszcntczkebtt.supabase.co/rest/v1/rpc/draft_replace_with_version'
KEY = os.environ.get('SUPABASE_SECRET_KEY', '').strip() or sys.exit('SUPABASE_SECRET_KEY missing')
ap = argparse.ArgumentParser(); ap.add_argument('--id', type=int, required=True); ap.add_argument('--file', required=True); ap.add_argument('--note', default='')
a = ap.parse_args()
body = {'p': {'id': a.id, 'data': json.load(open(a.file, encoding='utf-8')), 'note': a.note, 'model': 'v2: DeepSeek blueprint (OpenRouter) + Claude written and checked'}}
req = urllib.request.Request(SB, method='POST', data=json.dumps(body, ensure_ascii=False).encode(),
      headers={'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Content-Profile': 'mtb', 'Accept-Profile': 'mtb', 'Content-Type': 'application/json'})
try:
    with urllib.request.urlopen(req, timeout=180) as r: print('result:', r.read().decode())
except urllib.error.HTTPError as e:
    print('HTTP', e.code, e.read().decode()[:400]); sys.exit(1)
