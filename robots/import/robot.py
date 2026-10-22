#!/usr/bin/env python3
"""Import robot: one job = one paper (an English sheet link + optional Hindi sheet link).
   robot.py --job 12 [--dry-run] [--no-hindi]      robot.py --queued [--limit 3]
Everything lands as DRAFT. Nothing is published here. Needs env SUPABASE_SECRET_KEY (GitHub secret)."""
import os, sys, shutil, re, json, time, argparse, hashlib, traceback, collections, tempfile, urllib.request, urllib.parse
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import sscsheet as S, hindi as H

URL = os.environ.get('SUPABASE_URL', 'https://wobmtlcpszcntczkebtt.supabase.co')
KEY = os.environ.get('SUPABASE_SECRET_KEY', '')
UA = 'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Mobile Safari/537.36'


# ---------------- REST (schema mtb) ----------------
OFFLINE = False
OCR_EN = os.environ.get('OCR_EN') == '1'

def rest(method, path, body=None, prefer=None, params=None):
    if OFFLINE: return [] if method == 'GET' else ([{'id': 0}] if prefer and 'representation' in prefer else None)
    import requests
    h = {'apikey': KEY, 'Authorization': 'Bearer ' + KEY, 'Accept-Profile': 'mtb', 'Content-Profile': 'mtb', 'Content-Type': 'application/json'}
    if prefer: h['Prefer'] = prefer
    r = requests.request(method, URL + '/rest/v1/' + path, headers=h, params=params, data=json.dumps(body) if body is not None else None, timeout=120)
    if r.status_code == 401: raise SystemExit('❌ SUPABASE_SECRET_KEY गलत है: GitHub में रखी key इस प्रोजेक्ट (wobmtlcpszcntczkebtt) की नहीं है, या कॉपी में space/नई लाइन आ गई। Supabase → Project Settings → API Keys → Secret key (sb_secret_…) दोबारा डालें।')
    if r.status_code >= 300: raise RuntimeError(f'{method} {path} -> {r.status_code} {r.text[:300]}')
    return r.json() if r.text else None

def rpc(fn, args): return 0 if OFFLINE else rest('POST', 'rpc/' + fn, args)

def fetch_all(path, params, page=1000):
    out = []; off = 0
    while True:
        p = dict(params); p['limit'] = page; p['offset'] = off
        rows = rest('GET', path, params=p); out += rows
        if len(rows) < page: return out
        off += page


# ---------------- download ----------------
def drive_id(u):
    m = re.search(r'drive\.google\.com/file/d/([\w-]+)', u) or re.search(r'[?&]id=([\w-]+)', u)
    return m.group(1) if m else None

def download(u, dest):
    import requests
    if u.startswith('file:'):      # PDF staged on the temporary ntpc-sources branch (the host blocks GitHub runners)
        data = open(os.path.join(os.environ.get('SRC_DIR', '.'), u[5:]), 'rb').read()
        open(dest, 'wb').write(data); return hashlib.sha256(data).hexdigest()
    if u.startswith('repo:'):      # a PDF the user sent by chat, kept in robots/import/inputs/
        data = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'inputs', u[5:]), 'rb').read()
        open(dest, 'wb').write(data); return hashlib.sha256(data).hexdigest()
    if 'drive.google.com' in u:
        i = drive_id(u)
        if not i: raise RuntimeError('Drive link समझ नहीं आया')
        u = f'https://drive.google.com/uc?export=download&id={i}&confirm=t'
    r = requests.get(u, headers={'User-Agent': UA, 'Accept': 'application/pdf,*/*', 'Referer': 'https://www.google.com/'}, timeout=180, allow_redirects=True)
    if r.status_code == 403: raise RuntimeError('साइट ने robot को रोका (403) — PDF upload करें')
    if r.status_code >= 300: raise RuntimeError(f'download {r.status_code}')
    if not r.content[:5] == b'%PDF-': raise RuntimeError('यह PDF नहीं है (लिंक सीधा PDF नहीं)')
    open(dest, 'wb').write(r.content)
    return hashlib.sha256(r.content).hexdigest()


# ---------------- sheets printed without spaces between words: not safe to guess, refuse ----------------
def check_spaces(sheet):
    qs = [q for q in sheet['questions'] if q['lang'] == 'en' and len(q['text']) > 40]
    bad = sum(1 for q in qs if S.looks_nospace(q))
    if qs and bad / len(qs) > 0.3:
        raise RuntimeError(f'इस PDF में शब्दों के बीच खाली जगह ही नहीं है ({bad}/{len(qs)} सवाल) — पढ़ना सुरक्षित नहीं। इसी पेपर की दूसरी PDF / दूसरा लिंक दें')

