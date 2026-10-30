with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ DEFENCE CHEMISTRY (889-899) ═══
    (889, 'govt_defence', 'chem-react-def-concept', 'concept', 1, 'अभिक्रियाएँ — NDA/CDS',
     $j${"text":"Defence reactions: explosives (exothermic decomposition), propellants (rapid combustion), smoke grenades (combustion → smoke)। Types: combination, decomposition, displacement, double displacement, redox. Explosive reaction speed: μs to ms. Gunpowder: KNO₃ + S + C → K₂S + N₂ + CO₂.","note":"Defence में explosive reactions और propellants ज़रूरी हैं।"}$j$),
    (889, 'govt_defence', 'chem-react-def-formula', 'formula', 2, 'अभिक्रिया सूत्र',
     $j${"formula":"Gunpowder: 2KNO₃ + S + 3C → K₂S + N₂ + 3CO₂ · TNT (oxygen-deficient detonation): 2C₇H₅N₃O₆ → 3N₂ + 5H₂O + 7CO + 7C","explanation":"Explosive velocity: detonation > deflagration · Reaction rate = k[A][B] (kinetics)"}$j$),
    (889, 'govt_defence', 'chem-react-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Gunpowder में stoichiometry (KNO₃: S: C)","solution":"2 : 1 : 3 for KNO₃:S:C","answer":"2:1:3 ratio"}$j$),
    (889, 'govt_defence', 'chem-react-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Gunpowder में KNO₃ का role?","options":["Fuel","Oxidizer","Binder","Smoke"],"answer":1,"explanation":"KNO₃ = oxidizer (supplies O₂)"},{"q":"TNT detonation type?","options":["Deflagration","Detonation","Slow burn","No reaction"],"answer":1,"explanation":"TNT = detonation (supersonic)"}]}$j$),

    (890, 'govt_defence', 'redox-def-concept', 'concept', 1, 'रेडॉक्स — NDA/CDS',
     $j${"text":"Defence: batteries (lithium-ion), fuel cells (submarines), explosives (rapid oxidation), chemical agents (nerve agents — organophosphates, blister agents — sulfur mustard)। Oxidation = loss e⁻ (OIL), reduction = gain (RIG)। E° tables for battery selection।","note":"Defence में batteries, fuel cells, और chemical agents ज़रूरी हैं।"}$j$),
    (890, 'govt_defence', 'redox-def-formula', 'formula', 2, 'रेडॉक्स सूत्र',
     $j${"formula":"E°_cell = E°_cathode - E°_anode · ΔG° = -nFE° · F = 96500 C/mol","explanation":"Li-ion battery: ~3.7V per cell · Sulfur mustard: (ClCH₂CH₂)₂S (vesicant)"}$j$),
    (890, 'govt_defence', 'redox-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Li-ion cell E°≈3.7V, 4 cells in series। Voltage?","solution":"4 × 3.7","answer":"14.8 V"}$j$),
    (890, 'govt_defence', 'redox-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Battery में oxidation कहाँ?","options":["Anode","Cathode","Electrolyte","Separator"],"answer":0,"explanation":"Anode = oxidation (loss e⁻)"},{"q":"Nerve agent class?","options":["Nitro compound","Organophosphate","Metal","Alcohol"],"answer":1,"explanation":"Organophosphates (e.g., sarin, VX)"}]}$j$),

    (891, 'govt_defence', 'acid-def-concept', 'concept', 1, 'अम्ल-क्षार — NDA/CDS',
     $j${"text":"Defence: chemical warfare agents — chlorine (Cl₂), phosgene (COCl₂), mustard (blister), sarin (nerve)। Neutralization: acid + base → salt + water. Detection: pH paper, specific detectors. Protective: gas mask with activated charcoal + soda lime.","note":"Defence में chemical agents, detection, और gas mask ज़रूरी हैं।"}$j$),
    (891, 'govt_defence', 'acid-def-formula', 'formula', 2, 'अम्ल-क्षार सूत्र',
     $j${"formula":"Acid + Base → Salt + Water · pH = -log[H⁺] · Neutralize: HCl + NaOH → NaCl + H₂O","explanation":"Gas mask: activated charcoal (adsorb) + soda lime (neutralize acid gases) · Phosgene: COCl₂ + H₂O → CO₂ + 2HCl (lung damage)"}$j$),
    (891, 'govt_defence', 'acid-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Chlorine gas neutralize के लिए?","solution":"Soda lime (CaO + NaOH) या Na₂S₂O₃","answer":"Alkaline solution (soda lime)"}$j$),
    (891, 'govt_defence', 'acid-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Sarin किस class?","options":["Blister","Nerve","Choking","Blood"],"answer":1,"explanation":"Sarin = nerve agent (organophosphate)"},{"q":"Gas mask में क्या?","options":["Cotton","Activated charcoal + soda lime","Silica","Metal mesh"],"answer":1,"explanation":"Charcoal adsorbs, soda lime neutralizes"}]}$j$),

    (892, 'govt_defence', 'metal-def-concept', 'concept', 1, 'धातु-अधातु — NDA/CDS',
     $j${"text":"Defence metals: armor (RHA steel, alumina ceramic), penetrators (DU, tungsten), aircraft (Ti, Al alloys), radar (GaN, GaAs)। Extraction: roasting, calcination, electrolysis. Alloys: steel (Fe+C), stainless (Fe+Cr+Ni), titanium alloy (Ti-6Al-4V)।","note":"Defence में armor materials और penetrators ज़रूरी हैं।"}$j$),
    (892, 'govt_defence', 'metal-def-formula', 'formula', 2, 'धातु तथ्य',
     $j${"formula":"Steel: Fe+C (0.2-2% C) · Stainless: Fe+18%Cr+8%Ni · Ti-6Al-4V: high strength/weight","explanation":"RHA steel density 7.8 g/cm³ · DU density 19.1 g/cm³ · Tungsten 19.3 g/cm³"}$j$),
    (892, 'govt_defence', 'metal-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"DU vs steel density ratio?","solution":"DU 19.1 / steel 7.8","answer":"≈ 2.45× (DU much denser)"}$j$),
    (892, 'govt_defence', 'metal-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Aircraft के लिए कौन alloy?","options":["Fe-C","Ti-6Al-4V","Cu-Zn","Pb-Sn"],"answer":1,"explanation":"Ti-6Al-4V (high strength, light)"},{"q":"AP shell penetrator?","options":["Lead","Tungsten/DU","Aluminum","Zinc"],"answer":1,"explanation":"Tungsten or depleted uranium (high density)"}]}$j$),

    (893, 'govt_defence', 'carbon-def-concept', 'concept', 1, 'कार्बन — NDA/CDS',
     $j${"text":"Defence carbon: explosives (TNT, RDX — nitro compounds), propellants (nitrocellulose), smoke (HC smoke — ZnCl₂), carbon fiber (composite armor, lighter aircraft)। Allotropes: diamond (hard), graphite (lubricant), fullerene। Nitro group -NO₂ = explosive।","note":"Defence में explosives और carbon composites ज़रूरी हैं।"}$j$),
    (893, 'govt_defence', 'carbon-def-formula', 'formula', 2, 'कार्बन तथ्य',
     $j${"formula":"TNT: C₇H₅N₃O₆ · RDX: C₃H₆N₆O₆ · Nitrocellulose: cellulose + HNO₃ → (C₆H₇O₂(ONO₂)₃)ₙ","explanation":"Explosive power: RDX (8750 m/s) > TNT (6900 m/s) · Carbon fiber: high strength/weight"}$j$),
    (893, 'govt_defence', 'carbon-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"TNT (C₇H₅N₃O₆) का molar mass? (C=12, H=1, N=14, O=16)","solution":"7×12 + 5×1 + 3×14 + 6×16 = 84 + 5 + 42 + 96","answer":"227 g/mol"}$j$),
    (893, 'govt_defence', 'carbon-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"RDX का detonation velocity?","options":["3000 m/s","6900 m/s","8750 m/s","12000 m/s"],"answer":2,"explanation":"RDX ~8750 m/s"},{"q":"Carbon fiber का फायदा?","options":["Heavy","Low strength","High strength/weight","Brittle"],"answer":2,"explanation":"High strength/weight ratio"}]}$j$),

    (894, 'govt_defence', 'sol-def-concept', 'concept', 1, 'विलयन — NDA/CDS',
     $j${"text":"Defence solutions: blood (isotonic saline for transfusion), chemical agent dispersal (aerosol), smoke solutions (WP — white phosphorus), decontamination (bleach solution)। Osmotic pressure π = iCRT। Colligative properties.","note":"Defence में IV fluids, aerosols, और decontamination ज़रूरी हैं।"}$j$),
    (894, 'govt_defence', 'sol-def-formula', 'formula', 2, 'विलयन सूत्र',
     $j${"formula":"π = iCRT · 0.9% NaCl ≈ isotonic (308 mOsm/L) · Decontamination: 5% bleach solution","explanation":"Blood osmolarity ≈ 290 mOsm/L · Aerosol: liquid/solid particles dispersed in air"}$j$),
    (894, 'govt_defence', 'sol-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"0.9% NaCl osmolarity? (i=2, M≈0.154)","solution":"2 × 0.154 × 1000","answer":"≈ 308 mOsm/L"}$j$),
    (894, 'govt_defence', 'sol-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Isotonic saline (blood)?","options":["0.45% NaCl","0.9% NaCl","5% NaCl","10% NaCl"],"answer":1,"explanation":"0.9% NaCl = normal saline"},{"q":"Decontamination में?","options":["Distilled water","Bleach solution","Alcohol","Acetone"],"answer":1,"explanation":"5% bleach neutralizes chemical agents"}]}$j$),

    (895, 'govt_defence', 'electro-def-concept', 'concept', 1, 'विद्युत रसायन — NDA/CDS',
     $j${"text":"Defence electrochemistry: batteries (field, vehicle, submarine Li-ion, lead-acid), fuel cells (submarines — AIP), electrolysis (aluminum production for aircraft)। Nernst equation। Corrosion of equipment.","note":"Defence में military batteries, fuel cells, और corrosion ज़रूरी हैं।"}$j$),
    (895, 'govt_defence', 'electro-def-formula', 'formula', 2, 'विद्युत रसायन सूत्र',
     $j${"formula":"Nernst: E = E° - (0.059/n)log Q · F = 96500 C/mol · Lead-acid cell: 2V/cell","explanation":"Li-ion cell: 3.7V, energy density ~250 Wh/kg · Submarine AIP fuel cell: H₂ + O₂ → H₂O"}$j$),
    (895, 'govt_defence', 'electro-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Lead-acid battery (2V) × 6 cells। Total?","solution":"6 × 2","answer":"12 V (car battery)"}$j$),
    (895, 'govt_defence', 'electro-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Li-ion cell voltage?","options":["1.5V","2V","3.7V","5V"],"answer":2,"explanation":"Li-ion: ~3.7V nominal"},{"q":"Submarine AIP technology?","options":["Diesel","Fuel cell","Nuclear","Battery only"],"answer":1,"explanation":"AIP: Air-Independent Propulsion (fuel cell)"}]}$j$),

    (896, 'govt_defence', 'fuel-def-concept', 'concept', 1, 'ईंधन-दहन — NDA/CDS',
     $j${"text":"Defence fuels: jet fuel (JP-8, kerosene-based), diesel (tanks), gasoline (vehicles), rocket propellants (solid/liquid/hybrid), explosives (high explosive), gunpowder (propellant)। Calorific value: jet fuel ~43 MJ/kg, diesel ~45 MJ/kg.","note":"Defence में jet fuel, rocket propellants, और calorific value ज़रूरी हैं।"}$j$),
    (896, 'govt_defence', 'fuel-def-formula', 'formula', 2, 'ईंधन सूत्र',
     $j${"formula":"Jet fuel: JP-8 ~43 MJ/kg · Diesel: ~45 MJ/kg · Gasoline: ~44 MJ/kg","explanation":"Rocket propellant: APCP (ammonium perchlorate composite) · Solid: Al + AP + HTPB · Liquid: LOX + RP-1"}$j$),
    (896, 'govt_defence', 'fuel-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Jet engine 1 kg fuel = ? energy","solution":"~43 MJ/kg","answer":"43,000 kJ/kg"}$j$),
    (896, 'govt_defence', 'fuel-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"JP-8 किस type?","options":["Gasoline","Kerosene-based","Diesel","Alcohol"],"answer":1,"explanation":"JP-8 = kerosene-based jet fuel"},{"q":"Solid rocket propellant में?","options":["LOX+RP-1","AP+Al+HTPB","Kerosene+O₂","H₂+O₂"],"answer":1,"explanation":"AP (oxidizer) + Al (fuel) + HTPB (binder)"}]}$j$),

    (897, 'govt_defence', 'poly-def-concept', 'concept', 1, 'बहुलक — NDA/CDS',
     $j${"text":"Defence polymers: Kevlar (armor, bulletproof), Nomex (fire-resistant suit), Teflon (non-stick, chemical-resistant), polyethylene (light armor), polycarbonate (transparent armor), rubber (tires, seals)। Composite: fiber + resin. Kevlar = aramid polymer.","note":"Defence में Kevlar, Nomex, और composites ज़रूरी हैं।"}$j$),
    (897, 'govt_defence', 'poly-def-formula', 'formula', 2, 'बहुलक तथ्य',
     $j${"formula":"Kevlar: poly-para-phenylene terephthalamide · Nomex: poly-meta-phenylene isophthalamide","explanation":"Kevlar: strength 5× steel (weight basis) · Nomex: self-extinguishing (fire suit) · Teflon: PTFE"}$j$),
    (897, 'govt_defence', 'poly-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Kevlar का strength vs steel (weight basis)","solution":"~5× stronger than steel (same weight)","answer":"5× steel strength per weight"}$j$),
    (897, 'govt_defence', 'poly-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Bulletproof vest में?","options":["Polyethylene","Kevlar","Nylon","PVC"],"answer":1,"explanation":"Kevlar (aramid fiber)"},{"q":"Fire suit में?","options":["Teflon","Nomex","Polystyrene","Silicone"],"answer":1,"explanation":"Nomex (fire-resistant)"}]}$j$),

    (898, 'govt_defence', 'corr-def-concept', 'concept', 1, 'संक्षारण — NDA/CDS',
     $j${"text":"Defence corrosion: equipment rusting (tropical, coastal), gun barrel wear, naval vessel corrosion (salt water)। Prevention: galvanization (Zn), painting, cathodic protection, alloying (stainless)। Rust = Fe₂O₃·xH₂O. Salt accelerates corrosion (electrolyte)।","note":"Defence में military equipment की corrosion protection ज़रूरी है।"}$j$),
    (898, 'govt_defence', 'corr-def-formula', 'formula', 2, 'संक्षारण सूत्र',
     $j${"formula":"4Fe + 3O₂ + xH₂O → 2Fe₂O₃·xH₂O (rust) · Galvanization: Zn (E°=-0.76) protects Fe (E°=-0.44)","explanation":"Cathodic protection: sacrificial anode (Zn, Mg) · Corrosion rate: ↑ with salt, moisture, temperature"}$j$),
    (898, 'govt_defence', 'corr-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Naval ship पर corrosion तेज़ क्यों?","solution":"Salt water (electrolyte) accelerates electrochemical corrosion","answer":"Salt (NaCl) acts as electrolyte"}$j$),
    (898, 'govt_defence', 'corr-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Galvanization में?","options":["Cu","Zn","Ag","Au"],"answer":1,"explanation":"Zn coating (sacrificial)"},{"q":"Cathodic protection में?","options":["Sacrificial cathode","Sacrificial anode","Inert","None"],"answer":1,"explanation":"More reactive metal = sacrificial anode"}]}$j$),

    (899, 'govt_defence', 'lab-def-concept', 'concept', 1, 'लैब — NDA/CDS',
     $j${"text":"Defence lab analysis: explosives detection (TLC, GC-MS), chemical agent detection (colorimetric, ion mobility), forensic analysis (DNA, ballistics, trace evidence)। Spectroscopy: UV-Vis, IR, Raman (standoff detection)। Chromatography for explosive residues.","note":"Defence में explosives detection, chemical agents, और forensics ज़रूरी हैं।"}$j$),
    (899, 'govt_defence', 'lab-def-formula', 'formula', 2, 'लैब तकनीक',
     $j${"formula":"GC-MS: gas chromatography + mass spec (explosive residue) · IMS: ion mobility (agent detection) · Raman: standoff detection (light scattering)","explanation":"Beer-Lambert: A = εcl · TLC Rf = distance spot/solvent · DNA: PCR amplification for forensics"}$j$),
    (899, 'govt_defence', 'lab-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Explosive trace detection की technique?","solution":"IMS (ion mobility spec) — quick, portable","answer":"IMS (widely used at checkpoints)"}$j$),
    (899, 'govt_defence', 'lab-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Explosives detection portable device?","options":["NMR","IMS","XRD","HPLC"],"answer":1,"explanation":"IMS (Ion Mobility Spectroscopy)"},{"q":"Raman spectroscopy uses?","options":["Magnetic","Light scattering","Ionization","Absorption only"],"answer":1,"explanation":"Raman = inelastic light scattering"}]}$j$),

    -- ═══ DEFENCE BIOLOGY (907-910) ═══
    (907, 'govt_defence', 'digest-def-concept', 'concept', 1, 'पाचन — NDA/CDS',
     $j${"text":"Defence nutrition/digestion: field ration digestion, water sources (dehydration risk), food safety (field conditions), GI infections (dysentery, typhoid) from contaminated food/water. Digestive enzymes: amylase (starch), pepsin (protein, stomach), trypsin (small intestine), lipase (fat)।","note":"Defence में field nutrition, dehydration, और GI infections ज़रूरी हैं।"}$j$),
    (907, 'govt_defence', 'digest-def-formula', 'formula', 2, 'पाचन तथ्य',
     $j${"formula":"Amylase: starch → maltose · Pepsin: protein → peptide (stomach, pH 1.5-3.5) · Trypsin: peptide → AA (SI, pH 8)","explanation":"Field water: purify via chlorine tablets, iodine, filtration · Dehydration: 2% body weight loss = performance drop"}$j$),
    (907, 'govt_defence', 'digest-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Field soldier 5L water loss। Body weight drop (70kg)?","solution":"5/70 × 100","answer":"≈7% (severe dehydration)"}$j$),
    (907, 'govt_defence', 'digest-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Stomach में protein digest?","options":["Amylase","Pepsin","Trypsin","Lipase"],"answer":1,"explanation":"Pepsin (stomach, acidic)"},{"q":"Water purification field में?","options":["Boil only","Chlorine/iodine + filtration","Wait","Nothing"],"answer":1,"explanation":"Chemical purification + filtration"}]}$j$),

    (908, 'govt_defence', 'resp-def-concept', 'concept', 1, 'श्वसन — NDA/CDS',
     $j${"text":"Defence respiration: high altitude (low O₂ → hypoxia, acclimatization), chemical agents (phosgene, chlorine — lung damage), smoke inhalation (CO poisoning), respirator use, oxygen therapy। Aerobic vs anaerobic. CO binds Hb 200× stronger than O₂.","note":"Defence में altitude hypoxia, chemical lung damage, और CO poisoning ज़रूरी हैं।"}$j$),
    (908, 'govt_defence', 'resp-def-formula', 'formula', 2, 'श्वसन तथ्य',
     $j${"formula":"Aerobic: C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + 38 ATP · SpO₂ normal: 95-100%","explanation":"At 5000m: O₂ ~50% of sea level · CO binds Hb 200× stronger than O₂ → carboxyhemoglobin"}$j$),
    (908, 'govt_defence', 'resp-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"At 5500m, O₂ pressure vs sea level?","solution":"~50% (roughly half)","answer":"≈50% (high altitude hypoxia)"}$j$),
    (908, 'govt_defence', 'resp-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"CO poisoning क्यों घातक?","options":["CO₂ बनाता","CO-Hb बनता","O₂ बढ़ता","CO neutral"],"answer":1,"explanation":"CO binds Hb (200× O₂ affinity)"},{"q":"Altitude पर acclimatization?","options":["RBC ↓","RBC ↑","Same","कोई नहीं"],"answer":1,"explanation":"RBC ↑ (erythropoietin)"}]}$j$),

    (909, 'govt_defence', 'circ-def-concept', 'concept', 1, 'परिसंचरण — NDA/CDS',
     $j${"text":"Defence circulation: combat trauma (hemorrhage, shock), blood transfusion (ABO + Rh), tourniquets, hypovolemic shock, cardiac output. Normal BP 120/80, HR 60-100. Shock: BP ↓, HR ↑. Tourniquet time limit ~2 hours (tissue damage)।","note":"Defence में hemorrhage, shock, और transfusion ज़रूरी हैं।"}$j$),
    (909, 'govt_defence', 'circ-def-formula', 'formula', 2, 'परिसंचरण तथ्य',
     $j${"formula":"Cardiac output = HR × SV ≈ 5 L/min · BP = CO × SVR · Shock: SBP <90 mmHg","explanation":"Blood volume: ~5L (70kg) · Blood loss >40% → severe shock · Tourniquet <2h"}$j$),
    (909, 'govt_defence', 'circ-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"70kg soldier 2L blood loss। % of total?","solution":"2L / 5L = 0.4","answer":"40% (severe shock)"}$j$),
    (909, 'govt_defence', 'circ-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Universal donor?","options":["A+","B+","AB+","O-"],"answer":3,"explanation":"O- (no antigens)"},{"q":"Tourniquet time limit?","options":["30 min","1 hour","2 hours","4 hours"],"answer":2,"explanation":"<2h (beyond → tissue necrosis)"}]}$j$),

    (910, 'govt_defence', 'trans-def-concept', 'concept', 1, 'पादप परिवहन — NDA/CDS',
     $j${"text":"Defence plant biology: camouflage (vegetation cover), food from plants (edible plants in survival), poisonous plants (identify for survival), water from plants (cactus in desert)। Xylem (water up), phloem (food down/up)। Transpiration affects water supply.","note":"Defence में survival botany और camouflage ज़रूरी हैं।"}$j$),
    (910, 'govt_defence', 'trans-def-formula', 'formula', 2, 'परिवहन तथ्य',
     $j${"formula":"Xylem: water + minerals (upward) · Phloem: sugars + AA (source→sink) · Transpiration pull = main ascent force","explanation":"Edible plants: coconut, banana, berries (safe) · Poisonous: hemlock, nightshade, oleander"}$j$),
    (910, 'govt_defence', 'trans-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Cactus से water कैसे?","solution":"Cactus stores water in stem tissue; collect by squeezing pulp","answer":"Stem pulp (emergency source)"}$j$),
    (910, 'govt_defence', 'trans-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Water transport पादप में?","options":["Xylem","Phloem","Both","None"],"answer":0,"explanation":"Xylem (upward)"},{"q":"Poisonous plant identify?","options":["Coconut","Hemlock","Banana","Mango"],"answer":1,"explanation":"Hemlock (highly toxic)"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[], 'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, count(*) from mtb.atoms
-- where chapter_id in (889,890,891,892,893,894,895,896,897,898,899,907,908,909,910)
--   and level_id='govt_defence' and status='published' and not archived
-- group by 1 order by 1;
-- Expected: each chapter = 4

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: 2028 + 60 = 2088
