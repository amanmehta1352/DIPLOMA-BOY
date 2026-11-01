-- 0163_solution_auto_approve: a solver item becomes visible to students only if all code checks passed and a second AI
-- from a different family (not Gemini) reached the same answer. Service role only. Additive.
create or replace function mtb.solution_auto_approve(p_level text, p_chapter integer, p_slot integer)
returns text language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
declare s mtb.solution_items%rowtype; so jsonb;
begin
  if not mtb._is_service() then raise exception 'not allowed'; end if;
  select * into s from mtb.solution_items where level_id = p_level and chapter_id = p_chapter and slot = p_slot for update;
  if not found then return 'missing'; end if;
  if s.status = 'approved' then return 'already'; end if;
  if s.status <> 'draft' then return 'not_draft'; end if;
  so := s.checks->'second_opinion';
  if jsonb_array_length(coalesce(s.checks->'problems', '[]'::jsonb)) <> 0
     or coalesce((so->>'agree')::boolean, false) is not true
     or coalesce(so->>'model', '') ilike '%gemini%' or coalesce(so->>'model', '') = '' then
    return 'held';
  end if;
  update mtb.solution_items set status = 'approved', updated_at = now(),
    checks = s.checks || jsonb_build_object('auto_approved_at', now()) where id = s.id;
  return 'approved';
end $$;
