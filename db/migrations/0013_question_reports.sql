-- 0013: students can report a wrong question (no login needed). Additive only.
-- A report is one row per (question, device). When 3 different devices report the same published question
-- it is set to status='hidden' (never deleted) and shows up in mtb.report_queue for the checking robots / owner.
create table if not exists mtb.question_reports (
  id bigserial primary key,
  question_id bigint not null references mtb.questions(id) on delete cascade,
  device text not null check (char_length(device) between 8 and 64),
  reason text not null check (reason in ('answer','question','hindi','figure','other')),
  note text check (note is null or char_length(note) <= 300),
  created_at timestamptz not null default now(),
  unique (question_id, device)
);
create index if not exists question_reports_q_idx on mtb.question_reports (question_id);
create index if not exists question_reports_device_idx on mtb.question_reports (device, created_at);
alter table mtb.question_reports enable row level security;
revoke all on mtb.question_reports from anon, authenticated;
grant select, insert, update, delete on mtb.question_reports to service_role;
grant usage, select on sequence mtb.question_reports_id_seq to service_role;

-- The only door for students: validates, de-duplicates, rate-limits, auto-hides at 3 devices.
create or replace function mtb.report_question(p_question bigint, p_device text, p_reason text, p_note text default null)
returns jsonb language plpgsql security definer set search_path = mtb, public as $$
declare n int; hid boolean := false;
begin
  if p_device is null or char_length(p_device) < 8 or char_length(p_device) > 64 then return jsonb_build_object('ok', false, 'err', 'device'); end if;
  if p_reason is null or p_reason not in ('answer','question','hindi','figure','other') then return jsonb_build_object('ok', false, 'err', 'reason'); end if;
  if not exists (select 1 from mtb.questions where id = p_question and status = 'published') then return jsonb_build_object('ok', false, 'err', 'question'); end if;
  if (select count(*) from mtb.question_reports where device = p_device and created_at > now() - interval '24 hours') >= 30 then
    return jsonb_build_object('ok', false, 'err', 'limit');
  end if;
  insert into mtb.question_reports (question_id, device, reason, note)
    values (p_question, p_device, p_reason, nullif(left(p_note, 300), ''))
    on conflict (question_id, device) do nothing;
  select count(distinct device) into n from mtb.question_reports where question_id = p_question;
  if n >= 3 then
    update mtb.questions set status = 'hidden', updated_at = now() where id = p_question and status = 'published';
    hid := found;
  end if;
  return jsonb_build_object('ok', true, 'reports', n, 'hidden', hid);
end $$;
revoke all on function mtb.report_question(bigint, text, text, text) from public;
grant execute on function mtb.report_question(bigint, text, text, text) to anon, authenticated;

-- What the checking robots / owner look at (service role only).
create or replace view mtb.report_queue with (security_invoker = true) as
  select r.question_id, count(distinct r.device)::int as devices, array_agg(distinct r.reason) as reasons,
         max(r.created_at) as last_report, q.status, q.kind
  from mtb.question_reports r join mtb.questions q on q.id = r.question_id
  group by r.question_id, q.status, q.kind;
revoke all on mtb.report_queue from anon, authenticated;
grant select on mtb.report_queue to service_role;
