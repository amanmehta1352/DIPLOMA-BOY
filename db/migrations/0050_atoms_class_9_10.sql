-- 0050: class_9_10 seed — anchor topic 871 (Motion). 5 atoms, no exam tags (no board/olympiad exams in mtb.exams yet).

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (871,'class_9_10','c910-motion-concept','concept',1,'गति — कक्षा 9-10',$j${"note":"बोर्ड परीक्षा में दूरी और विस्थापन का अंतर अक्सर पूछा जाता है।","text":"किसी वस्तु की स्थिति समय के साथ बदलना गति है। दूरी एक अदिश राशि है और विस्थापन सदिश राशि है। एकसमान गति में वस्तु समान समय में समान दूरी तय करती है।"}$j$),
  (871,'class_9_10','c910-motion-formula','formula',2,'गति का समीकरण',$j${"formula":"v = u + at · s = ut + ½at² · v² = u² + 2as","explanation":"u प्रारंभिक वेग, v अंतिम वेग, a त्वरण, t समय, s विस्थापन"}$j$),
  (871,'class_9_10','c910-motion-example','example',3,'उदाहरण',$j${"question":"एक कार 2 m/s² त्वरण से 5 s तक चलती है (प्रारंभिक वेग 0)। अंतिम वेग क्या होगा?","solution":"v = u + at = 0 + 2 × 5 = 10 m/s","answer":"10 m/s"}$j$),
  (871,'class_9_10','c910-motion-mcq','mcq',4,'अभ्यास प्रश्न',$j${"questions":[{"q":"दूरी किस प्रकार की राशि है?","options":["अदिश","सदिश","दोनों","इनमें से कोई नहीं"],"answer":0,"explanation":"दूरी केवल परिमाण रखती है, इसलिए यह अदिश राशि है।"},{"q":"एकसमान गति में वस्तु का त्वरण कितना होता है?","options":["शून्य","धनात्मक","ऋणात्मक","अनंत"],"answer":0,"explanation":"एकसमान वेग में वेग नहीं बदलता, इसलिए त्वरण शून्य होता है।"}]}$j$),
  (871,null,'c910-motion-diagram','svg',5,'दूरी-समय ग्राफ',$j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><line x1='30' y1='100' x2='280' y2='100' stroke='#64748b' stroke-width='2'/><line x1='30' y1='100' x2='30' y2='15' stroke='#64748b' stroke-width='2'/><line x1='30' y1='100' x2='250' y2='30' stroke='#14b8a6' stroke-width='3'/><text x='150' y='118' text-anchor='middle' font-size='11' fill='#64748b'>समय →</text><text x='12' y='60' font-size='11' fill='#64748b'>दूरी</text></svg>","caption":"एकसमान गति में दूरी-समय ग्राफ सीधी रेखा होता है"}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
