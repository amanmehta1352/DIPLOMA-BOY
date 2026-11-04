import re
"""Renders robot content (structured JSON, Hindi+English pairs) into the owner's book HTML (mtb.chapter_books, kind chN).
Exact class vocabulary of Base_line_physics: sheet-header, panel <colour>, panel-header, panel-body, kv-list/kv-item, table,
formula-box, tip-box, diagram-container + diagram-caption, solution-box (solution-header, sol-given, sol-step, sol-answer),
teach-title, teach-sec, teach-sec-h, teach-text, teach-formula, teach-ex, teach-en-follow (bilingual).
AI never writes HTML: text is escaped; **bold** -> <strong>, x^2 -> <sup>. SVG diagrams are sanitised separately."""
import html, json, os, re, subprocess
import xml.etree.ElementTree as ET

COLOURS = ['blue', 'green', 'purple', 'orange', 'red']
L = {'hi': 0, 'en': 1}


def t(x, lang):
    """x is [hi, en] or a plain string (formulas)."""
    while isinstance(x, list) and len(x) == 1: x = x[0]          # AI sometimes wraps a pair or sends one string
    s = (x[L[lang]] if len(x) > L[lang] else (x[0] if x else '')) if isinstance(x, list) else str(x if x is not None else '')
    if isinstance(s, list): s = ' '.join(map(str, s))
    s = html.escape(str(s or ''))
    s = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', s)
    s = re.sub(r'(?<=[A-Za-z0-9)\]])\^(-?\d+)', r'<sup>\1</sup>', s)
    return s.replace('\n', '<br>')


# ---------------- SVG ----------------
SVG_BAD = re.compile(r'(?i)<\s*(script|foreignobject|iframe|image|use)\b|\son\w+\s*=|javascript:|href\s*=|@import|url\s*\((?!\s*#[\w-]+\s*\))')   # url(#marker) allowed


def safe_svg(svg):
    """Returns cleaned SVG text or None. Must parse as XML, have a viewBox, no scripts/links/images, under 12 kB."""
    if not isinstance(svg, str): return None
    s = svg.strip()
    if not s.startswith('<svg') or len(s) > 12000 or SVG_BAD.search(s): return None
    try:
        root = ET.fromstring(s)
    except ET.ParseError:
        return None
    if not root.tag.endswith('svg') or 'viewBox' not in root.attrib: return None
    if len(list(root.iter())) < 4: return None
    if 'xmlns' not in s[:200]: s = s.replace('<svg', '<svg xmlns="http://www.w3.org/2000/svg"', 1)
    return s


# ---------------- NOTES ----------------
def norm_kv(items):
    """Accepts the shapes free AIs return: [[k_hi,k_en],[v_hi,v_en]] (normal), [k, v] plain strings (symbols/units, same in
    both languages), or one wrapper list holding several [k, v] rows. Returns a list of ([k_hi,k_en], [v_hi,v_en])."""
    out = []
    for x in items or []:
        if not isinstance(x, list): continue
        if len(x) == 2 and all(isinstance(y, str) for y in x):
            out.append(([x[0], x[0]], [x[1], x[1]]))
        elif len(x) == 2 and all(isinstance(y, list) and len(y) == 2 and all(isinstance(z, str) for z in y) for y in x) \
                and not all(len(y[0].strip()) <= 4 for y in x):          # [[k_hi,k_en],[v_hi,v_en]]; two short symbols = two unit rows
            out.append((x[0], x[1]))
        elif all(isinstance(y, list) and len(y) == 2 for y in x):
            out += norm_kv(x)
    return out


def kv_list(items, lang, cls='kv-list'):
    items = norm_kv(items)
    rows = ''.join(f'<div class="kv-item"><span class="kv-key">{t(k, lang)}</span><span class="kv-val">{t(v, lang)}</span></div>' for k, v in items)
    return f'<div class="{cls}">{rows}</div>'


def panel(colour, emoji, title, body):
    return (f'<div class="panel {colour}"><div class="panel-header">{emoji} {title}</div>'
            f'<div class="panel-body">{body}</div></div>')


