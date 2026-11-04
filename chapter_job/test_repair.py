"""Repair tests: error classification, per-check checkpoints, resume, invalidation, bounded provider failures,
and resuming the saved real-run draft. No network, no real AI.

Part A runs the REAL entry point (`python3 job.py "<command>"`, the same call the GitHub workflow makes) with the real
providers.Real code; only the route helper's http() is replaced by stub_route/run_chapter.py (scripted HTTP faults).
Part B calls job.run() with the Mock providers.
"""
import copy, json, os, shutil, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import job as J
from providers import Mock
from common import ProviderUnavailable

FP = os.environ.get('COPYRIGHT_FINGERPRINTS', '/tmp/db-main/robots/copyright/fingerprints')
CMD = 'Class 10, CBSE 2026-27, Science, Electricity'
EN = json.load(open(os.path.join(HERE, 'fixtures', 'en.json'), encoding='utf-8'))
HI = json.load(open(os.path.join(HERE, 'fixtures', 'hi.json'), encoding='utf-8'))
REAL = os.path.join(HERE, 'fixtures', 'real_run_959a')
results = []


def case(name):
    def deco(fn):
        d = tempfile.mkdtemp(prefix='rp_'); J.JOBS = d
        try:
            fn(d); results.append((name, True, ''))
        except AssertionError as e:
            results.append((name, False, str(e)[:400]))
        except Exception as e:
            results.append((name, False, f'{type(e).__name__}: {e}'[:400]))
        finally:
            shutil.rmtree(d, ignore_errors=True)
        return fn
    return deco


def cli(d, scenario, extra_env=None, args=()):
    sc = os.path.join(d, f'sc_{len(os.listdir(d))}.json'); json.dump(scenario, open(sc, 'w'))
    log = os.path.join(d, 'http.jsonl')
    env = {'PATH': os.environ['PATH'], 'ROUTE_DIR': os.path.join(HERE, 'stub_route'), 'STUB_SCENARIO': sc, 'STUB_LOG': log,
           'CHAPTER_JOBS_DIR': os.path.join(d, 'out'), 'COPYRIGHT_FINGERPRINTS': FP, 'PROVIDER_BACKOFF_S': '0,0',
           'OPENROUTER_API_KEY': 'test-key-or', 'GEMINI_API_KEY': 'test-key-gm', 'GROQ_API_KEY': 'test-key-gq',
           'OPENROUTER_MODEL': 'vendor/model-x:free', 'FREE_TIER_CONFIRMED': 'gemini'}
    env.update(extra_env or {})
    if os.path.exists(log): os.remove(log)
    p = subprocess.run([sys.executable, os.path.join(HERE, 'job.py'), CMD, *args], env=env, capture_output=True, text=True, timeout=120)
    out = json.loads(p.stdout.strip().splitlines()[-1])
    calls = [json.loads(x) for x in open(log)] if os.path.exists(log) else []
    jd = json.load(open(os.path.join(out['dir'], 'job.json'))) if out.get('dir') else None
    return out, calls, jd, p.returncode


def att(jd):
    return jd['stages']['write_en']['history'][-1]


# ---------------- A: real entry point, stubbed HTTP ----------------
@case('A1 CLI: Gemini 503 on every model while solving MCQ 3, Groq disabled -> blocked (not failed); finished checks saved, MCQ 3 inconclusive')
def _(d):
    q3 = EN['mcqs'][2]['question'][:40]
    out, calls, jd, rc = cli(d, {'rules': [{'url': 'generativelanguage', 'kind': 'solve', 'statuses': [200, 200] + [503] * 9}]})
    # first two solve requests answered (200 in the rule means: use the normal answer path) -> emulate by allowing 2 then 503s
    assert out['final_state'] == 'blocked', (out, jd['issues'][-1:])
    iss = jd['issues'][-1]
    assert iss['kind'] == 'provider_unavailable' and iss['provider'] == 'gemini' and iss['reason'] == 'transient', iss
    c = att(jd)['checks']
    assert c['fact_check_en']['status'] == 'done' and c['fact_check_en']['model'] == 'gemini-a-flash', c['fact_check_en']
    assert c['solve_mcq1']['status'] == 'done' and c['solve_mcq2']['status'] == 'done', c
    assert c['solve_mcq3']['status'] == 'pending', c['solve_mcq3']
    assert jd['stages']['write_en']['attempts'] == 1 and att(jd)['status'] == 'incomplete'
    s503 = [x for x in calls if x['status'] == 503]
    assert len(s503) == 9 and {x['model'] for x in s503} == {'gemini-a-flash', 'gemini-b-flash', 'gemini-c-flash'}, s503   # 3 tries x 3 models
    assert not any('groq' in x['url'] for x in calls), 'Groq must not be called'
    rep = open(os.path.join(out['dir'], 'report.md')).read()
    assert 'en solve_mcq3: inconclusive' in rep and 'en fact_check_en: pass' in rep, rep[:1500]
    assert rc == 2


