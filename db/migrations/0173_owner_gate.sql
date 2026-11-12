-- 0173_owner_gate: nothing a robot writes reaches students until the owner approves it. Additive only (no DROP/DELETE).
-- 1. Robots lose the power to publish: auto_approve_draft / solution_auto_approve always return 'held'.
-- 2. Owner decides from Control Room -> Review (review code): approve / changes / reject / unpublish, per chapter and per solution.
-- 3. Every change to a chapter draft or solution item keeps the old copy (content_versions); the owner can roll back to any copy.
-- Docs: docs/ARCHITECTURE.md (pillar 4), docs/PRD.md (G1, FR7-FR9).

-- ---------- 1. robots never publish ----------
create or replace function mtb.auto_approve_draft(p_level text, p_chapter integer)
returns text language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._is_service() then raise exception 'not allowed'; end if;
  return 'held';   -- owner gate (0173): only mtb.draft_decide can approve
end $$;

create or replace function mtb.solution_auto_approve(p_level text, p_chapter integer, p_slot integer)
returns text language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._is_service() then raise exception 'not allowed'; end if;
  return 'held';   -- owner gate (0173): only mtb.solution_decide can approve
end $$;

-- ---------- 3. versions (before 2, so decisions are versioned too) ----------
create table if not exists mtb.content_versions (
  id         bigint generated always as identity primary key,
  kind       text not null check (kind in ('chapter','solution')),
  level_id   text not null,
  chapter_id integer not null,
  slot       integer,                         -- solutions only
  status     text not null,
  data       jsonb not null,
  checks     jsonb not null default '{}'::jsonb,
  model      text,
  saved_at   timestamptz not null default now()   -- when this copy was replaced
);
create index if not exists content_versions_key_idx on mtb.content_versions (kind, level_id, chapter_id, slot, id desc);
alter table mtb.content_versions enable row level security;   -- no policies: only security-definer functions read it

create or replace function mtb._keep_chapter_version()
returns trigger language plpgsql security definer set search_path = mtb, pg_temp as $$
begin
  if old.data is distinct from new.data or old.status is distinct from new.status then
    insert into mtb.content_versions (kind, level_id, chapter_id, status, data, checks, model)
    values ('chapter', old.level_id, old.chapter_id, old.status, old.data, old.checks, old.model);
  end if;
  return new;
end $$;
drop trigger if exists keep_chapter_version on mtb.chapter_drafts;   -- re-runnable; removes only this trigger, never data
create trigger keep_chapter_version before update on mtb.chapter_drafts for each row execute function mtb._keep_chapter_version();

create or replace function mtb._keep_solution_version()
returns trigger language plpgsql security definer set search_path = mtb, pg_temp as $$
begin
  if old.data is distinct from new.data or old.status is distinct from new.status then
    insert into mtb.content_versions (kind, level_id, chapter_id, slot, status, data, checks, model)
    values ('solution', old.level_id, old.chapter_id, old.slot, old.status, old.data, old.checks, old.model);
  end if;
  return new;
end $$;
drop trigger if exists keep_solution_version on mtb.solution_items;
create trigger keep_solution_version before update on mtb.solution_items for each row execute function mtb._keep_solution_version();

-- ---------- 2. owner decisions ----------
-- approve   : draft -> approved (students see it)
-- changes   : -> rejected, attempts reset, owner note kept -> Writer rewrites it with the note
-- reject    : -> rejected, attempts = 99 -> never rewritten automatically
-- unpublish : approved -> draft (students stop seeing it; back in the review queue)
create or replace function mtb._owner_mark(p_checks jsonb, p_decision text, p_note text)
returns jsonb language sql stable as $$
  select coalesce(p_checks, '{}'::jsonb) || jsonb_build_object('owner',
    jsonb_build_object('decision', p_decision, 'note', nullif(left(coalesce(p_note, ''), 1500), ''), 'at', now()));
$$;

create or replace function mtb.draft_decide(p_code text, p_level text, p_chapter integer, p_decision text, p_note text default null)
returns text language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
declare d mtb.chapter_drafts%rowtype;
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  if p_decision not in ('approve','changes','reject','unpublish') then raise exception 'bad decision'; end if;
  if p_decision = 'changes' and length(trim(coalesce(p_note, ''))) < 5 then raise exception 'note needed'; end if;
  select * into d from mtb.chapter_drafts where level_id = p_level and chapter_id = p_chapter for update;
  if not found then return 'missing'; end if;
  if p_decision = 'approve' then
    if d.status <> 'draft' then return 'not_draft'; end if;
    update mtb.chapter_drafts set status = 'approved', updated_at = now(), checks = mtb._owner_mark(d.checks, 'approve', p_note) where id = d.id;
  elsif p_decision = 'unpublish' then
    if d.status <> 'approved' then return 'not_approved'; end if;
    update mtb.chapter_drafts set status = 'draft', updated_at = now(), checks = mtb._owner_mark(d.checks, 'unpublish', p_note) where id = d.id;
  elsif p_decision = 'changes' then
    update mtb.chapter_drafts set status = 'rejected', attempts = 0, updated_at = now(), checks = mtb._owner_mark(d.checks, 'changes', p_note) where id = d.id;
  else
    update mtb.chapter_drafts set status = 'rejected', attempts = 99, updated_at = now(), checks = mtb._owner_mark(d.checks, 'reject', p_note) where id = d.id;
  end if;
  return 'ok';
end $$;

