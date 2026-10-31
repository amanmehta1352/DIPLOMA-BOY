-- Applied to the server on 2026-10-31 (migration 0157_draft_review). Additive only.
-- Owner-only preview of robot drafts. A draft is readable only with a review code (its sha256 is stored, never the code).
-- The owner's code hash was inserted separately and is not kept in this public repo.
create table if not exists mtb.review_codes (
  code_hash text primary key,
  note text,
  created_at timestamptz not null default now()
);
alter table mtb.review_codes enable row level security;

create or replace function mtb._review_ok(p_code text)
returns boolean language sql stable security definer set search_path = mtb, pg_temp as $$
  select length(regexp_replace(coalesce(p_code,''), '[^A-Za-z0-9]', '', 'g')) >= 20
     and exists (select 1 from mtb.review_codes r
                 where r.code_hash = encode(sha256(convert_to(upper(regexp_replace(coalesce(p_code,''), '[^A-Za-z0-9]', '', 'g')),'UTF8')),'hex'));
$$;

create or replace function mtb.draft_review_list(p_code text)
returns table(level_id text, chapter_id integer, status text, model text, checks jsonb, updated_at timestamptz)
language plpgsql stable security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  return query select d.level_id, d.chapter_id, d.status, d.model, d.checks, d.updated_at from mtb.chapter_drafts d order by d.level_id, d.chapter_id;
end $$;

create or replace function mtb.draft_review_get(p_level text, p_chapter integer, p_code text)
returns jsonb language plpgsql stable security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  return (select jsonb_build_object('data', d.data, 'status', d.status, 'model', d.model, 'checks', d.checks, 'updated_at', d.updated_at)
          from mtb.chapter_drafts d where d.level_id = p_level and d.chapter_id = p_chapter);
end $$;
