-- Migration 0115: fill remaining applicable gaps
--  - 416 current-affairs for govt_basic, govt_defence, state_psc, upsc_civil (4 x 4 = 16)
--  - class_9_10: 883 phy-machines, 899 chem-lab (2 x 4 = 8)
-- Total 24 atoms. Subjects: general-awareness (416), general-science (883, 899).
with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body, v.subject_tag, v.exam_tags, v.class_tags, v.difficulty
  from (values
    (416, 'govt_basic', 'ca-gb-concept', 'concept', 1, 'करंट अफेयर्स — RRB NTPC / SSC',
     $j${"text":"Current affairs में पिछले लगभग 6 से 12 महीने की महत्वपूर्ण घटनाएँ आती हैं: सरकारी योजनाएँ, खेल, पुरस्कार और नियुक्तियाँ। NTPC और SSC परीक्षाओं में GA के हिस्से से सीधे सवाल आते हैं। मासिक सारांश से पढ़ें और तारीख व व्यक्ति के नाम याद रखें।","note":"पिछले 6–12 महीने · मासिक सारांश"}$j$,
     'general-awareness', array['rrb-ntpc-graduate-cbt-1','rrb-ntpc-ug-cbt-1']::text[], '{}'::text[], 'medium'),
    (416, 'govt_basic', 'ca-gb-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"तैयारी = मासिक सारांश × तारीख व नाम की सूची × revision","explanation":"Static GK के साथ current affairs को जोड़कर पढ़ें"}$j$,
     'general-awareness', array['rrb-ntpc-graduate-cbt-1','rrb-ntpc-ug-cbt-1']::text[], '{}'::text[], 'medium'),
    (416, 'govt_basic', 'ca-gb-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"भारत ने G20 की अध्यक्षता किस वर्ष की?","solution":"भारत ने G20 की अध्यक्षता वर्ष 2023 में की","answer":"2023"}$j$,
     'general-awareness', array['rrb-ntpc-graduate-cbt-1','rrb-ntpc-ug-cbt-1']::text[], '{}'::text[], 'medium'),
    (416, 'govt_basic', 'ca-gb-mcq', 'mcq', 4, 'GA MCQs',
     $j${"questions":[{"q":"भारत की सबसे लंबी नदी (भारत में बहने वाली) कौन सी है?","options":["Ganga","Godavari","Brahmaputra","Yamuna"],"answer":0,"explanation":"गंगा"},{"q":"भारत ने G20 की अध्यक्षता किस वर्ष की?","options":["2019","2021","2023","2025"],"answer":2,"explanation":"2023"}]}$j$,
     'general-awareness', array['rrb-ntpc-graduate-cbt-1','rrb-ntpc-ug-cbt-1']::text[], '{}'::text[], 'medium'),

    (416, 'govt_defence', 'ca-gd-concept', 'concept', 1, 'करंट अफेयर्स — NDA / CDS',
     $j${"text":"NDA और CDS में current affairs के सवाल रक्षा (defence), अंतरराष्ट्रीय संबंध और सरकारी नीतियों से जुड़े होते हैं। पिछले 6–12 महीने की रक्षा खरीद, सैन्य अभ्यास और समझौते पढ़ें। सही तारीख और उद्देश्य याद रखें।","note":"रक्षा + अंतरराष्ट्रीय संबंध + नीतियाँ"}$j$,
     'general-awareness', array[]::text[], '{}'::text[], 'hard'),
    (416, 'govt_defence', 'ca-gd-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"तैयारी = रक्षा समाचार × मासिक सारांश × revision","explanation":"Defence और international relations को साथ पढ़ें"}$j$,
     'general-awareness', array[]::text[], '{}'::text[], 'hard'),
    (416, 'govt_defence', 'ca-gd-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"भारत ने G20 की अध्यक्षता किस वर्ष की?","solution":"भारत ने G20 की अध्यक्षता वर्ष 2023 में की","answer":"2023"}$j$,
     'general-awareness', array[]::text[], '{}'::text[], 'hard'),
    (416, 'govt_defence', 'ca-gd-mcq', 'mcq', 4, 'Defence GA MCQs',
     $j${"questions":[{"q":"भारत की सबसे लंबी नदी (भारत में बहने वाली) कौन सी है?","options":["Ganga","Godavari","Brahmaputra","Yamuna"],"answer":0,"explanation":"गंगा"},{"q":"भारत ने G20 की अध्यक्षता किस वर्ष की?","options":["2019","2021","2023","2025"],"answer":2,"explanation":"2023"}]}$j$,
     'general-awareness', array[]::text[], '{}'::text[], 'hard'),

    (416, 'state_psc', 'ca-psc-concept', 'concept', 1, 'करंट अफेयर्स — State PSC',
     $j${"text":"State PSC में current affairs के सवाल राज्य की नीतियों, योजनाओं, नियुक्तियों और राष्ट्रीय घटनाओं से आते हैं। पिछले 6–12 महीने के राज्य-स्तरीय समाचार (जैसे UP या Bihar की योजनाएँ) मुख्य रूप से पढ़ें। हिंदी स्रोत उपयोगी हैं।","note":"राज्य की योजनाएँ + राष्ट्रीय घटनाएँ"}$j$,
     'general-awareness', array[]::text[], '{}'::text[], 'hard'),
    (416, 'state_psc', 'ca-psc-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"तैयारी = राज्य योजनाएँ + राष्ट्रीय घटनाएँ + मासिक सारांश","explanation":"State-level और national दोनों तरह के सवाल आते हैं"}$j$,
     'general-awareness', array[]::text[], '{}'::text[], 'hard'),
    (416, 'state_psc', 'ca-psc-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"भारत ने G20 की अध्यक्षता किस वर्ष की?","solution":"भारत ने G20 की अध्यक्षता वर्ष 2023 में की","answer":"2023"}$j$,
     'general-awareness', array[]::text[], '{}'::text[], 'hard'),
    (416, 'state_psc', 'ca-psc-mcq', 'mcq', 4, 'PSC GA MCQs',
     $j${"questions":[{"q":"भारत की सबसे लंबी नदी (भारत में बहने वाली) कौन सी है?","options":["Ganga","Godavari","Brahmaputra","Yamuna"],"answer":0,"explanation":"गंगा"},{"q":"भारत ने G20 की अध्यक्षता किस वर्ष की?","options":["2019","2021","2023","2025"],"answer":2,"explanation":"2023"}]}$j$,
     'general-awareness', array[]::text[], '{}'::text[], 'hard'),

    (416, 'upsc_civil', 'ca-upsc-concept', 'concept', 1, 'करंट अफेयर्स — UPSC CSE',
     $j${"text":"UPSC में current affairs सिर्फ तथ्य नहीं, नीति (policy) और विश्लेषण के लिए पढ़े जाते हैं। पिछले 12 महीने की योजनाएँ, अंतरराष्ट्रीय समझौते, संवैधानिक घटनाएँ और सामाजिक मुद्दे समझें। हर घटना का कारण, प्रभाव और सरकारी प्रतिक्रिया सोचें।","note":"तथ्य + नीति + विश्लेषण (कारण, प्रभाव, प्रतिक्रिया)"}$j$,
     'general-awareness', array[]::text[], '{}'::text[], 'hard'),
    (416, 'upsc_civil', 'ca-upsc-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"हर घटना = कारण → प्रभाव → सरकारी/नीतिगत प्रतिक्रिया","explanation":"पिछले 12 महीने का मासिक सारांश + नीति-विश्लेषण नोट्स"}$j$,
     'general-awareness', array[]::text[], '{}'::text[], 'hard'),
    (416, 'upsc_civil', 'ca-upsc-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"भारत ने G20 की अध्यक्षता किस वर्ष की?","solution":"भारत ने G20 की अध्यक्षता वर्ष 2023 में की","answer":"2023"}$j$,
     'general-awareness', array[]::text[], '{}'::text[], 'hard'),
    (416, 'upsc_civil', 'ca-upsc-mcq', 'mcq', 4, 'UPSC GA MCQs',
     $j${"questions":[{"q":"भारत की सबसे लंबी नदी (भारत में बहने वाली) कौन सी है?","options":["Ganga","Godavari","Brahmaputra","Yamuna"],"answer":0,"explanation":"गंगा"},{"q":"भारत ने G20 की अध्यक्षता किस वर्ष की?","options":["2019","2021","2023","2025"],"answer":2,"explanation":"2023"}]}$j$,
     'general-awareness', array[]::text[], '{}'::text[], 'hard'),

    (883, 'class_9_10', 'sm-c910-concept', 'concept', 1, 'सरल मशीनें — Class 9-10',
     $j${"text":"सरल मशीन (simple machine) बल को आसान बनाती है। लीवर, पुली, झुका तल (inclined plane) इसके उदाहरण हैं। Mechanical advantage (MA) = Load ÷ Effort। Efficiency कितनी है यह बताता है कि इनपुट कार्य का कितना हिस्सा उपयोगी काम में बदला।","note":"MA = Load ÷ Effort · Efficiency = MA ÷ VR × 100%"}$j$,
     'general-science', array[]::text[], array['class_9','class_10']::text[], 'medium'),
    (883, 'class_9_10', 'sm-c910-formula', 'formula', 2, 'मुख्य सूत्र',
     $j${"formula":"MA = Load ÷ Effort · VR = Effort distance ÷ Load distance · η = MA ÷ VR × 100%","explanation":"Inclined plane में VR = 1 ÷ sinθ"}$j$,
     'general-science', array[]::text[], array['class_9','class_10']::text[], 'medium'),
    (883, 'class_9_10', 'sm-c910-example', 'example', 3, 'Board numerical',
     $j${"question":"500 N का load उठाने के लिए 100 N का effort लगाया। MA कितना?","solution":"MA = Load ÷ Effort = 500 ÷ 100 = 5","answer":"5"}$j$,
     'general-science', array[]::text[], array['class_9','class_10']::text[], 'medium'),
    (883, 'class_9_10', 'sm-c910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Mechanical advantage का सूत्र?","options":["Load ÷ Effort","Effort ÷ Load","Load × Effort","Load + Effort"],"answer":0,"explanation":"MA = Load ÷ Effort"},{"q":"Inclined plane की VR (θ = angle) क्या है?","options":["1 ÷ sinθ","sinθ","cosθ","tanθ"],"answer":0,"explanation":"VR = length ÷ height = 1 ÷ sinθ"}]}$j$,
     'general-science', array[]::text[], array['class_9','class_10']::text[], 'medium'),

    (899, 'class_9_10', 'lab-c910-concept', 'concept', 1, 'रसायन प्रयोगशाला — Class 9-10',
     $j${"text":"प्रयोगशाला में सुरक्षा सबसे ज़रूरी है: चश्मा और दस्ताने पहनें, रसायन को सूँघें नहीं, और एसिड में पानी नहीं मिलाएँ (हमेशा एसिड को पानी में धीरे-धीरे मिलाएँ)। लिटमस पेपर से acid और base की पहचान होती है: acid लाल लिटमस को लाल ही रखता है, base लाल को नीला करता है।","note":"एसिड को पानी में मिलाएँ, पानी को एसिड में नहीं"}$j$,
     'general-science', array[]::text[], array['class_9','class_10']::text[], 'medium'),
    (899, 'class_9_10', 'lab-c910-formula', 'formula', 2, 'मुख्य सूत्र',
     $j${"formula":"Molarity M = moles of solute ÷ volume of solution (L)","explanation":"Molarity का unit mol/L (M)"}$j$,
     'general-science', array[]::text[], array['class_9','class_10']::text[], 'medium'),
    (899, 'class_9_10', 'lab-c910-example', 'example', 3, 'Board numerical',
     $j${"question":"0.5 mol solute को 2 L solution में घोला। Molarity कितनी?","solution":"M = 0.5 ÷ 2 = 0.25","answer":"0.25 M"}$j$,
     'general-science', array[]::text[], array['class_9','class_10']::text[], 'medium'),
    (899, 'class_9_10', 'lab-c910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Acid में लाल लिटमस का रंग?","options":["Blue","Red","Green","Yellow"],"answer":1,"explanation":"Acid में लाल लिटमस लाल ही रहता है"},{"q":"Molarity का unit?","options":["mol/L","g/mol","kg","J"],"answer":0,"explanation":"mol/L"}]}$j$,
     'general-science', array[]::text[], array['class_9','class_10']::text[], 'medium')
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body, subject_tag, exam_tags, class_tags, difficulty)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  s.exam_tags, s.class_tags, s.subject_tag, s.difficulty,
  md5(s.body::text)
from src s
on conflict do nothing;
