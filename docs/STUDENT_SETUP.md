# Student setup (first run) — review build

Review link: `next.html` (same app as `index.html` plus the setup). `index.html` is unchanged until the owner approves.

Flow: language (one) → name → where are you now (one) → exact course with branch in the name (one)
→ studying / passed + class / semester / year (one) → what to study: "My course" + target exams (many) → summary.

After setup every screen (library, formulas, mission, counts) is built only from:
- **My course**: `mtb.qualifications.course` (subjects, and for General Science only the listed parts).
- **Each chosen exam**: the subjects of that exam's sections (`mtb.exam_sections`); "branch-engineering" becomes the
  student's own branch subject. Exams without a section table show their level's subjects, never another branch's
  engineering subject; JEE = physics + chemistry + maths, NEET = physics + chemistry + biology.
- A subject shared by two choices at the same level appears once, labelled with both.
- A subject split into syllabus subjects (`mtb.subject_units`, e.g. Mechanical → 11 subjects, Thermal Engineering = 7 chapters)
  is shown subject-wise instead of one flat chapter list.

Why each filter exists is stored next to the data: `mtb.qualifications.why`, `mtb.qualification_exams.why`.
Eligibility follows the exams' official notifications in general terms; age limits and yearly changes are not modelled.

Additive only: migrations 0167, 0168 (new tables + read functions). Old picker data, old functions and saved progress are untouched;
progress made under the old one-book-per-subject ids is carried to the new subject-wise books.

## v2 (2026-11-12)
- 42 qualifications (adds 10th/12th pass, ITI trades, D.Pharm, GNM, D.El.Ed, automobile diploma, B.Ed, B.Sc Nursing, B.Pharm, MBBS, LLB, BCA, BBA, B.Sc Agri, MBA, MCA).
- 53 more exam families in 16 groups (`mtb.exam_cats`): technical (JE/AE, PSU/metro/ISRO, railway ALP/technician, GATE/ESE/LEET)
  and non-technical (railway, SSC, banking, defence, police, civil services, teaching, health, entrance, school competitions, research, law/management).
  They are `active = false, setup_only = true`, so the old picker and robots are unchanged. Subjects per exam: `mtb.exams.setup_subjects`.
- Setup "goals" step lists exams under Technical / Non-technical, then by group. Many may be picked.
- Library: exam filter chips (All / My course / each exam), then Technical and Non-technical groups. A subject the app has no
  content for yet is shown locked. Inside a subject: Book · Notes · Class · Formulas, then its chapters (opens the reader on that tab).
- One shelf per subject even when several exams use it; the first goal decides its depth.

## v3 (2026-11-12): course syllabus, state, more exams (review build `next.html`)
- `mtb.course_subjects` (migration 0171) holds every subject of every course, stage-wise (semester / year / class), names only.
  Source file: `content/course-syllabus/syllabus.json` (built by `tools/build_course_syllabus.py`, loaded by the
  `course-syllabus-load` workflow). A subject opens only when it is mapped to existing chapters (`chapters`) or to a
  subject/units; everything else shows locked 🔒. To open a subject later: add its chapters, put the ids in the
  builder line (`ch:<id>,<id>`), push — the workflow loads it.
- Library: "📘 मेरा कोर्स" group first, with stage chips; then exam shelves (technical / non-technical).
  A chapter on two shelves counts once in progress; "continue" prefers the student's own semester.
- Setup asks the state (optional). State-wise exams carry the state name; the state's own PSC is marked 📍;
  "Other State PSC" is hidden when the state's own PSC is listed. Stored as `DB.setup.state`.
- Migration 0172 adds exam families: RPF Constable, RPF SI, SSC Selection Post, State SSC, DSSSB, Other State PSC,
  State teacher recruitment, Agriculture Officer (with eligibility rows). Backup: `mtb.bk_0172_qualification_exams`.
- Merit-only recruitments (India Post GDS, railway/PSU apprentices) are not listed: they have no written exam.

## v4 (2026-11-12): syllabus hierarchy, topic outlines, semester 6 fixes
Hierarchy everywhere: **course → stage (semester / year / class) → group → subject → unit (chapter) → topic**.
- Groups inside a stage: 📘 theory · 🎯 elective (pick one) · 🧪 lab / practical · 🗂️ project / internship. The library shows
  each group under its own small heading instead of one mixed grid.
