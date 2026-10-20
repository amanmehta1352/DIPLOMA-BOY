# Diploma Boy

Diploma-level exam prep (RRB JE, SSC JE, …). Official PYQ only. Hindi + English.
- App: `index.html` (one file, GitHub Pages). Data: Supabase project "Diploma Boy", schema `mtb` (publishable key only in the app).
- Grow by data: a new exam / branch / subject / topic / paper = rows in `mtb.*`. The app reads them; no code change.
- Database changes: add a new file in `db/migrations/` (additive only, never DROP/DELETE).
- Three views of one data source: विषय (chapter-wise, PYQ + Practice), PYQ (official papers + mock), Practice (our own questions). Every question has `chapter_id` (migration 0003).
- Test: `mkdir -p tests/shots && node tests/flow.test.js` (Playwright; phone 360/390 + tablet 820, light/dark).
- Plan and rules: `docs/FOUNDATION.md`.
