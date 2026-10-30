-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261024035627  name: 0024_question_sets
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): 7eae7fd897265342245209fb43bfafe8

create table if not exists mtb.question_sets (
  run_id bigint not null,
  question_id bigint not null references mtb.questions(id) on delete cascade,
  chapter_id int not null,
  set_no int not null,
  set_name text not null,
  set_size int not null,
  kind text not null,               -- 'pattern' or 'chapter_order'
  built_at timestamptz not null default now(),
  primary key (run_id, question_id)
);
alter table mtb.question_sets enable row level security;
revoke all on mtb.question_sets from anon, authenticated;
grant select, insert on mtb.question_sets to service_role;
create sequence if not exists mtb.question_sets_run_seq;

create or replace function mtb.build_question_sets() returns jsonb
language plpgsql security definer set search_path = mtb, public as $$
declare run bigint := nextval('mtb.question_sets_run_seq'); n int;
begin
  -- live questions only; pattern questions first (kept together), then the rest in chapter order; 20 per set at most
  with live as (
    select q.id, q.chapter_id, q.pattern_id, coalesce(q.pattern_n,0) pn
    from questions q where q.status='published' and q.chapter_id is not null),
  pat_sets as (
    select id, chapter_id, 'pattern' kind,
      dense_rank() over (partition by chapter_id order by pattern_id) pg, pattern_id,
      row_number() over (partition by chapter_id, pattern_id order by id) rn,
      count(*) over (partition by chapter_id, pattern_id) psz
    from live where pattern_id is not null),
  rest as (
    select id, chapter_id, 'chapter_order' kind, 0 pg, null::bigint pattern_id,
      row_number() over (partition by chapter_id order by id) rn, 0 psz
    from live where pattern_id is null),
  all_rows as (
    select id, chapter_id, kind, pg, rn, psz, pattern_id from pat_sets
    union all select id, chapter_id, kind, pg, rn, psz, pattern_id from rest),
  numbered as (
    select id, chapter_id, kind,
      -- pattern rows: one set per pattern (split every 20); rest rows: every 20 in chapter order
      case when kind='pattern' then 1000000 + pattern_id*100 + ((rn-1)/20) else (rn-1)/20 end as set_key,
      case when kind='pattern' then psz else 0 end as psz
    from all_rows)
  insert into question_sets (run_id, question_id, chapter_id, set_no, set_name, set_size, kind)
  select run, id, chapter_id, dense_rank() over (partition by chapter_id order by set_key),
         case when kind='pattern' then 'Pattern set' else 'Chapter set' end,
         count(*) over (partition by chapter_id, set_key), kind
  from numbered;
  get diagnostics n = row_count;
  return jsonb_build_object('run_id', run, 'rows', n);
end $$;
revoke all on function mtb.build_question_sets() from public, anon, authenticated;
grant execute on function mtb.build_question_sets() to service_role;
