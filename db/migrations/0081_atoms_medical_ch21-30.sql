-- Medical chapters 891-901 (4 atoms each, 40 total). Mission label "0080". Chapter 900 not in mission.
-- FIX before apply: formula/example/mcq rows for 892-899 and 901 were missing level_id (key sat in the level slot). Added 'medical' and moved key into atom_key.
-- Checked: [H⁺]=10⁻² M (pH 2); 5.5 mmol/L × 180 = 99 mg/dL; 4 g/70 kg ≈ 0.006%; 2×0.154×1000 ≈ 308 mOsm/L; ATP 1 per Na-K cycle; 36-38 ATP; no arithmetic errors found.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    (891, 'medical', 'acid-concept', 'concept', 1, 'अम्ल-क्षार-लवण — NEET',
     $j${"text":"Acids-Bases की NEET applications: gastric HCl (pH 1.5-3.5), blood pH buffer (7.35-7.45), respiratory/metabolic acidosis, alkalosis। Henderson-Hasselbalch equation blood buffer के लिए। Antacids (Al(OH)₃, Mg(OH)₂) gastric acid neutralize करते हैं।","note":"NEET में blood pH, buffer, और acid-base disorders पूछे जाते हैं।"}$j$),
    (891, 'medical', 'acid-formula', 'formula', 2, 'अम्ल-क्षार सूत्र',
     $j${"formula":"pH = -log[H⁺] · Henderson-Hasselbalch: pH = pKa + log([A⁻]/[HA]) · Gastric pH ≈ 1.5-3.5","explanation":"Blood buffer: CO₂ + H₂O ⇌ H₂CO₃ ⇌ H⁺ + HCO₃⁻ · Normal HCO₃⁻ ≈ 24 mM"}$j$),
    (891, 'medical', 'acid-example', 'example', 3, 'Medical numerical',
     $j${"question":"Gastric HCl pH 2। H⁺ concentration?","solution":"[H⁺] = 10^(-pH) = 10⁻² M","answer":"10⁻² M (0.01 M)"}$j$),
    (891, 'medical', 'acid-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Gastric juice का pH?","options":["1.5-3.5","4.5-5.5","6.5-7.5","7.35-7.45"],"answer":0,"explanation":"HCl से gastric pH = 1.5-3.5"},{"q":"Blood buffer system?","options":["Phosphate","Bicarbonate (H₂CO₃/HCO₃⁻)","Protein","Hemoglobin"],"answer":1,"explanation":"Main blood buffer = bicarbonate"}]}$j$),

    (892, 'medical', 'metal-concept', 'concept', 1, 'धातु-अधातु — NEET',
     $j${"text":"Metals-Nonmetals की NEET applications: essential minerals (Fe, Zn, Cu, Mg, Ca, K, Na), toxicity (Pb, Hg, Cd, As), radiopaque agents (Ba, I), dental amalgam (Hg+Ag+Sn)। Iron deficiency → anemia, iodine → goiter, zinc → wound healing।","note":"NEET में mineral deficiencies और toxic metals पूछे जाते हैं।"}$j$),
    (892, 'medical', 'metal-formula', 'formula', 2, 'धातु तथ्य',
     $j${"formula":"Fe: hemoglobin (O₂ transport) · I: thyroid hormones · Ca: bones/teeth · Zn: 300+ enzymes","explanation":"Toxic: Pb (brain damage), Hg (Minamata), Cd (Itai-itai), As (skin lesions)"}$j$),
    (892, 'medical', 'metal-example', 'example', 3, 'Medical numerical',
     $j${"question":"Adult body में iron का % (70 kg)?","solution":"Total body iron ≈ 4g। 4g/70kg = 0.057g/kg","answer":"≈ 0.006% of body weight"}$j$),
    (892, 'medical', 'metal-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Iron deficiency से रोग?","options":["Goiter","Anemia","Rickets","Scurvy"],"answer":1,"explanation":"Iron deficiency → anemia"},{"q":"Minamata disease किससे?","options":["Pb","Hg","Cd","As"],"answer":1,"explanation":"Mercury (Hg) poisoning (Japan)"}]}$j$),

    (893, 'medical', 'carbon-concept', 'concept', 1, 'कार्बन — NEET',
     $j${"text":"Carbon compounds की medical applications: biomolecules (carbohydrates, proteins, lipids, nucleic acids), functional groups (-OH, -COOH, -NH₂, -CHO), isomers, aromatic compounds (benzene, drugs)। Carbon की tetravalency और catenation जीवन का आधार।","note":"NEET में functional groups, isomers, और biomolecule structures पूछे जाते हैं।"}$j$),
    (893, 'medical', 'carbon-formula', 'formula', 2, 'कार्बन सूत्र',
     $j${"formula":"Functional groups: -OH (alcohol), -COOH (acid), -CHO (aldehyde), -CO (ketone), -NH₂ (amine), -COOR (ester)","explanation":"Glucose C₆H₁₂O₆ · Amino acids: NH₂-CHR-COOH · Fatty acids: R-COOH"}$j$),
    (893, 'medical', 'carbon-example', 'example', 3, 'Medical numerical',
     $j${"question":"Glucose ka molecular formula?","solution":"Carbohydrate hexose: 6C, 12H, 6O","answer":"C₆H₁₂O₆"}$j$),
    (893, 'medical', 'carbon-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Amino acid में functional groups?","options":["-OH,-CHO","-NH₂,-COOH","-CO,-OH","-NH₂,-CHO"],"answer":1,"explanation":"Amino group + carboxylic acid"},{"q":"Glucose किस class?","options":["Protein","Carbohydrate","Lipid","Nucleic acid"],"answer":1,"explanation":"Monosaccharide (carbohydrate)"}]}$j$),

    (894, 'medical', 'sol-concept', 'concept', 1, 'विलयन — NEET',
     $j${"text":"Solutions की medical applications: IV fluids (0.9% NaCl = isotonic, 5% dextrose), osmosis (cell volume), colligative properties (osmotic pressure), hypotonic/hypertonic solutions in cells, dialysis। Plasma osmolarity ≈ 290 mOsm/L।","note":"NEET में osmosis, osmolarity, और IV fluids की tonicity पूछे जाते हैं।"}$j$),
    (894, 'medical', 'sol-formula', 'formula', 2, 'विलयन सूत्र',
     $j${"formula":"Osmotic π = iCRT · Osmolarity = i × C (mOsm/L) · 0.9% NaCl ≈ 308 mOsm/L","explanation":"Isotonic ≈ 290-300 mOsm/L · Hypotonic: cell swell · Hypertonic: cell shrink"}$j$),
    (894, 'medical', 'sol-example', 'example', 3, 'Medical numerical',
     $j${"question":"0.9% NaCl (i=2), M=0.154M। Osmolarity?","solution":"Osmolarity = 2 × 0.154 × 1000","answer":"≈ 308 mOsm/L"}$j$),
    (894, 'medical', 'sol-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"0.9% NaCl को क्या कहते हैं?","options":["Hypotonic","Isotonic","Hypertonic","Pure water"],"answer":1,"explanation":"0.9% NaCl = normal saline (isotonic to blood)"},{"q":"Hypertonic solution में RBC?","options":["Swell","Shrink (crenate)","No change","Burst"],"answer":1,"explanation":"Water leaves cell → shrink"}]}$j$),

    (895, 'medical', 'electro-concept', 'concept', 1, 'विद्युत रसायन — NEET',
     $j${"text":"Electrochemistry की medical applications: action potential (Na⁺/K⁺ gradient), Na⁺-K⁺ ATPase pump (3Na⁺ out, 2K⁺ in), ECG, resting membrane potential (-70mV), Nernst equation biological membranes के लिए।","note":"NEET में Na⁺-K⁺ pump, membrane potential, और Nernst equation पूछे जाते हैं।"}$j$),
    (895, 'medical', 'electro-formula', 'formula', 2, 'विद्युत रसायन सूत्र',
     $j${"formula":"Nernst: E = E° - (RT/nF) ln Q · Membrane potential: -70mV (resting) · Na⁺-K⁺ pump: 3Na⁺ out / 2K⁺ in","explanation":"Depolarization: +30mV (Na⁺ in) · Repolarization: -70mV (K⁺ out)"}$j$),
    (895, 'medical', 'electro-example', 'example', 3, 'Medical numerical',
     $j${"question":"Na⁺-K⁺ pump 1 cycle में ATP?","solution":"3Na⁺ out, 2K⁺ in per ATP","answer":"1 ATP per cycle"}$j$),
    (895, 'medical', 'electro-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Resting membrane potential में main ion outside?","options":["K⁺","Na⁺","Cl⁻","Ca²⁺"],"answer":1,"explanation":"Na⁺ outside (high), K⁺ inside (high)"},{"q":"Depolarization में कौन अंदर आता है?","options":["K⁺","Na⁺","Cl⁻","Ca²⁺"],"answer":1,"explanation":"Na⁺ influx during depolarization"}]}$j$),

    (896, 'medical', 'fuel-concept', 'concept', 1, 'ईंधन-दहन — NEET',
     $j${"text":"Fuels-Combustion की medical applications: metabolism (cellular respiration ≈ combustion), ATP production, calorie value of foods (carbs 4 Cal/g, proteins 4 Cal/g, fats 9 Cal/g), oxygen consumption (VO₂ max), brown fat thermogenesis।","note":"NEET में food caloric values और metabolism पूछे जाते हैं।"}$j$),
    (896, 'medical', 'fuel-formula', 'formula', 2, 'ईंधन सूत्र',
     $j${"formula":"Energy from food: carbs 4 Cal/g · proteins 4 Cal/g · fats 9 Cal/g · alcohol 7 Cal/g","explanation":"Cellular respiration: C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + 38 ATP · BMR ≈ 1600-2000 Cal/day"}$j$),
    (896, 'medical', 'fuel-example', 'example', 3, 'Medical numerical',
     $j${"question":"100g fat से कितनी Cal?","solution":"100 g × 9 Cal/g","answer":"900 Cal"}$j$),
    (896, 'medical', 'fuel-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Fats से Cal/g?","options":["4","7","9","12"],"answer":2,"explanation":"Fats = 9 Cal/g (highest)"},{"q":"Proteins from Cal/g?","options":["4","7","9","12"],"answer":0,"explanation":"Proteins = 4 Cal/g (same as carbs)"}]}$j$),

    (897, 'medical', 'poly-concept', 'concept', 1, 'बहुलक — NEET',
     $j${"text":"Polymers की medical applications: biopolymers (DNA, RNA, proteins, starch, cellulose), biodegradable (PLA, PHA), medical devices (sutures, implants), hydrogels (contact lens, drug delivery)। Addition vs condensation polymerization।","note":"NEET में biopolymers, biodegradable polymers, और medical uses पूछे जाते हैं।"}$j$),
    (897, 'medical', 'poly-formula', 'formula', 2, 'बहुलक सूत्र',
     $j${"formula":"Addition: n CH₂=CH₂ → (CH₂-CH₂)ₙ (polyethylene) · Condensation: n H₂N-R-COOH → [-NH-R-CO-]ₙ + nH₂O","explanation":"Natural: DNA (nucleotides), protein (amino acids), starch (glucose) · Synthetic medical: PLA, PGA (sutures)"}$j$),
    (897, 'medical', 'poly-example', 'example', 3, 'Medical numerical',
     $j${"question":"Protein में monomers?","solution":"Amino acids (20 standard)","answer":"Amino acids (peptide bonds से जुड़े)"}$j$),
    (897, 'medical', 'poly-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"DNA किस type का polymer?","options":["Addition","Condensation (nucleotide)","Covalent network","Metallic"],"answer":1,"explanation":"DNA = condensation polymer of nucleotides"},{"q":"Biodegradable polymer?","options":["Polythene","PVC","PLA","Bakelite"],"answer":2,"explanation":"PLA (polylactic acid) = biodegradable"}]}$j$),

    (898, 'medical', 'corr-concept', 'concept', 1, 'संक्षारण — NEET',
     $j${"text":"Corrosion की medical applications: oxidative stress (ROS damage), iron metabolism (Fe²⁺ ↔ Fe³⁺ in hemoglobin), free radical damage, lipid peroxidation, antioxidant defense (SOD, catalase, glutathione peroxidase)। Rusting = iron oxidation, body में iron similar chemistry।","note":"NEET में ROS, antioxidants, और iron metabolism पूछे जाते हैं।"}$j$),
    (898, 'medical', 'corr-formula', 'formula', 2, 'संक्षारण सूत्र',
     $j${"formula":"Rust: 4Fe + 3O₂ + 6H₂O → 4Fe(OH)₃ · ROS: O₂⁻ (superoxide), H₂O₂, OH• (hydroxyl)","explanation":"Antioxidants: Vitamin C, E, SOD, catalase, glutathione · Fe²⁺ ↔ Fe³⁺ in heme"}$j$),
    (898, 'medical', 'corr-example', 'example', 3, 'Medical numerical',
     $j${"question":"Rusting में Fe oxidation state?","solution":"Fe⁰ → Fe³⁺ (loses 3 e⁻)","answer":"Fe(0) → Fe(+3)"}$j$),
    (898, 'medical', 'corr-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Most damaging ROS?","options":["O₂⁻","H₂O₂","OH•","NO"],"answer":2,"explanation":"Hydroxyl radical (OH•) - most reactive"},{"q":"SOD enzyme क्या करता है?","options":["O₂⁻ को H₂O₂ में","H₂O₂ को H₂O में","OH• बनाता है","Vitamin C बनाता है"],"answer":0,"explanation":"Superoxide dismutase: 2O₂⁻ + 2H⁺ → H₂O₂ + O₂"}]}$j$),

    (899, 'medical', 'lab-concept', 'concept', 1, 'प्रयोगशाला रसायन — NEET',
     $j${"text":"Laboratory Chemistry की NEET applications: blood tests (glucose, cholesterol, HbA1c), urine analysis, culture media, PCR, ELISA, chromatography (TLC, HPLC)। pH meters, spectrophotometer, centrifuge — सब diagnostic tools। Normal ranges: glucose 70-100 mg/dL, cholesterol <200 mg/dL।","note":"NEET में diagnostic tests, normal ranges, और lab techniques पूछे जाते हैं।"}$j$),
    (899, 'medical', 'lab-formula', 'formula', 2, 'Lab tests + ranges',
     $j${"formula":"Glucose: 70-100 mg/dL (fasting) · Cholesterol: <200 mg/dL · Hb: 13-17 g/dL · WBC: 4,000-11,000/μL","explanation":"ELISA: antibody-antigen · PCR: DNA amplification · TLC: separation by polarity"}$j$),
    (899, 'medical', 'lab-example', 'example', 3, 'Medical numerical',
     $j${"question":"Glucose 5.5 mmol/L को mg/dL में? (MW 180)","solution":"5.5 × 180 = 990 mg/L = 99 mg/dL","answer":"≈ 99 mg/dL (normal)"}$j$),
    (899, 'medical', 'lab-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Fasting blood glucose normal?","options":["40-60 mg/dL","70-100 mg/dL","150-200 mg/dL","200+ mg/dL"],"answer":1,"explanation":"70-100 mg/dL (fasting)"},{"q":"PCR का उपयोग?","options":["Protein separation","DNA amplification","Glucose test","Lipid test"],"answer":1,"explanation":"Polymerase Chain Reaction = DNA amplification"}]}$j$),

    (901, 'medical', 'cell-concept', 'concept', 1, 'कोशिका — NEET',
     $j${"text":"Cell की NEET applications: cell theory, prokaryotic (bacteria, no nucleus) vs eukaryotic (nucleus, organelles), plasma membrane (fluid mosaic model), organelle functions (mitochondria = power house, ribosome = protein synthesis, Golgi = packaging, lysosome = digestion, ER = transport)।","note":"NEET में cell organelles और उनके functions पूछे जाते हैं।"}$j$),
    (901, 'medical', 'cell-formula', 'formula', 2, 'कोशिका तथ्य',
     $j${"formula":"Mitochondria = ATP (powerhouse) · Ribosome = protein synthesis · Golgi = modification/packaging · Lysosome = digestion (suicidal bag)","explanation":"Prokaryotic: no nucleus, 70S ribosome · Eukaryotic: nucleus, 80S ribosome · Cell membrane = phospholipid bilayer"}$j$),
    (901, 'medical', 'cell-example', 'example', 3, 'Medical numerical',
     $j${"question":"Human RBC में mitochondria?","solution":"Mature RBC में mitochondria नहीं (anaerobic glycolysis)","answer":"नहीं होता (O₂ carrying के लिए space)"}$j$),
    (901, 'medical', 'cell-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Powerhouse of cell?","options":["Nucleus","Mitochondria","Ribosome","Golgi"],"answer":1,"explanation":"Mitochondria = ATP production"},{"q":"Suicidal bag?","options":["Lysosome","Ribosome","ER","Golgi"],"answer":0,"explanation":"Lysosome (hydrolytic enzymes)"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[], 'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY: select chapter_id, count(*) from mtb.atoms where chapter_id in (891,892,893,894,895,896,897,898,899,901) and level_id='medical' and status='published' and not archived group by 1 order by 1;  -- expect 4 each
