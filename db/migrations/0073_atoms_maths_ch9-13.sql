-- Maths chapters 9-13: Speed-Distance, Number System, Simplification, Algebra, Mensuration
-- 5 chapters × 9 atoms = 45 atoms

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ Ch 9: Speed, Time, Distance ═══
    (9, 'govt_technical', 'tsd-concept', 'concept', 1, 'चाल-समय-दूरी — SSC JE / RRB JE',
     $j${"text":"चाल = दूरी/समय। Average speed = कुल दूरी/कुल समय (individual speeds का average नहीं)। Relative speed: same direction → |a−b|, opposite → a+b। Train: pole पार करने में L/v, platform पार करने में (L+platform)/v।","note":"JE में boats-stream, trains, और relative speed वाले numericals आते हैं।"}$j$),
    (9, 'govt_technical', 'tsd-formula', 'formula', 2, 'चाल के सूत्र',
     $j${"formula":"Speed = D/T · Avg speed = Total D / Total T · Relative (same dir) = |S₁−S₂| · Boat: downstream = b+s, upstream = b−s","explanation":"km/h → m/s: × 5/18 · m/s → km/h: × 18/5"}$j$),
    (9, 'govt_technical', 'tsd-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"120 km, 2 घंटे। Speed? m/s में?","solution":"Speed = 120/2 = 60 km/h। m/s = 60 × 5/18","answer":"60 km/h = 16.67 m/s"}$j$),
    (9, 'govt_technical', 'tsd-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"60 km/h कितने m/s है?","options":["15","16.67","18","20"],"answer":1,"explanation":"60 × 5/18 = 300/18 = 16.67 m/s"},{"q":"100m लंबी ट्रेन 36 km/h से 200m प्लेटफॉर्म पार करे। समय?","options":["20s","25s","30s","35s"],"answer":2,"explanation":"Speed = 36×5/18 = 10 m/s। Distance = 100+200 = 300m। Time = 300/10 = 30s"}]}$j$),
    (9, 'govt_basic', 'tsd-concept', 'concept', 1, 'चाल-समय-दूरी',
     $j${"text":"चाल = दूरी ÷ समय। 100 km, 2 घंटे → चाल = 50 km/h। याद रखो: km/h को m/s में बदलने के लिए 5/18 से गुणा करो।","note":"same direction में relative speed = difference, opposite = sum"}$j$),
    (9, 'govt_basic', 'tsd-formula', 'formula', 2, 'चाल का सूत्र',
     $j${"formula":"Speed = Distance / Time","explanation":"D = S×T · T = D/S"}$j$),
    (9, 'govt_basic', 'tsd-example', 'example', 3, 'उदाहरण',
     $j${"question":"240 km, 4 घंटे। चाल?","solution":"240/4","answer":"60 km/h"}$j$),
    (9, 'govt_basic', 'tsd-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"120 km, 2 घंटे। चाल?","options":["50","55","60","65"],"answer":2,"explanation":"120/2 = 60 km/h"},{"q":"36 km/h कितने m/s?","options":["8","10","12","15"],"answer":1,"explanation":"36 × 5/18 = 10 m/s"}]}$j$),
    (9, null, 'tsd-diagram', 'svg', 5, 'चाल-दूरी-समय',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><line x1='30' y1='60' x2='270' y2='60' stroke='#64748b' stroke-width='2'/><circle cx='50' cy='60' r='6' fill='#60a5fa'/><circle cx='250' cy='60' r='6' fill='#14b8a6'/><text x='150' y='50' text-anchor='middle' fill='#f59e0b' font-size='12' font-weight='bold'>Distance</text><text x='150' y='90' text-anchor='middle' fill='#64748b' font-size='11'>Speed = D/T</text></svg>","caption":"चाल = दूरी ÷ समय"}$j$),

    -- ═══ Ch 10: Number System, LCM-HCF ═══
    (10, 'govt_technical', 'num-concept', 'concept', 1, 'संख्या पद्धति — SSC JE / RRB JE',
     $j${"text":"LCM × HCF = a × b (दो संख्याओं के लिए)। HCF कोई भी common factor का सबसे बड़ा, LCM सबसे छोटा common multiple। Division algorithm: Dividend = Divisor × Quotient + Remainder। Divisibility: 2(unit even), 3(sum÷3), 4(last 2÷4), 5(unit 0/5), 9(sum÷9), 11(alternating sum)।","note":"JE में HCF-LCM, remainder, और unit digit वाले problems आते हैं।"}$j$),
    (10, 'govt_technical', 'num-formula', 'formula', 2, 'संख्या पद्धति सूत्र',
     $j${"formula":"HCF(a,b) × LCM(a,b) = a × b","explanation":"Dividend = Divisor×Q + R · Three numbers: LCM ≥ HCF always"}$j$),
    (10, 'govt_technical', 'num-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"12 और 18 का HCF और LCM?","solution":"12=2²×3, 18=2×3²। HCF=2×3=6। LCM=2²×3²=36","answer":"HCF=6, LCM=36 (check: 6×36=216=12×18 ✅)"}$j$),
    (10, 'govt_technical', 'num-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"15 और 20 का LCM?","options":["30","45","60","75"],"answer":2,"explanation":"15=3×5, 20=2²×5। LCM=2²×3×5=60"},{"q":"किसी संख्या का 4 से divisibility?","options":["अंतिम अंक सम","अंतिम 2 अंक 4 से","अंकों का योग 4 से","कोई नहीं"],"answer":1,"explanation":"अंतिम 2 अंक 4 से विभाज्य होने चाहिए"}]}$j$),
    (10, 'govt_basic', 'num-concept', 'concept', 1, 'संख्या पद्धति',
     $j${"text":"HCF = सबसे बड़ा common factor, LCM = सबसे छोटा common multiple। Divisibility: 2 (even), 3 (sum), 5 (0/5), 10 (0)।","note":"HCF × LCM = product of two numbers"}$j$),
    (10, 'govt_basic', 'num-formula', 'formula', 2, 'HCF-LCM सूत्र',
     $j${"formula":"HCF × LCM = a × b","explanation":"दो संख्याओं के लिए हमेशा सही"}$j$),
    (10, 'govt_basic', 'num-example', 'example', 3, 'उदाहरण',
     $j${"question":"6 और 8 का LCM?","solution":"Multiples of 6: 6,12,18,24. Multiples of 8: 8,16,24. Common: 24","answer":"LCM = 24"}$j$),
    (10, 'govt_basic', 'num-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"12 और 18 का HCF?","options":["2","3","6","9"],"answer":2,"explanation":"12=2²×3, 18=2×3²। Common = 2×3 = 6"},{"q":"कौन सी संख्या 3 से विभाज्य है?","options":["124","125","126","127"],"answer":2,"explanation":"1+2+6 = 9, 9÷3 = 3 ✅"}]}$j$),
    (10, null, 'num-diagram', 'svg', 5, 'HCF-LCM',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><circle cx='100' cy='60' r='40' fill='#60a5fa' opacity='0.5'/><circle cx='160' cy='60' r='40' fill='#14b8a6' opacity='0.5'/><text x='100' y='65' text-anchor='middle' fill='white' font-size='12'>12</text><text x='160' y='65' text-anchor='middle' fill='white' font-size='12'>18</text><text x='130' y='65' text-anchor='middle' fill='#f59e0b' font-size='11' font-weight='bold'>6</text><text x='150' y='110' text-anchor='middle' fill='#64748b' font-size='11'>HCF=6, LCM=36</text></svg>","caption":"HCF intersection में, LCM union"}$j$),

    -- ═══ Ch 11: Simplification ═══
    (11, 'govt_technical', 'simp-concept', 'concept', 1, 'सरलीकरण — SSC JE / RRB JE',
     $j${"text":"BODMAS: Bracket → Of → Division → Multiplication → Addition → Subtraction। Surds: √a × √b = √(ab)। Fraction comparison: cross-multiply। JE में nested brackets, fractions, और decimals आते हैं।","note":"Simplification में order बहुत important है — 2+3×4 = 14, न कि 20"}$j$),
    (11, 'govt_technical', 'simp-formula', 'formula', 2, 'BODMAS सूत्र',
     $j${"formula":"(a/b) ÷ (c/d) = (a×d)/(b×c) · a^(m/n) = ⁿ√(aᵐ)","explanation":"√a × √b = √(ab) · √a / √b = √(a/b)"}$j$),
    (11, 'govt_technical', 'simp-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"(2/3) × (9/4) ÷ (3/2)?","solution":"(2/3)×(9/4) = 18/12 = 3/2। (3/2)÷(3/2) = 1","answer":"1"}$j$),
    (11, 'govt_technical', 'simp-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"2 + 3 × 4 = ?","options":["14","20","24","9"],"answer":0,"explanation":"BODMAS: 3×4=12 पहले, फिर 2+12=14"},{"q":"√16 + √25 = ?","options":["9","41","√41","10"],"answer":0,"explanation":"√16=4, √25=5, 4+5=9"}]}$j$),
    (11, 'govt_basic', 'simp-concept', 'concept', 1, 'सरलीकरण',
     $j${"text":"पहले bracket, फिर ÷, फिर ×, फिर +, फिर −. 2+3×4 में पहले 3×4=12, फिर 2+12=14।","note":"BODMAS order याद रखो"}$j$),
    (11, 'govt_basic', 'simp-formula', 'formula', 2, 'भिन्न सरलीकरण',
     $j${"formula":"a/b ÷ c/d = a/b × d/c","explanation":"भाग को गुणा में बदलने के लिए दूसरी भिन्न उलट दो"}$j$),
    (11, 'govt_basic', 'simp-example', 'example', 3, 'उदाहरण',
     $j${"question":"(1/2) + (1/3)?","solution":"LCM=6। (3/6)+(2/6)","answer":"5/6"}$j$),
    (11, 'govt_basic', 'simp-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"5 + 2 × 3 = ?","options":["11","21","16","10"],"answer":0,"explanation":"2×3=6 पहले, 5+6=11"},{"q":"(2/3) + (1/3)?","options":["1/2","2/3","1","3/3"],"answer":2,"explanation":"2/3+1/3 = 3/3 = 1"}]}$j$),
    (11, null, 'simp-diagram', 'svg', 5, 'BODMAS',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><text x='150' y='30' text-anchor='middle' fill='#f59e0b' font-size='13' font-weight='bold'>B O D M A S</text><line x1='40' y1='45' x2='260' y2='45' stroke='#64748b'/><text x='60' y='70' fill='#60a5fa' font-size='11'>Bracket</text><text x='130' y='70' fill='#14b8a6' font-size='11'>Of</text><text x='170' y='70' fill='#a78bfa' font-size='11'>Div</text><text x='220' y='70' fill='#f472b6' font-size='11'>Mul</text><text x='60' y='95' fill='#fbbf24' font-size='11'>Add</text><text x='130' y='95' fill='#fb7185' font-size='11'>Sub</text></svg>","caption":"BODMAS: पहले bracket, अंत में subtraction"}$j$),

    -- ═══ Ch 12: Algebra ═══
    (12, 'govt_technical', 'alg-concept', 'concept', 1, 'बीजगणित — SSC JE / RRB JE',
     $j${"text":"Identity: (a+b)² = a²+2ab+b², (a−b)² = a²−2ab+b², a²−b² = (a+b)(a−b)। Linear equation ax+b=0 → x=−b/a। Quadratic ax²+bx+c=0 → x = (−b±√(b²−4ac))/(2a)। Sum of roots = −b/a, product = c/a।","note":"JE में identity-based simplification, quadratic, और simultaneous equations आते हैं।"}$j$),
    (12, 'govt_technical', 'alg-formula', 'formula', 2, 'बीजगणित identities',
     $j${"formula":"(a+b)² = a²+2ab+b² · (a−b)² = a²−2ab+b² · a²−b² = (a+b)(a−b) · (a+b)³ = a³+3a²b+3ab²+b³","explanation":"Quadratic: x = (−b±√(b²−4ac))/2a · Discriminant D=b²−4ac"}$j$),
    (12, 'govt_technical', 'alg-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"अगर x + 1/x = 3, तो x² + 1/x² = ?","solution":"(x+1/x)² = x²+2+1/x²। 9 = x²+1/x²+2","answer":"x²+1/x² = 7"}$j$),
    (12, 'govt_technical', 'alg-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"x²−9 का factor?","options":["(x−3)²","(x+3)(x−3)","(x+9)(x−1)","x(x−9)"],"answer":1,"explanation":"a²−b² = (a+b)(a−b), यहाँ 9=3²"},{"q":"x²−5x+6=0 के roots?","options":["1,6","2,3","−2,−3","−1,−6"],"answer":1,"explanation":"Sum=5, product=6 → 2 और 3"}]}$j$),
    (12, 'govt_basic', 'alg-concept', 'concept', 1, 'बीजगणित',
     $j${"text":"(a+b)² = a²+2ab+b², (a−b)² = a²−2ab+b², a²−b² = (a+b)(a−b)। जैसे (x+2)² = x²+4x+4।","note":"Basic identities याद रखो"}$j$),
    (12, 'govt_basic', 'alg-formula', 'formula', 2, 'बीजगणित सूत्र',
     $j${"formula":"(a+b)² = a²+2ab+b² · a²−b² = (a+b)(a−b)","explanation":"(a−b)² = a²−2ab+b²"}$j$),
    (12, 'govt_basic', 'alg-example', 'example', 3, 'उदाहरण',
     $j${"question":"(x+3)² expand करो।","solution":"x² + 2×3×x + 3²","answer":"x²+6x+9"}$j$),
    (12, 'govt_basic', 'alg-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"(x+2)² = ?","options":["x²+4","x²+4x+4","x²+2x+4","x²+4x+2"],"answer":1,"explanation":"(a+b)² = a²+2ab+b², a=x b=2"},{"q":"x²−4 = ?","options":["(x−2)²","(x+2)(x−2)","x(x−4)","(x+4)(x−1)"],"answer":1,"explanation":"a²−b² identity, 4=2²"}]}$j$),
    (12, null, 'alg-diagram', 'svg', 5, 'Algebra identity',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='40' y='30' width='80' height='80' fill='#60a5fa' opacity='0.6'/><rect x='120' y='30' width='60' height='40' fill='#14b8a6' opacity='0.6'/><rect x='120' y='70' width='40' height='40' fill='#f59e0b' opacity='0.6'/><rect x='160' y='70' width='20' height='40' fill='#a78bfa' opacity='0.6'/><text x='80' y='75' text-anchor='middle' fill='white' font-size='12' font-weight='bold'>a²</text><text x='150' y='55' text-anchor='middle' fill='white' font-size='12'>ab</text><text x='140' y='95' text-anchor='middle' fill='white' font-size='11'>ab</text><text x='170' y='95' text-anchor='middle' fill='white' font-size='11'>b²</text></svg>","caption":"(a+b)² = a² + 2ab + b²"}$j$),

    -- ═══ Ch 13: Mensuration ═══
    (13, 'govt_technical', 'mens-concept', 'concept', 1, 'क्षेत्रमिति — SSC JE / RRB JE',
     $j${"text":"2D: Rectangle = l×b, Circle = πr², Triangle = ½×b×h। 3D: Cuboid V=lbh, Cylinder V=πr²h, Sphere V=⁴⁄₃πr³। Surface area: Cylinder CSA=2πrh, TSA=2πr(r+h)। JE में volume, area, और cost problems आते हैं।","note":"π=22/7 या 3.14 · पाइप: flow = area × velocity"}$j$),
    (13, 'govt_technical', 'mens-formula', 'formula', 2, 'क्षेत्रमिति सूत्र',
     $j${"formula":"Circle: A=πr², C=2πr · Cylinder: V=πr²h, CSA=2πrh · Sphere: V=⁴⁄₃πr³, A=4πr²","explanation":"Triangle: A=½bh · Rectangle: A=l×b · Cuboid: V=lbh"}$j$),
    (13, 'govt_technical', 'mens-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"7cm radius cylinder, 10cm height। Volume?","solution":"V = πr²h = (22/7)×7²×10 = 22×7×10","answer":"1540 cm³"}$j$),
    (13, 'govt_technical', 'mens-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"r=7 circle का area? (π=22/7)","options":["154","144","132","176"],"answer":0,"explanation":"πr² = 22/7 × 49 = 22×7 = 154"},{"q":"l=5, b=3, h=2 cuboid का volume?","options":["15","20","30","60"],"answer":2,"explanation":"V = lbh = 5×3×2 = 30"}]}$j$),
    (13, 'govt_basic', 'mens-concept', 'concept', 1, 'क्षेत्रमिति',
     $j${"text":"Rectangle area = length × breadth। Circle area = πr², circumference = 2πr। Square = side², side³ (volume)।","note":"π = 22/7 लो जब radius 7 का multiple हो"}$j$),
    (13, 'govt_basic', 'mens-formula', 'formula', 2, 'क्षेत्रमिति सूत्र',
     $j${"formula":"Rectangle: A=l×b · Square: A=a² · Circle: A=πr²","explanation":"Triangle: A=½×base×height"}$j$),
    (13, 'govt_basic', 'mens-example', 'example', 3, 'उदाहरण',
     $j${"question":"l=10, b=5 rectangle का area?","solution":"10 × 5","answer":"50 वर्ग इकाई"}$j$),
    (13, 'govt_basic', 'mens-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"Square (side=4) का area?","options":["8","12","16","20"],"answer":2,"explanation":"4² = 16"},{"q":"Circle r=14 का circumference? (π=22/7)","options":["44","66","88","154"],"answer":2,"explanation":"2πr = 2×22/7×14 = 88"}]}$j$),
    (13, null, 'mens-diagram', 'svg', 5, 'Mensuration basic',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='30' y='40' width='70' height='40' fill='#60a5fa' opacity='0.6'/><text x='65' y='65' text-anchor='middle' fill='white' font-size='11'>l×b</text><circle cx='160' cy='60' r='30' fill='#14b8a6' opacity='0.6'/><text x='160' y='65' text-anchor='middle' fill='white' font-size='11'>πr²</text><polygon points='240,90 270,90 255,50' fill='#f59e0b' opacity='0.6'/><text x='255' y='80' text-anchor='middle' fill='white' font-size='10'>½bh</text></svg>","caption":"Rectangle, Circle, Triangle areas"}$j$)
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
-- where chapter_id in (9,10,11,12,13) and status='published' and not archived
-- group by 1,2 order by 1,2;
-- Expected per chapter: govt_technical=4, govt_basic=4, NULL=1
