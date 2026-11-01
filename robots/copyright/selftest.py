"""Offline self-test for the copyright check (no network)."""
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import ngram as G
ref = G.trigrams('बल वह धक्का या खिंचाव है जो किसी वस्तु की गति की अवस्था बदल देता है')
copied, n = G.score('बल वह धक्का या खिंचाव है जो किसी वस्तु की गति की अवस्था बदल देता है', ref)
assert copied == 1.0 and n > 10
own, _ = G.score('किसी चीज़ को धकेलने या खींचने को हम बल कहते हैं, इससे चलती चीज़ रुक सकती है', ref)
assert own < 0.2, own
assert G.score('', ref) == (0.0, 0)
assert G.words('F = m × a, Force 10 N') == ['f', 'm', 'a', 'force', 'n']
print('copyright selftest OK')
