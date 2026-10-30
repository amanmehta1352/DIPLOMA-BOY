-- Chapter 2 (pl) Profit, Loss, Discount — Maths

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    (2, 'govt_technical', 'pl-concept', 'concept', 1, 'लाभ-हानि — SSC JE / RRB JE',
     $j${"text":"CP = क्रय मूल्य, SP = विक्रय मूल्य। यदि SP>CP → लाभ; SP<CP → हानि। Discount हमेशा MP (marked price) पर दिया जाता है, CP पर नहीं।","note":"JE में successive discounts, MP-CP-SP chains, और false weight वाले problems आते हैं।"}$j$),
    (2, 'govt_technical', 'pl-formula', 'formula', 2, 'लाभ-हानि सूत्र',
     $j${"formula":"लाभ% = (SP − CP) / CP × 100 · Discount% = (MP − SP) / MP × 100 · SP = CP(1+P/100) = MP(1−D/100)","explanation":"दो क्रमिक discounts x%, y%: net = x + y − xy/100"}$j$),
    (2, 'govt_technical', 'pl-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"एक वस्तु CP=800, MP=1200, discount=20% पर बेची। लाभ%?","solution":"SP = 1200 × 0.8 = 960। लाभ = 960 − 800 = 160। लाभ% = 160/800 × 100","answer":"20%"}$j$),
    (2, 'govt_technical', 'pl-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"CP=500, SP=600। लाभ%?","options":["10%","15%","20%","25%"],"answer":2,"explanation":"(600−500)/500 × 100 = 20%"},{"q":"Successive 10% और 20% discount का net?","options":["28%","30%","25%","32%"],"answer":0,"explanation":"10+20−200/100 = 28%"}]}$j$),
    (2, 'govt_basic', 'pl-concept', 'concept', 1, 'लाभ-हानि',
     $j${"text":"लाभ = SP − CP; हानि = CP − SP। लाभ% हमेशा CP पर, discount हमेशा MP पर। 100 का item 120 में बेचा → 20% लाभ।","note":"Formula: लाभ% = (लाभ/CP) × 100"}$j$),
    (2, 'govt_basic', 'pl-formula', 'formula', 2, 'लाभ का सूत्र',
     $j${"formula":"लाभ% = (SP − CP) / CP × 100","explanation":"SP = CP + लाभ · या SP = CP × (100 + लाभ%) / 100"}$j$),
    (2, 'govt_basic', 'pl-example', 'example', 3, 'उदाहरण',
     $j${"question":"CP=250, SP=300। लाभ% कितना?","solution":"लाभ = 300 − 250 = 50। लाभ% = 50/250 × 100","answer":"20%"}$j$),
    (2, 'govt_basic', 'pl-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"CP=100, SP=80। हानि%?","options":["10%","15%","20%","25%"],"answer":2,"explanation":"(100−80)/100 × 100 = 20%"},{"q":"500 का item 600 में बेचा। लाभ?","options":["₹50","₹100","₹150","₹200"],"answer":1,"explanation":"600 − 500 = ₹100"}]}$j$),
    (2, null, 'pl-diagram', 'svg', 5, 'लाभ-हानि',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='40' y='40' width='80' height='50' fill='#60a5fa'/><text x='80' y='70' text-anchor='middle' fill='white' font-size='13' font-weight='bold'>CP</text><rect x='140' y='40' width='120' height='50' fill='#14b8a6'/><text x='200' y='70' text-anchor='middle' fill='white' font-size='13' font-weight='bold'>SP</text><text x='250' y='115' text-anchor='middle' fill='#f59e0b' font-size='11'>लाभ = SP − CP</text></svg>","caption":"SP > CP → लाभ · SP < CP → हानि"}$j$)
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
-- select level_id, count(*) from mtb.atoms where chapter_id=2 and status='published' and not archived group by 1;
-- Expected: govt_technical=4, govt_basic=4, NULL=1
