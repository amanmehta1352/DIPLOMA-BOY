import re
"""Mock-based integration tests for the chapter job. AI replies are SCRIPTED; everything else is the real code
(command parsing, syllabus resolution, checks, copyright n-gram with the real NCERT fingerprints, retries, job state, files, preview).
   python3 test_job.py
"""
import copy, json, os, shutil, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import job as J
from providers import Mock
from job import ProviderUnavailable

FP = os.environ.get('COPYRIGHT_FINGERPRINTS', '/tmp/db-main/robots/copyright/fingerprints')
CMD = 'Class 10, CBSE 2026-27, Science, Electricity'

EN = {
 'concepts': [
  {'title': 'Electric current and potential difference', 'body': 'Think of electric current as how much charge passes a point every second, I = Q / t. Potential difference tells how much energy each coulomb gains or loses on its trip, V = W / Q. A torch cell keeps a potential difference across the bulb so charge keeps moving.'},
  {'title': "Ohm's law and resistance", 'body': "Ohm's law: at constant temperature V is proportional to I, so V = I R. Resistance of a wire depends on its length, area of cross-section, material (resistivity) and temperature, not on the current."},
  {'title': 'Series, parallel, heating effect and power', 'body': 'In series the same current flows; in parallel each branch gets the full voltage and the equivalent resistance is less than the smallest one. The heating effect of electric current, H = I^2 R t, is used in heaters and fuses. Electric power is the rate of using energy.'}],
 'formulas': [
  {'title': 'Ohm\'s law', 'body': 'V = I R (V in volt V, I in ampere A, R in ohm). Used to find any one quantity from the other two.'},
  {'title': 'Electric power', 'body': 'P = V I = I^2 R = V^2 / R (P in watt W, V in volt, I in ampere, R in ohm). 1 kWh = 3.6 x 10^6 J.'}],
 'examples': [
  {'title': 'Household wiring', 'body': 'Appliances at home are joined in parallel so each gets 220 V and can be switched on alone.'},
  {'title': 'Electric iron', 'body': 'An iron of 1000 W on 220 V draws I = 1000 / 220 = 4.5 A; its coil uses the heating effect.'}],
 'mcqs': [
  {'question': 'The SI unit of resistance is', 'options': ['ohm', 'volt', 'ampere', 'watt'], 'answer_index': 0, 'difficulty': 'easy', 'explanation': 'Resistance is measured in ohm.'},
  {'question': 'Two 6 ohm resistors are joined in parallel across 6 V. The total current is', 'options': ['1 A', '2 A', '0.5 A', '3 A'], 'answer_index': 1, 'difficulty': 'medium', 'explanation': 'Equivalent resistance = 6 x 6 / 12 = 3 ohm; I = 6 / 3 = 2 A.'},
  {'question': 'A 100 W bulb runs for 10 hours. Energy used is', 'options': ['1 kWh', '10 kWh', '0.1 kWh', '100 kWh'], 'answer_index': 0, 'difficulty': 'medium', 'explanation': 'E = P t = 100 W x 10 h = 1000 Wh = 1 kWh.'}]}

HI = copy.deepcopy(EN)
_hi_words = ' विद्युत धारा आवेश के प्रवाह की दर है विभवांतर प्रतिरोध श्रेणी समांतर क्रम तापीय प्रभाव शक्ति'
for sec in ('concepts', 'formulas', 'examples'):
    for x in HI[sec]:
        x['title'] = 'हिंदी शीर्षक' + _hi_words; x['body'] = ' '.join(__import__('re').findall(r'\d+(?:\.\d+)?|[=/^x]', x['body'])) + _hi_words * 3
for q in HI['mcqs']:
    q['question'] = 'प्रश्न ' + ' '.join(__import__('re').findall(r'\d+(?:\.\d+)?', q['question'])) + _hi_words
    q['options'] = [' '.join(__import__('re').findall(r'\d+(?:\.\d+)?', o)) + ' विकल्प ' + 'कखगघ'[i] + _hi_words for i, o in enumerate(q['options'])]
    q['explanation'] = ' '.join(__import__('re').findall(r'\d+(?:\.\d+)?', q['explanation'])) + _hi_words * 2

results = []
def case(name):
    def deco(fn):
        d = tempfile.mkdtemp(prefix='cj_'); J.JOBS = d
        try:
            fn(d); results.append((name, True, ''))
        except AssertionError as e:
            results.append((name, False, str(e)))
        except Exception as e:
            results.append((name, False, f'{type(e).__name__}: {e}'))
        finally:
            shutil.rmtree(d, ignore_errors=True)
        return fn
    return deco


def files(out): return sorted(os.listdir(out['dir']))
def jobd(out): return json.load(open(os.path.join(out['dir'], 'job.json'), encoding='utf-8'))


