with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ ENGINEERING CHEMISTRY (890-899) ═══
    (890, 'engineering', 'redox-eng-concept', 'concept', 1, 'रेडॉक्स — JEE',
     $j${"text":"Oxidation number rules, balancing redox (ion-electron method, oxidation number method)। Acidic vs basic medium balancing। Disproportionation reactions। Standard electrode potential E°। Electrochemical series।","note":"JEE में redox balancing और E° से spontaneity ज़रूरी है।"}$j$),
    (890, 'engineering', 'redox-eng-formula', 'formula', 2, 'रेडॉक्स सूत्र',
     $j${"formula":"Oxidation: ↑ ox state · Reduction: ↓ ox state · E°_cell = E°_cathode - E°_anode · ΔG° = -nFE°","explanation":"Balancing in acidic: add H⁺/H₂O · Basic: add OH⁻/H₂O · F = 96500 C/mol"}$j$),
    (890, 'engineering', 'redox-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"Zn + Cu²⁺ → Zn²⁺ + Cu। E°_cell? (E°_Zn²⁺/Zn=-0.76, Cu²⁺/Cu=+0.34)","solution":"E°_cell = E°_cathode - E°_anode = 0.34 - (-0.76)","answer":"E°_cell = 1.10 V (spontaneous, ΔG<0)"}$j$),
    (890, 'engineering', 'redox-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"KMnO₄ में Mn का oxidation state (acidic)?","options":["+2","+4","+6","+7"],"answer":3,"explanation":"KMnO₄: K=+1, O=-2×4=-8 → Mn = +7"},{"q":"ΔG° और E°_cell का relation?","options":["ΔG° = nFE°","ΔG° = -nFE°","ΔG° = -E°/nF","ΔG° = nF/E°"],"answer":1,"explanation":"ΔG° = -nFE°"}]}$j$),

    (891, 'engineering', 'acid-eng-concept', 'concept', 1, 'अम्ल-क्षार — JEE',
     $j${"text":"Bronsted-Lowry (proton donor/acceptor), Lewis (electron pair acceptor)। pH, pOH, pKw=14 (25°C)। Strong vs weak acids (Ka, Kb)। Salt hydrolysis (acidic, basic, neutral)। Buffer (Henderson-Hasselbalch)। Solubility product Ksp, common ion effect। Polyprotic acids।","note":"JEE में buffer, Ksp, और salt hydrolysis ज़रूरी हैं।"}$j$),
    (891, 'engineering', 'acid-eng-formula', 'formula', 2, 'अम्ल-क्षार सूत्र',
     $j${"formula":"pH = -log[H⁺] · pH + pOH = 14 · Ka·Kb = Kw = 10⁻¹⁴ · Henderson: pH = pKa + log([salt]/[acid]) · Ksp = [A⁺][B⁻]","explanation":"Weak acid: [H⁺] = √(Ka·C) · Buffer capacity max at pH = pKa"}$j$),
    (891, 'engineering', 'acid-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"0.1 M acetic acid, Ka=1.8×10⁻⁵। pH?","solution":"[H⁺] = √(Ka·C) = √(1.8×10⁻⁵ × 0.1) = √(1.8×10⁻⁶) = 1.34×10⁻³","answer":"pH ≈ 2.87"}$j$),
    (891, 'engineering', 'acid-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"Buffer capacity max कब?","options":["pH = 7","pH = pKa","pH = 14","pH = 0"],"answer":1,"explanation":"Buffer max at pH = pKa"},{"q":"Strong acid pH 0.001 M?","options":["1","2","3","4"],"answer":2,"explanation":"pH = -log(10⁻³) = 3"}]}$j$),

    (892, 'engineering', 'metal-eng-concept', 'concept', 1, 'धातु-अधातु — JEE',
     $j${"text":"Metallurgy: concentration (froth flotation, magnetic, leaching), roasting (sulfide→oxide), calcination (carbonate→oxide), reduction (C, CO, Al, electrolysis)। Ellingham diagram। Alloys (steel, brass, bronze)। Non-metals: S, P, halogens, noble gases। Inert pair effect।","note":"JEE में extraction methods और Ellingham ज़रूरी हैं।"}$j$),
    (892, 'engineering', 'metal-eng-formula', 'formula', 2, 'धातुकर्म सूत्र',
     $j${"formula":"Roasting: 2ZnS + 3O₂ → 2ZnO + 2SO₂ · Calcination: CaCO₃ → CaO + CO₂ · Reduction: ZnO + C → Zn + CO","explanation":"Ellingham: ΔG vs T; lower curve = more stable oxide · Aluminothermic: thermite (Fe₂O₃ + 2Al)"}$j$),
    (892, 'engineering', 'metal-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"Bauxite (Al₂O₃) से Al कैसे निकालते हैं?","solution":"Hall-Héroult: Al₂O₃ + cryolite → electrolysis → Al at cathode","answer":"Electrolytic reduction (molten Al₂O₃ in cryolite)"}$j$),
    (892, 'engineering', 'metal-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"Froth flotation किसके लिए?","options":["Oxide ores","Sulphide ores","Carbonate ores","All ores"],"answer":1,"explanation":"Froth flotation = sulphide ores (galena, sphalerite)"},{"q":"Thermite reaction?","options":["Fe₂O₃ + 2Al → Al₂O₃ + 2Fe","Fe + Al","Fe + O₂","Fe + C"],"answer":0,"explanation":"Thermite = highly exothermic Fe₂O₃ + Al"}]}$j$),

    (893, 'engineering', 'carbon-eng-concept', 'concept', 1, 'कार्बन — JEE',
     $j${"text":"Organic chemistry: IUPAC nomenclature, isomerism (chain, position, functional, geometrical, optical)। Reaction mechanisms: SN1, SN2, E1, E2, electrophilic addition, aromatic substitution (EAS)। Markovnikov's rule, anti-Markovnikov (peroxide effect)। Hybridization sp³/sp²/sp। Aromaticity (Huckel: 4n+2 π e⁻)।","note":"JEE में mechanisms और isomerism ज़रूरी हैं।"}$j$),
    (893, 'engineering', 'carbon-eng-formula', 'formula', 2, 'कार्बन सूत्र',
     $j${"formula":"SN2: rate = k[substrate][nucleophile] · SN1: rate = k[substrate] · EAS: benzene + E⁺ → σ-complex → product","explanation":"Markovnikov: H to carbon with more H · Peroxide: anti-Markovnikov · Huckel: 4n+2 aromatic"}$j$),
    (893, 'engineering', 'carbon-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"2-methylpropene + HBr (peroxide)। Major product?","solution":"Peroxide → anti-Markovnikov: Br to less substituted C","answer":"1-bromo-2-methylpropane"}$j$),
    (893, 'engineering', 'carbon-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"SN2 mechanism में stereochemistry?","options":["Retention","Inversion","Racemization","No change"],"answer":1,"explanation":"SN2 = Walden inversion"},{"q":"Benzene aromatic क्यों?","options":["6π e⁻ (4n+2)","4π e⁻","8π e⁻","10π e⁻"],"answer":0,"explanation":"6 π e⁻, Huckel 4n+2 (n=1)"}]}$j$),

    (894, 'engineering', 'sol-eng-concept', 'concept', 1, 'विलयन — JEE',
     $j${"text":"Colligative properties: relative lowering of VP, depression of freezing point (ΔT_f = Kf·m), elevation of BP (ΔT_b = Kb·m), osmotic pressure (π=iCRT)। van't Hoff factor i (electrolytes)। Raoult's law (ideal, non-ideal solutions)। Henry's law (gas solubility)। Azeotropes।","note":"JEE में colligative और van't Hoff factor ज़रूरी हैं।"}$j$),
    (894, 'engineering', 'sol-eng-formula', 'formula', 2, 'विलयन सूत्र',
     $j${"formula":"ΔT_f = i·Kf·m · ΔT_b = i·Kb·m · π = iCRT · Raoult: P = x_solvent·P° · Molality m = mol solute/kg solvent","explanation":"i = actual particles / formula units · Non-ideal: +ve dev (ΔH>0), -ve dev (ΔH<0)"}$j$),
    (894, 'engineering', 'sol-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"0.1 m NaCl (i=2), Kf=1.86। ΔT_f?","solution":"ΔT_f = i·Kf·m = 2 × 1.86 × 0.1","answer":"0.372 K (depression)"}$j$),
    (894, 'engineering', 'sol-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"Freezing point depression ∝?","options":["Mass","Molality","Volume","Density"],"answer":1,"explanation":"ΔT_f ∝ molality (m)"},{"q":"Positive deviation from Raoult?","options":["ΔH < 0","ΔH > 0","ΔH = 0","ΔV < 0"],"answer":1,"explanation":"Positive dev: ΔH > 0, weaker A-B interaction"}]}$j$),

    (895, 'engineering', 'electro-eng-concept', 'concept', 1, 'विद्युत रसायन — JEE',
     $j${"text":"Electrochemical cells (galvanic, electrolytic)। Nernst equation (E = E° - (RT/nF)lnQ)। Faraday's laws of electrolysis। Conductance, molar conductivity (Λm), Kohlrausch's law। Galvanic cell: anode oxidation, cathode reduction। Electrolysis of water, NaCl, CuSO₄। Batteries (dry cell, lead-acid, Li-ion)। Corrosion as electrochemical process।","note":"JEE में Nernst, electrolysis, और batteries ज़रूरी हैं।"}$j$),
    (895, 'engineering', 'electro-eng-formula', 'formula', 2, 'विद्युत रसायन सूत्र',
     $j${"formula":"Nernst: E = E° - (0.059/n)log Q (25°C) · Faraday: m = ZIt = (M/nF)It · Λm = κ/c · Kohlrausch: Λm° = ν₊λ₊° + ν₋λ₋°","explanation":"F = 96500 C/mol · Conductance G = 1/R · Cell EMF = E_cathode - E_anode"}$j$),
    (895, 'engineering', 'electro-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"Zn/Cu cell: E°=1.10V, [Zn²⁺]=1M, [Cu²⁺]=0.1M। E?","solution":"E = 1.10 - (0.059/2)log([Zn²⁺]/[Cu²⁺]) = 1.10 - 0.0295·log(10)","answer":"E = 1.07 V"}$j$),
    (895, 'engineering', 'electro-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"Nernst factor at 25°C?","options":["RT/F","0.059/n","2.303","0.059"],"answer":1,"explanation":"0.059/n (for log base 10)"},{"q":"Faraday constant?","options":["96500 C/mol","96485 C/mol","9650 C/mol","965 C/mol"],"answer":0,"explanation":"≈ 96500 C/mol (exact 96485)"}]}$j$),

    (896, 'engineering', 'fuel-eng-concept', 'concept', 1, 'ईंधन-दहन — JEE',
     $j${"text":"Fuels: classification (solid, liquid, gas), calorific value, combustion। Coal: types (peat, lignite, bituminous, anthracite)। Petroleum: fractional distillation। Octane number (petrol), cetane number (diesel)। Knocking, anti-knock agents (TEL)। Alternative fuels (LPG, CNG)। Combustion calculations: stoichiometry (O₂ required)।","note":"JEE में calorific value और combustion stoichiometry ज़रूरी हैं।"}$j$),
    (896, 'engineering', 'fuel-eng-formula', 'formula', 2, 'ईंधन सूत्र',
     $j${"formula":"Combustion: CₓHᵧ + (x + y/4)O₂ → x CO₂ + (y/2)H₂O · Calorific value (kJ/kg or kJ/m³)","explanation":"Octane number: iso-octane=100, n-heptane=0 (petrol) · Cetane: hexadecane=100 (diesel)"}$j$),
    (896, 'engineering', 'fuel-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"CH₄ के 1 mole combustion के लिए O₂?","solution":"CH₄ + 2O₂ → CO₂ + 2H₂O। x=1, y=4 → O₂ = 1 + 4/4 = 2","answer":"2 moles O₂"}$j$),
    (896, 'engineering', 'fuel-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"Octane number highest?","options":["n-heptane","Iso-octane","Benzene","Toluene"],"answer":1,"explanation":"Iso-octane = 100 (best anti-knock)"},{"q":"Diesel का quality?","options":["Octane number","Cetane number","Calorific value","Viscosity"],"answer":1,"explanation":"Diesel quality = cetane number"}]}$j$),

    (897, 'engineering', 'poly-eng-concept', 'concept', 1, 'बहुलक — JEE',
     $j${"text":"Polymers: addition (polyethylene, PVC, polystyrene) vs condensation (nylon, bakelite, PET)। Homopolymer vs copolymer। Tacticity (isotactic, syndiotactic, atactic)। Polymerization: free radical, ionic, Ziegler-Natta। Natural (rubber, cellulose) vs synthetic। Biodegradable polymers। Degree of polymerization, molecular weight distribution।","note":"JEE में polymerization types और polymer examples ज़रूरी हैं।"}$j$),
    (897, 'engineering', 'poly-eng-formula', 'formula', 2, 'बहुलक सूत्र',
     $j${"formula":"Addition: n CH₂=CHX → [-CH₂-CHX-]ₙ · Condensation: n H₂N-R-NH₂ + n HOOC-R'-COOH → [-NH-R-NH-CO-R'-CO-]ₙ + 2nH₂O","explanation":"Bakelite: phenol + formaldehyde · Nylon-6,6: hexamethylenediamine + adipic acid · PET: ethylene glycol + terephthalic acid"}$j$),
    (897, 'engineering', 'poly-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"Nylon-6,6 के monomers?","solution":"Hexamethylenediamine (6C diamine) + Adipic acid (6C diacid)","answer":"Both 6-carbon (nylon-6,6 → 6+6)"}$j$),
    (897, 'engineering', 'poly-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"Bakelite किसका polymer?","options":["Ethene","Phenol + formaldehyde","Styrene","Vinyl chloride"],"answer":1,"explanation":"Bakelite = phenol + formaldehyde (thermoset)"},{"q":"Ziegler-Natta catalyst?","options":["TiCl₄ + Al(C₂H₅)₃","Na + NH₃","H₂SO₄","BF₃"],"answer":0,"explanation":"TiCl₄ + triethylaluminium (for HDPE, isotactic PP)"}]}$j$),

    (898, 'engineering', 'corr-eng-concept', 'concept', 1, 'संक्षारण — JEE',
     $j${"text":"Corrosion: electrochemical process, rusting of iron requires O₂ + H₂O। Galvanic corrosion (two metals)। Prevention: galvanization (Zn coating), cathodic protection (sacrificial anode), painting, alloying (stainless steel: Fe+Cr+Ni)। Rust formula: Fe₂O₃·xH₂O। Corrosion rate affected by pH, O₂, electrolytes, temperature।","note":"JEE में electrochemical corrosion और prevention ज़रूरी हैं।"}$j$),
    (898, 'engineering', 'corr-eng-formula', 'formula', 2, 'संक्षारण सूत्र',
     $j${"formula":"Anode: Fe → Fe²⁺ + 2e⁻ · Cathode: O₂ + 2H₂O + 4e⁻ → 4OH⁻ · Overall: 2Fe + O₂ + 2H₂O → 2Fe(OH)₂ → Fe₂O₃·xH₂O","explanation":"Galvanization: Zn (E°=-0.76) protects Fe (E°=-0.44) — Zn oxidizes first"}$j$),
    (898, 'engineering', 'corr-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"Galvanization में कौन oxidize होगा?","solution":"Zn (E°=-0.76 < Fe -0.44) oxidizes first","answer":"Zn (sacrificial protection)"}$j$),
    (898, 'engineering', 'corr-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"Rusting के लिए ज़रूरी?","options":["O₂ only","H₂O only","Both O₂ + H₂O","CO₂"],"answer":2,"explanation":"Both O₂ and H₂O needed"},{"q":"Cathodic protection में?","options":["Sacrificial cathode","Sacrificial anode","Inert electrode","No electrodes"],"answer":1,"explanation":"More reactive metal = sacrificial anode (Zn, Mg)"}]}$j$),

    (899, 'engineering', 'lab-eng-concept', 'concept', 1, 'प्रयोगशाला रसायन — JEE',
     $j${"text":"Lab techniques: titration (acid-base, redox, complexometric), qualitative analysis (cation/anion groups), chromatography (paper, TLC, column, HPLC, GC)। Spectroscopy: UV-Vis (π→π*, n→π*), IR (functional groups), NMR (H environments), mass spec (molecular weight)। Purification: distillation, crystallization, sublimation, chromatography।","note":"JEE में group analysis, spectroscopy, और chromatography ज़रूरी हैं।"}$j$),
    (899, 'engineering', 'lab-eng-formula', 'formula', 2, 'लैब तकनीक',
     $j${"formula":"Beer-Lambert: A = εcl · Rf = distance spot/distance solvent · IR: C=O ~1700, O-H ~3300, N-H ~3300","explanation":"Cation groups: I (Ag, Pb), II (Cu, Cd), III (Fe, Al), IV (Zn, Mn), V (Ba, Sr), VI (Mg, NH₄⁺)"}$j$),
    (899, 'engineering', 'lab-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"Compound IR: strong peak at 1700 cm⁻¹। Functional group?","solution":"1700 cm⁻¹ = C=O (carbonyl)","answer":"C=O (aldehyde/ketone/acid)"}$j$),
    (899, 'engineering', 'lab-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"Beer-Lambert law?","options":["A = εcl","A = c/l","A = ε/c","A = εcl²"],"answer":0,"explanation":"A = εcl (A=absorbance, ε=molar absorptivity, c=conc, l=path)"},{"q":"IR spectroscopy किसके लिए?","options":["NMR","Functional groups","Mass","pH"],"answer":1,"explanation":"IR identifies functional groups"}]}$j$),

    -- ═══ ENGINEERING MATHS (1-10) ═══
    (1, 'engineering', 'pct-eng-concept', 'concept', 1, 'प्रतिशत — JEE',
     $j${"text":"Successive percentage changes: net effect = a + b + ab/100। Percentage increase then decrease (same rate) = net decrease = a²/100। Percentage points vs percentage difference। Applications: profit-loss, population growth, depreciation, compound interest chain।","note":"JEE में successive changes और mixed applications ज़रूरी हैं।"}$j$),
    (1, 'engineering', 'pct-eng-formula', 'formula', 2, 'प्रतिशत सूत्र',
     $j${"formula":"Successive: net% = a + b + ab/100 · Same +a% then -a%: net = -a²/100 · % change = (new-old)/old × 100","explanation":"Reverse: if price ↑20%, consumption must ↓16.67% to keep expense constant (20/120)"}$j$),
    (1, 'engineering', 'pct-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"Price ↑20%, consumption कितना ↓ ताकि expense same?","solution":"New price = 1.2P। New consumption = (1/1.2)C = 0.8333C। Decrease = 0.1667 = 16.67%","answer":"16.67% decrease"}$j$),
    (1, 'engineering', 'pct-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"Successive +10%, +20% = net?","options":["30%","32%","34%","28%"],"answer":1,"explanation":"10+20+200/100 = 32%"},{"q":"+25% then -25% = net?","options":["0%","-6.25%","+6.25%","-25%"],"answer":1,"explanation":"25²/100 = 6.25% decrease"}]}$j$),

    (2, 'engineering', 'pl-eng-concept', 'concept', 1, 'लाभ-हानि — JEE',
     $j${"text":"Profit/Loss on CP, discount on MP। Successive discounts: net = a + b - ab/100। Profit% if false weight (selling less): profit% = (true weight - false weight)/false weight × 100। Dishonest dealer, cheating। Relation: SP = CP(1+P/100) = MP(1-D/100)।","note":"JEE में false weight और successive discount ज़रूरी हैं।"}$j$),
    (2, 'engineering', 'pl-eng-formula', 'formula', 2, 'लाभ-हानि सूत्र',
     $j${"formula":"False weight: profit% = error/(true value - error) × 100 · Successive discounts: net = a + b - ab/100 · CP to SP: × (100+P)/100","explanation":"If sells at CP but uses 900g weight instead of 1kg: profit = 100/900 = 11.11%"}$j$),
    (2, 'engineering', 'pl-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"Dealer uses 900g for 1kg, sells at CP rate। Profit%?","solution":"Error = 100g (per 1kg claimed)। Actual weight = 900g। Profit = 100/900 = 11.11%","answer":"11.11% profit"}$j$),
    (2, 'engineering', 'pl-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"Successive 20%, 10% discounts?","options":["28%","30%","32%","25%"],"answer":0,"explanation":"20+10-200/100 = 28%"},{"q":"Uses 800g weight। Profit%?","options":["20%","25%","30%","15%"],"answer":1,"explanation":"200/800 = 25%"}]}$j$),

    (3, 'engineering', 'si-eng-concept', 'concept', 1, 'ब्याज — JEE',
     $j${"text":"SI = PRT/100, CI = P[(1+R/100)^T - 1]। CI-SI difference for 2 years = P(R/100)², for 3 years = P(R/100)²(3 + R/100)। Compounding half-yearly (R/2, 2T), quarterly (R/4, 4T)। Effective annual rate for CI: (1+R/n)ⁿ - 1। Rule of 72 (double money: 72/R years)।","note":"JEE में CI formula derivation और effective rate ज़रूरी है।"}$j$),
    (3, 'engineering', 'si-eng-formula', 'formula', 2, 'ब्याज सूत्र',
     $j${"formula":"SI = PRT/100 · CI = P[(1+R/100)^T - 1] · CI-SI (2y) = P(R/100)² · Effective: (1+R/n)ⁿ - 1","explanation":"Half-yearly: R/2, 2T · Quarterly: R/4, 4T · Rule 72: t_double ≈ 72/R"}$j$),
    (3, 'engineering', 'si-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"₹10000, 10%, 2y। CI-SI?","solution":"P(R/100)² = 10000 × (0.1)² = 10000 × 0.01","answer":"₹100"}$j$),
    (3, 'engineering', 'si-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"₹1000, 10%, half-yearly, 1y। Amount?","solution":"A = 1000(1+0.05)² = 1000(1.1025)","options":["1100","1102.5","1105","1120"],"answer":1,"explanation":"A = 1000(1.05)² = 1102.5"},{"q":"Rule 72 से double time (R=8%)?","options":["8y","9y","10y","12y"],"answer":1,"explanation":"72/8 = 9 years"}]}$j$),

    (4, 'engineering', 'ratio-eng-concept', 'concept', 1, 'अनुपात — JEE',
     $j${"text":"Ratio, proportion, variation (direct, inverse, joint)। Componendo-dividendo: a/b = c/d → (a+b)/(a-b) = (c+d)/(c-d)। Partnership (simple, compound with time). Mixture problems. Ratio of 3 quantities, continued proportion (a:b = b:c → b²=ac)।","note":"JEE में componendo-dividendo और partnership ज़रूरी हैं।"}$j$),
    (4, 'engineering', 'ratio-eng-formula', 'formula', 2, 'अनुपात सूत्र',
     $j${"formula":"Componendo-dividendo: a/b=c/d → (a+b)/(a-b)=(c+d)/(c-d) · Continued: a/b = b/c → b²=ac","explanation":"Partnership: profit ∝ investment × time · Direct variation: y ∝ x → y=kx"}$j$),
    (4, 'engineering', 'ratio-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"A:B = 3:4, B:C = 6:5। A:C?","solution":"A:B:C = 3×6 : 4×6 : 4×5 = 18:24:20 = 9:12:10","answer":"A:C = 9:10"}$j$),
    (4, 'engineering', 'ratio-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"A:B=2:3, B:C=4:5। A:C?","options":["8:15","2:5","5:8","10:12"],"answer":0,"explanation":"A:B:C = 8:12:15 → A:C = 8:15"},{"q":"Componendo-dividendo: (a+b)/(a-b) = ?","options":["a/b","c/d","(c+d)/(c-d)","ab/cd"],"answer":2,"explanation":"Rule: (a+b)/(a-b)=(c+d)/(c-d) if a/b=c/d"}]}$j$),

    (5, 'engineering', 'avg-eng-concept', 'concept', 1, 'औसत — JEE',
     $j${"text":"Arithmetic mean, weighted mean, geometric mean (GM = (a₁a₂...aₙ)^(1/n)), harmonic mean (HM = n/(Σ1/aᵢ))। AM ≥ GM ≥ HM equality if all equal। Average speed (for equal distances) = 2v₁v₂/(v₁+v₂) = HM। Mean of first n natural numbers = (n+1)/2।","note":"JEE में AM-GM-HM inequality ज़रूरी है।"}$j$),
    (5, 'engineering', 'avg-eng-formula', 'formula', 2, 'औसत सूत्र',
     $j${"formula":"AM = Σx/n · GM = (Πxᵢ)^(1/n) · HM = n/Σ(1/xᵢ) · AM ≥ GM ≥ HM · Avg speed (equal D) = 2v₁v₂/(v₁+v₂)","explanation":"1st n naturals: (n+1)/2 · 1st n odd: n · 1st n even: n+1"}$j$),
    (5, 'engineering', 'avg-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"Equal distance 60 km/h और 40 km/h। Avg speed?","solution":"2×60×40/(60+40) = 4800/100","answer":"48 km/h (HM, not 50)"}$j$),
    (5, 'engineering', 'avg-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"AM-GM-HM में सबसे बड़ा?","options":["AM","GM","HM","बराबर"],"answer":0,"explanation":"AM ≥ GM ≥ HM (equality only if all equal)"},{"q":"2 और 8 का GM?","options":["4","5","6","5.5"],"answer":0,"explanation":"GM = √(2×8) = √16 = 4"}]}$j$),

    (6, 'engineering', 'age-eng-concept', 'concept', 1, 'आयु — JEE',
     $j${"text":"Linear equations in one/two variables. Age problems: current age x, n years ago (x-n), n years hence (x+n)। Ratio equations across time। Two-variable systems: eliminate and solve। Quadratic for complex age relations।","note":"JEE में system of equations और quadratic age problems ज़रूरी हैं।"}$j$),
    (6, 'engineering', 'age-eng-formula', 'formula', 2, 'आयु सूत्र',
     $j${"formula":"If current age x: past (x-n), future (x+n) · Ratio equation: (x+n)/(y+n) = p/q · 2-var: solve by substitution/elimination","explanation":"For 'a times now' & 'b times later': a·x + n = b(x + n)"}$j$),
    (6, 'engineering', 'age-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"Father 3× son now; 12 years later 2×। Father's age?","solution":"Son = x, Father = 3x। 3x+12 = 2(x+12) → 3x+12=2x+24 → x=12। Father = 36","answer":"36 years"}$j$),
    (6, 'engineering', 'age-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"A age 40, B 20। कितने साल में A, B की 3x?","solution":"40+n = 3(20+n) → 40+n=60+3n → -20=2n → negative. So past: 40-n=3(20-n) → 40-n=60-3n → 2n=20 → n=10","options":["5y ago","10y ago","15y ago","20y ago"],"answer":1,"explanation":"10 years ago: A=30, B=10 (30=3×10)"},{"q":"A 32, B 8। जब A = 3B?","solution":"32+n = 3(8+n) → 32+n=24+3n → 8=2n → n=4","options":["2y","4y","6y","8y"],"answer":1,"explanation":"After 4 years: A=36, B=12 (36=3×12)"}]}$j$),

    (7, 'engineering', 'mix-eng-concept', 'concept', 1, 'मिश्रण — JEE',
     $j${"text":"Alligation: cheaper quantity : dearer quantity = (dear - mean) : (mean - cheap)। Repeated replacement: after n operations of volume r from total V: final pure = initial × (1 - r/V)ⁿ। Mixing with different concentrations। Two-stage mixing।","note":"JEE में repeated replacement और alligation cross ज़रूरी हैं।"}$j$),
    (7, 'engineering', 'mix-eng-formula', 'formula', 2, 'मिश्रण सूत्र',
     $j${"formula":"Alligation: q_cheap/q_dear = (dear-mean)/(mean-cheap) · Replacement: final = initial × (1 - r/V)ⁿ","explanation":"Mean price = weighted average of component prices · After n replacements ratio changes geometrically"}$j$),
    (7, 'engineering', 'mix-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"8L milk, 2L water (20%)। 2L mix निकालकर 2L water डालें। Water%?","solution":"Start: milk 8L, water 2L, total 10L। 2L mixture निकाला (80% milk): milk −1.6L, water −0.4L → milk 6.4L, water 1.6L। फिर 2L water डाला → water 3.6L, total 10L","answer":"36% water (milk 6.4L)"}$j$),
    (7, 'engineering', 'mix-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"₹40, ₹60 मिलाएँ → ₹45 mean। Ratio cheap:dear?","options":["1:3","2:3","3:1","3:2"],"answer":2,"explanation":"(60-45):(45-40) = 15:5 = 3:1"},{"q":"Replacement 3 times, r=V/4। Final pure fraction?","options":["(1/4)³","(3/4)³","1-3/4","(1-3/4)³"],"answer":1,"explanation":"(1-r/V)ⁿ = (1-1/4)³ = (3/4)³"}]}$j$),

    (8, 'engineering', 'tw-eng-concept', 'concept', 1, 'समय-कार्य — JEE',
     $j${"text":"Combined work: 1/x + 1/y = 1/t। Work done in n days with alternating workers। Efficiency-based problems (2 workers, ratio)। Wages proportional to work done। Pipes and cisterns (fill +, drain -)। Work and energy analogy।","note":"JEE में alternating work और wages ज़रूरी हैं।"}$j$),
    (8, 'engineering', 'tw-eng-formula', 'formula', 2, 'कार्य सूत्र',
     $j${"formula":"Combined: 1/x + 1/y = 1/t → t = xy/(x+y) · 3 workers: 1/x+1/y+1/z = 1/t · Wages ∝ work done","explanation":"Alternating: A in x days, B in y days alternate → work in 2 days = 1/x + 1/y"}$j$),
    (8, 'engineering', 'tw-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"A 12d, B 18d, alternate starting A। Total time?","solution":"A+B एक जोड़ी (2 दिन) = 1/12 + 1/18 = 5/36। 14 दिन = 7 जोड़े = 35/36। बचा 1/36। Day 15 पर A अकेला (1/12 per day): (1/36)÷(1/12) = 1/3 दिन। कुल = 14 + 1/3","answer":"14⅓ days (≈14.33)"}$j$),
    (8, 'engineering', 'tw-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"A 10d, B 15d। Together?","options":["5d","6d","7d","8d"],"answer":1,"explanation":"1/10+1/15=5/30=1/6 → 6d"},{"q":"Work wages ∝?","options":["Time","Work done","Efficiency only","None"],"answer":1,"explanation":"Wages ∝ work done (not just time)"}]}$j$),

    (9, 'engineering', 'tsd-eng-concept', 'concept', 1, 'चाल-दूरी — JEE',
     $j${"text":"Relative motion, train problems (pole: t=L/v, platform: t=(L+P)/v, crossing train: t=(L₁+L₂)/relative v)। Boats and streams (down: b+s, up: b-s)। Circular motion (relative, meeting points)। Average speed (2 speeds equal distance = HM)। Upstream/downstream time equations।","note":"JEE में train और boat problems ज़रूरी हैं।"}$j$),
    (9, 'engineering', 'tsd-eng-formula', 'formula', 2, 'चाल सूत्र',
     $j${"formula":"Relative (same dir) = |v₁-v₂| · Opposite = v₁+v₂ · Train pole: L/v · Platform: (L+P)/v · Boat downstream: b+s, upstream: b-s","explanation":"km/h to m/s: ×5/18 · Circular: relative speed = v₁±v₂, meeting time = circumference/relative"}$j$),
    (9, 'engineering', 'tsd-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"100m train 10 m/s, 200m platform। Time?","solution":"Distance = 100+200 = 300m। Time = 300/10","answer":"30 seconds"}$j$),
    (9, 'engineering', 'tsd-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"Boat 10 km/h still, stream 2 km/h। Upstream time for 24 km?","solution":"Up speed = 10-2 = 8 km/h। t = 24/8 = 3h","options":["2h","3h","4h","6h"],"answer":1,"explanation":"Upstream: b-s = 8, t=24/8=3h"},{"q":"Two trains 100m each, opposite, 10 m/s each। Time to cross?","solution":"Relative = 20 m/s, distance = 200m, t = 200/20 = 10s","options":["5s","10s","15s","20s"],"answer":1,"explanation":"t = 200/20 = 10s"}]}$j$),

    (10, 'engineering', 'num-eng-concept', 'concept', 1, 'संख्या पद्धति — JEE',
     $j${"text":"Divisibility rules (2, 3, 4, 5, 6, 8, 9, 11)। HCF/LCM (Euclid's algorithm)। Number of divisors (from prime factorization: if N = p^a·q^b, divisors = (a+1)(b+1))। Remainder theorem, cyclicity of units digit। Number of trailing zeros in n! (⌊n/5⌋+⌊n/25⌋+...)। Modular arithmetic, Chinese remainder theorem (basics)।","note":"JEE में divisors, cyclicity, और remainder ज़रूरी हैं।"}$j$),
    (10, 'engineering', 'num-eng-formula', 'formula', 2, 'संख्या सूत्र',
     $j${"formula":"Divisors of N=p^a·q^b = (a+1)(b+1) · Trailing zeros in n! = ⌊n/5⌋+⌊n/25⌋+... · HCF×LCM = a×b","explanation":"Euclid: HCF(a,b) = HCF(b, a mod b) · Units digit cyclicity: 2,3,7,8 (cycle 4); 4,9 (cycle 2); 5,6 (cycle 1); 0,1 (cycle 1)"}$j$),
    (10, 'engineering', 'num-eng-example', 'example', 3, 'JEE numerical',
     $j${"question":"360 के कुल divisors?","solution":"360 = 2³ × 3² × 5¹। Divisors = (3+1)(2+1)(1+1) = 4×3×2","answer":"24 divisors"}$j$),
    (10, 'engineering', 'num-eng-mcq', 'mcq', 4, 'JEE MCQs',
     $j${"questions":[{"q":"100! में trailing zeros?","solution":"⌊100/5⌋=20, ⌊100/25⌋=4, ⌊100/125⌋=0। Total = 24","options":["20","22","24","25"],"answer":2,"explanation":"20+4 = 24"},{"q":"2¹⁰⁰ का units digit?","solution":"Cyclicity of 2 = 4। 100 mod 4 = 0 → units = 6","options":["2","4","6","8"],"answer":2,"explanation":"Cycle: 2,4,8,6 → 100 mod 4 = 0 → 6"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[], 
  case when s.chapter_id >= 400 then 'general-science' 
       when s.chapter_id < 20 then 'maths' 
       else 'general-science' end,
  'hard', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, count(*) from mtb.atoms 
-- where chapter_id in (890,891,892,893,894,895,896,897,898,899,1,2,3,4,5,6,7,8,9,10) 
--   and level_id='engineering' and status='published' and not archived 
-- group by 1 order by 1;
-- Expected: each chapter = 4

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: 1139 + 80 = 1219