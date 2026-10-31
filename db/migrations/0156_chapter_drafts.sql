-- Applied to the server on 2026-10-31 (migration 0156_chapter_drafts). Additive only.
-- Deep chapter content written by the free-AI writer robot. Drafts only: nothing here is shown in the app.
create table if not exists mtb.chapter_drafts (
  id bigserial primary key,
  level_id text not null,
  chapter_id integer not null,
  status text not null default 'draft' check (status in ('draft','rejected','approved')),
  data jsonb not null,
  provider text,
  model text,
  checks jsonb not null default '{}'::jsonb,
  attempts integer not null default 1,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (level_id, chapter_id)
);
alter table mtb.chapter_drafts enable row level security;

-- Robot writes (service role only). An approved draft is never overwritten.
create or replace function mtb.draft_save(p jsonb)
returns text language plpgsql security definer set search_path = mtb, pg_temp as $$
declare claims json := nullif(current_setting('request.jwt.claims', true), '')::json;
begin
  if coalesce(claims->>'role', '') <> 'service_role' then raise exception 'not allowed'; end if;
  insert into mtb.chapter_drafts as d (level_id, chapter_id, status, data, provider, model, checks)
  values (p->>'level_id', (p->>'chapter_id')::int, coalesce(p->>'status','draft'), p->'data', p->>'provider', p->>'model', coalesce(p->'checks','{}'::jsonb))
  on conflict (level_id, chapter_id) do update
    set status = excluded.status, data = excluded.data, provider = excluded.provider, model = excluded.model,
        checks = excluded.checks, attempts = d.attempts + 1, updated_at = now()
    where d.status <> 'approved';
  return 'ok';
end $$;

-- Robot reads which chapters are already done (service role only).
create or replace function mtb.draft_status()
returns table(level_id text, chapter_id integer, status text, attempts integer)
language plpgsql security definer set search_path = mtb, pg_temp as $$
declare claims json := nullif(current_setting('request.jwt.claims', true), '')::json;
begin
  if coalesce(claims->>'role', '') <> 'service_role' then raise exception 'not allowed'; end if;
  return query select d.level_id, d.chapter_id, d.status, d.attempts from mtb.chapter_drafts d;
end $$;
