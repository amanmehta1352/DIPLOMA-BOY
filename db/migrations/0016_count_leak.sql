-- 0016 Count & Leak robot: counts only, service_role only. No data is changed.
create or replace function mtb.count_leak() returns jsonb
language sql stable security definer set search_path = mtb, public as $$
select jsonb_build_object(
  'checked_at', now(),
  'published_total', (select count(*) from questions where status='published'),
  'no_topic', (select count(*) from questions q where q.status='published' and q.topic_id is null),
  'nonchapter_leaf', (select count(*) from questions q join topics t on t.id=q.topic_id
      where q.status='published' and not coalesce(t.is_chapter,false)
        and not exists(select 1 from topics c where c.parent_id=t.id)),
  'branch_leak', (select count(*) from questions q join sources s on s.id=q.source_id
      join topics t on t.id=q.topic_id join subjects sj on sj.id=t.subject_id
      where q.status='published' and sj.branch_id is not null
        and not exists(select 1 from exam_branches eb where eb.exam_id=s.exam_id and eb.branch_id=sj.branch_id)),
  'pattern_split', (select count(*) from (select pattern_id from questions
      where status='published' and pattern_id is not null and chapter_id is not null
      group by 1 having count(distinct chapter_id)>1) x),
  'inactive_exam', (select count(*) from questions q join sources s on s.id=q.source_id join exams e on e.id=s.exam_id
      where q.status='published' and not coalesce(e.active,false)),
  'paper_stats_gap', (select count(*) from (select s.id from sources s
      left join questions q on q.source_id=s.id and q.status='published'
      group by s.id having count(q.id)=0) x)
);
$$;
revoke all on function mtb.count_leak() from public, anon, authenticated;
grant execute on function mtb.count_leak() to service_role;
