#!/usr/bin/env python3
"""Subject tagger for RRB NTPC sheets printed as ONE section ("RRB NTPC Graduate Level I"): those questions sit in subject
'ntpc-mixed'. NTPC sheets that DO print sections (Mathematics / General Intelligence and Reasoning / General Awareness)
are the teacher: TF-IDF (words + characters) + logistic regression. A question moves only when cross-validated accuracy
>= 0.92 and its own probability >= 0.85; the rest stay in 'ntpc-mixed' and are counted in the report.
   python3 subj_tag.py --dry-run | --apply      (needs SUPABASE_SECRET_KEY)"""
import os, sys, json, argparse, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import robot as R

def text_of(q):
    s = q.get('stem') or {}
    return ' '.join([s.get('en') or ''] + [(o or {}).get('en') or '' for o in (q.get('options') or [])])

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--apply', action='store_true'); ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--min-acc', type=float, default=0.92); ap.add_argument('--min-prob', type=float, default=0.85)
    a = ap.parse_args()
    from sklearn.feature_extraction.text import TfidfVectorizer
    from sklearn.linear_model import LogisticRegression
    from sklearn.model_selection import cross_val_score
    from sklearn.pipeline import make_pipeline, make_union
    subs = {s['slug']: s['id'] for s in R.fetch_all('subjects', {'select': 'id,slug'})}
    topics = R.fetch_all('topics', {'select': 'id,subject_id,slug'})
    inbox = {t['subject_id']: t['id'] for t in topics if t['slug'] == 'inbox'}
    labels = {inbox[subs[k]]: k for k in ('maths', 'reasoning', 'general-awareness') if subs.get(k) in inbox}
    mixed = inbox.get(subs.get('ntpc-mixed'))
    srcs = [x['id'] for x in R.fetch_all('sources', {'select': 'id', 'kind': 'eq.third_party_copy'})]
    rows = []
    for i in range(0, len(srcs), 40):
        rows += R.fetch_all('questions', {'select': 'id,topic_id,status,stem,options', 'source_id': 'in.(' + ','.join(map(str, srcs[i:i + 40])) + ')'})
    train = [q for q in rows if q['topic_id'] in labels and q['status'] != 'hidden' and len(text_of(q)) > 15]
    todo = [q for q in rows if q['topic_id'] == mixed and q['status'] != 'hidden']
    X = [text_of(q) for q in train]; y = [labels[q['topic_id']] for q in train]
    model = make_pipeline(make_union(TfidfVectorizer(ngram_range=(1, 2), min_df=2, sublinear_tf=True),
                                     TfidfVectorizer(analyzer='char_wb', ngram_range=(2, 5), min_df=3, sublinear_tf=True)),
                          LogisticRegression(max_iter=3000, C=8))
    acc = float(cross_val_score(model, X, y, cv=5).mean()) if len(set(y)) > 1 else 0.0
    rep = {'train': dict(collections.Counter(y)), 'cv_accuracy': round(acc, 4), 'todo': len(todo), 'moved': {}, 'left': 0}
    plan = collections.defaultdict(list)
    if acc >= a.min_acc and todo:
        model.fit(X, y); P = model.predict_proba([text_of(q) for q in todo]); cls = list(model.classes_)
        for q, p in zip(todo, P):
            j = int(p.argmax())
            if p[j] >= a.min_prob: plan[cls[j]].append(q['id'])
            else: rep['left'] += 1
        rep['moved'] = {k: len(v) for k, v in plan.items()}
        rep['sample'] = {k: [text_of(q)[:90] for q in todo if q['id'] in set(v[:3])] for k, v in plan.items()}
    else: rep['left'] = len(todo); rep['why'] = 'accuracy below the gate' if todo else 'nothing to tag'
    print(json.dumps(rep, ensure_ascii=False, indent=1))
    if a.apply:
        for k, ids in plan.items():
            for i in range(0, len(ids), 100):
                R.rest('PATCH', 'questions', {'topic_id': inbox[subs[k]]}, params={'id': 'in.(' + ','.join(map(str, ids[i:i + 100])) + ')'})

if __name__ == '__main__':
    main()
