"""Book robot tests: mock AI that answers each stage; checks the owner's HTML format, depth gates and safety. No network."""
import json, os, re, shutil, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import job as J, book_robot as B, book_render as R
from providers import Mock
from common import ProviderUnavailable

FP = os.environ.get('COPYRIGHT_FINGERPRINTS', '/tmp/db-main/robots/copyright/fingerprints')
CMD = 'Class 10, CBSE 2026-27, Science, Electricity'
W = 'झिलमिल कौतुक गुलमोहर तितली पतंग सारंगी कदंब चंपा केतकी मधुबन पगडंडी झरना कुहासा नीलकंठ टेसू पलाश '
E = 'zephyr quokka marmalade lantern cobalt saffron meadow tundra pebble violin harbor juniper orchid falcon '
P2 = lambda n=1: [W * n, E * n]
TOPICS = [('Electric current', 'विद्युत धारा', 'current_pd'), ('Potential difference', 'विभवांतर', 'current_pd'), ("Ohm's law", 'ओम का नियम', 'ohm'),
          ('Resistance and resistivity: length, area, material, temperature', 'प्रतिरोध और प्रतिरोधकता', 'resistance'),
          ('Resistors in series', 'श्रेणी', 'combos'), ('Resistors in parallel', 'पार्श्व', 'combos'),
          ('Heating effect of current', 'तापीय प्रभाव', 'heating'), ('Electric power P = V × I', 'विद्युत शक्ति', 'power'),
          ('Joule law uses', 'जूल', 'heating'), ('Electric circuits', 'परिपथ', 'current_pd')]
SVG = '<svg viewBox="0 0 340 200" xmlns="http://www.w3.org/2000/svg"><line x1="10" y1="10" x2="200" y2="10" stroke="#000"/><circle cx="50" cy="50" r="10"/><text x="60" y="60">R</text></svg>'


class Smart(Mock):
    def __init__(self, bad=None, **k):
        super().__init__(**k); self.bad = bad or {}; self.n = {}
    def write(self, prompt):
        self.calls.append('write'); self.last_prompt = prompt
        stage = ('plan' if 'Plan one chapter' in prompt else 'concepts' if 'note panels' in prompt else 'extras' if '5 solved numericals' in prompt
                 else 'teach' if 'friendly teacher' in prompt else 'hinglish' if 'Hinglish' in prompt else 'demo')
        self.n[stage] = self.n.get(stage, 0) + 1
        if stage in self.bad and self.n[stage] <= self.bad[stage][0]:
            out = self.bad[stage][1]
            if isinstance(out, Exception): raise out
            return out, 'mock-writer', 'mock-writer-1'
        return json.dumps(getattr(self, 'a_' + stage)(prompt), ensure_ascii=False), 'mock-writer', 'mock-writer-1'
    def a_plan(self, p):
        return {'titles': ['11. विद्युत', '11. Electricity'], 'short': ['विद्युत', 'Electricity'],
                'intro': {'paras': [P2()], 'kv': [[P2(), P2()]]},
                'concepts': [{'key': f'c{i}', 'emoji': '⚡', 'title': [h, e], 'scope_ids': [sid], 'diagram': i < 3, 'points': e} for i, (e, h, sid) in enumerate(TOPICS)],
                'teach': [{'heading': ['शुरुआत', 'Start'], 'emoji': '🚗', 'concept_keys': []}] + [{'heading': [h, e], 'emoji': '📘', 'concept_keys': [f'c{i}']} for i, (e, h, s) in enumerate(TOPICS)]}
    def a_concepts(self, p):
        keys = re.findall(r'"key": "(c\d+)"', p.split('Panels to write:')[1].split('Return ONLY')[0])
        return {'concepts': [{'key': k, 'emoji': '⚡', 'title': [TOPICS[int(k[1:])][1], TOPICS[int(k[1:])][0]], 'paras': [P2(3), P2(3), P2(3)],
                              'kv': [[P2(), P2()]] * 4, 'table': {'head': [P2(), P2()], 'rows': [[P2(), P2()]]}, 'formula': {'expr': 'V = I × R', 'units': [[['V', 'V'], ['वोल्ट', 'volt']]]},
                              'tip': P2(), 'diagram': {'svg': SVG, 'caption': P2()}} for k in keys]}
    def a_extras(self, p):
        return {'numericals': [{'title': P2(), 'given': [f'प्रश्न {i}: 12 V, 4 Ω', f'Q{i}: 12 V across 4 ohm, current?'], 'steps': [['I = V/R', 'I = V/R'], ['I = 12/4 = 3 A', 'I = 12/4 = 3 A']],
                                'answer': ['3 A', '3 A']} for i in range(5)],
                'revision': [[P2(), P2()] for _ in range(10)], 'practice': [{'q': P2(), 'a': P2()} for _ in range(10)],
                'formulas': [{'f': f, 't': P2(), 's': P2(), 'u': P2(), 'group': g} for f, g in [('V = I × R', 'ohm'), ('R = ρL/A', 'ohm'), ('P = V × I', 'power'),
                                                                                                ('H = I^2 R t', 'power'), ('R = R1 + R2', 'comb'), ('1/R = 1/R1 + 1/R2', 'comb')]],
                'formula_groups': [['ohm', 'ओम', 'Ohm'], ['power', 'शक्ति', 'Power'], ['comb', 'संयोजन', 'Combination']]}
    def a_teach(self, p):
        n = len(json.loads(p.split('Lessons: ')[1].split('\nReturn ONLY')[0]))
        return {'teach': [{'emoji': '📘', 'heading': P2(), 'paras': [P2(4), P2(4), P2(4)], 'formula': 'V = I × R', 'example': {'label': ['समझो ऐसे', 'Think'], 'text': P2()}} for _ in range(n)]}
    def a_hinglish(self, p):
        n = len(json.loads(p.split('\n\n', 1)[1]))
        return {'hinglish': [{'emoji': '📘', 'heading': 'Shuruaat', 'paras': ['Yeh ek line hai'], 'formula': None, 'example': None} for _ in range(n)]}
    def a_demo(self, p):
        return {'title': ['ओम का नियम', "Ohm's law"], 'hint': P2(), 'slider': ['वोल्टेज', 'Voltage'], 'min': 0, 'max': 12, 'step': 1, 'val': 6,
                'script': 'const I=v/4; arrow(new THREE.Vector3(0,0,0),new THREE.Vector3(I,0,0),0xf59e0b); info.textContent=T("धारा ","Current ")+I.toFixed(2)+" A";'}


