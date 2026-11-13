// Deterministic checks for a book.core.v1 file. Usage: node tools/book/check.js <core.json>
// Exit 1 on any error. Every worked example and numeric question is recomputed from its `calc`.
// Works in Node and in the browser (Control Room imports checkCore); Node-only modules load inside the CLI block.

export function checkCore(core) {
  const errs = [], warn = [];
  const need = (o, keys, where) => keys.forEach(k => { if (o[k] === undefined || o[k] === '' ) errs.push(`${where}: "${k}" missing`); });
  need(core, ['schema', 'id', 'level_family', 'subject', 'no', 'title_hi', 'title_en', 'intro', 'learn', 'prereq', 'sections', 'mistakes', 'summary', 'questions'], 'chapter');
  if (core.schema !== 'book.core.v1') errs.push('chapter: schema must be book.core.v1');
  if (!['basic', 'board', 'technical', 'higher'].includes(core.level_family)) errs.push('chapter: bad level_family');

  const recompute = (calc, value, where) => {
    if (!/^[0-9eE+\-*/(). ]+$/.test(calc || '')) { errs.push(`${where}: calc must be plain arithmetic`); return; }
    const got = Function(`"use strict";return (${calc})`)();
    const tol = Math.max(Math.abs(value) * 2e-3, 1e-12);
    if (!Number.isFinite(got) || Math.abs(got - value) > tol) errs.push(`${where}: calc ${calc} = ${got}, but value says ${value}`);
  };

  // text hygiene: no Markdown / LaTeX / HTML in plain-text fields, balanced fractions
  const texts = [];
  const walk = (v, path) => {
    if (typeof v === 'string') { if (!path.endsWith('.svg') && !path.endsWith('.calc')) texts.push([path, v]); }
    else if (Array.isArray(v)) v.forEach((x, i) => walk(x, `${path}[${i}]`));
    else if (v && typeof v === 'object') Object.entries(v).forEach(([k, x]) => walk(x, `${path}.${k}`));
  };
  walk(core, 'core');
  for (const [p, t] of texts) {
    if (/\*\*|\\frac|\$|^#|<[a-z\/]|```/.test(t)) errs.push(`${p}: Markdown/LaTeX/HTML found`);
    if ((t.match(/\[\[/g) || []).length !== (t.match(/\]\]/g) || []).length) errs.push(`${p}: unbalanced [[ ]]`);
    if (/\[VERIFY\]/.test(t)) warn.push(`${p}: [VERIFY] still open`);
  }

  const figs = core.figures || {};
  for (const [k, f] of Object.entries(figs)) {
    if (!/<title>/.test(f.svg)) errs.push(`figure ${k}: <title> missing`);
    if (/<script|on\w+=|href=/i.test(f.svg)) errs.push(`figure ${k}: script/link not allowed in svg`);
  }
  const keys = new Set();
  let nEx = 0;
  (core.sections || []).forEach((s, i) => {
    const w = `section ${i + 1} (${s.key})`;
    need(s, ['key', 'title', 'intro', 'defn', 'explain', 'examples', 'checks'], w);
    if (keys.has(s.key)) errs.push(`${w}: duplicate key`); keys.add(s.key);
    if (s.figure && !figs[s.figure]) errs.push(`${w}: figure "${s.figure}" not in figures`);
    if (!(s.explain || []).some(e => e.depth === 'core')) errs.push(`${w}: needs at least one core explain`);
    (s.examples || []).forEach((e, j) => {
      need(e, ['level', 'q', 'given', 'find', 'formula', 'steps', 'answer', 'calc', 'value'], `${w} example ${j + 1}`);
      recompute(e.calc, e.value, `${w} example ${j + 1}`); nEx++;
    });
    const lv = (s.examples || []).map(e => e.level);
    if (lv.join() !== [...lv].sort().join()) warn.push(`${w}: examples not ordered easy→hard`);
  });
  if ((core.sections || []).length < 3) errs.push('chapter: at least 3 sections');
  if (Object.keys(figs).length < 2) warn.push('chapter: fewer than 2 figures');
  if (nEx < 4) errs.push('chapter: at least 4 worked examples');
  if ((core.mistakes || []).length < 3) errs.push('chapter: at least 3 mistakes');
  if ((core.summary || []).length < 6) errs.push('chapter: at least 6 summary points');

  const count = {};
  (core.questions || []).forEach((q, i) => {
    const w = `question ${i + 1} (${q.type})`;
    count[q.type] = (count[q.type] || 0) + 1;
    if (!keys.has(q.section)) errs.push(`${w}: unknown section "${q.section}"`);
    if (![1, 2, 3].includes(q.level)) errs.push(`${w}: level must be 1, 2 or 3`);
    if (q.type === 'mcq') {
      if (!Array.isArray(q.options) || q.options.length !== 4) errs.push(`${w}: needs 4 options`);
      if (![0, 1, 2, 3].includes(q.answer)) errs.push(`${w}: answer must be 0-3`);
      if (new Set(q.options).size !== 4) errs.push(`${w}: options repeat`);
    } else if (q.type === 'numeric') {
      need(q, ['solution', 'calc', 'value', 'unit'], w);
      recompute(q.calc, q.value, w);
    } else if (!q.answer) errs.push(`${w}: answer missing`);
  });
  const min = { mcq: 5, vshort: 4, short: 3, long: 2, numeric: 4 };
  for (const [t, n] of Object.entries(min)) if ((count[t] || 0) < n) errs.push(`questions: need at least ${n} ${t}, have ${count[t] || 0}`);
  return { errs, warn, stats: { sections: (core.sections || []).length, examples: nEx, figures: Object.keys(figs).length, questions: count } };
}

if (globalThis.process?.argv?.[1]?.endsWith('check.js')) {
  const fs = await import('node:fs');
  const file = process.argv[2];
  if (!file) { console.error('usage: node tools/book/check.js <core.json>'); process.exit(2); }
  const r = checkCore(JSON.parse(fs.readFileSync(file, 'utf8')));
  r.warn.forEach(w => console.log('WARN ', w));
  r.errs.forEach(e => console.log('ERROR', e));
  console.log(JSON.stringify(r.stats));
  console.log(r.errs.length ? `FAIL: ${r.errs.length} error(s)` : 'OK');
  process.exit(r.errs.length ? 1 : 0);
}
