with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ BANKING REASONING (426, 427, 428, 429, 431, 27, 28) ═══
    (426, 'banking', 'code-bank-concept', 'concept', 1, 'कूट-लेखन — Banking',
     $j${"text":"Coding shortcuts: shift pattern (+n, -n), reverse alphabet (A↔Z), position number (A=1)। Banking में 3-4 types: word code, number code, mixed code। Speed trick: पहले 2-3 letters का shift check करो, बाकी same pattern होगा।","note":"Banking में speed और pattern detection ज़रूरी है।"}$j$),
    (426, 'banking', 'code-bank-formula', 'formula', 2, 'Coding shortcuts',
     $j${"formula":"+1 shift: A→B, B→C · Reverse: A↔Z (sum=27) · Position: A=1, B=2","explanation":"PEN → QFO (+1 each) · Reverse: CAT → XZG (C→X, A→Z, T→G)"}$j$),
    (426, 'banking', 'code-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"If CAT=DBU, then BAT=?","solution":"+1 shift each letter: B→C, A→B, T→U","answer":"CBU"}$j$),
    (426, 'banking', 'code-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"If PEN=QFO, then INK=?","options":["JOL","JOK","IOL","JNL"],"answer":0,"explanation":"+1 each: I→J, N→O, K→L = JOL"},{"q":"Reverse code of A is?","options":["A","Y","Z","B"],"answer":2,"explanation":"A↔Z (sum=27)"}]}$j$),

    (427, 'banking', 'dir-bank-concept', 'concept', 1, 'दिशा ज्ञान — Banking',
     $j${"text":"Direction: N/E/S/W। Right turn (clockwise): N→E→S→W. Left turn (anti): N→W→S→E. Distance: √(x²+y²) for diagonal. Shadow-based questions: सुबह shadow पश्चिम, शाम पूर्व। Banking में 2-3 questions।","note":"Banking में shadow और turns shortcut ज़रूरी हैं।"}$j$),
    (427, 'banking', 'dir-bank-formula', 'formula', 2, 'Direction shortcuts',
     $j${"formula":"Right: N→E, E→S, S→W, W→N · Left: N→W, W→S, S→E, E→N · Distance = √(x²+y²)","explanation":"2 right turns = 180° (opposite) · 4 right turns = back to start · Morning shadow = West"}$j$),
    (427, 'banking', 'dir-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"3km N, 4km E। Start से distance?","solution":"√(3²+4²) = √25","answer":"5 km (NE direction)"}$j$),
    (427, 'banking', 'dir-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"East facing, 2 right turns। Direction?","options":["N","E","S","W"],"answer":3,"explanation":"E→S→W = West"},{"q":"Morning में shadow किस direction?","options":["N","E","S","W"],"answer":3,"explanation":"Morning: sun east → shadow west"}]}$j$),

    (428, 'banking', 'op-bank-concept', 'concept', 1, 'गणितीय संक्रियाएँ — Banking',
     $j${"text":"Symbol replacement: दिए गए symbols का नया meaning। Speed trick: पहले सारे symbols replace करो, फिर BODMAS। जैसे + का मतलब ×, × का मतलब −।","note":"Banking में BODMAS + replacement fast ज़रूरी है।"}$j$),
    (428, 'banking', 'op-bank-formula', 'formula', 2, 'Symbol shortcuts',
     $j${"formula":"Replace symbols, then BODMAS · +→×: 4+3=4×3=12 · ÷→−: 8÷2=8−2=6","explanation":"BODMAS: bracket → order → ÷ → × → + → −"}$j$),
    (428, 'banking', 'op-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"+ = ×, तो 5+4?","solution":"5×4","answer":"20"}$j$),
    (428, 'banking', 'op-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"− = ÷, तो 12−4?","options":["8","3","48","16"],"answer":1,"explanation":"12÷4 = 3"},{"q":"× = +, तो 7×5?","options":["35","12","2","0"],"answer":1,"explanation":"7+5 = 12"}]}$j$),

    (429, 'banking', 'seat-bank-concept', 'concept', 1, 'बैठक व्यवस्था — Banking',
     $j${"text":"Linear arrangement: row (single/double)। Circular: face center vs face outside। Formula: 'between' = |pos1-pos2|-1। Fixed positions: सबसे पहले definite वालों को रखो। Banking में 5-8 लोगों के arrangement।","note":"Banking में linear और circular arrangement ज़रूरी हैं।"}$j$),
    (429, 'banking', 'seat-bank-formula', 'formula', 2, 'Arrangement shortcuts',
     $j${"formula":"Between = |pos1 - pos2| - 1 · Linear: N total positions · Circular (N): (N-1)!","explanation":"Facing center: left = clockwise · Facing outside: left = anti-clockwise"}$j$),
    (429, 'banking', 'seat-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"6 लोग row में। A 2nd from left, B 5th from left। Between?","solution":"|5-2|-1 = 2","answer":"2 people"}$j$),
    (429, 'banking', 'seat-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"7 लोग, A 2nd from left, B 6th from left। Between?","options":["2","3","4","5"],"answer":1,"explanation":"|6-2|-1 = 3"},{"q":"Circular 5 people arrangements?","options":["5!","4!","5²","5"],"answer":1,"explanation":"(N-1)! = 4!"}]}$j$),

    (431, 'banking', 'syl-bank-concept', 'concept', 1, 'न्याय निगमन — Banking',
     $j${"text":"Syllogism: Venn diagram method। Rules: (1) All A are B → A⊂B, (2) Some A are B → overlap, (3) No A is B → disjoint। Conclusions valid only if true in ALL cases। 'Some' includes 'All' (logical)। Banking में 2-3 statements, 2-4 conclusions।","note":"Banking में Venn और case method ज़रूरी हैं।"}$j$),
    (431, 'banking', 'syl-bank-formula', 'formula', 2, 'Syllogism shortcuts',
     $j${"formula":"All A are B + All B are C → All A are C · Some A are B + All B are C → Some A are C","explanation":"No A is B + All B are C → No A is C (valid) · Some A are B → Some B are A (valid)"}$j$),
    (431, 'banking', 'syl-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"All pens are books। Some books are red। Conclusion?","solution":"'Some pens are red' NOT valid (pens कहीं भी हो सकते हैं books में)","answer":"Cannot determine"}$j$),
    (431, 'banking', 'syl-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"All A are B। Conclusion: Some B are A?","options":["Valid","Invalid","Cannot determine","None"],"answer":0,"explanation":"All A are B → Some B are A (valid converse)"},{"q":"No cats are dogs। Conclusion: No dogs are cats?","options":["Valid","Invalid","Both","None"],"answer":0,"explanation":"No A is B → No B is A (valid)"}]}$j$),

    (27, 'banking', 'venn-bank-concept', 'concept', 1, 'वेन आरेख — Banking',
     $j${"text":"Venn formula: n(A∪B) = n(A) + n(B) - n(A∩B)। Only A = n(A) - n(A∩B)। Neither = Total - n(A∪B)। Banking में 2-3 sets with overlapping। 'At least one' = A∪B।","note":"Banking में 2-set और 3-set Venn formula ज़रूरी हैं।"}$j$),
    (27, 'banking', 'venn-bank-formula', 'formula', 2, 'Venn shortcuts',
     $j${"formula":"n(A∪B) = n(A)+n(B)-n(A∩B) · Only A = n(A)-n(A∩B) · Neither = Total - n(A∪B)","explanation":"3 sets: n(A∪B∪C) = Σn - Σn(pair) + n(A∩B∩C)"}$j$),
    (27, 'banking', 'venn-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"30 students, 15 cricket, 20 football, 10 both। Only cricket?","solution":"Only cricket = 15 - 10","answer":"5"}$j$),
    (27, 'banking', 'venn-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"15 C, 20 F, 10 both, 30 total। Neither?","solution":"C∪F = 15+20-10 = 25। Neither = 30-25 = 5","options":["0","5","10","15"],"answer":1,"explanation":"Neither = 30-25 = 5"},{"q":"Above, only football?","options":["5","10","15","20"],"answer":1,"explanation":"20-10 = 10"}]}$j$),

    (28, 'banking', 'stmt-bank-concept', 'concept', 1, 'कथन और तर्क — Banking',
     $j${"text":"Statement: direct inference, comparison chain, data sufficiency। Comparison: A>B, B>C → A>C. Data sufficiency: दी गई जानकारी काफी है या नहीं। Banking में 2-3 statements, options: I, II, Both, None.","note":"Banking में comparison और data sufficiency ज़रूरी हैं।"}$j$),
    (28, 'banking', 'stmt-bank-formula', 'formula', 2, 'Statement shortcuts',
     $j${"formula":"A>B, B>C → A>C · A>B, B=C → A>C · A≥B, B≥C → A≥C","explanation":"Data Sufficiency options: (A) I alone, (B) II alone, (C) Both, (D) Neither, (E) Both needed"}$j$),
    (28, 'banking', 'stmt-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"A>B, B<C। A vs C?","solution":"C>B, A>B — A और C का relation नहीं पता","answer":"Cannot determine"}$j$),
    (28, 'banking', 'stmt-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"P>Q, Q>R, R>S। Shortest?","options":["P","Q","R","S"],"answer":3,"explanation":"P>Q>R>S → S smallest"},{"q":"A=B, B>C। A vs C?","options":["A>C","A<C","A=C","Cannot determine"],"answer":0,"explanation":"A=B>C → A>C"}]}$j$),

    -- ═══ BANKING GA (415, 417, 418, 419, 421, 422, 38, 40) ═══
    (415, 'banking', 'comp-bank-concept', 'concept', 1, 'कंप्यूटर — Banking',
     $j${"text":"Computer basics for banking: hardware (CPU, RAM, ROM, HDD), software (OS, applications)। Shortcuts (Ctrl+C/V/X/Z/S/P)। Generations (1st vacuum, 2nd transistor, 3rd IC, 4th microprocessor, 5th AI)। IBPS/SBI में computer awareness ज़रूरी है।","note":"Banking में shortcuts, units, और generations पूछे जाते हैं।"}$j$),
    (415, 'banking', 'comp-bank-formula', 'formula', 2, 'कंप्यूटर तथ्य',
     $j${"formula":"1 bit = 0/1 · 1 byte = 8 bits · 1 KB = 1024 bytes · 1 MB = 1024 KB · 1 GB = 1024 MB","explanation":"Ctrl+C copy, Ctrl+V paste, Ctrl+X cut, Ctrl+Z undo, Ctrl+S save, Ctrl+P print, Alt+F4 close"}$j$),
    (415, 'banking', 'comp-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"1 GB = कितने MB?","solution":"1024 MB","answer":"1024 MB"}$j$),
    (415, 'banking', 'comp-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"Ctrl+Z का function?","options":["Copy","Paste","Undo","Save"],"answer":2,"explanation":"Ctrl+Z = undo"},{"q":"1 KB में bytes?","options":["1000","1024","512","2048"],"answer":1,"explanation":"1024 bytes"}]}$j$),

    (417, 'banking', 'eco-bank-concept', 'concept', 1, 'अर्थव्यवस्था — Banking',
     $j${"text":"Banking में economy ज़रूरी: RBI (1935 स्थापित, 1949 राष्ट्रीयकृत) — मौद्रिक नीति, repo rate, CRR, SLR, inflation control। GDP, fiscal policy, budget। Types of banks (commercial, cooperative, RRB)। NABARD, SIDBI, EXIM।","note":"Banking में RBI functions और monetary policy पूछे जाते हैं।"}$j$),
    (417, 'banking', 'eco-bank-formula', 'formula', 2, 'अर्थव्यवस्था तथ्य',
     $j${"formula":"RBI: 1935 · Repo rate (RBI→bank) · Reverse repo (bank→RBI) · CRR (cash reserve) · SLR (statutory liquidity)","explanation":"GDP = C+I+G+(X-M) · Inflation ↑ → RBI ↑ repo (control)"}$j$),
    (417, 'banking', 'eco-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"CRR क्या है?","solution":"Cash Reserve Ratio — banks को RBI के पास cash रखना","answer":"CRR = % of deposits kept with RBI"}$j$),
    (417, 'banking', 'eco-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"RBI कब स्थापित?","options":["1935","1947","1949","1950"],"answer":0,"explanation":"RBI: 1 April 1935"},{"q":"Repo rate क्या है?","options":["Bank→RBI","RBI→Bank","Both","None"],"answer":1,"explanation":"Repo = RBI lends to banks"}]}$j$),

    (418, 'banking', 'geo-bank-concept', 'concept', 1, 'भूगोल — Banking',
     $j${"text":"Geography: 7 continents, 5 oceans। Longest river (Nile/Africa, Amazon/South America), highest peak (Everest), largest desert (Sahara)। भारत: 28 states, 8 UTs, longest river Ganga, highest peak K2 (PoK), largest state Rajasthan, smallest Goa। RBI headquarters Mumbai।","note":"Banking में rivers, capitals, और India facts ज़रूरी हैं।"}$j$),
    (418, 'banking', 'geo-bank-formula', 'formula', 2, 'भूगोल तथ्य',
     $j${"formula":"7 continents, 5 oceans · Largest: Asia, Pacific · Longest river: Nile (Africa), Amazon (S.America)","explanation":"India: 28 states + 8 UTs · RBI HQ = Mumbai · Capital = Delhi"}$j$),
    (418, 'banking', 'geo-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"भारत में कितने states (2024)?","solution":"28 states + 8 UT","answer":"28 states, 8 UTs"}$j$),
    (418, 'banking', 'geo-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"Largest ocean?","options":["Pacific","Atlantic","Indian","Arctic"],"answer":0,"explanation":"Pacific = largest"},{"q":"RBI headquarters?","options":["Delhi","Mumbai","Kolkata","Chennai"],"answer":1,"explanation":"Mumbai"}]}$j$),

    (419, 'banking', 'hist-bank-concept', 'concept', 1, 'इतिहास — Banking',
     $j${"text":"History: Ancient (Indus Valley 2500 BCE, Maurya 322 BCE, Gupta 320 CE), Medieval (Delhi Sultanate 1206, Mughal 1526), Modern (British 1757, Independence 1947)। Monuments: Taj Mahal (Agra, Shah Jahan), Qutub Minar (Delhi), Red Fort (Delhi)। Banking में dates और monuments।","note":"Banking में तिथियाँ और monuments ज़रूरी हैं।"}$j$),
    (419, 'banking', 'hist-bank-formula', 'formula', 2, 'इतिहास तथ्य',
     $j${"formula":"Independence: 1947 · Mughal: 1526 · British rule: 1757 · Constitution: 1950","explanation":"Taj Mahal (Shah Jahan, Agra) · Qutub Minar (Qutb-ud-din Aibak, Delhi)"}$j$),
    (419, 'banking', 'hist-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"भारत की आज़ादी कब?","solution":"15 August 1947","answer":"1947"}$j$),
    (419, 'banking', 'hist-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"Taj Mahal किसने?","options":["Akbar","Shah Jahan","Aurangzeb","Babur"],"answer":1,"explanation":"Shah Jahan"},{"q":"Independence year?","options":["1945","1946","1947","1948"],"answer":2,"explanation":"1947"}]}$j$),

    (421, 'banking', 'pol-bank-concept', 'concept', 1, 'राजव्यवस्था — Banking',
     $j${"text":"Polity: Constitution (26 Jan 1950), Preamble, Fundamental Rights (Part III), DPSP (Part IV)। President (Head of State), PM (Head of Government)। Parliament = Lok Sabha + Rajya Sabha। Lok Sabha 545, Rajya Sabha 245। Supreme Court = highest court। 3 branches: legislature, executive, judiciary।","note":"Banking में Constitution, Articles, और Parliament ज़रूरी हैं।"}$j$),
    (421, 'banking', 'pol-bank-formula', 'formula', 2, 'राजव्यवस्था तथ्य',
     $j${"formula":"Constitution: 26 Jan 1950 · Fundamental Rights: Part III (Art 12-35) · DPSP: Part IV (Art 36-51) · Parliament: LS + RS","explanation":"LS: 545 (543 elected + 2 nominated) · RS: 245 (233 elected + 12 nominated)"}$j$),
    (421, 'banking', 'pol-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"Lok Sabha total seats?","solution":"545","answer":"545 (543 elected + 2 nominated)"}$j$),
    (421, 'banking', 'pol-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"Constitution लागू कब?","options":["15 Aug 1947","26 Nov 1949","26 Jan 1950","26 Jan 1949"],"answer":2,"explanation":"26 January 1950"},{"q":"Rajya Sabha max?","options":["245","250","252","260"],"answer":1,"explanation":"245 (currently) → max 250 as per Constitution"}]}$j$),

    (422, 'banking', 'sgk-bank-concept', 'concept', 1, 'स्थिर GK — Banking',
     $j${"text":"Static GK: national symbols (bird=peacock, animal=tiger, flower=lotus, tree=banyan, fruit=mango, sport=hockey, river=Ganga)। Important days: 26 Jan (Republic), 15 Aug (Independence), 2 Oct (Gandhi Jayanti), 5 Sep (Teacher's), 14 Nov (Children's), 8 Mar (Women's)। Capitals + currencies।","note":"Banking में national symbols और days ज़रूरी हैं।"}$j$),
    (422, 'banking', 'sgk-bank-formula', 'formula', 2, 'Static GK तथ्य',
     $j${"formula":"National: bird=मोर, animal=बाघ, flower=कमल, tree=बरगद, fruit=आम, sport=हॉकी","explanation":"Days: 26 Jan Republic · 15 Aug Independence · 2 Oct Gandhi · 5 Sep Teacher · 14 Nov Children"}$j$),
    (422, 'banking', 'sgk-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"RBI national bank कब?","solution":"1 April 1935","answer":"1935 (nationalized 1949)"}$j$),
    (422, 'banking', 'sgk-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"National flower?","options":["Rose","Lotus","Sunflower","Jasmine"],"answer":1,"explanation":"Lotus = national flower"},{"q":"Women's Day?","options":["8 Mar","8 Apr","18 Mar","8 May"],"answer":0,"explanation":"8 March"}]}$j$),

    (38, 'banking', 'cult-bank-concept', 'concept', 1, 'कला-संस्कृति — Banking',
     $j${"text":"8 classical dances: Bharatnatyam (TN), Kathak (UP), Kathakali (Kerala), Kuchipudi (AP), Odissi (Odisha), Manipuri (Manipur), Mohiniyattam (Kerala), Sattriya (Assam)। Music: Hindustani (North), Carnatic (South)। Monuments: Taj Mahal (Agra), Qutub Minar (Delhi), Konark (Odisha), Hampi (Karnataka)।","note":"Banking में dances और monuments ज़रूरी हैं।"}$j$),
    (38, 'banking', 'cult-bank-formula', 'formula', 2, 'कला-संस्कृति तथ्य',
     $j${"formula":"Bharatnatyam-TN · Kathak-UP · Kathakali-Kerala · Kuchipudi-AP · Odissi-Odisha · Manipuri-Manipur · Mohiniyattam-Kerala · Sattriya-Assam","explanation":"UNESCO sites: Taj Mahal, Qutub Minar, Red Fort, Ajanta, Ellora, Konark, Hampi"}$j$),
    (38, 'banking', 'cult-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"Kathakali किस राज्य?","solution":"Kerala","answer":"केरल"}$j$),
    (38, 'banking', 'cult-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"Odissi किस राज्य?","options":["Odisha","TN","Kerala","UP"],"answer":0,"explanation":"Odisha"},{"q":"Bharatnatyam?","options":["TN","UP","Kerala","AP"],"answer":0,"explanation":"Tamil Nadu"}]}$j$),

    (40, 'banking', 'scitech-bank-concept', 'concept', 1, 'विज्ञान-प्रौद्योगिकी — Banking',
     $j${"text":"Inventions: Telephone-Bell, Bulb-Edison, Radio-Marconi, Computer-Babbage, Penicillin-Fleming, Aeroplane-Wright Bros, Polio-Salk। SI units: Force=Newton, Energy=Joule, Power=Watt, Current=Ampere, Resistance=Ohm, Pressure=Pascal, Frequency=Hz।","note":"Banking में inventions और SI units ज़रूरी हैं।"}$j$),
    (40, 'banking', 'scitech-bank-formula', 'formula', 2, 'विज्ञान तथ्य',
     $j${"formula":"Force=N, Energy=J, Power=W, Current=A, R=Ω, P=Pa, f=Hz, T=K","explanation":"Telephone=Bell, Bulb=Edison, Computer=Babbage, Penicillin=Fleming"}$j$),
    (40, 'banking', 'scitech-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"Force का SI unit?","solution":"Newton","answer":"N (Newton)"}$j$),
    (40, 'banking', 'scitech-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"Electric current unit?","options":["Volt","Ampere","Ohm","Watt"],"answer":1,"explanation":"Current = Ampere (A)"},{"q":"Penicillin discoverer?","options":["Fleming","Pasteur","Koch","Salk"],"answer":0,"explanation":"Alexander Fleming"}]}$j$),

    -- ═══ GOVT_DEFENCE (870-874 start) ═══
    (870, 'govt_defence', 'meas-def-concept', 'concept', 1, 'मापन — NDA/CDS',
     $j${"text":"Defence applications of measurement: artillery range, radar frequency, navigation (nautical miles)। SI units + conversion: 1 nautical mile = 1.852 km, 1 knot = 1.852 km/h, military time 24-hour clock। Dimensional analysis। Errors: precision, accuracy।","note":"Defence में nautical miles, knots, और artillery angle ज़रूरी हैं।"}$j$),
    (870, 'govt_defence', 'meas-def-formula', 'formula', 2, 'मापन सूत्र',
     $j${"formula":"1 nautical mile = 1.852 km · 1 knot = 1.852 km/h · [Force] = MLT⁻²","explanation":"Radar: kHz-GHz · Artillery range: R = u²sin2θ/g (max at 45°) · Military time: 0-24 hours"}$j$),
    (870, 'govt_defence', 'meas-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Ship 20 knots। km/h में?","solution":"20 × 1.852","answer":"37.04 km/h"}$j$),
    (870, 'govt_defence', 'meas-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"1 nautical mile = ?","options":["1 km","1.5 km","1.852 km","2 km"],"answer":2,"explanation":"1 nautical mile = 1.852 km"},{"q":"1 knot = ?","options":["1 km/h","1.5 km/h","1.852 km/h","2 km/h"],"answer":2,"explanation":"1 knot = 1.852 km/h"}]}$j$),

    (871, 'govt_defence', 'motion-def-concept', 'concept', 1, 'गति — NDA/CDS',
     $j${"text":"Motion: projectile motion (Artillery, missile trajectory)। Equations: v=u+at, s=ut+½at²। Projectile: R=u²sin2θ/g, H=u²sin²θ/2g, T=2usinθ/g। Relative velocity। Motion graphs। गोलीबारी की range 45° पर maximum।","note":"Defence में projectile और range calculations ज़रूरी हैं।"}$j$),
    (871, 'govt_defence', 'motion-def-formula', 'formula', 2, 'गति सूत्र',
     $j${"formula":"v = u+at · s = ut+½at² · R = u²sin2θ/g · H = u²sin²θ/2g · T = 2usinθ/g","explanation":"Max range at θ=45°: R = u²/g · Same range at θ and (90°-θ)"}$j$),
    (871, 'govt_defence', 'motion-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Artillery u=100 m/s, θ=45°। Range? (g=10)","solution":"R = u²sin2θ/g = 10000 × sin90° / 10 = 10000/10","answer":"1000 m (max range)"}$j$),
    (871, 'govt_defence', 'motion-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Max range angle?","options":["30°","45°","60°","90°"],"answer":1,"explanation":"Max range at 45°"},{"q":"Projectile T = ?","options":["usinθ/g","2usinθ/g","u²sin²θ/2g","u/g"],"answer":1,"explanation":"T = 2usinθ/g"}]}$j$),

    (872, 'govt_defence', 'force-def-concept', 'concept', 1, 'बल — NDA/CDS',
     $j${"text":"Force: Newton's laws, F=ma। Defence applications: recoil (conservation of momentum — gun kickback), blast force, parachute drag, tension in cables। Impulse F·t = Δp। Friction: track vs tyre, drag। Free body diagram।","note":"Defence में recoil और projectile force ज़रूरी हैं।"}$j$),
    (872, 'govt_defence', 'force-def-formula', 'formula', 2, 'बल सूत्र',
     $j${"formula":"F = ma · p = mv · Impulse = F·t = Δp · Recoil: m₁v₁ = m₂v₂ (momentum conserved)","explanation":"Recoil velocity: v_gun = -m_bullet × v_bullet / m_gun · Drag: F = ½ρv²Cd A"}$j$),
    (872, 'govt_defence', 'force-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Gun 5 kg, bullet 20g, v=400 m/s। Recoil velocity?","solution":"m₁v₁ = m₂v₂ → 5×v = 0.02×400 → v = 8/5","answer":"1.6 m/s (backward)"}$j$),
    (872, 'govt_defence', 'force-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Recoil में conserved?","options":["Force","Momentum","Velocity","Energy"],"answer":1,"explanation":"Recoil: momentum conserved"},{"q":"F = ma का source?","options":["Newton 1st","Newton 2nd","Newton 3rd","None"],"answer":1,"explanation":"Newton's 2nd law"}]}$j$),

    (873, 'govt_defence', 'work-def-concept', 'concept', 1, 'कार्य-ऊर्जा — NDA/CDS',
     $j${"text":"Work W=F·d·cosθ। Energy: KE=½mv², PE=mgh। Ballistics: bullet KE (lethality), missile energy, explosion energy। Conservation: energy, momentum। Power = W/t। Efficiency।","note":"Defence में bullet KE और explosion energy ज़रूरी हैं।"}$j$),
    (873, 'govt_defence', 'work-def-formula', 'formula', 2, 'कार्य-ऊर्जा सूत्र',
     $j${"formula":"W = Fd cosθ · KE = ½mv² · PE = mgh · P = W/t","explanation":"Bullet KE: ½mv² (lethality ∝ v²) · Explosion: chemical → kinetic + heat"}$j$),
    (873, 'govt_defence', 'work-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Bullet 10g, v=800 m/s। KE?","solution":"KE = ½ × 0.01 × 800² = ½ × 0.01 × 640000","answer":"3200 J"}$j$),
    (873, 'govt_defence', 'work-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Bullet KE ∝?","options":["v","v²","v³","1/v"],"answer":1,"explanation":"KE = ½mv² → ∝ v²"},{"q":"Power unit?","options":["J","W","N","Pa"],"answer":1,"explanation":"Power = Watt (J/s)"}]}$j$),

    (874, 'govt_defence', 'grav-def-concept', 'concept', 1, 'गुरुत्वाकर्षण — NDA/CDS',
     $j${"text":"Gravitation: g=9.8 m/s²। Variation with altitude/depth। Escape velocity v_e=11.2 km/s (rockets)۔ Satellite motion, orbital velocity v_o=7.9 km/s. Missile trajectory: ballistic। Gravity effect on projectile (parabolic path)। Kepler's laws।","note":"Defence में escape velocity और ballistic trajectory ज़रूरी हैं।"}$j$),
    (874, 'govt_defence', 'grav-def-formula', 'formula', 2, 'गुरुत्व सूत्र',
     $j${"formula":"g = GM/R² = 9.8 m/s² · v_e = √(2gR) = 11.2 km/s · v_o = √(gR) = 7.9 km/s · T² ∝ r³","explanation":"g' at height h: g(1-2h/R) · Missile (ballistic) trajectory: parabola (ideal) / ellipse (long range)"}$j$),
    (874, 'govt_defence', 'grav-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"g at 6400km height (R=6400km)?","solution":"g' = g/(1+h/R)² (h=R) = 9.8/2² = 9.8/4","answer":"≈ 2.45 m/s²"}$j$),
    (874, 'govt_defence', 'grav-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Earth escape velocity?","options":["7.9 km/s","11.2 km/s","2.4 km/s","18 km/s"],"answer":1,"explanation":"v_e = 11.2 km/s"},{"q":"Orbital velocity Earth?","options":["5 km/s","7.9 km/s","11.2 km/s","15 km/s"],"answer":1,"explanation":"v_o = 7.9 km/s"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[],
  case when s.chapter_id < 20 then 'maths' 
       when s.chapter_id >= 400 and s.chapter_id < 500 then 'reasoning' 
       when s.chapter_id < 410 then 'general-awareness' 
       else 'general-science' end,
  'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select level_id, count(*) from mtb.atoms 
-- where chapter_id in (426,427,428,429,431,27,28,415,417,418,419,421,422,38,40,870,871,872,873,874) 
--   and status='published' and not archived 
-- group by level_id;
-- Expected: banking=60 (15 chapters), govt_defence=20 (5 chapters)

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: 1859 + 80 = 1939