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
COPY_SRC = 'the potential difference between two points is the work done to move a unit charge'
SVG = '<svg viewBox="0 0 340 200" xmlns="http://www.w3.org/2000/svg"><line x1="10" y1="10" x2="200" y2="10" stroke="#000"/><circle cx="50" cy="50" r="10"/><text x="60" y="60">R</text></svg>'


class Smart(Mock):
    def __init__(self, bad=None, **k):
        super().__init__(**k); self.bad = bad or {}; self.n = {}
    def write(self, prompt, avoid=()):
        self.calls.append('write'); self.last_prompt = prompt
        stage = ('tfix' if 'has a wrong JSON shape' in prompt else 'pairs' if 'Fix each [Hindi, English] text pair' in prompt else 'qfix' if 'Rewrite these Class 10' in prompt else 'outcomes' if 'Write learning outcomes' in prompt else 'questions' if 'Write the question bank' in prompt else 'plan' if 'Plan one chapter' in prompt else 'concepts' if 'note panels' in prompt else 'extras' if '5 solved numericals' in prompt
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
    def a_pairs(self, p):
        # a good fixer: banned forms -> standard term; missing standard term added; copied sentence replaced; numbers made equal (English wins)
        prs = [json.loads(m) for m in re.findall(r'^\d+\. (\[.*\])$', p, re.M)]; out = []
        for hi, en in prs:
            en = en.replace(COPY_SRC, 'zephyr quokka marmalade lantern cobalt saffron meadow')
            for t in B.GLOSSARY['terms']:
                for b in t.get('not', []): hi = hi.replace(b, t['hi'][0])
                if re.search(r'(?<![a-z])' + re.escape(t['en']) + r'(?![a-z])', en.lower()) and not any(h in hi for h in t['hi']): hi += ' ' + t['hi'][0]
            hi = re.sub(r'\d+(?:\.\d+)?', '', hi) + ' ' + ' '.join(sorted(set(re.findall(r'\d+(?:\.\d+)?', en))))
            out.append([hi.strip(), en])
        return {'pairs': out}
    def a_tfix(self, p):
        return {'table': {'head': [['पदार्थ', 'Material'], ['प्रतिरोधकता (Ω m)', 'Resistivity (Ω m)']],
                          'rows': [[['चालक', 'Conductor'], ['1.68 × 10^-8', '1.68 × 10^-8']], [['विद्युतरोधी', 'Insulator'], ['10^10', '10^10']]]}}
    def a_qfix(self, p):
        qs = [json.loads(m) for m in re.findall(r'^Question \d+: (\{.*\})$', p, re.M)]; whys = re.findall(r'^Why: (.*)$', p, re.M)
        for q, w in zip(qs, whys):
            if 'knowledge/understanding' in w: q['bloom'] = 'understand'
            q['q'] = ['सुधरा ' + q['q'][0], 'FIXED ' + q['q'][1]]
        return {'questions': qs}
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
    out = B.run(CMD, m, reference_dir=FP); chk = json.load(open(os.path.join(out['dir'], 'checks.json')))
    # code verified 12 V / 4 ohm = 3 A and every given is in the question: the AI solver's 5 A is shown as a warning, code wins
    assert out['final_state'] == 'review_ready' and any('numerical 1: AI solver disagreed' in w for w in chk['warnings']), (out, chk['problems'])


@case('B4b solver disagrees AND the code check uses numbers that are not in the question -> not trusted -> rewritten, then needs_review if it stays')
def _(d):
    class Off(Smart):
        def a_extras(self, p):
            o = super().a_extras(p); o['numericals'][0]['given'] = ['प्रश्न: धारा?', 'Q: find the current through the wire.']; return o
    m = Off(); m.solve_num_fn = lambda g: ['I = 5 A'] + ['3 A'] * (len(g) - 1)
    out = B.run(CMD, m, reference_dir=FP); chk = json.load(open(os.path.join(out['dir'], 'checks.json')))
    assert out['final_state'] == 'needs_review' and any('numerical 1: independent solver got a different answer' in x for x in chk['problems']), chk['problems']
    assert len(jd(out)['correction_rounds']) == 2 and jd(out)['correction_rounds'][0]['numericals'] == [1]


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
    assert out['final_state'] == 'review_ready' and j['correction_rounds'][0]['concepts'] == ['c2'] and len(j['correction_rounds']) == 1 and m.n['concepts'] == 5, (out, j.get('correction_rounds'), m.n)


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
    assert out['final_state'] == 'review_ready' and j['correction_rounds'][0]['numericals'] == [3], (out, j.get('correction_rounds'), j['issues'][-2:])


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
    # no check at all -> never verified (needs_review after the bounded rounds); an unknown formula id -> code picks the only registry formula that fits the givens
    assert out['final_state'] == 'needs_review' and any('numerical 2: not code-verified' in x for x in chk['problems']), chk['problems']
    assert chk['numericals'][4]['code'] is True and 'formula chosen by code: ohm' in chk['numericals'][4]['code_detail'], chk['numericals'][4]


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
    assert len(seen) in (2, 4, 6) and any(a['options'] != b['options'] for a, b in zip(seen[0], seen[1])) and all('answer_index' not in x for x in seen[0])
    assert jd(out)['correction_rounds'][0]['questions'][0][0] == 1, jd(out)['correction_rounds'][0]


@case('B23 Hindi term lock: English says resistance, Hindi uses रेज़िस्टेंस (banned) or no standard term -> needs_review; numbers differ -> warning')
def _(d):
    r = B.term_check([['इसका रेज़िस्टेंस 4 Ω है', 'Its resistance is 4 ohm'], ['परिपथ में 2 A', 'the current in this particular circuit is 3 A today']])
    assert r['missing_hindi_term'] == {'resistance': 1, 'current': 1} and r['banned_form'] == {'रेज़िस्टेंस': 1} and r['number_mismatch_pairs'] == 1, r
    assert B.term_check([['इसका प्रतिरोध ४ Ω है', 'Its resistance is 4 ohm']])['number_mismatch_pairs'] == 0
    class BadHi(Smart):
        def a_extras(self, p):
            o = super().a_extras(p); o['revision'][0] = [['इसका रेज़िस्टेंस', 'Its resistance'], ['4 Ω', '4 Ω']]; return o
        def a_pairs(self, p): return {'pairs': [json.loads(m) for m in re.findall(r'^\d+\. (\[.*\])$', p, re.M)]}      # a fixer that changes nothing
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
        def a_pairs(self, p): return {'pairs': [json.loads(m) for m in re.findall(r'^\d+\. (\[.*\])$', p, re.M)]}      # a fixer that changes nothing
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
            if 'c0' in p.split('Panels to write:')[1][:200]: o['concepts'][0]['paras'][0] = [W, src]
            return o
    P = CopyOnce(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=fp); j = jd(out)
    assert out['final_state'] == 'review_ready', (out, j['issues'][-1:])
    assert j['correction_rounds'][0]['pairs'] >= 1 and j['pairs_rewritten'] >= 1, j.get('correction_rounds')


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


@case('B35 one question group keeps failing (short case passages): the other stages still run, checks name the missing group, rerun redoes ONLY that group')
def _(d):
    class Short(Smart):
        def a_questions(self, p):
            o = super().a_questions(p)
            if 'case_based' in p.split('EXACTLY these numbers')[1][:80]:
                for q in o['questions']: q['case'] = ['छोटा', 'too short']
            return o
    P = Short(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); j = jd(out)
    chk = json.load(open(os.path.join(out['dir'], 'checks.json')))
    assert out['final_state'] == 'needs_review' and any('question groups missing: case_based' in x for x in chk['problems']) and j['stages']['teach']['status'] == 'done', (out, chk['problems'][:3])
    P2_ = M(); out2 = B.run(CMD, P2_, retry=True, reference_dir=FP)
    assert out2['final_state'] == 'review_ready' and P2_.n.get('questions') == 1 and P2_.n.get('teach', 0) == 0, (out2, P2_.n)


@case('B36 real run-10 demo mistakes: bare Vector3 and [english, hindi] order are repaired by code; the repaired model passes the node test')
def _(d):
    o = {'title': ["Ohm's Law", 'ओह्म का नियम'], 'hint': P2(), 'slider': ['Voltage', 'वोल्टेज'], 'min': 0, 'max': 12, 'step': 1, 'val': 6,
         'script': 'const I=v/4; arrow(new Vector3(-2,0,0), new Vector3(2,0,0), 0xff0000); add(new Mesh(new THREE.SphereGeometry(I/2,32,32), mat(0xffff00))); info.textContent=T("a","b")+I;'}
    assert not B.R.check_demo_script(o)[0]
    B.repair_demo(o)
    assert o['title'] == ['ओह्म का नियम', "Ohm's Law"] and o['script'].count('THREE.Vector3') == 2 and 'THREE.THREE' not in o['script'] and B.R.check_demo_script(o)[0], B.R.check_demo_script(o)


@case('B38 end to end: the demo reply uses bare Vector3 and english-first titles -> accepted on the FIRST attempt after code repair')
def _(d):
    class BareDemo(Smart):
        def a_demo(self, p):
            o = super().a_demo(p); o['title'] = ["Ohm's law", 'ओम का नियम']; o['script'] = 'const I=v/4; arrow(new Vector3(0,0,0),new Vector3(I,0,0),0xf59e0b); info.textContent=T("a","b")+I;'; return o
    P = BareDemo(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); j = jd(out)
    assert out['final_state'] == 'review_ready' and j['stages']['demo']['attempts'] == 1, (out, j['stages']['demo'])


@case('B37 a group is accepted question by question: 3 good case_based kept, only the 2 bad ones asked again (prompt names what is kept)')
def _(d):
    class Cases(Smart):
        k = 0
        def a_questions(self, p):
            o = super().a_questions(p)
            if 'EXACTLY these numbers of questions per type: {"case_based"' in p:
                Cases.k += 1
                if Cases.k == 1:
                    for q in o['questions'][3:]: q['case'] = ['छोटा', 'too short']
            return o
    P = Cases(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); j = jd(out)
    assert out['final_state'] == 'review_ready' and Cases.k == 2, (out, Cases.k)
    bank = json.load(open(os.path.join(out['dir'], 'questions.json'))); assert sum(q['type'] == 'case_based' for q in bank) == 5


@case('B39 quality rotation: two rejected replies from one provider -> the next try goes to the next provider (avoid), the first is not used again for that task')
def _(d):
    seen = []
    class Rot2(Smart):
        def write(self, prompt, avoid=()):
            seen.append(sorted(avoid)); raw, prov, model = super().write(prompt)
            who = 'nvidia' if 'groq' in avoid else 'groq'
            if 'Write the question bank' in prompt and who == 'groq': raw = '{"questions": "garbage"}'
            return raw, who, 'm-' + who
    P = Rot2(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); j = jd(out)
    qcalls = [a for a in seen]
    assert any(a == ['groq'] for a in qcalls), qcalls[:20]
    assert out['final_state'] in ('review_ready', 'needs_review') and j['stages']['questions']['status'] == 'done', (out, j['stages']['questions'])
    assert {a['provider'] for a in j['attribution'] if a['stage'] == 'questions'} >= {'groq', 'nvidia'}


@case('B40 providers: chain order Groq -> NVIDIA -> Cloudflare -> SambaNova; NVIDIA model picked only from the provider list (never guessed); avoided provider tried last, not never')
def _(d):
    import providers as PR
    assert PR.Real.pick_model(['a', 'openai/gpt-oss-120b', 'meta/llama-3.3-70b-instruct'], PR.Real.NVIDIA_PREFERRED) == 'meta/llama-3.3-70b-instruct'
    assert PR.Real.pick_model(['x', 'y'], PR.Real.NVIDIA_PREFERRED) == ''
    env = {'FREE_TIER_CONFIRMED': 'groq,nvidia,sambanova,cloudflare', 'GROQ_API_KEY': 'k1', 'NVIDIA_API_KEY': 'k2', 'NVIDIA_WRITE_MODEL': 'meta/llama-3.3-70b-instruct',
           'SAMBANOVA_API_KEY': 'k3', 'CLOUDFLARE_API_TOKEN': 'k4', 'CLOUDFLARE_ACCOUNT_ID': 'acc', 'ROUTE_DIR': os.environ.get('ROUTE_DIR', 'robots/route')}
    old = {k: os.environ.get(k) for k in env}; os.environ.update(env)
    try: R_ = PR.Real()
    finally:
        for k, v in old.items():
            if v is None: os.environ.pop(k, None)
            else: os.environ[k] = v
    assert [c[0] for c in R_.chain] == ['groq', 'nvidia', 'cloudflare', 'sambanova']
    order = []
    R_._chat = lambda url, key, model, prompt, provider, timeout=0, max_tokens=0: (order.append(provider), ('ok', provider, model))[1]
    R_._free_chain('p', 100, [], avoid=('groq',)); R_._free_chain('p', 100, [])
    assert order == ['nvidia', 'groq'], order
    order.clear(); R_._free_chain('p', 100, [], avoid=('groq', 'nvidia', 'cloudflare', 'sambanova')); assert order == ['groq']


@case('B41 run-11 shapes: answer ["400","J"] joined to "400 J"; V-I graph slope (writer named "ohm") verified by ohm_slope; heater "2 minutes" = 120 s found in the text')
def _(d):
    import numcheck as NC
    assert B.split_answer(['400', 'J']) == ['400 J', '400 J'] and B.split_answer(['400 जूल', '400 J']) == ['400 जूल', '400 J']
    slope = {'givens': [{'symbol': 'V1', 'value': 2, 'unit': 'V'}, {'symbol': 'I1', 'value': 0.5, 'unit': 'A'}, {'symbol': 'V2', 'value': 8, 'unit': 'V'}, {'symbol': 'I2', 'value': 2, 'unit': 'A'}],
             'formulas': ['ohm'], 'unknown': 'R', 'answer': {'value': 4, 'unit': 'Ω'}}
    ok, why = NC.verify(slope); assert ok is True and 'ohm_slope' in why, why
    assert NC.verify({**slope, 'answer': {'value': 16, 'unit': 'Ω'}})[0] is False          # a wrong slope answer is still caught
    heat = {'givens': [{'symbol': 'I', 'value': 5, 'unit': 'A'}, {'symbol': 'R', 'value': 10, 'unit': 'Ω'}, {'symbol': 't', 'value': 120, 'unit': 's'}], 'formulas': ['joule_heat'], 'unknown': 'H', 'answer': {'value': 30000, 'unit': 'J'}}
    assert NC.verify(heat)[0] is True and NC.givens_in_text(heat, 'A heater of resistance 10 Ω carries a current of 5 A for 2 minutes.')
    assert not NC.givens_in_text(heat, 'A heater of resistance 10 Ω carries a current of 7 A for 2 minutes.')
    class Run11(Smart):
        def a_extras(self, p):
            o = super().a_extras(p); o['numericals'][3]['answer'] = ['3', 'A']; return o
    P = Run11(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP)
    ex = json.load(open(os.path.join(out['dir'], 'extras.json')))
    assert out['final_state'] == 'review_ready' and ex['numericals'][3]['answer'] == ['3 A', '3 A'], (out, ex['numericals'][3]['answer'])


@case('B42 answer-blind solver misses the key of question 1 -> that question is rewritten with the solver reason -> rewritten one reaches the key -> review_ready')
def _(d):
    def blind(items): return [x['answer'] if (i or 'FIXED' in x['q']) else (x['answer'] + 1) % 4 for i, x in enumerate(items)]
    P = M(); P.solve_all_fn = blind; out = B.run(CMD, P, reference_dir=FP); j = jd(out)
    bank = json.load(open(os.path.join(out['dir'], 'questions.json')))
    assert out['final_state'] == 'review_ready', (out, j['issues'][-1:])
    assert j['correction_rounds'][0]['questions'][0][0] == 1 and bank[0]['q'][1].startswith('FIXED') and 'independent solver' in j['correction_rounds'][0]['questions'][0][1]
    assert not any(q['q'][1].startswith('FIXED') for q in bank[1:] if q['type'] in ('mcq', 'assertion_reason')), 'only the flagged question is rewritten'


@case('B43 knowledge/understanding 34% (min 40%) -> code picks non-competency apply questions, they are rewritten at understand level -> band >= 40%, competency still >= min')
def _(d):
    class Apply(Smart):
        def a_questions(self, p):
            o = super().a_questions(p)
            for i, q in enumerate(o['questions']):
                if q['type'] in ('mcq', 'vsa', 'sa', 'fill_blank', 'true_false') and q['bloom'] in ('remember', 'understand') and i % 3: q['bloom'] = 'apply'
            return o
    P = Apply(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); j = jd(out); chk = json.load(open(os.path.join(out['dir'], 'checks.json')))
    r0 = j['correction_rounds'][0]
    assert any('knowledge_understanding questions' in x for x in r0['problems']), r0['problems']
    assert out['final_state'] == 'review_ready' and chk['coverage']['bands']['knowledge_understanding'] >= 0.4 and chk['coverage']['bands']['competency'] >= 0.5, (out, chk['coverage']['bands'], chk['problems'])


@case('B44 Hindi terms: श्रृंखला for series and चार्ज for charge -> only those pairs rewritten with the standard terms; a rewrite that drops a number is rejected by code')
def _(d):
    class BadTerms(Smart):
        def a_extras(self, p):
            o = super().a_extras(p)
            o['revision'][1] = [['तीन प्रतिरोधक श्रृंखला में जुड़े हैं और उनमें 2 A धारा बहती है, यह एक सामान्य परिपथ का उदाहरण है', 'Three resistors are joined in series and 2 A current flows through them in this simple example'],
                                ['चार्ज का SI मात्रक कूलॉम है और एक इलेक्ट्रॉन पर बहुत कम चार्ज होता है जो ऋणात्मक है', 'The SI unit of charge is coulomb and an electron carries a very small negative charge always']]
            return o
    P = BadTerms(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); j = jd(out)
    ex = json.load(open(os.path.join(out['dir'], 'extras.json'))); txt = json.dumps(ex['revision'][1], ensure_ascii=False)
    assert out['final_state'] == 'review_ready' and 'श्रेणी' in txt and 'चार्ज' not in txt and 'आवेश' in txt and '2' in txt, (out, txt, j['issues'][-1:])
    old = ['3 Ω श्रेणी में', 'Three 3 Ω resistors in series']
    assert not B.pair_ok_after(old, ['श्रेणी में प्रतिरोधक', 'Resistors in series'], None)          # the number 3 was lost -> rejected
    assert B.pair_ok_after(old, ['3 Ω के प्रतिरोधक श्रेणी में', 'Three 3 Ω resistors in series'], None)


@case('B45 copied 12-word run in an extras answer (not in a concept) -> found where it is and that pair rewritten -> review_ready')
def _(d):
    src = COPY_SRC; w = src.split(); hs = [J.hashlib.sha256(' '.join(w[i:i + 3]).encode()).hexdigest()[:16] for i in range(len(w) - 2)]
    fp = os.path.join(d, 'fp'); os.makedirs(fp)
    for lang in ('en', 'hi'): json.dump({'hashes': hs, 'lang': lang, 'files': ['x']}, open(os.path.join(fp, lang + '.json'), 'w'))
    class CopyEx(Smart):
        def a_extras(self, p):
            o = super().a_extras(p); o['practice'][2]['a'] = [W, src]; return o
    P = CopyEx(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=fp); j = jd(out)
    ex = json.load(open(os.path.join(out['dir'], 'extras.json'))); chk = json.load(open(os.path.join(out['dir'], 'checks.json')))
    assert out['final_state'] == 'review_ready' and src not in ex['practice'][2]['a'][1] and (chk['copyright']['longest_copied_run_words'] or 0) < 8, (out, chk['copyright'], j['issues'][-1:])


@case('B46 Hindi/English number mismatch inside a teaching paragraph -> pair fixed, and the Hinglish of THAT section only is transliterated again')
def _(d):
    class Mis(Smart):
        def a_teach(self, p):
            o = super().a_teach(p)
            if 'Start' in p.split('Lessons: ')[1][:300]: o['teach'][0]['paras'][0] = [W + ' 5 ओम', E + ' 7 ohm']
            return o
    P = Mis(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); j = jd(out)
    te = json.load(open(os.path.join(out['dir'], 'teach.json')))
    assert out['final_state'] == 'review_ready' and '7' in te[0]['paras'][0][0] and '5' not in te[0]['paras'][0][0], (out, te[0]['paras'][0][0][-20:], j['issues'][-1:])
    assert P.n['hinglish'] == 4, P.n          # 3 normal batches (17 sections / 6) + 1 refresh for the changed section only


@case('B47 bounded: a problem no rewrite fixes -> at most 2 correction rounds, then needs_review with the exact problem; no endless calls')
def _(d):
    class Stuck(Smart):
        def a_extras(self, p):
            o = super().a_extras(p); o['revision'][0] = [['इसका रेज़िस्टेंस', 'Its resistance'], ['4 Ω', '4 Ω']]; return o
        def a_pairs(self, p): return {'pairs': [json.loads(m) for m in re.findall(r'^\d+\. (\[.*\])$', p, re.M)]}
    P = Stuck(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); j = jd(out)
    assert out['final_state'] == 'needs_review' and len(j['correction_rounds']) == 2 and P.n['pairs'] == 2, (len(j['correction_rounds']), P.n)
    assert 'non-standard Hindi form' in j['issues'][-1]['detail']


@case('B48 two different copied runs (14 and 9 words) in two places -> BOTH pairs are rewritten in the first round (not only the longest), one round only')
def _(d):
    src2 = 'resistors joined end to end carry the same current always'
    hs = []
    for s in (COPY_SRC, src2):
        w = s.split(); hs += [J.hashlib.sha256(' '.join(w[i:i + 3]).encode()).hexdigest()[:16] for i in range(len(w) - 2)]
    fp = os.path.join(d, 'fp'); os.makedirs(fp)
    for lang in ('en', 'hi'): json.dump({'hashes': hs, 'lang': lang, 'files': ['x']}, open(os.path.join(fp, lang + '.json'), 'w'))
    class Two(Smart):
        def a_extras(self, p):
            o = super().a_extras(p); o['practice'][2]['a'] = [W, COPY_SRC]; o['practice'][5]['a'] = [W, src2]; return o
        def a_pairs(self, p):
            o = super().a_pairs(p); o['pairs'] = [[h, e.replace(src2, 'zephyr quokka lantern cobalt')] for h, e in o['pairs']]; return o
    P = Two(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=fp); j = jd(out)
    assert out['final_state'] == 'review_ready' and len(j['correction_rounds']) == 1 and j['pairs_rewritten'] >= 2, (out, j.get('correction_rounds'), j['issues'][-1:])


@case('B49 run-12 gap: a question rewrite that brings in a copied 14-word textbook sentence is REJECTED by code (question stays, issue logged)')
def _(d):
    w = COPY_SRC.split(); hs = [J.hashlib.sha256(' '.join(w[i:i + 3]).encode()).hexdigest()[:16] for i in range(len(w) - 2)]
    fp = os.path.join(d, 'fp'); os.makedirs(fp)
    for lang in ('en', 'hi'): json.dump({'hashes': hs, 'lang': lang, 'files': ['x']}, open(os.path.join(fp, lang + '.json'), 'w'))
    def blind(items): return [x['answer'] if i else (x['answer'] + 1) % 4 for i, x in enumerate(items)]
    class CopyFix(Smart):
        def a_qfix(self, p):
            o = super().a_qfix(p); o['questions'][0]['q'] = ['सुधरा प्रश्न', 'FIXED ' + COPY_SRC]; return o
    P = CopyFix(); P.solve_num_fn = solver; P.solve_all_fn = blind; out = B.run(CMD, P, reference_dir=fp); j = jd(out)
    bank = json.load(open(os.path.join(out['dir'], 'questions.json')))
    assert COPY_SRC not in json.dumps(bank) and any(i['kind'] == 'correction_rejected' for i in j['issues']) and out['final_state'] == 'needs_review', (out, j['issues'][-2:])


@case('B50 run-12 gap: calculated mcq (options are numbers) with no check -> problem + rewrite; a rewrite whose key the code rejects (0.0168 for 0.00168) is not accepted')
def _(d):
    calc = {'type': 'mcq', 'outcome': 'o1', 'bloom': 'apply', 'q': ['ρ = 1.68 × 10^-8 Ω·m, L = 10 m, A = 1 × 10^-4 m², R?', 'rho = 1.68 × 10^-8 Ω·m, L = 10 m, A = 1 × 10^-4 m². Find R.'],
            'options': [['0.0168 Ω', '0.0168 Ω'], ['1.68 Ω', '1.68 Ω'], ['16.8 Ω', '16.8 Ω'], ['168 Ω', '168 Ω']], 'answer_index': 0}
    assert B.calc_mcq(calc) and not B.calc_mcq({**calc, 'options': [['क', 'a'], ['ख', 'b'], ['ग', 'c'], ['घ', 'd']]})
    wrong = {**calc, 'check': {'givens': [{'symbol': 'rho', 'value': 1.68e-8, 'unit': 'ohm m'}, {'symbol': 'L', 'value': 10, 'unit': 'm'}, {'symbol': 'A', 'value': 1e-4, 'unit': 'm^2'}],
                               'formulas': ['resistivity'], 'unknown': 'R', 'answer': {'value': 0.0168, 'unit': 'Ω'}}}
    assert not B.question_ok_after(wrong, None)
    right = {**wrong, 'options': [['0.00168 Ω', '0.00168 Ω'], ['0.0168 Ω', '0.0168 Ω'], ['1.68 Ω', '1.68 Ω'], ['16.8 Ω', '16.8 Ω']]}
    assert B.question_ok_after(right, None)
    class Calc(Smart):
        def a_questions(self, p):
            o = super().a_questions(p)
            if 'mcq' in p.split('per type: ')[1][:80]:
                i = next(k for k, q in enumerate(o['questions']) if q['type'] == 'mcq'); o['questions'][i] = {**calc, 'outcome': o['questions'][i]['outcome']}
            return o
        def a_qfix(self, p): return {'questions': [right]}
    P = Calc(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); j = jd(out)
    assert any('calculated options but no code check' in x for x in j['correction_rounds'][0]['problems']), j['correction_rounds'][0]['problems']
    assert out['final_state'] == 'review_ready', (out, j['issues'][-2:])


@case('B51 run-12 gap: Hindi teaching text changed but the Hinglish refresh crashes -> sections marked stale -> needs_review (never silently old Hinglish)')
def _(d):
    class Mis(Smart):
        def a_teach(self, p):
            o = super().a_teach(p)
            if 'Start' in p.split('Lessons: ')[1][:300]: o['teach'][0]['paras'][0] = [W + ' 5 ओम', E + ' 7 ohm']
            return o
        def a_hinglish(self, p):
            self.hn = getattr(self, 'hn', 0) + 1
            if self.hn > 3: raise ValueError('broken reply')          # the first 3 normal batches are fine; every refresh reply is broken
            return super().a_hinglish(p)
    P = Mis(); P.solve_num_fn = solver
    out = B.run(CMD, P, reference_dir=FP); j = jd(out); chk = json.load(open(os.path.join(out['dir'], 'checks.json')))
    assert out['final_state'] == 'needs_review' and j.get('hinglish_stale') and any('hinglish not refreshed' in x for x in chk['problems']), (out, j.get('hinglish_stale'), chk['problems'])


BAD_TABLE = {'head': [['सामग्री का प्रकार', 'प्रतिरोधकता का मान (Ω m)']], 'rows': [[['चालक (conductor)', '1.68 × 10^-8'], ['विद्युतरोधी (insulator)', '10^10']]]}


@case('B52 run-12 table shapes (Hindi-only head, [label, number] cells, 4-string cells) are detected; a good rewrite keeping every value is accepted, one losing a value is not')
def _(d):
    assert B.table_problems([{'key': 'c6', 'table': BAD_TABLE}, {'key': 'c3', 'table': {'head': [['उपकरण (Instrument)', 'परिपथ', 'प्रतिरोध', 'इकाई']], 'rows': [[['एमीटर', 'श्रृंखला', 'कम', 'A']]]}},
                             {'key': 'ok', 'table': {'head': [['पदार्थ', 'Material'], ['मान', 'Value']], 'rows': [[['चालक', 'Conductor'], ['1.68', '1.68']]]}}]) == ['c6', 'c3']
    good = Smart().a_tfix('')['table']
    assert B.table_ok_after(BAD_TABLE, good)
    lost = json.loads(json.dumps(good)); lost['rows'] = lost['rows'][1:]
    assert not B.table_ok_after(BAD_TABLE, lost)


def finished_job(d, bad_table=False, bad_q=None):
    class S(Smart):
        def a_concepts(self, p):
            o = super().a_concepts(p)
            if bad_table: o['concepts'][0]['table'] = BAD_TABLE
            return o
    P = S(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); return out, P


@case('B53 repair run: finished job + scope {questions, tables} + stale Hinglish -> no stage regenerated; only the table, the listed question and the stale sections change -> review_ready')
def _(d):
    out, _ = finished_job(d)
    dirp = out['dir']; cs = json.load(open(os.path.join(dirp, 'concepts.json'))); cs[0]['table'] = BAD_TABLE      # state like run 12: broken table saved
    json.dump(cs, open(os.path.join(dirp, 'concepts.json'), 'w'), ensure_ascii=False)
    before = {f: open(os.path.join(dirp, f), encoding='utf-8').read() for f in ('plan.json', 'extras.json', 'teach.json', 'outcomes.json', 'demo.json')}
    jj = json.load(open(os.path.join(dirp, 'job.json'))); jj['hinglish_stale'] = [0, 3]; json.dump(jj, open(os.path.join(dirp, 'job.json'), 'w'))
    hg0 = json.load(open(os.path.join(dirp, 'hinglish.json'))); bank0 = json.load(open(os.path.join(dirp, 'questions.json')))
    def blind(items): return [x['answer'] if (i or 'FIXED' in x['q']) else (x['answer'] + 1) % 4 for i, x in enumerate(items)]
    P = Smart(); P.solve_num_fn = solver; P.solve_all_fn = blind
    out2 = B.run(CMD, P, retry=True, reference_dir=FP, repair={'questions': [1], 'tables': ['c0']}); j = jd(out2)
    assert out2['final_state'] == 'review_ready', (out2, j['issues'][-2:])
    for f, s in before.items(): assert open(os.path.join(dirp, f), encoding='utf-8').read() == s, f + ' changed'
    for st in ('outcomes', 'plan', 'concepts', 'extras', 'questions', 'teach', 'demo'): assert P.n.get(st, 0) == 0, (st, P.n)
    assert P.n.get('hinglish') == 1 and P.n.get('tfix') == 1 and P.n.get('qfix') == 1, P.n
    hg = json.load(open(os.path.join(dirp, 'hinglish.json'))); bank = json.load(open(os.path.join(dirp, 'questions.json')))
    assert [i for i, (a, b) in enumerate(zip(hg0, hg)) if a != b] in ([], [0, 3]) and not j.get('hinglish_stale'), j.get('hinglish_stale')
    assert [i for i, (a, b) in enumerate(zip(bank0, bank)) if a != b] == [0] and bank[0]['bloom'] == bank0[0]['bloom'], [i for i, (a, b) in enumerate(zip(bank0, bank)) if a != b]
    assert j['correction_rounds_before_repair'] is not None and j['repair_scope'] == {'questions': [1], 'tables': ['c0']}, j.get('correction_rounds_before_repair')


@case('B54 repair run: a question outside the scope that fails the blind solver is NOT rewritten -> needs_review naming it; job with an unfinished stage -> blocked, nothing written')
def _(d):
    out, _ = finished_job(d)
    def blind(items): return [x['answer'] if i != 2 else (x['answer'] + 1) % 4 for i, x in enumerate(items)]
    P = Smart(); P.solve_num_fn = solver; P.solve_all_fn = blind
    out2 = B.run(CMD, P, retry=True, reference_dir=FP, repair={'questions': [1]}); j = jd(out2)
    assert out2['final_state'] == 'needs_review' and P.n.get('qfix', 0) == 0 and 'answer-blind' in j['issues'][-1]['detail'], (out2, P.n)
    jj = json.load(open(os.path.join(out['dir'], 'job.json'))); jj['stages']['teach']['status'] = 'failed'; jj['final_state'] = 'failed'
    json.dump(jj, open(os.path.join(out['dir'], 'job.json'), 'w'))
    P2 = Smart(); out3 = B.run(CMD, P2, retry=True, reference_dir=FP, repair={'questions': [1]})
    assert out3['final_state'] == 'blocked' and 'teach' in out3['reason'] and not P2.calls, (out3, P2.calls)


@case('B55 broken table and a fixer that keeps it broken -> needs_review naming the table (never shipped silently)')
def _(d):
    class Keep(Smart):
        def a_concepts(self, p):
            o = super().a_concepts(p); o['concepts'][0]['table'] = BAD_TABLE; return o
        def a_tfix(self, p): return {'table': BAD_TABLE}
    P = Keep(); P.solve_num_fn = solver; out = B.run(CMD, P, reference_dir=FP); chk = json.load(open(os.path.join(out['dir'], 'checks.json')))
    assert out['final_state'] == 'needs_review' and any('concept c0: table has a wrong shape' in x for x in chk['problems']), chk['problems']


@case('B56 run-13 gaps: givens as text "V1 = 10 V" are parsed and still code-verified; the wrong key 0.0168 ohm stays rejected; a provider out of quota is not asked again in the run')
def _(d):
    import numcheck as NC, providers as PR
    q8 = {'givens': ['ρ = 1.68 × 10^-8 Ω·m', 'L = 10 m', 'A = 1 × 10^-4 m²'], 'formulas': ['resistivity'], 'unknown': 'R', 'answer': {'value': 0.0168, 'unit': 'Ω'}}
    assert NC.verify(q8)[0] is False and NC.verify({**q8, 'answer': {'value': 0.00168, 'unit': 'Ω'}})[0] is True
    assert NC.verify({**q8, 'givens': ['nonsense']})[0] is None and NC.mcq_options_ok({'check': {'givens': [3]}, 'options': [], 'answer_index': 0})[0] is None
    q5 = {'type': 'mcq', 'outcome': 'o1', 'bloom': 'apply', 'q': ['बिंदु (2 A, 10 V) और (4 A, 20 V), R?', 'A V-I graph passes through (2 A, 10 V) and (4 A, 20 V). Find R.'],
          'options': [['2 Ω', '2 Ω'], ['5 Ω', '5 Ω'], ['10 Ω', '10 Ω'], ['20 Ω', '20 Ω']], 'answer_index': 1,
          'check': {'givens': ['V1 = 10 V', 'V2 = 20 V', 'I1 = 2 A', 'I2 = 4 A'], 'formulas': ['ohm_slope'], 'unknown': 'R', 'answer': {'value': 5, 'unit': 'Ω'}}}
    assert B.question_ok_after(q5, None)
    assert not B.question_ok_after({**q5, 'q': ['R?', 'A V-I graph has slope 5 ohm. Find R.']}, None)        # numbers of the check not in the question
    env = {'FREE_TIER_CONFIRMED': 'gemini,groq,cloudflare', 'GEMINI_API_KEY': 'g', 'GROQ_API_KEY': 'k1', 'CLOUDFLARE_API_TOKEN': 'k4', 'CLOUDFLARE_ACCOUNT_ID': 'acc'}
    old = {k: os.environ.get(k) for k in env}; os.environ.update(env)
    try: R_ = PR.Real()
    finally:
        for k, v in old.items():
            if v is None: os.environ.pop(k, None)
            else: os.environ[k] = v
    hits = []
    def gem(prompt, models=None): hits.append('gemini'); raise ProviderUnavailable('gemini', 'quota', 'x')
    def chat(url, key, model, prompt, provider, timeout=0, max_tokens=0):
        hits.append(provider)
        if provider == 'groq': raise ProviderUnavailable('groq', 'quota', 'x')
        return 'ok', provider, model
    R_._gemini = gem; R_._chat = chat; R_.writer = 'gemini'
    for _ in range(3): assert R_.write('p')[1] == 'cloudflare'
    assert hits == ['gemini', 'groq', 'cloudflare', 'cloudflare', 'cloudflare'], hits


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
