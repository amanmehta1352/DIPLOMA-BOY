-- 0167 student setup (first-run wizard). Additive only: new tables + one new read function.
-- Existing tables, functions and the old level picker are untouched.
--
-- qualifications       what the student is / studies (picked ONE)         -> "my course" content
-- qualification_exams  which exam families that qualification can target  -> picked MANY
-- subject_units        how a subject is split into syllabus subjects ("books") in the library
-- get_setup_config()   one read for the app wizard

create table if not exists mtb.qualifications (
  slug       text primary key,
  cat        text not null,             -- school | diploma | graduation | postgrad
  name_hi    text not null,
  name_en    text not null,
  level_id   text not null references mtb.content_levels(id),
  branch     text,                      -- mechanical | civil | electrical | electronics | computer
  course     jsonb not null default '[]'::jsonb,   -- [{"subject":"maths"},{"subject":"general-science","units":["physics"]}]
  stages     jsonb,                     -- e.g. {"label_hi":"सेमेस्टर","label_en":"Semester","list":["1","2",...]}
  passed_ok  boolean not null default true,        -- can the student say "already passed"?
  why        text,                      -- justification of the course filter
  sort       int not null default 0,
  active     boolean not null default true
);

create table if not exists mtb.qualification_exams (
  qual_slug  text not null references mtb.qualifications(slug),
  target     text not null,             -- exam family slug (mtb.exams.family_slug) or 'level:<content level id>'
  label_hi   text,                      -- only for 'level:' targets
  label_en   text,
  status     text not null default 'any' check (status in ('any','passed')),   -- 'passed' = shown only after passing
  why        text,
  sort       int not null default 0,
  primary key (qual_slug, target)
);

create table if not exists mtb.subject_units (
  subject_slug text not null,
  slug         text not null,
  name_hi      text not null,
  name_en      text not null,
  sort         int not null default 0,
  chapter_ids  int[] not null,          -- in syllabus order
  primary key (subject_slug, slug)
);

alter table mtb.qualifications enable row level security;
alter table mtb.qualification_exams enable row level security;
alter table mtb.subject_units enable row level security;

