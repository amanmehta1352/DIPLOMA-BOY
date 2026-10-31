"""Offline self-test for the topic sample (no network, no key)."""
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import topic_sample as S
assert 'Electric' in S.build_prompt('Electric potential') and 'JSON' in S.build_prompt('x')
assert S.check_note({'concept': 'Force is a push or pull.', 'key_points': ['a', 'b'], 'formula_or_fact': ''}) == []
assert S.check_note({'concept': '', 'key_points': ['a']}) != []
assert S.check_note({'concept': '<b>x</b>', 'key_points': ['a', 'b']}) == ['html in text']
assert S.check_note('nope') == ['not an object']
print('topic sample selftest OK')
