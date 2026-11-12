-- 0169 student setup v2: every missing qualification and exam family, exam categories (tech / non-tech groups).
-- Additive only. New exams are inserted with active = false and setup_only = true, so the old level picker
-- (mtb.get_qualifications, which reads active exams) and every robot that reads active exams see no change.
-- Subject tokens in exams.setup_subjects (new column; exam_sections is left for exams whose question counts are known):
--   <subject slug>                      whole subject
--   <subject slug>:<unit>+<unit>        only those syllabus parts (mtb.subject_units)
--   branch-engineering                  the student's own engineering branch
--   branch-or-trade                     branch for diploma/B.Tech, trade theory for ITI
-- Eligibility below follows the general rules in the exams' official notifications (qualification only;
-- age limits, attempts and domicile are not modelled). Each row carries its reason in "why".

-- keep id sequences in step with the rows already present (some rows were loaded with explicit ids)
select setval('mtb.subjects_id_seq', (select max(id) from mtb.subjects));
select setval('mtb.exams_id_seq', (select max(id) from mtb.exams));
select setval('mtb.exam_sections_id_seq', (select max(id) from mtb.exam_sections));

alter table mtb.exams add column if not exists setup_only boolean not null default false;
alter table mtb.exams add column if not exists exam_cat text;
alter table mtb.exams add column if not exists setup_subjects text[];
alter table mtb.qualification_exams add column if not exists active boolean not null default true;

-- exam groups for the setup screen
create table if not exists mtb.exam_cats (
  slug text primary key, name_hi text not null, name_en text not null, tech boolean not null default false, sort int not null default 0);
alter table mtb.exam_cats enable row level security;
insert into mtb.exam_cats (slug, name_hi, name_en, tech, sort) values
 ('tech-je','जूनियर इंजीनियर (JE) / असिस्टेंट इंजीनियर','Junior / Assistant Engineer',true,1),
 ('tech-psu','PSU, मेट्रो और अनुसंधान संस्थान','PSU, Metro & Research bodies',true,2),
 ('tech-railway','रेलवे तकनीकी (ALP, टेक्नीशियन)','Railway technical (ALP, Technician)',true,3),
 ('tech-higher','GATE / ESE / लेटरल एंट्री','GATE / ESE / Lateral entry',true,4),
 ('railway','रेलवे (गैर-तकनीकी)','Railway (non-technical)',false,10),
 ('ssc','एसएससी (SSC)','Staff Selection Commission',false,11),
 ('banking','बैंक और बीमा','Banking & Insurance',false,12),
 ('defence','रक्षा (सेना, नौसेना, वायुसेना, CAPF)','Defence & CAPF',false,13),
 ('police','पुलिस','Police',false,14),
 ('civil-services','सिविल सेवा (UPSC, राज्य PSC)','Civil services (UPSC, State PSC)',false,15),
 ('teaching','शिक्षक भर्ती','Teaching',false,16),
 ('health','स्वास्थ्य (नर्सिंग, फ़ार्मेसी, मेडिकल)','Health (nursing, pharmacy, medical)',false,17),
 ('entrance','प्रवेश परीक्षाएँ','Entrance exams',false,18),
 ('school-comp','स्कूल प्रतियोगी परीक्षाएँ','School competitions',false,19),
 ('research','शोध / उच्च शिक्षा','Research / higher study',false,20),
 ('law-mgmt','लॉ और मैनेजमेंट','Law & Management',false,21)
on conflict (slug) do nothing;

update mtb.exams set exam_cat = case family_slug
  when 'ssc-je' then 'tech-je' when 'rrb-je' then 'tech-je' when 'rrb-ntpc' then 'railway'
  when 'ibps-po' then 'banking' when 'sbi-po' then 'banking' when 'nda' then 'defence' when 'cds' then 'defence'
  when 'upsc-cse' then 'civil-services' when 'uppsc' then 'civil-services' when 'bpsc' then 'civil-services'
  when 'neet-ug' then 'entrance' when 'jee-main' then 'entrance' when 'jee-advanced' then 'entrance' end
 where exam_cat is null and family_slug in ('ssc-je','rrb-je','rrb-ntpc','ibps-po','sbi-po','nda','cds','upsc-cse','uppsc','bpsc','neet-ug','jee-main','jee-advanced');