-- ---------- qualifications ----------
insert into mtb.qualifications (slug, cat, name_hi, name_en, level_id, branch, course, stages, passed_ok, why, sort) values
 ('class-6','school','कक्षा 6','Class 6','class_6_8',null,'[{"subject":"maths"},{"subject":"general-science"}]',null,false,'school board syllabus: maths + science; reasoning is not a board subject',10),
 ('class-7','school','कक्षा 7','Class 7','class_6_8',null,'[{"subject":"maths"},{"subject":"general-science"}]',null,false,'same as class 6',11),
 ('class-8','school','कक्षा 8','Class 8','class_6_8',null,'[{"subject":"maths"},{"subject":"general-science"}]',null,false,'same as class 6',12),
 ('class-9','school','कक्षा 9','Class 9','class_9_10',null,'[{"subject":"maths"},{"subject":"general-science"}]',null,false,'board: maths + science',13),
 ('class-10','school','कक्षा 10','Class 10','class_9_10',null,'[{"subject":"maths"},{"subject":"general-science"}]',null,true,'board: maths + science',14),
 ('class-11-12-pcm','school','कक्षा 11-12 विज्ञान (PCM)','Class 11-12 Science (PCM)','class_11_12_sci',null,'[{"subject":"maths"},{"subject":"general-science","units":["physics","chemistry"]}]','{"label_hi":"कक्षा","label_en":"Class","list":["11","12"]}',true,'PCM = physics, chemistry, maths; no biology',20),
 ('class-11-12-pcb','school','कक्षा 11-12 विज्ञान (PCB)','Class 11-12 Science (PCB)','class_11_12_sci',null,'[{"subject":"general-science","units":["physics","chemistry","biology","environment"]}]','{"label_hi":"कक्षा","label_en":"Class","list":["11","12"]}',true,'PCB = physics, chemistry, biology; no maths',21),
 ('class-11-12-commerce','school','कक्षा 11-12 कॉमर्स','Class 11-12 Commerce','class_11_12_com',null,'[{"subject":"accountancy"},{"subject":"business-studies"},{"subject":"economics-com"},{"subject":"maths-com"}]','{"label_hi":"कक्षा","label_en":"Class","list":["11","12"]}',true,'commerce board subjects only',22),
 ('class-11-12-arts','school','कक्षा 11-12 कला','Class 11-12 Arts','class_11_12_arts',null,'[{"subject":"history"},{"subject":"political-science"},{"subject":"geography-arts"},{"subject":"sociology"},{"subject":"psychology"}]','{"label_hi":"कक्षा","label_en":"Class","list":["11","12"]}',true,'arts board subjects only',23),
 ('diploma-mechanical','diploma','डिप्लोमा इन मैकेनिकल इंजीनियरिंग','Diploma in Mechanical Engineering','govt_technical','mechanical','[{"subject":"mechanical-engineering"}]','{"label_hi":"सेमेस्टर","label_en":"Semester","list":["1","2","3","4","5","6"]}',true,'own branch technical subjects only',30),
 ('diploma-civil','diploma','डिप्लोमा इन सिविल इंजीनियरिंग','Diploma in Civil Engineering','govt_technical','civil','[{"subject":"civil-engineering"}]','{"label_hi":"सेमेस्टर","label_en":"Semester","list":["1","2","3","4","5","6"]}',true,'own branch technical subjects only',31),
 ('diploma-electrical','diploma','डिप्लोमा इन इलेक्ट्रिकल इंजीनियरिंग','Diploma in Electrical Engineering','govt_technical','electrical','[{"subject":"electrical-engineering"}]','{"label_hi":"सेमेस्टर","label_en":"Semester","list":["1","2","3","4","5","6"]}',true,'own branch technical subjects only',32),
 ('diploma-electronics','diploma','डिप्लोमा इन इलेक्ट्रॉनिक्स एवं संचार इंजीनियरिंग','Diploma in Electronics & Communication Engineering','govt_technical','electronics','[]','{"label_hi":"सेमेस्टर","label_en":"Semester","list":["1","2","3","4","5","6"]}',true,'branch content not written yet',33),
 ('diploma-computer','diploma','डिप्लोमा इन कंप्यूटर साइंस इंजीनियरिंग','Diploma in Computer Science Engineering','govt_technical','computer','[]','{"label_hi":"सेमेस्टर","label_en":"Semester","list":["1","2","3","4","5","6"]}',true,'branch content not written yet',34),
 ('btech-mechanical','graduation','बी.टेक / बी.ई. (मैकेनिकल इंजीनियरिंग)','B.Tech / B.E. (Mechanical Engineering)','govt_technical','mechanical','[{"subject":"mechanical-engineering"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3","4"]}',true,'core branch subjects',40),
 ('btech-civil','graduation','बी.टेक / बी.ई. (सिविल इंजीनियरिंग)','B.Tech / B.E. (Civil Engineering)','govt_technical','civil','[{"subject":"civil-engineering"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3","4"]}',true,'core branch subjects',41),
 ('btech-electrical','graduation','बी.टेक / बी.ई. (इलेक्ट्रिकल इंजीनियरिंग)','B.Tech / B.E. (Electrical Engineering)','govt_technical','electrical','[{"subject":"electrical-engineering"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3","4"]}',true,'core branch subjects',42),
 ('btech-electronics','graduation','बी.टेक / बी.ई. (इलेक्ट्रॉनिक्स एवं संचार)','B.Tech / B.E. (Electronics & Communication)','govt_technical','electronics','[]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3","4"]}',true,'branch content not written yet',43),
 ('btech-computer','graduation','बी.टेक / बी.ई. (कंप्यूटर साइंस)','B.Tech / B.E. (Computer Science)','govt_technical','computer','[]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3","4"]}',true,'branch content not written yet',44),
 ('bsc','graduation','बी.एससी. (विज्ञान स्नातक)','B.Sc. (Bachelor of Science)','graduation_sci',null,'[{"subject":"general-science"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3"]}',true,'science graduation content',45),
 ('bcom','graduation','बी.कॉम. (वाणिज्य स्नातक)','B.Com. (Bachelor of Commerce)','graduation_com',null,'[{"subject":"advanced-accountancy"},{"subject":"business-law"},{"subject":"cost-accounting"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3"]}',true,'commerce graduation content',46),
 ('ba','graduation','बी.ए. (कला स्नातक)','B.A. (Bachelor of Arts)','graduation_arts',null,'[{"subject":"advanced-history"},{"subject":"advanced-polity"},{"subject":"advanced-geography"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3"]}',true,'arts graduation content',47),
 ('postgrad','postgrad','स्नातकोत्तर / शोध (M.Sc., M.Tech., M.A., PhD)','Postgraduate / Research (M.Sc., M.Tech., M.A., PhD)','advanced_research',null,'[]',null,true,'research level: exams only',50)
on conflict (slug) do nothing;