def solver(givens): return ['I = 3 A'] * len(givens)
results = []


def case(name):
    def deco(fn):
        d = tempfile.mkdtemp(prefix='bk_'); J.JOBS = d
        try: fn(d); results.append((name, True, ''))
        except AssertionError as e: results.append((name, False, str(e)[:400]))
        except Exception as e: results.append((name, False, f'{type(e).__name__}: {e}'[:400]))
        finally: shutil.rmtree(d, ignore_errors=True)
        return fn
    return deco


def M(**k):
    m = Smart(**k); m.solve_num_fn = solver; return m


def jd(out): return json.load(open(os.path.join(out['dir'], 'job.json')))


@case('B1 one command -> chapter_books row in the owner format (notes hi/en panels, 4 teach modes, formulas+groups, 3D) -> review_ready, status draft')
def _(d):
    P = M(); out = B.run(CMD, P, reference_dir=FP)
    assert out['final_state'] == 'review_ready', (out, jd(out)['issues'][-2:])
    row = json.load(open(os.path.join(out['dir'], 'chapter_books_row.json'))); dd = row['data']
    assert row['status'] == 'draft' and row['topic_id'] == 880 and dd['kind'] == 'chN'
    for cls in ('sheet-header', 'panel blue', 'panel-header', 'kv-item', 'formula-box', 'tip-box', 'diagram-container', 'solution-box', 'sol-step', 'sol-answer', '<table>'):
        assert cls in dd['notes_hi'] and cls in dd['notes_en'], cls
    assert set(dd['teach']) == {'hindi', 'english', 'hinglish', 'bilingual'} and 'teach-en-follow' in dd['teach']['bilingual']
    assert 'Class mein Welcome' in dd['teach']['hinglish'] and dd['teach']['hindi'].count('class="teach-sec"') >= 12
    assert dd['formulas'][0].keys() >= {'cat', 'f', 'fe', 't', 's', 'u'} and len(dd['formula_groups']) == 3
    assert dd['demo_html'].startswith('<!DOCTYPE html>') and 'makeDemoDoc' not in dd['demo_html'] and 'three.min.js' in dd['demo_html']
    assert '<script>' not in dd['notes_hi'] and '<script' not in dd['notes_en']


@case('B2 thin plan (too few concepts / a syllabus item without a concept) -> rejected with reasons, fixed plan accepted')
def _(d):
    thin = json.dumps({'titles': ['11. विद्युत', '11. Electricity'], 'intro': {'paras': [P2()]}, 'concepts': [{'key': 'c0', 'title': P2(), 'scope_ids': ['ohm']}], 'teach': []})
    P = M(bad={'plan': (1, thin)}); out = B.run(CMD, P, reference_dir=FP)
    assert out['final_state'] == 'review_ready', jd(out)['issues'][-2:]
    assert 'concepts: 1 (want 10-14)' in P.last_prompt or jd(out)['stages']['plan']['attempts'] == 2


