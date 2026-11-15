// core (book.core.v1) + style → one offline HTML chapter. Same input → same output, byte for byte.
// Usage: node tools/book/render.js <core.json> <style|all> [outDir]
// Also imported in the browser (Control Room review, book reader): no Node modules at the top level.
import { STYLES, ACCENT } from './styles.js';
import { checkCore } from './check.js';

const esc = s => String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
// plain text → safe HTML, with [[top|bottom]] as a stacked fraction
const t = s => esc(s).replace(/\[\[([^|\]]+)\|([^\]]+)\]\]/g, '<span class="frac"><span>$1</span><span>$2</span></span>');
const LETTERS = ['a', 'b', 'c', 'd'];
const STARS = ['', '★', '★★', '★★★'];
const TYPE_HI = { mcq: 'बहुविकल्पी प्रश्न', vshort: 'अति लघु उत्तरीय प्रश्न', short: 'लघु उत्तरीय प्रश्न', long: 'दीर्घ उत्तरीय प्रश्न', numeric: 'आंकिक प्रश्न' };
const TYPE_ORDER = ['mcq', 'vshort', 'short', 'long', 'numeric'];
const KA = ['क', 'ख', 'ग', 'घ', 'ङ', 'च'];

const CSS = `
:root{--accent:#047857;--ink:#18212b;--muted:#4b5866;--paper:#fffdf8;--line:#d4dce2}
*{box-sizing:border-box}
body{margin:0;background:#eef1f4;color:var(--ink);font:17px/1.75 "Noto Sans Devanagari","Nirmala UI","Mangal",system-ui,sans-serif}
.page{max-width:820px;margin:0 auto;background:var(--paper);padding:28px 20px 48px}
@media(min-width:860px){.page{margin:24px auto;padding:48px 64px;border:1px solid var(--line);border-radius:6px}}
.running{display:flex;justify-content:space-between;gap:12px;flex-wrap:wrap;font-size:13px;color:var(--muted);border-bottom:1px solid var(--line);padding-bottom:6px;margin-bottom:24px}
h1,h2,h3{font-family:"Noto Serif Devanagari","Nirmala UI","Mangal",serif;line-height:1.35;color:var(--ink)}
.ch-head{border-left:6px solid var(--accent);padding:4px 0 4px 16px;margin-bottom:20px}
.ch-no{font-size:15px;font-weight:700;color:var(--accent);letter-spacing:.04em}
.ch-head h1{font-size:30px;margin:4px 0}.ch-head .en{font-size:17px;color:var(--muted)}
.intro{font-size:18px}
.learn{display:grid;gap:12px;margin:16px 0 28px}@media(min-width:640px){.learn{grid-template-columns:1fr 1fr}}
.learn div{border:1px solid var(--line);border-radius:10px;padding:10px 14px}.learn b{color:var(--accent)}
h2{font-size:23px;margin:40px 0 10px;padding-bottom:6px;border-bottom:2px solid var(--accent)}
h2 .no{color:var(--accent);margin-right:8px}
h3{font-size:19px;margin:24px 0 8px}
p{margin:0 0 14px}ul,ol{padding-left:24px;margin:0 0 14px}
.box{border:2px solid;border-radius:12px;margin:18px 0;overflow:hidden;break-inside:avoid}
.box>.bh{font-weight:700;padding:7px 14px;border-bottom:2px solid;font-size:15px}
.box>.bb{padding:10px 14px}.box>.bb>:last-child{margin-bottom:0}
.defn{border-color:#3b82f6}.defn>.bh{background:#eff6ff;color:#1d4ed8;border-color:#3b82f6}
.formula{border-color:#f59e0b}.formula>.bh{background:#fde68a;color:#0f172a;border-color:#f59e0b}
.example{border-color:#f59e0b}.example>.bh{background:#fffbeb;color:#b45309;border-color:#f59e0b}
.activity{border-color:#10b981}.activity>.bh{background:#ecfdf5;color:#047857;border-color:#10b981}
.know{border-color:#14b8a6}.know>.bh{background:#f0fdfa;color:#0f766e;border-color:#14b8a6}
.mistakes{border-color:#ef4444}.mistakes>.bh{background:#fef2f2;color:#b91c1c;border-color:#ef4444}
.summary{border-color:#10b981}.summary>.bh{background:#ecfdf5;color:#047857;border-color:#10b981}
.ladder{border-color:var(--accent)}.ladder>.bh{background:#f3f5f6;color:var(--ink);border-color:var(--accent)}
.eq{font:600 20px/1.6 "Cambria Math","Times New Roman",serif;text-align:center;margin:8px 0;overflow-x:auto}
.frac{display:inline-flex;flex-direction:column;vertical-align:middle;text-align:center;margin:0 3px;line-height:1.15}
.frac>span:first-child{border-bottom:1.5px solid currentColor;padding:0 4px}
.sym{font-size:15px;color:var(--muted)}
.step{margin:0 0 6px;padding-left:12px;border-left:3px solid #fde68a}
.ans{display:inline-block;border:2px solid #b45309;border-radius:999px;padding:2px 14px;font-weight:700;color:#b45309;margin-top:6px}
.lvl{display:inline-block;font-size:12px;color:#b45309;margin-right:6px;letter-spacing:1px}
figure{margin:20px 0;text-align:center;break-inside:avoid}figure svg{max-width:100%;height:auto}
figcaption{font-size:14px;color:var(--muted);margin-top:6px}
table{border-collapse:collapse;width:100%;margin:12px 0;font-size:15px}th,td{border:1px solid var(--line);padding:7px 9px;text-align:center}th{background:#f3f5f6}
.tw{overflow-x:auto}.tcap{font-size:14px;color:var(--muted);text-align:center;margin:0}
details.check{border:1px dashed var(--accent);border-radius:10px;padding:8px 14px;margin:14px 0}
details summary{cursor:pointer;font-weight:700;color:var(--accent);min-height:32px}
.exercise h3{color:var(--accent)}.exercise ol{margin-bottom:18px}
.opts{display:grid;grid-template-columns:1fr 1fr;gap:2px 16px;list-style:none;padding-left:0;margin:4px 0 12px}
@media(max-width:420px){.opts{grid-template-columns:1fr}}
.key li{margin-bottom:8px}
@media print{body{background:#fff}.page{border:0;margin:0;max-width:none;padding:0}@page{size:A4;margin:16mm}h2{break-after:avoid}details{display:block}details>*{display:block}}
`.trim();

