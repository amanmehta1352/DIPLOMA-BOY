with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ UPSC PHYSICS (875-883) ═══
    (875, 'upsc_civil', 'press-upsc-concept', 'concept', 1, 'दाब-तरल — UPSC CSE',
     $j${"text":"Pressure, buoyancy, fluid flow principles. Applications: dams (pressure with depth), submarines (ballast + pressure hull), hydraulic systems (Pascal's law), atmospheric pressure and weather, Bernoulli (aircraft lift, carburetor)। Groundwater pressure, artesian wells।","note":"UPSC में fluid physics को infrastructure/policy से link करते हैं।"}$j$),
    (875, 'upsc_civil', 'press-upsc-formula', 'formula', 2, 'दाब framework',
     $j${"formula":"P = F/A · P = ρgh (depth) · F_b = ρVg (Archimedes) · Bernoulli: P + ½ρv² + ρgh = const","explanation":"Pascal's law → hydraulic lift · 1 atm = 101325 Pa"}$j$),
    (875, 'upsc_civil', 'press-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Dam की base मोटी क्यों?","solution":"Pressure = ρgh → depth के साथ pressure बढ़ता → base पर ज़्यादा → thicker base","answer":"Depth pressure के कारण"}$j$),
    (875, 'upsc_civil', 'press-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Dam base मोटी?","options":["Aesthetics","Depth pressure","Wind","Cost"],"answer":1,"explanation":"P = ρgh increases with depth"},{"q":"Aircraft lift?","options":["Newton only","Bernoulli principle","Archimedes","Pascal"],"answer":1,"explanation":"Bernoulli (pressure difference)"}]}$j$),

    (876, 'upsc_civil', 'heat-upsc-concept', 'concept', 1, 'ऊष्मा — UPSC CSE',
     $j${"text":"Heat, temperature, thermal expansion. Heat transfer: conduction (solids), convection (fluids, monsoon), radiation (solar)। Applications: greenhouse effect, urban heat island, cooling towers, thermal power plants, insulation. Carnot efficiency limits। Latent heat (sweat cooling)।","note":"UPSC में heat transfer को climate/energy policy से जोड़ते हैं।"}$j$),
    (876, 'upsc_civil', 'heat-upsc-formula', 'formula', 2, 'ऊष्मा framework',
     $j${"formula":"Q = mcΔT · Q = mL · Carnot η = 1 - T_c/T_h · Stefan E = σT⁴","explanation":"Conduction: Q/t = kAΔT/L · Greenhouse: absorbed IR re-radiated, trapped"}$j$),
    (876, 'upsc_civil', 'heat-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Monsoon कैसे heat transfer से जुड़ा?","solution":"Land-sea temperature difference → convection → wind pattern → monsoon","answer":"Convection-driven (differential heating)"}$j$),
    (876, 'upsc_civil', 'heat-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Greenhouse effect?","options":["Ozone hole","IR trapping","Acid rain","Heat loss"],"answer":1,"explanation":"IR re-radiation trapped (CO₂, CH₄)"},{"q":"Monsoon drive?","options":["Radiation","Convection","Conduction","Latent only"],"answer":1,"explanation":"Convection (land-sea temp diff)"}]}$j$),

    (877, 'upsc_civil', 'wave-upsc-concept', 'concept', 1, 'तरंगें — UPSC CSE',
     $j${"text":"Waves: EM spectrum (radio, micro, IR, visible, UV, X-ray, gamma)। Applications: 5G (radio), radar, satellite communication (microwave), remote sensing (IR/visible), medical imaging (X-ray, gamma), UV damage. Spectrum allocation (TRAI), space weather (solar flares).","note":"UPSC में EM spectrum policy और applications पूछते हैं।"}$j$),
    (877, 'upsc_civil', 'wave-upsc-formula', 'formula', 2, 'तरंग framework',
     $j${"formula":"v = fλ · EM order: radio > micro > IR > visible (400-700nm) > UV > X-ray > gamma","explanation":"Higher frequency = higher energy (E = hf) · 5G: 3.3-3.8 GHz"}$j$),
    (877, 'upsc_civil', 'wave-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"5G auction क्यों important?","solution":"Radio spectrum is limited national resource — TRAI allocates for telecom growth","answer":"Spectrum = limited national resource"}$j$),
    (877, 'upsc_civil', 'wave-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Visible light range?","options":["100-400nm","400-700nm","700-1000nm",">1000nm"],"answer":1,"explanation":"400-700 nm"},{"q":"X-ray wavelength?","options":[">1000nm","400-700nm","100-400nm","0.01-10nm"],"answer":3,"explanation":"0.01-10 nm"}]}$j$),

    (878, 'upsc_civil', 'sound-upsc-concept', 'concept', 1, 'ध्वनि — UPSC CSE',
     $j${"text":"Sound: mechanical longitudinal wave, needs medium। Applications: sonar (ocean depth, fishing), ultrasound (medical, cleaning, NDT), noise pollution (dB, 65/55 limits)। Speed: air 340, water 1500, steel 5000 m/s. Ultrasound imaging (2-18 MHz)। Infrasound (<20 Hz — elephants, earthquakes)।","note":"UPSC में sound को health/environment से जोड़ते हैं।"}$j$),
    (878, 'upsc_civil', 'sound-upsc-formula', 'formula', 2, 'ध्वनि framework',
     $j${"formula":"v = fλ · dB = 10 log(I/I₀), I₀ = 10⁻¹² W/m² · Audible: 20-20,000 Hz · Sonar: d = vt/2","explanation":"Noise limits: industrial 85-90 dB, residential 55 dB (day)"}$j$),
    (878, 'upsc_civil', 'sound-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Noise pollution health impacts?","solution":"Hearing loss (>85 dB), hypertension, sleep disturbance, cognitive issues","answer":"Hearing + cardiovascular + cognitive"}$j$),
    (878, 'upsc_civil', 'sound-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Sonar uses?","options":["Light","Sound in water","Microwave","X-ray"],"answer":1,"explanation":"Sound reflection in water"},{"q":"Ultrasound frequency?","options":["<20 Hz","20-20kHz",">20 kHz","0 Hz"],"answer":2,"explanation":">20 kHz"}]}$j$),

    (879, 'upsc_civil', 'light-upsc-concept', 'concept', 1, 'प्रकाश — UPSC CSE',
     $j${"text":"Light: reflection, refraction, TIR (fiber optics — optical communication), dispersion (rainbow)। Applications: laser (surgery, cutting, range finding), fiber optic (Broadband India), optical instruments (telescope, microscope)। Total internal reflection (diamond sparkle, mirage)। Eye defects: myopia, hypermetropia।","note":"UPSC में optics को technology/infrastructure (Broadband) से जोड़ते हैं।"}$j$),
    (879, 'upsc_civil', 'light-upsc-formula', 'formula', 2, 'प्रकाश framework',
     $j${"formula":"Snell: n₁sinθ₁ = n₂sinθ₂ · TIR: sinθ_c = n₂/n₁ · Lens: 1/f = 1/v - 1/u","explanation":"Laser: coherent, monochromatic, directional · Fiber: TIR-based (low loss)"}$j$),
    (879, 'upsc_civil', 'light-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Fiber optic Broadband India में role?","solution":"High-speed internet via TIR (glass fibers), low loss over long distance","answer":"TIR-based high-speed internet"}$j$),
    (879, 'upsc_civil', 'light-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Fiber optic principle?","options":["Reflection","Total internal reflection","Refraction","Dispersion"],"answer":1,"explanation":"TIR (denser to rarer)"},{"q":"Laser property?","options":["Incoherent","Polychromatic","Coherent","Divergent"],"answer":2,"explanation":"Coherent (monochromatic, directional)"}]}$j$),

    (880, 'upsc_civil', 'elec-upsc-concept', 'concept', 1, 'विद्युत — UPSC CSE',
     $j${"text":"Electricity: current, voltage, resistance, Ohm's law. Power, energy (kWh)। Generation (thermal, hydro, nuclear, renewable), transmission (losses), distribution. Grid management (load balancing)। Electricity Act 2003 (reforms)। Renewable integration. Smart grid।","note":"UPSC में electricity policy और grid management angle पूछते हैं।"}$j$),
    (880, 'upsc_civil', 'elec-upsc-formula', 'formula', 2, 'विद्युत framework',
     $j${"formula":"V = IR · P = VI = I²R = V²/R · E = Pt · Transmission loss = I²R (reduced by high V)","explanation":"1 kWh = 1 unit · High-voltage transmission reduces loss (transformer)"}$j$),
    (880, 'upsc_civil', 'elec-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Transmission loss कैसे कम?","solution":"High voltage → lower current for same power → I²R loss reduced","answer":"High-voltage transmission (P=VI)"}$j$),
    (880, 'upsc_civil', 'elec-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Transmission loss कम करने के लिए?","options":["Low V","High V","Low R only","DC only"],"answer":1,"explanation":"High voltage → low current → low I²R"},{"q":"Ohm's law?","options":["V=IR","V=I/R","V=RI²","V=IR²"],"answer":0,"explanation":"V = IR"}]}$j$),

    (881, 'upsc_civil', 'mag-upsc-concept', 'concept', 1, 'चुंबकत्व — UPSC CSE',
     $j${"text":"Magnetism: Earth's magnetic field (navigation, compass), electromagnets, induction (Faraday)। Applications: transformers (power transmission), generators (electricity), motors (vehicles), MRI (medical)। Magnetic levitation (Maglev trains)। Geomagnetic storms (solar flares → grid damage)।","note":"UPSC में magnetism को infrastructure (grid, transport) से जोड़ते हैं।"}$j$),
    (881, 'upsc_civil', 'mag-upsc-formula', 'formula', 2, 'चुंबकत्व framework',
     $j${"formula":"Faraday: EMF = -dΦ/dt · Transformer: V_s/V_p = N_s/N_p · Earth's field ~50 μT","explanation":"Motor: F = BIL · Generator: rotating coil → EMF · Maglev: magnetic repulsion (no friction)"}$j$),
    (881, 'upsc_civil', 'mag-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Maglev trains के advantages?","solution":"No friction (levitation) → higher speed, less wear; challenges: cost, infrastructure","answer":"Frictionless (fast, less wear)"}$j$),
    (881, 'upsc_civil', 'mag-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Transformer basis?","options":["Ohm","Induction","Archimedes","Bernoulli"],"answer":1,"explanation":"Electromagnetic induction"},{"q":"Generator converts?","options":["Electrical→mechanical","Mechanical→electrical","Chemical→electrical","Light→heat"],"answer":1,"explanation":"Mechanical → electrical (induction)"}]}$j$),

    (882, 'upsc_civil', 'modern-upsc-concept', 'concept', 1, 'आधुनिक भौतिकी — UPSC CSE',
     $j${"text":"Modern physics: atom, nucleus, radioactivity. Nuclear fission (U-235, reactors) vs fusion (Sun, ITER)। E=mc². Applications: nuclear power, radiotherapy, radioisotopes (diagnosis, dating)। India's three-stage nuclear program (PHWR → FBR → Thorium)। Radiation safety (AERB)। Nuclear treaties (NPT, CTBT)।","note":"UPSC में nuclear physics को energy security और policy से जोड़ते हैं।"}$j$),
    (882, 'upsc_civil', 'modern-upsc-formula', 'formula', 2, 'आधुनिक framework',
     $j${"formula":"E = mc² · Fission: ²³⁵U + n → Ba + Kr + 3n + 200 MeV · N = N₀(1/2)^(t/t½)","explanation":"India 3-stage: PHWR (natural U) → FBR (Pu) → Thorium (³³²Th → ²³³U)"}$j$),
    (882, 'upsc_civil', 'modern-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"India's 3-stage nuclear program?","solution":"Stage 1: PHWR (U-238) → Pu-239; Stage 2: FBR (Pu + Th) → U-233; Stage 3: Th-based reactors","answer":"PHWR → FBR → Thorium"}$j$),
    (882, 'upsc_civil', 'modern-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"India's thorium reserve?","options":["Low","Among world's largest","None","Imported"],"answer":1,"explanation":"India has ~25% of world thorium"},{"q":"ITER is?","options":["Fission reactor","Fusion reactor","Solar","Tidal"],"answer":1,"explanation":"International fusion experiment"}]}$j$),

    (883, 'upsc_civil', 'mach-upsc-concept', 'concept', 1, 'मशीनें — UPSC CSE',
     $j${"text":"Simple machines: lever (classes 1/2/3), pulley, inclined plane, screw, wheel-axle. MA = Load/Effort. Efficiency। Applications: cranes, jacks, ramps (accessibility), bicycle gears, wheelchairs. Biomechanics: human body as machines (levers in limbs)।","note":"UPSC में simple machines को daily technology और accessibility से जोड़ते हैं।"}$j$),
    (883, 'upsc_civil', 'mach-upsc-formula', 'formula', 2, 'मशीन framework',
     $j${"formula":"MA = Load/Effort · VR = effort distance/load distance · η = MA/VR × 100%","explanation":"Lever class 1: see-saw · Class 2: wheelbarrow · Class 3: forearm · Inclined: VR = 1/sinθ"}$j$),
    (883, 'upsc_civil', 'mach-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Wheelchair ramp किस machine?","solution":"Inclined plane — MA = 1/sinθ, reduces effort for accessibility","answer":"Inclined plane (accessibility)"}$j$),
    (883, 'upsc_civil', 'mach-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Wheelbarrow lever class?","options":["1","2","3","None"],"answer":1,"explanation":"Class 2 (load between fulcrum and effort)"},{"q":"Efficiency formula?","options":["MA×VR","MA/VR","VR/MA","MA+VR"],"answer":1,"explanation":"η = MA/VR"}]}$j$),

    -- ═══ UPSC CHEMISTRY (890-899) ═══
    (890, 'upsc_civil', 'redox-upsc-concept', 'concept', 1, 'रेडॉक्स — UPSC CSE',
     $j${"text":"Redox: oxidation (loss e⁻) + reduction (gain e⁻)। OIL RIG. Applications: batteries (Li-ion — EVs, electronics), fuel cells (hydrogen economy), corrosion (infrastructure loss ~3% GDP), rusting prevention, electroplating। Oxidizing/reducing agents।","note":"UPSC में redox को energy/infrastructure से जोड़ते हैं।"}$j$),
    (890, 'upsc_civil', 'redox-upsc-formula', 'formula', 2, 'रेडॉक्स framework',
     $j${"formula":"Oxidation: loss e⁻ (OIL) · Reduction: gain e⁻ (RIG) · E°_cell = E°_cathode - E°_anode","explanation":"Li-ion: 3.7V, 250 Wh/kg · H₂ fuel cell: H₂ + O₂ → H₂O (zero emission)"}$j$),
    (890, 'upsc_civil', 'redox-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Hydrogen economy में fuel cell की भूमिका?","solution":"H₂ + O₂ → H₂O (electricity + heat, only water emission) — clean energy","answer":"Zero-emission power (water only)"}$j$),
    (890, 'upsc_civil', 'redox-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Fuel cell product?","options":["CO₂","H₂O only","CO","NOₓ"],"answer":1,"explanation":"H₂ + O₂ → H₂O"},{"q":"Corrosion GDP loss India?","options":["<1%","~3-4%","10%","20%"],"answer":1,"explanation":"~3-4% GDP"}]}$j$),

    (891, 'upsc_civil', 'acid-upsc-concept', 'concept', 1, 'अम्ल-क्षार — UPSC CSE',
     $j${"text":"Acids, bases, pH scale (0-14)। Neutralization. Buffer systems (blood)। Applications: acid rain (pH < 5.6, damages monuments — Taj Mahal), soil pH (agriculture), gastric acidity, water treatment (pH adjustment)। Indicators. Acid-base balance in environment (ocean acidification)।","note":"UPSC में pH को environment/heritage से जोड़ते हैं।"}$j$),
    (891, 'upsc_civil', 'acid-upsc-formula', 'formula', 2, 'अम्ल-क्षार framework',
     $j${"formula":"pH = -log[H⁺] · pH + pOH = 14 · Acid rain: pH < 5.6 (SO₂, NOₓ + H₂O → H₂SO₄, HNO₃)","explanation":"Blood buffer: H₂CO₃/HCO₃⁻ (pH 7.35-7.45) · Ocean acidification: CO₂ + H₂O → H₂CO₃"}$j$),
    (891, 'upsc_civil', 'acid-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Taj Mahal पर acid rain का effect?","solution":"SO₂ → H₂SO₄ → marble (CaCO₃) reacts → yellowing, corrosion","answer":"Marble corrosion (CaSO₄)"}$j$),
    (891, 'upsc_civil', 'acid-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Normal rain pH?","options":["7","5.6","7.4","4"],"answer":1,"explanation":"5.6 (CO₂ dissolved)"},{"q":"Ocean acidification cause?","options":["O₂","CO₂","CH₄","N₂"],"answer":1,"explanation":"CO₂ → H₂CO₃ → pH drop"}]}$j$),

    (892, 'upsc_civil', 'metal-upsc-concept', 'concept', 1, 'धातु-अधातु — UPSC CSE',
     $j${"text":"Metals/non-metals/metalloids. Reactivity series. Alloys: steel, stainless, brass, bronze। Applications: infrastructure (steel, aluminium), electronics (Cu, Au, Ag), aerospace (Ti, Al), EV (Li, Co, Ni)। Critical minerals (India import dependence). Recycling (circular economy)। Corrosion prevention।","note":"UPSC में metals को resource security और strategic autonomy से जोड़ते हैं।"}$j$),
    (892, 'upsc_civil', 'metal-upsc-formula', 'formula', 2, 'धातु framework',
     $j${"formula":"Reactivity: K>Na>Ca>Mg>Al>Zn>Fe>Cu>Ag>Au · Alloys: steel (Fe+C), brass (Cu+Zn), bronze (Cu+Sn)","explanation":"Critical: Li, Co, Ni (EV) · Rare earths (magnets) · India imports ~90% of critical minerals"}$j$),
    (892, 'upsc_civil', 'metal-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"India की critical minerals strategy?","solution":"KABIL (joint venture), bilateral with Australia/Argentina (Li), recycling initiatives","answer":"Import diversification + recycling"}$j$),
    (892, 'upsc_civil', 'metal-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"EV battery key metals?","options":["Fe, Cu","Li, Co, Ni","Al, Pb","Zn, Sn"],"answer":1,"explanation":"Lithium, cobalt, nickel"},{"q":"Brass alloy?","options":["Cu+Zn","Cu+Sn","Fe+C","Pb+Sn"],"answer":0,"explanation":"Cu + Zn"}]}$j$),

    (893, 'upsc_civil', 'carbon-upsc-concept', 'concept', 1, 'कार्बन — UPSC CSE',
     $j${"text":"Carbon compounds: organic chemistry, hydrocarbons (alkanes, alkenes, alkynes, aromatic)। Allotropes (diamond, graphite, fullerene, graphene)। Polymers (biodegradable, plastics pollution)। Petrochemicals। Biofuels (ethanol, biodiesel)। Carbon capture (CCUS)।","note":"UPSC में carbon को climate change (CO₂) और materials से जोड़ते हैं।"}$j$),
    (893, 'upsc_civil', 'carbon-upsc-formula', 'formula', 2, 'कार्बन framework',
     $j${"formula":"Alkane: CₙH₂ₙ₊₂ · Alkene: CₙH₂ₙ · Alkyne: CₙH₂ₙ₋₂ · Benzene: C₆H₆","explanation":"Biofuel: ethanol (C₂H₅OH) from sugarcane · Biodiesel from Jatropha"}$j$),
    (893, 'upsc_civil', 'carbon-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Ethanol blending program का उद्देश्य?","solution":"Reduce oil import, farmer income, lower emissions (E20 target by 2025)","answer":"Energy security + farmer income"}$j$),
    (893, 'upsc_civil', 'carbon-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Ethanol blending target (E20)?","options":["2030","2025","2035","2040"],"answer":1,"explanation":"E20 by 2025"},{"q":"C₂H₄ type?","options":["Alkane","Alkene","Alkyne","Aromatic"],"answer":1,"explanation":"Alkene (double bond)"}]}$j$),

    (894, 'upsc_civil', 'sol-upsc-concept', 'concept', 1, 'विलयन — UPSC CSE',
     $j${"text":"Solutions: solute + solvent, concentration (M, m, ppm)। Colligative properties. Osmosis (RO water purification)। Applications: water treatment (RO, desalination), IV fluids (isotonic saline), pollution (dissolved oxygen in water — BOD)। Solubility. Hardness of water।","note":"UPSC में solutions को water/pollution से जोड़ते हैं।"}$j$),
    (894, 'upsc_civil', 'sol-upsc-formula', 'formula', 2, 'विलयन framework',
     $j${"formula":"M = n/V(L) · π = iCRT · Osmosis: solvent moves low→high conc · 0.9% NaCl = isotonic","explanation":"BOD = O₂ consumed by microbes (pollution indicator) · DO < 4 mg/L = poor water quality"}$j$),
    (894, 'upsc_civil', 'sol-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"RO water purification principle?","solution":"Reverse osmosis — pressure > osmotic pressure → solvent passes membrane, salt rejected","answer":"Reverse osmosis (pressure-driven)"}$j$),
    (894, 'upsc_civil', 'sol-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"RO basis?","options":["Osmosis","Reverse osmosis","Distillation","Filtration"],"answer":1,"explanation":"Reverse osmosis (pressure)"},{"q":"BOD high = ?","options":["Clean water","More pollution","Neutral","Basic"],"answer":1,"explanation":"More organic pollution"}]}$j$),

    (895, 'upsc_civil', 'electro-upsc-concept', 'concept', 1, 'विद्युत रसायन — UPSC CSE',
     $j${"text":"Electrochemistry: electrolysis, batteries, fuel cells. Applications: EV batteries (Li-ion), grid storage, hydrogen production (electrolysis), metal refining (Al, Cu), electroplating, corrosion prevention। Nernst, Faraday. India's battery mission।","note":"UPSC में electrochemistry को energy transition से जोड़ते हैं।"}$j$),
    (895, 'upsc_civil', 'electro-upsc-formula', 'formula', 2, 'विद्युत रसायन framework',
     $j${"formula":"Faraday: m = (M/nF)It · E = E° - (0.059/n)log Q · F = 96500 C/mol","explanation":"Li-ion: 3.7V, 250 Wh/kg · H₂O electrolysis: 2H₂O → 2H₂ + O₂"}$j$),
    (895, 'upsc_civil', 'electro-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Green hydrogen production?","solution":"Electrolysis of water using renewable electricity → H₂ (zero-carbon)","answer":"Water electrolysis (renewable)"}$j$),
    (895, 'upsc_civil', 'electro-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Green hydrogen?","options":["From coal","From renewables + electrolysis","From fossil gas","From biomass"],"answer":1,"explanation":"Renewable-powered electrolysis"},{"q":"Electroplating cathode?","options":["Object","Anode","Solution","Source"],"answer":0,"explanation":"Object = cathode (metal deposits)"}]}$j$),

    (896, 'upsc_civil', 'fuel-upsc-concept', 'concept', 1, 'ईंधन — UPSC CSE',
     $j${"text":"Fuels: fossil (coal, oil, gas), biofuels (ethanol, biodiesel, biogas), hydrogen. Calorific value. Combustion and pollution (CO, CO₂, particulate)। Clean cooking (LPG, PNG, solar)। Energy transition (renewables)। India's energy mix. Octane/cetane numbers.","note":"UPSC में fuels को energy transition और climate से जोड़ते हैं।"}$j$),
    (896, 'upsc_civil', 'fuel-upsc-formula', 'formula', 2, 'ईंधन framework',
     $j${"formula":"Calorific: H₂(150) > CNG(50) > petrol/diesel(45) > coal(25-33) MJ/kg · Combustion: CₓHᵧ + O₂ → CO₂ + H₂O + heat","explanation":"Incomplete: CO + soot (pollution) · LPG: propane+butane · CNG: methane"}$j$),
    (896, 'upsc_civil', 'fuel-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Ujjwala Yojana का उद्देश्य?","solution":"Clean cooking fuel (LPG) to BPL women — reduce indoor air pollution, health, dignity","answer":"Clean cooking access (health + women)"}$j$),
    (896, 'upsc_civil', 'fuel-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Highest calorific value?","options":["Coal","Petrol","H₂","CNG"],"answer":2,"explanation":"H₂ ~150 MJ/kg"},{"q":"Ujjwala Yojana?","options":["Water","Cooking gas","Rural jobs","Solar"],"answer":1,"explanation":"LPG for BPL women"}]}$j$),

    (897, 'upsc_civil', 'poly-upsc-concept', 'concept', 1, 'बहुलक — UPSC CSE',
     $j${"text":"Polymers: natural (cellulose, rubber, protein, DNA) vs synthetic (polythene, PVC, nylon, PET)। Thermoplastic vs thermoset. Plastic pollution (single-use ban 2022)। Biodegradable, recycled. Applications: packaging, textiles, medical, aerospace composites। Plastic Waste Management Rules।","note":"UPSC में polymers को plastic pollution policy से जोड़ते हैं।"}$j$),
    (897, 'upsc_civil', 'poly-upsc-formula', 'formula', 2, 'बहुलक framework',
     $j${"formula":"Addition: polythene (from ethene) · Condensation: nylon (diamine + diacid) · Thermoset: bakelite","explanation":"Single-use plastic ban: <120 microns (2022) · Recyclable codes 1-7"}$j$),
    (897, 'upsc_civil', 'poly-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Single-use plastic ban (2022) — key items?","solution":"Plates, cups, cutlery, straws, earbuds, candy sticks, PVC banners (<100 micron)","answer":"Low-utility, high-litter items"}$j$),
    (897, 'upsc_civil', 'poly-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Plastic ban 2022 (single-use)?","options":["All plastic","Specific items","Only bags","None"],"answer":1,"explanation":"Specific list (plates, cups, straws)"},{"q":"Thermoset?","options":["Polythene","PVC","Bakelite","Nylon"],"answer":2,"explanation":"Bakelite (cannot remelt)"}]}$j$),

    (898, 'upsc_civil', 'corr-upsc-concept', 'concept', 1, 'संक्षारण — UPSC CSE',
     $j${"text":"Corrosion: rusting (Fe + O₂ + moisture), electrochemical process. Economic loss (~3-4% GDP). Prevention: galvanization, painting, alloying (stainless), cathodic protection. Infrastructure (bridges, pipelines), maritime, defense equipment। Corrosion of heritage (statues)।","note":"UPSC में corrosion को infrastructure economics और heritage से जोड़ते हैं।"}$j$),
    (898, 'upsc_civil', 'corr-upsc-formula', 'formula', 2, 'संक्षारण framework',
     $j${"formula":"4Fe + 3O₂ + xH₂O → 2Fe₂O₃·xH₂O · Requires BOTH O₂ + moisture · Galvanization: Zn (sacrificial)","explanation":"Cost: ~$2.5 trillion global (~3-4% GDP) · Salt accelerates (marine corrosion)"}$j$),
    (898, 'upsc_civil', 'corr-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Heritage monuments पर corrosion का impact?","solution":"Acid rain + pollution → stone/metal erosion (Taj Mahal, iron pillars)","answer":"Heritage erosion (pollution + acid rain)"}$j$),
    (898, 'upsc_civil', 'corr-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Rusting requires?","options":["Only O₂","Only water","Both O₂ + water","CO₂ only"],"answer":2,"explanation":"Both O₂ and moisture"},{"q":"Cathodic protection?","options":["Sacrificial anode","Sacrificial cathode","Inert","None"],"answer":0,"explanation":"More reactive metal = anode (Zn, Mg)"}]}$j$),

    (899, 'upsc_civil', 'lab-upsc-concept', 'concept', 1, 'लैब — UPSC CSE',
     $j${"text":"Lab techniques: titration, chromatography, spectroscopy (UV-Vis, IR, NMR, mass spec)। Applications: forensic (DNA, toxicology), environmental monitoring (pollutants), food safety, pharmaceutical quality, anti-counterfeit। Analytical chemistry policy (FSSAI, BIS)।","note":"UPSC में lab techniques को regulatory/forensic context से जोड़ते हैं।"}$j$),
    (899, 'upsc_civil', 'lab-upsc-formula', 'formula', 2, 'लैब framework',
     $j${"formula":"Beer-Lambert: A = εcl · Rf = spot/solvent distance · Titration: C₁V₁ = C₂V₂","explanation":"UV-Vis: concentration · IR: functional groups · NMR: structure · Mass: molecular weight"}$j$),
    (899, 'upsc_civil', 'lab-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Forensic DNA analysis steps?","solution":"Sample collection → extraction → PCR amplification → profiling → comparison","answer":"Extraction → PCR → profiling"}$j$),
    (899, 'upsc_civil', 'lab-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"PCR uses?","options":["Protein analysis","DNA amplification","pH measurement","Lipid test"],"answer":1,"explanation":"Polymerase Chain Reaction"},{"q":"IR spectroscopy?","options":["Structure","Functional groups","Mass","pH"],"answer":1,"explanation":"Identifies functional groups"}]}$j$),

    (903, 'upsc_civil', 'animal-upsc-concept', 'concept', 1, 'जंतु जगत — UPSC CSE',
     $j${"text":"Animal kingdom diversity: phyla (Porifera → Chordata)। Biodiversity (species, genetic, ecosystem)। Threats: habitat loss, poaching, climate change. Conservation: protected areas (national parks, sanctuaries, biosphere reserves), Wildlife Protection Act 1972, Project Tiger/Elephant, IUCN Red List।","note":"UPSC में animal diversity को biodiversity conservation policy से जोड़ते हैं।"}$j$),
    (903, 'upsc_civil', 'animal-upsc-formula', 'formula', 2, 'जंतु framework',
     $j${"formula":"Phyla order: Porifera → Cnidaria → Platyhelminthes → Annelida → Arthropoda (largest) → Mollusca → Echinodermata → Chordata","explanation":"IUCN: Extinct, Critically Endangered, Endangered, Vulnerable, Near Threatened, Least Concern"}$j$),
    (903, 'upsc_civil', 'animal-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Project Tiger की success?","solution":"Tiger reserves 9→54, population ~3,000 (2022); challenges: human-wildlife conflict","answer":"Conservation success + conflict management"}$j$),
    (903, 'upsc_civil', 'animal-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Largest phylum?","options":["Chordata","Mollusca","Arthropoda","Annelida"],"answer":2,"explanation":"Arthropoda"},{"q":"Project Tiger year?","options":["1970","1973","1980","1990"],"answer":1,"explanation":"1973"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[], 'general-science', 'hard', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, count(*) from mtb.atoms 
-- where chapter_id in (875,876,877,878,879,880,881,882,883,890,891,892,893,894,895,896,897,898,899,903) 
--   and level_id='upsc_civil' and status='published' and not archived 
-- group by 1 order by 1;
-- Expected: each chapter = 4

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: ~2700 + 80 = ~2780
