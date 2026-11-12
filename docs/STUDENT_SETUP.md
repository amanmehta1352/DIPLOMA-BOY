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
