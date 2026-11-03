"""Chapter Robot tests (mock AI, no network). Fixture is a synthetic app-format chapter, not real content."""
import copy, json, os, shutil, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import job as J, chapter_robot as C
from providers import Mock
from common import ProviderUnavailable

FP = os.environ.get('COPYRIGHT_FINGERPRINTS', '/tmp/db-main/robots/copyright/fingerprints')
CMD = 'Class 10, CBSE 2026-27, Science, Electricity'
ID = 'DB|class_9_10|880'
F = 'झिलमिल कौतुक नमूना पंक्ति गुलमोहर तितली पतंग सारंगी कदंब चंपा केतकी मधुबन पगडंडी झरना कुहासा नीलकंठ टेसू पलाश। '


def chapter():
    topics = ['विद्युत धारा और विभवांतर', 'ओम का नियम', 'प्रतिरोध और प्रतिरोधकता: लंबाई, क्षेत्रफल, पदार्थ, ताप', 'श्रेणी और पार्श्व संयोजन',
              'विद्युत धारा का तापीय प्रभाव (जूल)', 'विद्युत शक्ति P = V × I']
    d = {'id': ID,
         'notes': [{'title': t, 'points': [t + ' — ' + F, F, F]} for t in topics],
         'teach': [{'heading': t, 'explain': F * 3, 'example': 'समझो ऐसे: ' + F} for t in topics[:4]],
         'formulas': [{'title': 'सूत्र ' + str(i), 'formula': f, 'units': u, 'note': F} for i, (f, u) in enumerate([
             ('V = I × R', 'V (volt)'), ('R = ρ × L/A', 'ohm Ω'), ('I = Q/t', 'A (ampere)'), ('P = V × I', 'W (watt)'),
             ('H = I^2 × R × t', 'J'), ('R = R1 + R2', 'ohm Ω')])],
         'solved': [{'question': f'प्रश्न {i}: ' + F, 'steps': ['V = 12 V', 'R = 4 Ω', 'I = 12/4 = 3 A'], 'answer': '3 A'} for i in range(3)],
         'practice': [{'q': f'प्रश्न {i}: {i + 2} Ω पर 6 V हो तो धारा? ' + F, 'options': [f'{i}0 A', f'{i}1 A', f'{i}2 A', f'{i}3 A'], 'answer': 2,
                       'explanation': f'चरण 1: हल करें\nचरण 2: मान = {i}2 A'} for i in range(1, 11)],
         'mistakes': [F, F + '१', F + '२'], 'revision': [F + str(i) for i in range(6)]}
    return d


HI = chapter()
EN = C.W.shuffle_options(json.loads(json.dumps(HI)), ID)   # English fixture = what the translator gets back after the robot mixes options
results = []


def case(name):
    def deco(fn):
        d = tempfile.mkdtemp(prefix='rb_'); J.JOBS = d
        try: fn(d); results.append((name, True, ''))
        except AssertionError as e: results.append((name, False, str(e)[:300]))
        except Exception as e: results.append((name, False, f'{type(e).__name__}: {e}'[:300]))
        finally: shutil.rmtree(d, ignore_errors=True)
        return fn
    return deco


def M(**k):
    m = Mock(write=k.pop('write', [HI]), translate=k.pop('translate', [EN]), fact=k.pop('fact', None))
    for a, v in k.items(): setattr(m, a, v)
    return m


def jd(out): return json.load(open(os.path.join(out['dir'], 'job.json')))


@case('R0 fixture passes the Writer robot structure rules and the syllabus check (sanity of the test itself)')
def _(d):
    r = J.resolve(J.parse_command(CMD), json.load(open(J.SYLLABUS))); assert C.W.check_structure(HI, ID) == [], C.W.check_structure(HI, ID)
    assert all(x['covered'] for x in C.check_scope(HI, r)), C.check_scope(HI, r)


@case('R1 one command -> research, write (app format), checks, English, package -> review_ready; nothing published')
def _(d):
    P = M(); out = C.run(CMD, P, reference_dir=FP)
    assert out['final_state'] == 'review_ready', (out, jd(out)['issues'])
    assert P.calls[:2] == ['research', 'write'] and 'fact_app' in P.calls and 'solve_all' in P.calls and 'translate' in P.calls, P.calls
    data = json.load(open(os.path.join(out['dir'], 'data.json')))
    for k in ('notes', 'teach', 'formulas', 'solved', 'practice', 'mistakes', 'revision'): assert k in data and data[k], k
    assert data['id'] == ID and data['en']['practice'][0]['answer'] == data['practice'][0]['answer']
    p = json.load(open(os.path.join(out['dir'], 'draft_save_payload.json')))['p']
    assert p['level_id'] == 'class_9_10' and p['chapter_id'] == 880 and p['status'] == 'draft' and p['checks']['human_review'] is None


