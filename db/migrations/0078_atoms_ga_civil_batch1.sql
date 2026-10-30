-- GA chapters 422, 38, 40 (9 atoms each)
-- Civil chapters 401, 402 (5 atoms each: 4 tech + 1 shared, NO basic)
-- Corrected before apply: (a) PPC curing period set to min 10 days (IS 456), (b) subject_tag and exam_tags mapped per chapter (GA 422 was tagged civil-engineering).

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ GA Ch 422: Static GK (9 atoms) ═══
    (422, 'govt_technical', 'sgk-concept', 'concept', 1, 'स्थिर सामान्य ज्ञान — SSC JE / RRB JE',
     $j${"text":"Static GK में देशों की राजधानी, मुद्रा, राष्ट्रीय चिह्न, महत्वपूर्ण दिवस, और पुस्तकें-लेखक आते हैं। राष्ट्रीय पक्षी = मोर, राष्ट्रीय पशु = बाघ, राष्ट्रीय फूल = कमल, राष्ट्रीय वृक्ष = बरगद, राष्ट्रीय खेल = हॉकी।","note":"JE/SSc में capitals, currencies, important days हर साल पूछे जाते हैं।"}$j$),
    (422, 'govt_technical', 'sgk-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"राष्ट्रीय: पक्षी=मोर, पशु=बाघ, फूल=कमल, वृक्ष=बरगद, खेल=हॉकी, गान=जन गण मन, गीत=वंदे मातरम्","explanation":"दिवस: 26 Jan=Republic, 15 Aug=Independence, 2 Oct=Gandhi Jayanti, 5 Sep=Teacher's Day, 14 Nov=Children's Day"}$j$),
    (422, 'govt_technical', 'sgk-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"UNO का headquarter कहाँ है?","solution":"United Nations Organization → New York, USA","answer":"New York"}$j$),
    (422, 'govt_technical', 'sgk-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"भारत का राष्ट्रीय पक्षी?","options":["कबूतर","मोर","तोता","बाज"],"answer":1,"explanation":"मोर (Peacock) = national bird"},{"q":"UNO का मुख्यालय?","options":["Paris","Geneva","New York","London"],"answer":2,"explanation":"New York, USA"}]}$j$),
    (422, 'govt_basic', 'sgk-concept', 'concept', 1, 'स्थिर सामान्य ज्ञान',
     $j${"text":"भारत के राष्ट्रीय प्रतीक: पक्षी-मोर, पशु-बाघ, फूल-कमल। महत्वपूर्ण दिवस: 26 जनवरी गणतंत्र दिवस, 15 अगस्त स्वतंत्रता दिवस, 2 अक्टूबर गांधी जयंती।","note":"प्रतीक और दिवस याद रखो"}$j$),
    (422, 'govt_basic', 'sgk-formula', 'formula', 2, 'राष्ट्रीय प्रतीक',
     $j${"formula":"पक्षी=मोर, पशु=बाघ, फूल=कमल, वृक्ष=बरगद","explanation":"26 Jan=Republic Day, 15 Aug=Independence Day"}$j$),
    (422, 'govt_basic', 'sgk-example', 'example', 3, 'उदाहरण',
     $j${"question":"भारत का राष्ट्रीय पशु?","solution":"Tiger","answer":"बाघ (Tiger)"}$j$),
    (422, 'govt_basic', 'sgk-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"भारत का राष्ट्रीय फूल?","options":["गुलाब","कमल","सूरजमुखी","चमेली"],"answer":1,"explanation":"कमल (Lotus)"},{"q":"गांधी जयंती कब?","options":["2 Jan","2 Oct","15 Aug","26 Jan"],"answer":1,"explanation":"2 October"}]}$j$),
    (422, null, 'sgk-diagram', 'svg', 5, 'राष्ट्रीय प्रतीक',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><text x='150' y='30' text-anchor='middle' fill='#f59e0b' font-size='13' font-weight='bold'>राष्ट्रीय प्रतीक</text><text x='50' y='65' fill='#60a5fa' font-size='11'>पक्षी: मोर</text><text x='50' y='85' fill='#14b8a6' font-size='11'>पशु: बाघ</text><text x='50' y='105' fill='#a78bfa' font-size='11'>फूल: कमल</text><text x='180' y='65' fill='#60a5fa' font-size='11'>वृक्ष: बरगद</text><text x='180' y='85' fill='#14b8a6' font-size='11'>खेल: हॉकी</text><text x='180' y='105' fill='#a78bfa' font-size='11'>गान: जन गण मन</text></svg>","caption":"भारत के राष्ट्रीय प्रतीक"}$j$),

    -- ═══ GA Ch 38: Art & Culture (9 atoms) ═══
    (38, 'govt_technical', 'cult-concept', 'concept', 1, 'कला-संस्कृति — SSC JE / RRB JE',
     $j${"text":"भारत के 8 शास्त्रीय नृत्य: भरतनाट्यम (तमिलनाडु), कथक (उत्तर प्रदेश), कथकली (केरल), कुचिपुड़ी (आंध्र), ओडिसी (ओडिशा), मणिपुरी (मणिपुर), मोहिनीअट्टम (केरल), सत्रीया (असम)। शास्त्रीय संगीत: हिंदुस्तानी (उत्तर), कर्नाटक (दक्षिण)।","note":"JE/SSc में dances, monuments, और festivals पूछे जाते हैं।"}$j$),
    (38, 'govt_technical', 'cult-formula', 'formula', 2, 'नृत्य और संगीत',
     $j${"formula":"8 classical dances: Bharatnatyam, Kathak, Kathakali, Kuchipudi, Odissi, Manipuri, Mohiniyattam, Sattriya","explanation":"Hindustani (North) vs Carnatic (South) · Monuments: Taj Mahal (Agra), Qutub Minar (Delhi), Konark (Odisha)"}$j$),
    (38, 'govt_technical', 'cult-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"कथकली किस राज्य का नृत्य है?","solution":"Kathakali → Kerala","answer":"केरल"}$j$),
    (38, 'govt_technical', 'cult-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"भरतनाट्यम किस राज्य से?","options":["Kerala","Tamil Nadu","Karnataka","Odisha"],"answer":1,"explanation":"Bharatnatyam → Tamil Nadu"},{"q":"कथक किस राज्य का?","options":["UP","Kerala","Tamil Nadu","Manipur"],"answer":0,"explanation":"Kathak → Uttar Pradesh"}]}$j$),
    (38, 'govt_basic', 'cult-concept', 'concept', 1, 'कला-संस्कृति',
     $j${"text":"भारत में 8 शास्त्रीय नृत्य हैं। भरतनाट्यम तमिलनाडु से, कथक उत्तर प्रदेश से, कथकली केरल से।","note":"राज्य और नृत्य का जोड़ी याद रखो"}$j$),
    (38, 'govt_basic', 'cult-formula', 'formula', 2, 'मुख्य नृत्य',
     $j${"formula":"Bharatnatyam-TN, Kathak-UP, Kathakali-Kerala, Odissi-Odisha","explanation":"8 classical dances कुल"}$j$),
    (38, 'govt_basic', 'cult-example', 'example', 3, 'उदाहरण',
     $j${"question":"कुचिपुड़ी किस राज्य से?","solution":"Andhra Pradesh","answer":"आंध्र प्रदेश"}$j$),
    (38, 'govt_basic', 'cult-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"कथकली किस राज्य से?","options":["TN","Kerala","UP","Odisha"],"answer":1,"explanation":"Kerala"},{"q":"ओडिसी किस राज्य से?","options":["Odisha","UP","Kerala","TN"],"answer":0,"explanation":"Odisha"}]}$j$),
    (38, null, 'cult-diagram', 'svg', 5, 'शास्त्रीय नृत्य',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><text x='150' y='25' text-anchor='middle' fill='#f59e0b' font-size='12' font-weight='bold'>8 Classical Dances</text><text x='50' y='55' fill='#60a5fa' font-size='10'>Bharatnatyam-TN</text><text x='50' y='75' fill='#14b8a6' font-size='10'>Kathak-UP</text><text x='50' y='95' fill='#a78bfa' font-size='10'>Kathakali-Kerala</text><text x='180' y='55' fill='#60a5fa' font-size='10'>Kuchipudi-AP</text><text x='180' y='75' fill='#14b8a6' font-size='10'>Odissi-Odisha</text><text x='180' y='95' fill='#a78bfa' font-size='10'>Manipuri-Manipur</text></svg>","caption":"8 शास्त्रीय नृत्य और राज्य"}$j$),

    -- ═══ GA Ch 40: Science & Technology (9 atoms) ═══
    (40, 'govt_technical', 'scitech-concept', 'concept', 1, 'विज्ञान-प्रौद्योगिकी — SSC JE / RRB JE',
     $j${"text":"आविष्कार और आविष्कारक: Telephone-Graham Bell, Light Bulb-Thomas Edison, Radio-Marconi, Aeroplane-Wright Brothers, Computer-Charles Babbage, Penicillin-Alexander Fleming, Polio Vaccine-Jonas Salk। विज्ञान की शाखाएँ: Physics, Chemistry, Biology, Geology, Astronomy।","note":"JE/SSc में inventors और branches पूछे जाते हैं।"}$j$),
    (40, 'govt_technical', 'scitech-formula', 'formula', 2, 'आविष्कार-आविष्कारक',
     $j${"formula":"Telephone=Bell · Bulb=Edison · Radio=Marconi · Computer=Babbage · Penicillin=Fleming","explanation":"SI units: Force=Newton, Energy=Joule, Power=Watt, Current=Ampere, Resistance=Ohm"}$j$),
    (40, 'govt_technical', 'scitech-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"Computer का आविष्कार किसने किया?","solution":"Charles Babbage (Father of Computer)","answer":"चार्ल्स बैबेज"}$j$),
    (40, 'govt_technical', 'scitech-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"Telephone का आविष्कार?","options":["Edison","Bell","Marconi","Tesla"],"answer":1,"explanation":"Alexander Graham Bell"},{"q":"Penicillin किसने खोजा?","options":["Fleming","Pasteur","Koch","Salk"],"answer":0,"explanation":"Alexander Fleming (1928)"}]}$j$),
    (40, 'govt_basic', 'scitech-concept', 'concept', 1, 'विज्ञान-प्रौद्योगिकी',
     $j${"text":"आविष्कारक: Telephone-Bell, Bulb-Edison, Computer-Babbage, Penicillin-Fleming, Aeroplane-Wright Brothers।","note":"आविष्कार और आविष्कारक का जोड़ा याद रखो"}$j$),
    (40, 'govt_basic', 'scitech-formula', 'formula', 2, 'मुख्य आविष्कार',
     $j${"formula":"Telephone=Bell · Bulb=Edison · Radio=Marconi","explanation":"Computer = Charles Babbage"}$j$),
    (40, 'govt_basic', 'scitech-example', 'example', 3, 'उदाहरण',
     $j${"question":"Bulb का आविष्कार किसने किया?","solution":"Thomas Edison","answer":"एडिसन"}$j$),
    (40, 'govt_basic', 'scitech-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"Computer का father?","options":["Gates","Babbage","Jobs","Turing"],"answer":1,"explanation":"Charles Babbage"},{"q":"Radio का आविष्कारक?","options":["Marconi","Bell","Edison","Tesla"],"answer":0,"explanation":"Marconi"}]}$j$),
    (40, null, 'scitech-diagram', 'svg', 5, 'आविष्कार-आविष्कारक',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><text x='150' y='25' text-anchor='middle' fill='#f59e0b' font-size='12' font-weight='bold'>Inventions</text><text x='50' y='55' fill='#60a5fa' font-size='10'>Telephone: Bell</text><text x='50' y='75' fill='#14b8a6' font-size='10'>Bulb: Edison</text><text x='50' y='95' fill='#a78bfa' font-size='10'>Radio: Marconi</text><text x='180' y='55' fill='#60a5fa' font-size='10'>Computer: Babbage</text><text x='180' y='75' fill='#14b8a6' font-size='10'>Penicillin: Fleming</text><text x='180' y='95' fill='#a78bfa' font-size='10'>Polio: Salk</text></svg>","caption":"आविष्कार और आविष्कारक"}$j$),

    -- ═══ CIVIL Ch 401: Building Materials (5 atoms: 4 tech + 1 shared) ═══
    (401, 'govt_technical', 'bm-concept', 'concept', 1, 'निर्माण सामग्री — SSC JE / RRB JE',
     $j${"text":"Building materials: Cement, Bricks, Steel, Timber, Stones, Concrete। Cement types: OPC (Ordinary Portland Cement) - सामान्य काम के लिए, PPC (Portland Pozzolana Cement) - जलरोधक काम के लिए, Rapid Hardening - जल्दी मजबूत होने के लिए। Bricks का standard size: 190×90×90 mm (with mortar 200×100×100)।","note":"JE में cement types, brick classes, steel grades पूछे जाते हैं।"}$j$),
    (401, 'govt_technical', 'bm-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"OPC: 33, 43, 53 grades · Brick: 190×90×90mm · Steel: Fe415, Fe500, Fe550","explanation":"Cement setting time: Initial 30 min, Final 600 min (10 hours)। Concrete grades: M15, M20, M25 (M = mix, number = 28-day strength in N/mm²)"}$j$),
    (401, 'govt_technical', 'bm-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"M25 concrete का 28-day strength?","solution":"M25 में M = mix, 25 = N/mm² strength after 28 days curing","answer":"25 N/mm²"}$j$),
    (401, 'govt_technical', 'bm-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"OPC का full form?","options":["Ordinary Portland Cement","Original Portland Cement","Open Portland Cement","Organic Portland Cement"],"answer":0,"explanation":"Ordinary Portland Cement"},{"q":"Standard brick size (with mortar)?","options":["190×90×90","200×100×100","225×110×75","230×110×75"],"answer":1,"explanation":"With mortar = 200×100×100 mm (actual = 190×90×90)"}]}$j$),
    (401, null, 'bm-diagram', 'svg', 5, 'Building materials',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='30' y='40' width='50' height='30' rx='4' fill='#60a5fa'/><text x='55' y='58' text-anchor='middle' fill='white' font-size='10'>Cement</text><rect x='90' y='40' width='50' height='30' rx='4' fill='#a78bfa'/><text x='115' y='58' text-anchor='middle' fill='white' font-size='10'>Brick</text><rect x='150' y='40' width='50' height='30' rx='4' fill='#14b8a6'/><text x='175' y='58' text-anchor='middle' fill='white' font-size='10'>Steel</text><rect x='210' y='40' width='60' height='30' rx='4' fill='#f59e0b'/><text x='240' y='58' text-anchor='middle' fill='white' font-size='10'>Timber</text><text x='150' y='95' text-anchor='middle' fill='#64748b' font-size='11'>4 मुख्य निर्माण सामग्री</text></svg>","caption":"Building materials: 4 types"}$j$),

    -- ═══ CIVIL Ch 402: Concrete Technology (5 atoms) ═══
    (402, 'govt_technical', 'conc-concept', 'concept', 1, 'कंक्रीट प्रौद्योगिकी — SSC JE / RRB JE',
     $j${"text":"Concrete = Cement + Sand (fine aggregate) + Gravel/Crushed stone (coarse aggregate) + Water। Water-cement ratio: ideal 0.4-0.6 (जितना कम, उतना मजबूत)। Curing: कम से कम 7 days (OPC), 10 days (PPC) — IS 456 के अनुसार न्यूनतम। Concrete grades: M15, M20, M25 (higher = stronger)।","note":"JE में w/c ratio, grades, curing period पूछे जाते हैं।"}$j$),
    (402, 'govt_technical', 'conc-formula', 'formula', 2, 'कंक्रीट सूत्र',
     $j${"formula":"Concrete = Cement + Sand + Aggregate + Water · w/c ratio = Water/Cement (0.4-0.6 ideal)","explanation":"Grades: M15 (15 N/mm²), M20, M25 · Curing (न्यूनतम): 7 days (OPC), 10 days (PPC) · Higher grade = more cement"}$j$),
    (402, 'govt_technical', 'conc-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"M20 concrete में 28-day strength?","solution":"M20 → M = Mix, 20 = strength in N/mm²","answer":"20 N/mm²"}$j$),
    (402, 'govt_technical', 'conc-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"OPC का curing period (न्यूनतम)?","options":["3 days","7 days","14 days","28 days"],"answer":1,"explanation":"OPC = 7 days · PPC = 10 days (न्यूनतम, IS 456)"},{"q":"Ideal water-cement ratio?","options":["0.2-0.3","0.4-0.6","0.7-0.9","1.0-1.2"],"answer":1,"explanation":"0.4 to 0.6 ideal"}]}$j$),
    (402, null, 'conc-diagram', 'svg', 5, 'Concrete mix',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='30' y='40' width='50' height='30' rx='4' fill='#60a5fa'/><text x='55' y='58' text-anchor='middle' fill='white' font-size='10'>Cement</text><text x='90' y='58' fill='#f59e0b' font-size='14'>+</text><rect x='105' y='40' width='50' height='30' rx='4' fill='#a78bfa'/><text x='130' y='58' text-anchor='middle' fill='white' font-size='10'>Sand</text><text x='165' y='58' fill='#f59e0b' font-size='14'>+</text><rect x='180' y='40' width='50' height='30' rx='4' fill='#14b8a6'/><text x='205' y='58' text-anchor='middle' fill='white' font-size='10'>Aggregate</text><text x='240' y='58' fill='#f59e0b' font-size='14'>+</text><text x='265' y='58' fill='#f472b6' font-size='11'>Water</text><text x='150' y='95' text-anchor='middle' fill='#64748b' font-size='11'>Concrete = 4 components</text></svg>","caption":"Concrete: 4 components"}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  case
    when s.level_id = 'govt_technical' and s.chapter_id in (401,402) then array['rrb-je-cbt2','ssc-je-paper1']::text[]
    when s.level_id = 'govt_technical' then array['rrb-je-cbt1','rrb-je-cbt2','ssc-je-paper1']::text[]
    when s.level_id = 'govt_basic' then array['rrb-ntpc-graduate-cbt-1','rrb-ntpc-graduate-cbt-2','rrb-ntpc-ug-cbt-1','rrb-ntpc-ug-cbt-2']::text[]
    else '{}'::text[] end,
  '{}'::text[],
  case when s.chapter_id in (401,402) then 'civil-engineering' else 'general-awareness' end,
  'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, level_id, count(*) from mtb.atoms
-- where chapter_id in (422, 38, 40, 401, 402) and status='published' and not archived
-- group by 1,2 order by 1,2;
-- Expected: 422, 38, 40: govt_technical=4, govt_basic=4, NULL=1 (9 each); 401, 402: govt_technical=4, NULL=1 (5 each)
