-- Migration 0138: graduation_sci general-science chemistry
-- 889 (add missing formula atom, 3 -> 4), 890-892 (4 x 4 = 12 atoms). Total 13 atoms.
with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body, v.subject_tag, v.exam_tags, v.class_tags, v.difficulty
  from (values
    (889, 'graduation_sci', 'gsci-rxn-formula', 'formula', 4, 'रासायनिक समीकरण का संतुलन',
     $j${"formula":"संतुलित समीकरण: द्रव्यमान का संरक्षण — अभिकारकों के परमाणुओं की संख्या = उत्पादों के परमाणुओं की संख्या · 2H₂ + O₂ → 2H₂O","explanation":"समीकरण संतुलित करते समय केवल गुणांक बदलें, सूत्र नहीं"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),

    (890, 'graduation_sci', 'gsci-redox-concept', 'concept', 1, 'ऑक्सीकरण और अपचयन',
     $j${"text":"ऑक्सीकरण में पदार्थ ऑक्सीजन ग्रहण करता है या हाइड्रोजन खोता है, या इलेक्ट्रॉन खोता है। अपचयन में पदार्थ ऑक्सीजन खोता है या हाइड्रोजन/इलेक्ट्रॉन ग्रहण करता है। ये दोनों प्रक्रियाएँ साथ-साथ होती हैं, इसलिए इन्हें रेडॉक्स अभिक्रिया कहते हैं।","note":"OIL RIG: Oxidation Is Loss, Reduction Is Gain (इलेक्ट्रॉन के लिए)"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (890, 'graduation_sci', 'gsci-redox-formula', 'formula', 2, 'ऑक्सीकरण संख्या',
     $j${"formula":"ऑक्सीकरण संख्या में वृद्धि = ऑक्सीकरण · कमी = अपचयन · मुक्त तत्व की ऑक्सीकरण संख्या = 0 · O का सामान्य मान −2, H का +1","explanation":"ऑक्सीकरण संख्या से अभिक्रिया की पहचान"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (890, 'graduation_sci', 'gsci-redox-example', 'example', 3, 'उदाहरण',
     $j${"question":"अभिक्रिया 2Mg + O₂ → 2MgO में मैग्नीशियम का ऑक्सीकरण होता है या अपचयन?","solution":"Mg की ऑक्सीकरण संख्या 0 से बढ़कर +2 हो जाती है, इसलिए Mg का ऑक्सीकरण होता है।","answer":"ऑक्सीकरण"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (890, 'graduation_sci', 'gsci-redox-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"ऑक्सीकरण में पदार्थ क्या खोता है?","options":["इलेक्ट्रॉन","ऑक्सीजन ग्रहण","प्रोटॉन ग्रहण","न्यूट्रॉन"],"answer":0,"explanation":"ऑक्सीकरण में इलेक्ट्रॉन खोए जाते हैं।"},{"q":"किसी मुक्त तत्व की ऑक्सीकरण संख्या कितनी होती है?","options":["+1","−1","0","+2"],"answer":2,"explanation":"मुक्त तत्व की ऑक्सीकरण संख्या शून्य होती है।"}]}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),

    (891, 'graduation_sci', 'gsci-acid-concept', 'concept', 1, 'अम्ल, क्षार और लवण',
     $j${"text":"अम्ल हाइड्रोजन आयन (H⁺) देते हैं और स्वाद में खट्टे होते हैं। क्षार हाइड्रॉक्सिल आयन (OH⁻) देते हैं और स्वाद में कड़वे/फिसलन वाले होते हैं। अम्ल और क्षार की अभिक्रिया से लवण और जल बनते हैं, जिसे उदासीनीकरण कहते हैं।","note":"pH 7 उदासीन; 7 से कम अम्लीय; 7 से अधिक क्षारीय"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (891, 'graduation_sci', 'gsci-acid-formula', 'formula', 2, 'उदासीनीकरण अभिक्रिया',
     $j${"formula":"अम्ल + क्षार → लवण + जल · HCl + NaOH → NaCl + H₂O","explanation":"उदासीनीकरण का सामान्य रूप"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (891, 'graduation_sci', 'gsci-acid-example', 'example', 3, 'उदाहरण',
     $j${"question":"नींबू के रस (साइट्रिक अम्ल) के पास pH लगभग कितना होगा?","solution":"नींबू अम्लीय है, इसलिए इसका pH 7 से कम होता है, लगभग 2 से 3 के बीच।","answer":"7 से कम (लगभग 2–3)"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (891, 'graduation_sci', 'gsci-acid-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"अम्ल किस आयन को मुक्त करते हैं?","options":["OH⁻","H⁺","Na⁺","Cl⁻"],"answer":1,"explanation":"अम्ल जल में हाइड्रोजन आयन (H⁺) मुक्त करते हैं।"},{"q":"HCl + NaOH से कौन सा लवण बनता है?","options":["NaCl","NaOH","KCl","H₂SO₄"],"answer":0,"explanation":"HCl और NaOH की अभिक्रिया से NaCl (खाने का नमक) बनता है।"}]}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),

    (892, 'graduation_sci', 'gsci-metal-concept', 'concept', 1, 'धातु और अधातु',
     $j${"text":"धातुएँ चमकदार, आघातवर्ध्य (पीटकर पतली चादर बनाई जा सकती हैं) और तन्य (तार खींचे जा सकते हैं) होती हैं, और ऊष्मा व विद्युत की अच्छी चालक होती हैं। अधातुएँ सामान्यतः अचमकदार, भंगुर और कुचालक होती हैं।","note":"पारा (Hg) अपवाद: सामान्य तापमान पर द्रव धातु"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (892, 'graduation_sci', 'gsci-metal-formula', 'formula', 2, 'अभिक्रियाशीलता श्रेणी',
     $j${"formula":"K > Na > Ca > Mg > Al > Zn > Fe > Pb > H > Cu > Ag > Au","explanation":"ऊपर की धातु अधिक अभिक्रियाशील; ऊपर वाली धातु नीचे वाली धातु को लवण से विस्थापित करती है"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (892, 'graduation_sci', 'gsci-metal-example', 'example', 3, 'उदाहरण',
     $j${"question":"जिंक (Zn) कॉपर सल्फेट (CuSO₄) के विलयन से कॉपर को विस्थापित करेगा या नहीं?","solution":"Zn, Cu से अधिक अभिक्रियाशील है, इसलिए Zn, CuSO₄ से Cu को विस्थापित करेगा: Zn + CuSO₄ → ZnSO₄ + Cu।","answer":"हाँ"}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard'),
    (892, 'graduation_sci', 'gsci-metal-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"इनमें से कौन सी धातु सामान्य तापमान पर द्रव है?","options":["लोहा","पारा","एल्युमीनियम","सोडियम"],"answer":1,"explanation":"पारा (Hg) सामान्य तापमान पर द्रव धातु है।"},{"q":"कौन सा गुण धातुओं का नहीं है?","options":["आघातवर्ध्यता","तन्यता","भंगुरता","विद्युत चालकता"],"answer":2,"explanation":"भंगुरता सामान्यतः अधातुओं का गुण है।"}]}$j$,
     'general-science', array[]::text[], array[]::text[], 'hard')
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body, subject_tag, exam_tags, class_tags, difficulty)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false, s.exam_tags, s.class_tags, s.subject_tag, s.difficulty, md5(s.body::text)
from src s
on conflict do nothing;
