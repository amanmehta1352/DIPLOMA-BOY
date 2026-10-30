-- STATUS (2026-10-30 audit): NOT APPLIED to production. Depends on 0026 (mtb.pattern_candidates). Do not apply without owner decision.
-- 0027 Pattern candidate review (additive only). NOT APPLIED: needs explicit live-database approval.
-- Reviewing changes only mtb.pattern_candidates.status. It never writes mtb.questions.pattern_id.
-- Promotion of approved candidates to live patterns is a separate, later migration.
-- Only service_role (robots and reviewers using the service key) may call these functions.

create or replace function mtb.pattern_candidates_pending(p_after bigint default 0, p_limit int default 200)
returns table (id bigint, question_id bigint, pattern_lead_id bigint, relation_type text, confidence real, evidence jsonb, algorithm_version int)
language sql stable security definer set search_path to 'mtb', 'public'
as $$
  select c.id, c.question_id, c.pattern_lead_id, c.relation_type, c.confidence, c.evidence, c.algorithm_version
  from mtb.pattern_candidates c
  where c.status = 'pending_review' and c.id > coalesce(p_after, 0)
  order by c.id
  limit least(greatest(coalesce(p_limit, 50), 1), 500);
$$;

create or replace function mtb.pattern_review(p_ids bigint[], p_decision text, p_reviewer uuid)
returns integer
language plpgsql security definer set search_path to 'mtb', 'public'
as $$
declare n integer;
begin
  if p_decision not in ('approved', 'rejected') then
    raise exception 'decision must be approved or rejected';
  end if;
  if p_reviewer is null then
    raise exception 'reviewer is required';
  end if;
  if coalesce(array_length(p_ids, 1), 0) > 500 then
    raise exception 'batch too large: max 500 ids per call';
  end if;
  update mtb.pattern_candidates
     set status = p_decision, reviewed_by = p_reviewer, reviewed_at = now()
   where id = any(p_ids) and status = 'pending_review';
  get diagnostics n = row_count;
  return n;
end $$;

revoke all on function mtb.pattern_candidates_pending(bigint, int) from public, anon, authenticated;
revoke all on function mtb.pattern_review(bigint[], text, uuid) from public, anon, authenticated;
grant execute on function mtb.pattern_candidates_pending(bigint, int) to service_role;
grant execute on function mtb.pattern_review(bigint[], text, uuid) to service_role;
