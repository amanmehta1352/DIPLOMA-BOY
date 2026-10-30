-- Chapter 1 (pct) Percentage — Maths

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    (1, 'govt_technical', 'pct-concept', 'concept', 1, 'प्रतिशत — SSC JE / RRB JE',
     $j${"text":"प्रतिशत का अर्थ है प्रति सौ पर। a/b को % में बदलने के लिए ×100 करें। JE में percentage change, successive discounts, और data interpretation ज़रूरी हैं।","note":"20% कमी + 20% वृद्धि = 4% नेट कमी, मूल मान नहीं आता।"}$j$),
    (1, 'govt_technical', 'pct-formula', 'formula', 2, 'प्रतिशत परिवर्तन',
     $j${"formula":"% = (नया − पुराना) / पुराना × 100","explanation":"वृद्धि: +, कमी: −। Successive: a + b + ab/100 (दो वृद्धि), a − b − ab/100 (वृद्धि+कमी)"}$j$),
    (1, 'govt_technical', 'pct-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"मशीन का वज़न 500 kg से 600 kg हो गया। % वृद्धि?","solution":"% = (600 − 500) / 500 × 100 = 100/500 × 100","answer":"20%"}$j$),
    (1, 'govt_technical', 'pct-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"कीमत 20% कम होकर 400। मूल कीमत?","options":["480","500","520","450"],"answer":1,"explanation":"मूल × 0.8 = 400 → मूल = 500"},{"q":"20% वृद्धि के बाद 20% कमी। नेट परिवर्तन?","options":["0%","+4%","−4%","−2%"],"answer":2,"explanation":"1.2 × 0.8 = 0.96 → 4% कमी"}]}$j$),
    (1, 'govt_basic', 'pct-concept', 'concept', 1, 'प्रतिशत',
     $j${"text":"प्रतिशत का अर्थ है प्रति सौ। 25% = 25/100 = 1/4। परीक्षा में (नया-पुराना)/पुराना × 100 का सूत्र आता है।","note":"% का मतलब 100 में कितना। 50% = आधा।"}$j$),
    (1, 'govt_basic', 'pct-formula', 'formula', 2, 'प्रतिशत का सूत्र',
     $j${"formula":"% = (नया − पुराना) / पुराना × 100","explanation":"वृद्धि: पुराना × (1 + x/100) · कमी: पुराना × (1 − x/100)"}$j$),
    (1, 'govt_basic', 'pct-example', 'example', 3, 'उदाहरण',
     $j${"question":"400 में से 320 अंक आए। प्रतिशत?","solution":"% = 320/400 × 100","answer":"80%"}$j$),
    (1, 'govt_basic', 'pct-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"25% को भिन्न में?","options":["1/2","1/4","1/5","2/5"],"answer":1,"explanation":"25/100 = 1/4"},{"q":"500 का 20% कितना?","options":["50","75","100","125"],"answer":2,"explanation":"500 × 20/100 = 100"}]}$j$),
    (1, null, 'pct-diagram', 'svg', 5, 'प्रतिशत वृद्धि-कमी',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='40' y='40' width='100' height='60' fill='#60a5fa'/><rect x='140' y='30' width='100' height='70' fill='#14b8a6'/><text x='90' y='75' text-anchor='middle' fill='white' font-size='14' font-weight='bold'>100</text><text x='190' y='70' text-anchor='middle' fill='white' font-size='14' font-weight='bold'>120</text><text x='90' y='115' text-anchor='middle' fill='#64748b' font-size='11'>पुराना</text><text x='190' y='115' text-anchor='middle' fill='#64748b' font-size='11'>नया (+20%)</text></svg>","caption":"प्रतिशत परिवर्तन: (120−100)/100 × 100 = 20%"}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  case s.level_id
    when 'govt_technical' then array['rrb-je-cbt1']::text[]
    when 'govt_basic' then array['rrb-ntpc-graduate-cbt-1','rrb-ntpc-graduate-cbt-2','rrb-ntpc-ug-cbt-1','rrb-ntpc-ug-cbt-2']::text[]
    else '{}'::text[] end,
  '{}'::text[], 'maths', 'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select level_id, count(*) from mtb.atoms where chapter_id=1 and status='published' and not archived group by 1;
-- Expected: govt_technical=4, govt_basic=4, NULL=1, banking=5 (pre-existing)
