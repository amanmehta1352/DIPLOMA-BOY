# Migration index (repo file ↔ production history), 2026-10-30

- Production history: `supabase_migrations.schema_migrations` (164 entries after 0150).
- 23 migrations that were applied but missing from the repo were **reconstructed byte-for-byte** from the stored statements (md5 verified for all 23), then given a free suffix so no existing number changed. Two of them (`0001a`, `0003a`) had an expired import-token literal redacted.

| Production name | Repo file |
|---|---|
| import_pyq_rpc | 0001a_import_pyq_rpc.sql |
| import_practice_rpc | 0003a_import_practice_rpc.sql |
| 0013_pattern_apply | 0013a_pattern_apply.sql |
| question_reports | 0013_question_reports.sql (existing) |
| ntpc_prep_sources_kind_and_evidence | 0013b_… |
| ntpc_mixed_subject_and_aliases | 0013c_… |
| ntpc_exam_pattern_and_sections | 0013d_… |
| 0014b / 0014c / 0014d / 0015b / 0015c / 0015d / 0017b / 0018b / 0019b / 0020b | same name .sql |
| 0021 / 0022 / 0023 / 0024 / 0024b | same name .sql |
| backup_snapshot_2026_10_30 | 0112a_backup_snapshot_2026_10_30.sql |
| backup_snapshot_v2_pre_mission | 0118a_backup_snapshot_v2_pre_mission.sql |
| foundation_000N_* / atoms_0NNN_* / unnumbered 0067–0094 names | matching numbered repo file |

## Special cases
- **0026, 0027** — in repo, **never applied** (objects absent). Marked NOT APPLIED in file header. Owner decision pending.
- **0040** — applied live via SQL editor; marked in header.
- **0149_security_fixes_advisors** — in repo, **not applied** (client auto-cancels permission changes). Owner runs it once in SQL Editor.
- Fuzzy pairs to double-check by content: 0074–0077, 0087 (names differ between repo and production).
