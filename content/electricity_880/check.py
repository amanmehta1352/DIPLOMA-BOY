import json, sys, re
sys.path.insert(0, '/home/claude/diploma-boy/robots/copyright'); sys.path.insert(0, '/home/claude/build')
import ngram
from content import NOTES, TEACH, BEATS, NEW_MISTAKES, NEW_REVISION, NEW_PRACTICE
ref, langs = ngram.load_fingerprint_files()
print('reference docs', langs, 'hashes', len(ref))
texts = []
for n in NOTES:
    texts += [x for p in n['points'] for x in p] + list(n['title'])
    for row in n.get('table') or []: texts += [x for c in row for x in c]
for t in TEACH: texts += list(t['heading']) + list(t['explain']) + list(t['example'])
for q, st, a in BEATS: texts += list(q) + [x for s in st for x in s] + list(a)
for m in NEW_MISTAKES + NEW_REVISION: texts += list(m)
for q, o, a, e in NEW_PRACTICE: texts += list(q) + [x for oo in o for x in oo] + list(e)
def longest_run(text):
    w = ngram.words(text); best = cur = 0
    for i in range(len(w) - 2):
        if ngram.fp(tuple(w[i:i+3])) in ref: cur += 1; best = max(best, cur)
        else: cur = 0
    return best + 2 if best else 0
runs = sorted(((longest_run(x), x[:70]) for x in texts), reverse=True)
whole = ' '.join(texts)
sc, n = ngram.score(whole, ref)
print('items', len(texts), 'overall trigram overlap', round(sc, 4), 'of', n)
print('longest copied runs (words):', runs[:6])
fail = [r for r in runs if r[0] >= 8]
print('C1a 8-word check:', 'FAIL' if fail else 'PASS')
# Hindi fields: Devanagari majority
bad = []
for i, x in enumerate(texts):
    pass
def runs_detail(text):
    w = ngram.words(text); out=[]; i=0
    hits=[ngram.fp(tuple(w[k:k+3])) in ref for k in range(len(w)-2)]
    k=0
    while k<len(hits):
        if hits[k]:
            j=k
            while j<len(hits) and hits[j]: j+=1
            if j-k+2>=8: out.append(' '.join(w[k:j+2]))
            k=j
        else: k+=1
    return out
for x in texts:
    d=runs_detail(x)
    if d: print('>>',d)
