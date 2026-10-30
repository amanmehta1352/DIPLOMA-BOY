-- 0059: state_psc seed — anchor topic 421 (Polity). 3 level-specific atoms, no exam tags.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (421,'state_psc','spsc-polity-concept','concept',1,'भारतीय संविधान — राज्य PSC',$j${"note":"राज्य PSC में मौलिक अधिकार (अनुच्छेद 12–35) और नीति निदेशक तत्व (अनुच्छेद 36–51) का अंतर अक्सर पूछा जाता है।","text":"भारतीय संविधान के भाग III में मौलिक अधिकार हैं, जो न्यायालय द्वारा प्रवर्तनीय हैं। भाग IV के नीति निदेशक तत्व न्यायालय द्वारा प्रवर्तनीय नहीं हैं, पर शासन के लिए मार्गदर्शक हैं। अनुच्छेद 32 को डॉ. अंबेडकर ने संविधान की आत्मा कहा था।"}$j$),
  (421,'state_psc','spsc-polity-example','example',2,'उदाहरण',$j${"question":"मौलिक अधिकारों की रक्षा के लिए सीधे सर्वोच्च न्यायालय में याचिका किस अनुच्छेद के तहत दायर होती है?","solution":"अनुच्छेद 32 मौलिक अधिकारों के प्रवर्तन के लिए रिट का अधिकार देता है","answer":"अनुच्छेद 32"}$j$),
  (421,'state_psc','spsc-polity-mcq','mcq',3,'अभ्यास प्रश्न',$j${"questions":[{"q":"भारतीय संविधान में मौलिक अधिकार किस भाग में हैं?","options":["भाग III","भाग IV","भाग V","भाग II"],"answer":0,"explanation":"मौलिक अधिकार भाग III में अनुच्छेद 12 से 35 तक हैं।"},{"q":"नीति निदेशक तत्व किस भाग में हैं?","options":["भाग IV","भाग III","भाग I","भाग VI"],"answer":0,"explanation":"नीति निदेशक तत्व भाग IV (अनुच्छेद 36–51) में हैं।"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'general-awareness', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
