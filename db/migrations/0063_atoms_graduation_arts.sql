-- 0063: graduation_arts seed — anchor topic 38 (Art & Culture). 3 level-specific atoms, no exam tags.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (38,'graduation_arts','garts-culture-concept','concept',1,'भारतीय कला और संस्कृति — स्नातक कला',$j${"note":"स्नातक स्तर पर शास्त्रीय नृत्य और चित्रकला की शैलियाँ और उनके राज्य अक्सर पूछे जाते हैं।","text":"भारत में शास्त्रीय नृत्य आठ शैलियों में माने जाते हैं, जैसे भरतनाट्यम, कथक, कथकली, मोहिनीअट्टम, ओडिसी, कुचिपुडी, मणिपुरी और सत्रिया। मधुबनी चित्रकला बिहार से जुड़ी है, जबकि वारली चित्रकला महाराष्ट्र की आदिवासी कला है।"}$j$),
  (38,'graduation_arts','garts-culture-example','example',2,'उदाहरण',$j${"question":"कथकली किस राज्य का शास्त्रीय नृत्य है?","solution":"कथकली केरल का शास्त्रीय नृत्य-नाटक है","answer":"केरल"}$j$),
  (38,'graduation_arts','garts-culture-mcq','mcq',3,'अभ्यास प्रश्न',$j${"questions":[{"q":"मधुबनी चित्रकला किस राज्य से जुड़ी है?","options":["बिहार","राजस्थान","महाराष्ट्र","ओडिशा"],"answer":0,"explanation":"मधुबनी या मिथिला चित्रकला बिहार की प्रसिद्ध लोक कला है।"},{"q":"भरतनाट्यम किस राज्य का शास्त्रीय नृत्य है?","options":["तमिलनाडु","केरल","ओडिशा","असम"],"answer":0,"explanation":"भरतनाट्यम तमिलनाडु का शास्त्रीय नृत्य है।"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'general-awareness', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