def concept_panel(c, lang, i):
    b = ''.join(f'<p>{t(p, lang)}</p>' for p in c.get('paras') or [])
    if c.get('formula'):
        f = c['formula']; b += f'<div class="formula-box">{html.escape(f.get("expr", ""))}</div>'
        if f.get('units'): b += kv_list(f['units'], lang)
    if c.get('kv'): b += kv_list(c['kv'], lang)
    tb = c.get('table')
    if tb and tb.get('head') and tb.get('rows'):
        b += '<table><tbody><tr>' + ''.join(f'<th>{t(h, lang)}</th>' for h in tb['head']) + '</tr>' + \
             ''.join('<tr>' + ''.join(f'<td>{t(x, lang)}</td>' for x in row) + '</tr>' for row in tb['rows']) + '</tbody></table>'
    d = c.get('diagram') or {}
    svg = safe_svg(d.get('svg'))
    if svg:
        b += f'<div class="diagram-container">{svg}<div class="diagram-caption">{t(d.get("caption") or ["", ""], lang)}</div></div>'
    if c.get('tip'):
        lab = 'महत्वपूर्ण' if lang == 'hi' else 'Important'
        b += f'<div class="tip-box"><span>⚠</span><div><strong>{lab}:</strong> {t(c["tip"], lang)}</div></div>'
    return panel(COLOURS[i % len(COLOURS)], c.get('emoji', '📘'), t(c['title'], lang), b)


def solved_panel(k, n, lang):
    h = (f'हल किया गया संख्यात्मक {k}' if lang == 'hi' else f'Solved Numerical {k}') + f': {t(n["title"], lang)}'
    steps = ''.join(f'<div class="sol-step">{t(s, lang)}</div>' for s in n['steps'])
    body = (f'<div class="solution-box"><div class="solution-header">{"प्रश्न" if lang == "hi" else "Problem"} {k}</div><div class="solution-body">'
            f'<div class="sol-given">{t(n["given"], lang)}</div>{steps}<div class="sol-answer">{t(n["answer"], lang)}</div></div></div>')
    return panel(COLOURS[(k + 1) % len(COLOURS)], '✏️', h, body)


def notes_html(ch, lang):
    title, sub = t(ch['titles'], lang), html.escape(ch['titles'][1].split('. ', 1)[-1].upper())
    out = [f'<div class="sheet-header"><div class="sheet-title">{title}</div><div class="sheet-subtitle">{sub}</div></div>']
    intro = ch['intro']
    out.append(panel('blue', '📖', 'परिचय' if lang == 'hi' else 'Introduction',
                     ''.join(f'<p>{t(p, lang)}</p>' for p in intro['paras']) + (kv_list(intro['kv'], lang) if intro.get('kv') else '')))
    for i, c in enumerate(ch['concepts']): out.append(concept_panel(c, lang, i + 1))
    for k, n in enumerate(ch['numericals'], 1): out.append(solved_panel(k, n, lang))
    out.append(panel('red', '⚡', 'त्वरित पुनरावृत्ति' if lang == 'hi' else 'Quick Revision', kv_list(ch['revision'], lang)).replace(
        '<div class="panel-body"><div class="kv-list">', '<div class="panel-body kv-list"><div class="kv-list">'))
    qa = ''.join((f'<p style="margin-top:8px;">' if i else '<p>') + f'<strong>Q{i + 1}.</strong> {t(q["q"], lang)}</p>'
                 f'<p style="color:var(--secondary); font-weight:bold;">{"उत्तर" if lang == "hi" else "Answer"}: {t(q["a"], lang)}</p>'
                 for i, q in enumerate(ch['practice']))
    out.append(panel('red', '🎯', 'अभ्यास प्रश्न' if lang == 'hi' else 'Practice Questions', qa))
    return '\n'.join(out)


# ---------------- TEACH ----------------
def teach_sec(s, lang, follow=False):
    body = ''.join(f'<p>{t(p, lang)}</p>' for p in s.get('paras') or [])
    if s.get('formula'): body += f'<div class="teach-formula">{html.escape(s["formula"])}</div>'
    ex = s.get('example')
    if ex and ex.get('text'):
        body += f'<div class="teach-ex"><strong>{t(ex.get("label") or ["समझो ऐसे", "Think of it like this"], lang)}:</strong> {t(ex["text"], lang)}</div>'
    return (f'<div class="teach-sec{" teach-en-follow" if follow else ""}"><div class="teach-sec-h">{s.get("emoji", "📘")} {t(s["heading"], lang)}</div>'
            f'<div class="teach-text">{body}</div></div>')


