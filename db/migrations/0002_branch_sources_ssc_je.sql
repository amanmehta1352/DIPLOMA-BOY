-- 0002 (applied 21 Oct 2026): sources know their branch; SSC JE Paper I; branch engineering subjects. Additive only.
alter table mtb.sources add column if not exists branch_id int references mtb.branches(id);
alter table mtb.sources add column if not exists note text;
insert into mtb.exams(slug,name_en,name_hi,level,pattern) values
('ssc-je-paper1','SSC JE Paper I','एसएससी जेई पेपर I','diploma',
 '{"questions":200,"minutes":120,"marks_per_q":1,"negative_per_wrong":0.25,"sections":["reasoning","general-awareness","branch-engineering"]}')
on conflict (slug) do nothing;
insert into mtb.exam_branches select e.id,b.id from mtb.exams e, mtb.branches b
 where e.slug='ssc-je-paper1' and b.slug in ('civil','mechanical','electrical') on conflict do nothing;
insert into mtb.subjects(slug,name_en,name_hi,branch_id)
select v.slug, v.en, v.hi, b.id from (values
 ('civil-engineering','Civil Engineering','सिविल इंजीनियरिंग','civil'),
 ('mechanical-engineering','Mechanical Engineering','मैकेनिकल इंजीनियरिंग','mechanical'),
 ('electrical-engineering','Electrical Engineering','इलेक्ट्रिकल इंजीनियरिंग','electrical')) v(slug,en,hi,br)
join mtb.branches b on b.slug=v.br on conflict (slug) do nothing;
-- Data import uses a one-time token RPC (mtb.import_batch); tokens are expired and execute is revoked after use.
