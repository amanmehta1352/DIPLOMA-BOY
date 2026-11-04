"""Robot's own st_checks on the manually fixed copy. AI checks are NOT run: blind solver echoes the key (so it proves nothing), fact check = not run."""
import sys, json, os, shutil
sys.path.insert(0, '/home/claude/work/chapter_job')
import job as J, book_robot as B, chapter_robot as C
SRC = sys.argv[1]; J.JOBS = '/tmp/m13jobs'; shutil.rmtree(J.JOBS, ignore_errors=True); os.makedirs(J.JOBS); shutil.copytree(SRC, os.path.join(J.JOBS, '3bd19df16b889b65'))
syl = json.load(open(J.SYLLABUS, encoding='utf-8')); r = J.resolve(J.parse_command('Class 10, CBSE 2026-27, Science, Electricity'), syl); r['app'] = C.find_app(syl, r)
job = J.Job('3bd19df16b889b65'); job.d['hinglish_stale'] = []
refset, _ = J.load_reference(sys.argv[2])
class NoAI:
    max_calls = 0; n_calls = 0; calls = []
    def solve_all(self, items): return [x['answer'] for x in items], 'none', 'NOT RUN'
    def solve_numericals(self, g): return [''] * len(g), 'none', 'NOT RUN'
    def fact_check_app(self, x): return None, 'not run', 'none', 'NOT RUN'
B.st_checks(job, r, NoAI(), refset)
c = json.load(open(os.path.join(J.JOBS, '3bd19df16b889b65', 'checks.json')))
print('problems:', c['problems']); print('copyright', c['copyright']['overlap'], 'longest run', c['copyright']['longest_copied_run_words'])
print('keys', c['key_balance'], 'bands', c['coverage']['bands'], 'terms', c['terms']['missing_hindi_term'], c['terms']['banned_form'], c['terms']['number_mismatch_pairs'])
print('numericals code', all(x['code'] for x in c['numericals']), 'mcq code', [x['ok'] for x in c['mcq_code']], 'scope', all(x['covered'] for x in c['scope']), 'words', c['notes_words'], c['teach_words'])
