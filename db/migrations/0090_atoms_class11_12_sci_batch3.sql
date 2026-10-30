with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ CLASS 11-12 BIOLOGY (911-918, 920) ═══
    (911, 'class_11_12_sci', 'exc-1112-concept', 'concept', 1, 'उत्सर्जन — Class 11-12',
     $j${"text":"Kidney: 2 bean-shaped organs (retroperitoneal)। Nephron = functional unit (~1 million per kidney)। Urine formation 4 stages: filtration (glomerulus → Bowman's capsule), reabsorption (PCT — glucose, AA, Na⁺), secretion (DCT — H⁺, K⁺), concentration (Loop of Henle counter-current)। GFR ≈ 125 mL/min = 180 L/day filtrate, ~1.5 L urine। Hormones: ADH (water reabsorption — posterior pituitary), aldosterone (Na⁺ retention), ANF (natriuretic)।","note":"Board में nephron, GFR, और hormone regulation ज़रूरी हैं।"}$j$),
    (911, 'class_11_12_sci', 'exc-1112-formula', 'formula', 2, 'उत्सर्जन सूत्र',
     $j${"formula":"GFR ≈ 125 mL/min · Urine ≈ 1.5 L/day · Filtration fraction = GFR/RPF ≈ 0.2","explanation":"Counter-current: Loop of Henle (descending — water out; ascending — Na⁺/Cl⁻ out) · ADH → aquaporins in DCT/collecting duct → water reabsorption"}$j$),
    (911, 'class_11_12_sci', 'exc-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"ADH secretion ↑ हो तो urine volume?","solution":"ADH → more water reabsorbed → concentrated urine, ↓ volume","answer":"Urine volume decreases (concentrated)"}$j$),
    (911, 'class_11_12_sci', 'exc-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Nephron का functional unit?","options":["Neuron","Nephron","Alveolus","Villus"],"answer":1,"explanation":"Nephron = kidney's functional unit"},{"q":"ADH कहाँ से?","options":["Anterior pituitary","Posterior pituitary","Adrenal","Kidney"],"answer":1,"explanation":"ADH = posterior pituitary"}]}$j$),

    (912, 'class_11_12_sci', 'nerve-1112-concept', 'concept', 1, 'तंत्रिका तंत्र — Class 11-12',
     $j${"text":"Neuron: cell body, dendrites, axon, myelin (Schwann cells)। Resting potential -70 mV (Na⁺ out, K⁺ in — Na⁺/K⁺ ATPase)। Action potential +30 mV (Na⁺ influx → depolarization; K⁺ efflux → repolarization)। Myelinated: saltatory conduction (120 m/s), unmyelinated: 1 m/s। CNS: brain + spinal cord; PNS: somatic + autonomic (sympathetic + parasympathetic)। Reflex arc: receptor → sensory → spinal cord → motor → effector।","note":"Board में action potential, synapse, और brain parts ज़रूरी हैं।"}$j$),
    (912, 'class_11_12_sci', 'nerve-1112-formula', 'formula', 2, 'तंत्रिका सूत्र',
     $j${"formula":"Resting: -70 mV · Action: +30 mV · Change = 100 mV · Myelinated: 120 m/s · Synapse delay ≈ 0.5 ms","explanation":"Na⁺/K⁺ pump: 3Na⁺ out, 2K⁺ in per ATP · Brain: cerebrum (thinking), cerebellum (balance), medulla (involuntary — breathing, heart), hypothalamus (temperature, hunger)"}$j$),
    (912, 'class_11_12_sci', 'nerve-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Nerve impulse 0.6m neuron में 120 m/s। Time?","solution":"t = d/v = 0.6/120","answer":"5 ms"}$j$),
    (912, 'class_11_12_sci', 'nerve-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Resting potential में dominant outside ion?","options":["K⁺","Na⁺","Cl⁻","Ca²⁺"],"answer":1,"explanation":"Na⁺ outside, K⁺ inside"},{"q":"Balance center?","options":["Cerebrum","Cerebellum","Medulla","Hypothalamus"],"answer":1,"explanation":"Cerebellum = balance + coordination"}]}$j$),

    (913, 'class_11_12_sci', 'hormones-1112-concept', 'concept', 1, 'हार्मोन — Class 11-12',
     $j${"text":"Endocrine glands: hypothalamus (master regulator via pituitary), pituitary (master gland — anterior + posterior), thyroid (T3/T4 — metabolism; calcitonin — Ca²⁺↓), parathyroid (PTH — Ca²⁺↑), adrenal (cortex: cortisol, aldosterone; medulla: adrenaline), pancreas (insulin β-cells — glucose↓; glucagon α-cells — glucose↑), gonads (testosterone, estrogen, progesterone), pineal (melatonin — sleep), thymus (T cells)। Negative feedback maintains hormone levels।","note":"Board में hormone-gland-disorder mapping ज़रूरी है।"}$j$),
    (913, 'class_11_12_sci', 'hormones-1112-formula', 'formula', 2, 'हार्मोन सूत्र',
     $j${"formula":"Insulin: glucose↓ · Glucagon: glucose↑ · Thyroxine: BMR↑ · Cortisol: stress (glucose↑) · ADH: water retention","explanation":"Disorders: diabetes (insulin), goiter (I deficiency), dwarfism/gigantism (GH), Addison's (cortisol↓), Cushing's (cortisol↑)"}$j$),
    (913, 'class_11_12_sci', 'hormones-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Diabetes mellitus में कौन hormone deficient?","solution":"Insulin (β-cells of pancreas)","answer":"Insulin"}$j$),
    (913, 'class_11_12_sci', 'hormones-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Master gland?","options":["Thyroid","Pituitary","Adrenal","Pancreas"],"answer":1,"explanation":"Pituitary = master gland"},{"q":"Adrenaline कहाँ से?","options":["Cortex","Medulla","Thyroid","Pancreas"],"answer":1,"explanation":"Adrenal medulla (fight/flight)"}]}$j$),

    (914, 'class_11_12_sci', 'skeletal-1112-concept', 'concept', 1, 'कंकाल — Class 11-12',
     $j${"text":"Skeletal: 206 bones (adult), 300+ newborn। Axial (80): skull, vertebral, ribs, sternum; Appendicular (126): limbs + girdles। Bone types: long (femur), short (wrist), flat (skull), irregular (vertebra), sesamoid (patella)। Joints: fibrous (immovable), cartilaginous (slightly), synovial (freely movable — ball-socket, hinge, pivot, saddle, gliding, condyloid)। Muscle: skeletal (striated, voluntary), smooth (non-striated, involuntary), cardiac (striated, involuntary, intercalated discs)। Sliding filament theory: actin + myosin; sarcomere = functional unit।","note":"Board में bones count, joints, और muscle contraction ज़रूरी हैं।"}$j$),
    (914, 'class_11_12_sci', 'skeletal-1112-formula', 'formula', 2, 'कंकाल तथ्य',
     $j${"formula":"206 bones (adult) · Axial=80, Appendicular=126 · Smallest: stapes (~3 mm) · Largest: femur","explanation":"Synovial joints: ball-socket (shoulder/hip), hinge (elbow/knee), pivot (neck), saddle (thumb), gliding (wrist), condyloid (knuckle) · Sarcomere: Z-line to Z-line"}$j$),
    (914, 'class_11_12_sci', 'skeletal-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Sarcomere कहाँ से कहाँ?","solution":"Z-line to Z-line (functional unit of muscle)","answer":"Z-line → Z-line"}$j$),
    (914, 'class_11_12_sci', 'skeletal-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Adult bones?","options":["106","206","306","406"],"answer":1,"explanation":"206 adult bones"},{"q":"Shoulder joint type?","options":["Hinge","Ball-socket","Pivot","Saddle"],"answer":1,"explanation":"Shoulder = ball-socket"}]}$j$),

    (915, 'class_11_12_sci', 'repro-1112-concept', 'concept', 1, 'जनन — Class 11-12',
     $j${"text":"Male: testes → sperm (spermatogenesis — continuous from puberty; FSH + LH + testosterone)। Female: ovary → egg (oogenesis — begins in fetus, arrested at prophase I, completes only on fertilization)। Menstrual cycle 28 days: follicular (day 1-13) → ovulation (day 14, LH surge) → luteal (day 15-28, progesterone)। Fertilization in ampulla of fallopian tube। hCG from trophoblast maintains corpus luteum। Gestation ≈ 9 months।","note":"Board में menstrual cycle hormones और fertilization ज़रूरी हैं।"}$j$),
    (915, 'class_11_12_sci', 'repro-1112-formula', 'formula', 2, 'जनन सूत्र',
     $j${"formula":"Spermatogenesis: continuous, 74 days/cycle · Oogenesis: arrested prophase I until fertilization · Menstrual cycle: 28 days · Ovulation: day 14 (LH surge)","explanation":"Sperm: 200-300 million/ejaculation · Fertilization site: ampulla · hCG: maintains corpus luteum (progesterone)"}$j$),
    (915, 'class_11_12_sci', 'repro-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Ovulation कब होता है?","solution":"28-day cycle में day 14 (LH surge के बाद)","answer":"Day 14"}$j$),
    (915, 'class_11_12_sci', 'repro-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Fertilization site?","options":["Uterus","Ovary","Ampulla (fallopian)","Cervix"],"answer":2,"explanation":"Ampulla of fallopian tube"},{"q":"hCG का function?","options":["Ovulation","Maintain corpus luteum","Spermatogenesis","Menstruation"],"answer":1,"explanation":"hCG maintains corpus luteum"}]}$j$),

    (916, 'class_11_12_sci', 'genetics-1112-concept', 'concept', 1, 'आनुवंशिकी — Class 11-12',
     $j${"text":"Mendel's laws: segregation (alleles separate in gametes), independent assortment (different genes independent)। DNA structure: Watson-Crick (1953) — double helix, A=T (2 H-bonds), G≡C (3 H-bonds)। Central dogma: DNA → RNA → protein। Genetic disorders: autosomal (sickle cell, cystic fibrosis), sex-linked (hemophilia, color blindness), chromosomal (Down = trisomy 21, Turner = XO, Klinefelter = XXY)। Pedigree analysis। Linkage + crossing over (recombination)।","note":"Board में Mendel ratios, DNA pairing, और disorders ज़रूरी हैं।"}$j$),
    (916, 'class_11_12_sci', 'genetics-1112-formula', 'formula', 2, 'आनुवंशिकी सूत्र',
     $j${"formula":"Monohybrid F2: 3:1 (phenotype), 1:2:1 (genotype) · Dihybrid F2: 9:3:3:1 · Test cross: 1:1","explanation":"DNA pairing: A=T, G≡C · Codon = 3 bases = 1 AA · Down = trisomy 21 · Turner = XO · Klinefelter = XXY"}$j$),
    (916, 'class_11_12_sci', 'genetics-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"AaBb × AaBb dihybrid F2 ratio?","solution":"9:3:3:1 (A-B-, A-bb, aaB-, aabb)","answer":"9:3:3:1"}$j$),
    (916, 'class_11_12_sci', 'genetics-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Down syndrome?","options":["Trisomy 21","Monosomy X","Trisomy 18","XXY"],"answer":0,"explanation":"Down = trisomy 21"},{"q":"G-C H-bonds?","options":["1","2","3","4"],"answer":2,"explanation":"G≡C = 3 H-bonds"}]}$j$),

    (917, 'class_11_12_sci', 'evol-1112-concept', 'concept', 1, 'विकास — Class 11-12',
     $j${"text":"Evolution: Darwin (natural selection, Origin 1859), Lamarck (acquired characters — disproved)। Modern synthesis = Darwin + genetics। Evidence: fossils, homology (same structure — forelimb of man/whale/bat), analogy (different structure — wings of bird/insect), vestigial organs (appendix, wisdom teeth)। Hardy-Weinberg: p² + 2pq + q² = 1। Speciation via geographic isolation। Human evolution: Homo habilis → erectus → neanderthalensis → sapiens।","note":"Board में Darwin, H-W equilibrium, और human evolution ज़रूरी हैं।"}$j$),
    (917, 'class_11_12_sci', 'evol-1112-formula', 'formula', 2, 'विकास सूत्र',
     $j${"formula":"Hardy-Weinberg: p² + 2pq + q² = 1 (p + q = 1)","explanation":"p = dominant allele freq, q = recessive · Homologous = divergent evolution · Analogous = convergent evolution"}$j$),
    (917, 'class_11_12_sci', 'evol-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"p=0.7, q=?","solution":"p + q = 1 → q = 1 - 0.7","answer":"q = 0.3"}$j$),
    (917, 'class_11_12_sci', 'evol-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Natural selection?","options":["Lamarck","Darwin","Mendel","Pasteur"],"answer":1,"explanation":"Darwin (1859)"},{"q":"Vestigial organ?","options":["Heart","Appendix","Liver","Kidney"],"answer":1,"explanation":"Appendix = reduced function"}]}$j$),

    (918, 'class_11_12_sci', 'disease-1112-concept', 'concept', 1, 'रोग-प्रतिरक्षा — Class 11-12',
     $j${"text":"Immunity: innate (non-specific — skin, mucus, phagocytes) + acquired (specific — B cells → antibodies, T cells → cell-mediated, memory)। Active (own antibodies — vaccine) vs passive (transferred — mother→baby, antiserum)। Vaccines: live attenuated (BCG, MMR), killed (polio Salk), toxoid (tetanus), subunit (hepatitis B)। Diseases: malaria (Plasmodium, Anopheles), TB (Mycobacterium, airborne), AIDS (HIV, CD4 T-cells), typhoid (Salmonella, water)। Cancer: uncontrolled cell division, oncogenes, metastasis।","note":"Board में immunity types, vaccines, और diseases ज़रूरी हैं।"}$j$),
    (918, 'class_11_12_sci', 'disease-1112-formula', 'formula', 2, 'रोग सूत्र',
     $j${"formula":"Innate: non-specific (skin, phagocytes) · Acquired: specific (B, T cells) · Active: own antibodies (vaccine) · Passive: transferred (colostrum, antiserum)","explanation":"Malaria: Plasmodium (Anopheles) · TB: Mycobacterium · AIDS: HIV (CD4) · Cancer: oncogene + metastasis"}$j$),
    (918, 'class_11_12_sci', 'disease-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"BCG किस रोग के लिए?","solution":"Tuberculosis (TB)","answer":"TB"}$j$),
    (918, 'class_11_12_sci', 'disease-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"AIDS में target cells?","options":["RBC","CD4 T-cells","B cells","Platelets"],"answer":1,"explanation":"HIV attacks CD4 helper T-cells"},{"q":"Malaria pathogen?","options":["Virus","Bacteria","Protozoa (Plasmodium)","Fungi"],"answer":2,"explanation":"Plasmodium (protozoan)"}]}$j$),

    (920, 'class_11_12_sci', 'env-1112-concept', 'concept', 1, 'पर्यावरण — Class 11-12',
     $j${"text":"Ecosystem: biotic + abiotic components, food chain/web, trophic levels, 10% energy law (Lindeman)। Biogeochemical cycles: C, N, P, water। Pollution: air (PM, SO₂, NOₓ, CO), water (BOD, heavy metals), soil (pesticides), noise (dB)। Greenhouse: CO₂, CH₄, N₂O, CFCs। Ozone depletion: CFCs → Cl radical chain। Biodiversity hotspots: 4 in India (Western Ghats, Eastern Himalaya, Indo-Burma, Sundaland)। Conservation: in-situ (national parks), ex-situ (zoos, seed banks)।","note":"Board में pollution, ozone, और biodiversity ज़रूरी हैं।"}$j$),
    (920, 'class_11_12_sci', 'env-1112-formula', 'formula', 2, 'पर्यावरण सूत्र',
     $j${"formula":"10% energy transfer · BOD = O₂ consumed by microbes · Greenhouse: CO₂ > CH₄ > N₂O > CFCs (potency reverse)","explanation":"Pollution control: ESP, scrubber, catalytic converter · Ozone: O₃ absorbs UV-B · Biodiversity hotspots India: 4"}$j$),
    (920, 'class_11_12_sci', 'env-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"10,000 J producers → tertiary consumer?","solution":"10% × 10% × 10% = 0.1% → 0.001 × 10,000","answer":"10 J"}$j$),
    (920, 'class_11_12_sci', 'env-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"10% energy law?","options":["Darwin","Lindeman","Odum","Tansley"],"answer":1,"explanation":"Lindeman (1942)"},{"q":"Ozone depletion cause?","options":["CO₂","CFCs","SO₂","CH₄"],"answer":1,"explanation":"CFCs → Cl radicals"}]}$j$),

    -- ═══ CLASS 11-12 MATHS (1-11) ═══
    (1, 'class_11_12_sci', 'pct-1112-concept', 'concept', 1, 'प्रतिशत — Class 11-12',
     $j${"text":"Percentage: base concept + successive changes। Successive changes formula: net% = a + b + ab/100 (both increases), or a - b - ab/100 (increase then decrease)। For two equal rate changes (a% increase then a% decrease): net = -a²/100 (always decrease)। Percentage of percentage। Applications: population, depreciation, compound growth।","note":"Board में successive changes और mixed applications ज़रूरी हैं।"}$j$),
    (1, 'class_11_12_sci', 'pct-1112-formula', 'formula', 2, 'प्रतिशत सूत्र',
     $j${"formula":"Net% = a + b + ab/100 (both +) · a - b - ab/100 (one +, one −) · Equal ±a%: net = -a²/100","explanation":"Reverse: if price ↑20%, consumption ↓16.67% to keep expense constant (20/120) · Multiplier form: (1+a/100)(1+b/100) - 1"}$j$),
    (1, 'class_11_12_sci', 'pct-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Successive +10%, +20%। Net?","solution":"10 + 20 + 200/100 = 30 + 2","answer":"32% increase"}$j$),
    (1, 'class_11_12_sci', 'pct-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"+20%, -20% → net?","options":["0%","-4%","+4%","-20%"],"answer":1,"explanation":"-a²/100 = -400/100 = -4%"},{"q":"Price +25%, consumption ↓?","options":["20%","25%","15%","30%"],"answer":0,"explanation":"25/125 = 0.2 = 20% decrease"}]}$j$),

    (2, 'class_11_12_sci', 'pl-1112-concept', 'concept', 1, 'लाभ-हानि — Class 11-12',
     $j${"text":"Profit/Loss: CP, SP, MP (marked price)। Discount on MP, profit/loss on CP। Successive discounts: net = a + b - ab/100। False weight problems: profit% = (true - false)/false × 100। Relation: SP = CP(1+P/100) = MP(1-D/100)। If CP > SP → loss, if SP > CP → profit।","note":"Board में successive discounts और false weight ज़रूरी हैं।"}$j$),
    (2, 'class_11_12_sci', 'pl-1112-formula', 'formula', 2, 'लाभ-हानि सूत्र',
     $j${"formula":"Profit% = (SP-CP)/CP × 100 · Discount% = (MP-SP)/MP × 100 · Successive: net = a + b - ab/100","explanation":"SP = CP(100+P)/100 = MP(100-D)/100 · False weight (sells 900g as 1kg): profit = 100/900 = 11.11%"}$j$),
    (2, 'class_11_12_sci', 'pl-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"CP=₹800, MP=₹1200, discount=20%। Profit%?","solution":"SP = 1200 × 0.8 = 960। Profit = 960 - 800 = 160। % = 160/800 × 100","answer":"20%"}$j$),
    (2, 'class_11_12_sci', 'pl-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Successive 10%, 20% discounts?","options":["28%","30%","25%","32%"],"answer":0,"explanation":"10+20-200/100 = 28%"},{"q":"Sells 800g as 1kg। Profit%?","options":["20%","25%","30%","15%"],"answer":1,"explanation":"200/800 = 25%"}]}$j$),

    (3, 'class_11_12_sci', 'si-1112-concept', 'concept', 1, 'ब्याज — Class 11-12',
     $j${"text":"Simple Interest: SI = PRT/100 (linear growth)। Compound Interest: A = P(1+R/100)ⁿ, CI = A - P (exponential)। CI-SI difference: for 2 years = P(R/100)², for 3 years = P(R/100)²(3 + R/100)। Compounding frequency: half-yearly (R/2, 2n), quarterly (R/4, 4n)। Effective annual rate: (1+R/n)ⁿ - 1।","note":"Board में CI formula derivation और difference formula ज़रूरी हैं।"}$j$),
    (3, 'class_11_12_sci', 'si-1112-formula', 'formula', 2, 'ब्याज सूत्र',
     $j${"formula":"SI = PRT/100 · CI = P[(1+R/100)ⁿ - 1] · CI-SI (2y) = P(R/100)²","explanation":"Half-yearly: R/2, 2n · Quarterly: R/4, 4n · 3-year difference: P(R/100)²(3 + R/100)"}$j$),
    (3, 'class_11_12_sci', 'si-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"₹10000, 10%, 2 वर्ष। CI-SI?","solution":"P(R/100)² = 10000 × (0.1)² = 10000 × 0.01","answer":"₹100"}$j$),
    (3, 'class_11_12_sci', 'si-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"₹1000, 10%, 1 वर्ष, half-yearly। Amount?","solution":"A = 1000(1+0.05)² = 1000×1.1025","options":["1100","1102.5","1105","1120"],"answer":1,"explanation":"A = 1000(1.05)² = 1102.5"},{"q":"CI vs SI (same P, R, T)?","options":["CI < SI","CI = SI","CI > SI","Depends"],"answer":2,"explanation":"CI ≥ SI always (except T=1 or R=0)"}]}$j$),

    (4, 'class_11_12_sci', 'ratio-1112-concept', 'concept', 1, 'अनुपात — Class 11-12',
     $j${"text":"Ratio: a:b, comparison। Proportion: a:b::c:d → ad = bc। Componendo-dividendo: a/b=c/d → (a+b)/(a-b)=(c+d)/(c-d)। Continued proportion: a:b = b:c → b²=ac। Mean proportional of a,b = √(ab)। Compound ratio: (a:b)×(c:d) = (ac:bd)। Variation: direct (y=kx), inverse (y=k/x), joint (y=kxz)।","note":"Board में componendo-dividendo और variation ज़रूरी हैं।"}$j$),
    (4, 'class_11_12_sci', 'ratio-1112-formula', 'formula', 2, 'अनुपात सूत्र',
     $j${"formula":"a/b = c/d → ad=bc · (a+b)/(a-b) = (c+d)/(c-d) (componendo) · b² = ac (continued)","explanation":"Mean prop of a,b = √(ab) · Direct: y=kx · Inverse: y=k/x · Joint: y=kxz"}$j$),
    (4, 'class_11_12_sci', 'ratio-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"₹1200 को 2:3:5 में बाँटो। सबसे बड़ा?","solution":"Total parts = 10। Largest = 1200 × 5/10","answer":"₹600"}$j$),
    (4, 'class_11_12_sci', 'ratio-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Mean prop of 4 and 9?","options":["6","6.5","13","36"],"answer":0,"explanation":"√(4×9) = √36 = 6"},{"q":"If a/b=c/d, then (a+b)/(a-b)?","options":["c/d","(c+d)/(c-d)","ad/bc","cd"],"answer":1,"explanation":"Componendo-dividendo"}]}$j$),

    (5, 'class_11_12_sci', 'avg-1112-concept', 'concept', 1, 'औसत — Class 11-12',
     $j${"text":"Averages: arithmetic (AM), geometric (GM), harmonic (HM)। AM ≥ GM ≥ HM (equality if all equal)। Weighted average: (Σwᵢxᵢ)/(Σwᵢ)। Average of first n: naturals (n+1)/2, odd n, even n+1। Average speed = total distance/total time। Mean deviation, variance, standard deviation।","note":"Board में AM-GM-HM और weighted average ज़रूरी हैं।"}$j$),
    (5, 'class_11_12_sci', 'avg-1112-formula', 'formula', 2, 'औसत सूत्र',
     $j${"formula":"AM = Σx/n · GM = (Πxᵢ)^(1/n) · HM = n/Σ(1/xᵢ) · AM ≥ GM ≥ HM","explanation":"1st n naturals: (n+1)/2 · 1st n odd: n · 1st n even: n+1 · Avg speed = total dist/total time"}$j$),
    (5, 'class_11_12_sci', 'avg-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"10 students avg 50, 5 students avg 60। Combined?","solution":"(10×50 + 5×60)/(10+5) = 800/15","answer":"53.33"}$j$),
    (5, 'class_11_12_sci', 'avg-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"AM, GM, HM में सबसे बड़ा?","options":["AM","GM","HM","बराबर"],"answer":0,"explanation":"AM ≥ GM ≥ HM"},{"q":"2 और 8 का GM?","options":["4","5","6","5.5"],"answer":0,"explanation":"√(2×8) = 4"}]}$j$),

    (6, 'class_11_12_sci', 'age-1112-concept', 'concept', 1, 'आयु — Class 11-12',
     $j${"text":"Age problems: present (x), past (x-n), future (x+n)। Multi-variable: two-person age problems — use simultaneous equations। Ratio of ages at different times। Product/sum relations। Quadratic for complex age relations।","note":"Board में simultaneous equations और ratio-based age problems ज़रूरी हैं।"}$j$),
    (6, 'class_11_12_sci', 'age-1112-formula', 'formula', 2, 'आयु सूत्र',
     $j${"formula":"Present = x · Past (n years) = x - n · Future (n years) = x + n · Ratio: (x+a)/(y+a) = p/q","explanation":"Two variables: solve 2 equations · If 'a times now, b times later': a·x + n = b(x + n)"}$j$),
    (6, 'class_11_12_sci', 'age-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Father 3× son; 12 years later 2×। Father now?","solution":"3x+12 = 2(x+12) → 3x+12=2x+24 → x=12। Father = 36","answer":"36 years"}$j$),
    (6, 'class_11_12_sci', 'age-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"A 40, B 20। कितने साल पहले A = 3B?","solution":"40-n = 3(20-n) → 40-n = 60-3n → 2n=20 → n=10","options":["5y","10y","15y","20y"],"answer":1,"explanation":"10 years ago: A=30, B=10"},{"q":"A 32, B 8। कब A=3B?","solution":"32+n = 3(8+n) → 32+n=24+3n → 8=2n → n=4","options":["2y","4y","6y","8y"],"answer":1,"explanation":"After 4 years: A=36, B=12"}]}$j$),

    (7, 'class_11_12_sci', 'mix-1112-concept', 'concept', 1, 'मिश्रण — Class 11-12',
     $j${"text":"Alligation: mean price = weighted average। Ratio cheap:dear = (dear-mean):(mean-cheap)। Repeated replacement: after n ops of volume r from total V: final pure = initial × (1-r/V)ⁿ। Mixing with different concentrations। Two-stage mixing।","note":"Board में repeated replacement और alligation ज़रूरी हैं।"}$j$),
    (7, 'class_11_12_sci', 'mix-1112-formula', 'formula', 2, 'मिश्रण सूत्र',
     $j${"formula":"Alligation: q_cheap/q_dear = (dear-mean)/(mean-cheap) · Replacement: final = initial × (1-r/V)ⁿ","explanation":"Mean = (q₁p₁ + q₂p₂)/(q₁+q₂) · Repeated replacement causes geometric decrease"}$j$),
    (7, 'class_11_12_sci', 'mix-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"₹30, ₹50 मिलाएँ → ₹42। Ratio?","solution":"(50-42):(42-30) = 8:12 = 2:3","answer":"2:3 (cheap:dear)"}$j$),
    (7, 'class_11_12_sci', 'mix-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Replacement 3×, r=V/4। Final fraction?","options":["(1/4)³","(3/4)³","1-(3/4)³","1/4"],"answer":1,"explanation":"(1-r/V)ⁿ = (3/4)³"},{"q":"₹20, ₹30 1:1। Mean?","options":["25","24","26","27"],"answer":0,"explanation":"(20+30)/2 = 25"}]}$j$),

    (8, 'class_11_12_sci', 'tw-1112-concept', 'concept', 1, 'समय-कार्य — Class 11-12',
     $j${"text":"Work: rate = 1/time। Combined: 1/x + 1/y = 1/t। Efficiency-based: A twice as good as B → time ratio 1:2। Alternate work: pattern-based। Wages proportional to work done (or efficiency)। Pipes: fill (+), drain (-)। Work and energy relation।","note":"Board में alternate work और wages ज़रूरी हैं।"}$j$),
    (8, 'class_11_12_sci', 'tw-1112-formula', 'formula', 2, 'कार्य सूत्र',
     $j${"formula":"1/x + 1/y = 1/t → t = xy/(x+y) · Efficiency ∝ 1/time · Wages ∝ work done","explanation":"3 workers: 1/x+1/y+1/z = 1/t · Alternate: 2-day work = 1/x + 1/y"}$j$),
    (8, 'class_11_12_sci', 'tw-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"A 10d, B 15d। Together?","solution":"1/10 + 1/15 = 3/30 + 2/30 = 5/30 = 1/6","answer":"6 days"}$j$),
    (8, 'class_11_12_sci', 'tw-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"A 6d, B 3d। Together?","options":["1d","2d","3d","4d"],"answer":1,"explanation":"1/6+1/3 = 3/6 = 1/2 → 2 days"},{"q":"A twice as efficient as B। Time ratio?","options":["1:2","2:1","1:4","4:1"],"answer":0,"explanation":"Efficiency 2:1 → time 1:2"}]}$j$),

    (9, 'class_11_12_sci', 'tsd-1112-concept', 'concept', 1, 'चाल-दूरी — Class 11-12',
     $j${"text":"Speed = d/t। Average speed (equal distances) = 2v₁v₂/(v₁+v₂) (HM)। Relative: same |v₁-v₂|, opposite v₁+v₂। Train: pole L/v, platform (L+P)/v, crossing train (L₁+L₂)/relative। Boat: down (b+s), up (b-s)। Circular: relative speed, meeting points।","note":"Board में relative motion और boat-stream ज़रूरी हैं।"}$j$),
    (9, 'class_11_12_sci', 'tsd-1112-formula', 'formula', 2, 'चाल सूत्र',
     $j${"formula":"Avg speed (equal D) = 2v₁v₂/(v₁+v₂) · Relative = |v₁-v₂| (same), v₁+v₂ (opposite) · Train platform = (L+P)/v","explanation":"1 km/h = 5/18 m/s · Boat: down=b+s, up=b-s · Circular: relative speed, time = circumference/relative"}$j$),
    (9, 'class_11_12_sci', 'tsd-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"60 km/h और 40 km/h equal D। Avg speed?","solution":"2×60×40/(60+40) = 4800/100","answer":"48 km/h (not 50!)"}$j$),
    (9, 'class_11_12_sci', 'tsd-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Train 100m, 10m/s, 200m platform। Time?","options":["20s","25s","30s","35s"],"answer":2,"explanation":"(100+200)/10 = 30s"},{"q":"Boat still 10, stream 2। Upstream 24km?","options":["2h","3h","4h","6h"],"answer":1,"explanation":"Up speed = 10-2 = 8। t = 24/8 = 3h"}]}$j$),

    (10, 'class_11_12_sci', 'num-1112-concept', 'concept', 1, 'संख्या पद्धति — Class 11-12',
     $j${"text":"HCF/LCM: Euclid's algorithm, prime factorization। Number of divisors: N = p^a·q^b → (a+1)(b+1)। Remainder theorem, cyclicity of units digit। Trailing zeros in n! = ⌊n/5⌋+⌊n/25⌋+...। Divisibility: 2, 3, 4, 5, 6, 8, 9, 11। Modular arithmetic। Chinese remainder theorem (basics)।","note":"Board में divisors count, cyclicity, और remainder ज़रूरी हैं।"}$j$),
    (10, 'class_11_12_sci', 'num-1112-formula', 'formula', 2, 'संख्या सूत्र',
     $j${"formula":"Divisors of N=p^a·q^b = (a+1)(b+1) · Trailing zeros = ⌊n/5⌋+⌊n/25⌋+... · HCF×LCM = a×b","explanation":"Cyclicity: units digit cycles (2,3,7,8: cycle 4; 4,9: cycle 2; 5,6,0,1: cycle 1)"}$j$),
    (10, 'class_11_12_sci', 'num-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"360 = 2³×3²×5¹। Total divisors?","solution":"(3+1)(2+1)(1+1) = 4×3×2","answer":"24 divisors"}$j$),
    (10, 'class_11_12_sci', 'num-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"100! trailing zeros?","solution":"⌊100/5⌋=20, ⌊100/25⌋=4 → 24","options":["20","22","24","25"],"answer":2,"explanation":"20+4 = 24"},{"q":"2¹⁰⁰ units digit?","solution":"Cycle 4, 100 mod 4 = 0 → units = 6","options":["2","4","6","8"],"answer":2,"explanation":"Cycle: 2,4,8,6"}]}$j$),

    (11, 'class_11_12_sci', 'simp-1112-concept', 'concept', 1, 'सरलीकरण — Class 11-12',
     $j${"text":"BODMAS with nested brackets, surds, indices। Surds: √a·√b=√(ab), √a/√b=√(a/b), rationalization। Indices: aᵐ·aⁿ=aᵐ⁺ⁿ, (aᵐ)ⁿ=aᵐⁿ, a⁰=1, a⁻ᵐ=1/aᵐ। Fraction operations with LCM। Complex fractions (nested)। Approximation।","note":"Board में surds और rationalization ज़रूरी हैं।"}$j$),
    (11, 'class_11_12_sci', 'simp-1112-formula', 'formula', 2, 'सरलीकरण सूत्र',
     $j${"formula":"aᵐ·aⁿ = aᵐ⁺ⁿ · (aᵐ)ⁿ = aᵐⁿ · 1/(√a+√b) = (√a-√b)/(a-b) · a⁻ᵐ = 1/aᵐ","explanation":"BODMAS: bracket → order → div → mul → add → sub · Rationalize: multiply by conjugate"}$j$),
    (11, 'class_11_12_sci', 'simp-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"1/(√5-√3) rationalize?","solution":"×(√5+√3)/(√5+√3) = (√5+√3)/(5-3)","answer":"(√5+√3)/2"}$j$),
    (11, 'class_11_12_sci', 'simp-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"√8 + √18 = ?","options":["√26","5√2","√25","2√5"],"answer":1,"explanation":"2√2 + 3√2 = 5√2"},{"q":"2^(1/2) × 2^(1/3) = ?","options":["2^(1/6)","2^(5/6)","2^(2/6)","4"],"answer":1,"explanation":"2^(1/2+1/3) = 2^(5/6)"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], array['class_11', 'class_12']::text[],
  case when s.chapter_id < 20 then 'maths' else 'general-science' end,
  'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, count(*) from mtb.atoms 
-- where chapter_id in (911,912,913,914,915,916,917,918,920,1,2,3,4,5,6,7,8,9,10,11) 
--   and level_id='class_11_12_sci' and status='published' and not archived 
-- group by 1 order by 1;
-- Expected: each chapter = 4

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: 1699 + 80 = 1779