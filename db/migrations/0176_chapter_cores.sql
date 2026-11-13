-- 0176 chapter cores (docs/LIBRARY_ARCHITECTURE.md §3, §5, §10).
-- One verified core per chapter (schema/book.core.v1.json). Styles (saral, abhyas …) are built from it by code
-- (tools/book/render.js), so they need no table yet; chapter_styles comes only when a style needs AI-written extras.
-- Same owner gate as 0173: robots write drafts only, students see a core only after the owner approves it,
-- every change keeps the old copy, and the owner can roll back (as a draft).
-- Additive except: content_versions.kind now also allows 'core' (check constraint widened, no data touched).

create table if not exists mtb.chapter_cores (
  id           bigint generated always as identity primary key,
  core_id      text not null unique check (core_id ~ '^[a-z0-9-]+/[a-z0-9-]+/[a-z0-9-]+$'),  -- qual/subject/chapter
  qual_slug    text not null references mtb.qualifications(slug),
  subject_slug text not null,
  chapter_no   int  not null,
  title_hi     text not null,
  title_en     text,
  level_family text not null check (level_family in ('basic','board','technical','higher')),
  status       text not null default 'draft' check (status in ('draft','approved','rejected')),
  data         jsonb not null,
  checks       jsonb not null default '{}'::jsonb,
  model        text,
  attempts     int not null default 0,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create index if not exists chapter_cores_shelf_idx on mtb.chapter_cores (qual_slug, subject_slug, chapter_no);
alter table mtb.chapter_cores enable row level security;   -- no policies: read only through the functions below

-- ---------- versions ----------
alter table mtb.content_versions add column if not exists ref text;   -- core_id for kind = 'core'
alter table mtb.content_versions drop constraint if exists content_versions_kind_check;
alter table mtb.content_versions add constraint content_versions_kind_check check (kind in ('chapter','solution','core'));

create or replace function mtb._keep_core_version()
returns trigger language plpgsql security definer set search_path = mtb, pg_temp as $$
begin
  if old.data is distinct from new.data or old.status is distinct from new.status then
    insert into mtb.content_versions (kind, level_id, chapter_id, ref, status, data, checks, model)
    values ('core', old.qual_slug, old.chapter_no, old.core_id, old.status, old.data, old.checks, old.model);
  end if;
  return new;
end $$;
drop trigger if exists keep_core_version on mtb.chapter_cores;   -- re-runnable; removes only this trigger
create trigger keep_core_version before update on mtb.chapter_cores for each row execute function mtb._keep_core_version();

-- ---------- robots (service role): write a draft ----------
-- An approved core is never overwritten by a robot: it returns 'locked' (owner must unpublish or ask for changes first).
create or replace function mtb.core_upsert(p_data jsonb, p_checks jsonb default '{}'::jsonb, p_model text default null)
returns text language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
declare cid text := p_data->>'id'; parts text[] := string_to_array(p_data->>'id', '/'); cur mtb.chapter_cores%rowtype;
begin
  if not mtb._is_service() then raise exception 'not allowed'; end if;
  if p_data->>'schema' <> 'book.core.v1' or cardinality(parts) <> 3 then raise exception 'bad core'; end if;
  select * into cur from mtb.chapter_cores where core_id = cid for update;
  if found and cur.status = 'approved' then return 'locked'; end if;
  insert into mtb.chapter_cores (core_id, qual_slug, subject_slug, chapter_no, title_hi, title_en, level_family, status, data, checks, model)
  values (cid, parts[1], parts[2], (p_data->>'no')::int, p_data->>'title_hi', p_data->>'title_en', p_data->>'level_family',
          'draft', p_data, coalesce(p_checks, '{}'::jsonb), p_model)
  on conflict (core_id) do update set chapter_no = excluded.chapter_no, title_hi = excluded.title_hi, title_en = excluded.title_en,
     level_family = excluded.level_family, status = 'draft', data = excluded.data, checks = excluded.checks, model = excluded.model,
     attempts = mtb.chapter_cores.attempts + 1, updated_at = now();
  return 'ok';
end $$;

-- ---------- owner (review code) ----------
create or replace function mtb.core_review_list(p_code text)
returns jsonb language plpgsql stable security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  return (select coalesce(jsonb_agg(jsonb_build_object('core_id', core_id, 'qual', qual_slug, 'subject', subject_slug, 'no', chapter_no,
            'title_hi', title_hi, 'title_en', title_en, 'status', status, 'model', model, 'updated_at', updated_at, 'checks', checks)
            order by qual_slug, subject_slug, chapter_no), '[]'::jsonb) from mtb.chapter_cores);
end $$;

create or replace function mtb.core_review_get(p_code text, p_core text)
returns jsonb language plpgsql stable security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  return (select jsonb_build_object('core_id', core_id, 'status', status, 'data', data, 'checks', checks, 'model', model, 'updated_at', updated_at)
          from mtb.chapter_cores where core_id = p_core);
end $$;

-- approve / changes / reject / unpublish: same meaning as draft_decide (0173)
create or replace function mtb.core_decide(p_code text, p_core text, p_decision text, p_note text default null)
returns text language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
declare d mtb.chapter_cores%rowtype;
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  if p_decision not in ('approve','changes','reject','unpublish') then raise exception 'bad decision'; end if;
  if p_decision = 'changes' and length(trim(coalesce(p_note, ''))) < 5 then raise exception 'note needed'; end if;
  select * into d from mtb.chapter_cores where core_id = p_core for update;
  if not found then return 'missing'; end if;
  if p_decision = 'approve' then
    if d.status <> 'draft' then return 'not_draft'; end if;
    if jsonb_array_length(coalesce(d.checks->'errors', '[]'::jsonb)) > 0 then return 'has_errors'; end if;
    update mtb.chapter_cores set status = 'approved', updated_at = now(), checks = mtb._owner_mark(d.checks, 'approve', p_note) where id = d.id;
  elsif p_decision = 'unpublish' then
    if d.status <> 'approved' then return 'not_approved'; end if;
    update mtb.chapter_cores set status = 'draft', updated_at = now(), checks = mtb._owner_mark(d.checks, 'unpublish', p_note) where id = d.id;
  elsif p_decision = 'changes' then
    update mtb.chapter_cores set status = 'rejected', attempts = 0, updated_at = now(), checks = mtb._owner_mark(d.checks, 'changes', p_note) where id = d.id;
  else
    update mtb.chapter_cores set status = 'rejected', attempts = 99, updated_at = now(), checks = mtb._owner_mark(d.checks, 'reject', p_note) where id = d.id;
  end if;
  return 'ok';
end $$;

create or replace function mtb.core_versions_list(p_code text, p_core text)
returns jsonb language plpgsql stable security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  return (select coalesce(jsonb_agg(jsonb_build_object('id', id, 'status', status, 'model', model, 'saved_at', saved_at, 'owner', checks->'owner')
            order by id desc), '[]'::jsonb)
          from (select * from mtb.content_versions where kind = 'core' and ref = p_core order by id desc limit 30) t);
end $$;

-- old copy back as a DRAFT (never straight to students)
create or replace function mtb.core_rollback(p_code text, p_version bigint)
returns text language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
declare v mtb.content_versions%rowtype;
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  select * into v from mtb.content_versions where id = p_version and kind = 'core';
  if not found then return 'missing'; end if;
  update mtb.chapter_cores set status = 'draft', data = v.data, model = v.model, updated_at = now(),
    checks = mtb._owner_mark(v.checks, 'rollback', 'version ' || v.id) where core_id = v.ref;
  return case when found then 'ok' else 'missing' end;
end $$;

-- Writer robot: owner notes for cores sent back with 'changes'
create or replace function mtb.core_owner_notes()
returns table(core_id text, note text) language plpgsql stable security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._is_service() then raise exception 'not allowed'; end if;
  return query select c.core_id, c.checks->'owner'->>'note' from mtb.chapter_cores c
    where c.status = 'rejected' and c.checks->'owner'->>'decision' = 'changes';
end $$;

-- ---------- students: approved cores only ----------
create or replace function mtb.list_chapter_cores(p_qual text, p_subject text default null)
returns jsonb language sql stable security definer set search_path = mtb, pg_temp as $$
  select coalesce(jsonb_agg(jsonb_build_object('core_id', core_id, 'subject', subject_slug, 'no', chapter_no, 'hi', title_hi, 'en', title_en)
           order by subject_slug, chapter_no), '[]'::jsonb)
  from mtb.chapter_cores where status = 'approved' and qual_slug = p_qual and (p_subject is null or subject_slug = p_subject);
$$;

create or replace function mtb.get_chapter_core(p_core text)
returns jsonb language sql stable security definer set search_path = mtb, pg_temp as $$
  select data from mtb.chapter_cores where core_id = p_core and status = 'approved';
$$;

revoke all on function mtb.core_upsert(jsonb, jsonb, text) from public, anon, authenticated;
grant execute on function mtb.core_upsert(jsonb, jsonb, text) to service_role;
revoke all on function mtb.core_owner_notes() from public, anon, authenticated;
grant execute on function mtb.core_owner_notes() to service_role;
revoke all on function mtb.core_review_list(text) from public;
revoke all on function mtb.core_review_get(text, text) from public;
revoke all on function mtb.core_decide(text, text, text, text) from public;
revoke all on function mtb.core_versions_list(text, text) from public;
revoke all on function mtb.core_rollback(text, bigint) from public;
grant execute on function mtb.core_review_list(text) to anon, authenticated;
grant execute on function mtb.core_review_get(text, text) to anon, authenticated;
grant execute on function mtb.core_decide(text, text, text, text) to anon, authenticated;
grant execute on function mtb.core_versions_list(text, text) to anon, authenticated;
grant execute on function mtb.core_rollback(text, bigint) to anon, authenticated;
grant execute on function mtb.list_chapter_cores(text, text) to anon, authenticated;
grant execute on function mtb.get_chapter_core(text) to anon, authenticated;
