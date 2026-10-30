-- Chapter 3 (si) Simple & Compound Interest — Maths

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    (3, 'govt_technical', 'si-concept', 'concept', 1, 'साधारण व चक्रवृद्धि ब्याज',
     $j${"text":"SI = P×R×T/100 (मूलधन पर)। CI = P[(1+R/100)^T − 1] (मूलधन + पिछला ब्याज)। CI हमेशा SI से ≥। Half-yearly: R/2, T×2।","note":"JE में CI का 2-3 साल का difference और installment वाले questions आते हैं।"}$j$),
    (3, 'govt_technical', 'si-formula', 'formula', 2, 'SI और CI सूत्र',
     $j${"formula":"SI = P·R·T/100 · CI = P[(1+R/100)^T − 1]","explanation":"2 साल के लिए: CI − SI = P(R/100)² · 3 साल: P(R/100)²(3+R/100)"}$j$),
    (3, 'govt_technical', 'si-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"₹10,000 पर 10% वार्षिक, 2 साल का CI−SI difference?","solution":"CI−SI (2yr) = P(R/100)² = 10000 × (0.1)² = 10000 × 0.01","answer":"₹100"}$j$),
    (3, 'govt_technical', 'si-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"₹5000, 10%, 2 वर्ष SI?","options":["₹500","₹1000","₹1100","₹1200"],"answer":1,"explanation":"5000 × 10 × 2 / 100 = 1000"},{"q":"Half-yearly compounding में rate?","options":["R","R/2","2R","R/4"],"answer":1,"explanation":"Half-yearly → rate आधी, period दोगुनी"}]}$j$),
    (3, 'govt_basic', 'si-concept', 'concept', 1, 'साधारण ब्याज (SI)',
     $j${"text":"SI = P×R×T/100। P = मूलधन, R = वार्षिक दर %, T = साल। CI में ब्याज पर भी ब्याज मिलता है।","note":"2 साल के लिए CI = SI + P(R/100)²"}$j$),
    (3, 'govt_basic', 'si-formula', 'formula', 2, 'ब्याज का सूत्र',
     $j${"formula":"SI = P × R × T / 100","explanation":"मिश्रधन (A) = P + SI = P(1 + RT/100)"}$j$),
    (3, 'govt_basic', 'si-example', 'example', 3, 'उदाहरण',
     $j${"question":"₹2000 पर 5% वार्षिक, 3 साल का SI?","solution":"SI = 2000 × 5 × 3 / 100","answer":"₹300"}$j$),
    (3, 'govt_basic', 'si-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"₹1000, 10%, 1 वर्ष SI?","options":["₹50","₹100","₹150","₹200"],"answer":1,"explanation":"1000×10×1/100 = 100"},{"q":"SI का सूत्र?","options":["PRT","PRT/100","P/RT","P+R+T"],"answer":1,"explanation":"SI = PRT/100"}]}$j$),
    (3, null, 'si-diagram', 'svg', 5, 'SI vs CI',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><line x1='40' y1='100' x2='280' y2='100' stroke='#94a3b8'/><line x1='40' y1='20' x2='40' y2='100' stroke='#94a3b8'/><polyline points='40,100 100,80 160,55 220,25' fill='none' stroke='#14b8a6' stroke-width='2'/><polyline points='40,100 100,82 160,60 220,36' fill='none' stroke='#60a5fa' stroke-width='2'/><text x='240' y='30' fill='#14b8a6' font-size='11'>CI</text><text x='240' y='45' fill='#60a5fa' font-size='11'>SI</text></svg>","caption":"CI (मिंट) SI (नीला) से हमेशा बड़ा"}$j$)
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
-- select level_id, count(*) from mtb.atoms where chapter_id=3 and status='published' and not archived group by 1;
-- Expected: govt_technical=4, govt_basic=4, NULL=1, graduation_com=4 (pre-existing)
