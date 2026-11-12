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