@case('1 happy path: one command -> review_ready package (EN + HI, checks, report, preview)')
def _(d):
    P = Mock(write=[EN], translate=[HI])
    out = J.run(CMD, P, reference_dir=FP)
    assert out['final_state'] == 'review_ready', out
    f = files(out)
    for n in ('en.json', 'hi.json', 'checks_en.json', 'checks_hi.json', 'report.md', 'preview.html', 'scope.json', 'blueprint.json'):
        assert n in f, (n, f)
    ce = json.load(open(os.path.join(out['dir'], 'checks_en.json')))
    assert all(c['covered'] for c in ce['scope']), ce['scope']
    assert ce['copyright']['status'] == 'pass' and ce['copyright']['overlap'] is not None, ce['copyright']
    j = jobd(out); roles = {a['role'] for a in j['attribution']}
    assert {'writer', 'fact_checker_en', 'solver_mcq1', 'translator', 'fact_checker_hi'} <= roles, roles
    assert P.calls.count('write') == 1 and P.calls.count('solve') == 3, P.calls


@case('2 same command again -> same job, nothing regenerated, no duplicate')
def _(d):
    J.run(CMD, Mock(write=[EN], translate=[HI]), reference_dir=FP)
    P2 = Mock()
    out = J.run(CMD, P2, reference_dir=FP)
    assert out['reused'] and out['final_state'] == 'review_ready' and P2.calls == [], (out, P2.calls)
    assert len(os.listdir(d)) == 1, os.listdir(d)


@case('3 first draft misses a syllabus item -> feedback names it -> second draft accepted')
def _(d):
    bad = copy.deepcopy(EN)
    _heat = re.compile(r"heating effect|joule.s law|h = i\^2|i\^2 r t|i2rt", re.I)
    for sec in ('concepts', 'formulas', 'examples', 'mcqs'):      # remove every heating-effect phrase -> genuine scope miss
        for x in bad[sec]:
            for k, v in list(x.items()):
                if isinstance(v, str): x[k] = _heat.sub('effect', v)
                elif isinstance(v, list): x[k] = [_heat.sub('effect', o) if isinstance(o, str) else o for o in v]
    P = Mock(write=[bad, EN], translate=[HI])
    out = J.run(CMD, P, reference_dir=FP)
    assert out['final_state'] == 'review_ready', out
    st = jobd(out)['stages']['write_en']
    assert st['attempts'] == 2 and st['accepted_attempt'] == 2, st
    assert 'Heating effect' in P.last_prompt, 'second prompt must carry the failed check'


@case('4 wrong answer key every time -> needs_review after 3 attempts, no Hindi, not review_ready')
def _(d):
    P = Mock(write=[EN, EN, EN], solve=lambda q: (q['answer_index'] + 1) % 4 if q['difficulty'] == 'medium' else q['answer_index'])
    out = J.run(CMD, P, reference_dir=FP)
    assert out['final_state'] == 'needs_review', out
    j = jobd(out); assert j['stages']['write_en']['attempts'] == 3 and 'translate' not in P.calls
    assert 'hi.json' not in files(out) and 'report.md' in files(out)


@case('5 quota stop during translation -> blocked; re-run resumes and does NOT rewrite English')
def _(d):
    P = Mock(write=[EN], translate=[ProviderUnavailable('gemini', 'quota', 'HTTP 429')])
    out = J.run(CMD, P, reference_dir=FP)
    assert out['final_state'] == 'blocked', out
    assert any(i['kind'] == 'provider_unavailable' for i in jobd(out)['issues'])
    P2 = Mock(translate=[HI])
    out2 = J.run(CMD, P2, reference_dir=FP)
    assert out2['final_state'] == 'review_ready' and out2['job'] == out['job'], out2
    assert 'write' not in P2.calls and P2.calls.count('translate') == 1, P2.calls


@case('6 quota stop while writing -> blocked, attempt not wasted as a content failure')
def _(d):
    out = J.run(CMD, Mock(write=[ProviderUnavailable('openrouter', 'quota', 'HTTP 429')]), reference_dir=FP)
    assert out['final_state'] == 'blocked', out
    out2 = J.run(CMD, Mock(write=[EN], translate=[HI]), reference_dir=FP)
    assert out2['final_state'] == 'review_ready', out2


@case('7 Hindi changes a number -> needs_review (not review_ready)')
def _(d):
    hi = copy.deepcopy(HI); hi['mcqs'][1]['explanation'] = hi['mcqs'][1]['explanation'].replace('2', '4', 1)
    out = J.run(CMD, Mock(write=[EN], translate=[hi]), reference_dir=FP)
    assert out['final_state'] == 'needs_review', out
    assert any('numbers match' in i['detail'] for i in jobd(out)['issues'])


@case('8 copyright reference missing -> check did not run -> needs_review, never review_ready')
def _(d):
    out = J.run(CMD, Mock(write=[EN]), reference_dir='/nonexistent')
    assert out['final_state'] == 'needs_review', out
    assert any(i['kind'] == 'check_not_run' for i in jobd(out)['issues'])


