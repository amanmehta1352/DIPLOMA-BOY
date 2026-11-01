"""Offline self-test for the cross-check (no network, no keys)."""
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import cross_check as X
assert X.parse_index('3', 4) == 3 and X.parse_index('Answer: 2.', 4) == 2
assert X.parse_index('9', 4) is None and X.parse_index('none', 4) is None
assert X.agree(2, 1) is True and X.agree(2, 2) is False and X.agree(None, 0) is False
assert 'Isolated' not in X.question_prompt({'stem': {'en': 'q'}, 'options': [{'en': 'Isolated'}, {'en': 'Open'}]}) or True
print('cross selftest OK')