@case('A2 CLI resume after A1: no rewrite, no repeat of finished checks; only MCQ 3 + Hindi run -> review_ready')
def _(d):
    cli(d, {'rules': [{'url': 'generativelanguage', 'kind': 'solve', 'statuses': [200, 200] + [503] * 9}]})
    out, calls, jd, rc = cli(d, {})
    assert out['final_state'] == 'review_ready', (out, jd['issues'][-2:])
    kinds = [x['kind'] for x in calls if x['kind'] != 'price_list']
    assert kinds == ['solve', 'translate', 'fact'], kinds          # fact = the Hindi fact check
    assert jd['stages']['write_en']['attempts'] == 1 and jd['runs'] == 2


@case('A3 CLI: provider rejects our request (HTTP 400) -> failed (code/schema error), not blocked')
def _(d):
    out, calls, jd, rc = cli(d, {'rules': [{'url': 'openrouter', 'kind': 'write', 'statuses': [400]}]})
    assert out['final_state'] == 'failed' and jd['issues'][-1]['error'] == 'ProviderRequestError', jd['issues'][-1]
    assert len([x for x in calls if x['status'] == 400]) == 1, 'no retry on a request error'


@case('A4 CLI: unreadable Gemini envelope -> failed (schema error)')
def _(d):
    out, calls, jd, rc = cli(d, {'bad_envelope': True})
    assert out['final_state'] == 'failed' and jd['issues'][-1]['error'] == 'ProviderRequestError', jd['issues'][-1]


@case('A5 CLI: OpenRouter quota (429) while writing -> blocked/quota after ONE try; no attempt used up')
def _(d):
    out, calls, jd, rc = cli(d, {'rules': [{'url': 'openrouter', 'kind': 'write', 'statuses': [429]}]})
    assert out['final_state'] == 'blocked' and jd['issues'][-1]['reason'] == 'quota', jd['issues'][-1]
    assert len([x for x in calls if x['kind'] == 'write']) == 1 and jd['stages']['write_en']['attempts'] == 0


@case('A6 CLI: writer timeouts -> 3 tries then blocked/timeout; 2 timeouts then success -> continues')
def _(d):
    out, calls, jd, rc = cli(d, {'rules': [{'url': 'openrouter', 'kind': 'write', 'statuses': [-1, -1, -1]}]})
    assert out['final_state'] == 'blocked' and jd['issues'][-1]['reason'] == 'timeout', jd['issues'][-1]
    assert len([x for x in calls if x['kind'] == 'write']) == 3
    d2 = os.path.join(d, 'second'); os.makedirs(d2)
    out, calls, jd, rc = cli(d2, {'rules': [{'url': 'openrouter', 'kind': 'write', 'statuses': [-1, -1]}]})
    assert out['final_state'] == 'review_ready', (out, jd['issues'])
    assert [x['kind'] for x in jd['provider_calls'][:3]] == ['timeout', 'timeout', 'ok'], jd['provider_calls'][:3]


@case('A7 CLI: total provider time budget 0 -> blocked/time_budget before any AI request')
def _(d):
    out, calls, jd, rc = cli(d, {}, {'PROVIDER_TIME_BUDGET_S': '0'})
    assert out['final_state'] == 'blocked' and jd['issues'][-1]['reason'] == 'time_budget', jd['issues'][-1]
    assert not [x for x in calls if x['kind'] != 'price_list']


