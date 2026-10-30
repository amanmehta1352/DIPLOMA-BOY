-- 0064: advanced_research seed — anchor topic 441 (Thermodynamics). 3 level-specific atoms, no exam tags (GATE/NET not in mtb.exams yet).

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (441,'advanced_research','adv-thermo-concept','concept',1,'ऊष्मागतिकी का पहला नियम — उच्च शोध',$j${"note":"GATE और NET में ऊष्मागतिकी के पहले नियम और उसके अनुप्रयोग अक्सर पूछे जाते हैं।","text":"ऊष्मागतिकी का पहला नियम ऊर्जा संरक्षण का कथन है: किसी तंत्र को दी गई ऊष्मा का कुछ भाग आंतरिक ऊर्जा बढ़ाने और शेष बाहर कार्य करने में जाता है। चक्रीय प्रक्रिया में तंत्र की आंतरिक ऊर्जा में शुद्ध परिवर्तन शून्य होता है।"}$j$),
  (441,'advanced_research','adv-thermo-formula','formula',2,'पहला नियम',$j${"formula":"ΔQ = ΔU + ΔW","explanation":"ΔQ ग्रहण की गई ऊष्मा, ΔU आंतरिक ऊर्जा में परिवर्तन, ΔW तंत्र द्वारा किया गया कार्य"}$j$),
  (441,'advanced_research','adv-thermo-example','example',3,'Numerical',$j${"question":"एक गैस को 500 J ऊष्मा दी जाती है और वह 200 J कार्य करती है। आंतरिक ऊर्जा में परिवर्तन क्या होगा?","solution":"ΔU = ΔQ − ΔW = 500 − 200 = 300 J","answer":"300 J"}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'mechanical-engineering', 'hard', md5(s.body::text)
from src s
on conflict do nothing;
