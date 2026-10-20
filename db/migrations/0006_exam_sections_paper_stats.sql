-- 0006: exam pattern as data (sections) + paper completeness. Additive only. Backup: backup.nightly slot taken 2026-10-20 23:35 UTC.
create table if not exists mtb.exam_sections (
  id serial primary key,
  exam_id int not null references mtb.exams(id),
  sort int not null default 0,
  slug text not null,
  name_hi text not null, name_en text not null,
  questions int not null check (questions > 0),
  qno_from int, qno_to int,                -- official question-number range, when the paper is sectioned
  subjects text[] not null,                -- subject slugs; 'branch-engineering' = the student's own branch subject
  unique (exam_id, slug));
alter table mtb.exam_sections enable row level security;
do $$ begin
  if not exists (select 1 from pg_policies where policyname='read_sections') then
    create policy read_sections on mtb.exam_sections for select using (true);
  end if; end $$;
grant select on mtb.exam_sections to anon, authenticated;

insert into mtb.exam_sections(exam_id,sort,slug,name_hi,name_en,questions,qno_from,qno_to,subjects)
select e.id, v.sort, v.slug, v.hi, v.en, v.n, v.a, v.b, v.subj
from mtb.exams e join (values
  ('rrb-je-cbt1',1,'maths','गणित','Mathematics',30,null::int,null::int,array['maths']),
  ('rrb-je-cbt1',2,'reasoning','सामान्य बुद्धि और तर्क','General Intelligence & Reasoning',25,null,null,array['reasoning']),
  ('rrb-je-cbt1',3,'general-awareness','सामान्य जागरूकता','General Awareness',15,null,null,array['general-awareness']),
  ('rrb-je-cbt1',4,'general-science','सामान्य विज्ञान','General Science',30,null,null,array['general-science']),
  ('ssc-je-paper1',1,'reasoning','सामान्य बुद्धि और तर्क','General Intelligence & Reasoning',50,1,50,array['reasoning']),
  ('ssc-je-paper1',2,'general-awareness','सामान्य जागरूकता','General Awareness',50,51,100,array['general-awareness','general-science']),
  ('ssc-je-paper1',3,'engineering','इंजीनियरिंग (आपकी ब्रांच)','Engineering (your branch)',100,101,200,array['branch-engineering'])
) as v(exam,sort,slug,hi,en,n,a,b,subj) on v.exam = e.slug
on conflict (exam_id, slug) do nothing;

create or replace view mtb.paper_stats as
  select source_id, count(*)::int n from mtb.questions
  where status = 'published' and kind = 'pyq' and source_id is not null group by 1;
grant select on mtb.paper_stats to anon, authenticated;
