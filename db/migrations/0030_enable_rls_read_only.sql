-- 0030 Security: RLS on the 6 reference tables, read-only for the public (anon/authenticated) key. Additive only.
-- Live state before this (checked 2026-10-30): RLS OFF on exams, branches, exam_branches, subjects, topics, sources.
-- anon/authenticated already had SELECT only (no INSERT/UPDATE/DELETE grant), so writes were already denied by grants;
-- this adds row-level protection on top. Service role bypasses RLS (robots/import keep working).
-- Number note: 0005 is taken (nightly backup), so this is 0030.

alter table mtb.exams         enable row level security;
alter table mtb.branches      enable row level security;
alter table mtb.exam_branches enable row level security;
alter table mtb.subjects      enable row level security;
alter table mtb.topics        enable row level security;
alter table mtb.sources       enable row level security;

do $$ begin
  if not exists (select 1 from pg_policies where schemaname='mtb' and tablename='exams' and policyname='read_exams') then
    create policy read_exams on mtb.exams for select using (true); end if;
  if not exists (select 1 from pg_policies where schemaname='mtb' and tablename='branches' and policyname='read_branches') then
    create policy read_branches on mtb.branches for select using (true); end if;
  if not exists (select 1 from pg_policies where schemaname='mtb' and tablename='exam_branches' and policyname='read_exam_branches') then
    create policy read_exam_branches on mtb.exam_branches for select using (true); end if;
  if not exists (select 1 from pg_policies where schemaname='mtb' and tablename='subjects' and policyname='read_subjects') then
    create policy read_subjects on mtb.subjects for select using (true); end if;
  if not exists (select 1 from pg_policies where schemaname='mtb' and tablename='topics' and policyname='read_topics') then
    create policy read_topics on mtb.topics for select using (true); end if;
  if not exists (select 1 from pg_policies where schemaname='mtb' and tablename='sources' and policyname='read_sources') then
    create policy read_sources on mtb.sources for select using (true); end if;
end $$;
