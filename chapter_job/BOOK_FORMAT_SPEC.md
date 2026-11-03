# Owner's chapter format ("Library" book) — spec for the chapter robot

Source of truth: owner's file `Base_line_physics_all_chapters_merged.html` (Physics baseline, 11 chapters), served in the app by
`book.html` from `mtb.chapter_books` (book_slug, ch_no, topic_id, titles, `data`, status). Measured on chapters 2–11.

## 1. One chapter = one row in mtb.chapter_books, data.kind = "chN"
| key | what | measured size (per chapter) |
|---|---|---|
| titles / title_hi, title_en, short_hi, short_en | "2. गति (Motion)" / "2. Motion & Kinematics" | — |
| notes_hi, notes_en | the NOTES sheet, HTML, one per language | 17–53k chars, **880–1720 words**, **15–22 panels** |
| teach.hindi / .english / .hinglish / .bilingual | the CLASS (teach) lesson, HTML, 4 language modes | **1350–2400 words** each, **~15 sections** |
| formulas | list of {cat, f, fe, t:[hi,en], s:[hi,en], u:[hi,en]} | 3–30 formulas |
| formula_groups | [[key, hi, en, [formula indexes]]] | 1–4 groups |
| demo_html + demo_hdr [hi,en] | 3D / slider model (Three.js r128, makeDemoDoc pattern) | 4–8k chars |
| Book tab | built by the app from the notes panel titles + teach section titles + formula count + 3D | nothing to write |

## 2. NOTES sheet (notes_hi / notes_en) — building blocks and order
`sheet-header` (sheet-title, sheet-subtitle) then panels in this order:
1. 📖 Introduction (what the chapter is about; key terms in a kv-list)
2. one panel per concept of the syllabus (10–14 panels), colours rotate blue / green / purple / orange / red
3. ✏️ Solved Numerical 1…5 (solution-box: solution-header, sol-given, sol-step × n, sol-answer)
4. ⚡ Quick Revision (panel red, kv-list of 8–12 one-line facts)
5. 🎯 Practice Questions (8–10 Q with answer lines)

Inside a concept panel (`panel <colour>` → `panel-header` emoji + title → `panel-body`), as the topic needs:
- `<p>` definitions with <strong> key words
- `kv-list` / `kv-item` (kv-key, kv-val): units, dimensions, properties, comparisons — **23–45 per chapter**
- `<table>` comparisons (Type | Description | Example) — **1–5 per chapter**
- `formula-box` with `frac/num/den` fractions + a kv-list of units
- `tip-box` (⚠ Important / common mistake) — 0–5
- `diagram-container` + inline `<svg>` + `diagram-caption` — **2–12 per chapter**

## 3. TEACH lesson (teach.*) — building blocks and order
`teach-title` "N. Title — क्लास में आपका स्वागत है!" then `teach-sec` × ~15:
- story opener (🚗 सबसे पहले — … क्या है?) with a `teach-ex` "समझो ऐसे:"
- one section per concept, spoken-teacher style: `teach-text` paragraphs, `teach-formula` lines, `teach-ex` (समझो ऐसे / याद रखो)
- ✅ हल किए गए उदाहरण (worked examples), 🧠 सारांश (Quick Revision), 🎓 त्वरित जाँच (Quick Check), 📐 सभी सूत्र (Formula Sheet)
- hindi = Hindi with English terms in brackets; english = English; hinglish = Hindi in Roman script; bilingual = both

## 4. FORMULA list
{cat: 'basic', f: 'v = u + at', fe: same in English, t: [name hi, name en], s: [short meaning hi, en], u: [use/units hi, en]};
formula_groups split them into 1–4 topic groups.

## 5. Depth rule
A chapter is not complete until, for its level, it matches the reference books found by the research step:
every syllabus item has its own concept panel AND teach section; numbers above are the minimum targets
(notes ≥ 900 words per language, ≥ 15 panels, ≥ 5 solved numericals, ≥ 8 practice Q, ≥ 8 revision facts,
teach ≥ 1300 words per language, ≥ 12 sections). Diagrams: at least one per concept where the reference books draw one.

## 6. Rules that do not change
- No text copied from NCERT or any book/site; reference books give topics, order, depth and question types only.
- Official syllabus scope (grounded in the syllabus PDF) decides what is in and out.
- Every numerical re-solved by a different AI; copyright n-gram < 20 %; nothing goes live without owner approval.

## 7. Rules already saved in the project (found in the database and repo; the robots follow them)
- robots/STYLE.md: purpose of each mode; maths typed plainly (a/b, ×, x^2, sqrt) and drawn by the app; every solution = notebook
  steps with real numbers, last step = answer; second AI solves without seeing answers; no HTML/LaTeX from AI.
- mtb.pipeline_rules: hidden-not-deleted (delete only on the owner's explicit order), backup before any server change,
  tests before every app release, publish only when complete and checked.
- Masterclass solutions (mtb.solution_items: q, topic, type, methods[steps with why], quiz) = the universal solved-question style;
  the Solver robot fills these per level/chapter.
- Language policy: each board's own medium standard; class 9-10 bilingual (both languages written in full).
- Copyright: nothing copied; copyright n-gram gate; automatic publishing only where a copyright reference exists.

## 8. Known limits found while checking the app (not changed by the robot)
- book.html is wired to the Physics book: chapters 2-11 by number (CHS map) and a special chapter 1. A new book
  (e.g. Class 10 Science) needs book.html to build its chapter list from the server rows before it can show all 5 tabs.
- robots/ecosystem/config.json has auto_approve = true for the level-book Writer robot (drafts can go live without the owner);
  migration 0169 (hold) is not applied.
