-- Medical chapters 880-890 (4 atoms each, 40 total). Mission label "0079".
-- FIX before apply: 882, 883, 885-890 formula/example/mcq rows were missing level_id (key sat in the level slot). Added 'medical' and moved key into atom_key.
-- Checked: Ohm/energy 100μF·2000V=200 J; 10^1.3≈20 (HCO3:H2CO3); 0.0057%≈0.006%; I-131 4 half-lives=6.25%; 2×0.15×...; lever Effort=64 kg (MA 0.125); YDSE etc. No other changes.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    (880, 'medical', 'elec-concept', 'concept', 1, 'विद्युत — NEET',
     $j${"text":"Electricity की NEET applications: nerve impulse (action potential -70mV → +30mV), ECG (PQRST waves), defibrillator (~200-360 J), pacemaker। Cell membrane potential, ion channels (Na⁺/K⁺), और resistance of body tissues।","note":"NEET में action potential, ECG, और defibrillator energy पूछे जाते हैं।"}$j$),
    (880, 'medical', 'elec-formula', 'formula', 2, 'विद्युत सूत्र',
     $j${"formula":"V = IR · P = VI · Action potential ≈ 100 mV · Defibrillator energy = ½CV²","explanation":"Resting potential: -70 mV (inside negative) · Depolarization: +30 mV · Repolarization: वापस -70 mV"}$j$),
    (880, 'medical', 'elec-example', 'example', 3, 'Medical numerical',
     $j${"question":"Defibrillator 100 μF, 2000V। Energy?","solution":"E = ½CV² = ½ × 100×10⁻⁶ × 4×10⁶","answer":"200 J"}$j$),
    (880, 'medical', 'elec-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Resting membrane potential?","options":["-70 mV","-30 mV","+30 mV","0 mV"],"answer":0,"explanation":"-70 mV (inside negative)"},{"q":"Defibrillator में क्या stored होता है?","options":["Current","Voltage","Energy (capacitor)","Resistance"],"answer":2,"explanation":"Capacitor में energy ½CV²"}]}$j$),

    (881, 'medical', 'mag-concept', 'concept', 1, 'चुंबकत्व — NEET',
     $j${"text":"Magnetism की medical applications: MRI (1.5-3 Tesla), magnetic nanoparticles (drug delivery), transcranial magnetic stimulation (TMS, ~1-2 T), magnetoencephalography (MEG)। Earth's magnetic field ~50 μT, neuron activity से tiny magnetic fields।","note":"NEET में MRI principle, TMS, और magnetic field effects पूछे जाते हैं।"}$j$),
    (881, 'medical', 'mag-formula', 'formula', 2, 'चुंबकत्व सूत्र',
     $j${"formula":"F = qvBsinθ · B = μ₀I/(2πr) · MRI field ≈ 1.5-3 T","explanation":"Lorentz force on moving ions · TMS: 1-2 T short pulses · Earth's field ≈ 50 μT"}$j$),
    (881, 'medical', 'mag-example', 'example', 3, 'Medical numerical',
     $j${"question":"MRI field 3T, body area 1m²। Compare Earth's field 50μT","solution":"3T / 50×10⁻⁶ T = 60,000","answer":"MRI field 60,000× stronger"}$j$),
    (881, 'medical', 'mag-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"MRI में magnetic field?","options":["0.05 T","1.5-3 T","10 T","50 μT"],"answer":1,"explanation":"1.5-3 Tesla typically"},{"q":"TMS का उपयोग?","options":["Imaging","Brain stimulation","Blood pressure","Bone density"],"answer":1,"explanation":"Transcranial Magnetic Stimulation for brain"}]}$j$),

    (882, 'medical', 'modern-concept', 'concept', 1, 'आधुनिक भौतिकी — NEET',
     $j${"text":"Modern Physics की medical applications: X-ray (0.01-10 nm), CT scan (X-ray based), PET scan (positron emitters like ¹⁸F, half-life 110 min), radiotherapy (γ-rays, dose in Gy)। Radioactive isotopes: I-131 (thyroid, t½ 8 days), Tc-99m (imaging, t½ 6 hours)।","note":"NEET में X-ray production, PET, और isotopes की half-life पूछे जाते हैं।"}$j$),
    (882, 'medical', 'modern-formula', 'formula', 2, 'आधुनिक भौतिकी सूत्र',
     $j${"formula":"E = hf · X-ray: λ_min = hc/(eV) · N = N₀(1/2)^(t/t½)","explanation":"PET: e⁺ + e⁻ → 2γ (511 keV each) · Dose unit: 1 Gy = 1 J/kg"}$j$),
    (882, 'medical', 'modern-example', 'example', 3, 'Medical numerical',
     $j${"question":"I-131 t½=8 days। 4 half-lives बाद %?","solution":"(1/2)⁴ = 1/16","answer":"6.25%"}$j$),
    (882, 'medical', 'modern-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"PET scan में positron annihilation से?","options":["1 γ-ray","2 γ-rays (511 keV)","α particle","β particle"],"answer":1,"explanation":"2 γ-rays, each 511 keV, opposite directions"},{"q":"Tc-99m half-life?","options":["6 hours","8 days","110 min","12 years"],"answer":0,"explanation":"Tc-99m = 6 hours (ideal for imaging)"}]}$j$),

    (883, 'medical', 'mach-concept', 'concept', 1, 'सरल मशीनें — NEET',
     $j${"text":"Simple Machines की biological analogies: bones as levers (femur = class 3 lever, jaw = class 2), muscle-tendon = pulley system, joints as fulcrums। Mechanical advantage of human body ≈ 0.1 (body prefers speed over force)।","note":"NEET में lever classes, mechanical advantage, और joint types पूछे जाते हैं।"}$j$),
    (883, 'medical', 'mach-formula', 'formula', 2, 'मशीन सूत्र',
     $j${"formula":"MA = Load/Effort · Lever: Load×Load-arm = Effort×Effort-arm · Efficiency = output/input × 100%","explanation":"Class 1: fulcrum middle · Class 2: load middle (wheelbarrow) · Class 3: effort middle (biceps)"}$j$),
    (883, 'medical', 'mach-example', 'example', 3, 'Medical numerical',
     $j${"question":"Biceps, effort arm 4cm, load arm 32cm, load 8kg। Effort?","solution":"E × 4 = 8 × 32 → E = 64 kg","answer":"64 kg (MA = 0.125)"}$j$),
    (883, 'medical', 'mach-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Biceps muscle कौन सा lever?","options":["Class 1","Class 2","Class 3","Class 4"],"answer":2,"explanation":"Class 3 (effort between fulcrum and load)"},{"q":"Forearm कौन सा lever?","options":["Class 1","Class 2","Class 3","कोई नहीं"],"answer":2,"explanation":"Elbow joint में biceps effort between fulcrum और load"}]}$j$),

    (885, 'medical', 'matter-concept', 'concept', 1, 'पदार्थ — NEET',
     $j${"text":"Matter की medical applications: blood (liquid + cells), CSF (cerebrospinal fluid), interstitial fluid, cell membrane (lipid bilayer, semi-solid)। Plasma state: blood plasma, state changes: freezing (cryopreservation of embryos at -196°C, liquid N₂)।","note":"NEET में states of matter, freezing, और biological fluids पूछे जाते हैं।"}$j$),
    (885, 'medical', 'matter-formula', 'formula', 2, 'पदार्थ सूत्र',
     $j${"formula":"PV = nRT (ideal) · v_rms = √(3RT/M) · Liquid N₂ boiling point: -196°C (77 K)","explanation":"Human body ≈ 60% water · Blood viscosity: plasma + cells"}$j$),
    (885, 'medical', 'matter-example', 'example', 3, 'Medical numerical',
     $j${"question":"37°C पर gas के v_rms और 0°C का ratio?","solution":"v_rms ∝ √T। T₁=310K, T₂=273K। √(310/273)","answer":"≈ 1.066"}$j$),
    (885, 'medical', 'matter-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Cryopreservation में कौन use?","options":["Dry ice","Liquid N₂","Ice water","Ethanol"],"answer":1,"explanation":"Liquid N₂ at -196°C"},{"q":"Blood plasma का state?","options":["Solid","Liquid","Gas","Plasma"],"answer":1,"explanation":"Blood plasma = liquid (95% water + proteins)"}]}$j$),

    (886, 'medical', 'atom-concept', 'concept', 1, 'परमाणु संरचना — NEET',
     $j${"text":"Atomic structure की medical applications: radioactive tracers (Tc-99m, I-131, F-18), radiotherapy (α, β, γ decay), X-ray generation, isotopes में diagnostic imaging। Bohr model, quantum numbers, और electron configuration NEET में पूछे जाते हैं।","note":"NEET में radioactive decay types, half-life, और imaging isotopes पूछे जाते हैं।"}$j$),
    (886, 'medical', 'atom-formula', 'formula', 2, 'परमाणु सूत्र',
     $j${"formula":"E = -13.6/n² eV (H) · N = N₀(1/2)^(t/t½) · λ = ln2/t½","explanation":"α: ⁴₂He nucleus · β⁻: electron · β⁺: positron · γ: photon"}$j$),
    (886, 'medical', 'atom-example', 'example', 3, 'Medical numerical',
     $j${"question":"F-18 half-life 110 min। 220 min बाद % remaining?","solution":"220/110 = 2 half-lives। (1/2)² = 1/4","answer":"25%"}$j$),
    (886, 'medical', 'atom-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"α decay में nucleus से निकलता है?","options":["Electron","Proton","Helium nucleus (⁴₂He)","Photon"],"answer":2,"explanation":"α particle = ⁴₂He (2 proton + 2 neutron)"},{"q":"F-18 का उपयोग?","options":["MRI","PET scan","X-ray","CT"],"answer":1,"explanation":"PET scan (positron emitter)"}]}$j$),

    (887, 'medical', 'periodic-concept', 'concept', 1, 'आवर्त सारणी — NEET',
     $j${"text":"Periodic Table की medical applications: essential elements (Na, K, Ca, Fe, Zn, I, Se), toxicity (Pb, Hg, As), radiopaque contrast (Ba, I), radioactive isotopes (I-131, Tc-99m)। Electrolytes balance body functions।","note":"NEET में essential elements, minerals की deficiency, और radiopaque contrast पूछे जाते हैं।"}$j$),
    (887, 'medical', 'periodic-formula', 'formula', 2, 'आवर्त सारणी तथ्य',
     $j${"formula":"Essential: Fe (Hb), I (thyroid), Ca (bones), Na/K (nerve), Zn (enzymes) · Toxic: Pb, Hg, Cd, As","explanation":"Radiopaque contrast: Ba (barium swallow), I (iodine contrast) · Radioactive: I-131, Tc-99m"}$j$),
    (887, 'medical', 'periodic-example', 'example', 3, 'Medical numerical',
     $j${"question":"Adult body में iron?","solution":"~4g total (2.5g in Hb, 1g stored)","answer":"≈ 4 grams"}$j$),
    (887, 'medical', 'periodic-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Thyroid hormone में कौन element?","options":["Fe","I","Zn","Ca"],"answer":1,"explanation":"Iodine (I) - T3, T4 hormones"},{"q":"X-ray contrast में?","options":["Fe","Ba","K","Na"],"answer":1,"explanation":"Barium (Ba) for GI contrast"}]}$j$),

    (888, 'medical', 'bond-concept', 'concept', 1, 'रासायनिक आबंधन — NEET',
     $j${"text":"Chemical Bonding की medical applications: hydrogen bonds (DNA base pairing, protein secondary structure), ionic (NaCl, electrolytes), covalent (organic molecules), van der Waals (lipid membranes)। Enzyme-substrate binding hydrogen bonds से।","note":"NEET में H-bonding, ionic/covalent, और biological molecules पूछे जाते हैं।"}$j$),
    (888, 'medical', 'bond-formula', 'formula', 2, 'आबंध सूत्र',
     $j${"formula":"Ionic: metal + non-metal (NaCl) · Covalent: sharing (H₂O) · H-bond: H between electronegative (O, N, F)","explanation":"DNA: A=T (2 H-bonds), G≡C (3 H-bonds) · Protein α-helix: intramolecular H-bonds"}$j$),
    (888, 'medical', 'bond-example', 'example', 3, 'Medical numerical',
     $j${"question":"DNA में A-T pair में H-bonds?","solution":"Adenine-Thymine = 2 hydrogen bonds","answer":"2 H-bonds (G-C = 3)"}$j$),
    (888, 'medical', 'bond-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"DNA में G-C pair H-bonds?","options":["1","2","3","4"],"answer":2,"explanation":"Guanine-Cytosine = 3 H-bonds"},{"q":"NaCl में bonding?","options":["Covalent","Ionic","H-bond","Metallic"],"answer":1,"explanation":"Na⁺ and Cl⁻ (ionic)"}]}$j$),

    (889, 'medical', 'chem-react-concept', 'concept', 1, 'रासायनिक अभिक्रियाएँ — NEET',
     $j${"text":"Chemical Reactions की medical applications: metabolism (glycolysis, Krebs cycle, oxidative phosphorylation), ATP synthesis, enzyme catalysis, acid-base reactions in blood (H₂CO₃ ⇌ H⁺ + HCO₃⁻ buffer)। Rate of reactions में factors: temperature, concentration, catalyst।","note":"NEET में metabolism, enzyme kinetics, और buffer systems पूछे जाते हैं।"}$j$),
    (889, 'medical', 'chem-react-formula', 'formula', 2, 'अभिक्रिया सूत्र',
     $j${"formula":"Rate = k[A][B] · Arrhenius: k = Ae^(-Ea/RT) · Henderson-Hasselbalch: pH = pKa + log([A⁻]/[HA])","explanation":"Glycolysis: C₆H₁₂O₆ → 2 C₃H₄O₃ + 2 ATP + 2 NADH · Blood pH = 7.35-7.45"}$j$),
    (889, 'medical', 'chem-react-example', 'example', 3, 'Medical numerical',
     $j${"question":"Blood pH 7.4, pKa(H₂CO₃) 6.1। HCO₃⁻/H₂CO₃ ratio?","solution":"7.4 = 6.1 + log(r) → log(r) = 1.3 → r = 10^1.3","answer":"≈ 20:1"}$j$),
    (889, 'medical', 'chem-react-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Blood का normal pH?","options":["7.0-7.2","7.35-7.45","7.5-7.7","6.8-7.0"],"answer":1,"explanation":"Blood pH = 7.35-7.45"},{"q":"Enzyme क्या कम करता है?","options":["ΔG","Rate","Activation energy","Temperature"],"answer":2,"explanation":"Enzyme reduces activation energy"}]}$j$),

    (890, 'medical', 'redox-concept', 'concept', 1, 'ऑक्सीकरण-अपचयन — NEET',
     $j${"text":"Redox की medical applications: cellular respiration (glucose oxidation), antioxidant vitamins (C, E), oxidative stress (ROS → DNA damage), ROS in aging and cancer, cytochrome electron transport chain। Free radicals और antioxidants balance।","note":"NEET में ROS, antioxidants, और electron transport chain पूछे जाते हैं।"}$j$),
    (890, 'medical', 'redox-formula', 'formula', 2, 'Redox सूत्र',
     $j${"formula":"Oxidation = loss of e⁻ · Reduction = gain of e⁻ · OIL RIG · ROS: O₂⁻, H₂O₂, OH•","explanation":"Glucose oxidation: C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + energy · Antioxidants donate e⁻"}$j$),
    (890, 'medical', 'redox-example', 'example', 3, 'Medical numerical',
     $j${"question":"1 glucose से ATP (aerobic)?","solution":"Glucose oxidation ≈ 36-38 ATP","answer":"36-38 ATP per glucose"}$j$),
    (890, 'medical', 'redox-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Vitamin C का role?","options":["Oxidant","Antioxidant","Enzyme","Hormone"],"answer":1,"explanation":"Vitamin C (ascorbic acid) = antioxidant"},{"q":"Cellular respiration में final electron acceptor?","options":["NAD⁺","FAD","O₂","H₂O"],"answer":2,"explanation":"O₂ accepts electrons in mitochondria"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[], 'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY: select chapter_id, count(*) from mtb.atoms where chapter_id between 880 and 890 and level_id='medical' and status='published' and not archived group by 1 order by 1;  -- expect 4 each (no 884)
