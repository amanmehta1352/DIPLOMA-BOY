"""Every copied run >= 8 words in the same text the robot's copyright gate reads (rendered notes + teach + questions)."""
import json, os, re, sys
sys.path.insert(0, '/home/claude/work/chapter_job')
import job as J, book_robot as B
D = sys.argv[1]; refset, _ = J.load_reference(sys.argv[2])
row = json.load(open(os.path.join(D, 'chapter_books_row.json'), encoding='utf-8'))['data']; bank = json.load(open(os.path.join(D, 'questions.json'), encoding='utf-8'))
plain = re.sub(r'<[^>]+>', ' ', row['notes_hi'] + ' ' + row['notes_en'] + ' ' + row['teach']['hindi'] + ' ' + row['teach']['english'])
qplain = ' '.join(x for pr in B.pairs([{k: v for k, v in q.items() if not (q.get('type') == 'assertion_reason' and k in ('options', 'answer'))} for q in bank]) for x in pr)
w = re.findall(r'[a-z0-9ऀ-ॿ]+', (plain + ' ' + qplain).lower()); cur = 0; out = set()
for i in range(len(w) - 2):
    hit = J.hashlib.sha256(' '.join(w[i:i + 3]).encode()).hexdigest()[:16] in refset
    if hit: cur += 1
    if (not hit or i == len(w) - 3) and cur:
        end = i - 1 if not hit else i
        if cur + 2 >= 8: out.add(' '.join(w[end - cur + 1:end + 3]))
        cur = 0
for r in sorted(out, key=len, reverse=True): print(len(r.split()), '|', r)
print('total', len(out))
