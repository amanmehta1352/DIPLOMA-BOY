-- 0007: universal path. Exam family + stage, subject aliases, auto-path functions (robot only), import queue,
--       RRB JE CBT-2 with its official sections. Additive only (no DROP / DELETE).
alter table mtb.exams add column if not exists family_slug text;
alter table mtb.exams add column if not exists family_hi text;
alter table mtb.exams add column if not exists family_en text;
alter table mtb.exams add column if not exists stage_hi text;
alter table mtb.exams add column if not exists stage_en text;
alter table mtb.exams add column if not exists stage_sort int not null default 1;
update mtb.exams set family_slug='rrb-je', family_hi='आरआरबी जेई', family_en='RRB JE', stage_hi='सीबीटी-1', stage_en='CBT-1', stage_sort=1 where slug='rrb-je-cbt1' and family_slug is null;
update mtb.exams set family_slug='ssc-je', family_hi='एसएससी जेई', family_en='SSC JE', stage_hi='पेपर-I', stage_en='Paper-I', stage_sort=1 where slug='ssc-je-paper1' and family_slug is null;

-- new common subjects needed by RRB JE CBT-2
insert into mtb.subjects(slug,name_en,name_hi,branch_id) values
  ('computer-basics','Basics of Computers','कंप्यूटर की बुनियादी बातें',null),
  ('environment','Environment & Pollution Control','पर्यावरण और प्रदूषण नियंत्रण',null)
on conflict (slug) do nothing;

insert into mtb.exams(slug,name_en,name_hi,level,pattern,family_slug,family_hi,family_en,stage_hi,stage_en,stage_sort)
values ('rrb-je-cbt2','RRB JE CBT 2','आरआरबी जेई सीबीटी 2','diploma',
  '{"minutes":120,"questions":150,"marks_per_q":1,"negative_per_wrong":0.3333,"sections":["general-awareness","general-science","computer-basics","environment","branch-engineering"]}'::jsonb,
  'rrb-je','आरआरबी जेई','RRB JE','सीबीटी-2','CBT-2',2)
on conflict (slug) do nothing;
insert into mtb.exam_branches(exam_id,branch_id)
  select e.id, b.id from mtb.exams e cross join mtb.branches b where e.slug='rrb-je-cbt2' on conflict do nothing;
insert into mtb.exam_sections(exam_id,sort,slug,name_hi,name_en,questions,qno_from,qno_to,subjects)
select e.id, v.sort, v.slug, v.hi, v.en, v.n, null, null, v.subj from mtb.exams e join (values
  (1,'general-awareness','सामान्य जागरूकता','General Awareness',15,array['general-awareness']),
  (2,'physics-chemistry','भौतिकी और रसायन','Physics & Chemistry',15,array['general-science']),
  (3,'computer-basics','कंप्यूटर की बुनियादी बातें','Basics of Computers',10,array['computer-basics']),
  (4,'environment','पर्यावरण और प्रदूषण नियंत्रण','Environment & Pollution Control',10,array['environment']),
  (5,'technical','तकनीकी (आपकी ब्रांच)','Technical abilities (your branch)',100,array['branch-engineering'])
) as v(sort,slug,hi,en,n,subj) on e.slug='rrb-je-cbt2'
on conflict (exam_id,slug) do nothing;

