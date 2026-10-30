-- 0028 Content levels + atoms (additive only). Live: applied 2026-10-30.
-- One chapter (mtb.topics row) can carry notes at different depths. An exam picks its depth via exams.content_level.
-- Name note: mtb.profiles already exists (per-student settings), so the depth table is mtb.content_levels.
-- Questions (PYQ / Practice) are untouched; atoms are chapter notes shown above the question buttons.

create table if not exists mtb.content_levels (
  id text primary key,
  name_en text not null,
  name_hi text not null,
  depth int not null,
  covers text,
  sort int not null default 0
);

insert into mtb.content_levels (id, name_en, name_hi, depth, covers, sort) values
  ('class_6_8','Class 6-8','कक्षा 6-8',1,'School 6-8, NTSE stage 1',1),
  ('class_9_10','Class 9-10','कक्षा 9-10',2,'Board 9-10, NTSE, Olympiad foundation',2),
  ('class_11_12_sci','Class 11-12 Science','कक्षा 11-12 विज्ञान',3,'Board PCM/PCB',3),
  ('class_11_12_com','Class 11-12 Commerce','कक्षा 11-12 कॉमर्स',3,'Board Commerce',4),
  ('class_11_12_arts','Class 11-12 Arts','कक्षा 11-12 कला',3,'Board Arts',5),
  ('govt_basic','Govt Basic','सरकारी (सामान्य)',2,'SSC CGL/CHSL/MTS, RRB NTPC/Group D, police',6),
  ('govt_technical','Govt Technical','सरकारी (तकनीकी)',3,'SSC JE, RRB JE, ITI, diploma PSU',7),
  ('banking','Banking','बैंकिंग',3,'IBPS, SBI, RBI, NABARD',8),
  ('govt_defence','Defence','रक्षा',3,'NDA, CDS, AFCAT, Agniveer',9),
  ('state_psc','State PSC','राज्य PSC',4,'UPPSC, BPSC, MPSC, RPSC',10),
  ('upsc_civil','UPSC Civil','UPSC सिविल',5,'UPSC CSE, CAPF',11),
  ('medical','Medical','मेडिकल',3,'NEET, AIIMS, nursing',12),
  ('engineering','Engineering','इंजीनियरिंग',4,'JEE Main/Advanced, BITSAT, CETs',13),
  ('graduation_sci','Graduation Science','स्नातक विज्ञान',4,'B.Sc, B.Tech 1-2 year',14),
  ('graduation_com','Graduation Commerce','स्नातक कॉमर्स',4,'B.Com, BBA, CA Foundation',15),
  ('graduation_arts','Graduation Arts','स्नातक कला',4,'BA',16),
  ('advanced_research','Advanced Research','उच्च शोध',6,'GATE, CSIR/UGC NET, PhD',17),
  ('law_management','Law / Management','कानून / प्रबंधन',5,'CLAT, CAT, XAT, MAT',18)
on conflict (id) do nothing;

alter table mtb.exams add column if not exists content_level text references mtb.content_levels(id);

create table if not exists mtb.atoms (
  id bigint generated always as identity primary key,
  chapter_id int not null references mtb.topics(id),
  level_id text references mtb.content_levels(id),   -- null = shared by every level (e.g. a diagram)
  atom_key text not null,                              -- same idea across levels shares a key, e.g. 'phy-force-concept'
  atom_type text not null check (atom_type in ('concept','formula','example','mcq','svg')),
  atom_order int not null default 0,
  title text,
  body jsonb not null,
  lang text not null default 'hi' check (lang in ('hi','en','both')),
  status text not null default 'published' check (status in ('draft','published','hidden')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create unique index if not exists atoms_one_per_level on mtb.atoms (chapter_id, atom_key, coalesce(level_id,'*'));
create index if not exists atoms_chapter_level on mtb.atoms (chapter_id, level_id, atom_order);

-- Read-only for the app (same rule as other reference data); writes only by service_role.
alter table mtb.content_levels enable row level security;
alter table mtb.atoms enable row level security;
do $$ begin
  if not exists (select 1 from pg_policies where policyname='read_levels') then
    create policy read_levels on mtb.content_levels for select using (true);
  end if;
  if not exists (select 1 from pg_policies where policyname='read_published_atoms') then
    create policy read_published_atoms on mtb.atoms for select using (status = 'published');
  end if;
end $$;
grant select on mtb.content_levels, mtb.atoms to anon, authenticated;
grant select, insert, update, delete on mtb.content_levels, mtb.atoms to service_role;

-- Exam → level (only exams that exist today).
update mtb.exams set content_level = 'govt_technical' where content_level is null and slug in ('rrb-je-cbt1','rrb-je-cbt2','ssc-je-paper1');
update mtb.exams set content_level = 'govt_basic'     where content_level is null and slug like 'rrb-ntpc-%';
