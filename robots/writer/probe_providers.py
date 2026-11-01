"""One short call to each backup provider (Groq, SambaNova, Cloudflare) to check its key and model. Prints status only, never a key.

Env: GROQ_API_KEY, SAMBANOVA_API_KEY, CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID; optional *_WRITE_MODEL overrides.
"""
import json, os, sys, urllib.request, urllib.error


class NoRedirect(urllib.request.HTTPRedirectHandler):
    """Never follow redirects: urllib would copy the Authorization header to the new host."""
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


OPENER = urllib.request.build_opener(NoRedirect)

PROVIDERS = [
    ('groq', 'GROQ_API_KEY', 'https://api.groq.com/openai/v1/chat/completions', 'openai/gpt-oss-120b', 'GROQ_WRITE_MODEL'),
    ('sambanova', 'SAMBANOVA_API_KEY', 'https://api.sambanova.ai/v1/chat/completions', 'Meta-Llama-3.3-70B-Instruct', 'SAMBANOVA_WRITE_MODEL'),
]
acc = os.environ.get('CLOUDFLARE_ACCOUNT_ID', '').strip()
PROVIDERS.append(('cloudflare', 'CLOUDFLARE_API_TOKEN', f'https://api.cloudflare.com/client/v4/accounts/{acc}/ai/v1/chat/completions',
                  '@cf/meta/llama-3.3-70b-instruct-fp8-fast', 'CLOUDFLARE_WRITE_MODEL'))

failed = 0
for name, key_env, url, default_model, model_env in PROVIDERS:
    key = os.environ.get(key_env, '').strip()
    model = os.environ.get(model_env, '').strip() or default_model
    if not key or (name == 'cloudflare' and not acc):
        print(f'{name}: FAIL key or account missing in the secrets'); failed += 1; continue
    body = json.dumps({'model': model, 'messages': [{'role': 'user', 'content': 'Reply with the single word: ok'}],
                       'max_tokens': 300}).encode()
    req = urllib.request.Request(url, data=body, headers={'Authorization': 'Bearer ' + key, 'Content-Type': 'application/json',
                                                          'User-Agent': 'Mozilla/5.0 (diploma-boy-probe)'})   # Groq answers 403 to the default Python agent
    try:
        with OPENER.open(req, timeout=120) as r:
            status, raw = r.status, r.read()
    except urllib.error.HTTPError as e:
        status, raw = e.code, e.read()
    except Exception as e:
        print(f'{name}: FAIL network error ({type(e).__name__})'); failed += 1; continue
    if status != 200:
        print(f'{name}: FAIL HTTP {status} (model {model})'); failed += 1; continue     # status only: bodies can echo details
    try:
        choice = json.loads(raw)['choices'][0]
        content = (choice.get('message') or {}).get('content') or ''
    except Exception as e:
        print(f'{name}: FAIL unexpected reply format ({type(e).__name__})'); failed += 1; continue
    if not content.strip() or choice.get('finish_reason') == 'length':
        print(f'{name}: FAIL unusable completion (finish {choice.get("finish_reason")})'); failed += 1; continue
    print(f'{name}: OK model {model} answered')
sys.exit(1 if failed else 0)
