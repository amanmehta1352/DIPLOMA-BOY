-- 0058: class_11_12_arts seed — anchor topic 419 (History). 3 level-specific atoms, no exam tags.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (419,'class_11_12_arts','c1112a-hist-concept','concept',1,'भारतीय इतिहास — कक्षा 11-12 कला',$j${"note":"बोर्ड परीक्षा में 1857 का विद्रोह और स्वतंत्रता आंदोलन के चरण अक्सर पूछे जाते हैं।","text":"भारत में ब्रिटिश शासन के विरुद्ध 1857 का विद्रोह एक बड़ा मोड़ था। इसके बाद ब्रिटिश सरकार ने शासन सीधे अपने हाथ में लिया। बाद में राष्ट्रीय कांग्रेस की स्थापना (1885) और गांधी जी के असहयोग (1920), सविनय अवज्ञा (1930) और भारत छोड़ो (1942) आंदोलनों ने स्वतंत्रता संघर्ष को गति दी।"}$j$),
  (419,'class_11_12_arts','c1112a-hist-example','example',2,'उदाहरण',$j${"question":"भारतीय राष्ट्रीय कांग्रेस की स्थापना किस वर्ष हुई?","solution":"भारतीय राष्ट्रीय कांग्रेस की स्थापना 1885 में हुई","answer":"1885"}$j$),
  (419,'class_11_12_arts','c1112a-hist-mcq','mcq',3,'अभ्यास प्रश्न',$j${"questions":[{"q":"भारत छोड़ो आंदोलन किस वर्ष शुरू हुआ?","options":["1942","1920","1930","1857"],"answer":0,"explanation":"भारत छोड़ो आंदोलन 1942 में शुरू हुआ।"},{"q":"1857 के विद्रोह के बाद भारत का शासन किसने सीधे अपने हाथ में लिया?","options":["ब्रिटिश सरकार","मुगल सम्राट","डच कंपनी","पुर्तगाली"],"answer":0,"explanation":"1858 में ब्रिटिश सरकार ने ईस्ट इंडिया कंपनी से शासन अपने हाथ में ले लिया।"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'general-awareness', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
