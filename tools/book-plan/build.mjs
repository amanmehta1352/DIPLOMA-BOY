// Book plan: every book the app shows, level by level, with HOW to write it — the input for an AI book-writing agent.
//   node tools/book-plan/build.mjs
// Reads the live catalogue (same public API the app uses) + content/course-syllabus/*.json, writes docs/book-plan/:
//   books.json  — one object per book: key, level, who reads it, chapters (with topics), design profile, editions to make
//   books.csv   — the same as a sheet (one row per book)
//   BOOK_PLAN.md — level-wise list and totals (Hindi)
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { PROFILES, courseProfile, examProfile } from './profiles.mjs';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
const OUT = path.join(ROOT, 'docs/book-plan');
const html = fs.readFileSync(path.join(ROOT, 'index.html'), 'utf8');
const m = html.match(/const SB=\{url:'([^']+)',\s*key:'([^']+)'\}/);
if (!m) throw new Error('SB url/key not found in index.html');
const [, URL, KEY] = m;
const get = async p => { const r = await fetch(URL + '/rest/v1/' + p, { headers: { apikey: KEY, Authorization: 'Bearer ' + KEY, 'Accept-Profile': 'mtb' } });
  if (!r.ok) throw new Error(p + ' HTTP ' + r.status); return r.json(); };

const cfg = await get('rpc/get_setup_config');
const subjects = await get('subjects?select=id,slug,name_en,name_hi');
const topics = await get('topics?select=id,subject_id,name_en,name_hi,unit_en,sort&is_chapter=eq.true&order=sort,id');
const syl = JSON.parse(fs.readFileSync(path.join(ROOT, 'content/course-syllabus/syllabus.json'), 'utf8'));
const outline = JSON.parse(fs.readFileSync(path.join(ROOT, 'content/course-syllabus/outline.json'), 'utf8'));

const LV = id => (cfg.levels || {})[id] || { en: id, hi: id };
const SJ = slug => (cfg.subjects || {})[slug] || (s => s ? { en: s.name_en, hi: s.name_hi } : { en: slug, hi: slug })(subjects.find(s => s.slug === slug));
const BRANCH = { mechanical: 'mechanical-engineering', civil: 'civil-engineering', electrical: 'electrical-engineering', electronics: 'electronics-engineering', computer: 'computer-engineering' };
const CAT_HI = { school: 'स्कूल', iti: 'आईटीआई', diploma: 'डिप्लोमा', graduation: 'स्नातक (ग्रेजुएशन)', postgrad: 'स्नातकोत्तर' };
const KIND_HI = { theory: 'थ्योरी', lab: 'लैब/प्रैक्टिकल', elective: 'ऐच्छिक (इलेक्टिव)', project: 'प्रोजेक्ट/इंटर्नशिप' };
const chOf = slug => { const s = subjects.find(x => x.slug === slug); return s ? topics.filter(t => t.subject_id === s.id) : []; };

const books = [];

// ---------- 1. course books: course -> year/semester -> subject ----------
const quals = cfg.quals || [];
for (const q of quals) {
  const rows = syl.filter(r => r.qual === q.slug).sort((a, b) => (+a.stage - +b.stage) || a.sort - b.sort);
  for (const r of rows) {
    const units = (r.outline && outline[r.outline]) || null, prof = courseProfile(q, r.kind);
    books.push({
      key: `c:${q.slug}:${r.stage}:${r.slug}`, family: 'course',
      category: q.cat, category_hi: CAT_HI[q.cat] || q.cat,
      course: q.slug, course_en: q.en, course_hi: q.hi,
      stage: r.stage, stage_en: q.stages ? `${q.stages.label_en} ${r.stage}` : '', stage_hi: q.stages ? `${q.stages.label_hi} ${r.stage}` : '',
      level: q.level, level_en: LV(q.level).en, level_hi: LV(q.level).hi,
      subject: r.slug, title_en: r.en, title_hi: r.hi, kind: r.kind, kind_hi: KIND_HI[r.kind] || r.kind,
      profile: prof, styles: PROFILES[prof].styles,
      chapter_source: units ? 'syllabus-outline' : 'to-plan',
      chapters: units ? units.map((u, i) => ({ n: i + 1, en: u.en, hi: u.hi, topics: u.topics || [] })) : [],
      same_content: r.outline || null,     // books with the same outline key can share one written text
      used_by: [q.en], source: r.source || '',
    });
  }
}

