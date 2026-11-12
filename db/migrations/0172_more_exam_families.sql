-- 0172: exam families that were missing in the setup (audit 2026-11-12). Additive only: new setup_only exams + eligibility rows.
-- Backup of qualification_exams before this: mtb.bk_0172_qualification_exams.
create table if not exists mtb.bk_0172_qualification_exams as select * from mtb.qualification_exams;

create temporary table _fam (slug text, hi text, en text, lvl text, cat text, subj text[]) on commit drop;
insert into _fam values
 ('rpf-constable','आरपीएफ़ कांस्टेबल','RPF Constable','govt_basic','railway','{maths,reasoning,general-awareness}'),
 ('rpf-si','आरपीएफ़ सब-इंस्पेक्टर','RPF Sub-Inspector','govt_basic','railway','{maths,reasoning,general-awareness}'),
 ('ssc-selection-post','एसएससी सिलेक्शन पोस्ट','SSC Selection Post','govt_basic','ssc','{english,general-awareness,maths,reasoning}'),
 ('state-ssc','राज्य कर्मचारी चयन आयोग (BSSC, UPSSSC, HSSC, RSMSSB आदि)','State SSC (BSSC, UPSSSC, HSSC, RSMSSB etc.)','govt_basic','ssc','{general-awareness,general-science,hindi,maths,reasoning}'),
 ('dsssb','डीएसएसएसबी (दिल्ली अधीनस्थ सेवा)','DSSSB (Delhi Subordinate Services)','govt_basic','ssc','{english,general-awareness,hindi,maths,reasoning}'),
 ('state-psc','अन्य राज्य लोक सेवा आयोग (HPSC, JPSC, WBPSC, OPSC आदि)','Other State PSC (HPSC, JPSC, WBPSC, OPSC etc.)','state_psc','civil-services','{general-awareness,general-science,maths,reasoning}'),
 ('state-teacher','राज्य शिक्षक भर्ती (BPSC TRE, UP TGT/PGT, REET मुख्य आदि)','State teacher recruitment (BPSC TRE, UP TGT/PGT, REET Mains etc.)','govt_basic','teaching','{child-development-pedagogy,general-awareness,hindi,english,maths,general-science}'),
 ('agri-officer','कृषि अधिकारी (IBPS AFO, राज्य कृषि अधिकारी)','Agriculture Officer (IBPS AFO, State Agriculture Officer)','graduation_sci','banking','{general-science:biology+chemistry,general-awareness,reasoning,english}');
insert into mtb.exams (slug, name_en, name_hi, active, setup_only, family_slug, family_hi, family_en, content_level, exam_cat, stage_sort, setup_subjects)
select f.slug, f.en, f.hi, false, true, f.slug, f.hi, f.en, f.lvl, f.cat, 1, f.subj from _fam f
on conflict (slug) do nothing;

create temporary table _el (q text, t text, st text, why text) on commit drop;
-- 10th-pass level
insert into _el select a.q, b.t, b.st, b.why from (values ('class-10'),('class-11-12-pcm'),('class-11-12-pcb'),('class-11-12-commerce'),('class-11-12-arts')) a(q)
 cross join (values ('rpf-constable','passed','RPF Constable: 10th pass'),('ssc-selection-post','passed','matric-level posts: 10th pass'),('state-ssc','passed','10th / 12th level posts')) b(t, st, why);
insert into _el select a.q, b.t, 'any', b.why from (values ('class-10-pass'),('class-12-pass'),('iti-mechanical'),('iti-electrical'),('iti-copa'),
  ('diploma-mechanical'),('diploma-civil'),('diploma-electrical'),('diploma-electronics'),('diploma-computer'),('diploma-automobile'),
  ('diploma-pharmacy'),('diploma-nursing'),('diploma-deled')) a(q)
 cross join (values ('rpf-constable','RPF Constable: 10th pass'),('ssc-selection-post','matric / higher-secondary level posts'),('state-ssc','10th / 12th level posts')) b(t, why);
insert into _el select a.q, 'dsssb', 'any', 'DSSSB: 10th / 12th / graduate posts' from (values ('class-12-pass'),('diploma-deled')) a(q);
insert into _el select a.q, 'dsssb', 'passed', 'DSSSB: 12th-level posts' from (values ('class-11-12-pcm'),('class-11-12-pcb'),('class-11-12-commerce'),('class-11-12-arts')) a(q);
insert into _el values ('diploma-deled','state-teacher','any','primary teacher: D.El.Ed + TET');
-- every graduate / postgraduate
insert into _el select q.slug, b.t, 'any', b.why from mtb.qualifications q cross join (values
 ('rpf-si','RPF SI: any graduate'),('rpf-constable','10th pass'),('ssc-selection-post','graduate-level posts'),('state-ssc','graduate-level posts'),
 ('dsssb','graduate posts'),('state-psc','any graduate')) b(t, why)
 where q.cat in ('graduation','postgrad');
insert into _el values ('bed','state-teacher','any','TGT / upper primary: graduate + B.Ed'),('bsc-agriculture','agri-officer','any','B.Sc Agriculture');

insert into mtb.qualification_exams (qual_slug, target, status, why, sort)
select q, t, min(st), min(why), 200 + (row_number() over (partition by q order by t))::int from _el
where exists (select 1 from mtb.qualifications where slug = q)
group by q, t
on conflict (qual_slug, target) do nothing;
