with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ UPSC BIO 904-920 ═══
    (904, 'upsc_civil', 'plant-upsc-concept', 'concept', 1, 'पादप जगत — UPSC CSE',
     $j${"text":"Plant kingdom groups: algae, bryophytes, pteridophytes, gymnosperms, angiosperms. Angiosperms dominate (flowering plants)। India is mega-diverse (45,000+ plant species, 4 biodiversity hotspots: Himalaya, Indo-Burma, Sundaland, Western Ghats)। Threats: deforestation, invasive species, climate change। Conservation: botanical gardens, seed banks, sacred groves।","note":"UPSC में plant diversity को biodiversity policy और climate से जोड़ते हैं।"}$j$),
    (904, 'upsc_civil', 'plant-upsc-formula', 'formula', 2, 'पादप framework',
     $j${"formula":"Algae→Bryophytes→Pteridophytes→Gymnosperms→Angiosperms · Monocot: 1 cotyledon, parallel venation, fibrous root","explanation":"Dicot: 2 cotyledons, reticulate venation, tap root · India: 4 hotspots, ~7% of world species"}$j$),
    (904, 'upsc_civil', 'plant-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Sacred groves का conservation significance?","solution":"Community-protected forests (cultural belief) — in-situ biodiversity conservation","answer":"Community-led in-situ conservation"}$j$),
    (904, 'upsc_civil', 'plant-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"India biodiversity hotspots?","options":["2","3","4","5"],"answer":2,"explanation":"4 (Himalaya, Indo-Burma, Sundaland, Western Ghats)"},{"q":"Monocot venation?","options":["Reticulate","Parallel","Both","None"],"answer":1,"explanation":"Parallel"}]}$j$),

    (905, 'upsc_civil', 'nutrition-upsc-concept', 'concept', 1, 'पोषण — UPSC CSE',
     $j${"text":"Human nutrition: macronutrients (carbs, proteins, fats), micronutrients (vitamins, minerals)। Malnutrition: undernutrition (stunting, wasting), overnutrition (obesity)। Government schemes: Poshan Abhiyaan, ICDS, Mid-Day Meal, NFSA। Deficiency diseases: scurvy (C), rickets (D), anemia (Fe), goiter (I)।","note":"UPSC में nutrition को health policy और SDG-2 (Zero Hunger) से जोड़ते हैं।"}$j$),
    (905, 'upsc_civil', 'nutrition-upsc-formula', 'formula', 2, 'पोषण framework',
     $j${"formula":"Carbs 4 Cal/g · Proteins 4 · Fats 9 · Fat-soluble vitamins: A, D, E, K · Water-soluble: B, C","explanation":"Stunting: low height-for-age · Wasting: low weight-for-height · Obesity: BMI > 30"}$j$),
    (905, 'upsc_civil', 'nutrition-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Poshan Abhiyaan का उद्देश्य?","solution":"Reduce malnutrition (stunting, wasting, anemia) via convergence, technology, community","answer":"Malnutrition reduction (multi-sectoral)"}$j$),
    (905, 'upsc_civil', 'nutrition-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Anemia deficiency?","options":["Iodine","Iron","Calcium","Vitamin C"],"answer":1,"explanation":"Iron deficiency → anemia"},{"q":"Fat Cal/g?","options":["4","7","9","12"],"answer":2,"explanation":"9 Cal/g"}]}$j$),

    (906, 'upsc_civil', 'photo-upsc-concept', 'concept', 1, 'प्रकाश संश्लेषण — UPSC CSE',
     $j${"text":"Photosynthesis: CO₂ + H₂O + light → glucose + O₂. C3 (most plants), C4 (maize, sugarcane), CAM (cacti)। Chlorophyll, chloroplast। Photosynthesis = base of food chain, oxygen source। Climate change: CO₂ fertilization effect, ocean acidification (phytoplankton impact)।","note":"UPSC में photosynthesis को climate/agriculture से जोड़ते हैं।"}$j$),
    (906, 'upsc_civil', 'photo-upsc-formula', 'formula', 2, 'प्रकाश संश्लेषण framework',
     $j${"formula":"6CO₂ + 6H₂O + light → C₆H₁₂O₆ + 6O₂","explanation":"C4: Kranz anatomy, OAA first product, high temp efficiency · CAM: night CO₂, desert plants"}$j$),
    (906, 'upsc_civil', 'photo-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"C4 crops climate resilience में क्यों important?","solution":"High temp, low water efficient (Kranz anatomy) — climate-smart agriculture","answer":"Climate-resilient (heat/drought)"}$j$),
    (906, 'upsc_civil', 'photo-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"C4 crop?","options":["Rice","Wheat","Maize","Potato"],"answer":2,"explanation":"Maize (sugarcane also)"},{"q":"Photosynthesis O₂ source?","options":["CO₂","H₂O","Glucose","Air"],"answer":1,"explanation":"Water photolysis"}]}$j$),

    (907, 'upsc_civil', 'digest-upsc-concept', 'concept', 1, 'पाचन — UPSC CSE',
     $j${"text":"Digestive system: mouth → stomach → small intestine → large intestine. Enzymes: amylase (starch), pepsin (protein), lipase (fats)। Malnutrition absorption disorders (celiac, lactose intolerance)। Gut microbiome (health, immunity)। Swachh Bharat (sanitation → diarrheal disease)। ORS (dehydration treatment)।","note":"UPSC में digestion को sanitation/public health से जोड़ते हैं।"}$j$),
    (907, 'upsc_civil', 'digest-upsc-formula', 'formula', 2, 'पाचन framework',
     $j${"formula":"Mouth: amylase (starch→maltose) · Stomach: pepsin (protein→peptide) · Small intestine: trypsin + lipase (complete digestion)","explanation":"Small intestine = main absorption site (villi) · Large intestine: water absorption"}$j$),
    (907, 'upsc_civil', 'digest-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"ORS कैसे काम करता है?","solution":"Glucose + Na⁺ co-transport → water absorption → rehydration (WHO formula)","answer":"Na⁺-glucose co-transport"}$j$),
    (907, 'upsc_civil', 'digest-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Main absorption site?","options":["Stomach","Small intestine","Large intestine","Mouth"],"answer":1,"explanation":"Small intestine (villi)"},{"q":"ORS main principle?","options":["Glucose only","Na-glucose co-transport","Salt only","Water only"],"answer":1,"explanation":"Co-transport → water reabsorption"}]}$j$),

    (908, 'upsc_civil', 'resp-upsc-concept', 'concept', 1, 'श्वसन — UPSC CSE',
     $j${"text":"Respiration: aerobic (38 ATP) vs anaerobic (2 ATP)۔ Respiratory diseases: TB, asthma, COPD, pneumonia। Air pollution (PM2.5, PM10, NOₓ, SO₂) — respiratory health, lung cancer। COVID-19 (respiratory pandemic)। Oxygen therapy, ventilators। National Clean Air Programme (NCAP)।","note":"UPSC में respiration को air pollution policy से जोड़ते हैं।"}$j$),
    (908, 'upsc_civil', 'resp-upsc-formula', 'formula', 2, 'श्वसन framework',
     $j${"formula":"Aerobic: C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + 38 ATP · Anaerobic: glucose → lactic acid + 2 ATP","explanation":"Alveoli: gas exchange · SpO₂: 95-100% normal · PM2.5 annual: WHO 2021 guideline 5 μg/m³ (24-hr 15), India NAAQS 40 μg/m³"}$j$),
    (908, 'upsc_civil', 'resp-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"NCAP का target?","solution":"Reduce PM2.5/PM10 by 40% by 2025-26 (from 2017 baseline) in 130+ cities","answer":"40% PM reduction by 2025-26"}$j$),
    (908, 'upsc_civil', 'resp-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Aerobic ATP?","options":["2","18","38","100"],"answer":2,"explanation":"38 ATP (per glucose)"},{"q":"NCAP pollutant target?","options":["CO₂","PM2.5","CH₄","Ozone only"],"answer":1,"explanation":"PM2.5 and PM10"}]}$j$),

    (909, 'upsc_civil', 'circ-upsc-concept', 'concept', 1, 'परिसंचरण — UPSC CSE',
     $j${"text":"Cardiovascular system: heart, blood vessels, blood. Heart diseases (CVD — #1 killer globally)। Risk factors: hypertension, diabetes, smoking, obesity, stress, sedentary lifestyle। BP (120/80), ECG, stents, bypass surgery। Government initiatives: NPCDCS, Fit India, Ayushman Bharat (cardiac care)।","note":"UPSC में circulation को NCD prevention और health policy से जोड़ते हैं।"}$j$),
    (909, 'upsc_civil', 'circ-upsc-formula', 'formula', 2, 'परिसंचरण framework',
     $j${"formula":"CO = HR × SV ≈ 5 L/min · BP = 120/80 mmHg · Cardiac cycle = 0.8s","explanation":"Hypertension: >140/90 · Heart attack: coronary artery blocked → tissue death"}$j$),
    (909, 'upsc_civil', 'circ-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Cardiovascular diseases India में #1 killer क्यों?","solution":"Sedentary lifestyle, unhealthy diet, stress, smoking, diabetes rise","answer":"Lifestyle + NCD rise"}$j$),
    (909, 'upsc_civil', 'circ-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Normal BP?","options":["100/60","120/80","140/100","160/110"],"answer":1,"explanation":"120/80 mmHg"},{"q":"Universal donor?","options":["A+","B+","AB+","O−"],"answer":3,"explanation":"O− (no antigens)"}]}$j$),

    (910, 'upsc_civil', 'trans-upsc-concept', 'concept', 1, 'पादप परिवहन — UPSC CSE',
     $j${"text":"Plant transport: xylem (water + minerals up), phloem (sugars, source→sink)। Transpiration (~99% of absorbed water)। Water use efficiency in agriculture। Drip irrigation, micro-irrigation (Per Drop More Crop)। Transpiration → rainfall (hydrological cycle)।","note":"UPSC में plant transport को water/agriculture policy से जोड़ते हैं।"}$j$),
    (910, 'upsc_civil', 'trans-upsc-formula', 'formula', 2, 'परिवहन framework',
     $j${"formula":"Xylem: water up (transpiration pull) · Phloem: sugars source→sink (bidirectional)","explanation":"Transpiration: ~99% of absorbed water lost · Drip irrigation: 40-60% water saving"}$j$),
    (910, 'upsc_civil', 'trans-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Drip irrigation के benefits?","solution":"Water saving (40-60%), fertiliser efficiency (fertigation), yield ↑, weeds ↓","answer":"Water efficiency + yield"}$j$),
    (910, 'upsc_civil', 'trans-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Phloem transport?","options":["Up only","Down only","Both directions","None"],"answer":2,"explanation":"Source→sink (bidirectional)"},{"q":"Drip irrigation saving?","options":["10%","20%","40-60%","100%"],"answer":2,"explanation":"40-60% water saving"}]}$j$),

    (911, 'upsc_civil', 'exc-upsc-concept', 'concept', 1, 'उत्सर्जन — UPSC CSE',
     $j${"text":"Excretion: kidney (nephron, GFR ~125 mL/min), skin, lungs, liver। Kidney diseases: CKD, kidney failure, dialysis, transplant। Water pollution (fluoride, arsenic, nitrate) — kidney health। Jal Jeevan Mission (tap water)। Swachh Bharat (sanitation)।","note":"UPSC में excretion को water/sanitation policy से जोड़ते हैं।"}$j$),
    (911, 'upsc_civil', 'exc-upsc-formula', 'formula', 2, 'उत्सर्जन framework',
     $j${"formula":"GFR ≈ 125 mL/min · Urine ~1.5 L/day · Dialysis: 3-4 hours, 3x/week","explanation":"CKD stages: 1 (normal) to 5 (failure) · Fluorosis, arsenicosis (water pollution)"}$j$),
    (911, 'upsc_civil', 'exc-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Jal Jeevan Mission का objective?","solution":"Tap water to every rural household (2024 target), water quality testing","answer":"Rural tap water access"}$j$),
    (911, 'upsc_civil', 'exc-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"GFR normal?","options":["25","75","125","250"],"answer":2,"explanation":"125 mL/min"},{"q":"Jal Jeevan Mission target?","options":["Urban only","Rural tap water","Industry","Agriculture"],"answer":1,"explanation":"Rural household tap water"}]}$j$),

    (912, 'upsc_civil', 'nerve-upsc-concept', 'concept', 1, 'तंत्रिका — UPSC CSE',
     $j${"text":"Nervous system: CNS (brain, spinal cord) + PNS. Mental health: depression, anxiety, stress (increasing burden). Neurodegenerative: Alzheimer's, Parkinson's. Substance abuse (opioids, alcohol)। National Mental Health Programme (NMHP), Mental Healthcare Act 2017. Yoga, meditation (cognitive benefits)।","note":"UPSC में nervous system को mental health policy से जोड़ते हैं।"}$j$),
    (912, 'upsc_civil', 'nerve-upsc-formula', 'formula', 2, 'तंत्रिका framework',
     $j${"formula":"Resting: -70 mV · Action: +30 mV · Myelinated: 120 m/s · Brain: cerebrum (thinking), cerebellum (balance), medulla (involuntary)","explanation":"Mental health: NMHP (1982) · Mental Healthcare Act 2017 (rights-based)"}$j$),
    (912, 'upsc_civil', 'nerve-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Mental Healthcare Act 2017 का significance?","solution":"Rights-based (decriminalized suicide attempt), advance directives, insurance parity","answer":"Rights-based approach"}$j$),
    (912, 'upsc_civil', 'nerve-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Mental Healthcare Act year?","options":["1987","2002","2013","2017"],"answer":3,"explanation":"2017"},{"q":"Balance center?","options":["Cerebrum","Cerebellum","Medulla","Spinal cord"],"answer":1,"explanation":"Cerebellum"}]}$j$),

    (913, 'upsc_civil', 'hormones-upsc-concept', 'concept', 1, 'हार्मोन — UPSC CSE',
     $j${"text":"Endocrine system: pituitary, thyroid, adrenal, pancreas, gonads. Hormone disorders: diabetes (insulin), thyroid (hypo/hyper), PCOS, osteoporosis. Lifestyle diseases (diabetes, obesity)। Government: NPCDCS (diabetes+cancer), Fit India, Eat Right India। Endocrine disruptors (pesticides, plastics — environmental health)।","note":"UPSC में hormones को lifestyle disease policy से जोड़ते हैं।"}$j$),
    (913, 'upsc_civil', 'hormones-upsc-formula', 'formula', 2, 'हार्मोन framework',
     $j${"formula":"Insulin: glucose↓ · Glucagon: glucose↑ · Thyroxine: metabolism · Cortisol: stress","explanation":"Diabetes: fasting >126 mg/dL, HbA1c >6.5% · Hypothyroid: TSH ↑, T4 ↓"}$j$),
    (913, 'upsc_civil', 'hormones-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Diabetes India epidemic क्यों?","solution":"Lifestyle (diet, sedentary), genetics, urbanisation, obesity — 100M+ diabetic","answer":"Lifestyle + genetic"}$j$),
    (913, 'upsc_civil', 'hormones-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Diabetes fasting blood sugar?","options":[">100",">126",">200","Any"],"answer":1,"explanation":">126 mg/dL"},{"q":"Cortisol type?","options":["Protein","Steroid","Amine","Lipid"],"answer":1,"explanation":"Steroid hormone"}]}$j$),

    (914, 'upsc_civil', 'skeletal-upsc-concept', 'concept', 1, 'कंकाल — UPSC CSE',
     $j${"text":"Skeletal system: 206 bones, axial (80) + appendicular (126)। Joints, muscles. Bone diseases: osteoporosis (Ca/vit D deficiency), arthritis, rickets। Women at higher risk (postmenopausal)। Calcium + vitamin D + exercise. Government: anaemia/calcium supplementation।","note":"UPSC में skeletal health को nutrition/women health से जोड़ते हैं।"}$j$),
    (914, 'upsc_civil', 'skeletal-upsc-formula', 'formula', 2, 'कंकाल framework',
     $j${"formula":"206 bones (adult) · Axial=80, Appendicular=126 · Ca requirement: 1000 mg/day (adult)","explanation":"Osteoporosis: bone density ↓ (DEXA T-score < -2.5) · Risk: women > men, age >50"}$j$),
    (914, 'upsc_civil', 'skeletal-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Osteoporosis India में क्यों बढ़ रहा है?","solution":"Vitamin D deficiency (indoor lifestyle, pollution), low calcium intake, aging population","answer":"Vit D deficiency + aging"}$j$),
    (914, 'upsc_civil', 'skeletal-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Osteoporosis cause?","options":["Ca excess","Ca deficiency","Protein excess","Fat excess"],"answer":1,"explanation":"Ca + Vit D deficiency"},{"q":"Adult bones?","options":["106","206","306","406"],"answer":1,"explanation":"206"}]}$j$),

    (915, 'upsc_civil', 'repro-upsc-concept', 'concept', 1, 'जनन — UPSC CSE',
     $j${"text":"Reproduction: male + female reproductive systems, menstrual cycle, fertilization, pregnancy। Population policy: TFR (Total Fertility Rate) 2.0 (India achieved 2021), family planning, sex ratio (950/1000 in India)। Government schemes: Janani Suraksha Yojana (JSY), Pradhan Mantri Matru Vandana Yojana (PMMVY), Beti Bachao Beti Padhao।","note":"UPSC में reproduction को population/demographic policy से जोड़ते हैं।"}$j$),
    (915, 'upsc_civil', 'repro-upsc-formula', 'formula', 2, 'जनन framework',
     $j${"formula":"TFR India: 2.0 (2021, below replacement 2.1) · Sex ratio: 943 (Census 2011)","explanation":"Menstrual cycle: 28 days · Ovulation: day 14 · JSY: institutional delivery cash assistance"}$j$),
    (915, 'upsc_civil', 'repro-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Beti Bachao Beti Padhao के objectives?","solution":"Sex-selective abortion ↓, girl child education ↑, nutrition, safety","answer":"Girl child survival + education"}$j$),
    (915, 'upsc_civil', 'repro-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"India TFR (2021)?","options":["1.5","2.0","2.5","3.0"],"answer":1,"explanation":"2.0 (below replacement)"},{"q":"JSY target?","options":["Education","Institutional delivery","Nutrition","Water"],"answer":1,"explanation":"Institutional delivery for safe motherhood"}]}$j$),

    (916, 'upsc_civil', 'genetics-upsc-concept', 'concept', 1, 'आनुवंशिकी — UPSC CSE',
     $j${"text":"Genetics: DNA, genes, chromosomes, heredity। Genetic disorders: sickle cell (SC/ST high), thalassemia, cystic fibrosis, hemophilia। Genetic testing, gene therapy (CRISPR)। Ethics: genetic discrimination, designer babies, GM crops (Bt cotton)। National guidelines: ICMR genetic testing, GM regulation (GEAC)।","note":"UPSC में genetics को ethics और governance से जोड़ते हैं।"}$j$),
    (916, 'upsc_civil', 'genetics-upsc-formula', 'formula', 2, 'आनुवंशिकी framework',
     $j${"formula":"DNA: A=T (2 H-bonds), G≡C (3) · Human: 46 chromosomes · Down: trisomy 21 · Sickle cell: HbS (autosomal recessive)","explanation":"Sickle cell: high in tribal MP, Chhattisgarh, Odisha · Thalassemia: high in some communities"}$j$),
    (916, 'upsc_civil', 'genetics-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Sickle cell anemia high in tribal India क्यों?","solution":"Malaria endemic region → heterozygote advantage (HbAS protects against malaria)","answer":"Malaria selection (heterozygote advantage)"}$j$),
    (916, 'upsc_civil', 'genetics-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Down syndrome?","options":["Trisomy 21","Monosomy","Deletion","Duplication"],"answer":0,"explanation":"Trisomy 21"},{"q":"Sickle cell type?","options":["Autosomal dominant","Autosomal recessive","X-linked","Y-linked"],"answer":1,"explanation":"Autosomal recessive"}]}$j$),

    (917, 'upsc_civil', 'evol-upsc-concept', 'concept', 1, 'विकास — UPSC CSE',
     $j${"text":"Evolution: Darwin (natural selection), Lamarck (disproved)। Evidence: fossils, homologous/analogous organs, molecular clocks। Human evolution: Homo habilis → erectus → neanderthalensis → sapiens। Antibiotic resistance (evolution in real-time)। Evolution education (debates)।","note":"UPSC में evolution को science literacy और education से जोड़ते हैं।"}$j$),
    (917, 'upsc_civil', 'evol-upsc-formula', 'formula', 2, 'विकास framework',
     $j${"formula":"Darwin (1859): natural selection · Hardy-Weinberg: p² + 2pq + q² = 1 · Antibiotic resistance = natural selection","explanation":"Homologous: same origin, different function · Analogous: different origin, same function"}$j$),
    (917, 'upsc_civil', 'evol-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Antibiotic resistance AMR में evolution का role?","solution":"Random mutations + antibiotic selection → resistant bacteria survive → spread (Lamarck's acquired concept नहीं)","answer":"Natural selection (survival of resistant)"}$j$),
    (917, 'upsc_civil', 'evol-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Natural selection?","options":["Lamarck","Darwin","Mendel","Pasteur"],"answer":1,"explanation":"Darwin"},{"q":"AMR cause?","options":["Overuse of antibiotics","Natural selection","Both","None"],"answer":2,"explanation":"Overuse + selection (both)"}]}$j$),

    (918, 'upsc_civil', 'disease-upsc-concept', 'concept', 1, 'रोग-प्रतिरक्षा — UPSC CSE',
     $j${"text":"Diseases: communicable (TB, malaria, HIV, dengue) vs non-communicable (diabetes, cancer, CVD)। India's burden: TB highest globally, NCD 63% deaths. Immunity, vaccines। Public health: NHM, Ayushman Bharat (PM-JAY), Mission Indradhanush. Antimicrobial resistance (AMR) — global health emergency। WHO, GAVI, CEPI।","note":"UPSC में disease को health policy और global governance से जोड़ते हैं।"}$j$),
    (918, 'upsc_civil', 'disease-upsc-formula', 'formula', 2, 'रोग framework',
     $j${"formula":"Malaria: Plasmodium (Anopheles) · TB: Mycobacterium (airborne) · HIV: retrovirus (CD4 cells) · Dengue: virus (Aedes)","explanation":"TB incidence India: ~200/100,000 (highest globally) · PM-JAY: 50 crore beneficiaries"}$j$),
    (918, 'upsc_civil', 'disease-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"India TB elimination target?","solution":"Eliminate TB by 2025 (5 years ahead of SDG 2030) — NTEP, Ni-kshay, nutritional support","answer":"2025 (5 years before SDG)"}$j$),
    (918, 'upsc_civil', 'disease-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"TB target India?","options":["2025","2030","2035","2040"],"answer":0,"explanation":"2025"},{"q":"AIDS target cells?","options":["RBC","CD4 T-cells","B cells","Platelets"],"answer":1,"explanation":"CD4 helper T-cells"}]}$j$),

    (920, 'upsc_civil', 'env-upsc-concept', 'concept', 1, 'पर्यावरण — UPSC CSE',
     $j${"text":"Ecosystem, biodiversity, climate change। India: net zero 2070, NDC (renewable 500 GW, emissions intensity ↓45%)। Climate finance, Loss and Damage fund। International: Paris Agreement, COP, IPCC। National: NAPCC, Green India Mission, CAMPA, FAME, Mission LiFE। Pollution: NCAP, Namami Gange, Plastic Waste Rules।","note":"UPSC में environment को international climate diplomacy से जोड़ते हैं।"}$j$),
    (920, 'upsc_civil', 'env-upsc-formula', 'formula', 2, 'पर्यावरण framework',
     $j${"formula":"India NDC: 500 GW renewable by 2030, emissions intensity ↓45% (2005 base), net zero 2070","explanation":"10% energy law (Lindeman) · Biodiversity hotspots: 4 in India · Mission LiFE (lifestyle for environment)"}$j$),
    (920, 'upsc_civil', 'env-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Mission LiFE का approach?","solution":"Lifestyle changes for sustainability (pro-planet behavior) — demand-side climate action","answer":"Demand-side (lifestyle) climate action"}$j$),
    (920, 'upsc_civil', 'env-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"India net zero target?","options":["2050","2060","2070","2100"],"answer":2,"explanation":"2070"},{"q":"Paris Agreement year?","options":["2012","2015","2018","2021"],"answer":1,"explanation":"2015 (COP21)"}]}$j$),

    -- ═══ CLASS 6-8 MATHS (1-3) ═══
    (1, 'class_6_8', 'pct-68-concept', 'concept', 1, 'प्रतिशत — Class 6-8',
     $j${"text":"प्रतिशत का मतलब है 'प्रति सौ में'। 25% का मतलब है 100 में से 25। आधा = 50%, चौथाई = 25%, तीन-चौथाई = 75%। प्रतिशत को भिन्न में बदलने के लिए 100 से भाग दो। भिन्न को प्रतिशत में बदलने के लिए 100 से गुणा करो।","note":"50% = 1/2, 25% = 1/4, 20% = 1/5, 10% = 1/10 — ये याद रखो।"}$j$),
    (1, 'class_6_8', 'pct-68-formula', 'formula', 2, 'प्रतिशत सूत्र',
     $j${"formula":"% = (भाग / पूरा) × 100","explanation":"25% = 25/100 = 1/4 · 50% = 50/100 = 1/2 · भिन्न → %: × 100"}$j$),
    (1, 'class_6_8', 'pct-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"100 में से 40 अंक मिले। प्रतिशत कितना?","solution":"(40/100) × 100","answer":"40%"}$j$),
    (1, 'class_6_8', 'pct-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"50% को भिन्न में बदलो","options":["1/4","1/2","1/3","1/5"],"answer":1,"explanation":"50/100 = 1/2"},{"q":"100 का 20% कितना?","options":["10","20","25","30"],"answer":1,"explanation":"100 × 20/100 = 20"}]}$j$),

    (2, 'class_6_8', 'pl-68-concept', 'concept', 1, 'लाभ-हानि — Class 6-8',
     $j${"text":"जब हम कोई चीज़ खरीदते हैं, उसे CP (लागत मूल्य) कहते हैं। जब बेचते हैं, उसे SP (विक्रय मूल्य) कहते हैं। अगर SP > CP, तो लाभ। अगर SP < CP, तो हानि।","note":"लाभ = SP - CP, हानि = CP - SP"}$j$),
    (2, 'class_6_8', 'pl-68-formula', 'formula', 2, 'लाभ-हानि सूत्र',
     $j${"formula":"लाभ = SP - CP · हानि = CP - SP","explanation":"₹100 में खरीदा, ₹120 में बेचा → ₹20 लाभ"}$j$),
    (2, 'class_6_8', 'pl-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"CP = ₹100, SP = ₹120। लाभ?","solution":"120 - 100","answer":"₹20"}$j$),
    (2, 'class_6_8', 'pl-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"CP=₹50, SP=₹60। लाभ?","options":["₹5","₹10","₹15","₹20"],"answer":1,"explanation":"60-50 = 10"},{"q":"CP=₹80, SP=₹60। हानि?","options":["₹10","₹20","₹30","₹40"],"answer":1,"explanation":"80-60 = 20"}]}$j$),

    (3, 'class_6_8', 'si-68-concept', 'concept', 1, 'साधारण ब्याज — Class 6-8',
     $j${"text":"जब हम बैंक में पैसा जमा करते हैं, तो बैंक हमें ब्याज देता है। जब हम बैंक से पैसा उधार लेते हैं, तो हमें बैंक को ब्याज देना पड़ता है। साधारण ब्याज (SI) = मूलधन × दर × समय / 100।","note":"P = मूलधन, R = दर (%), T = समय (साल)"}$j$),
    (3, 'class_6_8', 'si-68-formula', 'formula', 2, 'साधारण ब्याज सूत्र',
     $j${"formula":"SI = (P × R × T) / 100","explanation":"₹1000, 10%, 2 साल → SI = 1000×10×2/100 = ₹200"}$j$),
    (3, 'class_6_8', 'si-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"₹500 पर 10% ब्याज, 1 साल। SI?","solution":"500 × 10 × 1 / 100","answer":"₹50"}$j$),
    (3, 'class_6_8', 'si-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"₹1000, 5%, 1 साल SI?","options":["₹25","₹50","₹75","₹100"],"answer":1,"explanation":"1000×5×1/100 = 50"},{"q":"SI का सूत्र?","options":["PRT","PRT/100","P+R+T","P/RT"],"answer":1,"explanation":"SI = PRT/100"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[],
  case when s.level_id = 'class_6_8' then array['class_6','class_7','class_8']::text[] else '{}'::text[] end,
  case when s.chapter_id < 20 then 'maths' 
       when s.chapter_id = 920 then 'environment' 
       else 'general-science' end,
  case when s.level_id = 'class_6_8' then 'easy' else 'hard' end,
  md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select level_id, count(*) from mtb.atoms 
-- where chapter_id in (904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,920,1,2,3) 
--   and status='published' and not archived 
--   and level_id in ('upsc_civil','class_6_8')
-- group by level_id;
-- Expected: upsc_civil=68 (17 chapters × 4), class_6_8=12 (3 chapters × 4)

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: ~2780 + 80 = ~2860
