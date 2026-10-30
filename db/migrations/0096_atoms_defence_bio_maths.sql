with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ DEFENCE BIO (911-918, 920) ═══
    (911, 'govt_defence', 'exc-def-concept', 'concept', 1, 'उत्सर्जन — NDA/CDS',
     $j${"text":"Defence excretion: kidney function under stress (dehydration → concentrated urine), field water discipline, heat casualties (sweat → water+salt loss), kidney stones risk (dehydration)। GFR ~125 mL/min. ADH increases with dehydration.","note":"Defence में dehydration और kidney function ज़रूरी हैं।"}$j$),
    (911, 'govt_defence', 'exc-def-formula', 'formula', 2, 'उत्सर्जन तथ्य',
     $j${"formula":"GFR ≈ 125 mL/min · Urine ≈ 1.5 L/day (normal) · Sweat: water + NaCl + urea","explanation":"Dehydration → ADH ↑ → concentrated urine · Heat casualty: >2% body weight water loss"}$j$),
    (911, 'govt_defence', 'exc-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"70kg soldier, 3L sweat loss। %?","solution":"3/70 × 100","answer":"≈4.3% (serious dehydration)"}$j$),
    (911, 'govt_defence', 'exc-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Dehydration में ADH?","options":["↓","↑","Same","0"],"answer":1,"explanation":"ADH ↑ → water reabsorption ↑"},{"q":"GFR normal?","options":["25 mL/min","75 mL/min","125 mL/min","250 mL/min"],"answer":2,"explanation":"125 mL/min"}]}$j$),

    (912, 'govt_defence', 'nerve-def-concept', 'concept', 1, 'तंत्रिका तंत्र — NDA/CDS',
     $j${"text":"Defence neuro: blast injury (TBI — traumatic brain injury), nerve agents (organophosphates inhibit AChE → ACh buildup → paralysis), flash-bang (sensory overload), PTSD। Action potential -70mV → +30mV. Synapse: ACh, dopamine, serotonin।","note":"Defence में TBI, nerve agents, और PTSD ज़रूरी हैं।"}$j$),
    (912, 'govt_defence', 'nerve-def-formula', 'formula', 2, 'तंत्रिका तथ्य',
     $j${"formula":"Resting: -70mV · Action: +30mV · AChE inhibited → ACh ↑ (nerve agent poisoning)","explanation":"Antidote for nerve agent: atropine + pralidoxime (2-PAM) · TBI: blast wave → brain injury"}$j$),
    (912, 'govt_defence', 'nerve-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Nerve agent का effect?","solution":"AChE inhibit → ACh ↑ → muscle paralysis","answer":"Cholinergic crisis (SLUDGE)"}$j$),
    (912, 'govt_defence', 'nerve-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Nerve agent affects?","options":["DNA","AChE","RBC","Kidney"],"answer":1,"explanation":"Acetylcholinesterase inhibitor"},{"q":"Antidote for nerve agent?","options":["Morphine","Atropine + pralidoxime","Insulin","Antibiotics"],"answer":1,"explanation":"Atropine (ACh receptor block) + 2-PAM (reactivates AChE)"}]}$j$),

    (913, 'govt_defence', 'hormones-def-concept', 'concept', 1, 'हार्मोन — NDA/CDS',
     $j${"text":"Defence endocrinology: stress hormones (cortisol, adrenaline), anabolic steroids (muscle mass — banned in sports/military), altitude sickness (erythropoietin ↑), combat fatigue (cortisol)। Adrenaline: fight-or-flight. Cortisol: chronic stress. Insulin: glucose control.","note":"Defence में stress hormones और performance enhancement ज़रूरी हैं।"}$j$),
    (913, 'govt_defence', 'hormones-def-formula', 'formula', 2, 'हार्मोन तथ्य',
     $j${"formula":"Adrenaline: HR ↑, BP ↑, glucose ↑ (fight/flight) · Cortisol: chronic stress → immunity ↓ · Erythropoietin: RBC ↑ (altitude)","explanation":"Anabolic steroids: testosterone-based (banned by WADA) · Insulin: glucose ↓"}$j$),
    (913, 'govt_defence', 'hormones-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"High altitude पर erythropoietin?","solution":"Low O₂ → EPO ↑ → RBC ↑ (acclimatization)","answer":"EPO ↑ → RBC ↑"}$j$),
    (913, 'govt_defence', 'hormones-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Fight/flight hormone?","options":["Insulin","Adrenaline","Cortisol","Thyroxine"],"answer":1,"explanation":"Adrenaline (immediate)"},{"q":"Stress hormone?","options":["Insulin","Cortisol","Glucagon","ADH"],"answer":1,"explanation":"Cortisol (chronic stress)"}]}$j$),

    (914, 'govt_defence', 'skeletal-def-concept', 'concept', 1, 'कंकाल — NDA/CDS',
     $j${"text":"Defence skeletal: combat injuries (bone fracture, blast trauma), body armor design (chest/abdomen protection), parachute landing (leg bone stress), G-forces (spine compression)। 206 bones. Long bones: femur (strongest), tibia. Joints: ball-socket (hip), hinge (knee)।","note":"Defence में fracture, armor, और G-force ज़रूरी हैं।"}$j$),
    (914, 'govt_defence', 'skeletal-def-formula', 'formula', 2, 'कंकाल तथ्य',
     $j${"formula":"Femur: strongest bone (yield ~170 MPa) · G-force limit: ~9G (with suit) · Bone healing: 6-12 weeks","explanation":"Parachute landing: bend knees (absorb) · Body armor: chest/back ceramic plates"}$j$),
    (914, 'govt_defence', 'skeletal-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"9G at 70kg effective weight?","solution":"9 × 70 × 9.8 N","answer":"≈6174 N (9× body weight)"}$j$),
    (914, 'govt_defence', 'skeletal-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Strongest bone?","options":["Skull","Femur","Vertebra","Rib"],"answer":1,"explanation":"Femur (thigh bone)"},{"q":"G-force tolerance?","options":["3G","6G","9G","15G"],"answer":2,"explanation":"~9G with G-suit (fighter pilots)"}]}$j$),

    (915, 'govt_defence', 'repro-def-concept', 'concept', 1, 'जनन — NDA/CDS',
     $j${"text":"Defence reproductive: combat stress → reproductive dysfunction, chemical/radiation exposure → infertility, biological warfare agents (smallpox, anthrax)। Basic: spermatogenesis (testes), oogenesis (ovary), fertilization, menstrual cycle। DNA damage from radiation affects germ cells।","note":"Defence में radiation effects on reproduction और biowarfare ज़रूरी हैं।"}$j$),
    (915, 'govt_defence', 'repro-def-formula', 'formula', 2, 'जनन तथ्य',
     $j${"formula":"Menstrual cycle: 28 days · Ovulation: day 14 · Fertilization: ampulla","explanation":"Radiation: affects spermatogonia (sperm count ↓) · Smallpox: eradicated 1980 (biowarfare concern)"}$j$),
    (915, 'govt_defence', 'repro-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Radiation 1 Gy effect on sperm?","solution":"Sperm count ↓ (temporary), recovers 6-12 months","answer":"Temporary sterility (usually reversible)"}$j$),
    (915, 'govt_defence', 'repro-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Ovulation day?","options":["Day 7","Day 14","Day 21","Day 28"],"answer":1,"explanation":"Day 14 (LH surge)"},{"q":"Smallpox status?","options":["Endemic","Eradicated 1980","Common","New"],"answer":1,"explanation":"Eradicated 1980"}]}$j$),

    (916, 'govt_defence', 'genetics-def-concept', 'concept', 1, 'आनुवंशिकी — NDA/CDS',
     $j${"text":"Defence genetics: biological warfare (anthrax spores, smallpox virus), radiation-induced mutations, DNA fingerprinting (forensics — crime/military ID), genetic screening for soldiers। DNA double helix (Watson-Crick), A=T, G≡C. Mutations can be point/insertion/deletion।","note":"Defence में biowarfare, forensics, और mutations ज़रूरी हैं।"}$j$),
    (916, 'govt_defence', 'genetics-def-formula', 'formula', 2, 'आनुवंशिकी तथ्य',
     $j${"formula":"DNA: double helix, A=T (2 H-bonds), G≡C (3 H-bonds) · Codon = 3 bases = 1 AA · Human chromosomes = 46","explanation":"DNA fingerprint: ~99.9% same, 0.1% unique · Radiation: 1 Sv → ~5% mutation rate increase"}$j$),
    (916, 'govt_defence', 'genetics-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"DNA match probability (2 unrelated)?","solution":"~1 in 10⁹ (with full profile)","answer":"1 in billion"}$j$),
    (916, 'govt_defence', 'genetics-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"DNA H-bonds A=T?","options":["1","2","3","4"],"answer":1,"explanation":"A=T = 2 H-bonds"},{"q":"DNA fingerprint uniqueness?","options":["100%","99.9%","~0.1% unique","50%"],"answer":2,"explanation":"~0.1% unique (used for ID)"}]}$j$),

    (917, 'govt_defence', 'evol-def-concept', 'concept', 1, 'विकास — NDA/CDS',
     $j${"text":"Defence evolution: biological warfare evolution (pathogens adapt), antibiotic resistance (evolution in real-time), chemical/biological arms race। Darwin natural selection। Homologous vs analogous organs. Antibiotic resistance is natural selection — bacteria evolve fast (hours-days)।","note":"Defence में biowarfare evolution और antibiotic resistance ज़रूरी हैं।"}$j$),
    (917, 'govt_defence', 'evol-def-formula', 'formula', 2, 'विकास तथ्य',
     $j${"formula":"Natural selection: fittest survive · Antibiotic resistance: mutations + selection in hours-days","explanation":"Homologous: same structure (forelimb man/whale) · Analogous: same function (bird/insect wing) · MRSA: methicillin-resistant S. aureus"}$j$),
    (917, 'govt_defence', 'evol-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Antibiotic resistance evolves कितनी जल्दी?","solution":"Bacteria double every 20 min → resistance in days","answer":"Days to weeks (in human body)"}$j$),
    (917, 'govt_defence', 'evol-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Natural selection?","options":["Lamarck","Darwin","Mendel","Pasteur"],"answer":1,"explanation":"Darwin (1859)"},{"q":"MRSA क्या है?","options":["Virus","Antibiotic-resistant bacteria","Fungus","Protozoa"],"answer":1,"explanation":"Methicillin-resistant Staphylococcus aureus"}]}$j$),

    (918, 'govt_defence', 'disease-def-concept', 'concept', 1, 'रोग-प्रतिरक्षा — NDA/CDS',
     $j${"text":"Defence medicine: biological warfare agents (Category A: anthrax, smallpox, plague, botulism, tularemia), vaccines (anthrax, smallpox), quarantine, immunity (innate + acquired)। Infection → immune response → antibodies. Antibiotics for bacteria, antivirals for viruses।","note":"Defence में biowarfare agents, vaccines, और immunity ज़रूरी हैं।"}$j$),
    (918, 'govt_defence', 'disease-def-formula', 'formula', 2, 'रोग तथ्य',
     $j${"formula":"Category A biowarfare: anthrax (bacteria), smallpox (virus), plague (bacteria), botulism (toxin), tularemia (bacteria)","explanation":"Innate: skin, mucus, phagocytes · Acquired: B/T cells, memory · Vaccine: active immunity (weakened/killed pathogen)"}$j$),
    (918, 'govt_defence', 'disease-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Anthrax vaccine type?","solution":"Subunit (PA antigen)","answer":"Subunit vaccine (protective antigen)"}$j$),
    (918, 'govt_defence', 'disease-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Category A biowarfare?","options":["HIV","Anthrax","Common cold","Flu"],"answer":1,"explanation":"Anthrax (Bacillus anthracis, spores)"},{"q":"Smallpox vaccine?","options":["Inactivated","Live attenuated","Subunit","mRNA"],"answer":1,"explanation":"Live attenuated (vaccinia virus)"}]}$j$),

    (920, 'govt_defence', 'env-def-concept', 'concept', 1, 'पर्यावरण — NDA/CDS',
     $j${"text":"Defence environment: terrain analysis (desert, jungle, mountain, arctic), camouflage (natural), pollution (military — fuel, chemicals, noise), depleted uranium contamination, nuclear test legacy, environmental security। Renewable energy in military (solar for remote bases)।","note":"Defence में terrain analysis, camouflage, और environmental security ज़रूरी हैं।"}$j$),
    (920, 'govt_defence', 'env-def-formula', 'formula', 2, 'पर्यावरण तथ्य',
     $j${"formula":"Terrain: desert (heat, water), jungle (humidity, disease), mountain (altitude, cold), arctic (extreme cold)","explanation":"Camouflage: matching terrain colors · Nuclear test legacy: soil contamination (Pu, U)"}$j$),
    (920, 'govt_defence', 'env-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Desert में water need/day?","solution":"~6-8 L/day (hot, active)","answer":"6-8 L/day minimum"}$j$),
    (920, 'govt_defence', 'env-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Desert में camouflage color?","options":["Green","Tan/brown","Blue","White"],"answer":1,"explanation":"Tan/brown matches desert"},{"q":"Arctic main challenge?","options":["Heat","Cold","Rain","Wind"],"answer":1,"explanation":"Extreme cold (frostbite risk)"}]}$j$),

    -- ═══ DEFENCE MATHS (1-11) ═══
    (1, 'govt_defence', 'pct-def-concept', 'concept', 1, 'प्रतिशत — NDA/CDS',
     $j${"text":"Percentage basics: conversion, successive changes, applications (ammunition accuracy, hit rate, fuel efficiency)। Successive: net = a+b+ab/100. Reverse: if price ↑20%, consumption ↓16.67% to keep same. Target hit % calculation.","note":"Defence में accuracy %, fuel efficiency, और successive changes ज़रूरी हैं।"}$j$),
    (1, 'govt_defence', 'pct-def-formula', 'formula', 2, 'प्रतिशत सूत्र',
     $j${"formula":"% = (part/whole)×100 · Successive: net = a+b+ab/100 · Reverse: decrease = (a/(100+a))×100","explanation":"+25% → reverse -20% · Accuracy: hits/shots × 100"}$j$),
    (1, 'govt_defence', 'pct-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"100 shots, 75 hits। Accuracy?","solution":"75/100 × 100","answer":"75%"}$j$),
    (1, 'govt_defence', 'pct-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Successive +10%, +20%?","options":["30%","32%","34%","28%"],"answer":1,"explanation":"10+20+200/100 = 32%"},{"q":"Hit rate 80%, 500 shots। Hits?","options":["350","400","450","500"],"answer":1,"explanation":"500 × 0.8 = 400"}]}$j$),

    (2, 'govt_defence', 'pl-def-concept', 'concept', 1, 'लाभ-हानि — NDA/CDS',
     $j${"text":"Profit/Loss: military procurement cost analysis। CP, SP, discount, successive discounts। Bulk purchase → discount → profit। False weight (illegal trade)। Effective price = MP(1-D).","note":"Defence में procurement cost और discounts ज़रूरी हैं।"}$j$),
    (2, 'govt_defence', 'pl-def-formula', 'formula', 2, 'लाभ-हानि सूत्र',
     $j${"formula":"Profit% = (SP-CP)/CP×100 · Effective SP = MP(1-D/100) · Successive: net = a+b-ab/100","explanation":"Bulk discount 10% + 20% = net 28% off"}$j$),
    (2, 'govt_defence', 'pl-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"MP ₹1000, discount 15%। SP?","solution":"1000 × 0.85","answer":"₹850"}$j$),
    (2, 'govt_defence', 'pl-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Successive 10%, 20% discounts?","options":["28%","30%","25%","32%"],"answer":0,"explanation":"10+20-200/100 = 28%"},{"q":"CP ₹500, SP ₹600। Profit%?","options":["15%","20%","25%","30%"],"answer":1,"explanation":"100/500 × 100 = 20%"}]}$j$),

    (3, 'govt_defence', 'si-def-concept', 'concept', 1, 'ब्याज — NDA/CDS',
     $j${"text":"SI = PRT/100. CI = P[(1+R/100)^n - 1]. Defence: military loans, equipment depreciation। Rule of 72: doubling time = 72/R. CI-SI difference: 2 years = P(R/100)².","note":"Defence में loans और depreciation ज़रूरी हैं।"}$j$),
    (3, 'govt_defence', 'si-def-formula', 'formula', 2, 'ब्याज सूत्र',
     $j${"formula":"SI = PRT/100 · CI = P[(1+R/100)ⁿ-1] · CI-SI (2y) = P(R/100)²","explanation":"Rule 72: t_double = 72/R · Equipment depreciation: similar to CI (reducing value)"}$j$),
    (3, 'govt_defence', 'si-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"₹20000, 8%, 3y SI?","solution":"20000×8×3/100","answer":"₹4800"}$j$),
    (3, 'govt_defence', 'si-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Rule 72: R=9%, double time?","options":["6y","8y","9y","12y"],"answer":1,"explanation":"72/9 = 8y"},{"q":"₹10k, 10%, 2y CI-SI?","options":["₹50","₹100","₹150","₹200"],"answer":1,"explanation":"10000×0.01 = 100"}]}$j$),

    (4, 'govt_defence', 'ratio-def-concept', 'concept', 1, 'अनुपात — NDA/CDS',
     $j${"text":"Ratio/proportion, direct/inverse variation. Defence: force ratios, fuel mixture, troop deployment, ammunition split। Partnership: profit ∝ investment × time. Alligation for mixtures.","note":"Defence में force ratio, fuel mix, और troop deployment ज़रूरी हैं।"}$j$),
    (4, 'govt_defence', 'ratio-def-formula', 'formula', 2, 'अनुपात सूत्र',
     $j${"formula":"a:b divide N → shares = Na/(a+b), Nb/(a+b) · Partnership: profit ∝ inv × time","explanation":"a:b::c:d → ad=bc · Fuel mix 1:50 (oil:petrol)"}$j$),
    (4, 'govt_defence', 'ratio-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"600 troops 2:3:5 में। Largest?","solution":"Total parts = 10। Largest = 600×5/10","answer":"300 troops"}$j$),
    (4, 'govt_defence', 'ratio-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Fuel mix 1:50 में 5L oil के लिए petrol?","options":["100L","150L","200L","250L"],"answer":3,"explanation":"1:50 → 5×50 = 250L"},{"q":"A:B=2:3, B:C=4:5। A:C?","options":["8:15","2:5","3:4","5:8"],"answer":0,"explanation":"A:B:C=8:12:15 → A:C=8:15"}]}$j$),

    (5, 'govt_defence', 'avg-def-concept', 'concept', 1, 'औसत — NDA/CDS',
     $j${"text":"Average: rounds fired, fuel consumption, march speed। Weighted average. Average speed (equal D) = HM. Batch average with different groups. AM ≥ GM ≥ HM.","note":"Defence में fuel average, march speed, और weighted average ज़रूरी हैं।"}$j$),
    (5, 'govt_defence', 'avg-def-formula', 'formula', 2, 'औसत सूत्र',
     $j${"formula":"Avg = Σx/n · Weighted = (Σwᵢxᵢ)/(Σwᵢ) · Avg speed (equal D) = 2v₁v₂/(v₁+v₂)","explanation":"Sum = Avg × Count · First n naturals avg = (n+1)/2"}$j$),
    (5, 'govt_defence', 'avg-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"4 tanks: 40, 45, 50, 55 km/h। Avg speed?","solution":"(40+45+50+55)/4 = 190/4","answer":"47.5 km/h"}$j$),
    (5, 'govt_defence', 'avg-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"10 rounds avg 85% accuracy, 20 rounds 90%। Combined?","solution":"(10×85 + 20×90)/30 = 2650/30","options":["86%","87.7%","88.3%","90%"],"answer":2,"explanation":"(850+1800)/30 = 88.3%"},{"q":"Avg speed equal D 60, 40?","options":["50","48","52","55"],"answer":1,"explanation":"2×60×40/100 = 48"}]}$j$),

    (6, 'govt_defence', 'age-def-concept', 'concept', 1, 'आयु — NDA/CDS',
     $j${"text":"Age problems: recruitment age limits, retirement age, seniority calculations। Basic: present x, past x-n, future x+n. Linear equations with 1-2 variables। Age ratio across time।","note":"Defence में recruitment age limits और seniority ज़रूरी हैं।"}$j$),
    (6, 'govt_defence', 'age-def-formula', 'formula', 2, 'आयु सूत्र',
     $j${"formula":"Present = x · Past (n years) = x-n · Future (n years) = x+n · Ratio condition: (x+n)/(y+n) = p/q","explanation":"If 'a times now, b times later': a·x + n = b(x+n)"}$j$),
    (6, 'govt_defence', 'age-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Recruit 20, retirement 60। Service years?","solution":"60 - 20","answer":"40 years"}$j$),
    (6, 'govt_defence', 'age-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"A 30, B 15। 5 साल में age ratio?","solution":"(30+5):(15+5) = 35:20 = 7:4","options":["2:1","7:4","3:2","5:4"],"answer":1,"explanation":"35:20 = 7:4"},{"q":"NDA entry age group?","options":["16.5-19.5","18-21","20-24","25-30"],"answer":0,"explanation":"16.5-19.5 years"}]}$j$),

    (7, 'govt_defence', 'mix-def-concept', 'concept', 1, 'मिश्रण — NDA/CDS',
     $j${"text":"Mixture: fuel blending, propellant mixing, food ration allocation. Alligation: cheap:dear = (dear-mean):(mean-cheap). Mixture concentration, replacement problems. Gasoline octane blending.","note":"Defence में fuel blending और propellant mix ज़रूरी हैं।"}$j$),
    (7, 'govt_defence', 'mix-def-formula', 'formula', 2, 'मिश्रण सूत्र',
     $j${"formula":"cheap:dear = (dear-mean):(mean-cheap) · Mean = (q₁p₁+q₂p₂)/(q₁+q₂) · Replacement: final = initial × (1-r/V)ⁿ","explanation":"Octane blending: 87 + 92 → 89 (ratio depends)"}$j$),
    (7, 'govt_defence', 'mix-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Petrol 87 और 92 octane मिलाएँ → 89। Ratio?","solution":"(92-89):(89-87) = 3:2","answer":"3:2 (87:92)"}$j$),
    (7, 'govt_defence', 'mix-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"₹40, ₹60 → mean ₹45। Ratio?","options":["3:1","1:3","2:3","3:2"],"answer":0,"explanation":"(60-45):(45-40) = 15:5 = 3:1"},{"q":"Milk 80% + water 20% (20L)। Water?","options":["2L","3L","4L","5L"],"answer":2,"explanation":"20% of 20 = 4L"}]}$j$),

    (8, 'govt_defence', 'tw-def-concept', 'concept', 1, 'समय-कार्य — NDA/CDS',
     $j${"text":"Work: construction (bunkers, bridges), equipment maintenance, march planning. Combined rate 1/x + 1/y = 1/t. Efficiency. Wages ∝ work. Alternate work, pipes (fuel filling)।","note":"Defence में construction, maintenance, और march planning ज़रूरी हैं।"}$j$),
    (8, 'govt_defence', 'tw-def-formula', 'formula', 2, 'कार्य सूत्र',
     $j${"formula":"1/x + 1/y = 1/t → t = xy/(x+y) · Efficiency ∝ 1/time · Wages ∝ work done","explanation":"A 12d, B 18d → together = 216/30 = 7.2d"}$j$),
    (8, 'govt_defence', 'tw-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"10 soldiers bunker 5 days, 5 more soldiers कितने days?","solution":"Rate: 10 soldiers = 5d → 1 soldier = 50 man-days। 15 soldiers = 50/15 = 10/3","answer":"≈3.33 days"}$j$),
    (8, 'govt_defence', 'tw-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"A 8d, B 12d। Together?","options":["4.8d","5d","6d","4d"],"answer":0,"explanation":"96/20 = 4.8d"},{"q":"Pipes: fill 4h, drain 6h। Both?","options":["8h","10h","12h","14h"],"answer":2,"explanation":"1/4-1/6 = 1/12 → 12h"}]}$j$),

    (9, 'govt_defence', 'tsd-def-concept', 'concept', 1, 'चाल-दूरी — NDA/CDS',
     $j${"text":"Speed: vehicle speed, patrol distance, aircraft speed. Average speed (equal D) = 2v₁v₂/(v₁+v₂). Relative velocity. Boat in stream. Train crossing. Missile speed (Mach)।","note":"Defence में vehicle, aircraft, और missile speed ज़रूरी हैं।"}$j$),
    (9, 'govt_defence', 'tsd-def-formula', 'formula', 2, 'चाल सूत्र',
     $j${"formula":"v = d/t · Avg speed (equal D) = 2v₁v₂/(v₁+v₂) · Relative = |v₁-v₂| (same), v₁+v₂ (opp)","explanation":"1 km/h = 5/18 m/s · Mach 1 = 340 m/s · Train platform: (L+P)/v"}$j$),
    (9, 'govt_defence', 'tsd-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Patrol 120 km in 2h। Speed?","solution":"120/2","answer":"60 km/h"}$j$),
    (9, 'govt_defence', 'tsd-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Avg speed 60, 40 equal D?","options":["48","50","52","55"],"answer":0,"explanation":"2×60×40/100 = 48"},{"q":"36 km/h in m/s?","options":["8","10","12","15"],"answer":1,"explanation":"36×5/18 = 10 m/s"}]}$j$),

    (10, 'govt_defence', 'num-def-concept', 'concept', 1, 'संख्या पद्धति — NDA/CDS',
     $j${"text":"HCF/LCM: ammunition grouping, unit formation. Divisibility. Number system: binary (computers, radar), octal, hex. Units digit cyclicity. Remainder. Modular arithmetic।","note":"Defence में grouping, binary, और cyclicity ज़रूरी हैं।"}$j$),
    (10, 'govt_defence', 'num-def-formula', 'formula', 2, 'संख्या सूत्र',
     $j${"formula":"HCF×LCM = a×b · Divisors of p^a·q^b = (a+1)(b+1) · Cyclicity: 2,3,7,8 (4), 4,9 (2)","explanation":"Binary: 2 base (0,1) · Decimal 10 → binary 1010"}$j$),
    (10, 'govt_defence', 'num-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Decimal 10 in binary?","solution":"10 = 8+2 = 1010₂","answer":"1010"}$j$),
    (10, 'govt_defence', 'num-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Decimal 15 in binary?","options":["1001","1010","1111","1011"],"answer":2,"explanation":"15 = 8+4+2+1 = 1111"},{"q":"2^50 units digit?","solution":"Cycle 4, 50 mod 4 = 2 → 4","options":["2","4","6","8"],"answer":1,"explanation":"Cycle 2: pos 2 = 4"}]}$j$),

    (11, 'govt_defence', 'simp-def-concept', 'concept', 1, 'सरलीकरण — NDA/CDS',
     $j${"text":"BODMAS, surds, indices, fractions. Rationalization. Approximation for quick estimation (artillery range, supply calculations). Complex fractions।","note":"Defence में fast estimation और rationalization ज़रूरी हैं।"}$j$),
    (11, 'govt_defence', 'simp-def-formula', 'formula', 2, 'सरलीकरण सूत्र',
     $j${"formula":"aᵐ·aⁿ = aᵐ⁺ⁿ · (aᵐ)ⁿ = aᵐⁿ · 1/(√a+√b) = (√a-√b)/(a-b) · BODMAS order","explanation":"√8 = 2√2 · √18 = 3√2 · √8+√18 = 5√2"}$j$),
    (11, 'govt_defence', 'simp-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"√50 + √32 = ?","solution":"5√2 + 4√2 = 9√2","answer":"9√2 ≈ 12.73"}$j$),
    (11, 'govt_defence', 'simp-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"√8 + √18?","options":["√26","5√2","3√3","√30"],"answer":1,"explanation":"2√2+3√2 = 5√2"},{"q":"2^(1/2) × 2^(1/3)?","options":["2^(1/6)","2^(5/6)","2^(2/6)","4"],"answer":1,"explanation":"2^(1/2+1/3) = 2^(5/6)"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[],
  case when s.chapter_id < 20 then 'maths' else 'general-science' end,
  'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select level_id, count(*) from mtb.atoms 
-- where chapter_id in (911,912,913,914,915,916,917,918,920,1,2,3,4,5,6,7,8,9,10,11) 
--   and status='published' and not archived 
-- group by level_id;
-- Expected: govt_defence = 80 (20 chapters × 4)

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: 2088 + 80 = 2168
