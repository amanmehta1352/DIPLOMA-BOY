-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261022163852  name: ntpc_exam_pattern_and_sections
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): b57702bfa6b06dcc5b1f5ae23b331401

create table if not exists backup.ntpc_pre_exam_sections_20261022 as select * from mtb.exam_sections;
create table if not exists backup.ntpc_pre_exams2_20261022 as select * from mtb.exams;
update mtb.exams set pattern = '{"minutes":90,"sections":["general-awareness","maths","reasoning"],"questions":100,"marks_per_q":1,"negative_per_wrong":0.3333}'::jsonb where id in (6,8) and family_en='RRB NTPC';
update mtb.exams set pattern = '{"minutes":90,"sections":["general-awareness","maths","reasoning"],"questions":120,"marks_per_q":1,"negative_per_wrong":0.3333}'::jsonb where id in (7,9) and family_en='RRB NTPC';
insert into mtb.exam_sections(exam_id,sort,slug,name_hi,name_en,questions,qno_from,qno_to,subjects)
select e.id, v.sort, v.slug, v.hi, v.en, case when e.id in (6,8) then v.n1 else v.n2 end, null, null, v.subj
from mtb.exams e cross join (values
 (1,'general-awareness','सामान्य जागरूकता','General Awareness',40,50,array['general-awareness','general-science']),
 (2,'maths','गणित','Mathematics',30,35,array['maths']),
 (3,'reasoning','सामान्य बुद्धि और तर्क','General Intelligence & Reasoning',30,35,array['reasoning'])
) as v(sort,slug,hi,en,n1,n2,subj)
where e.id in (6,7,8,9) and e.family_en='RRB NTPC'
on conflict (exam_id,slug) do nothing;
select 1;
