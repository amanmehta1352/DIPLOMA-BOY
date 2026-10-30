with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ CLASS 11-12 SCI MATHS (12-16) ═══
    (12, 'class_11_12_sci', 'alg-1112-concept', 'concept', 1, 'बीजगणित — Class 11-12',
     $j${"text":"Polynomials: degree, roots, factor/remainder theorem। Quadratic: ax²+bx+c=0, D=b²-4ac (D>0 real distinct, D=0 equal, D<0 complex)। Roots: α+β=-b/a, αβ=c/a। Cubic: sum=-b/a, pairwise sum=c/a, product=-d/a। AP: aₙ=a+(n-1)d, Sₙ=n/2(2a+(n-1)d)। GP: aₙ=arⁿ⁻¹, Sₙ=a(rⁿ-1)/(r-1) (r≠1)। HP: reciprocals of AP।","note":"Board में quadratic, AP/GP, और cubic relations ज़रूरी हैं।"}$j$),
    (12, 'class_11_12_sci', 'alg-1112-formula', 'formula', 2, 'बीजगणित सूत्र',
     $j${"formula":"Quadratic: x=(-b±√D)/2a · Sum=-b/a, Product=c/a · AP: aₙ=a+(n-1)d, Sₙ=n/2[2a+(n-1)d] · GP: aₙ=arⁿ⁻¹, Sₙ=a(rⁿ-1)/(r-1)","explanation":"AM=(a+b)/2, GM=√(ab), HM=2ab/(a+b) · AM≥GM≥HM · Sum of infinite GP (|r|<1): S=a/(1-r)"}$j$),
    (12, 'class_11_12_sci', 'alg-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"x²-5x+6=0। Roots?","solution":"D=25-24=1। x=(5±1)/2","answer":"x=2, 3"}$j$),
    (12, 'class_11_12_sci', 'alg-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"x²-7x+12=0 roots?","options":["3,4","2,6","1,12","-3,-4"],"answer":0,"explanation":"Sum=7, product=12 → 3,4"},{"q":"AP 2,5,8,... 10th term?","options":["29","30","32","35"],"answer":0,"explanation":"a₁₀=2+9×3=29"}]}$j$),

    (13, 'class_11_12_sci', 'mens-1112-concept', 'concept', 1, 'क्षेत्रमिति — Class 11-12',
     $j${"text":"2D: Heron's formula (triangle), circle (area, circumference, sector, segment), parallelogram, trapezium। 3D: cuboid (V=lbh), cube (V=a³), cylinder (V=πr²h), cone (V=⅓πr²h, l=√(r²+h²)), sphere (V=⁴/₃πr³), hemisphere, frustum। Cutting/casting problems (volume conserved)। Similar figures: A∝s², V∝s³।","note":"Board में Heron's, frustum, और volume conservation ज़रूरी हैं।"}$j$),
    (13, 'class_11_12_sci', 'mens-1112-formula', 'formula', 2, 'क्षेत्रमिति सूत्र',
     $j${"formula":"Triangle: A=½bh or Heron √[s(s-a)(s-b)(s-c)] · Circle: A=πr², C=2πr · Sphere: V=⁴/₃πr³, A=4πr² · Cone: V=⅓πr²h, CSA=πrl (l=√(r²+h²))","explanation":"Frustum: V=⅓πh(r₁²+r₂²+r₁r₂) · Sector: A=½r²θ (θ radians)"}$j$),
    (13, 'class_11_12_sci', 'mens-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Cone r=3, h=4। CSA?","solution":"l=√(9+16)=5। CSA=π×3×5","answer":"15π ≈ 47.1 sq units"}$j$),
    (13, 'class_11_12_sci', 'mens-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Sphere r=7। V (π=22/7)?","options":["4312/3","1437.3","4312","1437"],"answer":1,"explanation":"V=⁴/₃×22/7×343=1437.3"},{"q":"Similar area ratio (sides 2:3)?","options":["2:3","4:9","8:27","2:9"],"answer":1,"explanation":"Area∝s² → 4:9"}]}$j$),

    (14, 'class_11_12_sci', 'geo-1112-concept', 'concept', 1, 'ज्यामिति — Class 11-12',
     $j${"text":"Coordinate geometry: distance, midpoint, section formula, slope, line equations (slope-intercept, point-slope, two-point, intercept)। Distance point-line: |ax+by+c|/√(a²+b²)। Circle: x²+y²+2gx+2fy+c=0, r=√(g²+f²-c)। Conics: parabola y²=4ax (focus (a,0)), ellipse x²/a²+y²/b²=1 (e<1), hyperbola (e>1)।","note":"Board में coordinate geometry और conics ज़रूरी हैं।"}$j$),
    (14, 'class_11_12_sci', 'geo-1112-formula', 'formula', 2, 'ज्यामिति सूत्र',
     $j${"formula":"Distance=√[(x₂-x₁)²+(y₂-y₁)²] · Slope m=(y₂-y₁)/(x₂-x₁) · Line: y-y₁=m(x-x₁) · Circle r=√(g²+f²-c)","explanation":"Parabola y²=4ax: focus (a,0), directrix x=-a · Ellipse: foci (±ae,0) · Hyperbola: foci (±ae,0)"}$j$),
    (14, 'class_11_12_sci', 'geo-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Line (1,2), slope 3। Equation?","solution":"y-2=3(x-1) → y-2=3x-3","answer":"3x - y - 1 = 0"}$j$),
    (14, 'class_11_12_sci', 'geo-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Parabola y²=4x focus?","options":["(1,0)","(0,1)","(4,0)","(0,4)"],"answer":0,"explanation":"y²=4ax, a=1 → focus (1,0)"},{"q":"Distance (0,0) to (3,4)?","options":["5","7","25","√7"],"answer":0,"explanation":"√(9+16)=5"}]}$j$),

    (15, 'class_11_12_sci', 'trig-1112-concept', 'concept', 1, 'त्रिकोणमिति — Class 11-12',
     $j${"text":"Trig identities: sin²+cos²=1, 1+tan²=sec², 1+cot²=cosec²। Addition: sin(A±B), cos(A±B), tan(A±B)। Double angle: sin2A=2sinAcosA, cos2A=cos²A-sin²A=1-2sin²A=2cos²A-1। Half angle। Sum-to-product, product-to-sum। General solutions: sinθ=k → θ=nπ+(-1)ⁿα, cosθ=k → 2nπ±α, tanθ=k → nπ+α। Inverse trig functions (principal values)।","note":"Board में double angle, general solutions, और inverse trig ज़रूरी हैं।"}$j$),
    (15, 'class_11_12_sci', 'trig-1112-formula', 'formula', 2, 'त्रिकोणमिति सूत्र',
     $j${"formula":"sin(A+B) = sinAcosB + cosAsinB · cos2A = 1-2sin²A · sin2A = 2sinAcosA · tan2A = 2tanA/(1-tan²A)","explanation":"sinθ=k → θ = nπ+(-1)ⁿα · cosθ=k → θ=2nπ±α · tanθ=k → θ=nπ+α"}$j$),
    (15, 'class_11_12_sci', 'trig-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"sin75° = ?","solution":"sin(45+30) = (√2/2)(√3/2) + (√2/2)(1/2)","answer":"(√6+√2)/4"}$j$),
    (15, 'class_11_12_sci', 'trig-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"cos2A = ?","options":["2cos²A-1","1-2cos²A","2sin²A-1","sin²A-cos²A"],"answer":0,"explanation":"cos2A = 2cos²A-1 (also 1-2sin²A)"},{"q":"sinθ=1/2 general solution?","options":["nπ+π/6","nπ+(-1)ⁿπ/6","2nπ+π/6","nπ-π/6"],"answer":1,"explanation":"sin: nπ+(-1)ⁿα, α=π/6"}]}$j$),

    (16, 'class_11_12_sci', 'stat-1112-concept', 'concept', 1, 'सांख्यिकी — Class 11-12',
     $j${"text":"Central tendency: mean (arithmetic, weighted, geometric), median, mode। Dispersion: range, variance σ²=Σ(x-μ)²/N, standard deviation σ, mean deviation। Grouped data formulas। Combined mean: (n₁x̄₁+n₂x̄₂)/(n₁+n₂)। Empirical: Mode=3Median-2Mean। Quartiles, percentiles, coefficient of variation CV=(σ/mean)×100।","note":"Board में variance, SD, और combined mean ज़रूरी हैं।"}$j$),
    (16, 'class_11_12_sci', 'stat-1112-formula', 'formula', 2, 'सांख्यिकी सूत्र',
     $j${"formula":"Mean = Σx/n · σ² = Σ(x-μ)²/N = Σx²/N - μ² · SD = √σ² · Combined mean = (n₁x̄₁+n₂x̄₂)/(n₁+n₂)","explanation":"CV = (σ/mean)×100% · Mode = 3Median - 2Mean"}$j$),
    (16, 'class_11_12_sci', 'stat-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"2,4,4,6,8,10। Mean?","solution":"Sum=34, count=6","answer":"5.67"}$j$),
    (16, 'class_11_12_sci', 'stat-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Variance का unit?","options":["Same as data","Square of data unit","Unitless","Cube"],"answer":1,"explanation":"Variance = (unit)² · SD = same as data"},{"q":"Mode = ?","options":["3Med-2Mean","Mean","Median","2Med-Mean"],"answer":0,"explanation":"Empirical: Mode=3Median-2Mean"}]}$j$),

    -- ═══ BANKING MATHS (1-5) ═══
    (1, 'banking', 'pct-bank-concept', 'concept', 1, 'प्रतिशत — Banking',
     $j${"text":"Banking में percentage fast calculation ज़रूरी है। Shortcut: 1/8=12.5%, 1/16=6.25%, 1/6≈16.67%, 1/7≈14.28%, 1/9≈11.11% (याद रखो)। Successive changes: net=a+b+ab/100। Speed: fractions → percentage, percentage → fractions quickly।","note":"IBPS/SBI में fast percentage conversions shortcut ज़रूरी हैं।"}$j$),
    (1, 'banking', 'pct-bank-formula', 'formula', 2, 'प्रतिशत shortcuts',
     $j${"formula":"Common fractions: 1/2=50%, 1/3=33.33%, 1/4=25%, 1/5=20%, 1/6≈16.67%, 1/7≈14.28%, 1/8=12.5%, 1/9≈11.11%","explanation":"Successive: net = a+b+ab/100 · Speed trick: 100 का x% = x (direct)"}$j$),
    (1, 'banking', 'pct-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"₹840 का 12.5% (speed trick)?","solution":"12.5% = 1/8 → 840/8","answer":"105 (2 sec में)"}$j$),
    (1, 'banking', 'pct-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"16.67% किस fraction के बराबर?","options":["1/5","1/6","1/7","1/8"],"answer":1,"explanation":"1/6 = 16.67%"},{"q":"600 का 14.28%?","options":["72","84","86","98"],"answer":2,"explanation":"14.28% ≈ 1/7 → 600/7 ≈ 85.7 ≈ 86 (closest)"}]}$j$),

    (2, 'banking', 'pl-bank-concept', 'concept', 1, 'लाभ-हानि — Banking',
     $j${"text":"Shortcut: लाभ% = (लाभ/CP)×100। Successive discounts formula: net = a+b-ab/100। Fast trick: if SP is x% of CP, profit% = x-100। Multiplier method: SP=CP×(1+P/100)। Dishonest dealer: profit% = error/(true-error)×100।","note":"Banking में multiplier method और successive discounts shortcut ज़रूरी हैं।"}$j$),
    (2, 'banking', 'pl-bank-formula', 'formula', 2, 'लाभ-हानि shortcuts',
     $j${"formula":"Profit% = (SP/CP - 1)×100 · Discount% = (1 - SP/MP)×100 · Successive: net = a+b-ab/100","explanation":"If SP = 125% of CP → profit 25% · If SP = 80% of MP, discount 20%"}$j$),
    (2, 'banking', 'pl-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"SP = 1.25×CP। Profit%?","solution":"(1.25-1)×100","answer":"25%"}$j$),
    (2, 'banking', 'pl-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"Two successive 25%, 20% discounts?","options":["45%","40%","42%","35%"],"answer":1,"explanation":"25+20-500/100 = 45-5 = 40%"},{"q":"SP = 0.8MP। Discount%?","options":["10%","20%","25%","15%"],"answer":1,"explanation":"(1-0.8)×100 = 20%"}]}$j$),

    (3, 'banking', 'si-bank-concept', 'concept', 1, 'ब्याज — Banking',
     $j${"text":"SI = PRT/100 (fast mental math)। CI = P[(1+R/100)ⁿ-1]। Trick: CI-SI (2yr) = P(R/100)²। Rule of 72: money doubles in 72/R years। Effective rate for half-yearly: (1+R/200)²-1। Simple mental shortcuts: 5% = /20, 10% = /10, 12.5% = /8।","note":"Banking में Rule 72 और shortcut fractions ज़रूरी हैं।"}$j$),
    (3, 'banking', 'si-bank-formula', 'formula', 2, 'ब्याज shortcuts',
     $j${"formula":"SI = PRT/100 · Rule 72: t_double ≈ 72/R · CI-SI (2y) = P(R/100)²","explanation":"R=8%: t_double ≈ 9y · R=12%: 6y · Faster: 1 year CI = SI"}$j$),
    (3, 'banking', 'si-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"₹5000, 12%, 2 साल SI (fast)?","solution":"12%×2 = 24% of 5000 = 5000×0.24","answer":"₹1200 (5 sec)"}$j$),
    (3, 'banking', 'si-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"Rule 72: R=8%, double time?","options":["8y","9y","10y","12y"],"answer":1,"explanation":"72/8 = 9y"},{"q":"₹10000, 10%, 2y CI-SI?","options":["₹50","₹100","₹150","₹200"],"answer":1,"explanation":"P(R/100)² = 10000×0.01 = 100"}]}$j$),

    (4, 'banking', 'ratio-bank-concept', 'concept', 1, 'अनुपात — Banking',
     $j${"text":"Ratio shortcuts: divide by parts = total/(a+b+c)। Partnership: profit ∝ investment × time। Mixture: alligation cross method। Componendo-dividendo। Fast: if a:b=2:3, then a=2k, b=3k।","note":"Banking में partnership और alligation shortcut ज़रूरी हैं।"}$j$),
    (4, 'banking', 'ratio-bank-formula', 'formula', 2, 'अनुपात shortcuts',
     $j${"formula":"Divide N in a:b → shares = Na/(a+b), Nb/(a+b) · Partnership: profit ∝ inv × time","explanation":"Alligation: cheap:dear = (dear-mean):(mean-cheap) · Componendo: (a+b)/(a-b) = (c+d)/(c-d) if a/b=c/d"}$j$),
    (4, 'banking', 'ratio-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"₹10000 को 1:2:3:4 में। सबसे बड़ा?","solution":"Parts = 10। Largest = 10000 × 4/10","answer":"₹4000"}$j$),
    (4, 'banking', 'ratio-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"A invests 5000 for 4 months, B 10000 for 2 months। Profit ratio?","solution":"5000×4 : 10000×2 = 20000:20000 = 1:1","options":["1:1","1:2","2:1","1:4"],"answer":0,"explanation":"20k:20k = 1:1"},{"q":"A:B=2:3, B:C=4:5। A:C?","options":["8:15","2:5","3:4","4:5"],"answer":0,"explanation":"A:B:C=8:12:15 → A:C=8:15"}]}$j$),

    (5, 'banking', 'avg-bank-concept', 'concept', 1, 'औसत — Banking',
     $j${"text":"Average shortcut: if one value added/changed, average shifts by Δ/n। Weighted average for groups। Average speed (equal distances) = HM = 2v₁v₂/(v₁+v₂)। Sum = Average × n। Fast trick: average of consecutive = middle।","note":"Banking में shortcut average और speed average ज़रूरी हैं।"}$j$),
    (5, 'banking', 'avg-bank-formula', 'formula', 2, 'औसत shortcuts',
     $j${"formula":"Avg = sum/count · New avg after adding x = (old×n + x)/(n+1) · Avg speed (equal D) = 2v₁v₂/(v₁+v₂)","explanation":"If one value changes by Δ, avg shifts by Δ/n · First n naturals avg = (n+1)/2"}$j$),
    (5, 'banking', 'avg-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"10 संख्याओं का avg 40। एक 60 हटाया। New avg?","solution":"New sum = 400-60 = 340, n=9","answer":"340/9 ≈ 37.78"}$j$),
    (5, 'banking', 'avg-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"5 संख्या avg 20। Sum?","options":["100","80","120","60"],"answer":0,"explanation":"Sum = 20×5 = 100"},{"q":"Avg 25 (10 numbers)। एक 25 बदला 50 से। New avg?","options":["27.5","28.5","29","30"],"answer":0,"explanation":"Δ=25, shift = 25/10 = 2.5 → 27.5"}]}$j$),

    -- ═══ BANKING REASONING (17, 18, 19, 423, 425) ═══
    (17, 'banking', 'ser-bank-concept', 'concept', 1, 'श्रृंखला — Banking',
     $j${"text":"Series shortcuts: pattern recognition (arithmetic +n, geometric ×n, square/cube, alternate)। Banking में mixed pattern (combination of two series) common। Double difference method: दो बार difference निकालो, equal आए तो quadratic। Letter series: +n pattern, reverse।","note":"Banking में mixed pattern और double difference shortcut ज़रूरी हैं।"}$j$),
    (17, 'banking', 'ser-bank-formula', 'formula', 2, 'श्रृंखला shortcuts',
     $j${"formula":"+n: check difference · ×n: check ratio · Square: 1,4,9,16 · Cube: 1,8,27,64","explanation":"Alternate: two series combined (odd positions, even positions) · Double difference: D₂ = constant → quadratic pattern"}$j$),
    (17, 'banking', 'ser-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"2, 6, 12, 20, 30, ?","solution":"Differ: 4,6,8,10 (arithmetic +2)। Next diff = 12। 30+12","answer":"42"}$j$),
    (17, 'banking', 'ser-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"1, 4, 9, 16, 25, ?","options":["30","36","42","49"],"answer":1,"explanation":"Squares → 6² = 36"},{"q":"3, 5, 9, 17, ?","solution":"Differ: 2,4,8 (×2)। Next 16। 17+16=33","options":["25","29","33","37"],"answer":2,"explanation":"Differences double: 2,4,8,16"}]}$j$),

    (18, 'banking', 'ana-bank-concept', 'concept', 1, 'सादृश्यता — Banking',
     $j${"text":"Analogy: relationship types — worker:place, tool:action, cause:effect, part:whole, synonym, antonym, number (square/cube)। Banking में number analogy और word analogy। Direction: A:B :: C:D — same relation।","note":"Banking में relation identify और speed ज़रूरी है।"}$j$),
    (18, 'banking', 'ana-bank-formula', 'formula', 2, 'सादृश्यता shortcuts',
     $j${"formula":"n:n² or n:n³ · Worker:Place · Tool:Action · Part:Whole · Synonym/Antonym","explanation":"2:8 (cube) · 4:16 (square) · Doctor:Hospital (worker:place)"}$j$),
    (18, 'banking', 'ana-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"5:125 :: 4:?","solution":"125 = 5³, so 4³=64","answer":"64"}$j$),
    (18, 'banking', 'ana-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"3:27 :: 4:?","options":["16","27","64","81"],"answer":2,"explanation":"3³=27, 4³=64"},{"q":"Pen:Write :: Knife:?","options":["Sharp","Cut","Blade","Metal"],"answer":1,"explanation":"Tool:action"}]}$j$),

    (19, 'banking', 'odd-bank-concept', 'concept', 1, 'विषम तत्व — Banking',
     $j${"text":"Odd One Out shortcut: category check (fruits, colors, planets), number property (prime, square, even), pattern (all have letter 'a', all end in 'e')। Banking में fast decision ज़रूरी — 10-15 sec per question।","note":"Banking में fast observation और pattern detection ज़रूरी है।"}$j$),
    (19, 'banking', 'odd-bank-formula', 'formula', 2, 'विषम shortcuts',
     $j${"formula":"Category check: which doesn't fit · Number: even/odd, prime/composite, square/cube · Letter: position, vowel/consonant","explanation":"e.g., Apple/Mango/Carrot → Carrot (vegetable)"}$j$),
    (19, 'banking', 'odd-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"3, 5, 7, 9, 11 — विषम?","solution":"3,5,7,11 prime, 9=3×3 नहीं","answer":"9"}$j$),
    (19, 'banking', 'odd-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"2, 4, 6, 8, 10, 13 — विषम?","options":["2","8","10","13"],"answer":3,"explanation":"13 odd, बाकी even"},{"q":"Delhi, Mumbai, Kolkata, Nepal — विषम?","options":["Delhi","Mumbai","Kolkata","Nepal"],"answer":3,"explanation":"Nepal देश, बाकी शहर"}]}$j$),

    (423, 'banking', 'alpha-bank-concept', 'concept', 1, 'वर्णमाला श्रृंखला — Banking',
     $j${"text":"Alphabet positions: A=1 से Z=26। EJOTY trick: E=5, J=10, O=15, T=20, Y=25 (5 का multiple)। CFILORUX: C=3, F=6, I=9, L=12, O=15, R=18, U=21, X=24 (3 का multiple)। Opposite: sum=27 (A↔Z, B↔Y)।","note":"Banking में EJOTY और CFILORUX trick ज़रूरी हैं।"}$j$),
    (423, 'banking', 'alpha-bank-formula', 'formula', 2, 'वर्णमाला shortcuts',
     $j${"formula":"A=1, B=2, ..., Z=26 · Opposite sum = 27 · EJOTY: 5,10,15,20,25 = E,J,O,T,Y","explanation":"CFILORUX: every 3rd (C,F,I,L,O,R,U,X) · Missing letter series: +n pattern"}$j$),
    (423, 'banking', 'alpha-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"B, E, H, K, ?","solution":"+3 pattern (2,5,8,11,14)","answer":"N (14)"}$j$),
    (423, 'banking', 'alpha-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"M का position?","options":["12","13","14","15"],"answer":1,"explanation":"A=1... M=13"},{"q":"R का opposite?","options":["F","G","I","H"],"answer":2,"explanation":"R=18, opp=27-18=9=I"}]}$j$),

    (425, 'banking', 'blood-bank-concept', 'concept', 1, 'रक्त संबंध — Banking',
     $j${"text":"Blood relation shortcut: family tree बनाओ symbols से — + male, − female, ↔ siblings, | parent, ═ spouse। Pointing: 'my father's son' = brother/self। 'Brother's father' = father (self)। 2-3 generation gap देखो।","note":"Banking में family tree symbols और pointing questions shortcut ज़रूरी हैं।"}$j$),
    (425, 'banking', 'blood-bank-formula', 'formula', 2, 'रक्त संबंध shortcuts',
     $j${"formula":"Symbols: + male, − female, ↔ siblings, | parent, ═ spouse","explanation":"'X's father's son' = X's brother (or X himself if male) · 'X's brother's father' = X's father"}$j$),
    (425, 'banking', 'blood-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"'मेरे पिता की माँ' — मेरी कौन?","solution":"Father's mother","answer":"दादी (paternal grandmother)"}$j$),
    (425, 'banking', 'blood-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"A's father's sister?","options":["माँ","बुआ (aunt)","दादी","बहन"],"answer":1,"explanation":"Father's sister = बुआ (aunt)"},{"q":"'Only son of my grandfather'?","options":["Father","Uncle","Brother","Self"],"answer":0,"explanation":"Grandfather's only son = Father"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[],
  case when s.level_id = 'class_11_12_sci' then array['class_11','class_12']::text[] else '{}'::text[] end,
  case when s.chapter_id < 20 then 'maths' 
       when s.chapter_id >= 400 and s.chapter_id < 500 then 'reasoning' 
       else 'maths' end,
  'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select level_id, count(*) from mtb.atoms 
-- where chapter_id in (12,13,14,15,16,1,2,3,4,5,17,18,19,423,425) 
--   and status='published' and not archived 
-- group by level_id;
-- Expected: class_11_12_sci=20 (chapters 12-16 × 4), banking=60 (chapters 1-5, 17-19, 423, 425 × 4)

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: 1779 + 80 = 1859