def canon_section(name, aliases):
    key = re.sub(r'[^a-z0-9]', '', (name or '').lower())
    for a in aliases:
        if re.sub(r'[^a-z0-9]', '', a) == key: return a.title() if ' ' in a else name
    return name


# ---------------- path ----------------
FAMILY_GUESS = [(r'ntpc', ('RRB NTPC', 'आरआरबी एनटीपीसी')), (r'junior engineer|ssc je|\bje\b', ('SSC JE', 'एसएससी जेई'))]

def resolve_path(job, meta, header, log):
    fam = (job.get('exam_hint') or '').strip()
    if not fam:
        subj = header.get('subject') or ''
        for pat, (en, hi) in FAMILY_GUESS:
            if re.search(pat, subj, re.I): fam, fam_hi = en, hi; break
        else: raise RuntimeError(f"परीक्षा पहचानी नहीं गई ({subj!r}) — job में exam_hint डालें")
    else: fam_hi = None
    stage = (job.get('stage_hint') or meta.get('paper') or 'Paper-I').strip()
    stage_hi = {'Paper-I': 'पेपर-I', 'Paper-II': 'पेपर-II'}.get(stage) or (stage.replace('Graduate', 'ग्रेजुएट').replace('UG', 'अंडर-ग्रेजुएट') if 'CBT' in stage else None)
    exam_id = rpc('ensure_exam', {'p_family_en': fam, 'p_family_hi': fam_hi, 'p_stage_en': stage, 'p_stage_hi': stage_hi, 'p_stage_sort': 2 if (stage.endswith('II') or stage.endswith('CBT-2')) else 1})
    br = (job.get('branch_hint') or meta.get('branch') or '').strip()
    branch_id = rpc('ensure_branch', {'p_en': br, 'p_hi': None}) if br else None
    log(f'path: exam {fam} / {stage} (id {exam_id}), branch {br or "-"} (id {branch_id})')
    return exam_id, branch_id, fam, stage, br


def get_source(exam_id, branch_id, meta, job, en_url, sha, fam, stage, br, dry, log):
    date = meta['date']; shift = meta['shift']      # the PDF's own header is the truth; the job's date/shift is only a label
    params = {'select': 'id,note', 'exam_id': f'eq.{exam_id}', 'paper_date': f'eq.{date}', 'shift': f'eq.{shift}'}
    if branch_id: params['branch_id'] = f'eq.{branch_id}'
    rows = rest('GET', 'sources', params=params)
    if rows: return rows[0]['id'], True
    if dry: return None, False
    third = fam == 'RRB NTPC'      # NTPC sheets come from re-hosted copies, not from a source we can call official
    host = re.sub(r'^https?://(www\.)?', '', en_url).split('/')[0]
    note = (f"{fam} {meta['year']} {br} {stage} · {date} Shift {shift} · candidate response sheet re-hosted by {host} (NOT checked against an official RRB record) · answer = tick in that sheet"
            if third else f"{fam} {meta['year']} {br} {stage} · {date} Shift {shift} · official response sheet (PDF) · answer = official key")
    extra = {'verification': 'UNVERIFIED_COPY', 'host': host,
             'reuse_note': 'Re-hosted copy; host terms not cleared for republishing. Keep draft until the owner decides.'} if third else {}
    row = rest('POST', 'sources', {'exam_id': exam_id, 'exam_year': meta['year'], 'shift': shift, 'paper_date': date, 'kind': 'third_party_copy' if third else 'official_response_sheet',
                                   'url': en_url, 'file_sha256': sha, 'branch_id': branch_id, 'note': note, **extra}, prefer='return=representation')
    return row[0]['id'], False


