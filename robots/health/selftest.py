"""Offline selftest for the Health Robot: no network, no secrets. Run: python3 robots/health/selftest.py"""
import json, os, sys, tempfile, subprocess
sys.path.insert(0, os.path.dirname(__file__))
import health
from datetime import datetime, timezone, timedelta

AT = datetime(2026, 10, 23, 12, 0, tzinfo=timezone.utc)
GOOD = {'site': {'ok': True, 'ms': 120, 'sw': 'db-v6'}, 'branches': 3, 'errors': {},
        'runs': [{'name': 'Tests', 'branch': 'main', 'event': 'push', 'status': 'completed', 'conclusion': 'success', 'at': '2026-10-23T10:00:00Z'},
                 {'name': 'Daily backup', 'branch': 'main', 'event': 'schedule', 'status': 'completed', 'conclusion': 'success', 'at': '2026-10-23T05:00:00Z'}],
        'db': {'total': 10, 'by_exam': {'a': {'published': 6, 'draft': 3, 'hidden': 1}}, 'published_failing_lock': 0, 'published_failing_reasons': {},
               'draft_figure': 2, 'published_picture': 0, 'published_in_inbox': 0, 'reports_open': 0,
               'backup_last_at': '2026-10-23T02:00:00+00:00'},
        'backup_verify': {'checked_at': '2026-10-23T03:00:00+00:00', 'slot': 5, 'backup_rows': 10, 'missing_in_live': 0, 'changed_since': 0}}
def st(mod=None):
    d = json.loads(json.dumps(GOOD))
    if mod: mod(d)
    return health.build(d, None, AT)
def state(s, id): return next(c['state'] for c in s['checks'] if c['id'] == id)

s = st(); assert s['schema'] == 1 and s['overall'] == 'ok', s['overall']
assert s['numbers']['published'] == 6 and s['numbers']['draft'] == 3 and s['numbers']['hidden'] == 1
assert [r['id'] for r in s['robots']] == ['Tests', 'Daily backup']
assert all(set(c) == {'id', 'label_hi', 'state', 'count', 'detail', 'link'} for c in s['checks'])
# red tests on main -> overall bad
s = st(lambda d: d['runs'].insert(0, {'name': 'Tests', 'branch': 'main', 'event': 'push', 'status': 'completed', 'conclusion': 'failure', 'at': '2026-10-23T11:00:00Z'}))
assert state(s, 'tests') == 'bad' and s['overall'] == 'bad'
# old backup -> bad; 40 h -> warn
assert state(st(lambda d: d['db'].update(backup_last_at='2026-10-20T00:00:00+00:00')), 'backup') == 'bad'
assert state(st(lambda d: d['db'].update(backup_last_at='2026-10-21T20:00:00+00:00')), 'backup') == 'warn'
# bad rows live -> warn only (known debt), with reasons in detail
s = st(lambda d: d['db'].update(published_failing_lock=5, published_failing_reasons={'hindi_missing': 5}))
assert state(s, 'lock') == 'warn' and 'hindi_missing: 5' in next(c['detail'] for c in s['checks'] if c['id'] == 'lock') and s['overall'] == 'warn'
# backup unreadable -> bad
assert state(st(lambda d: d['backup_verify'].update(missing_in_live=3)), 'restore') == 'bad'
# database unreachable -> red check, no crash
s = st(lambda d: d.update(db=None, errors={'supabase': 'URLError'})); assert state(s, 'db') == 'bad' and s['overall'] == 'bad'
# verify failed -> red even if an old good result exists; no result at all -> check still present (warn)
s = st(lambda d: d.update(errors={'verify': 'HTTPError'})); assert state(s, 'restore') == 'bad' and s['overall'] == 'bad'
s = st(lambda d: d.pop('backup_verify')); assert state(s, 'restore') == 'warn'
# reports: only recent ones count
assert state(st(lambda d: d['db'].update(reports_7d=2)), 'reports') == 'warn' and state(st(), 'reports') == 'ok'
# site down
assert state(st(lambda d: d.update(site={'ok': False})), 'site') == 'bad'
# github unreachable
assert state(st(lambda d: d.update(runs=None)), 'tests') == 'bad'
# no secrets / emails / ids in the public report
blob = json.dumps(st()); assert '@' not in blob and 'eyJ' not in blob and 'sb_secret' not in blob
# history row + CLI round trip with --offline
with tempfile.TemporaryDirectory() as t:
    fx = os.path.join(t, 'fx.json'); json.dump(GOOD, open(fx, 'w'))
    for _ in range(2): subprocess.run([sys.executable, os.path.join(os.path.dirname(__file__), 'health.py'), '--out', t, '--offline', fx], check=True, capture_output=True)
    h = json.load(open(os.path.join(t, 'history.json'))); assert len(h) == 2 and h[-1]['published'] == 6
    assert json.load(open(os.path.join(t, 'status.json')))['app'] == 'diploma-boy'
print('health selftest OK')