@case('R2 too few sections (the old thin format) -> rejected with the Writer counts as feedback; fixed draft accepted')
def _(d):
    thin = copy.deepcopy(HI); thin['notes'] = thin['notes'][:3]; thin['practice'] = thin['practice'][:3]; thin['mistakes'] = []
    P = M(write=[thin, HI]); out = C.run(CMD, P, reference_dir=FP)
    assert out['final_state'] == 'review_ready'
    assert 'notes: 3 (want 5-8)' in P.last_prompt and 'practice: 3 (want 10-10)' in P.last_prompt, P.last_prompt[-400:]
    assert P.calls.count('fact_app') == 1, 'no AI check spent on a draft that failed local checks'


@case('R3 a syllabus item missing -> named in feedback; 3 bad drafts -> needs_review (no 4th attempt)')
def _(d):
    t = json.dumps(HI, ensure_ascii=False)
    for a in ('जूल', 'तापीय प्रभाव', 'तापन', 'H = I^2'): t = t.replace(a, 'क्ष')
    bad = json.loads(t)
    P = M(write=[bad, bad, bad]); out = C.run(CMD, P, reference_dir=FP)
    assert out['final_state'] == 'needs_review' and P.calls.count('write') == 3, (out, P.calls)
    assert 'syllabus item not covered: Heating effect' in P.last_prompt


@case('R4 independent solver disagrees on a practice answer -> rejected with question numbers')
def _(d):
    n = {'k': 0}
    def solver(pr):
        n['k'] += 1; a = [x['answer'] for x in pr]
        if n['k'] == 1: a[9] = (a[9] + 1) % 4
        return a
    P = M(write=[HI, HI], solve_all_fn=solver); out = C.run(CMD, P, reference_dir=FP)
    assert out['final_state'] == 'review_ready' and 'questions [10]' in P.last_prompt, P.last_prompt[-300:]


@case('R5 research without sources -> needs_review (outline not evidenced), never review_ready')
def _(d):
    P = M(research_fn=lambda p: ({'subtopics': []}, [])); out = C.run(CMD, P, reference_dir=FP)
    assert out['final_state'] == 'needs_review' and any(i['kind'] == 'reference_unsourced' for i in jd(out)['issues'])


@case('R6 English changes a number or an answer -> needs_review')
def _(d):
    en = copy.deepcopy(EN); en['practice'][0]['answer'] = (en['practice'][0]['answer'] + 1) % 4
    out = C.run(CMD, M(translate=[en]), reference_dir=FP); assert out['final_state'] == 'needs_review'


@case('R7 quota stop while writing -> blocked; rerun resumes WITHOUT repeating research')
def _(d):
    out = C.run(CMD, M(write=[ProviderUnavailable('gemini', 'quota')]), reference_dir=FP); assert out['final_state'] == 'blocked'
    P = M(); out = C.run(CMD, P, reference_dir=FP)
    assert out['final_state'] == 'review_ready' and 'research' not in P.calls, P.calls


@case('R8 copyright reference missing -> check did not run -> never review_ready')
def _(d):
    out = C.run(CMD, M(write=[HI, HI, HI]), reference_dir='/nonexistent'); assert out['final_state'] == 'needs_review'


@case('R9 chapter not mapped/verified -> blocked before any AI call')
def _(d):
    P = M(); out = C.run('Class 10, CBSE 2026-27, Science, Light', P, reference_dir=FP)
    assert out['final_state'] == 'blocked' and P.calls == [], (out, P.calls)


@case('R10 web research provider down -> chapter still written from the syllabus, but only needs_review (never review_ready)')
def _(d):
    P = M(research_fn=lambda p: ProviderUnavailable('groq', 'permanent')); out = C.run(CMD, P, reference_dir=FP)
    j = jd(out); assert out['final_state'] == 'needs_review' and 'write' in P.calls, (out, P.calls)
    assert any(i['kind'] == 'reference_unavailable' for i in j['issues'])


if __name__ == '__main__':
    for n, ok, why in results: print(('PASS ' if ok else 'FAIL ') + n + ('' if ok else '  -> ' + why))
    print(f'{sum(ok for _, ok, _ in results)}/{len(results)} passed')
