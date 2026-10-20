-- 0005 (applied 21 Oct 2026): nightly server-side backup, no secret keys needed.
-- Keeps 7 rolling copies (one per weekday) of questions, topics, sources and exams in backup.nightly.
create schema if not exists backup;
revoke all on schema backup from anon, authenticated;
create table if not exists backup.nightly (slot smallint primary key, taken_at timestamptz not null, questions jsonb, topics jsonb, sources jsonb, exams jsonb);
create or replace function backup.take_nightly() returns text language sql security definer set search_path = backup, mtb, public as $$
  insert into backup.nightly(slot, taken_at, questions, topics, sources, exams)
  select extract(dow from now())::smallint, now(),
    (select jsonb_agg(q) from mtb.questions q), (select jsonb_agg(t) from mtb.topics t),
    (select jsonb_agg(s) from mtb.sources s), (select jsonb_agg(e) from mtb.exams e)
  on conflict (slot) do update set taken_at = excluded.taken_at, questions = excluded.questions,
    topics = excluded.topics, sources = excluded.sources, exams = excluded.exams;
  select 'ok ' || now()::text;
$$;
revoke all on function backup.take_nightly() from public, anon, authenticated;
create extension if not exists pg_cron;
select cron.schedule('diploma-boy-nightly-backup', '7 21 * * *', 'select backup.take_nightly()'); -- 02:37 IST
