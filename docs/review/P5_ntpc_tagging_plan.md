# P5 — NTPC untagged questions: classification plan (NO UPDATE DONE)

## Current state (2026-10-30)
- 775 questions sit in subject `ntpc-mixed` (id 15), all on inbox topic 1028, `chapter_id` NULL.
- Status: **238 published**, **520 hidden** (510 of them have figures), **17 draft** (all with figures).
- 64 have an empty English stem (Hindi only); several Hindi stems are OCR-garbled.
- Convention elsewhere: in maths/reasoning/GS/GA, 15,793 of 19,523 questions have `topic_id = chapter_id`.

## Sample mapping
`P5_ntpc_sample_50.csv` — first 50 questions by id:
- reasoning 19 · general-awareness 18 · maths 13
- confidence: high 39 · medium 10 · low 1 · flagged 11 (garbled Hindi, empty English, figure, or ambiguous chapter)
- 13 of 50 are Current Affairs (416) — dated content; may need an expiry/"as of" label.

## Plan
1. **Rules first, then judgement.** Keyword rules for clear patterns (floors/sitting → 429, "code language" → 426, "%" → 1, LCM/HCF → 10, census/monsoon → 418, year-dated events → 416). Remaining questions are classified one by one from the full stem + options.
2. Output a CSV for all 775: `question_id, proposed_chapter_id, confidence, flag`. You review medium/low and flagged rows.
3. **Update, after approval only**, in batches of ~100, published questions first:
   `update mtb.questions set topic_id = <chapter>, chapter_id = <chapter>, updated_at = now() where id = any(<ids>) and topic_id = 1028;`
   - Before each batch: copy the affected rows to the backup schema.
   - `status` is not changed. Hidden/draft questions stay hidden.
   - The audit trigger (`trg_audit_questions`) logs every change.
4. Verify after each batch: remaining count on topic 1028, count per new chapter, and `refresh_question_attributes()` / `build_question_sets()` if those are needed for the app filters.
5. Flagged questions (garbled Hindi, empty English) stay on 1028 until text is fixed.

Side finding: 2,753 non-NTPC questions in maths/reasoning/GS/GA also have `chapter_id` NULL. Not in scope; noted for later.