def teach_sections(ch):
    """Opener + concept lessons + worked examples + summary + quick check + formula sheet (last three built from the chapter)."""
    secs = list(ch['teach'])
    secs.append({'emoji': '✅', 'heading': ['हल किए गए उदाहरण', 'Solved Examples'],
                 'paras': [[f'**{n["title"][0]}:** {n["given"][0]} → {n["answer"][0]}', f'**{n["title"][1]}:** {n["given"][1]} → {n["answer"][1]}'] for n in ch['numericals'][:3]]})
    secs.append({'emoji': '🧠', 'heading': ['सारांश (Quick Revision)', 'Summary (Quick Revision)'],
                 'paras': [[f'**{k[0]}:** {v[0]}', f'**{k[1]}:** {v[1]}'] for k, v in norm_kv(ch['revision'])]})
    secs.append({'emoji': '🎓', 'heading': ['त्वरित जाँच (Quick Check)', 'Quick Check'],
                 'paras': [[f'**{q["q"][0]}** — {q["a"][0]}', f'**{q["q"][1]}** — {q["a"][1]}'] for q in ch['practice'][:5]]})
    secs.append({'emoji': '📐', 'heading': ['सभी सूत्र (Formula Sheet)', 'Formula Sheet'],
                 'paras': [[f'{f["t"][0]}: {f["f"]}', f'{f["t"][1]}: {f["f"]}'] for f in ch['formulas']]})
    return secs


def teach_html(ch, lang):
    n, titles = ch['titles'], ch['titles']
    if lang in ('hi', 'en'):
        head = f'<div class="teach-title">{t(titles, lang)} — {"क्लास में आपका स्वागत है!" if lang == "hi" else "Welcome to the Class!"}</div>'
        return head + ''.join(teach_sec(s, lang) for s in teach_sections(ch))
    if lang == 'bilingual':
        head = (f'<div class="teach-title">{t(titles, "hi")} — क्लास में आपका स्वागत है!</div>'
                f'<div class="teach-title teach-en-follow">{t(titles, "en")} — Welcome to the Class!</div>')
        return head + ''.join(teach_sec(s, 'hi') + teach_sec(s, 'en', follow=True) for s in teach_sections(ch))
    if lang == 'hinglish':   # Hindi in Roman script, written by the robot section by section (same order as teach)
        hs = ch.get('hinglish') or []
        head = f'<div class="teach-title">{html.escape(titles[1])} — Class mein Welcome hai!</div>'
        return head + ''.join(teach_sec({**s, 'heading': [s['heading'], s['heading']], 'paras': [[p, p] for p in s.get('paras', [])],
                                          'example': ({'label': ['Samjho aise', 'Samjho aise'], 'text': [s['example'], s['example']]} if s.get('example') else None)}, 'en')
                              for s in hs)


# ---------------- FORMULAS + 3D ----------------
def formulas_data(ch):
    fs, groups, keys = [], [], []
    for f in ch['formulas']:
        fs.append({'cat': 'basic', 'f': f['f'], 'fe': f['f'], 't': f['t'], 's': f['s'], 'u': f['u']})
        g = f.get('group') or 'main'
        if g not in keys: keys.append(g)
    for g in keys:
        name = next((x for x in ch.get('formula_groups', []) if isinstance(x, list) and x and x[0] == g), [g, g, g])
        groups.append([g, name[1] if len(name) > 1 else g, name[2] if len(name) > 2 else g, [i for i, f in enumerate(ch['formulas']) if (f.get('group') or 'main') == g]])
    if len(groups) > 4:       # owner's books use 1-4 topic chips: keep the 3 biggest groups, the rest go into one
        groups.sort(key=lambda x: -len(x[3])); rest = sorted(i for x in groups[3:] for i in x[3])
        groups = sorted(groups[:3], key=lambda x: x[3][0]) + [['more', 'अन्य सूत्र', 'More formulas', rest]]
    return fs, groups