- Source: `tools/syllabus/courses.mjs` (courses, stages, subjects, chapter mapping) and `tools/syllabus/outlines/*.mjs`
  (units + topics of every subject; 487 outlines, ~2,200 units). `node tools/build_course_syllabus.mjs` writes
  `content/course-syllabus/syllabus.json` (→ `mtb.course_subjects`) and `content/course-syllabus/outline.json` (read by the app).
  The builder refuses: a chapter id in two subjects of one course, a theory/elective subject without an outline, an unused
  outline, a course subject mapped to competitive maths / GS content.
- Every subject (open or 🔒) shows **📋 Full syllabus**: its units and topics. Content work now only fills chapters; to open a
  subject add its chapter ids in `courses.mjs` (`'ch:…'`), rebuild, push.
- Semester 6 (and the whole diploma) fixed: civil (12 chapters) and electrical (6 chapters) content was never mapped, so every
  civil / electrical subject was locked; mechanical chapters 436 and 438 were shown in two semesters; mechanical semester 6 had
  no open subject (Industrial Engineering & Management moved 5 → 6, its usual place); sem-6 electives added for every branch.
  Progress made under a subject's old id (old semester) is carried to the new one.
- Broad subjects are **one book with sections** (`mtb.subject_units.mode = 'section'`, migration 0174): General Awareness =
  History & Culture · Geography · Polity · Economy · Science & Technology · Static GK · Current Affairs; General Science =
  Physics · Chemistry · Biology · Environment (was 4 separate books). Progress from the old per-section books is carried over.
- Loader: `course_syllabus_sync` replaces a whole course (removed rows kept in `mtb.bk_0173_course_subjects`); the old loader
  only upserted, so renamed / moved subjects stayed as duplicates.
- Fix: a student who had finished setup got a crash on every reopen (first paint read `SETUP_CFG` before it was declared).

## v5 (2026-11-13): many books per subject (editions), book designer, desktop layout
Hierarchy: course → stage → group → subject → **edition (book)** → chapter → blocks.
- A subject can hold several books. Book 1 is always the app's own book (atoms; Book / Notes / Class / Formulas). The others
  are **editions**: original books written in a teaching style — 📗 textbook (board-book layout) · 🧑‍🏫 teacher's notes ·
  🎯 exam focus · 🔢 practice workbook · ⚡ quick revision · 📚 reference. No writer / publisher names or copied text:
  an edition follows a style, never the wording or pictures of a published book.
- Students: on a subject, **📚 Books for this subject** shows every published book as a card; picking one shows its chapters,
  which open in the reader (`edition.html?e=<id>&ch=<n>`, Hindi / English / both). A 🔒 subject that has a published book opens
  on it. "Done" marks are kept on the phone (`DB.edRead`).
- Owner: with the review code in this browser (Control Room → Review saves it, key `cr_owner_code`), every subject also shows
  drafts and **＋ Add a book** (pick a style + name). ✏️ opens the designer `edition.html?e=<id>&key=<book id>&edit=1`:
  chapter list (first open can create every chapter from the syllabus, with its topics as headings to write under),
  blocks (heading, paragraph, key point, formula, solved example, MCQ, table, note, image link), live preview, save (Ctrl+S),
  publish / unpublish per chapter and per book. Students see only published chapters of a published book.
- Server (migration 0175): `mtb.book_editions`, `mtb.edition_chapters`, `mtb.edition_versions` (every replaced or deleted
  chapter copy is kept). Public: `get_book_editions(keys)`, `get_edition_chapter(id, ch)`. Owner (review code): `owner_ok`,
  `edition_owner_list`, `edition_save`, `edition_chapter_get`, `edition_chapter_save`. Without 0175 the library works as before.
- Desktop / laptop (≥1024 px): the bottom bar becomes a left sidebar; the library is two panes (browse left, chosen subject with
  its books, chapters and syllabus in a sticky panel right); the dashboard shows cards in 2 columns (3 at ≥1440 px). Tablet
  (≥768 px) gets a wider subject grid. Phones are unchanged.