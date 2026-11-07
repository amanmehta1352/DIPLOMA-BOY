-- Applied to the server 2026-11-07 (migration 0170_draft_replace_with_version). Additive.
-- Replace the content of one chapter draft on the owner's order, always saving the current version first. Service role only.
create or replace function mtb.draft_replace_with_version(p jsonb)
returns jsonb language plpgsql security definer set search_path = mtb, pg_temp as $$
declare claims json := nullif(current_setting('request.jwt.claims', true), '')::json; d mtb.chapter_drafts; v bigint;
begin
  if coalesce(claims->>'role', '') <> 'service_role' then raise exception 'not allowed'; end if;
  select * into d from mtb.chapter_drafts where id = (p->>'id')::bigint for update;
  if not found then raise exception 'draft not found'; end if;
  if p->'data' is null or jsonb_typeof(p->'data') <> 'object' then raise exception 'data missing'; end if;
  if md5(d.data::text) = md5((p->'data')::text) then return jsonb_build_object('result', 'unchanged'); end if;
  insert into mtb.chapter_draft_versions (draft_id, level_id, chapter_id, status, data, checks, provider, model, note)
  values (d.id, d.level_id, d.chapter_id, d.status, d.data, d.checks, d.provider, d.model, coalesce(p->>'note', 'saved before replace'))
  returning version_id into v;
  update mtb.chapter_drafts set data = p->'data',
         checks = coalesce(d.checks, '{}'::jsonb) || jsonb_build_object('v2', coalesce(p->>'note', '')),
         model = coalesce(p->>'model', d.model), updated_at = now()
   where id = d.id;
  return jsonb_build_object('result', 'replaced', 'saved_version', v, 'status', d.status, 'bytes', length((p->'data')::text));
end $$;
revoke all on function mtb.draft_replace_with_version(jsonb) from public, anon, authenticated;
grant execute on function mtb.draft_replace_with_version(jsonb) to service_role;