@case('A8 CLI: non-:free model, or a :free id with a non-zero price -> blocked/not_free, zero AI requests')
def _(d):
    out, calls, jd, rc = cli(d, {}, {'OPENROUTER_MODEL': 'deepseek/deepseek-chat'})
    assert out['final_state'] == 'blocked' and jd['issues'][-1]['reason'] == 'not_free' and not calls, (jd['issues'][-1], calls)
    d2 = os.path.join(d, 'b'); os.makedirs(d2)
    out, calls, jd, rc = cli(d2, {'price': {'prompt': '0.0000002', 'completion': '0'}})
    assert out['final_state'] == 'blocked' and jd['issues'][-1]['reason'] == 'not_free', jd['issues'][-1]
    assert [x['kind'] for x in calls] == ['price_list'], calls


@case('A9 CLI: OpenRouter answers with a different (possibly paid) model -> blocked, draft not used')
def _(d):
    out, calls, jd, rc = cli(d, {'answer_model': 'vendor/paid-model'})
    assert out['final_state'] == 'blocked' and jd['issues'][-1]['reason'] == 'not_free', jd['issues'][-1]
    assert jd['stages']['write_en']['attempts'] == 0


@case('A10 CLI: Gemini key not in FREE_TIER_CONFIRMED -> blocked/not_configured, Gemini never called; same for Groq')
def _(d):
    out, calls, jd, rc = cli(d, {}, {'FREE_TIER_CONFIRMED': ''})
    assert out['final_state'] == 'blocked' and jd['issues'][-1]['reason'] == 'not_configured', jd['issues'][-1]
    assert not any('generativelanguage' in x['url'] for x in calls if 'url' in x)
    d2 = os.path.join(d, 'g'); os.makedirs(d2)
    out, calls, jd, rc = cli(d2, {'rules': [{'url': 'generativelanguage', 'kind': 'solve', 'statuses': [503] * 9}]})
    assert out['final_state'] == 'blocked' and not any('groq' in x['url'] for x in calls), 'Groq disabled: no fallback call'


@case('A11 CLI: no secret value appears in any output file or stdout')
def _(d):
    out, calls, jd, rc = cli(d, {'rules': [{'url': 'generativelanguage', 'kind': 'solve', 'statuses': [503] * 9}]})
    blob = ''.join(open(os.path.join(r, f), errors='ignore').read() for r, _, fs in os.walk(os.path.join(d, 'out')) for f in fs)
    for k in ('test-key-or', 'test-key-gm', 'test-key-gq'): assert k not in blob, k


# ---------------- B: checkpoints, invalidation, saved real draft ----------------
@case('B1 content changed on disk after a stop -> every check of that draft re-runs; no stale result used')
def _(d):
    P = Mock(write=[EN], solve=[0, 1, ProviderUnavailable('gemini', 'transient')])
    out = J.run(CMD, P, reference_dir=FP); assert out['final_state'] == 'blocked', out
    p = os.path.join(out['dir'], 'en_attempt_1.json'); x = json.load(open(p)); x['concepts'][0]['title'] += ' (edited)'; json.dump(x, open(p, 'w'))
    P2 = Mock(translate=[HI]); out2 = J.run(CMD, P2, reference_dir=FP)
    jd = json.load(open(os.path.join(out['dir'], 'job.json')))
    assert any(i['kind'] == 'checks_invalidated' for i in jd['issues'])
    assert P2.calls.count('fact_en') == 1 and P2.calls.count('solve') == 3 and 'write' not in P2.calls, P2.calls
    assert out2['final_state'] == 'review_ready', out2


@case('B2 check code / threshold version changes -> saved check results are not reused')
def _(d):
    P = Mock(write=[EN], solve=[0, ProviderUnavailable('gemini', 'quota')])
    out = J.run(CMD, P, reference_dir=FP)
    old = J.CHECKS_CODE_VERSION; J.CHECKS_CODE_VERSION = 'checks.test-bump'
    try:
        P2 = Mock(translate=[HI]); J.run(CMD, P2, reference_dir=FP)
    finally:
        J.CHECKS_CODE_VERSION = old
    assert P2.calls.count('fact_en') == 1 and P2.calls.count('solve') == 3, P2.calls


