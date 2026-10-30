-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261020205246  name: import_pyq_rpc
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): 6da4a2080b687450845f62592eca64ff
-- NOTE: 1 import token literal(s) redacted for the public repo (all tokens expired 2026-10-20).

create table if not exists mtb.import_tokens (token text primary key, expires_at timestamptz not null, used boolean not null default false);
alter table mtb.import_tokens enable row level security;
revoke all on mtb.import_tokens from anon, authenticated;
insert into mtb.import_tokens(token, expires_at) values ('<redacted-expired-token>', now() + interval '2 hours') on conflict do nothing;

create or replace function mtb.import_pyq(tok text, meta jsonb, qs jsonb)
returns jsonb language plpgsql security definer set search_path = mtb, public as $$
declare ex_id int; n_q int := 0; t jsonb; p jsonb; q jsonb; sid int; tid int; subj int;
begin
  if not exists (select 1 from mtb.import_tokens where token = tok and not used and expires_at > now()) then
    raise exception 'bad token';
  end if;
  select id into ex_id from mtb.exams where slug = 'rrb-je-cbt1';
  if meta is not null then
    for t in select * from jsonb_array_elements(meta->'topics') loop
      select id into subj from mtb.subjects where slug = t->>'subject';
      insert into mtb.topics(subject_id, slug, name_en, name_hi, sort)
      values (subj, t->>'slug', t->>'en', t->>'hi', (t->>'sort')::int) on conflict (subject_id, slug) do nothing;
    end loop;
    for p in select * from jsonb_array_elements(meta->'papers') loop
      insert into mtb.sources(exam_id, exam_year, shift, paper_date, kind, verified_at)
      values (ex_id, (p->>'year')::int, (p->>'shift')::int, (p->>'date')::date, 'official_response_sheet', now())
      on conflict (exam_id, paper_date, shift, kind) do nothing;
    end loop;
  end if;
  if qs is not null then
    for q in select * from jsonb_array_elements(qs) loop
      select s.id into sid from mtb.sources s, jsonb_array_elements(meta->'papers') pp
       where (pp->>'key')::int = (q->>'paper')::int and s.exam_id = ex_id and s.paper_date = (pp->>'date')::date and s.shift = (pp->>'shift')::int and s.kind = 'official_response_sheet';
      select tp.id into tid from mtb.topics tp join mtb.subjects su on su.id = tp.subject_id where tp.slug = q->>'topic' and su.slug = q->>'subject';
      insert into mtb.questions(kind, source_id, source_qno, topic_id, stem, options, answer, solution, status, content_hash)
      values ('pyq', sid, (q->>'qno')::int, tid, q->'stem', q->'options', (q->>'answer')::smallint, q->'solution', 'published', q->>'hash')
      on conflict (source_id, source_qno) do nothing;
      n_q := n_q + 1;
    end loop;
  end if;
  return jsonb_build_object('processed', n_q, 'questions_total', (select count(*) from mtb.questions), 'topics', (select count(*) from mtb.topics), 'sources', (select count(*) from mtb.sources));
end $$;
revoke all on function mtb.import_pyq(text, jsonb, jsonb) from public;
grant execute on function mtb.import_pyq(text, jsonb, jsonb) to anon;
notify pgrst, 'reload schema';
