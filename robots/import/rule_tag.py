#!/usr/bin/env python3
"""Chapter rules for NTPC questions still in 'To be tagged' (Maths, General Awareness, Reasoning).
One place for all keywords: RULES below. The first chapter whose keyword is found in the English text wins.
Accuracy is measured on questions already tagged by hand/model; a subject is applied only if the rules are right
at least --min-acc of the time on those (default 0.80). Everything else stays in 'To be tagged'.
   python3 rule_tag.py --dry-run | --apply     (needs SUPABASE_SECRET_KEY, same as robot.py)"""
import os, sys, re, json, argparse, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import robot as R

# subject -> [(chapter slug, [keywords])]  -- order matters (most specific first)
RULES = {
 'maths': [
  ('pl',    ['profit', 'loss', 'discount', 'marked price', 'cost price', 'selling price']),
  ('si',    ['simple interest', 'compound interest', 'per annum', 'principal', 'interest']),
  ('tw',    ['pipe', 'cistern', 'alone', 'together', 'complete the work', 'work done', 'days to complete']),
  ('tsd',   ['km/h', 'speed', 'boat', 'stream', 'train', 'distance', 'metres per second', 'm/s']),
  ('ratio', ['ratio', 'proportion']),
  ('mix',   ['mixture', 'alligation', 'mixed', 'vessel', 'milk and water']),
  ('age',   ['ages', 'age of', 'years ago', 'years hence', 'years old']),
  ('avg',   ['average']),
  ('num',   ['lcm', 'hcf', 'remainder', 'divisible', 'prime', 'digit', 'factor', 'number system']),
  ('mens',  ['volume', 'surface area', 'cylinder', 'cone', 'sphere', 'hemisphere', 'cuboid', 'cube', 'perimeter', 'circumference']),
  ('trig',  ['sin ', 'cos ', 'tan ', 'sec ', 'cosec', 'cot ', 'angle of elevation', 'angle of depression']),
  ('geo',   ['triangle', 'circle', 'chord', 'tangent', 'parallel', 'polygon', 'rhombus', 'quadrilateral', 'bisector', 'area of', 'angle']),
  ('stat',  ['median', 'mode', 'frequency', 'variance', 'standard deviation', 'probability', 'data']),
  ('alg',   ['equation', 'quadratic', 'roots', 'value of x', 'value of x²', 'x²', 'polynomial']),
  ('simp',  ['simplify', 'simplification', 'find the value', 'evaluate', 'value of']),
  ('pct',   ['percent', '%', 'percentage']),
 ],
 'general-awareness': [
  ('polity',      ['article', 'constitution', 'parliament', 'lok sabha', 'rajya sabha', 'fundamental right', 'governor', 'amendment', 'supreme court', 'high court', 'schedule']),
  ('history',     ['battle', 'empire', 'dynasty', 'treaty', 'revolt', 'viceroy', 'mughal', 'gupta', 'british', 'freedom', 'movement', 'congress', 'founded']),
  ('geography',   ['river', 'mountain', 'plateau', 'climate', 'soil', 'desert', 'peninsula', 'latitude', 'longitude', 'monsoon', 'rainfall', 'lake']),
  ('economy',     ['gdp', 'inflation', 'rbi', 'budget', 'fiscal', 'tax', 'monetary', 'export', 'import', 'bank', 'economic', 'repo rate']),
  ('computer',    ['computer', 'software', 'hardware', 'internet', 'keyboard', 'windows', 'ms office', 'network', 'virus', 'binary']),
  ('sci',         ['physics', 'chemistry', 'biology', 'atom', 'element', 'cell', 'vitamin', 'disease', 'plant', 'acid', 'metal', 'force', 'energy', 'light', 'gas', 'sound', 'heat', 'speed of']),
  ('cult',        ['dance', 'music', 'festival', 'temple', 'painting', 'classical', 'folk', 'art ', 'monument']),
  ('current-affairs', ['2025', '2026', 'summit', 'launched', 'appointed', 'scheme', 'celebrated', 'index']),
  ('static-gk',   ['award', 'book', 'author', 'capital of', 'currency', 'headquarter', 'organisation', 'organization', 'national']),
 ],
 'reasoning': [
  ('series',        ['series']),
  ('analogy',       ['analogy', 'is to', 'as is to']),
  ('odd',           ['odd one', 'odd man', 'which one is different', 'does not belong']),
  ('syllogism',     ['syllogism', 'conclusion', 'conclusions follow']),
  ('blood-relation',['brother', 'sister', 'father', 'mother', 'son of', 'daughter', 'uncle', 'aunt', 'relation']),
  ('direction-sense',['north', 'south', 'east', 'west', 'direction']),
  ('coding-decoding',['code', 'coded', 'decoded', 'coding']),
  ('alphabet-word-order',['alphabet', 'letters', 'word order', 'alphanumeric']),
  ('seating-arrangement-puzzle',['seated', 'seating', 'arranged', 'row', 'facing']),
  ('mathematical-operations',['symbol', 'operation', 'replaced by']),
  ('venn',          ['venn']),
  ('stmt',          ['statement', 'data sufficiency', 'sufficient']),
 ],
}

