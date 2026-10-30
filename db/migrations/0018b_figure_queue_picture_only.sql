-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261023165845  name: 0018b_figure_queue_picture_only
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): aac44b5afd43063fe6d3fe376a3fee76

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