create or replace function mtb.solution_decide(p_code text, p_level text, p_chapter integer, p_slot integer, p_decision text, p_note text default null)
returns text language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
declare s mtb.solution_items%rowtype;
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  if p_decision not in ('approve','changes','reject','unpublish') then raise exception 'bad decision'; end if;
  if p_decision = 'changes' and length(trim(coalesce(p_note, ''))) < 5 then raise exception 'note needed'; end if;
  select * into s from mtb.solution_items where level_id = p_level and chapter_id = p_chapter and slot = p_slot for update;
  if not found then return 'missing'; end if;
  if p_decision = 'approve' then
    if s.status <> 'draft' then return 'not_draft'; end if;
    update mtb.solution_items set status = 'approved', updated_at = now(), checks = mtb._owner_mark(s.checks, 'approve', p_note) where id = s.id;
  elsif p_decision = 'unpublish' then
    if s.status <> 'approved' then return 'not_approved'; end if;
    update mtb.solution_items set status = 'draft', updated_at = now(), checks = mtb._owner_mark(s.checks, 'unpublish', p_note) where id = s.id;
  elsif p_decision = 'changes' then
    update mtb.solution_items set status = 'rejected', attempts = 0, updated_at = now(), checks = mtb._owner_mark(s.checks, 'changes', p_note) where id = s.id;
  else
    update mtb.solution_items set status = 'rejected', attempts = 99, updated_at = now(), checks = mtb._owner_mark(s.checks, 'reject', p_note) where id = s.id;
  end if;
  return 'ok';
end $$;

-- Review screen: every chapter that has solution items, with counts per status (drafts first in the UI).
create or replace function mtb.solution_review_list(p_code text)
returns jsonb language plpgsql stable security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  return (select coalesce(jsonb_agg(jsonb_build_object('level_id', level_id, 'chapter_id', chapter_id, 'draft', nd, 'approved', na, 'auto', nauto)
                                     order by level_id, chapter_id), '[]'::jsonb)
          from (select level_id, chapter_id, count(*) filter (where status = 'draft') nd, count(*) filter (where status = 'approved') na,
                       count(*) filter (where status = 'approved' and checks ? 'auto_approved_at' and not checks ? 'owner') nauto
                from mtb.solution_items group by level_id, chapter_id) t);
end $$;

-- Writer robot (service role): the owner's notes for chapters sent back with 'changes'.
create or replace function mtb.draft_owner_notes()
returns table(level_id text, chapter_id integer, note text)
language plpgsql stable security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._is_service() then raise exception 'not allowed'; end if;
  return query select d.level_id, d.chapter_id, d.checks->'owner'->>'note' from mtb.chapter_drafts d
    where d.status = 'rejected' and d.checks->'owner'->>'decision' = 'changes';
end $$;

-- ---------- versions: list + roll back (owner) ----------
create or replace function mtb.content_versions_list(p_code text, p_kind text, p_level text, p_chapter integer, p_slot integer default null)
returns jsonb language plpgsql stable security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  return (select coalesce(jsonb_agg(jsonb_build_object('id', id, 'status', status, 'model', model, 'saved_at', saved_at,
                                     'owner', checks->'owner', 'problems', checks->'problems') order by id desc), '[]'::jsonb)
          from (select * from mtb.content_versions v where v.kind = p_kind and v.level_id = p_level and v.chapter_id = p_chapter
                  and v.slot is not distinct from p_slot order by id desc limit 30) t);
end $$;

-- Puts an old copy back as a DRAFT (never straight to students); the current copy is kept as a version by the trigger.
create or replace function mtb.content_rollback(p_code text, p_version bigint)
returns text language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
declare v mtb.content_versions%rowtype;
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  select * into v from mtb.content_versions where id = p_version;
  if not found then return 'missing'; end if;
  if v.kind = 'chapter' then
    update mtb.chapter_drafts set status = 'draft', data = v.data, model = v.model, updated_at = now(),
      checks = mtb._owner_mark(v.checks, 'rollback', 'version ' || v.id) where level_id = v.level_id and chapter_id = v.chapter_id;
  else
    update mtb.solution_items set status = 'draft', data = v.data, model = v.model, updated_at = now(),
      checks = mtb._owner_mark(v.checks, 'rollback', 'version ' || v.id) where level_id = v.level_id and chapter_id = v.chapter_id and slot = v.slot;
  end if;
  return case when found then 'ok' else 'missing' end;
end $$;

-- only the owner (through the review code) and robots (service role) may call these
revoke all on function mtb.draft_decide(text, text, integer, text, text) from public;
revoke all on function mtb.solution_decide(text, text, integer, integer, text, text) from public;
revoke all on function mtb.content_versions_list(text, text, text, integer, integer) from public;
revoke all on function mtb.content_rollback(text, bigint) from public;
revoke all on function mtb.solution_review_list(text) from public;
grant execute on function mtb.draft_decide(text, text, integer, text, text) to anon, authenticated;
grant execute on function mtb.solution_decide(text, text, integer, integer, text, text) to anon, authenticated;
grant execute on function mtb.content_versions_list(text, text, text, integer, integer) to anon, authenticated;
grant execute on function mtb.content_rollback(text, bigint) to anon, authenticated;
grant execute on function mtb.solution_review_list(text) to anon, authenticated;
revoke all on function mtb.draft_owner_notes() from public, anon, authenticated;
grant execute on function mtb.draft_owner_notes() to service_role;
