-- 0015 (S4): one read-only function for the Health Robot. COUNTS ONLY (the repo is public).
-- Callable only with the service role (robot). Additive.
create or replace function mtb.health_counts() returns jsonb
language sql stable security definer set search_path = mtb, public as $$
  with c as (
    select e.slug as exam, q.status, count(*) n
    from mtb.questions q left join mtb.sources s on s.id = q.source_id left join mtb.exams e on e.id = s.exam_id
    group by 1, 2),
  byx as (select coalesce(exam, 'practice') exam, jsonb_object_agg(status, n) v from c group by 1),
  fl as (select q.id, r from mtb.questions q, unnest(mtb.publish_problems(q)) r where q.status = 'published'),
  lastb as (select slot, taken_at from backup.nightly order by taken_at desc limit 1)
  select jsonb_build_object(
    'at', now(),
    'by_exam', (select coalesce(jsonb_object_agg(exam, v), '{}'::jsonb) from byx),
    'total', (select count(*) from mtb.questions),
    'published_failing_lock', (select count(distinct id) from fl),
    'published_failing_reasons', (select coalesce(jsonb_object_agg(r, n), '{}'::jsonb) from (select r, count(*) n from fl group by r) t),
    'draft_figure', (select count(*) from mtb.questions where status = 'draft' and stem ? 'img'),
    'published_picture', (select count(*) from mtb.questions where status = 'published' and stem ? 'img'),
    'published_in_inbox', (select count(*) from mtb.questions q join mtb.topics t on t.id = q.topic_id where q.status = 'published' and t.slug = 'inbox'),
    'audit_rows', (select count(*) from mtb.audit_log),
    'reports_7d', (select count(*) from mtb.question_reports where created_at > now() - interval '7 days'),
    'backup_last_at', (select taken_at from lastb),
    'backup_last_slot', (select slot from lastb));
$$;
revoke all on function mtb.health_counts() from public, anon, authenticated;
grant execute on function mtb.health_counts() to service_role;

-- the Health Robot (service role) may also run the backup read-back check
grant execute on function backup.verify_nightly(int) to service_role;
