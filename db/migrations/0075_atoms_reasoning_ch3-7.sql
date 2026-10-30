-- Reasoning chapters: 426 (Coding-Decoding), 427 (Direction), 428 (Math Ops),
-- 429 (Seating), 431 (Syllogism)
-- Corrected before apply: 428 tech MCQ 2 and 429 tech MCQ 2 had leftover working text and no matching answer.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ Ch 426: Coding-Decoding ═══
    (426, 'govt_technical', 'code-concept', 'concept', 1, 'कूट-लेखन — Reasoning',
     $j${"text":"Coding-Decoding में letter/number का pattern खोजो। Types: (1) Letter shift (+n/−n), (2) Reverse alphabet, (3) Position number (A=1), (4) Interchange, (5) Word-based (vowels/consonants का code)।","note":"SSC/JE में 2-3 questions पक्के आते हैं।"}$j$),
    (426, 'govt_technical', 'code-formula', 'formula', 2, 'Coding patterns',
     $j${"formula":"Shift: A+n → letter · Reverse: A↔Z (27−pos) · Position: A=1, B=2","explanation":"Example: CAT with +1 → DBU · CAT with reverse → XZG"}$j$),
    (426, 'govt_technical', 'code-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"अगर PEN = QFO, तो INK = ?","solution":"P→Q (+1), E→F (+1), N→O (+1)। I→J, N→O, K→L","answer":"JOL"}$j$),
    (426, 'govt_technical', 'code-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"CAT = DBU. DOG = ?","options":["EPH","EPG","FPH","DPH"],"answer":0,"explanation":"D→E, O→P, G→H (+1 each) = EPH"},{"q":"अगर 'MOTHER' का code 'NPUIFS' है, तो 'FATHER' का code?","options":["GBUIFS","GBUIFR","GBTIFS","GBUJFS"],"answer":0,"explanation":"+1 each: F→G, A→B, T→U, H→I, E→F, R→S = GBUIFS"}]}$j$),
    (426, 'govt_basic', 'code-concept', 'concept', 1, 'कूट-लेखन',
     $j${"text":"Coding में हर letter को shift करके नया letter बनता है। जैसे +1 shift: A→B, B→C, ... Z→A।","note":"Shift (+1, +2) या reverse (A↔Z) देखो"}$j$),
    (426, 'govt_basic', 'code-formula', 'formula', 2, 'Shift pattern',
     $j${"formula":"Forward: A+1=B, B+1=C · Reverse: A↔Z, B↔Y (sum=27)","explanation":"PEN → QFO (+1 shift each letter)"}$j$),
    (426, 'govt_basic', 'code-example', 'example', 3, 'उदाहरण',
     $j${"question":"अगर CAT = DBU (+1), तो BAT = ?","solution":"B→C, A→B, T→U","answer":"CBU"}$j$),
    (426, 'govt_basic', 'code-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"+1 shift में A = ?","options":["A","B","Y","Z"],"answer":1,"explanation":"A+1 = B"},{"q":"अगर Z का code Y है, तो shift?","options":["+1","−1","+2","−2"],"answer":1,"explanation":"Z−1 = Y"}]}$j$),
    (426, null, 'code-diagram', 'svg', 5, 'Coding shift',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><text x='150' y='35' text-anchor='middle' fill='#60a5fa' font-size='14' font-weight='bold'>P E N</text><line x1='110' y1='50' x2='190' y2='50' stroke='#f59e0b' stroke-width='2' marker-end='url(#ar)'/><text x='150' y='45' text-anchor='middle' fill='#f59e0b' font-size='10'>+1</text><text x='150' y='85' text-anchor='middle' fill='#14b8a6' font-size='14' font-weight='bold'>Q F O</text></svg>","caption":"PEN → QFO: हर letter +1"}$j$),

    -- ═══ Ch 427: Direction Sense ═══
    (427, 'govt_technical', 'dir-concept', 'concept', 1, 'दिशा ज्ञान — Reasoning',
     $j${"text":"North सामने, South पीछे, East right, West left। Right turn: N→E→S→W→N (clockwise)। Left turn: N→W→S→E (anticlockwise)। Distance: Pythagoras — √(x²+y²) यदि diagonal।","note":"JE में final position और direction दोनों पूछे जाते हैं।"}$j$),
    (427, 'govt_technical', 'dir-formula', 'formula', 2, 'Direction rules',
     $j${"formula":"Right: N→E, E→S, S→W, W→N · Left: N→W, W→S, S→E, E→N","explanation":"Distance = √((N−S)² + (E−W)²) · Diagonal 45° turn में direction बदलती है"}$j$),
    (427, 'govt_technical', 'dir-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"3 km North, फिर 4 km East। Start से distance?","solution":"√(3²+4²) = √(9+16) = √25","answer":"5 km (North-East दिशा)"}$j$),
    (427, 'govt_technical', 'dir-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"North facing, 2 बार right turn। Direction?","options":["N","E","S","W"],"answer":2,"explanation":"N→E→S = South"},{"q":"5km N, 12km E। Distance?","options":["7","10","13","17"],"answer":2,"explanation":"√(5²+12²) = √169 = 13"}]}$j$),
    (427, 'govt_basic', 'dir-concept', 'concept', 1, 'दिशा ज्ञान',
     $j${"text":"North, South, East, West — चार दिशाएँ। Right turn में N→E, E→S, S→W, W→N. Left turn उल्टा।","note":"चित्र बनाकर हल करो"}$j$),
    (427, 'govt_basic', 'dir-formula', 'formula', 2, 'Right/Left turns',
     $j${"formula":"Right: N→E→S→W→N · Left: N→W→S→E→N","explanation":"कुल right turn चार में वापस North"}$j$),
    (427, 'govt_basic', 'dir-example', 'example', 3, 'उदाहरण',
     $j${"question":"East facing, right turn। अब कौन सी दिशा?","solution":"East के right = South","answer":"South"}$j$),
    (427, 'govt_basic', 'dir-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"South facing, right turn?","options":["N","E","W","S"],"answer":2,"explanation":"S के right = West"},{"q":"2km N, 2km S। अब position?","options":["4km N","Same spot","2km N","2km S"],"answer":1,"explanation":"N और S cancel"}]}$j$),
    (427, null, 'dir-diagram', 'svg', 5, 'Compass directions',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><line x1='150' y1='20' x2='150' y2='100' stroke='#64748b' stroke-width='2'/><line x1='100' y1='60' x2='200' y2='60' stroke='#64748b' stroke-width='2'/><text x='150' y='18' text-anchor='middle' fill='#60a5fa' font-size='12' font-weight='bold'>N</text><text x='150' y='115' text-anchor='middle' fill='#60a5fa' font-size='12' font-weight='bold'>S</text><text x='92' y='65' text-anchor='middle' fill='#14b8a6' font-size='12' font-weight='bold'>W</text><text x='208' y='65' text-anchor='middle' fill='#14b8a6' font-size='12' font-weight='bold'>E</text></svg>","caption":"N-E-S-W: Right turn clockwise"}$j$),

    -- ═══ Ch 428: Mathematical Operations ═══
    (428, 'govt_technical', 'op-concept', 'concept', 1, 'गणितीय संक्रियाएँ — Reasoning',
     $j${"text":"Symbols को नए अर्थ में बदला जाता है। जैसे + का मतलब × हो तो 2+3 का मतलब 2×3 = 6. BODMAS लगाओ असली operations पर, नए symbols पर नहीं।","note":"पहले सारे symbols replace करो, फिर BODMAS।"}$j$),
    (428, 'govt_technical', 'op-formula', 'formula', 2, 'Symbol replacement',
     $j${"formula":"+→× means 4+3 = 4×3 = 12 · ÷→− means 8÷2 = 8−2 = 6","explanation":"BODMAS हमेशा replace के बाद apply"}$j$),
    (428, 'govt_technical', 'op-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"अगर + = ×, × = −, तो 4 + 3 × 2 = ?","solution":"4×3−2 = 12−2","answer":"10"}$j$),
    (428, 'govt_technical', 'op-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"अगर − = ÷, तो 8 − 2 = ?","options":["6","4","10","16"],"answer":1,"explanation":"8÷2 = 4"},{"q":"अगर × = +, + = ×, तो 2 × 3 + 4 = ?","options":["14","20","10","18"],"answer":0,"explanation":"× → +, + → ×: 2 + 3 × 4 = 2 + 12 = 14"}]}$j$),
    (428, 'govt_basic', 'op-concept', 'concept', 1, 'गणितीय संक्रियाएँ',
     $j${"text":"Symbols का मतलब बदल जाता है। + का मतलब ×, तो 2+3 = 2×3 = 6। पहले symbol replace करो, फिर solve।","note":"BODMAS हमेशा apply"}$j$),
    (428, 'govt_basic', 'op-formula', 'formula', 2, 'Symbols बदलो',
     $j${"formula":"+→× (replace), फिर BODMAS लगाओ","explanation":"2+3 = 6 (अगर + का मतलब ×)"}$j$),
    (428, 'govt_basic', 'op-example', 'example', 3, 'उदाहरण',
     $j${"question":"अगर − = +, तो 5 − 3 = ?","solution":"5+3","answer":"8"}$j$),
    (428, 'govt_basic', 'op-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"अगर + = −, तो 7 + 2 = ?","options":["9","5","14","3"],"answer":1,"explanation":"7−2 = 5"},{"q":"अगर × = ÷, तो 12 × 4 = ?","options":["48","16","3","8"],"answer":2,"explanation":"12÷4 = 3"}]}$j$),
    (428, null, 'op-diagram', 'svg', 5, 'Symbol replacement',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='40' y='40' width='80' height='40' rx='8' fill='#60a5fa'/><text x='80' y='65' text-anchor='middle' fill='white' font-size='18' font-weight='bold'>+</text><text x='135' y='65' fill='#f59e0b' font-size='20'>→</text><rect x='165' y='40' width='80' height='40' rx='8' fill='#14b8a6'/><text x='205' y='65' text-anchor='middle' fill='white' font-size='18' font-weight='bold'>×</text><text x='150' y='105' text-anchor='middle' fill='#64748b' font-size='11'>2+3 means 2×3 = 6</text></svg>","caption":"Symbol replace करके solve करो"}$j$),

    -- ═══ Ch 429: Seating Arrangement & Puzzle ═══
    (429, 'govt_technical', 'seat-concept', 'concept', 1, 'बैठक व्यवस्था — Reasoning',
     $j${"text":"Linear arrangement: 1D row, Left-Right। Circular: चारों ओर बैठना, clockwise/anticlockwise। Facing center vs facing outside — direction उल्टी होती है। N people in row: कुल positions N, 'between' count = |pos1 − pos2| − 1।","note":"SSC में 5-7 लोगों की arrangement के 3-4 questions आते हैं।"}$j$),
    (429, 'govt_technical', 'seat-formula', 'formula', 2, 'Arrangement rules',
     $j${"formula":"Linear: कुल = N · 'Between' = |pos1−pos2|−1 · Circular: (N−1)! arrangements","explanation":"Facing center: left = clockwise · Facing outside: left = anti-clockwise"}$j$),
    (429, 'govt_technical', 'seat-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"5 लोग row में। A 2nd from left, B 4th from left। बीच में कितने?","solution":"|4−2|−1 = 1","answer":"1 व्यक्ति (C)"}$j$),
    (429, 'govt_technical', 'seat-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"7 लोगों में A 3rd from left, B 5th from left। बीच में?","options":["1","2","3","4"],"answer":0,"explanation":"|5−3|−1 = 1"},{"q":"4 लोग circle में center की ओर मुख करके बैठे हैं। A के left वाला व्यक्ति किस दिशा में गिना जाता है?","options":["clockwise","anticlockwise","opposite","same"],"answer":0,"explanation":"Facing center: left = clockwise"}]}$j$),
    (429, 'govt_basic', 'seat-concept', 'concept', 1, 'बैठक व्यवस्था',
     $j${"text":"Linear में सीधी पंक्ति, Circular में गोल। 'Left' और 'Right' वक्ता के सामने बैठे व्यक्ति की दिशा से।","note":"चित्र बनाकर हल करो"}$j$),
    (429, 'govt_basic', 'seat-formula', 'formula', 2, 'Position नियम',
     $j${"formula":"'Between' = |pos1 − pos2| − 1","explanation":"Total positions पहले count करो"}$j$),
    (429, 'govt_basic', 'seat-example', 'example', 3, 'उदाहरण',
     $j${"question":"5 लोग row में। A 1st from left, B 5th from left। बीच में?","solution":"|5−1|−1 = 3","answer":"3 लोग"}$j$),
    (429, 'govt_basic', 'seat-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"4 लोग row में। A 1st, B 4th। बीच में?","options":["1","2","3","0"],"answer":1,"explanation":"|4−1|−1 = 2"},{"q":"'Left' और 'Right' किससे?","options":["वक्ता से","व्यक्ति से","किताब से","कोई नहीं"],"answer":0,"explanation":"वक्ता के सामने से देखो"}]}$j$),
    (429, null, 'seat-diagram', 'svg', 5, 'Linear arrangement',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><circle cx='60' cy='60' r='15' fill='#60a5fa'/><text x='60' y='65' text-anchor='middle' fill='white' font-size='11'>A</text><circle cx='110' cy='60' r='15' fill='#94a3b8'/><text x='110' y='65' text-anchor='middle' fill='white' font-size='11'>B</text><circle cx='160' cy='60' r='15' fill='#94a3b8'/><text x='160' y='65' text-anchor='middle' fill='white' font-size='11'>C</text><circle cx='210' cy='60' r='15' fill='#94a3b8'/><text x='210' y='65' text-anchor='middle' fill='white' font-size='11'>D</text><circle cx='260' cy='60' r='15' fill='#14b8a6'/><text x='260' y='65' text-anchor='middle' fill='white' font-size='11'>E</text><text x='150' y='100' text-anchor='middle' fill='#64748b' font-size='11'>Row: A B C D E</text></svg>","caption":"Linear arrangement: 5 लोग row में"}$j$),

    -- ═══ Ch 431: Syllogism ═══
    (431, 'govt_technical', 'syl-concept', 'concept', 1, 'न्याय निगमन — Syllogism',
     $j${"text":"All / Some / No statements से conclusions निकालो। Venn diagram बनाओ। Rules: (1) All A are B → A ⊂ B, (2) Some A are B → A ∩ B ≠ ∅, (3) No A is B → A ∩ B = ∅। Conclusion valid होगा अगर सभी cases में सही।","note":"SSC में 2-3 statements, 2-4 conclusions के questions आते हैं।"}$j$),
    (431, 'govt_technical', 'syl-formula', 'formula', 2, 'Syllogism rules',
     $j${"formula":"All A are B: A⊂B · Some A are B: overlap · No A is B: disjoint","explanation":"All A are B + All B are C → All A are C · Some A are B + All B are C → Some A are C"}$j$),
    (431, 'govt_technical', 'syl-example', 'example', 3, 'Numerical (JE style)',
     $j${"question":"All cats are dogs. All dogs are animals. Conclusion?","solution":"Cats ⊂ Dogs ⊂ Animals","answer":"All cats are animals (valid)"}$j$),
    (431, 'govt_technical', 'syl-mcq', 'mcq', 4, 'JE MCQs',
     $j${"questions":[{"q":"All A are B. Some B are C. Conclusion?","options":["All A are C","Some A are C","No A is C","Cannot determine"],"answer":3,"explanation":"C के साथ A का relationship clear नहीं (C में कुछ B हैं जो A नहीं)"},{"q":"No A is B. All B are C. Conclusion?","options":["No A is C","Some A are C","All A are C","Cannot determine"],"answer":3,"explanation":"C में कुछ B हैं; A उन B से अलग है, पर C के साथ A का relation uncertain"}]}$j$),
    (431, 'govt_basic', 'syl-concept', 'concept', 1, 'न्याय निगमन',
     $j${"text":"All A are B का मतलब सारे A, B के अंदर। Some A are B का मतलब कुछ A, B के साथ। Venn diagram बनाकर conclusion check करो।","note":"हर case में valid होना चाहिए"}$j$),
    (431, 'govt_basic', 'syl-formula', 'formula', 2, 'मूल नियम',
     $j${"formula":"All A are B → A⊂B · Some A are B → overlap · No A is B → disjoint","explanation":"All+All → All conclusion valid"}$j$),
    (431, 'govt_basic', 'syl-example', 'example', 3, 'उदाहरण',
     $j${"question":"All roses are flowers. Conclusion: All flowers are roses?","solution":"Roses ⊆ Flowers, not reverse","answer":"False (invalid conclusion)"}$j$),
    (431, 'govt_basic', 'syl-mcq', 'mcq', 4, 'अभ्यास प्रश्न',
     $j${"questions":[{"q":"All birds can fly. Peacock is a bird. Can peacock fly?","options":["Yes","No","Cannot determine","Maybe"],"answer":0,"explanation":"All birds → peacock can fly (statement के अनुसार)"},{"q":"No dog is cat. Some cats are pets. Conclusion?","options":["Some dogs are pets","No dogs are pets","Cannot determine","All pets are cats"],"answer":2,"explanation":"Pets में क्या dog है या नहीं, clear नहीं"}]}$j$),
    (431, null, 'syl-diagram', 'svg', 5, 'Venn diagram',
     $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><circle cx='120' cy='60' r='40' fill='#60a5fa' opacity='0.6'/><circle cx='180' cy='60' r='40' fill='#14b8a6' opacity='0.6'/><text x='100' y='65' text-anchor='middle' fill='white' font-size='12'>A</text><text x='200' y='65' text-anchor='middle' fill='white' font-size='12'>B</text><text x='150' y='115' text-anchor='middle' fill='#64748b' font-size='11'>Some A are B (overlap)</text></svg>","caption":"Venn: Some A are B → overlap"}$j$)
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
-- where chapter_id in (426,427,428,429,431) and status='published' and not archived
-- group by 1,2 order by 1,2;
-- Expected per chapter: govt_technical=4, govt_basic=4, NULL=1 (ch 431 also has law_management=3 pre-existing)
