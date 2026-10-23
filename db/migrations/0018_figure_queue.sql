-- 0018 Figure robot (R4), read-only part: counts of picture questions by state. service_role only. No data changed.
-- Rule kept: nothing may publish a picture question unless stem.checks.fig_ok = 'true' (see mtb.publish_problems).
create or replace function mtb.figure_queue() returns jsonb
language sql stable security definer set search_path = mtb, public as $$
select jsonb_build_object(
  'checked_at', now(),
  'live_unreviewed', (select count(*) from questions q where q.status='published' and (q.stem ? 'img') and coalesce(q.stem->>'img','') <> ''
                        and coalesce(q.stem->'checks'->>'fig_ok','') <> 'true'),
  'draft_waiting', (select count(*) from questions q where q.status='draft' and (q.stem ? 'img') and coalesce(q.stem->>'img','') <> ''
                        and coalesce(q.stem->'checks'->>'fig_ok','') <> 'true'),
  'reviewed_ok', (select count(*) from questions q where q.stem->'checks'->>'fig_ok' = 'true' and (q.stem ? 'img') and coalesce(q.stem->>'img','') <> ''),
  'hidden_picture', (select count(*) from questions q where q.status='hidden' and (q.stem ? 'img') and coalesce(q.stem->>'img','') <> ''));
$$;
revoke all on function mtb.figure_queue() from public, anon, authenticated;
grant execute on function mtb.figure_queue() to service_role;