// ---------- 2. exam shelves: one book per (exam level, subject), shared by every exam of that level ----------
const shelf = new Map();
for (const [fk, f] of Object.entries(cfg.families || {})) {
  for (const tok of f.subjects || []) {
    const [sj, u] = String(tok).split(':');
    const slugs = sj === 'branch-engineering' ? Object.values(BRANCH) : sj === 'branch-or-trade' ? [...Object.values(BRANCH), 'trade-theory'] : [sj];
    for (const slug of slugs) {
      const k = f.level + '|' + slug;
      const o = shelf.get(k) || { level: f.level, slug, units: new Set(), all: false, exams: [], cats: new Set() };
      if (u) u.split('+').forEach(x => o.units.add(x)); else o.all = true;
      if (!o.exams.includes(f.en)) o.exams.push(f.en); if (f.cat) o.cats.add(f.cat);
      shelf.set(k, o);
    }
  }
}
const unitCfg = cfg.units || {};
for (const o of [...shelf.values()].sort((a, b) => a.level.localeCompare(b.level) || a.slug.localeCompare(b.slug))) {
  const sj = SJ(o.slug), prof = examProfile(o.level, o.cats), base = {
    family: 'exam', category: 'exam', category_hi: 'प्रतियोगी परीक्षा', course: '', course_en: '', course_hi: '', stage: '', stage_en: '', stage_hi: '',
    level: o.level, level_en: LV(o.level).en, level_hi: LV(o.level).hi, kind: 'exam', kind_hi: 'परीक्षा', profile: prof, styles: PROFILES[prof].styles,
    used_by: o.exams, source: 'official exam notifications / syllabus of: ' + o.exams.join('; ') };
  const all = chOf(o.slug), ul = unitCfg[o.slug];
  const toCh = list => list.map((t, i) => ({ n: i + 1, id: t.id, en: t.name_en, hi: t.name_hi, section: t.unit_en || null, topics: [] }));
  if (ul && ul.every(x => x.mode === 'book')) {          // a big subject (mechanical) is several books, one per unit
    const used = new Set();
    for (const x of ul) { const list = (x.ch || []).map(id => all.find(t => t.id === id)).filter(Boolean); list.forEach(t => used.add(t.id));
      books.push({ ...base, key: `s:${o.level}:${o.slug}~${x.slug}`, subject: o.slug, title_en: x.en, title_hi: x.hi,
        chapter_source: list.length ? 'app-topics' : 'to-plan', chapters: toCh(list), same_content: `s:${o.slug}~${x.slug}` }); }
    const rest = all.filter(t => !used.has(t.id));
    if (rest.length) books.push({ ...base, key: `s:${o.level}:${o.slug}~other`, subject: o.slug, title_en: `${sj.en} · Other`, title_hi: `${sj.hi} · अन्य`,
      chapter_source: 'app-topics', chapters: toCh(rest), same_content: `s:${o.slug}~other` });
    continue;
  }
  let list = all;
  if (!o.all && o.units.size && ul) { const ids = new Set(ul.filter(x => o.units.has(x.slug)).flatMap(x => x.ch || [])); list = all.filter(t => ids.has(t.id)); }
  books.push({ ...base, key: `s:${o.level}:${o.slug}`, subject: o.slug, title_en: sj.en, title_hi: sj.hi,
    title_note: !o.all && o.units.size ? 'only: ' + [...o.units].join(' + ') : '',
    chapter_source: list.length ? 'app-topics' : 'to-plan', chapters: toCh(list), same_content: `s:${o.slug}` });
}

// ---------- order of work: the app's own students first ----------
const PHASES = [
  { n: 1, hi: 'डिप्लोमा (इंजीनियरिंग) + JE / तकनीकी और सामान्य सरकारी परीक्षाएँ', test: b => (b.family === 'course' && /^diploma-(mechanical|civil|electrical|electronics|computer|automobile)$/.test(b.course)) || (b.family === 'exam' && ['govt_technical', 'govt_basic'].includes(b.level)) },
  { n: 2, hi: 'स्कूल (कक्षा 6-12) + ITI + स्कूल-स्तर प्रवेश परीक्षाएँ', test: b => ['school', 'iti'].includes(b.category) || (b.family === 'exam' && ['class_6_8', 'class_9_10', 'class_11_12_sci', 'engineering'].includes(b.level)) },
  { n: 3, hi: 'बी.टेक + बैंकिंग, रक्षा, सिविल सेवा', test: b => /^btech-/.test(b.course) || (b.family === 'exam' && ['banking', 'govt_defence', 'state_psc', 'upsc_civil'].includes(b.level)) },
  { n: 4, hi: 'बाकी डिग्रियाँ और परीक्षाएँ (मेडिकल, कानून, कॉमर्स, कला, शोध)', test: () => true },
];
books.forEach(b => { b.phase = PHASES.find(p => p.test(b)).n; });