@case('9 copyright overlap above 20% -> fed back, rewritten, accepted')
def _(d):
    import hashlib, re
    real, _ = J.load_reference(FP)
    w = re.findall(r'[a-z0-9ऀ-ॿ]+', J.text_of(EN).lower())
    fake = {hashlib.sha256(' '.join(w[i:i + 3]).encode()).hexdigest()[:16] for i in range(len(w) - 2)}
    tmp = os.path.join(d, 'fp'); os.makedirs(tmp)
    for lang in ('en', 'hi'):
        json.dump({'lang': lang, 'files': [{'file': 'x'}], 'hashes': sorted(fake) if lang == 'en' else []}, open(os.path.join(tmp, lang + '.json'), 'w'))
    other = copy.deepcopy(EN)
    for x in other['concepts'] + other['examples']: x['body'] = x['body'] + ' In short, this idea links charge, energy and circuits in our homes.'
    for x in other['concepts'] + other['examples'] + other['formulas']: x['body'] = ' '.join(reversed(x['body'].split('. ')))
    P = Mock(write=[EN, other], translate=[HI])
    out = J.run(CMD, P, reference_dir=tmp)
    h = jobd(out)['stages']['write_en']['history']
    assert 'copyright overlap' in ' '.join(h[0]['problems']), h[0]['problems']
    assert 'copyright overlap' in P.last_prompt


@case('10 fact checker says wrong -> retried with its reason; persistent -> needs_review')
def _(d):
    out = J.run(CMD, Mock(write=[EN, EN, EN], fact=lambda c, l: (False, 'resistance does not depend on current')), reference_dir=FP)
    assert out['final_state'] == 'needs_review', out
    assert 'resistance does not depend on current' in json.dumps(jobd(out)['stages']['write_en']['history'][-1])


@case('11 unknown / unverified chapters and subjects -> blocked with a reason, no AI call')
def _(d):
    for c, why in (('Class 10, CBSE 2026-27, Science, Life Processes', 'scope not read'),
                   ('Class 10, CBSE 2026-27, Hindi, 1', 'not found'),
                   ('Class 10, CBSE 2026-27, Social Science, Federalism', 'scope not read'),
                   ('Class 12, CBSE 2026-27, Physics, 1', 'no syllabus'),
                   ('Class 10, CBSE 2026-27, Science, Gravity', 'not found')):
        P = Mock(); out = J.run(c, P, reference_dir=FP)
        assert out['final_state'] == 'blocked' and why in out['reason'] and P.calls == [], (c, out)


@case('12 chapter by number works the same as by name (same job id)')
def _(d):
    a = J.run(CMD, Mock(write=[EN], translate=[HI]), reference_dir=FP)
    b = J.run('Class 10, CBSE 2026-27, Science, chapter 11', Mock(), reference_dir=FP)
    assert a['job'] == b['job'] and b['reused'], (a, b)


@case('13 needs_review is not silently redone; --retry starts new attempts on the same job')
def _(d):
    bad = Mock(write=[EN, EN, EN], fact=lambda c, l: (False, 'x'))
    a = J.run(CMD, bad, reference_dir=FP); assert a['final_state'] == 'needs_review'
    b = J.run(CMD, Mock(), reference_dir=FP); assert b['reused'] and b['final_state'] == 'needs_review'
    c = J.run(CMD, Mock(write=[EN], translate=[HI]), retry=True, reference_dir=FP)
    assert c['final_state'] == 'review_ready' and c['job'] == a['job'], c


@case('14 invalid JSON from the writer is a content failure with feedback, not a crash')
def _(d):
    class P(Mock):
        def write(self, prompt):
            self.calls.append('write'); self.last_prompt = prompt
            return ('not json at all', 'mock-writer', 'mock-writer-1') if self.calls.count('write') == 1 else (json.dumps(EN), 'mock-writer', 'mock-writer-1')
    out = J.run(CMD, P(translate=[HI]), reference_dir=FP)
    assert out['final_state'] == 'review_ready', out


@case('15 preview and report state the truth (not published, human review needed, issues listed)')
def _(d):
    out = J.run(CMD, Mock(write=[EN], translate=[HI]), reference_dir=FP)
    p = open(os.path.join(out['dir'], 'preview.html'), encoding='utf-8').read(); r = open(os.path.join(out['dir'], 'report.md'), encoding='utf-8').read()
    assert 'Not published' in p and 'review_ready' in p and 'NOT published' in r and 'mock-writer-1' in r, 'labels missing'


@case('16 crash inside a stage -> failed, error recorded, job file still valid')
def _(d):
    out = J.run(CMD, Mock(write=[EN], solve=lambda q: 1 / 0), reference_dir=FP)
    assert out['final_state'] == 'failed', out
    assert any(i['kind'] == 'crash' for i in jobd(out)['issues'])


if __name__ == '__main__':
    for n, ok, why in results: print(('PASS ' if ok else 'FAIL ') + n + ('' if ok else '  -> ' + why))
    print(f'{sum(ok for _, ok, _ in results)}/{len(results)} passed')
    sys.exit(0 if all(ok for _, ok, _ in results) else 1)
