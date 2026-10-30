-- GA chapters: 415 (Computer), 417 (Economy), 418 (Geography), 419 (History), 421 (Polity)
-- Note: "formula" atom type holds key facts/data for GA (same body structure).

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ Ch 415: Computer ═══
    (415, 'govt_technical', 'comp-concept', 'concept', 1, 'कंप्यूटर — SSC JE / RRB JE',
     $j${"text":"कंप्यूटर के मुख्य भाग: CPU (प्रोसेसिंग), RAM (अस्थायी मेमोरी), ROM (स्थायी), Hard Disk (भंडारण), Input (keyboard, mouse), Output (monitor, printer)। Computer generations: 1st (vacuum tubes), 2nd (transistors), 3rd (IC), 4th (microprocessor), 5th (AI)।","note":"JE/SSc में memory units, generations, और shortcuts पूछे जाते हैं।"}$j$),
    (415, 'govt_technical', 'comp-formula', 'formula', 2, 'Memory units और shortcuts',
     $j${"formula":"1 bit = 0/1 · 1 byte = 8 bits · 1 KB = 1024 bytes · 1 MB = 1024 KB · 1 GB = 1024 MB · 1 TB = 1024 GB","explanation":"Shortcuts: Ctrl+C (copy), Ctrl+V (paste), Ctrl+X (cut), Ctrl+Z (undo), Ctrl+S (save), Ctrl+P (print), Alt+F4 (close)"}$j$),
    (415, 'govt_technical', 'comp-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"2 GB में कितने MB?","solution":"1 GB = 1024 MB। 2 × 1024","answer":"2048 MB"}$j$),
    (415, 'govt_technical', 'comp-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"1 KB में कितने bytes?","options":["1000","1024","512","2048"],"answer":1,"explanation":"1 KB = 1024 bytes"},{"q":"कंप्यूटर का brain किसे कहते हैं?","options":["RAM","CPU","Hard Disk","Monitor"],"answer":1,"explanation":"CPU (Central Processing Unit) = brain"}]}$j$),
    (415, 'govt_basic', 'comp-concept', 'concept', 1, 'कंप्यूटर',
     $j${"text":"कंप्यूटर के भाग: CPU (दिमाग), RAM (मेमोरी), Hard Disk (स्टोरेज), Keyboard (input), Monitor (output)।","note":"CPU = brain, RAM = short-term memory"}$j$),
    (415, 'govt_basic', 'comp-formula', 'formula', 2, 'मेमोरी यूनिट',
     $j${"formula":"1 byte = 8 bits · 1 KB = 1024 bytes · 1 MB = 1024 KB · 1 GB = 1024 MB","explanation":"Ctrl+C = copy, Ctrl+V = paste"}$j$),
    (415, 'govt_basic', 'comp-example', 'example', 3, 'उदाहरण',
     $j${"question":"1 MB में कितने KB?","solution":"1024","answer":"1024 KB"}$j$),
    (415, 'govt_basic', 'comp-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"कंप्यूटर की main memory?","options":["RAM","ROM","Hard Disk","Monitor"],"answer":0,"explanation":"RAM = main memory (अस्थायी)"},{"q":"Input device कौन सा?","options":["Monitor","Printer","Keyboard","Speaker"],"answer":2,"explanation":"Keyboard = input device"}]}$j$),
    (415, null, 'comp-diagram', 'svg', 5, 'कंप्यूटर के भाग',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='30' y='40' width='50' height='30' rx='4' fill='#60a5fa'/><text x='55' y='60' text-anchor='middle' fill='white' font-size='11'>CPU</text><rect x='90' y='40' width='50' height='30' rx='4' fill='#14b8a6'/><text x='115' y='60' text-anchor='middle' fill='white' font-size='11'>RAM</text><rect x='150' y='40' width='50' height='30' rx='4' fill='#f59e0b'/><text x='175' y='60' text-anchor='middle' fill='white' font-size='11'>HDD</text><rect x='210' y='40' width='60' height='30' rx='4' fill='#a78bfa'/><text x='240' y='60' text-anchor='middle' fill='white' font-size='11'>Monitor</text><text x='150' y='95' text-anchor='middle' fill='#64748b' font-size='11'>CPU + RAM + Storage + Output</text></svg>","caption":"कंप्यूटर के 4 मुख्य भाग"}$j$),

    -- ═══ Ch 417: Economy ═══
    (417, 'govt_technical', 'eco-concept', 'concept', 1, 'अर्थव्यवस्था — SSC JE / RRB JE',
     $j${"text":"GDP = किसी देश में एक वर्ष में उत्पादित वस्तुओं/सेवाओं का कुल मूल्य। GNP = GDP + विदेशों से शुद्ध आय। Inflation = कीमतों में वृद्धि। RBI (Reserve Bank of India) = भारत का केंद्रीय बैंक, मौद्रिक नीति बनाता है। Repo rate = RBI द्वारा बैंकों को दिए loan की दर।","note":"JE में GDP, inflation, और RBI के बारे में पूछा जाता है।"}$j$),
    (417, 'govt_technical', 'eco-formula', 'formula', 2, 'Economy facts और formulas',
     $j${"formula":"GDP = C + I + G + (X − M) · Inflation % = (नई कीमत − पुरानी) / पुरानी × 100","explanation":"C = consumption, I = investment, G = government, X = exports, M = imports · RBI स्थापित: 1935, राष्ट्रीयकृत: 1949"}$j$),
    (417, 'govt_technical', 'eco-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"किसी वस्तु का मूल्य ₹100 से ₹120 हुआ। inflation %?","solution":"(120−100)/100 × 100","answer":"20%"}$j$),
    (417, 'govt_technical', 'eco-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"GDP का full form?","options":["Gross Domestic Product","General Domestic Product","Gross Direct Product","Gross Domestic Price"],"answer":0,"explanation":"GDP = Gross Domestic Product"},{"q":"भारत का केंद्रीय बैंक?","options":["SBI","RBI","PNB","HDFC"],"answer":1,"explanation":"RBI (Reserve Bank of India) = central bank"}]}$j$),
    (417, 'govt_basic', 'eco-concept', 'concept', 1, 'अर्थव्यवस्था',
     $j${"text":"GDP = देश में पैदा हुई सारी चीज़ों का मूल्य। RBI = भारत का केंद्रीय बैंक, जो नोट छापता है और बैंकों को नियंत्रित करता है।","note":"GDP = Gross Domestic Product"}$j$),
    (417, 'govt_basic', 'eco-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"GDP = C+I+G+(X−M)","explanation":"C=उपभोग, I=निवेश, G=सरकारी खर्च, X-M=शुद्ध निर्यात"}$j$),
    (417, 'govt_basic', 'eco-example', 'example', 3, 'उदाहरण',
     $j${"question":"GDP का full form?","solution":"Gross Domestic Product","answer":"सकल घरेलू उत्पाद"}$j$),
    (417, 'govt_basic', 'eco-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"GDP का मतलब?","options":["Gross Domestic Product","General Data","Gold Deposit","Gross Direct"],"answer":0,"explanation":"Gross Domestic Product"},{"q":"भारत की मुद्रा?","options":["Dollar","Rupee","Pound","Euro"],"answer":1,"explanation":"भारतीय रुपया (Rupee)"}]}$j$),
    (417, null, 'eco-diagram', 'svg', 5, 'GDP घटक',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><text x='150' y='25' text-anchor='middle' fill='#f59e0b' font-size='13' font-weight='bold'>GDP</text><rect x='30' y='50' width='50' height='40' rx='4' fill='#60a5fa'/><text x='55' y='73' text-anchor='middle' fill='white' font-size='11'>C</text><rect x='90' y='50' width='50' height='40' rx='4' fill='#14b8a6'/><text x='115' y='73' text-anchor='middle' fill='white' font-size='11'>I</text><rect x='150' y='50' width='50' height='40' rx='4' fill='#a78bfa'/><text x='175' y='73' text-anchor='middle' fill='white' font-size='11'>G</text><rect x='210' y='50' width='60' height='40' rx='4' fill='#f472b6'/><text x='240' y='73' text-anchor='middle' fill='white' font-size='11'>X-M</text><text x='150' y='110' text-anchor='middle' fill='#64748b' font-size='11'>C+I+G+(X−M)</text></svg>","caption":"GDP के 4 घटक"}$j$),

    -- ═══ Ch 418: Geography ═══
    (418, 'govt_technical', 'geo2-concept', 'concept', 1, 'भूगोल — SSC JE / RRB JE',
     $j${"text":"7 महाद्वीप: Asia, Africa, North America, South America, Antarctica, Europe, Australia। 5 महासागर: Pacific, Atlantic, Indian, Arctic, Southern। भारत की सबसे लंबी नदी: Ganga। सबसे ऊँचा पर्वत: Mount Everest (8,848m)। Latitude: East-West lines, Longitude: North-South lines। 1° longitude = 4 min time difference।","note":"JE/SSc में longest, largest, highest, और capitals पूछे जाते हैं।"}$j$),
    (418, 'govt_technical', 'geo2-formula', 'formula', 2, 'भूगोल तथ्य',
     $j${"formula":"7 continents · 5 oceans · 1° longitude = 4 min time · Earth circumference ≈ 40,075 km","explanation":"Largest: Asia (continent), Pacific (ocean), Sahara (hot desert), Nile (long river), Everest (peak)"}$j$),
    (418, 'govt_technical', 'geo2-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"15° longitude = कितने minute time difference?","solution":"1° = 4 min। 15 × 4","answer":"60 min = 1 hour"}$j$),
    (418, 'govt_technical', 'geo2-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"सबसे बड़ा महासागर?","options":["Pacific","Atlantic","Indian","Arctic"],"answer":0,"explanation":"Pacific = largest ocean"},{"q":"भारत की सबसे लंबी नदी?","options":["Ganga","Godavari","Brahmaputra","Yamuna"],"answer":0,"explanation":"Ganga = longest river in India"}]}$j$),
    (418, 'govt_basic', 'geo2-concept', 'concept', 1, 'भूगोल',
     $j${"text":"7 महाद्वीप, 5 महासागर। सबसे बड़ा महाद्वीप = Asia, सबसे बड़ा महासागर = Pacific। भारत की राजधानी = Delhi।","note":"7 continents, 5 oceans"}$j$),
    (418, 'govt_basic', 'geo2-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"Continents = 7 · Oceans = 5 · India capital = Delhi","explanation":"Largest continent = Asia, largest ocean = Pacific"}$j$),
    (418, 'govt_basic', 'geo2-example', 'example', 3, 'उदाहरण',
     $j${"question":"भारत की राजधानी?","solution":"New Delhi","answer":"दिल्ली"}$j$),
    (418, 'govt_basic', 'geo2-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"पृथ्वी का उपग्रह?","options":["Sun","Moon","Mars","Venus"],"answer":1,"explanation":"Moon = Earth's satellite"},{"q":"भारत की राजधानी?","options":["Mumbai","Delhi","Kolkata","Chennai"],"answer":1,"explanation":"Delhi = capital of India"}]}$j$),
    (418, null, 'geo2-diagram', 'svg', 5, 'पृथ्वी',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><circle cx='150' cy='60' r='45' fill='#60a5fa'/><ellipse cx='150' cy='60' rx='45' ry='15' fill='none' stroke='#f59e0b' stroke-width='2'/><text x='150' y='115' text-anchor='middle' fill='#64748b' font-size='11'>Earth: 7 continents, 5 oceans</text></svg>","caption":"पृथ्वी: 7 महाद्वीप, 5 महासागर"}$j$),

    -- ═══ Ch 419: History ═══
    (419, 'govt_technical', 'hist-concept', 'concept', 1, 'इतिहास — SSC JE / RRB JE',
     $j${"text":"भारतीय इतिहास के 3 काल: प्राचीन (सिंधु घाटी 2500 BCE, वैदिक 1500 BCE, मौर्य 322 BCE, गुप्त 320 CE), मध्यकाल (दिल्ली सल्तनत 1206, मुगल 1526), आधुनिक (British 1757, स्वतंत्रता 1947)। ताजमहल शाहजहाँ ने बनवाया (1632-1653)।","note":"JE में dates और monuments पूछे जाते हैं।"}$j$),
    (419, 'govt_technical', 'hist-formula', 'formula', 2, 'मुख्य तिथियाँ',
     $j${"formula":"सिंधु घाटी 2500 BCE · मौर्य 322 BCE · गुप्त 320 CE · मुगल 1526 · British 1757 · स्वतंत्रता 1947","explanation":"Monuments: Taj Mahal (Shah Jahan), Qutub Minar (Qutb-ud-din Aibak), Red Fort (Shah Jahan)"}$j$),
    (419, 'govt_technical', 'hist-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"भारत की आज़ादी कब हुई?","solution":"15 August 1947","answer":"1947"}$j$),
    (419, 'govt_technical', 'hist-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"भारत की आज़ादी कब?","options":["1945","1946","1947","1948"],"answer":2,"explanation":"15 August 1947"},{"q":"ताजमहल किसने बनवाया?","options":["Akbar","Shah Jahan","Aurangzeb","Babur"],"answer":1,"explanation":"Shah Jahan ने बनवाया"}]}$j$),
    (419, 'govt_basic', 'hist-concept', 'concept', 1, 'इतिहास',
     $j${"text":"भारत 1947 में आज़ाद हुआ। ताजमहल शाहजहाँ ने बनवाया, आगरा में है। Qutub Minar दिल्ली में है।","note":"1947 = independence"}$j$),
    (419, 'govt_basic', 'hist-formula', 'formula', 2, 'मुख्य तिथियाँ',
     $j${"formula":"स्वतंत्रता: 1947 · मुगल साम्राज्य: 1526 · British राज: 1757","explanation":"Taj Mahal = Shah Jahan, Agra"}$j$),
    (419, 'govt_basic', 'hist-example', 'example', 3, 'उदाहरण',
     $j${"question":"ताजमहल कहाँ है?","solution":"Agra, Uttar Pradesh","answer":"आगरा"}$j$),
    (419, 'govt_basic', 'hist-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"भारत की आज़ादी?","options":["1945","1946","1947","1948"],"answer":2,"explanation":"1947"},{"q":"ताजमहल कहाँ है?","options":["Delhi","Agra","Jaipur","Mumbai"],"answer":1,"explanation":"Agra में"}]}$j$),
    (419, null, 'hist-diagram', 'svg', 5, 'भारतीय इतिहास',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><line x1='20' y1='60' x2='280' y2='60' stroke='#64748b' stroke-width='2'/><circle cx='60' cy='60' r='6' fill='#60a5fa'/><text x='60' y='85' text-anchor='middle' fill='#60a5fa' font-size='9'>Ancient</text><circle cx='150' cy='60' r='6' fill='#14b8a6'/><text x='150' y='85' text-anchor='middle' fill='#14b8a6' font-size='9'>Medieval</text><circle cx='240' cy='60' r='6' fill='#f59e0b'/><text x='240' y='85' text-anchor='middle' fill='#f59e0b' font-size='9'>Modern</text><text x='60' y='45' text-anchor='middle' fill='#64748b' font-size='9'>2500 BCE</text><text x='150' y='45' text-anchor='middle' fill='#64748b' font-size='9'>1206 CE</text><text x='240' y='45' text-anchor='middle' fill='#64748b' font-size='9'>1757 CE</text></svg>","caption":"Ancient → Medieval → Modern"}$j$),

    -- ═══ Ch 421: Polity ═══
    (421, 'govt_technical', 'pol-concept', 'concept', 1, 'राजव्यवस्था — SSC JE / RRB JE',
     $j${"text":"भारतीय संविधान 26 Jan 1950 को लागू हुआ। 3 branches: Legislature (Parliament — Lok Sabha + Rajya Sabha), Executive (President + PM + Council of Ministers), Judiciary (Supreme Court → High Court → District Court)। Fundamental Rights = Part III (Articles 12-35)। President = Head of State (ceremonial), PM = Head of Government (real power)।","note":"JE में Constitution, Articles, और President/PM roles पूछे जाते हैं।"}$j$),
    (421, 'govt_technical', 'pol-formula', 'formula', 2, 'Polity facts',
     $j${"formula":"Constitution: 26 Jan 1950 · Parts: 25 (originally 22) · Articles: 448 · Schedules: 12 · Amendments: 100+","explanation":"Fundamental Rights = Part III (Art 12-35), DPSP = Part IV (Art 36-51)"}$j$),
    (421, 'govt_technical', 'pol-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"भारतीय संविधान कब लागू हुआ?","solution":"26 January 1950","answer":"26 जनवरी 1950"}$j$),
    (421, 'govt_technical', 'pol-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"संविधान कब लागू हुआ?","options":["26 Jan 1950","15 Aug 1947","26 Nov 1949","26 Jan 1949"],"answer":0,"explanation":"26 January 1950 = Republic Day"},{"q":"पहले प्रधानमंत्री?","options":["Nehru","Gandhi","Patel","Rajendra Prasad"],"answer":0,"explanation":"Jawaharlal Nehru = first PM"}]}$j$),
    (421, 'govt_basic', 'pol-concept', 'concept', 1, 'राजव्यवस्था',
     $j${"text":"भारतीय संविधान 26 जनवरी 1950 से लागू हुआ। President देश के head हैं, PM सरकार चलाते हैं। Parliament = Lok Sabha + Rajya Sabha।","note":"Constitution Day = 26 Nov, Republic Day = 26 Jan"}$j$),
    (421, 'govt_basic', 'pol-formula', 'formula', 2, 'मुख्य तथ्य',
     $j${"formula":"Constitution: 26 Jan 1950 · President: Head of State · PM: Head of Government","explanation":"Lok Sabha + Rajya Sabha = Parliament"}$j$),
    (421, 'govt_basic', 'pol-example', 'example', 3, 'उदाहरण',
     $j${"question":"भारत के राष्ट्रपति कौन?","solution":"Head of State","answer":"राष्ट्रपति (President)"}$j$),
    (421, 'govt_basic', 'pol-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"संविधान कब लागू हुआ?","options":["26 Jan 1950","15 Aug 1947","26 Nov 1949","26 Jan 1949"],"answer":0,"explanation":"26 January 1950"},{"q":"राष्ट्रपति को कौन चुनता है?","options":["जनता","Electoral College","PM","सांसद"],"answer":1,"explanation":"Electoral College (MPs + MLAs) द्वारा"}]}$j$),
    (421, null, 'pol-diagram', 'svg', 5, 'भारतीय शासन',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='110' y='15' width='80' height='25' rx='4' fill='#60a5fa'/><text x='150' y='32' text-anchor='middle' fill='white' font-size='11' font-weight='bold'>President</text><rect x='110' y='55' width='80' height='25' rx='4' fill='#14b8a6'/><text x='150' y='72' text-anchor='middle' fill='white' font-size='11' font-weight='bold'>PM</text><rect x='50' y='90' width='70' height='22' rx='4' fill='#f59e0b'/><text x='85' y='105' text-anchor='middle' fill='white' font-size='10'>Lok Sabha</text><rect x='180' y='90' width='70' height='22' rx='4' fill='#f59e0b'/><text x='215' y='105' text-anchor='middle' fill='white' font-size='10'>Rajya Sabha</text></svg>","caption":"President → PM → Parliament"}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  case s.level_id
    when 'govt_technical' then array['rrb-je-cbt1','rrb-je-cbt2','ssc-je-paper1']::text[]
    when 'govt_basic' then array['rrb-ntpc-graduate-cbt-1','rrb-ntpc-graduate-cbt-2','rrb-ntpc-ug-cbt-1','rrb-ntpc-ug-cbt-2']::text[]
    else '{}'::text[] end,
  '{}'::text[], 'general-awareness', 'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, level_id, count(*) from mtb.atoms
-- where chapter_id in (415,417,418,419,421) and status='published' and not archived
-- group by 1,2 order by 1,2;
-- Expected per chapter: govt_technical=4, govt_basic=4, NULL=1
-- Note: chapters 417, 418, 419, 421 may have pre-existing starter atoms (class_11_12_com, class_11_12_arts, upsc_civil, state_psc). Those should be unchanged.
