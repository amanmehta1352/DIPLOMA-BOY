"""Copyright overlap diagnostic for a saved draft. No AI call, no network.

Explains the score the job's copyright_overlap() gives:
  tokens      = re.findall(r'[a-z0-9ऀ-ॿ]+', text_of(draft).lower())
  shingles    = every 3 consecutive tokens (len(tokens) - 2 of them, duplicates counted)
  fingerprint = sha256(' '.join(shingle))[:16]; reference = union of all fingerprint files
  score       = matched shingles / all shingles
Matched shingles that touch each other are merged into passages and each passage is put in one group.
The groups are a reading aid, not a legal finding; the job's gate still uses the plain score.

usage: python3 diagnose_copyright.py <draft.json> <fingerprints_dir> [--md out.md]
"""
import hashlib, json, os, re, sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from common import text_of  # noqa: E402

TOK = r'[a-z0-9ऀ-ॿ]+'
NOTATION = {'v', 'i', 'r', 'p', 'h', 't', 'q', 'w', 'j', 's', 'a', 'c', 'kw', 'kwh', 'ohm', 'ohms', 'volt', 'volts', 'ampere',
            'amperes', 'watt', 'watts', 'joule', 'joules', 'coulomb', 'coulombs', 'm', 'mm', 'x', '2', 'per'}
TERMS = ['electric current', 'potential difference', 'ohm s law', 'ohms law', 'resistivity', 'resistance', 'in series', 'in parallel',
         'series combination', 'parallel combination', 'heating effect', 'electric power', 'si unit', 'rate of flow', 'flow of charge',
         'joule s law', 'electric circuit', 'conductor', 'equivalent resistance', 'commercial unit', 'kilowatt hour']
FUNCTION = {'the', 'of', 'a', 'an', 'is', 'in', 'to', 'and', 'it', 'its', 'are', 'by', 'for', 'on', 'as', 'with', 'that', 'this', 'be',
            'which', 'what', 'when', 'its', 'at', 'from', 'or', 'two', 'one'}


def fp(s):
    return hashlib.sha256(s.encode()).hexdigest()[:16]


def load_ref(d):
    hs, files = set(), []
    for n in sorted(os.listdir(d)):
        if n.endswith('.json'):
            j = json.load(open(os.path.join(d, n), encoding='utf-8')); hs |= set(j['hashes']); files.append((n, j.get('lang'), len(j['hashes'])))
    return hs, files


def classify(span, text, all_spans):
    toks = span.split()
    if len(toks) >= 8: return 'long_passage'
    if all_spans[span] >= 2: return 'repeated_boilerplate'
    content = [t for t in toks if t not in FUNCTION]
    if content and sum(t in NOTATION or t.isdigit() for t in content) / len(content) >= 0.5: return 'formula_notation'
    if any(term in span for term in TERMS): return 'standard_terminology'
    if not content: return 'function_words_only'
    return 'other_short_phrase'


def diagnose(draft, ref):
    w = re.findall(TOK, text_of(draft).lower())
    g = [' '.join(w[i:i + 3]) for i in range(len(w) - 2)]
    hit = [fp(x) in ref for x in g]
    spans = []                                   # (start_shingle, end_shingle) inclusive runs of matches
    i = 0
    while i < len(g):
        if hit[i]:
            j = i
            while j + 1 < len(g) and hit[j + 1]: j += 1
            spans.append((i, j)); i = j + 1
        else:
            i += 1
    texts = [' '.join(w[a:b + 3]) for a, b in spans]
    cnt = Counter(texts)
    groups = {}
    for (a, b), t in zip(spans, texts):
        k = classify(t, w, cnt)
        e = groups.setdefault(k, {'passages': 0, 'matched_shingles': 0, 'examples': Counter()})
        e['passages'] += 1; e['matched_shingles'] += b - a + 1; e['examples'][t] += 1
    m = sum(hit)
    return {'tokens': len(w), 'shingles': len(g), 'matched': m, 'score': round(m / len(g), 4) if g else 0.0,
            'longest_passage_tokens': max((b - a + 3 for a, b in spans), default=0),
            'groups': {k: {'passages': v['passages'], 'matched_shingles': v['matched_shingles'],
                           'share_of_score': round(v['matched_shingles'] / m, 3) if m else 0,
                           'examples': [f'{t}' + (f'  (x{c})' if c > 1 else '') for t, c in v['examples'].most_common(12)]}
                       for k, v in sorted(groups.items(), key=lambda kv: -kv[1]['matched_shingles'])}}


def to_md(res, files, name, threshold=0.20):
    L = [f'# Copyright overlap diagnostic: {name}', '',
         'Method: 3-word shingles of the draft text (lowercased, tokens = letters/digits/Devanagari), each hashed (sha256, first 16 hex) '
         'and looked up in the NCERT fingerprint set. Score = matched shingles / all shingles (duplicates counted).',
         f"Reference files: {', '.join(f'{n} ({l}, {c} hashes)' for n, l, c in files)}",
         '', f"- Tokens: {res['tokens']}", f"- Shingles (denominator): {res['shingles']}", f"- Matched shingles (numerator): {res['matched']}",
         f"- Score: {res['score']:.2%} (gate threshold {threshold:.0%}; threshold unchanged)",
         f"- Longest matching passage: {res['longest_passage_tokens']} tokens", '',
         'This is a text-similarity measurement against hashed reference text. It is not legal clearance and not a verdict of infringement. '
         'The reference holds hashes only, so the matching NCERT sentences themselves cannot be shown; the passages below are the draft\'s own words that matched.', '']
    for k, v in res['groups'].items():
        L.append(f"## {k}: {v['passages']} passages, {v['matched_shingles']} shingles, {v['share_of_score']:.0%} of the matched total")
        L += [f'- "{x}"' for x in v['examples']]
        L.append('')
    return '\n'.join(L)


if __name__ == '__main__':
    draft = json.load(open(sys.argv[1], encoding='utf-8'))
    ref, files = load_ref(sys.argv[2])
    res = diagnose(draft, ref)
    md = to_md(res, files, os.path.basename(sys.argv[1]))
    if '--md' in sys.argv: open(sys.argv[sys.argv.index('--md') + 1], 'w', encoding='utf-8').write(md)
    print(md)
