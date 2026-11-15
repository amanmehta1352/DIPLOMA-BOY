"""Offline self-test for the Book Core Writer (no network, no keys). Needs node for tools/book/check.js."""
import copy, json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import core_writer as C

ROOT = C.ROOT
pilot = json.load(open(os.path.join(ROOT, 'content', 'pilot', 'class-10-science-electricity.core.json'), encoding='utf-8'))
queue = json.load(open(os.path.join(HERE, 'queue.json'), encoding='utf-8'))
tpl = open(C.PROMPT, encoding='utf-8').read()

# queue items are complete and their ids fit the server's rule (qual/subject/chapter)
import re
for q in queue:
    for k in ('id', 'level_family', 'level_hi', 'subject_hi', 'subject_en', 'no', 'title_hi', 'title_en', 'topics'):
        assert q.get(k) not in (None, ''), (q.get('id'), k)
    assert re.fullmatch(r'[a-z0-9-]+/[a-z0-9-]+/[a-z0-9-]+', q['id']), q['id']
    assert q['level_family'] in ('basic', 'board', 'technical', 'higher')
assert len({q['id'] for q in queue}) == len(queue)

# prompt: every placeholder filled, owner note and feedback appended
p = C.build_prompt(tpl, queue[0])
assert not re.search(r'\{(id|level_family|level_hi|subject_hi|subject_en|no|title_hi|title_en|topics)\}', p), 'placeholder left'
assert queue[0]['title_hi'] in p
p2 = C.build_prompt(tpl, queue[0], 'चित्र 2 में तीर उलटा है', ['section 1 example 2: calc 2*3 = 6, but value says 7'])
assert 'चित्र 2 में तीर उलटा है' in p2 and 'value says 7' in p2
print('prompt ok')

# the pilot core passes the same code check Control Room runs
r = C.code_check(pilot)
assert r['errs'] == [], r['errs']
bad = copy.deepcopy(pilot); bad['sections'][0]['examples'][0]['value'] += 1
assert any('value says' in e for e in C.code_check(bad)['errs'])
bad = copy.deepcopy(pilot); bad['intro'] = '**मोटा** पाठ'
assert any('Markdown' in e for e in C.code_check(bad)['errs'])
print('code check ok')

# pin_fields: the AI cannot change id, numbering or titles
ai = copy.deepcopy(pilot); ai['id'] = 'x/y/z'; ai['no'] = 99; ai['title_hi'] = 'कुछ और'
item = dict(queue[0])
pinned = C.pin_fields(ai, item)
assert pinned['id'] == item['id'] and pinned['no'] == item['no'] and pinned['title_hi'] == item['title_hi']
assert pinned['subject'] == {'hi': item['subject_hi'], 'en': item['subject_en']}

# MCQ shuffle keeps the right option, is the same on every run, and spreads the answers
a = C.shuffle_mcqs(copy.deepcopy(pilot)); b = C.shuffle_mcqs(copy.deepcopy(pilot))
for x, o in zip(C.mcqs(a), C.mcqs(pilot)):
    assert x['options'][x['answer']] == o['options'][o['answer']]
assert [q['options'] for q in C.mcqs(a)] == [q['options'] for q in C.mcqs(b)]
assert len({q['answer'] for q in C.mcqs(a)}) > 1
print('shuffle ok')

# second-opinion numeric comparison
vals = [q['value'] for q in C.numerics(pilot)]
assert C.numeric_disagreements(pilot, vals) == []
assert C.numeric_disagreements(pilot, [v * 1.01 for v in vals]) == []          # within 2 %
assert C.numeric_disagreements(pilot, [vals[0] * 2] + vals[1:]) == [0]
assert C.numeric_disagreements(pilot, vals[:-1] + ['n/a']) == [len(vals) - 1]

# Hindi and copyright inputs
assert C.W._hindi_major(C.teaching_text(pilot))
assert 'figures' not in C.without_figures(pilot) and 'figures' in pilot

# queue picking
ids = [q['id'] for q in queue]
assert C.pick(queue, {}, {}, set()) == queue                                    # nothing on the server yet
assert C.pick(queue, None, {}, set()) == []                                     # status unknown: write nothing
st = {ids[0]: {'status': 'draft'}, ids[1]: {'status': 'rejected'}, ids[2]: {'status': 'approved'}}
assert [q['id'] for q in C.pick(queue, st, {}, set())] == []                    # drafts wait; owner rejects stay rejected
assert [q['id'] for q in C.pick(queue, st, {ids[1]: 'और उदाहरण'}, set())] == [ids[1]]   # owner asked for changes
assert [q['id'] for q in C.pick(queue, st, {}, {ids[0], ids[2]})] == [ids[0]]   # --only never touches an approved core
assert [q['id'] for q in C.pick(queue, None, {}, {ids[0]})] == [ids[0]]
print('book core writer selftest ok')