-- subjects that exams need but the app has no content for yet (shown locked "coming soon"; no chapters)
insert into mtb.subjects (slug, name_en, name_hi) values
 ('english','English Language','अंग्रेज़ी भाषा'),
 ('hindi','Hindi Language','हिंदी भाषा'),
 ('trade-theory','Trade Theory (ITI)','ट्रेड थ्योरी (ITI)'),
 ('child-development-pedagogy','Child Development & Pedagogy','बाल विकास एवं शिक्षाशास्त्र'),
 ('teaching-aptitude','Teaching & Research Aptitude','शिक्षण एवं शोध अभिरुचि'),
 ('nursing','Nursing','नर्सिंग'),
 ('pharmacy','Pharmacy','फ़ार्मेसी'),
 ('medicine','Medical Subjects (MBBS)','चिकित्सा विषय (MBBS)'),
 ('law','Law Subjects','विधि (कानून) विषय'),
 ('electronics-engineering','Electronics & Communication Engineering','इलेक्ट्रॉनिक्स एवं संचार इंजीनियरिंग'),
 ('computer-engineering','Computer Science Engineering','कंप्यूटर साइंस इंजीनियरिंग')
on conflict (slug) do nothing;

-- ---------- new exam families ----------
create temporary table _fam (slug text, hi text, en text, lvl text, cat text, subj text[]) on commit drop;
insert into _fam values
 -- railway
 ('rrb-group-d','आरआरबी ग्रुप डी','RRB Group D','govt_basic','railway','{maths,reasoning,general-science,general-awareness}'),
 ('rrb-alp','आरआरबी एएलपी (सहायक लोको पायलट)','RRB ALP (Assistant Loco Pilot)','govt_technical','tech-railway','{maths,reasoning,general-science,general-awareness,branch-or-trade}'),
 ('rrb-technician','आरआरबी टेक्नीशियन','RRB Technician','govt_technical','tech-railway','{maths,reasoning,general-science,general-awareness,branch-or-trade}'),
 ('rrb-paramedical','आरआरबी पैरामेडिकल (स्टाफ़ नर्स, फ़ार्मासिस्ट)','RRB Paramedical (Staff Nurse, Pharmacist)','medical','health','{nursing,pharmacy,maths,reasoning,general-science,general-awareness}'),
 -- SSC
 ('ssc-mts','एसएससी एमटीएस','SSC MTS','govt_basic','ssc','{maths,reasoning,english,general-awareness}'),
 ('ssc-gd','एसएससी जीडी कांस्टेबल','SSC GD Constable','govt_basic','ssc','{maths,reasoning,general-awareness,english,hindi}'),
 ('ssc-chsl','एसएससी सीएचएसएल','SSC CHSL','govt_basic','ssc','{maths,reasoning,english,general-awareness}'),
 ('ssc-steno','एसएससी स्टेनोग्राफ़र','SSC Stenographer','govt_basic','ssc','{reasoning,english,general-awareness}'),
 ('ssc-cgl','एसएससी सीजीएल','SSC CGL','govt_basic','ssc','{maths,reasoning,english,general-awareness}'),
 ('ssc-cpo','एसएससी सीपीओ (दिल्ली पुलिस/CAPF में SI)','SSC CPO (SI in Delhi Police & CAPF)','govt_basic','ssc','{maths,reasoning,english,general-awareness}'),
 -- banking
 ('ibps-clerk','आईबीपीएस क्लर्क','IBPS Clerk','banking','banking','{maths,reasoning,english,general-awareness,computer-basics}'),
 ('ibps-rrb','आईबीपीएस आरआरबी (ग्रामीण बैंक)','IBPS RRB (Regional Rural Banks)','banking','banking','{maths,reasoning,english,hindi,general-awareness,computer-basics}'),
 ('sbi-clerk','एसबीआई क्लर्क','SBI Clerk','banking','banking','{maths,reasoning,english,general-awareness,computer-basics}'),
 ('rbi-assistant','आरबीआई असिस्टेंट','RBI Assistant','banking','banking','{maths,reasoning,english,general-awareness,computer-basics}'),
 ('rbi-grade-b','आरबीआई ग्रेड बी','RBI Grade B','banking','banking','{maths,reasoning,english,general-awareness}'),
 ('lic-aao','एलआईसी एएओ','LIC AAO','banking','banking','{maths,reasoning,english,general-awareness}'),
 -- defence
 ('agniveer-army','अग्निवीर (थल सेना)','Agniveer (Army)','govt_defence','defence','{maths,reasoning,general-science,general-awareness}'),
 ('agniveer-navy','अग्निवीर (नौसेना)','Agniveer (Navy)','govt_defence','defence','{maths,general-science:physics+chemistry,english,general-awareness}'),
 ('agniveer-airforce','अग्निवीर वायु (वायुसेना)','Agniveer Vayu (Air Force)','govt_defence','defence','{maths,general-science:physics,english,reasoning,general-awareness}'),
 ('afcat','एएफ़कैट (वायुसेना अधिकारी)','AFCAT (Air Force officer)','govt_defence','defence','{maths,reasoning,english,general-awareness}'),
 ('army-tes','सेना टीईएस (10+2 टेक्निकल एंट्री)','Army TES (10+2 Technical Entry)','govt_defence','defence','{maths,general-science:physics+chemistry,english,reasoning}'),
 ('capf-ac','यूपीएससी सीएपीएफ़ (असिस्टेंट कमांडेंट)','UPSC CAPF (Assistant Commandant)','upsc_civil','defence','{general-awareness,reasoning,maths,english}'),
 -- police
 ('police-constable','राज्य पुलिस कांस्टेबल','State Police Constable','govt_basic','police','{maths,reasoning,general-awareness,hindi}'),
 ('police-si','राज्य पुलिस सब-इंस्पेक्टर (SI)','State Police Sub-Inspector (SI)','govt_basic','police','{maths,reasoning,general-awareness,general-science,hindi}'),
 -- civil services
 ('mppsc','एमपीपीएससी','MPPSC','state_psc','civil-services','{general-awareness,general-science,reasoning,maths}'),
 ('rpsc-ras','आरपीएससी आरएएस','RPSC RAS','state_psc','civil-services','{general-awareness,general-science,reasoning,maths}'),
 -- teaching
 ('ctet','सीटीईटी','CTET','govt_basic','teaching','{child-development-pedagogy,hindi,english,maths,environment,general-science}'),
 ('state-tet','राज्य टीईटी (STET/TET)','State TET','govt_basic','teaching','{child-development-pedagogy,hindi,english,maths,environment,general-science}'),
 ('kvs-nvs','केवीएस / एनवीएस शिक्षक','KVS / NVS Teacher','govt_basic','teaching','{child-development-pedagogy,general-awareness,reasoning,english,hindi,computer-basics}'),
 ('ugc-net','यूजीसी नेट','UGC NET','advanced_research','research','{teaching-aptitude,reasoning}'),
 -- technical jobs
 ('state-je','राज्य जेई (BSSC, UPSSSC, MPESB आदि)','State JE (BSSC, UPSSSC, MPESB etc.)','govt_technical','tech-je','{branch-engineering,general-awareness,reasoning,maths}'),
 ('state-ae','राज्य एई (असिस्टेंट इंजीनियर)','State AE (Assistant Engineer)','govt_technical','tech-je','{branch-engineering,general-awareness,maths}'),
 ('psu-diploma-trainee','पीएसयू डिप्लोमा ट्रेनी (BHEL, NTPC, PGCIL, SAIL)','PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL)','govt_technical','tech-psu','{branch-engineering,reasoning,general-awareness}'),
 ('metro-je','मेट्रो जेई / मेंटेनर (DMRC आदि)','Metro JE / Maintainer (DMRC etc.)','govt_technical','tech-psu','{branch-or-trade,reasoning,general-awareness,maths}'),
 ('isro-drdo-technician','इसरो / डीआरडीओ टेक्नीशियन और टेक्निकल असिस्टेंट','ISRO / DRDO Technician & Technical Assistant','govt_technical','tech-psu','{branch-or-trade,general-awareness,reasoning}'),
 ('gate','गेट (GATE)','GATE','govt_technical','tech-higher','{branch-engineering,maths,reasoning}'),
 ('ese','यूपीएससी ईएसई (IES)','UPSC ESE (IES)','govt_technical','tech-higher','{branch-engineering,general-awareness,maths,reasoning}'),
 ('leet','लेटरल एंट्री बी.टेक (LEET)','Lateral Entry B.Tech (LEET)','govt_technical','tech-higher','{maths,branch-engineering}'),
 -- health
 ('nursing-officer','नर्सिंग ऑफ़िसर (AIIMS NORCET, राज्य)','Nursing Officer (AIIMS NORCET, State)','medical','health','{nursing,general-awareness}'),
 ('pharmacist','फ़ार्मासिस्ट भर्ती','Pharmacist recruitment','medical','health','{pharmacy,general-awareness}'),
 ('gpat','जीपैट','GPAT','medical','health','{pharmacy}'),
 ('neet-pg','नीट पीजी','NEET PG','medical','health','{medicine}'),
 ('nursing-entrance','नर्सिंग प्रवेश (B.Sc नर्सिंग)','Nursing entrance (B.Sc Nursing)','medical','entrance','{general-science:physics+chemistry+biology,english,general-awareness}'),
 -- entrance
 ('polytechnic-entrance','पॉलिटेक्निक प्रवेश (DCECE, JEECUP आदि)','Polytechnic entrance (DCECE, JEECUP etc.)','class_9_10','entrance','{maths,general-science:physics+chemistry}'),
 ('cuet-ug','सीयूईटी यूजी','CUET UG','class_11_12_sci','entrance','{english,general-awareness,reasoning,maths}'),
 ('state-cet','राज्य इंजीनियरिंग प्रवेश (MHT CET, WBJEE, BCECE आदि)','State engineering entrance (MHT CET, WBJEE, BCECE etc.)','engineering','entrance','{maths,general-science:physics+chemistry}'),
 ('sainik-school','सैनिक स्कूल प्रवेश (AISSEE)','Sainik School entrance (AISSEE)','class_6_8','school-comp','{maths,general-science,english,general-awareness}'),
 ('olympiad','ओलंपियाड (गणित / विज्ञान)','Olympiad (Maths / Science)','class_9_10','school-comp','{maths,general-science,reasoning}'),
 -- research / law / management
 ('csir-net','सीएसआईआर नेट','CSIR NET','advanced_research','research','{general-science,maths,reasoning}'),
 ('cat','कैट (CAT) / एमबीए प्रवेश','CAT / MBA entrance','law_management','law-mgmt','{quant-law,reasoning,english-law}'),
 ('clat','क्लैट (CLAT)','CLAT','law_management','law-mgmt','{legal-reasoning,legal-aptitude,english-law,quant-law,general-awareness}'),
 ('judiciary','न्यायिक सेवा (सिविल जज)','Judicial Services (Civil Judge)','law_management','law-mgmt','{law,general-awareness,english,hindi}');

