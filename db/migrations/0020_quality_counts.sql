-- 0020 Quality robot (R3), read-only: counts of draft questions by publish blocker. service_role only. No data changed.
create or replace function mtb.quality_counts() returns jsonb
language sql stable security definer set search_path = mtb, public as $$
with d as (select q.id, q.chapter_id, s.exam_id, mtb.publish_problems(q) pr
           from questions q left join sources s on s.id = q.source_id where q.status = 'draft')
select jsonb_build_object(
  'checked_at', now(),
  'drafts', (select count(*) from d),
  'ready', (select count(*) from d where cardinality(pr) = 0 and chapter_id is not null),
  'no_chapter', (select count(*) from d where chapter_id is null),
  'figure_wait', (select count(*) from d where 'figure_not_reviewed' = any(pr)),
  'no_hindi', (select count(*) from d where 'hindi_missing' = any(pr)),
  'wrong_language', (select count(*) from d where 'english_wrong_language' = any(pr)),
  'english_missing', (select count(*) from d where 'english_missing' = any(pr)),
  'no_answer_or_options', (select count(*) from d where 'answer' = any(pr) or 'options' = any(pr)),
  'duplicate', (select count(*) from d where 'duplicate_in_exam' = any(pr)));
$$;
revoke all on function mtb.quality_counts() from public, anon, authenticated;
grant execute on function mtb.quality_counts() to service_role;
