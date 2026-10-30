# P3 — Repo ↔ DB migration drift: reconstruction plan (PLAN ONLY, no files created yet)

Source: `supabase list_migrations` (163 applied, 2026-10-30) vs `db/migrations/` (144 files). Raw diff: `migration_drift_raw.txt`.

## Findings
| Group | Count | Meaning |
|---|---|---|
| Matched by number | ~112 | Repo file number = DB entry number. Names differ only by prefix (`atoms_`, `foundation_`, `_batch`), so content is very likely identical. |
| Matched by name (no number in DB name) | 28 | 0067–0094 range applied with names without numbers. 24 are exact; **4 fuzzy pairs are probably mis-paired** (0074, 0075, 0076, 0077, 0087) and must be checked by content. |
| Applied in DB, no repo file | 23 | See list below. |
| Repo file, not in DB history | 4 | 0026, 0027 (never applied: objects absent), 0040 (applied live via SQL editor; its effects exist), 0149 (written, apply pending owner confirmation). |
| Same number, different migration | 2 | DB `0013_pattern_apply` vs repo `0013_question_reports.sql` (repo file actually matches DB `question_reports`); DB `0038/0039_batch1b/1c` vs repo `batch2/batch3`. |

### Applied in DB with no repo file (23)
`import_pyq_rpc`, `import_practice_rpc`, `ntpc_prep_sources_kind_and_evidence`, `ntpc_mixed_subject_and_aliases`, `ntpc_exam_pattern_and_sections`, `0013_pattern_apply`, `0014b_publish_problems_array_fix`, `0014c_questions_hash_index`, `0014d_audit_actor_and_verify_fields`, `0015b_verify_nightly_service_role`, `0015c_health_reports_7d`, `0015d_verify_backup_wrapper`, `0017b_publish_robot_guard`, `0018b_figure_queue_picture_only`, `0019b_report_global_caps`, `0020b_quality_english_missing`, `0021_question_attributes`, `0022_filter_questions`, `0023_refresh_question_attributes`, `0024_question_sets`, `0024b_question_sets_min10`, `backup_snapshot_2026_10_30`, `backup_snapshot_v2_pre_mission`.
(`question_reports` is covered by repo `0013_question_reports.sql`.)

## Reconstruction plan (needs approval before any file is written)
1. **Source of truth = live DB.** Supabase stores each applied migration's SQL in `supabase_migrations.schema_migrations.statements`. Read the 23 missing entries from there (read-only query) — no guessing.
2. Write each as a file using a free suffix so existing numbers never change:
   - `0013a_pattern_apply.sql`, `0014b_…`, `0014c_…`, `0014d_…`, `0015b/c/d_…`, `0017b_…`, `0018b_…`, `0019b_…`, `0020b_…`, `0021_…`–`0024b_…`
   - NTPC/RPC ones (no number) → `0005a_import_pyq_rpc.sql`, `0005b_import_practice_rpc.sql`, `0013b/c/d_ntpc_…` (placed by applied timestamp order).
   - Backup snapshots → `0112a_backup_snapshot_2026_10_30.sql`, `0118a_backup_snapshot_v2_pre_mission.sql`.
   Each file gets a header: `-- Reconstructed from supabase_migrations.schema_migrations version <ts>; already applied — do not re-run.`
3. Mark repo-only files: add a header note to 0026/0027 (`NOT APPLIED — pending decision`) and 0040 (`applied live, not via migration tool`). No deletion.
4. Verify the 5 fuzzy pairs (0074–0077, 0087) by comparing file text with stored `statements`; fix pairing only in the drift report, not by renaming applied files.
5. Add `docs/review/migration_index.md`: one row per DB version ↔ repo file.
6. Going forward: every change goes through a numbered file + `apply_migration` with the **same** name (e.g. name `0150_…`), so the two lists stay 1:1.

Rows changed in DB by this plan: **0** (read-only queries + new repo files only).
