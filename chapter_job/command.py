"""Owner command entry point.
   python3 command.py "Class 10, CBSE 2026-27, Science, Electricity"   -> one chapter
   python3 command.py "Class 10, CBSE 2026-27, Science"                -> whole subject: syllabus robot first, then every verified,
                                                                          app-mapped chapter, one after another; stops at the first
                                                                          blocked chapter (quota) so a rerun continues from there.
Never writes the database; every chapter stops at review_ready / needs_review for the owner."""
import json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import job as J, chapter_robot as C, syllabus_robot as S, providers, websearch

def main(cmd, retry):
    req = J.parse_command(cmd); P = providers.Real(); out = []
    if not req['chapter']:
        cat = None
        if os.environ.get('CATALOG_FILE') and os.path.exists(os.environ['CATALOG_FILE']):
            cat = [ch for subj in json.load(open(os.environ['CATALOG_FILE'])) for ch in subj.get('chapters', [])]
        path = os.environ.get('SYLLABUS_OUT', os.path.join(J.JOBS, 'syllabus.json')); os.makedirs(os.path.dirname(path), exist_ok=True)
        rep = S.run(cmd, P, websearch.fetch, cat, path); out.append({'syllabus': rep})
        J.SYLLABUS = path
        syl = json.load(open(path, encoding='utf-8'))
        subj = [s for s in syl['subjects'] if s['slug'] == rep.get('subject')]
        chapters = [c for c in (subj[0]['chapters'] if subj else []) if c.get('scope_verified') and c.get('app')]
        for c in chapters:
            r = C.run(f"Class {syl['class']}, {syl['board']} {syl['session']}, {req['subject']}, {c['no']}", P, retry=retry,
                      reference_dir=os.environ.get('COPYRIGHT_FINGERPRINTS'))
            out.append({'chapter': c['name_en'], **r})
            if r['final_state'] == 'blocked': break
    else:
        out.append(C.run(cmd, P, retry=retry, reference_dir=os.environ.get('COPYRIGHT_FINGERPRINTS')))
    print(json.dumps(out, ensure_ascii=False, indent=1))

if __name__ == '__main__':
    main([a for a in sys.argv[1:] if not a.startswith('--')][0], '--retry' in sys.argv)
