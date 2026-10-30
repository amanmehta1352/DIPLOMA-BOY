-- 0155: APPLIED LIVE 2026-10-31 (name: exam_diploma_polytechnic). Owner approved (blanket go-ahead, 01:52 IST).
-- Adds the "Diploma (Polytechnic)" qualification, mapped to govt_technical content. Additive, idempotent.
insert into mtb.exams (slug, name_en, name_hi, level, active, family_slug, family_hi, family_en, stage_sort, content_level)
select 'diploma-polytechnic', 'Diploma (Polytechnic)', 'डिप्लोमा (पॉलिटेक्निक)', 'diploma', true, 'diploma-polytechnic', 'डिप्लोमा (पॉलिटेक्निक)', 'Diploma (Polytechnic)', 1, 'govt_technical'
where not exists (select 1 from mtb.exams where slug = 'diploma-polytechnic');