insert into mtb.exams (slug, name_en, name_hi, active, setup_only, family_slug, family_hi, family_en, content_level, exam_cat, stage_sort, setup_subjects)
select f.slug, f.en, f.hi, false, true, f.slug, f.hi, f.en, f.lvl, f.cat, 1, f.subj from _fam f
on conflict (slug) do nothing;

-- SSC JE Paper II (technical) as a second stage of the SSC JE family
insert into mtb.exams (slug, name_en, name_hi, active, setup_only, family_slug, family_hi, family_en, stage_hi, stage_en, stage_sort, content_level, exam_cat, setup_subjects)
values ('ssc-je-paper2','SSC JE Paper II','एसएससी जेई पेपर II',false,true,'ssc-je','एसएससी जेई','SSC JE','पेपर-II','Paper-II',2,'govt_technical','tech-je','{branch-engineering}')
on conflict (slug) do nothing;

-- subjects for existing exams that have no section table (new column only; the exams are otherwise unchanged)
update mtb.exams e set setup_subjects = s.subj
from (values
 ('jee-main','{maths,general-science:physics+chemistry}'::text[]), ('jee-advanced','{maths,general-science:physics+chemistry}'),
 ('neet-ug','{general-science:physics+chemistry+biology}'), ('nda','{maths,general-science,english,general-awareness}'),
 ('cds','{maths,english,general-awareness,general-science}'), ('ibps-po','{maths,reasoning,english,general-awareness,computer-basics}'),
 ('sbi-po','{maths,reasoning,english,general-awareness,computer-basics}'), ('upsc-cse','{general-awareness,general-science,reasoning,maths,english}'),
 ('uppsc','{general-awareness,general-science,reasoning,maths,hindi}'), ('bpsc','{general-awareness,general-science,reasoning,maths}')
) as s(slug, subj)
where e.slug = s.slug and e.setup_subjects is null;