@case('B3 unsafe SVG (script/onclick) is never shown: dropped and recorded; url(#marker) arrows are allowed')
def _(d):
    bad = Smart().a_concepts.__func__
    class P(Smart):
        k = 0
        def a_concepts(self, p):
            o = bad(self, p); P.k += 1
            if P.k == 1: o['concepts'][0]['diagram']['svg'] = '<svg viewBox="0 0 340 200" xmlns="http://www.w3.org/2000/svg"><line x1="1" y1="1" x2="9" y2="9"/><circle cx="5" cy="5" r="2"/><text x="1" y="1" onclick="alert(1)">R</text><script>alert(1)</script></svg>'
            return o
    m = P(); m.solve_num_fn = solver; out = B.run(CMD, m, reference_dir=FP)
    row = json.load(open(os.path.join(out['dir'], 'chapter_books_row.json')))
    assert 'alert(1)' not in json.dumps(row) and 'diagram_dropped' in json.dumps(jd(out)['issues'])


@case('B4 numerical answer not confirmed by the independent solver -> needs_review, reason listed')
def _(d):
    m = M(); m.solve_num_fn = lambda g: ['I = 5 A'] + ['3 A'] * (len(g) - 1)
    out = B.run(CMD, m, reference_dir=FP)
    assert out['final_state'] == 'needs_review' and 'numerical 1' in json.dumps(jd(out)['issues'])


@case('B5 broken 3D script (throws) -> rejected and rewritten; final model passes the node test')
def _(d):
    m = M(bad={'demo': (1, json.dumps({'title': P2(), 'hint': P2(), 'slider': P2(), 'min': 0, 'max': 1, 'step': 1, 'val': 0, 'script': 'nope(;'}))})
    out = B.run(CMD, m, reference_dir=FP)
    assert out['final_state'] == 'review_ready' and jd(out)['stages']['demo']['attempts'] == 2


@case('B6 too little text (depth gate) -> needs_review with word counts')
def _(d):
    class P(Smart):
        def a_concepts(self, p):
            o = super().a_concepts(p)
            for c in o['concepts']: c['paras'] = [['छोटा', 'short']] * 3
            return o
        def a_teach(self, p):
            o = super().a_teach(p)
            for s in o['teach']: s['paras'] = [['छोटा', 'short']] * 3
            return o
    m = P(); m.solve_num_fn = solver; out = B.run(CMD, m, reference_dir=FP)
    assert out['final_state'] == 'needs_review' and 'words (min' in json.dumps(jd(out)['issues'])


@case('B7 quota stop in the middle (teach) -> blocked; rerun continues WITHOUT redoing plan/concepts/extras')
def _(d):
    out = B.run(CMD, M(bad={'teach': (1, ProviderUnavailable('gemini', 'quota'))}), reference_dir=FP)
    assert out['final_state'] == 'blocked'
    P = M(); out = B.run(CMD, P, reference_dir=FP)
    assert out['final_state'] == 'review_ready' and P.n.get('plan', 0) == 0 and P.n.get('concepts', 0) == 0 and P.n.get('extras', 0) == 0, P.n


@case('B9 SVG with marker arrows url(#m) is accepted')
def _(d):
    assert R.safe_svg('<svg viewBox="0 0 10 10" xmlns="http://www.w3.org/2000/svg"><defs><marker id="m"><path d="M0,0 L1,1"/></marker></defs><line x1="0" y1="0" x2="5" y2="5" marker-end="url(#m)"/></svg>')
    assert not R.safe_svg('<svg viewBox="0 0 10 10"><rect/><line/><circle/><image href="x"/></svg>')


@case('B10 fact checker names a concept -> that concept is rewritten once with the reason, checks run again -> review_ready')
def _(d):
    m = M(); n = {'k': 0}
    def fact(c, l):
        n['k'] += 1
        return (False, "In 'Ohm's law' the statement is wrong") if n['k'] == 1 else (True, '')
    m.fact = fact; out = B.run(CMD, m, reference_dir=FP); j = jd(out)
    assert out['final_state'] == 'review_ready' and j['corrected']['concepts'] == ['c2'] and m.n['concepts'] == 5, (out, j.get('corrected'), m.n)


@case('B8 renderer: AI text is escaped (no HTML injection), **bold** and x^2 become <strong>/<sup>')
def _(d):
    h = R.t(['<b>x</b> **ज़रूरी** v^2', 'e'], 'hi')
    assert '<b>' not in h and '&lt;b&gt;' in h and '<strong>ज़रूरी</strong>' in h and 'v<sup>2</sup>' in h, h


if __name__ == '__main__':
    for n, ok, why in results: print(('PASS ' if ok else 'FAIL ') + n + ('' if ok else '  -> ' + why))
    print(f'{sum(ok for _, ok, _ in results)}/{len(results)} passed')
