#!/usr/bin/env python3
"""Chapter tagger for import drafts. Learns from questions already tagged by hand (published, chapter_id set),
per subject: TF-IDF + logistic regression. Moves a draft only when the subject's cross-validation accuracy >= 0.80
and the top chapter probability >= 0.55. Everything else stays in 'To be tagged' and is listed in the report.
   python3 tag.py --dry-run | --apply     (needs SUPABASE_SECRET_KEY, same as robot.py)"""
import os, sys, json, argparse, collections, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import robot as R

def text_of(stem, opts):
    return ' '.join([(stem or {}).get('en', '') or ''] + [(o or {}).get('en', '') or '' for o in (opts or [])])

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--apply', action='store_true'); ap.add_argument('--dry-run', action='store_true'); ap.add_argument('--min-acc', type=float, default=0.80); ap.add_argument('--min-prob', type=float, default=0.55); ap.add_argument('--status', default='draft', help='draft (imports) or published (NTPC questions already live in To be tagged)')
    a = ap.parse_args()
    from sklearn.feature_extraction.text import TfidfVectorizer
    from sklearn.linear_model import LogisticRegression
    from sklearn.model_selection import cross_val_score
    from sklearn.pipeline import make_pipeline
    topics = R.fetch_all('topics', {'select': 'id,subject_id,slug,is_chapter'})
    chap = {t['id']: t for t in topics if t['is_chapter']}
    inbox = {t['subject_id']: t['id'] for t in topics if t['slug'] == 'inbox'}
    train = R.fetch_all('questions', {'select': 'id,chapter_id,topic_id,stem,options', 'status': 'eq.published', 'chapter_id': 'not.is.null'})
    drafts = R.fetch_all('questions', {'select': 'id,topic_id,stem,options', 'status': 'eq.' + a.status, 'topic_id': 'in.(' + ','.join(str(v) for v in inbox.values()) + ')'})
    by_subj = collections.defaultdict(lambda: ([], []))
    for q in train:
        c = chap.get(q['chapter_id'])
        if c: by_subj[c['subject_id']][0].append(text_of(q['stem'], q['options'])); by_subj[c['subject_id']][1].append(q['chapter_id'])
    subj_of_inbox = {v: k for k, v in inbox.items()}
    report = {'drafts': len(drafts), 'moved': {}, 'left': {}, 'subjects': {}}
    plan = []
    groups = collections.defaultdict(list)
    for d in drafts: groups[subj_of_inbox.get(d['topic_id'])].append(d)
    for sid, ds in groups.items():
        X, y = by_subj.get(sid, ([], []))
        if len(set(y)) < 2 or len(X) < 30:
            report['subjects'][str(sid)] = 'too few tagged examples'; report['left'][str(sid)] = len(ds); continue
        model = make_pipeline(TfidfVectorizer(ngram_range=(1, 2), min_df=2, sublinear_tf=True), LogisticRegression(max_iter=2000, C=5))
        k = min(5, collections.Counter(y).most_common()[-1][1])
        acc = float(cross_val_score(model, X, y, cv=max(2, k)).mean()) if k >= 2 else 0.0
        report['subjects'][str(sid)] = round(acc, 3)
        if acc < a.min_acc: report['left'][str(sid)] = len(ds); continue
        model.fit(X, y); P = model.predict_proba([text_of(d['stem'], d['options']) for d in ds]); cls = model.classes_
        n = 0
        for d, p in zip(ds, P):
            j = int(p.argmax())
            if p[j] >= a.min_prob: plan.append((d['id'], int(cls[j]), chap[int(cls[j])]['id'])); n += 1
        report['moved'][str(sid)] = n; report['left'][str(sid)] = len(ds) - n
    print(json.dumps(report, ensure_ascii=False))
    if a.apply:
        for i in range(0, len(plan), 200):
            for qid, cid, tid in plan[i:i + 200]:
                R.rest('PATCH', 'questions', {'chapter_id': cid, 'topic_id': cid}, params={'id': f'eq.{qid}'})
    json.dump({'plan': plan}, open('tag_plan.json', 'w'))

if __name__ == '__main__':
    main()
