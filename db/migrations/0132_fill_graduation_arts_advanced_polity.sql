-- Migration 0132: graduation_arts advanced-polity chapters 1168-1172 (5 x 4 = 20 atoms)
with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body, v.subject_tag, v.exam_tags, v.class_tags, v.difficulty
  from (values
    (1168, 'graduation_arts', 'apol-ind-concept', 'concept', 1, 'भारतीय राजनीतिक चिंतन',
     $j${"text":"भारतीय राजनीतिक चिंतन में धर्म, राज्यधर्म और लोककल्याण की अवधारणाएँ प्रमुख हैं। कौटिल्य का अर्थशास्त्र शासन और कूटनीति पर केंद्रित है। आधुनिक काल में राजा राम मोहन राय, गांधी, अंबेडकर और नेहरू ने लोकतंत्र, स्वराज और सामाजिक न्याय पर विचार दिए।","note":"गांधी = स्वराज और ग्राम स्वावलंबन; अंबेडकर = सामाजिक न्याय और संवैधानिक नैतिकता"}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),
    (1168, 'graduation_arts', 'apol-ind-formula', 'formula', 2, 'प्रमुख ग्रंथ और विचारक',
     $j${"formula":"कौटिल्य — अर्थशास्त्र (शासन, कूटनीति) · गांधी — हिंद स्वराज (स्वराज) · अंबेडकर — जाति का उन्मूलन (सामाजिक न्याय)","explanation":"विचारक, ग्रंथ और उनकी मुख्य अवधारणा"}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),
    (1168, 'graduation_arts', 'apol-ind-example', 'example', 3, 'उदाहरण',
     $j${"question":"'हिंद स्वराज' ग्रंथ किस विचारक से जुड़ा है और उसका केंद्रीय विषय क्या है?","solution":"यह ग्रंथ गांधी का है, जिसका केंद्रीय विषय स्वराज और आत्मनिर्भर समाज है।","answer":"गांधी — स्वराज"}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),
    (1168, 'graduation_arts', 'apol-ind-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"कौटिल्य का प्रसिद्ध ग्रंथ कौन सा है?","options":["मनुस्मृति","अर्थशास्त्र","हिंद स्वराज","जाति का उन्मूलन"],"answer":1,"explanation":"कौटिल्य का प्रसिद्ध ग्रंथ अर्थशास्त्र है।"},{"q":"'जाति का उन्मूलन' ग्रंथ किससे जुड़ा है?","options":["गांधी","नेहरू","अंबेडकर","टैगोर"],"answer":2,"explanation":"'जाति का उन्मूलन' डॉ. अंबेडकर का ग्रंथ है।"}]}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),

    (1169, 'graduation_arts', 'apol-west-concept', 'concept', 1, 'पाश्चात्य राजनीतिक चिंतन',
     $j${"text":"प्लेटो के 'रिपब्लिक' में दार्शनिक-शासक का आदर्श है। अरस्तू ने राज्य को सर्वोच्च समुदाय माना और संविधानों का वर्गीकरण किया। हॉब्स ने सामाजिक संविदा में शांति के लिए निरंकुश शासन का समर्थन किया, लॉक ने सीमित शासन और संपत्ति के अधिकार पर बल दिया, और रूसो ने सामान्य इच्छा (general will) की अवधारणा दी।","note":"हॉब्स = निरंकुश; लॉक = सीमित; रूसो = सामान्य इच्छा"}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),
    (1169, 'graduation_arts', 'apol-west-formula', 'formula', 2, 'संविदा विचारक',
     $j${"formula":"हॉब्स — निरंकुश शासन (लेविएथन) · लॉक — सीमित शासन, जीवन-स्वतंत्रता-संपत्ति · रूसो — सामान्य इच्छा (लोकप्रिय संप्रभुता)","explanation":"तीन संविदा विचारक और उनके निष्कर्ष"}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),
    (1169, 'graduation_arts', 'apol-west-example', 'example', 3, 'उदाहरण',
     $j${"question":"कौन सा विचारक सीमित सरकार और संपत्ति के अधिकार का समर्थक था?","solution":"जॉन लॉक सीमित सरकार और जीवन, स्वतंत्रता व संपत्ति के अधिकार के समर्थक थे।","answer":"जॉन लॉक"}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),
    (1169, 'graduation_arts', 'apol-west-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"'सामान्य इच्छा' (General Will) की अवधारणा किसने दी?","options":["हॉब्स","लॉक","रूसो","प्लेटो"],"answer":2,"explanation":"सामान्य इच्छा की अवधारणा रूसो ने दी।"},{"q":"'रिपब्लिक' ग्रंथ किससे जुड़ा है?","options":["अरस्तू","प्लेटो","हॉब्स","मार्क्स"],"answer":1,"explanation":"'रिपब्लिक' प्लेटो का ग्रंथ है।"}]}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),

    (1170, 'graduation_arts', 'apol-pa-concept', 'concept', 1, 'लोक प्रशासन',
     $j${"text":"लोक प्रशासन सरकारी नीतियों को लागू करने और सेवाएँ देने का विज्ञान व कला है। वेबर ने नौकरशाही के आदर्श-प्रारूप में पदानुक्रम, नियम और योग्यता पर बल दिया। भारत में नौकरशाही संघ लोक सेवा आयोग (UPSC) द्वारा भर्ती होती है।","note":"वेबर = आदर्श नौकरशाही; UPSC = अखिल भारतीय सेवाओं की भर्ती"}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),
    (1170, 'graduation_arts', 'apol-pa-formula', 'formula', 2, 'नौकरशाही के लक्षण',
     $j${"formula":"पदानुक्रम (hierarchy) · नियम व विनियम · विशेषज्ञता · योग्यता-आधारित भर्ती · निष्पक्षता","explanation":"वेबर के नौकरशाही मॉडल के मुख्य लक्षण"}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),
    (1170, 'graduation_arts', 'apol-pa-example', 'example', 3, 'उदाहरण',
     $j${"question":"भारत में अखिल भारतीय सेवाओं की भर्ती किस संस्था द्वारा होती है?","solution":"अखिल भारतीय सेवाओं (IAS, IPS, IFS) की भर्ती संघ लोक सेवा आयोग (UPSC) द्वारा होती है।","answer":"UPSC"}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),
    (1170, 'graduation_arts', 'apol-pa-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"नौकरशाही के आदर्श-प्रारूप का विचार किसने दिया?","options":["मार्क्स","वेबर","दुर्खाइम","हॉब्स"],"answer":1,"explanation":"आदर्श नौकरशाही का मॉडल मैक्स वेबर ने दिया।"},{"q":"अखिल भारतीय सेवाओं की भर्ती कौन करता है?","options":["राज्य लोक सेवा आयोग","UPSC","राष्ट्रपति सचिवालय","नीति आयोग"],"answer":1,"explanation":"अखिल भारतीय सेवाओं की भर्ती UPSC करता है।"}]}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),

    (1171, 'graduation_arts', 'apol-comp-concept', 'concept', 1, 'तुलनात्मक राजनीति',
     $j${"text":"तुलनात्मक राजनीति विभिन्न देशों की राजनीतिक व्यवस्थाओं का तुलनात्मक अध्ययन है। शासन-प्रणालियों को संसदीय और अध्यक्षीय में बाँटा जाता है। संसदीय प्रणाली में कार्यपालिका विधायिका के प्रति उत्तरदायी होती है, जबकि अध्यक्षीय में कार्यपालिका का कार्यकाल निश्चित होता है (जैसे अमेरिका)।","note":"भारत = संसदीय; अमेरिका = अध्यक्षीय"}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),
    (1171, 'graduation_arts', 'apol-comp-formula', 'formula', 2, 'प्रणालियों का अंतर',
     $j${"formula":"संसदीय → कार्यपालिका विधायिका के प्रति उत्तरदायी (ब्रिटेन, भारत) · अध्यक्षीय → कार्यपालिका का निश्चित कार्यकाल (अमेरिका)","explanation":"दो मुख्य शासन-प्रणालियाँ"}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),
    (1171, 'graduation_arts', 'apol-comp-example', 'example', 3, 'उदाहरण',
     $j${"question":"अमेरिका में राष्ट्रपति का कार्यकाल निश्चित होता है। यह किस प्रकार की प्रणाली है?","solution":"कार्यकाल निश्चित होना अध्यक्षीय प्रणाली का लक्षण है।","answer":"अध्यक्षीय प्रणाली"}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),
    (1171, 'graduation_arts', 'apol-comp-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"भारत में कौन सी शासन-प्रणाली अपनाई गई है?","options":["अध्यक्षीय","संसदीय","राजतंत्र","सैन्य"],"answer":1,"explanation":"भारत में संसदीय प्रणाली है।"},{"q":"किस देश में अध्यक्षीय प्रणाली है?","options":["ब्रिटेन","भारत","अमेरिका","जापान"],"answer":2,"explanation":"अमेरिका में अध्यक्षीय प्रणाली है।"}]}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),

    (1172, 'graduation_arts', 'apol-ir-concept', 'concept', 1, 'अंतर्राष्ट्रीय संबंध सिद्धांत',
     $j${"text":"यथार्थवाद राज्यों को शक्ति-संघर्ष में प्रमुख मानता है और राष्ट्रीय हित पर बल देता है। उदारवाद सहयोग, अंतर्राष्ट्रीय संस्थाओं और परस्पर निर्भरता पर जोर देता है। रचनावाद पहचान, विचार और मानदंडों को अंतर्राष्ट्रीय राजनीति का आधार मानता है।","note":"यथार्थवाद = शक्ति; उदारवाद = सहयोग; रचनावाद = पहचान"}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),
    (1172, 'graduation_arts', 'apol-ir-formula', 'formula', 2, 'सिद्धांत और केंद्रीय विचार',
     $j${"formula":"यथार्थवाद → शक्ति व राष्ट्रीय हित · उदारवाद → सहयोग व संस्थाएँ · रचनावाद → पहचान व विचार","explanation":"तीन प्रमुख IR सिद्धांत"}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),
    (1172, 'graduation_arts', 'apol-ir-example', 'example', 3, 'उदाहरण',
     $j${"question":"जो सिद्धांत राज्यों के बीच सहयोग और अंतर्राष्ट्रीय संस्थाओं पर जोर देता है, वह कौन सा है?","solution":"यह उदारवाद है, जो सहयोग और संस्थाओं को महत्व देता है।","answer":"उदारवाद"}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard'),
    (1172, 'graduation_arts', 'apol-ir-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"राज्यों को शक्ति-संघर्ष में प्रमुख मानने वाला सिद्धांत?","options":["उदारवाद","यथार्थवाद","रचनावाद","मार्क्सवाद"],"answer":1,"explanation":"यथार्थवाद शक्ति-संघर्ष पर बल देता है।"},{"q":"पहचान और मानदंडों को आधार मानने वाला सिद्धांत?","options":["यथार्थवाद","उदारवाद","रचनावाद","व्यवहारवाद"],"answer":2,"explanation":"रचनावाद पहचान और मानदंडों पर आधारित है।"}]}$j$,
     'advanced-polity', array[]::text[], array[]::text[], 'hard')
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body, subject_tag, exam_tags, class_tags, difficulty)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false, s.exam_tags, s.class_tags, s.subject_tag, s.difficulty, md5(s.body::text)
from src s
on conflict do nothing;
