"""Syllabus robot tests: a real PDF is generated locally (reportlab) and read with pdftotext. Mock AI."""
import io, json, os, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
from reportlab.pdfgen import canvas
import syllabus_robot as S
from providers import Mock

LINES = ['Unit III: Natural Phenomena',
         'Light - Reflection and Refraction: Reflection of light by curved surfaces; Images formed by spherical mirrors, centre of curvature,',
         'principal axis, principal focus, focal length, mirror formula (Derivation not required), magnification.',
         'Refraction; Laws of refraction, refractive index.',
         'Our Environment: Eco-system, Environmental problems, Ozone depletion, waste production and their solutions.']


def pdf():
    b = io.BytesIO(); c = canvas.Canvas(b); y = 800
    for l in LINES: c.drawString(20, y, l); y -= 18
    c.save(); return b.getvalue()


PDF = pdf()
CAT = [{'id': 879, 'en': 'Light & Optics', 'slug': 'phy-light'}, {'id': 920, 'en': 'Environment & Ecology', 'slug': 'env-ecology'},
       {'id': 880, 'en': 'Electricity', 'slug': 'phy-electricity'}, {'id': 1, 'en': 'Percentage', 'slug': 'pct'}]
results = []


def case(name):
    def deco(fn):
        try: fn(); results.append((name, True, ''))
        except AssertionError as e: results.append((name, False, str(e)[:300]))
        except Exception as e: results.append((name, False, f'{type(e).__name__}: {e}'[:300]))
        return fn
    return deco


def go(answer):
    m = Mock(); m.extract_fn = lambda p: answer
    out = tempfile.mktemp(suffix='.json')
    rep = S.run('Class 10, CBSE 2026-27, Science', m, lambda u: (200, PDF), CAT, out)
    return rep, json.load(open(out)), m


def chap(syl, no): return [c for c in syl['subjects'][0]['chapters'] if c['no'] == no][0]


@case('S1 lines printed in the PDF become verified scope with key phrases; Electricity stays as it was')
def _():
    rep, syl, m = go({'chapters': [{'no': 9, 'items': [
        {'text': 'Refraction; Laws of refraction, refractive index.', 'key_phrases': ['laws of refraction', 'refractive index'], 'key_phrases_hi': ['अपवर्तन के नियम', 'अपवर्तनांक']},
        {'text': 'mirror formula (Derivation not required), magnification.', 'key_phrases': ['mirror formula', 'magnification'], 'key_phrases_hi': ['दर्पण सूत्र', 'आवर्धन']}]}]})
    c = chap(syl, 9)
    assert c['scope_verified'] and len(c['scope_items']) == 2 and c['scope_items'][0]['need_any'] == [['laws of refraction'], ['refractive index']], c
    assert chap(syl, 11)['scope_verified'] and chap(syl, 11)['scope_items'][0]['id'] == 'current_pd'
    assert 'Electricity' not in m.last_extract.split('PDF TEXT')[0], 'already verified chapters are not re-extracted'


@case('S2 an AI line NOT printed in the PDF is dropped and the chapter stays unverified (AI cannot invent syllabus)')
def _():
    rep, syl, m = go({'chapters': [{'no': 13, 'items': [
        {'text': 'Eco-system, Environmental problems, Ozone depletion', 'key_phrases': ['ozone depletion'], 'key_phrases_hi': ['ओजोन']},
        {'text': 'Global warming and carbon credits', 'key_phrases': ['carbon credits'], 'key_phrases_hi': ['']}]}]})
    c = chap(syl, 13)
    assert not c['scope_verified'] and len(c['scope_items']) == 1, c
    assert [x for x in rep['chapters'] if x['no'] == 13][0]['dropped'] == ['Global warming and carbon credits']


@case('S3 key phrase not inside its own line -> removed; line with no grounded phrase -> dropped')
def _():
    rep, syl, m = go({'chapters': [{'no': 9, 'items': [{'text': 'Refraction; Laws of refraction, refractive index.', 'key_phrases': ['snell law'], 'key_phrases_hi': ['स्नेल']}]}]})
    assert not chap(syl, 9)['scope_verified']


@case('S4 app mapping: clear single name match only (Electricity->880 kept; Environment->920; Light->879; nothing for unmatched)')
def _():
    rep, syl, m = go({'chapters': []})
    assert chap(syl, 11)['app']['chapter_id'] == 880 and chap(syl, 13)['app']['chapter_id'] == 920, (chap(syl, 13).get('app'))
    assert chap(syl, 9).get('app', {}).get('chapter_id') == 879, chap(syl, 9).get('app')
    assert not chap(syl, 1).get('app'), chap(syl, 1).get('app')


@case('S5 PDF not reachable -> blocked (ProviderUnavailable), nothing written')
def _():
    m = Mock(); out = tempfile.mktemp()
    try:
        S.run('Class 10, CBSE 2026-27, Science', m, lambda u: (404, b''), CAT, out); assert False, 'should raise'
    except S.ProviderUnavailable:
        assert not os.path.exists(out)


if __name__ == '__main__':
    for n, ok, why in results: print(('PASS ' if ok else 'FAIL ') + n + ('' if ok else '  -> ' + why))
    print(f'{sum(ok for _, ok, _ in results)}/{len(results)} passed')
