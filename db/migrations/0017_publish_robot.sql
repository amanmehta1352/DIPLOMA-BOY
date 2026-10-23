-- 0017 Publish Robot (R7): the only sanctioned path draft -> published. service_role only.
-- Rule: question passes mtb.publish_problems (no problems) AND has a chapter. Snapshot of ids first. Never touches published/hidden.
create table if not exists backup.publish_runs (
  id bigserial primary key, at timestamptz not null default now(),
  actor text, exam_id int, dry boolean, ids bigint[] not null default '{}');
create or replace function mtb.publish_ready(p_limit int default 100, p_exam int default null, p_dry boolean default true)
returns jsonb language plpgsql security definer set search_path = mtb, public as $$
declare ids bigint[]; n int := 0; lim int := least(greatest(coalesce(p_limit,100),1),500);
begin
  select coalesce(array_agg(x.id),'{}') into ids from (
    select q.id from questions q left join sources s on s.id = q.source_id
    where q.status = 'draft' and q.chapter_id is not null
      and (p_exam is null or s.exam_id = p_exam)
      and cardinality(publish_problems(q)) = 0
      -- no twin draft in the same exam + paper date (two drafts of one question must not both go live)
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
-- 0017b (applied live, same text as above): twin-draft guard + chapter guard in the update.
