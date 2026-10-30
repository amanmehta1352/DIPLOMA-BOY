-- Maths chapters 4-8: Ratio, Average, Ages, Mixture, Time-Work
-- 5 chapters × 9 atoms = 45 atoms
-- Note: ch6 tech MCQ and age-formula were corrected before apply (original draft had wrong answers and leftover working text).

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ Ch 4: Ratio & Proportion ═══
    (4, 'govt_technical', 'ratio-concept', 'concept', 1, 'अनुपात-समानुपात — SSC JE / RRB JE',
     $j${"text":"अनुपात a:b दो राशियों की तुलना है। Compound ratio: (a:b)×(c:d)=(ac:bd)। Proportion: a:b::c:d → ad=bc। Four proportional: a:b=c:d → d=bc/a। Mean proportional of a,b = √(ab)।","note":"JE में ratio compounding, mixture, aur division problems आते हैं।"}$j$),
    (4, 'govt_technical', 'ratio-formula', 'formula', 2, 'अनुपात सूत्र',
     $j${"formula":"a:b = a/b · a:b::c:d → ad=bc · Mean prop = √(ab)","explanation":"Compounding: (a:b)×(c:d)=ac:bd · Dividing N in a:b:c → shares = Na/(a+b+c) etc."}$j$),
    (4, 'govt_technical', 'ratio-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"₹4800 को A:B:C = 3:5:7 में बाँटो। सबसे बड़ा हिस्सा?","solution":"Total parts = 15। C का हिस्सा = 4800 × 7/15","answer":"₹2240"}$j$),
    (4, 'govt_technical', 'ratio-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"₹3600 को 2:3:4 में बाँटो। सबसे बड़ा?","options":["1200","1400","1600","1800"],"answer":2,"explanation":"parts=9, largest=3600×4/9=1600"},{"q":"अगर a:b=2:3, b:c=4:5। a:c?","options":["8:15","2:5","5:2","3:4"],"answer":0,"explanation":"a:b:c = 8:12:15, so a:c=8:15"}]}$j$),
    (4, 'govt_basic', 'ratio-concept', 'concept', 1, 'अनुपात',
     $j${"text":"अनुपात बताता है कि एक राशि दूसरी की कितनी गुनी है। 2:3 का मतलब है 2 भाग बनाम 3 भाग। 100 को 2:3 में बाँटो → 40 और 60।","note":"अनुपात में दोनों भाग एक ही इकाई के होने चाहिए।"}$j$),
    (4, 'govt_basic', 'ratio-formula', 'formula', 2, 'अनुपात-समानुपात',
     $j${"formula":"a:b :: c:d ⇒ ad = bc","explanation":"a/b = c/d · Cross-multiply: a×d = b×c"}$j$),
    (4, 'govt_basic', 'ratio-example', 'example', 3, 'उदाहरण',
     $j${"question":"₹1000 को 3:7 में बाँटो।","solution":"Total parts = 10। Shares = 1000×3/10 और 1000×7/10","answer":"₹300 और ₹700"}$j$),
    (4, 'govt_basic', 'ratio-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"2:5 का मतलब क्या है?","options":["2+5","2/5","2×5","5−2"],"answer":1,"explanation":"a:b = a/b"},{"q":"₹900 को 4:5 में बाँटो। छोटा हिस्सा?","options":["₹400","₹500","₹450","₹600"],"answer":0,"explanation":"900×4/9=400"}]}$j$),
    (4, null, 'ratio-diagram', 'svg', 5, 'अनुपात',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='30' y='40' width='80' height='40' fill='#60a5fa'/><rect x='110' y='40' width='160' height='40' fill='#14b8a6'/><text x='70' y='65' text-anchor='middle' fill='white' font-size='13' font-weight='bold'>3</text><text x='190' y='65' text-anchor='middle' fill='white' font-size='13' font-weight='bold'>7</text><text x='150' y='105' text-anchor='middle' fill='#64748b' font-size='11'>a:b = 3:7</text></svg>","caption":"अनुपात 3:7 — कुल 10 भागों में बाँटा"}$j$),

    -- ═══ Ch 5: Average ═══
    (5, 'govt_technical', 'avg-concept', 'concept', 1, 'औसत — SSC JE / RRB JE',
     $j${"text":"औसत = राशियों का योग / राशियों की संख्या। Weighted average = Σwᵢxᵢ / Σwᵢ। Consecutive numbers का average = (first+last)/2। JE में speed-average, replacement, aur inclusion-exclusion आते हैं।","note":"Average speed = Total distance / Total time (harmonic mean जब same distance)"}$j$),
    (5, 'govt_technical', 'avg-formula', 'formula', 2, 'औसत सूत्र',
     $j${"formula":"Avg = Σx/n · 1st n naturals का औसत = (n+1)/2 · 1st n odd का औसत = n · 1st n even का औसत = n+1","explanation":"Weighted: (n₁x₁+n₂x₂)/(n₁+n₂)"}$j$),
    (5, 'govt_technical', 'avg-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"किसी कक्षा के 20 छात्रों का औसत 45, 30 का 55। Combined average?","solution":"Total = 20×45 + 30×55 = 900+1650 = 2550। Combined avg = 2550/50","answer":"51"}$j$),
    (5, 'govt_technical', 'avg-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"1 से 20 तक का औसत?","options":["10","10.5","11","11.5"],"answer":1,"explanation":"(20+1)/2 = 10.5"},{"q":"5 संख्याओं का औसत 20, चार का 18। पाँचवीं संख्या?","options":["24","26","28","30"],"answer":2,"explanation":"5×20−4×18 = 100−72 = 28"}]}$j$),
    (5, 'govt_basic', 'avg-concept', 'concept', 1, 'औसत',
     $j${"text":"औसत = सब राशियों का जोड़ / कितनी राशियाँ। 10 और 20 का औसत = 30/2 = 15।","note":"औसत हमेशा smallest और largest के बीच होता है।"}$j$),
    (5, 'govt_basic', 'avg-formula', 'formula', 2, 'औसत का सूत्र',
     $j${"formula":"Avg = Sum / Count","explanation":"Sum = Avg × Count · Count = Sum / Avg"}$j$),
    (5, 'govt_basic', 'avg-example', 'example', 3, 'उदाहरण',
     $j${"question":"4, 6, 8, 10, 12 का औसत?","solution":"Sum = 40, Count = 5, Avg = 40/5","answer":"8"}$j$),
    (5, 'govt_basic', 'avg-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"5, 15 का औसत?","options":["8","10","12","15"],"answer":1,"explanation":"(5+15)/2 = 10"},{"q":"3 संख्याओं का औसत 7 है। Sum?","options":["10","15","21","24"],"answer":2,"explanation":"Sum = 7×3 = 21"}]}$j$),
    (5, null, 'avg-diagram', 'svg', 5, 'औसत',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='30' y='90' width='30' height='30' fill='#60a5fa'/><rect x='70' y='60' width='30' height='60' fill='#60a5fa'/><rect x='110' y='40' width='30' height='80' fill='#60a5fa'/><rect x='150' y='80' width='30' height='40' fill='#60a5fa'/><rect x='190' y='70' width='30' height='50' fill='#60a5fa'/><line x1='20' y1='65' x2='280' y2='65' stroke='#f59e0b' stroke-width='2' stroke-dasharray='5,3'/><text x='285' y='68' fill='#f59e0b' font-size='11'>avg</text></svg>","caption":"बार्स का औसत = कुल योग / संख्या"}$j$),

    -- ═══ Ch 6: Ages ═══
    (6, 'govt_technical', 'age-concept', 'concept', 1, 'आयु — SSC JE / RRB JE',
     $j${"text":"आयु के सवालों में समय के साथ ratio बदलता है। Present age को x मानो, past = x−n, future = x+n। Years ago/hence वाले relations को ratio equations में बदलो।","note":"JE में father-son, mother-daughter, और समूह आयु के questions आते हैं।"}$j$),
    (6, 'govt_technical', 'age-formula', 'formula', 2, 'आयु के सूत्र',
     $j${"formula":"पहले की आयु = x − n · भविष्य की आयु = x + n","explanation":"n साल बाद के ratio से समीकरण बनाएँ, फिर x निकालें"}$j$),
    (6, 'govt_technical', 'age-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"पिता की आयु पुत्र से 3 गुनी है। 12 साल बाद 2 गुनी होगी। पिता की आयु?","solution":"पुत्र = x, पिता = 3x। 12 साल बाद: 3x+12 = 2(x+12) → x=12। पिता = 36","answer":"36 वर्ष"}$j$),
    (6, 'govt_technical', 'age-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"माँ की आयु 32 और बेटी की 8। कितने साल बाद माँ, बेटी की 3 गुनी होगी?","options":["2","3","4","5"],"answer":2,"explanation":"32+n = 3(8+n) → 32+n = 24+3n → 2n = 8 → n = 4"},{"q":"A की आयु 40 और B की 20। कितने साल पहले A, B की 3 गुनी थी?","options":["5","8","10","12"],"answer":2,"explanation":"40−n = 3(20−n) → 40−n = 60−3n → 2n = 20 → n = 10"}]}$j$),
    (6, 'govt_basic', 'age-concept', 'concept', 1, 'आयु',
     $j${"text":"आयु के सवाल में अगर किसी की आयु x है, तो n साल बाद x+n होगी, n साल पहले x−n थी।","note":"पहले ratio देखो, फिर equation बनाओ।"}$j$),
    (6, 'govt_basic', 'age-formula', 'formula', 2, 'आयु का सूत्र',
     $j${"formula":"Present = Past + years · Present = Future − years","explanation":"अगर किसी की आयु आज x है, तो n साल पहले (x−n) थी"}$j$),
    (6, 'govt_basic', 'age-example', 'example', 3, 'उदाहरण',
     $j${"question":"A 30 साल का है। 5 साल बाद उसकी आयु?","solution":"30 + 5","answer":"35 वर्ष"}$j$),
    (6, 'govt_basic', 'age-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"B 20 साल का, 4 साल पहले कितना था?","options":["14","15","16","17"],"answer":2,"explanation":"20−4 = 16"},{"q":"A 24, B 12। A, B का कितना गुना?","options":["1.5","2","2.5","3"],"answer":1,"explanation":"24/12 = 2"}]}$j$),
    (6, null, 'age-diagram', 'svg', 5, 'आयु रेखा',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><line x1='30' y1='70' x2='270' y2='70' stroke='#94a3b8' stroke-width='2'/><polygon points='270,70 260,65 260,75' fill='#94a3b8'/><circle cx='80' cy='70' r='8' fill='#60a5fa'/><text x='80' y='100' text-anchor='middle' fill='#60a5fa' font-size='11'>Past</text><circle cx='150' cy='70' r='8' fill='#f59e0b'/><text x='150' y='55' text-anchor='middle' fill='#f59e0b' font-size='11'>Now</text><circle cx='220' cy='70' r='8' fill='#14b8a6'/><text x='220' y='100' text-anchor='middle' fill='#14b8a6' font-size='11'>Future</text></svg>","caption":"आयु समय के साथ बदलती है"}$j$),

    -- ═══ Ch 7: Mixture & Alligation ═══
    (7, 'govt_technical', 'mix-concept', 'concept', 1, 'मिश्रण-एलीगेशन — SSC JE / RRB JE',
     $j${"text":"Alligation उस rule को कहते हैं जो दो अलग rates वाली चीज़ों को mix करने पर mean rate देता है। Cheap की मात्रा / Dear की मात्रा = (Dear − Mean) : (Mean − Cheap)। Replacement problems भी इसी pattern पर।","note":"JE में milk-water, tea, और metal-alloy के problems आते हैं।"}$j$),
    (7, 'govt_technical', 'mix-formula', 'formula', 2, 'Alligation सूत्र',
     $j${"formula":"Quantity cheap : Quantity dear = (dear − mean) : (mean − cheap)","explanation":"Replacement: बार-बार r लीटर निकालकर पानी डालें तो n बार के बाद शुद्ध बचा = original × (1 − r/total)^n"}$j$),
    (7, 'govt_technical', 'mix-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"₹30/kg और ₹50/kg चाय को किस अनुपात में मिलाएँ कि मिश्रण ₹42/kg हो?","solution":"Cheap:Dear = (50−42):(42−30) = 8:12 = 2:3","answer":"2:3 अनुपात"}$j$),
    (7, 'govt_technical', 'mix-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"20L में 25% water मिलाना है। कितना water?","options":["4L","5L","6L","7L"],"answer":1,"explanation":"25% of 20 = 5L water"},{"q":"₹60 और ₹80 की चीज़ें 1:1 में मिलीं। mean price?","options":["₹65","₹68","₹70","₹72"],"answer":2,"explanation":"(60+80)/2 = 70"}]}$j$),
    (7, 'govt_basic', 'mix-concept', 'concept', 1, 'मिश्रण',
     $j${"text":"मिश्रण में दो या ज़्यादा चीज़ें मिलाई जाती हैं। अगर ₹20 और ₹30 की चीज़ें 1:1 में मिलाएँ, तो mean = ₹25।","note":"Alligation में ratios से mean price निकालते हैं।"}$j$),
    (7, 'govt_basic', 'mix-formula', 'formula', 2, 'मिश्रण का सूत्र',
     $j${"formula":"Mean = (q₁p₁ + q₂p₂) / (q₁ + q₂)","explanation":"q = quantity, p = price"}$j$),
    (7, 'govt_basic', 'mix-example', 'example', 3, 'उदाहरण',
     $j${"question":"₹40 के 2 kg और ₹60 के 3 kg मिलाए। mean price?","solution":"(2×40 + 3×60) / 5 = (80+180)/5","answer":"₹52/kg"}$j$),
    (7, 'govt_basic', 'mix-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"₹10 और ₹20 की 1:1 mixture का mean?","options":["₹12","₹15","₹18","₹20"],"answer":1,"explanation":"(10+20)/2 = 15"},{"q":"40L में 10% water। पानी की मात्रा?","options":["2L","3L","4L","5L"],"answer":2,"explanation":"10% of 40 = 4L"}]}$j$),
    (7, null, 'mix-diagram', 'svg', 5, 'Alligation Cross',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><text x='40' y='45' fill='#60a5fa' font-size='13' font-weight='bold'>₹30</text><text x='40' y='90' fill='#14b8a6' font-size='13' font-weight='bold'>₹50</text><text x='150' y='68' fill='#f59e0b' font-size='15' font-weight='bold'>₹42</text><text x='260' y='45' fill='#14b8a6' font-size='13' font-weight='bold'>8</text><text x='260' y='90' fill='#60a5fa' font-size='13' font-weight='bold'>12</text><line x1='90' y1='40' x2='250' y2='85' stroke='#64748b'/><line x1='90' y1='85' x2='250' y2='40' stroke='#64748b'/><text x='150' y='110' text-anchor='middle' fill='#64748b' font-size='11'>30:50 = 8:12 = 2:3</text></svg>","caption":"Alligation: 8:12 = 2:3 में मिलाएँ"}$j$),

    -- ═══ Ch 8: Time & Work, Pipes ═══
    (8, 'govt_technical', 'tw-concept', 'concept', 1, 'समय-कार्य — SSC JE / RRB JE',
     $j${"text":"अगर A काम x दिन में करता है, तो 1 दिन में 1/x काम। Combined rate = 1/x + 1/y। Time = xy/(x+y)। Pipes: भरने वाले +, खाली करने वाले −। Alternate days में अलग-अलग rate।","note":"JE में efficiency, wages, और pipe leak problems आते हैं।"}$j$),
    (8, 'govt_technical', 'tw-formula', 'formula', 2, 'समय-कार्य सूत्र',
     $j${"formula":"1/x + 1/y = 1/t · t = xy/(x+y)","explanation":"Efficiency ∝ 1/time · Wages ∝ work · Leak: fill − leak"}$j$),
    (8, 'govt_technical', 'tw-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"A 12 दिन, B 18 दिन। साथ में कितने दिन?","solution":"1/12 + 1/18 = 3/36 + 2/36 = 5/36। t = 36/5","answer":"7.2 दिन"}$j$),
    (8, 'govt_technical', 'tw-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"A 10 दिन, B 15 दिन। साथ में?","options":["5","6","7","8"],"answer":1,"explanation":"1/10+1/15 = 3/30+2/30 = 5/30 = 1/6, so 6 days"},{"q":"Pipe A 6h, B 4h भरता है, leak 12h में खाली। सब साथ?","options":["2h","3h","4h","6h"],"answer":1,"explanation":"1/6+1/4−1/12 = 2/12+3/12−1/12 = 4/12 = 1/3, so 3h"}]}$j$),
    (8, 'govt_basic', 'tw-concept', 'concept', 1, 'समय और कार्य',
     $j${"text":"अगर A काम 5 दिन में करता है, तो 1 दिन में 1/5 काम। अगर B 10 दिन में करता है, तो साथ में 1/5+1/10 = 3/10 काम प्रतिदिन।","note":"Combined time = xy/(x+y)"}$j$),
    (8, 'govt_basic', 'tw-formula', 'formula', 2, 'कार्य का सूत्र',
     $j${"formula":"1/A + 1/B = 1/T","explanation":"A, B अलग-अलग दिन, T साथ में"}$j$),
    (8, 'govt_basic', 'tw-example', 'example', 3, 'उदाहरण',
     $j${"question":"A 4 दिन, B 6 दिन। साथ में कितने दिन?","solution":"1/4+1/6 = 3/12+2/12 = 5/12। T = 12/5","answer":"2.4 दिन"}$j$),
    (8, 'govt_basic', 'tw-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"A 2 दिन, B 4 दिन। साथ में?","options":["1.33","1.5","2","3"],"answer":0,"explanation":"1/2+1/4=3/4, T=4/3≈1.33"},{"q":"Combined rate formula?","options":["1/A+1/B","A+B","A×B","A/B"],"answer":0,"explanation":"1/T = 1/A + 1/B"}]}$j$),
    (8, null, 'tw-diagram', 'svg', 5, 'कार्य दर',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='40' y='40' width='80' height='30' fill='#60a5fa'/><text x='80' y='60' text-anchor='middle' fill='white' font-size='12' font-weight='bold'>A: 1/12</text><rect x='40' y='80' width='120' height='30' fill='#14b8a6'/><text x='100' y='100' text-anchor='middle' fill='white' font-size='12' font-weight='bold'>B: 1/18</text><text x='220' y='65' fill='#f59e0b' font-size='12'>+ = 1/7.2</text></svg>","caption":"Combined rate = sum of individual rates"}$j$)
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
-- select chapter_id, level_id, count(*) from mtb.atoms
-- where chapter_id in (4,5,6,7,8) and status='published' and not archived
-- group by 1,2 order by 1,2;
-- Expected per chapter: govt_technical=4, govt_basic=4, NULL=1
-- Total: 45 new atoms
