with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ DEFENCE PHYSICS (875-879) ═══
    (875, 'govt_defence', 'press-def-concept', 'concept', 1, 'दाब-तरल — NDA/CDS',
     $j${"text":"Defence fluids: submarines (P=ρgh depth pressure), torpedoes, ballast tanks, hydraulic systems in tanks/aircraft। Pascal's law → hydraulic brakes. Bernoulli for aircraft lift. Archimedes → buoyancy of ships. Sonar uses sound in water (not fluid pressure but related).","note":"Defence में submarine depth pressure, hydraulic systems, और buoyancy ज़रूरी हैं।"}$j$),
    (875, 'govt_defence', 'press-def-formula', 'formula', 2, 'दाब सूत्र',
     $j${"formula":"P = ρgh · F_b = ρVg · Bernoulli: P + ½ρv² + ρgh = const · Hydraulic: F₁/A₁ = F₂/A₂","explanation":"Submarine depth 100m: P = 1030×9.8×100 ≈ 1 MPa + atm · Aircraft lift: ½ρv²S·CL"}$j$),
    (875, 'govt_defence', 'press-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Submarine 200m depth। Water pressure? (ρ=1030)","solution":"P = 1030 × 9.8 × 200","answer":"≈ 2.02 MPa (≈20 atm)"}$j$),
    (875, 'govt_defence', 'press-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Submarine depth में pressure?","options":["P∝h","P∝h²","P∝√h","P independent"],"answer":0,"explanation":"P = ρgh → P ∝ h"},{"q":"Hydraulic lift basis?","options":["Bernoulli","Pascal","Archimedes","Newton"],"answer":1,"explanation":"Pascal's law → hydraulic systems"}]}$j$),

    (876, 'govt_defence', 'heat-def-concept', 'concept', 1, 'ऊष्मा — NDA/CDS',
     $j${"text":"Defence heat: jet engines (thermodynamics), gun barrel heating, thermal imaging (IR), heat-seeking missiles, camouflage (thermal signature). Carnot efficiency (engine limits). Specific heat, latent heat. Thermal expansion affects artillery accuracy.","note":"Defence में jet engine, thermal imaging, और heat-seeking ज़रूरी हैं।"}$j$),
    (876, 'govt_defence', 'heat-def-formula', 'formula', 2, 'ऊष्मा सूत्र',
     $j${"formula":"Q = mcΔT · Carnot η = 1 - T_c/T_h · Wien λ_max T = 2.9×10⁻³ · Stefan E = σT⁴","explanation":"Jet engine η ~ 40% · Thermal imaging: object temp → IR wavelength · Gun barrel: friction → heat"}$j$),
    (876, 'govt_defence', 'heat-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Carnot engine T_h=800K, T_c=300K। η?","solution":"1 - 300/800 = 1 - 0.375","answer":"62.5%"}$j$),
    (876, 'govt_defence', 'heat-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Heat-seeking missile detects?","options":["Visible","IR","UV","X-ray"],"answer":1,"explanation":"IR (thermal radiation)"},{"q":"Carnot max efficiency limit?","options":["100%","<100%","50%","0%"],"answer":1,"explanation":"<100% (unless T_c=0 or T_h=∞)"}]}$j$),

    (877, 'govt_defence', 'wave-def-concept', 'concept', 1, 'तरंगें — NDA/CDS',
     $j${"text":"Defence waves: radar (radio waves, ~10cm), sonar (sound in water), radio communication (HF/VHF/UHF), jamming (EW)। Radar: R = c·t/2 (echo time)। Doppler radar for moving targets. Sonar: v≈1500 m/s in water.","note":"Defence में radar range, sonar, और Doppler ज़रूरी हैं।"}$j$),
    (877, 'govt_defence', 'wave-def-formula', 'formula', 2, 'तरंग सूत्र',
     $j${"formula":"Radar: R = ct/2 (c=3×10⁸ m/s) · Sonar: R = vt/2 (v≈1500 m/s water) · Doppler: Δf/f = 2v_target/c","explanation":"Radar wavelength ~cm (X-band ~3cm) · Sonar frequency ~kHz · Doppler shift for speed measurement"}$j$),
    (877, 'govt_defence', 'wave-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Radar echo 100 μs बाद। Target distance? (c=3×10⁸)","solution":"R = c·t/2 = 3×10⁸ × 100×10⁻⁶ / 2","answer":"15 km"}$j$),
    (877, 'govt_defence', 'wave-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Radar uses?","options":["Sound","Radio waves","X-rays","UV"],"answer":1,"explanation":"Radar = radio waves (electromagnetic)"},{"q":"Sonar speed in water?","options":["340 m/s","1500 m/s","3×10⁸ m/s","1000 m/s"],"answer":1,"explanation":"≈1500 m/s (4.5× air)"}]}$j$),

    (878, 'govt_defence', 'sound-def-concept', 'concept', 1, 'ध्वनि — NDA/CDS',
     $j${"text":"Defence sound: sonar (active/passive), underwater communication, noise of aircraft (detection), sniper location by sound, flash-bang grenades (disorientation)। Supersonic: Mach number, sonic boom. Speed of sound in air ~340 m/s, water ~1500, steel ~5000.","note":"Defence में sonar, sonic boom, और Mach number ज़रूरी हैं।"}$j$),
    (878, 'govt_defence', 'sound-def-formula', 'formula', 2, 'ध्वनि सूत्र',
     $j${"formula":"v_sound (air) ≈ 340 m/s · Mach number M = v_object/v_sound · Sonar R = vt/2","explanation":"Mach 1 = 340 m/s · Mach 2 = 680 m/s · Sonic boom at M>1"}$j$),
    (878, 'govt_defence', 'sound-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Fighter 680 m/s। Mach number?","solution":"M = 680/340","answer":"Mach 2"}$j$),
    (878, 'govt_defence', 'sound-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Sonic boom कब?","options":["M<1","M=1","M>1","M=0"],"answer":2,"explanation":"M>1 (supersonic)"},{"q":"Sonar speed water में?","options":["340","1500","3000","5000"],"answer":1,"explanation":"≈1500 m/s"}]}$j$),

    (879, 'govt_defence', 'light-def-concept', 'concept', 1, 'प्रकाश — NDA/CDS',
     $j${"text":"Defence optics: night vision (IR + image intensification), laser range finder (LIDAR), sniper scope (telescope), camouflage (visual), periscope (submarine), laser-guided weapons। Reflection, refraction, TIR (fiber optics)। Laser: coherent, monochromatic।","note":"Defence में laser, night vision, और periscope ज़रूरी हैं।"}$j$),
    (879, 'govt_defence', 'light-def-formula', 'formula', 2, 'प्रकाश सूत्र',
     $j${"formula":"Laser range: d = c·t/2 · TIR: sinθ_c = n₂/n₁ · Lens: 1/f = 1/v - 1/u","explanation":"Laser rangefinder: precision ~1 m · Night vision: amplifies IR ~10,000× · Periscope: 2 mirrors/reflections"}$j$),
    (879, 'govt_defence', 'light-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Laser echo 2 μs बाद। Distance?","solution":"d = c·t/2 = 3×10⁸ × 2×10⁻⁶ / 2","answer":"300 m"}$j$),
    (879, 'govt_defence', 'light-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Night vision किस पर काम?","options":["Visible","IR","UV","X-ray"],"answer":1,"explanation":"IR (thermal + amplification)"},{"q":"Laser property?","options":["Incoherent","Polychromatic","Coherent","Divergent"],"answer":2,"explanation":"Laser = coherent (same phase/freq)"}]}$j$),

    -- ═══ DEFENCE CHEMISTRY (885-888) ═══
    (885, 'govt_defence', 'matter-def-concept', 'concept', 1, 'पदार्थ — NDA/CDS',
     $j${"text":"Defence: explosives (TNT, RDX, HMX), propellants (gunpowder, cordite), gases (tear gas CS, nerve agents)। Ideal gas: PV=nRT. Gunpowder: KNO₃+S+C → rapid gas → pressure. Shape charge effect: explosive+metal → jet।","note":"Defence में explosives, propellants, और gas laws ज़रूरी हैं।"}$j$),
    (885, 'govt_defence', 'matter-def-formula', 'formula', 2, 'पदार्थ सूत्र',
     $j${"formula":"PV = nRT · Gunpowder: 2KNO₃ + S + 3C → K₂S + N₂ + 3CO₂ (rapid gas)","explanation":"Explosive velocity: TNT 6900 m/s, RDX 8750 m/s, HMX 9100 m/s · Ideal gas R = 8.314 J/mol·K"}$j$),
    (885, 'govt_defence', 'matter-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Ideal gas: 2L, 1 atm, 300K। n?","solution":"n = PV/RT = 101325 × 0.002 / (8.314 × 300)","answer":"≈ 0.081 mol"}$j$),
    (885, 'govt_defence', 'matter-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"RDX का full form?","options":["Research Dept Explosive","Royal Demolition Explosive","Rapid Detonation Explosive","Reactive Def Explosive"],"answer":0,"explanation":"Research Department Explosive"},{"q":"Ideal gas equation?","options":["PV = nRT","PV = RT","P = nRT","V = nRT"],"answer":0,"explanation":"PV = nRT"}]}$j$),

    (886, 'govt_defence', 'atom-def-concept', 'concept', 1, 'परमाणु संरचना — NDA/CDS',
     $j${"text":"Nuclear weapons physics: fission (U-235, Pu-239), fusion (H-bomb: D+T→He+n)। Critical mass (chain reaction)। E=mc² → 1g mass = 9×10¹³ J। Enrichment, nuclear reactors (control rods B, Cd)। Radiation: α, β, γ; effects on body (rads, sieverts)।","note":"Defence में nuclear fission/fusion, critical mass, और radiation ज़रूरी हैं।"}$j$),
    (886, 'govt_defence', 'atom-def-formula', 'formula', 2, 'परमाणु सूत्र',
     $j${"formula":"E = mc² · Fission: ²³⁵U + n → ¹⁴¹Ba + ⁹²Kr + 3n + 200 MeV · Fusion: D + T → ⁴He + n + 17.6 MeV","explanation":"Critical mass U-235 ≈ 52 kg (bare), ~15 kg with reflector · 1 kg U fission ≈ 8×10¹³ J"}$j$),
    (886, 'govt_defence', 'atom-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"1g mass → energy (E=mc²)?","solution":"E = 10⁻³ × (3×10⁸)² = 10⁻³ × 9×10¹⁶","answer":"9 × 10¹³ J (≈ 21.5 kt TNT)"}$j$),
    (886, 'govt_defence', 'atom-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"H-bomb में?","options":["Fission","Fusion","Both","Neither"],"answer":2,"explanation":"H-bomb: fission trigger + fusion main"},{"q":"Critical mass का मतलब?","options":["Max mass","Min mass for chain reaction","Total mass","Half mass"],"answer":1,"explanation":"Min mass to sustain chain reaction"}]}$j$),

    (887, 'govt_defence', 'periodic-def-concept', 'concept', 1, 'आवर्त सारणी — NDA/CDS',
     $j${"text":"Defence materials: uranium (nuclear), plutonium (Pu-239), depleted uranium (DU — tank armor/penetrators), tungsten (AP shells), titanium (aircraft, light+strong), aluminum (aircraft), steel (armor)। Rare earths for magnets (radar, missiles)।","note":"Defence में strategic metals और alloys ज़रूरी हैं।"}$j$),
    (887, 'govt_defence', 'periodic-def-formula', 'formula', 2, 'आवर्त तथ्य',
     $j${"formula":"U-235 (fissile), Pu-239 (fissile), DU (depleted U — high density 19.1 g/cm³) · Tungsten (W): density 19.3 g/cm³","explanation":"Titanium: high strength/weight ratio (aircraft) · Armor: RHA steel, ceramic composite · Radar: GaN (gallium nitride)"}$j$),
    (887, 'govt_defence', 'periodic-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"DU density vs lead? (DU~19.1, Pb~11.3)","solution":"DU अधिक dense (19.1 vs 11.3)","answer":"DU ≈ 1.7× lead density"}$j$),
    (887, 'govt_defence', 'periodic-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Aircraft में कौन metal?","options":["Fe","Ti","Cu","Pb"],"answer":1,"explanation":"Titanium (light + strong)"},{"q":"AP shells में?","options":["Steel","Tungsten/DU","Aluminum","Copper"],"answer":1,"explanation":"Tungsten/DU (high density)"}]}$j$),

    (888, 'govt_defence', 'bond-def-concept', 'concept', 1, 'आबंधन — NDA/CDS',
     $j${"text":"Defence chemistry: explosives (nitro compounds — TNT: trinitrotoluene), propellants (nitrocellulose + nitroglycerin = cordite), nerve agents (organophosphates), smoke (white phosphorus)। Bond energy in explosives (N-N, N-O, C-N unstable, release gas+heat)।","note":"Defence में explosive chemistry और propellants ज़रूरी हैं।"}$j$),
    (888, 'govt_defence', 'bond-def-formula', 'formula', 2, 'आबंधन तथ्य',
     $j${"formula":"TNT: C₆H₂(NO₂)₃CH₃ · Nitroglycerin: C₃H₅N₃O₉ · Detonation: rapid decomposition → gas + heat","explanation":"Nitro group -NO₂ → explosive when many on molecule · Cordite: nitrocellulose + nitroglycerin + petroleum jelly"}$j$),
    (888, 'govt_defence', 'bond-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"TNT का full name?","solution":"Tri-nitro-toluene (C₆H₂(NO₂)₃CH₃)","answer":"2,4,6-trinitrotoluene"}$j$),
    (888, 'govt_defence', 'bond-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"TNT किस class?","options":["Alcohol","Nitro compound","Amine","Acid"],"answer":1,"explanation":"Nitro compound (-NO₂)"},{"q":"Propellant example?","options":["TNT","Cordite","RDX","HMX"],"answer":1,"explanation":"Cordite = propellant (not high explosive)"}]}$j$),

    -- ═══ DEFENCE BIOLOGY (901-906) ═══
    (901, 'govt_defence', 'cell-def-concept', 'concept', 1, 'कोशिका — NDA/CDS',
     $j${"text":"Defence medicine: cell biology basics — cells affected by radiation, chemical agents, biological weapons। Prokaryotic vs eukaryotic। RBC (O₂), WBC (immunity), platelets (clotting)। Cell organelles। Radiation effects: DNA damage (mitosis arrest)।","note":"Defence में radiation effects, blood cells, और biological warfare ज़रूरी हैं।"}$j$),
    (901, 'govt_defence', 'cell-def-formula', 'formula', 2, 'कोशिका तथ्य',
     $j${"formula":"RBC: O₂ transport (Hb), no nucleus (mammal) · WBC: 4,000-11,000/μL · Platelets: 150,000-450,000/μL","explanation":"Radiation: LD50 ~4 Gy (whole body) · Cell cycle arrest (G2/M checkpoint) after DNA damage"}$j$),
    (901, 'govt_defence', 'cell-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Human body cells approx?","solution":"~37 trillion (3.7×10¹³)","answer":"≈ 3.7 × 10¹³ cells"}$j$),
    (901, 'govt_defence', 'cell-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"O₂ transport?","options":["WBC","RBC","Platelets","Plasma"],"answer":1,"explanation":"RBC (hemoglobin)"},{"q":"LD50 radiation?","options":["1 Gy","4 Gy","10 Gy","40 Gy"],"answer":1,"explanation":"~4 Gy (whole body, no treatment)"}]}$j$),

    (902, 'govt_defence', 'tissue-def-concept', 'concept', 1, 'ऊतक — NDA/CDS',
     $j${"text":"Defence medical: tissue types — epithelial (barrier), connective (bone, blood), muscular (skeletal, smooth, cardiac), nervous (neurons)। Combat injuries: tissue damage (blast, fragment)। Blood typing (ABO, Rh) critical for transfusion. Burns damage epithelium।","note":"Defence में blood typing, burn tissue damage, और trauma ज़रूरी हैं।"}$j$),
    (902, 'govt_defence', 'tissue-def-formula', 'formula', 2, 'ऊतक तथ्य',
     $j${"formula":"Blood: 4.5-6 L adult · Plasma 55% + cells 45% · ABO + Rh (8 types)","explanation":"Burns: superficial (epidermis), partial (dermis), full (all layers)। Epithelial: barrier function"}$j$),
    (902, 'govt_defence', 'tissue-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Body में blood volume?","solution":"~7% body weight (70kg → 5L)","answer":"≈ 4.5-6 L"}$j$),
    (902, 'govt_defence', 'tissue-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Universal donor?","options":["A+","B+","AB+","O-"],"answer":3,"explanation":"O- (no antigens)"},{"q":"Blood clotting cells?","options":["RBC","WBC","Platelets","Plasma"],"answer":2,"explanation":"Platelets (thrombocytes)"}]}$j$),

    (903, 'govt_defence', 'animal-def-concept', 'concept', 1, 'जंतु जगत — NDA/CDS',
     $j${"text":"Defence biology: disease vectors — mosquito (malaria: Anopheles, dengue: Aedes), tick, flea। Biological warfare agents: anthrax (Bacillus anthracis), plague (Yersinia), smallpox (variola virus)। Zoonotic diseases: from animals to humans.","note":"Defence में disease vectors और biowarfare agents ज़रूरी हैं।"}$j$),
    (903, 'govt_defence', 'animal-def-formula', 'formula', 2, 'जंतु तथ्य',
     $j${"formula":"Malaria: Plasmodium (Anopheles) · Dengue: virus (Aedes) · Anthrax: Bacillus anthracis (spores)","explanation":"Biowarfare: Category A (anthrax, plague, smallpox, botulism, tularemia)"}$j$),
    (903, 'govt_defence', 'animal-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Malaria vector?","solution":"Female Anopheles mosquito","answer":"Anopheles (Plasmodium)"}$j$),
    (903, 'govt_defence', 'animal-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Anthrax का cause?","options":["Virus","Bacteria","Fungi","Protozoa"],"answer":1,"explanation":"Bacillus anthracis (bacteria)"},{"q":"Dengue vector?","options":["Anopheles","Aedes","Culex","Tick"],"answer":1,"explanation":"Aedes aegypti mosquito"}]}$j$),

    (904, 'govt_defence', 'plant-def-concept', 'concept', 1, 'पादप जगत — NDA/CDS',
     $j${"text":"Defence botany: camouflage (natural — leaves, bushes), poisonous plants, medicinal plants (morphine from poppy, quinine from cinchona)। Plant-based agents: ricin (from castor bean — toxin)। Camouflage color: chlorophyll green।","note":"Defence में camouflage, medicinal plants, और toxins ज़रूरी हैं।"}$j$),
    (904, 'govt_defence', 'plant-def-formula', 'formula', 2, 'पादप तथ्य',
     $j${"formula":"Chlorophyll: Mg-centered, absorbs red+blue, reflects green · Morphine: Papaver somniferum · Ricin: Ricinus communis","explanation":"Camouflage: matching environment (green → forest, tan → desert) · Poisonous: nightshade, hemlock"}$j$),
    (904, 'govt_defence', 'plant-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Ricin किससे?","solution":"Castor bean (Ricinus communis)","answer":"Castor beans (Ricinus)"}$j$),
    (904, 'govt_defence', 'plant-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Chlorophyll में metal?","options":["Fe","Mg","Zn","Cu"],"answer":1,"explanation":"Mg (magnesium)"},{"q":"Ricin source?","options":["Poppy","Castor","Cinchona","Tobacco"],"answer":1,"explanation":"Castor bean"}]}$j$),

    (905, 'govt_defence', 'nutrition-def-concept', 'concept', 1, 'पोषण — NDA/CDS',
     $j${"text":"Defence nutrition: field rations (caloric needs 3000-4000 Cal/day for active soldiers), dehydration (water need 4-6 L/day, hot climates), vitamins for performance (B complex, C), iron for hemoglobin (altitude), protein for muscle repair। Combat stress affects digestion.","note":"Defence में caloric needs, dehydration, और vitamins ज़रूरी हैं।"}$j$),
    (905, 'govt_defence', 'nutrition-def-formula', 'formula', 2, 'पोषण तथ्य',
     $j${"formula":"Soldier Cal/day: 3000-4000 (active) · Water: 4-6 L/day (hot) · Protein: 1.2-1.6 g/kg/day","explanation":"Carbs: 4 Cal/g, protein: 4, fat: 9 · Iron needs higher at altitude (hypoxia)"}$j$),
    (905, 'govt_defence', 'nutrition-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"70kg soldier, 1.5 g/kg protein। Protein/day?","solution":"70 × 1.5","answer":"105 g/day"}$j$),
    (905, 'govt_defence', 'nutrition-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Active soldier Cal/day?","options":["1500-2000","2000-2500","3000-4000","5000+"],"answer":2,"explanation":"3000-4000 Cal (active)"},{"q":"Altitude पर ज़रूरत?","options":["Iron","Calcium","Vitamin K","Sodium"],"answer":0,"explanation":"Iron (hypoxia → more RBC)"}]}$j$),

    (906, 'govt_defence', 'photo-def-concept', 'concept', 1, 'प्रकाश संश्लेषण — NDA/CDS',
     $j${"text":"Defence photosynthesis: O₂ production (atmosphere, life support), camouflage (green plants), plant-based oxygen generation in submarines (experimental)। C3/C4/CAM differences. Chlorophyll absorbs red+blue, reflects green (camouflage basis)।","note":"Defence में O₂ production और camouflage ज़रूरी हैं।"}$j$),
    (906, 'govt_defence', 'photo-def-formula', 'formula', 2, 'प्रकाश संश्लेषण सूत्र',
     $j${"formula":"6CO₂ + 6H₂O + light → C₆H₁₂O₆ + 6O₂","explanation":"1 hectare forest → ~10-15 tonnes O₂/year · Human: 550 L O₂/day · Algae: high O₂ per area"}$j$),
    (906, 'govt_defence', 'photo-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Human O₂ consumption/day?","solution":"≈ 550 L/day (at rest), more in activity","answer":"550 L (rest) → 1000+ L (active)"}$j$),
    (906, 'govt_defence', 'photo-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Photosynthesis O₂ source?","options":["CO₂","H₂O","Glucose","Air"],"answer":1,"explanation":"Water splitting (photolysis)"},{"q":"Chlorophyll क्या reflect करता?","options":["Red","Blue","Green","All"],"answer":2,"explanation":"Green (that's why leaves green)"}]}$j$),

    -- ═══ BANKING MATHS (6-10) ═══
    (6, 'banking', 'age-bank-concept', 'concept', 1, 'आयु — Banking',
     $j${"text":"Age shortcuts: 1-2 variable equations, ratio across time। Fast trick: if 'a times now, b times later': a·x + n = b(x+n)। Banking में 1-2 questions, 30-45 sec target।","note":"Banking में speed के लिए shortcuts ज़रूरी हैं।"}$j$),
    (6, 'banking', 'age-bank-formula', 'formula', 2, 'आयु shortcuts',
     $j${"formula":"a·x + n = b(x+n) → x(a-b) = n(b-1) → x = n(b-1)/(a-b)","explanation":"If father 3× son now, 2× 12y later: 3x+12=2(x+12) → x=12, father=36"}$j$),
    (6, 'banking', 'age-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"Father 4× son now; 20y later 2×। Son now?","solution":"4x+20 = 2(x+20) → 4x+20=2x+40 → 2x=20 → x=10","answer":"Son = 10, Father = 40"}$j$),
    (6, 'banking', 'age-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"Father 3×, son 15। Father age?","options":["30","40","45","50"],"answer":2,"explanation":"3×15 = 45"},{"q":"A 24, B 16। कितने साल में A=2B?","solution":"24+n = 2(16+n) → 24+n=32+2n → n=-8 → 8 साल पहले","options":["4y ago","8y ago","12y ago","16y ago"],"answer":1,"explanation":"8 years ago: A=16, B=8 (16=2×8)"}]}$j$),

    (7, 'banking', 'mix-bank-concept', 'concept', 1, 'मिश्रण — Banking',
     $j${"text":"Alligation: cheap:dear = (dear-mean):(mean-cheap)। Banking में milk-water, tea, alloys के questions। Fast trick: 2-3 steps में solve। Mixture + profit-loss combination।","note":"Banking में alligation shortcut ज़रूरी है।"}$j$),
    (7, 'banking', 'mix-bank-formula', 'formula', 2, 'मिश्रण shortcuts',
     $j${"formula":"cheap:dear = (dear-mean):(mean-cheap) · Mean price = (q₁p₁+q₂p₂)/(q₁+q₂)","explanation":"Alligation cross: two prices → mean → ratio in 1 step"}$j$),
    (7, 'banking', 'mix-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"₹40 और ₹60 चीनी मिलाएँ → ₹45। Ratio?","solution":"(60-45):(45-40) = 15:5","answer":"3:1 (cheap:dear)"}$j$),
    (7, 'banking', 'mix-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"₹30, ₹50 मिलाएँ → ₹42। Ratio?","options":["2:3","3:2","1:1","4:5"],"answer":0,"explanation":"(50-42):(42-30) = 8:12 = 2:3"},{"q":"20L, 25% water। Water?","options":["4L","5L","6L","7L"],"answer":1,"explanation":"25% of 20 = 5L"}]}$j$),

    (8, 'banking', 'tw-bank-concept', 'concept', 1, 'समय-कार्य — Banking',
     $j${"text":"Time-work shortcuts: 1/x + 1/y = 1/t → t = xy/(x+y)। Efficiency: if A twice as good as B, time ratio 1:2। Wages ∝ work done (or efficiency)। Banking में 1-2 questions।","note":"Banking में combined work और efficiency shortcut ज़रूरी हैं।"}$j$),
    (8, 'banking', 'tw-bank-formula', 'formula', 2, 'कार्य shortcuts',
     $j${"formula":"Combined: t = xy/(x+y) · Efficiency ratio: time ratio inversely · Wages ∝ work done","explanation":"A 12d, B 18d → t = 216/30 = 7.2d (quick)"}$j$),
    (8, 'banking', 'tw-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"A 10d, B 15d। Together?","solution":"t = 10×15/(10+15) = 150/25","answer":"6 days (3 sec)"}$j$),
    (8, 'banking', 'tw-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"A 8d, B 12d। Together?","options":["4d","4.8d","5d","6d"],"answer":1,"explanation":"8×12/(8+12) = 96/20 = 4.8d"},{"q":"A twice as efficient as B। Time ratio?","options":["1:2","2:1","1:4","4:1"],"answer":0,"explanation":"Time inversely proportional to efficiency"}]}$j$),

    (9, 'banking', 'tsd-bank-concept', 'concept', 1, 'चाल-दूरी — Banking',
     $j${"text":"Speed shortcuts: 1 km/h = 5/18 m/s। Average speed (equal distance) = HM = 2v₁v₂/(v₁+v₂)। Relative speed: same diff, opposite sum. Boat: down b+s, up b-s. Train: L/v or (L+P)/v।","note":"Banking में train, boat, और avg speed shortcuts ज़रूरी हैं।"}$j$),
    (9, 'banking', 'tsd-bank-formula', 'formula', 2, 'चाल shortcuts',
     $j${"formula":"Avg speed (equal D) = 2v₁v₂/(v₁+v₂) · Relative (same) = |v₁-v₂|, opposite = v₁+v₂","explanation":"Train platform: (L+P)/v · Boat up: b-s, down: b+s"}$j$),
    (9, 'banking', 'tsd-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"100m train 10 m/s, 200m platform। Time?","solution":"(100+200)/10","answer":"30 sec"}$j$),
    (9, 'banking', 'tsd-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"Avg 60, 40 equal distance?","options":["50","48","46","52"],"answer":1,"explanation":"2×60×40/100 = 48"},{"q":"36 km/h in m/s?","options":["8","10","12","15"],"answer":1,"explanation":"36 × 5/18 = 10 m/s"}]}$j$),

    (10, 'banking', 'num-bank-concept', 'concept', 1, 'संख्या पद्धति — Banking',
     $j${"text":"Number shortcuts: divisibility (3=sum, 9=sum, 11=alternating sum)। HCF-LCM: HCF×LCM = a×b। Cyclicity of units digit: cycle 4 (2,3,7,8), cycle 2 (4,9), cycle 1 (5,6,0,1)। Remainder theorem: dividend = divisor×quotient + remainder।","note":"Banking में divisibility, cyclicity, और remainder shortcuts ज़रूरी हैं।"}$j$),
    (10, 'banking', 'num-bank-formula', 'formula', 2, 'संख्या shortcuts',
     $j${"formula":"HCF×LCM = a×b · Units digit cycle: 2,3,7,8 (4), 4,9 (2), 5,6,0,1 (1)","explanation":"Divisibility 11: (sum odd positions) - (sum even positions) = 0 or multiple of 11"}$j$),
    (10, 'banking', 'num-bank-example', 'example', 3, 'Banking numerical',
     $j${"question":"7¹⁰⁰ units digit?","solution":"Cycle 4 (7,9,3,1)। 100 mod 4 = 0 → units = 1","answer":"1"}$j$),
    (10, 'banking', 'num-bank-mcq', 'mcq', 4, 'Banking MCQs',
     $j${"questions":[{"q":"12, 18 LCM?","options":["24","36","48","72"],"answer":1,"explanation":"LCM = 36 (12=2²×3, 18=2×3²)"},{"q":"3¹⁰⁰ units?","solution":"Cycle 4 (3,9,7,1)। 100 mod 4 = 0 → 1","options":["1","3","7","9"],"answer":0,"explanation":"Cycle ends at 4th = 1"}]}$j$)
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
-- where chapter_id in (875,876,877,878,879,885,886,887,888,901,902,903,904,905,906,6,7,8,9,10)
--   and status='published' and not archived
-- group by level_id;
-- Expected: govt_defence=60 (15 chapters), banking=20 (5 chapters)
-- Total delta: 80
