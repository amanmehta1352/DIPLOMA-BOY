with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ CLASS 9-10 MATHS (7-16) ═══
    (7, 'class_9_10', 'mix-910-concept', 'concept', 1, 'मिश्रण — Class 9-10',
     $j${"text":"Mixture: दो या ज़्यादा substances मिले। Alligation: दो prices के items mix करके mean price। Ratio of cheap : dear = (dear price - mean) : (mean - cheap price)।","note":"Board में alligation cross method ज़रूरी है।"}$j$),
    (7, 'class_9_10', 'mix-910-formula', 'formula', 2, 'मिश्रण सूत्र',
     $j${"formula":"Cheap:Dear = (dear - mean) : (mean - cheap) · Mean price = (q₁p₁ + q₂p₂)/(q₁ + q₂)","explanation":"जैसे ₹20 और ₹30 मिलाएँ 1:1 में → mean = 25"}$j$),
    (7, 'class_9_10', 'mix-910-example', 'example', 3, 'Board numerical',
     $j${"question":"₹40 (2kg) + ₹60 (3kg)। Mean price?","solution":"(2×40 + 3×60)/(2+3) = 260/5","answer":"₹52/kg"}$j$),
    (7, 'class_9_10', 'mix-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"₹10 और ₹20 मिलाएँ 1:1। Mean?","options":["12","15","18","20"],"answer":1,"explanation":"(10+20)/2 = 15"},{"q":"Alligation ratio cheap:dear = ?","options":["(mean-cheap):(dear-mean)","(dear-mean):(mean-cheap)","cheap:dear","dear:cheap"],"answer":1,"explanation":"(dear-mean):(mean-cheap)"}]}$j$),

    (8, 'class_9_10', 'tw-910-concept', 'concept', 1, 'समय-कार्य — Class 9-10',
     $j${"text":"Work: अगर A काम x दिन में करता है, 1 दिन में 1/x काम। Combined: 1/x + 1/y = 1/t। Time = xy/(x+y)। Pipes: भरने वाले (+), खाली करने वाले (-)।","note":"Board में combined work और pipes ज़रूरी हैं।"}$j$),
    (8, 'class_9_10', 'tw-910-formula', 'formula', 2, 'कार्य सूत्र',
     $j${"formula":"1/x + 1/y = 1/t → t = xy/(x+y) · Combined rate = sum of individual rates","explanation":"A 10 दिन, B 15 दिन → together t = 150/25 = 6 दिन"}$j$),
    (8, 'class_9_10', 'tw-910-example', 'example', 3, 'Board numerical',
     $j${"question":"A 4d, B 6d। साथ में?","solution":"1/4 + 1/6 = 5/12 → t = 12/5","answer":"2.4 दिन"}$j$),
    (8, 'class_9_10', 'tw-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"A 6d, B 3d। Together?","options":["1d","2d","3d","4d"],"answer":1,"explanation":"1/6+1/3 = 3/6 = 1/2 → 2d"},{"q":"A 12d। 1 day में कितना काम?","options":["1/2","1/6","1/12","12"],"answer":2,"explanation":"1 day = 1/12 of work"}]}$j$),

    (9, 'class_9_10', 'tsd-910-concept', 'concept', 1, 'चाल-दूरी — Class 9-10',
     $j${"text":"Speed = distance/time। Average speed = total distance/total time। Relative speed: same direction = difference, opposite = sum। Train: pole पार = L/v, platform = (L+P)/v। Boat: downstream = b+s, upstream = b-s।","note":"Board में train और boat problems ज़रूरी हैं।"}$j$),
    (9, 'class_9_10', 'tsd-910-formula', 'formula', 2, 'चाल सूत्र',
     $j${"formula":"v = d/t · Relative = |v₁-v₂| (same), v₁+v₂ (opp) · Train pole: L/v · Boat: down=b+s, up=b-s","explanation":"1 km/h = 5/18 m/s · 1 m/s = 18/5 km/h"}$j$),
    (9, 'class_9_10', 'tsd-910-example', 'example', 3, 'Board numerical',
     $j${"question":"120 km, 3 घंटे। Speed?","solution":"v = 120/3","answer":"40 km/h"}$j$),
    (9, 'class_9_10', 'tsd-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"100 km, 2 घंटे। Speed?","options":["25","50","75","100"],"answer":1,"explanation":"100/2 = 50 km/h"},{"q":"36 km/h in m/s?","options":["5","10","15","36"],"answer":1,"explanation":"36 × 5/18 = 10 m/s"}]}$j$),

    (10, 'class_9_10', 'num-910-concept', 'concept', 1, 'संख्या पद्धति — Class 9-10',
     $j${"text":"HCF: सबसे बड़ा common factor। LCM: सबसे छोटा common multiple। HCF × LCM = a × b (दो संख्याओं के लिए)। Divisibility: 2 (even), 3 (sum÷3), 5 (0/5), 9 (sum÷9), 10 (0)।","note":"Board में HCF-LCM और divisibility ज़रूरी हैं।"}$j$),
    (10, 'class_9_10', 'num-910-formula', 'formula', 2, 'संख्या सूत्र',
     $j${"formula":"HCF(a,b) × LCM(a,b) = a × b · Divisibility 3: sum of digits ÷ 3 · Divisibility 9: sum ÷ 9","explanation":"HCF = common prime factors (min power) · LCM = all prime factors (max power)"}$j$),
    (10, 'class_9_10', 'num-910-example', 'example', 3, 'Board numerical',
     $j${"question":"12 और 18 का HCF?","solution":"12=2²×3, 18=2×3²। Common = 2×3","answer":"HCF = 6 (LCM = 36)"}$j$),
    (10, 'class_9_10', 'num-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"15 और 20 का LCM?","options":["30","45","60","75"],"answer":2,"explanation":"15=3×5, 20=2²×5 → LCM=2²×3×5=60"},{"q":"126 3 से divisible?","options":["हाँ","नहीं","कभी-कभी","पता नहीं"],"answer":0,"explanation":"1+2+6=9, 9÷3=3 ✓"}]}$j$),

    (11, 'class_9_10', 'simp-910-concept', 'concept', 1, 'सरलीकरण — Class 9-10',
     $j${"text":"BODMAS: Bracket → Of → Division → Multiplication → Addition → Subtraction। Fractions: add/subtract with LCM, multiply straight, divide by flipping। Decimals: align point।","note":"Board में BODMAS और fractions ज़रूरी हैं।"}$j$),
    (11, 'class_9_10', 'simp-910-formula', 'formula', 2, 'सरलीकरण सूत्र',
     $j${"formula":"a/b ÷ c/d = a/b × d/c · a/b + c/d = (ad + bc)/bd","explanation":"BODMAS order: ब्रैकेट पहले, subtraction अंत में"}$j$),
    (11, 'class_9_10', 'simp-910-example', 'example', 3, 'Board numerical',
     $j${"question":"(2/3) + (1/4) = ?","solution":"LCM=12 → 8/12 + 3/12","answer":"11/12"}$j$),
    (11, 'class_9_10', 'simp-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"3 + 2 × 4 = ?","options":["14","20","11","24"],"answer":2,"explanation":"2×4=8 पहले, फिर 3+8=11"},{"q":"(1/2) ÷ (1/4) = ?","options":["1/8","1/2","2","4"],"answer":2,"explanation":"1/2 × 4/1 = 2"}]}$j$),

    (12, 'class_9_10', 'alg-910-concept', 'concept', 1, 'बीजगणित — Class 9-10',
     $j${"text":"Algebra: variables + constants। Identities: (a+b)² = a²+2ab+b², (a-b)² = a²-2ab+b², a²-b² = (a+b)(a-b)। Linear equation ax+b = 0 → x = -b/a। Polynomials add/subtract/multiply।","note":"Board में identities और linear equations ज़रूरी हैं।"}$j$),
    (12, 'class_9_10', 'alg-910-formula', 'formula', 2, 'बीजगणित सूत्र',
     $j${"formula":"(a+b)² = a²+2ab+b² · (a-b)² = a²-2ab+b² · a²-b² = (a+b)(a-b) · ax+b=0 → x=-b/a","explanation":"(x+3)² = x²+6x+9 · (x-3)² = x²-6x+9 · x²-9 = (x+3)(x-3)"}$j$),
    (12, 'class_9_10', 'alg-910-example', 'example', 3, 'Board numerical',
     $j${"question":"(x+4)² expand?","solution":"x² + 2×4×x + 4²","answer":"x² + 8x + 16"}$j$),
    (12, 'class_9_10', 'alg-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"(a+b)² = ?","options":["a²+b²","a²+2ab+b²","a²-2ab+b²","(a+b)(a-b)"],"answer":1,"explanation":"a² + 2ab + b²"},{"q":"x²-16 = ?","options":["(x-4)²","(x+4)(x-4)","(x+16)(x-1)","x(x-16)"],"answer":1,"explanation":"a²-b² identity, 16=4²"}]}$j$),

    (13, 'class_9_10', 'mens-910-concept', 'concept', 1, 'क्षेत्रमिति — Class 9-10',
     $j${"text":"2D: Rectangle A=l×b, Square A=a², Triangle A=½bh, Circle A=πr² (C=2πr)। 3D: Cuboid V=lbh, Cube V=a³, Cylinder V=πr²h, Sphere V=⁴/₃πr³। Perimeter, surface area।","note":"Board में area, perimeter, और volume formulas ज़रूरी हैं।"}$j$),
    (13, 'class_9_10', 'mens-910-formula', 'formula', 2, 'क्षेत्रमिति सूत्र',
     $j${"formula":"Rect: A=l×b, P=2(l+b) · Circle: A=πr², C=2πr · Cuboid: V=lbh · Cylinder: V=πr²h, CSA=2πrh","explanation":"π = 22/7 या 3.14 · Sphere: V=⁴/₃πr³, A=4πr²"}$j$),
    (13, 'class_9_10', 'mens-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Circle r=7 का area? (π=22/7)","solution":"πr² = 22/7 × 49","answer":"154 sq units"}$j$),
    (13, 'class_9_10', 'mens-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Square side 5। Area?","options":["10","20","25","30"],"answer":2,"explanation":"5² = 25"},{"q":"Rect l=8, b=5। Perimeter?","options":["13","26","40","80"],"answer":1,"explanation":"2×(8+5) = 26"}]}$j$),

    (14, 'class_9_10', 'geo-910-concept', 'concept', 1, 'ज्यामिति — Class 9-10',
     $j${"text":"Triangle: 3 sides, 3 angles sum 180°। Types: equilateral (all equal), isosceles (2 equal), scalene (all different)। Right triangle: Pythagoras a²+b²=c²। Quadrilateral: 4 sides, sum 360°। Circle: chord, tangent, arc।","note":"Board में triangle properties और Pythagoras ज़रूरी हैं।"}$j$),
    (14, 'class_9_10', 'geo-910-formula', 'formula', 2, 'ज्यामिति सूत्र',
     $j${"formula":"Triangle sum = 180° · Quad sum = 360° · Pythagoras: a²+b²=c² (right triangle)","explanation":"3-4-5 triple: 3²+4²=5² · 5-12-13 triple · 8-15-17 triple"}$j$),
    (14, 'class_9_10', 'geo-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Right triangle a=6, b=8। c?","solution":"c = √(36+64) = √100","answer":"c = 10"}$j$),
    (14, 'class_9_10', 'geo-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Triangle angles sum?","options":["90°","180°","270°","360°"],"answer":1,"explanation":"Triangle = 180°"},{"q":"3-4-? right triangle","options":["5","6","7","8"],"answer":0,"explanation":"3-4-5 Pythagorean triple"}]}$j$),

    (15, 'class_9_10', 'trig-910-concept', 'concept', 1, 'त्रिकोणमिति — Class 9-10',
     $j${"text":"Trigonometry: right triangle में ratios। sin = opp/hyp, cos = adj/hyp, tan = opp/adj। Standard angles: sin30=1/2, sin45=1/√2, sin60=√3/2, sin90=1। sin²θ+cos²θ=1।","note":"Board में standard angles और ratios ज़रूरी हैं।"}$j$),
    (15, 'class_9_10', 'trig-910-formula', 'formula', 2, 'त्रिकोणमिति सूत्र',
     $j${"formula":"sin = opp/hyp · cos = adj/hyp · tan = opp/adj = sin/cos · sin²θ+cos²θ=1","explanation":"sin30=1/2, cos30=√3/2, tan30=1/√3 · sin45=cos45=1/√2, tan45=1 · sin60=√3/2"}$j$),
    (15, 'class_9_10', 'trig-910-example', 'example', 3, 'Board numerical',
     $j${"question":"sin 30° + cos 60° = ?","solution":"1/2 + 1/2","answer":"1"}$j$),
    (15, 'class_9_10', 'trig-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"sin 45° = ?","options":["1/2","1/√2","√3/2","1"],"answer":1,"explanation":"sin45 = 1/√2"},{"q":"tan 45° = ?","options":["0","1","√3","1/√3"],"answer":1,"explanation":"tan45 = 1"}]}$j$),

    (16, 'class_9_10', 'stat-910-concept', 'concept', 1, 'सांख्यिकी — Class 9-10',
     $j${"text":"Statistics: data का collection, analysis, presentation। Mean = sum/count। Median = middle value (sorted)। Mode = most frequent। Range = max-min। Bar graph, histogram, pie chart।","note":"Board में mean, median, mode ज़रूरी हैं।"}$j$),
    (16, 'class_9_10', 'stat-910-formula', 'formula', 2, 'सांख्यिकी सूत्र',
     $j${"formula":"Mean = Σx/n · Median = middle (sorted data) · Mode = most frequent · Range = max-min","explanation":"Odd n: middle value। Even n: average of two middle values"}$j$),
    (16, 'class_9_10', 'stat-910-example', 'example', 3, 'Board numerical',
     $j${"question":"2, 4, 6, 8, 10 का mean?","solution":"Sum=30, count=5","answer":"6"}$j$),
    (16, 'class_9_10', 'stat-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"1, 2, 3, 4, 5 का median?","options":["2","3","4","5"],"answer":1,"explanation":"Middle value = 3"},{"q":"3, 5, 5, 7 का mode?","options":["3","5","7","4"],"answer":1,"explanation":"5 twice (most frequent)"}]}$j$),

    -- ═══ CLASS 9-10 REASONING (17, 18, 19, 27, 28, 423, 425, 426, 427, 428) ═══
    (17, 'class_9_10', 'ser-910-concept', 'concept', 1, 'श्रृंखला — Class 9-10',
     $j${"text":"Number series में pattern खोजो: +n, ×n, squares (1,4,9,16), cubes (1,8,27,64), alternate (+2,+4,+2,+4)। Letter series: alphabet positions (A=1 से Z=26)।","note":"Board में simple patterns और alphabet series ज़रूरी हैं।"}$j$),
    (17, 'class_9_10', 'ser-910-formula', 'formula', 2, 'श्रृंखला सूत्र',
     $j${"formula":"+n: 2,4,6,8 · ×n: 2,4,8,16 · Squares: 1,4,9,16,25 · Cubes: 1,8,27,64","explanation":"Alphabet positions: A=1, B=2, ..., Z=26"}$j$),
    (17, 'class_9_10', 'ser-910-example', 'example', 3, 'Board numerical',
     $j${"question":"2, 4, 8, 16, ?","solution":"×2 pattern","answer":"32"}$j$),
    (17, 'class_9_10', 'ser-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"3, 6, 9, 12, ?","options":["14","15","16","18"],"answer":1,"explanation":"+3 pattern → 15"},{"q":"1, 4, 9, 16, ?","options":["20","24","25","36"],"answer":2,"explanation":"Squares: 5² = 25"}]}$j$),

    (18, 'class_9_10', 'ana-910-concept', 'concept', 1, 'सादृश्यता — Class 9-10',
     $j${"text":"Analogy: दो pairs के बीच relation खोजो। जैसे Doctor:Hospital :: Teacher:School (worker-place)। Pen:Write :: Knife:Cut (tool-action)। 2:4 :: 3:9 (square relation)।","note":"Board में worker-place, tool-action, और number relations ज़रूरी हैं।"}$j$),
    (18, 'class_9_10', 'ana-910-formula', 'formula', 2, 'सादृश्यता सूत्र',
     $j${"formula":"Worker:Place · Tool:Action · Cause:Effect · Part:Whole · Number: n → n² or n³","explanation":"Doctor:Hospital = worker:place · Pen:Write = tool:action · 2:4 = n:n²"}$j$),
    (18, 'class_9_10', 'ana-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Bird:Fly :: Fish:?","solution":"Bird flies, fish swims","answer":"Swim"}$j$),
    (18, 'class_9_10', 'ana-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Doctor:Hospital :: Teacher:?","options":["Book","School","Student","Pen"],"answer":1,"explanation":"Teacher works in School"},{"q":"2:4 :: 5:?","options":["10","15","20","25"],"answer":3,"explanation":"n:n² → 5² = 25"}]}$j$),

    (19, 'class_9_10', 'odd-910-concept', 'concept', 1, 'विषम तत्व — Class 9-10',
     $j${"text":"Odd One Out: दिए items में जो बाकी से अलग है। Pattern: (1) जो category में fit न हो, (2) जो even/odd न हो, (3) जो prime/square न हो।","note":"Board में category check और number patterns ज़रूरी हैं।"}$j$),
    (19, 'class_9_10', 'odd-910-formula', 'formula', 2, 'विषम सूत्र',
     $j${"formula":"Categories: Fruits (apple, mango), Vegetables (carrot, potato), Even (2,4,6), Odd (1,3,5), Prime (2,3,5,7)","explanation":"जो category में fit न हो, वो odd है"}$j$),
    (19, 'class_9_10', 'odd-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Apple, Mango, Carrot, Banana — odd?","solution":"Carrot सब्ज़ी, बाकी फल","answer":"Carrot"}$j$),
    (19, 'class_9_10', 'odd-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"1, 3, 5, 7, 8 — विषम?","options":["1","3","5","8"],"answer":3,"explanation":"8 even, बाकी odd"},{"q":"Dog, Cat, Cow, Chair — विषम?","options":["Dog","Cat","Cow","Chair"],"answer":3,"explanation":"Chair = furniture, बाकी जानवर"}]}$j$),

    (27, 'class_9_10', 'venn-910-concept', 'concept', 1, 'वेन आरेख — Class 9-10',
     $j${"text":"Venn diagram: sets का visual। n(A∪B) = n(A) + n(B) - n(A∩B)। Only A = n(A) - n(A∩B)। 'At least one' = A∪B।","note":"Board में venn formula और overlap ज़रूरी हैं।"}$j$),
    (27, 'class_9_10', 'venn-910-formula', 'formula', 2, 'वेन सूत्र',
     $j${"formula":"n(A∪B) = n(A) + n(B) - n(A∩B) · Only A = n(A) - n(A∩B)","explanation":"जोड़ो दोनों groups, फिर overlap घटाओ (क्योंकि दो बार गिना)"}$j$),
    (27, 'class_9_10', 'venn-910-example', 'example', 3, 'Board numerical',
     $j${"question":"10 में से 6 tea, 5 coffee, 3 both। Only tea?","solution":"Only tea = 6-3","answer":"3"}$j$),
    (27, 'class_9_10', 'venn-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"3 A, 2 B, 1 both। At least one?","options":["3","4","5","6"],"answer":1,"explanation":"3+2-1 = 4"},{"q":"Above, only A?","options":["1","2","3","4"],"answer":1,"explanation":"3-1 = 2"}]}$j$),

    (28, 'class_9_10', 'stmt-910-concept', 'concept', 1, 'कथन और तर्क — Class 9-10',
     $j${"text":"Statement से conclusion निकालो। 'All A are B' → 'Some B are A' (valid)। Comparison: A>B, B>C → A>C। 'Cannot determine' तब जब जानकारी अधूरी।","note":"Board में direct inference और comparison chain ज़रूरी है।"}$j$),
    (28, 'class_9_10', 'stmt-910-formula', 'formula', 2, 'कथन सूत्र',
     $j${"formula":"All A are B → A ⊆ B · Some A are B → A ∩ B ≠ ∅ · A>B, B>C → A>C","explanation":"'Some B are A' valid converse of 'All A are B'"}$j$),
    (28, 'class_9_10', 'stmt-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Ram > Mohan, Mohan > Sohan। Shortest?","solution":"Ram > Mohan > Sohan","answer":"Sohan"}$j$),
    (28, 'class_9_10', 'stmt-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"All cats are animals। Some animals are cats?","options":["Valid","Invalid","Cannot determine","None"],"answer":0,"explanation":"Valid converse"},{"q":"A>B, B>C। Largest?","options":["A","B","C","Cannot determine"],"answer":0,"explanation":"A>B>C"}]}$j$),

    (423, 'class_9_10', 'alpha-910-concept', 'concept', 1, 'वर्णमाला श्रृंखला — Class 9-10',
     $j${"text":"Alphabet: A=1, B=2, ..., Z=26। Opposite: A↔Z, B↔Y (sum=27)। Series pattern: +1, +2, +3। Missing letter खोजो pattern से।","note":"Board में alphabet positions और patterns ज़रूरी हैं।"}$j$),
    (423, 'class_9_10', 'alpha-910-formula', 'formula', 2, 'वर्णमाला सूत्र',
     $j${"formula":"A=1, B=2, ..., Z=26 · Opposite (A↔Z) sum = 27 · Pattern: +1 (A,B,C), +2 (A,C,E)","explanation":"EJOTY: E=5, J=10, O=15, T=20, Y=25 (हर 5वाँ)"}$j$),
    (423, 'class_9_10', 'alpha-910-example', 'example', 3, 'Board numerical',
     $j${"question":"A, C, E, G, ?","solution":"+2 pattern (positions 1,3,5,7)","answer":"I (9)"}$j$),
    (423, 'class_9_10', 'alpha-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"C का opposite?","options":["X","Y","Z","W"],"answer":0,"explanation":"C=3, opp=27-3=24=X"},{"q":"A, B, C, D, ?","options":["E","F","G","H"],"answer":0,"explanation":"+1 pattern → E"}]}$j$),

    (425, 'class_9_10', 'blood-910-concept', 'concept', 1, 'रक्त संबंध — Class 9-10',
     $j${"text":"Blood relation: family tree बनाओ। 'Father's father' = grandfather (दादा)। 'Mother's brother' = uncle (मामा)। 'Father's sister' = aunt (बुआ)। 'Brother's son' = nephew (भतीजा)।","note":"Board में family relations और generations ज़रूरी हैं।"}$j$),
    (425, 'class_9_10', 'blood-910-formula', 'formula', 2, 'रक्त संबंध तथ्य',
     $j${"formula":"Father's father = दादा · Mother's father = नाना · Father's brother = चाचा · Mother's brother = मामा · Brother's son = भतीजा","explanation":"अपने से एक generation ऊपर (parents), दो ऊपर (grandparents), नीचे (children)"}$j$),
    (425, 'class_9_10', 'blood-910-example', 'example', 3, 'Board numerical',
     $j${"question":"'मेरी माँ की माँ' मेरी कौन?","solution":"Mother's mother","answer":"नानी (maternal grandmother)"}$j$),
    (425, 'class_9_10', 'blood-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"पिता की माँ?","options":["नानी","दादी","मौसी","बुआ"],"answer":1,"explanation":"Father's mother = दादी"},{"q":"भाई का बेटा?","options":["भतीजा","भांजा","चचेरा","भतीजी"],"answer":0,"explanation":"Brother's son = भतीजा (nephew)"}]}$j$),

    (426, 'class_9_10', 'code-910-concept', 'concept', 1, 'कूट-लेखन — Class 9-10',
     $j${"text":"Coding: letter shift (+n, -n), reverse alphabet (A↔Z), position number। जैसे PEN = QFO (+1 each)। Reverse: A→Z, B→Y।","note":"Board में shift pattern और reverse coding ज़रूरी हैं।"}$j$),
    (426, 'class_9_10', 'code-910-formula', 'formula', 2, 'Coding सूत्र',
     $j${"formula":"+1 shift: A→B, B→C · -1: A→Z, B→A · Reverse: A↔Z, B↔Y (sum=27)","explanation":"PEN → QFO (+1 each letter) · CAT → DBU (+1)"}$j$),
    (426, 'class_9_10', 'code-910-example', 'example', 3, 'Board numerical',
     $j${"question":"CAT = DBU। DOG = ?","solution":"D→E, O→P, G→H (+1 each)","answer":"EPH"}$j$),
    (426, 'class_9_10', 'code-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"+1 shift में A→?","options":["A","B","Z","Y"],"answer":1,"explanation":"A+1 = B"},{"q":"Reverse में Z→?","options":["A","B","Y","Z"],"answer":0,"explanation":"Z reverse = A"}]}$j$),

    (427, 'class_9_10', 'dir-910-concept', 'concept', 1, 'दिशा ज्ञान — Class 9-10',
     $j${"text":"North, South, East, West। Right turn: N→E→S→W (clockwise)। Left turn: N→W→S→E (anticlockwise)। Distance: √(x²+y²) for diagonal।","note":"Board में direction और turns ज़रूरी हैं।"}$j$),
    (427, 'class_9_10', 'dir-910-formula', 'formula', 2, 'दिशा सूत्र',
     $j${"formula":"Right: N→E→S→W→N · Left: N→W→S→E→N · Diagonal: √(x²+y²)","explanation":"2 right turns = 180° (opposite direction)"}$j$),
    (427, 'class_9_10', 'dir-910-example', 'example', 3, 'Board numerical',
     $j${"question":"North facing, 1 right turn। Direction?","solution":"N→E (right)","answer":"East"}$j$),
    (427, 'class_9_10', 'dir-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"South facing, right turn?","options":["N","E","W","S"],"answer":2,"explanation":"S right = West"},{"q":"N→2 right turns?","options":["N","S","E","W"],"answer":1,"explanation":"N→E→S"}]}$j$),

    (428, 'class_9_10', 'op-910-concept', 'concept', 1, 'गणितीय संक्रियाएँ — Class 9-10',
     $j${"text":"Symbols का मतलब बदला जाता है। + का मतलब × हो तो 2+3 का मतलब 2×3=6। पहले symbol replace, फिर BODMAS।","note":"Board में symbol replacement और BODMAS ज़रूरी हैं।"}$j$),
    (428, 'class_9_10', 'op-910-formula', 'formula', 2, 'संक्रिया सूत्र',
     $j${"formula":"Symbol replace करो, फिर BODMAS · +→× means 2+3 = 2×3 = 6","explanation":"-→+ means 5-3 = 5+3 = 8"}$j$),
    (428, 'class_9_10', 'op-910-example', 'example', 3, 'Board numerical',
     $j${"question":"+ = ×, तो 4+5 = ?","solution":"4×5","answer":"20"}$j$),
    (428, 'class_9_10', 'op-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"- = +, तो 7-2?","options":["5","9","14","3"],"answer":1,"explanation":"7+2 = 9"},{"q":"× = +, तो 3×4?","options":["12","7","1","0"],"answer":1,"explanation":"3+4 = 7"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], array['class_9', 'class_10']::text[],
  case when s.chapter_id < 20 then 'maths' else 'reasoning' end,
  'easy', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, count(*) from mtb.atoms 
-- where chapter_id in (7,8,9,10,11,12,13,14,15,16,17,18,19,27,28,423,425,426,427,428) 
--   and level_id='class_9_10' and status='published' and not archived 
-- group by 1 order by 1;
-- Expected: each chapter = 4

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: 1459 + 80 = 1539