-- ---------- new qualifications ----------
insert into mtb.qualifications (slug, cat, name_hi, name_en, level_id, branch, course, stages, passed_ok, why, sort) values
 ('class-10-pass','school','10वीं पास (आगे नहीं पढ़ रहे)','10th pass (not studying further)','govt_basic',null,'[]',null,false,'10th-pass job exams only; no school course',15),
 ('class-12-pass','school','12वीं पास (कोई भी स्ट्रीम, आगे नहीं पढ़ रहे)','12th pass (any stream, not studying further)','govt_basic',null,'[]',null,false,'12th-pass job and entrance exams only',24),
 ('iti-mechanical','iti','आईटीआई — फ़िटर / टर्नर / मशीनिस्ट / वेल्डर / मैकेनिक (डीज़ल, मोटर व्हीकल)','ITI — Fitter / Turner / Machinist / Welder / Mechanic (Diesel, Motor Vehicle)','govt_technical','mechanical','[{"subject":"trade-theory"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2"]}',true,'trade theory is the ITI course; branch = mechanical for railway/PSU technical papers',26),
 ('iti-electrical','iti','आईटीआई — इलेक्ट्रीशियन / वायरमैन / इलेक्ट्रॉनिक्स मैकेनिक','ITI — Electrician / Wireman / Electronics Mechanic','govt_technical','electrical','[{"subject":"trade-theory"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2"]}',true,'trade theory is the ITI course',27),
 ('iti-copa','iti','आईटीआई — कोपा (कंप्यूटर ऑपरेटर)','ITI — COPA (Computer Operator)','govt_basic',null,'[{"subject":"trade-theory"},{"subject":"computer-basics"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1"]}',true,'COPA = computer trade',28),
 ('diploma-automobile','diploma','डिप्लोमा इन ऑटोमोबाइल इंजीनियरिंग','Diploma in Automobile Engineering','govt_technical','mechanical','[{"subject":"mechanical-engineering"}]','{"label_hi":"सेमेस्टर","label_en":"Semester","list":["1","2","3","4","5","6"]}',true,'automobile is accepted in the mechanical group of RRB JE / ALP; core subjects are mechanical',35),
 ('diploma-pharmacy','diploma','डी.फ़ार्मा (डिप्लोमा इन फ़ार्मेसी)','D.Pharm (Diploma in Pharmacy)','medical',null,'[{"subject":"pharmacy"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2"]}',true,'pharmacy course',36),
 ('diploma-nursing','diploma','जीएनएम (जनरल नर्सिंग एवं मिडवाइफ़री)','GNM (General Nursing & Midwifery)','medical',null,'[{"subject":"nursing"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3"]}',true,'nursing course',37),
 ('diploma-deled','diploma','डी.एल.एड. (प्राथमिक शिक्षक डिप्लोमा)','D.El.Ed. (Diploma in Elementary Education)','govt_basic',null,'[{"subject":"child-development-pedagogy"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2"]}',true,'teacher training course',38),
 ('bed','graduation','बी.एड. (शिक्षा स्नातक)','B.Ed. (Bachelor of Education)','govt_basic',null,'[{"subject":"child-development-pedagogy"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2"]}',true,'teacher training degree',48),
 ('bsc-nursing','graduation','बी.एससी. नर्सिंग','B.Sc. Nursing','medical',null,'[{"subject":"nursing"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3","4"]}',true,'nursing degree',49),
 ('bpharm','graduation','बी.फ़ार्मा (फ़ार्मेसी स्नातक)','B.Pharm (Bachelor of Pharmacy)','medical',null,'[{"subject":"pharmacy"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3","4"]}',true,'pharmacy degree',50),
 ('mbbs','graduation','एमबीबीएस','MBBS','medical',null,'[{"subject":"medicine"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3","4","5"]}',true,'medical degree',51),
 ('llb','graduation','एलएल.बी. (विधि स्नातक)','LL.B. (Bachelor of Laws)','law_management',null,'[{"subject":"law"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3","4","5"]}',true,'law degree (3-year or 5-year)',52),
 ('bca','graduation','बी.सी.ए. (कंप्यूटर एप्लिकेशन)','BCA (Bachelor of Computer Applications)','graduation_sci',null,'[{"subject":"computer-basics"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3"]}',true,'computer applications degree',53),
 ('bba','graduation','बी.बी.ए. (व्यवसाय प्रशासन)','BBA (Bachelor of Business Administration)','graduation_com',null,'[{"subject":"business-studies"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3"]}',true,'business degree',54),
 ('bsc-agriculture','graduation','बी.एससी. कृषि','B.Sc. Agriculture','graduation_sci',null,'[{"subject":"general-science","units":["biology","chemistry"]}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2","3","4"]}',true,'agriculture degree; nearest content is biology + chemistry',55),
 ('mba','postgrad','एम.बी.ए.','MBA','law_management',null,'[]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2"]}',true,'management postgraduate',56),
 ('mca','postgrad','एम.सी.ए.','MCA','graduation_sci',null,'[{"subject":"computer-basics"}]','{"label_hi":"वर्ष","label_en":"Year","list":["1","2"]}',true,'computer applications postgraduate',57)
