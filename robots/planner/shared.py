"""Shared topics: one entry per topic, however many levels teach it.

   python3 robots/planner/shared.py --in out/syllabus_return.json --out out/shared_topics.json

Two topics are the same when their normalised words are the same (order and case ignored).
Each shared topic lists the levels it appears in, so a note is written once and reused by every level.
Pure logic, no network. Self-test: robots/planner/selftest.py.
"""
import argparse, json, os, re, sys

def key(topic):
    """Pure: normalised key for a topic (lowercase words, sorted, stop words removed)."""
    stop = {'and', 'of', 'the', 'in', 'to', 'a', 'an', 'for', 'with', 'on', 'by', 'or'}
    words = {w for w in re.findall(r'[a-z]+', topic.lower()) if w not in stop and len(w) > 1}
    return ' '.join(sorted(words))


def merge(pages):
    """Pure: pages = {level: [topic, ...]} -> [{'topic', 'levels': [...]}] with one entry per key."""
    groups = {}
    for level, topics in pages.items():
        for t in topics:
            k = key(t)
            if not k: continue
            g = groups.setdefault(k, {'topic': t, 'levels': []})
            if level not in g['levels']: g['levels'].append(level)
    return sorted(groups.values(), key=lambda g: (-len(g['levels']), g['topic'].lower()))


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--in', dest='src', required=True); ap.add_argument('--out', required=True); a = ap.parse_args()
    r = json.load(open(a.src, encoding='utf-8'))
    pages = {lv: [m if isinstance(m, str) else m.get('title', '') for m in (v.get('missing') or [])] for lv, v in (r.get('pages') or {}).items()}
    shared = merge(pages)
    os.makedirs(os.path.dirname(a.out) or '.', exist_ok=True)
    json.dump({'topics': len(shared), 'shared_by_2_or_more': sum(1 for g in shared if len(g['levels']) > 1), 'items': shared}, open(a.out, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(f"{len(shared)} topics; {sum(1 for g in shared if len(g['levels']) > 1)} shared by 2+ levels")


if __name__ == '__main__':
    main()
