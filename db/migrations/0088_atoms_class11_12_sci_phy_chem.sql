with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ CLASS 11-12 SCIENCE PHYSICS (870-879) ═══
    (870, 'class_11_12_sci', 'phy-meas-1112-concept', 'concept', 1, 'मापन — Class 11-12',
     $j${"text":"SI base units (7): m, kg, s, A, K, mol, cd। Derived units। Dimensional formula: [MᵃLᵇTᶜ]। Dimensional analysis checks equations। Significant figures: precision के according। Errors: absolute, relative, percentage। Propagation of errors।","note":"Board में dimensional analysis और error propagation ज़रूरी हैं।"}$j$),
    (870, 'class_11_12_sci', 'phy-meas-1112-formula', 'formula', 2, 'मापन सूत्र',
     $j${"formula":"[Force] = [MLT⁻²] · [Energy] = [ML²T⁻²] · [Pressure] = [ML⁻¹T⁻²] · % error = (Δa/a) × 100","explanation":"Sum/diff: Δz = Δx + Δy · Product: Δz/z = Δx/x + Δy/y · Vernier LC = 0.1 mm, screw gauge LC = 0.01 mm"}$j$),
    (870, 'class_11_12_sci', 'phy-meas-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Force का dimensional formula?","solution":"F = ma → [M][LT⁻²]","answer":"[MLT⁻²]"}$j$),
    (870, 'class_11_12_sci', 'phy-meas-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Work का dimensional formula?","options":["[MLT⁻²]","[ML²T⁻²]","[ML²T⁻¹]","[MLT⁻¹]"],"answer":1,"explanation":"W = F·d = MLT⁻² × L = ML²T⁻²"},{"q":"Vernier least count?","options":["0.1 mm","0.01 mm","1 mm","0.001 mm"],"answer":0,"explanation":"Standard vernier = 0.1 mm"}]}$j$),

    (871, 'class_11_12_sci', 'phy-motion-1112-concept', 'concept', 1, 'गति — Class 11-12',
     $j${"text":"Kinematics: v=u+at, s=ut+½at², v²=u²+2as। Projectile: R=u²sin2θ/g, H=u²sin²θ/2g, T=2usinθ/g। Relative velocity: v_AB = v_A - v_B। Motion graphs: x-t (slope=v), v-t (slope=a, area=displacement)।","note":"Board में projectile और relative motion ज़रूरी हैं।"}$j$),
    (871, 'class_11_12_sci', 'phy-motion-1112-formula', 'formula', 2, 'गति सूत्र',
     $j${"formula":"v = u+at · s = ut+½at² · v² = u²+2as · R = u²sin2θ/g · H = u²sin²θ/2g","explanation":"Max range at 45°: R = u²/g · Same range for θ and 90°-θ"}$j$),
    (871, 'class_11_12_sci', 'phy-motion-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"u=20 m/s, 30°। Range? (g=10)","solution":"R = u²sin2θ/g = 400×sin60°/10 = 400×0.866/10","answer":"≈ 34.6 m"}$j$),
    (871, 'class_11_12_sci', 'phy-motion-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Max range angle?","options":["30°","45°","60°","90°"],"answer":1,"explanation":"R_max at θ=45°"},{"q":"Projectile 90° पर?","options":["Max range","Max height, zero range","Zero height","None"],"answer":1,"explanation":"90° = straight up (H=u²/2g, R=0)"}]}$j$),

    (872, 'class_11_12_sci', 'phy-force-1112-concept', 'concept', 1, 'बल — Class 11-12',
     $j${"text":"Newton's laws: 1st (inertia), 2nd (F=ma), 3rd (action-reaction)। Types: contact (friction, tension, normal) vs non-contact (gravity, electromagnetic)। Friction: static (μs) vs kinetic (μk)। FBD (free body diagram) बनाकर problems solve करो।","note":"Board में friction और FBD ज़रूरी हैं।"}$j$),
    (872, 'class_11_12_sci', 'phy-force-1112-formula', 'formula', 2, 'बल सूत्र',
     $j${"formula":"F = ma · f_s ≤ μs·N (static) · f_k = μk·N (kinetic) · p = mv · Impulse = F·t = Δp","explanation":"Normal force N (surface पर perpendicular) · Tension T (rope में) · Weight = mg"}$j$),
    (872, 'class_11_12_sci', 'phy-force-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"5 kg block, μ=0.4, g=10। Friction?","solution":"f = μN = μmg = 0.4×5×10","answer":"20 N"}$j$),
    (872, 'class_11_12_sci', 'phy-force-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Newton's 2nd law?","options":["F=ma","F=mv","F=m/a","F=a/m"],"answer":0,"explanation":"F = ma (net force)"},{"q":"Friction force direction?","options":["Motion के साथ","Motion के opposite","Perpendicular","Anywhere"],"answer":1,"explanation":"Friction = opposes motion"}]}$j$),

    (873, 'class_11_12_sci', 'phy-work-1112-concept', 'concept', 1, 'कार्य-ऊर्जा — Class 11-12',
     $j${"text":"Work W = F·d·cosθ। Energy: KE = ½mv², PE = mgh (gravitational), PE = ½kx² (spring)। Work-Energy theorem: W_net = ΔKE। Power P = W/t = F·v। Conservative forces (gravity, spring) vs non-conservative (friction)।","note":"Board में conservation of energy और work-energy theorem ज़रूरी हैं।"}$j$),
    (873, 'class_11_12_sci', 'phy-work-1112-formula', 'formula', 2, 'कार्य-ऊर्जा सूत्र',
     $j${"formula":"W = Fd cosθ · KE = ½mv² · PE = mgh · P = W/t = Fv · Spring PE = ½kx²","explanation":"Conservative: KE+PE = constant · Spring force F = -kx (restoring)"}$j$),
    (873, 'class_11_12_sci', 'phy-work-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"2 kg, v=10 m/s। KE?","solution":"KE = ½mv² = ½×2×100","answer":"100 J"}$j$),
    (873, 'class_11_12_sci', 'phy-work-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Work का unit?","options":["N","J","W","Pa"],"answer":1,"explanation":"Work = Joule (J)"},{"q":"Power का unit?","options":["J","N","W","Pa"],"answer":2,"explanation":"Power = Watt (J/s)"}]}$j$),

    (874, 'class_11_12_sci', 'phy-grav-1112-concept', 'concept', 1, 'गुरुत्वाकर्षण — Class 11-12',
     $j${"text":"Newton's law: F = Gm₁m₂/r², G=6.67×10⁻¹¹। g at height h: g' = g(1-2h/R)। g at depth d: g' = g(1-d/R)। Escape velocity: v_e = √(2gR) = 11.2 km/s। Orbital velocity: v_o = √(gR) = 7.9 km/s। Kepler's laws। Satellite energy।","note":"Board में g-variation, escape velocity, और Kepler ज़रूरी हैं।"}$j$),
    (874, 'class_11_12_sci', 'phy-grav-1112-formula', 'formula', 2, 'गुरुत्व सूत्र',
     $j${"formula":"F = Gm₁m₂/r² · g' = g(1-2h/R) (height) · g' = g(1-d/R) (depth) · v_e = √(2gR)","explanation":"v_e Earth = 11.2 km/s · v_o Earth = 7.9 km/s · Kepler: T² ∝ r³"}$j$),
    (874, 'class_11_12_sci', 'phy-grav-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Earth g=9.8, R=6400 km। v_e?","solution":"v_e = √(2×9.8×6.4×10⁶) = √(1.2544×10⁸)","answer":"≈ 11.2 km/s"}$j$),
    (874, 'class_11_12_sci', 'phy-grav-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Escape velocity Earth?","options":["7.9 km/s","11.2 km/s","2.4 km/s","18 km/s"],"answer":1,"explanation":"v_e = 11.2 km/s"},{"q":"Depth के साथ g?","options":["बढ़ता","घटता","Constant","Zero"],"answer":1,"explanation":"g' = g(1-d/R) → depth में घटता"}]}$j$),

    (875, 'class_11_12_sci', 'phy-press-1112-concept', 'concept', 1, 'दाब-तरल — Class 11-12',
     $j${"text":"Pressure P = F/A। Pascal's law (hydraulic lift)। Buoyancy: F_b = ρVg। Archimedes। Bernoulli: P + ½ρv² + ρgh = const (ideal fluid)। Viscosity η, Poiseuille Q = πPr⁴/(8ηL)। Surface tension, capillary rise।","note":"Board में Bernoulli और surface tension ज़रूरी हैं।"}$j$),
    (875, 'class_11_12_sci', 'phy-press-1112-formula', 'formula', 2, 'दाब सूत्र',
     $j${"formula":"P = F/A · F_b = ρVg · Bernoulli: P + ½ρv² + ρgh = const · Capillary: h = 2Tcosθ/(ρgr)","explanation":"Terminal velocity: v_t = 2r²(ρ-σ)g/9η · Poiseuille: Q = πPr⁴/(8ηL)"}$j$),
    (875, 'class_11_12_sci', 'phy-press-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Bernoulli: A₁=4cm², A₂=2cm², v₁=2 m/s। v₂?","solution":"A₁v₁ = A₂v₂ → 4×2 = 2×v₂","answer":"v₂ = 4 m/s"}$j$),
    (875, 'class_11_12_sci', 'phy-press-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Bernoulli का basis?","options":["Momentum","Energy conservation","Force","Mass"],"answer":1,"explanation":"Bernoulli = energy conservation for fluid"},{"q":"Capillary rise ∝?","options":["r","1/r","r²","1/r²"],"answer":1,"explanation":"h ∝ 1/r (narrow tube → higher)"}]}$j$),

    (876, 'class_11_12_sci', 'phy-heat-1112-concept', 'concept', 1, 'ऊष्मा — Class 11-12',
     $j${"text":"Thermal: Q=mcΔT, Q=mL। Thermal expansion: linear α, area 2α, volume 3α। Calorimetry: heat lost = heat gained। Newton's cooling: rate ∝ (T-T_s)। Conduction: Q/t = kAΔT/L। Radiation: Stefan-Boltzmann E = σT⁴, Wien λ_max T = b। Carnot: η = 1-T_c/T_h।","note":"Board में Carnot, heat transfer, और thermodynamics ज़रूरी हैं।"}$j$),
    (876, 'class_11_12_sci', 'phy-heat-1112-formula', 'formula', 2, 'ऊष्मा सूत्र',
     $j${"formula":"Q = mcΔT · Q = mL · Conduction Q/t = kAΔT/L · Stefan E = σT⁴ · Carnot η = 1-T_c/T_h","explanation":"Wien: λ_max T = 2.9×10⁻³ m·K · σ = 5.67×10⁻⁸ W/m²K⁴"}$j$),
    (876, 'class_11_12_sci', 'phy-heat-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Carnot T_h=500K, T_c=300K। η?","solution":"η = 1 - 300/500 = 1 - 0.6","answer":"40%"}$j$),
    (876, 'class_11_12_sci', 'phy-heat-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Carnot η = 1 - ?","options":["T_h/T_c","T_c/T_h","T_c-T_h","T_h×T_c"],"answer":1,"explanation":"η = 1 - T_c/T_h"},{"q":"Stefan: E ∝?","options":["T","T²","T³","T⁴"],"answer":3,"explanation":"E = σT⁴"}]}$j$),

    (877, 'class_11_12_sci', 'phy-wave-1112-concept', 'concept', 1, 'तरंगें — Class 11-12',
     $j${"text":"Wave: v=fλ, y = A sin(kx-ωt)। Types: transverse, longitudinal। Superposition → interference (constructive/destructive)। Standing waves: nodes, antinodes। String: v=√(T/μ), f_n = nv/2L। Beats: |f₁-f₂|। Doppler effect।","note":"Board में standing waves, beats, और Doppler ज़रूरी हैं।"}$j$),
    (877, 'class_11_12_sci', 'phy-wave-1112-formula', 'formula', 2, 'तरंग सूत्र',
     $j${"formula":"v = fλ · String: v = √(T/μ) · f_n = nv/2L (both ends fixed) · f_beat = |f₁-f₂|","explanation":"Open pipe: f_n = nv/2L · Closed pipe: f_n = (2n-1)v/4L (odd only)"}$j$),
    (877, 'class_11_12_sci', 'phy-wave-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"String L=1m, T=100N, μ=0.01 kg/m। Fundamental?","solution":"v = √(100/0.01) = 100 m/s। f₁ = v/2L = 100/2","answer":"50 Hz"}$j$),
    (877, 'class_11_12_sci', 'phy-wave-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Closed pipe harmonics?","options":["All integer","Only odd","Only even","None"],"answer":1,"explanation":"Closed pipe: odd harmonics only"},{"q":"Beat frequency?","options":["f₁+f₂","f₁-f₂","f₁×f₂","f₁/f₂"],"answer":1,"explanation":"|f₁ - f₂|"}]}$j$),

    (878, 'class_11_12_sci', 'phy-sound-1112-concept', 'concept', 1, 'ध्वनि — Class 11-12',
     $j${"text":"Sound: longitudinal wave, needs medium। Speed v = √(γRT/M), air ~340 m/s at 20°C। Intensity I = P²/(2ρv)। Loudness dB = 10 log(I/I₀)। Doppler effect: moving source/observer। Audible range: 20 Hz-20 kHz। Ultrasonic > 20 kHz।","note":"Board में Doppler और intensity ज़रूरी हैं।"}$j$),
    (878, 'class_11_12_sci', 'phy-sound-1112-formula', 'formula', 2, 'ध्वनि सूत्र',
     $j${"formula":"v = √(γRT/M) · I = P²/(2ρv) · dB = 10 log(I/I₀) · I₀ = 10⁻¹² W/m²","explanation":"Doppler (source toward): f' = f × v/(v-v_s) · Source away: f' = f × v/(v+v_s)"}$j$),
    (878, 'class_11_12_sci', 'phy-sound-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Sound speed 2× (temp T से)?","solution":"v ∝ √T → v₂/v₁ = √(T₂/T₁)","answer":"4× temperature से 2× speed"}$j$),
    (878, 'class_11_12_sci', 'phy-sound-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Sound speed air में?","options":["~340 m/s","~1500 m/s","~3×10⁸ m/s","~100 m/s"],"answer":0,"explanation":"~340 m/s at 20°C"},{"q":"dB = ?","options":["10 log(I/I₀)","log(I/I₀)","I/I₀","10 I/I₀"],"answer":0,"explanation":"dB = 10 log(I/I₀)"}]}$j$),

    (879, 'class_11_12_sci', 'lgt-1112-concept', 'concept', 1, 'प्रकाश — Class 11-12',
     $j${"text":"Reflection: 1/f = 1/v + 1/u (mirror)। Refraction: Snell n₁sinθ₁ = n₂sinθ₂। Lens: 1/f = 1/v - 1/u। Lens maker: 1/f = (n-1)(1/R₁-1/R₂)। TIR: sinθ_c = n₂/n₁ (denser to rarer)। Power P = 1/f (diopter)। Dispersion, prism, optical instruments।","note":"Board में lens, TIR, और optical instruments ज़रूरी हैं।"}$j$),
    (879, 'class_11_12_sci', 'lgt-1112-formula', 'formula', 2, 'प्रकाश सूत्र',
     $j${"formula":"Mirror: 1/f = 1/v+1/u · Lens: 1/f = 1/v-1/u · Snell: n₁sinθ₁ = n₂sinθ₂ · TIR: sinθ_c = n₂/n₁","explanation":"P = 1/f (D) · Concave f positive, convex f negative (in lens convention)"}$j$),
    (879, 'class_11_12_sci', 'lgt-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Convex lens f=10cm, u=-15cm। v?","solution":"1/v = 1/f + 1/u = 1/10 - 1/15 = (3-2)/30 = 1/30","answer":"v = 30 cm (real image)"}$j$),
    (879, 'class_11_12_sci', 'lgt-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"TIR condition?","options":["Denser to rarer","Rarer to denser","Equal","Any"],"answer":0,"explanation":"TIR = denser to rarer (angle > critical)"},{"q":"Power unit?","options":["J","W","Diopter","N"],"answer":2,"explanation":"Power = diopter (D) = 1/m"}]}$j$),

    -- ═══ CLASS 11-12 SCIENCE CHEMISTRY (885-894) ═══
    (885, 'class_11_12_sci', 'matter-1112-concept', 'concept', 1, 'पदार्थ — Class 11-12',
     $j${"text":"States: solid, liquid, gas, plasma। Ideal gas: PV=nRT (R=0.0821 L·atm/mol·K = 8.314 J/mol·K)। Kinetic theory: v_rms = √(3RT/M)। Real gas: van der Waals (P+an²/V²)(V-nb)=nRT। Critical point। Phase diagram।","note":"Board में gas laws, kinetic theory, और van der Waals ज़रूरी हैं।"}$j$),
    (885, 'class_11_12_sci', 'matter-1112-formula', 'formula', 2, 'पदार्थ सूत्र',
     $j${"formula":"PV = nRT · v_rms = √(3RT/M) · v_avg = √(8RT/πM) · v_mp = √(2RT/M)","explanation":"v_rms > v_avg > v_mp · 1 atm = 1.013×10⁵ Pa = 760 mmHg"}$j$),
    (885, 'class_11_12_sci', 'matter-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"O₂ (M=32) 300K। v_rms?","solution":"v_rms = √(3×8.314×300/0.032) = √(234000)","answer":"≈ 483 m/s"}$j$),
    (885, 'class_11_12_sci', 'matter-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Ideal gas equation?","options":["PV = nRT","PV = RT","P = nRT","V = nRT"],"answer":0,"explanation":"PV = nRT"},{"q":"v_rms ∝?","options":["T","√T","T²","1/T"],"answer":1,"explanation":"v_rms ∝ √T"}]}$j$),

    (886, 'class_11_12_sci', 'atom-1112-concept', 'concept', 1, 'परमाणु संरचना — Class 11-12',
     $j${"text":"Bohr model: E_n = -13.6/n² eV (H)। Quantum numbers: n (shell), l (shape), m (orientation), s (spin)। Aufbau principle, Pauli exclusion, Hund's rule। de Broglie: λ = h/p। Heisenberg: Δx·Δp ≥ h/4π। Photoelectric: hf = φ + KE_max।","note":"Board में Bohr, quantum numbers, और photoelectric ज़रूरी हैं।"}$j$),
    (886, 'class_11_12_sci', 'atom-1112-formula', 'formula', 2, 'परमाणु सूत्र',
     $j${"formula":"E_n = -13.6/n² eV · r_n = 0.53n² Å · λ = h/p · hf = φ + KE_max","explanation":"Lyman: n→1 (UV) · Balmer: n→2 (visible) · Paschen: n→3 (IR) · 1/λ = R(1/n₁²-1/n₂²)"}$j$),
    (886, 'class_11_12_sci', 'atom-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"H में n=2→1 transition। E?","solution":"E = -13.6(1/4 - 1) = -13.6 × (-3/4)","answer":"10.2 eV (Lyman α)"}$j$),
    (886, 'class_11_12_sci', 'atom-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Bohr ground state E?","options":["-13.6 eV","-3.4 eV","0 eV","+13.6 eV"],"answer":0,"explanation":"E₁ = -13.6 eV"},{"q":"Balmer series?","options":["UV","Visible","IR","X-ray"],"answer":1,"explanation":"Balmer (n→2) = visible"}]}$j$),

    (887, 'class_11_12_sci', 'periodic-1112-concept', 'concept', 1, 'आवर्त सारणी — Class 11-12',
     $j${"text":"Modern periodic law: properties periodic function of atomic number। Periods (7), groups (18)। Trends: atomic radius ↓ across, ↑ down; IE ↑ across, ↓ down; EN ↑ across, ↓ down (F highest); metallic ↑ down। Blocks: s, p, d, f। Diagonal relationship, inert pair effect।","note":"Board में trends और exceptions ज़रूरी हैं।"}$j$),
    (887, 'class_11_12_sci', 'periodic-1112-formula', 'formula', 2, 'आवर्त सारणी तथ्य',
     $j${"formula":"Radius: ↓ across, ↑ down · IE: ↑ across, ↓ down · EN: F=4.0 (highest)","explanation":"s-block: 1-2 · p-block: 13-18 · d-block: 3-12 · f-block: lanthanides + actinides"}$j$),
    (887, 'class_11_12_sci', 'periodic-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Na, Mg, Al radius order?","solution":"Across period → radius decreases","answer":"Na > Mg > Al"}$j$),
    (887, 'class_11_12_sci', 'periodic-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Highest electronegativity?","options":["O","F","Cl","N"],"answer":1,"explanation":"F = 4.0 (highest)"},{"q":"IE across period?","options":["Increases","Decreases","Constant","Random"],"answer":0,"explanation":"IE increases across (smaller radius)"}]}$j$),

    (888, 'class_11_12_sci', 'bond-1112-concept', 'concept', 1, 'आबंधन — Class 11-12',
     $j${"text":"Bond types: ionic, covalent, coordinate, metallic, H-bond, van der Waals। VSEPR: electron pairs → shape (linear, trigonal, tetrahedral, etc.)। Hybridization: sp (linear, 180°), sp² (trigonal, 120°), sp³ (tetrahedral, 109.5°)। MOT: bond order। Bond length, angle, dipole moment।","note":"Board में VSEPR, hybridization, और MOT ज़रूरी हैं।"}$j$),
    (888, 'class_11_12_sci', 'bond-1112-formula', 'formula', 2, 'आबंधन सूत्र',
     $j${"formula":"Bond order = (N_b - N_a)/2 · sp = 180° (linear) · sp² = 120° (trigonal) · sp³ = 109.5° (tetrahedral)","explanation":"VSEPR pairs: 2=linear, 3=trigonal, 4=tetrahedral, 5=trigonal bipyramidal, 6=octahedral"}$j$),
    (888, 'class_11_12_sci', 'bond-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"CH₄ hybridization?","solution":"4 bond pairs, 0 lone pairs → sp³","answer":"sp³ (tetrahedral, 109.5°)"}$j$),
    (888, 'class_11_12_sci', 'bond-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"CH₄ bond angle?","options":["90°","104.5°","109.5°","120°"],"answer":2,"explanation":"sp³ tetrahedral = 109.5°"},{"q":"O₂ bond order?","solution":"8 bonding - 4 antibonding (in MO) = BO = 2","options":["1","2","3","2.5"],"answer":1,"explanation":"BO = (8-4)/2 = 2"}]}$j$),

    (889, 'class_11_12_sci', 'chem-react-1112-concept', 'concept', 1, 'अभिक्रियाएँ — Class 11-12',
     $j${"text":"Kinetics: rate = k[A]ⁿ, order (0, 1, 2)। Arrhenius: k = Ae^(-Ea/RT)। Half-life: t½ = 0.693/k (1st order)। Thermodynamics: ΔG = ΔH - TΔS (ΔG<0 spontaneous)। Equilibrium: Kc, Kp, Le Chatelier।","note":"Board में kinetics, thermodynamics, और equilibrium ज़रूरी हैं।"}$j$),
    (889, 'class_11_12_sci', 'chem-react-1112-formula', 'formula', 2, 'अभिक्रिया सूत्र',
     $j${"formula":"Rate = k[A]ⁿ · k = Ae^(-Ea/RT) · ΔG = ΔH - TΔS · ΔG° = -RT ln K","explanation":"1st order: t½ = 0.693/k · ΔG=0 at equilibrium · Le Chatelier: stress → shift to oppose"}$j$),
    (889, 'class_11_12_sci', 'chem-react-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"1st order k=0.693 min⁻¹। t½?","solution":"t½ = 0.693/k","answer":"1 min"}$j$),
    (889, 'class_11_12_sci', 'chem-react-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Spontaneous: ΔG?","options":[">0","<0","=0","Any"],"answer":1,"explanation":"ΔG < 0 → spontaneous"},{"q":"1st order t½?","options":["0.693/k","1/k","k/0.693","k²"],"answer":0,"explanation":"t½ = 0.693/k"}]}$j$),

    (890, 'class_11_12_sci', 'redox-1112-concept', 'concept', 1, 'रेडॉक्स — Class 11-12',
     $j${"text":"Oxidation: ↑ oxidation state (loss of e⁻)। Reduction: ↓ oxidation state (gain of e⁻)। Balancing: oxidation number method, ion-electron method (acidic/basic)। Disproportionation। Standard electrode potential E°। Electrochemical series।","note":"Board में balancing और E° ज़रूरी हैं।"}$j$),
    (890, 'class_11_12_sci', 'redox-1112-formula', 'formula', 2, 'रेडॉक्स सूत्र',
     $j${"formula":"E°_cell = E°_cathode - E°_anode · ΔG° = -nFE° · F = 96500 C/mol","explanation":"Acidic: add H⁺/H₂O · Basic: add OH⁻/H₂O · Zn/Cu: 0.34-(-0.76)=1.10V"}$j$),
    (890, 'class_11_12_sci', 'redox-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Zn + Cu²⁺ → E°_cell? (E°_Zn²⁺/Zn=-0.76, Cu²⁺/Cu=+0.34)","solution":"E°_cell = 0.34 - (-0.76)","answer":"1.10 V (spontaneous)"}$j$),
    (890, 'class_11_12_sci', 'redox-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"KMnO₄ में Mn oxidation state?","options":["+2","+4","+6","+7"],"answer":3,"explanation":"K(+1), O(-2×4=-8) → Mn = +7"},{"q":"ΔG° = ?","options":["nFE°","-nFE°","nF/E°","-F/n"],"answer":1,"explanation":"ΔG° = -nFE°"}]}$j$),

    (891, 'class_11_12_sci', 'acid-1112-concept', 'concept', 1, 'अम्ल-क्षार — Class 11-12',
     $j${"text":"Bronsted-Lowry (proton transfer), Lewis (electron pair)। pH = -log[H⁺], pOH, pH+pOH=14 (25°C)। Ka, Kb, Kw = 10⁻¹⁴। Salt hydrolysis। Buffer: Henderson-Hasselbalch (pH = pKa + log([salt]/[acid]))। Solubility product Ksp।","note":"Board में pH, buffer, और salt hydrolysis ज़रूरी हैं।"}$j$),
    (891, 'class_11_12_sci', 'acid-1112-formula', 'formula', 2, 'अम्ल-क्षार सूत्र',
     $j${"formula":"pH = -log[H⁺] · pH+pOH = 14 · Ka·Kb = Kw = 10⁻¹⁴ · Henderson: pH = pKa + log([A⁻]/[HA])","explanation":"Weak acid: [H⁺] = √(Ka×C) · Buffer max capacity at pH = pKa"}$j$),
    (891, 'class_11_12_sci', 'acid-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"0.01 M HCl। pH?","solution":"[H⁺]=0.01=10⁻²","answer":"pH = 2"}$j$),
    (891, 'class_11_12_sci', 'acid-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"pH 3 का [H⁺]?","options":["10⁻³ M","10³ M","3 M","0.3 M"],"answer":0,"explanation":"pH=3 → [H⁺]=10⁻³ M"},{"q":"Buffer pH=pKa + ?","options":["log([A⁻]/[HA])","log([HA]/[A⁻])","[A⁻]/[HA]","[HA]×[A⁻]"],"answer":0,"explanation":"Henderson: pH = pKa + log([A⁻]/[HA])"}]}$j$),

    (892, 'class_11_12_sci', 'metal-1112-concept', 'concept', 1, 'धातु-अधातु — Class 11-12',
     $j${"text":"Metallurgy: concentration (froth flotation, magnetic), roasting (sulfide→oxide), calcination (carbonate→oxide), reduction (C, CO, Al, electrolysis)। Ellingham diagram। Alloys (steel, brass, bronze)। Reactivity series। Non-metals: S, P, halogens, noble gases।","note":"Board में extraction methods और Ellingham ज़रूरी हैं।"}$j$),
    (892, 'class_11_12_sci', 'metal-1112-formula', 'formula', 2, 'धातु सूत्र',
     $j${"formula":"Roasting: 2ZnS + 3O₂ → 2ZnO + 2SO₂ · Calcination: CaCO₃ → CaO + CO₂ · Reduction: ZnO + C → Zn + CO","explanation":"Ellingham: ΔG vs T (lower curve = more stable oxide) · Aluminothermic: Fe₂O₃ + 2Al → 2Fe + Al₂O₃"}$j$),
    (892, 'class_11_12_sci', 'metal-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"Bauxite से Al कैसे निकलता है?","solution":"Hall-Héroult electrolysis (Al₂O₃ + cryolite, molten)","answer":"Electrolytic reduction"}$j$),
    (892, 'class_11_12_sci', 'metal-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Froth flotation?","options":["Oxide ores","Sulphide ores","Carbonate","All"],"answer":1,"explanation":"Froth flotation = sulphide ores"},{"q":"Thermite reaction?","options":["Fe₂O₃+2Al → Al₂O₃+2Fe","Fe+O₂","Fe+C","Fe+Cl₂"],"answer":0,"explanation":"Thermite = Fe₂O₃ + Al (highly exothermic)"}]}$j$),

    (893, 'class_11_12_sci', 'carbon-1112-concept', 'concept', 1, 'कार्बन — Class 11-12',
     $j${"text":"Organic: IUPAC nomenclature, isomerism (chain, position, functional, geometric, optical)। Hybridization sp³/sp²/sp। Reaction types: substitution (SN1, SN2), addition (Markovnikov), elimination (E1, E2), aromatic (EAS)। Functional groups। Aromaticity (Huckel 4n+2)।","note":"Board में nomenclature, isomerism, और reaction types ज़रूरी हैं।"}$j$),
    (893, 'class_11_12_sci', 'carbon-1112-formula', 'formula', 2, 'कार्बन सूत्र',
     $j${"formula":"Alkane: CₙH₂ₙ₊₂ (sp³) · Alkene: CₙH₂ₙ (sp²) · Alkyne: CₙH₂ₙ₋₂ (sp) · Benzene: C₆H₆","explanation":"Markovnikov: H to more H carbon · Peroxide: anti-Markovnikov · SN2: inversion"}$j$),
    (893, 'class_11_12_sci', 'carbon-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"C₄H₁₀ isomers?","solution":"n-butane (straight) + isobutane (branched)","answer":"2 isomers (n-butane, isobutane)"}$j$),
    (893, 'class_11_12_sci', 'carbon-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"CH₄ hybridization?","options":["sp","sp²","sp³","sp³d"],"answer":2,"explanation":"CH₄ = sp³ (tetrahedral)"},{"q":"SN2 stereochemistry?","options":["Retention","Inversion","Racemization","None"],"answer":1,"explanation":"SN2 = Walden inversion"}]}$j$),

    (894, 'class_11_12_sci', 'sol-1112-concept', 'concept', 1, 'विलयन — Class 11-12',
     $j${"text":"Concentration: molarity (M), molality (m), mole fraction, normality (N)। Colligative properties: relative lowering of VP, ΔTf = i·Kf·m, ΔTb = i·Kb·m, π = iCRT। van't Hoff factor i (electrolytes)। Raoult's law। Ideal/non-ideal solutions। Azeotropes।","note":"Board में colligative properties और van't Hoff factor ज़रूरी हैं।"}$j$),
    (894, 'class_11_12_sci', 'sol-1112-formula', 'formula', 2, 'विलयन सूत्र',
     $j${"formula":"M = n/V(L) · m = n/kg solvent · ΔTf = i·Kf·m · ΔTb = i·Kb·m · π = iCRT","explanation":"i = actual/formula units (NaCl=2, CaCl₂=3) · Raoult: P = x_solvent P°"}$j$),
    (894, 'class_11_12_sci', 'sol-1112-example', 'example', 3, 'Board numerical',
     $j${"question":"0.1 m NaCl (i=2), Kf=1.86। ΔTf?","solution":"ΔTf = 2 × 1.86 × 0.1","answer":"0.372 K"}$j$),
    (894, 'class_11_12_sci', 'sol-1112-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Freezing depression ∝?","options":["Mass","Molality","Volume","Density"],"answer":1,"explanation":"ΔTf ∝ molality"},{"q":"CaCl₂ का i?","options":["1","2","3","4"],"answer":2,"explanation":"CaCl₂ → Ca²⁺ + 2Cl⁻ = 3 particles"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], array['class_11', 'class_12']::text[], 'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, count(*) from mtb.atoms 
-- where chapter_id in (870,871,872,873,874,875,876,877,878,879,885,886,887,888,889,890,891,892,893,894) 
--   and level_id='class_11_12_sci' and status='published' and not archived 
-- group by 1 order by 1;
-- Expected: each chapter = 4

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: 1539 + 80 = 1619