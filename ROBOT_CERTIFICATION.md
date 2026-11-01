# Robot Certification (Phase 6) — 1 Nov 2026

"Certified" here means: ran without error on GitHub, produced the expected output, and the output was checked in the database or artifact. Every robot lives on `main` (scheduled workflows only run from `main`).

| Robot | Dept | Status | Evidence | Command Queue | Scheduled |
|---|---|---|---|---|---|
| Writer (Gemini) + second AI (OpenRouter DeepSeek) + Hindi check + auto-approve | CP / QA | ✅ Certified | 1 Nov run: Class 9–10 chapters 1 and 2 written, DeepSeek disagreed on 0 of 10 answers each, Hindi check passed, auto-approved; students now get them (`get_level_book_ids('class_9_10')` → [1, 2]) | ✅ | Daily 04:01 IST (3 chapters) |
| Solver (Gemini) | CP | 🟡 Runs, not auto-approved | 1 Nov run: 3 solution drafts saved; 5 earlier approved by hand. Second opinion is still Gemini; no auto-approve | ✅ | Daily 04:41 IST (10) |
| Cross-check (OpenRouter) | QA | ✅ Certified (review only) | 30 published PYQs: 26 agree (87%), 0 empty, 0 errors; 2 of the 4 disagreements were wrong answers in the DB (hidden by owner's go-ahead) | — | Manual |
| Publish gate + auto_approve_draft (DB) | QA | ✅ Certified | Approved only drafts with 0 problems and 0 disagreements (2 of 2 today) | — | via Writer |
| Dispatcher | DO | ✅ Certified | Started Health from a robot command; command #1 = done | ✅ (is the queue) | Every 15 min (GitHub ran it 3 times in 16 h) |
| Command queue + Control Room Command tab | DO | ✅ Certified | Migration 0159; wrong code rejected; student key cannot read the table; Control Room test passes | ✅ | — |
| Health robot (+ Coverage Planner inside) | ID / RI | ✅ Certified | status.json refreshed; errors {} on last run; coverage and syllabus sections present | ✅ | Every 2 h (GitHub ran it once on schedule; also after other robots) |
| Daily backup + keep-alive | ID | ✅ Certified | 10 scheduled runs, all success | ✅ | Daily 02:11 IST |
| Full backup (all questions) | DO | ✅ Certified | 21,197 rows; counts match the DB; file given to owner | — | Weekly, Monday 02:33 IST |
| Syllabus Watcher + Reader + Planner return | RI | ✅ Certified (manual runs) | NEET UG 2026 official PDF → 49 units; 6 coaching pages read; shared topics published; handed a command to Health | ✅ (sends commands) | Daily 08:53 IST — no scheduled run seen yet |
| Topic sample | CP | ✅ Runs (review only) | 5 notes for real topics, all passed structure check | — | Manual |
| Tests (CI) | DU | ✅ Certified | Required check `flow` passed on every PR today | — | On every PR/push |
| Import robot (PDF → questions) | DO | 🟡 Partial | Existing; 17 jobs in review, 5 failed (scanned PDFs need OCR) | — | Manual |
| Pattern rebuild | QA / DO | 🟡 Not re-run today | Existing; ran after imports earlier | ✅ | Manual |

## Not built (by plan)
TL (English mode), DU a11y, AT mock generator, CL, TS correction log, AI analytics, LC, SEC pentest — later. PIE, PA, SC, CS, CO, GE, MG, SP, FA — not needed at 0 users / 0 revenue.
