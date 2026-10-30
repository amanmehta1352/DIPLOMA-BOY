-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261022101314  name: ntpc_prep_sources_kind_and_evidence
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): 73c855ea2617aa472df88147928d406d

create schema if not exists backup;
create table if not exists backup.ntpc_pre_sources_20261022 as select * from mtb.sources;
create table if not exists backup.ntpc_pre_exams_20261022 as select * from mtb.exams;
create table if not exists backup.ntpc_pre_subjects_20261022 as select * from mtb.subjects;
create table if not exists backup.ntpc_pre_aliases_20261022 as select * from mtb.subject_aliases;
alter table mtb.sources drop constraint if exists sources_kind_check;
alter table mtb.sources add constraint sources_kind_check check (kind = any (array['official_paper','official_answer_key','official_response_sheet','third_party_copy']));
alter table mtb.sources add column if not exists verification text;
alter table mtb.sources add column if not exists reuse_note text;
alter table mtb.sources add column if not exists host text;
select 1;
