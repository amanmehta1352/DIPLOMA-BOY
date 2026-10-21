#!/usr/bin/env python3
"""Pattern grouper: finds same-type PYQ questions (they differ only in numbers / names) inside each chapter.
Numbers are masked, then TF-IDF (1-2 grams) cosine >= TH links two questions; linked questions form one pattern.
Writes pattern_id (= lead question id), pattern_n (size, all exams) and pattern_rep (true for the lead / for questions without a pattern).
   group.py [--dry-run] [--sql out.sql]      (reads published questions with the public key; writes need SUPABASE_SECRET_KEY)"""
import os, re, sys, json, argparse, collections
import requests
from sklearn.feature_extraction.text import TfidfVectorizer

URL = 'https://wobmtlcpszcntczkebtt.supabase.co/rest/v1/'
PUB = 'sb_publishable_7ZZEUDULfYaMHSeLIxfluQ_fZWSCi8R'
TH = 0.70


def fetch():
    H = {'apikey': PUB, 'Accept-Profile': 'mtb'}; rows = []; o = 0
    while True:
        r = requests.get(URL + 'questions', headers=H, timeout=60, params={'select': 'id,kind,chapter_id,topic_id,stem->en,stem->hi', 'order': 'id', 'limit': 1000, 'offset': o})
        r.raise_for_status(); b = r.json(); rows += b; o += 1000
        if len(b) < 1000: return rows


def text(r):
    t = re.sub(r'<[^>]+>', ' ', (r.get('hi') or r.get('en') or '').lower())
    t = re.sub(r'\d+(\.\d+)?', '#', t)
    t = re.sub(r'[^\w#ऀ-ॿ ]+', ' ', t)
    return re.sub(r'\s+', ' ', t).strip()


def patterns(rows):
    by = collections.defaultdict(list)
    for r in rows:
        r['t'] = text(r)
        if len(r['t']) >= 15: by[r['chapter_id'] or ('t', r['topic_id'])].append(r)
    out = []
    for rs in by.values():
        if len(rs) < 2: continue
        X = TfidfVectorizer(ngram_range=(1, 2), sublinear_tf=True, token_pattern=r'[#\wऀ-ॿ]+').fit_transform([r['t'] for r in rs])
        S = (X @ X.T).toarray(); n = len(rs); p = list(range(n))
        def f(x):
            while p[x] != x: p[x] = p[p[x]]; x = p[x]
            return x
        for i in range(n):
            for j in range(i + 1, n):
                if S[i, j] >= TH: p[f(i)] = f(j)
        g = collections.defaultdict(list)
        for i in range(n): g[f(i)].append(rs[i]['id'])
        out += [sorted(v) for v in g.values() if len(v) > 1]
    return out


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--dry-run', action='store_true'); ap.add_argument('--sql'); a = ap.parse_args()
    rows = fetch(); pats = patterns(rows)
    vals = [(i, g[0], len(g)) for g in pats for i in g]
    print(json.dumps({'pyq': len(rows), 'patterns': len(pats), 'questions_in_patterns': len(vals), 'largest': max((len(g) for g in pats), default=0)}))
    if a.sql:
        open(a.sql, 'w').write("update mtb.questions set pattern_id=null, pattern_n=null, pattern_rep=true where pattern_id is not null;\n"
            "update mtb.questions q set pattern_id=v.pid, pattern_n=v.n, pattern_rep=(q.id=v.pid) from (values " + ','.join(f'({i},{p},{n})' for i, p, n in vals) + ") v(id,pid,n) where q.id=v.id;\n")
    if a.dry_run or a.sql: return
    key = os.environ.get('SUPABASE_SECRET_KEY')
    if not key: sys.exit('no SUPABASE_SECRET_KEY: pattern step skipped (dry run ok)')
    H = {'apikey': key, 'Authorization': 'Bearer ' + key, 'Content-Profile': 'mtb', 'Content-Type': 'application/json'}
    # one RPC = one transaction (mtb.pattern_apply, migration 0013): all or nothing
    body = [{'id': i, 'pid': p, 'n': n} for i, p, n in vals]
    r = requests.post(URL + 'rpc/pattern_apply', headers=H, json={'p': body}, timeout=120)
    if r.status_code >= 300: sys.exit('pattern_apply failed, data unchanged: ' + r.text[:300])
    print(json.dumps({'written': r.json(), 'patterns': len(pats)}))


if __name__ == '__main__': main()
