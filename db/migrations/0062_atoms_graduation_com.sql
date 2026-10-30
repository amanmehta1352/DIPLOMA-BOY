-- 0062: graduation_com seed — anchor topic 3 (Simple & Compound Interest). 3 level-specific atoms, no exam tags.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (3,'graduation_com','gcom-si-concept','concept',1,'साधारण और चक्रवृद्धि ब्याज — स्नातक कॉमर्स',$j${"note":"B.Com, BBA और CA Foundation में चक्रवृद्धि ब्याज के सूत्र और अंतर अक्सर पूछे जाते हैं।","text":"साधारण ब्याज मूल धन पर लगता है, जबकि चक्रवृद्धि ब्याज हर अवधि में जमा ब्याज पर भी लगता है। साधारण ब्याज की राशि समान रहती है, पर चक्रवृद्धि में हर वर्ष ब्याज की राशि बढ़ती जाती है।"}$j$),
  (3,'graduation_com','gcom-si-formula','formula',2,'सूत्र',$j${"formula":"SI = P × R × T / 100 · A (चक्रवृद्धि) = P (1 + R/100)ⁿ","explanation":"P मूल धन, R वार्षिक दर, T समय (वर्ष), n अवधियों की संख्या"}$j$),
  (3,'graduation_com','gcom-si-example','example',3,'Numerical',$j${"question":"₹10000 पर 10% वार्षिक दर से 2 वर्ष का चक्रवृद्धि ब्याज कितना होगा?","solution":"A = 10000 × (1.1)² = 12100; ब्याज = 12100 − 10000 = ₹2100","answer":"₹2100"}$j$),
  (3,'graduation_com','gcom-si-mcq','mcq',4,'अभ्यास प्रश्न',$j${"questions":[{"q":"₹1000 पर 10% वार्षिक साधारण ब्याज से 2 वर्ष का ब्याज कितना होगा?","options":["₹200","₹210","₹220","₹100"],"answer":0,"explanation":"SI = 1000 × 10 × 2 / 100 = ₹200।"},{"q":"चक्रवृद्धि ब्याज किस पर लगता है?","options":["मूल धन और जमा ब्याज दोनों पर","केवल मूल धन पर","केवल ब्याज पर","किसी पर नहीं"],"answer":0,"explanation":"चक्रवृद्धि में पिछली अवधि का ब्याज भी मूल धन में जुड़कर अगला ब्याज देता है।"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'maths', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
