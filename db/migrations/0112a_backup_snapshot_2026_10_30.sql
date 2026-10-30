-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261030114225  name: backup_snapshot_2026_10_30
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): 33b4cae1784175ddd3ed7a29c3537909

CREATE SCHEMA IF NOT EXISTS backup_2026_10_30;
CREATE TABLE backup_2026_10_30.atoms AS SELECT * FROM mtb.atoms WHERE status='published' AND NOT archived;
CREATE TABLE backup_2026_10_30.exams AS SELECT * FROM mtb.exams;
CREATE TABLE backup_2026_10_30.content_levels AS SELECT * FROM mtb.content_levels;
