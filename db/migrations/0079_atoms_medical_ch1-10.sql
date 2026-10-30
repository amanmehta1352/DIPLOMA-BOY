-- Medical chapters 870-879 (4 atoms each, 40 total). Mission label "0078" (number already used by GA/Civil batch).
-- Checked: arithmetic (39°C→312.15 K, 120×133.32=15998.4 Pa, 0.6/120=5 ms, 3×70×9.8≈2058 N, π≈7.6 atm, 13,377 Pa≈100 mmHg, 60 dB, 490 kJ, 334,720 J). No changes needed.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    (870, 'medical', 'phy-meas-concept', 'concept', 1, 'मापन — NEET',
     $j${"text":"NEET में भौतिक मापन, SI units, और biological measurements ज़रूरी हैं। Body temp ≈ 37°C (310 K), BP 120/80 mmHg, nerve impulse ≈ 120 m/s, heart rate ≈ 72 beats/min। Significant figures और dimensional analysis भी पूछे जाते हैं।","note":"Unit conversion (mmHg, °C to K) और biological parameters के units NEET में ज़रूरी हैं।"}$j$),
    (870, 'medical', 'phy-meas-formula', 'formula', 2, 'मापन सूत्र',
     $j${"formula":"T(K) = T(°C) + 273.15 · 1 mmHg = 133.32 Pa · 1 atm = 760 mmHg = 101325 Pa","explanation":"BP: 120/80 = systolic/diastolic · Body temp: 37°C = 310 K · Cellular scale: μm"}$j$),
    (870, 'medical', 'phy-meas-example', 'example', 3, 'Biological numerical',
     $j${"question":"Patient का body temp 39°C है। Kelvin में?","solution":"T(K) = T(°C) + 273.15 = 39 + 273.15","answer":"312.15 K"}$j$),
    (870, 'medical', 'phy-meas-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Systolic BP 120 mmHg को Pa में?","options":["15000 Pa","15998.4 Pa","16000 Pa","120 Pa"],"answer":1,"explanation":"120 × 133.32 = 15998.4 Pa"},{"q":"Normal body temp K में?","options":["300 K","310 K","273 K","373 K"],"answer":1,"explanation":"37°C + 273 = 310 K"}]}$j$),

    (871, 'medical', 'phy-motion-concept', 'concept', 1, 'गति — NEET',
     $j${"text":"Motion की NEET applications: blood flow velocity (aorta ≈ 0.3 m/s), nerve impulse (myelinated ≈ 120 m/s, unmyelinated ≈ 1 m/s), peristalsis, और cardiac cycle। Kinematics equations biological examples के साथ।","note":"NEET में uniform motion और biological velocities के comparisons पूछे जाते हैं।"}$j$),
    (871, 'medical', 'phy-motion-formula', 'formula', 2, 'गति सूत्र',
     $j${"formula":"v = u + at · s = ut + ½at² · v² = u² + 2as","explanation":"Blood flow: v = Q/A (Q=flow rate, A=cross-section area) · Nerve impulse: speed = distance/time"}$j$),
    (871, 'medical', 'phy-motion-example', 'example', 3, 'Medical numerical',
     $j${"question":"Nerve impulse 0.6m neuron में 120 m/s। समय?","solution":"t = d/v = 0.6/120","answer":"5 ms"}$j$),
    (871, 'medical', 'phy-motion-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Myelinated neuron में impulse speed?","options":["1 m/s","10 m/s","120 m/s","300 m/s"],"answer":2,"explanation":"Myelinated = 120 m/s (saltatory conduction)"},{"q":"Aorta flow 0.3 m/s, 0.6m distance में समय?","options":["1s","2s","0.5s","3s"],"answer":1,"explanation":"t = 0.6/0.3 = 2s"}]}$j$),

    (872, 'medical', 'phy-force-concept', 'concept', 1, 'बल — NEET',
     $j${"text":"Force की NEET applications: muscle contraction (skeletal ≈ 30 N/cm²), joint reaction (hip walking ≈ 3× BW, running ≈ 6× BW), blood pressure = F/A, lung compliance = ΔV/ΔP, capillary filtration, bone load (femur ≈ 1700 N)।","note":"NEET में biomechanics, muscle force, और BP = F/A ज़रूरी हैं।"}$j$),
    (872, 'medical', 'phy-force-formula', 'formula', 2, 'बल सूत्र',
     $j${"formula":"F = ma · BP = F/A · Muscle force = tension × cross-section · Compliance = ΔV/ΔP","explanation":"Hip force: walking 3×BW, climbing 4×BW, running 6×BW · Lung compliance ≈ 200 mL/cm H₂O"}$j$),
    (872, 'medical', 'phy-force-example', 'example', 3, 'Medical numerical',
     $j${"question":"70 kg person walking। Hip joint reaction force?","solution":"F = 3 × body weight = 3 × 70 × 9.8","answer":"≈ 2058 N"}$j$),
    (872, 'medical', 'phy-force-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Running के समय hip joint force ≈?","options":["1× BW","3× BW","6× BW","10× BW"],"answer":2,"explanation":"Running = 6× body weight"},{"q":"BP = F/A में force source?","options":["Gravity","Blood on vessel walls","Heart pumping","Muscle"],"answer":1,"explanation":"Blood द्वारा vessel wall पर force"}]}$j$),

    (873, 'medical', 'phy-work-concept', 'concept', 1, 'कार्य-ऊर्जा — NEET',
     $j${"text":"Energy की NEET applications: ATP hydrolysis (ΔG ≈ -30.5 kJ/mol), BMR ≈ 1600-2000 kcal/day, food calories (1 Cal = 1000 cal = 4184 J), muscle efficiency ≈ 20-25%, heart pumping ≈ 5W।","note":"NEET में energy units (Cal vs cal) और ATP energy पूछे जाते हैं।"}$j$),
    (873, 'medical', 'phy-work-formula', 'formula', 2, 'कार्य-ऊर्जा सूत्र',
     $j${"formula":"W = F·d·cosθ · KE = ½mv² · PE = mgh · 1 Cal = 4184 J","explanation":"Efficiency = output/input × 100 · ATP → ADP + Pi ≈ 30.5 kJ/mol released"}$j$),
    (873, 'medical', 'phy-work-example', 'example', 3, 'Medical numerical',
     $j${"question":"1 ब्रेड स्लाइस ≈ 80 Cal। Joule?","solution":"80 × 4184","answer":"≈ 334,720 J"}$j$),
    (873, 'medical', 'phy-work-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"ATP → ADP से कितनी energy release?","options":["10 kJ/mol","30.5 kJ/mol","100 kJ/mol","1000 kJ/mol"],"answer":1,"explanation":"Standard ΔG = -30.5 kJ/mol"},{"q":"1 nutritional Cal = ?","options":["1 cal","1000 cal","4184 cal","10 cal"],"answer":1,"explanation":"1 Cal = 1000 cal = 1 kcal"}]}$j$),

    (874, 'medical', 'phy-grav-concept', 'concept', 1, 'गुरुत्वाकर्षण — NEET',
     $j${"text":"Gravitation की medical applications: BP में gravity का role (standing vs lying), G-tolerance (fighter pilots ≈ 9G), orthostatic hypotension (standing → BP drop), hydrostatic pressure in vessels।","note":"NEET में hydrostatic pressure और G-forces के biological effects पूछे जाते हैं।"}$j$),
    (874, 'medical', 'phy-grav-formula', 'formula', 2, 'गुरुत्व सूत्र',
     $j${"formula":"F = GMm/r² · g = GM/R² · g' = g(1 - 2h/R) at height h","explanation":"Hydrostatic P = ρgh · G-force = (a+g)/g · Orthostatic ΔP = ρgΔh"}$j$),
    (874, 'medical', 'phy-grav-example', 'example', 3, 'Medical numerical',
     $j${"question":"Brain-feet 1.3m। Standing hydrostatic BP difference?","solution":"ΔP = ρgΔh = 1050 × 9.8 × 1.3","answer":"≈ 13,377 Pa ≈ 100 mmHg"}$j$),
    (874, 'medical', 'phy-grav-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"9G का मतलब?","options":["9× gravity","9 m/s²","9 atm","9 N"],"answer":0,"explanation":"9G = 9× gravity ≈ 88.2 m/s²"},{"q":"Standing में feet पर BP, brain से?","options":["कम","ज़्यादा","बराबर","शून्य"],"answer":1,"explanation":"Hydrostatic pressure से feet पर ज़्यादा"}]}$j$),

    (875, 'medical', 'phy-press-concept', 'concept', 1, 'दाब और तरल — NEET',
     $j${"text":"Fluids की NEET applications: BP (120/80 mmHg), osmotic pressure (π = CRT), capillary action, Bernoulli in blood flow (atherosclerosis), Poiseuille's law (Q ∝ r⁴)। Blood viscosity ≈ 3-4× water।","note":"NEET में hemodynamics, osmosis, और surface tension (alveoli) पूछे जाते हैं।"}$j$),
    (875, 'medical', 'phy-press-formula', 'formula', 2, 'दाब सूत्र',
     $j${"formula":"P = F/A · P = ρgh · Osmotic π = CRT · Poiseuille: Q = πPr⁴/(8ηL)","explanation":"R = gas constant, C = concentration, T = temp · Atherosclerosis में r कम → Q drastically कम"}$j$),
    (875, 'medical', 'phy-press-example', 'example', 3, 'Medical numerical',
     $j${"question":"Osmotic π: 0.15 M NaCl, 37°C। (i=2 for NaCl)","solution":"π = iCRT = 2 × 0.15 × 0.0821 × 310","answer":"≈ 7.6 atm"}$j$),
    (875, 'medical', 'phy-press-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Poiseuille flow ∝?","options":["r","r²","r³","r⁴"],"answer":3,"explanation":"Q ∝ r⁴"},{"q":"Blood viscosity vs water?","options":["कम","बराबर","3-4× ज़्यादा","10×"],"answer":2,"explanation":"Blood ≈ 3-4× water"}]}$j$),

    (876, 'medical', 'phy-heat-concept', 'concept', 1, 'ऊष्मा — NEET',
     $j${"text":"Heat की NEET applications: body temp regulation 37°C, fever (pyrexia >38°C), hypothermia (<35°C), heat loss (radiation, evaporation, conduction, convection), specific heat of body ≈ 3.5 kJ/kg·K। Latent heat water evaporation body cools।","note":"NEET में thermoregulation, fever, specific heat of body पूछे जाते हैं।"}$j$),
    (876, 'medical', 'phy-heat-formula', 'formula', 2, 'ऊष्मा सूत्र',
     $j${"formula":"Q = mcΔT · Q = mL (latent) · Heat loss = radiation + evaporation + conduction + convection","explanation":"Body specific heat ≈ 3.5 kJ/kg·K · Water Lv ≈ 2260 kJ/kg (sweat cooling)"}$j$),
    (876, 'medical', 'phy-heat-example', 'example', 3, 'Medical numerical',
     $j${"question":"70 kg person, temp 37→39°C। Heat?","solution":"Q = mcΔT = 70 × 3.5 × 2","answer":"490 kJ"}$j$),
    (876, 'medical', 'phy-heat-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Fever में temp कब?","options":[">37°C",">38°C",">39°C",">40°C"],"answer":1,"explanation":"Fever = temp > 38°C"},{"q":"Sweating से cooling किस कारण?","options":["Conduction","Convection","Evaporation","Radiation"],"answer":2,"explanation":"Water evaporation latent heat लेता है"}]}$j$),

    (877, 'medical', 'phy-wave-concept', 'concept', 1, 'तरंगें — NEET',
     $j${"text":"Waves की medical applications: ultrasound imaging (>20 kHz), ECG/EEG, hearing range (20 Hz-20 kHz), Doppler for blood flow। Wavelength of diagnostic ultrasound ≈ 0.1-1 mm।","note":"NEET में ultrasound, Doppler, hearing range पूछे जाते हैं।"}$j$),
    (877, 'medical', 'phy-wave-formula', 'formula', 2, 'तरंग सूत्र',
     $j${"formula":"v = fλ · Doppler: f' = f(v±v_obs)/(v∓v_src)","explanation":"Audible: 20 Hz - 20 kHz · Imaging ultrasound: 1-15 MHz · Doppler for blood flow"}$j$),
    (877, 'medical', 'phy-wave-example', 'example', 3, 'Medical numerical',
     $j${"question":"Ultrasound 5 MHz, tissue v=1540 m/s। λ?","solution":"λ = v/f = 1540/(5×10⁶)","answer":"≈ 0.308 mm"}$j$),
    (877, 'medical', 'phy-wave-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Ultrasound की frequency?","options":[">20 Hz",">200 Hz",">2000 Hz",">20 kHz"],"answer":3,"explanation":">20 kHz (above human hearing)"},{"q":"Doppler effect किसमें?","options":["X-ray","Blood flow","MRI","CT scan"],"answer":1,"explanation":"Doppler ultrasound for blood flow"}]}$j$),

    (878, 'medical', 'phy-sound-concept', 'concept', 1, 'ध्वनि — NEET',
     $j${"text":"Sound की medical applications: stethoscope (heart sounds 20-650 Hz), hearing range (20 Hz-20 kHz), presbycusis (age-related hearing loss >25 dB), audiometry। Human ear sensitive 1-4 kHz। Sound speed tissue ≈ 1540 m/s (air से ज़्यादा)।","note":"NEET में decibel, hearing loss, ultrasound पूछे जाते हैं।"}$j$),
    (878, 'medical', 'phy-sound-formula', 'formula', 2, 'ध्वनि सूत्र',
     $j${"formula":"v = √(B/ρ) · dB = 10 log(I/I₀) · I₀ = 10⁻¹² W/m²","explanation":"B = bulk modulus · Normal hearing: 0 dB · Pain threshold: 120 dB"}$j$),
    (878, 'medical', 'phy-sound-example', 'example', 3, 'Medical numerical',
     $j${"question":"Sound intensity 10⁻⁶ W/m²। dB?","solution":"dB = 10 log(10⁻⁶/10⁻¹²) = 10 × 6","answer":"60 dB"}$j$),
    (878, 'medical', 'phy-sound-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Normal hearing range?","options":["20-20,000 Hz","50-10,000 Hz","100-5,000 Hz","10-30,000 Hz"],"answer":0,"explanation":"20 Hz से 20 kHz"},{"q":"Pain threshold?","options":["60 dB","90 dB","120 dB","150 dB"],"answer":2,"explanation":"120 dB (damage risk)"}]}$j$),

    (879, 'medical', 'lgt-concept', 'concept', 1, 'प्रकाश — NEET',
     $j${"text":"Light की medical applications: vision (400-700 nm visible), eye as optical instrument (myopia, hypermetropia, presbyopia), microscope (compound, ~1000×), LASIK surgery। Lens/mirror formula और magnification NEET में पूछे जाते हैं।","note":"NEET में eye defects, lens power (diopter), microscope पूछे जाते हैं।"}$j$),
    (879, 'medical', 'lgt-formula', 'formula', 2, 'प्रकाश सूत्र',
     $j${"formula":"1/f = 1/v - 1/u · P = 1/f (diopter) · m = v/u · Myopia: concave (-ve), Hypermetropia: convex (+ve)","explanation":"Near point = 25 cm (normal) · Far point = infinity (normal) · Presbyopia = age-related"}$j$),
    (879, 'medical', 'lgt-example', 'example', 3, 'Medical numerical',
     $j${"question":"Myopia -2D। Focal length?","solution":"f = 1/P = 1/(-2) = -0.5m","answer":"f = -50 cm (concave)"}$j$),
    (879, 'medical', 'lgt-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Myopia में lens?","options":["Convex","Concave","Cylindrical","Bifocal"],"answer":1,"explanation":"Concave (diverging) lens"},{"q":"Normal eye near point?","options":["10 cm","25 cm","50 cm","100 cm"],"answer":1,"explanation":"25 cm = least distance of distinct vision"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[], 'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY: select chapter_id, count(*) from mtb.atoms where chapter_id between 870 and 879 and level_id='medical' and status='published' and not archived group by 1 order by 1;  -- expect 4 each
