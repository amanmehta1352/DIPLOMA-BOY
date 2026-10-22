#!/usr/bin/env python3
"""Complete-paper importer (replaces robot.run_job). One job = English sheet + Hindi sheet of the same shift.
   importer.py --job 27 [--job 14 ...] [--dry-run]
Writes every question of the paper (text questions + figure questions as pictures) as DRAFT, upgrades machine Hindi of
questions already in the paper to the official Hindi when the twin is verified, restores rows hidden by an earlier faulty
read when the same question is read cleanly now. Publishing is a separate checked step (publish.py)."""
import os, sys, json, time, argparse, hashlib, traceback, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import robot as R, sscsheet as S, paper as P

BUCKET = 'qimg'

def upload_png(path, data):
    import requests
    u = f'{R.URL}/storage/v1/object/{BUCKET}/{path}'
    r = requests.post(u, headers={'apikey': R.KEY, 'Authorization': 'Bearer ' + R.KEY, 'Content-Type': 'image/png', 'x-upsert': 'true', 'cache-control': '31536000'}, data=data, timeout=120)
    if r.status_code >= 300: raise RuntimeError(f'image upload {r.status_code} {r.text[:200]}')
    return f'{R.URL}/storage/v1/object/public/{BUCKET}/{path}'


def run(job, dry, work, log=print):
    rep = {'job': job['id'], 'dry_run': dry, 'started': time.strftime('%Y-%m-%d %H:%M:%S')}
    os.makedirs(work, exist_ok=True)
    en_pdf = os.path.join(work, 'en.pdf'); sha = R.download(job['url'], en_pdf)
    hi_pdf = None
    if job.get('url_hi'):
        hi_pdf = os.path.join(work, 'hi.pdf'); R.download(job['url_hi'], hi_pdf)
    built = P.build(en_pdf, hi_pdf, os.path.join(work, 'build'), log)
    A = built['A']; qs = built['questions']; rep['build'] = built['report']
    meta = S.meta_of(A['header'])
    if not meta.get('date') and job.get('paper_date'): meta['date'] = str(job['paper_date'])
    if not meta.get('shift') and job.get('shift'): meta['shift'] = int(job['shift'])
    if not meta.get('branch') and job.get('branch_hint'): meta['branch'] = job['branch_hint']
    if not meta.get('year') and meta.get('date'): meta['year'] = int(meta['date'][:4])
    if not meta['date'] or not meta['shift']: raise RuntimeError('तारीख/शिफ्ट नहीं मिली')
    if built['B'] is not None:
        mb = S.meta_of(built['B']['header'])
        if mb.get('date') and (mb['date'] != meta['date'] or mb['shift'] != meta['shift']): raise RuntimeError(f"Hindi PDF दूसरी शिफ्ट का है ({mb['date']} S{mb['shift']})")
    R.check_spaces(A)
    rep['meta'] = meta
    aliases = [x['alias'] for x in R.fetch_all('subject_aliases', {'select': 'alias'})] if not R.OFFLINE else []
    exam_id, branch_id, fam, stage, br = R.resolve_path(job, meta, A['header'], log)
    src_id, existed = R.get_source(exam_id, branch_id, meta, job, job.get('src_url') or job['url'], sha, fam, stage, br, dry, log)
    rep['source_id'] = src_id

    existing = {}; used_qno = set()
    if src_id:
        for r in R.fetch_all('questions', {'select': 'id,status,stem,options,answer,source_qno,topic_id,chapter_id', 'source_id': f'eq.{src_id}'}):
            key = r['stem'].get('key') or S.qkey(r['stem'].get('en', ''), [o.get('en', '') for o in r['options']])
            existing.setdefault(key, r); used_qno.add(r['source_qno'])
    sub_cache = {}
    def topic_for(sec):
        sec = R.canon_section(sec or 'Unknown', aliases)
        if sec not in sub_cache:
            sid = R.rpc('ensure_subject', {'p_section': sec, 'p_branch_id': branch_id, 'p_hi': None})
            sub_cache[sec] = R.rpc('ensure_inbox', {'p_subject_id': sid})
        return sub_cache[sec]
    def free_qno(want):
        n = want
        if n in used_qno: n = next((k for k in range(1, 1000) if k not in used_qno))
        used_qno.add(n); return n

    st = collections.Counter(); inserts = []; patches = []
    for q in qs:
        if q['fig']:
            key = hashlib.sha1(((q['en'] or q['hi'] or '') + '|' + str(q['order']) + '|' + str(meta['date']) + str(meta['shift'])).encode()).hexdigest()[:16]
        else:
            if not q['en'] or not all(q['en_opts']): st['skip_no_english'] += 1; continue
            key = S.qkey(q['en'], q['en_opts'])
        stem = {'en': q['en'], 'hi': q['hi'], 'hi_mt': bool(q.get('hi_mt')), 'key': key}
        if q['fig']: stem['fig'] = True
        for k_, lang in (('img', 'en'), ('img_hi', 'hi')):
            if q[k_]:
                path = f"{src_id or 'dry'}/{q['order']:03d}-{lang}-{hashlib.sha1(q[k_]).hexdigest()[:8]}.png"
                stem[k_] = upload_png(path, q[k_]) if not dry else 'dry://' + path
                st['images'] += 1
        opts = [{'en': q['en_opts'][k] or (str(k + 1) if q['fig'] else None), 'hi': q['hi_opts'][k] or (str(k + 1) if q['fig'] and stem.get('img_hi') else None)} for k in range(4)]
        verified = q['answer'] is not None and q['complete_en'] and q['complete_hi'] and not q['checks'].get('hindi')
        stem['checks'] = {**q['checks'], 'verified': verified}
        ex = existing.get(key)
        if ex:
            if ex['status'] == 'published':
                # never touch the English of a published question; take the official Hindi if ours is verified and theirs is machine/missing
                if q['hi'] and not q.get('hi_mt') and (not ex['stem'].get('hi') or ex['stem'].get('hi_mt')) and not q['checks'].get('hindi') and q['checks'].get('twin') in ('answers agree', 'strong match'):
                    s2 = dict(ex['stem']); s2['hi'] = q['hi']; s2['hi_mt'] = False
                    o2 = [dict(o) for o in ex['options']]
                    if all(q['hi_opts']):
                        # option order of the published row may differ: map by English text
                        pos = {S.norm(o.get('en', '')): k for k, o in enumerate(o2)}
                        for k in range(4):
                            kk = pos.get(S.norm(q['en_opts'][k] or ''))
                            hv = q['hi_opts'][k] or ''
                            if kk is not None and (P.DEVA.search(hv) or hv == (q['en_opts'][k] or '')): o2[kk]['hi'] = hv
                    patches.append((ex['id'], {'stem': s2, 'options': o2})); st['hindi_upgraded'] += 1
                else: st['already_published'] += 1
                continue
            # draft / hidden rows: replace with this clean read
            patches.append((ex['id'], {'stem': stem, 'options': opts, 'answer': q['answer'], 'status': 'draft'}))
            st['restored' if ex['status'] == 'hidden' else 'updated'] += 1
            continue
        if q['answer'] is None: st['skip_no_answer'] += 1; continue
        inserts.append({'kind': 'pyq', 'source_id': src_id, 'source_qno': free_qno(q['order']), 'topic_id': topic_for(q['section']),
                        'stem': stem, 'options': opts, 'answer': q['answer'], 'status': 'draft', 'content_hash': key})
        existing[key] = {'id': None, 'status': 'draft'}
        st['new'] += 1
        st['verified' if verified else 'not_verified'] += 1
    rep['write'] = dict(st)
    rep['sample'] = [{'n': q['order'], 'sec': (q['section'] or '')[:20], 'fig': q['fig'], 'ans': q['answer'], 'en': (q['en'] or '')[:140], 'hi': (q['hi'] or '')[:140],
                      'en_opts': q['en_opts'], 'hi_opts': q['hi_opts'], 'checks': q['checks'], 'match': q['match']} for q in qs[::9]]
    if dry: return rep
    for qid, body in patches: R.rest('PATCH', 'questions', body, params={'id': f'eq.{qid}'})
    for i in range(0, len(inserts), 50): R.rest('POST', 'questions', inserts[i:i + 50], prefer='return=minimal')
    return rep


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--job', type=int, action='append', default=[]); ap.add_argument('--dry-run', action='store_true'); ap.add_argument('--work', default='work')
    ap.add_argument('--jobs-file'); ap.add_argument('--shard', default='0/1')
    a = ap.parse_args()
    if not R.KEY: sys.exit('SUPABASE_SECRET_KEY नहीं मिली')
    bad = 0
    file_jobs = {}
    if a.jobs_file:       # jobs kept in a file (public URLs only): no import_jobs row; the shard picks every n-th job
        allj = json.load(open(a.jobs_file)); k, n = map(int, a.shard.split('/'))
        file_jobs = {x['id']: x for x in allj if (x['id'] - allj[0]['id']) % n == k and (not a.job or x['id'] in a.job)}
        a.job = sorted(file_jobs)
    for j in a.job:
        job = file_jobs[j] if j in file_jobs else R.rest('GET', 'import_jobs', params={'id': f'eq.{j}'})[0]
        print(f'--- job {j}: {job["url"][:90]}', flush=True)
        try:
            if not a.dry_run and j not in file_jobs: R.rest('PATCH', 'import_jobs', {'status': 'running'}, params={'id': f'eq.{j}'})
            rep = run(job, a.dry_run, os.path.join(a.work, str(j)))
            print(json.dumps(rep, ensure_ascii=False), flush=True)
            open(os.path.join(a.work, f'report_{j}.json'), 'w').write(json.dumps(rep, ensure_ascii=False, indent=1))
            if not a.dry_run and j not in file_jobs: R.rest('PATCH', 'import_jobs', {'status': 'review', 'report': rep, 'source_id': rep.get('source_id')}, params={'id': f'eq.{j}'})
        except Exception as e:
            bad += 1; traceback.print_exc()
            if not a.dry_run and j not in file_jobs: R.rest('PATCH', 'import_jobs', {'status': 'failed', 'report': {'error': str(e)[:500]}}, params={'id': f'eq.{j}'})
    sys.exit(1 if bad else 0)

if __name__ == '__main__': main()
