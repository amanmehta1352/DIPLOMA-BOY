-- Maths 14-16 (Geometry, Trigonometry, Statistics)
-- Reasoning 423, 425 (Alphabet Series, Blood Relation)
-- + Fix for Chapter 10 diagram caption
-- Corrected before apply: 425 tech example and both tech MCQs had wrong/ambiguous answers.

-- ═══ FIX: Ch 10 caption clarity ═══
update mtb.atoms
set body = jsonb_set(body, '{caption}', '"HCF = common factors का intersection, LCM = सभी factors का union"'),
    content_hash = md5((jsonb_set(body, '{caption}', '"HCF = common factors का intersection, LCM = सभी factors का union"'))::text),
    updated_at = now()
where chapter_id = 10 and atom_type = 'svg' and atom_key = 'num-diagram';

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ Ch 14: Geometry ═══
    (14, 'govt_technical', 'geo-concept', 'concept', 1, 'ज्यामिति — SSC JE / RRB JE',
     $j${"text":"Triangle के तीनों कोणों का योग = 180°। Pythagoras: right triangle में a²+b²=c² (c = hypotenuse)। Circle: radius, diameter, chord, tangent। Cyclic quadrilateral: opposite angles sum = 180°।","note":"JE में triangle properties, circle theorems, और coordinate geometry के basic questions आते हैं।"}$j$),
    (14, 'govt_technical', 'geo-formula', 'formula', 2, 'ज्यामिति सूत्र',
     $j${"formula":"Triangle: A+B+C = 180° · Pythagoras: a²+b²=c² · Circle tangent ⊥ radius","explanation":"Equilateral: each angle = 60°, area = (√3/4)a² · Isosceles: base angles equal"}$j$),
    (14, 'govt_technical', 'geo-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"Right triangle: a=3, b=4। c=?","solution":"c² = 3²+4² = 9+16 = 25","answer":"c=5 (3-4-5 triple)"}$j$),
    (14, 'govt_technical', 'geo-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"Triangle के तीनों कोणों का sum?","options":["90°","180°","270°","360°"],"answer":1,"explanation":"हर triangle के angles का sum = 180°"},{"q":"3-4-5 triangle कैसा है?","options":["Equilateral","Right","Isosceles","Obtuse"],"answer":1,"explanation":"3²+4²=5² → Right angle triangle"}]}$j$),
    (14, 'govt_basic', 'geo-concept', 'concept', 1, 'ज्यामिति',
     $j${"text":"Triangle = 3 sides, 3 angles जिनका sum 180°। Square = 4 equal sides, 4 right angles (90°)। Circle = round shape।","note":"Right triangle में Pythagoras: a²+b²=c²"}$j$),
    (14, 'govt_basic', 'geo-formula', 'formula', 2, 'बुनियादी ज्यामिति',
     $j${"formula":"Triangle sum = 180° · Square area = a² · Rectangle perimeter = 2(l+b)","explanation":"Circle: Area = πr², Circumference = 2πr"}$j$),
    (14, 'govt_basic', 'geo-example', 'example', 3, 'उदाहरण',
     $j${"question":"Triangle में 60°, 70° दिए हैं। तीसरा कोण?","solution":"180 − 60 − 70","answer":"50°"}$j$),
    (14, 'govt_basic', 'geo-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"Square का हर कोण कितना?","options":["45°","60°","90°","180°"],"answer":2,"explanation":"Square में सब 90°"},{"q":"Equilateral triangle का हर कोण?","options":["45°","60°","90°","120°"],"answer":1,"explanation":"180/3 = 60°"}]}$j$),
    (14, null, 'geo-diagram', 'svg', 5, 'Triangle basics',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><polygon points='50,90 150,90 100,40' fill='#60a5fa' opacity='0.6'/><text x='75' y='85' fill='#0f172a' font-size='11' font-weight='bold'>A</text><text x='150' y='85' fill='#0f172a' font-size='11' font-weight='bold'>B</text><text x='100' y='35' fill='#0f172a' font-size='11' font-weight='bold'>C</text><text x='220' y='65' fill='#f59e0b' font-size='12'>∠A+∠B+∠C = 180°</text></svg>","caption":"त्रिभुज के तीनों कोणों का योग 180°"}$j$),

    -- ═══ Ch 15: Trigonometry ═══
    (15, 'govt_technical', 'trig-concept', 'concept', 1, 'त्रिकोणमिति — SSC JE / RRB JE',
     $j${"text":"sinθ = opp/hyp, cosθ = adj/hyp, tanθ = opp/adj = sin/cos। Fundamental identity: sin²θ + cos²θ = 1। 1 + tan²θ = sec²θ, 1 + cot²θ = cosec²θ। Standard angles: sin30=1/2, cos60=1/2, tan45=1, sin90=1।","note":"JE में height-distance problems और identity simplification आते हैं।"}$j$),
    (15, 'govt_technical', 'trig-formula', 'formula', 2, 'त्रिकोणमिति सूत्र',
     $j${"formula":"sin²θ + cos²θ = 1 · 1+tan²θ = sec²θ · 1+cot²θ = cosec²θ · sin2θ = 2sinθcosθ","explanation":"sin30=1/2, cos30=√3/2, tan30=1/√3, sin45=cos45=1/√2, tan45=1"}$j$),
    (15, 'govt_technical', 'trig-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"sin²30 + cos²30 = ?","solution":"(1/2)² + (√3/2)² = 1/4 + 3/4","answer":"1"}$j$),
    (15, 'govt_technical', 'trig-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"sin 45° = ?","options":["1/2","1/√2","√3/2","1"],"answer":1,"explanation":"sin45 = 1/√2 ≈ 0.707"},{"q":"tan 60° = ?","options":["1/√3","1","√3","2"],"answer":2,"explanation":"tan60 = √3"}]}$j$),
    (15, 'govt_basic', 'trig-concept', 'concept', 1, 'त्रिकोणमिति',
     $j${"text":"sin, cos, tan triangle की sides के ratios हैं। sin = सामने की side/hypotenuse, cos = आस-पास की side/hypotenuse, tan = sin/cos।","note":"Standard angles याद रखो"}$j$),
    (15, 'govt_basic', 'trig-formula', 'formula', 2, 'बुनियादी सूत्र',
     $j${"formula":"sin²θ + cos²θ = 1 · tanθ = sinθ/cosθ","explanation":"sin30=1/2, sin45=1/√2, sin60=√3/2, sin90=1"}$j$),
    (15, 'govt_basic', 'trig-example', 'example', 3, 'उदाहरण',
     $j${"question":"sin 30° + cos 60° = ?","solution":"1/2 + 1/2","answer":"1"}$j$),
    (15, 'govt_basic', 'trig-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"sin 30° = ?","options":["0","1/2","1/√2","1"],"answer":1,"explanation":"sin30 = 1/2"},{"q":"cos 0° = ?","options":["0","1/2","1/√2","1"],"answer":3,"explanation":"cos0 = 1"}]}$j$),
    (15, null, 'trig-diagram', 'svg', 5, 'Right triangle ratios',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><polygon points='50,100 220,100 220,30' fill='none' stroke='#60a5fa' stroke-width='2'/><text x='70' y='90' fill='#f59e0b' font-size='11'>θ</text><text x='130' y='115' fill='#14b8a6' font-size='11'>adjacent</text><text x='235' y='70' fill='#14b8a6' font-size='11'>opposite</text><text x='120' y='55' fill='#f472b6' font-size='11'>hypotenuse</text></svg>","caption":"sin=opp/hyp, cos=adj/hyp, tan=opp/adj"}$j$),

    -- ═══ Ch 16: Statistics ═══
    (16, 'govt_technical', 'stat-concept', 'concept', 1, 'सांख्यिकी — SSC JE / RRB JE',
     $j${"text":"Mean (औसत) = sum/count। Median = बीच वाली value (sorted data का)। Mode = सबसे ज़्यादा बार आने वाली value। Range = max − min। Median for odd n: (n+1)/2-th value; for even n: average of n/2 and n/2+1।","note":"JE में mean-median-mode का relation: Mode = 3×Median − 2×Mean"}$j$),
    (16, 'govt_technical', 'stat-formula', 'formula', 2, 'सांख्यिकी सूत्र',
     $j${"formula":"Mean = Σx/n · Median (odd) = (n+1)/2-th · Mode = most frequent · Range = max−min","explanation":"Empirical: Mode = 3×Median − 2×Mean"}$j$),
    (16, 'govt_technical', 'stat-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"2, 4, 4, 6, 8। Mean, Median, Mode?","solution":"Mean = 24/5 = 4.8। Sorted middle = 4 (median)। 4 सबसे ज़्यादा बार (mode)","answer":"Mean=4.8, Median=4, Mode=4"}$j$),
    (16, 'govt_technical', 'stat-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"1,2,3,4,5 का median?","options":["2","3","3.5","4"],"answer":1,"explanation":"Middle value = 3"},{"q":"Mode किसे कहते हैं?","options":["औसत","बीच वाली","सबसे frequent","range"],"answer":2,"explanation":"Mode = most frequent value"}]}$j$),
    (16, 'govt_basic', 'stat-concept', 'concept', 1, 'सांख्यिकी',
     $j${"text":"Mean = average (जोड़ ÷ संख्या)। Median = बीच वाली value (sorted)। Mode = सबसे ज़्यादा बार आने वाली value।","note":"Data sorted करके median निकालो"}$j$),
    (16, 'govt_basic', 'stat-formula', 'formula', 2, 'Mean, Median, Mode',
     $j${"formula":"Mean = Sum/Count · Median = middle value · Mode = most frequent","explanation":"Range = max − min"}$j$),
    (16, 'govt_basic', 'stat-example', 'example', 3, 'उदाहरण',
     $j${"question":"2, 4, 6, 8, 10 का mean?","solution":"Sum = 30, Count = 5","answer":"Mean = 6"}$j$),
    (16, 'govt_basic', 'stat-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"1, 2, 3, 4, 5 का median?","options":["2","3","4","5"],"answer":1,"explanation":"Middle = 3"},{"q":"3, 3, 4, 5, 5, 5 का mode?","options":["3","4","5","3 और 5"],"answer":2,"explanation":"5 सबसे ज़्यादा (3 बार)"}]}$j$),
    (16, null, 'stat-diagram', 'svg', 5, 'Mean vs Median',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='40' y='80' width='30' height='20' fill='#60a5fa'/><rect x='80' y='60' width='30' height='40' fill='#60a5fa'/><rect x='120' y='40' width='30' height='60' fill='#60a5fa'/><rect x='160' y='70' width='30' height='30' fill='#60a5fa'/><rect x='200' y='50' width='30' height='50' fill='#60a5fa'/><line x1='30' y1='65' x2='280' y2='65' stroke='#f59e0b' stroke-width='2' stroke-dasharray='5,3'/><text x='285' y='68' fill='#f59e0b' font-size='11'>mean</text></svg>","caption":"Mean = सारे values का average"}$j$),

    -- ═══ Reasoning 423: Alphabet & Alphanumeric Series ═══
    (423, 'govt_technical', 'alpha-concept', 'concept', 1, 'वर्णमाला श्रृंखला — Reasoning',
     $j${"text":"A=1, B=2, ..., Z=26। Opposite letters का sum = 27 (A↔Z, B↔Y, C↔X...)। Trick: EJOTY → E=5, J=10, O=15, T=20, Y=25। Series में gap देखो (1,2,3 या 2,4,6)। Position-based और letter-based दोनों patterns।","note":"JE/SSc में missing letters, next term, और coded positions आते हैं।"}$j$),
    (423, 'govt_technical', 'alpha-formula', 'formula', 2, 'अक्षर-संख्या मान',
     $j${"formula":"A=1 ... Z=26 · Opposite: X=27−X · EJOTY: E=5, J=10, O=15, T=20, Y=25","explanation":"Word का numerical sum = each letter का number जोड़ो · e.g. CAT = 3+1+20 = 24"}$j$),
    (423, 'govt_technical', 'alpha-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"Series: A, C, E, G, ?","solution":"Positions: 1, 3, 5, 7 — हर बार +2","answer":"I (9)"}$j$),
    (423, 'govt_technical', 'alpha-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"C का opposite?","options":["X","Y","Z","W"],"answer":0,"explanation":"C=3, opposite = 27−3 = 24 = X"},{"q":"A, D, G, J, ?","options":["L","M","N","K"],"answer":1,"explanation":"+3 → M (13)"}]}$j$),
    (423, 'govt_basic', 'alpha-concept', 'concept', 1, 'अक्षर श्रृंखला',
     $j${"text":"A=1, B=2, ..., Z=26। A का opposite Z, B का opposite Y। Series में पैटर्न देखो — +1, +2, +3 या ×2।","note":"EJOTY से positions याद रखो"}$j$),
    (423, 'govt_basic', 'alpha-formula', 'formula', 2, 'अक्षर positions',
     $j${"formula":"A=1, B=2, ..., Z=26 · Opposite = 27 − current","explanation":"A↔Z, M↔N (opposite pair)"}$j$),
    (423, 'govt_basic', 'alpha-example', 'example', 3, 'उदाहरण',
     $j${"question":"A, B, C, D, ?","solution":"+1 pattern","answer":"E"}$j$),
    (423, 'govt_basic', 'alpha-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"J की position?","options":["9","10","11","12"],"answer":1,"explanation":"A=1, ..., J=10"},{"q":"A का opposite?","options":["X","Y","Z","W"],"answer":2,"explanation":"A=1, opp=26 = Z"}]}$j$),
    (423, null, 'alpha-diagram', 'svg', 5, 'Alphabet positions',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><text x='150' y='35' text-anchor='middle' fill='#60a5fa' font-size='13' font-weight='bold'>A B C D E F G H I J K L M</text><text x='150' y='65' text-anchor='middle' fill='#14b8a6' font-size='13' font-weight='bold'>Z Y X W V U T S R Q P O N</text><text x='150' y='95' text-anchor='middle' fill='#f59e0b' font-size='11'>Opposites: A↔Z, B↔Y, ... (sum=27)</text></svg>","caption":"A-Z positions और opposite pairs"}$j$),

    -- ═══ Reasoning 425: Blood Relation ═══
    (425, 'govt_technical', 'blood-concept', 'concept', 1, 'रक्त संबंध — Reasoning',
     $j${"text":"Blood relation में family tree बनाओ। Symbols: + male, − female, × siblings, ÷ parent, = spouse। Pointing questions: 'my father's son' = brother/self (पुरुष वक्ता के लिए)। 'Brother's father' = father। Generation gap देखो।","note":"JE/SSC में 2-3 generation family tree पूछा जाता है।"}$j$),
    (425, 'govt_technical', 'blood-formula', 'formula', 2, 'Blood relation symbols',
     $j${"formula":"+ = male · − = female · × = sibling · ÷ = parent · = = spouse","explanation":"A + B → A is father of B · A − B → A is mother of B · A × B → A is sibling of B"}$j$),
    (425, 'govt_technical', 'blood-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"A, B का पिता है। B, C की माँ है। C का A से क्या संबंध है?","solution":"A, B का पिता → B की माँ (C की माँ) का पिता → C का नाना","answer":"नाना (maternal grandfather)"}$j$),
    (425, 'govt_technical', 'blood-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"A, B का पिता है। B, C की माँ है। A, C से कैसे संबंधित है?","options":["Father","Mother","Maternal grandfather","Uncle"],"answer":2,"explanation":"A, B का पिता है और B, C की माँ है → A, C का नाना (maternal grandfather) है।"},{"q":"एक पुरुष कहता है: 'वो मेरे पिता के बेटे का बेटा है।' वो उसका कौन है?","options":["Son","Nephew","Brother","Cousin"],"answer":1,"explanation":"पिता का बेटा = भाई (या स्वयं); भाई का बेटा = भतीजा (nephew)।"}]}$j$),
    (425, 'govt_basic', 'blood-concept', 'concept', 1, 'रक्त संबंध',
     $j${"text":"रक्त संबंध में परिवार का चित्र बनाओ। 'मेरे पिता की माँ' = दादी। 'मेरे भाई की बहन' = बहन (या मैं)।","note":"अपने से बड़े/छोटे relationship से generation पता करो"}$j$),
    (425, 'govt_basic', 'blood-formula', 'formula', 2, 'रिश्ते के सूत्र',
     $j${"formula":"Father's father = Grandfather · Mother's mother = Grandmother · Father's brother = Uncle","explanation":"Brother's son = Nephew · Sister's daughter = Niece"}$j$),
    (425, 'govt_basic', 'blood-example', 'example', 3, 'उदाहरण',
     $j${"question":"'मेरी माँ की माँ' मेरी कौन है?","solution":"Maa ki maa","answer":"नानी (maternal grandmother)"}$j$),
    (425, 'govt_basic', 'blood-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"पिता की माँ को क्या कहते हैं?","options":["नानी","दादी","मौसी","बुआ"],"answer":1,"explanation":"पिता की माँ = दादी"},{"q":"भाई का बेटा?","options":["भतीजा","भांजा","चचेरा भाई","भतीजी"],"answer":0,"explanation":"भाई का बेटा = भतीजा (nephew)"}]}$j$),
    (425, null, 'blood-diagram', 'svg', 5, 'Family tree',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><circle cx='150' cy='25' r='14' fill='#60a5fa'/><text x='150' y='30' text-anchor='middle' fill='white' font-size='11'>दादा</text><circle cx='220' cy='25' r='14' fill='#f472b6'/><text x='220' y='30' text-anchor='middle' fill='white' font-size='11'>दादी</text><circle cx='150' cy='70' r='14' fill='#60a5fa'/><text x='150' y='75' text-anchor='middle' fill='white' font-size='10'>पिता</text><circle cx='220' cy='70' r='14' fill='#60a5fa'/><text x='220' y='75' text-anchor='middle' fill='white' font-size='10'>चाचा</text><circle cx='150' cy='105' r='12' fill='#14b8a6'/><text x='150' y='110' text-anchor='middle' fill='white' font-size='10'>मैं</text><line x1='150' y1='39' x2='150' y2='56' stroke='#64748b'/><line x1='220' y1='39' x2='220' y2='56' stroke='#64748b'/><line x1='150' y1='84' x2='150' y2='93' stroke='#64748b'/></svg>","caption":"3 generation family tree"}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  case s.level_id
    when 'govt_technical' then
      case when s.chapter_id >= 400 then array['rrb-je-cbt1','ssc-je-paper1']::text[]
           else array['rrb-je-cbt1']::text[] end
    when 'govt_basic' then array['rrb-ntpc-graduate-cbt-1','rrb-ntpc-graduate-cbt-2','rrb-ntpc-ug-cbt-1','rrb-ntpc-ug-cbt-2']::text[]
    else '{}'::text[] end,
  '{}'::text[],
  case when s.chapter_id >= 400 then 'reasoning' else 'maths' end,
  'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, level_id, count(*) from mtb.atoms
-- where chapter_id in (14,15,16,423,425) and status='published' and not archived
-- group by 1,2 order by 1,2;
-- Expected per chapter: govt_technical=4, govt_basic=4, NULL=1
