-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261030121340  name: backup_snapshot_v2_pre_mission
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): db432e81aebe94e6777b799e5474ace0

create schema if not exists backup_2026_10_30_v2;
create table backup_2026_10_30_v2.atoms as select * from mtb.atoms;
create table backup_2026_10_30_v2.topics as select * from mtb.topics;
create table backup_2026_10_30_v2.subjects as select * from mtb.subjects;
create table backup_2026_10_30_v2.content_levels as select * from mtb.content_levels;
