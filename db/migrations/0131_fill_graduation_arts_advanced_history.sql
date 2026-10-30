-- Migration 0131: graduation_arts advanced-history chapters 1163-1167 (5 x 4 = 20 atoms)
with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body, v.subject_tag, v.exam_tags, v.class_tags, v.difficulty
  from (values
    (1163, 'graduation_arts', 'ahist-hist-concept', 'concept', 1, 'इतिहास-लेखन (Historiography)',
     $j${"text":"इतिहास-लेखन यह अध्ययन करता है कि इतिहासकार अतीत को कैसे लिखते और व्याख्या करते हैं। प्राथमिक स्रोत (मूल दस्तावेज़, अभिलेख, सिक्के) और द्वितीयक स्रोत (किसी और की लिखी पुस्तकें) में अंतर करना आवश्यक है। रांके ने वस्तुनिष्ठ इतिहास-लेखन पर बल दिया।","note":"रांके = वस्तुनिष्ठ स्रोत-आधारित इतिहास"}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),
    (1163, 'graduation_arts', 'ahist-hist-formula', 'formula', 2, 'स्रोतों के प्रकार',
     $j${"formula":"प्राथमिक स्रोत = समकालीन मूल सामग्री · द्वितीयक स्रोत = बाद में लिखे गए विवरण · पुरातात्विक स्रोत = उत्खनन की वस्तुएँ","explanation":"स्रोत-वर्गीकरण का आधार"}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),
    (1163, 'graduation_arts', 'ahist-hist-example', 'example', 3, 'उदाहरण',
     $j${"question":"अशोक का शिलालेख किस प्रकार का स्रोत है?","solution":"यह समकालीन मूल अभिलेख है, इसलिए प्राथमिक स्रोत है।","answer":"प्राथमिक स्रोत"}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),
    (1163, 'graduation_arts', 'ahist-hist-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"वस्तुनिष्ठ इतिहास-लेखन पर बल किसने दिया?","options":["रांके","मार्क्स","गांधी","टॉयनबी"],"answer":0,"explanation":"रांके ने स्रोत-आधारित वस्तुनिष्ठ इतिहास पर बल दिया।"},{"q":"समकालीन मूल अभिलेख कौन सा स्रोत है?","options":["द्वितीयक","प्राथमिक","काल्पनिक","पाठ्यपुस्तक"],"answer":1,"explanation":"समकालीन मूल अभिलेख प्राथमिक स्रोत होता है।"}]}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),

    (1164, 'graduation_arts', 'ahist-anc-concept', 'concept', 1, 'प्राचीन सभ्यताएँ',
     $j${"text":"प्राचीन सभ्यताएँ मेसोपोटामिया, मिस्र, सिंधु घाटी और चीन में नदी-घाटियों के किनारे विकसित हुईं। नगर, लेखन, व्यापार और राज्य-व्यवस्था इनकी पहचान हैं। सिंधु सभ्यता नगर-नियोजन के लिए विशेष जानी जाती है।","note":"नदी घाटी सभ्यताएँ: दजला-फ़रात, नील, सिंधु, पीली नदी"}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),
    (1164, 'graduation_arts', 'ahist-anc-formula', 'formula', 2, 'नदी-घाटी सभ्यताएँ',
     $j${"formula":"मेसोपोटामिया (दजला-फ़रात) · मिस्र (नील) · सिंधु (सिंधु नदी) · चीन (पीली नदी)","explanation":"सभ्यता और उसकी नदी"}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),
    (1164, 'graduation_arts', 'ahist-anc-example', 'example', 3, 'उदाहरण',
     $j${"question":"मिस्र की सभ्यता किस नदी के किनारे विकसित हुई?","solution":"मिस्र की सभ्यता नील नदी के किनारे विकसित हुई।","answer":"नील नदी"}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),
    (1164, 'graduation_arts', 'ahist-anc-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"मेसोपोटामिया की सभ्यता किन नदियों के बीच विकसित हुई?","options":["नील और सिंधु","दजला और फ़रात","गंगा और यमुना","पीली और यांग्त्ज़े"],"answer":1,"explanation":"मेसोपोटामिया दजला और फ़रात नदियों के बीच है।"},{"q":"पीली नदी किस सभ्यता से जुड़ी है?","options":["मिस्र","चीन","मेसोपोटामिया","सिंधु"],"answer":1,"explanation":"पीली नदी चीनी सभ्यता से जुड़ी है।"}]}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),

    (1165, 'graduation_arts', 'ahist-med-concept', 'concept', 1, 'मध्यकालीन राज्य और समाज',
     $j${"text":"मध्यकाल में यूरोप में सामंतवाद प्रचलित था, जिसमें भूमि के बदले सेवा का संबंध था। भारत में दिल्ली सल्तनत और मुग़ल काल में इक्ता और जागीर व्यवस्था प्रचलित थी। इक्ता प्रणाली में अधिकारियों को राजस्व वसूलने का अधिकार दिया जाता था।","note":"इक्ता = राजस्व वसूली का अधिकार; जागीर = भूमि-आधारित वेतन"}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),
    (1165, 'graduation_arts', 'ahist-med-formula', 'formula', 2, 'भूमि-व्यवस्थाएँ',
     $j${"formula":"यूरोप: सामंतवाद (भूमि ↔ सेवा) · भारत: इक्ता (राजस्व अधिकार) · मुग़ल: मनसबदारी व जागीर","explanation":"मध्यकालीन भूमि-संबंधों के रूप"}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),
    (1165, 'graduation_arts', 'ahist-med-example', 'example', 3, 'उदाहरण',
     $j${"question":"इक्ता व्यवस्था में अधिकारी को किस बात का अधिकार मिलता था?","solution":"इक्ता में अधिकारी को एक क्षेत्र से राजस्व वसूलने का अधिकार मिलता था।","answer":"राजस्व वसूलने का अधिकार"}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),
    (1165, 'graduation_arts', 'ahist-med-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"यूरोप में भूमि के बदले सेवा का संबंध किस व्यवस्था से जुड़ा है?","options":["इक्ता","सामंतवाद","मनसबदारी","रैयतवाड़ी"],"answer":1,"explanation":"सामंतवाद में भूमि के बदले सेवा का संबंध होता था।"},{"q":"मुग़ल काल में मनसब किससे जुड़ा था?","options":["व्यापार","सैन्य और प्रशासनिक पद","कृषि कर","मुद्रा"],"answer":1,"explanation":"मनसब सैन्य और प्रशासनिक पद का दर्जा था।"}]}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),

    (1166, 'graduation_arts', 'ahist-mod-concept', 'concept', 1, 'स्वतंत्रता के बाद का भारत (1947 से)',
     $j${"text":"1947 के बाद भारत ने विभाजन की त्रासदी, रियासतों का विलय, संविधान निर्माण और लोकतांत्रिक ढाँचा स्थापित किया। नेहरू के काल में औद्योगीकरण और योजनाबद्ध विकास पर बल रहा। 1975–77 का आपातकाल लोकतांत्रिक इतिहास का महत्वपूर्ण अध्याय है।","note":"सरदार पटेल ने रियासतों के विलय में प्रमुख भूमिका निभाई"}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),
    (1166, 'graduation_arts', 'ahist-mod-formula', 'formula', 2, 'प्रमुख घटनाएँ',
     $j${"formula":"विभाजन और स्वतंत्रता: 1947 · गणतंत्र: 1950 · आपातकाल: 1975–77 · उदारीकरण: 1991","explanation":"स्वतंत्र भारत के मुख्य मोड़"}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),
    (1166, 'graduation_arts', 'ahist-mod-example', 'example', 3, 'उदाहरण',
     $j${"question":"भारत में रियासतों के विलय में सबसे अधिक भूमिका किसकी मानी जाती है?","solution":"रियासतों के विलय में सरदार पटेल की प्रमुख भूमिका मानी जाती है।","answer":"सरदार वल्लभभाई पटेल"}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),
    (1166, 'graduation_arts', 'ahist-mod-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"आपातकाल किस अवधि में लगा था?","options":["1962–64","1971–72","1975–77","1984–85"],"answer":2,"explanation":"आपातकाल 1975 से 1977 तक लगा।"},{"q":"भारत में उदारीकरण की शुरुआत किस वर्ष मानी जाती है?","options":["1947","1966","1991","2000"],"answer":2,"explanation":"उदारीकरण की शुरुआत 1991 में मानी जाती है।"}]}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),

    (1167, 'graduation_arts', 'ahist-world-concept', 'concept', 1, '20वीं सदी का विश्व इतिहास',
     $j${"text":"20वीं सदी में दो विश्व युद्ध, रूसी क्रांति (1917), महामंदी (1929), उपनिवेशवाद का अंत और शीत युद्ध प्रमुख घटनाएँ रहीं। संयुक्त राष्ट्र (1945) की स्थापना युद्धों के बाद शांति के लिए हुई। एशिया और अफ़्रीका में स्वतंत्रता आंदोलन इसी सदी में सफल हुए।","note":"दो ध्रुव: अमेरिका और सोवियत संघ (शीत युद्ध)"}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),
    (1167, 'graduation_arts', 'ahist-world-formula', 'formula', 2, 'प्रमुख वर्ष',
     $j${"formula":"रूसी क्रांति: 1917 · महामंदी: 1929 · संयुक्त राष्ट्र: 1945 · बर्लिन दीवार का गिरना: 1989","explanation":"20वीं सदी के प्रमुख मोड़"}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),
    (1167, 'graduation_arts', 'ahist-world-example', 'example', 3, 'उदाहरण',
     $j${"question":"शीत युद्ध के दो प्रमुख ध्रुव कौन थे?","solution":"शीत युद्ध में अमेरिका और सोवियत संघ दो प्रमुख ध्रुव थे।","answer":"अमेरिका और सोवियत संघ"}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard'),
    (1167, 'graduation_arts', 'ahist-world-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"रूसी क्रांति किस वर्ष हुई?","options":["1905","1917","1929","1945"],"answer":1,"explanation":"रूसी क्रांति 1917 में हुई।"},{"q":"महामंदी किस वर्ष शुरू हुई?","options":["1914","1929","1939","1945"],"answer":1,"explanation":"महामंदी 1929 में शुरू हुई।"}]}$j$,
     'advanced-history', array[]::text[], array[]::text[], 'hard')
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body, subject_tag, exam_tags, class_tags, difficulty)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false, s.exam_tags, s.class_tags, s.subject_tag, s.difficulty, md5(s.body::text)
from src s
on conflict do nothing;