export function render(core, styleCode) {
  const st = STYLES[styleCode];
  if (!st) throw new Error(`unknown style ${styleCode}`);
  const N = core.no;
  const c = { fig: 0, ex: 0, tab: 0, act: 0 };
  const figNo = {};               // figure key → number, in order of first use
  const out = [];
  const box = (cls, head, body) => `<div class="box ${cls}"><div class="bh">${head}</div><div class="bb">${body}</div></div>`;
  const worked = e => box('example', `उदाहरण ${N}.${++c.ex}`,
    `<p><b>${t(e.q)}</b></p><p class="step">दिया है: ${t(e.given)}</p><p class="step">ज्ञात करना है: ${t(e.find)}</p>` +
    `<p class="step">सूत्र: ${t(e.formula)}</p>${e.steps.map(s => `<p class="step">${t(s)}</p>`).join('')}<span class="ans">उत्तर: ${t(e.answer)}</span>`);
  const byLevel = (a, b) => a.level - b.level;
  const opts = q => `<ul class="opts">${q.options.map((o, i) => `<li>(${LETTERS[i]}) ${t(o)}</li>`).join('')}</ul>`;

  // ---------- head ----------
  out.push(`<div class="running"><span>${esc(core.subject.hi)} · ${esc(core.level_hi || '')}</span><span>${st.icon} ${esc(st.name)} · अध्याय ${N}</span></div>`);
  out.push(`<header class="ch-head"><div class="ch-no">अध्याय ${N}</div><h1>${t(core.title_hi)}</h1><div class="en">${t(core.title_en)}</div></header>`);
  out.push(`<p class="intro">${t(core.intro)}</p>`);
  out.push(`<div class="learn"><div><b>इस अध्याय में आप सीखेंगे</b><ul>${core.learn.map(x => `<li>${t(x)}</li>`).join('')}</ul></div>` +
           `<div><b>पहले से आना चाहिए</b><ul>${core.prereq.map(x => `<li>${t(x)}</li>`).join('')}</ul></div></div>`);

  // ---------- sections ----------
  const ladderKey = [];           // abhyas: answers collected per section
  core.sections.forEach((s, i) => {
    const sn = `${N}.${i + 1}`;
    const h = [`<section id="s${N}-${i + 1}"><h2><span class="no">${sn}</span>${t(s.title)}</h2>`, `<p>${t(s.intro)}</p>`, box('defn', 'परिभाषा', `<p>${t(s.defn)}</p>`)];
    s.explain.filter(e => st.explain.includes(e.depth)).forEach(e => h.push(`<p>${t(e.text)}</p>`));
    if (s.figure) {
      const no = figNo[s.figure] ??= `${N}.${++c.fig}`;
      h.push(`<figure>${core.figures[s.figure].svg}<figcaption>चित्र ${no} — ${t(core.figures[s.figure].caption)}</figcaption></figure>`);
    }
    if (s.table) {
      const [head, ...rows] = s.table.rows;
      h.push(`<p class="tcap">सारणी ${N}.${++c.tab} — ${t(s.table.caption)}</p><div class="tw"><table><thead><tr>${head.map(x => `<th>${t(x)}</th>`).join('')}</tr></thead><tbody>` +
             rows.map(r => `<tr>${r.map(x => `<td>${t(x)}</td>`).join('')}</tr>`).join('') + `</tbody></table></div>`);
    }
    if (s.formula) h.push(box('formula', 'सूत्र', s.formula.eq.split(/\s{3,}/).map(x => `<div class="eq">${t(x)}</div>`).join('') + `<p class="sym">${t(s.formula.symbols)} · मात्रक: ${t(s.formula.unit)}${s.formula.when ? ` · ${t(s.formula.when)}` : ''}</p>`));
    const exs = [...s.examples].sort(byLevel);
    (st.examples === 'all' ? exs : exs.slice(0, 1)).forEach(e => h.push(worked(e)));
    if (st.activity && s.activity) {
      const a = s.activity, [head, ...rows] = a.table;
      h.push(box('activity', `क्रियाकलाप ${N}.${++c.act} — ${t(a.title)}`,
        `<p><b>सामग्री:</b> ${t(a.material)}</p><ol>${a.steps.map(x => `<li>${t(x)}</li>`).join('')}</ol>` +
        `<div class="tw"><table><thead><tr>${head.map(x => `<th>${t(x)}</th>`).join('')}</tr></thead><tbody>${rows.map(r => `<tr>${r.map(x => `<td>${t(x)}</td>`).join('')}</tr>`).join('')}</tbody></table></div>` +
        `<p><b>निष्कर्ष:</b> ${t(a.result)}</p>`));
    }
    if (st.know && s.know) h.push(box('know', 'क्या आप जानते हैं?', `<p>${t(s.know)}</p>`));
    if (st.checks) s.checks.forEach(q => h.push(`<details class="check"><summary>स्वयं जाँचें</summary><p>${t(q.q)}</p><p><b>उत्तर:</b> ${t(q.a)}</p></details>`));
    if (st.ladder) {
      const qs = core.questions.filter(q => q.section === s.key && st.ladder.includes(q.type)).sort(byLevel);
      if (qs.length) {
        const keyItems = [];
        h.push(box('ladder', `खंड ${sn} का अभ्यास <span class="lvl">★ आसान · ★★ मध्यम · ★★★ कठिन</span>`,
          `<ol>${qs.map((q, k) => {
            keyItems.push(answerOf(q));
            return `<li><span class="lvl">${STARS[q.level]}</span>${t(q.q)}${q.type === 'mcq' ? opts(q) : ''}</li>`;
          }).join('')}</ol>`));
        ladderKey.push([sn, keyItems]);
      }
    }
    h.push('</section>');
    out.push(h.join('\n'));
  });

  // ---------- chapter end ----------
  out.push(box('mistakes', 'सावधान! आम गलतियाँ', `<ul>${core.mistakes.map(m => `<li><b>गलत:</b> ${t(m.wrong)} → <b>सही:</b> ${t(m.right)}</li>`).join('')}</ul>`));
  out.push(box('summary', 'सारांश', `<ul>${core.summary.map(x => `<li>${t(x)}</li>`).join('')}</ul>`));

  const ex = [];                  // [type, picked questions]
  TYPE_ORDER.forEach(type => {
    const n = st.exercise[type]; if (!n) return;
    const qs = core.questions.filter(q => q.type === type).map((q, i) => ({ q, i })).sort((a, b) => a.q.level - b.q.level || a.i - b.i).slice(0, n).map(x => x.q);
    if (qs.length) ex.push([type, qs]);
  });
  if (ex.length) {
    out.push(`<section class="exercise"><h2>${st.ladder ? 'मिश्रित अभ्यास' : 'अभ्यास'}</h2>` + ex.map(([type, qs], k) =>
      `<h3>${KA[k]}. ${TYPE_HI[type]}</h3><ol>${qs.map(q => `<li>${st.ladder ? `<span class="lvl">${STARS[q.level]}</span>` : ''}${t(q.q)}${type === 'mcq' ? opts(q) : ''}</li>`).join('')}</ol>`).join('') + `</section>`);
  }

  // ---------- answer key ----------
  const key = [];
  ladderKey.forEach(([sn, items]) => key.push(`<h3>खंड ${sn}</h3><ol class="key">${items.map(x => `<li>${x}</li>`).join('')}</ol>`));
  ex.forEach(([type, qs], k) => {
    if (st.answerKey === 'brief' && !['mcq', 'numeric'].includes(type)) return;
    key.push(`<h3>${st.ladder ? 'मिश्रित अभ्यास' : 'अभ्यास'} ${KA[k]}. ${TYPE_HI[type]}</h3><ol class="key">${qs.map(q => `<li>${answerOf(q)}</li>`).join('')}</ol>`);
  });
  if (key.length) out.push(`<section><h2>उत्तरमाला</h2>${key.join('')}</section>`);

  return `<!doctype html>
<html lang="hi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>${esc(core.title_hi)} · ${esc(st.name)}</title>
<meta name="generator" content="tools/book/render.js · ${esc(core.id)} · ${styleCode}">
<style>
${CSS.replace('--accent:#047857', `--accent:${ACCENT[core.level_family]}`)}
</style></head>
<body><main class="page">
${out.join('\n')}
</main></body></html>
`;
}