-- ---------- exams each qualification can target (eligibility as per official notifications) ----------
insert into mtb.qualification_exams (qual_slug, target, label_hi, label_en, status, why, sort) values
 ('class-11-12-pcm','jee-main',null,null,'any','10+2 with PCM; class 12 students can appear',1),
 ('class-11-12-pcm','jee-advanced',null,null,'any','after JEE Main, PCM',2),
 ('class-11-12-pcm','nda',null,null,'any','10+2 (appearing allowed); PCM for Air Force/Navy',3),
 ('class-11-12-pcm','rrb-ntpc',null,null,'passed','undergraduate posts need 12th pass',4),
 ('class-11-12-pcb','neet-ug',null,null,'any','10+2 with PCB; class 12 students can appear',1),
 ('class-11-12-pcb','nda',null,null,'any','Army wing: 10+2 any stream',2),
 ('class-11-12-pcb','rrb-ntpc',null,null,'passed','undergraduate posts need 12th pass',3),
 ('class-11-12-commerce','nda',null,null,'any','Army wing: 10+2 any stream',1),
 ('class-11-12-commerce','rrb-ntpc',null,null,'passed','undergraduate posts need 12th pass',2),
 ('class-11-12-commerce','level:law_management','क्लैट (लॉ प्रवेश)','CLAT (law entrance)','any','CLAT UG: 10+2 any stream',3),
 ('class-11-12-arts','nda',null,null,'any','Army wing: 10+2 any stream',1),
 ('class-11-12-arts','rrb-ntpc',null,null,'passed','undergraduate posts need 12th pass',2),
 ('class-11-12-arts','level:law_management','क्लैट (लॉ प्रवेश)','CLAT (law entrance)','any','CLAT UG: 10+2 any stream',3),
 ('diploma-mechanical','ssc-je',null,null,'any','SSC JE (Mechanical): diploma in mechanical engineering',1),
 ('diploma-mechanical','rrb-je',null,null,'any','RRB JE (Mechanical group): diploma in mechanical engineering',2),
 ('diploma-civil','ssc-je',null,null,'any','SSC JE (Civil): diploma in civil engineering',1),
 ('diploma-civil','rrb-je',null,null,'any','RRB JE (Civil group)',2),
 ('diploma-electrical','ssc-je',null,null,'any','SSC JE (Electrical): diploma in electrical engineering',1),
 ('diploma-electrical','rrb-je',null,null,'any','RRB JE (Electrical group)',2),
 ('diploma-electronics','rrb-je',null,null,'any','RRB JE (Electronics group); SSC JE has no ECE post',1),
 ('diploma-computer','rrb-je',null,null,'any','RRB JE (IT); SSC JE has no CS post',1)
on conflict do nothing;

-- graduates: technical JE (own branch) + graduate-level exams
insert into mtb.qualification_exams (qual_slug, target, label_hi, label_en, status, why, sort)
select q.slug, t.target, t.lh, t.le, 'any', t.why, t.sort
from mtb.qualifications q
cross join (values
  ('rrb-ntpc', null, null, 'graduate posts: any degree', 10),
  ('ibps-po', null, null, 'any graduate', 11),
  ('sbi-po', null, null, 'any graduate (final year allowed)', 12),
  ('cds', null, null, 'graduate (stream rules per academy)', 13),
  ('uppsc', null, null, 'any graduate', 14),
  ('bpsc', null, null, 'any graduate', 15),
  ('upsc-cse', null, null, 'any graduate', 16),
  ('level:law_management', 'कैट / लॉ-मैनेजमेंट', 'CAT / Law-Management', 'CAT and similar: any graduate', 17),
  ('level:advanced_research', 'गेट / नेट (उच्च शोध)', 'GATE / NET (research)', 'GATE: final-year B.Tech/B.Sc and above', 18)
) as t(target, lh, le, why, sort)
where q.cat in ('graduation','postgrad')
on conflict do nothing;

insert into mtb.qualification_exams (qual_slug, target, status, why, sort) values
 ('btech-mechanical','ssc-je','any','B.Tech in mechanical is eligible for SSC JE (Mechanical)',1),
 ('btech-mechanical','rrb-je','any','B.Tech eligible for RRB JE',2),
 ('btech-civil','ssc-je','any','B.Tech civil eligible for SSC JE (Civil)',1),
 ('btech-civil','rrb-je','any','B.Tech eligible for RRB JE',2),
 ('btech-electrical','ssc-je','any','B.Tech electrical eligible for SSC JE (Electrical)',1),
 ('btech-electrical','rrb-je','any','B.Tech eligible for RRB JE',2),
 ('btech-electronics','rrb-je','any','B.Tech eligible for RRB JE (Electronics)',1),
 ('btech-computer','rrb-je','any','B.Tech eligible for RRB JE (IT)',1)
on conflict do nothing;

