-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261023135456  name: 0017b_publish_robot_guard
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): b5f5a86700f0e8d5d05ec280a260ea0a

create or replace function mtb.publish_ready(p_limit int default 100, p_exam int default null, p_dry boolean default true)
returns jsonb language plpgsql security definer set search_path = mtb, public as $$
declare ids bigint[]; n int := 0; lim int := least(greatest(coalesce(p_limit,100),1),500);
begin
  select coalesce(array_agg(x.id),'{}') into ids from (
    select q.id from questions q left join sources s on s.id = q.source_id
    where q.status = 'draft' and q.chapter_id is not null
      and (p_exam is null or s.exam_id = p_exam)
      and cardinality(publish_problems(q)) = 0
      and not exists (select 1 from questions o left join sources os on os.id = o.source_id
        where o.status = 'draft' and o.id <> q.id and o.content_hash = q.content_hash
          and o.source_id <> q.source_id and os.exam_id is not distinct from s.exam_id
          and os.paper_date is not distinct from s.paper_date)
    order by q.id limit lim) x;
  insert into backup.publish_runs(actor, exam_id, dry, ids) values ('publish-robot', p_exam, p_dry, ids);
  if not p_dry and cardinality(ids) > 0 then
    update questions set status = 'published', updated_at = now()
    where id = any(ids) and status = 'draft' and chapter_id is not null;
    get diagnostics n = row_count;
  end if;
  return jsonb_build_object('dry', p_dry, 'eligible', cardinality(ids), 'published', n, 'limit', lim, 'exam', p_exam);
end $$;
revoke all on function mtb.publish_ready(int,int,boolean) from public, anon, authenticated;
grant execute on function mtb.publish_ready(int,int,boolean) to service_role;
