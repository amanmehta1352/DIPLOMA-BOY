-- Chapter 899 (chem-lab) Laboratory Chemistry
-- 4 govt_technical + 4 govt_basic + 1 shared SVG = 9 atoms

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    (899, 'govt_technical', 'lab-concept', 'concept', 1, 'प्रयोगशाला रसायन — SSC JE / RRB JE',
     $j${"text":"प्रयोगशाला में सुरक्षा सर्वोपरि। सामान्य उपकरण: बीकर (मिलाने), ब्यूरेट (titration), पिपेट (सटीक मापन), कॉनिकल फ्लास्क (reaction)। नियम: एसिड को पानी में धीरे-धीरे डालें, कभी उलटा नहीं।","note":"JE में titration, molarity, apparatus identification आम हैं।"}$j$),
    (899, 'govt_technical', 'lab-formula', 'formula', 2, 'Molarity / Normality / Dilution',
     $j${"formula":"M = n/V (mol/L) · N = M × n-factor · C₁V₁ = C₂V₂","explanation":"M = molarity, N = normality, n = moles, V = volume(L)। Titration: N₁V₁ = N₂V₂। Dilution: moles conserved।"}$j$),
    (899, 'govt_technical', 'lab-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"500 mL विलयन में 0.5 mol NaCl घुला है। Molarity?","solution":"M = n / V(L) = 0.5 / 0.5","answer":"1 M (1 mol/L)"}$j$),
    (899, 'govt_technical', 'lab-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"एसिड को पानी में मिलाते समय सही तरीका?","options":["पानी → एसिड","एसिड → पानी धीरे-धीरे","दोनों साथ","तेज़ी से"],"answer":1,"explanation":"एसिड → पानी, धीरे-धीरे, ताकि heat नियंत्रित रहे"},{"q":"ब्यूरेट का उपयोग?","options":["मिलाने","Titration","गर्म करने","छानने"],"answer":1,"explanation":"ब्यूरेट titration में सटीक आयतन के लिए"}]}$j$),
    (899, 'govt_basic', 'lab-concept', 'concept', 1, 'प्रयोगशाला रसायन',
     $j${"text":"प्रयोगशाला में बीकर, टेस्ट ट्यूब, ब्यूरेट, पिपेट जैसे उपकरण होते हैं। सुरक्षा: हमेशा चश्मा पहनें, एसिड को पानी में ही मिलाएँ।","note":"कभी एसिड सीधे ऊपर न डालें — छींटे लगेंगे।"}$j$),
    (899, 'govt_basic', 'lab-formula', 'formula', 2, 'Dilution का सूत्र',
     $j${"formula":"C₁V₁ = C₂V₂","explanation":"C = concentration, V = volume · Example: 2 M × 100 mL = 1 M × V₂ → V₂ = 200 mL"}$j$),
    (899, 'govt_basic', 'lab-example', 'example', 3, 'उदाहरण',
     $j${"question":"2 M HCl के 100 mL को 1 M बनाने के लिए कितना पानी?","solution":"C₁V₁ = C₂V₂ → 2×100 = 1×V₂ → V₂ = 200 mL (कुल)। अतिरिक्त पानी = 100 mL","answer":"100 mL पानी मिलाएँ"}$j$),
    (899, 'govt_basic', 'lab-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"एसिड को पानी में कैसे मिलाएँ?","options":["पानी ऊपर से","एसिड धीरे-धीरे पानी में","दोनों साथ","जल्दी"],"answer":1,"explanation":"एसिड → पानी, धीरे-धीरे"},{"q":"टेस्ट ट्यूब का उपयोग?","options":["केवल गर्म करना","छोटे प्रयोग","दोनों","कोई नहीं"],"answer":2,"explanation":"टेस्ट ट्यूब छोटे प्रयोग + गर्म करना दोनों"}]}$j$),
    (899, null, 'lab-diagram', 'svg', 5, 'प्रयोगशाला सेटअप',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='40' y='30' width='40' height='70' fill='#60a5fa'/><text x='60' y='115' text-anchor='middle' fill='#64748b' font-size='10'>बीकर</text><rect x='150' y='20' width='6' height='60' fill='#94a3b8'/><rect x='140' y='80' width='26' height='20' fill='#14b8a6' opacity='0.7'/><text x='153' y='115' text-anchor='middle' fill='#64748b' font-size='10'>ब्यूरेट</text></svg>","caption":"Titration: ब्यूरेट से बीकर में डालें"}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  case s.level_id
    when 'govt_technical' then array['rrb-je-cbt1','rrb-je-cbt2','ssc-je-paper1']::text[]
    when 'govt_basic' then array['rrb-ntpc-graduate-cbt-1','rrb-ntpc-graduate-cbt-2','rrb-ntpc-ug-cbt-1','rrb-ntpc-ug-cbt-2']::text[]
    else '{}'::text[] end,
  '{}'::text[], 'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select level_id, count(*) from mtb.atoms where chapter_id=899 and status='published' and not archived group by 1;
-- Expected: govt_technical=4, govt_basic=4, NULL=1
