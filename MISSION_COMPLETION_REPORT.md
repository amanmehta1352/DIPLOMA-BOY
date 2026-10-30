# Diploma Boy — Content DB Mission Report

Branch: `content-fill-database` (not merged to main). Supabase project `wobmtlcpszcntczkebtt`, schema `mtb`.
Status: **Mostly complete, with 3 open items that need a decision (see below).**

## Totals
- Active published atoms: **3,925** (count after migration 0146; the count before migration 0119 is not recorded in the repo, so the starting baseline is not stated here)
- Atoms with `level_id` NULL: **96** (flagged, not modified, not deleted)
- NULL `content_hash`, `subject_tag`, `difficulty`, `lang` among active atoms: **0**

## Migrations in this mission (0119 onward)
| Range | Content |
|---|---|
| 0119 | 19 subjects added |
| 0120 | 116 topics (chapters) added |
| 0121–0124 | Commerce: accountancy, business studies, economics-com, maths-com, advanced accountancy, cost/business/law |
| 0125–0135 | Class 11–12 commerce & arts, graduation arts, law/management |
| 0136–0137 | Graduation science: physics 874–881, chemistry 885–888 |
| 0138–0139 | Graduation science: chemistry 889–900 |
| 0140–0143 | Graduation science: biology 901–920 (incl. 919 Biology: Other, 920 Environment) |
| 0144 | Graduation science: physics 882–884 |
| 0145 | Advanced research: thermodynamics (441) missing MCQ |
| 0146 | Formula atom added to 4 chapters that had only 3 atoms (419, 417, 38, 431) |

## Quality checks
- Every migration verified by chapter-wise atom count (4 per chapter) and total count after apply.
- Insert uses `on conflict do nothing`, so re-runs are safe.
- No deletions. No edits to `index.html` or app code. No merge to `main`.

## Open items (need your decision)
1. **Chapters with 5 atoms (over by one), 8 in total:** banking 1, class_11_12_sci 886, engineering 872, govt_defence 9, medical 908. Left as they are, since the mission says not to delete. Tell me if you want an archive step.
2. **Advanced research scope:** only 3 chapters (872, 873, 441) have atoms at this level, and the older `gap_fill_progress.json` marks `advanced_research` as out of the fill scope. I could not confirm from the repo that the mission requires more chapters here. Please confirm the expected list.
3. **Old progress file is stale:** `gap_fill_progress.json` was not updated for migrations 0119 onward. This report is the authoritative record.

## Human-review caveat
Graduation science and advanced content was written from general knowledge, not from a source book. Please review a sample before publishing.

## Backup
Take a fresh export from the Supabase dashboard before any further changes.

## Verification update (2026-10-30, after report)
- Snapshot checksum (published, not archived): 3,925 rows, md5 `e0af8d47499a7aab0b2d97edab3876b5`, taken 2026-10-30 16:43:50 UTC. This is a fingerprint, not a full JSON backup. A full export still needs to be taken from the Supabase dashboard or via `backups/export_atoms_by_level.sh` with DB_URL.
- Structure: across 18 levels, 956 chapter-level pairs. Every pair has exactly 4 text atoms (concept, formula, example, mcq).
- The 5 chapters with 5 atoms (banking 1, class_11_12_sci 886, engineering 872, govt_defence 9, medical 908) have a 5th atom of type `svg`. This is a diagram, not a defect. No change needed.
- The 96 NULL-level atoms are all `svg` diagrams attached to chapters. They look intentionally shared across levels. Not assigned; awaiting owner decision.
- Content review: formulas in the atoms written for graduation science (874–920) and advanced_research (441) were spot-checked for arithmetic and equation correctness. Source verification is still pending. Medical, law and engineering atoms have not been individually reviewed.
- Open decisions for the owner: (1) backup/export, (2) NULL-level svg handling, (3) advanced_research scope, (4) content source review.