on conflict (slug) do nothing;

-- the two broad "level:" targets are replaced by real exam families below (kept, only switched off)
update mtb.qualification_exams set active = false where target in ('level:law_management','level:advanced_research');

-- ---------- eligibility ----------
create temporary table _el (q text, t text, st text, why text) on commit drop;
-- school
insert into _el values
 ('class-8','sainik-school','any','AISSEE class IX entry: studying class 8'),
 ('class-8','olympiad','any','olympiads are open to school students'),
 ('class-9','olympiad','any','olympiads are open to school students'),
 ('class-10','olympiad','any','olympiads are open to school students'),
 ('class-10','polytechnic-entrance','any','polytechnic entrance: 10th appearing / passed'),
 ('class-10','ssc-mts','passed','10th pass'), ('class-10','ssc-gd','passed','10th pass'), ('class-10','rrb-group-d','passed','10th pass (or ITI)'),
 ('class-10','agniveer-army','passed','Agniveer GD: 10th pass'), ('class-10','police-constable','passed','most states: 10th or 12th pass');
-- 10th / 12th pass (not studying)
insert into _el select 'class-10-pass', v.t, 'any', v.why from (values
 ('ssc-mts','10th pass'),('ssc-gd','10th pass'),('rrb-group-d','10th pass (or ITI)'),('agniveer-army','Agniveer GD: 10th pass'),
 ('police-constable','most states: 10th or 12th pass'),('polytechnic-entrance','10th pass')) v(t, why);