-- ---------- syllabus subjects inside a subject ----------
insert into mtb.subject_units (subject_slug, slug, name_hi, name_en, sort, chapter_ids) values
 ('mechanical-engineering','engineering-mechanics','इंजीनियरिंग मैकेनिक्स','Engineering Mechanics',1,'{433}'),
 ('mechanical-engineering','strength-of-materials','पदार्थों की सामर्थ्य (SOM)','Strength of Materials',2,'{439}'),
 ('mechanical-engineering','theory-of-machines','मशीनों का सिद्धांत (TOM)','Theory of Machines',3,'{440}'),
 ('mechanical-engineering','machine-design','मशीन डिज़ाइन','Machine Design',4,'{1616}'),
 ('mechanical-engineering','engineering-materials','इंजीनियरिंग सामग्री','Engineering Materials',5,'{432}'),
 ('mechanical-engineering','thermal-engineering','थर्मल इंजीनियरिंग','Thermal Engineering',6,'{441,438,435,1618,437,1619,1617}'),
 ('mechanical-engineering','fluid-mechanics','द्रव यांत्रिकी और मशीनरी','Fluid Mechanics & Machinery',7,'{434}'),
 ('mechanical-engineering','industrial-engineering','औद्योगिक अभियांत्रिकी','Industrial Engineering',8,'{1620}'),
 ('mechanical-engineering','production-engineering','उत्पादन इंजीनियरिंग','Production Engineering',9,'{436}'),
 ('mechanical-engineering','metrology','मापिकी और मापन','Metrology & Measurement',10,'{1621}'),
 ('mechanical-engineering','advanced-manufacturing','उन्नत विनिर्माण','Advanced Manufacturing',11,'{1622}')
on conflict do nothing;

insert into mtb.subject_units (subject_slug, slug, name_hi, name_en, sort, chapter_ids)
select 'general-science', lower(u.unit_en),
       case u.unit_en when 'Physics' then 'भौतिकी' when 'Chemistry' then 'रसायन विज्ञान' when 'Biology' then 'जीव विज्ञान' else 'पर्यावरण' end,
       u.unit_en,
       case u.unit_en when 'Physics' then 1 when 'Chemistry' then 2 when 'Biology' then 3 else 4 end,
       array_agg(t.id order by t.sort, t.id)
from mtb.topics t join mtb.subjects s on s.id = t.subject_id
cross join lateral (select t.unit_en) u
where s.slug = 'general-science' and t.is_chapter and t.unit_en is not null
group by u.unit_en
on conflict do nothing;

-- ---------- one read for the wizard ----------
create or replace function mtb.get_setup_config()
 returns jsonb language sql stable security definer set search_path to 'mtb', 'pg_catalog'
as $$
  select jsonb_build_object(
    'quals', (select jsonb_agg(jsonb_build_object('slug', q.slug, 'cat', q.cat, 'hi', q.name_hi, 'en', q.name_en, 'level', q.level_id,
                'branch', q.branch, 'course', q.course, 'stages', q.stages, 'passed_ok', q.passed_ok,
                'exams', coalesce((select jsonb_agg(jsonb_build_object('target', x.target, 'status', x.status, 'hi', x.label_hi, 'en', x.label_en) order by x.sort)
                                   from mtb.qualification_exams x where x.qual_slug = q.slug), '[]'::jsonb)) order by q.sort)
              from mtb.qualifications q where q.active),
    'families', (select jsonb_object_agg(f.family_slug, f.j) from (
                   select e.family_slug, jsonb_build_object('hi', min(e.family_hi), 'en', min(e.family_en), 'level', min(e.content_level),
                     'subjects', (select jsonb_agg(distinct sj) from mtb.exams e2 join mtb.exam_sections x on x.exam_id = e2.id
                                  cross join lateral jsonb_array_elements_text(to_jsonb(x.subjects)) sj where e2.family_slug = e.family_slug)) j
                   from mtb.exams e where e.active and e.family_slug is not null group by e.family_slug) f),
    'levels', (select jsonb_object_agg(l.id, jsonb_build_object('hi', l.name_hi, 'en', l.name_en)) from mtb.content_levels l),
    'branches', (select jsonb_object_agg(b.slug, b.name_en) from mtb.branches b),
    'units', (select jsonb_object_agg(u.subject_slug, u.list) from (
                select subject_slug, jsonb_agg(jsonb_build_object('slug', slug, 'hi', name_hi, 'en', name_en, 'ch', to_jsonb(chapter_ids)) order by sort) list
                from mtb.subject_units group by subject_slug) u));
$$;
grant execute on function mtb.get_setup_config() to anon, authenticated;
