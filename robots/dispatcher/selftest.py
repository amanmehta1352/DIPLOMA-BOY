"""Offline self-test for the Dispatcher (no network, no secrets)."""
import json, os, re, sys
from datetime import datetime, timezone, timedelta
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)
import dispatcher as D

R = D.load_robots()
# every robot points to a real workflow that can be started by hand, and declares command_id when it reports back
for k, s in R.items():
    wf = os.path.join(ROOT, '.github', 'workflows', s['workflow']); assert os.path.exists(wf), (k, wf)
    y = open(wf, encoding='utf8').read(); assert 'workflow_dispatch' in y, k
    for i in s['inputs']: assert re.search(rf'^\s+{i}:', y, re.M), (k, i)
    if s.get('reports'): assert re.search(r'^\s+command_id:', y, re.M) and 'robots/dispatcher/report.py' in y, k
# same robot list as the database whitelist
sql = open(os.path.join(ROOT, 'db', 'migrations', '0159_robot_commands.sql'), encoding='utf8').read()
db = set(re.search(r"array\[([^\]]+)\]", sql).group(1).replace("'", '').replace(' ', '').split(','))
assert db == set(R), (db, set(R))

w = R['writer']
i, p = D.build_inputs(w, {}); assert p == [] and i == {'count': '3', 'level': 'govt_technical', 'only': '', 'dry_run': 'false'}, i
i, p = D.build_inputs(w, {'count': '7', 'level': 'class_9_10', 'only': '1, 2,3', 'dry_run': 'हाँ'}); assert p == [] and i['count'] == '7' and i['only'] == '1,2,3' and i['dry_run'] == 'true', i
assert D.build_inputs(w, {'count': 999})[1]
assert D.build_inputs(w, {'count': 'abc'})[1]
assert D.build_inputs(w, {'level': 'x; rm -rf'})[1]
assert D.build_inputs(w, {'only': '1,a'})[1]
assert D.build_inputs(w, {'evil': 1})[1]
assert D.build_inputs(R['health'], {}) == ({}, [])

t = datetime(2026, 10, 31, 12, 0, tzinfo=timezone.utc)
runs = [{'id': 1, 'event': 'workflow_dispatch', 'created_at': '2026-10-31T11:50:00Z'},
        {'id': 2, 'event': 'schedule', 'created_at': '2026-10-31T12:00:05Z'},
        {'id': 3, 'event': 'workflow_dispatch', 'created_at': '2026-10-31T12:00:04Z'},
        {'id': 4, 'event': 'workflow_dispatch', 'created_at': '2026-10-31T12:01:00Z'}]
assert D.match_run(runs, t, set())['id'] == 3
assert D.match_run(runs, t, {3})['id'] == 4
assert D.match_run(runs, t, {3, 4}) is None
assert D.run_state({'status': 'in_progress'}) is None
assert D.run_state({'status': 'completed', 'conclusion': 'success'}) == ('done', 'success')
assert D.run_state({'status': 'completed', 'conclusion': 'failure'}) == ('failed', 'failure')
print('dispatcher selftest OK')
