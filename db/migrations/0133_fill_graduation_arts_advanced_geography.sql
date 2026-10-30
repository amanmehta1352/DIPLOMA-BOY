-- Migration 0133: graduation_arts advanced-geography chapters 1173-1177 (5 x 4 = 20 atoms)
with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body, v.subject_tag, v.exam_tags, v.class_tags, v.difficulty
  from (values
    (1173, 'graduation_arts', 'ageo-geomorph-concept', 'concept', 1, 'भू-आकृति विज्ञान (Geomorphology)',
     $j${"text":"भू-आकृति विज्ञान पृथ्वी की सतह की आकृतियों के निर्माण और विकास का अध्ययन है। डेविस का अपरदन-चक्र सिद्धांत बताता है कि भू-दृश्य युवावस्था, प्रौढ़ावस्था और वृद्धावस्था से गुज़रता है। अपक्षय (यांत्रिक व रासायनिक) और अपरदन इसकी मुख्य प्रक्रियाएँ हैं।","note":"डेविस: युवा → प्रौढ़ → वृद्ध अवस्था"}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),
    (1173, 'graduation_arts', 'ageo-geomorph-formula', 'formula', 2, 'डेविस का चक्र',
     $j${"formula":"संरचना + प्रक्रम + समय = भू-आकृति (W.M. Davis) · युवा → प्रौढ़ → वृद्ध अवस्था","explanation":"अपरदन-चक्र सिद्धांत का सूत्र"}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),
    (1173, 'graduation_arts', 'ageo-geomorph-example', 'example', 3, 'उदाहरण',
     $j${"question":"नदी घाटी जो गहरी V-आकार की है और तेज़ कटाव हो रहा है, किस अवस्था में मानी जाएगी?","solution":"गहरी V-आकार घाटी और तेज़ कटाव युवा अवस्था के लक्षण हैं।","answer":"युवा अवस्था"}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),
    (1173, 'graduation_arts', 'ageo-geomorph-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"अपरदन-चक्र सिद्धांत किसने दिया?","options":["वेगनर","डेविस","हटन","लाइल"],"answer":1,"explanation":"अपरदन-चक्र सिद्धांत डब्ल्यू.एम. डेविस ने दिया।"},{"q":"यांत्रिक अपक्षय का उदाहरण?","options":["घोल बनना","तापमान में बदलाव से चट्टान टूटना","रासायनिक घुलन","ऑक्सीकरण"],"answer":1,"explanation":"तापमान के बदलाव से चट्टान का टूटना यांत्रिक अपक्षय है।"}]}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),

    (1174, 'graduation_arts', 'ageo-clim-concept', 'concept', 1, 'जलवायु विज्ञान (Climatology)',
     $j${"text":"जलवायु विज्ञान पृथ्वी की जलवायु के प्रकारों और उनके कारणों का अध्ययन है। कोपेन वर्गीकरण तापमान और वर्षा पर आधारित है। जलवायु को प्रभावित करने वाले कारक हैं: अक्षांश, ऊँचाई, समुद्र से दूरी, पवनें और धाराएँ।","note":"कोपेन = तापमान + वर्षा आधारित वर्गीकरण"}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),
    (1174, 'graduation_arts', 'ageo-clim-formula', 'formula', 2, 'जलवायु को प्रभावित करने वाले कारक',
     $j${"formula":"अक्षांश · ऊँचाई · समुद्र से दूरी · पवन-प्रणाली · समुद्री धाराएँ","explanation":"जलवायु के प्रमुख नियंत्रक"}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),
    (1174, 'graduation_arts', 'ageo-clim-example', 'example', 3, 'उदाहरण',
     $j${"question":"समुद्र के पास स्थित स्थान की जलवायु सामान्यतः कैसी होती है?","solution":"समुद्र का प्रभाव तापमान की अति को कम करता है, इसलिए वहाँ की जलवायु अपेक्षाकृत सम (मॉडरेट) होती है।","answer":"सम (मॉडरेट) जलवायु"}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),
    (1174, 'graduation_arts', 'ageo-clim-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"कोपेन वर्गीकरण किन दो कारकों पर आधारित है?","options":["ऊँचाई और दिशा","तापमान और वर्षा","पवन और धारा","मिट्टी और वनस्पति"],"answer":1,"explanation":"कोपेन वर्गीकरण तापमान और वर्षा पर आधारित है।"},{"q":"कौन सा कारक जलवायु को सबसे अधिक प्रभावित करता है?","options":["अक्षांश","नदी की चौड़ाई","भाषा","जनसंख्या"],"answer":0,"explanation":"अक्षांश सौर विकिरण को सीधे प्रभावित करता है।"}]}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),

    (1175, 'graduation_arts', 'ageo-ocean-concept', 'concept', 1, 'महासागर विज्ञान (Oceanography)',
     $j${"text":"महासागर विज्ञान महासागरों की भौतिक, रासायनिक और जैविक विशेषताओं का अध्ययन है। महासागरीय धाराएँ तापमान और जलवायु का संतुलन बनाती हैं। गर्म धारा (जैसे गल्फ स्ट्रीम) और ठंडी धारा (जैसे लैब्रेडोर) का मिलन क्षेत्र मत्स्य-क्षेत्र बनाता है।","note":"गर्म धारा = तटों को गर्म रखती है; ठंडी धारा = तटों को ठंडा"}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),
    (1175, 'graduation_arts', 'ageo-ocean-formula', 'formula', 2, 'धाराओं के प्रकार',
     $j${"formula":"गर्म धारा (जैसे गल्फ स्ट्रीम) → उत्तर-पश्चिमी यूरोप को गर्म · ठंडी धारा (जैसे लैब्रेडोर) → तट को ठंडा","explanation":"धाराओं का प्रभाव"}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),
    (1175, 'graduation_arts', 'ageo-ocean-example', 'example', 3, 'उदाहरण',
     $j${"question":"गल्फ स्ट्रीम किस प्रकार की धारा है?","solution":"गल्फ स्ट्रीम एक गर्म महासागरीय धारा है।","answer":"गर्म धारा"}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),
    (1175, 'graduation_arts', 'ageo-ocean-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"गल्फ स्ट्रीम किस प्रकार की धारा है?","options":["ठंडी","गर्म","लवणीय","तूफ़ानी"],"answer":1,"explanation":"गल्फ स्ट्रीम गर्म धारा है।"},{"q":"गर्म और ठंडी धाराओं का मिलन क्षेत्र क्या बनाता है?","options":["रेगिस्तान","मत्स्य-क्षेत्र","पर्वत","झील"],"answer":1,"explanation":"ऐसे मिलन क्षेत्र मत्स्य-क्षेत्र बनाते हैं, जैसे न्यूफ़ाउंडलैंड।"}]}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),

    (1176, 'graduation_arts', 'ageo-hum-concept', 'concept', 1, 'मानव भूगोल (उन्नत)',
     $j${"text":"उन्नत मानव भूगोल में जनसंख्या सिद्धांत (माल्थस की जनसंख्या वृद्धि, जनसंख्या संक्रमण), प्रवास और नगरीकरण शामिल हैं। माल्थस का मानना था कि जनसंख्या ज्यामितीय गति से और खाद्य अंकगणितीय गति से बढ़ते हैं। जनसंख्या संक्रमण में मृत्यु-दर और जन्म-दर दोनों घटती हैं।","note":"माल्थस: ज्यामितीय बनाम अंकगणितीय वृद्धि"}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),
    (1176, 'graduation_arts', 'ageo-hum-formula', 'formula', 2, 'जनसंख्या सिद्धांत',
     $j${"formula":"माल्थस: जनसंख्या ज्यामितीय (2, 4, 8…) · खाद्य अंकगणितीय (1, 2, 3…) · जनसंख्या संक्रमण: उच्च → निम्न जन्म-मृत्यु दर","explanation":"जनसंख्या वृद्धि के दो मॉडल"}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),
    (1176, 'graduation_arts', 'ageo-hum-example', 'example', 3, 'उदाहरण',
     $j${"question":"यदि जनसंख्या 2, 4, 8, 16 के क्रम में बढ़े, तो यह किस प्रकार की वृद्धि है?","solution":"हर चरण में गुणा होने से यह ज्यामितीय वृद्धि है।","answer":"ज्यामितीय वृद्धि"}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),
    (1176, 'graduation_arts', 'ageo-hum-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"माल्थस के अनुसार जनसंख्या किस गति से बढ़ती है?","options":["अंकगणितीय","ज्यामितीय","स्थिर","घातीय नहीं"],"answer":1,"explanation":"माल्थस के अनुसार जनसंख्या ज्यामितीय गति से बढ़ती है।"},{"q":"जनसंख्या संक्रमण में पहले किसमें गिरावट आती है?","options":["जन्म-दर","मृत्यु-दर","प्रवास","साक्षरता"],"answer":1,"explanation":"संक्रमण में पहले मृत्यु-दर घटती है।"}]}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),

    (1177, 'graduation_arts', 'ageo-reg-concept', 'concept', 1, 'प्रादेशिक नियोजन (Regional Planning)',
     $j${"text":"प्रादेशिक नियोजन किसी क्षेत्र के संसाधनों, जनसंख्या और अवसंरचना का योजनाबद्ध विकास है। भारत में पंचवर्षीय योजनाएँ और क्षेत्रीय विकास कार्यक्रम इसका हिस्सा हैं। संतुलित विकास के लिए पिछड़े क्षेत्रों में निवेश और अवसंरचना पर बल दिया जाता है।","note":"लक्ष्य: संसाधनों का संतुलित और टिकाऊ उपयोग"}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),
    (1177, 'graduation_arts', 'ageo-reg-formula', 'formula', 2, 'नियोजन के मुख्य तत्व',
     $j${"formula":"संसाधन सर्वेक्षण → क्षेत्रीय विश्लेषण → लक्ष्य-निर्धारण → कार्यान्वयन → मूल्यांकन","explanation":"प्रादेशिक नियोजन की प्रक्रिया"}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),
    (1177, 'graduation_arts', 'ageo-reg-example', 'example', 3, 'उदाहरण',
     $j${"question":"पिछड़े क्षेत्रों में सड़क और बिजली जैसी सुविधाएँ देना किस उद्देश्य से है?","solution":"यह संतुलित क्षेत्रीय विकास के लिए अवसंरचना देने का कदम है।","answer":"संतुलित क्षेत्रीय विकास"}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard'),
    (1177, 'graduation_arts', 'ageo-reg-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"प्रादेशिक नियोजन की प्रक्रिया में पहला चरण क्या है?","options":["मूल्यांकन","संसाधन सर्वेक्षण","कार्यान्वयन","लक्ष्य-निर्धारण"],"answer":1,"explanation":"पहला चरण संसाधन सर्वेक्षण है।"},{"q":"भारत में क्षेत्रीय विकास का एक प्रमुख माध्यम क्या है?","options":["पंचवर्षीय योजनाएँ","फ़िल्में","खेल","व्यापार मेला"],"answer":0,"explanation":"पंचवर्षीय योजनाएँ क्षेत्रीय विकास का एक प्रमुख माध्यम रही हैं।"}]}$j$,
     'advanced-geography', array[]::text[], array[]::text[], 'hard')
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body, subject_tag, exam_tags, class_tags, difficulty)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false, s.exam_tags, s.class_tags, s.subject_tag, s.difficulty, md5(s.body::text)
from src s
on conflict do nothing;
