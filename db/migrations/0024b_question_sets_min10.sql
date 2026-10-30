-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261024040332  name: 0024b_question_sets_min10
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): 71a15783fa7ee7bba79d3bd55081d618

create or replace function mtb.build_question_sets() returns jsonb
language plpgsql security definer set search_path = mtb, public as $$
declare run bigint := nextval('mtb.question_sets_run_seq'); n int;
begin
  -- pattern groups with >=10 live questions stay together (split every 20);
  -- smaller pattern groups and questions without pattern are pooled per chapter in id order (20 per set)
  with live as (
    select q.id, q.chapter_id, q.pattern_id,
      count(*) over (partition by q.chapter_id, q.pattern_id) psz
    from questions q where q.status='published' and q.chapter_id is not null),
  classed as (
    select id, chapter_id, pattern_id, psz,
      case when pattern_id is not null and psz >= 10 then 'pattern' else 'chapter_order' end kind,
      row_number() over (partition by chapter_id, pattern_id order by id) prn
    from live),
  numbered as (
    select id, chapter_id, kind,
      case when kind='pattern'
        then 1000000 + pattern_id*100 + ((prn-1)/20)
        else (row_number() over (partition by chapter_id, kind order by id) - 1)/20 end as set_key
    from classed)
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