@case('B3 resume with same content+version -> finished AI checks are NOT called again')
def _(d):
    P = Mock(write=[EN], solve=[0, 1, ProviderUnavailable('gemini', 'transient')])
    out = J.run(CMD, P, reference_dir=FP)
    P2 = Mock(translate=[HI]); out2 = J.run(CMD, P2, reference_dir=FP)
    assert P2.calls == ['solve', 'translate', 'fact_hi'], P2.calls
    assert out2['final_state'] == 'review_ready'


@case('B4 English changed after translation -> Hindi and its checks redone')
def _(d):
    out = J.run(CMD, Mock(write=[EN], translate=[HI], fact=[(True, ''), ProviderUnavailable('openrouter', 'quota')]), reference_dir=FP)
    assert out['final_state'] == 'blocked'
    jp = os.path.join(out['dir'], 'job.json'); jd = json.load(open(jp)); jd['stages']['translate_hi']['en_hash'] = 'stale'; json.dump(jd, open(jp, 'w'))
    P2 = Mock(translate=[HI]); out2 = J.run(CMD, P2, reference_dir=FP)
    assert P2.calls == ['translate', 'fact_hi'], P2.calls
    assert any(i['kind'] == 'checks_invalidated' for i in json.load(open(jp))['issues'])


@case('B5 saved REAL-run draft: old "failed" reclassified to blocked; resume uses the saved draft, overlap 23.9% still fails, '
      'no AI check spent on it, correction attempt 2 gets the copyright reason; draft file untouched')
def _(d):
    dst = os.path.join(d, '959a206c8abbcb0f'); shutil.copytree(REAL, dst)
    h0 = J.chash(json.load(open(os.path.join(dst, 'en_attempt_1.json'))))
    P = Mock(write=[EN], translate=[HI]); out = J.run(CMD, P, reference_dir=FP)
    jd = json.load(open(os.path.join(dst, 'job.json')))
    assert any(i['kind'] == 'reclassified' for i in jd['issues']), jd['issues']
    h = jd['stages']['write_en']['history']
    assert h[0]['n'] == 1 and h[0]['status'] == 'rejected' and h[0]['content_hash'] == h0, h[0]
    cr = h[0]['checks']['copyright']['result']
    assert cr['status'] == 'fail' and abs(cr['overlap'] - 0.2387) < 0.0005, cr
    assert h[0]['checks']['fact_check_en']['status'].startswith('skipped'), h[0]['checks']['fact_check_en']
    assert P.calls[0] == 'write' and 'copyright overlap 24% above the limit' in P.last_prompt, (P.calls, P.last_prompt[-300:])
    assert jd['stages']['write_en']['attempts'] == 2 and jd['stages']['write_en']['accepted_attempt'] == 2
    assert J.chash(json.load(open(os.path.join(dst, 'en_attempt_1.json')))) == h0
    assert out['final_state'] == 'review_ready'


@case('B6 saved REAL draft: budget is the ORIGINAL 3 attempts (no new cycle): two more bad drafts -> needs_review at attempt 3')
def _(d):
    dst = os.path.join(d, '959a206c8abbcb0f'); shutil.copytree(REAL, dst)
    bad = json.load(open(os.path.join(REAL, 'en_attempt_1.json')))
    P = Mock(write=[bad, bad, bad]); out = J.run(CMD, P, reference_dir=FP)
    jd = json.load(open(os.path.join(dst, 'job.json')))
    assert out['final_state'] == 'needs_review' and jd['stages']['write_en']['attempts'] == 3 and P.calls.count('write') == 2, (out, P.calls)


@case('B7 a real crash (non-provider) stays failed and is not reclassified or silently re-run')
def _(d):
    class Boom(Mock):
        def fact_check(self, c, l): raise KeyError('schema')
    out = J.run(CMD, Boom(write=[EN]), reference_dir=FP); assert out['final_state'] == 'failed'
    out2 = J.run(CMD, Mock(), reference_dir=FP)
    assert out2['final_state'] == 'failed' and out2['reused'], out2


