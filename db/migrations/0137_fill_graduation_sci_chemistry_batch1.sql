-- Migration 0137: graduation_sci general-science chemistry chapters 885-888 (4 x 4 = 16 atoms)
with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body, v.subject_tag, v.exam_tags, v.class_tags, v.difficulty
  from (values
    (885, 'graduation_sci', 'gsci-matter-concept', 'concept', 1, 'पदार्थ और उसकी अवस्थाएँ',
     $j${"text":"पदार्थ वह है जिसमें द्रव्यमान और आयतन होता है। पदार्थ तीन मुख्य अवस्थाओं में मिलता है: ठोस, द्रव और गैस। कणों के बीच आकर्षण और उनकी गतिज ऊर्जा अवस्था तय करती है। अवस्था परिवर्तन के लिए ऊष्मा दी या ली जाती है।","note":"ठोस → द्रव: गलन; द्रव → गैस: वाष्पीकरण"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (885, 'graduation_sci', 'gsci-matter-formula', 'formula', 2, 'अवस्था परिवर्तन',
     $j${"formula":"ठोस ⇌ द्रव (गलन/हिमीकरण) · द्रव ⇌ गैस (वाष्पीकरण/संघनन) · ठोस ⇌ गैस (उर्ध्वपातन)","explanation":"अवस्था परिवर्तन के प्रमुख मार्ग"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (885, 'graduation_sci', 'gsci-matter-example', 'example', 3, 'उदाहरण',
     $j${"question":"कपूर ठोस से सीधे गैस में बदल जाता है। इस प्रक्रिया को क्या कहते हैं?","solution":"ठोस से सीधे गैस में बदलने की प्रक्रिया को उर्ध्वपातन (sublimation) कहते हैं।","answer":"उर्ध्वपातन (sublimation)"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (885, 'graduation_sci', 'gsci-matter-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"बर्फ का पानी में बदलना किस प्रक्रिया का उदाहरण है?","options":["वाष्पीकरण","गलन","संघनन","उर्ध्वपातन"],"answer":1,"explanation":"ठोस से द्रव में बदलना गलन है।"},{"q":"पदार्थ की मुख्य अवस्थाएँ कितनी हैं?","options":["एक","दो","तीन","चार"],"answer":2,"explanation":"ठोस, द्रव और गैस तीन मुख्य अवस्थाएँ हैं।"}]}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),

    (886, 'graduation_sci', 'gsci-atom-concept', 'concept', 1, 'परमाणु संरचना',
     $j${"text":"परमाणु के केंद्र में प्रोटॉन (धनावेशित) और न्यूट्रॉन (उदासीन) होते हैं, और उसके चारों ओर इलेक्ट्रॉन (ऋणावेशित) कक्षाओं में घूमते हैं। परमाणु क्रमांक = प्रोटॉन की संख्या; द्रव्यमान संख्या = प्रोटॉन + न्यूट्रॉन।","note":"परमाणु उदासीन होता है: इलेक्ट्रॉन = प्रोटॉन"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (886, 'graduation_sci', 'gsci-atom-formula', 'formula', 2, 'मुख्य सूत्र',
     $j${"formula":"परमाणु क्रमांक (Z) = प्रोटॉन · द्रव्यमान संख्या (A) = Z + न्यूट्रॉन · इलेक्ट्रॉन विन्यास: 2, 8, 8, ...","explanation":"परमाणु के मूल संबंध"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (886, 'graduation_sci', 'gsci-atom-example', 'example', 3, 'उदाहरण',
     $j${"question":"किसी तत्व का परमाणु क्रमांक 11 और द्रव्यमान संख्या 23 है। न्यूट्रॉन कितने हैं?","solution":"न्यूट्रॉन = A − Z = 23 − 11 = 12","answer":"12"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (886, 'graduation_sci', 'gsci-atom-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"परमाणु का कौन सा कण उदासीन होता है?","options":["प्रोटॉन","इलेक्ट्रॉन","न्यूट्रॉन","आयन"],"answer":2,"explanation":"न्यूट्रॉन उदासीन होता है।"},{"q":"परमाणु क्रमांक किसकी संख्या है?","options":["न्यूट्रॉन","प्रोटॉन","इलेक्ट्रॉन कक्षा","द्रव्यमान"],"answer":1,"explanation":"परमाणु क्रमांक प्रोटॉन की संख्या है।"}]}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),

    (887, 'graduation_sci', 'gsci-period-concept', 'concept', 1, 'आवर्त सारणी',
     $j${"text":"आधुनिक आवर्त सारणी तत्वों को परमाणु क्रमांक के आधार पर व्यवस्थित करती है। समूह (ऊर्ध्वाधर स्तंभ) में समान संयोजकता होती है, और आवर्त (क्षैतिज पंक्ति) में इलेक्ट्रॉन कक्षाओं की संख्या समान होती है। बाएँ से दाएँ जाने पर धातु गुण घटते हैं और अधातु गुण बढ़ते हैं।","note":"समूह 1 = क्षार धातुएँ; समूह 18 = अक्रिय गैसें"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (887, 'graduation_sci', 'gsci-period-formula', 'formula', 2, 'मुख्य समूह',
     $j${"formula":"समूह 1 → क्षार धातुएँ · समूह 17 → हैलोजन · समूह 18 → अक्रिय (उत्कृष्ट) गैसें","explanation":"प्रमुख समूहों के नाम"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (887, 'graduation_sci', 'gsci-period-example', 'example', 3, 'उदाहरण',
     $j${"question":"हीलियम किस समूह का तत्व है?","solution":"हीलियम अक्रिय गैस है और समूह 18 में आती है।","answer":"समूह 18"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (887, 'graduation_sci', 'gsci-period-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"आवर्त सारणी किस आधार पर व्यवस्थित है?","options":["परमाणु द्रव्यमान","परमाणु क्रमांक","घनत्व","रंग"],"answer":1,"explanation":"आधुनिक आवर्त सारणी परमाणु क्रमांक पर आधारित है।"},{"q":"क्षार धातुएँ किस समूह में हैं?","options":["समूह 1","समूह 2","समूह 17","समूह 18"],"answer":0,"explanation":"क्षार धातुएँ समूह 1 में हैं।"}]}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),

    (888, 'graduation_sci', 'gsci-bond-concept', 'concept', 1, 'रासायनिक बंधन',
     $j${"text":"परमाणु स्थायित्व के लिए बंधन बनाते हैं। आयनिक बंधन में इलेक्ट्रॉनों का स्थानांतरण होता है (जैसे NaCl)। सहसंयोजक बंधन में इलेक्ट्रॉनों की साझेदारी होती है (जैसे H₂, O₂)। अधिकांश तत्व अष्टक नियम (octet rule) का पालन करते हैं।","note":"आयनिक = देना-लेना; सहसंयोजक = साझा करना"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (888, 'graduation_sci', 'gsci-bond-formula', 'formula', 2, 'बंधन के प्रकार',
     $j${"formula":"आयनिक बंधन → इलेक्ट्रॉन स्थानांतरण (NaCl) · सहसंयोजक बंधन → इलेक्ट्रॉन साझेदारी (H₂O, CH₄) · अष्टक नियम → बाहरी कक्ष में 8 इलेक्ट्रॉन","explanation":"बंधन और उनके उदाहरण"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (888, 'graduation_sci', 'gsci-bond-example', 'example', 3, 'उदाहरण',
     $j${"question":"सोडियम क्लोराइड (NaCl) में किस प्रकार का बंधन है?","solution":"सोडियम एक इलेक्ट्रॉन देता है और क्लोरीन उसे ग्रहण करता है, इसलिए यह आयनिक बंधन है।","answer":"आयनिक बंधन"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (888, 'graduation_sci', 'gsci-bond-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"H₂ अणु में कौन सा बंधन है?","options":["आयनिक","सहसंयोजक","धात्विक","हाइड्रोजन बंधन"],"answer":1,"explanation":"H₂ में इलेक्ट्रॉनों की साझेदारी से सहसंयोजक बंधन बनता है।"},{"q":"अष्टक नियम के अनुसार बाहरी कक्ष में कितने इलेक्ट्रॉन आदर्श हैं?","options":["2","4","6","8"],"answer":3,"explanation":"अष्टक नियम के अनुसार बाहरी कक्ष में 8 इलेक्ट्रॉन आदर्श हैं।"}]}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard')
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body, subject_tag, exam_tags, class_tags, difficulty)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false, s.exam_tags, s.class_tags, s.subject_tag, s.difficulty, md5(s.body::text)
from src s
on conflict do nothing;
