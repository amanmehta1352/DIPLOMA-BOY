-- 0162_pgcron_scheduler: reliable schedule. Supabase pg_cron starts the GitHub robots (GitHub's own cron runs late or skips).
-- Additive only. The GitHub token is kept in Supabase Vault under the name 'github_actions_token' (fine-grained, this repo only,
-- Actions: read and write). It is never stored in a table, never returned, never printed.
create extension if not exists pg_net;

create table if not exists mtb.cron_log (
  id bigint generated always as identity primary key,
  at timestamptz not null default now(),
  workflow text not null,
  status text not null,          -- sent | no_token | error
  request_id bigint,
  detail text
);
alter table mtb.cron_log enable row level security;   -- no policies: service role / SQL only

create or replace function mtb.gh_dispatch(p_workflow text, p_inputs jsonb default '{}'::jsonb)
returns text language plpgsql security definer set search_path = mtb, pg_temp as $$
declare tok text; rid bigint;
begin
  if p_workflow !~ '^[a-z0-9-]+\.yml$' then raise exception 'bad workflow name'; end if;
  select decrypted_secret into tok from vault.decrypted_secrets where name = 'github_actions_token' limit 1;
  if tok is null or length(tok) < 20 then
    insert into mtb.cron_log (workflow, status, detail) values (p_workflow, 'no_token', 'Vault secret github_actions_token is missing');
    return 'no_token';
  end if;
  select net.http_post(
    url := 'https://api.github.com/repos/amanmehta1352/DIPLOMA-BOY/actions/workflows/' || p_workflow || '/dispatches',
    headers := jsonb_build_object('Authorization', 'Bearer ' || tok, 'Accept', 'application/vnd.github+json',
                                  'User-Agent', 'diploma-boy-pgcron', 'X-GitHub-Api-Version', '2022-11-28', 'Content-Type', 'application/json'),
    body := jsonb_build_object('ref', 'main', 'inputs', coalesce(p_inputs, '{}'::jsonb))
  ) into rid;
  insert into mtb.cron_log (workflow, status, request_id) values (p_workflow, 'sent', rid);
  return 'sent';
exception when others then
  insert into mtb.cron_log (workflow, status, detail) values (p_workflow, 'error', left(sqlerrm, 300));
  return 'error';
end $$;
revoke all on function mtb.gh_dispatch(text, jsonb) from public, anon, authenticated;

-- Results: GitHub answers 204 when it accepted the run. Readable by the Health robot (service role).
create or replace function mtb.cron_status(p_hours integer default 24)
returns jsonb language sql stable security definer set search_path = mtb, pg_temp as $$
  select coalesce(jsonb_agg(jsonb_build_object('at', l.at, 'workflow', l.workflow, 'status', l.status,
         'http', r.status_code) order by l.at desc), '[]'::jsonb)
  from mtb.cron_log l left join net._http_response r on r.id = l.request_id
  where l.at > now() - make_interval(hours => p_hours);
$$;
revoke all on function mtb.cron_status(integer) from public, anon, authenticated;

-- Schedule (UTC). IST = UTC + 5:30.
select cron.schedule('db-dispatcher', '*/15 * * * *', $$select mtb.gh_dispatch('dispatcher.yml')$$);
select cron.schedule('db-health', '17 */2 * * *', $$select mtb.gh_dispatch('health-robot.yml')$$);
select cron.schedule('db-daily-backup', '41 20 * * *', $$select mtb.gh_dispatch('daily-backup.yml')$$);   -- 02:11 IST
select cron.schedule('db-writer', '31 22 * * *', $$select mtb.gh_dispatch('writer-robot.yml', '{"count":"3","level":""}')$$);  -- 04:01 IST
select cron.schedule('db-solver', '11 23 * * *', $$select mtb.gh_dispatch('solver-robot.yml', '{"count":"10","level":"govt_technical"}')$$);  -- 04:41 IST
select cron.schedule('db-syllabus', '23 3 * * *', $$select mtb.gh_dispatch('syllabus-watch.yml')$$);   -- 08:53 IST
select cron.schedule('db-full-backup', '3 21 * * 0', $$select mtb.gh_dispatch('backup-drafts.yml')$$);  -- Mon 02:33 IST

-- Health robot reads the schedule results.
grant execute on function mtb.cron_status(integer) to service_role;
grant select on mtb.cron_log to service_role;
