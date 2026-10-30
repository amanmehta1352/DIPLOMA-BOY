with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    (4, 'state_psc', 'ratio-psc-concept', 'concept', 1, 'अनुपात — State PSC',
     $j${"text":"Ratio a:b, proportion a:b::c:d (ad=bc)। Componendo-dividendo: (a+b)/(a-b) = (c+d)/(c-d)। Mean proportional: √(ab)। Partnership: profit ∝ investment×time। Variation: direct (y=kx), inverse (y=k/x)।","note":"State PSC में ratio division और partnership ज़रूरी हैं।"}$j$),
    (4, 'state_psc', 'ratio-psc-formula', 'formula', 2, 'अनुपात सूत्र',
     $j${"formula":"a:b divide N → shares = Na/(a+b), Nb/(a+b) · a/b=c/d → ad=bc · Mean prop = √(ab)","explanation":"Componendo-dividendo: (a+b)/(a-b) = (c+d)/(c-d) · Partnership: P ∝ inv×time"}$j$),
    (4, 'state_psc', 'ratio-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"₹1200 को 2:3:5 में। Largest?","solution":"Total=10, largest = 1200×5/10","answer":"₹600"}$j$),
    (4, 'state_psc', 'ratio-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"4 और 9 का mean prop?","options":["6","6.5","13","36"],"answer":0,"explanation":"√(36) = 6"},{"q":"A:B=2:3, B:C=4:5। A:C?","options":["8:15","2:5","3:4","4:5"],"answer":0,"explanation":"A:B:C=8:12:15 → A:C=8:15"}]}$j$),

    (5, 'state_psc', 'avg-psc-concept', 'concept', 1, 'औसत — State PSC',
     $j${"text":"AM ≥ GM ≥ HM (equality if all equal)। Weighted average: (Σwx)/(Σw)। Avg speed (equal D) = HM = 2v₁v₂/(v₁+v₂)। First n naturals = (n+1)/2, odd = n, even = n+1।","note":"State PSC में AM-GM-HM और weighted average ज़रूरी हैं।"}$j$),
    (5, 'state_psc', 'avg-psc-formula', 'formula', 2, 'औसत सूत्र',
     $j${"formula":"AM = Σx/n · GM = (Πx)^(1/n) · HM = n/Σ(1/x) · AM ≥ GM ≥ HM","explanation":"Equal distance: avg speed = HM (not arithmetic mean)"}$j$),
    (5, 'state_psc', 'avg-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Equal D 60, 40 km/h। Avg?","solution":"2×60×40/100","answer":"48 km/h"}$j$),
    (5, 'state_psc', 'avg-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"2 और 8 का GM?","options":["4","5","6","5.5"],"answer":0,"explanation":"√16 = 4"},{"q":"5 संख्या avg 20। Sum?","options":["80","100","120","150"],"answer":1,"explanation":"20×5 = 100"}]}$j$),

    (6, 'state_psc', 'age-psc-concept', 'concept', 1, 'आयु — State PSC',
     $j${"text":"Present x, past x-n, future x+n। Two-variable equations। Ratio across time: (x+n)/(y+n)=p/q. If 'a times now, b times later': a·x+n = b(x+n)।","note":"State PSC में age ratio और equations ज़रूरी हैं।"}$j$),
    (6, 'state_psc', 'age-psc-formula', 'formula', 2, 'आयु सूत्र',
     $j${"formula":"Present=x · Past=x-n · Future=x+n · a·x+n = b(x+n)","explanation":"Solve: x = n(b-1)/(a-b) for a-times-now-b-times-later"}$j$),
    (6, 'state_psc', 'age-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Father 3× son; 12y later 2×। Father now?","solution":"3x+12=2(x+12) → x=12, Father=36","answer":"36 years"}$j$),
    (6, 'state_psc', 'age-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"A 30, B 10। 10 साल बाद A:B?","options":["3:1","2:1","4:3","1:2"],"answer":1,"explanation":"40:20 = 2:1"},{"q":"A 32, B 8। कब A=3B?","solution":"32+n=3(8+n) → 8=2n → n=4","options":["2y","4y","6y","8y"],"answer":1,"explanation":"After 4 years"}]}$j$),

    (7, 'state_psc', 'mix-psc-concept', 'concept', 1, 'मिश्रण — State PSC',
     $j${"text":"Alligation: cheap:dear = (dear-mean):(mean-cheap)। Replacement: final = initial × (1-r/V)ⁿ। Mixture concentration problems। Mean price = weighted average।","note":"State PSC में alligation cross और replacement ज़रूरी हैं।"}$j$),
    (7, 'state_psc', 'mix-psc-formula', 'formula', 2, 'मिश्रण सूत्र',
     $j${"formula":"cheap:dear = (dear-mean):(mean-cheap) · Replacement: final = initial × (1-r/V)ⁿ","explanation":"Mean price: (q₁p₁+q₂p₂)/(q₁+q₂)"}$j$),
    (7, 'state_psc', 'mix-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"₹40, ₹60 → mean 45। Ratio?","solution":"(60-45):(45-40) = 15:5","answer":"3:1"}$j$),
    (7, 'state_psc', 'mix-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"₹30, ₹50 → 42। Ratio?","options":["2:3","3:2","1:1","4:5"],"answer":0,"explanation":"8:12 = 2:3"},{"q":"20L, 25% water। Water?","options":["2L","3L","4L","5L"],"answer":3,"explanation":"25% of 20 = 5L"}]}$j$),

    (8, 'state_psc', 'tw-psc-concept', 'concept', 1, 'समय-कार्य — State PSC',
     $j${"text":"1/x + 1/y = 1/t → t = xy/(x+y)। Efficiency ∝ 1/time। Wages ∝ work done। Alternate work, pipes (fill +, drain -)।","note":"State PSC में combined work और pipes ज़रूरी हैं।"}$j$),
    (8, 'state_psc', 'tw-psc-formula', 'formula', 2, 'कार्य सूत्र',
     $j${"formula":"1/x + 1/y = 1/t → t = xy/(x+y)","explanation":"Efficiency ratio inversely proportional to time · Wages proportional to work"}$j$),
    (8, 'state_psc', 'tw-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"A 10d, B 15d। Together?","solution":"10×15/25","answer":"6 days"}$j$),
    (8, 'state_psc', 'tw-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"A 6d, B 3d। Together?","options":["1d","2d","3d","4d"],"answer":1,"explanation":"1/6+1/3 = 1/2 → 2d"},{"q":"Pipes fill 4h, drain 6h। Both?","options":["8h","10h","12h","14h"],"answer":2,"explanation":"1/4-1/6 = 1/12 → 12h"}]}$j$),

    (9, 'state_psc', 'tsd-psc-concept', 'concept', 1, 'चाल-दूरी — State PSC',
     $j${"text":"v=d/t। Avg speed (equal D) = HM = 2v₁v₂/(v₁+v₂)। Relative: same |v₁-v₂|, opposite v₁+v₂। Train: pole L/v, platform (L+P)/v। Boat: down b+s, up b-s।","note":"State PSC में avg speed, trains, और boats ज़रूरी हैं।"}$j$),
    (9, 'state_psc', 'tsd-psc-formula', 'formula', 2, 'चाल सूत्र',
     $j${"formula":"v = d/t · Avg (equal D) = 2v₁v₂/(v₁+v₂) · Relative: |v₁−v₂| (same), v₁+v₂ (opp) · Boat down b+s, up b-s","explanation":"1 km/h = 5/18 m/s · 1 m/s = 18/5 km/h"}$j$),
    (9, 'state_psc', 'tsd-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"100m train 10 m/s, 200m platform। Time?","solution":"(100+200)/10","answer":"30 sec"}$j$),
    (9, 'state_psc', 'tsd-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Avg 60, 40 equal D?","options":["48","50","52","55"],"answer":0,"explanation":"2×60×40/100 = 48"},{"q":"36 km/h in m/s?","options":["8","10","12","15"],"answer":1,"explanation":"36×5/18 = 10"}]}$j$),

    (10, 'state_psc', 'num-psc-concept', 'concept', 1, 'संख्या पद्धति — State PSC',
     $j${"text":"HCF×LCM = a×b। Divisors of p^a·q^b = (a+1)(b+1)। Divisibility: 2,3,4,5,9,11। Units digit cyclicity: 2,3,7,8 (4), 4,9 (2), 5,6,0,1 (1)। Remainder theorem। Binary, octal, hex।","note":"State PSC में HCF-LCM, divisibility, और cyclicity ज़रूरी हैं।"}$j$),
    (10, 'state_psc', 'num-psc-formula', 'formula', 2, 'संख्या सूत्र',
     $j${"formula":"HCF×LCM = a×b · Divisors = (a+1)(b+1) · Cyclicity: 2,3,7,8 (4); 4,9 (2); 5,6,0,1 (1)","explanation":"Divisibility 11: (odd sum) - (even sum) = 0 or multiple of 11"}$j$),
    (10, 'state_psc', 'num-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"2^100 units digit?","solution":"Cycle 4, 100 mod 4 = 0 → units = 6","answer":"6"}$j$),
    (10, 'state_psc', 'num-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"12, 18 LCM?","options":["24","36","48","72"],"answer":1,"explanation":"LCM = 36"},{"q":"3^100 units?","solution":"Cycle 4, 100 mod 4 = 0 → 1","options":["1","3","7","9"],"answer":0,"explanation":"Cycle ends at 1"}]}$j$),

    (11, 'state_psc', 'simp-psc-concept', 'concept', 1, 'सरलीकरण — State PSC',
     $j${"text":"BODMAS, surds, indices, fractions। aᵐ·aⁿ = aᵐ⁺ⁿ, (aᵐ)ⁿ = aᵐⁿ, a⁰=1, a⁻ᵐ=1/aᵐ। Rationalization: 1/(√a+√b) = (√a-√b)/(a-b)।","note":"State PSC में BODMAS, surds, और rationalization ज़रूरी हैं।"}$j$),
    (11, 'state_psc', 'simp-psc-formula', 'formula', 2, 'सरलीकरण सूत्र',
     $j${"formula":"aᵐ·aⁿ = aᵐ⁺ⁿ · (aᵐ)ⁿ = aᵐⁿ · 1/(√a+√b) = (√a-√b)/(a-b)","explanation":"BODMAS: Bracket → Order → ÷ → × → + → −"}$j$),
    (11, 'state_psc', 'simp-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"√8 + √18?","solution":"2√2 + 3√2","answer":"5√2"}$j$),
    (11, 'state_psc', 'simp-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"3 + 2×4?","options":["14","20","11","24"],"answer":2,"explanation":"2×4=8 पहले, फिर 3+8=11"},{"q":"2^(1/2) × 2^(1/3)?","options":["2^(1/6)","2^(5/6)","2^(2/6)","4"],"answer":1,"explanation":"2^(5/6)"}]}$j$),

    (12, 'state_psc', 'alg-psc-concept', 'concept', 1, 'बीजगणित — State PSC',
     $j${"text":"Quadratic ax²+bx+c=0, roots (-b±√D)/2a, D=b²-4ac. Sum=-b/a, product=c/a. AP: aₙ=a+(n-1)d, Sₙ=n/2[2a+(n-1)d]. GP: aₙ=arⁿ⁻¹. Identities: (a±b)², a²-b².","note":"State PSC में quadratic, AP/GP, और identities ज़रूरी हैं।"}$j$),
    (12, 'state_psc', 'alg-psc-formula', 'formula', 2, 'बीजगणित सूत्र',
     $j${"formula":"x = (-b±√D)/2a, D=b²-4ac · Sum=-b/a, Product=c/a · AP: aₙ=a+(n-1)d","explanation":"GP: aₙ=arⁿ⁻¹ · (a+b)² = a²+2ab+b² · a²-b² = (a+b)(a-b)"}$j$),
    (12, 'state_psc', 'alg-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"x²-5x+6=0 roots?","solution":"D=1, x=(5±1)/2","answer":"2, 3"}$j$),
    (12, 'state_psc', 'alg-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"x²-7x+12=0?","options":["3,4","2,6","1,12","-3,-4"],"answer":0,"explanation":"Sum=7, product=12"},{"q":"AP 2,5,8,...10th?","options":["29","30","32","35"],"answer":0,"explanation":"a₁₀=2+9×3=29"}]}$j$),

    (13, 'state_psc', 'mens-psc-concept', 'concept', 1, 'क्षेत्रमिति — State PSC',
     $j${"text":"2D: rectangle (l×b), circle (πr²), triangle (½bh)। 3D: cuboid (lbh), cylinder (πr²h), sphere (⁴/₃πr³), cone (⅓πr²h)। Surface areas: cylinder CSA=2πrh, TSA=2πr(r+h)। Similar figures: A∝s², V∝s³.","note":"State PSC में 2D/3D formulas ज़रूरी हैं।"}$j$),
    (13, 'state_psc', 'mens-psc-formula', 'formula', 2, 'क्षेत्रमिति सूत्र',
     $j${"formula":"Circle: A=πr², C=2πr · Sphere: V=⁴/₃πr³, A=4πr² · Cylinder: V=πr²h, CSA=2πrh","explanation":"Cone: V=⅓πr²h, CSA=πrl (l=√(r²+h²)) · Triangle: A=½bh"}$j$),
    (13, 'state_psc', 'mens-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Circle r=7 area? (π=22/7)","solution":"22/7 × 49","answer":"154 sq units"}$j$),
    (13, 'state_psc', 'mens-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Square side 5। Area?","options":["10","20","25","30"],"answer":2,"explanation":"5²=25"},{"q":"Rect l=8 b=5। Perimeter?","options":["13","26","40","80"],"answer":1,"explanation":"2×(8+5)=26"}]}$j$),

    (14, 'state_psc', 'geo-psc-concept', 'concept', 1, 'ज्यामिति — State PSC',
     $j${"text":"Triangle: angles sum 180°, types (equilateral, isosceles, scalene)। Pythagoras: a²+b²=c²। Circle: chord, tangent, arc। Quadrilateral: sum 360°। Coordinate geometry: distance, slope.","note":"State PSC में triangle, Pythagoras, और coordinate ज़रूरी हैं।"}$j$),
    (14, 'state_psc', 'geo-psc-formula', 'formula', 2, 'ज्यामिति सूत्र',
     $j${"formula":"Triangle sum=180° · Quad sum=360° · Pythagoras: a²+b²=c² · Distance: √[(x₂-x₁)²+(y₂-y₁)²]","explanation":"Slope: (y₂-y₁)/(x₂-x₁) · Right triangle: 3-4-5, 5-12-13, 8-15-17"}$j$),
    (14, 'state_psc', 'geo-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Right triangle a=6, b=8। c?","solution":"√(36+64) = √100","answer":"10"}$j$),
    (14, 'state_psc', 'geo-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Triangle sum?","options":["90°","180°","270°","360°"],"answer":1,"explanation":"180°"},{"q":"3-4-? right triangle","options":["5","6","7","8"],"answer":0,"explanation":"3-4-5 triple"}]}$j$),

    (15, 'state_psc', 'trig-psc-concept', 'concept', 1, 'त्रिकोणमिति — State PSC',
     $j${"text":"Trig ratios: sin=opp/hyp, cos=adj/hyp, tan=opp/adj। Standard: sin30=1/2, sin45=1/√2, sin60=√3/2, sin90=1। Identity: sin²θ+cos²θ=1। Height-distance problems।","note":"State PSC में trig ratios और standard angles ज़रूरी हैं।"}$j$),
    (15, 'state_psc', 'trig-psc-formula', 'formula', 2, 'त्रिकोणमिति सूत्र',
     $j${"formula":"sin=opp/hyp · cos=adj/hyp · tan=opp/adj=sin/cos · sin²θ+cos²θ=1","explanation":"Standard: sin30=1/2, sin45=1/√2, sin60=√3/2 · tan45=1"}$j$),
    (15, 'state_psc', 'trig-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"sin30 + cos60?","solution":"1/2 + 1/2","answer":"1"}$j$),
    (15, 'state_psc', 'trig-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"sin45?","options":["1/2","1/√2","√3/2","1"],"answer":1,"explanation":"1/√2"},{"q":"tan45?","options":["0","1","√3","1/√3"],"answer":1,"explanation":"tan45 = 1"}]}$j$),

    (16, 'state_psc', 'stat-psc-concept', 'concept', 1, 'सांख्यिकी — State PSC',
     $j${"text":"Mean = Σx/n. Median = middle value (sorted)। Mode = most frequent। Range = max-min. Variance σ² = Σ(x-μ)²/n। SD = √variance। CV = σ/mean × 100%.","note":"State PSC में mean, median, mode, और SD ज़रूरी हैं।"}$j$),
    (16, 'state_psc', 'stat-psc-formula', 'formula', 2, 'सांख्यिकी सूत्र',
     $j${"formula":"Mean = Σx/n · Median = middle · Mode = most frequent · σ² = Σ(x-μ)²/n","explanation":"SD = √σ² · CV = (σ/mean) × 100% (relative variability)"}$j$),
    (16, 'state_psc', 'stat-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"2, 4, 6, 8, 10 mean?","solution":"30/5","answer":"6"}$j$),
    (16, 'state_psc', 'stat-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"1,2,3,4,5 median?","options":["2","3","4","5"],"answer":1,"explanation":"Middle = 3"},{"q":"3,5,5,7 mode?","options":["3","5","7","4"],"answer":1,"explanation":"5 twice"}]}$j$),

    (429, 'state_psc', 'seat-psc-concept', 'concept', 1, 'बैठक व्यवस्था — State PSC',
     $j${"text":"Linear (row), circular (facing center/outside)। 'Between' = |pos1-pos2|-1. Fixed positions first. State PSC में 1-2 questions।","note":"State PSC में arrangement logic ज़रूरी है।"}$j$),
    (429, 'state_psc', 'seat-psc-formula', 'formula', 2, 'Arrangement सूत्र',
     $j${"formula":"Between = |pos1 - pos2| - 1 · Circular (N): (N-1)!","explanation":"Facing center: left = clockwise · Facing outside: left = anti-clockwise"}$j$),
    (429, 'state_psc', 'seat-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"5 row। A 1st, B 5th। Between?","solution":"|5-1|-1 = 3","answer":"3"}$j$),
    (429, 'state_psc', 'seat-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"6 row। A 2nd, B 5th। Between?","options":["2","3","4","5"],"answer":0,"explanation":"|5-2|-1 = 2"},{"q":"Circular 4 people arrangements?","options":["4!","3!","4²","4"],"answer":1,"explanation":"(N-1)! = 3!"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[],
  case when s.chapter_id < 20 then 'maths' 
       when s.chapter_id = 429 then 'reasoning' 
       else 'general-science' end,
  'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, count(*) from mtb.atoms 
-- where chapter_id in (4,5,6,7,8,9,10,11,12,13,14,15,16,429) 
--   and level_id='state_psc' and status='published' and not archived 
-- group by 1 order by 1;
-- Expected: each chapter = 4 (14 chapters = 56 atoms)

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: ~2564 + 56 = ~2620
