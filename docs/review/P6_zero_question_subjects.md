# P6 — Subjects with 0 questions (NO DELETE)

22 subjects have no questions (counted through their topics):
computer-basics (8), environment (9), part-a-general-engineering-civil-structural (14), accountancy (16), business-studies (17), economics-com (18), maths-com (19), advanced-accountancy (20), business-law (21), cost-accounting (22), history (23), political-science (24), geography-arts (25), sociology (26), psychology (27), advanced-history (28), advanced-polity (29), advanced-geography (30), legal-reasoning (31), legal-aptitude (32), english-law (33), quant-law (34).

Note: ids 16–34 do have **notes (atoms)**; only practice questions are missing. 8, 9, 14 have neither questions nor their own chapters' atoms checked here.

## Proposal (UI only, no data deleted)
- Show a subject normally when it has notes, but on its **Practice** tab show "प्रश्न जल्द आ रहे हैं / Questions coming soon" instead of an empty list.
- Hide a subject from pickers only if it has **no notes and no questions** (candidates: 8, 9, 14 — confirm).
- Implementation idea (needs your approval + diff before any frontend change): one extra count in the existing subjects fetch, e.g. a view `mtb.subject_counts(subject_id, questions, atoms)` read-only, and a `comingSoon` flag in `index.html` rendering.