def short_title(ch):
    s = ch.get('short') or ch['titles']
    ok = isinstance(s, list) and len(s) == 2 and all(isinstance(x, str) and 0 < len(x) <= 18 for x in s)
    if ok: return s
    strip = lambda x: re.sub(r'^\d+\.\s*', '', re.sub(r'\s*\(.*?\)', '', x)).strip()[:18]
    return [strip(ch['titles'][0]), strip(ch['titles'][1])]


DEMO_JS = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'makeDemoDoc.js')


def demo_html(d):
    """Same makeDemoDoc as the owner's book (Three.js r128 + slider). Built with node so the template is byte-identical."""
    js = open(DEMO_JS, encoding='utf-8').read() + '\nprocess.stdout.write(makeDemoDoc(' + ','.join(
        json.dumps(x, ensure_ascii=False) for x in (d['title'], d['hint'], d['slider'], d['min'], d['max'], d['step'], d['val'], demo_body(d['script']))) + '));'
    r = subprocess.run(['node', '-e', js], capture_output=True, text=True, timeout=30)
    if r.returncode: raise ValueError('demo build failed: ' + r.stderr[:200])
    return r.stdout


def demo_body(script):
    """AI often wraps the body in 'function update(v){...}': unwrap it (the template already defines update)."""
    s = (script or '').strip()
    m = re.match(r'^function\s+update\s*\(\s*v\s*\)\s*\{(.*)\}\s*;?\s*$', s, re.S)
    return m.group(1) if m else s


def check_demo_script(d):
    """Runs update(v) at min, mid and max against a stub THREE in node: syntax errors or exceptions reject the model."""
    stub = r'''
const P=new Proxy(function(){},{get:(t,k)=>k==='prototype'?{}:P,apply:()=>P,construct:()=>P});
const THREE=new Proxy({},{get:()=>P});
let shown=0;const objs=[];function clear(){} function add(o){shown++;return o} function mat(){return P} function line(){return P} function arrow(){shown++;return P}
const info={textContent:''};const s={value:0};const valEl={};const scene={add(){},remove(){}};const LANG='hi';function T(h,e){return h}
function update(v){ __BODY__ }
for (const v of [__MIN__, (__MIN__+__MAX__)/2, __MAX__]) { shown=0; info.textContent=''; update(v);
  if (!shown) throw new Error('nothing is drawn: call add(mesh) or arrow(...) inside the body');
  if (!String(info.textContent).trim()) throw new Error('info.textContent is never set'); }
process.stdout.write('ok');'''
    js = stub.replace('__BODY__', demo_body(d['script'])).replace('__MIN__', str(float(d['min']))).replace('__MAX__', str(float(d['max'])))
    r = subprocess.run(['node', '-e', js], capture_output=True, text=True, timeout=30)
    err = next((l.strip() for l in r.stderr.splitlines() if re.match(r'\w*(Error|Exception)\b', l.strip())), r.stderr[-300:].strip())
    return r.stdout == 'ok', err[:300]


def chapter_row(ch, book_slug, ch_no, topic_id):
    fs, groups = formulas_data(ch)
    data = {'kind': 'chN', 'titles': {'hi': ch['titles'][0], 'en': ch['titles'][1]},
            'notes_hi': notes_html(ch, 'hi'), 'notes_en': notes_html(ch, 'en'),
            'teach': {k: teach_html(ch, k2) for k, k2 in (('hindi', 'hi'), ('english', 'en'), ('hinglish', 'hinglish'), ('bilingual', 'bilingual'))},
            'formulas': fs, 'formula_groups': groups,
            'demo_hdr': [ch['demo']['title'][0] + ' — 3D मॉडल (स्लाइडर चलाकर देखें)', ch['demo']['title'][1] + ' — 3D model (move the slider)'] if ch.get('demo') else None,
            'demo_html': demo_html(ch['demo']) if ch.get('demo') else None}
    return {'book_slug': book_slug, 'ch_no': ch_no, 'topic_id': topic_id, 'title_hi': ch['titles'][0], 'title_en': ch['titles'][1],
            'short_hi': short_title(ch)[0], 'short_en': short_title(ch)[1], 'data': data, 'status': 'draft'}