insert into _el select 'class-12-pass', v.t, 'any', v.why from (values
 ('ssc-mts','10th pass'),('ssc-gd','10th pass'),('rrb-group-d','10th pass'),('agniveer-army','10th / 12th pass'),
 ('police-constable','12th pass'),('ssc-chsl','12th pass'),('ssc-steno','12th pass'),('rrb-ntpc','UG posts: 12th pass'),
 ('nda','10+2 (Army wing any stream)'),('agniveer-airforce','12th pass (non-science option for any stream)'),('cuet-ug','12th pass'),('clat','CLAT UG: 12th pass')) v(t, why);
-- class 11-12 streams (studying = may appear for entrances; jobs need 'passed')
insert into _el select a.q, b.t, b.st, b.why from (values ('class-11-12-pcm'),('class-11-12-pcb'),('class-11-12-commerce'),('class-11-12-arts')) a(q)
 cross join (values
 ('cuet-ug','any','12th appearing / passed'),('clat','any','CLAT UG: 12th appearing / passed'),
 ('ssc-chsl','passed','12th pass'),('ssc-steno','passed','12th pass'),('ssc-mts','passed','10th pass'),('ssc-gd','passed','10th pass'),
 ('rrb-group-d','passed','10th pass'),('agniveer-army','passed','10th / 12th pass'),('agniveer-airforce','passed','12th pass'),
 ('police-constable','passed','12th pass')) b(t, st, why);
