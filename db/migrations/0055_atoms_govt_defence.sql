-- 0055: govt_defence seed — anchor topic 9 (Speed, Time & Distance). 5 level-specific atoms; exam tags for the existing defence exams are not yet in mtb.exams, so none are set.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (9,'govt_defence','def-tsd-concept','concept',1,'चाल, समय और दूरी — रक्षा',$j${"note":"NDA और CDS में चाल-समय-दूरी के सरल प्रश्न आते हैं।","text":"चाल = दूरी / समय। यदि दो व्यक्ति विपरीत दिशा में चलें तो सापेक्ष चाल = v₁ + v₂। एक ही दिशा में चलें तो सापेक्ष चाल = v₁ − v₂। किलोमीटर प्रति घंटा को मीटर प्रति सेकंड में बदलने के लिए 5/18 से गुणा करें।"}$j$),
  (9,'govt_defence','def-tsd-formula','formula',2,'चाल का सूत्र',$j${"formula":"चाल = दूरी / समय · km/h → m/s = × 5/18 · m/s → km/h = × 18/5","explanation":"ये रूपांतरण प्रश्नों में सबसे अधिक काम आते हैं"}$j$),
  (9,'govt_defence','def-tsd-example','example',3,'Numerical (Defence style)',$j${"question":"72 km/h की चाल से चलती एक गाड़ी 10 सेकंड में कितनी दूरी तय करेगी (मीटर में)?","solution":"72 km/h = 72 × 5/18 = 20 m/s; दूरी = 20 × 10 = 200 m","answer":"200 m"}$j$),
  (9,'govt_defence','def-tsd-mcq','mcq',4,'अभ्यास प्रश्न',$j${"questions":[{"q":"60 km/h की चाल को m/s में बदलें।","options":["16.67 m/s","60 m/s","3.6 m/s","216 m/s"],"answer":0,"explanation":"60 × 5/18 = 16.67 m/s।"},{"q":"दो व्यक्ति विपरीत दिशा में 4 km/h और 6 km/h से चलें, तो सापेक्ष चाल कितनी होगी?","options":["10 km/h","2 km/h","24 km/h","5 km/h"],"answer":0,"explanation":"विपरीत दिशा में सापेक्ष चाल = 4 + 6 = 10 km/h।"}]}$j$),
  (9,'govt_defence','def-tsd-diagram','svg',5,'दूरी-समय ग्राफ',$j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><line x1='30' y1='100' x2='280' y2='100' stroke='#64748b' stroke-width='2'/><line x1='30' y1='100' x2='30' y2='15' stroke='#64748b' stroke-width='2'/><line x1='30' y1='100' x2='250' y2='30' stroke='#f59e0b' stroke-width='3'/><text x='150' y='118' text-anchor='middle' font-size='11' fill='#64748b'>समय →</text><text x='12' y='60' font-size='11' fill='#64748b'>दूरी</text></svg>","caption":"दूरी-समय ग्राफ का ढाल चाल दर्शाता है"}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'maths', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
