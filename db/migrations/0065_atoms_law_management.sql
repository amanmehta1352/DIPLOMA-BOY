-- 0065: law_management seed — anchor topic 431 (Syllogism). 3 level-specific atoms, no exam tags (clat/cat not in mtb.exams yet).

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (431,'law_management','lm-syll-concept','concept',1,'सिलॉजिज़्म (न्याय-वाक्य) — कानून / प्रबंधन',$j${"note":"CLAT, CAT और XAT में सिलॉजिज़्म के प्रश्न तार्किक निष्कर्ष की जाँच करते हैं।","text":"सिलॉजिज़्म में दो आधार वाक्य (premises) से एक निष्कर्ष निकाला जाता है। यदि आधार सत्य हों और तर्क वैध हो, तो निष्कर्ष अनिवार्य रूप से सत्य होता है। वैधता की जाँच के लिए वाक्यों में मध्य पद (middle term) का होना आवश्यक है।"}$j$),
  (431,'law_management','lm-syll-example','example',2,'उदाहरण',$j${"question":"आधार: सभी वकील पढ़े-लिखे हैं। कुछ पढ़े-लिखे लोग शिक्षक हैं। क्या यह निष्कर्ष निश्चित है कि 'कुछ वकील शिक्षक हैं'?","solution":"नहीं। आधार से यह निश्चित नहीं होता कि पढ़े-लिखे शिक्षक वकीलों में से ही हों, इसलिए निष्कर्ष निश्चित नहीं है","answer":"निश्चित नहीं"}$j$),
  (431,'law_management','lm-syll-mcq','mcq',3,'अभ्यास प्रश्न',$j${"questions":[{"q":"आधार: सभी A, B हैं। सभी B, C हैं। निष्कर्ष क्या है?","options":["सभी A, C हैं","सभी C, A हैं","कुछ A, C नहीं हैं","निष्कर्ष निश्चित नहीं"],"answer":0,"explanation":"A ⊂ B ⊂ C, इसलिए सभी A, C हैं।"},{"q":"किसी सिलॉजिज़्म की वैधता के लिए आवश्यक है","options":["मध्य पद का होना","तीन से अधिक वाक्य","नकारात्मक निष्कर्ष","संख्यात्मक आँकड़े"],"answer":0,"explanation":"मध्य पद दोनों आधारों को जोड़ता है; इसके बिना निष्कर्ष नहीं निकल सकता।"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'reasoning', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