def predict(subj, text):
    t = ' ' + re.sub(r'\s+', ' ', (text or '').lower()) + ' '
    for chap, kws in RULES.get(subj, []):
        for k in kws:
            if re.search(r'(?<![a-z])' + re.escape(k.strip()) + r'(?![a-z])', t) or (k in t and not k[0].isalpha()):
                return chap
    return None

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--apply', action='store_true'); ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--min-acc', type=float, default=0.80)
    a = ap.parse_args()
    subs = {s['id']: s['slug'] for s in R.fetch_all('subjects', {'select': 'id,slug'})}
    topics = R.fetch_all('topics', {'select': 'id,subject_id,slug,is_chapter'})
    by_id = {t['id']: t for t in topics}
    chap = {(t['slug'], t['subject_id']): t['id'] for t in topics if t['is_chapter']}
    inbox = {t['subject_id']: t['id'] for t in topics if t['slug'] == 'inbox'}
    # tagged questions: chapter_id is the chapter topic; its subject comes from that chapter row
    allq = R.fetch_all('questions', {'select': 'id,chapter_id,topic_id,stem,options', 'status': 'eq.published', 'chapter_id': 'not.is.null'})
    report = {'subjects': {}}; plan = []
    for sslug in RULES:
        sid = next((i for i, s in subs.items() if s == sslug), None)
        if sid is None or sid not in inbox: continue
        def text(q):
            s = q.get('stem') or {}; return ' '.join([s.get('en') or ''] + [(o or {}).get('en') or '' for o in (q.get('options') or [])])
        tagged = [q for q in allq if q['chapter_id'] in by_id and by_id[q['chapter_id']]['subject_id'] == sid]
        ok = n = 0
        for q in tagged:
            p = predict(sslug, text(q)); n += 1
            if p and chap.get((p, sid)) == q['chapter_id']: ok += 1
        acc = ok / n if n else 0.0
        drafts = R.fetch_all('questions', {'select': 'id,stem,options', 'status': 'eq.published', 'topic_id': f'eq.{inbox[sid]}'})
        moves = []
        for q in drafts:
            p = predict(sslug, text(q))
            if p and (p, sid) in chap: moves.append((q['id'], chap[(p, sid)]))
        report['subjects'][sslug] = {'rule_accuracy_on_tagged': round(acc, 3), 'checked': n, 'to_be_tagged': len(drafts), 'would_move': len(moves)}
        if acc >= a.min_acc: plan += moves
    print(json.dumps(report, ensure_ascii=False))
    if a.apply:
        for i in range(0, len(plan), 200):
            for qid, tid in plan[i:i + 200]:
                R.rest('PATCH', 'questions', {'chapter_id': tid, 'topic_id': tid}, params={'id': f'eq.{qid}'})
        print('moved', len(plan))

if __name__ == '__main__':
    main()
