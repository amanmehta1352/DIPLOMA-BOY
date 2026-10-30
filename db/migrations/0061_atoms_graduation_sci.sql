-- 0061: graduation_sci seed — anchor topic 889 (Chemical Reactions & Equations). 3 level-specific atoms, no exam tags.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (889,'graduation_sci','gsci-chem-concept','concept',1,'रासायनिक अभिक्रियाएँ — स्नातक विज्ञान',$j${"note":"स्नातक स्तर पर संतुलित समीकरण और अभिक्रिया के प्रकार (संयोजन, अपघटन, विस्थापन) अक्सर पूछे जाते हैं।","text":"रासायनिक अभिक्रिया में अभिकारक उत्पादों में बदलते हैं। समीकरण संतुलित होना चाहिए, यानी हर तत्व के परमाणुओं की संख्या दोनों ओर समान हो (द्रव्यमान संरक्षण का नियम)। मुख्य प्रकार हैं: संयोजन, अपघटन, विस्थापन और द्विविस्थापन।"}$j$),
  (889,'graduation_sci','gsci-chem-example','example',2,'Numerical',$j${"question":"H₂ + O₂ → H₂O को संतुलित करें।","solution":"2H₂ + O₂ → 2H₂O (दोनों ओर H = 4, O = 2)","answer":"2H₂ + O₂ → 2H₂O"}$j$),
  (889,'graduation_sci','gsci-chem-mcq','mcq',3,'अभ्यास प्रश्न',$j${"questions":[{"q":"कौन सी अभिक्रिया संयोजन (combination) का उदाहरण है?","options":["2Mg + O₂ → 2MgO","CaCO₃ → CaO + CO₂","Zn + CuSO₄ → ZnSO₄ + Cu","NaOH + HCl → NaCl + H₂O"],"answer":0,"explanation":"दो पदार्थ मिलकर एक नया यौगिक बनाते हैं, इसलिए यह संयोजन है।"},{"q":"रासायनिक समीकरण संतुलित करने का आधार कौन सा नियम है?","options":["द्रव्यमान संरक्षण का नियम","ऊर्जा संरक्षण","आवेग संरक्षण","चार्ज का नियम"],"answer":0,"explanation":"अभिक्रिया में कुल द्रव्यमान नहीं बदलता, इसलिए परमाणु दोनों ओर समान होने चाहिए।"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
