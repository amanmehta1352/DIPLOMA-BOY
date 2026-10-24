#!/usr/bin/env python3
"""Pattern candidate review (migration 0027). Human-in-the-loop: lists pending candidates and records decisions.
It only changes candidate status. It never touches live pattern_id.
  review.py --list [--limit N]                     show pending candidates (keyset-paged, read via service key)
  review.py --decide approved|rejected --ids 1,2,3 --reviewer <uuid>   record decisions in batches of 200
Needs SUPABASE_SECRET_KEY. Reviewer id must be a real person's uuid, never the robot."""
import os, sys, json, argparse, requests

URL = 'https://wobmtlcpszcntczkebtt.supabase.co/rest/v1/'

def headers():
    key = os.environ.get('SUPABASE_SECRET_KEY')
    if not key: sys.exit('no SUPABASE_SECRET_KEY')
    return {'apikey': key, 'Authorization': 'Bearer ' + key, 'Content-Profile': 'mtb', 'Accept-Profile': 'mtb', 'Content-Type': 'application/json'}

def pending(limit):
    after, out = 0, []
    while len(out) < limit:
        r = requests.post(URL + 'rpc/pattern_candidates_pending', headers=headers(), json={'p_after': after, 'p_limit': min(500, limit - len(out))}, timeout=60)
        if r.status_code >= 300: sys.exit('list failed: ' + r.text[:200])
        page = r.json()
        if not page: break
        out += page; after = page[-1]['id']
    return out

def decide(decision, ids, reviewer):
    total = 0
    for k in range(0, len(ids), 200):
        try:
            r = requests.post(URL + 'rpc/pattern_review', headers=headers(), json={'p_ids': ids[k:k+200], 'p_decision': decision, 'p_reviewer': reviewer}, timeout=60)
        except requests.RequestException as e:
            print(json.dumps({'updated_before_failure': total, 'failed_at_batch_offset': k}), file=sys.stderr)
            sys.exit('network error; updates above are confirmed, the rest were not sent: ' + type(e).__name__)
        if r.status_code >= 300:
            print(json.dumps({'updated_before_failure': total, 'failed_at_batch_offset': k}), file=sys.stderr)
            sys.exit('batch failed; updates above are confirmed, the rest were not sent: ' + r.text[:200])
        total += int(r.json() or 0)
    return total

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--list', action='store_true'); ap.add_argument('--limit', type=int, default=50)
    ap.add_argument('--decide', choices=['approved', 'rejected']); ap.add_argument('--ids'); ap.add_argument('--reviewer')
    a = ap.parse_args()
    if a.list:
        rows = pending(a.limit)
        print(json.dumps({'pending_shown': len(rows), 'all_unverified': True}))
        for c in rows: print(json.dumps(c, ensure_ascii=False))
        return
    if a.decide:
        if not a.ids or not a.reviewer: sys.exit('--ids and --reviewer are required')
        ids = [int(x) for x in a.ids.split(',') if x.strip()]
        print(json.dumps({'decision': a.decide, 'updated': decide(a.decide, ids, a.reviewer)}))
        return
    ap.print_help()

if __name__ == '__main__': main()
