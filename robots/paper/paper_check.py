"""Paper robot (R1). Pure checks on a paper BEFORE import. No network, no DB writes.
Each check returns (ok, reason_hi). `check_paper(meta)` returns a verdict dict.
meta = {url, host, exam_slug, paper_date, shift, expected_count, found_count, languages, sha256, already_sha256s, label}"""
OFFICIAL_HOSTS = {'rrbcdg.gov.in', 'www.rrbcdg.gov.in', 'indianrailways.gov.in', 'ssc.gov.in', 'ssc.nic.in', 'rrbapply.gov.in'}
ALLOWED_LANGS = {'en', 'hi'}

from urllib.parse import urlsplit
from datetime import date

def _host_ok(url):
    # Hostname comes from the URL itself; a separate 'host' field is never trusted.
    if not url.startswith('https://'): return False, 'लिंक https नहीं है'
    h = (urlsplit(url).hostname or '').lower()
    if h not in OFFICIAL_HOSTS and not any(h.endswith('.' + o) for o in OFFICIAL_HOSTS if '.' in o and not o.startswith('www.')):
        return False, f'आधिकारिक साइट नहीं: {h or "पता नहीं"}'
    return True, 'आधिकारिक साइट'

def _real_date(s):
    try:
        date.fromisoformat(str(s)); return True
    except (TypeError, ValueError):
        return False

def _pos_int(x):
    return isinstance(x, int) and not isinstance(x, bool) and x > 0

def check_paper(m):
    checks = []
    def add(id, ok, why): checks.append({'id': id, 'ok': bool(ok), 'why_hi': why})
    ok, why = _host_ok(m.get('url') or ''); add('official_source', ok, why)
    add('exam_known', bool(m.get('exam_slug')), 'परीक्षा तय है' if m.get('exam_slug') else 'परीक्षा तय नहीं')
    good_date = _real_date(m.get('paper_date')) and bool(m.get('shift'))
    add('date_shift', good_date, 'तारीख और shift सही हैं' if good_date else 'तारीख गलत या shift नहीं')
    langs = set(m.get('languages') or [])
    add('language_en_hi_only', langs and langs <= ALLOWED_LANGS, 'सिर्फ़ English/Hindi' if langs and langs <= ALLOWED_LANGS else f'दूसरी भाषा: {sorted(langs - ALLOWED_LANGS) or "पता नहीं"}')
    exp, got = m.get('expected_count'), m.get('found_count')
    good_count = _pos_int(exp) and _pos_int(got) and got == exp
    add('count_matches', good_count, f'सवाल {got}/{exp}' if good_count else 'सवाल की संख्या सही नहीं')
    add('not_imported_before', m.get('sha256') and m.get('sha256') not in set(m.get('already_sha256s') or []), 'नई फ़ाइल' if m.get('sha256') not in set(m.get('already_sha256s') or []) else 'यह फ़ाइल पहले import हो चुकी है')
    passed = all(c['ok'] for c in checks)
    return {'verdict': 'pass' if passed else 'reject', 'checks': checks}
