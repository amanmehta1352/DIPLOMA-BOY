-- 0164: keep GitHub's answer for the full status window (pg_net drops responses after about 6 hours),
-- and mark Writer/Solver starts from Supabase (source = pgcron) so the workflow guard runs only the first start in 6 hours.
alter table mtb.cron_log add column if not exists http_status integer;

create or replace function mtb.cron_collect()
returns integer language plpgsql security definer set search_path = mtb, pg_temp as $$
declare n integer;
begin
  update mtb.cron_log l set http_status = r.status_code
  from net._http_response r where r.id = l.request_id and l.http_status is null and r.status_code is not null;
  get diagnostics n = row_count;
  return n;
end $$;
revoke all on function mtb.cron_collect() from public, anon, authenticated;

create or replace function mtb.cron_status(p_hours integer default 24)
returns jsonb language sql stable security definer set search_path = mtb, pg_temp as $$
  select coalesce(jsonb_agg(jsonb_build_object('at', l.at, 'workflow', l.workflow, 'status', l.status,
         'http', coalesce(l.http_status, r.status_code)) order by l.at desc), '[]'::jsonb)
  from mtb.cron_log l left join net._http_response r on r.id = l.request_id
  where l.at > now() - make_interval(hours => p_hours);
$$;
revoke all on function mtb.cron_status(integer) from public, anon, authenticated;
grant execute on function mtb.cron_status(integer) to service_role;

select cron.schedule('db-cron-collect', '*/10 * * * *', $$select mtb.cron_collect()$$);
select cron.schedule('db-writer', '31 22 * * *', $$select mtb.gh_dispatch('writer-robot.yml', '{"count":"3","level":"","source":"pgcron"}')$$);
select cron.schedule('db-solver', '11 23 * * *', $$select mtb.gh_dispatch('solver-robot.yml', '{"count":"10","level":"govt_technical","source":"pgcron"}')$$);
