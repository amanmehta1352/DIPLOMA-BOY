"""Book Core Writer: writes chapter cores (schema/book.core.v1.json) with a free AI, checks them, saves them as DRAFTS.
Nothing reaches students until the owner approves the core in Control Room -> Review -> किताब.

   python3 robots/book/core_writer.py --count 1 [--only <core id>,...] [--dry-run]

Env: GEMINI_API_KEY, SUPABASE_SECRET_KEY (service role), optional OPENROUTER_API_KEY and backup keys (see robots/writer).
Keys are never printed.

Checks before saving (a core that fails is NOT saved; the next run tries again):
  1. tools/book/check.js: structure, counts, every worked example and numeric recomputed from its calc, no Markdown/LaTeX/HTML
  2. second opinion: another AI solves the MCQs and the numeric questions without seeing the answers
  3. Hindi: Devanagari is the majority in the teaching text
  4. copyright: overlap with the NCERT fingerprints we hold (only where they exist)
Which cores to write: robots/book/queue.json, skipping cores already on the server, except ones the owner sent back with
'changes' (the owner's note goes into the prompt). An approved core is never overwritten (the server refuses).
"""
import argparse, copy, json, os, random, subprocess, sys, tempfile, time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.join(HERE, '..', 'writer'))
import writer as W   # AI providers, rpc, owner-note wording, Hindi and copyright checks

PROMPT = os.path.join(ROOT, 'prompts', 'book-core.v1.md')
CHECK_JS = os.path.join(ROOT, 'tools', 'book', 'check.js')
FIXED = ('schema', 'id', 'level_family', 'subject', 'level_hi', 'no', 'title_hi', 'title_en')
MAX_DISAGREE = 1          # second AI may differ on at most this many MCQs, and this many numerics
NUM_TOL = 0.02            # numeric answers agree within 2 %


def build_prompt(tpl, item, note='', feedback=None):
    """Pure: fill the template from a queue item; the owner's note and the last attempt's problems go at the end."""
    p = tpl
    for k in ('id', 'level_family', 'level_hi', 'subject_hi', 'subject_en', 'no', 'title_hi', 'title_en', 'topics'):
        p = p.replace('{' + k + '}', str(item.get(k, '')))
    p = W.add_owner_note(p, note)
    if feedback:
        p += ('\n\nपिछली कोशिश में code की जाँच ने ये गलतियाँ पकड़ीं। इन्हें ठीक करके पूरा JSON फिर से दो:\n- '
              + '\n- '.join(str(x) for x in feedback[:25]) + '\n')
    return p


def pin_fields(core, item):
    """Pure: the queue, not the AI, decides id, numbering and titles."""
    core['schema'] = 'book.core.v1'
    core['subject'] = {'hi': item['subject_hi'], 'en': item['subject_en']}
    for k in ('id', 'level_family', 'level_hi', 'no', 'title_hi', 'title_en'):
        core[k] = item[k]
    return core


def mcqs(core):
    return [q for q in core.get('questions', []) if isinstance(q, dict) and q.get('type') == 'mcq']


def numerics(core):
    return [q for q in core.get('questions', []) if isinstance(q, dict) and q.get('type') == 'numeric']


def shuffle_mcqs(core):
    """AI writers put the right answer in the same place; mix the order (same order on every rerun)."""
    rnd = random.Random(core.get('id'))
    for q in mcqs(core):
        if isinstance(q.get('options'), list) and len(q['options']) == 4 and q.get('answer') in (0, 1, 2, 3):
            right = q['options'][q['answer']]; order = [0, 1, 2, 3]; rnd.shuffle(order)
            q['options'] = [q['options'][i] for i in order]; q['answer'] = q['options'].index(right)
    return core


def code_check(core):
    """tools/book/check.js (the same check Control Room re-runs in the browser). Returns {errs, warn, stats}."""
    fd, path = tempfile.mkstemp(suffix='.json')
    try:
        with os.fdopen(fd, 'w', encoding='utf-8') as f: json.dump(core, f, ensure_ascii=False)
        r = subprocess.run(['node', CHECK_JS, '--json', path], capture_output=True, text=True, encoding='utf-8', timeout=60)
        try: return json.loads(r.stdout.strip().splitlines()[-1])
        except Exception: return {'errs': ['check.js did not answer: ' + (r.stderr or r.stdout)[:200]], 'warn': [], 'stats': {}}
    finally:
        os.remove(path)


def teaching_text(core):
    parts = [core.get('intro', '')]
    for s in core.get('sections', []):
        if isinstance(s, dict):
            parts += [s.get('intro', ''), s.get('defn', '')] + [e.get('text', '') for e in s.get('explain', []) if isinstance(e, dict)]
    parts += [q.get('q', '') for q in core.get('questions', []) if isinstance(q, dict)]
    return ' '.join(str(p) for p in parts)


def without_figures(core):
    c = copy.deepcopy(core); c.pop('figures', None); return c


def ask_checker(prompt):
    """A different company if OPENROUTER_API_KEY is set, else Gemini's small models, else a free backup."""
    if W.ORKEY: return W.openrouter(prompt)
    try: return W.gemini(prompt, W.CHECK_MODELS, temperature=0, deadline=time.time() + 300)
    except RuntimeError: return W.free_write(prompt)


def numeric_disagreements(core, answers):
    """Pure: indexes of numeric questions where the checker's number is missing or more than NUM_TOL away."""
    out = []
    for i, q in enumerate(numerics(core)):
        got = answers[i] if i < len(answers) else None
        try: got = float(got)
        except (TypeError, ValueError): out.append(i); continue
        v = float(q.get('value', 0))
        if abs(got - v) > max(abs(v) * NUM_TOL, 1e-9): out.append(i)
    return out