function answerOf(q) {
  if (q.type === 'mcq') return `(${LETTERS[q.answer]}) ${t(q.options[q.answer])}${q.solution ? '<br>' + q.solution.map(t).join('<br>') : ''}`;
  if (q.type === 'numeric') return q.solution.map(s => `<p class="step">${t(s)}</p>`).join('') + `<span class="ans">उत्तर: ${t(fmt(q.value))} ${t(q.unit)}</span>`;
  return t(q.answer);
}
const fmt = v => Number.isInteger(v) ? String(v) : String(+v.toPrecision(4));

// ---------- CLI ----------
if (globalThis.process?.argv?.[1]?.endsWith('render.js')) {
  const fs = await import('node:fs'), path = await import('node:path');
  const [file, style = 'all', outDir = 'design/pilot'] = process.argv.slice(2);
  if (!file) { console.error('usage: node tools/book/render.js <core.json> <style|all> [outDir]'); process.exit(2); }
  const core = JSON.parse(fs.readFileSync(file, 'utf8'));
  const r = checkCore(core);
  if (r.errs.length) { r.errs.forEach(e => console.error('ERROR', e)); process.exit(1); }
  fs.mkdirSync(outDir, { recursive: true });
  const slug = core.id.split('/').pop();
  for (const code of style === 'all' ? Object.keys(STYLES) : [style]) {
    const f = path.join(outDir, `${slug}-${code}.html`);
    fs.writeFileSync(f, render(core, code));
    console.log(f, fs.statSync(f).size, 'bytes');
  }
}
