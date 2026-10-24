"""Offline selftest for the Paper robot. Run: python3 robots/paper/selftest.py"""
import os, sys
sys.path.insert(0, os.path.dirname(__file__))
from paper_check import check_paper
GOOD = {'url': 'https://www.rrbcdg.gov.in/uploads/2024/01-ALP/012024-CBT2_QPHTML_Revised.pdf', 'host': 'www.rrbcdg.gov.in',
        'exam_slug': 'rrb-je-cbt1', 'paper_date': '2024-01-01', 'shift': '1', 'expected_count': 100, 'found_count': 100,
        'languages': ['en', 'hi'], 'sha256': 'abc', 'already_sha256s': ['zzz']}
def v(mod=None):
    m = dict(GOOD); m.update(mod or {}); return check_paper(m)['verdict']
assert v() == 'pass'
assert v({'url': 'http://www.rrbcdg.gov.in/x.pdf'}) == 'reject'                 # not https
assert v({'host': 'some-coaching-site.com', 'url': 'https://some-coaching-site.com/p.pdf'}) == 'reject'  # not official
assert v({'languages': ['en', 'ta']}) == 'reject'                                # Tamil paper
assert v({'found_count': 99}) == 'reject'                                        # missing question
assert v({'shift': None}) == 'reject'                                            # no shift
assert v({'sha256': 'zzz'}) == 'reject'                                          # already imported
assert v({'exam_slug': None}) == 'reject'
# Hardening (review fixes)
assert v({'host': 'www.rrbcdg.gov.in', 'url': 'https://some-coaching-site.com/p.pdf'}) == 'reject'  # host field must not be trusted
assert v({'paper_date': '2024-02-30'}) == 'reject'                               # not a real date
assert v({'expected_count': -1, 'found_count': -1}) == 'reject'                  # counts must be positive
assert v({'expected_count': 0, 'found_count': 0}) == 'reject'
print('paper selftest OK')