# ---------------- main per job ----------------
def run_job(job, dry, use_hindi, work, log=print, upgrade_hi=False):
    rep = {'job': job['id'], 'dry_run': dry, 'started': time.strftime('%Y-%m-%d %H:%M:%S')}
    rep_ocr = None
    os.makedirs(work, exist_ok=True)
    en_pdf = os.path.join(work, f"j{job['id']}_en.pdf")
    sha = download(job['url'], en_pdf)
    en = S.read_sheet(en_pdf)
    if OCR_EN:
        # the PDF's text layer can lose letters: re-read every question from the picture (English OCR, tick icons painted out)
        idx = [i for i, q in enumerate(en['questions']) if q['lang'] == 'en']
        ocr = H.ocr_sheet(en_pdf, en, idx, os.path.join(work, 'ocr_en'), lang='eng')
        fixed = 0
        for i, o in ocr.items():
            if o and o['text'] and all(o['opts']):
                q = en['questions'][i]
                q['text_layer'] = q['text']
                q['text'] = S.fix(o['text']); q['opts'] = {str(k + 1): S.fix(o['opts'][k]) for k in range(4)}; fixed += 1
        rep_ocr = {'ocr_en_questions': len(idx), 'ocr_en_used': fixed,
                   'sample': [(en['questions'][i]['qno'], en['questions'][i].get('text_layer', '')[:90], en['questions'][i]['text'][:90]) for i in idx[:4]]}
    meta = S.meta_of(en['header']); rep['header'] = en['header']
    # the sheet's own header is read first; the job's date/shift/branch label fills any field the header did not give
    if not meta.get('date') and job.get('paper_date'): meta['date'] = str(job['paper_date'])
    if not meta.get('shift') and job.get('shift'): meta['shift'] = int(job['shift'])
    if not meta.get('branch') and job.get('branch_hint'): meta['branch'] = job['branch_hint']
    if not meta.get('year') and meta.get('date'): meta['year'] = int(meta['date'][:4])
    rep['meta'] = meta
    if rep_ocr: rep['ocr_en'] = rep_ocr
    check_spaces(en)
    try: aliases = [x['alias'] for x in fetch_all('subject_aliases', {'select': 'alias'})]
    except Exception: aliases = []
    for q in en['questions']: q['section'] = canon_section(q['section'], aliases)
    if not meta['date'] or not meta['shift']: raise RuntimeError('PDF के header से तारीख/शिफ्ट नहीं मिली')
    hi = None
    if use_hindi and job.get('url_hi'):
        try:
            hi_pdf = os.path.join(work, f"j{job['id']}_hi.pdf"); download(job['url_hi'], hi_pdf); hi = S.read_sheet(hi_pdf)
            if S.meta_of(hi['header'])['date'] != meta['date'] or S.meta_of(hi['header'])['shift'] != meta['shift']:
                rep['hindi_sheet'] = 'तारीख/शिफ्ट मेल नहीं खाई — Hindi छोड़ी'; hi = None
        except Exception as e:
            rep['hindi_sheet'] = f'Hindi sheet नहीं पढ़ी: {e}'; hi = None

    if (job.get('paper_date') and str(job['paper_date']) != meta['date']) or (job.get('shift') and int(job['shift']) != meta['shift']):
        rep['label_mismatch'] = f"job: {job.get('paper_date')} शिफ्ट {job.get('shift')}  ·  PDF header: {meta['date']} शिफ्ट {meta['shift']} (PDF वाली मानी गई)"
    exam_id, branch_id, fam, stage, br = resolve_path(job, meta, en['header'], log)
    src_id, existed = get_source(exam_id, branch_id, meta, job, job['url'], sha, fam, stage, br, dry, log)
    rep['source_id'] = src_id; rep['source_existed'] = existed

    if hi:
        for q in hi['questions']: q['section'] = canon_section(q['section'], aliases)
    # English pool = this sheet's English entries + the Hindi sheet's English entries
    pool = []
    for sheet, tag in ((en, 'en-sheet'), (hi, 'hi-sheet')):
        if not sheet: continue
        for idx, q in enumerate(sheet['questions']):
            if q['lang'] == 'en': pool.append((tag, idx, q))
    hold = collections.Counter(); rows = []; seen = {}; dup = 0; conflicts = []
    existing = {}; ex_rows = []
    if src_id:
        for r in fetch_all('questions', {'select': 'id,status,stem,options,answer,source_qno', 'source_id': f'eq.{src_id}'}):
            en_opts = [o.get('en', '') for o in r['options']]
            existing[S.qkey(r['stem'].get('en', ''), en_opts)] = (r, S.norm(en_opts[r['answer']]))
            ex_rows.append(r)
    rep['existing_in_source'] = len(existing)
    for tag, idx, q in pool:
        why = S.hold_reason(q)
        if why: hold[why] += 1; continue
        opts = [q['opts'][str(i)] for i in range(1, 5)]
        key = S.qkey(q['text'], opts); right = S.norm(opts[q['answer_pos']])
        if key in seen:
            if seen[key] != right: conflicts.append({'key': key, 'qno': q['qno'], 'why': 'दो sheet में सही उत्तर अलग'})
            dup += 1; continue
        seen[key] = right
        if key in existing:
            if existing[key][1] != right: conflicts.append({'key': key, 'qno': q['qno'], 'why': 'DB में उत्तर अलग', 'db_id': existing[key][0]['id']})
            dup += 1; continue
        rows.append({'key': key, 'sheet': tag, 'idx': idx, 'q': q, 'opts': opts})
    rep['held'] = dict(hold); rep['dup_skipped'] = dup; rep['conflicts'] = conflicts
    rep['new_english'] = len(rows)
    hi_only = [q for q in (hi['questions'] if hi else []) if q['lang'] == 'hi' and not S.hold_reason(q)]
    rep['hindi_only_entries'] = (sum(1 for q in en["questions"] if q["lang"] == "hi" and not S.hold_reason(q)), len(hi_only))

    # Hindi: OCR the Hindi-shown questions of the Hindi sheet, pair them with English ones
    hi_stats = {'ocr': 0, 'paired': 0, 'stem_only': 0, 'unpaired': 0}
    upgrades = []
    if hi and use_hindi:
        if not H.have_hindi_ocr(): hi_stats['note'] = 'tesseract hin नहीं मिला — Hindi छोड़ी (अंग्रेज़ी import होगी)'
        else:
            want = [i for i, q in enumerate(hi['questions']) if q['lang'] == 'hi' and not S.hold_reason(q)]
            wd = os.path.join(work, f"ocr{job['id']}"); os.makedirs(wd, exist_ok=True)
            ocr = H.ocr_sheet(hi_pdf, hi, want, wd, log=log)
            wm = [w for w in hi.get('watermark_words', []) if not w.startswith('http')]
            def scrub(t):
                t = S.URL_INLINE.sub('', t)
                for w in wm: t = re.sub(r'\b' + re.escape(w) + r'\b', '', t, flags=re.I)
                return re.sub(r'\s+', ' ', t).strip()
            for o in ocr.values():
                o['text'] = scrub(o['text']); o['opts'] = [scrub(x) for x in o['opts']]
            for i, o in ocr.items():     # options that are only numbers / letters are taken from the sheet's own text layer (OCR garbles them)
                tl = hi['questions'][i]['opts']
                for k in range(4):
                    t = (tl.get(str(k + 1)) or '').strip()
                    if t and not H.DEVA.search(t) and '(cid:' not in t: o['opts'][k] = t
            good = {i: o for i, o in ocr.items() if H.ocr_ok(o)}
            hi_stats['ocr'] = len(good); hi_stats['ocr_bad'] = len(ocr) - len(good)
            json.dump({str(i): o for i, o in ocr.items()}, open(os.path.join(work, f"j{job['id']}_ocr.json"), 'w'), ensure_ascii=False, indent=1)
            hitems = [{'text': hi['questions'][i]['text'], 'opts': [hi['questions'][i]['opts'].get(str(k), '') for k in range(1, 5)], 'ans': hi['questions'][i]['answer_pos'], 'i': i} for i in good]
            eitems = [{'text': r['q']['text'], 'opts': r['opts'], 'ans': r['q']['answer_pos'], 'row': r} for r in rows]
            n_new = len(eitems)
            for r in ex_rows:   # questions already in this paper can take the official Hindi too
                eitems.append({'text': r['stem'].get('en', ''), 'opts': [o.get('en', '') for o in r['options']], 'ans': r['answer'], 'db': r})
            pr = H.pair(hitems, eitems)
            for hk, (ek, omap) in pr.items():
                o = good[hitems[hk]['i']]; tgt = eitems[ek]
                if not H.stem_valid(o['text'], tgt['text']): hi_stats['rejected_ocr'] = hi_stats.get('rejected_ocr', 0) + 1; continue
                hi_opts = [None] * 4
                if omap:
                    for hi_i, en_i in enumerate(omap): hi_opts[en_i] = o['opts'][hi_i]
                    hi_stats['paired'] += 1
                else: hi_stats['stem_only'] += 1
                if 'row' in tgt: tgt['row']['hi'] = {'text': o['text'], 'opts': hi_opts}
                else: upgrades.append((tgt['db'], {'text': o['text'], 'opts': hi_opts}))
            hi_stats['unpaired'] = len(good) - len(pr)
            hi_stats['attached'] = hi_stats['paired'] + hi_stats['stem_only']
            hi_stats['upgrade_existing'] = len(upgrades)
    rep['hindi'] = hi_stats

    if upgrades and upgrade_hi and not dry:
        for r, h in upgrades:   # only where the stored Hindi is a machine translation or missing; never overwrite official Hindi
            if r['stem'].get('hi') and not r['stem'].get('hi_mt'): continue
            stem = dict(r['stem']); stem['hi'] = h['text']; stem['hi_mt'] = False
            opts = [dict(o) for o in r['options']]
            for i in range(4):
                if h['opts'][i]: opts[i]['hi'] = h['opts'][i]
            rest('PATCH', 'questions', {'stem': stem, 'options': opts}, params={'id': f"eq.{r['id']}"})
    # insert as draft
    by_sec = collections.Counter(r['q']['section'] for r in rows)
    rep['by_section'] = dict(by_sec)
    if dry:
        rep['inserted'] = 0; rep['status'] = 'dry-run'; return rep
    sub_cache = {}
    out = []
    used = {x['source_qno'] for x in ex_rows if x.get('source_qno')}   # (source, qno) is unique; another candidate's numbering can clash
    def free_qno(want):
        n = want
        if n in used:
            n = next((k for k in range(1, 201) if k not in used), max(used | {200}) + 1)
        used.add(n); return n
    for r in rows:
        sec = r['q']['section'] or 'Unknown'
        if sec not in sub_cache:
            sid = rpc('ensure_subject', {'p_section': sec, 'p_branch_id': branch_id, 'p_hi': None})
            sub_cache[sec] = (sid, rpc('ensure_inbox', {'p_subject_id': sid}))
        topic_id = sub_cache[sec][1]
        h = r.get('hi')
        stem = {'en': r['q']['text'], 'hi': h['text'] if h else None, 'hi_mt': False}
        options = [{'en': r['opts'][i], 'hi': (h['opts'][i] if h and h['opts'][i] else None)} for i in range(4)]
        out.append({'kind': 'pyq', 'source_id': src_id, 'source_qno': free_qno(r['q']['qno']), 'topic_id': topic_id, 'stem': stem, 'options': options,
                    'answer': r['q']['answer_pos'], 'status': 'draft', 'content_hash': r['key']})
    for i in range(0, len(out), 50): rest('POST', 'questions', out[i:i + 50], prefer='return=minimal')
    rep['inserted'] = len(out); rep['subjects'] = {k: v[0] for k, v in sub_cache.items()}
    rep['status'] = 'review'
    return rep


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--job', type=int, action='append'); ap.add_argument('--queued', action='store_true'); ap.add_argument('--limit', type=int, default=3)
    ap.add_argument('--dry-run', action='store_true'); ap.add_argument('--no-hindi', action='store_true'); ap.add_argument('--upgrade-hindi', action='store_true'); ap.add_argument('--ocr-en', action='store_true'); ap.add_argument('--work', default='work')
    ap.add_argument('--offline', action='store_true', help='no database: only read the PDFs and show what would happen'); ap.add_argument('--url'); ap.add_argument('--url-hi')
    a = ap.parse_args()
    global OFFLINE, OCR_EN
    OCR_EN = OCR_EN or a.ocr_en
    if a.offline:
        OFFLINE = True; a.dry_run = True
        jobs = [{'id': 0, 'url': a.url, 'url_hi': a.url_hi, 'status': 'queued', 'exam_hint': 'SSC JE', 'stage_hint': None, 'branch_hint': None, 'paper_date': None, 'shift': None}]
        a.job = None
    elif not KEY: sys.exit('SUPABASE_SECRET_KEY नहीं मिली')
    if a.offline: pass
    elif a.job: jobs = [rest('GET', 'import_jobs', params={'id': f'eq.{j}'})[0] for j in a.job]
    else: jobs = rest('GET', 'import_jobs', params={'status': 'eq.queued', 'order': 'id', 'limit': a.limit})
    print(f'{len(jobs)} job')
    bad = 0
    for job in jobs:
        print(f"--- job {job['id']}: {job['url'][:80]}")
        if not a.dry_run: rest('PATCH', 'import_jobs', {'status': 'running', 'updated_at': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())}, params={'id': f"eq.{job['id']}"})
        try:
            rep = run_job(job, a.dry_run, not a.no_hindi, os.path.join(a.work, str(job['id'])), log=print, upgrade_hi=a.upgrade_hindi)
            st = 'review' if not a.dry_run else job['status']
            print(json.dumps(rep, ensure_ascii=False, indent=1)[:3000])
            open(os.path.join(a.work, f"report_{job['id']}.json"), 'w').write(json.dumps(rep, ensure_ascii=False, indent=1))
            if not a.dry_run: rest('PATCH', 'import_jobs', {'status': 'review', 'report': rep, 'source_id': rep.get('source_id'), 'updated_at': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())}, params={'id': f"eq.{job['id']}"})
        except Exception as e:
            bad += 1; traceback.print_exc()
            if not a.dry_run: rest('PATCH', 'import_jobs', {'status': 'failed', 'report': {'error': str(e)[:500]}, 'updated_at': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())}, params={'id': f"eq.{job['id']}"})
    sys.exit(1 if bad else 0)

if __name__ == '__main__': main()
