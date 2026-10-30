-- 0041 General Science notes, batch 1 (5 chapters x 9 atoms).
-- Chapters (explicit ids from mtb.topics where subject = general-science):
--   870 Measurement & Units (phy-measurement)
--   874 Gravitation (phy-gravitation)
--   875 Pressure & Fluids (phy-pressure)
--   876 Heat & Thermodynamics (phy-heat)
--   877 Waves (phy-waves)
-- Per chapter: 4 govt_technical + 4 govt_basic + 1 shared svg (level_id null).
-- Metadata: exam_tags = real exam slugs from mtb.exams for the level ('{}' for shared),
-- subject_tag = 'general-science', difficulty = 'medium', content_hash = md5(body::text).
-- Idempotent: on conflict do nothing.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  -- 870 Measurement & Units
  (870,'govt_technical','meas-concept','concept',1,'माप और SI मात्रक — SSC JE / RRB JE',$j${"note":"JE में मूल राशियों की संख्या (7) और उपसर्ग अक्सर पूछे जाते हैं।","text":"SI की 7 मूल राशियाँ: लंबाई (m), द्रव्यमान (kg), समय (s), विद्युत धारा (A), ताप (K), पदार्थ की मात्रा (mol), ज्योति तीव्रता (cd)। उपसर्ग: किलो = 10³, मिली = 10⁻³, नैनो = 10⁻⁹।"}$j$),
  (870,'govt_technical','meas-formula','formula',2,'विमीय सूत्र',$j${"formula":"[v] = [LT⁻¹]","explanation":"v = वेग (m/s), L = लंबाई, T = समय · बल: [MLT⁻²], ऊर्जा: [ML²T⁻²]"}$j$),
  (870,'govt_technical','meas-example','example',3,'Numerical (JE style)',$j${"question":"72 km/h को m/s में बदलो।","solution":"72 × 5/18 = 20 m/s","answer":"20 m/s"}$j$),
  (870,'govt_technical','meas-mcq','mcq',4,'JE MCQs',$j${"questions":[{"q":"SI की मूल राशि कौन सी नहीं है?","options":["लंबाई","द्रव्यमान","बल","समय"],"answer":2,"explanation":"बल व्युत्पन्न राशि है (F = ma), मूल राशि नहीं।"},{"q":"1 nm = ? m","options":["10⁻⁹","10⁻⁶","10⁻³","10⁹"],"answer":0,"explanation":"नैनो = 10⁻⁹।"}]}$j$),
  (870,'govt_basic','meas-concept','concept',1,'माप की इकाइयाँ',$j${"note":"परीक्षा में मीटर, किलोग्राम, सेकंड मूल मात्रक पूछे जाते हैं।","text":"किसी चीज़ को नापने के लिए मानक इकाई चाहिए। दुनिया भर में SI पद्धति चलती है: लंबाई का मात्रक मीटर, द्रव्यमान का किलोग्राम और समय का सेकंड।"}$j$),
  (870,'govt_basic','meas-formula','formula',2,'इकाई परिवर्तन',$j${"formula":"1 km = 1000 m","explanation":"1 मीटर = 100 सेमी · 1 किलोग्राम = 1000 ग्राम"}$j$),
  (870,'govt_basic','meas-example','example',3,'उदाहरण',$j${"question":"5 km कितने मीटर होते हैं?","solution":"5 × 1000 = 5000 m","answer":"5000 m"}$j$),
  (870,'govt_basic','meas-mcq','mcq',4,'अभ्यास प्रश्न',$j${"questions":[{"q":"समय का SI मात्रक क्या है?","options":["मिनट","सेकंड","घंटा","दिन"],"answer":1,"explanation":"समय का SI मात्रक सेकंड (s) है।"},{"q":"द्रव्यमान का SI मात्रक क्या है?","options":["ग्राम","किलोग्राम","टन","पाउंड"],"answer":1,"explanation":"द्रव्यमान का SI मात्रक किलोग्राम (kg) है।"}]}$j$),
  (870,null,'meas-diagram','svg',5,'मीटर पैमाना',$j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='20' y='50' width='260' height='30' fill='#f59e0b' opacity='0.6' rx='3'/><line x1='20' y1='50' x2='20' y2='90' stroke='#0f172a' stroke-width='2'/><line x1='280' y1='50' x2='280' y2='90' stroke='#0f172a' stroke-width='2'/><text x='150' y='115' text-anchor='middle' fill='#64748b' font-size='11'>मीटर पैमाना (SI लंबाई)</text></svg>","caption":"लंबाई का SI मात्रक मीटर है"}$j$),
  -- 874 Gravitation
  (874,'govt_technical','grav-concept','concept',1,'गुरुत्वाकर्षण — SSC JE / RRB JE',$j${"note":"JE में G का मात्रक और g का सूत्र अक्सर पूछा जाता है।","text":"हर दो द्रव्यमानों के बीच आकर्षण बल लगता है (न्यूटन का गुरुत्वाकर्षण नियम)। G = 6.67 × 10⁻¹¹ N·m²/kg²। पृथ्वी की सतह पर g = GM/R²।"}$j$),
  (874,'govt_technical','grav-formula','formula',2,'गुरुत्वाकर्षण बल',$j${"formula":"F = G·m₁·m₂ / r²","explanation":"F = बल (N), G = 6.67×10⁻¹¹ N·m²/kg², m₁, m₂ = द्रव्यमान (kg), r = दूरी (m)"}$j$),
  (874,'govt_technical','grav-example','example',3,'Numerical (JE style)',$j${"question":"g = GM/R² से पृथ्वी पर g निकालो। M = 6×10²⁴ kg, R = 6.4×10⁶ m, G = 6.67×10⁻¹¹ लें।","solution":"g = 6.67×10⁻¹¹ × 6×10²⁴ / (6.4×10⁶)² ≈ 9.8 m/s²","answer":"लगभग 9.8 m/s²"}$j$),
  (874,'govt_technical','grav-mcq','mcq',4,'JE MCQs',$j${"questions":[{"q":"पृथ्वी के लिए पलायन वेग (escape velocity) लगभग कितना है?","options":["11.2 km/s","7.9 km/s","3 km/s","30 km/s"],"answer":0,"explanation":"पृथ्वी का पलायन वेग लगभग 11.2 km/s है।"},{"q":"G का मात्रक क्या है?","options":["N·m²/kg²","N/kg","kg/m³","J/s"],"answer":0,"explanation":"G का SI मात्रक N·m²/kg² है।"}]}$j$),
  (874,'govt_basic','grav-concept','concept',1,'गुरुत्वाकर्षण',$j${"note":"भार का मात्रक न्यूटन है, द्रव्यमान का किलोग्राम।","text":"पृथ्वी हर वस्तु को अपनी ओर खींचती है, इसे गुरुत्व कहते हैं। वस्तु का भार = द्रव्यमान × g। पृथ्वी पर g ≈ 9.8 m/s²।"}$j$),
  (874,'govt_basic','grav-formula','formula',2,'भार का सूत्र',$j${"formula":"W = m × g","explanation":"W = भार (N), m = द्रव्यमान (kg), g = गुरुत्वीय त्वरण (9.8 m/s²)"}$j$),
  (874,'govt_basic','grav-example','example',3,'उदाहरण',$j${"question":"10 kg द्रव्यमान का भार पृथ्वी पर कितना होगा? (g = 10 लें)","solution":"W = 10 × 10 = 100 N","answer":"100 N"}$j$),
  (874,'govt_basic','grav-mcq','mcq',4,'अभ्यास प्रश्न',$j${"questions":[{"q":"पृथ्वी पर g का लगभग मान क्या है?","options":["9.8 m/s²","98 m/s²","0.98 m/s²","10 km/s²"],"answer":0,"explanation":"पृथ्वी की सतह पर g ≈ 9.8 m/s²।"},{"q":"भार का SI मात्रक क्या है?","options":["किलोग्राम","न्यूटन","जूल","वाट"],"answer":1,"explanation":"भार बल है, इसलिए उसका मात्रक न्यूटन (N) है।"}]}$j$),
  (874,null,'grav-diagram','svg',5,'गुरुत्व आकर्षण',$j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><circle cx='70' cy='60' r='25' fill='#60a5fa'/><circle cx='230' cy='60' r='25' fill='#14b8a6'/><line x1='100' y1='60' x2='140' y2='60' stroke='#f59e0b' stroke-width='3'/><polygon points='100,60 108,55 108,65' fill='#f59e0b'/><line x1='200' y1='60' x2='160' y2='60' stroke='#f59e0b' stroke-width='3'/><polygon points='200,60 192,55 192,65' fill='#f59e0b'/><text x='150' y='110' text-anchor='middle' fill='#64748b' font-size='11'>F ∝ m₁m₂ / r²</text></svg>","caption":"दो द्रव्यमान एक-दूसरे को आकर्षित करते हैं"}$j$),
  -- 875 Pressure & Fluids
  (875,'govt_technical','pres-concept','concept',1,'दाब और उछाल — SSC JE / RRB JE',$j${"note":"JE में Pa मात्रक और आर्किमिडीज़ सिद्धांत अक्सर पूछे जाते हैं।","text":"दाब p = F/A (Pa)। द्रव में गहराई h पर दाब p = hρg। आर्किमिडीज़ का सिद्धांत: डूबी वस्तु पर ऊपर की ओर उछाल बल = विस्थापित द्रव का भार।"}$j$),
  (875,'govt_technical','pres-formula','formula',2,'दाब का सूत्र',$j${"formula":"p = F / A","explanation":"p = दाब (Pa), F = लंबवत बल (N), A = क्षेत्रफल (m²) · 1 atm ≈ 1.013×10⁵ Pa"}$j$),
  (875,'govt_technical','pres-example','example',3,'Numerical (JE style)',$j${"question":"10 N बल 0.5 m² क्षेत्रफल पर लगता है। दाब कितना है?","solution":"p = 10 / 0.5 = 20 Pa","answer":"20 Pa"}$j$),
  (875,'govt_technical','pres-mcq','mcq',4,'JE MCQs',$j${"questions":[{"q":"1 atm दाब लगभग कितने Pa है?","options":["1.013×10⁵","10³","10⁹","9.8"],"answer":0,"explanation":"1 atm ≈ 1.013×10⁵ Pa।"},{"q":"उछाल बल किसके बराबर होता है?","options":["विस्थापित द्रव का भार","वस्तु का भार","वस्तु का आयतन","द्रव का घनत्व"],"answer":0,"explanation":"आर्किमिडीज़ के सिद्धांत के अनुसार उछाल बल = विस्थापित द्रव का भार।"}]}$j$),
  (875,'govt_basic','pres-concept','concept',1,'दाब और उछाल',$j${"note":"परीक्षा में दाब का सूत्र और उछाल का सिद्धांत पूछे जाते हैं।","text":"किसी सतह के प्रति इकाई क्षेत्रफल पर लगने वाला बल दाब है। पानी में गहराई बढ़ने पर दाब बढ़ता है। पानी में डूबी वस्तु हल्की लगती है, क्योंकि ऊपर की ओर उछाल बल लगता है।"}$j$),
  (875,'govt_basic','pres-formula','formula',2,'दाब का सूत्र',$j${"formula":"p = F / A","explanation":"p = दाब (N/m²), F = बल (N), A = क्षेत्रफल (m²)"}$j$),
  (875,'govt_basic','pres-example','example',3,'उदाहरण',$j${"question":"100 N बल 2 m² क्षेत्रफल पर लगे तो दाब कितना होगा?","solution":"p = 100 / 2 = 50 N/m²","answer":"50 N/m²"}$j$),
  (875,'govt_basic','pres-mcq','mcq',4,'अभ्यास प्रश्न',$j${"questions":[{"q":"दाब का SI मात्रक क्या है?","options":["Pascal","Joule","Newton","Watt"],"answer":0,"explanation":"दाब का SI मात्रक Pascal (Pa) है।"},{"q":"पानी में गहराई बढ़ने पर दाब कैसे बदलता है?","options":["बढ़ता है","घटता है","वही रहता है","शून्य हो जाता है"],"answer":0,"explanation":"गहराई बढ़ने पर द्रव का दाब बढ़ता है।"}]}$j$),
  (875,null,'pres-diagram','svg',5,'गहराई के साथ दाब',$j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='80' y='15' width='140' height='95' fill='#60a5fa' fill-opacity='0.25' stroke='#60a5fa' stroke-width='2'/><text x='150' y='112' text-anchor='middle' fill='#64748b' font-size='11'>गहराई बढ़ने पर दाब बढ़ता है</text></svg>","caption":"पानी की टंकी में गहराई के साथ दाब बढ़ता है"}$j$),
  -- 876 Heat & Thermodynamics
  (876,'govt_technical','heat-concept','concept',1,'ऊष्मा और ताप — SSC JE / RRB JE',$j${"note":"JE में ऊष्मा संचरण के तीन तरीके और K = °C + 273 अक्सर पूछे जाते हैं।","text":"ऊष्मा ऊर्जा का एक रूप है (मात्रक J), और ताप बताता है कि वस्तु कितनी गर्म है (मात्रक °C या K)। ऊष्मा तीन तरीकों से चलती है: चालन, संवहन और विकिरण।"}$j$),
  (876,'govt_technical','heat-formula','formula',2,'ऊष्मा का सूत्र',$j${"formula":"Q = m × c × ΔT","explanation":"Q = ऊष्मा (J), m = द्रव्यमान (kg), c = विशिष्ट ऊष्मा (J/kg·°C), ΔT = ताप परिवर्तन · पानी का c ≈ 4186 J/kg·°C"}$j$),
  (876,'govt_technical','heat-example','example',3,'Numerical (JE style)',$j${"question":"2 kg पानी का ताप 10°C से 30°C करने में कितनी ऊष्मा लगेगी? (c = 4186 J/kg·°C)","solution":"Q = 2 × 4186 × 20 = 167440 J","answer":"लगभग 1.67×10⁵ J"}$j$),
  (876,'govt_technical','heat-mcq','mcq',4,'JE MCQs',$j${"questions":[{"q":"पानी की विशिष्ट ऊष्मा का लगभग मान क्या है?","options":["4186 J/kg°C","100 J/kg°C","1000 J/kg°C","22 J/kg°C"],"answer":0,"explanation":"पानी की विशिष्ट ऊष्मा लगभग 4186 J/kg°C है।"},{"q":"ऊष्मा का कौन सा संचरण माध्यम के बिना होता है?","options":["विकिरण","चालन","संवहन","कोई नहीं"],"answer":0,"explanation":"विकिरण में ऊष्मा बिना माध्यम के चलती है, जैसे सूर्य से पृथ्वी तक।"}]}$j$),
  (876,'govt_basic','heat-concept','concept',1,'ऊष्मा और ताप',$j${"note":"परीक्षा में ऊष्मा संचरण के तीन तरीके पूछे जाते हैं।","text":"ऊष्मा ऊर्जा है और ताप बताता है कि वस्तु कितनी गर्म है। ऊष्मा तीन तरीकों से जाती है: चालन (ठोस में), संवहन (द्रव और गैस में) और विकिरण (बिना माध्यम के)।"}$j$),
  (876,'govt_basic','heat-formula','formula',2,'केल्विन और सेल्सियस',$j${"formula":"K = °C + 273","explanation":"K = केल्विन, °C = सेल्सियस · पानी का क्वथनांक 100°C = 373 K"}$j$),
  (876,'govt_basic','heat-example','example',3,'उदाहरण',$j${"question":"27°C को केल्विन में बदलो।","solution":"27 + 273 = 300 K","answer":"300 K"}$j$),
  (876,'govt_basic','heat-mcq','mcq',4,'अभ्यास प्रश्न',$j${"questions":[{"q":"सूर्य की ऊष्मा पृथ्वी तक किस तरीके से आती है?","options":["विकिरण","चालन","संवहन","इनमें से कोई नहीं"],"answer":0,"explanation":"सूर्य की ऊष्मा विकिरण से शून्य माध्यम में होकर पृथ्वी तक पहुँचती है।"},{"q":"ताप का SI मात्रक क्या है?","options":["केल्विन","सेल्सियस","जूल","वाट"],"answer":0,"explanation":"ताप का SI मात्रक केल्विन (K) है।"}]}$j$),
  (876,null,'heat-diagram','svg',5,'ऊष्मा का प्रवाह',$j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><circle cx='40' cy='60' r='22' fill='#f59e0b'/><path d='M 80 40 Q 100 60 80 80' fill='none' stroke='#f59e0b' stroke-width='3'/><path d='M 110 40 Q 130 60 110 80' fill='none' stroke='#f59e0b' stroke-width='3'/><rect x='170' y='40' width='100' height='40' fill='#60a5fa' opacity='0.5' rx='4'/><text x='220' y='115' text-anchor='middle' fill='#64748b' font-size='11'>ऊष्मा विकिरण और चालन से</text></svg>","caption":"ऊष्मा विभिन्न तरीकों से एक जगह से दूसरी जगह जाती है"}$j$),
  -- 877 Waves
  (877,'govt_technical','wave-concept','concept',1,'तरंगें — SSC JE / RRB JE',$j${"note":"JE में v = fλ और तरंग के प्रकार अक्सर पूछे जाते हैं।","text":"तरंग में ऊर्जा आगे जाती है, माध्यम के कण अपनी जगह पर दोलन करते हैं। अनुप्रस्थ तरंग (प्रकाश, जल की सतह) और अनुदैर्ध्य तरंग (ध्वनि) होती हैं।"}$j$),
  (877,'govt_technical','wave-formula','formula',2,'तरंग-वेग',$j${"formula":"v = f × λ","explanation":"v = तरंग-वेग (m/s), f = आवृत्ति (Hz), λ = तरंगदैर्घ्य (m) · आवर्त काल T = 1/f"}$j$),
  (877,'govt_technical','wave-example','example',3,'Numerical (JE style)',$j${"question":"500 Hz आवृत्ति और 0.66 m तरंगदैर्घ्य वाली ध्वनि का वेग कितना है?","solution":"v = 500 × 0.66 = 330 m/s","answer":"330 m/s"}$j$),
  (877,'govt_technical','wave-mcq','mcq',4,'JE MCQs',$j${"questions":[{"q":"ध्वनि किस प्रकार की तरंग है?","options":["अनुदैर्ध्य","अनुप्रस्थ","विद्युत-चुंबकीय","स्थिर"],"answer":0,"explanation":"ध्वनि अनुदैर्ध्य तरंग है, माध्यम के कण तरंग की दिशा में दोलन करते हैं।"},{"q":"50 Hz आवृत्ति का आवर्त काल कितना है?","options":["0.02 s","0.5 s","50 s","2 s"],"answer":0,"explanation":"T = 1/f = 1/50 = 0.02 s।"}]}$j$),
  (877,'govt_basic','wave-concept','concept',1,'तरंगें',$j${"note":"परीक्षा में तरंग का सूत्र और आवृत्ति का मात्रक पूछे जाते हैं।","text":"पानी की लहरें और ध्वनि तरंगें उदाहरण हैं। तरंग में ऊर्जा चलती है, पदार्थ नहीं। आवृत्ति = एक सेकंड में कंपन की संख्या (Hz)।"}$j$),
  (877,'govt_basic','wave-formula','formula',2,'तरंग का सूत्र',$j${"formula":"v = f × λ","explanation":"v = वेग (m/s), f = आवृत्ति (Hz), λ = तरंगदैर्घ्य (m)"}$j$),
  (877,'govt_basic','wave-example','example',3,'उदाहरण',$j${"question":"आवृत्ति 10 Hz और तरंगदैर्घ्य 2 m हो तो तरंग का वेग कितना है?","solution":"v = 10 × 2 = 20 m/s","answer":"20 m/s"}$j$),
  (877,'govt_basic','wave-mcq','mcq',4,'अभ्यास प्रश्न',$j${"questions":[{"q":"आवृत्ति का मात्रक क्या है?","options":["Hertz","Pascal","Joule","Ohm"],"answer":0,"explanation":"आवृत्ति का SI मात्रक Hertz (Hz) है।"},{"q":"प्रकाश किस प्रकार की तरंग है?","options":["अनुप्रस्थ","अनुदैर्ध्य","स्थिर","इनमें से कोई नहीं"],"answer":0,"explanation":"प्रकाश अनुप्रस्थ तरंग है।"}]}$j$),
  (877,null,'wave-diagram','svg',5,'तरंग का आकार',$j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><path d='M 20 60 Q 45 20 70 60 T 120 60 T 170 60 T 220 60 T 270 60' fill='none' stroke='#14b8a6' stroke-width='3'/><line x1='20' y1='60' x2='270' y2='60' stroke='#64748b' stroke-dasharray='4,3'/><text x='150' y='112' text-anchor='middle' fill='#64748b' font-size='11'>λ = तरंगदैर्घ्य</text></svg>","caption":"तरंग का एक पूर्ण चक्र तरंगदैर्घ्य के बराबर होता है"}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi',
  case
    when s.level_id = 'govt_technical' then array['rrb-je-cbt1','rrb-je-cbt2','ssc-je-paper1']::text[]
    when s.level_id = 'govt_basic' then array['rrb-ntpc-graduate-cbt-1','rrb-ntpc-graduate-cbt-2','rrb-ntpc-ug-cbt-1','rrb-ntpc-ug-cbt-2']::text[]
    else '{}'::text[]
  end,
  'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
