-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261023182540  name: 0019b_report_global_caps
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): 72efa8559f89ccbe3a52a67fbb66f732

create or replace function mtb.report_question(p_question bigint, p_device text, p_reason text, p_note text default null)
returns jsonb language plpgsql security definer set search_path = mtb, public as $$
declare n int;
begin
  if p_device is null or char_length(p_device) < 8 or char_length(p_device) > 64 then return jsonb_build_object('ok', false, 'err', 'device'); end if;
  if p_reason is null or p_reason not in ('answer','question','hindi','figure','other') then return jsonb_build_object('ok', false, 'err', 'reason'); end if;
  if not exists (select 1 from mtb.questions where id = p_question and status = 'published') then return jsonb_build_object('ok', false, 'err', 'question'); end if;
  -- caps that do not depend on the caller's device string
  if (select count(*) from mtb.question_reports where created_at > now() - interval '1 hour') >= 2000 then
    return jsonb_build_object('ok', false, 'err', 'limit');
  end if;
  if (select count(*) from mtb.question_reports where question_id = p_question) >= 25 then
    return jsonb_build_object('ok', false, 'err', 'limit');
  end if;
  if (select count(*) from mtb.question_reports where device = p_device and created_at > now() - interval '24 hours') >= 30 then
    return jsonb_build_object('ok', false, 'err', 'limit');
  end if;
  insert into mtb.question_reports (question_id, device, reason, note)
    values (p_question, p_device, p_reason, nullif(left(p_note, 300), ''))
    on conflict (question_id, device) do nothing;
  select count(distinct device) into n from mtb.question_reports where question_id = p_question;
  return jsonb_build_object('ok', true, 'reports', n, 'hidden', false);
end $$;
revoke all on function mtb.report_question(bigint,text,text,text) from public, anon, authenticated;
grant execute on function mtb.report_question(bigint,text,text,text) to anon, authenticated;
