// Builds the course syllabus from tools/syllabus/*.mjs:
//   content/course-syllabus/syllabus.json  every subject of every course, stage-wise (loaded into mtb.course_subjects)
//   content/course-syllabus/outline.json   every subject's units (chapters) and topics, in syllabus order (read by the app)
// Hierarchy: course → stage (semester / year / class) → group (theory · elective · lab · project) → subject → unit → topic.
// Run: node tools/build_course_syllabus.mjs        (fails on any rule break; the CI loader runs it and compares)
import { writeFileSync, readdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { C } from './syllabus/courses.mjs';

const HERE = dirname(fileURLToPath(import.meta.url));
const OUT = join(HERE, '..', 'content', 'course-syllabus');
const KIND = { T: 'theory', E: 'elective', L: 'lab', P: 'project' };
export const slug = s => s.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '').slice(0, 60).replace(/-+$/, '');

// ---- outline catalog: every file in tools/syllabus/outlines/ exports O = { key: [[unit_en, unit_hi, 'topic; topic; …'], …] }
const O = {};
for (const f of readdirSync(join(HERE, 'syllabus', 'outlines')).filter(f => f.endsWith('.mjs')).sort()) {
  const m = await import(pathToFileURL(join(HERE, 'syllabus', 'outlines', f)).href);
  for (const [k, v] of Object.entries(m.O)) { if (O[k]) throw new Error(`outline ${k} defined twice (${f})`); O[k] = v; }
}
// a string value is an alias: the same syllabus under another course's name (e.g. 'pharmaceutics-i': 'pharmaceutics')
for (const [k, v] of Object.entries(O)) if (typeof v === 'string') { if (!Array.isArray(O[v])) throw new Error(`alias ${k} -> ${v}: not found`); O[k] = O[v]; }

const errs = [], used = new Set(), rows = [];
for (const [q, [src, stages]] of Object.entries(C)) {
  const chSeen = new Map();
  for (const [st, subs] of Object.entries(stages)) {
    const seen = new Set();
    subs.forEach((t, i) => {
      const [en, hi, k = 'T', m = '', ok] = t, kind = KIND[k];
      if (!kind) errs.push(`${q} ${st} ${en}: bad kind ${k}`);
      const r = { qual: q, stage: st, slug: slug(en), sort: i + 1, en, hi, kind, source: src };
      if (seen.has(r.slug)) errs.push(`${q} ${st}: duplicate slug ${r.slug}`); seen.add(r.slug);
      if (kind === 'theory' || kind === 'elective') {
        const key = ok || slug(en);
        if (!O[key]) errs.push(`${q} ${st} "${en}": no outline "${key}"`); else { r.outline = key; used.add(key); }
      }
      if (m.startsWith('ch:')) {
        r.chapters = m.slice(3).split(',').map(Number);
        r.chapters.forEach(id => { if (chSeen.has(id)) errs.push(`${q}: chapter ${id} in both ${chSeen.get(id)} and ${st}:${r.slug}`); chSeen.set(id, st + ':' + r.slug); });
      } else if (m.startsWith('s:')) {
        const [s, u] = m.slice(2).split(':'); r.subject = s; if (u) r.units = u.split('+');
        // competitive-exam maths / GS content is not the board or university syllabus of a course subject (audit 2026-11-12)
        if (s === 'maths' || s === 'general-science') errs.push(`${q} ${st} ${en}: course subjects must not map to ${s}`);
      } else if (m) errs.push(`${q} ${st} ${en}: bad map ${m}`);
      rows.push(r);
    });
  }
}
// outline shape: 2+ units, every unit has an English + Hindi name and at least one topic line
for (const [k, units] of Object.entries(O)) {
  if (!Array.isArray(units) || units.length < 2) errs.push(`outline ${k}: needs 2+ units`);
  (units || []).forEach((u, i) => { if (u.length !== 3 || !u[0] || !u[1] || !String(u[2] || '').trim()) errs.push(`outline ${k} unit ${i + 1}: needs [en, hi, topics]`); });
}
const exam = Object.keys(O).filter(k => k.startsWith('x:'));   // exam subjects (General Awareness, Reasoning, …) are kept even when no course uses them
const unused = Object.keys(O).filter(k => !used.has(k) && !k.startsWith('x:'));
if (unused.length) errs.push('outlines not used by any course: ' + unused.join(', '));
if (errs.length) { console.error(errs.join('\n')); console.error(errs.length + ' problem(s)'); process.exit(1); }

const outline = {};
for (const k of Object.keys(O).sort()) outline[k] = O[k].map(([en, hi, t]) => ({ en, hi, topics: t.split(';').map(x => x.trim()).filter(Boolean) }));
const lines = a => '[\n' + a.map(x => JSON.stringify(x)).join(',\n') + '\n]\n';
writeFileSync(join(OUT, 'syllabus.json'), lines(rows));
writeFileSync(join(OUT, 'outline.json'), '{\n' + Object.entries(outline).map(([k, v]) => JSON.stringify(k) + ':' + JSON.stringify(v)).join(',\n') + '\n}\n');
const nU = Object.values(outline).reduce((a, u) => a + u.length, 0), nT = Object.values(outline).reduce((a, u) => a + u.reduce((b, x) => b + x.topics.length, 0), 0);
console.log(`${rows.length} subjects in ${Object.keys(C).length} courses; ${Object.keys(outline).length} outlines (${exam.length} exam subjects), ${nU} units, ${nT} topics`);
