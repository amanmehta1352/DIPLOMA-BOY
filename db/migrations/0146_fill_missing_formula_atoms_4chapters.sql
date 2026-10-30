-- Migration 0146: add missing formula atom (order 4) to 4 chapters that had only 3 atoms
-- class_11_12_arts 419 (History), class_11_12_com 417 (Economy), graduation_arts 38 (Art & Culture), law_management 431 (Syllogism)
with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body, v.subject_tag, v.exam_tags, v.class_tags, v.difficulty
  from (values
    (419, 'class_11_12_arts', 'c1112a-hist-formula', 'formula', 4, 'कालखंड क्रम',
     $j${"formula":"भारतीय इतिहास: प्राचीन → मध्यकालीन → आधुनिक (ब्रिटिश काल) → स्वतंत्रता","explanation":"प्रमुख कालखंडों का क्रम याद रखने का आधार"}$j$,
     'general-awareness', array[]::text[], array[]::text[], 'medium'),
    (417, 'class_11_12_com', 'c1112c-econ-formula', 'formula', 4, 'राष्ट्रीय आय का मूल सूत्र',
     $j${"formula":"GDP = C + I + G + (X − M)","explanation":"C: उपभोग, I: निवेश, G: सरकारी व्यय, X: निर्यात, M: आयात"}$j$,
     'general-awareness', array[]::text[], array[]::text[], 'medium'),
    (38, 'graduation_arts', 'garts-culture-formula', 'formula', 4, 'भारतीय कला के प्रकार',
     $j${"formula":"कला = वास्तुकला + मूर्तिकला + चित्रकला + संगीत + नृत्य + साहित्य","explanation":"भारतीय संस्कृति की प्रमुख कला-विधाएँ"}$j$,
     'general-awareness', array[]::text[], array[]::text[], 'medium'),
    (431, 'law_management', 'lm-syll-formula', 'formula', 4, 'सिलॉजिज़्म का मूल नियम',
     $j${"formula":"यदि सभी A, B हैं, और सभी B, C हैं → तो सभी A, C हैं","explanation":"वैध निष्कर्ष के लिए आधार-कथन की श्रृंखला"}$j$,
     'reasoning', array[]::text[], array[]::text[], 'medium')
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body, subject_tag, exam_tags, class_tags, difficulty)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false, s.exam_tags, s.class_tags, s.subject_tag, s.difficulty, md5(s.body::text)
from src s
on conflict do nothing;