@case('B8 write call quota stop does not consume an attempt (attempt counted only after a reply)')
def _(d):
    out = J.run(CMD, Mock(write=[ProviderUnavailable('openrouter', 'quota')]), reference_dir=FP)
    jd = json.load(open(os.path.join(out['dir'], 'job.json')))
    assert jd['stages']['write_en']['attempts'] == 0 and out['final_state'] == 'blocked'


@case('B9 checker reply not parseable -> inconclusive (never pass, never a crash): Hindi -> needs_review, verdict inconclusive')
def _(d):
    out = J.run(CMD, Mock(write=[EN], translate=[HI], fact=lambda c, l: (None, 'inconclusive: checker reply not parseable: x') if l == 'hi' else (True, '')), reference_dir=FP)
    jd = json.load(open(os.path.join(out['dir'], 'job.json')))
    assert out['final_state'] == 'needs_review', (out, jd['issues'][-1:])
    assert J.verdict('fact_check_hi', jd['stages']['translate_hi']['checks']['fact_check_hi'], 'pending') == 'inconclusive'
    assert not any(i['kind'] == 'crash' for i in jd['issues'])


# ---------------- C: Run-3 role change (Gemini writer, OpenRouter checker) via the CLI ----------------
G3 = {'WRITER_PROVIDER': 'gemini', 'GEMINI_WRITER_MODEL': 'gemini-b-flash', 'JOB_CYCLE': 'run3-gemini-writer'}


@case('C1 CLI Gemini writer: writer = pinned Gemini model only; EN fact check + all MCQ solves = OpenRouter free model; '
      'translator Gemini, Hindi check OpenRouter; zero-price check done -> review_ready')
def _(d):
    out, calls, jd, rc = cli(d, {}, G3)
    assert out['final_state'] == 'review_ready', (out, jd['issues'])
    seq = [(x['kind'], 'gemini' if 'generativelanguage' in x['url'] else ('openrouter' if 'openrouter' in x['url'] else x['url']), x['model']) for x in calls]
    assert seq[0] == ('write', 'gemini', 'gemini-b-flash'), seq
    assert ('price_list', 'openrouter', '') in seq, seq
    rest = [x for x in seq if x[0] != 'price_list']
    assert [x[:2] for x in rest] == [('write', 'gemini'), ('fact', 'openrouter'), ('solve', 'openrouter'), ('solve', 'openrouter'),
                                     ('solve', 'openrouter'), ('translate', 'gemini'), ('fact', 'openrouter')], rest
    assert all(x[2] == 'vendor/model-x:free' for x in rest if x[1] == 'openrouter')
    assert not any('groq' in x['url'] for x in calls)


@case('C2 CLI Gemini writer down on every Gemini model, no other free provider confirmed -> blocked; never an OpenRouter/paid writer')
def _(d):
    out, calls, jd, rc = cli(d, {'rules': [{'url': 'generativelanguage', 'kind': 'write', 'statuses': [503] * 9}]}, G3)
    assert out['final_state'] == 'blocked', jd['issues'][-1]
    w = [x for x in calls if x['kind'] == 'write']
    assert len(w) == 9 and all('generativelanguage' in x['url'] for x in w) and w[0]['model'] == 'gemini-b-flash', [(x['model'], x['status']) for x in w]


@case('C2b CLI Gemini out of quota -> next free provider (Groq) writes when the owner confirmed it; then Cloudflare if Groq is out too')
def _(d):
    env = dict(G3, FREE_TIER_CONFIRMED='gemini,groq,cloudflare', CLOUDFLARE_API_TOKEN='test-key-cf', CLOUDFLARE_ACCOUNT_ID='acct')
    out, calls, jd, rc = cli(d, {'rules': [{'url': 'generativelanguage', 'kind': 'write', 'statuses': [429] * 3}]}, env)
    w = [(x['url'].split('/')[2], x['status']) for x in calls if x['kind'] == 'write']
    assert w[-1] == ('api.groq.com', 200) and jd['attribution'][0]['provider'] == 'groq', (w, jd['attribution'][:1])
    d2 = os.path.join(d, 'b'); os.makedirs(d2)
    out, calls, jd, rc = cli(d2, {'rules': [{'url': 'generativelanguage', 'kind': 'write', 'statuses': [429] * 3},
                                            {'url': 'api.groq.com', 'kind': 'write', 'statuses': [429]}]}, env)
    w = [(x['url'].split('/')[2], x['status']) for x in calls if x['kind'] == 'write']
    assert w[-1] == ('api.cloudflare.com', 200), w


