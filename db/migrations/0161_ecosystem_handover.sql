-- 0161_ecosystem_handover: service-role-only helpers for the automatic robots (Phase 3 + handover). Additive only.
-- auto_approve_draft: a robot draft becomes visible to students ONLY if its checks passed and the second AI agreed on every answer.
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
  update mtb.chapter_drafts set status = 'approved', updated_at = now(),
    checks = d.checks || jsonb_build_object('auto_approved_at', now()) where id = d.id;
  return 'approved';
end $$;

-- Robots hand work to each other: an automatic command with a note saying who asked (no owner code needed, service role only).
create or replace function mtb.cmd_enqueue_auto(p_robot text, p_args jsonb default '{}'::jsonb, p_note text default null)
returns bigint language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
declare claims json := nullif(current_setting('request.jwt.claims', true), '')::json; v_id bigint;
begin
  if coalesce(claims->>'role', '') <> 'service_role' then raise exception 'not allowed'; end if;
  if not mtb._cmd_robot_ok(p_robot) then raise exception 'unknown robot'; end if;
  if (select count(*) from mtb.robot_commands where status in ('queued','running')) >= 20 then return null; end if;
  insert into mtb.robot_commands (robot, args, note) values (p_robot, coalesce(p_args, '{}'::jsonb), left(p_note, 500)) returning id into v_id;
  return v_id;
end $$;
