with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ STATE PSC BIO 913-918 ═══
    (913, 'state_psc', 'hormones-psc-concept', 'concept', 1, 'हार्मोन — State PSC',
     $j${"text":"Endocrine glands: pituitary (master), thyroid (thyroxine — metabolism, calcitonin — Ca²⁺↓), parathyroid (PTH — Ca²⁺↑), adrenal (cortisol, adrenaline), pancreas (insulin β-cells, glucagon α-cells), gonads (testosterone, estrogen)। Disorders: diabetes (insulin), goiter (iodine), dwarfism/gigantism (GH)। Negative feedback controls hormone levels।","note":"State PSC में hormone-gland-disorder mapping ज़रूरी है।"}$j$),
    (913, 'state_psc', 'hormones-psc-formula', 'formula', 2, 'हार्मोन तथ्य',
     $j${"formula":"Insulin: glucose↓ · Glucagon: glucose↑ · Thyroxine: BMR↑ · Adrenaline: fight/flight · Cortisol: stress","explanation":"Disorders: diabetes (insulin), goiter (iodine), dwarfism (GH↓), gigantism/acromegaly (GH↑)"}$j$),
    (913, 'state_psc', 'hormones-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Master gland कौन?","solution":"Pituitary (controls other glands)","answer":"Pituitary (master gland)"}$j$),
    (913, 'state_psc', 'hormones-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Insulin कहाँ से?","options":["Thyroid","Pancreas β-cells","Adrenal","Liver"],"answer":1,"explanation":"Pancreas β-cells"},{"q":"Goiter किसकी कमी?","options":["Iron","Iodine","Calcium","Vitamin C"],"answer":1,"explanation":"Iodine deficiency → goiter"}]}$j$),

    (914, 'state_psc', 'skeletal-psc-concept', 'concept', 1, 'कंकाल — State PSC',
     $j${"text":"Skeletal: 206 bones adult, 300+ newborn. Axial (80: skull, vertebral, ribs, sternum) + appendicular (126: limbs, girdles). Bone types: long (femur), short (wrist), flat (skull), irregular (vertebra)। Joints: fibrous (immovable), cartilaginous (slightly), synovial (freely movable)। Muscle: skeletal, smooth, cardiac।","note":"State PSC में bones count, joints, और muscle types ज़रूरी हैं।"}$j$),
    (914, 'state_psc', 'skeletal-psc-formula', 'formula', 2, 'कंकाल तथ्य',
     $j${"formula":"206 bones (adult) · Axial=80, Appendicular=126 · Longest: femur · Smallest: stapes (~3 mm)","explanation":"Synovial joints: ball-socket (shoulder/hip), hinge (elbow/knee), pivot (neck), saddle (thumb)"}$j$),
    (914, 'state_psc', 'skeletal-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"सबसे लंबी हड्डी?","solution":"Femur (thigh)","answer":"Femur"}$j$),
    (914, 'state_psc', 'skeletal-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Adult bones?","options":["106","206","306","406"],"answer":1,"explanation":"206 adult bones"},{"q":"Shoulder joint type?","options":["Hinge","Ball-socket","Pivot","Saddle"],"answer":1,"explanation":"Ball-socket joint"}]}$j$),

    (915, 'state_psc', 'repro-psc-concept', 'concept', 1, 'जनन — State PSC',
     $j${"text":"Reproduction: asexual (binary fission, budding, fragmentation) vs sexual (gametes)। Male: testes → sperm (spermatogenesis)। Female: ovary → egg (oogenesis)। Menstrual cycle: 28 days, ovulation day 14 (LH surge)। Fertilization: ampulla of fallopian tube। Gestation ~9 months।","note":"State PSC में menstrual cycle, ovulation, और fertilization ज़रूरी हैं।"}$j$),
    (915, 'state_psc', 'repro-psc-formula', 'formula', 2, 'जनन तथ्य',
     $j${"formula":"Menstrual cycle: 28 days · Ovulation: day 14 · Fertilization site: ampulla (fallopian tube)","explanation":"Menstrual phases: follicular (1-13), ovulation (14), luteal (15-28) · hCG maintains corpus luteum"}$j$),
    (915, 'state_psc', 'repro-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Ovulation day?","solution":"Day 14 (28-day cycle)","answer":"Day 14"}$j$),
    (915, 'state_psc', 'repro-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Fertilization site?","options":["Uterus","Ovary","Ampulla (fallopian)","Cervix"],"answer":2,"explanation":"Ampulla of fallopian tube"},{"q":"Asexual reproduction?","options":["Binary fission","Gamete fusion","Meiosis","Fertilization"],"answer":0,"explanation":"Binary fission (amoeba)"}]}$j$),

    (916, 'state_psc', 'genetics-psc-concept', 'concept', 1, 'आनुवंशिकी — State PSC',
     $j${"text":"Genetics: DNA double helix (Watson-Crick), A=T (2 H-bonds), G≡C (3)। Mendelian ratios: monohybrid 3:1, dihybrid 9:3:3:1. Human chromosomes: 46 (23 pairs)। Sex: XX female, XY male। Disorders: Down (trisomy 21), sickle cell (autosomal), hemophilia (X-linked)।","note":"State PSC में DNA pairing, Mendel ratios, और disorders ज़रूरी हैं।"}$j$),
    (916, 'state_psc', 'genetics-psc-formula', 'formula', 2, 'आनुवंशिकी तथ्य',
     $j${"formula":"Monohybrid F2: 3:1 · Dihybrid F2: 9:3:3:1 · DNA: A=T (2 H), G≡C (3 H)","explanation":"Human: 46 chromosomes · Down syndrome: trisomy 21 · Hemophilia: X-linked recessive"}$j$),
    (916, 'state_psc', 'genetics-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Aa × Aa F2 phenotype?","solution":"3:1 (dominant:recessive)","answer":"3:1"}$j$),
    (916, 'state_psc', 'genetics-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Down syndrome?","options":["Trisomy 21","Monosomy X","Trisomy 18","XXY"],"answer":0,"explanation":"Trisomy 21"},{"q":"G-C H-bonds?","options":["1","2","3","4"],"answer":2,"explanation":"G≡C = 3 H-bonds"}]}$j$),

    (917, 'state_psc', 'evol-psc-concept', 'concept', 1, 'विकास — State PSC',
     $j${"text":"Evolution: Darwin (natural selection, 1859), Lamarck (acquired characters — disproved)। Evidence: fossils, homologous (same structure), analogous (same function), vestigial organs (appendix)। Hardy-Weinberg: p²+2pq+q²=1। Human evolution: Homo habilis → erectus → sapiens।","note":"State PSC में Darwin, Hardy-Weinberg, और human evolution ज़रूरी हैं।"}$j$),
    (917, 'state_psc', 'evol-psc-formula', 'formula', 2, 'विकास तथ्य',
     $j${"formula":"Hardy-Weinberg: p² + 2pq + q² = 1 (p+q=1) · Natural selection (Darwin)","explanation":"Homologous: same origin, different function · Analogous: different origin, same function"}$j$),
    (917, 'state_psc', 'evol-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"p=0.7। q?","solution":"q = 1-0.7 = 0.3","answer":"0.3"}$j$),
    (917, 'state_psc', 'evol-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Natural selection?","options":["Lamarck","Darwin","Mendel","Pasteur"],"answer":1,"explanation":"Darwin (1859)"},{"q":"Vestigial organ?","options":["Heart","Appendix","Liver","Kidney"],"answer":1,"explanation":"Appendix (reduced)"}]}$j$),

    (918, 'state_psc', 'disease-psc-concept', 'concept', 1, 'रोग-प्रतिरक्षा — State PSC',
     $j${"text":"Diseases: infectious (bacterial, viral, protozoan) vs non-infectious। Malaria (Plasmodium, Anopheles), TB (Mycobacterium, airborne), polio (virus), typhoid (Salmonella, water), dengue (Aedes)। Immunity: innate (non-specific) + acquired (specific, memory)। Vaccines: live attenuated (BCG), killed (Salk), toxoid (tetanus)।","note":"State PSC में disease-pathogen-vector और vaccines ज़रूरी हैं।"}$j$),
    (918, 'state_psc', 'disease-psc-formula', 'formula', 2, 'रोग तथ्य',
     $j${"formula":"Malaria: Plasmodium (Anopheles) · TB: Mycobacterium (airborne) · Dengue: virus (Aedes) · Typhoid: Salmonella (water)","explanation":"Vaccines: BCG (TB, live), OPV (polio, live), Salk (polio, killed), tetanus (toxoid)"}$j$),
    (918, 'state_psc', 'disease-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Malaria vector?","solution":"Female Anopheles mosquito","answer":"Anopheles"}$j$),
    (918, 'state_psc', 'disease-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"TB pathogen?","options":["Virus","Bacteria","Fungi","Protozoa"],"answer":1,"explanation":"Mycobacterium tuberculosis"},{"q":"Dengue vector?","options":["Anopheles","Aedes","Culex","Sandfly"],"answer":1,"explanation":"Aedes aegypti"}]}$j$),

    -- ═══ STATE PSC REASONING (17,18,19,27,28,423,425-428,431) ═══
    (17, 'state_psc', 'ser-psc-concept', 'concept', 1, 'श्रृंखला — State PSC',
     $j${"text":"Series: number pattern (+n, ×n, square, cube, alternate)। Letter series: position gap. State PSC में simple-to-moderate patterns। Double difference for complex series।","note":"State PSC में pattern recognition ज़रूरी है।"}$j$),
    (17, 'state_psc', 'ser-psc-formula', 'formula', 2, 'श्रृंखला सूत्र',
     $j${"formula":"+n: 2,4,6,8 · ×n: 2,4,8,16 · Squares: 1,4,9,16 · Cubes: 1,8,27,64","explanation":"Alternate: two series combined (odd, even positions)"}$j$),
    (17, 'state_psc', 'ser-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"3, 6, 12, 24, ?","solution":"×2 pattern","answer":"48"}$j$),
    (17, 'state_psc', 'ser-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"1, 4, 9, 16, ?","options":["20","24","25","36"],"answer":2,"explanation":"5² = 25"},{"q":"2, 5, 10, 17, ?","solution":"Differ: 3,5,7 → next 9 → 17+9","options":["24","26","28","30"],"answer":1,"explanation":"Differences 3,5,7,9 → 26"}]}$j$),

    (18, 'state_psc', 'ana-psc-concept', 'concept', 1, 'सादृश्यता — State PSC',
     $j${"text":"Analogy: relationship types — worker:place, tool:action, part:whole, synonym, antonym. Number analogy: n:n², n:n³. State PSC में moderate difficulty।","note":"State PSC में relation identify ज़रूरी है।"}$j$),
    (18, 'state_psc', 'ana-psc-formula', 'formula', 2, 'सादृश्यता सूत्र',
     $j${"formula":"Worker:Place · Tool:Action · Cause:Effect · Part:Whole · n:n² or n:n³","explanation":"Doctor:Hospital · Pen:Write · 2:8 (cube)"}$j$),
    (18, 'state_psc', 'ana-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Bird:Fly :: Fish:?","solution":"Bird flies, fish swims","answer":"Swim"}$j$),
    (18, 'state_psc', 'ana-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Doctor:Hospital :: Teacher:?","options":["Book","School","Student","Pen"],"answer":1,"explanation":"Teacher works in School"},{"q":"3:27 :: 5:?","options":["25","75","125","150"],"answer":2,"explanation":"3³=27, 5³=125"}]}$j$),

    (19, 'state_psc', 'odd-psc-concept', 'concept', 1, 'विषम तत्व — State PSC',
     $j${"text":"Odd One Out: category check (fruits, colors, planets), number property (prime, square, even), pattern (all have letter 'a')। State PSC में 1-2 questions।","note":"State PSC में category detection ज़रूरी है।"}$j$),
    (19, 'state_psc', 'odd-psc-formula', 'formula', 2, 'विषम सूत्र',
     $j${"formula":"Categories: fruits (apple, mango), planets (Earth, Mars), prime (2,3,5,7), square (1,4,9,16)","explanation":"जो category में fit न हो, वो odd है"}$j$),
    (19, 'state_psc', 'odd-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"2, 3, 5, 7, 9, 11 — विषम?","solution":"9 = 3×3 (not prime)","answer":"9"}$j$),
    (19, 'state_psc', 'odd-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Apple, Mango, Carrot, Banana — विषम?","options":["Apple","Mango","Carrot","Banana"],"answer":2,"explanation":"Carrot = सब्ज़ी, बाकी फल"},{"q":"1, 4, 9, 16, 20 — विषम?","options":["4","9","16","20"],"answer":3,"explanation":"20 not perfect square"}]}$j$),

    (27, 'state_psc', 'venn-psc-concept', 'concept', 1, 'वेन आरेख — State PSC',
     $j${"text":"Venn: n(A∪B) = n(A)+n(B)-n(A∩B)। Only A = n(A)-n(A∩B)। Neither = Total-n(A∪B)। 3-set formula: n(A∪B∪C) = Σn - Σpair + n(A∩B∩C)।","note":"State PSC में 2-3 set Venn formula ज़रूरी हैं।"}$j$),
    (27, 'state_psc', 'venn-psc-formula', 'formula', 2, 'वेन सूत्र',
     $j${"formula":"n(A∪B) = n(A)+n(B)-n(A∩B) · Only A = n(A)-n(A∩B) · Neither = Total-n(A∪B)","explanation":"3 sets: n(A∪B∪C) = Σn - Σpair + n(A∩B∩C)"}$j$),
    (27, 'state_psc', 'venn-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"10 में 6 tea, 5 coffee, 3 both। Only tea?","solution":"6-3","answer":"3"}$j$),
    (27, 'state_psc', 'venn-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Above: at least one?","solution":"6+5-3 = 8","options":["5","8","11","14"],"answer":1,"explanation":"6+5-3 = 8"},{"q":"Neither?","solution":"10-8 = 2","options":["0","1","2","3"],"answer":2,"explanation":"10-8=2"}]}$j$),

    (28, 'state_psc', 'stmt-psc-concept', 'concept', 1, 'कथन तर्क — State PSC',
     $j${"text":"Statements: logical inference, comparison chains, data sufficiency। All A are B → Some B are A (valid)। A>B, B>C → A>C। Cannot determine when info incomplete।","note":"State PSC में logical inference ज़रूरी है।"}$j$),
    (28, 'state_psc', 'stmt-psc-formula', 'formula', 2, 'कथन सूत्र',
     $j${"formula":"All A are B → A⊂B · A>B, B>C → A>C · Data sufficiency: I, II, Both, Neither","explanation":"Converse: Some B are A valid (from All A are B)"}$j$),
    (28, 'state_psc', 'stmt-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"A>B, B>C, C>D। Largest?","solution":"A>B>C>D","answer":"A"}$j$),
    (28, 'state_psc', 'stmt-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"All cars have wheels। Maruti is car। Maruti has wheels?","options":["Yes","No","Cannot determine","Maybe"],"answer":0,"explanation":"Yes (all cars have wheels)"},{"q":"A>B, B<C। A vs C?","options":["A>C","A<C","A=C","Cannot determine"],"answer":3,"explanation":"C>B, A>B — A/C uncertain"}]}$j$),

    (423, 'state_psc', 'alpha-psc-concept', 'concept', 1, 'वर्णमाला — State PSC',
     $j${"text":"Alphabet positions: A=1 to Z=26। EJOTY: 5,10,15,20,25। Opposite: 27-position। Series: +n pattern। NATO alphabet (military)।","note":"State PSC में positions और patterns ज़रूरी हैं।"}$j$),
    (423, 'state_psc', 'alpha-psc-formula', 'formula', 2, 'वर्णमाला सूत्र',
     $j${"formula":"A=1, B=2, ..., Z=26 · Opposite = 27 - position · EJOTY: E=5, J=10, O=15, T=20, Y=25","explanation":"NATO: A=Alpha, B=Bravo, ... Z=Zulu"}$j$),
    (423, 'state_psc', 'alpha-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"A, C, E, G, ?","solution":"+2 pattern","answer":"I"}$j$),
    (423, 'state_psc', 'alpha-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"M का position?","options":["12","13","14","15"],"answer":1,"explanation":"A=1 ... M=13"},{"q":"R का opposite?","options":["F","G","I","H"],"answer":2,"explanation":"R=18, opp=27-18=9=I"}]}$j$),

    (425, 'state_psc', 'blood-psc-concept', 'concept', 1, 'रक्त संबंध — State PSC',
     $j${"text":"Blood relations: family tree, 2-3 generations। Pointing questions। 'Father's father' = दादा, 'Mother's brother' = मामा, 'Father's brother' = चाचा।","note":"State PSC में family tree और relations ज़रूरी हैं।"}$j$),
    (425, 'state_psc', 'blood-psc-formula', 'formula', 2, 'रक्त संबंध सूत्र',
     $j${"formula":"Father's father = दादा · Mother's father = नाना · Father's brother = चाचा · Mother's brother = मामा","explanation":"'X's father's son' = X's brother (or self if male)"}$j$),
    (425, 'state_psc', 'blood-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"'पिता के भाई' — कौन?","solution":"Father's brother = चाचा","answer":"चाचा"}$j$),
    (425, 'state_psc', 'blood-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"पिता की माँ?","options":["नानी","दादी","मौसी","बुआ"],"answer":1,"explanation":"दादी (paternal grandmother)"},{"q":"भाई का बेटा?","options":["भतीजा","भांजा","चचेरा","भतीजी"],"answer":0,"explanation":"भतीजा (nephew)"}]}$j$),

    (426, 'state_psc', 'code-psc-concept', 'concept', 1, 'कूट-लेखन — State PSC',
     $j${"text":"Coding: shift (+n, -n), reverse (A↔Z), position-based। Simple substitution cipher। State PSC में 2-3 questions। NATO alphabet (military) basics।","note":"State PSC में shift pattern ज़रूरी है।"}$j$),
    (426, 'state_psc', 'code-psc-formula', 'formula', 2, 'Coding सूत्र',
     $j${"formula":"+1 shift: A→B · Reverse: A↔Z (sum=27) · Position: A=1","explanation":"PEN +1 → QFO · NATO: A=Alpha, B=Bravo"}$j$),
    (426, 'state_psc', 'code-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"+1 shift: CAT → ?","solution":"C→D, A→B, T→U","answer":"DBU"}$j$),
    (426, 'state_psc', 'code-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"NATO for 'A'?","options":["Alpha","Apple","Able","Ace"],"answer":0,"explanation":"A = Alpha"},{"q":"Caesar +1: 'Z' → ?","options":["A","B","Y","Z"],"answer":0,"explanation":"Z+1 wraps to A"}]}$j$),

    (427, 'state_psc', 'dir-psc-concept', 'concept', 1, 'दिशा ज्ञान — State PSC',
     $j${"text":"Directions: N, E, S, W. Right turn (clockwise), left turn (anti)। Distance √(x²+y²) for diagonal। Shadow: morning West, evening East. State PSC में 1-2 questions।","note":"State PSC में turns और distance ज़रूरी हैं।"}$j$),
    (427, 'state_psc', 'dir-psc-formula', 'formula', 2, 'दिशा सूत्र',
     $j${"formula":"Right: N→E→S→W→N · Left: N→W→S→E→N · Distance = √(x²+y²)","explanation":"Morning shadow: West · Evening shadow: East"}$j$),
    (427, 'state_psc', 'dir-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"N, 2 right turns। Direction?","solution":"N→E→S","answer":"South"}$j$),
    (427, 'state_psc', 'dir-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"East facing, right turn?","options":["N","E","S","W"],"answer":2,"explanation":"E→S (right)"},{"q":"Morning shadow?","options":["N","E","S","W"],"answer":3,"explanation":"Morning: sun East → shadow West"}]}$j$),

    (428, 'state_psc', 'op-psc-concept', 'concept', 1, 'संक्रिया — State PSC',
     $j${"text":"Symbol replacement: नए meaning के साथ BODMAS। + का मतलब ×, तो 2+3 = 2×3 = 6। पहले replace, फिर solve।","note":"State PSC में BODMAS + replacement ज़रूरी है।"}$j$),
    (428, 'state_psc', 'op-psc-formula', 'formula', 2, 'संक्रिया सूत्र',
     $j${"formula":"Replace symbols, then BODMAS · +→×: 4+3 = 12 · −→÷: 8−2 = 4","explanation":"Order: bracket → order → ÷ → × → + → −"}$j$),
    (428, 'state_psc', 'op-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"+ = ×, तो 5+3?","solution":"5×3","answer":"15"}$j$),
    (428, 'state_psc', 'op-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"− = +, तो 9−4?","options":["5","13","36","0"],"answer":1,"explanation":"9+4 = 13"},{"q":"× = ÷, तो 12×3?","options":["36","4","15","9"],"answer":1,"explanation":"12÷3 = 4"}]}$j$),

    (431, 'state_psc', 'syl-psc-concept', 'concept', 1, 'न्याय निगमन — State PSC',
     $j${"text":"Syllogism: Venn diagram। All A are B, Some A are B, No A is B. Conclusion valid only if true in all cases. State PSC में 1-2 questions।","note":"State PSC में logical inference ज़रूरी है।"}$j$),
    (431, 'state_psc', 'syl-psc-formula', 'formula', 2, 'Syllogism सूत्र',
     $j${"formula":"All A are B + All B are C → All A are C · Some A are B + All B are C → Some A are C","explanation":"No A is B + All B are C → No A is C"}$j$),
    (431, 'state_psc', 'syl-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"All cats are dogs। Some dogs are cats?","solution":"Valid converse","answer":"Valid"}$j$),
    (431, 'state_psc', 'syl-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"All A are B। Some B are A?","options":["Valid","Invalid","Cannot determine","None"],"answer":0,"explanation":"Valid converse"},{"q":"No X is Y। No Y is X?","options":["Valid","Invalid","Cannot determine","Both"],"answer":0,"explanation":"Symmetric (No A is B → No B is A)"}]}$j$),

    -- ═══ STATE PSC MATHS 1-3 ═══
    (1, 'state_psc', 'pct-psc-concept', 'concept', 1, 'प्रतिशत — State PSC',
     $j${"text":"Percentage: प्रति सौ। 25% = 1/4। Successive changes: net = a+b+ab/100। Applications: marks, price, population, depreciation। State PSC में 2-3 questions।","note":"State PSC में successive changes और reverse percentage ज़रूरी हैं।"}$j$),
    (1, 'state_psc', 'pct-psc-formula', 'formula', 2, 'प्रतिशत सूत्र',
     $j${"formula":"% = (part/whole)×100 · Successive: net = a+b+ab/100 · Reverse: if +a%, then -a/(100+a)×100","explanation":"Same +a% then -a%: net = -a²/100 (decrease)"}$j$),
    (1, 'state_psc', 'pct-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Price +25%, consumption ↓?","solution":"25/125 × 100","answer":"20% decrease"}$j$),
    (1, 'state_psc', 'pct-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"+20% then -20%। Net?","options":["0%","-4%","+4%","-20%"],"answer":1,"explanation":"-a²/100 = -4%"},{"q":"500 का 15%?","options":["65","70","75","80"],"answer":2,"explanation":"500×0.15 = 75"}]}$j$),

    (2, 'state_psc', 'pl-psc-concept', 'concept', 1, 'लाभ-हानि — State PSC',
     $j${"text":"Profit% = (SP-CP)/CP×100। Discount on MP। Successive discounts: net = a+b-ab/100. False weight: profit% = error/(true-error)×100। State PSC में 1-2 questions।","note":"State PSC में profit/discount relations ज़रूरी हैं।"}$j$),
    (2, 'state_psc', 'pl-psc-formula', 'formula', 2, 'लाभ-हानि सूत्र',
     $j${"formula":"Profit% = (SP-CP)/CP × 100 · Discount% = (MP-SP)/MP × 100 · Successive: net = a+b-ab/100","explanation":"SP = CP(1+P/100) = MP(1-D/100) · False weight: profit = error/(true-error) × 100"}$j$),
    (2, 'state_psc', 'pl-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"CP=₹100, SP=₹120। Profit%?","solution":"20/100 × 100","answer":"20%"}$j$),
    (2, 'state_psc', 'pl-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Successive 10%, 20% discount?","options":["28%","30%","25%","32%"],"answer":0,"explanation":"10+20-200/100 = 28%"},{"q":"SP=₹0.8MP। Discount?","options":["10%","20%","25%","15%"],"answer":1,"explanation":"20%"}]}$j$),

    (3, 'state_psc', 'si-psc-concept', 'concept', 1, 'ब्याज — State PSC',
     $j${"text":"SI = PRT/100 (linear). CI = P[(1+R/100)ⁿ-1] (exponential). CI-SI difference: 2 years = P(R/100)²। Rule of 72: doubling time = 72/R। Compounding frequency: half-yearly, quarterly।","note":"State PSC में SI/CI formula और difference ज़रूरी हैं।"}$j$),
    (3, 'state_psc', 'si-psc-formula', 'formula', 2, 'ब्याज सूत्र',
     $j${"formula":"SI = PRT/100 · CI = P[(1+R/100)ⁿ-1] · CI-SI (2y) = P(R/100)²","explanation":"Rule 72: doubling = 72/R years · CI > SI always (except n=1)"}$j$),
    (3, 'state_psc', 'si-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"₹10000, 10%, 2y। CI-SI?","solution":"10000 × 0.01","answer":"₹100"}$j$),
    (3, 'state_psc', 'si-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"₹1000, 10%, 1y SI?","options":["₹50","₹100","₹150","₹200"],"answer":1,"explanation":"1000×10×1/100 = 100"},{"q":"Rule 72: R=8%, double time?","options":["8y","9y","10y","12y"],"answer":1,"explanation":"72/8 = 9y"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[],
  case when s.chapter_id < 20 then 'maths' 
       when s.chapter_id >= 400 and s.chapter_id < 500 then 'reasoning' 
       else 'general-science' end,
  'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, count(*) from mtb.atoms 
-- where chapter_id in (913,914,915,916,917,918,17,18,19,27,28,423,425,426,427,428,431,1,2,3) 
--   and level_id='state_psc' and status='published' and not archived 
-- group by 1 order by 1;
-- Expected: each chapter = 4 (20 chapters = 80 atoms)

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: ~2484 + 80 = ~2564
