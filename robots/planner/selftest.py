"""Offline self-test for the Coverage Planner (no network, no secrets)."""
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import planner as P

T = {'default': {'concept': 1, 'formula': 1, 'example': 1, 'mcq': 2, 'solution': 2}, 'levels': {'lvl_b': {'mcq': 1, 'solution': 0}}}
chapters = [{'l': 'lvl_a', 'c': 1}, {'l': 'lvl_a', 'c': 2}, {'l': 'lvl_b', 'c': 3}]
atoms = [{'level_id': 'lvl_a', 'chapter_id': 1, 'atom_type': t} for t in ('concept', 'formula', 'example', 'mcq', 'mcq', 'mcq')]
atoms += [{'level_id': 'lvl_b', 'chapter_id': 3, 'atom_type': 'mcq'}]
sols = [{'level_id': 'lvl_a', 'chapter_id': 1}] * 5 + [{'level_id': 'lvl_a', 'chapter_id': 2}]
r = P.coverage(chapters, atoms, sols, T)
a = r['levels']['lvl_a']
# lvl_a: 2 chapters x (concept1 formula1 example1 mcq2 solution2) = 14 target.
# ch1: concept1 formula1 example1, mcq 3 capped to 2, solutions 5 capped to 2 -> 7 (full); ch2: one solution -> 1. Total 8.
assert a['target'] == 14 and a['have'] == 8, a
assert a['chapters'] == 2 and a['chapters_full'] == 1, a
assert a['pct'] == 57, a
assert a['per_type']['mcq'] == {'have': 2, 'target': 4}, a
assert a['per_type']['solution'] == {'have': 3, 'target': 4}, a
b = r['levels']['lvl_b']
# lvl_b overrides: mcq 1, solution 0 -> target 4 (concept1 formula1 example1 mcq1); it has only one mcq -> 1 of 4
assert b['target'] == 4 and b['have'] == 1 and b['chapters_full'] == 0, b
assert r['total']['chapters'] == 3
# capping: 50 mcqs in one chapter never fills another chapter's target
over = P.coverage([{'l': 'x', 'c': 1}, {'l': 'x', 'c': 2}], [{'level_id': 'x', 'chapter_id': 1, 'atom_type': 'mcq'}] * 50, [], {'default': {'mcq': 2}, 'levels': {}})
assert over['levels']['x']['have'] == 2 and over['levels']['x']['target'] == 4, over
# no chapters -> empty, no division by zero
assert P.coverage([], [], [], T)['total']['pct'] == 0
# real repo files load and every level has a target
real = P.run(offline=True)
assert real['total']['chapters'] == 956 and len(real['levels']) == 18, (real['total'], len(real['levels']))
assert all(v['target'] > 0 for v in real['levels'].values())
print('planner selftest OK')
# syllabus return: a unit is covered when most of its words appear in one chapter title
U = [{'subject': 'PHYSICS', 'unit': '1', 'title': 'PHYSICS AND MEASUREMENT'}, {'subject': 'PHYSICS', 'unit': '3', 'title': 'LAWS OF MOTION'}, {'subject': 'BIOLOGY', 'unit': '9', 'title': 'BREATHING AND EXCHANGE OF GASES'}]
R = P.syllabus_return(U, ['Units & Measurement', 'Force & Laws of Motion', 'Respiration in Plants'])
assert R['covered'] == 2 and [m['unit'] for m in R['missing']] == ['9'], R
print('syllabus return selftest OK')
