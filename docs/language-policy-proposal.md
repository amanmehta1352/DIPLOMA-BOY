# Language policy — fixed standard (for CEO approval)

Status: **proposed.** No seed rows yet. Schema: `db/migrations/0166_exam_language_policy.sql`, `db/migrations/0167_chapter_language_policy.sql`.

## Fixed rules (no in-house overrides)
1. Every exam and board follows its own official medium. We do not add, remove or reorder languages.
2. `primary_lang` = the language the official notice lists first as the exam or board's default. `secondary_lang` = the next official option. Where the notice gives no order, both are listed in the order the notice prints them, and the row is marked `needs check`.
3. A row changes only when the official notice changes. Each row carries `source_url`.
4. Where a row is based on a secondary source (news or coaching site), it stays `proposed` until someone opens the official PDF.
5. Student medium (`use_student_medium`) stays FALSE until there are 1000+ users.

## Findings (1 Nov 2026)

| Exam / board | Official medium (from sources) | primary | secondary | Source | Verification |
|---|---|---|---|---|---|
| NEET UG | 13 languages: English, Hindi, Assamese, Bengali, Gujarati, Kannada, Malayalam, Marathi, Odia, Punjabi, Tamil, Telugu, Urdu. Hindi/regional get a bilingual booklet (language + English); English gets English only. English is final in translation disputes. | en | hi | NTA NEET UG 2026 bulletin (not opened); https://www.pw.live/news/neet-ug-2026-languages-list-nta-notification | Secondary only. **Conflicts with the belief that NEET is English-only; the bulletin decides.** |
| JEE Main | 13 languages; English at all centres, others at specified centres. English prevails. | en | hi | NTA JEE Main 2026 bulletin (not opened) | Secondary only. 2026 is past; 2027 bulletin pending. |
| UPSC CSE | English and Hindi (medium for papers). Plus a compulsory Indian-language qualifying paper. | en | hi | https://www.upsc.gov.in/examinations/Civil%20Services%20%28Preliminary%29%20Examination%2C%202026 (official page; medium line not in excerpt) | Official page seen; medium line not confirmed. |
| SSC CGL | English and Hindi, except English Comprehension (English only). | en | hi | ssc.gov.in notice (not opened) | Secondary only. |
| RRB NTPC | English, Hindi, plus regional options by state (policy from CRP RRB VIII, 2019). | en | hi | https://www.taxtmi.com/news?id=21576 | 2019 policy text seen; 2026 notice not opened. |
| CBSE Class 9–10 | English and Hindi as medium; schools must offer an Indian-language medium option. | en | hi | CBSE circular not opened; https://organiser.org/2026/04/04/347020/bharat/cbse-mandates-three-language-rule-for-class-10-boards-by-2031-board-will-now-cover-all-22-languages/amp/ (news) | Secondary only. |
| CBSE Class 11–12 | English and Hindi as medium; answers cannot mix the two. | en | hi | CBSE Notification 40/2026 (official, medium line not in excerpt) | Official notice exists; medium line not confirmed. |
| UPPSC (PCS) | Prelims in English and Hindi; Mains in Hindi or English; Hindi proficiency mandatory. | en | hi | https://uppsc.up.nic.in (not opened) | Secondary only. Order not stated in sources: `needs check`. |
| BPSC (72nd CCE) | Prelims in Hindi and English; Mains in English or Hindi (candidate's choice); General Hindi qualifying. | en | hi | https://bpsc.bihar.gov.in (not opened) | Secondary only. Order not stated: `needs check`. |

## What changed from the earlier draft
- **CBSE subject split removed.** The earlier CEO table (Social Science primary Hindi) is not an official CBSE rule. CBSE's default medium is English, with Hindi as the other option. The split can come back only if the CEO asks for it, and then it needs a source too.
- **UPPSC and BPSC primary changed from Hindi to English** to follow the order in the sources. Both are `needs check`.

## Robots (fixed plan)

| Robot | Job | Input | Output | Stops when |
|---|---|---|---|---|
| **language-policy-research** | Opens each official notice, finds the medium clause, writes or updates a policy row with `source_url`. Runs on new notices (similar to the existing syllabus-watch robot). | exam or board list | proposed rows + a diff for review | notice cannot be opened, or the medium clause is missing |
| **language-standard-check** | Before any content is published, compares the content's language with the policy row. Blocks publish on mismatch. Plugs into the existing publish gate (migration 0014). | content row, policy row | pass or block with reason | policy row not approved |
| **writer** (existing `robots/writer`) | Writes the item in `primary_lang` only. | approved policy row | draft in primary | policy missing |
| **translator** (existing Hindi/MT path, `robots/hindi`) | Produces `secondary_lang` from the approved primary text. | draft in primary | draft in secondary | translation fails key checks |
| **QA** (existing copyright and cross-check robots) | Checks both language versions for figures, terms and answer keys. | both drafts | pass or fix list | any mismatch |

Order: research → CEO approval → seed rows → writer → translator → QA → language-standard-check → publish.

## Open questions (only the CEO can decide)
1. Confirm each row against the official PDF before approval. The research robot's first run is the way to do this.
2. NEET: confirm the bulletin's language list. If it lists 13 options, the policy above stands.
3. CBSE 11–12: confirm the medium clause in Notification 40/2026.

## Tests after approval
- NEET chapter 1 → English primary, Hindi secondary
- Class 9 chapter 1 (Science) → English primary, Hindi secondary
- UPSC chapter 1 → English and Hindi