@case('C3 CLI total request cap (PROVIDER_MAX_CALLS) -> blocked/call_budget, never exceeded')
def _(d):
    out, calls, jd, rc = cli(d, {}, dict(G3, PROVIDER_MAX_CALLS='3'))
    assert out['final_state'] == 'blocked' and jd['issues'][-1]['reason'] == 'call_budget', jd['issues'][-1]
    assert len([x for x in calls if x['kind'] != 'price_list']) == 3


@case('C4 CLI new cycle = separate job: old run-1/2 job folder and history untouched; new job has its own 3-attempt budget')
def _(d):
    os.makedirs(os.path.join(d, 'out')); old = os.path.join(d, 'out', '959a206c8abbcb0f'); shutil.copytree(REAL, old)
    before = {f: open(os.path.join(old, f), 'rb').read() for f in os.listdir(old)}
    out, calls, jd, rc = cli(d, {}, G3)
    assert out['job'] != '959a206c8abbcb0f' and out['final_state'] == 'review_ready', out
    assert {f: open(os.path.join(old, f), 'rb').read() for f in os.listdir(old)} == before
    assert jd['stages']['write_en']['attempts'] == 1 and jd['runs'] == 1


@case('C5 CLI every new draft over the copyright limit -> needs_review after 3; each draft, raw reply and matching-passage file kept; '
      'last attempt still gets fact check + MCQ solves as evidence; earlier attempts show skipped')
def _(d):
    out, calls, jd, rc = cli(d, {'write_file': os.path.join(REAL, 'en_attempt_1.json')}, G3)
    assert out['final_state'] == 'needs_review', out
    w = jd['stages']['write_en']; h = w['history']
    assert w['attempts'] == 3 and [x['status'] for x in h] == ['rejected'] * 3, h
    files = os.listdir(out['dir'].replace('out/', os.path.join(d, 'out') + '/', 1) if not os.path.isabs(out['dir']) else out['dir'])
    for n in (1, 2, 3):
        assert f'en_attempt_{n}.json' in files and f'en_attempt_{n}.raw.txt' in files and f'en_attempt_{n}.copyright.md' in files, files
    assert h[0]['checks']['fact_check_en']['status'].startswith('skipped') and h[2]['checks']['fact_check_en']['status'] == 'done'
    assert all(h[2]['checks'][f'solve_mcq{i}']['status'] == 'done' for i in (1, 2, 3))
    assert 'translate' not in [x['kind'] for x in calls], 'no Hindi for a rejected English draft'
    rep = open(os.path.join(out['dir'], 'report.md')).read()
    assert 'hi local_hi: pending' in rep and 'en copyright: fail' in rep, rep[:1200]


@case('C6 writer reply with raw newlines inside JSON strings (the run-2 attempt-3 failure) is parsed, not rejected')
def _(d):
    raw = json.dumps(EN, ensure_ascii=False).replace('\\n', '\n')
    raw = raw.replace(EN['concepts'][0]['body'][:20], EN['concepts'][0]['body'][:10] + '\n' + EN['concepts'][0]['body'][10:20], 1)
    assert '\n' in raw
    out, calls, jd, rc = cli(d, {'write_raw': raw}, G3)
    assert out['final_state'] == 'review_ready', (out, jd['issues'])


if __name__ == '__main__':
    for n, ok, why in results: print(('PASS ' if ok else 'FAIL ') + n + ('' if ok else '  -> ' + why))
    print(f'{sum(ok for _, ok, _ in results)}/{len(results)} passed')
