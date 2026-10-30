with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ DEFENCE REASONING (17,18,19,27,28,423,425) ═══
    (17, 'govt_defence', 'ser-def-concept', 'concept', 1, 'श्रृंखला — NDA/CDS',
     $j${"text":"Series patterns: +n, ×n, square, cube, alternate. Defence: coded messages, sequence decoding, target prioritization series. Double difference method for complex series.","note":"Defence में sequence decoding और pattern recognition ज़रूरी हैं।"}$j$),
    (17, 'govt_defence', 'ser-def-formula', 'formula', 2, 'श्रृंखला सूत्र',
     $j${"formula":"+n: 2,4,6,8 · ×n: 2,4,8,16 · Square: 1,4,9,16 · Cube: 1,8,27,64","explanation":"Alternate series: odd positions separate from even positions"}$j$),
    (17, 'govt_defence', 'ser-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"3, 6, 12, 24, ?","solution":"×2 pattern","answer":"48"}$j$),
    (17, 'govt_defence', 'ser-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"1, 4, 9, 16, ?","options":["20","24","25","36"],"answer":2,"explanation":"Squares → 5² = 25"},{"q":"2, 5, 10, 17, ?","solution":"Differ: 3,5,7 (arithmetic +2)। Next diff = 9। 17+9=26","options":["24","26","28","30"],"answer":1,"explanation":"Differences 3,5,7,9 → 26"}]}$j$),

    (18, 'govt_defence', 'ana-def-concept', 'concept', 1, 'सादृश्यता — NDA/CDS',
     $j${"text":"Analogy: relation types — worker:place, tool:action, cause:effect, part:whole, synonym, antonym. Defence: weapon:function, rank:hierarchy. Number analogy: n:n², n:n³.","note":"Defence में weapon-function और rank hierarchy ज़रूरी हैं।"}$j$),
    (18, 'govt_defence', 'ana-def-formula', 'formula', 2, 'सादृश्यता सूत्र',
     $j${"formula":"Worker:Place · Tool:Action · Weapon:Function · Rank:Seniority · n:n² or n:n³","explanation":"Rifle:Shoot · Tank:Armor · General:Army"}$j$),
    (18, 'govt_defence', 'ana-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Rifle:Shoot :: Tank:?","solution":"Rifle shoots, tank fires/blasts","answer":"Fire (or Blast)"}$j$),
    (18, 'govt_defence', 'ana-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Captain:Major :: Lieutenant Colonel:?","options":["Colonel","Brigadier","General","Sepoy"],"answer":0,"explanation":"Each is the next rank up: Captain→Major→Lt Col→Colonel"},{"q":"3:27 :: 5:?","options":["25","75","125","150"],"answer":2,"explanation":"3³=27, 5³=125"}]}$j$),

    (19, 'govt_defence', 'odd-def-concept', 'concept', 1, 'विषम तत्व — NDA/CDS',
     $j${"text":"Odd One Out: category check, number pattern, letter property. Defence: weapon categories (rifle, pistol — not tank), aircraft types (fighter, bomber — not carrier), rank categories.","note":"Defence में weapon/aircraft category classification ज़रूरी है।"}$j$),
    (19, 'govt_defence', 'odd-def-formula', 'formula', 2, 'विषम सूत्र',
     $j${"formula":"Categories: small arms (rifle, pistol), heavy (tank, artillery), aircraft (fighter, bomber), naval (destroyer, frigate)","explanation":"Number properties: even/odd, prime/composite, square/cube"}$j$),
    (19, 'govt_defence', 'odd-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Rifle, Pistol, Tank, Revolver — विषम?","solution":"Rifle, pistol, revolver = small arms; tank = heavy","answer":"Tank"}$j$),
    (19, 'govt_defence', 'odd-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Fighter, Bomber, Tanker, Submarine — विषम?","options":["Fighter","Bomber","Tanker","Submarine"],"answer":3,"explanation":"Submarine = naval, बाकी aircraft"},{"q":"2, 3, 5, 7, 9, 11 — विषम?","options":["5","7","9","11"],"answer":2,"explanation":"9 not prime"}]}$j$),

    (27, 'govt_defence', 'venn-def-concept', 'concept', 1, 'वेन आरेख — NDA/CDS',
     $j${"text":"Venn: sets overlap. n(A∪B) = n(A)+n(B)-n(A∩B). Defence: personnel with multiple skills (combat + medical), units with overlapping equipment. 2-3 sets.","note":"Defence में multi-skill personnel और overlapping resources ज़रूरी हैं।"}$j$),
    (27, 'govt_defence', 'venn-def-formula', 'formula', 2, 'वेन सूत्र',
     $j${"formula":"n(A∪B) = n(A)+n(B)-n(A∩B) · Only A = n(A)-n(A∩B) · Neither = Total-n(A∪B)","explanation":"3 sets: n(A∪B∪C) = Σn - Σpair + n(A∩B∩C)"}$j$),
    (27, 'govt_defence', 'venn-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"100 soldiers: 60 rifles, 50 pistols, 30 both। Only rifles?","solution":"60-30","answer":"30"}$j$),
    (27, 'govt_defence', 'venn-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Above: neither?","solution":"R∪P = 60+50-30 = 80। Neither = 100-80 = 20","options":["10","20","30","40"],"answer":1,"explanation":"100-80 = 20"},{"q":"3 A, 2 B, 1 both। At least one?","options":["4","5","6","7"],"answer":0,"explanation":"3+2-1 = 4"}]}$j$),

    (28, 'govt_defence', 'stmt-def-concept', 'concept', 1, 'कथन तर्क — NDA/CDS',
     $j${"text":"Statements: inference, comparison chains, data sufficiency. Defence intelligence analysis — information validity. A>B, B>C → A>C. 'Cannot determine' when info incomplete.","note":"Defence में intelligence analysis और logical inference ज़रूरी हैं।"}$j$),
    (28, 'govt_defence', 'stmt-def-formula', 'formula', 2, 'कथन सूत्र',
     $j${"formula":"A>B, B>C → A>C · A>B, B=C → A>C · A≥B, B≥C → A≥C","explanation":"Valid inference = true in ALL cases · Data sufficiency: I alone, II alone, both, or neither"}$j$),
    (28, 'govt_defence', 'stmt-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Tank A>B, B>C, C>D। Strongest?","solution":"A>B>C>D","answer":"Tank A"}$j$),
    (28, 'govt_defence', 'stmt-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"All missiles are weapons। Some weapons are tanks। Conclusion?","options":["All missiles are tanks","Some missiles are tanks","Cannot determine","No missiles are tanks"],"answer":2,"explanation":"Cannot determine (missiles/tanks overlap unknown)"},{"q":"A>B, B<C। A vs C?","options":["A>C","A<C","A=C","Cannot determine"],"answer":3,"explanation":"C>B, A>B — A/C relation unknown"}]}$j$),

    (423, 'govt_defence', 'alpha-def-concept', 'concept', 1, 'वर्णमाला — NDA/CDS',
     $j${"text":"Alphabet positions: A=1 to Z=26. EJOTY trick (E=5, J=10, O=15, T=20, Y=25). Opposite sum = 27. Defence: coded messages, radio alphabet (Alpha, Bravo...), navigation codes.","note":"Defence में NATO alphabet और code letters ज़रूरी हैं।"}$j$),
    (423, 'govt_defence', 'alpha-def-formula', 'formula', 2, 'वर्णमाला सूत्र',
     $j${"formula":"A=1, B=2, ..., Z=26 · Opposite = 27 - position · EJOTY: 5,10,15,20,25","explanation":"NATO: A=Alpha, B=Bravo, ..., Z=Zulu"}$j$),
    (423, 'govt_defence', 'alpha-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"NATO alphabet में 'F'?","solution":"Foxtrot","answer":"Foxtrot"}$j$),
    (423, 'govt_defence', 'alpha-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"NATO for 'T'?","options":["Tango","Tiger","Tower","Tank"],"answer":0,"explanation":"T = Tango"},{"q":"A, C, E, G, ?","solution":"+2 (1,3,5,7,9)","options":["H","I","J","K"],"answer":1,"explanation":"I (9)"}]}$j$),

    (425, 'govt_defence', 'blood-def-concept', 'concept', 1, 'रक्त संबंध — NDA/CDS',
     $j${"text":"Blood relations: family tree with symbols. Defence: family lineage questions, inheritance, next-of-kin identification (for casualty notification)। Pointing questions. 2-3 generations.","note":"Defence में family tree, inheritance, और next-of-kin ज़रूरी हैं।"}$j$),
    (425, 'govt_defence', 'blood-def-formula', 'formula', 2, 'रक्त संबंध सूत्र',
     $j${"formula":"Father's father = दादा · Mother's father = नाना · Father's brother = चाचा · Mother's brother = मामा","explanation":"'X's father's son' = X's brother/self · 'Brother's father' = father"}$j$),
    (425, 'govt_defence', 'blood-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"'मेरे पिता के भाई' — कौन?","solution":"Father's brother","answer":"चाचा (uncle)"}$j$),
    (425, 'govt_defence', 'blood-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Mother's brother?","options":["चाचा","मामा","फूफा","मौसा"],"answer":1,"explanation":"Mother's brother = मामा"},{"q":"'Only son of my grandfather'?","options":["Father","Uncle","Brother","Self"],"answer":0,"explanation":"Grandfather's only son = Father"}]}$j$),

    -- ═══ DEFENCE MATHS 12-16 ═══
    (12, 'govt_defence', 'alg-def-concept', 'concept', 1, 'बीजगणित — NDA/CDS',
     $j${"text":"Algebra: linear equations, quadratic, polynomials. Defence: ballistics (projectile path), fuel consumption (linear), supply chain, ballistic equation. Roots: α+β=-b/a, αβ=c/a. Discriminant D=b²-4ac.","note":"Defence में ballistics और linear equations ज़रूरी हैं।"}$j$),
    (12, 'govt_defence', 'alg-def-formula', 'formula', 2, 'बीजगणित सूत्र',
     $j${"formula":"Quadratic: x=(-b±√D)/2a, D=b²-4ac · Sum=-b/a, Product=c/a · (a+b)²=a²+2ab+b²","explanation":"D>0 real, D=0 equal, D<0 complex · Ballistic path: y = x tanθ - gx²/(2u²cos²θ)"}$j$),
    (12, 'govt_defence', 'alg-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"x²-6x+8=0। Roots?","solution":"D=36-32=4। x=(6±2)/2","answer":"x=4, 2"}$j$),
    (12, 'govt_defence', 'alg-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"x²-5x+6=0 roots?","options":["1,6","2,3","-2,-3","-1,-6"],"answer":1,"explanation":"Sum=5, product=6 → 2,3"},{"q":"(a+b)² = ?","options":["a²+b²","a²+2ab+b²","a²-2ab+b²","(a+b)(a-b)"],"answer":1,"explanation":"Standard identity"}]}$j$),

    (13, 'govt_defence', 'mens-def-concept', 'concept', 1, 'क्षेत्रमिति — NDA/CDS',
     $j${"text":"Mensuration: area, volume, surface area. Defence: bunker volume, ammunition storage, fuel tank capacity, runway area, radar coverage area (circular). Circle, sphere, cylinder, cone.","note":"Defence में bunker, tank, और runway measurements ज़रूरी हैं।"}$j$),
    (13, 'govt_defence', 'mens-def-formula', 'formula', 2, 'क्षेत्रमिति सूत्र',
     $j${"formula":"Circle: A=πr², C=2πr · Sphere: V=⁴/₃πr³, A=4πr² · Cylinder: V=πr²h, CSA=2πrh · Cone: V=⅓πr²h","explanation":"Cuboid: V=lbh · Triangle: A=½bh · π=22/7 or 3.14"}$j$),
    (13, 'govt_defence', 'mens-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Cylinder fuel tank r=2m, h=5m। Volume?","solution":"V = π×4×5 = 20π","answer":"≈ 62.8 m³"}$j$),
    (13, 'govt_defence', 'mens-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Radar coverage radius 100 km। Area?","options":["10000π km²","1000π km²","π×10⁴ km²","Both 1 and 3"],"answer":3,"explanation":"A = πr² = 10000π km² = π×10⁴ km²"},{"q":"Sphere r=7। V (π=22/7)?","options":["1437","4312","1500","1000"],"answer":0,"explanation":"V=⁴/₃×22/7×343 ≈ 1437"}]}$j$),

    (14, 'govt_defence', 'geo-def-concept', 'concept', 1, 'ज्यामिति — NDA/CDS',
     $j${"text":"Geometry: triangle properties, circle theorems, coordinate geometry, trigonometric ratios in right triangle. Defence: triangulation for range finding, bearings, map coordinates, navigation. Pythagoras: a²+b²=c².","note":"Defence में triangulation, bearings, और map coordinates ज़रूरी हैं।"}$j$),
    (14, 'govt_defence', 'geo-def-formula', 'formula', 2, 'ज्यामिति सूत्र',
     $j${"formula":"Triangle sum=180° · Pythagoras: a²+b²=c² · Distance: √[(x₂-x₁)²+(y₂-y₁)²] · Slope: (y₂-y₁)/(x₂-x₁)","explanation":"Right triangle: sin=opp/hyp, cos=adj/hyp, tan=opp/adj · Bearing: angle from North (clockwise)"}$j$),
    (14, 'govt_defence', 'geo-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Observer 100m height, target at horizontal 200m। Line-of-sight distance?","solution":"√(100²+200²) = √50000","answer":"≈ 223.6 m"}$j$),
    (14, 'govt_defence', 'geo-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"3-4-? triangle","options":["5","6","7","8"],"answer":0,"explanation":"Pythagorean triple 3-4-5"},{"q":"Distance (0,0) to (6,8)?","options":["10","12","14","16"],"answer":0,"explanation":"√(36+64)=10"}]}$j$),

    (15, 'govt_defence', 'trig-def-concept', 'concept', 1, 'त्रिकोणमिति — NDA/CDS',
     $j${"text":"Trigonometry: sine, cosine, tangent, standard angles. Defence: artillery elevation angle, aircraft climb angle, missile trajectory, radar sweep. Height and distance problems. sin²θ+cos²θ=1.","note":"Defence में artillery elevation, aircraft climb, और height-distance ज़रूरी हैं।"}$j$),
    (15, 'govt_defence', 'trig-def-formula', 'formula', 2, 'त्रिकोणमिति सूत्र',
     $j${"formula":"sin=opp/hyp · cos=adj/hyp · tan=opp/adj = sin/cos · sin²θ+cos²θ=1","explanation":"sin30=1/2, sin45=1/√2, sin60=√3/2, sin90=1 · tan45=1, tan60=√3"}$j$),
    (15, 'govt_defence', 'trig-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Artillery angle 30°, distance 1000m। Height reached?","solution":"h = d × tanθ = 1000 × tan30° = 1000 × 1/√3","answer":"≈ 577 m"}$j$),
    (15, 'govt_defence', 'trig-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"sin 45°?","options":["1/2","1/√2","√3/2","1"],"answer":1,"explanation":"sin45 = 1/√2"},{"q":"Aircraft climb 30°, horizontal 1000m। Altitude?","solution":"h = 1000 × tan30° = 577m","options":["500m","577m","866m","1000m"],"answer":1,"explanation":"1000×1/√3 ≈ 577m"}]}$j$),

    (16, 'govt_defence', 'stat-def-concept', 'concept', 1, 'सांख्यिकी — NDA/CDS',
     $j${"text":"Statistics: mean, median, mode, standard deviation. Defence: ammunition accuracy (mean deviation), performance stats, casualty rate, equipment reliability. Normal distribution. CV = σ/mean × 100%.","note":"Defence में accuracy stats, performance, और reliability ज़रूरी हैं।"}$j$),
    (16, 'govt_defence', 'stat-def-formula', 'formula', 2, 'सांख्यिकी सूत्र',
     $j${"formula":"Mean = Σx/n · Median = middle · Mode = most frequent · σ = √(Σ(x-μ)²/n)","explanation":"CV = σ/mean × 100% (relative variability) · Accuracy: mean deviation from target"}$j$),
    (16, 'govt_defence', 'stat-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Shots: 5, 7, 8, 9, 11 (accuracy score)। Mean?","solution":"Sum=40, n=5","answer":"8"}$j$),
    (16, 'govt_defence', 'stat-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Shots 8, 9, 9, 10, 14। Median?","options":["9","9.5","10","11"],"answer":0,"explanation":"Middle value = 9"},{"q":"Mode of 3,3,5,7,7,7,9?","options":["3","5","7","9"],"answer":2,"explanation":"7 appears most (3 times)"}]}$j$),

    -- ═══ DEFENCE GA (415,417,418,419,421,422,38,40) ═══
    (415, 'govt_defence', 'comp-def-concept', 'concept', 1, 'कंप्यूटर — NDA/CDS',
     $j${"text":"Defence computers: command & control systems, fire control, radar processing, missile guidance, encryption/cyber warfare. Basic hardware (CPU, RAM, HDD), memory units (KB→TB), cybersecurity (firewall, encryption)। Cyber attack types: malware, phishing, DoS.","note":"Defence में cyber warfare, encryption, और command systems ज़रूरी हैं।"}$j$),
    (415, 'govt_defence', 'comp-def-formula', 'formula', 2, 'कंप्यूटर तथ्य',
     $j${"formula":"1 byte = 8 bits · 1 KB = 1024 bytes · 1 MB = 1024 KB · 1 GB = 1024 MB · 1 TB = 1024 GB","explanation":"Encryption: AES-256 (military) · Firewall, IDS, VPN for security"}$j$),
    (415, 'govt_defence', 'comp-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"1 TB में GB?","solution":"1024","answer":"1024 GB"}$j$),
    (415, 'govt_defence', 'comp-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Encryption standard military?","options":["MD5","AES-256","DES","SHA-1"],"answer":1,"explanation":"AES-256 (strong, widely used)"},{"q":"CPU का function?","options":["Storage","Processing","Display","Network"],"answer":1,"explanation":"CPU = processing (brain)"}]}$j$),

    (417, 'govt_defence', 'eco-def-concept', 'concept', 1, 'अर्थव्यवस्था — NDA/CDS',
     $j${"text":"Defence economy: defence budget (~2% GDP India), defence procurement (import/export), GDP, inflation, defence industry (HAL, BEL, DRDO)। FDI in defence. Russia/Israel/US as arms suppliers. Indian defence exports growing.","note":"Defence में budget, procurement, और industry ज़रूरी हैं।"}$j$),
    (417, 'govt_defence', 'eco-def-formula', 'formula', 2, 'अर्थव्यवस्था तथ्य',
     $j${"formula":"GDP = C+I+G+(X-M) · Defence budget ≈ 2% GDP (India) · Inflation: price rise","explanation":"Defence PSUs: HAL (aircraft), BEL (electronics), BDL (missiles), DRDO (research)"}$j$),
    (417, 'govt_defence', 'eco-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"GDP $3T, 2% defence। Budget?","solution":"3 × 0.02","answer":"$60 billion"}$j$),
    (417, 'govt_defence', 'eco-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"India's defence budget % GDP?","options":["1%","2%","5%","10%"],"answer":1,"explanation":"≈2% of GDP"},{"q":"DRDO does?","options":["Aircraft only","Research & development","Banking","Trade"],"answer":1,"explanation":"Defence Research & Development Organisation"}]}$j$),

    (418, 'govt_defence', 'geo2-def-concept', 'concept', 1, 'भूगोल — NDA/CDS',
     $j${"text":"Defence geography: terrain analysis (mountain, desert, jungle, arctic), strategic locations (LAC, LoC, coastal borders), India's neighbours (China, Pakistan, Nepal, Bhutan, Bangladesh, Myanmar, Sri Lanka, Afghanistan), maritime boundaries (7,500 km coastline). Strategic straits: Malacca, Hormuz.","note":"Defence में terrain, borders, और strategic straits ज़रूरी हैं।"}$j$),
    (418, 'govt_defence', 'geo2-def-formula', 'formula', 2, 'भूगोल तथ्य',
     $j${"formula":"India: 15,200 km land border, 7,500 km coastline · Neighbours: 7 (China, Pak, Nepal, Bhutan, BD, Myanmar, Afghanistan)","explanation":"Strategic straits: Malacca (Indian Ocean), Hormuz (Persian Gulf), Suez (Egypt)"}$j$),
    (418, 'govt_defence', 'geo2-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"India land border length?","solution":"≈ 15,200 km","answer":"15,200 km"}$j$),
    (418, 'govt_defence', 'geo2-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"India coastline?","options":["5,000 km","7,500 km","10,000 km","15,000 km"],"answer":1,"explanation":"7,500 km (mainland + islands)"},{"q":"China border name?","options":["LoC","LAC","Radcliffe","Durand"],"answer":1,"explanation":"LAC (Line of Actual Control)"}]}$j$),

    (419, 'govt_defence', 'hist-def-concept', 'concept', 1, 'इतिहास — NDA/CDS',
     $j${"text":"Defence history: major wars (1947, 1962, 1965, 1971, 1999 Kargil), military leaders, independence 1947, British Indian Army heritage. 1971 war created Bangladesh. Kargil (1999) — Operation Vijay. Surgical strikes (2016), Balakot (2019)।","note":"Defence में wars, dates, और operations ज़रूरी हैं।"}$j$),
    (419, 'govt_defence', 'hist-def-formula', 'formula', 2, 'इतिहास तथ्य',
     $j${"formula":"Indo-Pak wars: 1947, 1965, 1971, 1999 (Kargil) · India-China: 1962","explanation":"1971: Bangladesh creation · Kargil 1999: Operation Vijay · Surgical strikes 2016, Balakot 2019"}$j$),
    (419, 'govt_defence', 'hist-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Kargil war year?","solution":"1999","answer":"1999 (Operation Vijay)"}$j$),
    (419, 'govt_defence', 'hist-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"1971 war result?","options":["No change","Bangladesh creation","Kashmir issue","Ceasefire only"],"answer":1,"explanation":"Bangladesh created (East Pakistan → Bangladesh)"},{"q":"Kargil operation name?","options":["Vijay","Meghdoot","Cactus","Safed Sagar"],"answer":0,"explanation":"Operation Vijay (1999)"}]}$j$),

    (421, 'govt_defence', 'pol-def-concept', 'concept', 1, 'राजव्यवस्था — NDA/CDS',
     $j${"text":"Defence polity: President = Supreme Commander of Armed Forces, PM = head of government, Defence Minister (civilian control)। Parliament controls defence budget. Armed Forces: Army, Navy, Air Force. Paramilitary: BSF, CRPF, ITBP, SSB, CISF, Assam Rifles. Article 352 (national emergency)।","note":"Defence में Supreme Commander, civilian control, और armed forces ज़रूरी हैं।"}$j$),
    (421, 'govt_defence', 'pol-def-formula', 'formula', 2, 'राजव्यवस्था तथ्य',
     $j${"formula":"President = Supreme Commander · Defence Minister (civilian) · 3 services: Army, Navy, Air Force · Paramilitary: BSF, CRPF, ITBP, SSB, CISF","explanation":"Article 352: National Emergency (war/external aggression) · Article 53: executive power of Union vested in President"}$j$),
    (421, 'govt_defence', 'pol-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Supreme Commander of Armed Forces?","solution":"President of India","answer":"President"}$j$),
    (421, 'govt_defence', 'pol-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Supreme Commander?","options":["PM","President","Defence Minister","CDS"],"answer":1,"explanation":"President (Article 53)"},{"q":"Border guarding force?","options":["CRPF","BSF","CISF","SSB"],"answer":1,"explanation":"BSF (Border Security Force)"}]}$j$),

    (422, 'govt_defence', 'sgk-def-concept', 'concept', 1, 'स्थिर GK — NDA/CDS',
     $j${"text":"Defence static GK: ranks (Army: Sepoy→Field Marshal, Navy: Seaman→Admiral of Fleet, Air Force: Airman→Marshal of Air Force), gallantry awards (Param Vir Chakra, Maha Vir Chakra, Vir Chakra), defence academies (NDA Khadakwasla, IMA Dehradun, OTA Chennai, NDA). Regimental centres.","note":"Defence में ranks, awards, और academies ज़रूरी हैं।"}$j$),
    (422, 'govt_defence', 'sgk-def-formula', 'formula', 2, 'स्थिर तथ्य',
     $j${"formula":"Highest gallantry: Param Vir Chakra (Army), Maha Vir Chakra (2nd), Vir Chakra (3rd)","explanation":"NDA: Khadakwasla (Pune) · IMA: Dehradun · OTA: Chennai · Air Force Academy: Dundigal"}$j$),
    (422, 'govt_defence', 'sgk-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Highest gallantry award?","solution":"Param Vir Chakra","answer":"Param Vir Chakra"}$j$),
    (422, 'govt_defence', 'sgk-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"IMA कहाँ?","options":["Pune","Dehradun","Chennai","Delhi"],"answer":1,"explanation":"Indian Military Academy, Dehradun"},{"q":"Highest gallantry?","options":["Vir Chakra","Maha Vir","Param Vir","Shaurya Chakra"],"answer":2,"explanation":"Param Vir Chakra (highest)"}]}$j$),

    (38, 'govt_defence', 'cult-def-concept', 'concept', 1, 'कला-संस्कृति — NDA/CDS',
     $j${"text":"Defence culture: regimental traditions (war cries, mottos), military music (bands), ceremonial (Republic Day parade, Beating Retreat), martial races heritage (Sikh, Gorkha, Rajput, Jat, Maratha regiments), Indian military history heritage (forts, war memorials)।","note":"Defence में regimental traditions, military music, और ceremonial ज़रूरी हैं।"}$j$),
    (38, 'govt_defence', 'cult-def-formula', 'formula', 2, 'कला-संस्कृति तथ्य',
     $j${"formula":"War cries: Sikh 'Bole So Nihal', Gorkha 'Jai Mahakali', Rajput 'Bol Bajrang Bali ki Jai'","explanation":"Republic Day parade: 26 Jan · Beating Retreat: 29 Jan · War memorial: India Gate (Delhi)"}$j$),
    (38, 'govt_defence', 'cult-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Beating Retreat कब?","solution":"29 January (3 days after Republic Day)","answer":"29 January"}$j$),
    (38, 'govt_defence', 'cult-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Sikh Regiment war cry?","options":["Jai Mahakali","Bole So Nihal","Bol Bajrang Bali","Durga Mata ki Jai"],"answer":1,"explanation":"'Bole So Nihal, Sat Sri Akal'"},{"q":"Beating Retreat?","options":["26 Jan","28 Jan","29 Jan","31 Jan"],"answer":2,"explanation":"29 January"}]}$j$),

    (40, 'govt_defence', 'scitech-def-concept', 'concept', 1, 'विज्ञान-प्रौद्योगिकी — NDA/CDS',
     $j${"text":"Defence technology: missiles (Agni, Prithvi, BrahMos, Akash, Trishul, Nag), aircraft (Tejas LCA, Sukhoi Su-30MKI, Rafale), tanks (Arjun, T-90), submarines (Arihant nuclear, Scorpene), radar, stealth, drones. DRDO developed. Anti-satellite weapon (Mission Shakti 2019)।","note":"Defence में missiles, aircraft, और indigenous technology ज़रूरी हैं।"}$j$),
    (40, 'govt_defence', 'scitech-def-formula', 'formula', 2, 'विज्ञान-प्रौद्योगिकी तथ्य',
     $j${"formula":"Agni (ballistic), Prithvi (short-range), BrahMos (supersonic cruise, India-Russia), Akash (SAM), Nag (anti-tank)","explanation":"Tejas: LCA (HAL) · Arjun: MBT (DRDO) · Arihant: nuclear submarine · Mission Shakti: ASAT (2019)"}$j$),
    (40, 'govt_defence', 'scitech-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"BrahMos किस type?","solution":"Supersonic cruise missile (India-Russia)","answer":"Supersonic cruise missile (Mach 2.8+)"}$j$),
    (40, 'govt_defence', 'scitech-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"India's nuclear submarine?","options":["Arihant","Chakra","Vikrant","Kolkata"],"answer":0,"explanation":"INS Arihant (indigenous nuclear submarine)"},{"q":"BrahMos किस class?","options":["Ballistic","Cruise","SAM","Anti-tank"],"answer":1,"explanation":"Supersonic cruise missile"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[],
  case when s.chapter_id < 20 then 'maths' 
       when s.chapter_id >= 400 and s.chapter_id < 500 then 'reasoning' 
       else 'general-awareness' end,
  'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select level_id, count(*) from mtb.atoms 
-- where chapter_id in (17,18,19,27,28,423,425,12,13,14,15,16,415,417,418,419,421,422,38,40) 
--   and level_id='govt_defence' and status='published' and not archived 
-- group by 1;
-- Expected: 80

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: 2168 + 80 = 2248
