-- Applied to the server on 2026-10-31 (migration 0158_solution_items). Additive only.
-- Step-by-step solved questions (owner's "masterclass" solution format).
create table if not exists mtb.solution_plans (
  level_id text not null,
  chapter_id integer not null,
  plan jsonb not null,               -- {"fit":true,"topics":[{"key","en","hi","types":[{"key","en","hi"}]}]}
  model text,
  updated_at timestamptz not null default now(),
  primary key (level_id, chapter_id)
);
alter table mtb.solution_plans enable row level security;

create table if not exists mtb.solution_items (
  id bigserial primary key,
  level_id text not null,
  chapter_id integer not null,
  slot integer not null,
  topic_key text not null,
  type_key text not null,
  difficulty smallint check (difficulty between 1 and 3),
  status text not null default 'draft' check (status in ('draft','rejected','approved')),
  data jsonb not null,
  checks jsonb not null default '{}'::jsonb,
  model text,
  attempts integer not null default 1,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (level_id, chapter_id, slot)
);
alter table mtb.solution_items enable row level security;

create or replace function mtb._is_service()
returns boolean language sql stable set search_path = mtb, pg_temp as $$
  select coalesce(nullif(current_setting('request.jwt.claims', true), '')::json->>'role', '') = 'service_role';
$$;

-- robot: save plan / item, read what exists (service role only). Approved items are never overwritten.
create or replace function mtb.solution_plan_save(p jsonb)
returns text language plpgsql security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._is_service() then raise exception 'not allowed'; end if;
  insert into mtb.solution_plans(level_id, chapter_id, plan, model)
  values (p->>'level_id', (p->>'chapter_id')::int, p->'plan', p->>'model')
  on conflict (level_id, chapter_id) do update set plan = excluded.plan, model = excluded.model, updated_at = now();
  return 'ok';
end $$;

create or replace function mtb.solution_save(p jsonb)
returns text language plpgsql security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._is_service() then raise exception 'not allowed'; end if;
  insert into mtb.solution_items as s (level_id, chapter_id, slot, topic_key, type_key, difficulty, status, data, checks, model)
  values (p->>'level_id', (p->>'chapter_id')::int, (p->>'slot')::int, p->>'topic_key', p->>'type_key',
          nullif(p->>'difficulty','')::smallint, coalesce(p->>'status','draft'), p->'data', coalesce(p->'checks','{}'::jsonb), p->>'model')
  on conflict (level_id, chapter_id, slot) do update
    set topic_key = excluded.topic_key, type_key = excluded.type_key, difficulty = excluded.difficulty, status = excluded.status,
        data = excluded.data, checks = excluded.checks, model = excluded.model, attempts = s.attempts + 1, updated_at = now()
    where s.status <> 'approved';
  return 'ok';
end $$;

create or replace function mtb.solution_status()
returns table(level_id text, chapter_id integer, slot integer, status text, attempts integer, has_plan boolean)
language plpgsql security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._is_service() then raise exception 'not allowed'; end if;
  return query
    select p.level_id, p.chapter_id, s.slot, s.status, s.attempts, true
    from mtb.solution_plans p left join mtb.solution_items s on s.level_id = p.level_id and s.chapter_id = p.chapter_id;
end $$;

create or replace function mtb.solution_plan_get(p_level text, p_chapter integer)
returns jsonb language plpgsql security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._is_service() then raise exception 'not allowed'; end if;
  return (select plan from mtb.solution_plans where level_id = p_level and chapter_id = p_chapter);
end $$;

-- students: approved only
create or replace function mtb.get_chapter_solutions(p_level text, p_chapter integer)
returns jsonb language sql stable security definer set search_path = mtb, pg_temp as $$
  select coalesce(jsonb_agg(jsonb_build_object('slot', slot, 'data', data) order by slot), '[]'::jsonb)
  from mtb.solution_items where level_id = p_level and chapter_id = p_chapter and status = 'approved';
$$;

-- which chapters of a level have approved solutions (for the "✍️" button)
create or replace function mtb.get_level_solution_counts(p_level text)
returns jsonb language sql stable security definer set search_path = mtb, pg_temp as $$
  select coalesce(jsonb_object_agg(chapter_id::text, n), '{}'::jsonb)
  from (select chapter_id, count(*) n from mtb.solution_items where level_id = p_level and status = 'approved' group by chapter_id) t;
$$;

-- owner review (drafts too), with the review code
create or replace function mtb.solution_review_get(p_level text, p_chapter integer, p_code text)
returns jsonb language plpgsql stable security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  return (select coalesce(jsonb_agg(jsonb_build_object('slot', slot, 'status', status, 'checks', checks, 'model', model, 'data', data) order by slot), '[]'::jsonb)
          from mtb.solution_items where level_id = p_level and chapter_id = p_chapter and status <> 'rejected');
end $$;

create or replace function mtb.solution_review_counts(p_level text, p_code text)
returns jsonb language plpgsql stable security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  return (select coalesce(jsonb_object_agg(chapter_id::text, n), '{}'::jsonb)
          from (select chapter_id, count(*) n from mtb.solution_items where level_id = p_level and status <> 'rejected' group by chapter_id) t);
end $$;
