-- 0056: class_6_8 seed — anchor topic 870 (Measurement & Units). 3 level-specific atoms, no exam tags.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (870,'class_6_8','c68-measure-concept','concept',1,'मापन और इकाइयाँ — कक्षा 6-8',$j${"note":"स्कूल परीक्षा में SI इकाइयों के नाम और उनके प्रतीक अक्सर पूछे जाते हैं।","text":"किसी राशि को नापने के लिए एक मानक इकाई चुनी जाती है। अंतर्राष्ट्रीय मात्रक पद्धति (SI) में लंबाई की इकाई मीटर (m), द्रव्यमान की किलोग्राम (kg) और समय की सेकंड (s) है। बड़ी दूरी किलोमीटर (km) में और छोटी दूरी सेंटीमीटर (cm) या मिलीमीटर (mm) में नापी जाती है।"}$j$),
  (870,'class_6_8','c68-measure-example','example',2,'उदाहरण',$j${"question":"1 km में कितने मीटर होते हैं?","solution":"1 km = 1000 m","answer":"1000 m"}$j$),
  (870,'class_6_8','c68-measure-mcq','mcq',3,'अभ्यास प्रश्न',$j${"questions":[{"q":"लंबाई की SI इकाई क्या है?","options":["मीटर","किलोग्राम","सेकंड","लीटर"],"answer":0,"explanation":"लंबाई की SI इकाई मीटर है।"},{"q":"1 मीटर में कितने सेंटीमीटर होते हैं?","options":["100","10","1000","10000"],"answer":0,"explanation":"1 m = 100 cm।"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
