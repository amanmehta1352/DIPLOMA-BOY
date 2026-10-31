"""Offline self-test for the Syllabus Watcher (no network)."""
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import watch as W
a = W.normalize('<html><script>var x=1</script><h1>SSC  JE</h1> <p>Syllabus &amp; Pattern</p> token 0123456789abcdef0123</html>')
b = W.normalize('<div>ssc je</div><p>syllabus &amp; pattern token</p>')
assert a == b == 'ssc je syllabus & pattern token', (a, b)            # markup/script/whitespace ignored, same text = same fingerprint
assert W.fingerprint(a) != W.fingerprint(W.normalize('<p>syllabus changed</p>'))
assert W.changed_ids({'x': '1', 'y': '2'}, {'x': '1', 'y': '9'}) == ['y']   # only real change
assert W.changed_ids({'new': '1'}, {}) == []                       # first sight is baseline
assert W.changed_ids({'x': '1'}, {'x': '1'}) == []
print('syllabus selftest OK')
