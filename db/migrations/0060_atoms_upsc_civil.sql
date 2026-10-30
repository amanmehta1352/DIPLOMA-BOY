-- 0060: upsc_civil seed — anchor topic 418 (Geography). 3 level-specific atoms, no exam tags.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (418,'upsc_civil','upsc-geo-concept','concept',1,'भारत का भूगोल — UPSC सिविल',$j${"note":"UPSC प्रारंभिक परीक्षा में भारत की जलवायु और मानसून की प्रणाली अक्सर पूछी जाती है।","text":"भारत की जलवायु मानसून से नियंत्रित होती है। दक्षिण-पश्चिम मानसून जून से सितंबर तक वर्षा लाता है, जबकि उत्तर-पूर्व मानसून अक्टूबर से दिसंबर तक तमिलनाडु और दक्षिण भारत में वर्षा देता है। हिमालय ठंडी उत्तरी हवाओं को रोकता है और मानसून को भारत में रोके रखता है।"}$j$),
  (418,'upsc_civil','upsc-geo-example','example',2,'उदाहरण',$j${"question":"भारत में अधिकांश वर्षा किस मानसून से होती है?","solution":"दक्षिण-पश्चिम मानसून जून से सितंबर तक भारत की अधिकांश वर्षा लाता है","answer":"दक्षिण-पश्चिम मानसून"}$j$),
  (418,'upsc_civil','upsc-geo-mcq','mcq',3,'अभ्यास प्रश्न',$j${"questions":[{"q":"भारत की सबसे लंबी नदी कौन सी है?","options":["गंगा","ब्रह्मपुत्र","यमुना","गोदावरी"],"answer":0,"explanation":"भारत में गंगा सबसे लंबी नदी है; ब्रह्मपुत्र को भारत में बहने वाली सबसे लंबी नदियों में गिना जाता है, पर सामान्य रूप से गंगा को लंबी नदी कहा जाता है।"},{"q":"तमिलनाडु में मुख्य वर्षा किस मानसून से होती है?","options":["उत्तर-पूर्व मानसून","दक्षिण-पश्चिम मानसून","पश्चिमी विक्षोभ","दक्षिण-पूर्व व्यापारिक हवा"],"answer":0,"explanation":"तमिलनाडु में उत्तर-पूर्व मानसून से मुख्य वर्षा होती है।"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'general-awareness', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
