"""Applies fixes.json to a LOCAL copy of the run-13 result and runs every code-only check. No AI, no network, nothing published."""
import json, os, re, shutil, sys
sys.path.insert(0, '/home/claude/work/chapter_job')
import job as J, book_robot as B, numcheck as NC
SRC, DST = sys.argv[1], sys.argv[2]
FP = sys.argv[3]
shutil.rmtree(DST, ignore_errors=True); shutil.copytree(SRC, DST)
F = json.load(open(os.path.join(os.path.dirname(__file__), 'fixes.json'), encoding='utf-8'))
ld = lambda f: json.load(open(os.path.join(DST, f), encoding='utf-8'))
sv = lambda f, o: json.dump(o, open(os.path.join(DST, f), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
bank = ld('questions.json')
for k, fx in F['questions'].items():
    q = bank[int(k) - 1]; q.update(fx)
    if q['type'] == 'mcq': q['answer'] = q['options'][q['answer_index']]
B.normalize_questions(bank); B.finalize_questions.__globals__  # AR stem rebuilt from assertion + reason
for q in bank:
    if q['type'] == 'assertion_reason': q['options'] = B.AR_OPTIONS; q['answer'] = B.AR_OPTIONS[q['answer_index']]
sv('questions.json', bank)
def walk(o, fn):
    if B.pair_ok(o): fn(o); return
    if isinstance(o, list): [walk(y, fn) for y in o]
    elif isinstance(o, dict): [walk(v, fn) for kk, v in o.items() if kk not in ('svg', 'script')]
hits = {}
def fix_pair(p):
    for i, f in enumerate(F['pairs'] + [F['outside_list_fact_check']] + F['copy_runs']):
        if p[1].startswith(f['match_en_start']):
            if 'hi_replace' in f: assert f['hi_replace'][0] in p[0], 'hindi text to replace not found'; p[0] = p[0].replace(*f['hi_replace'])
            elif 'hi_full' in f: p[0] = f['hi_full']
            else: p[:] = f['pair']
            hits[i] = hits.get(i, 0) + 1
import book_render as R
class Jb0:
    def get(s, f): return ld(f)
    def has(s, f): return os.path.exists(os.path.join(DST, f))
secs0 = R.teach_sections(B.assemble(Jb0()))
for f in B.CONTENT_FILES:
    o = ld(f); walk(o, fix_pair)
    if f == 'questions.json': B.normalize_questions(o)       # assertion-reason stems rebuilt from the fixed assertion
    sv(f, o)
# Hinglish of the changed teaching paragraphs (Claude's transliteration of the new Hindi)
secs1 = R.teach_sections(B.assemble(Jb0())); hg = ld('hinglish.json'); hl = {f['pair'][0]: f['hinglish'] for f in F['copy_runs'] if 'hinglish' in f}
changed = []
for si, (a, b) in enumerate(zip(secs0, secs1)):
    if a == b: continue
    for pi, p in enumerate(b.get('paras') or []):
        hit = [h for h in hl if B.pair_ok(p) and p[0].endswith(h)]
        if hit:
            old = hg[si]['paras'][pi]; m = __import__('re').match(r'(\*\*[^*]+:\*\*\s*)', old)
            hg[si]['paras'][pi] = (m.group(1) if m and p[0].startswith('**') else '') + hl[hit[0]]; changed.append((si + 1, pi + 1))
        elif any(B.pair_ok(p) and f['pair'][0] in p[0] and 'hinglish_replace' in f for f in F['copy_runs']):
            f = [f for f in F['copy_runs'] if f['pair'][0] in p[0] and 'hinglish_replace' in f][0]
            assert f['hinglish_replace'][0] in hg[si]['paras'][pi]; hg[si]['paras'][pi] = hg[si]['paras'][pi].replace(*f['hinglish_replace']); changed.append((si + 1, pi + 1))
        elif p != (a.get('paras') or [None] * 99)[pi]: raise SystemExit(f'section {si + 1} para {pi + 1} changed without a Hinglish text')
sv('hinglish.json', hg); print('hinglish paragraphs replaced (section, para):', changed)
cs = ld('concepts.json')
for c in cs:
    if c['key'] in F['tables']: c['table'] = F['tables'][c['key']]
sv('concepts.json', cs)
print('pair fixes applied (index: count):', hits)
# ---- code-only checks on the whole chapter
class Jb:
    dir = DST
    def get(s, f): return ld(f)
    def has(s, f): return os.path.exists(os.path.join(DST, f))
ch = B.assemble(Jb()); bank = ld('questions.json')
refset, langs = J.load_reference(FP)
prs = B.pairs({k: v for k, v in ch.items() if k not in ('hinglish', 'demo')}) + B.pairs(bank)
t = B.term_check(prs)
print('terms: missing', t['missing_hindi_term'], 'banned', t['banned_form'], 'number mismatch', t['number_mismatch_pairs'])
for x in t['bad_pairs']: print('   bad pair:', x['why'], x['pair'][1][:80])
print('tables wrong shape:', B.table_problems(ch['concepts']))
ar_opts = {json.dumps(x, ensure_ascii=False) for x in B.AR_OPTIONS}
runs = [(n, tx, pr[1][:60]) for pr in prs if json.dumps(pr, ensure_ascii=False) not in ar_opts for n, tx in [B.longest_run(re.sub(r'<[^>]+>', ' ', pr[0] + ' ' + pr[1]), refset)] if n and n >= 8]
print('pairs with copied run >= 8 words:', len(runs)); [print('   ', r) for r in runs[:8]]
for k in (2, 5, 8, 19):
    q = bank[k - 1]
    print(f'Q{k}', q['type'], 'calc' if B.calc_mcq(q) else 'text', 'code:', NC.mcq_options_ok(q) if q.get('check') else '-', 'givens in text:', NC.givens_in_text(q.get('check'), q['q'][1]) if q.get('check') else '-',
          'shape problems:', B.question_problems([dict(q)], {q['type']: 1}, {o['id'] for o in ld('outcomes.json')}))
print('calc mcq without check:', [i + 1 for i, q in enumerate(bank) if B.calc_mcq(q) and not q.get('check')])
print('bands:', B.bands(bank))
print('NOT run (need AI): answer-blind solver, numerical re-solve, fact checker, copyright 20% whole-chapter overlap on render (run separately below)')
