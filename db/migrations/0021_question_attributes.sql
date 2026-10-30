-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261024031530  name: 0021_question_attributes
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): eb1643df64ec6b9a68f23357657ee351

create table if not exists mtb.question_attributes (
  question_id bigint not null references mtb.questions(id) on delete cascade,
  key text not null,
  value text not null,
  primary key (question_id, key)
);
create index if not exists question_attributes_kv on mtb.question_attributes (key, value);
alter table mtb.question_attributes enable row level security;
revoke all on mtb.question_attributes from anon, authenticated;
grant select, insert, update on mtb.question_attributes to service_role;
insert into mtb.question_attributes (question_id, key, value)
select q.id, k.key, k.value from mtb.questions q
left join mtb.sources s on s.id = q.source_id
cross join lateral (values
  ('status', q.status),
  ('kind', coalesce(q.kind,'')),
  ('exam', coalesce(s.exam_id::text,'')),
  ('subject', coalesce((select t.subject_id::text from mtb.topics t where t.id=q.topic_id),'')),
  ('chapter', coalesce(q.chapter_id::text,'')),
  ('pattern', coalesce(q.pattern_id::text,'')),
  ('language_en', case when coalesce(btrim(q.stem->>'en'),'')<>'' then 'yes' else 'no' end),
  ('language_hi', case when coalesce(btrim(q.stem->>'hi'),'')<>'' then 'yes' else 'no' end),
  ('figure', case when (q.stem ? 'img') and coalesce(q.stem->>'img','')<>'' then 'yes' else 'no' end),
  ('figure_ok', case when coalesce(q.stem->'checks'->>'fig_ok','')='true' then 'yes' else 'no' end)
) as k(key, value)
on conflict (question_id, key) do update set value = excluded.value;
select key, count(*) from mtb.question_attributes group by 1 order by 1;