insert into _el values
 ('class-11-12-pcm','state-cet','any','PCM, 12th appearing / passed'),
 ('class-11-12-pcm','agniveer-navy','passed','Navy SSR: 12th with maths and physics'),
 ('class-11-12-pcm','army-tes','passed','12th PCM'),
 ('class-11-12-pcb','nursing-entrance','any','B.Sc Nursing: 12th PCB');
-- ITI (all trades: ITI implies 10th pass)
insert into _el select a.q, b.t, 'any', b.why from (values ('iti-mechanical'),('iti-electrical'),('iti-copa')) a(q)
 cross join (values ('rrb-group-d','10th / ITI'),('ssc-mts','10th pass'),('ssc-gd','10th pass'),('agniveer-army','10th pass'),('police-constable','10th / 12th pass')) b(t, why);
insert into _el select a.q, b.t, 'any', b.why from (values ('iti-mechanical'),('iti-electrical')) a(q)
 cross join (values ('rrb-alp','ITI in notified trades'),('rrb-technician','ITI in the post''s trade'),('metro-je','maintainer posts: ITI'),('isro-drdo-technician','technician-B: ITI in the trade')) b(t, why);
-- engineering diplomas (common)
insert into _el select a.q, b.t, 'any', b.why from (values ('diploma-mechanical'),('diploma-civil'),('diploma-electrical'),('diploma-electronics'),('diploma-computer'),('diploma-automobile')) a(q)
 cross join (values ('state-je','state JE: diploma in the branch'),('psu-diploma-trainee','diploma trainee: diploma in the branch'),('metro-je','JE: diploma in the branch'),
 ('isro-drdo-technician','technical assistant: diploma in the branch'),('leet','lateral entry: diploma holders'),
 ('rrb-group-d','10th pass'),('ssc-mts','10th pass'),('ssc-gd','10th pass'),('police-constable','10th / 12th pass')) b(t, why);
insert into _el select a.q, 'rrb-alp', 'any', 'ALP: diploma in mech / elec / electronics / auto accepted in place of ITI' from (values ('diploma-mechanical'),('diploma-electrical'),('diploma-electronics'),('diploma-automobile')) a(q);
insert into _el values ('diploma-automobile','rrb-je','any','RRB JE mechanical group accepts automobile');
-- health / teaching diplomas
insert into _el values
 ('diploma-pharmacy','pharmacist','any','D.Pharm + registration'),('diploma-pharmacy','rrb-paramedical','any','pharmacist post: D.Pharm'),
 ('diploma-nursing','nursing-officer','any','GNM + registration'),('diploma-nursing','rrb-paramedical','any','staff nurse: GNM'),
 ('diploma-deled','ctet','any','primary level: D.El.Ed'),('diploma-deled','state-tet','any','primary level: D.El.Ed');
-- every graduate / postgraduate
insert into _el select q.slug, b.t, 'any', b.why from mtb.qualifications q cross join (values
 ('ssc-cgl','any graduate'),('ssc-cpo','any graduate'),('ssc-chsl','12th pass (graduates also eligible)'),('ibps-clerk','any graduate'),
 ('ibps-rrb','any graduate'),('sbi-clerk','any graduate'),('rbi-assistant','any graduate'),('rbi-grade-b','graduate with required marks'),
 ('lic-aao','any graduate'),('afcat','graduate (stream rules per branch)'),('capf-ac','any graduate'),('police-si','any graduate'),
 ('mppsc','any graduate'),('rpsc-ras','any graduate'),('cat','any graduate'),('rrb-group-d','10th pass'),('ssc-mts','10th pass')) b(t, why)
 where q.cat in ('graduation','postgrad');
insert into _el select a.q, b.t, 'any', b.why from (values ('btech-mechanical'),('btech-civil'),('btech-electrical'),('btech-electronics'),('btech-computer')) a(q)
 cross join (values ('gate','B.Tech final year / passed'),('state-ae','B.Tech in the branch'),('state-je','degree holders are also eligible for JE'),
 ('metro-je','degree holders eligible'),('isro-drdo-technician','scientist/engineer posts: B.Tech')) b(t, why);