def second_opinion(core):
    mc = mcqs(core)
    diff_m, model = W.second_opinion({'practice': [{'q': q['q'], 'options': q['options'], 'answer': q['answer']} for q in mc]})
    nq = [{'n': i, 'q': q['q'], 'unit': q.get('unit', '')} for i, q in enumerate(numerics(core))]
    diff_n = []
    if nq:
        txt, _ = ask_checker('Solve each numeric question carefully. Reply only with JSON: {"answers": [number, ...]} in the same '
                             'order, each answer a plain number in the given unit.\n\n' + json.dumps(nq, ensure_ascii=False))
        diff_n = numeric_disagreements(core, W.parse_json(txt).get('answers', []))
    return {'model': model, 'mcq_disagree': diff_m, 'numeric_disagree': diff_n}


def judge(core):
    """Runs every check. Returns (problems, checks) — checks is what Control Room shows."""
    r = code_check(core)
    checks = {'errors': r.get('errs', []), 'warnings': r.get('warn', []), 'stats': r.get('stats', {})}
    prob = list(checks['errors'])
    if prob: return prob, checks
    so = second_opinion(core); checks['second_opinion'] = so
    if len(so['mcq_disagree']) > MAX_DISAGREE: prob.append(f"second AI disagrees on {len(so['mcq_disagree'])} MCQ answers")
    if len(so['numeric_disagree']) > MAX_DISAGREE: prob.append(f"second AI disagrees on {len(so['numeric_disagree'])} numeric answers")
    if not W._hindi_major(teaching_text(core)): prob.append('not Hindi (Devanagari is not the majority)')
    cs = W.copyright_score(without_figures(core))
    checks['copyright_overlap'] = None if cs is None else round(cs, 3)
    if cs is not None and cs > W.COPY_THRESHOLD: prob.append(f'copyright overlap {cs:.0%} is above {W.COPY_THRESHOLD:.0%}')
    return prob, checks


def pick(queue, status, notes, only):
    """Pure: which queue items to write this run.
    status: {core_id: {'status', 'attempts'}} from the server, or None when it could not be read (then only --only runs)."""
    if only: return [q for q in queue if q['id'] in only and (status or {}).get(q['id'], {}).get('status') != 'approved']
    if status is None: return []
    out = []
    for q in queue:
        s = status.get(q['id'])
        if s is None or (s['status'] == 'rejected' and q['id'] in notes): out.append(q)   # new, or owner asked for changes
    return out


def core_status():
    try: return {r['core_id']: r for r in (W.rpc('core_status') or [])}
    except Exception as e:
        print('core status not read (migration 0177?):', W.hide(e)[:120], flush=True); return None


def core_notes():
    try: return {r['core_id']: r.get('note') or '' for r in (W.rpc('core_owner_notes') or [])}
    except Exception as e:
        print('owner notes not read:', W.hide(e)[:120], flush=True); return {}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--count', type=int, default=1)
    ap.add_argument('--only', default='', help='core ids, comma separated (rewrites a draft; never an approved core)')
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--report', default='book-writer-report.md')
    a = ap.parse_args()
    if not W.GKEY: sys.exit('GEMINI_API_KEY missing')
    if not W.SB_KEY and not a.dry_run: sys.exit('SUPABASE_SECRET_KEY missing')

    queue = json.load(open(os.path.join(HERE, 'queue.json'), encoding='utf-8'))
    tpl = open(PROMPT, encoding='utf-8').read()
    status, notes = (core_status(), core_notes()) if W.SB_KEY else ({}, {})
    only = {x.strip() for x in a.only.split(',') if x.strip()}
    todo = pick(queue, status, notes, only)[:a.count]
    lines = ['# Book core writer report', f'to write this run: {len(todo)}', '']
    for item in todo:
        note, feedback, core, checks, model, prob = notes.get(item['id'], ''), None, None, {}, None, ['not written']
        for attempt in range(2):
            try:
                txt, model = W.write_text(build_prompt(tpl, item, note, feedback))
                core = shuffle_mcqs(pin_fields(W.parse_json(txt), item))
                prob, checks = judge(core)
            except Exception as e:
                prob, checks = ['error: ' + W.hide(e)[:300]], {}
            if not prob: break
            feedback = prob
            time.sleep(10)
        if note: checks['owner_note_used'] = note[:1500]
        st = checks.get('stats', {})
        size = f"{st.get('sections', '?')} खंड · {st.get('examples', '?')} उदाहरण · {st.get('figures', '?')} चित्र"
        if prob:
            lines.append(f"- {item['id']}: **not saved** · {model} · {'; '.join(prob[:5])}")
        elif a.dry_run:
            os.makedirs('book-out', exist_ok=True)
            json.dump(core, open(os.path.join('book-out', item['id'].replace('/', '__') + '.core.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
            lines.append(f"- {item['id']}: **ok (dry run)** · {model} · {size}")
        else:
            r = W.rpc('core_upsert', {'p_data': core, 'p_checks': checks, 'p_model': model})
            lines.append(f"- {item['id']}: **{'draft saved' if r == 'ok' else r}** · {model} · {size} · waits for owner review")
        print(lines[-1], flush=True)
        time.sleep(6)
    open(a.report, 'w', encoding='utf-8').write('\n'.join(lines) + '\n')


if __name__ == '__main__':
    main()
