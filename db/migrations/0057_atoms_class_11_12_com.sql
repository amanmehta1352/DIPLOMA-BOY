-- 0057: class_11_12_com seed — anchor topic 417 (Economy). 3 level-specific atoms, no exam tags.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (417,'class_11_12_com','c1112c-econ-concept','concept',1,'अर्थशास्त्र की मूल बातें — कक्षा 11-12 कॉमर्स',$j${"note":"बोर्ड परीक्षा में माँग और पूर्ति का संतुलन और GDP की गणना अक्सर पूछी जाती है।","text":"अर्थशास्त्र सीमित संसाधनों से अधिकतम संतुष्टि प्राप्त करने का अध्ययन है। माँग वह मात्रा है जिसे उपभोक्ता एक कीमत पर खरीदना चाहता है, और पूर्ति वह मात्रा है जिसे विक्रेता बेचने को तैयार है। जब माँग और पूर्ति बराबर होती हैं, तब बाज़ार संतुलन में होता है।"}$j$),
  (417,'class_11_12_com','c1112c-econ-example','example',2,'उदाहरण',$j${"question":"GDP = C + I + G + (X − M) है। यदि C = 500, I = 200, G = 100, X = 150, M = 50 हो, तो GDP क्या होगी?","solution":"GDP = 500 + 200 + 100 + (150 − 50) = 900","answer":"900"}$j$),
  (417,'class_11_12_com','c1112c-econ-mcq','mcq',3,'अभ्यास प्रश्न',$j${"questions":[{"q":"बाज़ार संतुलन पर माँग और पूर्ति की स्थिति कैसी होती है?","options":["बराबर होती हैं","माँग अधिक होती है","पूर्ति अधिक होती है","दोनों शून्य होती हैं"],"answer":0,"explanation":"संतुलन पर माँग और पूर्ति बराबर होती हैं।"},{"q":"राष्ट्रीय आय की गणना में 'C' किसका प्रतीक है?","options":["उपभोग व्यय","निवेश","सरकारी व्यय","निर्यात"],"answer":0,"explanation":"C का अर्थ उपभोग व्यय (Consumption) है।"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'general-awareness', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
