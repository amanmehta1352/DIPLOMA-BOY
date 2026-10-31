-- 0159_robot_commands: owner's command queue for robots (Phase 1, CEO command system). Additive only.
-- Control Room -> cmd_submit (owner review code) -> mtb.robot_commands (queued)
-- Dispatcher robot (GitHub Actions, service role) starts the matching workflow, tracks the run, stores the result.
-- No secret is ever stored here. Students never see this table (RLS on, no policies).

create table if not exists mtb.robot_commands (
  id            bigint generated always as identity primary key,
  robot         text not null check (robot ~ '^[a-z_]{2,30}$'),
  args          jsonb not null default '{}'::jsonb check (jsonb_typeof(args) = 'object'),
  note          text check (note is null or length(note) <= 500),
  status        text not null default 'queued' check (status in ('queued','running','done','failed','cancelled')),
  created_at    timestamptz not null default now(),
  dispatched_at timestamptz,
  finished_at   timestamptz,
  workflow      text,
  run_id        bigint,
  run_url       text,
  conclusion    text,
  report        text,
  error         text
);
create index if not exists robot_commands_status_idx on mtb.robot_commands (status, id);
alter table mtb.robot_commands enable row level security;

-- Robots the owner may start from the Control Room. A new robot = add its key here + in robots/dispatcher/robots.json.
create or replace function mtb._cmd_robot_ok(p_robot text)
returns boolean language sql immutable as $$
  select p_robot = any (array['writer','solver','health','backup','pattern','tests']);
$$;

create or replace function mtb.cmd_submit(p_code text, p_robot text, p_args jsonb default '{}'::jsonb, p_note text default null)
returns bigint language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
declare v_id bigint;
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  if not mtb._cmd_robot_ok(p_robot) then raise exception 'unknown robot'; end if;
  if p_args is null or jsonb_typeof(p_args) <> 'object' or length(p_args::text) > 2000 then raise exception 'bad args'; end if;
  if (select count(*) from mtb.robot_commands where status in ('queued','running')) >= 20 then raise exception 'queue full'; end if;
  insert into mtb.robot_commands (robot, args, note) values (p_robot, p_args, left(p_note, 500)) returning id into v_id;
  return v_id;
end $$;

create or replace function mtb.cmd_list(p_code text, p_limit integer default 30)
returns jsonb language plpgsql stable security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  return (select coalesce(jsonb_agg(to_jsonb(t) order by t.id desc), '[]'::jsonb) from (
    select id, robot, args, note, status, created_at, dispatched_at, finished_at, run_url, conclusion, error,
           left(report, 6000) as report
    from mtb.robot_commands order by id desc limit least(greatest(coalesce(p_limit, 30), 1), 100)) t);
end $$;

create or replace function mtb.cmd_cancel(p_code text, p_id bigint)
returns boolean language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  update mtb.robot_commands set status = 'cancelled', finished_at = now() where id = p_id and status = 'queued';
  return found;
end $$;

-- Dispatcher robot (service role only): read open commands, update one command.
create or replace function mtb.cmd_open()
returns jsonb language plpgsql stable security definer set search_path = mtb, pg_temp as $$
declare claims json := nullif(current_setting('request.jwt.claims', true), '')::json;
begin
  if coalesce(claims->>'role', '') <> 'service_role' then raise exception 'not allowed'; end if;
  return (select coalesce(jsonb_agg(to_jsonb(c) order by c.id), '[]'::jsonb) from (
    select id, robot, args, status, created_at, dispatched_at, workflow, run_id from mtb.robot_commands
    where status in ('queued','running') order by id limit 50) c);
end $$;

create or replace function mtb.cmd_set(p_id bigint, p jsonb)
returns text language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
declare claims json := nullif(current_setting('request.jwt.claims', true), '')::json;
begin
  if coalesce(claims->>'role', '') <> 'service_role' then raise exception 'not allowed'; end if;
  update mtb.robot_commands set
    status        = coalesce(p->>'status', status),
    dispatched_at = coalesce((p->>'dispatched_at')::timestamptz, dispatched_at),
    finished_at   = coalesce((p->>'finished_at')::timestamptz, finished_at),
    workflow      = coalesce(p->>'workflow', workflow),
    run_id        = coalesce((p->>'run_id')::bigint, run_id),
    run_url       = coalesce(p->>'run_url', run_url),
    conclusion    = coalesce(p->>'conclusion', conclusion),
    report        = coalesce(left(p->>'report', 20000), report),
    error         = coalesce(left(p->>'error', 1000), error)
  where id = p_id;
  return case when found then 'ok' else 'missing' end;
end $$;
