-- 0052: medical seed — anchor topic 908 (Respiration). 5 level-specific atoms, no exam tags (neet not in mtb.exams yet).

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (908,'medical','med-resp-concept','concept',1,'श्वसन — मेडिकल',$j${"note":"NEET में फेफड़ों की संरचना, गैस विनिमय और श्वसन नियंत्रण अक्सर पूछे जाते हैं।","text":"श्वसन में ग्लूकोज़ का ऑक्सीकरण होकर ATP बनता है। मनुष्य में गैस विनिमय वायुकोशिकाओं (alveoli) में विसरण से होता है। श्वसन की दर मेड्यूला ऑब्लॉन्गेटा में स्थित केंद्र द्वारा नियंत्रित होती है, जो रक्त में CO₂ के स्तर के प्रति संवेदनशील है।"}$j$),
  (908,'medical','med-resp-formula','formula',2,'श्वसन गुणांक (RQ)',$j${"formula":"RQ = CO₂ उत्सर्जित / O₂ उपभोग · कार्बोहाइड्रेट के लिए RQ = 1.0","explanation":"वसा के लिए RQ लगभग 0.7 होता है"}$j$),
  (908,'medical','med-resp-example','example',3,'Clinical',$j${"question":"वायुकोशिकाओं में विसरण किस नियम के कारण होता है?","solution":"गैसें अधिक दाब वाले क्षेत्र से कम दाब वाले क्षेत्र की ओर जाती हैं (आंशिक दाब प्रवणता)","answer":"आंशिक दाब प्रवणता"}$j$),
  (908,'medical','med-resp-mcq','mcq',4,'अभ्यास प्रश्न',$j${"questions":[{"q":"श्वसन की दर किस मस्तिष्क भाग द्वारा नियंत्रित होती है?","options":["मेड्यूला ऑब्लॉन्गेटा","सेरेबेलम","थैलेमस","हाइपोथैलेमस"],"answer":0,"explanation":"मेड्यूला श्वसन केंद्र का नियंत्रण करता है।"},{"q":"कार्बोहाइड्रेट के लिए श्वसन गुणांक (RQ) कितना होता है?","options":["1.0","0.7","0.8","0.9"],"answer":0,"explanation":"कार्बोहाइड्रेट के पूर्ण ऑक्सीकरण में CO₂ और O₂ का अनुपात 1 होता है।"}]}$j$),
  (908,'medical','med-resp-diagram','svg',5,'फेफड़े और वायुकोशिका',$j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><ellipse cx='100' cy='60' rx='40' ry='50' fill='#fca5a5'/><ellipse cx='200' cy='60' rx='40' ry='50' fill='#fca5a5'/><circle cx='100' cy='60' r='8' fill='#fde047'/><circle cx='200' cy='60' r='8' fill='#fde047'/><text x='150' y='118' text-anchor='middle' font-size='11' fill='#64748b'>फेफड़े (वायुकोशिकाएँ)</text></svg>","caption":"फेफड़ों में वायुकोशिकाओं के माध्यम से गैस विनिमय"}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
