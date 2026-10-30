with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ CLASS 9-10 CHEMISTRY (885-898) ═══
    (885, 'class_9_10', 'matter-910-concept', 'concept', 1, 'पदार्थ — Class 9-10',
     $j${"text":"Matter की 3 अवस्थाएँ: solid (निश्चित आकार + आयतन), liquid (निश्चित आयतन, आकार नहीं), gas (कोई निश्चित नहीं)। Solid में particles closely packed, gas में बहुत दूर। State change: melting, boiling, sublimation, condensation, freezing।","note":"Board में state changes के नाम और examples ज़रूरी हैं।"}$j$),
    (885, 'class_9_10', 'matter-910-formula', 'formula', 2, 'पदार्थ तथ्य',
     $j${"formula":"Solid → Liquid: melting · Liquid → Gas: boiling/evaporation · Solid → Gas: sublimation · Gas → Liquid: condensation","explanation":"Water: 0°C melting, 100°C boiling (at 1 atm) · Density: solid > liquid > gas (usually)"}$j$),
    (885, 'class_9_10', 'matter-910-example', 'example', 3, 'Board numerical',
     $j${"question":"बर्फ का पिघलना कौन सा change?","solution":"Solid → Liquid","answer":"Melting (fusion)"}$j$),
    (885, 'class_9_10', 'matter-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Gas → Liquid क्या कहलाता है?","options":["Melting","Condensation","Boiling","Sublimation"],"answer":1,"explanation":"Condensation (gas to liquid)"},{"q":"Solid में particles?","options":["बहुत दूर","Closely packed","Random","कोई नहीं"],"answer":1,"explanation":"Solid = closely packed, fixed positions"}]}$j$),

    (886, 'class_9_10', 'atom-910-concept', 'concept', 1, 'परमाणु संरचना — Class 9-10',
     $j${"text":"Atom: smallest particle of element। Structure: nucleus (protons + neutrons) + electrons (orbiting)। Proton +ve, neutron neutral, electron -ve। Atomic number = protons। Mass number = protons + neutrons। Isotopes: same protons, different neutrons (e.g., H, D, T)। Valency: combining capacity।","note":"Board में atomic number, mass number, और isotopes ज़रूरी हैं।"}$j$),
    (886, 'class_9_10', 'atom-910-formula', 'formula', 2, 'परमाणु तथ्य',
     $j${"formula":"Atomic number (Z) = protons · Mass number (A) = protons + neutrons · Neutrons = A - Z","explanation":"H: Z=1, A=1 (1p, 0n) · C: Z=6, A=12 (6p, 6n) · O: Z=8, A=16 (8p, 8n)"}$j$),
    (886, 'class_9_10', 'atom-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Atom: Z=11, A=23। Neutrons?","solution":"n = A - Z = 23 - 11","answer":"12 neutrons (Sodium)"}$j$),
    (886, 'class_9_10', 'atom-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Atomic number = ?","options":["Protons","Protons + neutrons","Neutrons","Electrons only"],"answer":0,"explanation":"Z = number of protons"},{"q":"Isotopes में अंतर?","options":["Protons","Neutrons","Electrons","Charge"],"answer":1,"explanation":"Isotopes: same protons, different neutrons"}]}$j$),

    (887, 'class_9_10', 'periodic-910-concept', 'concept', 1, 'आवर्त सारणी — Class 9-10',
     $j${"text":"Periodic Table: elements atomic number के order में। Groups (vertical, similar properties), Periods (horizontal)। Metals (left), non-metals (right), metalloids (border)। Group 1: alkali metals (Li, Na, K)। Group 17: halogens (F, Cl, Br, I)। Group 18: noble gases (He, Ne, Ar)।","note":"Board में group names और metal/non-metal position ज़रूरी हैं।"}$j$),
    (887, 'class_9_10', 'periodic-910-formula', 'formula', 2, 'आवर्त सारणी तथ्य',
     $j${"formula":"Group 1 = alkali metals · Group 2 = alkaline earth · Group 17 = halogens · Group 18 = noble gases","explanation":"Metals: left side (groups 1-12 mostly) · Non-metals: right (13-17 except metalloids) · Metalloids: B, Si, Ge, As, Sb, Te"}$j$),
    (887, 'class_9_10', 'periodic-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Na किस group में?","solution":"Sodium (Na) = alkali metal → Group 1","answer":"Group 1 (alkali metal)"}$j$),
    (887, 'class_9_10', 'periodic-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Noble gases किस group?","options":["1","2","17","18"],"answer":3,"explanation":"Group 18 = noble gases"},{"q":"Halogens किस group?","options":["1","17","18","2"],"answer":1,"explanation":"Group 17 = halogens (F, Cl, Br, I)"}]}$j$),

    (888, 'class_9_10', 'bond-910-concept', 'concept', 1, 'रासायनिक आबंधन — Class 9-10',
     $j${"text":"Chemical bond: atoms के बीच force जो molecule बनाता है। Ionic bond: metal + non-metal (electron transfer), e.g., NaCl। Covalent bond: non-metal + non-metal (electron sharing), e.g., H₂O, CH₄। Metallic bond: metal atoms (electron sea)। Ionic compounds: high melting point, conduct in solution।","note":"Board में ionic vs covalent और उनके properties ज़रूरी हैं।"}$j$),
    (888, 'class_9_10', 'bond-910-formula', 'formula', 2, 'आबंध सूत्र',
     $j${"formula":"Ionic: Na⁺ + Cl⁻ → NaCl · Covalent: H + H → H₂ (shared pair) · H₂O: O shares with 2 H","explanation":"Ionic: high mp, conduct in solution · Covalent: low mp, don't conduct (except acid/base/ionic after reaction)"}$j$),
    (888, 'class_9_10', 'bond-910-example', 'example', 3, 'Board numerical',
     $j${"question":"NaCl में bonding?","solution":"Na (metal) + Cl (non-metal) = ionic","answer":"Ionic bond"}$j$),
    (888, 'class_9_10', 'bond-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"H₂O में bonding?","options":["Ionic","Covalent","Metallic","H-bond only"],"answer":1,"explanation":"H₂O = covalent (electron sharing)"},{"q":"Ionic compounds conduct in?","options":["Solid","Solution/melt","Gas","Never"],"answer":1,"explanation":"Ionic conduct in solution or molten state"}]}$j$),

    (889, 'class_9_10', 'chem-react-910-concept', 'concept', 1, 'अभिक्रियाएँ — Class 9-10',
     $j${"text":"Chemical reaction: reactants → products। Types: combination (A+B→AB), decomposition (AB→A+B), displacement (A+BC→AC+B), double displacement (AB+CD→AD+CB), redox (oxidation-reduction)। Balancing equations: same atoms on both sides। Signs: color change, gas, temperature, precipitate।","note":"Board में reaction types और balancing ज़रूरी हैं।"}$j$),
    (889, 'class_9_10', 'chem-react-910-formula', 'formula', 2, 'अभिक्रिया सूत्र',
     $j${"formula":"Combination: 2H₂ + O₂ → 2H₂O · Decomposition: CaCO₃ → CaO + CO₂ · Displacement: Zn + CuSO₄ → ZnSO₄ + Cu · Double displacement: AgNO₃ + NaCl → AgCl↓ + NaNO₃","explanation":"Balancing: count atoms both sides, adjust coefficients · CaO + CO₂: calcium oxide + carbon dioxide"}$j$),
    (889, 'class_9_10', 'chem-react-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Zn + HCl → ?","solution":"Zn + 2HCl → ZnCl₂ + H₂↑","answer":"Zinc chloride + hydrogen gas"}$j$),
    (889, 'class_9_10', 'chem-react-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"A+B → AB कौन सी reaction?","options":["Combination","Decomposition","Displacement","Double displacement"],"answer":0,"explanation":"Combination (two → one)"},{"q":"CaCO₃ → CaO + CO₂ ?","options":["Combination","Decomposition","Redox","None"],"answer":1,"explanation":"Decomposition (one → two)"}]}$j$),

    (890, 'class_9_10', 'redox-910-concept', 'concept', 1, 'रेडॉक्स — Class 9-10',
     $j${"text":"Oxidation: gain of oxygen/loss of hydrogen/loss of electrons। Reduction: loss of oxygen/gain of hydrogen/gain of electrons। OIL RIG (Oxidation Is Loss, Reduction Is Gain of electrons)। Redox reaction: oxidation + reduction together। Examples: rusting, combustion, respiration।","note":"Board में oxidation-reduction definitions और OIL RIG ज़रूरी हैं।"}$j$),
    (890, 'class_9_10', 'redox-910-formula', 'formula', 2, 'रेडॉक्स सूत्र',
     $j${"formula":"Oxidation: loss of e⁻ (OIL) · Reduction: gain of e⁻ (RIG) · Redox: both together","explanation":"Rusting: 4Fe + 3O₂ → 2Fe₂O₃ (Fe oxidized) · Combustion: C + O₂ → CO₂ (C oxidized)"}$j$),
    (890, 'class_9_10', 'redox-910-example', 'example', 3, 'Board numerical',
     $j${"question":"2Mg + O₂ → 2MgO में oxidized कौन?","solution":"Mg: 0 → +2 (loses electrons)","answer":"Mg oxidized (Mg → Mg²⁺)"}$j$),
    (890, 'class_9_10', 'redox-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Oxidation = ?","options":["Gain e⁻","Loss e⁻","Gain oxygen","Loss H"],"answer":1,"explanation":"Oxidation = loss of electrons (OIL)"},{"q":"Reduction = ?","options":["Loss e⁻","Gain e⁻","Loss H","Gain O"],"answer":1,"explanation":"Reduction = gain of electrons (RIG)"}]}$j$),

    (891, 'class_9_10', 'acid-910-concept', 'concept', 1, 'अम्ल-क्षार — Class 9-10',
     $j${"text":"Acids: sour, turn blue litmus red, pH < 7 (HCl, H₂SO₄, CH₃COOH)। Bases: bitter, slippery, turn red litmus blue, pH > 7 (NaOH, KOH, Ca(OH)₂)। Salt: acid + base → salt + water (neutralization)। pH scale: 0-14, 7 neutral। Indicators: litmus, methyl orange, phenolphthalein।","note":"Board में pH scale, neutralization, और indicators ज़रूरी हैं।"}$j$),
    (891, 'class_9_10', 'acid-910-formula', 'formula', 2, 'अम्ल-क्षार सूत्र',
     $j${"formula":"Acid + Base → Salt + Water (neutralization) · pH < 7 acidic, = 7 neutral, > 7 basic · HCl + NaOH → NaCl + H₂O","explanation":"Strong acid: HCl, HNO₃, H₂SO₄ · Weak: CH₃COOH, H₂CO₃ · Strong base: NaOH, KOH · Weak: NH₄OH"}$j$),
    (891, 'class_9_10', 'acid-910-example', 'example', 3, 'Board numerical',
     $j${"question":"HCl + NaOH → ?","solution":"Neutralization: acid + base","answer":"NaCl + H₂O (salt + water)"}$j$),
    (891, 'class_9_10', 'acid-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"pH = 7 का मतलब?","options":["Acidic","Basic","Neutral","Zero"],"answer":2,"explanation":"pH 7 = neutral (pure water)"},{"q":"Acid litmus को क्या करता है?","options":["Red → Blue","Blue → Red","कोई बदलाव नहीं","Green"],"answer":1,"explanation":"Acid: blue litmus → red"}]}$j$),

    (892, 'class_9_10', 'metal-910-concept', 'concept', 1, 'धातु-अधातु — Class 9-10',
     $j${"text":"Metals: shiny, malleable, ductile, good conductors, sonorous (Fe, Cu, Al, Au)। Non-metals: dull, brittle, poor conductors (S, P, C, O)। Metalloids: properties of both (B, Si, Ge)। Reactivity series: K > Na > Ca > Mg > Al > Zn > Fe > Cu > Ag > Au। Displacement: more reactive displaces less reactive।","note":"Board में reactivity series और displacement ज़रूरी हैं।"}$j$),
    (892, 'class_9_10', 'metal-910-formula', 'formula', 2, 'धातु सूत्र',
     $j${"formula":"Reactivity: K > Na > Ca > Mg > Al > Zn > Fe > Cu > Ag > Au · More reactive displaces less reactive from salt solution","explanation":"Zn + CuSO₄ → ZnSO₄ + Cu (Zn more reactive than Cu) · Cu + ZnSO₄ → no reaction (Cu less reactive)"}$j$),
    (892, 'class_9_10', 'metal-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Fe + CuSO₄ → ?","solution":"Fe more reactive than Cu → displaces","answer":"FeSO₄ + Cu (displacement)"}$j$),
    (892, 'class_9_10', 'metal-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"सबसे reactive metal?","options":["Fe","Cu","K","Au"],"answer":2,"explanation":"K (potassium) - top of reactivity series"},{"q":"Cu + ZnSO₄ → ?","options":["CuSO₄ + Zn","No reaction","Zn + Cu","CuO"],"answer":1,"explanation":"Cu less reactive → no displacement"}]}$j$),

    (893, 'class_9_10', 'carbon-910-concept', 'concept', 1, 'कार्बन — Class 9-10',
     $j${"text":"Carbon: tetravalent (4 bonds)। Allotropes: diamond (hard, 3D), graphite (soft, layers), fullerene (C₆₀)। Hydrocarbons: alkanes (single bonds, CₙH₂ₙ₊₂), alkenes (double, CₙH₂ₙ), alkynes (triple, CₙH₂ₙ₋₂)। Functional groups: -OH (alcohol), -COOH (acid), -CHO (aldehyde)।","note":"Board में allotropes और hydrocarbon types ज़रूरी हैं।"}$j$),
    (893, 'class_9_10', 'carbon-910-formula', 'formula', 2, 'कार्बन सूत्र',
     $j${"formula":"Alkane: CₙH₂ₙ₊₂ · Alkene: CₙH₂ₙ · Alkyne: CₙH₂ₙ₋₂","explanation":"CH₄ (methane) · C₂H₆ (ethane) · C₂H₄ (ethene, alkene) · C₂H₂ (ethyne, alkyne)"}$j$),
    (893, 'class_9_10', 'carbon-910-example', 'example', 3, 'Board numerical',
     $j${"question":"C₃H₈ कौन सा hydrocarbon?","solution":"CₙH₂ₙ₊₂ → n=3, H=2×3+2=8","answer":"Alkane (propane)"}$j$),
    (893, 'class_9_10', 'carbon-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"सबसे hard allotrope?","options":["Graphite","Diamond","Fullerene","Coal"],"answer":1,"explanation":"Diamond - hardest natural substance"},{"q":"C₂H₄ कौन सा?","options":["Alkane","Alkene","Alkyne","Aromatic"],"answer":1,"explanation":"C₂H₄ = ethene (alkene, double bond)"}]}$j$),

    (894, 'class_9_10', 'sol-910-concept', 'concept', 1, 'विलयन — Class 9-10',
     $j${"text":"Solution: solute + solvent (homogeneous)। Types: dilute (कम solute), concentrated (ज़्यादा), saturated (और dissolve नहीं), unsaturated (और dissolve कर सकता)। Solubility: किसी temperature पर max solute। Factors: temperature, pressure (gas)। Suspension vs colloid vs solution (particle size)।","note":"Board में solute/solvent और types of solutions ज़रूरी हैं।"}$j$),
    (894, 'class_9_10', 'sol-910-formula', 'formula', 2, 'विलयन सूत्र',
     $j${"formula":"Mass % = (mass solute/mass solution) × 100 · Solubility = g solute per 100 g solvent","explanation":"Solution: transparent, particles <1 nm · Colloid: translucent, 1-1000 nm · Suspension: opaque, >1000 nm"}$j$),
    (894, 'class_9_10', 'sol-910-example', 'example', 3, 'Board numerical',
     $j${"question":"20g sugar + 80g water। Mass%?","solution":"Mass% = 20/(20+80) × 100","answer":"20%"}$j$),
    (894, 'class_9_10', 'sol-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Solute + solvent = ?","options":["Element","Compound","Solution","Mixture only"],"answer":2,"explanation":"Solute + solvent = solution (homogeneous)"},{"q":"Saturated solution?","options":["और dissolve कर सकता","और नहीं","Dilute","Pure"],"answer":1,"explanation":"Saturated: और solute dissolve नहीं होगा"}]}$j$),

    (895, 'class_9_10', 'electro-910-concept', 'concept', 1, 'विद्युत रसायन — Class 9-10',
     $j${"text":"Electrolysis: electric current से chemical change। Electrolyte: conduct current in solution (acid/base/salt)। Electrodes: anode (+), cathode (-)। Cations → cathode (reduction), anions → anode (oxidation)। Applications: electroplating, purification (Cu refining), electrolysis of water (H₂ + O₂)।","note":"Board में electrolysis, anode/cathode, और applications ज़रूरी हैं।"}$j$),
    (895, 'class_9_10', 'electro-910-formula', 'formula', 2, 'विद्युत रसायन सूत्र',
     $j${"formula":"Cathode (reduction): Cu²⁺ + 2e⁻ → Cu · Anode (oxidation): 2H₂O → O₂ + 4H⁺ + 4e⁻ · 2H₂O → 2H₂ + O₂","explanation":"Electroplating: object at cathode (metal deposited) · Cu refining: pure Cu at cathode, impure at anode"}$j$),
    (895, 'class_9_10', 'electro-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Electrolysis of water में cathode पर?","solution":"H₂ gas (reduction)","answer":"Hydrogen (H₂) at cathode"}$j$),
    (895, 'class_9_10', 'electro-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Cathode पर क्या होता है?","options":["Oxidation","Reduction","Neutral","कोई नहीं"],"answer":1,"explanation":"Cathode = reduction (gain electrons)"},{"q":"Electroplating में object?","options":["Anode","Cathode","Solution","None"],"answer":1,"explanation":"Object = cathode (metal deposits)"}]}$j$),

    (896, 'class_9_10', 'fuel-910-concept', 'concept', 1, 'ईंधन-दहन — Class 9-10',
     $j${"text":"Fuel: burning से energy दे। Types: solid (coal, wood), liquid (petrol, diesel), gas (LPG, CNG)। Combustion: fuel + O₂ → CO₂ + H₂O + heat + light। Complete vs incomplete combustion। Incomplete: CO (toxic)। Calorific value: energy per unit (kJ/kg)। Fire triangle: fuel + O₂ + heat।","note":"Board में combustion और fire triangle ज़रूरी हैं।"}$j$),
    (896, 'class_9_10', 'fuel-910-formula', 'formula', 2, 'ईंधन सूत्र',
     $j${"formula":"CH₄ + 2O₂ → CO₂ + 2H₂O + heat · Complete: CO₂ + H₂O · Incomplete: CO + H₂O","explanation":"Fire triangle: fuel + oxygen + heat · Fire extinguisher: remove any one (CO₂ removes O₂)"}$j$),
    (896, 'class_9_10', 'fuel-910-example', 'example', 3, 'Board numerical',
     $j${"question":"CH₄ के पूर्ण combustion में product?","solution":"CH₄ + 2O₂ → CO₂ + 2H₂O + heat","answer":"CO₂ + H₂O + heat"}$j$),
    (896, 'class_9_10', 'fuel-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Incomplete combustion से?","options":["CO₂","CO (toxic)","H₂O","O₂"],"answer":1,"explanation":"Incomplete: CO + H₂O (carbon monoxide toxic)"},{"q":"Fire triangle में नहीं है?","options":["Fuel","Oxygen","Heat","Water"],"answer":3,"explanation":"Fire triangle: fuel, oxygen, heat (water नहीं)"}]}$j$),

    (897, 'class_9_10', 'poly-910-concept', 'concept', 1, 'बहुलक — Class 9-10',
     $j${"text":"Polymer: बड़ा molecule, small monomers से बना। Natural: cotton (cellulose), wool (protein), silk, rubber (isoprene)। Synthetic: polythene (ethene), PVC (vinyl chloride), nylon (polyamide), bakelite (phenol + formaldehyde), terylene (polyester)। Addition vs condensation polymerization।","note":"Board में natural/synthetic polymers और उनके monomers ज़रूरी हैं।"}$j$),
    (897, 'class_9_10', 'poly-910-formula', 'formula', 2, 'बहुलक सूत्र',
     $j${"formula":"Polythene: n CH₂=CH₂ → [-CH₂-CH₂-]ₙ · Nylon: diamine + diacid · Bakelite: phenol + formaldehyde","explanation":"Thermoplastic: soften on heating (polythene, PVC) · Thermoset: don't soften (bakelite)"}$j$),
    (897, 'class_9_10', 'poly-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Polythene का monomer?","solution":"Ethene (CH₂=CH₂)","answer":"Ethene (ethylene)"}$j$),
    (897, 'class_9_10', 'poly-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Nylon किसका polymer?","options":["Ethene","Vinyl chloride","Diamine + diacid","Styrene"],"answer":2,"explanation":"Nylon = polyamide (diamine + diacid)"},{"q":"Thermoset polymer?","options":["Polythene","PVC","Bakelite","Nylon"],"answer":2,"explanation":"Bakelite = thermoset (doesn't soften)"}]}$j$),

    (898, 'class_9_10', 'corr-910-concept', 'concept', 1, 'संक्षारण — Class 9-10',
     $j${"text":"Corrosion: metal का surface damage (oxygen/moisture से)। Rusting: iron + O₂ + H₂O → hydrated iron oxide (Fe₂O₃·xH₂O)। Rusting के लिए O₂ + moisture ज़रूरी। Prevention: painting, oiling, galvanization (Zn coating), alloying (stainless steel), electroplating।","note":"Board में rusting conditions और prevention ज़रूरी हैं।"}$j$),
    (898, 'class_9_10', 'corr-910-formula', 'formula', 2, 'संक्षारण सूत्र',
     $j${"formula":"Rust: 4Fe + 3O₂ + xH₂O → 2Fe₂O₃·xH₂O · Conditions: O₂ + moisture बोथ ज़रूरी","explanation":"Galvanization: Zn coating (Zn corrodes first, protects Fe) · Stainless steel: Fe + Cr + Ni + C"}$j$),
    (898, 'class_9_10', 'corr-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Galvanization में कौन metal?","solution":"Zinc (Zn) coating on iron","answer":"Zinc (Zn)"}$j$),
    (898, 'class_9_10', 'corr-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Rusting के लिए ज़रूरी?","options":["Only O₂","Only H₂O","Both O₂ + moisture","CO₂"],"answer":2,"explanation":"Both O₂ and moisture (water)"},{"q":"Galvanization में?","options":["Cu coating","Zn coating","Ag coating","Au coating"],"answer":1,"explanation":"Galvanization = Zn coating"}]}$j$),

    -- ═══ CLASS 9-10 BIOLOGY (901-906) ═══
    (901, 'class_9_10', 'cell-910-concept', 'concept', 1, 'कोशिका — Class 9-10',
     $j${"text":"Cell: basic structural and functional unit। Cell theory: all living things made of cells। Types: prokaryotic (no nucleus — bacteria) vs eukaryotic (nucleus — plant, animal)। Plant cell: cell wall, chloroplast, large vacuole। Animal cell: no cell wall, no chloroplast, small vacuoles। Cell organelles: nucleus, mitochondria, ribosome, ER, Golgi, lysosome।","note":"Board में plant vs animal cell और organelles ज़रूरी हैं।"}$j$),
    (901, 'class_9_10', 'cell-910-formula', 'formula', 2, 'कोशिका तथ्य',
     $j${"formula":"Nucleus = control center · Mitochondria = powerhouse · Ribosome = protein synthesis · Chloroplast = photosynthesis · Lysosome = digestion","explanation":"Plant cell: cell wall + chloroplast + large vacuole · Animal cell: no cell wall, centriole present"}$j$),
    (901, 'class_9_10', 'cell-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Plant cell में कौन सा organelle animal cell में नहीं?","solution":"Chloroplast (photosynthesis) + large central vacuole","answer":"Chloroplast"}$j$),
    (901, 'class_9_10', 'cell-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Powerhouse of cell?","options":["Nucleus","Mitochondria","Ribosome","Golgi"],"answer":1,"explanation":"Mitochondria = ATP production"},{"q":"Plant cell में unique?","options":["Nucleus","Mitochondria","Chloroplast","Ribosome"],"answer":2,"explanation":"Chloroplast (photosynthesis) - only in plant cell"}]}$j$),

    (902, 'class_9_10', 'bio-tissues-910-concept', 'concept', 1, 'ऊतक — Class 9-10',
     $j${"text":"Tissue: similar cells का group जो specific function करता है। Plant: meristematic (growth), parenchyma (storage), collenchyma (support), sclerenchyma (hard), xylem (water), phloem (food)। Animal: epithelial (covering), connective (blood, bone), muscular (movement), nervous (control)।","note":"Board में plant vs animal tissue और types ज़रूरी हैं।"}$j$),
    (902, 'class_9_10', 'bio-tissues-910-formula', 'formula', 2, 'ऊतक तथ्य',
     $j${"formula":"Plant: meristem (growth) · parenchyma (storage) · xylem (water up) · phloem (food)","explanation":"Animal: epithelial (cover) · connective (blood/bone) · muscular (movement) · nervous (signal)"}$j$),
    (902, 'class_9_10', 'bio-tissues-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Blood किस tissue?","solution":"Fluid connective tissue","answer":"Connective tissue"}$j$),
    (902, 'class_9_10', 'bio-tissues-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Xylem का function?","options":["Food transport","Water transport","Growth","Support"],"answer":1,"explanation":"Xylem = water + minerals (upward)"},{"q":"Blood किस tissue type?","options":["Epithelial","Connective","Muscular","Nervous"],"answer":1,"explanation":"Blood = fluid connective tissue"}]}$j$),

    (903, 'class_9_10', 'bio-animal-910-concept', 'concept', 1, 'जंतु जगत — Class 9-10',
     $j${"text":"Animal kingdom: multicellular, heterotrophic। Main phyla: Porifera (sponges), Cnidaria (hydra, jellyfish), Platyhelminthes (flatworms), Nematoda (roundworms), Annelida (earthworm), Arthropoda (insects, largest), Mollusca (snails, octopus), Echinodermata (starfish), Chordata (vertebrates)। Symmetry: radial vs bilateral।","note":"Board में phyla examples और symmetry ज़रूरी हैं।"}$j$),
    (903, 'class_9_10', 'bio-animal-910-formula', 'formula', 2, 'जंतु तथ्य',
     $j${"formula":"Porifera: cellular level · Cnidaria: tissue level · Arthropoda: largest phylum · Chordata: notochord present","explanation":"Radial symmetry: Cnidaria, adult Echinodermata · Bilateral: most animals"}$j$),
    (903, 'class_9_10', 'bio-animal-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Earthworm किस phylum?","solution":"Segmented body, true coelom","answer":"Annelida"}$j$),
    (903, 'class_9_10', 'bio-animal-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"सबसे बड़ा phylum?","options":["Chordata","Mollusca","Arthropoda","Annelida"],"answer":2,"explanation":"Arthropoda (insects) - largest phylum"},{"q":"Starfish किस phylum?","options":["Mollusca","Echinodermata","Cnidaria","Porifera"],"answer":1,"explanation":"Starfish = Echinodermata"}]}$j$),

    (904, 'class_9_10', 'bio-plant-910-concept', 'concept', 1, 'पादप जगत — Class 9-10',
     $j${"text":"Plant kingdom: autotrophic (photosynthesis)। Groups: algae (aquatic, thalloid), bryophytes (amphibians of plant kingdom, no vascular), pteridophytes (first vascular, fern), gymnosperms (naked seeds, pine), angiosperms (flowering, enclosed seeds)। Angiosperms: monocot (1 cotyledon) vs dicot (2 cotyledons)।","note":"Board में plant groups और monocot/dicot ज़रूरी हैं।"}$j$),
    (904, 'class_9_10', 'bio-plant-910-formula', 'formula', 2, 'पादप तथ्य',
     $j${"formula":"Algae → Bryophytes (no vascular) → Pteridophytes (vascular, no seed) → Gymnosperms (naked seed) → Angiosperms (flower)","explanation":"Monocot: 1 cotyledon, parallel venation, fibrous root · Dicot: 2 cotyledons, reticulate venation, tap root"}$j$),
    (904, 'class_9_10', 'bio-plant-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Fern किस group?","solution":"Vascular, no seed → Pteridophytes","answer":"Pteridophytes"}$j$),
    (904, 'class_9_10', 'bio-plant-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Amphibians of plant kingdom?","options":["Algae","Bryophytes","Pteridophytes","Gymnosperms"],"answer":1,"explanation":"Bryophytes (need water for reproduction)"},{"q":"Monocot में cotyledon?","options":["0","1","2","Many"],"answer":1,"explanation":"Monocot = 1 cotyledon"}]}$j$),

    (905, 'class_9_10', 'bio-nutrition-910-concept', 'concept', 1, 'पोषण — Class 9-10',
     $j${"text":"Nutrition: autotrophic (photosynthesis — plants) vs heterotrophic (animals, fungi)। Types of heterotrophic: holozoic (ingestion — amoeba, humans), saprophytic (dead matter — fungi), parasitic (host — tapeworm), symbiotic (mutual benefit — lichen)। Human digestion: mouth → esophagus → stomach → small intestine → large intestine।","note":"Board में nutrition types और digestive system ज़रूरी हैं।"}$j$),
    (905, 'class_9_10', 'bio-nutrition-910-formula', 'formula', 2, 'पोषण तथ्य',
     $j${"formula":"Autotrophic: photosynthesis (CO₂ + H₂O + light → glucose + O₂) · Heterotrophic: holozoic, saprophytic, parasitic, symbiotic","explanation":"Human digestive order: mouth → esophagus → stomach → small intestine → large intestine → anus"}$j$),
    (905, 'class_9_10', 'bio-nutrition-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Amoeba किस type का nutrition?","solution":"Ingestion of food particles (phagocytosis)","answer":"Holozoic (ingestion)"}$j$),
    (905, 'class_9_10', 'bio-nutrition-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Fungi किस type?","options":["Autotrophic","Holozoic","Saprophytic","Parasitic"],"answer":2,"explanation":"Fungi = saprophytic (dead matter)"},{"q":"Photosynthesis में product?","options":["CO₂ + H₂O","Glucose + O₂","Protein","Fat"],"answer":1,"explanation":"Glucose + O₂ (from CO₂ + H₂O + light)"}]}$j$),

    (906, 'class_9_10', 'photo-910-concept', 'concept', 1, 'प्रकाश संश्लेषण — Class 9-10',
     $j${"text":"Photosynthesis: green plants sunlight से food बनाते हैं। Equation: 6CO₂ + 6H₂O + light → C₆H₁₂O₆ + 6O₂। Chlorophyll (green pigment) sunlight absorb करता है। Chloroplast में होता है। Light + dark reaction। Stomata से CO₂ intake, O₂ release।","note":"Board में photosynthesis equation, chlorophyll, और stomata ज़रूरी हैं।"}$j$),
    (906, 'class_9_10', 'photo-910-formula', 'formula', 2, 'प्रकाश संश्लेषण सूत्र',
     $j${"formula":"6CO₂ + 6H₂O + light (chlorophyll) → C₆H₁₂O₆ + 6O₂","explanation":"Light reaction: thylakoid · Dark reaction: stroma (Calvin cycle) · Chlorophyll = green pigment"}$j$),
    (906, 'class_9_10', 'photo-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Photosynthesis में O₂ कहाँ से?","solution":"Light reaction में PSII पर water split होता है (photolysis)","answer":"Water photolysis: 2H₂O → O₂ + 4H⁺ + 4e⁻"}$j$),
    (906, 'class_9_10', 'photo-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Photosynthesis कहाँ होता है?","options":["Mitochondria","Chloroplast","Nucleus","Ribosome"],"answer":1,"explanation":"Chloroplast (contains chlorophyll)"},{"q":"Green pigment?","options":["Carotene","Chlorophyll","Xanthophyll","Anthocyanin"],"answer":1,"explanation":"Chlorophyll (green)"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], array['class_9', 'class_10']::text[], 'general-science', 'easy', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, count(*) from mtb.atoms 
-- where chapter_id in (885,886,887,888,889,890,891,892,893,894,895,896,897,898,901,902,903,904,905,906) 
--   and level_id='class_9_10' and status='published' and not archived 
-- group by 1 order by 1;
-- Expected: each chapter = 4

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: 1299 + 80 = 1379