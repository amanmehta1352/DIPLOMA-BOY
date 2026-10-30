-- Migration 0113: fill govt_technical gaps — civil-engineering chapters 403–412 (10 chapters x 4 atoms)
-- Exam: SSC JE / RRB JE. Subject: civil-engineering (exists in DB, subject_id 5).
with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    (403, 'govt_technical', 'env-gt-concept', 'concept', 1, 'पर्यावरण इंजीनियरिंग — SSC JE / RRB JE',
     $j${"text":"पानी की गुणवत्ता नापने के लिए pH, turbidity (गंदलापन), BOD और COD देखे जाते हैं। पीने के पानी का pH 6.5 से 8.5 के बीच होना चाहिए (BIS)। सीवेज ट्रीटमेंट तीन चरणों में होता है: प्राथमिक (screening, sedimentation), द्वितीयक (biological, activated sludge), और तृतीयक (advanced treatment)।","note":"पीने का पानी pH 6.5–8.5 · BOD = biological oxygen demand"}$j$),
    (403, 'govt_technical', 'env-gt-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"Detention time (h) = Volume (m³) ÷ Flow rate (m³/h)","explanation":"Sedimentation tank में पानी जितनी देर रुके, उसे detention time कहते हैं। Sludge digestion से मुख्यतः methane गैस निकलती है।"}$j$),
    (403, 'govt_technical', 'env-gt-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"Tank का volume 1200 m³ और flow 300 m³/h है। Detention time कितना?","solution":"1200 ÷ 300 = 4","answer":"4 hours"}$j$),
    (403, 'govt_technical', 'env-gt-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"पीने के पानी का BIS desirable pH?","options":["4.5–5.5","6.5–8.5","9–10","10–12"],"answer":1,"explanation":"6.5 से 8.5 के बीच pH"},{"q":"Sludge digestion से मुख्यतः कौन सी गैस निकलती है?","options":["CO₂","Methane","Nitrogen","Oxygen"],"answer":1,"explanation":"Methane (biogas)"}]}$j$),

    (404, 'govt_technical', 'est-gt-concept', 'concept', 1, 'अनुमान और लागत — SSC JE / RRB JE',
     $j${"text":"Estimating का मतलब है किसी काम की मात्रा (quantity) निकालना, फिर उस पर rate लगाकर लागत निकालना। Approximate estimate जल्दी बनता है, detailed estimate में हर item की मात्रा अलग से नापी जाती है। Earthwork, brickwork और concrete की मात्रा सबसे ज़्यादा पूछी जाती है।","note":"लागत = मात्रा × दर (rate)"}$j$),
    (404, 'govt_technical', 'est-gt-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"Brickwork volume = लंबाई × चौड़ाई × ऊँचाई · 1 m³ brick masonry में लगभग 500 ईंटें","explanation":"लागत = Quantity × Rate · ईंट का standard size 190×90×90 mm (mortar के साथ 200×100×100 mm)"}$j$),
    (404, 'govt_technical', 'est-gt-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"10 m लंबी, 0.3 m मोटी और 3 m ऊँची दीवार में लगभग कितनी ईंटें?","solution":"Volume = 10 × 0.3 × 3 = 9 m³ · ईंटें = 9 × 500 = 4500","answer":"लगभग 4500 ईंटें"}$j$),
    (404, 'govt_technical', 'est-gt-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"1 m³ brick masonry में लगभग कितनी ईंटें?","options":["400","500","600","700"],"answer":1,"explanation":"लगभग 500 ईंटें प्रति घन मीटर"},{"q":"Cost estimate का सूत्र?","options":["Quantity × Rate","Quantity + Rate","Quantity ÷ Rate","Rate − Quantity"],"answer":0,"explanation":"Cost = Quantity × Rate"}]}$j$),

    (405, 'govt_technical', 'fld-gt-concept', 'concept', 1, 'द्रव यांत्रिकी — SSC JE / RRB JE',
     $j${"text":"द्रव (fluid) में दाब गहराई के साथ बढ़ता है। Viscosity (श्यानता) द्रव का चिपचिपापन है। Flow दो तरह का होता है: laminar (सुचारू) और turbulent (अस्त-व्यस्त)। Reynolds number से flow का प्रकार तय होता है। Continuity equation बताती है कि pipe में flow की मात्रा स्थिर रहती है।","note":"Re < 2000 = laminar · Re > 4000 = turbulent"}$j$),
    (405, 'govt_technical', 'fld-gt-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"p = ρgh · Re = ρvD/μ · Q = A·v","explanation":"ρ = घनत्व, g = गुरुत्वीय त्वरण, h = गहराई, μ = dynamic viscosity"}$j$),
    (405, 'govt_technical', 'fld-gt-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"5 m गहरे पानी में दाब कितना? (ρ = 1000 kg/m³, g = 9.8 m/s²)","solution":"p = 1000 × 9.8 × 5 = 49000 Pa","answer":"49 kPa"}$j$),
    (405, 'govt_technical', 'fld-gt-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"Reynolds number 2000 से कम हो तो flow कैसा?","options":["Turbulent","Laminar","Transition","Sonic"],"answer":1,"explanation":"Re < 2000 पर laminar flow"},{"q":"Continuity equation कौन सी है?","options":["A₁V₁ = A₂V₂","P₁ = P₂","F = ma","E = mc²"],"answer":0,"explanation":"A₁V₁ = A₂V₂ (mass conservation)"}]}$j$),

    (406, 'govt_technical', 'irr-gt-concept', 'concept', 1, 'सिंचाई और जल-विज्ञान — SSC JE / RRB JE',
     $j${"text":"सिंचाई के मुख्य तरीके: flood (बाढ़), furrow (कुंड), basin, sprinkler (फुहारा) और drip (बूँद-बूँद)। Drip सबसे efficient है, क्योंकि पानी सीधे जड़ तक पहुँचता है। Hydrology चक्र में वर्षा, वाष्पीकरण और बहाव (runoff) आते हैं। Rainfall नापने का यूनिट mm है।","note":"Drip = सबसे efficient · Rainfall = mm में"}$j$),
    (406, 'govt_technical', 'irr-gt-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"Delta Δ (m) = 8.64 × B ÷ D","explanation":"B = base period (days), D = duty (हेक्टेयर/cumec)"}$j$),
    (406, 'govt_technical', 'irr-gt-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"Duty = 1000 हेक्टेयर/cumec और base period = 120 दिन। Delta कितना?","solution":"Δ = 8.64 × 120 ÷ 1000 = 1.0368","answer":"≈ 1.04 m"}$j$),
    (406, 'govt_technical', 'irr-gt-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"सबसे efficient irrigation method?","options":["Flood","Furrow","Drip","Basin"],"answer":2,"explanation":"Drip (बूँद-बूँद) irrigation"},{"q":"Rainfall किस इकाई में नापते हैं?","options":["mm","kg","m/s","°C"],"answer":0,"explanation":"mm (millimetre)"}]}$j$),

    (407, 'govt_technical', 'rcc-gt-concept', 'concept', 1, 'RCC डिज़ाइन — SSC JE / RRB JE',
     $j${"text":"RCC (Reinforced Cement Concrete) में concrete दबाव (compression) सहता है और steel तनाव (tension) सहता है। Concrete grade M का मतलब mix है, और संख्या 28-दिन की characteristic strength (N/mm²) है। Limit state method में भार को factor से बढ़ाकर design किया जाता है।","note":"Concrete compression · Steel tension"}$j$),
    (407, 'govt_technical', 'rcc-gt-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"Factored load = 1.5 × Service load (DL + LL के लिए, IS 456)","explanation":"Steel grade Fe500 का yield strength = 500 N/mm²"}$j$),
    (407, 'govt_technical', 'rcc-gt-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"Service load 40 kN/m है। Factored load कितना?","solution":"1.5 × 40 = 60","answer":"60 kN/m"}$j$),
    (407, 'govt_technical', 'rcc-gt-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"Steel grade Fe500 का yield strength?","options":["415 N/mm²","500 N/mm²","550 N/mm²","250 N/mm²"],"answer":1,"explanation":"Fe500 = 500 N/mm²"},{"q":"M25 concrete की 28-day characteristic strength?","options":["20 N/mm²","25 N/mm²","30 N/mm²","15 N/mm²"],"answer":1,"explanation":"M25 = 25 N/mm²"}]}$j$),

    (408, 'govt_technical', 'soil-gt-concept', 'concept', 1, 'मृदा यांत्रिकी — SSC JE / RRB JE',
     $j${"text":"मिट्टी के मुख्य प्रकार: gravel (बजरी), sand (रेत), silt (गाद), clay (चिकनी मिट्टी)। Void ratio और porosity से मिट्टी में खाली जगह का पता चलता है। Atterberg limits (liquid limit, plastic limit) मिट्टी की चिपचिपाहट बताती हैं। Permeability Darcy's law से नापी जाती है।","note":"Plasticity index = LL − PL"}$j$),
    (408, 'govt_technical', 'soil-gt-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"Darcy: Q = k·i·A · Porosity n = e ÷ (1 + e)","explanation":"k = permeability (m/s), i = hydraulic gradient, e = void ratio"}$j$),
    (408, 'govt_technical', 'soil-gt-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"Void ratio e = 0.6 है। Porosity कितनी?","solution":"n = 0.6 ÷ (1 + 0.6) = 0.6 ÷ 1.6 = 0.375","answer":"0.375 (37.5%)"}$j$),
    (408, 'govt_technical', 'soil-gt-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"Darcy's law में permeability k का unit?","options":["m/s","m²","kg","N"],"answer":0,"explanation":"k का unit m/s"},{"q":"Plasticity index का सूत्र?","options":["LL − PL","LL + PL","PL − SL","LL ÷ PL"],"answer":0,"explanation":"PI = LL − PL"}]}$j$),

    (409, 'govt_technical', 'stl-gt-concept', 'concept', 1, 'Steel संरचना — SSC JE / RRB JE',
     $j${"text":"Structural steel के लिए IS 800 code लागू होता है। Rolled sections में I-section, channel और angle आते हैं। Steel members को bolts, rivets या welding से जोड़ा जाता है। Column में buckling (झुकाव) एक बड़ी समस्या है, जो slenderness ratio से तय होती है।","note":"IS 800 = steel structures · Slenderness λ = L/r"}$j$),
    (409, 'govt_technical', 'stl-gt-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"Slenderness ratio λ = L ÷ r · Stress σ = P ÷ A · Euler: P = π²EI ÷ L²","explanation":"E = steel का elastic modulus, I = moment of inertia, L = effective length"}$j$),
    (409, 'govt_technical', 'stl-gt-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"Column की लंबाई L = 3 m और radius of gyration r = 30 mm है। Slenderness ratio?","solution":"λ = 3000 ÷ 30 = 100","answer":"100"}$j$),
    (409, 'govt_technical', 'stl-gt-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"Structural steel के लिए IS code?","options":["IS 456","IS 800","IS 1343","IS 383"],"answer":1,"explanation":"IS 800 (steel)"},{"q":"Steel का approx. modulus of elasticity?","options":["2×10⁵ MPa","2×10³ MPa","2×10⁸ MPa","2×10² MPa"],"answer":0,"explanation":"E ≈ 2×10⁵ MPa (200 GPa)"}]}$j$),

    (410, 'govt_technical', 'som-gt-concept', 'concept', 1, 'सामग्री की मज़बूती — SSC JE / RRB JE',
     $j${"text":"Stress (प्रतिबल) = बल ÷ क्षेत्रफल। Strain (विकृति) = बदलाव ÷ मूल लंबाई। Hooke's law के अनुसार elastic limit के भीतर stress, strain के अनुपात में होता है। इस अनुपात को Young's modulus (E) कहते हैं। Poisson ratio पार्श्व (lateral) विकृति बताता है।","note":"Stress = F/A · Strain = ΔL/L · E = σ/ε"}$j$),
    (410, 'govt_technical', 'som-gt-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"σ = P ÷ A · ε = ΔL ÷ L · E = σ ÷ ε","explanation":"Hooke's law: elastic limit के भीतर σ ∝ ε"}$j$),
    (410, 'govt_technical', 'som-gt-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"10 kN बल एक 100 mm² क्षेत्रफल पर लगा है। Stress कितना?","solution":"σ = 10000 N ÷ 100 mm² = 100 N/mm²","answer":"100 N/mm² (MPa)"}$j$),
    (410, 'govt_technical', 'som-gt-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"Steel का Young's modulus लगभग?","options":["200 GPa","70 GPa","100 MPa","2 GPa"],"answer":0,"explanation":"Steel ≈ 200 GPa"},{"q":"Steel का Poisson ratio लगभग?","options":["0.3","1.5","0.9","−1"],"answer":0,"explanation":"≈ 0.3"}]}$j$),

    (411, 'govt_technical', 'surv-gt-concept', 'concept', 1, 'सर्वेक्षण — SSC JE / RRB JE',
     $j${"text":"Surveying में chain surveying, compass surveying, levelling और theodolite आते हैं। Principle: काम पूरे से हिस्से की ओर होता है। Levelling में Bench Mark (BM) की reduced level (RL) से शुरू करते हैं। Back sight (BS) और foresight (FS) से height of instrument (HI) निकलता है।","note":"BS = Back Sight · FS = Fore Sight · HI = RL + BS"}$j$),
    (411, 'govt_technical', 'surv-gt-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"HI = RL + BS · RL (point) = HI − FS","explanation":"Levelling में instrument की ऊँचाई (HI) से reduced level निकाला जाता है"}$j$),
    (411, 'govt_technical', 'surv-gt-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"BM की RL = 100.00 m, BS = 1.20 m, FS = 0.80 m है। Point की RL?","solution":"HI = 100.00 + 1.20 = 101.20 · RL = 101.20 − 0.80 = 100.40","answer":"100.40 m"}$j$),
    (411, 'govt_technical', 'surv-gt-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"Levelling में BS का full form?","options":["Back Sight","Bottom Sight","Base Station","Ball Staff"],"answer":0,"explanation":"Back Sight (BS)"},{"q":"Metric chain की लंबाई?","options":["10 m","20 m","30 m","66 ft"],"answer":1,"explanation":"Metric chain = 20 m"}]}$j$),

    (412, 'govt_technical', 'tr-gt-concept', 'concept', 1, 'सड़क इंजीनियरिंग — SSC JE / RRB JE',
     $j${"text":"Flexible pavement की layers ऊपर से नीचे: wearing course (सबसे ऊपर), base course, sub-base, फिर subgrade। सड़क के बीच में camber (ढलान) दिया जाता है ताकि पानी बह जाए। Bituminous सड़क पर camber लगभग 2% होता है। Curve पर superelevation (e) दिया जाता है।","note":"Wearing course = सबसे ऊपर · Bituminous camber ≈ 2%"}$j$),
    (412, 'govt_technical', 'tr-gt-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"Superelevation e = v² ÷ (127 × R)","explanation":"v = speed (km/h), R = radius of curve (m)"}$j$),
    (412, 'govt_technical', 'tr-gt-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"Speed 40 km/h और curve radius 300 m है। Superelevation कितना?","solution":"e = 40² ÷ (127 × 300) = 1600 ÷ 38100 ≈ 0.042","answer":"≈ 4.2%"}$j$),
    (412, 'govt_technical', 'tr-gt-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"Flexible pavement की सबसे ऊपरी layer?","options":["Subgrade","Wearing course","Sub-base","Base"],"answer":1,"explanation":"Wearing course सबसे ऊपर"},{"q":"Bituminous सड़क पर camber लगभग?","options":["2%","0%","10%","25%"],"answer":0,"explanation":"लगभग 2%"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  array['rrb-je-cbt2','ssc-je-paper1']::text[], '{}'::text[], 'civil-engineering', 'medium',
  md5(s.body::text)
from src s
on conflict do nothing;