-- every name a paper may use for a section → our subject ('branch-engineering' = the paper's branch subject)
create table if not exists mtb.subject_aliases (alias text primary key, subject_slug text not null);
alter table mtb.subject_aliases enable row level security;
insert into mtb.subject_aliases(alias,subject_slug) values
  ('mathematics','maths'),('maths','maths'),('quantitative aptitude','maths'),('arithmetic','maths'),('गणित','maths'),
  ('general intelligence and reasoning','reasoning'),('general intelligence & reasoning','reasoning'),('reasoning','reasoning'),('general intelligence','reasoning'),('तर्कशक्ति','reasoning'),('सामान्य बुद्धि और तर्क','reasoning'),
  ('general awareness','general-awareness'),('general knowledge','general-awareness'),('current affairs','general-awareness'),('सामान्य जागरूकता','general-awareness'),('सामान्य ज्ञान','general-awareness'),
  ('general science','general-science'),('science','general-science'),('physics and chemistry','general-science'),('physics & chemistry','general-science'),('सामान्य विज्ञान','general-science'),
  ('basics of computers and applications','computer-basics'),('basics of computers','computer-basics'),('computer awareness','computer-basics'),
  ('basics of environment and pollution control','environment'),('environment','environment'),
  ('technical abilities','branch-engineering'),('technical ability','branch-engineering'),('engineering','branch-engineering'),('general engineering','branch-engineering'),('technical','branch-engineering'),
  ('general engineering civil and structural','civil-engineering'),('general engineering (civil & structural)','civil-engineering'),('civil engineering','civil-engineering'),
  ('general engineering mechanical','mechanical-engineering'),('general engineering (mechanical)','mechanical-engineering'),('mechanical engineering','mechanical-engineering'),
  ('general engineering electrical','electrical-engineering'),('general engineering (electrical)','electrical-engineering'),('electrical engineering','electrical-engineering')
on conflict (alias) do nothing;

create or replace function mtb.norm_name(t text) returns text language sql immutable as
$$ select trim(regexp_replace(lower(coalesce(t,'')), '[^a-z0-9ऀ-ॿ&]+', ' ', 'g')) $$;
create or replace function mtb.slugify(t text) returns text language sql immutable as
$$ select trim(both '-' from regexp_replace(lower(coalesce(t,'')), '[^a-z0-9]+', '-', 'g')) $$;

-- exam: find or create (family + stage)
create or replace function mtb.ensure_exam(p_family_en text, p_family_hi text, p_stage_en text, p_stage_hi text, p_stage_sort int default 1)
returns int language plpgsql security definer set search_path = mtb, public as $$
declare v_slug text := mtb.slugify(p_family_en || ' ' || coalesce(p_stage_en,'')); v_id int;
begin
  select id into v_id from mtb.exams where slug = v_slug or (family_slug = mtb.slugify(p_family_en) and mtb.norm_name(stage_en) = mtb.norm_name(p_stage_en)) limit 1;
  if v_id is null then
    insert into mtb.exams(slug,name_en,name_hi,level,pattern,family_slug,family_hi,family_en,stage_hi,stage_en,stage_sort,active)
    values (v_slug, trim(p_family_en||' '||coalesce(p_stage_en,'')), trim(coalesce(p_family_hi,p_family_en)||' '||coalesce(p_stage_hi,p_stage_en,'')), 'diploma', '{}'::jsonb,
            mtb.slugify(p_family_en), coalesce(p_family_hi,p_family_en), p_family_en, coalesce(p_stage_hi,p_stage_en), p_stage_en, coalesce(p_stage_sort,1), false)
    returning id into v_id;   -- new exam stays hidden (active=false) until its first paper is published
  end if;
  return v_id;
end $$;

create or replace function mtb.ensure_branch(p_en text, p_hi text default null)
returns int language plpgsql security definer set search_path = mtb, public as $$
declare v_id int;
begin
  select id into v_id from mtb.branches where slug = mtb.slugify(p_en) or mtb.norm_name(name_en) = mtb.norm_name(p_en) limit 1;
  if v_id is null then insert into mtb.branches(slug,name_en,name_hi,sort) values (mtb.slugify(p_en), p_en, coalesce(p_hi,p_en), 99) returning id into v_id; end if;
  return v_id;
end $$;

-- section name in a paper → subject id (creates subject + alias when new)
create or replace function mtb.ensure_subject(p_section text, p_branch_id int default null, p_hi text default null)
returns int language plpgsql security definer set search_path = mtb, public as $$
declare v_slug text; v_id int; v_alias text := mtb.norm_name(p_section);
begin
  select subject_slug into v_slug from mtb.subject_aliases where alias = v_alias;
  if v_slug = 'branch-engineering' then
    select id into v_id from mtb.subjects where branch_id = p_branch_id order by id limit 1;
    if v_id is null and p_branch_id is not null then
      insert into mtb.subjects(slug,name_en,name_hi,branch_id)
        select b.slug||'-engineering', b.name_en||' Engineering', b.name_hi||' इंजीनियरिंग', b.id from mtb.branches b where b.id = p_branch_id
        on conflict (slug) do nothing;
      select id into v_id from mtb.subjects where branch_id = p_branch_id order by id limit 1;
    end if;
    return v_id;
  end if;
  if v_slug is not null then select id into v_id from mtb.subjects where slug = v_slug; return v_id; end if;
  v_slug := mtb.slugify(p_section);
  insert into mtb.subjects(slug,name_en,name_hi,branch_id) values (v_slug, initcap(p_section), coalesce(p_hi, p_section), null) on conflict (slug) do nothing;
  insert into mtb.subject_aliases(alias,subject_slug) values (v_alias, v_slug) on conflict do nothing;
  select id into v_id from mtb.subjects where slug = v_slug;
  return v_id;
end $$;

-- holding chapter for questions the Tag Robot has not placed yet (never shown as a chapter)
create or replace function mtb.ensure_inbox(p_subject_id int)
returns int language plpgsql security definer set search_path = mtb, public as $$
declare v_id int;
begin
  insert into mtb.topics(subject_id,slug,name_en,name_hi,sort,is_chapter) values (p_subject_id,'inbox','To be tagged','टैग बाकी',9999,false)
  on conflict (subject_id,slug) do nothing;
  select id into v_id from mtb.topics where subject_id = p_subject_id and slug = 'inbox';
  return v_id;
end $$;

-- import queue (filled from the admin page, worked by the GitHub robot)
create table if not exists mtb.import_jobs (
  id bigserial primary key,
  kind text not null check (kind in ('link','upload')),
  url text, storage_path text,
  exam_hint text, stage_hint text, branch_hint text, paper_date date, shift int,
  status text not null default 'queued' check (status in ('queued','running','review','published','failed','cancelled')),
  report jsonb not null default '{}'::jsonb,
  created_by uuid, created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
  constraint one_input check (url is not null or storage_path is not null));
alter table mtb.import_jobs enable row level security;

revoke all on function mtb.ensure_exam(text,text,text,text,int), mtb.ensure_branch(text,text), mtb.ensure_subject(text,int,text), mtb.ensure_inbox(int) from public, anon, authenticated;
grant execute on function mtb.ensure_exam(text,text,text,text,int), mtb.ensure_branch(text,text), mtb.ensure_subject(text,int,text), mtb.ensure_inbox(int) to service_role;
grant select, insert, update on mtb.import_jobs, mtb.subject_aliases to service_role;
grant usage on sequence mtb.import_jobs_id_seq to service_role;
