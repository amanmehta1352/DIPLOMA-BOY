# Audit Report — 22 Departments (Phase 0)

Date: 1 Nov 2026. Read-only audit. Repo `amanmehta1352/DIPLOMA-BOY`, Supabase project `wobmtlcpszcntczkebtt`, schema `mtb`.
Machine-readable copy: `audit_data.json`.

## 0. Branch situation (needs owner decision)
- `content-fill-database` (this branch) was last changed on 30 Oct. It is 132 commits ahead of `main` and 118 behind; 313 files differ.
- All automation built since then (Command queue, Dispatcher, Coverage Planner, Syllabus Watcher, Cross-check, full backup) is on **`main`**, not here.
- GitHub runs scheduled workflows **only from the default branch (`main`)**. Robots that live only on this branch can never run on a schedule.
- So "commit to content-fill-database, never merge to main" and "Phase 5 scheduler" cannot both hold. See "Decision needed" at the end.

## A. Repo structure (main)
- App: `index.html`, `level-book.html`, `solve.html`, `book.html` (single-file pages, GitHub Pages).
- Control Room: `control/` (index.html, cr.js, cmd.js, cr.css, apps.json), multi-app. Tabs: हाल, सवाल, Robots, Backup, Command.
- Robots: `robots/` → backup, cross, dispatcher, ecosystem, health, hindi, import, paper, planner, purge, sample, solver, syllabus, writer.
- Workflows: 20 (`.github/workflows/`). Scheduled: Dispatcher (every 15 min), Health (every 2 h), Daily backup (02:11 IST), Syllabus Watcher (08:53 IST). The other 16 are manual.
- DB: 35 tables in `mtb`; migrations 0001–0161 (additive, numbered).

## B. Robot inventory by department
Legend: ✅ exists and has run · 🟡 partial · ❌ missing

| # | Dept | Exists | Partial | Missing |
|---|---|---|---|---|
| 1 | CP Content | Writer (Gemini, writes chapter drafts), Solver (masterclass solutions) | Topic sample (review-only notes for syllabus topics); Example/MCQ are inside Writer | Translator for atoms (atoms are Hindi only), SVG designer |
| 2 | QA | Publish gate (DB function), structure checks in Writer/Solver, Gemini second opinion, duplicate check (content_hash + pattern groups), Cross-check via OpenRouter (DeepSeek) — 26/30 agree | Hindi sample (read-only), auto-approve gate (built, switched OFF) | Copyright checker, level checker, human review queue in Control Room |
| 3 | TL | — | Hindi machine translation inside Import robot (IndicTrans) | English version of atoms, glossary, consistency check |
| 4 | DU | Tests (phone 360/390, tablet 820, light/dark, tap size, overflow) | — | Style keeper, a11y audit beyond tap size |
| 5 | PIE | — | — | all (skip at 0 users) |
| 6 | AT | — | question_sets (36,620 rows) and books built by pattern/book tools | mock generator, scheduler, score analyzer |
| 7 | PA | — | — | all (needs users) |
| 8 | RI | Syllabus Watcher (daily; NEET official PDF → 49 units; 6 coaching pages), Coverage Planner | PYQ hunter = Import robot + import_jobs (17 in review, 5 failed scans) | vacancy tracker, book scanner, competitor watch |
| 9 | AI | Health counts | — | usage, weakness, A/B (needs users) |
| 10 | TS | question_reports table + report guard | — | correction log, attestation |
| 11 | LC | privacy, terms, delete-data pages | — | notice handler, attribution per atom |
| 12 | SEC | RLS on all tables, owner review code stored as hash, keys never printed | — | pentest, fraud |
| 13–16 | SC, CS, CO, GE | — | — | all (needs users) |
| 17 | CL | audit_log trigger on questions, content_hash | — | freshness, stale flag, version history |
| 18–19 | MG, SP | — | — | all (no product launch yet) |
| 20 | ID | Health robot, Daily backup + keep-alive, Tests, key checks (Gemini, OpenRouter) | — | cost/quota tracker; load balancer not needed |
| 21 | DO | Import robot, NTPC import/tag robots, Pattern rebuild, full backup workflow, migrations | purge backup | export to user (done by hand today) |
| 22 | FA | — | — | all (no revenue) |

## C. DB state
- Atoms (published, not archived): 3,925 (3,829 levelled + 96 shared SVG). By level: govt_technical 452, govt_basic 380, govt_defence 341, state_psc 340, class_9_10 296, upsc_civil 276, class_11_12_sci 257, class_6_8 252, graduation_sci 204, medical 193, engineering 185, banking 149, class_11_12_arts 148, class_11_12_com 132, law_management 84, graduation_arts 64, graduation_com 64, advanced_research 12.
- Chapters: all 956 chapters in `chapters.json` have atoms, but only about 4 each (1 concept, 1 formula, 1 example, 1 MCQ). Planner fill against targets: about 13% per level; 0 chapters full.
- Questions: 18,323 published, 2,873 hidden, 1 draft. Published with a solution: 1,814 (~10%).
- Robot drafts: chapter_drafts 3 approved; solution_items 5 approved.
- Users: 0 profiles.

## D. Integration state
- Command queue: ✅ `mtb.robot_commands` (migration 0159), owner-code RPCs.
- Dispatcher: ✅ every 15 min; evidence: 1 command completed end-to-end (Health, sent by the Syllabus Watcher).
- Robots hand work to each other: ✅ `cmd_enqueue_auto` (Syllabus Watcher → Health).
- Reports: Writer/Solver post to the command record (Control Room) **and** still to GitHub Issues. Health → status.json → Control Room.
- Robot registry: 🟡 Control Room "Robots" tab shows last run and result per workflow; no next-run time or success count yet.

## E. Infrastructure
- Keys present (checked by workflows, values never printed): GEMINI_API_KEY ✅, SUPABASE_SECRET_KEY ✅, OPENROUTER_API_KEY ✅ (models endpoint HTTP 200). No Claude/OpenAI/Groq key.
- Supabase reachable ✅. GitHub Actions ✅ (protected main: required check `flow`, review threads must be resolved).
- Gemini free quota runs out under load (HTTP 429 seen in topic sample).

## Integration gaps (what is broken or missing)
1. Writer and Solver have no schedule (manual only).
2. Auto-approve is OFF; no human review queue in Control Room.
3. Cross-check is review-only; it is not wired into the publish path.
4. Syllabus topic matching is word-based; missing counts are inflated (e.g. govt_technical ~1,000).
5. Branch conflict (section 0).

## Recommendation
Build now: CP (schedule + English), QA (wire cross-check, review queue), RI (finish), DO, ID (quota tracker), Scheduler. Later: TL, DU, AT, CL, TS, AI, LC, SEC. Skip for now: PIE, PA, SC, CS, CO, GE, MG, SP, FA.
