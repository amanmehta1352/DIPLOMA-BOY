-- Migration 0144: graduation_sci general-science physics 882-884 (3 x 4 = 12 atoms)
with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body, v.subject_tag, v.exam_tags, v.class_tags, v.difficulty
  from (values
    (882, 'graduation_sci', 'gsci-modphy-concept', 'concept', 1, 'आधुनिक भौतिकी और रेडियोधर्मिता',
     $j${"text":"रेडियोधर्मिता वह प्रक्रिया है जिसमें अस्थिर नाभिक स्वतः α (अल्फा), β (बीटा) या γ (गामा) विकिरण उत्सर्जित करके स्थायी होता है। α कण हीलियम नाभिक हैं, β इलेक्ट्रॉन या पॉज़िट्रॉन हैं, और γ उच्च-ऊर्जा विद्युतचुंबकीय तरंग है। अर्ध-आयु वह समय है जिसमें नमूने की आधी मात्रा क्षय हो जाती है।","note":"γ उत्सर्जन में द्रव्यमान संख्या और परमाणु क्रमांक नहीं बदलते"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (882, 'graduation_sci', 'gsci-modphy-formula', 'formula', 2, 'क्षय नियम',
     $j${"formula":"N = N₀ · (1/2)^(t/T) · (T = अर्ध-आयु) · α-क्षय: ΔA = −4, ΔZ = −2 · β⁻-क्षय: ΔZ = +1, ΔA = 0","explanation":"रेडियोधर्मी क्षय का मूल नियम और विस्थापन नियम"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (882, 'graduation_sci', 'gsci-modphy-example', 'example', 3, 'उदाहरण',
     $j${"question":"एक रेडियोधर्मी पदार्थ की अर्ध-आयु 10 दिन है। 40 दिन बाद कितना अंश शेष रहेगा?","solution":"t/T = 40/10 = 4। N = N₀ × (1/2)⁴ = N₀/16। अतः 1/16 अंश शेष रहेगा।","answer":"1/16 (लगभग 6.25%)"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (882, 'graduation_sci', 'gsci-modphy-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"α-कण किसके नाभिक के समान है?","options":["हाइड्रोजन","हीलियम","ऑक्सीजन","नाइट्रोजन"],"answer":1,"explanation":"α-कण हीलियम नाभिक (He²⁺) है।"},{"q":"γ-विकिरण की प्रकृति क्या है?","options":["इलेक्ट्रॉन","प्रोटॉन","विद्युतचुंबकीय तरंग","न्यूट्रॉन"],"answer":2,"explanation":"γ-विकिरण उच्च-ऊर्जा विद्युतचुंबकीय तरंग है।"}]}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),

    (883, 'graduation_sci', 'gsci-machines-concept', 'concept', 1, 'सरल मशीनें',
     $j${"text":"सरल मशीन बल की दिशा या परिमाण बदलकर कार्य आसान करती है। लीवर (उत्तोलक), घिरनी, आनत तल, पेंच और पहिया-धुरी इसके उदाहरण हैं। यांत्रिक लाभ (MA) = भार / प्रयुक्त बल। मशीन ऊर्जा नहीं बनाती, केवल उसका रूपांतरण या सुविधा देती है।","note":"आदर्श मशीन में दक्षता 100% होती है; वास्तविक मशीन में घर्षण के कारण कम"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (883, 'graduation_sci', 'gsci-machines-formula', 'formula', 2, 'मशीन के सूत्र',
     $j${"formula":"यांत्रिक लाभ MA = भार (L) / प्रयुक्त बल (E) · वेग अनुपात VR = दूरी (बल द्वारा) / दूरी (भार द्वारा) · दक्षता η = (MA / VR) × 100%","explanation":"सरल मशीन के मुख्य राशि-संबंध"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (883, 'graduation_sci', 'gsci-machines-example', 'example', 3, 'उदाहरण',
     $j${"question":"एक लीवर से 500 N का भार 100 N के बल से उठाया जाता है। यांत्रिक लाभ क्या है?","solution":"MA = भार / प्रयुक्त बल = 500 / 100 = 5","answer":"5"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (883, 'graduation_sci', 'gsci-machines-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"सरल मशीन का मुख्य कार्य क्या है?","options":["ऊर्जा बनाना","कार्य आसान करना","द्रव्यमान बढ़ाना","तापमान बढ़ाना"],"answer":1,"explanation":"सरल मशीन बल की दिशा या परिमाण बदलकर कार्य आसान करती है।"},{"q":"आदर्श मशीन की दक्षता कितनी होती है?","options":["50%","75%","100%","0%"],"answer":2,"explanation":"आदर्श मशीन में दक्षता 100% होती है।"}]}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),

    (884, 'graduation_sci', 'gsci-phys-other-concept', 'concept', 1, 'भौतिकी: मूल मात्राएँ और मात्रक',
     $j${"text":"भौतिकी में मूल राशियाँ लंबाई, द्रव्यमान, समय, ताप, विद्युत धारा, ज्योति-तीव्रता और पदार्थ की मात्रा हैं। SI पद्धति इनके मानक मात्रक देती है: मीटर, किलोग्राम, सेकंड, केल्विन, एम्पियर, कैंडेला और मोल। अदिश राशि केवल परिमाण से और सदिश राशि परिमाण व दिशा दोनों से पहचानी जाती है।","note":"वेग और बल सदिश हैं; चाल और द्रव्यमान अदिश हैं"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (884, 'graduation_sci', 'gsci-phys-other-formula', 'formula', 2, 'मूल सूत्र',
     $j${"formula":"वेग v = दूरी / समय · त्वरण a = (v − u) / t · बल F = m × a · कार्य W = F × s · शक्ति P = W / t","explanation":"भौतिकी के आधारभूत सूत्र"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (884, 'graduation_sci', 'gsci-phys-other-example', 'example', 3, 'उदाहरण',
     $j${"question":"5 kg द्रव्यमान की वस्तु पर 20 N बल लगता है। उसका त्वरण क्या होगा?","solution":"F = m × a → a = F / m = 20 / 5 = 4 m/s²","answer":"4 m/s²"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (884, 'graduation_sci', 'gsci-phys-other-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"इनमें से कौन सी राशि सदिश है?","options":["चाल","द्रव्यमान","वेग","समय"],"answer":2,"explanation":"वेग सदिश राशि है, क्योंकि उसकी दिशा होती है।"},{"q":"SI पद्धति में बल का मात्रक क्या है?","options":["जूल","न्यूटन","वॉट","पास्कल"],"answer":1,"explanation":"SI में बल का मात्रक न्यूटन (N) है।"}]}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard')
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body, subject_tag, exam_tags, class_tags, difficulty)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false, s.exam_tags, s.class_tags, s.subject_tag, s.difficulty, md5(s.body::text)
from src s
on conflict do nothing;