// ---------- totals ----------
const sum = (a, f) => a.reduce((s, x) => s + f(x), 0);
const course = books.filter(b => b.family === 'course'), exam = books.filter(b => b.family === 'exam');
const uniq = new Set(course.map(b => b.same_content || b.key)).size + new Set(exam.map(b => b.same_content)).size;
const T = {
  books: books.length, course: course.length, exam: exam.length,
  editions_phase1: books.length, editions_full: sum(books, b => b.styles.length),
  unique_texts: uniq, chapters: sum(books, b => b.chapters.length), to_plan: books.filter(b => b.chapter_source === 'to-plan').length,
};

// ---------- write ----------
fs.mkdirSync(OUT, { recursive: true });
fs.writeFileSync(path.join(OUT, 'books.json'), JSON.stringify({ generated: new Date().toISOString().slice(0, 10), totals: T, profiles: PROFILES, books }, null, 1) + '\n');

const csvq = v => { const s = Array.isArray(v) ? v.join('; ') : String(v ?? ''); return /[",\n]/.test(s) ? '"' + s.replace(/"/g, '""') + '"' : s; };
const cols = [['#', (b, i) => i + 1], ['phase', b => b.phase], ['book_key', b => b.key], ['family', b => b.family], ['category', b => b.category], ['course', b => b.course_en],
  ['stage', b => b.stage_en], ['level', b => b.level_en], ['subject_en', b => b.title_en + (b.title_note ? ` (${b.title_note})` : '')], ['subject_hi', b => b.title_hi],
  ['kind', b => b.kind], ['profile', b => b.profile], ['first_edition_style', b => b.styles[0]], ['all_edition_styles', b => b.styles],
  ['chapters', b => b.chapters.length], ['chapter_source', b => b.chapter_source], ['same_content_key', b => b.same_content || ''], ['used_by', b => b.used_by]];
fs.writeFileSync(path.join(OUT, 'books.csv'), '﻿' + [cols.map(c => c[0]).join(','), ...books.map((b, i) => cols.map(c => csvq(c[1](b, i))).join(','))].join('\n') + '\n');

// ---------- BOOK_PLAN.md ----------
const L = [];
const STY = { textbook: '📗 पाठ्यपुस्तक', teacher: '🧑‍🏫 शिक्षक', exam: '🎯 परीक्षा', practice: '🔢 अभ्यास', revision: '⚡ रिवीजन', reference: '📚 संदर्भ' };
L.push('# 📚 Diploma Boy — पूरी किताब योजना (Book Plan)', '',
  `> यह फ़ाइल \`node tools/book-plan/build.mjs\` से अपने-आप बनती है (${new Date().toISOString().slice(0, 10)})। ऐप में कोर्स या परीक्षा जुड़े तो स्क्रिप्ट दोबारा चलाएँ।`,
  '> AI एजेंट के लिए पूरा डेटा: [books.json](books.json) · शीट: [books.csv](books.csv) · लिखने के नियम: [AGENT_BRIEF.md](AGENT_BRIEF.md)', '',
  '## 1. कुल गिनती', '',
  '| क्या | संख्या |', '|---|---|',
  `| ऐप में कुल किताबें (हर विषय की एक जगह) | **${T.books}** |`,
  `| — कोर्स की किताबें (कोर्स → साल/सेमेस्टर → विषय) | ${T.course} |`,
  `| — परीक्षा की किताबें (परीक्षा लेवल → विषय, कई परीक्षाएँ एक किताब शेयर करती हैं) | ${T.exam} |`,
  `| अलग-अलग लिखनी पड़ेंगी (एक जैसा सिलेबस एक बार लिखें, कई जगह लगाएँ) | **${T.unique_texts}** |`,
  `| पहला चरण: हर किताब का 1 संस्करण | ${T.editions_phase1} |`,
  `| पूरा सेट: सुझाए गए सभी संस्करण (शैली) | ${T.editions_full} |`,
  `| कुल अध्याय (पहले संस्करण में) | ${T.chapters} |`,
  `| जिनके अध्याय अभी तय नहीं (एजेंट पहले अध्याय-सूची बनाएगा) | ${T.to_plan} |`, '',
  '**किताब बनाम संस्करण:** "किताब" = ऐप में विषय की एक जगह (जैसे डिप्लोमा मैकेनिकल · सेमेस्टर 3 · थर्मल इंजीनियरिंग)। "संस्करण" = उस किताब का एक लिखा हुआ रूप, किसी एक शैली में (पाठ्यपुस्तक, परीक्षा, रिवीजन…)। हर किताब में पहले 1 संस्करण बनाएँ, बाद में बाकी शैलियाँ।', '',
  '### किस क्रम में बनाएँ', '', '| चरण | क्या | किताबें | पहला संस्करण | पूरा सेट | अध्याय (पहला संस्करण) |', '|---|---|---|---|---|---|');
for (const p of PHASES) { const bs = books.filter(b => b.phase === p.n);
  L.push(`| ${p.n} | ${p.hi} | ${bs.length} | ${bs.length} | ${sum(bs, b => b.styles.length)} | ${sum(bs, b => b.chapters.length)} |`); }
L.push('');

L.push('## 2. लेवल के हिसाब से गिनती', '', '| श्रेणी | कोर्स / परीक्षा लेवल | किताबें | थ्योरी | लैब | इलेक्टिव | प्रोजेक्ट | डिज़ाइन प्रोफ़ाइल | संस्करण (पूरा सेट) |', '|---|---|---|---|---|---|---|---|---|');
for (const q of quals) { const bs = course.filter(b => b.course === q.slug); if (!bs.length) continue;
  const k = x => bs.filter(b => b.kind === x).length, profs = [...new Set(bs.map(b => b.profile))].join(', ');
  L.push(`| ${CAT_HI[q.cat] || q.cat} | ${q.hi} | ${bs.length} | ${k('theory')} | ${k('lab')} | ${k('elective')} | ${k('project')} | ${profs} | ${sum(bs, b => b.styles.length)} |`); }
for (const lv of [...new Set(exam.map(b => b.level))]) { const bs = exam.filter(b => b.level === lv);
  L.push(`| प्रतियोगी परीक्षा | ${LV(lv).hi} | ${bs.length} | — | — | — | — | ${[...new Set(bs.map(b => b.profile))].join(', ')} | ${sum(bs, b => b.styles.length)} |`); }
L.push('');

L.push('## 3. हर लेवल किताब कैसे डिज़ाइन हो (प्रोफ़ाइल)', '', '| प्रोफ़ाइल | किसके लिए | पढ़ने वाला | भाषा | अध्याय की लंबाई और बनावट | संस्करण (क्रम से) |', '|---|---|---|---|---|---|');
for (const [id, p] of Object.entries(PROFILES)) L.push(`| \`${id}\` | ${p.hi} | ${p.reader} | ${p.language} | ${p.chapter} | ${p.styles.map(s => STY[s]).join(' → ')} |`);
L.push('');

L.push('## 4. पूरी सूची — कोर्स की किताबें', '');
for (const cat of ['school', 'iti', 'diploma', 'graduation', 'postgrad']) {
  const qs = quals.filter(q => q.cat === cat && course.some(b => b.course === q.slug)); if (!qs.length) continue;
  L.push(`### ${CAT_HI[cat]}`, '');
  for (const q of qs) { const bs = course.filter(b => b.course === q.slug);
    L.push(`#### ${q.hi} — ${q.en} (${bs.length} किताबें · प्रोफ़ाइल: ${[...new Set(bs.map(b => b.profile))].join(', ')})`, '', '| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |', '|---|---|---|---|---|---|---|');
    bs.forEach((b, i) => L.push(`| ${i + 1} | ${b.stage_hi || '—'} | ${b.title_hi} (${b.title_en}) | ${b.kind_hi} | ${b.chapters.length || 'तय करना'} | ${STY[b.styles[0]]} | \`${b.key}\` |`));
    L.push(''); } }

L.push('## 5. पूरी सूची — प्रतियोगी परीक्षा की किताबें', '', 'एक लेवल की सब परीक्षाएँ एक ही किताब पढ़ती हैं (जैसे SSC CGL, CHSL, RRB NTPC सब "सरकारी (सामान्य)" की गणित किताब)।', '');
for (const lv of [...new Set(exam.map(b => b.level))]) { const bs = exam.filter(b => b.level === lv);
  L.push(`### ${LV(lv).hi} — ${LV(lv).en} (${bs.length} किताबें · प्रोफ़ाइल: ${[...new Set(bs.map(b => b.profile))].join(', ')})`, '', '| # | विषय | अध्याय | किन परीक्षाओं के लिए | पहला संस्करण | book_key |', '|---|---|---|---|---|---|');
  bs.forEach((b, i) => L.push(`| ${i + 1} | ${b.title_hi} (${b.title_en}${b.title_note ? ', ' + b.title_note : ''}) | ${b.chapters.length || 'तय करना'} | ${b.used_by.join(', ')} | ${STY[b.styles[0]]} | \`${b.key}\` |`));
  L.push(''); }
fs.writeFileSync(path.join(OUT, 'BOOK_PLAN.md'), L.join('\n'));
console.log(JSON.stringify(T));
