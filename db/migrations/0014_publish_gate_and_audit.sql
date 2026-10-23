-- 0014 (S3): publish lock + audit log + backup verify. ADDITIVE ONLY (no DROP / DELETE).
-- 1) mtb.publish_problems(q): list of reasons a question may NOT be published.
-- 2) trigger: a question can only move INTO status 'published' if it has no problems (covers SQL bypass, robots, admins).
--    Rows that are already published are not touched by this trigger.
-- 3) mtb.audit_log + trigger: who/when/old->new for status, topic, chapter, answer, content_hash.
-- 4) backup.verify_nightly(slot): proves a nightly backup can be read back and compares it with live.

create or replace function mtb.publish_problems(q mtb.questions) returns text[]
language plpgsql stable set search_path = mtb, public as $$
declare p text[] := '{}'; en text; hi text; other int; latin int; exam int; has_img boolean; opt jsonb;
begin
  has_img := (q.stem ? 'img') and coalesce(q.stem->>'img','') <> '';
  if q.answer is null or q.answer < 0 or q.answer > 3 then p := array_append(p, 'answer'); end if;
  if jsonb_typeof(q.options) <> 'array' or jsonb_array_length(q.options) <> 4 then p := array_append(p, 'options'); end if;
  if q.source_id is null and q.kind = 'pyq' then p := array_append(p, 'source'); end if;
  en := coalesce(q.stem->>'en', ''); hi := coalesce(q.stem->>'hi', '');
  if not has_img and btrim(en) = '' then p := array_append(p, 'english_missing'); end if;
  if en <> '' then
    other := length(regexp_replace(en, '[^ऀ-෿]', '', 'g'));
    latin := length(regexp_replace(en, '[^A-Za-z]', '', 'g'));
    if other > 10 and other > latin then p := array_append(p, 'english_wrong_language'); end if;
  end if;
  if btrim(hi) = '' and coalesce(q.stem->>'img_hi', '') = '' then p := array_append(p, 'hindi_missing'); end if;
  if has_img and coalesce(q.stem->'checks'->>'fig_ok', '') <> 'true' then p := array_append(p, 'figure_not_reviewed'); end if;
  if q.source_id is not null and q.content_hash is not null then
    select s.exam_id into exam from mtb.sources s where s.id = q.source_id;
    if exists (select 1 from mtb.questions o join mtb.sources os on os.id = o.source_id
               where o.content_hash = q.content_hash and o.id <> q.id and o.status = 'published' and os.exam_id = exam
                 and (select paper_date from mtb.sources where id = o.source_id) is not distinct from (select paper_date from mtb.sources where id = q.source_id)
                 and o.source_id <> q.source_id) then
      p := array_append(p, 'duplicate_in_exam');
    end if;
  end if;
  return p;
end $$;

create or replace function mtb.trg_publish_lock() returns trigger
language plpgsql set search_path = mtb, public as $$
declare p text[];
begin
  if new.status = 'published' and (tg_op = 'INSERT' or old.status is distinct from 'published') then
    p := mtb.publish_problems(new);
    if array_length(p, 1) is not null then
      raise exception 'publish blocked for question %: %', coalesce(new.id::text, 'new'), array_to_string(p, ', ') using errcode = 'P0001';
    end if;
  end if;
  return new;
end $$;

do $$ begin
  if not exists (select 1 from pg_trigger where tgname = 'questions_publish_lock') then
    create trigger questions_publish_lock before insert or update of status on mtb.questions
      for each row execute function mtb.trg_publish_lock();
  end if;
end $$;

create table if not exists mtb.audit_log (
  id bigserial primary key,
  at timestamptz not null default now(),
  actor text,
  question_id bigint not null,
  field text not null,
  old_value text,
  new_value text
);
create index if not exists audit_log_q_idx on mtb.audit_log (question_id, at desc);
alter table mtb.audit_log enable row level security;   -- no policy: only service role / SQL owner can read or write

create or replace function mtb.trg_audit_questions() returns trigger
language plpgsql security definer set search_path = mtb, public as $$
declare who text := coalesce(nullif(current_setting('request.headers', true), '')::json->>'x-actor', current_user);
begin
  if new.status is distinct from old.status then insert into mtb.audit_log(actor, question_id, field, old_value, new_value) values (who, new.id, 'status', old.status, new.status); end if;
  if new.topic_id is distinct from old.topic_id then insert into mtb.audit_log(actor, question_id, field, old_value, new_value) values (who, new.id, 'topic_id', old.topic_id::text, new.topic_id::text); end if;
  if new.chapter_id is distinct from old.chapter_id then insert into mtb.audit_log(actor, question_id, field, old_value, new_value) values (who, new.id, 'chapter_id', old.chapter_id::text, new.chapter_id::text); end if;
  if new.answer is distinct from old.answer then insert into mtb.audit_log(actor, question_id, field, old_value, new_value) values (who, new.id, 'answer', old.answer::text, new.answer::text); end if;
  if new.content_hash is distinct from old.content_hash then insert into mtb.audit_log(actor, question_id, field, old_value, new_value) values (who, new.id, 'content_hash', left(old.content_hash, 12), left(new.content_hash, 12)); end if;
  return new;
end $$;

do $$ begin
  if not exists (select 1 from pg_trigger where tgname = 'questions_audit') then
    create trigger questions_audit after update on mtb.questions
      for each row execute function mtb.trg_audit_questions();
  end if;
end $$;

create or replace function backup.verify_nightly(p_slot int default null) returns jsonb
language sql security definer set search_path = backup, mtb, public as $$
  with n as (select * from backup.nightly where slot = coalesce(p_slot, (select slot from backup.nightly order by taken_at desc limit 1))),
  b as (select r.* from n, jsonb_populate_recordset(null::mtb.questions, n.questions) r)
  select jsonb_build_object(
    'slot', (select slot from n), 'taken_at', (select taken_at from n),
    'backup_rows', (select count(*) from b),
    'live_rows', (select count(*) from mtb.questions),
    'missing_in_live', (select count(*) from b left join mtb.questions q using (id) where q.id is null),
    'changed_since', (select count(*) from b join mtb.questions q using (id)
                      where (q.stem, q.options, q.answer, q.kind, q.source_id, q.source_qno, q.content_hash, q.status, q.topic_id)
                            is distinct from (b.stem, b.options, b.answer, b.kind, b.source_id, b.source_qno, b.content_hash, b.status, b.topic_id)),
    'checked_at', now());
$$;
revoke all on function backup.verify_nightly(int) from public, anon, authenticated;

-- speeds up the duplicate check in publish_problems (applied live as 0014c)
create index if not exists questions_hash_idx on mtb.questions (content_hash);
-- NOTE: live history shows 0014 + 0014b (array_append fix) + 0014c (index); this file is the final combined result.
