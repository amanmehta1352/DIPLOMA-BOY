# P4 — NULL level_id atoms: proposal (NO UPDATE DONE)

- Count: **96** published, non-archived atoms with `level_id IS NULL` (not 98). All are `atom_type = 'svg'` (chapter diagrams).
- Per-atom table: `P4_null_level_atoms_proposal.csv` (atom_id, chapter_id, subject, levels using that chapter, proposed level, reason). Chapter names and titles: see the query in this doc's history or `mtb.topics`.
- **Design check:** `index.html` line 369 loads atoms with `level_id.eq.<level>` **or** `level_id.is.null`, and the unique index `atoms_one_per_level` uses `COALESCE(level_id,'*')`. So NULL means "shared by every level that has this chapter". This is intentional.

## Proposal
| Group | Atoms | Proposed |
|---|---|---|
| Chapter used by 2–12 levels | 94 | **Keep NULL.** Setting one level would remove the diagram from the other levels. |
| Chapter used by 1 level (401, 402 → govt_technical) | 2 (921, 926) | Optional: set `govt_technical`. No visible change today. |

If you still want per-level rows, the safe way is **copy, not move**: insert one copy per level (94 atoms × their level counts ≈ 870 new rows) and leave the shared row. That needs your approval and is not recommended.

Rows changed: **0**. Remaining NULL: **96**.
