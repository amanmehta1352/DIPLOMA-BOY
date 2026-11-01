# Language policy — proposal (for CEO approval)

Status: **proposed, not approved.** No seed rows are inserted. Schema: `db/migrations/0166_exam_language_policy.sql` and `0167_chapter_language_policy.sql`.

Research date: 1 Nov 2026. Students: 0 users, so medium-wise student data is skipped; `use_student_medium` stays FALSE.

## How to read the verification column
- **Official page seen**: an official site appeared in search results and the excerpt confirmed the language line.
- **Secondary only**: language taken from coaching or news sites that quote the notification. The official PDF was not opened, so confirm before approval.
- **CEO decision**: internal decision, not an exam rule.

## Findings per exam

| Exam | Primary | Secondary | Regional options | Source URL | Verified |
|---|---|---|---|---|---|
| NEET (UG) | en | hi | 11 regional: Assamese, Bengali, Gujarati, Kannada, Malayalam, Marathi, Odia, Punjabi, Tamil, Telugu, Urdu (state-wise centres) | NTA bulletin (not opened); reports cite it, e.g. https://www.pw.live/news/neet-ug-2026-languages-list-nta-notification | Secondary only. English booklet for English; Hindi/regional get bilingual booklet with English; English is final in disputes. |
| JEE Main | en | hi | 11 regional (13 languages total, bilingual at specified centres) | NTA JEE Main 2026 bulletin (PDF in search results, text unreadable); https://www.pw.live/iit-jee/exams/jee-main-exam-language-options | Secondary only. English prevails in discrepancy. 2026 cycle is over; 2027 language list not yet published. |
| UPSC CSE | en | hi | Compulsory Indian-language paper (qualifying) — candidate chooses from Indian languages | https://www.upsc.gov.in/examinations/Civil%20Services%20%28Preliminary%29%20Examination%2C%202026 (official page, medium line not in excerpt) | Secondary only for medium. Medium is English or Hindi; both papers offered in both. |
| SSC CGL | en | hi | None | https://ssc.gov.in (notification not opened); reports cite it | Secondary only. Bilingual, except English Comprehension section which is English only. |
| RRB NTPC | en | hi | Regional options: up to 13 regional languages (state-wise), per 2019 CRP RRB VIII policy | https://www.taxtmi.com/news?id=21576 (2019 policy notice) | Secondary only for the 2026 notification. The 2019 policy is official-type text, but NTPC 2026 notice not opened. |
| CBSE Class 9–10 | per subject (see CEO table) | per subject | Schools must offer at least one Indian language as medium from preparatory to Class 12 | https://organiser.org/2026/04/04/347020/bharat/cbse-mandates-three-language-rule-for-class-10-boards-by-2031-board-will-now-cover-all-22-languages/amp/ (news); CBSE circular not opened | CEO decision for subject split. Medium rule is secondary only. |
| CBSE Class 11–12 | en | hi | Schools must offer at least one Indian language as medium | https://www.selfstudys.com/books/cbse-syllabus/english/12th/11th/2678 (secondary); CBSE Notification 40/2026 is official but excerpt does not show medium | Secondary only. Answers cannot mix English and Hindi. **Needs CEO call on primary.** |
| UPPSC (PCS) | hi | en | None | https://uppsc.up.nic.in (official site listed; notification not opened) | Secondary only. Prelims bilingual (Hindi and English); Mains in Hindi or English; Hindi proficiency mandatory for eligibility. **Primary chosen as Hindi because it is the state exam; CEO to confirm.** |
| BPSC (72nd CCE) | hi | en | None | https://bpsc.bihar.gov.in (notification not opened); reports cite it | Secondary only. Prelims in Hindi and English; Mains in English or Hindi (candidate's choice); General Hindi is qualifying. **Primary chosen as Hindi; CEO to confirm.** |

## Points that need a human decision
1. **CBSE Class 11–12 primary**: English or Hindi? Set as English here; not decided.
2. **UPPSC and BPSC primary**: set as Hindi because these are state exams. Confirm.
3. **NEET primary is English**: notification says English is final in translation disputes. Confirm this is the right base for the writer.
4. **Which regional languages to cover later**: we currently cover English and Hindi only. Regional languages are listed for reference, not planned.

## Class 9–10 subject split (CEO decision, Nov 2026)

| Subject | Primary | Secondary |
|---|---|---|
| Science (Physics, Chemistry, Biology) | en | hi |
| Mathematics | en | hi |
| Social Science (History, Geography, Polity, Economics) | hi | en |
| English (as subject) | en | — |
| Hindi (as subject) | hi | — |

Reason given: formulas are standard in English in Science/Maths; Social Science is natural in Hindi. Both versions are stored and the app filters by the student's chosen language. Goes into `mtb.chapter_language_policy` (0167), one row per chapter and level.

## Limits of this research
- Most sources are coaching or news sites. Official PDFs were not downloaded; verify each row against the official notice before approval.
- JEE Main 2026 and NEET 2026 are past dates; the 2027 bulletins may change languages. Re-check when released.
- The `mtb.exams` table has more than the 9 rows above. Only those 9 were researched; the rest are not in this proposal.
- Student medium data was not checked (no users yet).

## Workflow once approved
1. Insert approved rows into `exam_language_policy` and `chapter_language_policy` (service role, separate data commit).
2. Writer writes in `primary_lang`; translator produces `secondary_lang`; QA checks both.
3. Only `status = approved` (or `approved = true`) drives content generation.

## Tests planned after approval
- NEET chapter 1 → English
- Class 9 chapter 1 (Science) → English primary, Hindi secondary
- UPSC chapter 1 → English and Hindi
