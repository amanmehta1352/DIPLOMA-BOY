-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261020221627  name: import_practice_rpc
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): 3b149b9ce0d5155fca28123f65775c02
-- NOTE: 1 import token literal(s) redacted for the public repo (all tokens expired 2026-10-20).

insert into mtb.import_tokens(token, expires_at) values ('<redacted-expired-token>', now() + interval '1 hour') on conflict do nothing;
create unique index if not exists questions_practice_hash_uq on mtb.questions(content_hash) where kind = 'practice';
create or replace function mtb.import_practice(tok text, qs jsonb)
returns jsonb language plpgsql security definer set search_path = mtb, public as $$
declare q jsonb; tid int; n int := 0;
begin
  if not exists (select 1 from mtb.import_tokens where token = tok and not used and expires_at > now()) then raise exception 'bad token'; end if;
  for q in select * from jsonb_array_elements(qs) loop
    select t.id into tid from mtb.topics t join mtb.subjects s on s.id = t.subject_id where s.slug = coalesce(q->>'subject','general-science') and t.slug = q->>'chapter' and t.is_chapter;
    if tid is null then raise exception 'unknown chapter %', q->>'chapter'; end if;
    insert into mtb.questions(kind, topic_id, chapter_id, stem, options, answer, solution, status, content_hash)
    values ('practice', tid, tid, q->'stem', q->'options', (q->>'answer')::smallint, q->'solution', 'published', q->>'hash')
    on conflict (content_hash) where kind = 'practice' do nothing;
    n := n + 1;
  end loop;
  return jsonb_build_object('processed', n, 'practice_total', (select count(*) from mtb.questions where kind='practice'));
end $$;
revoke all on function mtb.import_practice(text, jsonb) from public;
grant execute on function mtb.import_practice(text, jsonb) to anon;
notify pgrst, 'reload schema';
