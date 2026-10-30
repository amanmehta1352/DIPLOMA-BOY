-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261023103333  name: 0014d_audit_actor_and_verify_fields
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): 5216b8a47a353828a9b6ba0df44e958b

create or replace function mtb.trg_audit_questions() returns trigger
language plpgsql security definer set search_path = mtb, public as $$
declare claims json := nullif(current_setting('request.jwt.claims', true), '')::json;
        hdr json := nullif(current_setting('request.headers', true), '')::json;
        who text;
begin
  if claims->>'role' = 'service_role' then who := coalesce(nullif(hdr->>'x-actor', ''), 'service_role');
  else who := coalesce(nullif(claims->>'email', ''), nullif(claims->>'role', ''), session_user);
  end if;
  if new.status is distinct from old.status then insert into mtb.audit_log(actor, question_id, field, old_value, new_value) values (who, new.id, 'status', old.status, new.status); end if;
  if new.topic_id is distinct from old.topic_id then insert into mtb.audit_log(actor, question_id, field, old_value, new_value) values (who, new.id, 'topic_id', old.topic_id::text, new.topic_id::text); end if;
  if new.chapter_id is distinct from old.chapter_id then insert into mtb.audit_log(actor, question_id, field, old_value, new_value) values (who, new.id, 'chapter_id', old.chapter_id::text, new.chapter_id::text); end if;
  if new.answer is distinct from old.answer then insert into mtb.audit_log(actor, question_id, field, old_value, new_value) values (who, new.id, 'answer', old.answer::text, new.answer::text); end if;
  if new.content_hash is distinct from old.content_hash then insert into mtb.audit_log(actor, question_id, field, old_value, new_value) values (who, new.id, 'content_hash', left(old.content_hash, 12), left(new.content_hash, 12)); end if;
  return new;
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
                      where (q.stem, q.options, q.answer, q.kind, q.source_id, q.source_qno, q.content_hash, q.status, q.topic_id, q.chapter_id, q.solution, q.difficulty)
                            is distinct from (b.stem, b.options, b.answer, b.kind, b.source_id, b.source_qno, b.content_hash, b.status, b.topic_id, b.chapter_id, b.solution, b.difficulty)),
    'checked_at', now());
$$;
revoke all on function backup.verify_nightly(int) from public, anon, authenticated;
