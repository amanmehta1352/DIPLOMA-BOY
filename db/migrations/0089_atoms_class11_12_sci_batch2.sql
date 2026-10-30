with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ CLASS 11-12 PHYSICS (880-883, 920) ═══
    (880, 'class_11_12_sci', 'elec-1112-concept', 'concept', 1, 'विद्युत — Class 11-12',
     $j${"text":"Electrostatics: Coulomb F=kq₁q₂/r² (k=9×10⁹)। Electric field E=F/q, potential V=kQ/r। Capacitor C=Q/V, energy U=½CV²। Dielectric: C=ε_r C₀। Kirchhoff's laws for circuits। Wheatstone bridge, potentiometer। Current electricity: V=IR, power P=VI।","note":"Board में electrostatics, capacitors, और circuits ज़रूरी हैं।"}$j$),
    (880, 'class_11_12_sci', 'elec-1112-formula', 'formula', 2, 'विद्युत सूत्र',
     $j${"formula":"F = kq₁q₂/r² · E = kQ/r² · V = kQ/r · C = ε₀A/d · U = ½CV² · P = VI = I²R = V²/R","explanation":"k = 1/(4πε₀) = 9×10⁹ N·m²/C² · Series C: 1/C = 1/C₁ + 1/C₂ · Parallel: C = C₁ + C₂"}$j$),
    (880, 'class_11_12_sci', 'elec-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"C=10 μF, V=100 V। Energy?","solution":"U = ½CV² = ½ × 10⁻⁵ × 10⁴","answer":"0.05 J"}$j$),
    (880, 'class_11_12_sci', 'elec-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Capacitor energy?","options":["CV²","½CV²","CV","½C²V"],"answer":1,"explanation":"U = ½CV²"},{"q":"Parallel C?","options":["1/C=1/C₁+1/C₂","C=C₁+C₂","C=C₁×C₂","C=√C₁C₂"],"answer":1,"explanation":"Parallel = sum of capacitances"}]}$j$),

    (881, 'class_11_12_sci', 'mag-1112-concept', 'concept', 1, 'चुंबकत्व — Class 11-12',
     $j${"text":"Magnetic effects: Biot-Savart B=μ₀I/2πr (long wire), Ampere's law, solenoid B=μ₀nI। Lorentz F=qvBsinθ, F=BIL for wire। Cyclotron r=mv/qB। Magnetic moment μ=NIA। Torque τ=μ×B। Moving coil galvanometer।","note":"Board में Biot-Savart, Ampere, और cyclotron ज़रूरी हैं।"}$j$),
    (881, 'class_11_12_sci', 'mag-1112-formula', 'formula', 2, 'चुंबकत्व सूत्र',
     $j${"formula":"B = μ₀I/2πr (wire) · B = μ₀nI (solenoid) · F = qvBsinθ = BIL · r = mv/qB (cyclotron) · τ = NIAB sinθ","explanation":"μ₀ = 4π×10⁻⁷ T·m/A · Right-hand rule for B direction"}$j$),
    (881, 'class_11_12_sci', 'mag-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Proton (m=1.67×10⁻²⁷, q=1.6×10⁻¹⁹), v=10⁶ m/s, B=1T। r?","solution":"r = mv/qB = 1.67×10⁻²⁷ × 10⁶ / (1.6×10⁻¹⁹ × 1)","answer":"≈ 1.04 cm"}$j$),
    (881, 'class_11_12_sci', 'mag-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Solenoid B field?","options":["μ₀I/2πr","μ₀nI","μ₀I/4πr²","μ₀I"],"answer":1,"explanation":"B = μ₀nI inside solenoid"},{"q":"Cyclotron r ∝?","options":["v","1/v","v²","1/v²"],"answer":0,"explanation":"r = mv/qB → r ∝ v"}]}$j$),

    (882, 'class_11_12_sci', 'modern-1112-concept', 'concept', 1, 'आधुनिक भौतिकी — Class 11-12',
     $j${"text":"Modern Physics: photoelectric (Einstein hf = φ + KE_max), de Broglie λ = h/p, Bohr model E_n = -13.6/n² eV, X-rays λ_min = hc/eV। Nuclear: mass defect Δm, E = Δmc², binding energy, fission, fusion। Radioactivity: N = N₀e^(-λt), t½ = 0.693/λ।","note":"Board में photoelectric, Bohr, और nuclear physics ज़रूरी हैं।"}$j$),
    (882, 'class_11_12_sci', 'modern-1112-formula', 'formula', 2, 'आधुनिक भौतिकी सूत्र',
     $j${"formula":"E = hf = φ + KE_max · λ = h/p · E_n = -13.6/n² eV · t½ = 0.693/λ · E = Δmc²","explanation":"h = 6.626×10⁻³⁴ J·s · Bohr radius = 0.53 Å · 1 amu = 931.5 MeV/c²"}$j$),
    (882, 'class_11_12_sci', 'modern-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Electron v=10⁶ m/s (m=9.1×10⁻³¹)। λ?","solution":"λ = h/mv = 6.626×10⁻³⁴/(9.1×10⁻³¹ × 10⁶)","answer":"≈ 0.73 nm"}$j$),
    (882, 'class_11_12_sci', 'modern-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Bohr ground state E (H)?","options":["-13.6 eV","-3.4 eV","-1.51 eV","0"],"answer":0,"explanation":"E₁ = -13.6 eV"},{"q":"de Broglie λ ∝?","options":["p","1/p","p²","1/p²"],"answer":1,"explanation":"λ = h/p → λ ∝ 1/p"}]}$j$),

    (883, 'class_11_12_sci', 'mach-1112-concept', 'concept', 1, 'मशीनें — Class 11-12',
     $j${"text":"Simple machines: lever (MA = load/effort), pulley (MA = n for n pulleys), inclined plane (MA = 1/sinθ), screw (MA = 2πL/pitch), wheel-axle। Efficiency η = MA/VR × 100%। Friction affects MA। Reversible vs irreversible।","note":"Board में MA, VR, और efficiency ज़रूरी हैं।"}$j$),
    (883, 'class_11_12_sci', 'mach-1112-formula', 'formula', 2, 'मशीन सूत्र',
     $j${"formula":"MA = Load/Effort · VR = effort distance/load distance · η = MA/VR × 100%","explanation":"Ideal machine: MA = VR (η=100%) · Pulley n: VR = n · Inclined plane: VR = 1/sinθ"}$j$),
    (883, 'class_11_12_sci', 'mach-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"MA=4, VR=5। η?","solution":"η = 4/5 × 100","answer":"80%"}$j$),
    (883, 'class_11_12_sci', 'mach-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Ideal machine?","options":["MA>VR","MA=VR","MA<VR","MA=0"],"answer":1,"explanation":"Ideal: MA=VR, η=100%"},{"q":"Pulley n का VR?","options":["1","n","n²","1/n"],"answer":1,"explanation":"VR = n for n-pulley system"}]}$j$),

    (920, 'class_11_12_sci', 'env-1112-concept', 'concept', 1, 'पर्यावरण — Class 11-12',
     $j${"text":"Environment: ecosystem components (biotic + abiotic), food chain/web, trophic levels, 10% energy law। Pollution types (air, water, soil, noise)। Greenhouse effect (CO₂, CH₄, N₂O, CFCs)। Ozone depletion (CFCs → Cl radical)। Biodiversity hotspots। Conservation, sustainable development।","note":"Board में pollution, ozone, और biodiversity ज़रूरी हैं।"}$j$),
    (920, 'class_11_12_sci', 'env-1112-formula', 'formula', 2, 'पर्यावरण सूत्र',
     $j${"formula":"10% energy flow between trophic levels · BOD = Biochemical Oxygen Demand · Greenhouse: CO₂ > CH₄ > N₂O (potency reverse)","explanation":"Pollution control: ESP (electrostatic precipitator), scrubber, catalytic converter · Ozone (O₃) absorbs UV-B"}$j$),
    (920, 'class_11_12_sci', 'env-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"10,000 J producers। Tertiary consumer को?","solution":"10% × 10% × 10% = 0.1% of 10,000","answer":"10 J"}$j$),
    (920, 'class_11_12_sci', 'env-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"10% energy law किसने?","options":["Darwin","Lindeman","Odum","Tansley"],"answer":1,"explanation":"Lindeman (1942)"},{"q":"Ozone depletion cause?","options":["CO₂","CFCs","SO₂","CH₄"],"answer":1,"explanation":"CFCs → chlorine radicals"}]}$j$),

    -- ═══ CLASS 11-12 CHEMISTRY (895-899) ═══
    (895, 'class_11_12_sci', 'electro-1112-concept', 'concept', 1, 'विद्युत रसायन — Class 11-12',
     $j${"text":"Electrochemistry: galvanic cells, Nernst equation, Faraday's laws। Electrolysis: anode oxidation, cathode reduction। Conductance, molar conductivity Λm, Kohlrausch's law। Batteries (dry cell, lead-acid, Li-ion)। Fuel cells। Corrosion as electrochemical।","note":"Board में Nernst, electrolysis, और batteries ज़रूरी हैं।"}$j$),
    (895, 'class_11_12_sci', 'electro-1112-formula', 'formula', 2, 'विद्युत रसायन सूत्र',
     $j${"formula":"Nernst: E = E° - (0.059/n)log Q (25°C) · m = (M/nF)It · Λm = κ/c · Λm° = ν₊λ₊° + ν₋λ₋°","explanation":"F = 96500 C/mol · Galvanic: anode (-), cathode (+) · Electrolytic: anode (+), cathode (-)"}$j$),
    (895, 'class_11_12_sci', 'electro-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Zn/Cu cell, E°=1.10, [Zn²⁺]=1M, [Cu²⁺]=0.1M। E?","solution":"E = 1.10 - (0.059/2)log(1/0.1) = 1.10 - 0.0295×1","answer":"≈ 1.07 V"}$j$),
    (895, 'class_11_12_sci', 'electro-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Nernst factor (25°C)?","options":["RT/F","0.059/n","2.303","0.059"],"answer":1,"explanation":"0.059/n for log base 10"},{"q":"Faraday constant?","options":["96500 C/mol","96485 C/mol","9650","965"],"answer":0,"explanation":"≈ 96500 C/mol"}]}$j$),

    (896, 'class_11_12_sci', 'fuel-1112-concept', 'concept', 1, 'ईंधन-दहन — Class 11-12',
     $j${"text":"Fuels: solid, liquid, gas। Calorific value (kJ/kg)। Coal types (peat, lignite, bituminous, anthracite)। Petroleum fractional distillation। Octane number (petrol), cetane number (diesel)। Knocking, TEL। Combustion stoichiometry। Alternative fuels (LPG, CNG, hydrogen)।","note":"Board में calorific value और combustion calculations ज़रूरी हैं।"}$j$),
    (896, 'class_11_12_sci', 'fuel-1112-formula', 'formula', 2, 'ईंधन सूत्र',
     $j${"formula":"CₓHᵧ + (x+y/4)O₂ → xCO₂ + (y/2)H₂O · Calorific value: kJ per kg or kJ per m³","explanation":"Octane: iso-octane=100, n-heptane=0 · Cetane: hexadecane=100 · 1 Cal = 4184 J"}$j$),
    (896, 'class_11_12_sci', 'fuel-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"CH₄ combustion में O₂?","solution":"CH₄ + 2O₂ → CO₂ + 2H₂O","answer":"2 moles O₂"}$j$),
    (896, 'class_11_12_sci', 'fuel-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Octane highest?","options":["n-heptane","Iso-octane","Benzene","Toluene"],"answer":1,"explanation":"Iso-octane = 100"},{"q":"Diesel quality?","options":["Octane","Cetane","Calorific","Viscosity"],"answer":1,"explanation":"Diesel = cetane number"}]}$j$),

    (897, 'class_11_12_sci', 'poly-1112-concept', 'concept', 1, 'बहुलक — Class 11-12',
     $j${"text":"Polymers: addition (polyethylene, PVC, PS) vs condensation (nylon, bakelite, PET)। Homopolymer vs copolymer। Tacticity (iso, syndio, atactic)। Polymerization: free radical, ionic, Ziegler-Natta। Natural (rubber, cellulose) vs synthetic। Biodegradable (PLA, PHA)। Degree of polymerization।","note":"Board में polymerization types और examples ज़रूरी हैं।"}$j$),
    (897, 'class_11_12_sci', 'poly-1112-formula', 'formula', 2, 'बहुलक सूत्र',
     $j${"formula":"Addition: n CH₂=CHX → [-CH₂-CHX-]ₙ · Condensation: diamine + diacid → polyamide + H₂O","explanation":"Nylon-6,6: hexamethylenediamine + adipic acid (both 6C) · PET: ethylene glycol + terephthalic acid"}$j$),
    (897, 'class_11_12_sci', 'poly-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Nylon-6,6 के monomers?","solution":"Hexamethylenediamine (6C diamine) + adipic acid (6C diacid)","answer":"Both 6C → nylon-6,6"}$j$),
    (897, 'class_11_12_sci', 'poly-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Bakelite?","options":["Ethene","Phenol+formaldehyde","Styrene","Vinyl chloride"],"answer":1,"explanation":"Bakelite = phenol + formaldehyde (thermoset)"},{"q":"Ziegler-Natta?","options":["TiCl₄+Al(C₂H₅)₃","Na+NH₃","H₂SO₄","BF₃"],"answer":0,"explanation":"TiCl₄ + triethylaluminium"}]}$j$),

    (898, 'class_11_12_sci', 'corr-1112-concept', 'concept', 1, 'संक्षारण — Class 11-12',
     $j${"text":"Corrosion: electrochemical process। Rusting requires O₂ + H₂O। Galvanic corrosion (two metals)। Prevention: galvanization (Zn), cathodic protection (sacrificial anode), painting, alloying (stainless steel = Fe+Cr+Ni)। Corrosion rate affected by pH, electrolytes, temperature।","note":"Board में electrochemical corrosion और prevention ज़रूरी हैं।"}$j$),
    (898, 'class_11_12_sci', 'corr-1112-formula', 'formula', 2, 'संक्षारण सूत्र',
     $j${"formula":"Anode: Fe → Fe²⁺ + 2e⁻ · Cathode: O₂ + 2H₂O + 4e⁻ → 4OH⁻ · Overall: 2Fe + O₂ + 2H₂O → 2Fe(OH)₂ → Fe₂O₃·xH₂O","explanation":"Galvanization: Zn (E°=-0.76) protects Fe (E°=-0.44) — Zn oxidizes first"}$j$),
    (898, 'class_11_12_sci', 'corr-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Galvanization में कौन oxidize?","solution":"Zn (E°=-0.76 < Fe -0.44) oxidizes first","answer":"Zn (sacrificial protection)"}$j$),
    (898, 'class_11_12_sci', 'corr-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Rusting requires?","options":["O₂ only","H₂O only","Both O₂+H₂O","CO₂"],"answer":2,"explanation":"Both O₂ and H₂O"},{"q":"Cathodic protection?","options":["Sacrificial cathode","Sacrificial anode","Inert","None"],"answer":1,"explanation":"More reactive metal = sacrificial anode"}]}$j$),

    (899, 'class_11_12_sci', 'lab-1112-concept', 'concept', 1, 'लैब रसायन — Class 11-12',
     $j${"text":"Lab techniques: titration (acid-base, redox, complexometric), qualitative analysis (cation/anion groups), chromatography (paper, TLC, column, HPLC)। Spectroscopy: UV-Vis (π→π*, n→π*), IR (functional groups), NMR (H environments), mass spec (MW)। Purification: distillation, crystallization, chromatography।","note":"Board में group analysis, spectroscopy, और chromatography ज़रूरी हैं।"}$j$),
    (899, 'class_11_12_sci', 'lab-1112-formula', 'formula', 2, 'लैब तकनीक',
     $j${"formula":"Beer-Lambert: A = εcl · Rf = distance spot/distance solvent · IR: C=O ~1700, O-H ~3300 cm⁻¹","explanation":"Cation groups: I (Ag, Pb), II (Cu, Cd), III (Fe, Al), IV (Zn, Mn), V (Ba, Sr), VI (Mg, NH₄⁺)"}$j$),
    (899, 'class_11_12_sci', 'lab-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"IR peak 1700 cm⁻¹। Group?","solution":"C=O (carbonyl)","answer":"C=O (aldehyde/ketone/acid)"}$j$),
    (899, 'class_11_12_sci', 'lab-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Beer-Lambert?","options":["A=εcl","A=c/l","A=ε/c","A=εcl²"],"answer":0,"explanation":"A=εcl (absorbance)"},{"q":"IR for?","options":["NMR","Functional groups","Mass","pH"],"answer":1,"explanation":"IR identifies functional groups"}]}$j$),

    -- ═══ CLASS 11-12 BIOLOGY (901-910) ═══
    (901, 'class_11_12_sci', 'cell-1112-concept', 'concept', 1, 'कोशिका — Class 11-12',
     $j${"text":"Cell biology: cell theory, prokaryotic vs eukaryotic। Plasma membrane (fluid mosaic model)। Organelles: mitochondria (ATP), chloroplast (photosynthesis), ER (transport), Golgi (packaging), lysosome (digestion), ribosome (protein synthesis)। Cell cycle: interphase + M phase (mitosis/meiosis)।","note":"Board में organelles और cell cycle ज़रूरी हैं।"}$j$),
    (901, 'class_11_12_sci', 'cell-1112-formula', 'formula', 2, 'कोशिका तथ्य',
     $j${"formula":"Mitochondria: ATP (powerhouse) · Chloroplast: photosynthesis · Ribosome: protein · Lysosome: digestion (suicidal bag)","explanation":"Prokaryotic: 70S ribosome · Eukaryotic: 80S · Cell cycle: G1 → S → G2 → M"}$j$),
    (901, 'class_11_12_sci', 'cell-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Mature RBC में mitochondria?","solution":"नहीं (anaerobic glycolysis for O₂ space)","answer":"नहीं होता"}$j$),
    (901, 'class_11_12_sci', 'cell-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Powerhouse?","options":["Nucleus","Mitochondria","Ribosome","Golgi"],"answer":1,"explanation":"Mitochondria = ATP"},{"q":"Suicidal bag?","options":["Lysosome","Ribosome","ER","Golgi"],"answer":0,"explanation":"Lysosome (hydrolytic enzymes)"}]}$j$),

    (902, 'class_11_12_sci', 'bio-tissues-1112-concept', 'concept', 1, 'ऊतक — Class 11-12',
     $j${"text":"Tissues: epithelial (covering), connective (support), muscular (movement), nervous (control)। Epithelial: simple (1 layer) vs stratified (multiple)। Connective: loose, dense, specialized (bone, cartilage, blood)। Muscle: skeletal (striated, voluntary), smooth (non-striated, involuntary), cardiac (striated, involuntary)।","note":"Board में tissue types और locations ज़रूरी हैं।"}$j$),
    (902, 'class_11_12_sci', 'bio-tissues-1112-formula', 'formula', 2, 'ऊतक तथ्य',
     $j${"formula":"Epithelial: cover/lining · Connective: support/bind · Muscular: movement · Nervous: control","explanation":"Blood = fluid connective · Bone = hard connective · Tendon: muscle→bone · Ligament: bone→bone"}$j$),
    (902, 'class_11_12_sci', 'bio-tissues-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Heart muscle type?","solution":"Striated + involuntary (intercalated discs)","answer":"Cardiac muscle"}$j$),
    (902, 'class_11_12_sci', 'bio-tissues-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Blood tissue?","options":["Epithelial","Connective","Muscular","Nervous"],"answer":1,"explanation":"Blood = fluid connective"},{"q":"Skeletal muscle?","options":["Non-striated, involuntary","Striated, voluntary","Striated, involuntary","Non-striated, voluntary"],"answer":1,"explanation":"Skeletal = striated + voluntary"}]}$j$),

    (903, 'class_11_12_sci', 'bio-animal-1112-concept', 'concept', 1, 'जंतु जगत — Class 11-12',
     $j${"text":"Animal Kingdom: Porifera (cellular), Cnidaria (tissue), Platyhelminthes (flatworms), Aschelminthes (roundworms), Annelida (segmented), Arthropoda (largest), Mollusca, Echinodermata (water vascular), Chordata (notochord)। Symmetry, coelom, segmentation, germ layers।","note":"Board में phyla characteristics और examples ज़रूरी हैं।"}$j$),
    (903, 'class_11_12_sci', 'bio-animal-1112-formula', 'formula', 2, 'जंतु तथ्य',
     $j${"formula":"Porifera: cellular · Cnidaria: tissue · Arthropoda: largest · Chordata: notochord","explanation":"Symmetry: radial (Cnidaria) vs bilateral (most) · Coelom: acoelomate, pseudocoelomate, coelomate"}$j$),
    (903, 'class_11_12_sci', 'bio-animal-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Largest phylum?","solution":"Arthropoda (insects)","answer":"Arthropoda"}$j$),
    (903, 'class_11_12_sci', 'bio-animal-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Largest phylum?","options":["Chordata","Mollusca","Arthropoda","Annelida"],"answer":2,"explanation":"Arthropoda = largest"},{"q":"Water vascular system?","options":["Mollusca","Echinodermata","Cnidaria","Porifera"],"answer":1,"explanation":"Echinodermata (starfish)"}]}$j$),

    (904, 'class_11_12_sci', 'bio-plant-1112-concept', 'concept', 1, 'पादप जगत — Class 11-12',
     $j${"text":"Plant Kingdom: algae (Chlorophyceae, Phaeophyceae, Rhodophyceae), bryophytes (no vascular, amphibian), pteridophytes (vascular, no seed), gymnosperms (naked seed), angiosperms (flower)। Monocot (1 cotyledon) vs dicot (2)। Double fertilization = angiosperms only।","note":"Board में plant groups और angiosperm details ज़रूरी हैं।"}$j$),
    (904, 'class_11_12_sci', 'bio-plant-1112-formula', 'formula', 2, 'पादप तथ्य',
     $j${"formula":"Algae → Bryophytes (no vascular) → Pteridophytes (vascular, no seed) → Gymnosperms → Angiosperms","explanation":"Monocot: 1 cotyledon, fibrous root, parallel venation · Dicot: 2 cotyledons, tap root, reticulate venation"}$j$),
    (904, 'class_11_12_sci', 'bio-plant-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Double fertilization किसमें?","solution":"1 sperm + egg → zygote; 1 sperm + 2 polar nuclei → endosperm","answer":"Angiosperms only"}$j$),
    (904, 'class_11_12_sci', 'bio-plant-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Amphibians of plant kingdom?","options":["Algae","Bryophytes","Pteridophytes","Gymnosperms"],"answer":1,"explanation":"Bryophytes (need water)"},{"q":"Monocot cotyledon?","options":["0","1","2","Many"],"answer":1,"explanation":"Monocot = 1"}]}$j$),

    (905, 'class_11_12_sci', 'bio-nutrition-1112-concept', 'concept', 1, 'पोषण — Class 11-12',
     $j${"text":"Nutrition: autotrophic (photosynthesis) vs heterotrophic (holozoic, saprophytic, parasitic, symbiotic)। Human: carbs (4 Cal/g), proteins (4, 9 essential amino acids), fats (9, essential fatty acids), vitamins (fat-soluble A,D,E,K; water-soluble B,C), minerals। Deficiency diseases।","note":"Board में nutrients और vitamins ज़रूरी हैं।"}$j$),
    (905, 'class_11_12_sci', 'bio-nutrition-1112-formula', 'formula', 2, 'पोषण तथ्य',
     $j${"formula":"Carbs: 4 Cal/g · Proteins: 4 Cal/g · Fats: 9 Cal/g · Fat-soluble: A,D,E,K · Water-soluble: B,C","explanation":"Deficiency: scurvy (C), rickets (D), beriberi (B1), night blindness (A), goiter (I), anemia (Fe)"}$j$),
    (905, 'class_11_12_sci', 'bio-nutrition-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Fat 100g से Cal?","solution":"100 × 9","answer":"900 Cal"}$j$),
    (905, 'class_11_12_sci', 'bio-nutrition-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Fat Cal/g?","options":["4","7","9","12"],"answer":2,"explanation":"Fats = 9 Cal/g"},{"q":"Scurvy?","options":["Vit A","Vit B","Vit C","Vit D"],"answer":2,"explanation":"Vitamin C deficiency"}]}$j$),

    (906, 'class_11_12_sci', 'photo-1112-concept', 'concept', 1, 'प्रकाश संश्लेषण — Class 11-12',
     $j${"text":"Photosynthesis: 6CO₂+12H₂O+light → C₆H₁₂O₆+6O₂+6H₂O। Light reaction (thylakoid): PSII→PSI, photolysis, ATP+NADPH। Dark reaction (stroma): Calvin cycle (RuBisCO)। C3 vs C4 (Kranz anatomy) vs CAM। Pigments: chlorophyll a/b, carotenoids।","note":"Board में C3/C4/CAM और photosynthesis steps ज़रूरी हैं।"}$j$),
    (906, 'class_11_12_sci', 'photo-1112-formula', 'formula', 2, 'प्रकाश संश्लेषण सूत्र',
     $j${"formula":"6CO₂ + 12H₂O + light → C₆H₁₂O₆ + 6O₂ + 6H₂O · Light: PSII → PSI · Dark: Calvin (RuBisCO)","explanation":"C3: 1st product 3-PGA · C4: OAA (4C) · CAM: night CO₂ · RuBisCO = most abundant enzyme"}$j$),
    (906, 'class_11_12_sci', 'photo-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"C4 का first product?","solution":"CO₂ + PEP → OAA (4C)","answer":"OAA (4C)"}$j$),
    (906, 'class_11_12_sci', 'photo-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Most abundant enzyme?","options":["Amylase","RuBisCO","Catalase","Pepsin"],"answer":1,"explanation":"RuBisCO"},{"q":"Photolysis कहाँ?","options":["Stroma","PSII (thylakoid)","Mitochondria","Nucleus"],"answer":1,"explanation":"PSII: 2H₂O → 4H⁺ + 4e⁻ + O₂"}]}$j$),

    (907, 'class_11_12_sci', 'digest-1112-concept', 'concept', 1, 'पाचन — Class 11-12',
     $j${"text":"Digestion: mechanical + chemical। Enzymes: amylase (starch), pepsin (protein, stomach), trypsin (protein, SI), lipase (fats)। Liver (bile — emulsification), pancreas (digestive enzymes)। Villi/microvilli = absorption surface। Peristalsis।","note":"Board में digestive enzymes और absorption ज़रूरी हैं।"}$j$),
    (907, 'class_11_12_sci', 'digest-1112-formula', 'formula', 2, 'पाचन सूत्र',
     $j${"formula":"Mouth: starch→maltose (amylase) · Stomach: protein→peptide (pepsin, pH 1.5-3.5) · SI: peptide→AA (trypsin, pH 8)","explanation":"Bile (liver): fat emulsification (no enzyme) · Villi: absorption · Gastric juice: HCl + pepsinogen + mucus + intrinsic factor"}$j$),
    (907, 'class_11_12_sci', 'digest-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Stomach में protein digestion enzyme?","solution":"Pepsin (HCl activates pepsinogen)","answer":"Pepsin"}$j$),
    (907, 'class_11_12_sci', 'digest-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Bile role?","options":["Enzyme","Emulsification","Absorption","Storage"],"answer":1,"explanation":"Bile = emulsification (fat droplets)"},{"q":"Stomach pH?","options":["6.8","7.4","1.5-3.5","8.0"],"answer":2,"explanation":"HCl → pH 1.5-3.5"}]}$j$),

    (908, 'class_11_12_sci', 'resp-1112-concept', 'concept', 1, 'श्वसन — Class 11-12',
     $j${"text":"Respiration: aerobic (38 ATP, complete oxidation) vs anaerobic (2 ATP, partial)। Glycolysis → Krebs cycle → Oxidative phosphorylation (ETC)। Mitochondria = site। Respiratory substrates: glucose, fats, proteins। RQ (respiratory quotient)। Lungs: alveoli for gas exchange।","note":"Board में ATP yield और respiration stages ज़रूरी हैं।"}$j$),
    (908, 'class_11_12_sci', 'resp-1112-formula', 'formula', 2, 'श्वसन सूत्र',
     $j${"formula":"Aerobic: C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + 38 ATP · Anaerobic: glucose → lactic acid + 2 ATP","explanation":"RQ = CO₂/O₂ (carbs=1, fats~0.7, proteins~0.8) · Glycolysis (cytosol) + Krebs (matrix) + ETC (inner membrane)"}$j$),
    (908, 'class_11_12_sci', 'resp-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Glucose से aerobic ATP?","solution":"Complete oxidation","answer":"38 ATP"}$j$),
    (908, 'class_11_12_sci', 'resp-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Glycolysis कहाँ?","options":["Cytoplasm","Mitochondria","Nucleus","ER"],"answer":0,"explanation":"Glycolysis in cytoplasm"},{"q":"RQ for carbs?","options":["0.7","0.8","1","0.5"],"answer":2,"explanation":"Carbs RQ = 1 (CO₂/O₂ equal)"}]}$j$),

    (909, 'class_11_12_sci', 'circ-1112-concept', 'concept', 1, 'परिसंचरण — Class 11-12',
     $j${"text":"Circulatory system: heart 4 chambers, double circulation (pulmonary + systemic)। Cardiac cycle (0.8s: systole + diastole)। ECG (PQRST)। Blood: plasma + RBC + WBC + platelets। RBC: Hb, life 120 days। Blood groups: ABO, Rh factor। Cardiac output = HR × SV।","note":"Board में cardiac cycle, ECG, और blood groups ज़रूरी हैं।"}$j$),
    (909, 'class_11_12_sci', 'circ-1112-formula', 'formula', 2, 'परिसंचरण सूत्र',
     $j${"formula":"Cardiac output = HR × SV · Normal: 72 × 70 = 5040 mL/min ≈ 5 L/min · BP = 120/80 mmHg","explanation":"Cardiac cycle: 0.3s systole + 0.5s diastole = 0.8s · RBC life = 120 days · Hb = 13-17 g/dL"}$j$),
    (909, 'class_11_12_sci', 'circ-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"HR 75, SV 70 mL। CO?","solution":"75 × 70","answer":"5250 mL/min ≈ 5.25 L/min"}$j$),
    (909, 'class_11_12_sci', 'circ-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Cardiac output?","options":["2 L/min","5 L/min","10 L/min","15 L/min"],"answer":1,"explanation":"≈ 5 L/min"},{"q":"Mature RBC nucleus?","options":["Yes","No","Sometimes","None"],"answer":1,"explanation":"Mature mammalian RBC = anucleate"}]}$j$),

    (910, 'class_11_12_sci', 'trans-1112-concept', 'concept', 1, 'पादप परिवहन — Class 11-12',
     $j${"text":"Plant transport: xylem (water + minerals, upward) and phloem (food, source→sink)। Transpiration pull (cohesion-tension theory)। Root pressure, guttation। Stomata: guard cells (K⁺ influx → open)। Cohesion, adhesion, surface tension।","note":"Board में transpiration और xylem/phloem transport ज़रूरी हैं।"}$j$),
    (910, 'class_11_12_sci', 'trans-1112-formula', 'formula', 2, 'परिवहन तथ्य',
     $j${"formula":"Xylem: water (unidirectional, up) · Phloem: sugars + AA (bidirectional, source→sink)","explanation":"Transpiration pull = main water ascent force · Stomata open: K⁺ in → water in → turgid"}$j$),
    (910, 'class_11_12_sci', 'trans-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Stomata कब open?","solution":"Day (light → K⁺ influx → turgid)","answer":"Day time"}$j$),
    (910, 'class_11_12_sci', 'trans-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Phloem transport?","options":["Up only","Down only","Both directions","None"],"answer":2,"explanation":"Phloem bidirectional (source→sink)"},{"q":"Water ascent force?","options":["Root pressure","Transpiration pull","Capillarity","Gravity"],"answer":1,"explanation":"Cohesion-tension (transpiration pull)"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], array['class_11', 'class_12']::text[], 'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, count(*) from mtb.atoms 
-- where chapter_id in (880,881,882,883,920,895,896,897,898,899,901,902,903,904,905,906,907,908,909,910) 
--   and level_id='class_11_12_sci' and status='published' and not archived 
-- group by 1 order by 1;
-- Expected: each chapter = 4

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: 1619 + 80 = 1699