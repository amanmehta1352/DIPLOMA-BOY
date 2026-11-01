# Build Plan — 22 Departments (Phase 1)

Stage: foundation. 0 users, 0 revenue, content thin (~13% of targets), free AI quotas.
Rule used: build what removes the owner's manual work on content now; leave everything that needs users or money.

| Dept | Decision | Robots to build | Effort | Depends on |
|---|---|---|---|---|
| CP Content | BUILD NOW | Schedule Writer + Solver (nightly, within quota); feed Writer from Planner gaps | Medium | Scheduler, Planner |
| QA | BUILD NOW | Wire Cross-check (OpenRouter) into drafts; auto-approve rules (code checks + 2 AIs agree + Hindi present); human review queue + 5 daily samples in Control Room | Medium | OpenRouter key ✅ |
| RI | BUILD NOW (finish) | Syllabus topic list per level cleaned; PYQ hunter = finish Import queue (17 in review, 5 scans) | Medium | — |
| DO | BUILD NOW (small) | Scheduled full backup (weekly) with downloadable artifact; export on command | Small | — |
| ID | BUILD NOW (small) | Quota/usage tracker (calls per day per key) shown in Control Room | Small | — |
| Scheduler | BUILD NOW | Daily chain: backup → planner → writer → QA → publish (if auto-approve on) → report | Medium | branch decision (schedules run only on main) |
| TL | LATER | English mode for atoms; glossary | Medium | QA wired |
| DU | LATER | a11y checks; style keeper | Small | app redesign |
| AT | LATER | Mock generator from question_sets | Medium | content |
| CL | LATER | Freshness/stale flags, version history | Small | 6+ months of content |
| TS | LATER | Correction log from question_reports | Small | users |
| AI | LATER | Usage, weakness | Medium | users |
| LC | LATER | Attribution per atom, notice handler | Small | launch |
| SEC | LATER | Basics exist (RLS, hashed code); pentest later | — | launch |
| PIE, PA, SC, CS, CO, GE | SKIP now | — | — | users |
| MG, SP, FA | SKIP now | — | — | launch / revenue |

## Targets (Phase 3, from the mission)
Class 6–8: 2/2/2 · Class 9–10: 3/3/3 · Class 11–12: 4/4/4 · NEET/JEE/UPSC: 5/5/5 (concepts/examples/MCQs per chapter).
Current planner file (`robots/planner/targets.json`, on main) uses 4/3/3/10/10 for every level; switch to the mission's numbers.

## Status against the mission phases
- Phase 2 Command system: ✅ built (on main). Registry/unified dashboard: partial.
- Phase 3 Coverage planner: ✅ built (on main); heat map drill-down missing; targets to update.
- Phase 4 Auto-verify: 🟡 cross-check works (26/30); not wired; auto-approve OFF.
- Phase 5 Scheduler: ❌ blocked by branch decision.
- Phase 6–7: not started.
