with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ STATE PSC GS PHYSICS (873-883) ═══
    (873, 'state_psc', 'phy-work-psc-concept', 'concept', 1, 'कार्य-ऊर्जा — State PSC',
     $j${"text":"Work: W=F·d·cosθ. Energy: KE=½mv², PE=mgh. Work-Energy theorem: W_net=ΔKE. Power P=W/t=F·v. Conservation of energy. Commercial unit kWh (1 unit electricity = 3.6×10⁶ J)।","note":"State PSC में work-energy theorem और power ज़रूरी हैं।"}$j$),
    (873, 'state_psc', 'phy-work-psc-formula', 'formula', 2, 'कार्य-ऊर्जा सूत्र',
     $j${"formula":"W = Fd cosθ · KE = ½mv² · PE = mgh · P = W/t · 1 kWh = 3.6×10⁶ J","explanation":"Energy conserved (no friction) · Power unit = Watt (W = J/s)"}$j$),
    (873, 'state_psc', 'phy-work-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"2 kg v=10 m/s। KE?","solution":"½ × 2 × 100","answer":"100 J"}$j$),
    (873, 'state_psc', 'phy-work-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Work SI unit?","options":["N","J","W","Pa"],"answer":1,"explanation":"Joule (J)"},{"q":"1 kWh = ? J","options":["3.6×10³","3.6×10⁶","3.6×10⁹","1000"],"answer":1,"explanation":"3.6×10⁶ J"}]}$j$),

    (874, 'state_psc', 'phy-grav-psc-concept', 'concept', 1, 'गुरुत्वाकर्षण — State PSC',
     $j${"text":"Newton's law: F=Gm₁m₂/r², G=6.67×10⁻¹¹ N·m²/kg². g at surface=9.8 m/s². g decreases with height and depth. Escape velocity v_e=11.2 km/s (Earth). Orbital velocity v_o=7.9 km/s. Kepler's laws. Satellites, GPS, ISRO missions।","note":"State PSC में escape velocity, g-variation, और satellites ज़रूरी हैं।"}$j$),
    (874, 'state_psc', 'phy-grav-psc-formula', 'formula', 2, 'गुरुत्व सूत्र',
     $j${"formula":"F = Gm₁m₂/r² · g' = g(1-2h/R) (height) · v_e = √(2gR) = 11.2 km/s","explanation":"G = 6.67×10⁻¹¹ · Moon g ≈ 1.6 m/s² (Earth's 1/6) · v_o = 7.9 km/s"}$j$),
    (874, 'state_psc', 'phy-grav-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Earth escape velocity?","solution":"11.2 km/s","answer":"11.2 km/s"}$j$),
    (874, 'state_psc', 'phy-grav-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Moon g vs Earth?","options":["Same","1/6","6×","1/2"],"answer":1,"explanation":"Moon g ≈ 1/6 Earth"},{"q":"g at height?","options":["Increases","Decreases","Constant","Zero"],"answer":1,"explanation":"g' = g(1-2h/R) decreases with height"}]}$j$),

    (875, 'state_psc', 'phy-press-psc-concept', 'concept', 1, 'दाब — State PSC',
     $j${"text":"Pressure P=F/A (Pascal). Liquid pressure P=ρgh (depth के साथ बढ़ता)। Atmospheric pressure 1 atm = 101325 Pa = 760 mmHg. Archimedes: buoyant force = weight of displaced fluid. Pascal's law → hydraulic brakes/lift. Bernoulli for flow. Surface tension, viscosity।","note":"State PSC में pressure, Archimedes, और hydraulic systems ज़रूरी हैं।"}$j$),
    (875, 'state_psc', 'phy-press-psc-formula', 'formula', 2, 'दाब सूत्र',
     $j${"formula":"P = F/A · P = ρgh · F_b = ρVg · 1 atm = 101325 Pa = 760 mmHg","explanation":"Hydraulic lift: F₁/A₁ = F₂/A₂ (Pascal's law) · Bernoulli: P+½ρv²+ρgh = const"}$j$),
    (875, 'state_psc', 'phy-press-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"5m depth water pressure (ρ=1000)","solution":"P = 1000 × 9.8 × 5","answer":"49000 Pa ≈ 49 kPa"}$j$),
    (875, 'state_psc', 'phy-press-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Pressure unit?","options":["N","Pa","J","W"],"answer":1,"explanation":"Pascal (Pa = N/m²)"},{"q":"Depth के साथ pressure?","options":["Decreases","Same","Increases","0"],"answer":2,"explanation":"P = ρgh → depth से बढ़ता"}]}$j$),

    (876, 'state_psc', 'phy-heat-psc-concept', 'concept', 1, 'ऊष्मा — State PSC',
     $j${"text":"Heat vs temperature. Q=mcΔT (specific heat), Q=mL (latent heat)। Heat transfer: conduction (solid), convection (fluid), radiation (no medium, EM waves)। Newton's cooling. Thermal expansion. Anomalous expansion of water (4°C density max)।","note":"State PSC में latent heat, heat transfer modes, और anomalous expansion ज़रूरी हैं।"}$j$),
    (876, 'state_psc', 'phy-heat-psc-formula', 'formula', 2, 'ऊष्मा सूत्र',
     $j${"formula":"Q = mcΔT · Q = mL (latent) · K = °C + 273 · °F = 9/5×°C + 32","explanation":"Water specific heat 4186 J/kg·K · Ice Lf=334 kJ/kg, steam Lv=2260 kJ/kg"}$j$),
    (876, 'state_psc', 'phy-heat-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"1 kg water 20→80°C। Q?","solution":"1 × 4200 × 60","answer":"252 kJ"}$j$),
    (876, 'state_psc', 'phy-heat-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"0°C in K?","options":["32","273","373","0"],"answer":1,"explanation":"K = °C + 273"},{"q":"Water density maximum at?","options":["0°C","4°C","10°C","100°C"],"answer":1,"explanation":"4°C (anomalous expansion)"}]}$j$),

    (877, 'state_psc', 'phy-wave-psc-concept', 'concept', 1, 'तरंगें — State PSC',
     $j${"text":"Wave: energy transfer. Types: mechanical (needs medium) vs electromagnetic (no medium)। Longitudinal (compression/rarefaction) vs transverse (crest/trough). Wave parameters: λ, f, A, v=fλ. Sound: longitudinal, mechanical. Light: transverse, EM. Reflection, refraction, interference, diffraction।","note":"State PSC में wave types, v=fλ, और EM spectrum ज़रूरी हैं।"}$j$),
    (877, 'state_psc', 'phy-wave-psc-formula', 'formula', 2, 'तरंग सूत्र',
     $j${"formula":"v = fλ · T = 1/f · EM spectrum: radio > micro > IR > visible > UV > X-ray > gamma","explanation":"Sound: longitudinal, needs medium · Light: transverse, no medium · Visible: 400-700 nm"}$j$),
    (877, 'state_psc', 'phy-wave-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"f=100 Hz, λ=3m। v?","solution":"v = 100 × 3","answer":"300 m/s"}$j$),
    (877, 'state_psc', 'phy-wave-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Light wave type?","options":["Longitudinal","Transverse","Both","Neither"],"answer":1,"explanation":"Transverse EM wave"},{"q":"Visible light range?","options":["100-400 nm","400-700 nm","700-1000 nm",">1000 nm"],"answer":1,"explanation":"400-700 nm"}]}$j$),

    (878, 'state_psc', 'phy-sound-psc-concept', 'concept', 1, 'ध्वनि — State PSC',
     $j${"text":"Sound: mechanical longitudinal wave, needs medium. Speed: solid > liquid > gas. Air ~340 m/s (20°C). Audible: 20 Hz - 20 kHz. Ultrasound > 20 kHz (medical, sonar, cleaning)। Infrasound < 20 Hz. Reflection → echo. Doppler effect. Loudness in dB.","note":"State PSC में sound speed comparison, audible range, ultrasound ज़रूरी हैं।"}$j$),
    (878, 'state_psc', 'phy-sound-psc-formula', 'formula', 2, 'ध्वनि सूत्र',
     $j${"formula":"v = fλ · Echo: 2d = vt · dB = 10 log(I/I₀) · I₀ = 10⁻¹² W/m²","explanation":"Air 340 m/s · Water 1500 m/s · Steel 5000 m/s · Audible: 20 Hz - 20 kHz"}$j$),
    (878, 'state_psc', 'phy-sound-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Echo 2s बाद। Distance (v=340)?","solution":"2d = 340×2 → d = 340","answer":"340 m"}$j$),
    (878, 'state_psc', 'phy-sound-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Sound speed highest in?","options":["Air","Water","Steel","Vacuum"],"answer":2,"explanation":"Solid > liquid > gas"},{"q":"Ultrasound?","options":["<20 Hz","20 Hz-20 kHz",">20 kHz","0 Hz"],"answer":2,"explanation":">20 kHz (above human hearing)"}]}$j$),

    (879, 'state_psc', 'phy-light-psc-concept', 'concept', 1, 'प्रकाश — State PSC',
     $j${"text":"Reflection: ∠i=∠r. Refraction: Snell n₁sinθ₁=n₂sinθ₂. Lens: 1/f=1/v-1/u. Mirror: 1/f=1/v+1/u. TIR: sinθ_c=n₂/n₁ (denser to rarer). Dispersion (prism, rainbow). Eye defects: myopia (concave), hypermetropia (convex). Optical instruments।","note":"State PSC में reflection, refraction, TIR, और eye defects ज़रूरी हैं।"}$j$),
    (879, 'state_psc', 'phy-light-psc-formula', 'formula', 2, 'प्रकाश सूत्र',
     $j${"formula":"∠i = ∠r · n₁sinθ₁ = n₂sinθ₂ · 1/f = 1/v - 1/u (lens) · sinθ_c = n₂/n₁","explanation":"Myopia: concave (-ve), Hypermetropia: convex (+ve) · Power P = 1/f (diopter)"}$j$),
    (879, 'state_psc', 'phy-light-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Myopia -2D। f?","solution":"f = 1/P = -0.5 m","answer":"-50 cm (concave)"}$j$),
    (879, 'state_psc', 'phy-light-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Myopia lens?","options":["Convex","Concave","Cylindrical","Bifocal"],"answer":1,"explanation":"Concave (diverging)"},{"q":"TIR condition?","options":["Denser→rarer","Rarer→denser","Both","Any"],"answer":0,"explanation":"Denser to rarer, angle > critical"}]}$j$),

    (880, 'state_psc', 'elec-psc-concept', 'concept', 1, 'विद्युत — State PSC',
     $j${"text":"Electric current: charge flow (Ampere). Ohm's law V=IR. Resistance (Ω). Series: R=R₁+R₂. Parallel: 1/R=1/R₁+1/R₂. Power P=VI=I²R=V²/R. Electric energy: kWh (1 unit)। Household circuits: live, neutral, earth, fuse। Electric shock, safety।","note":"State PSC में Ohm's law, series/parallel, और household circuits ज़रूरी हैं।"}$j$),
    (880, 'state_psc', 'elec-psc-formula', 'formula', 2, 'विद्युत सूत्र',
     $j${"formula":"V = IR · P = VI = I²R = V²/R · Series: R = R₁+R₂ · Parallel: 1/R = 1/R₁+1/R₂ · E = Pt","explanation":"1 kWh = 1 unit · Fuse: safety device (melts on overload) · Earth wire: safety"}$j$),
    (880, 'state_psc', 'elec-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"220V, 2A। Power?","solution":"P = 220 × 2","answer":"440 W"}$j$),
    (880, 'state_psc', 'elec-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Ohm's law?","options":["V=IR","V=I/R","V=RI²","V=IR²"],"answer":0,"explanation":"V = IR"},{"q":"Series R?","options":["Sum","Product","Reciprocal","Average"],"answer":0,"explanation":"R = R₁+R₂+..."}]}$j$),

    (881, 'state_psc', 'mag-psc-concept', 'concept', 1, 'चुंबकत्व — State PSC',
     $j${"text":"Magnetic field from current (Oersted). Right-hand rule. Solenoid (uniform field). Electromagnetic induction: Faraday's law, Lenz's law. Applications: generator (EMF from rotating coil), transformer (AC voltage change), motor (current + magnetic field → force)। Earth's magnetic field."}$j$),
    (881, 'state_psc', 'mag-psc-formula', 'formula', 2, 'चुंबकत्व सूत्र',
     $j${"formula":"Right-hand rule: thumb = I, fingers = B · Faraday: EMF = -dΦ/dt · Transformer: V_s/V_p = N_s/N_p","explanation":"Motor: F = BIL · Generator: EMF from rotating coil · Solenoid: B = μ₀nI"}$j$),
    (881, 'state_psc', 'mag-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Step-up transformer Np=100, Ns=500, Vp=220। Vs?","solution":"Vs = 220 × 500/100","answer":"1100 V"}$j$),
    (881, 'state_psc', 'mag-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Transformer basis?","options":["Ohm's law","Electromagnetic induction","Magnetic field only","Electric field"],"answer":1,"explanation":"Mutual induction (Faraday)"},{"q":"Electric motor converts?","options":["Mechanical→electrical","Electrical→mechanical","Heat→electrical","Light→electrical"],"answer":1,"explanation":"Electrical → mechanical energy"}]}$j$),

    (882, 'state_psc', 'modern-psc-concept', 'concept', 1, 'आधुनिक भौतिकी — State PSC',
     $j${"text":"Atom: proton, neutron, electron. Nucleus: strong force. Radioactivity: α, β, γ. Nuclear fission (U-235, releases energy) vs fusion (Sun, D+T)। E=mc² (Einstein). Half-life. Applications: nuclear reactor, radiocarbon dating (C-14), medical (radiotherapy), nuclear weapons।","note":"State PSC में radioactivity, fission/fusion, और applications ज़रूरी हैं।"}$j$),
    (882, 'state_psc', 'modern-psc-formula', 'formula', 2, 'आधुनिक भौतिकी सूत्र',
     $j${"formula":"E = mc² · Fission: ²³⁵U + n → Ba + Kr + 3n + energy · Fusion: 4H → He + energy","explanation":"α = ⁴₂He · β = electron · γ = photon · C-14 half-life = 5730 years"}$j$),
    (882, 'state_psc', 'modern-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"C-14 half-life?","solution":"5730 years","answer":"5730 years"}$j$),
    (882, 'state_psc', 'modern-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Sun energy source?","options":["Fission","Fusion","Chemical","Radioactive"],"answer":1,"explanation":"Nuclear fusion (H → He)"},{"q":"α particle = ?","options":["Electron","Proton","He nucleus","Photon"],"answer":2,"explanation":"⁴₂He (2p + 2n)"}]}$j$),

    (883, 'state_psc', 'mach-psc-concept', 'concept', 1, 'मशीनें — State PSC',
     $j${"text":"Simple machines: lever, pulley, inclined plane, screw, wheel-axle. Mechanical advantage MA = Load/Effort. Velocity ratio VR = effort distance/load distance. Efficiency η = MA/VR × 100%. Lever classes: 1 (fulcrum middle), 2 (load middle), 3 (effort middle)।","note":"State PSC में MA, VR, efficiency, और lever classes ज़रूरी हैं।"}$j$),
    (883, 'state_psc', 'mach-psc-formula', 'formula', 2, 'मशीन सूत्र',
     $j${"formula":"MA = Load/Effort · VR = effort dist/load dist · η = MA/VR × 100%","explanation":"Ideal: MA=VR (η=100%) · Lever class 1: see-saw, class 2: wheelbarrow, class 3: forearm"}$j$),
    (883, 'state_psc', 'mach-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"MA=4, VR=5। η?","solution":"4/5 × 100","answer":"80%"}$j$),
    (883, 'state_psc', 'mach-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Lever class 3 example?","options":["See-saw","Wheelbarrow","Forearm","Pliers"],"answer":2,"explanation":"Forearm (biceps between elbow and hand)"},{"q":"Efficiency formula?","options":["MA×VR","MA/VR","VR/MA","MA+VR"],"answer":1,"explanation":"η = MA/VR"}]}$j$),

    -- ═══ STATE PSC GS CHEMISTRY (885-893) ═══
    (885, 'state_psc', 'matter-psc-concept', 'concept', 1, 'पदार्थ — State PSC',
     $j${"text":"States of matter: solid, liquid, gas, plasma. Changes: melting, boiling, sublimation, condensation, freezing. Ideal gas PV=nRT. Kinetic theory. Real gas: van der Waals. Diffusion (gas mixing). Plasma: ionized gas (stars, lightning, neon)।","note":"State PSC में states, gas laws, और plasma ज़रूरी हैं।"}$j$),
    (885, 'state_psc', 'matter-psc-formula', 'formula', 2, 'पदार्थ सूत्र',
     $j${"formula":"PV = nRT · R = 8.314 J/mol·K = 0.0821 L·atm/mol·K · v_rms = √(3RT/M)","explanation":"Solid → Liquid: melting · Solid → Gas: sublimation (camphor, dry ice)"}$j$),
    (885, 'state_psc', 'matter-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Ideal gas 2L, 1 atm, 300K। n?","solution":"n = PV/RT = (1×2)/(0.0821×300)","answer":"≈ 0.081 mol"}$j$),
    (885, 'state_psc', 'matter-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Sublimation example?","options":["Ice melting","Camphor","Water boiling","Steam condensing"],"answer":1,"explanation":"Camphor (solid → gas directly)"},{"q":"Plasma state?","options":["Solid","Liquid","Gas","Ionized gas"],"answer":3,"explanation":"Ionized gas (stars, neon tubes)"}]}$j$),

    (886, 'state_psc', 'atom-psc-concept', 'concept', 1, 'परमाणु संरचना — State PSC',
     $j${"text":"Atom: nucleus (protons + neutrons) + electrons. Atomic number Z = protons. Mass number A = p+n. Isotopes (same Z, different n), isobars (same A), isotones (same n). Bohr model: E_n=-13.6/n² eV (H)। Quantum numbers (n,l,m,s)। Aufbau, Pauli, Hund's rules।","note":"State PSC में atomic number, isotopes, और quantum numbers ज़रूरी हैं।"}$j$),
    (886, 'state_psc', 'atom-psc-formula', 'formula', 2, 'परमाणु सूत्र',
     $j${"formula":"Z = protons · A = p + n · n = A - Z · E_n = -13.6/n² eV (H)","explanation":"Isotopes: same Z, different A (H, D, T) · Isobars: same A (Ar-40, K-40) · Quantum: n (shell), l (shape), m (orientation), s (spin)"}$j$),
    (886, 'state_psc', 'atom-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Atom Z=11, A=23। Neutrons?","solution":"n = 23 - 11","answer":"12 (Sodium)"}$j$),
    (886, 'state_psc', 'atom-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Isotopes differ in?","options":["Protons","Neutrons","Electrons","Charge"],"answer":1,"explanation":"Same protons, different neutrons"},{"q":"Bohr ground state (H)?","options":["-3.4","-13.6","+13.6","0"],"answer":1,"explanation":"E₁ = -13.6 eV"}]}$j$),

    (887, 'state_psc', 'periodic-psc-concept', 'concept', 1, 'आवर्त सारणी — State PSC',
     $j${"text":"Modern periodic law: properties periodic function of atomic number. Periods (7), groups (18)। Trends: atomic radius ↓ across, ↑ down; IE ↑ across, ↓ down; EN ↑ across, ↓ down (F highest=4.0); metallic ↑ down. Blocks: s, p, d, f. Diagonal relationship (Li-Mg, Be-Al)।","note":"State PSC में periodic trends और blocks ज़रूरी हैं।"}$j$),
    (887, 'state_psc', 'periodic-psc-formula', 'formula', 2, 'आवर्त तथ्य',
     $j${"formula":"Radius: ↓ across, ↑ down · IE: ↑ across, ↓ down · EN: F=4.0 (highest)","explanation":"s-block: 1-2 · p-block: 13-18 · d-block: 3-12 (transition) · f-block: lanthanides/actinides"}$j$),
    (887, 'state_psc', 'periodic-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Na, Mg, Al radius order?","solution":"Across period: radius decreases","answer":"Na > Mg > Al"}$j$),
    (887, 'state_psc', 'periodic-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Highest EN?","options":["O","F","Cl","N"],"answer":1,"explanation":"F = 4.0"},{"q":"Noble gases group?","options":["1","2","17","18"],"answer":3,"explanation":"Group 18"}]}$j$),

    (888, 'state_psc', 'bond-psc-concept', 'concept', 1, 'आबंधन — State PSC',
     $j${"text":"Chemical bonds: ionic (metal+nonmetal, e⁻ transfer), covalent (sharing), coordinate (dative), metallic, H-bond, van der Waals. VSEPR shapes. Hybridization sp/sp²/sp³. Bond properties: length, angle, energy. Polar vs nonpolar. Ionic compounds: high mp, conduct in solution.","note":"State PSC में ionic vs covalent और VSEPR shapes ज़रूरी हैं।"}$j$),
    (888, 'state_psc', 'bond-psc-formula', 'formula', 2, 'आबंधन तथ्य',
     $j${"formula":"Ionic: NaCl (metal+nonmetal) · Covalent: H₂O, CH₄ (sharing) · Hybridization: sp (linear), sp² (120°), sp³ (109.5°)","explanation":"VSEPR: e⁻ pairs repel → shape · Polar: asymmetric (H₂O), Nonpolar: symmetric (CH₄)"}$j$),
    (888, 'state_psc', 'bond-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"CH₄ hybridization?","solution":"4 bond pairs → sp³","answer":"sp³ (tetrahedral)"}$j$),
    (888, 'state_psc', 'bond-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"NaCl bond type?","options":["Ionic","Covalent","Metallic","H-bond"],"answer":0,"explanation":"Ionic (metal + nonmetal)"},{"q":"H₂O bond angle?","options":["104.5°","109.5°","120°","180°"],"answer":0,"explanation":"104.5° (lone pair repulsion)"}]}$j$),

    (889, 'state_psc', 'chem-react-psc-concept', 'concept', 1, 'अभिक्रियाएँ — State PSC',
     $j${"text":"Chemical reactions: combination, decomposition, displacement, double displacement, redox. Balancing chemical equations (same atoms both sides)। Signs: color change, gas evolution, precipitate, temperature change. Exothermic vs endothermic. Catalyst accelerates without consumption. Rate, equilibrium।","note":"State PSC में reaction types, balancing, और exo/endothermic ज़रूरी हैं।"}$j$),
    (889, 'state_psc', 'chem-react-psc-formula', 'formula', 2, 'अभिक्रिया तथ्य',
     $j${"formula":"Combination: 2H₂+O₂→2H₂O · Decomposition: CaCO₃→CaO+CO₂ · Displacement: Zn+CuSO₄→ZnSO₄+Cu · Double: AgNO₃+NaCl→AgCl↓+NaNO₃","explanation":"Exothermic: releases heat (combustion) · Endothermic: absorbs heat (decomposition)"}$j$),
    (889, 'state_psc', 'chem-react-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Zn + 2HCl → ?","solution":"ZnCl₂ + H₂↑","answer":"Zinc chloride + hydrogen gas"}$j$),
    (889, 'state_psc', 'chem-react-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"CaCO₃ → CaO + CO₂ कौन सी?","options":["Combination","Decomposition","Displacement","Redox"],"answer":1,"explanation":"Decomposition"},{"q":"Exothermic reaction?","options":["Absorbs heat","Releases heat","No heat","Equilibrium"],"answer":1,"explanation":"Releases heat (combustion)"}]}$j$),

    (890, 'state_psc', 'redox-psc-concept', 'concept', 1, 'रेडॉक्स — State PSC',
     $j${"text":"Oxidation (loss of e⁻, gain of O, loss of H) + Reduction (gain of e⁻, loss of O, gain of H). OIL RIG. Redox reactions occur together. Examples: rusting (Fe oxidation), combustion, respiration, photosynthesis (water oxidation)। Oxidizing agent (reduces), reducing agent (oxidizes)।","note":"State PSC में oxidation/reduction definitions और OIL RIG ज़रूरी हैं।"}$j$),
    (890, 'state_psc', 'redox-psc-formula', 'formula', 2, 'रेडॉक्स सूत्र',
     $j${"formula":"Oxidation: loss e⁻ (OIL) · Reduction: gain e⁻ (RIG) · Both together = redox","explanation":"Rusting: 4Fe + 3O₂ → 2Fe₂O₃ (Fe oxidized, O reduced) · Respiration: glucose oxidized"}$j$),
    (890, 'state_psc', 'redox-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"2Mg + O₂ → 2MgO में oxidized?","solution":"Mg: 0→+2 (loses e⁻)","answer":"Mg (oxidized)"}$j$),
    (890, 'state_psc', 'redox-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Oxidation = ?","options":["Gain e⁻","Loss e⁻","Gain H","None"],"answer":1,"explanation":"Loss of electrons (OIL)"},{"q":"Reducing agent?","options":["Gains e⁻","Loses e⁻","Neither","Both"],"answer":1,"explanation":"Reducing agent loses e⁻ (itself oxidized)"}]}$j$),

    (891, 'state_psc', 'acid-psc-concept', 'concept', 1, 'अम्ल-क्षार — State PSC',
     $j${"text":"Acids: sour, pH < 7, turn blue litmus red. Bases: bitter, slippery, pH > 7, turn red litmus blue. pH scale 0-14 (7 neutral). Neutralization: acid + base → salt + water. Strong vs weak. Indicators: litmus, phenolphthalein, methyl orange. pH in daily life: gastric (1.5-3.5), blood (7.35-7.45)।","note":"State PSC में pH scale, neutralization, और daily life pH ज़रूरी हैं।"}$j$),
    (891, 'state_psc', 'acid-psc-formula', 'formula', 2, 'अम्ल-क्षार सूत्र',
     $j${"formula":"pH = -log[H⁺] · pH < 7 acidic, = 7 neutral, > 7 basic · HCl + NaOH → NaCl + H₂O","explanation":"Strong acid: HCl, H₂SO₄, HNO₃ · Weak: CH₃COOH · Strong base: NaOH, KOH · Weak: NH₄OH"}$j$),
    (891, 'state_psc', 'acid-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"pH 3 का [H⁺]?","solution":"[H⁺] = 10⁻³ M","answer":"10⁻³ M (0.001 M)"}$j$),
    (891, 'state_psc', 'acid-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"pH 7 का मतलब?","options":["Acidic","Basic","Neutral","Zero"],"answer":2,"explanation":"Neutral (pure water)"},{"q":"Acid litmus को?","options":["Red→Blue","Blue→Red","No change","Green"],"answer":1,"explanation":"Acid: blue → red"}]}$j$),

    (892, 'state_psc', 'metal-psc-concept', 'concept', 1, 'धातु-अधातु — State PSC',
     $j${"text":"Metals: shiny, malleable, ductile, conductors (Fe, Cu, Al, Au, Ag)। Non-metals: dull, brittle, insulators (S, P, C, O)। Metalloids: B, Si, Ge, As. Reactivity series: K>Na>Ca>Mg>Al>Zn>Fe>Cu>Ag>Au. Displacement: more reactive displaces less. Alloys: steel, brass, bronze. Corrosion prevention: galvanization, painting।","note":"State PSC में reactivity series, alloys, और corrosion ज़रूरी हैं।"}$j$),
    (892, 'state_psc', 'metal-psc-formula', 'formula', 2, 'धातु तथ्य',
     $j${"formula":"Reactivity: K>Na>Ca>Mg>Al>Zn>Fe>Cu>Ag>Au · More reactive displaces less from salt","explanation":"Alloys: steel (Fe+C), brass (Cu+Zn), bronze (Cu+Sn) · Galvanization: Zn coating on Fe"}$j$),
    (892, 'state_psc', 'metal-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Fe + CuSO₄ → ?","solution":"Fe more reactive → displaces Cu","answer":"FeSO₄ + Cu"}$j$),
    (892, 'state_psc', 'metal-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Most reactive metal?","options":["Fe","Cu","K","Au"],"answer":2,"explanation":"K (potassium) top of series"},{"q":"Brass alloy?","options":["Cu+Zn","Cu+Sn","Fe+C","Pb+Sn"],"answer":0,"explanation":"Brass = Cu + Zn"}]}$j$),

    (893, 'state_psc', 'carbon-psc-concept', 'concept', 1, 'कार्बन — State PSC',
     $j${"text":"Carbon: tetravalent, catenation (self-linking) → millions of compounds. Allotropes: diamond (hard, 3D, sp³), graphite (soft, layers, sp², conductor), fullerene (C₆₀). Hydrocarbons: alkanes (single), alkenes (double), alkynes (triple), aromatic (benzene)। Functional groups: -OH, -COOH, -CHO।","note":"State PSC में allotropes, hydrocarbons, और functional groups ज़रूरी हैं।"}$j$),
    (893, 'state_psc', 'carbon-psc-formula', 'formula', 2, 'कार्बन सूत्र',
     $j${"formula":"Alkane: CₙH₂ₙ₊₂ · Alkene: CₙH₂ₙ · Alkyne: CₙH₂ₙ₋₂ · Benzene: C₆H₆","explanation":"Diamond: sp³, hardest · Graphite: sp², conductor, lubricant · Fullerene: C₆₀"}$j$),
    (893, 'state_psc', 'carbon-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"C₃H₈ कौन?","solution":"CₙH₂ₙ₊₂ → alkane (propane)","answer":"Propane (alkane)"}$j$),
    (893, 'state_psc', 'carbon-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Hardest allotrope?","options":["Graphite","Diamond","Fullerene","Coal"],"answer":1,"explanation":"Diamond"},{"q":"C₂H₄ type?","options":["Alkane","Alkene","Alkyne","Aromatic"],"answer":1,"explanation":"Alkene (double bond)"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[], 'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, count(*) from mtb.atoms 
-- where chapter_id in (873,874,875,876,877,878,879,880,881,882,883,885,886,887,888,889,890,891,892,893) 
--   and level_id='state_psc' and status='published' and not archived 
-- group by 1 order by 1;
-- Expected: each chapter = 4

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: ~2328 + 80 = ~2408
