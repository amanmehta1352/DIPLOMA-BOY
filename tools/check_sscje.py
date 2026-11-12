#!/usr/bin/env python3
"""Checks every content/sscje-mechanical/ch-*.json before it goes anywhere near the database.
   python3 tools/check_sscje.py [file ...]
Rules: same spirit as robots/writer/writer.py check_structure, but for the deeper A-to-Z chapters."""
import json, re, sys, glob, pathlib
import xml.etree.ElementTree as ET

root = pathlib.Path(__file__).resolve().parent.parent
files = sys.argv[1:] or sorted(glob.glob(str(root / 'content/sscje-mechanical/ch-*.json')))
BAD = re.compile(r'<(?!svg)[a-zA-Z/]|\\\(|\\\[|\\frac|\$\$')


def strings(o):
    if isinstance(o, str): yield o
    elif isinstance(o, dict):
        for k, v in o.items():
            if k == 'fig': continue
            yield from strings(v)
    elif isinstance(o, list):
        for v in o: yield from strings(v)


def check(path):
    p = []
    try: d = json.load(open(path, encoding='utf-8'))
    except Exception as e: return [f'JSON error: {e}']
    cid = re.search(r'ch-(\d+|new-[a-z-]+)', path)
    for key, lo in (('book', 8), ('notes', 10), ('teach', 6), ('formulas', 12), ('solved', 6), ('practice', 20), ('mistakes', 5), ('revision', 10)):
        v = d.get(key)
        if not isinstance(v, list) or len(v) < lo: p.append(f'{key}: {0 if not isinstance(v, list) else len(v)} (want >= {lo})')
    for i, x in enumerate(d.get('book', [])):
        if not x.get('title') or not isinstance(x.get('paras'), list) or not x['paras']: p.append(f'book[{i}] needs title+paras')
    for i, x in enumerate(d.get('notes', [])):
        if not x.get('title') or not isinstance(x.get('points'), list) or len(x['points']) < 3: p.append(f'notes[{i}] needs title + >=3 points')
        if x.get('table'):
            w = {len(r) for r in x['table']}
            if len(w) != 1: p.append(f'notes[{i}] table rows differ in width {w}')
    for i, x in enumerate(d.get('teach', [])):
        if not x.get('heading') or not x.get('explain'): p.append(f'teach[{i}] needs heading+explain')
    for i, x in enumerate(d.get('formulas', [])):
        if not x.get('title') or not x.get('formula'): p.append(f'formulas[{i}] needs title+formula')
    for i, x in enumerate(d.get('solved', [])):
        if not x.get('question') or not isinstance(x.get('steps'), list) or len(x['steps']) < 2 or not x.get('answer'): p.append(f'solved[{i}] needs question, >=2 steps, answer')
        else:
            nums = re.findall(r'\d+(?:\.\d+)?', x['answer'].replace(',', ''))
            last = ' '.join(x['steps'][-2:]).replace(',', '')
            if nums and not all(n in last for n in nums): p.append(f'solved[{i}] last steps do not show the answer {x["answer"]}')
    for i, x in enumerate(d.get('practice', [])):
        o = x.get('options')
        ok = x.get('q') and isinstance(o, list) and len(o) == 4 and all(isinstance(s, str) and s.strip() for s in o) and isinstance(x.get('answer'), int) and 0 <= x['answer'] <= 3
        if not ok: p.append(f'practice[{i}] needs q, 4 options, answer 0-3'); continue
        if len({s.strip() for s in o}) < 4: p.append(f'practice[{i}] duplicate options')
        exp = str(x.get('explanation') or '').replace(',', '')
        if not exp.strip(): p.append(f'practice[{i}] explanation missing'); continue
        nums = re.findall(r'\d+(?:\.\d+)?', o[x['answer']].replace(',', ''))
        if nums and not all(n in exp for n in nums): p.append(f'practice[{i}] explanation does not reach the right option ({o[x["answer"]]})')
        elif nums and '=' in exp:   # stricter: the figure after the LAST '=' must be the right option, and no other option's number may be there
            tail = exp.rsplit('=', 1)[1]
            if not all(n in tail for n in nums): p.append(f'practice[{i}] last result in explanation is not the marked option ({o[x["answer"]]}): ...{tail[:40]}')
        if '*' in exp or '*' in x['q']: p.append(f'practice[{i}] use × not *')
    for s in strings(d):
        if BAD.search(s): p.append(f'HTML/LaTeX in text: {s[:60]}'); break
    for sec in ('book', 'notes', 'teach'):
        for i, x in enumerate(d.get(sec, [])):
            f = x.get('fig')
            if f:
                try: ET.fromstring(f)
                except Exception as e: p.append(f'{sec}[{i}] fig is not valid SVG: {e}')
                if re.search(r'<script|onload|onclick|href=', f, re.I): p.append(f'{sec}[{i}] fig has script/link')
    total = sum(len(s) for s in strings(d))
    if total < 18000: p.append(f'too short: {total} characters (want >= 18000)')
    p.append(f'INFO {total} chars, notes {len(d.get("notes", []))}, formulas {len(d.get("formulas", []))}, solved {len(d.get("solved", []))}, practice {len(d.get("practice", []))}, figs {sum(1 for s in ("book","notes","teach") for x in d.get(s, []) if x.get("fig"))}')
    return p


bad = 0
for f in files:
    r = check(f); errs = [x for x in r if not x.startswith('INFO')]
    print(('FAIL ' if errs else 'ok   ') + pathlib.Path(f).name); [print('   ', x) for x in r]
    bad += bool(errs)
sys.exit(1 if bad else 0)
