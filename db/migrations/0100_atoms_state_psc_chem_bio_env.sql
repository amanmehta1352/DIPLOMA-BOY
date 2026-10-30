with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ STATE PSC CHEM 894-899 ═══
    (894, 'state_psc', 'sol-psc-concept', 'concept', 1, 'विलयन — State PSC',
     $j${"text":"Solution: solute + solvent. Types: dilute, concentrated, saturated, unsaturated. Concentration: mass%, molarity (M), molality (m), mole fraction. Colligative properties: ΔTf = iKf·m, ΔTb = iKb·m, π=iCRT. Osmosis (water movement).","note":"State PSC में concentration, colligative, और osmosis ज़रूरी हैं।"}$j$),
    (894, 'state_psc', 'sol-psc-formula', 'formula', 2, 'विलयन सूत्र',
     $j${"formula":"M = n/V(L) · m = n/kg solvent · ΔTf = iKf·m · ΔTb = iKb·m · π = iCRT","explanation":"i = van't Hoff factor (NaCl=2, CaCl₂=3, glucose=1) · Osmosis: solvent moves to higher concentration"}$j$),
    (894, 'state_psc', 'sol-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"0.1 m NaCl (i=2), Kf=1.86। ΔTf?","solution":"2×1.86×0.1","answer":"0.372 K (freezing)"}$j$),
    (894, 'state_psc', 'sol-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Osmosis में solvent कहाँ?","options":["Lower to higher conc","Higher to lower","No movement","Random"],"answer":0,"explanation":"Solvent moves low→high solute conc"},{"q":"CaCl₂ का i?","options":["1","2","3","4"],"answer":2,"explanation":"CaCl₂ → Ca²⁺ + 2Cl⁻ = 3 particles"}]}$j$),

    (895, 'state_psc', 'electro-psc-concept', 'concept', 1, 'विद्युत रसायन — State PSC',
     $j${"text":"Electrolysis: current → chemical change. Anode (+), cathode (−)। Electroplating, metal refining, water electrolysis. Batteries: dry cell (1.5V), lead-acid (2V/cell), Li-ion (3.7V)। Corrosion: electrochemical rusting. Faraday's laws.","note":"State PSC में electrolysis, batteries, और electroplating ज़रूरी हैं।"}$j$),
    (895, 'state_psc', 'electro-psc-formula', 'formula', 2, 'विद्युत रसायन सूत्र',
     $j${"formula":"Faraday: m = (M/nF)·It · F = 96500 C/mol · Lead-acid cell: 2V","explanation":"Electroplating: object = cathode (metal deposits) · Li-ion: 3.7V, energy density ~250 Wh/kg"}$j$),
    (895, 'state_psc', 'electro-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Electrolysis में cathode पर क्या?","solution":"Reduction (metal deposits)","answer":"Reduction (metal ions → metal)"}$j$),
    (895, 'state_psc', 'electro-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Electroplating में object?","options":["Anode","Cathode","Solution","None"],"answer":1,"explanation":"Cathode (metal deposits)"},{"q":"Dry cell voltage?","options":["1V","1.5V","2V","3.7V"],"answer":1,"explanation":"~1.5V"}]}$j$),

    (896, 'state_psc', 'fuel-psc-concept', 'concept', 1, 'ईंधन — State PSC',
     $j${"text":"Fuels: solid (coal, wood), liquid (petrol, diesel, kerosene), gas (LPG, CNG, PNG)। Combustion: fuel + O₂ → CO₂ + H₂O + heat. Calorific value (kJ/kg). Octane (petrol), cetane (diesel)। Incomplete combustion → CO (toxic)। CNG = mostly methane, LPG = propane + butane.","note":"State PSC में calorific value, CNG/LPG composition, और combustion ज़रूरी हैं।"}$j$),
    (896, 'state_psc', 'fuel-psc-formula', 'formula', 2, 'ईंधन तथ्य',
     $j${"formula":"CH₄ + 2O₂ → CO₂ + 2H₂O + heat · Calorific: H₂(150) > CNG(50) > petrol(45) > coal(25-33) MJ/kg","explanation":"CNG = methane (CH₄) · LPG = propane (C₃H₈) + butane (C₄H₁₀) · Petrol octane, diesel cetane"}$j$),
    (896, 'state_psc', 'fuel-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"CNG का main component?","solution":"Methane (CH₄)","answer":"Methane (CH₄)"}$j$),
    (896, 'state_psc', 'fuel-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"LPG का main?","options":["Methane","Propane+Butane","Hydrogen","CO"],"answer":1,"explanation":"Propane + butane"},{"q":"CNG का main?","options":["Methane","Ethane","Propane","Butane"],"answer":0,"explanation":"Methane (CH₄)"}]}$j$),

    (897, 'state_psc', 'poly-psc-concept', 'concept', 1, 'बहुलक — State PSC',
     $j${"text":"Polymers: natural (cotton, wool, silk, rubber) vs synthetic (polythene, PVC, nylon, bakelite, terylene)। Addition (polythene from ethene) vs condensation (nylon from diamine+diacid)। Thermoplastic (soften on heating — polythene) vs thermoset (bakelite)। Biodegradable (PLA)।","note":"State PSC में natural/synthetic polymers और thermoplastic/thermoset ज़रूरी हैं।"}$j$),
    (897, 'state_psc', 'poly-psc-formula', 'formula', 2, 'बहुलक तथ्य',
     $j${"formula":"Polythene: n CH₂=CH₂ → [-CH₂-CH₂-]ₙ · Nylon: diamine + diacid → polyamide","explanation":"Thermoplastic: polythene, PVC (recyclable) · Thermoset: bakelite, melamine (cannot remelt) · Natural rubber: isoprene"}$j$),
    (897, 'state_psc', 'poly-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Nylon monomers?","solution":"Diamine + diacid","answer":"Diamine + dicarboxylic acid"}$j$),
    (897, 'state_psc', 'poly-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Thermoset example?","options":["Polythene","PVC","Bakelite","Nylon"],"answer":2,"explanation":"Bakelite (cannot remelt)"},{"q":"Natural polymer?","options":["Nylon","Cotton","PVC","Polystyrene"],"answer":1,"explanation":"Cotton (cellulose)"}]}$j$),

    (898, 'state_psc', 'corr-psc-concept', 'concept', 1, 'संक्षारण — State PSC',
     $j${"text":"Corrosion: metal damage from environment (O₂ + moisture)। Rust = Fe₂O₃·xH₂O. Requires O₂ + H₂O. Prevention: painting, oiling, galvanization (Zn), electroplating (Cr, Ni), alloying (stainless steel)। Corrosion is electrochemical process.","note":"State PSC में rusting conditions और prevention ज़रूरी हैं।"}$j$),
    (898, 'state_psc', 'corr-psc-formula', 'formula', 2, 'संक्षारण सूत्र',
     $j${"formula":"4Fe + 3O₂ + xH₂O → 2Fe₂O₃·xH₂O (rust) · Requires BOTH O₂ + moisture","explanation":"Galvanization: Zn (more reactive, protects Fe) · Stainless steel: Fe+Cr+Ni"}$j$),
    (898, 'state_psc', 'corr-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Galvanization में कौन metal?","solution":"Zinc (Zn)","answer":"Zinc (Zn)"}$j$),
    (898, 'state_psc', 'corr-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Rusting requires?","options":["Only O₂","Only H₂O","Both O₂+H₂O","CO₂"],"answer":2,"explanation":"Both needed"},{"q":"Galvanization में?","options":["Cu","Zn","Ag","Au"],"answer":1,"explanation":"Zinc coating"}]}$j$),

    (899, 'state_psc', 'lab-psc-concept', 'concept', 1, 'लैब रसायन — State PSC',
     $j${"text":"Lab basics: titration (acid-base), qualitative analysis (cation/anion), pH meter. Chromatography (paper, TLC)। Safety: acid → water (never reverse), goggles. Common reagents. Bunsen burner, beaker, burette, pipette।","note":"State PSC में lab techniques, safety, और qualitative analysis ज़रूरी हैं।"}$j$),
    (899, 'state_psc', 'lab-psc-formula', 'formula', 2, 'लैब तथ्य',
     $j${"formula":"Beer-Lambert: A = εcl · Rf = spot distance/solvent distance · Acid → water (not water → acid)","explanation":"Titration: burette (titrant) into conical flask (analyte) · Phenolphthalein (base) / methyl orange (acid)"}$j$),
    (899, 'state_psc', 'lab-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Acid dilution का rule?","solution":"Acid → water slowly (never water → acid)","answer":"Acid to water"}$j$),
    (899, 'state_psc', 'lab-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Acid diluting सही तरीका?","options":["Water→acid","Acid→water slowly","Both together","Fast"],"answer":1,"explanation":"Acid→water, slowly"},{"q":"Burette usage?","options":["Mixing","Titration","Heating","Filtering"],"answer":1,"explanation":"Titration (precise volume)"}]}$j$),

    -- ═══ STATE PSC BIO 901-912 ═══
    (901, 'state_psc', 'cell-psc-concept', 'concept', 1, 'कोशिका — State PSC',
     $j${"text":"Cell: basic unit of life. Prokaryotic (bacteria, no nucleus) vs eukaryotic (plant, animal — have nucleus)। Plant cell: cell wall, chloroplast, large vacuole. Animal: no cell wall, centriole. Organelles: nucleus (control), mitochondria (ATP), chloroplast (photosynthesis), ribosome (protein), Golgi (packaging), lysosome (digestion)।","note":"State PSC में plant vs animal cell और organelles ज़रूरी हैं।"}$j$),
    (901, 'state_psc', 'cell-psc-formula', 'formula', 2, 'कोशिका तथ्य',
     $j${"formula":"Nucleus = control · Mitochondria = powerhouse (ATP) · Chloroplast = photosynthesis · Ribosome = protein synthesis","explanation":"Prokaryotic: 70S ribosome, no membrane-bound organelles · Eukaryotic: 80S ribosome"}$j$),
    (901, 'state_psc', 'cell-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Plant cell में unique organelle?","solution":"Chloroplast (also cell wall, large vacuole)","answer":"Chloroplast (photosynthesis)"}$j$),
    (901, 'state_psc', 'cell-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Powerhouse?","options":["Nucleus","Mitochondria","Ribosome","Golgi"],"answer":1,"explanation":"Mitochondria (ATP)"},{"q":"Plant vs animal unique?","options":["Nucleus","Mitochondria","Chloroplast","Ribosome"],"answer":2,"explanation":"Chloroplast only in plants"}]}$j$),

    (902, 'state_psc', 'tissue-psc-concept', 'concept', 1, 'ऊतक — State PSC',
     $j${"text":"Plant tissues: meristematic (growth), parenchyma (storage), sclerenchyma (support), xylem (water), phloem (food)। Animal tissues: epithelial (covering), connective (blood, bone), muscular (movement), nervous (control). Tissue = group of similar cells.","note":"State PSC में plant vs animal tissues और types ज़रूरी हैं।"}$j$),
    (902, 'state_psc', 'tissue-psc-formula', 'formula', 2, 'ऊतक तथ्य',
     $j${"formula":"Plant: meristem (growth), xylem (water up), phloem (food) · Animal: epithelial (cover), connective (support), muscular (move), nervous (control)","explanation":"Blood = fluid connective · Bone = hard connective · Tendon: muscle→bone, Ligament: bone→bone"}$j$),
    (902, 'state_psc', 'tissue-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Blood किस tissue?","solution":"Fluid connective","answer":"Connective tissue"}$j$),
    (902, 'state_psc', 'tissue-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Xylem function?","options":["Food","Water up","Growth","Support"],"answer":1,"explanation":"Water + minerals (upward)"},{"q":"Blood tissue?","options":["Epithelial","Connective","Muscular","Nervous"],"answer":1,"explanation":"Fluid connective"}]}$j$),

    (903, 'state_psc', 'animal-psc-concept', 'concept', 1, 'जंतु जगत — State PSC',
     $j${"text":"Animal kingdom: Porifera (sponges), Cnidaria (hydra), Platyhelminthes (flatworms), Annelida (earthworm), Arthropoda (largest — insects), Mollusca (snails), Echinodermata (starfish), Chordata (vertebrates)। Symmetry, coelom, segmentation key features।","note":"State PSC में phyla features और examples ज़रूरी हैं।"}$j$),
    (903, 'state_psc', 'animal-psc-formula', 'formula', 2, 'जंतु तथ्य',
     $j${"formula":"Porifera: cellular · Cnidaria: tissue · Arthropoda: largest · Chordata: notochord","explanation":"Radial symmetry: Cnidaria, Echinodermata adult · Bilateral: most others · Coelom: true vs pseudo vs none"}$j$),
    (903, 'state_psc', 'animal-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Largest phylum?","solution":"Arthropoda","answer":"Arthropoda (insects)"}$j$),
    (903, 'state_psc', 'animal-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Largest phylum?","options":["Chordata","Mollusca","Arthropoda","Annelida"],"answer":2,"explanation":"Arthropoda"},{"q":"Starfish phylum?","options":["Mollusca","Echinodermata","Cnidaria","Porifera"],"answer":1,"explanation":"Echinodermata"}]}$j$),

    (904, 'state_psc', 'plant-psc-concept', 'concept', 1, 'पादप जगत — State PSC',
     $j${"text":"Plant kingdom: algae (aquatic), bryophytes (no vascular, amphibian), pteridophytes (first vascular, fern), gymnosperms (naked seeds, pine), angiosperms (flower+fruit)। Angiosperms: monocot (1 cotyledon, parallel venation) vs dicot (2 cotyledons, reticulate). Double fertilization = angiosperms only.","note":"State PSC में plant groups और monocot/dicot ज़रूरी हैं।"}$j$),
    (904, 'state_psc', 'plant-psc-formula', 'formula', 2, 'पादप तथ्य',
     $j${"formula":"Algae → Bryophytes (no vascular) → Pteridophytes (vascular, no seed) → Gymnosperms (naked) → Angiosperms (flower)","explanation":"Monocot: 1 cotyledon, fibrous root, parallel · Dicot: 2 cotyledons, tap root, reticulate"}$j$),
    (904, 'state_psc', 'plant-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"First vascular plants?","solution":"Pteridophytes (ferns)","answer":"Pteridophytes"}$j$),
    (904, 'state_psc', 'plant-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Amphibians of plant kingdom?","options":["Algae","Bryophytes","Pteridophytes","Gymnosperms"],"answer":1,"explanation":"Bryophytes (need water)"},{"q":"Monocot venation?","options":["Parallel","Reticulate","Both","None"],"answer":0,"explanation":"Parallel venation (monocots)"}]}$j$),

    (905, 'state_psc', 'nutrition-psc-concept', 'concept', 1, 'पोषण — State PSC',
     $j${"text":"Nutrition: autotrophic (photosynthesis) vs heterotrophic (holozoic, saprophytic, parasitic, symbiotic)। Human nutrition: carbs (energy), proteins (essential amino acids), fats, vitamins (fat-soluble A,D,E,K; water-soluble B,C), minerals (Ca, Fe, I)। Deficiency: scurvy (C), rickets (D), beriberi (B1), night blindness (A), goiter (I), anemia (Fe)।","note":"State PSC में vitamins, deficiencies, और nutrients ज़रूरी हैं।"}$j$),
    (905, 'state_psc', 'nutrition-psc-formula', 'formula', 2, 'पोषण तथ्य',
     $j${"formula":"Carbs 4 Cal/g · Proteins 4 Cal/g · Fats 9 Cal/g · Fat-soluble: A, D, E, K · Water-soluble: B, C","explanation":"Deficiency: scurvy (C), rickets (D), beriberi (B1), night blindness (A), goiter (I), anemia (Fe), kwashiorkor (protein)"}$j$),
    (905, 'state_psc', 'nutrition-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Scurvy किसकी कमी?","solution":"Vitamin C","answer":"Vitamin C"}$j$),
    (905, 'state_psc', 'nutrition-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Rickets vitamin?","options":["A","B","C","D"],"answer":3,"explanation":"Vitamin D (Ca absorption)"},{"q":"Fat Cal/g?","options":["4","7","9","12"],"answer":2,"explanation":"Fats = 9 Cal/g"}]}$j$),

    (906, 'state_psc', 'photo-psc-concept', 'concept', 1, 'प्रकाश संश्लेषण — State PSC',
     $j${"text":"Photosynthesis: 6CO₂ + 6H₂O + light → C₆H₁₂O₆ + 6O₂. Chlorophyll (green pigment, chloroplast)। Light reaction (thylakoid) + dark reaction (Calvin cycle, stroma)। C3 (most), C4 (maize, sugarcane — Kranz anatomy), CAM (cacti — night)। Stomata exchange gases।","note":"State PSC में photosynthesis equation, chlorophyll, और C3/C4 ज़रूरी हैं।"}$j$),
    (906, 'state_psc', 'photo-psc-formula', 'formula', 2, 'प्रकाश संश्लेषण सूत्र',
     $j${"formula":"6CO₂ + 6H₂O + light (chlorophyll) → C₆H₁₂O₆ + 6O₂","explanation":"Light reaction: PSII→PSI, ATP+NADPH · Dark: Calvin (RuBisCO) · C4 first product: OAA"}$j$),
    (906, 'state_psc', 'photo-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Photosynthesis में O₂ source?","solution":"Water (photolysis)","answer":"Water splitting"}$j$),
    (906, 'state_psc', 'photo-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Photosynthesis site?","options":["Mitochondria","Chloroplast","Nucleus","Ribosome"],"answer":1,"explanation":"Chloroplast"},{"q":"Most abundant enzyme?","options":["Amylase","RuBisCO","Catalase","Pepsin"],"answer":1,"explanation":"RuBisCO (CO₂ fixation)"}]}$j$),

    (907, 'state_psc', 'digest-psc-concept', 'concept', 1, 'पाचन — State PSC',
     $j${"text":"Digestive system: mouth (saliva amylase — starch) → esophagus → stomach (pepsin, HCl — protein) → small intestine (complete digestion + absorption, villi) → large intestine (water absorption) → anus. Liver (bile), pancreas (enzymes)।","note":"State PSC में digestive enzymes और absorption ज़रूरी हैं।"}$j$),
    (907, 'state_psc', 'digest-psc-formula', 'formula', 2, 'पाचन तथ्य',
     $j${"formula":"Amylase: starch→maltose (mouth) · Pepsin: protein→peptide (stomach, pH 1.5-3.5) · Trypsin: peptide→AA (SI, pH 8)","explanation":"Bile (liver): fat emulsification · Villi: absorption · Peristalsis: movement"}$j$),
    (907, 'state_psc', 'digest-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Protein digestion stomach में किस enzyme?","solution":"Pepsin","answer":"Pepsin (HCl activates pepsinogen)"}$j$),
    (907, 'state_psc', 'digest-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Starch digestion starts?","options":["Stomach","Mouth","SI","LI"],"answer":1,"explanation":"Mouth (salivary amylase)"},{"q":"Bile function?","options":["Protein digest","Fat emulsification","Starch","Water"],"answer":1,"explanation":"Emulsification (no enzyme)"}]}$j$),

    (908, 'state_psc', 'resp-psc-concept', 'concept', 1, 'श्वसन — State PSC',
     $j${"text":"Respiration: aerobic (O₂ → 38 ATP, CO₂+H₂O) vs anaerobic (no O₂ → 2 ATP, lactic acid in muscle, ethanol in yeast)। Human: nose → trachea → bronchi → bronchioles → alveoli (gas exchange)। Diaphragm + ribs breathing. Cellular: glycolysis → Krebs → ETC.","note":"State PSC में aerobic vs anaerobic और respiration steps ज़रूरी हैं।"}$j$),
    (908, 'state_psc', 'resp-psc-formula', 'formula', 2, 'श्वसन सूत्र',
     $j${"formula":"Aerobic: C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + 38 ATP · Anaerobic (muscle): glucose → lactic acid + 2 ATP","explanation":"Yeast: glucose → ethanol + CO₂ + 2 ATP · Alveoli = gas exchange site · ATP from mitochondria"}$j$),
    (908, 'state_psc', 'resp-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Aerobic ATP per glucose?","solution":"38 ATP","answer":"38 ATP"}$j$),
    (908, 'state_psc', 'resp-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Gas exchange site?","options":["Trachea","Bronchi","Alveoli","Nose"],"answer":2,"explanation":"Alveoli"},{"q":"Muscle anaerobic product?","options":["Ethanol","Lactic acid","CO₂","O₂"],"answer":1,"explanation":"Lactic acid (muscle)"}]}$j$),

    (909, 'state_psc', 'circ-psc-concept', 'concept', 1, 'परिसंचरण — State PSC',
     $j${"text":"Circulatory: heart (4 chambers), double circulation (pulmonary + systemic)। Blood: plasma + RBC (O₂, Hb) + WBC (immunity) + platelets (clotting)। RBC life 120 days। Blood groups: ABO + Rh. Heart rate 72/min, BP 120/80। Cardiac cycle 0.8s. ECG (PQRST)।","note":"State PSC में heart, blood components, और BP ज़रूरी हैं।"}$j$),
    (909, 'state_psc', 'circ-psc-formula', 'formula', 2, 'परिसंचरण तथ्य',
     $j${"formula":"CO = HR × SV ≈ 5 L/min · BP = 120/80 mmHg · Cardiac cycle = 0.8s (systole 0.3 + diastole 0.5)","explanation":"RBC: Hb, 120-day life · WBC: immunity · Platelets: clotting · Universal donor: O−"}$j$),
    (909, 'state_psc', 'circ-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Universal donor blood group?","solution":"O negative (O−)","answer":"O− (no antigens)"}$j$),
    (909, 'state_psc', 'circ-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Heart chambers?","options":["2","3","4","5"],"answer":2,"explanation":"4 chambers (2 atria, 2 ventricles)"},{"q":"Blood clotting cells?","options":["RBC","WBC","Platelets","Plasma"],"answer":2,"explanation":"Platelets"}]}$j$),

    (910, 'state_psc', 'trans-psc-concept', 'concept', 1, 'पादप परिवहन — State PSC',
     $j${"text":"Xylem (water + minerals, upward, dead cells) + phloem (food, bidirectional, living cells)। Transpiration pull (cohesion-tension theory) — main ascent force. Root pressure, guttation. Stomata: guard cells (K⁺ → open)। Translocation: phloem source→sink।","note":"State PSC में xylem vs phloem और transpiration ज़रूरी हैं।"}$j$),
    (910, 'state_psc', 'trans-psc-formula', 'formula', 2, 'परिवहन तथ्य',
     $j${"formula":"Xylem: water + minerals (upward, unidirectional) · Phloem: food (source→sink, bidirectional)","explanation":"Transpiration pull: main force · Stomata open: K⁺ influx → water → turgid"}$j$),
    (910, 'state_psc', 'trans-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Water ascent force?","solution":"Transpiration pull","answer":"Transpiration pull (cohesion-tension)"}$j$),
    (910, 'state_psc', 'trans-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Phloem transport?","options":["Up only","Down only","Both directions","None"],"answer":2,"explanation":"Bidirectional (source→sink)"},{"q":"Xylem cells?","options":["Living","Dead","Both","None"],"answer":1,"explanation":"Dead (hollow tubes)"}]}$j$),

    (911, 'state_psc', 'exc-psc-concept', 'concept', 1, 'उत्सर्जन — State PSC',
     $j${"text":"Excretion: kidney (main), skin, lungs, liver. Nephron = functional unit. Urine formation: filtration → reabsorption → secretion. GFR ~125 mL/min। ADH (water reabsorption), aldosterone (Na⁺). Plant excretion: O₂, CO₂, water, resins।","note":"State PSC में nephron, GFR, और ADH ज़रूरी हैं।"}$j$),
    (911, 'state_psc', 'exc-psc-formula', 'formula', 2, 'उत्सर्जन तथ्य',
     $j${"formula":"GFR ≈ 125 mL/min · Urine ≈ 1.5 L/day · Nephron ≈ 1 million per kidney","explanation":"ADH: ↑ water reabsorption · Aldosterone: ↑ Na⁺ reabsorption · Kidney hormones: renin (BP), erythropoietin (RBC), calcitriol (Vit D)"}$j$),
    (911, 'state_psc', 'exc-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Kidney functional unit?","solution":"Nephron","answer":"Nephron"}$j$),
    (911, 'state_psc', 'exc-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Erythropoietin source?","options":["Liver","Kidney","Bone marrow","Spleen"],"answer":1,"explanation":"Kidney → RBC production"},{"q":"ADH effect?","options":["Water loss","Water retention","Na⁺ loss","None"],"answer":1,"explanation":"Water reabsorption ↑"}]}$j$),

    (912, 'state_psc', 'nerve-psc-concept', 'concept', 1, 'तंत्रिका — State PSC',
     $j${"text":"Nervous system: CNS (brain, spinal cord) + PNS. Neuron = functional unit. Resting potential -70 mV, action potential +30 mV. Brain: cerebrum (thinking), cerebellum (balance), medulla (involuntary — heart, breathing), hypothalamus (temperature, hunger). Reflex arc. Neurotransmitters (ACh, dopamine)।","note":"State PSC में brain parts, action potential, और reflex ज़रूरी हैं।"}$j$),
    (912, 'state_psc', 'nerve-psc-formula', 'formula', 2, 'तंत्रिका तथ्य',
     $j${"formula":"Resting: -70 mV · Action: +30 mV · Myelinated: 120 m/s · Unmyelinated: 1 m/s","explanation":"Cerebrum: thinking · Cerebellum: balance · Medulla: involuntary (heart, breathing) · Hypothalamus: temperature, hunger"}$j$),
    (912, 'state_psc', 'nerve-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Balance center?","solution":"Cerebellum","answer":"Cerebellum"}$j$),
    (912, 'state_psc', 'nerve-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Thinking center?","options":["Cerebrum","Cerebellum","Medulla","Spinal cord"],"answer":0,"explanation":"Cerebrum"},{"q":"Resting potential?","options":["-90 mV","-70 mV","0 mV","+30 mV"],"answer":1,"explanation":"-70 mV"}]}$j$),

    -- ═══ STATE PSC ENV 920 ═══
    (920, 'state_psc', 'env-psc-concept', 'concept', 1, 'पर्यावरण — State PSC',
     $j${"text":"Ecosystem: biotic + abiotic. Food chain/web, trophic levels, 10% energy law. Biogeochemical cycles (C, N, P, water)। Pollution: air (PM, SO₂, NOₓ), water (BOD), soil (pesticides), noise (dB). Greenhouse: CO₂, CH₄, N₂O, CFCs. Ozone depletion (CFCs)। Biodiversity hotspots (India: 4)। Conservation: in-situ (parks), ex-situ (zoos)।","note":"State PSC में ecosystem, pollution, और biodiversity ज़रूरी हैं।"}$j$),
    (920, 'state_psc', 'env-psc-formula', 'formula', 2, 'पर्यावरण सूत्र',
     $j${"formula":"10% energy transfer · BOD = biological O₂ demand · Ozone: O₃ absorbs UV-B","explanation":"Pollution control: ESP, scrubber, catalytic converter · Biodiversity hotspots: 4 in India (Western Ghats, E.Himalaya, Indo-Burma, Sundaland)"}$j$),
    (920, 'state_psc', 'env-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"10% energy law?","solution":"Lindeman (1942)","answer":"10% transfer (Lindeman)"}$j$),
    (920, 'state_psc', 'env-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Ozone depletion cause?","options":["CO₂","CFCs","SO₂","CH₄"],"answer":1,"explanation":"CFCs → Cl radicals"},{"q":"India biodiversity hotspots?","options":["2","3","4","5"],"answer":2,"explanation":"4 hotspots"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[],
  case when s.chapter_id = 920 then 'environment' else 'general-science' end,
  'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, count(*) from mtb.atoms 
-- where chapter_id in (894,895,896,897,898,899,901,902,903,904,905,906,907,908,909,910,911,912,920) 
--   and level_id='state_psc' and status='published' and not archived 
-- group by 1 order by 1;
-- Expected: each = 4, total 76

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: 2408 + 76 = 2484
