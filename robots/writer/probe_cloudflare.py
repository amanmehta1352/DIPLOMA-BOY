"""Single call to Cloudflare Workers AI to check the token and account ID. Prints status only, never the key.

Env: CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID, optional CLOUDFLARE_WRITE_MODEL.
"""
import json, os, sys, urllib.request, urllib.error

TOKEN = os.environ.get('CLOUDFLARE_API_TOKEN', '').strip()
ACCOUNT = os.environ.get('CLOUDFLARE_ACCOUNT_ID', '').strip()
MODEL = os.environ.get('CLOUDFLARE_WRITE_MODEL', '@cf/meta/llama-3.3-70b-instruct-fp8-fast')

if not TOKEN or not ACCOUNT:
    sys.exit('FAIL: CLOUDFLARE_API_TOKEN or CLOUDFLARE_ACCOUNT_ID is missing in the secrets')

url = f'https://api.cloudflare.com/client/v4/accounts/{ACCOUNT}/ai/v1/chat/completions'
body = json.dumps({'model': MODEL, 'messages': [{'role': 'user', 'content': 'Reply with the single word: ok'}],
                   'max_tokens': 20}).encode()
req = urllib.request.Request(url, data=body, headers={'Authorization': 'Bearer ' + TOKEN, 'Content-Type': 'application/json'})
try:
    with urllib.request.urlopen(req, timeout=120) as r:
        status, raw = r.status, r.read()
except urllib.error.HTTPError as e:
    status, raw = e.code, e.read()
if status != 200:
    print(f'FAIL: HTTP {status}'); sys.exit(1)     # status only: the body can echo the account
try:
    choice = json.loads(raw)['choices'][0]
    content = (choice.get('message') or {}).get('content') or ''
except Exception as e:
    print(f'FAIL: unexpected reply format ({type(e).__name__})'); sys.exit(1)
if not content.strip() or choice.get('finish_reason') == 'length':
    print(f'FAIL: unusable completion (finish {choice.get("finish_reason")})'); sys.exit(1)
print(f'OK: model {MODEL} answered: {str(content)[:80]!r}')
