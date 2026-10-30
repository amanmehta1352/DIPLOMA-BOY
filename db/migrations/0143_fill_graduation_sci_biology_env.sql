-- Migration 0143: graduation_sci general-science 919 (Biology: Other) and 920 (Environment & Ecology), 2 x 4 = 8 atoms
with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body, v.subject_tag, v.exam_tags, v.class_tags, v.difficulty
  from (values
    (919, 'graduation_sci', 'gsci-bio-other-concept', 'concept', 1, 'जैव विज्ञान: जीवन के मूल सिद्धांत',
     $j${"text":"जीव वे इकाइयाँ हैं जो पोषण, श्वसन, उत्सर्जन, वृद्धि, गति, उद्दीपन के प्रति प्रतिक्रिया और जनन दिखाती हैं। जीवन के मूल लक्षण: कोशिकीय संगठन, चयापचय, वृद्धि, अनुकूलन और वंशागति। जैव विविधता जीवों की विभिन्नता है, जिसे वर्गीकरण से पहचाना जाता है।","note":"द्विनाम पद्धति: जीवों का नाम वंश और जाति से (जैसे Homo sapiens)"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (919, 'graduation_sci', 'gsci-bio-other-formula', 'formula', 2, 'वर्गीकरण के स्तर',
     $j${"formula":"जगत → संघ → वर्ग → गण → कुल → वंश → जाति","explanation":"जैविक वर्गीकरण का क्रम (ऊपर से नीचे)"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (919, 'graduation_sci', 'gsci-bio-other-example', 'example', 3, 'उदाहरण',
     $j${"question":"द्विनाम पद्धति में मनुष्य का वैज्ञानिक नाम क्या है?","solution":"द्विनाम पद्धति में पहला शब्द वंश (genus) और दूसरा जाति (species) होता है। मनुष्य का नाम Homo sapiens है।","answer":"Homo sapiens"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (919, 'graduation_sci', 'gsci-bio-other-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"द्विनाम पद्धति किसने प्रस्तुत की?","options":["डार्विन","लिनियस","मेंडल","वाटसन"],"answer":1,"explanation":"द्विनाम पद्धति कार्ल लिनियस ने प्रस्तुत की।"},{"q":"वर्गीकरण का सबसे बड़ा स्तर कौन सा है?","options":["वंश","कुल","जगत","जाति"],"answer":2,"explanation":"जगत वर्गीकरण का सबसे बड़ा स्तर है।"}]}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),

    (920, 'graduation_sci', 'gsci-env-concept', 'concept', 1, 'पर्यावरण और पारितंत्र',
     $j${"text":"पारितंत्र में जैविक (जीव) और अजैविक (जल, मृदा, वायु, ताप) घटक परस्पर क्रिया करते हैं। ऊर्जा प्रवाह एकदिशीय होता है (सूर्य → उत्पादक → उपभोक्ता → अपघटक)। खाद्य श्रृंखला और खाद्य जाल ऊर्जा और पोषक तत्वों के प्रवाह को दिखाते हैं।","note":"उत्पादक: हरे पौधे; उपभोक्ता: जंतु; अपघटक: जीवाणु व कवक"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (920, 'graduation_sci', 'gsci-env-formula', 'formula', 2, 'पोषण स्तर और ऊर्जा',
     $j${"formula":"ऊर्जा का लगभग 10% अगले पोषण स्तर में जाता है (10% नियम) · उत्पादक → प्राथमिक उपभोक्ता → द्वितीयक उपभोक्ता → तृतीयक उपभोक्ता","explanation":"ऊर्जा का पिरामिड और 10% नियम"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (920, 'graduation_sci', 'gsci-env-example', 'example', 3, 'उदाहरण',
     $j${"question":"यदि उत्पादक में 10000 J ऊर्जा है, तो द्वितीयक उपभोक्ता तक लगभग कितनी ऊर्जा पहुँचेगी?","solution":"10% नियम के अनुसार: प्राथमिक उपभोक्ता = 1000 J, द्वितीयक उपभोक्ता = 100 J।","answer":"लगभग 100 J"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (920, 'graduation_sci', 'gsci-env-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"पारितंत्र में ऊर्जा का प्रवाह कैसा होता है?","options":["चक्रीय","एकदिशीय","द्विदिशीय","यादृच्छिक"],"answer":1,"explanation":"पारितंत्र में ऊर्जा का प्रवाह एकदिशीय होता है।"},{"q":"पारितंत्र में अपघटक कौन हैं?","options":["हरे पौधे","शाकाहारी जंतु","जीवाणु और कवक","मांसाहारी जंतु"],"answer":2,"explanation":"जीवाणु और कवक अपघटक हैं।"}]}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard')
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body, subject_tag, exam_tags, class_tags, difficulty)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false, s.exam_tags, s.class_tags, s.subject_tag, s.difficulty, md5(s.body::text)
from src s
on conflict do nothing;