insert into _el select a.q, 'ese', 'any', 'ESE: B.Tech in civil / mech / elec / E&T' from (values ('btech-mechanical'),('btech-civil'),('btech-electrical'),('btech-electronics')) a(q);
insert into _el values
 ('bsc','gate','any','GATE: B.Sc final year / passed (science papers)'),
 ('bed','ctet','any','upper primary: graduate + B.Ed'),('bed','state-tet','any','graduate + B.Ed'),('bed','kvs-nvs','any','TGT/PGT: B.Ed'),
 ('bsc-nursing','nursing-officer','any','B.Sc Nursing + registration'),('bsc-nursing','rrb-paramedical','any','staff nurse'),
 ('bpharm','pharmacist','any','B.Pharm'),('bpharm','gpat','any','B.Pharm final year / passed'),('bpharm','rrb-paramedical','any','pharmacist post'),
 ('mbbs','neet-pg','any','MBBS with internship'),('llb','judiciary','any','LL.B. + enrolment rules per state'),
 ('postgrad','ugc-net','any','master''s degree (final year allowed)'),('postgrad','csir-net','any','M.Sc / integrated (science)'),
 ('postgrad','gate','any','postgraduates eligible'),('mba','ugc-net','any','master''s degree'),('mca','ugc-net','any','master''s degree'),
 ('mca','gate','any','MCA eligible for GATE CS');

insert into mtb.qualification_exams (qual_slug, target, status, why, sort)
select q, t, min(st), min(why), 100 + (row_number() over (partition by q order by t))::int from _el
where exists (select 1 from mtb.qualifications where slug = q)
group by q, t
on conflict (qual_slug, target) do nothing;

-- ---------- setup config v2 ----------
create or replace function mtb.get_setup_config()
 returns jsonb language sql stable security definer set search_path to 'mtb', 'pg_catalog'
as $$
  select jsonb_build_object(
    'quals', (select jsonb_agg(jsonb_build_object('slug', q.slug, 'cat', q.cat, 'hi', q.name_hi, 'en', q.name_en, 'level', q.level_id,
                'branch', q.branch, 'course', q.course, 'stages', q.stages, 'passed_ok', q.passed_ok,
                'exams', coalesce((select jsonb_agg(jsonb_build_object('target', x.target, 'status', x.status, 'hi', x.label_hi, 'en', x.label_en) order by x.sort, x.target)
                                   from mtb.qualification_exams x where x.qual_slug = q.slug and x.active), '[]'::jsonb)) order by q.sort)
              from mtb.qualifications q where q.active),
    'families', (select jsonb_object_agg(f.family_slug, f.j) from (
                   select e.family_slug, jsonb_build_object('hi', min(e.family_hi), 'en', min(e.family_en), 'level', min(e.content_level), 'cat', min(e.exam_cat),
                     'subjects', (select jsonb_agg(distinct sj) from (
                                    select unnest(x.subjects) sj from mtb.exams e2 join mtb.exam_sections x on x.exam_id = e2.id
                                     where e2.family_slug = e.family_slug and (e2.active or e2.setup_only)
                                    union
                                    select unnest(e2.setup_subjects) from mtb.exams e2
                                     where e2.family_slug = e.family_slug and (e2.active or e2.setup_only)) z)) j
                   from mtb.exams e where (e.active or e.setup_only) and e.family_slug is not null group by e.family_slug) f),
    'cats', (select jsonb_agg(jsonb_build_object('slug', c.slug, 'hi', c.name_hi, 'en', c.name_en, 'tech', c.tech) order by c.sort) from mtb.exam_cats c),
    'subjects', (select jsonb_object_agg(s.slug, jsonb_build_object('hi', s.name_hi, 'en', s.name_en)) from mtb.subjects s),
    'levels', (select jsonb_object_agg(l.id, jsonb_build_object('hi', l.name_hi, 'en', l.name_en)) from mtb.content_levels l),
    'branches', (select jsonb_object_agg(b.slug, b.name_en) from mtb.branches b),
    'units', (select jsonb_object_agg(u.subject_slug, u.list) from (
                select subject_slug, jsonb_agg(jsonb_build_object('slug', slug, 'hi', name_hi, 'en', name_en, 'ch', to_jsonb(chapter_ids)) order by sort) list
                from mtb.subject_units group by subject_slug) u));
$$;
grant execute on function mtb.get_setup_config() to anon, authenticated;
