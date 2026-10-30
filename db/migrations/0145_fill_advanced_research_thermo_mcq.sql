-- Migration 0145: advanced_research thermodynamics (chapter 441) missing mcq atom (3 -> 4)
with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body, v.subject_tag, v.exam_tags, v.class_tags, v.difficulty
  from (values
    (441, 'advanced_research', 'adv-thermo-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"ऊष्मागतिकी का प्रथम नियम किसका संरक्षण है?","options":["द्रव्यमान","ऊर्जा","संवेग","आवेश"],"answer":1,"explanation":"प्रथम नियम ऊर्जा संरक्षण का नियम है: ΔU = Q − W।"},{"q":"एन्ट्रॉपी किस दिशा में सामान्यतः बढ़ती है?","options":["व्यवस्थित से अव्यवस्थित की ओर","अव्यवस्थित से व्यवस्थित की ओर","कोई दिशा नहीं","केवल ठंडे पिंड में"],"answer":0,"explanation":"पृथक तंत्र में एन्ट्रॉपी सामान्यतः बढ़ती है, यानी अव्यवस्था बढ़ती है।"}]}$j$,
     'mechanical-engineering', array[]::text[], array[]::text[], 'hard')
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body, subject_tag, exam_tags, class_tags, difficulty)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false, s.exam_tags, s.class_tags, s.subject_tag, s.difficulty, md5(s.body::text)
from src s
on conflict do nothing;
