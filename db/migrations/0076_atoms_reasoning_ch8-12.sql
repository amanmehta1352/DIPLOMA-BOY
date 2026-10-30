-- Reasoning chapters: 17 (Series), 18 (Analogy), 19 (Odd One Out),
-- 27 (Venn Diagram), 28 (Statements & Data Sufficiency)
-- Corrected before apply: 28 basic formula inferred C's position from "A tallest, B shortest" (not valid); reworded.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ Ch 17: Series (Number/Letter) ═══
    (17, 'govt_technical', 'ser-concept', 'concept', 1, 'श्रृंखला — Reasoning',
     $j${"text":"Series में pattern खोजो: (1) Arithmetic (+n/−n), (2) Geometric (×n), (3) Square (1,4,9,16), (4) Cube (1,8,27,64), (5) Alternate (+2, +4, +2, +4), (6) Combination (arithmetic + multiplication)। Letter series: position gap देखो।","note":"पहले difference निकालो, फिर दूसरा difference। अगर equal हो, तो arithmetic।"}$j$),
    (17, 'govt_technical', 'ser-formula', 'formula', 2, 'Series types',
     $j${"formula":"Arithmetic: a, a+d, a+2d · Geometric: a, ar, ar² · Squares: n² · Cubes: n³","explanation":"Alternate: 2 series combined · Letter: A+2=C+2=E..."}$j$),
    (17, 'govt_technical', 'ser-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"2, 6, 18, 54, ?","solution":"2×3=6, 6×3=18, 18×3=54 → ×3 pattern","answer":"162 (54×3)"}$j$),
    (17, 'govt_technical', 'ser-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"2, 4, 8, 16, ?","options":["24","28","32","36"],"answer":2,"explanation":"×2 pattern: 16×2=32"},{"q":"1, 4, 9, 16, ?","options":["20","24","25","36"],"answer":2,"explanation":"Squares: 1²,2²,3²,4²,5²=25"}]}$j$),
    (17, 'govt_basic', 'ser-concept', 'concept', 1, 'श्रृंखला',
     $j${"text":"Series में संख्याएँ एक pattern से चलती हैं। 2,4,6,8 → +2। 3,9,27 → ×3। 1,4,9,16 → squares।","note":"पहले difference देखो"}$j$),
    (17, 'govt_basic', 'ser-formula', 'formula', 2, 'Pattern types',
     $j${"formula":"+n pattern: 1,2,3,4 · ×n pattern: 2,4,8,16 · Square: 1,4,9,16 · Cube: 1,8,27,64","explanation":"पहले test करो arithmetic, फिर geometric, फिर squares/cubes"}$j$),
    (17, 'govt_basic', 'ser-example', 'example', 3, 'उदाहरण',
     $j${"question":"3, 6, 9, 12, ?","solution":"+3 pattern","answer":"15"}$j$),
    (17, 'govt_basic', 'ser-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"2, 4, 6, 8, ?","options":["9","10","11","12"],"answer":1,"explanation":"+2 → 10"},{"q":"5, 10, 15, ?","options":["18","20","25","30"],"answer":1,"explanation":"+5 → 20"}]}$j$),
    (17, null, 'ser-diagram', 'svg', 5, 'Series pattern',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><text x='50' y='60' text-anchor='middle' fill='#60a5fa' font-size='13' font-weight='bold'>2</text><text x='100' y='60' text-anchor='middle' fill='#60a5fa' font-size='13' font-weight='bold'>4</text><text x='150' y='60' text-anchor='middle' fill='#60a5fa' font-size='13' font-weight='bold'>8</text><text x='200' y='60' text-anchor='middle' fill='#60a5fa' font-size='13' font-weight='bold'>16</text><text x='250' y='60' text-anchor='middle' fill='#f59e0b' font-size='13' font-weight='bold'>?</text><text x='75' y='45' text-anchor='middle' fill='#f59e0b' font-size='10'>×2</text><text x='125' y='45' text-anchor='middle' fill='#f59e0b' font-size='10'>×2</text><text x='175' y='45' text-anchor='middle' fill='#f59e0b' font-size='10'>×2</text><text x='150' y='100' text-anchor='middle' fill='#64748b' font-size='11'>×2 pattern → 32</text></svg>","caption":"हर बार ×2 → 32"}$j$),

    -- ═══ Ch 18: Analogy ═══
    (18, 'govt_technical', 'ana-concept', 'concept', 1, 'सादृश्यता — Analogy',
     $j${"text":"Analogy में दो pairs के बीच समान relationship खोजो। Types: (1) Worker-Tool, (2) Worker-Place, (3) Cause-Effect, (4) Part-Whole, (5) Synonym, (6) Antonym, (7) Number-Relation (2:8 = 2³, 3:27 = 3³)।","note":"पहले पहले pair का relation समझो, फिर उसे दूसरे pair पर लगाओ।"}$j$),
    (18, 'govt_technical', 'ana-formula', 'formula', 2, 'Analogy relations',
     $j${"formula":"Doctor:Hospital → Worker:Place · Pen:Write → Tool:Action · 2:8 → x:x³ · 4:16 → x:x²","explanation":"Number analogy में square/cube check करो"}$j$),
    (18, 'govt_technical', 'ana-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"Book : Read :: Music : ?","solution":"Book को read करते हैं, music को सुनते हैं","answer":"Listen"}$j$),
    (18, 'govt_technical', 'ana-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"Doctor : Hospital :: Teacher : ?","options":["Book","School","Student","Pen"],"answer":1,"explanation":"Doctor works in Hospital; Teacher works in School"},{"q":"2 : 8 :: 3 : ?","options":["6","9","12","27"],"answer":3,"explanation":"2³=8, 3³=27 (cube)"}]}$j$),
    (18, 'govt_basic', 'ana-concept', 'concept', 1, 'सादृश्यता',
     $j${"text":"Analogy में word pairs का connection देखो। Doctor:Hospital का मतलब doctor अस्पताल में काम करता है।","note":"पहले pair से relation पकड़ो, फिर दूसरे पर लगाओ"}$j$),
    (18, 'govt_basic', 'ana-formula', 'formula', 2, 'Common relations',
     $j${"formula":"Worker:Place · Tool:Action · Cause:Effect · Part:Whole · Synonym/Antonym","explanation":"Number analogy: squares (2:4, 3:9) या cubes (2:8, 3:27)"}$j$),
    (18, 'govt_basic', 'ana-example', 'example', 3, 'उदाहरण',
     $j${"question":"Bird : Fly :: Fish : ?","solution":"Bird flies, fish swims","answer":"Swim"}$j$),
    (18, 'govt_basic', 'ana-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"Pen : Write :: Knife : ?","options":["Sharp","Cut","Blade","Metal"],"answer":1,"explanation":"Pen write करने के लिए, knife cut करने के लिए"},{"q":"4 : 16 :: 5 : ?","options":["10","20","25","30"],"answer":2,"explanation":"4²=16, 5²=25"}]}$j$),
    (18, null, 'ana-diagram', 'svg', 5, 'Analogy pairs',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><text x='50' y='50' text-anchor='middle' fill='#60a5fa' font-size='12' font-weight='bold'>Doctor</text><text x='50' y='90' text-anchor='middle' fill='#60a5fa' font-size='12' font-weight='bold'>Hospital</text><text x='150' y='70' text-anchor='middle' fill='#f59e0b' font-size='11'>::</text><text x='250' y='50' text-anchor='middle' fill='#14b8a6' font-size='12' font-weight='bold'>Teacher</text><text x='250' y='90' text-anchor='middle' fill='#14b8a6' font-size='12' font-weight='bold'>?</text><text x='150' y='35' text-anchor='middle' fill='#64748b' font-size='10'>works in</text><text x='150' y='105' text-anchor='middle' fill='#64748b' font-size='10'>→ School</text></svg>","caption":"Worker : Place relation"}$j$),

    -- ═══ Ch 19: Odd One Out ═══
    (19, 'govt_technical', 'odd-concept', 'concept', 1, 'विषम तत्व — Odd One Out',
     $j${"text":"दिए गए items में से जो बाकी से अलग है उसे खोजो। Patterns: (1) जो category में fit न हो, (2) जो prime/square/cube न हो, (3) जो pattern follow न करे (जैसे सब even, एक odd), (4) जो category से बाहर (जैसे सब फल, एक सब्ज़ी)।","note":"पहले common property खोजो — जो उसे नहीं follow करे, वही odd है।"}$j$),
    (19, 'govt_technical', 'odd-formula', 'formula', 2, 'Odd patterns',
     $j${"formula":"Prime: 2,3,5,7,11,13,17,19 · Square: 1,4,9,16,25,36 · Cube: 1,8,27,64","explanation":"Even/Odd check: जो सब में अलग हो · Category: जो group में fit न हो"}$j$),
    (19, 'govt_technical', 'odd-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"3, 5, 7, 11, 15 में odd one out?","solution":"3,5,7,11 prime हैं, 15 = 3×5 नहीं prime","answer":"15 (not prime)"}$j$),
    (19, 'govt_technical', 'odd-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"2, 3, 5, 7, 9 — विषम?","options":["2","3","5","9"],"answer":3,"explanation":"9 prime नहीं (3×3), बाकी सब prime हैं"},{"q":"Apple, Mango, Banana, Carrot — विषम?","options":["Apple","Mango","Banana","Carrot"],"answer":3,"explanation":"Carrot सब्ज़ी है, बाकी फल हैं"}]}$j$),
    (19, 'govt_basic', 'odd-concept', 'concept', 1, 'विषम तत्व',
     $j${"text":"जो बाकी सब से अलग हो, वो odd one out है। जैसे Apple, Mango, Carrot में Carrot odd है (सब्ज़ी, फल नहीं)।","note":"पहले category देखो"}$j$),
    (19, 'govt_basic', 'odd-formula', 'formula', 2, 'Category check',
     $j${"formula":"Fruits: Apple, Mango, Banana · Vegetables: Carrot, Potato · Prime: 2,3,5,7,11 · Even: 2,4,6,8","explanation":"जो इन में fit न हो, वो odd है"}$j$),
    (19, 'govt_basic', 'odd-example', 'example', 3, 'उदाहरण',
     $j${"question":"1, 3, 5, 7, 4 में odd?","solution":"1,3,5,7 odd numbers हैं, 4 even","answer":"4"}$j$),
    (19, 'govt_basic', 'odd-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"1, 4, 9, 16, 20 — विषम?","options":["4","9","16","20"],"answer":3,"explanation":"1,4,9,16 perfect squares, 20 नहीं"},{"q":"Dog, Cat, Cow, Table — विषम?","options":["Dog","Cat","Cow","Table"],"answer":3,"explanation":"सब जानवर हैं, Table नहीं"}]}$j$),
    (19, null, 'odd-diagram', 'svg', 5, 'Odd one out',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='30' y='40' width='50' height='50' rx='8' fill='#60a5fa'/><text x='55' y='70' text-anchor='middle' fill='white' font-size='12' font-weight='bold'>2</text><rect x='90' y='40' width='50' height='50' rx='8' fill='#60a5fa'/><text x='115' y='70' text-anchor='middle' fill='white' font-size='12' font-weight='bold'>3</text><rect x='150' y='40' width='50' height='50' rx='8' fill='#60a5fa'/><text x='175' y='70' text-anchor='middle' fill='white' font-size='12' font-weight='bold'>5</text><rect x='210' y='40' width='50' height='50' rx='8' fill='#fb7185'/><text x='235' y='70' text-anchor='middle' fill='white' font-size='12' font-weight='bold'>9</text><text x='150' y='110' text-anchor='middle' fill='#64748b' font-size='11'>9 odd है (prime नहीं)</text></svg>","caption":"2,3,5 prime हैं, 9 नहीं"}$j$),

    -- ═══ Ch 27: Venn Diagram ═══
    (27, 'govt_technical', 'venn-concept', 'concept', 1, 'वेन आरेख — Venn Diagram',
     $j${"text":"Set theory: n(A∪B) = n(A) + n(B) − n(A∩B)। Only A = n(A) − n(A∩B)। Only B = n(B) − n(A∩B)। Neither = Total − n(A∪B)। Three-set: n(A∪B∪C) = n(A)+n(B)+n(C) − n(A∩B) − n(B∩C) − n(A∩C) + n(A∩B∩C)।","note":"'At least one' = A∪B · 'Only A' = A−B · 'Both' = A∩B"}$j$),
    (27, 'govt_technical', 'venn-formula', 'formula', 2, 'Venn formulas',
     $j${"formula":"n(A∪B) = n(A)+n(B)−n(A∩B) · Only A = n(A)−n(A∩B) · Neither = Total−n(A∪B)","explanation":"3-set में + (A∩B∩C) वापस add करना"}$j$),
    (27, 'govt_technical', 'venn-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"10 में से 6 tea, 5 coffee, 3 both। Only tea?","solution":"Only tea = 6 − 3 = 3","answer":"3 लोग"}$j$),
    (27, 'govt_technical', 'venn-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"6 tea, 5 coffee, 3 both. At least one?","options":["5","8","11","14"],"answer":1,"explanation":"6+5−3 = 8"},{"q":"Above, only tea?","options":["2","3","5","6"],"answer":1,"explanation":"6−3 = 3"}]}$j$),
    (27, 'govt_basic', 'venn-concept', 'concept', 1, 'वेन आरेख',
     $j${"text":"दो groups के बीच overlap देखो। Tea ∪ Coffee = Tea + Coffee − Both। 'Both' वालों को दो बार गिना जाता है, तो एक बार घटाओ।","note":"'At least one' = A∪B"}$j$),
    (27, 'govt_basic', 'venn-formula', 'formula', 2, 'Venn rule',
     $j${"formula":"A∪B = A + B − (A∩B) · Only A = A − (A∩B)","explanation":"जोड़ो, फिर overlap घटाओ"}$j$),
    (27, 'govt_basic', 'venn-example', 'example', 3, 'उदाहरण',
     $j${"question":"3 A, 2 B, 1 both। Only A?","solution":"3 − 1 = 2","answer":"2 लोग"}$j$),
    (27, 'govt_basic', 'venn-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"3 A, 2 B, 1 both. At least one?","options":["3","4","5","6"],"answer":1,"explanation":"3+2−1 = 4"},{"q":"Above, Only A?","options":["1","2","3","4"],"answer":1,"explanation":"3−1 = 2"}]}$j$),
    (27, null, 'venn-diagram', 'svg', 5, 'Venn overlap',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><circle cx='120' cy='60' r='40' fill='#60a5fa' opacity='0.6'/><circle cx='180' cy='60' r='40' fill='#14b8a6' opacity='0.6'/><text x='100' y='65' text-anchor='middle' fill='white' font-size='12'>Tea</text><text x='200' y='65' text-anchor='middle' fill='white' font-size='12'>Coffee</text><text x='150' y='65' text-anchor='middle' fill='white' font-size='10'>3</text><text x='150' y='110' text-anchor='middle' fill='#64748b' font-size='11'>Both = 3</text></svg>","caption":"Venn: Both 3, Only Tea 3, Only Coffee 2"}$j$),

    -- ═══ Ch 28: Statements & Data Sufficiency ═══
    (28, 'govt_technical', 'stmt-concept', 'concept', 1, 'कथन और पर्याप्तता — Statements',
     $j${"text":"Statement से logical conclusion निकालो। Syllogism जैसा ही, पर यहाँ: (1) Direct conclusion (सीधा), (2) Comparison (A>B, B>C → A>C), (3) Data Sufficiency में बताओ कि दी गई जानकारी उत्तर के लिए काफी है या नहीं (Statement I, Statement II, Both, None)।","note":"'Can be determined' = answer मिल सकता है · 'Cannot determine' = अधूरी जानकारी"}$j$),
    (28, 'govt_technical', 'stmt-formula', 'formula', 2, 'Statement rules',
     $j${"formula":"All A are B → Some B are A (valid converse) · A > B, B > C → A > C","explanation":"Data Sufficiency: Statement I काफी, Statement II काफी, दोनों, या कोई नहीं"}$j$),
    (28, 'govt_technical', 'stmt-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"A > B, B > C, C > D. सबसे बड़ा?","solution":"A > B > C > D","answer":"A"}$j$),
    (28, 'govt_technical', 'stmt-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"All students are intelligent. Conclusion: Some intelligent are students","options":["Valid","Invalid","Cannot determine","Both"],"answer":0,"explanation":"All A are B → Some B are A (valid converse)"},{"q":"Ram > Mohan, Mohan > Sohan. Shortest?","options":["Ram","Mohan","Sohan","Cannot determine"],"answer":2,"explanation":"Ram > Mohan > Sohan → Sohan shortest"}]}$j$),
    (28, 'govt_basic', 'stmt-concept', 'concept', 1, 'कथन और तर्क',
     $j${"text":"Statement में दी जानकारी से सही conclusion चुनो। जैसे 'सभी कुत्ते जानवर हैं' → 'कुछ जानवर कुत्ते हैं' valid है।","note":"'Cannot determine' तब जब जानकारी अधूरी"}$j$),
    (28, 'govt_basic', 'stmt-formula', 'formula', 2, 'Common patterns',
     $j${"formula":"All A are B → Some B are A (valid) · A > B, B > C → A > C · A tallest, B shortest → A > B (C का स्थान इससे तय नहीं)","explanation":"Direct inference से conclusion"}$j$),
    (28, 'govt_basic', 'stmt-example', 'example', 3, 'उदाहरण',
     $j${"question":"A > B, B > C. सबसे बड़ा?","solution":"A > B > C","answer":"A"}$j$),
    (28, 'govt_basic', 'stmt-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"A > B, B > C. सबसे बड़ा?","options":["A","B","C","Cannot determine"],"answer":0,"explanation":"A > B > C → A सबसे बड़ा"},{"q":"All cars have wheels. Maruti is a car. Does Maruti have wheels?","options":["Yes","No","Cannot determine","Maybe"],"answer":0,"explanation":"All cars → Maruti is car → Maruti has wheels"}]}$j$),
    (28, null, 'stmt-diagram', 'svg', 5, 'Comparison chain',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><text x='60' y='60' text-anchor='middle' fill='#60a5fa' font-size='14' font-weight='bold'>A</text><text x='90' y='60' text-anchor='middle' fill='#f59e0b' font-size='14'>&gt;</text><text x='130' y='60' text-anchor='middle' fill='#14b8a6' font-size='14' font-weight='bold'>B</text><text x='160' y='60' text-anchor='middle' fill='#f59e0b' font-size='14'>&gt;</text><text x='200' y='60' text-anchor='middle' fill='#a78bfa' font-size='14' font-weight='bold'>C</text><text x='150' y='100' text-anchor='middle' fill='#64748b' font-size='11'>A सबसे बड़ा, C सबसे छोटा</text></svg>","caption":"A > B > C chain"}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  case s.level_id
    when 'govt_technical' then array['rrb-je-cbt1','ssc-je-paper1']::text[]
    when 'govt_basic' then array['rrb-ntpc-graduate-cbt-1','rrb-ntpc-graduate-cbt-2','rrb-ntpc-ug-cbt-1','rrb-ntpc-ug-cbt-2']::text[]
    else '{}'::text[] end,
  '{}'::text[], 'reasoning', 'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, level_id, count(*) from mtb.atoms
-- where chapter_id in (17,18,19,27,28) and status='published' and not archived
-- group by 1,2 order by 1,2;
-- Expected per chapter: govt_technical=4, govt_basic=4, NULL=1
