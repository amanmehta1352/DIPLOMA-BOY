"""Syllabus Watcher: checks official pages, remembers a fingerprint of each, and hands a change to the rest of the system.

   python3 robots/syllabus/watch.py --prev PREV_STATE.json --out OUT_DIR

First time a source is seen it is only recorded (no alert). A later change writes a command for the Health Robot
(mtb.cmd_enqueue_auto), so the change is visible in the Control Room and Health reruns on the new picture.
Only fingerprints are stored, never page text. Keys never printed.
"""
import argparse, hashlib, html, json, os, re, sys, urllib.request, urllib.error
from datetime import datetime, timezone

HERE = os.path.dirname(os.path.abspath(__file__))
SB = os.environ.get('SUPABASE_URL', 'https://wobmtlcpszcntczkebtt.supabase.co').rstrip('/')
KEY = os.environ.get('SUPABASE_SECRET_KEY', '').strip()


def normalize(raw):
    """Visible text only, whitespace collapsed, dates/tokens that change every load removed."""
    t = re.sub(r'(?is)<(script|style|noscript)[^>]*>.*?</\1>', ' ', raw)
    t = re.sub(r'(?s)<[^>]+>', ' ', t)
    t = html.unescape(t)
    t = re.sub(r'\b[0-9a-f]{16,}\b', ' ', t)          # random tokens
    t = re.sub(r'\s+', ' ', t).strip().lower()
    return t


def fingerprint(text):
    return hashlib.sha256(text.encode('utf8')).hexdigest()


def changed_ids(now_fp, prev_fp):
    """Pure: ids whose fingerprint differs from the previous run. A new id is a baseline, not a change."""
    return sorted(k for k, v in now_fp.items() if k in prev_fp and prev_fp[k] != v)


def fetch(url):
    req = urllib.request.Request(url, headers={'User-Agent': 'diploma-boy-syllabus-watch/1.0'})
    with urllib.request.urlopen(req, timeout=40) as r:
        return r.read().decode('utf8', 'ignore')


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--prev', default=''); ap.add_argument('--out', default='out'); a = ap.parse_args()
    src = json.load(open(os.path.join(HERE, 'sources.json'), encoding='utf-8'))['sources']
    prev = {}
    if a.prev and os.path.exists(a.prev):
        try: prev = json.load(open(a.prev, encoding='utf-8')).get('fingerprints', {})
        except Exception: prev = {}
    now, errors = {}, {}
    for s in src:
        try: now[s['id']] = fingerprint(normalize(fetch(s['url'])))
        except Exception as e: errors[s['id']] = type(e).__name__ + (f':{e.code}' if isinstance(e, urllib.error.HTTPError) else '')
    changed = changed_ids(now, prev)
    fp = {**prev, **now}   # keep old fingerprints if a source failed this time
    os.makedirs(a.out, exist_ok=True)
    state = {'schema': 1, 'checked_at': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'),
             'fingerprints': fp, 'changed': changed, 'errors': errors, 'sources': len(src)}
    json.dump(state, open(os.path.join(a.out, 'syllabus_state.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(f'sources {len(src)} · checked {len(now)} · changed {changed or "none"} · errors {errors or "none"}')
    if changed and KEY:
        import urllib.request as R
        body = json.dumps({'p_robot': 'health', 'p_args': {}, 'p_note': 'Syllabus changed: ' + ', '.join(changed)[:400]}).encode()
        h = {'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Content-Profile': 'mtb', 'Content-Type': 'application/json'}
        try:
            with R.urlopen(R.Request(f'{SB}/rest/v1/rpc/cmd_enqueue_auto', body, h, method='POST'), timeout=60) as r:
                print('handover to Health Robot: command', r.read().decode()[:20])
        except urllib.error.HTTPError as e:
            print('handover failed: HTTP', e.code)


if __name__ == '__main__':
    main()
