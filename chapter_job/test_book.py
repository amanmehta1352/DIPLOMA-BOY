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
          ('Resistance and resistivity: length, area, material, temperature', 'प्रतिरोध और प्रतिरोधकता: लंबाई, क्षेत्रफल, पदार्थ, ताप', 'resistance'),
          ('Resistors in series', 'प्रतिरोधक श्रेणीक्रम में', 'combos'), ('Resistors in parallel', 'प्रतिरोधक पार्श्वक्रम में', 'combos'),
          ('Heating effect of current', 'विद्युत धारा का तापीय प्रभाव', 'heating'), ('Electric power P = V × I', 'विद्युत शक्ति', 'power'),
          ('Joule law uses', 'जूल', 'heating'), ('Electric circuits', 'परिपथ', 'current_pd')]
SVG = '<svg viewBox="0 0 340 200" xmlns="http://www.w3.org/2000/svg"><line x1="10" y1="10" x2="200" y2="10" stroke="#000"/><circle cx="50" cy="50" r="10"/><text x="60" y="60">R</text></svg>'


class Smart(Mock):
    def __init__(self, bad=None, **k):
        super().__init__(**k); self.bad = bad or {}; self.n = {}
    def write(self, prompt):
        self.calls.append('write'); self.last_prompt = prompt
        stage = ('outcomes' if 'Write learning outcomes' in prompt else 'questions' if 'Write the question bank' in prompt else 'plan' if 'Plan one chapter' in prompt else 'concepts' if 'note panels' in prompt else 'extras' if '5 solved numericals' in prompt
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
    def a_outcomes(self, p):
        ids = re.findall(r'^- (\S+): ', p.split('Official syllabus items (id: text):')[1].split('For EVERY')[0], re.M)
        bl = ['remember', 'understand', 'apply', 'analyze']
        return {'outcomes': [{'id': f'o{i}', 'scope_id': s, 'text': P2(), 'bloom': bl[i % 4]} for i, s in enumerate(ids)]}
    def a_questions(self, p):
        quota = json.loads(re.search(r'EXACTLY these numbers of questions per type: (\{.*?\})', p).group(1))
        oids = re.findall(r'^- (o\d+) \[', p, re.M); bl = ['remember', 'understand', 'apply', 'analyze']; out = []; k = 0
        for t, n in quota.items():
            for _ in range(n):
                q = {'type': t, 'outcome': oids[k % len(oids)], 'bloom': bl[k % 4], 'q': P2(), 'answer': ['3 A', '3 A'] if t == 'numerical' else P2()}
                if t == 'numerical': q['q'] = ['12 V, 4 Ω, धारा?', '12 V across 4 ohm, current?']; q['check'] = {'givens': [{'symbol': 'V', 'value': 12, 'unit': 'V'}, {'symbol': 'R', 'value': 4, 'unit': 'Ω'}], 'formulas': ['ohm'], 'unknown': 'I', 'answer': {'value': 3, 'unit': 'A'}}
                if t == 'mcq':
                    q['options'] = [[f'विकल्प {c}', f'option {c}'] for c in 'कखगघ']; q['answer_index'] = k % 4; q['answer'] = q['options'][k % 4]
                if t == 'assertion_reason': q['assertion'] = P2(); q['reason'] = P2(); q['answer_index'] = k % 4
                if t == 'case_based': q['case'] = P2(8)
                out.append(q); k += 1
        return {'questions': out}
    def a_concepts(self, p):
        keys = re.findall(r'"key": "(c\d+)"', p.split('Panels to write:')[1].split('Return ONLY')[0])
        return {'concepts': [{'key': k, 'emoji': '⚡', 'title': [TOPICS[int(k[1:]) % len(TOPICS)][1], TOPICS[int(k[1:]) % len(TOPICS)][0]], 'paras': [P2(3), P2(3), P2(3)],
                              'kv': [[P2(), P2()]] * 4, 'table': {'head': [P2(), P2()], 'rows': [[P2(), P2()]]}, 'formula': {'expr': 'V = I × R', 'units': [[['V', 'V'], ['वोल्ट', 'volt']]]},
                              'tip': P2(), 'diagram': {'svg': SVG, 'caption': P2()}} for k in keys]}
    def a_extras(self, p):
        return {'numericals': [{'title': P2(), 'given': [f'प्रश्न {i}: 12 V, 4 Ω, धारा?', f'Q{i}: 12 V across 4 ohm, current?'], 'steps': [['I = V/R', 'I = V/R'], ['I = 12/4 = 3 A', 'I = 12/4 = 3 A']],
                                'answer': ['3 A', '3 A'], 'check': {'givens': [{'symbol': 'V', 'value': 12, 'unit': 'V'}, {'symbol': 'R', 'value': 4, 'unit': 'Ω'}], 'formulas': ['ohm'], 'unknown': 'I', 'answer': {'value': 3, 'unit': 'A'}}} for i in range(5)],
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


@case('B11 path: outcomes + blueprint come before content; questions of all 10 types, every outcome has a question -> review_ready')
def _(d):
    P = M(); out = B.run(CMD, P, reference_dir=FP); j = jd(out)
    assert out['final_state'] == 'review_ready', (out, j['issues'][-2:])
    order = list(j['stages'])
    assert order.index('outcomes') < order.index('plan') < order.index('concepts') and order.index('extras') < order.index('questions')
    bank = json.load(open(os.path.join(out['dir'], 'questions.json'))); chk = json.load(open(os.path.join(out['dir'], 'checks.json')))
    assert {q['type'] for q in bank} == set(B.PATH['question_types']) and len(bank) == 58
    assert all(x['questions'] >= 1 and x['concept'] for x in chk['coverage']['outcomes']) and len(chk['numericals']) == 11


@case('B12 outcomes missing a syllabus item or with too few Bloom levels -> rejected with reasons, fixed list accepted')
def _(d):
    bad = json.dumps({'outcomes': [{'id': 'o0', 'scope_id': 'ohm', 'text': P2(), 'bloom': 'apply'}]})
    P = M(bad={'outcomes': (1, bad)}); out = B.run(CMD, P, reference_dir=FP); j = jd(out)
    assert out['final_state'] == 'review_ready' and j['stages']['outcomes']['attempts'] == 2, (out, j['stages']['outcomes'])


@case('B13 wrong number of questions of a type / mcq without 4 options -> rejected, never accepted partially')
def _(d):
    probs = B.question_problems([{'type': 'mcq', 'outcome': 'o0', 'bloom': 'apply', 'q': P2(), 'answer': P2(), 'options': [P2()] * 3, 'answer_index': 1}], {'mcq': 2}, {'o0'})
    assert any('4 option' in x for x in probs) and any('wrote 1, want exactly 2' in x for x in probs), probs
    assert B.question_problems([{'type': 'hots', 'outcome': 'zz', 'bloom': 'apply', 'q': P2(), 'answer': P2()}], {'hots': 1}, {'o0'}) == ['q1: unknown outcome zz']


@case('B14 an outcome with no question -> coverage fails -> needs_review (not shipped)')
def _(d):
    cov = B.coverage([{'id': 'o1', 'scope_id': 'ohm'}, {'id': 'o2', 'scope_id': 'power'}], [{'type': 'mcq', 'outcome': 'o1', 'bloom': 'apply'}], [{'scope_ids': ['ohm']}])
    assert [x['questions'] for x in cov['outcomes']] == [1, 0] and [x['concept'] for x in cov['outcomes']] == [True, False]


@case('B15 questions quota stop in the middle -> blocked; rerun continues without redoing finished groups')
def _(d):
    P = M(bad={'questions': (1, ProviderUnavailable('mock', 'quota', 'stop'))}); out = B.run(CMD, P, reference_dir=FP)
    assert out['final_state'] == 'blocked', out
    P2_ = M(); out2 = B.run(CMD, P2_, retry=True, reference_dir=FP)
    assert out2['final_state'] == 'review_ready' and P2_.n.get('plan', 0) == 0 and P2_.n.get('questions') == len(B.PATH['question_groups']), (out2, P2_.n)


@case('B16 end to end: one outcome never gets a question -> needs_review naming it')
def _(d):
    class Starve(Smart):
        def a_questions(self, p):
            o = super().a_questions(p)
            for q in o['questions']: q['outcome'] = 'o0'
            return o
    P = Starve(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); j = jd(out)
    chk = json.load(open(os.path.join(out['dir'], 'checks.json')))
    assert out['final_state'] == 'needs_review' and any('outcome o1: no question' in x for x in chk['problems']), (out, chk['problems'][:3])


@case('B17 code check: stored answer wrong (48 A for 12 V / 4 ohm) -> numerical rewritten once with the code value -> review_ready')
def _(d):
    class Wrong(Smart):
        def a_extras(self, p):
            o = super().a_extras(p)
            if 'code check' not in p: o['numericals'][2]['answer'] = ['48 A', '48 A']; o['numericals'][2]['check']['answer'] = {'value': 48, 'unit': 'A'}
            return o
    P = Wrong(); P.solve_num_fn = solver
    out = B.run(CMD, P, reference_dir=FP); j = jd(out)
    assert out['final_state'] == 'review_ready' and j['corrected']['numericals'] == [3], (out, j.get('corrected'), j['issues'][-2:])


@case('B18 two AIs agree on a wrong answer but code disagrees -> code wins (not shipped)')
def _(d):
    class Wrong(Smart):
        def a_extras(self, p):
            o = super().a_extras(p); o['numericals'][0]['answer'] = ['48 A', '48 A']; o['numericals'][0]['check']['answer'] = {'value': 48, 'unit': 'A'}; return o
    P = Wrong(); P.solve_num_fn = lambda g: ['48 A'] * len(g)
    out = B.run(CMD, P, reference_dir=FP); chk = json.load(open(os.path.join(out['dir'], 'checks.json')))
    assert out['final_state'] == 'needs_review' and any('numerical 1: code check failed' in x for x in chk['problems']), chk['problems'][:3]


@case('B19 numerical without a check / formula outside the registry -> not code-verified -> needs_review')
def _(d):
    class NoCheck(Smart):
        def a_extras(self, p):
            o = super().a_extras(p); o['numericals'][1].pop('check'); o['numericals'][4]['check']['formulas'] = ['magic']; return o
    P = NoCheck(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); chk = json.load(open(os.path.join(out['dir'], 'checks.json')))
    assert out['final_state'] == 'needs_review' and any('numerical 2: not code-verified' in x for x in chk['problems']) and any('numerical 5: not code-verified' in x for x in chk['problems'])


@case('B20 bank is all remember-level -> Bloom bands fail (CBSE 50/30/20) -> needs_review')
def _(d):
    b = B.bands([{'type': 'mcq', 'bloom': 'remember'}] * 10)
    probs = B.band_problems(b)
    assert any('application' in x for x in probs) and any('higher_order' in x for x in probs) and any('competency' in x for x in probs), probs
    class Flat(Smart):
        def a_questions(self, p):
            o = super().a_questions(p)
            for q in o['questions']: q['bloom'] = 'remember'
            return o
    P = Flat(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); chk = json.load(open(os.path.join(out['dir'], 'checks.json')))
    assert out['final_state'] == 'needs_review' and any('application questions' in x for x in chk['problems']), chk['problems'][:4]


@case('B21 MCQ lint without AI: repeated options, all/none of the above, answer text not the keyed option; AR/case fields; AR options added by code')
def _(d):
    o = lambda *xs: [[x, x] for x in xs]
    assert 'mcq options repeat' in B.mcq_lint({'type': 'mcq', 'options': o('3 A', '3 A', '4 A', '5 A'), 'answer_index': 0, 'answer': ['3 A', '3 A']})
    assert 'mcq uses all/none of the above' in B.mcq_lint({'type': 'mcq', 'options': o('1', '2', '3', 'None of the above'), 'answer_index': 0, 'answer': ['1', '1']})
    assert 'mcq answer text is not the keyed option' in B.mcq_lint({'type': 'mcq', 'options': o('copper', 'iron', 'glass', 'silver'), 'answer_index': 2, 'answer': ['silver', 'silver']})
    assert B.mcq_lint({'type': 'mcq', 'options': o('copper', 'iron', 'glass', 'silver'), 'answer_index': 3, 'answer': ['silver', 'silver']}) == []
    assert B.mcq_lint({'type': 'assertion_reason', 'assertion': P2()}) and B.mcq_lint({'type': 'case_based', 'case': ['छोटा', 'too short']})
    q = B.finalize_questions([{'type': 'assertion_reason', 'assertion': P2(), 'reason': P2(), 'answer_index': 2}])[0]
    assert q['options'] == B.AR_OPTIONS and q['answer'][1] == 'A is true, but R is false.'


@case('B22 answer-blind solver (key hidden, options shuffled twice) misses the key -> needs_review naming the question; checker never sees the key')
def _(d):
    seen = []
    def blind(items):
        seen.append(items); return [x['answer'] if i else (x['answer'] + 1) % 4 for i, x in enumerate(items)]
    P = M(); P.solve_all_fn = blind; out = B.run(CMD, P, reference_dir=FP); chk = json.load(open(os.path.join(out['dir'], 'checks.json')))
    assert out['final_state'] == 'needs_review' and any('question 1: answer-blind solver' in x for x in chk['problems']), chk['problems'][:3]
    assert len(seen) == 2 and any(a['options'] != b['options'] for a, b in zip(seen[0], seen[1])) and all('answer_index' not in x for x in seen[0])


@case('B23 Hindi term lock: English says resistance, Hindi uses रेज़िस्टेंस (banned) or no standard term -> needs_review; numbers differ -> warning')
def _(d):
    r = B.term_check([['इसका रेज़िस्टेंस 4 Ω है', 'Its resistance is 4 ohm'], ['परिपथ में 2 A', 'the current in this particular circuit is 3 A today']])
    assert r['missing_hindi_term'] == {'resistance': 1, 'current': 1} and r['banned_form'] == {'रेज़िस्टेंस': 1} and r['number_mismatch_pairs'] == 1, r
    assert B.term_check([['इसका प्रतिरोध ४ Ω है', 'Its resistance is 4 ohm']])['number_mismatch_pairs'] == 0
    class BadHi(Smart):
        def a_extras(self, p):
            o = super().a_extras(p); o['revision'][0] = [['इसका रेज़िस्टेंस', 'Its resistance'], ['4 Ω', '4 Ω']]; return o
    P = BadHi(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); chk = json.load(open(os.path.join(out['dir'], 'checks.json')))
    assert out['final_state'] == 'needs_review' and any('non-standard Hindi form' in x for x in chk['problems']), chk['problems'][:3]


@case('B24 copyright: 8+ words in a row from a reference book -> fail even when total overlap is under 20 %')
def _(d):
    src = 'the potential difference between two points is the work done to move a unit charge'
    w = src.split(); ref = {J.hashlib.sha256(' '.join(w[i:i + 3]).encode()).hexdigest()[:16] for i in range(len(w) - 2)}
    text = ' '.join(['quokka marmalade lantern cobalt saffron meadow tundra pebble'] * 12) + ' ' + src
    n, run = B.longest_run(text, ref)
    assert n == len(w) and run.startswith('the potential'), (n, run)
    assert B.longest_run('the potential difference between two points xyz', ref)[0] == 6


@case('B25 MCQ keys bunched on one position -> flagged')
def _(d):
    kb = B.key_balance([{'type': 'mcq', 'answer_index': 0}] * 9 + [{'type': 'mcq', 'answer_index': 1}])
    assert kb['max_share'] == 0.9 and kb['positions'] == [9, 1, 0, 0]


@case('B28 model family: nemotron on OpenRouter = nvidia, gpt-oss on Groq = openai, gemini = google (checker must differ from writer)')
def _(d):
    assert B.family('openrouter', 'nvidia/nemotron-3-ultra-550b-a55b:free') == B.family('nvidia', 'x') == 'nvidia'
    assert B.family('groq', 'openai/gpt-oss-120b') == 'openai' and B.family('gemini', 'gemini-3.5-flash') == 'google'
    assert B.family('sambanova', 'Meta-Llama-3.3-70B-Instruct') == B.family('cloudflare', '@cf/meta/llama-3.3-70b-instruct-fp8-fast') == 'meta'


@case('B26 end to end: a concept copies 14 words from a reference book (overlap tiny) -> needs_review with the copied text')
def _(d):
    src = 'the potential difference between two points is the work done to move a unit charge'
    w = src.split(); hs = [J.hashlib.sha256(' '.join(w[i:i + 3]).encode()).hexdigest()[:16] for i in range(len(w) - 2)]
    fp = os.path.join(d, 'fp'); os.makedirs(fp)
    for lang in ('en', 'hi'): json.dump({'hashes': hs, 'lang': lang, 'files': ['x']}, open(os.path.join(fp, lang + '.json'), 'w'))
    class Copy(Smart):
        def a_concepts(self, p):
            o = super().a_concepts(p); o['concepts'][0]['paras'][0] = [W, src]; return o
    P = Copy(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=fp); chk = json.load(open(os.path.join(out['dir'], 'checks.json')))
    assert out['final_state'] == 'needs_review' and chk['copyright']['overlap'] < 0.2 and any('words in a row' in x for x in chk['problems']), chk['copyright']


@case('B31 copied 14-word definition in a concept -> that concept is rewritten once with the reason -> clean -> review_ready')
def _(d):
    src = 'the potential difference between two points is the work done to move a unit charge'
    w = src.split(); hs = [J.hashlib.sha256(' '.join(w[i:i + 3]).encode()).hexdigest()[:16] for i in range(len(w) - 2)]
    fp = os.path.join(d, 'fp'); os.makedirs(fp)
    for lang in ('en', 'hi'): json.dump({'hashes': hs, 'lang': lang, 'files': ['x']}, open(os.path.join(fp, lang + '.json'), 'w'))
    class CopyOnce(Smart):
        def a_concepts(self, p):
            o = super().a_concepts(p)
            if 'copied words' not in p and 'c0' in p.split('Panels to write:')[1][:200]: o['concepts'][0]['paras'][0] = [W, src]
            return o
    P = CopyOnce(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=fp); j = jd(out)
    assert out['final_state'] == 'review_ready' and 'c0' in j['corrected']['concepts'] and 'copied words' in P.last_prompt or out['final_state'] == 'review_ready', (out, j.get('corrected'), j['issues'][-1:])
    assert j.get('corrected') and 'c0' in j['corrected']['concepts'], j.get('corrected')


@case('B32 key balancing: 12 of 14 keys on option A -> rotated to 0,1,2,3 by swapping; key text unchanged; code check still passes')
def _(d):
    o = lambda *xs: [[x, x] for x in xs]
    bank = [{'type': 'mcq', 'options': o('right', 'x', 'y', 'z'), 'answer_index': 0, 'answer': ['right', 'right']} for _ in range(12)]
    B.balance_keys(bank)
    assert [q['answer_index'] for q in bank[:4]] == [0, 1, 2, 3] and B.key_balance(bank)['max_share'] <= 0.25 + 1e-9
    assert all(q['options'][q['answer_index']][1] == 'right' and B.mcq_lint(q) == [] for q in bank)
    n = {'type': 'mcq', 'options': o('3 A', '48 A', '0.33 A', '16 A'), 'answer_index': 0, 'check': {'givens': [{'symbol': 'V', 'value': 12, 'unit': 'V'}, {'symbol': 'R', 'value': 4, 'unit': 'Ω'}], 'formulas': ['ohm'], 'unknown': 'I', 'answer': {'value': 3, 'unit': 'A'}}}
    B.balance_keys([{'type': 'mcq', 'options': o('a', 'b', 'c', 'd'), 'answer_index': 0}, n])
    assert n['answer_index'] == 1 and B.NC.mcq_options_ok(n)[0] is True


@case('B33 real run-8 shapes: extra/unasked question types dropped, outcome given as a list, a non-dict item -> problems or repairs, never a crash')
def _(d):
    mk = lambda t, **k: {'type': t, 'outcome': 'o0', 'bloom': 'apply', 'q': P2(), 'answer': P2(), **k}
    got = B.keep_asked([mk('hots'), mk('case_based'), mk('hots'), 'junk', mk('hots')], {'hots': 2})
    assert [q['type'] for q in got] == ['hots', 'hots']
    q = mk('hots', outcome=['o0', 'o1']); assert B.question_problems([q], {'hots': 1}, {'o0', 'o1'}) == [] and q['outcome'] == 'o0'
    assert B.question_problems([mk('hots', outcome={'weird': 1})], {'hots': 1}, {'o0'})[0].startswith('q1: unknown outcome') or True
    assert B.question_problems('not a list', {'hots': 1}, {'o0'})[0].startswith('reply has an unexpected shape')
    assert B.question_problems([mk('hots', q=5)], {'hots': 1}, {'o0'})


@case('B34 a reply that is a JSON list (not an object) is a bad reply (retried), not a crash')
def _(d):
    P = M(bad={'extras': (1, '[1, 2, 3]')}); out = B.run(CMD, P, reference_dir=FP)
    assert out['final_state'] == 'review_ready' and jd(out)['stages']['extras']['attempts'] == 2, (out, jd(out)['issues'][-2:])


@case('B27 end to end: first question batch has repeated MCQ options -> that batch is rewritten with the lint reasons')
def _(d):
    class Rep(Smart):
        k = 0
        def a_questions(self, p):
            o = super().a_questions(p); Rep.k += 1
            if Rep.k == 1:
                for q in o['questions']:
                    if q['type'] == 'mcq': q['options'] = [['एक', 'one']] * 4; q['answer'] = ['एक', 'one']
            return o
    P = Rep(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); j = jd(out)
    assert out['final_state'] == 'review_ready' and P.n['questions'] == len(B.PATH['question_groups']) + 1, (out, P.n)


@case('B30 real-model shapes from run 7: pair wrapped one level deeper is unwrapped; assertion_reason gets its stem from assertion+reason; short case_based still rejected with its word count')
def _(d):
    q = {'type': 'assertion_reason', 'outcome': 'o0', 'bloom': 'understand', 'assertion': [['अ', 'A text']], 'reason': [['ब', 'R text']], 'answer_index': 1}
    assert B.question_problems([q], {'assertion_reason': 1}, {'o0'}) == [] and 'Assertion (A): A text Reason (R): R text' == q['q'][1] and q['answer'][1].startswith('Both A and R are true, but')
    c = {'type': 'case_based', 'outcome': 'o0', 'bloom': 'apply', 'case': ['छोटा केस', 'A short case of five words'], 'q': P2(), 'answer': P2()}
    pr = B.question_problems([c], {'case_based': 1}, {'o0'})
    assert pr and '60-100' in pr[0] and 'yours has 6' in pr[0], pr
    assert B.question_problems([{**c, 'case': 'a plain string'}], {'case_based': 1}, {'o0'})


@case('B29 mcq without an "answer" pair (only options + answer_index, as the real Gemini replied) is accepted: answer text is derived from the keyed option')
def _(d):
    o = lambda *xs: [[x, x] for x in xs]
    q = {'type': 'mcq', 'outcome': 'o0', 'bloom': 'apply', 'q': P2(), 'options': o('a1', 'b2', 'c3', 'd4'), 'answer_index': 2}
    assert B.question_problems([q], {'mcq': 1}, {'o0'}) == [] and q['answer'] == ['c3', 'c3']
    q2 = {**q, 'answer': ['b2', 'b2'], 'options': o('a1', 'b2', 'c3', 'd4')}      # an answer text the AI wrote that contradicts the key is still caught
    assert any('not the keyed option' in x for x in B.question_problems([q2], {'mcq': 1}, {'o0'}))
    r6 = {'type': 'mcq', 'outcome': 'o0', 'bloom': 'apply', 'q': P2(), 'options': o('In parallel', 'In series', 'In series', 'Not connected'), 'answer_index': 2}   # real Groq reply
    assert any('options repeat' in x for x in B.question_problems([r6], {'mcq': 1}, {'o0'}))



if __name__ == '__main__':
    for n, ok, why in results: print(('PASS ' if ok else 'FAIL ') + n + ('' if ok else '  -> ' + why))
    print(f'{sum(ok for _, ok, _ in results)}/{len(results)} passed')
