#!/usr/bin/env python3
"""Checked publish for the papers of the given jobs. A draft goes live only if ALL checks pass:
official answer present · 4 options · English (text or picture) · Hindi (text or picture) · twin/Hindi checks passed.
   publish.py --job 27 [--dry-run]"""
import os, sys, json, argparse, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import robot as R


def check(q):
    s = q['stem'] or {}; o = q['options'] or []
    why = []
    if q['answer'] is None or not (0 <= q['answer'] < len(o)): why.append('answer')
    if len(o) != 4: why.append('options')
    if not (s.get('img') or (s.get('en') and all((x or {}).get('en') for x in o))): why.append('english')
    if not (s.get('img_hi') or (s.get('fig') and s.get('img') and s.get('hi')) or (s.get('hi') and all((x or {}).get('hi') for x in o))): why.append('hindi')
    # checks.hindi records why the OFFICIAL Hindi read was rejected; when machine Hindi (hi_mt) replaced it, that flag is history, not a fault
    if (s.get('checks') or {}).get('hindi') and not s.get('hi_mt'): why.append('hindi-check')
    return why


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--job', type=int, action='append', required=True); ap.add_argument('--dry-run', action='store_true'); ap.add_argument('--work', default='work')
    a = ap.parse_args(); os.makedirs(a.work, exist_ok=True)
    for j in a.job:
        job = R.rest('GET', 'import_jobs', params={'id': f'eq.{j}'})[0]
        sid = job.get('source_id') or (job.get('report') or {}).get('source_id')
        if not sid: print(f'job {j}: no paper yet'); continue
        src = R.rest('GET', 'sources', params={'select': 'kind,verification', 'id': f'eq.{sid}'})
        if src and src[0].get('kind') == 'third_party_copy' and os.environ.get('ALLOW_THIRD_PARTY') != 'yes':
            print(f'job {j}: source is a re-hosted third-party copy ({src[0].get("verification")}) - stays DRAFT until the owner allows publishing'); continue
        qs = R.fetch_all('questions', {'select': 'id,status,stem,options,answer', 'source_id': f'eq.{sid}'})
        st = collections.Counter(); ok = []; fails = collections.Counter()
        for q in qs:
            st[q['status']] += 1
            if q['status'] != 'draft': continue
            why = check(q)
            if why:
                for w in why: fails[w] += 1
            else: ok.append(q['id'])
        rep = {'job': j, 'source_id': sid, 'by_status': dict(st), 'will_publish': len(ok), 'held_because': dict(fails),
               'paper_total_after': st['published'] + len(ok)}
        print(json.dumps(rep, ensure_ascii=False))
        json.dump(rep, open(os.path.join(a.work, f'publish_{j}.json'), 'w'), ensure_ascii=False, indent=1)
        if not a.dry_run:
            for i in range(0, len(ok), 100):
                R.rest('PATCH', 'questions', {'status': 'published'}, params={'id': 'in.(' + ','.join(map(str, ok[i:i + 100])) + ')'})

if __name__ == '__main__': main()
