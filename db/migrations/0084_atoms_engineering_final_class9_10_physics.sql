with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ ENGINEERING MATHS 11-16 ═══
    (11, 'engineering', 'simp-eng-concept', 'concept', 1, 'सरलीकरण — JEE',
     $j${"text":"BODMAS extended: nested brackets, surds, indices। Surds: √a·√b=√(ab), √a/√b=√(a/b), rationalization: 1/(√a+√b) = (√a-√b)/(a-b)। Indices: aᵐ·aⁿ=aᵐ⁺ⁿ, (aᵐ)ⁿ=aᵐⁿ, a⁰=1 (a≠0), a⁻ᵐ=1/aᵐ।","note":"JEE में surds और rationalization ज़रूरी हैं।"}$j$),
    (11, 'engineering', 'simp-eng-formula', 'formula', 2, 'सरलीकरण सूत्र',
     $j${"formula":"aᵐ·aⁿ = aᵐ⁺ⁿ · (aᵐ)ⁿ = aᵐⁿ · (ab)ᵐ = aᵐbᵐ · 1/(√a+√b) = (√a-√b)/(a-b)","explanation":"Rationalization: multiply by conjugate · (a+b)(a-b) = a²-b²"}$j$),
    (11, 'engineering', 'simp-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"Rationalize: 1/(√5 - √3)","solution":"Multiply by (√5+√3)/(√5+√3): (√5+√3)/(5-3)","answer":"(√5+√3)/2"}$j$),
    (11, 'engineering', 'simp-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"√8 + √18 = ?","options":["√26","2√2+3√2=5√2","2√3+3√2","√25"],"answer":1,"explanation":"√8=2√2, √18=3√2 → 5√2"},{"q":"2^(1/2) × 2^(1/3) = ?","options":["2^(1/6)","2^(5/6)","2^(2/6)","4"],"answer":1,"explanation":"2^(1/2+1/3) = 2^(3/6+2/6) = 2^(5/6)"}]}$j$),

    (12, 'engineering', 'alg-eng-concept', 'concept', 1, 'बीजगणित — JEE',
     $j${"text":"Polynomials: degree, roots, factor theorem, remainder theorem। Quadratic: ax²+bx+c=0, discriminant D=b²-4ac (D>0 real distinct, D=0 equal, D<0 complex)। Sum of roots = -b/a, product = c/a। Cubics: sum = -b/a, sum of pairwise = c/a, product = -d/a। AP, GP, HP series।","note":"JEE में quadratic, cubic, और series ज़रूरी हैं।"}$j$),
    (12, 'engineering', 'alg-eng-formula', 'formula', 2, 'बीजगणित सूत्र',
     $j${"formula":"Quadratic: x = (-b ± √D)/(2a), D=b²-4ac · Sum = -b/a, Product = c/a · AP: aₙ = a+(n-1)d, Sₙ = n/2(2a+(n-1)d) · GP: aₙ = arⁿ⁻¹, Sₙ = a(rⁿ-1)/(r-1)","explanation":"AM = (a+b)/2, GM = √(ab), HM = 2ab/(a+b) · AM ≥ GM ≥ HM"}$j$),
    (12, 'engineering', 'alg-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"x²-5x+6 = 0। Roots?","solution":"D = 25-24 = 1। x = (5±1)/2 = 3, 2","answer":"x = 2, 3"}$j$),
    (12, 'engineering', 'alg-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"x²-7x+12=0 roots?","options":["3,4","2,6","1,12","-3,-4"],"answer":0,"explanation":"Sum=7, product=12 → 3 and 4"},{"q":"AP: 2,5,8,... का 10th term?","options":["29","30","32","35"],"answer":0,"explanation":"a₁₀ = 2+9×3 = 29"}]}$j$),

    (13, 'engineering', 'mens-eng-concept', 'concept', 1, 'क्षेत्रमिति — JEE',
     $j${"text":"2D: triangle (Heron's), circle, sector, parallelogram, trapezium। 3D: cuboid, cube, cylinder, cone, sphere, hemisphere, frustum। Volume, surface area (total, curved/lateral)। Cutting/casting problems। Path/ring area problems। Similar figures: area ∝ (scale)², volume ∝ (scale)³।","note":"JEE में 3D और cutting problems ज़रूरी हैं।"}$j$),
    (13, 'engineering', 'mens-eng-formula', 'formula', 2, 'क्षेत्रमिति सूत्र',
     $j${"formula":"Triangle (Heron): A = √[s(s-a)(s-b)(s-c)], s=(a+b+c)/2 · Sphere: V=⁴/₃πr³, A=4πr² · Cone: V=⅓πr²h, CSA=πrl (l=√(r²+h²)) · Frustum: V=⅓πh(r₁²+r₂²+r₁r₂)","explanation":"Sector: A = ½r²θ (θ in radians) · Similar: A₁/A₂ = (s₁/s₂)², V₁/V₂ = (s₁/s₂)³"}$j$),
    (13, 'engineering', 'mens-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"Cone r=3, h=4। CSA?","solution":"l = √(9+16) = 5। CSA = πrl = π×3×5","answer":"15π ≈ 47.1 sq units"}$j$),
    (13, 'engineering', 'mens-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"Sphere r=7। Volume (π=22/7)?","options":["4312/3","1437.3","4312","1437"],"answer":1,"explanation":"V=4/3×22/7×343=4×22×49/3=1437.3"},{"q":"Similar triangles area ratio (sides 2:3)?","options":["2:3","4:9","8:27","2:9"],"answer":1,"explanation":"Area ∝ s² → 4:9"}]}$j$),

    (14, 'engineering', 'geo-eng-concept', 'concept', 1, 'ज्यामिति — JEE',
     $j${"text":"Lines, angles, triangles (similar, congruent), circles (tangent, chord, secant, cyclic quad)। Coordinate geometry: distance, midpoint, section formula, slope, equation of line (various forms), circle equation (x-h)²+(y-k)²=r²। Conic sections: parabola (y²=4ax), ellipse (x²/a²+y²/b²=1), hyperbola।","note":"JEE में coordinate geometry और conics ज़रूरी हैं।"}$j$),
    (14, 'engineering', 'geo-eng-formula', 'formula', 2, 'ज्यामिति सूत्र',
     $j${"formula":"Distance = √[(x₂-x₁)²+(y₂-y₁)²] · Slope m = (y₂-y₁)/(x₂-x₁) · Line: y-y₁=m(x-x₁) · Circle: x²+y²+2gx+2fy+c=0, r=√(g²+f²-c)","explanation":"Parabola: y²=4ax, focus (a,0), directrix x=-a · Ellipse: e<1, foci (±ae,0) · Hyperbola: e>1"}$j$),
    (14, 'engineering', 'geo-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"Line through (1,2) slope 3। Equation?","solution":"y-2 = 3(x-1) → y-2 = 3x-3","answer":"3x - y - 1 = 0"}$j$),
    (14, 'engineering', 'geo-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"Parabola y²=4x का focus?","options":["(1,0)","(0,1)","(4,0)","(0,4)"],"answer":0,"explanation":"y²=4ax → a=1, focus (a,0)=(1,0)"},{"q":"Distance between (0,0) and (3,4)?","options":["5","7","25","√7"],"answer":0,"explanation":"√(9+16) = 5"}]}$j$),

    (15, 'engineering', 'trig-eng-concept', 'concept', 1, 'त्रिकोणमिति — JEE',
     $j${"text":"Trig identities: sin²+cos²=1, 1+tan²=sec², 1+cot²=cosec²। Addition: sin(A±B), cos(A±B), tan(A±B)। Double angle: sin2A=2sinAcosA, cos2A=cos²A-sin²A=1-2sin²A=2cos²A-1। Half angle। Sum-to-product, product-to-sum। Trig equations: general solution। Inverse trig functions।","note":"JEE में identities, equations, और inverse trig ज़रूरी हैं।"}$j$),
    (15, 'engineering', 'trig-eng-formula', 'formula', 2, 'त्रिकोणमिति सूत्र',
     $j${"formula":"sin(A+B) = sinAcosB + cosAsinB · cos2A = 1-2sin²A · sin2A = 2sinAcosA · tan2A = 2tanA/(1-tan²A)","explanation":"General solution: sinθ=k → θ=nπ+(-1)ⁿα · cosθ=k → θ=2nπ±α · tanθ=k → θ=nπ+α"}$j$),
    (15, 'engineering', 'trig-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"sin75° = ?","solution":"sin(45+30) = sin45cos30 + cos45sin30 = (√2/2)(√3/2)+(√2/2)(1/2)","answer":"(√6+√2)/4"}$j$),
    (15, 'engineering', 'trig-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"cos2A = ?","options":["2cos²A-1","1-2cos²A","2sin²A-1","2sinA·cosA"],"answer":0,"explanation":"cos2A = 2cos²A-1 (सही)। 1-2cos²A और 2sin²A-1 = −cos2A (गलत)।"},{"q":"sinθ=1/2 का general solution?","options":["nπ+π/6","nπ+(-1)ⁿπ/6","2nπ+π/6","nπ-π/6"],"answer":1,"explanation":"sin: nπ+(-1)ⁿ α where sinα=1/2 → α=π/6"}]}$j$),

    (16, 'engineering', 'stat-eng-concept', 'concept', 1, 'सांख्यिकी — JEE',
     $j${"text":"Central tendency: mean (arithmetic, weighted, geometric), median, mode। Dispersion: range, variance (σ²=Σ(x-μ)²/N), standard deviation (σ), mean deviation। For grouped data: weighted formulas। Combined mean of two groups। Relation: Mode = 3Median - 2Mean (empirical)। Quartiles, percentiles।","note":"JEE में variance, SD, और combined mean ज़रूरी हैं।"}$j$),
    (16, 'engineering', 'stat-eng-formula', 'formula', 2, 'सांख्यिकी सूत्र',
     $j${"formula":"Mean = Σx/n · Variance σ² = Σ(x-μ)²/N = Σx²/N - μ² · SD = √variance · Combined mean = (n₁x̄₁ + n₂x̄₂)/(n₁+n₂)","explanation":"Median = middle (sorted) · Mode = most frequent · CV = (σ/mean) × 100% (coefficient of variation)"}$j$),
    (16, 'engineering', 'stat-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"2,4,4,6,8,10। Mean, variance?","solution":"Mean = 34/6 = 5.67। Σx² = 4+16+16+36+64+100 = 236। Var = 236/6 - 32.11 = 39.33 - 32.11 = 7.22","answer":"Mean=5.67, Var≈7.22, SD≈2.69"}$j$),
    (16, 'engineering', 'stat-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"Variance का unit?","options":["Same as data","Square of data unit","Unitless","Cube"],"answer":1,"explanation":"Variance = (unit)² · SD same as data unit"},{"q":"Empirical relation?","options":["Mode = 3Med - 2Mean","Mean = 3Med - 2Mode","Median = 3Mode - 2Mean","Mode = Mean"],"answer":0,"explanation":"Mode = 3(Median) - 2(Mean)"}]}$j$),

    -- ═══ ENGINEERING ENV 920 ═══
    (920, 'engineering', 'env-eng-concept', 'concept', 1, 'पर्यावरण — JEE',
     $j${"text":"Environment Engineering: air pollution (PM, SO₂, NOₓ, CO, O₃), water pollution (BOD, COD, DO), soil pollution, noise pollution (dB)। Greenhouse effect: CO₂, CH₄, N₂O, CFCs। Ozone depletion: CFC → Cl radical chain। Green chemistry: atom economy, catalytic, renewable। Pollution control: ESP, scrubbers, catalytic converters।","note":"JEE में pollution control और green chemistry ज़रूरी हैं।"}$j$),
    (920, 'engineering', 'env-eng-formula', 'formula', 2, 'पर्यावरण सूत्र',
     $j${"formula":"BOD = O₂ consumed by microbes (mg/L) · COD ≥ BOD · Greenhouse order: CO₂ > CH₄ > N₂O > CFCs (potency reverse)","explanation":"Atom economy = (mass of desired product/total mass of reactants) × 100 · pH normal rain = 5.6 (CO₂), acid rain < 5.6"}$j$),
    (920, 'engineering', 'env-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"Atom economy: C + O₂ → CO₂ (desired CO₂)। %?","solution":"Desired = CO₂ (44g), Total = C+O₂ (44g)","answer":"100% atom economy"}$j$),
    (920, 'engineering', 'env-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"Greenhouse gas highest potency?","options":["CO₂","CH₄","N₂O","CFCs"],"answer":3,"explanation":"CFCs most potent per molecule (thousands× CO₂)"},{"q":"BOD और COD relation?","options":["BOD > COD","BOD < COD","BOD = COD","No relation"],"answer":1,"explanation":"COD (chemical) > BOD (biological) - COD includes non-biodegradable"}]}$j$),

    -- ═══ CLASS 9-10 PHYSICS 870-882 ═══
    (870, 'class_9_10', 'phy-meas-910-concept', 'concept', 1, 'माप — Class 9-10',
     $j${"text":"Measurement में units ज़रूरी हैं। SI units: length=m, mass=kg, time=s, temperature=K, current=A। Fundamental vs derived units। Measurement tools: ruler (cm), measuring tape, balance (kg), stopwatch (s)। Significant figures: last digit uncertain।","note":"हर measurement में unit और instrument का नाम याद रखो।"}$j$),
    (870, 'class_9_10', 'phy-meas-910-formula', 'formula', 2, 'माप सूत्र',
     $j${"formula":"Length: m · Mass: kg · Time: s · Speed: m/s · Force: N = kg·m/s²","explanation":"1 km = 1000 m · 1 kg = 1000 g · 1 hour = 3600 s"}$j$),
    (870, 'class_9_10', 'phy-meas-910-example', 'example', 3, 'Board numerical',
     $j${"question":"5 km को metre में?","solution":"1 km = 1000 m → 5 × 1000","answer":"5000 m"}$j$),
    (870, 'class_9_10', 'phy-meas-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Force का SI unit?","options":["kg","m/s","Newton","Joule"],"answer":2,"explanation":"Force → Newton (N)"},{"q":"Mass का SI unit?","options":["g","kg","N","m"],"answer":1,"explanation":"Mass → kilogram (kg)"}]}$j$),

    (871, 'class_9_10', 'phy-motion-910-concept', 'concept', 1, 'गति — Class 9-10',
     $j${"text":"Motion: object की position का time के साथ बदलना। Distance = total path। Displacement = shortest path (direction के साथ)। Speed = distance/time (scalar)। Velocity = displacement/time (vector)। Acceleration = change in velocity/time। Uniform vs non-uniform motion।","note":"Board में speed vs velocity और distance vs displacement ज़रूरी हैं।"}$j$),
    (871, 'class_9_10', 'phy-motion-910-formula', 'formula', 2, 'गति सूत्र',
     $j${"formula":"Speed v = d/t · Velocity = s/t (with direction) · Acceleration a = (v-u)/t · v = u + at · s = ut + ½at²","explanation":"1 km/h = 1000m/3600s = (5/18) m/s"}$j$),
    (871, 'class_9_10', 'phy-motion-910-example', 'example', 3, 'Board numerical',
     $j${"question":"100 km, 2 hours। Speed?","solution":"v = 100/2","answer":"50 km/h"}$j$),
    (871, 'class_9_10', 'phy-motion-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Displacement का unit?","options":["m/s","m","m/s²","kg"],"answer":1,"explanation":"Displacement = distance, unit = m"},{"q":"Acceleration का unit?","options":["m/s","m","m/s²","kg"],"answer":2,"explanation":"a = Δv/t → m/s²"}]}$j$),

    (872, 'class_9_10', 'phy-force-910-concept', 'concept', 1, 'बल — Class 9-10',
     $j${"text":"Force = push or pull। Types: contact (friction, tension, normal) vs non-contact (gravity, magnetic, electrostatic)। Newton's 1st law: inertia। 2nd law: F = ma। 3rd law: action-reaction (equal, opposite)। Balanced vs unbalanced force। Momentum p = mv।","note":"Board में Newton's 3 laws और momentum ज़रूरी हैं।"}$j$),
    (872, 'class_9_10', 'phy-force-910-formula', 'formula', 2, 'बल सूत्र',
     $j${"formula":"F = ma · p = mv · Impulse = F×t = Δp · Weight W = mg (g=9.8 m/s²)","explanation":"1 N = 1 kg·m/s² · Balanced: net F = 0 (no acceleration) · Unbalanced: net F ≠ 0"}$j$),
    (872, 'class_9_10', 'phy-force-910-example', 'example', 3, 'Board numerical',
     $j${"question":"10 kg पर 20 N force। a?","solution":"F = ma → a = 20/10","answer":"2 m/s²"}$j$),
    (872, 'class_9_10', 'phy-force-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Newton's 1st law = ?","options":["F=ma","Inertia","Action-reaction","Momentum"],"answer":1,"explanation":"1st law = law of inertia"},{"q":"Force का unit?","options":["Joule","Newton","Watt","Pascal"],"answer":1,"explanation":"Force → Newton (N)"}]}$j$),

    (873, 'class_9_10', 'phy-work-910-concept', 'concept', 1, 'कार्य-ऊर्जा — Class 9-10',
     $j${"text":"Work = force × displacement (in direction of force)। Energy = capacity to do work। Types: kinetic (motion), potential (position)। Work-Energy theorem: W = ΔKE। Power = work/time। Conservation of energy: energy can't be created/destroyed, only transformed।","note":"Board में work-energy theorem और power ज़रूरी हैं।"}$j$),
    (873, 'class_9_10', 'phy-work-910-formula', 'formula', 2, 'कार्य-ऊर्जा सूत्र',
     $j${"formula":"W = F × d × cosθ · KE = ½mv² · PE = mgh · Power P = W/t · 1 kWh = 3.6 × 10⁶ J","explanation":"Commercial unit: 1 kWh = 1 unit (electricity bill)"}$j$),
    (873, 'class_9_10', 'phy-work-910-example', 'example', 3, 'Board numerical',
     $j${"question":"5 kg पर 10 N, 3 m displace। Work?","solution":"W = F×d = 10 × 3","answer":"30 J"}$j$),
    (873, 'class_9_10', 'phy-work-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Work का unit?","options":["Newton","Joule","Watt","Pascal"],"answer":1,"explanation":"Work → Joule (J)"},{"q":"Power का unit?","options":["J","N","W","Pa"],"answer":2,"explanation":"Power → Watt (J/s)"}]}$j$),

    (874, 'class_9_10', 'phy-grav-910-concept', 'concept', 1, 'गुरुत्वाकर्षण — Class 9-10',
     $j${"text":"Gravitation: every object attracts every other object। Newton's law: F = Gm₁m₂/r²। g = GM/R² ≈ 9.8 m/s² (Earth)। Mass vs weight: mass constant, weight = mg (depends on g)। Free fall: g acceleration। Moon का g ≈ 1.6 m/s² (Earth का ~1/6)।","note":"Board में g, mass vs weight, और free fall ज़रूरी हैं।"}$j$),
    (874, 'class_9_10', 'phy-grav-910-formula', 'formula', 2, 'गुरुत्व सूत्र',
     $j${"formula":"F = Gm₁m₂/r² · g = GM/R² ≈ 9.8 m/s² · W = mg · Free fall: v = gt, h = ½gt²","explanation":"G = 6.67 × 10⁻¹¹ N·m²/kg² · Moon g ≈ 1.6 m/s²"}$j$),
    (874, 'class_9_10', 'phy-grav-910-example', 'example', 3, 'Board numerical',
     $j${"question":"60 kg का weight Earth पर?","solution":"W = mg = 60 × 9.8","answer":"588 N"}$j$),
    (874, 'class_9_10', 'phy-grav-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"g का value?","options":["6.67","9.8","10","1.6"],"answer":1,"explanation":"g ≈ 9.8 m/s² on Earth"},{"q":"Moon पर weight?","options":["Same","1/6 Earth","6× Earth","0"],"answer":1,"explanation":"Moon g ≈ 1/6 Earth"}]}$j$),

    (875, 'class_9_10', 'phy-press-910-concept', 'concept', 1, 'दाब — Class 9-10',
     $j${"text":"Pressure = force/area। Unit Pascal (Pa = N/m²)। Atmospheric pressure ≈ 101325 Pa = 1 atm। Liquid pressure: P = ρgh (depth के साथ बढ़ता)। Archimedes: buoyant force = weight of displaced fluid। Float/sink: density comparison।","note":"Board में pressure, buoyancy, और Archimedes ज़रूरी हैं।"}$j$),
    (875, 'class_9_10', 'phy-press-910-formula', 'formula', 2, 'दाब सूत्र',
     $j${"formula":"P = F/A · P = ρgh · Buoyant F = ρVg · Density = mass/volume","explanation":"1 Pa = 1 N/m² · 1 atm = 1.013 × 10⁵ Pa = 760 mmHg · Float if density < water"}$j$),
    (875, 'class_9_10', 'phy-press-910-example', 'example', 3, 'Board numerical',
     $j${"question":"20 N on 0.5 m²। Pressure?","solution":"P = 20/0.5","answer":"40 Pa"}$j$),
    (875, 'class_9_10', 'phy-press-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Pressure का unit?","options":["N","Pa","J","W"],"answer":1,"explanation":"Pressure = N/m² = Pascal"},{"q":"Depth के साथ pressure?","options":["Decreases","Same","Increases","0"],"answer":2,"explanation":"P = ρgh → depth के साथ बढ़ता"}]}$j$),

    (876, 'class_9_10', 'phy-heat-910-concept', 'concept', 1, 'ऊष्मा — Class 9-10',
     $j${"text":"Heat vs temperature: heat = energy transferred, temperature = measure of hotness। Q = mcΔT (specific heat)। Latent heat: Q = mL (state change, no temp change)। Conduction, convection, radiation। Good/bad conductors। Thermometer: Celsius, Fahrenheit, Kelvin।","note":"Board में Q = mcΔT, latent heat, और heat transfer ज़रूरी हैं।"}$j$),
    (876, 'class_9_10', 'phy-heat-910-formula', 'formula', 2, 'ऊष्मा सूत्र',
     $j${"formula":"Q = mcΔT · Q = mL (latent) · K = °C + 273 · °F = (9/5)°C + 32","explanation":"Water specific heat = 4186 J/kg·K (high) · Ice latent Lf = 334 kJ/kg · Steam Lv = 2260 kJ/kg"}$j$),
    (876, 'class_9_10', 'phy-heat-910-example', 'example', 3, 'Board numerical',
     $j${"question":"1 kg पानी 20→30°C। Q? (c=4200)","solution":"Q = mcΔT = 1 × 4200 × 10","answer":"42000 J = 42 kJ"}$j$),
    (876, 'class_9_10', 'phy-heat-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"0°C में Kelvin?","options":["32","273","373","100"],"answer":1,"explanation":"K = 0+273 = 273"},{"q":"Latent heat में temp?","options":["बदलता","स्थिर","घटता","बढ़ता"],"answer":1,"explanation":"State change में temp constant"}]}$j$),

    (877, 'class_9_10', 'phy-wave-910-concept', 'concept', 1, 'तरंगें — Class 9-10',
     $j${"text":"Wave: disturbance that travels, energy transport। Types: mechanical (needs medium: sound, water) vs electromagnetic (no medium: light)। Longitudinal (compression/rarefaction) vs transverse (crest/trough)। Wave properties: wavelength λ, frequency f, amplitude A, speed v = fλ।","note":"Board में v = fλ और wave types ज़रूरी हैं।"}$j$),
    (877, 'class_9_10', 'phy-wave-910-formula', 'formula', 2, 'तरंग सूत्र',
     $j${"formula":"v = fλ · Period T = 1/f · Amplitude = max displacement","explanation":"Sound: longitudinal, needs medium · Light: transverse, no medium"}$j$),
    (877, 'class_9_10', 'phy-wave-910-example', 'example', 3, 'Board numerical',
     $j${"question":"f=50 Hz, λ=2 m। v?","solution":"v = fλ = 50 × 2","answer":"100 m/s"}$j$),
    (877, 'class_9_10', 'phy-wave-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Light wave type?","options":["Longitudinal","Transverse","Both","Neither"],"answer":1,"explanation":"Light = transverse electromagnetic"},{"q":"v=fλ में λ का unit?","options":["Hz","m","s","m/s"],"answer":1,"explanation":"λ = wavelength (m)"}]}$j$),

    (878, 'class_9_10', 'phy-sound-910-concept', 'concept', 1, 'ध्वनि — Class 9-10',
     $j${"text":"Sound: mechanical longitudinal wave, needs medium (air, water, solid)। Speed: solid > liquid > gas (air ≈ 343 m/s at 20°C)। Audible range: 20 Hz - 20 kHz। Ultrasonic > 20 kHz, infrasonic < 20 Hz। Frequency determines pitch, amplitude determines loudness। Reflection → echo।","note":"Board में sound speed comparison, audible range, और echo ज़रूरी हैं।"}$j$),
    (878, 'class_9_10', 'phy-sound-910-formula', 'formula', 2, 'ध्वनि सूत्र',
     $j${"formula":"v = fλ · Echo: 2d = v × t (d = distance) · Speed in air ≈ 343 m/s","explanation":"Solid > Liquid > Gas speed · Audible: 20 Hz - 20 kHz"}$j$),
    (878, 'class_9_10', 'phy-sound-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Echo 2s बाद। Distance? (v=340 m/s)","solution":"2d = v×t = 340×2 → d = 340","answer":"340 m"}$j$),
    (878, 'class_9_10', 'phy-sound-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Sound की speed सबसे ज़्यादा?","options":["Air","Water","Solid","Vacuum"],"answer":2,"explanation":"Solid > liquid > gas"},{"q":"Audible range?","options":["0-20 Hz","20 Hz-20 kHz",">20 kHz","0-20 kHz"],"answer":1,"explanation":"Human: 20 Hz to 20,000 Hz"}]}$j$),

    (879, 'class_9_10', 'phy-light-910-concept', 'concept', 1, 'प्रकाश — Class 9-10',
     $j${"text":"Light: electromagnetic wave, travels in straight lines (rectilinear propagation)। Reflection: mirror (regular/irregular)। Laws: incident ray, reflected ray, normal all in same plane, ∠i = ∠r। Types of mirrors: plane, concave (converging), convex (diverging)। Refraction: bending of light due to speed change।","note":"Board में reflection laws और mirror types ज़रूरी हैं।"}$j$),
    (879, 'class_9_10', 'phy-light-910-formula', 'formula', 2, 'प्रकाश सूत्र',
     $j${"formula":"∠i = ∠r (reflection) · 1/f = 1/v + 1/u (mirror) · m = -v/u","explanation":"Concave mirror: converging (f positive) · Convex: diverging (f negative) · Plane mirror: f = ∞, m = 1"}$j$),
    (879, 'class_9_10', 'phy-light-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Concave mirror f=10cm, object 20cm। Image?","solution":"Object 20 cm (C पर), f = 10 cm। 1/v = 1/f − 1/u = 1/10 − 1/20 = 1/20 → v = 20 cm","answer":"Real, inverted image at 20 cm (C पर, same size)"}$j$),
    (879, 'class_9_10', 'phy-light-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Concave mirror converging क्यों?","options":["Diverge","Converge","Parallel","None"],"answer":1,"explanation":"Concave mirror converges light to focus"},{"q":"Reflection law?","options":["∠i = ∠r","∠i = 2∠r","∠i = 90°","∠r = 0"],"answer":0,"explanation":"∠i = ∠r (equal angles)"}]}$j$),

    (880, 'class_9_10', 'elec-910-concept', 'concept', 1, 'विद्युत — Class 9-10',
     $j${"text":"Electric current: flow of charge, unit Ampere (A)। Ohm's law: V = IR (constant temp)। Resistance: opposition to flow, unit Ohm (Ω)। Series: R_total = R₁ + R₂; parallel: 1/R = 1/R₁ + 1/R₂। Electric power: P = VI = I²R = V²/R। Fuse, earth wire, live wire (household circuit)।","note":"Board में Ohm's law और series/parallel ज़रूरी हैं।"}$j$),
    (880, 'class_9_10', 'elec-910-formula', 'formula', 2, 'विद्युत सूत्र',
     $j${"formula":"V = IR · P = VI = I²R = V²/R · Series: R = R₁+R₂ · Parallel: 1/R = 1/R₁+1/R₂ · E = Pt","explanation":"1 kWh = 1 unit = 3.6 × 10⁶ J"}$j$),
    (880, 'class_9_10', 'elec-910-example', 'example', 3, 'Board numerical',
     $j${"question":"12 V, 3 Ω। Current?","solution":"I = V/R = 12/3","answer":"4 A"}$j$),
    (880, 'class_9_10', 'elec-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Ohm's law?","options":["V = I/R","V = IR","V = I²R","I = VR"],"answer":1,"explanation":"Ohm's law: V = IR"},{"q":"Series combination?","options":["1/R = 1/R₁+1/R₂","R = R₁+R₂","R = R₁R₂","R = 0"],"answer":1,"explanation":"Series: R total = sum"}]}$j$),

    (881, 'class_9_10', 'mag-910-concept', 'concept', 1, 'चुंबकत्व — Class 9-10',
     $j${"text":"Magnetic effect of current: Oersted (current → magnetic field)। Electromagnet (coil + iron core)। Right-hand thumb rule (direction)। Magnetic field lines: from N to S outside magnet। Solenoid: uniform field inside। Electromagnetic induction: Faraday (changing magnetic field → current), applications: generator, transformer।","note":"Board में right-hand rule और induction ज़रूरी हैं।"}$j$),
    (881, 'class_9_10', 'mag-910-formula', 'formula', 2, 'चुंबकत्व सूत्र',
     $j${"formula":"Right-hand rule: thumb = current, fingers = B field · Faraday: EMF = -dΦ/dt · Transformer: V_s/V_p = N_s/N_p","explanation":"Electromagnet: core + coil + current · AC vs DC"}$j$),
    (881, 'class_9_10', 'mag-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Transformer: N_p=100, N_s=500, V_p=220। V_s?","solution":"V_s/V_p = N_s/N_p → V_s = 220 × 500/100","answer":"V_s = 1100 V (step-up)"}$j$),
    (881, 'class_9_10', 'mag-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Right-hand thumb rule क्या देता है?","options":["Voltage","Magnetic field direction","Resistance","Current"],"answer":1,"explanation":"Thumb = current, fingers = B field direction"},{"q":"Transformer किस principle?","options":["Ohm's law","Electromagnetic induction","Newton's law","Faraday electrolysis"],"answer":1,"explanation":"Mutual induction (Faraday)"}]}$j$),

    (882, 'class_9_10', 'modern-910-concept', 'concept', 1, 'आधुनिक भौतिकी — Class 9-10',
     $j${"text":"Modern Physics: atom structure (proton, neutron, electron)। Nucleus: protons + neutrons, held by strong nuclear force। Radioactivity: α (He nucleus), β (electron), γ (photon)। Nuclear fission (heavy → light, releases energy — nuclear reactor)। Nuclear fusion (light → heavy, releases more energy — Sun)। Einstein: E = mc²।","note":"Board में radioactivity types और fission/fusion ज़रूरी हैं।"}$j$),
    (882, 'class_9_10', 'modern-910-formula', 'formula', 2, 'आधुनिक भौतिकी सूत्र',
     $j${"formula":"E = mc² · Fission: U-235 + n → Ba + Kr + 3n + energy · Fusion: 4H → He + energy","explanation":"α: ⁴₂He · β: ⁰₋₁e · γ: photon · Reactor: control rods (B, Cd) absorb neutrons"}$j$),
    (882, 'class_9_10', 'modern-910-example', 'example', 3, 'Board numerical',
     $j${"question":"E = mc²: 1g mass → energy?","solution":"E = 10⁻³ × (3×10⁸)² = 10⁻³ × 9×10¹⁶","answer":"9 × 10¹³ J"}$j$),
    (882, 'class_9_10', 'modern-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Sun में energy source?","options":["Fission","Fusion","Chemical","Radioactive decay"],"answer":1,"explanation":"Sun: nuclear fusion (H → He)"},{"q":"α particle = ?","options":["Electron","Photon","He nucleus","Proton"],"answer":2,"explanation":"α = ⁴₂He nucleus (2p + 2n)"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], 
  case when s.level_id = 'class_9_10' then array['class_9', 'class_10']::text[] else '{}'::text[] end,
  case when s.chapter_id < 20 then 'maths' 
       when s.chapter_id = 920 then 'environment'
       else 'general-science' end,
  case when s.level_id = 'class_9_10' then 'easy' else 'hard' end,
  md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select level_id, count(*) from mtb.atoms 
-- where chapter_id in (11,12,13,14,15,16,920,870,871,872,873,874,875,876,877,878,879,880,881,882) 
--   and status='published' and not archived 
-- group by level_id;
-- Expected: engineering: chapters 11-16 (24 atoms) + 920 (4 atoms) = 28
--          class_9_10: chapters 870-882 (52 atoms) 
--          Note: class_9_10 may have pre-existing atoms (870 has 3, 871 has 4, 872 has 0? etc.)

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: 1219 + 80 = 1299