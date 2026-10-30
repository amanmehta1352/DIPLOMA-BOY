with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ CLASS 6-8 MATHS (4-16) ═══
    (4, 'class_6_8', 'ratio-68-concept', 'concept', 1, 'अनुपात — Class 6-8',
     $j${"text":"अनुपात बताता है कि एक चीज़ दूसरी से कितनी गुना है। जैसे अगर 2 संतरे और 3 सेब हैं, तो संतरे:सेब = 2:3। दोनों को एक ही संख्या से गुणा या भाग करने पर अनुपात नहीं बदलता — 2:3 = 4:6 = 6:9।","note":"a:b में 'a' पहली चीज़, 'b' दूसरी चीज़।"}$j$),
    (4, 'class_6_8', 'ratio-68-formula', 'formula', 2, 'अनुपात सूत्र',
     $j${"formula":"a:b = a/b","explanation":"2:3 = 2/3 · 4:6 = 4/6 = 2/3 (same)"}$j$),
    (4, 'class_6_8', 'ratio-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"10 लड्डू और 15 जलेबी। अनुपात?","solution":"10:15 = (10÷5):(15÷5)","answer":"2:3"}$j$),
    (4, 'class_6_8', 'ratio-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"4:6 को simplify करो","options":["1:2","2:3","3:4","4:6"],"answer":1,"explanation":"4÷2:6÷2 = 2:3"},{"q":"2:3 = ?","options":["3:2","4:6","2:5","5:2"],"answer":1,"explanation":"2×2:3×2 = 4:6"}]}$j$),

    (5, 'class_6_8', 'avg-68-concept', 'concept', 1, 'औसत — Class 6-8',
     $j${"text":"औसत (Average) = सब संख्याओं को जोड़कर, कितनी संख्याएँ हैं उससे भाग देना। जैसे 2, 4, 6 का औसत = (2+4+6)/3 = 12/3 = 4। औसत हमेशा सबसे छोटी और सबसे बड़ी संख्या के बीच होता है।","note":"औसत = जोड़ / संख्या"}$j$),
    (5, 'class_6_8', 'avg-68-formula', 'formula', 2, 'औसत सूत्र',
     $j${"formula":"औसत = जोड़ / कितनी संख्याएँ","explanation":"2,4,6: (2+4+6)/3 = 12/3 = 4"}$j$),
    (5, 'class_6_8', 'avg-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"5, 10, 15 का औसत?","solution":"(5+10+15)/3 = 30/3","answer":"10"}$j$),
    (5, 'class_6_8', 'avg-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"2, 4, 6 का औसत?","options":["3","4","5","6"],"answer":1,"explanation":"12/3 = 4"},{"q":"औसत का सूत्र?","options":["जोड़×संख्या","जोड़/संख्या","संख्या/जोड़","जोड़+संख्या"],"answer":1,"explanation":"जोड़ ÷ संख्या"}]}$j$),

    (6, 'class_6_8', 'age-68-concept', 'concept', 1, 'आयु — Class 6-8',
     $j${"text":"आयु के सवाल में समय के साथ सबकी उम्र बढ़ती है। अगर आज मैं 10 साल का हूँ, तो 5 साल बाद 15 का होऊँगा। 5 साल पहले 5 का था। सभी की उम्र एक साथ बढ़ती है।","note":"आज की उम्र + n = n साल बाद की उम्र"}$j$),
    (6, 'class_6_8', 'age-68-formula', 'formula', 2, 'आयु सूत्र',
     $j${"formula":"आज = x · n साल बाद = x+n · n साल पहले = x−n","explanation":"10 साल का → 5 साल बाद 15 → 5 साल पहले 5"}$j$),
    (6, 'class_6_8', 'age-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"आज 12 साल का हूँ। 8 साल बाद?","solution":"12 + 8","answer":"20 साल"}$j$),
    (6, 'class_6_8', 'age-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"आज 15 साल, 5 साल पहले?","options":["5","10","15","20"],"answer":1,"explanation":"15−5 = 10"},{"q":"आज 8, 4 साल बाद?","options":["8","10","12","14"],"answer":2,"explanation":"8+4 = 12"}]}$j$),

    (7, 'class_6_8', 'mix-68-concept', 'concept', 1, 'मिश्रण — Class 6-8',
     $j${"text":"जब दो चीज़ें मिलाई जाती हैं, तो मिश्रण बनता है। जैसे 2 किलो चीनी और 3 किलो आटा मिलाया → 5 किलो मिश्रण। अगर ₹20 और ₹30 वाली चीज़ें बराबर मात्रा में मिलाएँ, तो मिश्रण की कीमत बीच में होगी (₹25)।","note":"बराबर मात्रा में मिलाने पर औसत निकालो"}$j$),
    (7, 'class_6_8', 'mix-68-formula', 'formula', 2, 'मिश्रण सूत्र',
     $j${"formula":"Mean price = (q₁p₁ + q₂p₂) / (q₁ + q₂)","explanation":"2 kg ₹20 + 3 kg ₹30 → (40+90)/5 = ₹26/kg"}$j$),
    (7, 'class_6_8', 'mix-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"₹10 और ₹20 के 1-1 kg मिलाएँ। कीमत?","solution":"(10+20)/2","answer":"₹15/kg"}$j$),
    (7, 'class_6_8', 'mix-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"2kg चीनी + 3kg आटा = ? मिश्रण","options":["4kg","5kg","6kg","7kg"],"answer":1,"explanation":"2+3 = 5 kg"},{"q":"₹20 और ₹30 1:1 में। औसत?","options":["₹22","₹25","₹30","₹35"],"answer":1,"explanation":"(20+30)/2 = 25"}]}$j$),

    (8, 'class_6_8', 'tw-68-concept', 'concept', 1, 'समय-कार्य — Class 6-8',
     $j${"text":"अगर कोई काम 5 दिन में पूरा होता है, तो 1 दिन में 1/5 काम होता है। अगर राम 5 दिन में और श्याम 10 दिन में करता है, तो साथ में 1/5 + 1/10 = 3/10 काम 1 दिन में। कुल समय = 10/3 ≈ 3.33 दिन।","note":"1 दिन का काम = 1/कुल_दिन"}$j$),
    (8, 'class_6_8', 'tw-68-formula', 'formula', 2, 'कार्य सूत्र',
     $j${"formula":"1/x + 1/y = 1/t → t = xy/(x+y)","explanation":"5 और 10 दिन → t = 50/15 = 3.33 दिन"}$j$),
    (8, 'class_6_8', 'tw-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"राम 4 दिन, श्याम 4 दिन। साथ में?","solution":"1/4 + 1/4 = 1/2 → 2 दिन","answer":"2 दिन"}$j$),
    (8, 'class_6_8', 'tw-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"A 6 दिन, B 6 दिन। साथ में?","options":["2","3","4","6"],"answer":1,"explanation":"1/6+1/6 = 1/3 → 3 दिन"},{"q":"1 दिन का काम?","options":["1/x","x","x/2","2x"],"answer":0,"explanation":"1/x"}]}$j$),

    (9, 'class_6_8', 'tsd-68-concept', 'concept', 1, 'चाल-दूरी — Class 6-8',
     $j${"text":"चाल = दूरी / समय। अगर कार 100 km, 2 घंटे में गई, तो चाल = 50 km/h. अगर चाल और समय पता है, तो दूरी = चाल × समय। अगर दूरी और चाल पता है, तो समय = दूरी / चाल।","note":"चाल, दूरी, समय — तीनों में से कोई दो पता हों, तो तीसरा निकालो"}$j$),
    (9, 'class_6_8', 'tsd-68-formula', 'formula', 2, 'चाल सूत्र',
     $j${"formula":"चाल = दूरी / समय","explanation":"दूरी = चाल × समय · समय = दूरी / चाल"}$j$),
    (9, 'class_6_8', 'tsd-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"60 km, 2 घंटे। चाल?","solution":"60/2","answer":"30 km/h"}$j$),
    (9, 'class_6_8', 'tsd-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"100 km, 2 घंटे। चाल?","options":["25","50","75","100"],"answer":1,"explanation":"100/2 = 50"},{"q":"चाल 20, समय 3। दूरी?","options":["23","40","60","80"],"answer":2,"explanation":"20×3 = 60"}]}$j$),

    (10, 'class_6_8', 'num-68-concept', 'concept', 1, 'संख्या — Class 6-8',
     $j${"text":"HCF = सबसे बड़ी संख्या जो दोनों में पूरी-पूरी आती है। LCM = सबसे छोटी संख्या जो दोनों की टेबल में आती है। जैसे 4 और 6: HCF = 2, LCM = 12। अगर किसी संख्या के अंत में 0, 2, 4, 6, 8 हो, तो 2 से divisible. अगर अंकों का जोड़ 3 से divisible हो, तो संख्या भी 3 से divisible.","note":"HCF = common factor का सबसे बड़ा · LCM = common multiple का सबसे छोटा"}$j$),
    (10, 'class_6_8', 'num-68-formula', 'formula', 2, 'संख्या सूत्र',
     $j${"formula":"HCF × LCM = a × b","explanation":"4 और 6: HCF=2, LCM=12 · 2×12 = 24 = 4×6 ✓"}$j$),
    (10, 'class_6_8', 'num-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"8 और 12 का HCF?","solution":"8 = 2×2×2, 12 = 2×2×3। Common = 2×2","answer":"4"}$j$),
    (10, 'class_6_8', 'num-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"6 और 9 का LCM?","options":["12","15","18","21"],"answer":2,"explanation":"LCM = 18"},{"q":"15 को 3 से divisible?","options":["हाँ","नहीं","शायद","पता नहीं"],"answer":0,"explanation":"1+5 = 6, 6÷3 = 2 ✓"}]}$j$),

    (11, 'class_6_8', 'simp-68-concept', 'concept', 1, 'सरलीकरण — Class 6-8',
     $j${"text":"BODMAS का order: पहले Bracket, फिर 'of', फिर भाग (÷), फिर गुणा (×), फिर जोड़ (+), फिर घटाना (−)। जैसे 2 + 3 × 4 = 2 + 12 = 14 (पहले गुणा, फिर जोड़)।","note":"BODMAS का order याद रखो — बिना इसके answer गलत आएगा"}$j$),
    (11, 'class_6_8', 'simp-68-formula', 'formula', 2, 'BODMAS order',
     $j${"formula":"B → O → D → M → A → S","explanation":"2 + 3×4 = 2 + 12 = 14 · 2×3 + 4 = 6 + 4 = 10"}$j$),
    (11, 'class_6_8', 'simp-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"5 + 2 × 3 = ?","solution":"पहले 2×3 = 6, फिर 5+6","answer":"11"}$j$),
    (11, 'class_6_8', 'simp-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"4 + 3 × 2 = ?","options":["14","10","24","9"],"answer":1,"explanation":"3×2=6 पहले, 4+6=10"},{"q":"BODMAS में पहले क्या?","options":["जोड़","गुणा","Bracket","घटाना"],"answer":2,"explanation":"Bracket पहले"}]}$j$),

    (12, 'class_6_8', 'alg-68-concept', 'concept', 1, 'बीजगणित — Class 6-8',
     $j${"text":"बीजगणित में अक्षर (x, y) का इस्तेमाल होता है — यह कोई अनजानी संख्या है। जैसे (x + 2)² = x² + 2×x×2 + 2² = x² + 4x + 4। (a + b)² = a² + 2ab + b², (a − b)² = a² − 2ab + b².","note":"(a+b)² और (a-b)² के formulas याद रखो"}$j$),
    (12, 'class_6_8', 'alg-68-formula', 'formula', 2, 'बीजगणित सूत्र',
     $j${"formula":"(a+b)² = a² + 2ab + b²","explanation":"(a−b)² = a² − 2ab + b² · (x+3)² = x²+6x+9"}$j$),
    (12, 'class_6_8', 'alg-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"(x+2)² expand?","solution":"x² + 2×x×2 + 2²","answer":"x² + 4x + 4"}$j$),
    (12, 'class_6_8', 'alg-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"(a+b)² = ?","options":["a²+b²","a²+2ab+b²","a²-2ab+b²","(a+b)(a-b)"],"answer":1,"explanation":"Standard identity"},{"q":"(x+1)² = ?","options":["x²+1","x²+2x+1","x²+1x+1","x²-2x+1"],"answer":1,"explanation":"x²+2×x×1+1²"}]}$j$),

    (13, 'class_6_8', 'mens-68-concept', 'concept', 1, 'क्षेत्रमिति — Class 6-8',
     $j${"text":"आयत (Rectangle) का area = लंबाई × चौड़ाई। वर्ग (Square) का area = भुजा × भुजा। वृत्त (Circle) का area = π × त्रिज्या × त्रिज्या (π = 22/7 या 3.14)। घन (Cube) का volume = भुजा³।","note":"Area = 2D (cm²), Volume = 3D (cm³)"}$j$),
    (13, 'class_6_8', 'mens-68-formula', 'formula', 2, 'क्षेत्रमिति सूत्र',
     $j${"formula":"Rectangle: A = l × b · Square: A = a² · Circle: A = πr²","explanation":"l = लंबाई, b = चौड़ाई, a = भुजा, r = त्रिज्या"}$j$),
    (13, 'class_6_8', 'mens-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"आयत 8×5 का area?","solution":"8×5","answer":"40 वर्ग इकाई"}$j$),
    (13, 'class_6_8', 'mens-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"वर्ग भुजा 5 का area?","options":["10","20","25","30"],"answer":2,"explanation":"5² = 25"},{"q":"Rectangle area formula?","options":["l+b","l×b","2(l+b)","l²"],"answer":1,"explanation":"l × b"}]}$j$),

    (14, 'class_6_8', 'geo-68-concept', 'concept', 1, 'ज्यामिति — Class 6-8',
     $j${"text":"त्रिभुज (Triangle): 3 भुजाएँ, 3 कोण जिनका जोड़ 180°। समबाहु (equilateral) — तीनों भुजाएँ बराबर, हर कोण 60°। समद्विबाहु (isosceles) — दो भुजाएँ बराबर। विषमबाहु (scalene) — सब अलग। समकोण (right) — एक कोण 90°, Pythagoras: a²+b²=c².","note":"Triangle के तीनों कोणों का जोड़ = 180°"}$j$),
    (14, 'class_6_8', 'geo-68-formula', 'formula', 2, 'ज्यामिति सूत्र',
     $j${"formula":"Triangle sum = 180° · Pythagoras: a² + b² = c²","explanation":"Equilateral: हर कोण 60° · Right triangle में 3-4-5, 5-12-13"}$j$),
    (14, 'class_6_8', 'geo-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"Triangle में 60° और 70°। तीसरा?","solution":"180 − 60 − 70","answer":"50°"}$j$),
    (14, 'class_6_8', 'geo-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"Triangle का angle sum?","options":["90°","180°","270°","360°"],"answer":1,"explanation":"180°"},{"q":"3-4-? right triangle","options":["5","6","7","8"],"answer":0,"explanation":"3-4-5 triple"}]}$j$),

    (15, 'class_6_8', 'trig-68-concept', 'concept', 1, 'त्रिकोणमिति — Class 6-8',
     $j${"text":"त्रिकोणमिति (Trigonometry) में समकोण त्रिभुज की भुजाओं का अनुपात देखते हैं। sin = सामने की भुजा / कर्ण (hypotenuse)। cos = पास की भुजा / कर्ण। tan = सामने / पास। sin²θ + cos²θ = 1.","note":"Standard angles: sin30=1/2, sin45=1/√2, sin60=√3/2"}$j$),
    (15, 'class_6_8', 'trig-68-formula', 'formula', 2, 'त्रिकोणमिति सूत्र',
     $j${"formula":"sin = opposite/hypotenuse · cos = adjacent/hypotenuse · tan = opposite/adjacent","explanation":"sin30 = 1/2, sin45 = 1/√2, sin60 = √3/2"}$j$),
    (15, 'class_6_8', 'trig-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"sin 30° = ?","solution":"1/2 (standard value)","answer":"1/2"}$j$),
    (15, 'class_6_8', 'trig-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"sin 30°?","options":["1/2","1/√2","√3/2","1"],"answer":0,"explanation":"1/2"},{"q":"sin θ = ?","options":["opp/adj","opp/hyp","adj/hyp","hyp/opp"],"answer":1,"explanation":"opp/hyp"}]}$j$),

    (16, 'class_6_8', 'stat-68-concept', 'concept', 1, 'सांख्यिकी — Class 6-8',
     $j${"text":"सांख्यिकी में डेटा को समझते हैं। Mean = औसत। Median = बीच वाली संख्या (sorted data में)। Mode = सबसे ज़्यादा बार आने वाली संख्या। जैसे 2, 3, 3, 4, 5: mean = 17/5 = 3.4, median = 3, mode = 3.","note":"Median के लिए पहले data को sorted करो"}$j$),
    (16, 'class_6_8', 'stat-68-formula', 'formula', 2, 'सांख्यिकी सूत्र',
     $j${"formula":"Mean = Sum/Count · Median = middle · Mode = most frequent","explanation":"2,3,3,4,5: mean=3.4, median=3, mode=3"}$j$),
    (16, 'class_6_8', 'stat-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"1, 2, 3, 4, 5 का median?","solution":"Middle value","answer":"3"}$j$),
    (16, 'class_6_8', 'stat-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"3, 5, 5, 7 का mode?","options":["3","5","7","4"],"answer":1,"explanation":"5 twice (most frequent)"},{"q":"1, 2, 3 का mean?","options":["1","2","3","6"],"answer":1,"explanation":"6/3 = 2"}]}$j$),

    -- ═══ CLASS 6-8 REASONING (17, 18, 19, 27, 28) ═══
    (17, 'class_6_8', 'ser-68-concept', 'concept', 1, 'श्रृंखला — Class 6-8',
     $j${"text":"Series में संख्याएँ या अक्षर एक pattern से चलते हैं। जैसे 2, 4, 6, 8 (हर बार +2), 1, 4, 9, 16 (वर्ग), 1, 8, 27 (घन)। Alphabet: A=1, B=2, ..., Z=26।","note":"पहले difference देखो — +1, +2, +3 या ×2"}$j$),
    (17, 'class_6_8', 'ser-68-formula', 'formula', 2, 'Series pattern',
     $j${"formula":"+n: 2,4,6,8 · ×n: 2,4,8,16 · Square: 1,4,9,16","explanation":"अगला term निकालने के लिए pattern पहचानो"}$j$),
    (17, 'class_6_8', 'ser-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"2, 4, 6, 8, ?","solution":"+2 pattern","answer":"10"}$j$),
    (17, 'class_6_8', 'ser-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"5, 10, 15, ?","options":["18","20","25","30"],"answer":1,"explanation":"+5 → 20"},{"q":"1, 3, 5, 7, ?","options":["8","9","10","11"],"answer":1,"explanation":"+2 → 9"}]}$j$),

    (18, 'class_6_8', 'ana-68-concept', 'concept', 1, 'सादृश्यता — Class 6-8',
     $j${"text":"Analogy (सादृश्यता) में दो जोड़ों के बीच का संबंध देखते हैं। जैसे 'पक्षी : आकाश :: मछली : पानी' — जैसे पक्षी आकाश में उड़ता है, वैसे मछली पानी में तैरती है।","note":"पहले जोड़े का relation समझो, फिर दूसरे पर लगाओ"}$j$),
    (18, 'class_6_8', 'ana-68-formula', 'formula', 2, 'Analogy relations',
     $j${"formula":"Animal:Home · Tool:Use · Parent:Child · Number:n²","explanation":"Bird:Sky :: Fish:Water · Pen:Write :: Knife:Cut"}$j$),
    (18, 'class_6_8', 'ana-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"Bird : Sky :: Fish : ?","solution":"Fish पानी में रहती है","answer":"Water"}$j$),
    (18, 'class_6_8', 'ana-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"Pen:Write :: Knife:?","options":["Sharp","Cut","Metal","Blade"],"answer":1,"explanation":"Pen writes, knife cuts"},{"q":"2:4 :: 3:?","options":["5","6","9","12"],"answer":2,"explanation":"n:n² → 3²=9"}]}$j$),

    (19, 'class_6_8', 'odd-68-concept', 'concept', 1, 'विषम तत्व — Class 6-8',
     $j${"text":"Odd One Out में देखो कि कौन सी चीज़ बाकी से अलग है। जैसे 'आम, केला, गाजर, सेब' — गाजर सब्ज़ी है, बाकी फल। या '1, 3, 5, 7, 8' — 8 सम (even) है, बाकी विषम (odd)।","note":"पहले category देखो — फल/सब्ज़ी, जानवर/पक्षी, सम/विषम"}$j$),
    (19, 'class_6_8', 'odd-68-formula', 'formula', 2, 'Odd patterns',
     $j${"formula":"Categories: fruits (आम, केला, सेब), vegetables (गाजर, आलू), animals (कुत्ता, बिल्ली)","explanation":"Even: 2,4,6,8 · Odd: 1,3,5,7 · Prime: 2,3,5,7,11"}$j$),
    (19, 'class_6_8', 'odd-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"आम, केला, गाजर, सेब — विषम?","solution":"गाजर सब्ज़ी है","answer":"गाजर"}$j$),
    (19, 'class_6_8', 'odd-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"2, 4, 6, 8, 9 — विषम?","options":["2","4","8","9"],"answer":3,"explanation":"9 odd, बाकी even"},{"q":"कुत्ता, बिल्ली, गाय, कुर्सी — विषम?","options":["कुत्ता","बिल्ली","गाय","कुर्सी"],"answer":3,"explanation":"कुर्सी furniture है"}]}$j$),

    (27, 'class_6_8', 'venn-68-concept', 'concept', 1, 'वेन आरेख — Class 6-8',
     $j${"text":"Venn diagram में दो या ज़्यादा groups के बीच overlap देखते हैं। जैसे class में 20 बच्चे — 12 क्रिकेट खेलते हैं, 10 फुटबॉल, 5 दोनों। सिर्फ क्रिकेट = 12 − 5 = 7. सिर्फ फुटबॉल = 10 − 5 = 5.","note":"'Both' वालों को दो बार नहीं गिनते — overlap घटाते हैं"}$j$),
    (27, 'class_6_8', 'venn-68-formula', 'formula', 2, 'Venn formula',
     $j${"formula":"n(A∪B) = n(A) + n(B) − n(A∩B)","explanation":"12 + 10 − 5 = 17 (कुल खिलाड़ी)"}$j$),
    (27, 'class_6_8', 'venn-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"10 क्रिकेट, 8 फुटबॉल, 3 दोनों। Only cricket?","solution":"10 − 3","answer":"7"}$j$),
    (27, 'class_6_8', 'venn-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"6 A, 4 B, 2 दोनों। At least one?","options":["8","10","12","14"],"answer":0,"explanation":"6+4−2 = 8"},{"q":"Above, only A?","options":["2","3","4","6"],"answer":2,"explanation":"6−2 = 4"}]}$j$),

    (28, 'class_6_8', 'stmt-68-concept', 'concept', 1, 'कथन-तर्क — Class 6-8',
     $j${"text":"किसी दिए हुए कथन (statement) से नया निष्कर्ष (conclusion) निकालना। जैसे 'सभी कुत्ते जानवर हैं' → 'कुछ जानवर कुत्ते हैं' (सही)। Comparison: राम > श्याम, श्याम > मोहन, तो राम > मोहन।","note":"जो conclusion हर हाल में सही हो, वही valid है"}$j$),
    (28, 'class_6_8', 'stmt-68-formula', 'formula', 2, 'Statement rules',
     $j${"formula":"All A are B → Some B are A (valid) · A > B, B > C → A > C","explanation":"'सभी' से 'कुछ' निकलता है, पर 'कुछ' से 'सभी' नहीं"}$j$),
    (28, 'class_6_8', 'stmt-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"राम > श्याम, श्याम > मोहन। सबसे बड़ा?","solution":"राम > श्याम > मोहन","answer":"राम"}$j$),
    (28, 'class_6_8', 'stmt-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"All cats are animals। Some animals are cats?","options":["Valid","Invalid","Cannot determine","Maybe"],"answer":0,"explanation":"Valid converse"},{"q":"A>B, B>C। Largest?","options":["A","B","C","None"],"answer":0,"explanation":"A>B>C"}]}$j$),

    -- ═══ CLASS 6-8 SCI (870, 871) ═══
    (870, 'class_6_8', 'phy-meas-68-concept', 'concept', 1, 'माप — Class 6-8',
     $j${"text":"माप (Measurement) से हम पता करते हैं कि कोई चीज़ कितनी लंबी, भारी, या गर्म है। लंबाई का माप — मीटर (m), भार का — किलोग्राम (kg), समय का — सेकंड (s)। रूलर से लंबाई, तराज़ू से वज़न, घड़ी से समय नापते हैं।","note":"हर चीज़ का अपना माप होता है — जैसे कद, वज़न, तापमान"}$j$),
    (870, 'class_6_8', 'phy-meas-68-formula', 'formula', 2, 'माप units',
     $j${"formula":"1 km = 1000 m · 1 m = 100 cm · 1 kg = 1000 g · 1 hour = 60 min = 3600 s","explanation":"मापने की units याद रखो"}$j$),
    (870, 'class_6_8', 'phy-meas-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"2 km में कितने मीटर?","solution":"1 km = 1000 m → 2×1000","answer":"2000 m"}$j$),
    (870, 'class_6_8', 'phy-meas-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"लंबाई का unit?","options":["kg","m","s","°C"],"answer":1,"explanation":"मीटर (m)"},{"q":"1 kg = ? g","options":["100","500","1000","10000"],"answer":2,"explanation":"1000 g"}]}$j$),

    (871, 'class_6_8', 'phy-motion-68-concept', 'concept', 1, 'गति — Class 6-8',
     $j${"text":"जब कोई चीज़ एक जगह से दूसरी जगह जाती है, तो कहते हैं कि वो गति कर रही है। जैसे साइकिल चलाना, पक्षी उड़ना, कार दौड़ना। चाल (Speed) बताती है कि कितनी जल्दी चल रहे हैं — कम समय में ज़्यादा दूरी = तेज़ चाल।","note":"चाल = दूरी / समय"}$j$),
    (871, 'class_6_8', 'phy-motion-68-formula', 'formula', 2, 'गति सूत्र',
     $j${"formula":"चाल = दूरी / समय","explanation":"100 km, 2 घंटे → चाल = 50 km/h"}$j$),
    (871, 'class_6_8', 'phy-motion-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"60 km, 2 घंटे। चाल?","solution":"60/2","answer":"30 km/h"}$j$),
    (871, 'class_6_8', 'phy-motion-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"चाल का सूत्र?","options":["दूरी×समय","दूरी/समय","समय/दूरी","दूरी+समय"],"answer":1,"explanation":"दूरी ÷ समय"},{"q":"तेज़ चाल = ?","options":["कम समय में कम दूरी","कम समय में ज़्यादा दूरी","ज़्यादा समय","कोई फर्क नहीं"],"answer":1,"explanation":"कम समय में ज़्यादा दूरी = तेज़"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], array['class_6','class_7','class_8']::text[],
  case when s.chapter_id < 20 then 'maths' 
       when s.chapter_id >= 400 and s.chapter_id < 500 then 'reasoning' 
       else 'general-science' end,
  'easy', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, count(*) from mtb.atoms 
-- where chapter_id in (4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,27,28,870,871) 
--   and level_id='class_6_8' and status='published' and not archived 
-- group by 1 order by 1;
-- Expected: 870 = 7 (3 pre-existing phy-meas-910-* + 4 new phy-meas-68-*), others = 4
-- Note: chapter 870 may have had 3 pre-existing atoms from Phase 4

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: ~2860 + 80 = ~2940
