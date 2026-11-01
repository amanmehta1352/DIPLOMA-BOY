-- Automatic publishing needs copyright evidence: the writer must have checked the draft against a reference for its subject.
-- Drafts without that evidence stay as drafts for owner review.
create or replace function mtb.auto_approve_draft(p_level text, p_chapter integer)
returns text language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
declare claims json := nullif(current_setting('request.jwt.claims', true), '')::json; d mtb.chapter_drafts%rowtype; dis int;
begin
  if coalesce(claims->>'role', '') <> 'service_role' then raise exception 'not allowed'; end if;
  select * into d from mtb.chapter_drafts where level_id = p_level and chapter_id = p_chapter for update;
  if not found then return 'missing'; end if;
  if d.status = 'approved' then return 'already'; end if;
  if d.status <> 'draft' then return 'not_draft'; end if;
  dis := coalesce(jsonb_array_length(d.checks->'second_opinion'->'disagree'), -1);
  if jsonb_array_length(coalesce(d.checks->'problems', '[]'::jsonb)) <> 0 or dis <> 0 then return 'held'; end if;
  if coalesce((d.checks->>'copyright_covered')::boolean, false) is not true then return 'held'; end if;
  update mtb.chapter_drafts set status = 'approved', updated_at = now(),
    checks = d.checks || jsonb_build_object('auto_approved_at', now()) where id = d.id;
  return 'approved';
end $$;
