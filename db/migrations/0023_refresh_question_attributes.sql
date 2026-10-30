-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261024034429  name: 0023_refresh_question_attributes
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): d7d7062b986c02883908eee7eb9b98d0

create or replace function mtb.refresh_question_attributes() returns jsonb
language plpgsql security definer set search_path = mtb, public as $$
declare n int;
begin
  insert into question_attributes (question_id, key, value)
  select q.id, k.key, k.value from questions q
  left join sources s on s.id = q.source_id
  cross join lateral (values
    ('status', q.status),
    ('kind', coalesce(q.kind,'')),
    ('exam', coalesce(s.exam_id::text,'')),
    ('subject', coalesce((select t.subject_id::text from topics t where t.id=q.topic_id),'')),
    ('chapter', coalesce(q.chapter_id::text,'')),
    ('pattern', coalesce(q.pattern_id::text,'')),
    ('language_en', case when coalesce(btrim(q.stem->>'en'),'')<>'' then 'yes' else 'no' end),
    ('language_hi', case when coalesce(btrim(q.stem->>'hi'),'')<>'' then 'yes' else 'no' end),
    ('figure', case when (q.stem ? 'img') and coalesce(q.stem->>'img','')<>'' then 'yes' else 'no' end),
    ('figure_ok', case when coalesce(q.stem->'checks'->>'fig_ok','')='true' then 'yes' else 'no' end)
  ) as k(key, value)
  on conflict (question_id, key) do update set value = excluded.value where question_attributes.value is distinct from excluded.value;
  get diagnostics n = row_count;
  return jsonb_build_object('checked_at', now(), 'rows_changed_or_added', n, 'questions', (select count(*) from questions));
end $$;
revoke all on function mtb.refresh_question_attributes() from public, anon, authenticated;
grant execute on function mtb.refresh_question_attributes() to service_role;
