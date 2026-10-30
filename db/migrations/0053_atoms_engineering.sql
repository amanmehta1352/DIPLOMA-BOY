-- 0053: engineering seed — anchor topic 872 (Force & Laws of Motion). 5 level-specific atoms, no exam tags (jee not in mtb.exams yet).

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (872,'engineering','eng-force-concept','concept',1,'बल और गति के नियम — इंजीनियरिंग',$j${"note":"JEE में न्यूटन के नियम और मुक्त-पिंड आरेख (FBD) अक्सर पूछे जाते हैं।","text":"न्यूटन का प्रथम नियम: बाहरी बल न होने पर वस्तु अपनी स्थिति नहीं बदलती। द्वितीय नियम: F = ma। तृतीय नियम: हर क्रिया की समान और विपरीत प्रतिक्रिया होती है। मुक्त-पिंड आरेख में वस्तु पर लगने वाले सभी बल दर्शाए जाते हैं।"}$j$),
  (872,'engineering','eng-force-formula','formula',2,'संवेग और आवेग',$j${"formula":"p = mv · F = dp/dt · J = FΔt = Δp","explanation":"आवेग (impulse) संवेग परिवर्तन के बराबर होता है"}$j$),
  (872,'engineering','eng-force-example','example',3,'Numerical',$j${"question":"5 kg द्रव्यमान की वस्तु पर 20 N बल लगता है। त्वरण क्या होगा?","solution":"a = F/m = 20/5 = 4 m/s²","answer":"4 m/s²"}$j$),
  (872,'engineering','eng-force-mcq','mcq',4,'अभ्यास प्रश्न',$j${"questions":[{"q":"न्यूटन का द्वितीय नियम किसे परिभाषित करता है?","options":["F = ma","F = mv","F = m/a","E = mc²"],"answer":0,"explanation":"द्वितीय नियम के अनुसार बल द्रव्यमान और त्वरण के गुणनफल के बराबर है।"},{"q":"यदि बाहरी बल शून्य है, तो चलती वस्तु का वेग कैसा रहेगा?","options":["स्थिर","बढ़ेगा","घटेगा","शून्य होगा"],"answer":0,"explanation":"न्यूटन के प्रथम नियम के अनुसार वेग स्थिर रहता है।"}]}$j$),
  (872,'engineering','eng-force-diagram','svg',5,'मुक्त-पिंड आरेख',$j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='120' y='40' width='60' height='40' fill='#bfdbfe' stroke='#2563eb' stroke-width='2'/><line x1='150' y1='40' x2='150' y2='10' stroke='#dc2626' stroke-width='3'/><line x1='150' y1='80' x2='150' y2='110' stroke='#16a34a' stroke-width='3'/><text x='150' y='118' text-anchor='middle' font-size='11' fill='#64748b'>ऊपर: सामान्य बल · नीचे: भार</text></svg>","caption":"वस्तु पर लगने वाले बलों का मुक्त-पिंड आरेख"}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
