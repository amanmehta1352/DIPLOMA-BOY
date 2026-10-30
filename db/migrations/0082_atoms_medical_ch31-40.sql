-- Medical chapters 902-912 excluding 908 (4 atoms each, 40 total). Mission label "0081".
-- FIX before apply: digest-formula line said "Trypsin: peptide → dipeptide"; corrected to "Trypsin: protein → peptides" (trypsin cleaves protein, not peptide→dipeptide).
-- Checked: cardiac output 75×70 = 5250 mL/min (≈5.25 L); GFR 125×1440 = 180 L/day; 5 MHz λ=0.308 mm; all MCQ answers verified.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    (902, 'medical', 'bio-tissues-concept', 'concept', 1, 'ऊतक — NEET',
     $j${"text":"4 basic tissues: epithelial (covering), connective (support), muscular (movement), nervous (control)। Epithelial: simple (1 layer) vs stratified (multiple); squamous, cuboidal, columnar। Connective: loose (areolar, adipose), dense (tendon, ligament), specialized (bone, cartilage, blood)। Muscle: skeletal (striated, voluntary), smooth (non-striated, involuntary), cardiac (striated, involuntary)।","note":"NEET में tissue types और उनके locations पूछे जाते हैं।"}$j$),
    (902, 'medical', 'bio-tissues-formula', 'formula', 2, 'ऊतक तथ्य',
     $j${"formula":"Epithelial: covering/lining · Connective: support/bind · Muscular: movement · Nervous: control","explanation":"Blood = fluid connective tissue · Bone = hard connective · Adipose = fat storage · Tendon: muscle-bone · Ligament: bone-bone"}$j$),
    (902, 'medical', 'bio-tissues-example', 'example', 3, 'Medical application',
     $j${"question":"Heart muscle किस type का?","solution":"Cardiac muscle — striated + involuntary","answer":"Cardiac (striated, involuntary, intercalated discs)"}$j$),
    (902, 'medical', 'bio-tissues-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Blood किस tissue type?","options":["Epithelial","Connective","Muscular","Nervous"],"answer":1,"explanation":"Blood = fluid connective tissue (plasma + cells)"},{"q":"Skeletal muscle characteristics?","options":["Non-striated, involuntary","Striated, voluntary","Striated, involuntary","Non-striated, voluntary"],"answer":1,"explanation":"Skeletal: striated + voluntary"}]}$j$),

    (903, 'medical', 'bio-animal-concept', 'concept', 1, 'जंतु जगत — NEET',
     $j${"text":"Animal Kingdom phyla: Porifera (sponges, cellular level), Coelenterata/Cnidaria (hydra, tissue level), Platyhelminthes (flatworms), Aschelminthes (roundworms), Annelida (segmented, earthworm), Arthropoda (largest phylum, insects), Mollusca (snails), Echinodermata (starfish, water vascular), Chordata (vertebrates)। Key features: symmetry, coelom, segmentation, notochord।","note":"NEET में phyla characteristics और examples पूछे जाते हैं।"}$j$),
    (903, 'medical', 'bio-animal-formula', 'formula', 2, 'जंतु वर्गीकरण',
     $j${"formula":"Porifera-cellular · Cnidaria-tissue · Platyhelminthes-flat · Annelida-segmented · Arthropoda-largest · Chordata-notochord","explanation":"Symmetry: radial (Cnidaria, Echinodermata adult) vs bilateral (most others) · Coelom: acoelomate, pseudocoelomate, coelomate"}$j$),
    (903, 'medical', 'bio-animal-example', 'example', 3, 'Medical application',
     $j${"question":"Vector of malaria किस phylum?","solution":"Anopheles mosquito → Arthropoda","answer":"Arthropoda (Insects)"}$j$),
    (903, 'medical', 'bio-animal-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"सबसे बड़ा phylum?","options":["Chordata","Mollusca","Arthropoda","Annelida"],"answer":2,"explanation":"Arthropoda - largest phylum (insects)"},{"q":"Water vascular system किसमें?","options":["Mollusca","Echinodermata","Cnidaria","Porifera"],"answer":1,"explanation":"Echinodermata (starfish, sea urchin)"}]}$j$),

    (904, 'medical', 'bio-plant-concept', 'concept', 1, 'पादप जगत — NEET',
     $j${"text":"Plant Kingdom: Algae (Chlorophyceae, Phaeophyceae, Rhodophyceae), Bryophytes (amphibians of plant kingdom, moss), Pteridophytes (first vascular, fern), Gymnosperms (naked seeds, pine), Angiosperms (flowering, enclosed seeds)। Angiosperms: monocots (1 cotyledon) vs dicots (2 cotyledons)। Double fertilization unique to angiosperms।","note":"NEET में plant groups, vascular tissue, और seed types पूछे जाते हैं।"}$j$),
    (904, 'medical', 'bio-plant-formula', 'formula', 2, 'पादप वर्गीकरण',
     $j${"formula":"Algae (thalloid) → Bryophytes (no vascular, amphibian) → Pteridophytes (vascular, no seed) → Gymnosperms (naked seed) → Angiosperms (flower+fruit)","explanation":"Monocot: 1 cotyledon, fibrous root, parallel venation · Dicot: 2 cotyledons, tap root, reticulate venation"}$j$),
    (904, 'medical', 'bio-plant-example', 'example', 3, 'Medical application',
     $j${"question":"Double fertilization किसमें?","solution":"Only in Angiosperms (2 male gametes: 1 egg + 1 polar nuclei)","answer":"Angiosperms (unique)"}$j$),
    (904, 'medical', 'bio-plant-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Amphibians of plant kingdom?","options":["Algae","Bryophytes","Pteridophytes","Gymnosperms"],"answer":1,"explanation":"Bryophytes (need water for reproduction)"},{"q":"Monocot में cotyledon?","options":["0","1","2","Many"],"answer":1,"explanation":"Monocot = 1 cotyledon (mono=one)"}]}$j$),

    (905, 'medical', 'bio-nutrition-concept', 'concept', 1, 'पोषण — NEET',
     $j${"text":"Nutrition types: autotrophic (photosynthesis) vs heterotrophic (holozoic, saprophytic, parasitic, symbiotic)। Human nutrition: carbohydrates (energy), proteins (amino acids, 9 essential), fats (fatty acids, omega-3/6), vitamins (fat-soluble A,D,E,K; water-soluble B,C), minerals (Ca, Fe, I, Zn)। Deficiency diseases: scurvy (Vit C), rickets (Vit D), beriberi (B1), night blindness (Vit A), goiter (I), anemia (Fe)।","note":"NEET में vitamins, deficiencies, और essential nutrients पूछे जाते हैं।"}$j$),
    (905, 'medical', 'bio-nutrition-formula', 'formula', 2, 'पोषण तथ्य',
     $j${"formula":"Fat-soluble: A, D, E, K · Water-soluble: B-complex, C · Vit A = night vision · Vit C = collagen · Vit D = Ca absorption · Fe = Hb","explanation":"9 essential amino acids · 2 essential fatty acids (linoleic, linolenic) · BMR = 1600-2000 Cal/day"}$j$),
    (905, 'medical', 'bio-nutrition-example', 'example', 3, 'Medical application',
     $j${"question":"Night blindness किसकी कमी से?","solution":"Vitamin A deficiency → rhodopsin ↓","answer":"Vitamin A"}$j$),
    (905, 'medical', 'bio-nutrition-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Scurvy किस विटामिन से?","options":["Vit A","Vit B","Vit C","Vit D"],"answer":2,"explanation":"Scurvy = Vitamin C deficiency"},{"q":"Fat-soluble vitamins?","options":["A,B,C,D","A,D,E,K","B,C,E,K","A,B,K,E"],"answer":1,"explanation":"Fat-soluble: A, D, E, K"}]}$j$),

    (906, 'medical', 'photo-concept', 'concept', 1, 'प्रकाश संश्लेषण — NEET',
     $j${"text":"Photosynthesis: 6CO₂ + 12H₂O + light → C₆H₁₂O₆ + 6O₂ + 6H₂O। Two phases: Light reaction (thylakoid — PSI, PSII, photolysis of water, ATP+NADPH) and Dark reaction/Calvin cycle (stroma — C fixation)। C3 (most plants), C4 (maize, sugarcane — Kranz anatomy), CAM (cacti — night CO₂)। Pigments: chlorophyll a, b, carotenoids।","note":"NEET में C3/C4/CAM और photosynthesis steps पूछे जाते हैं।"}$j$),
    (906, 'medical', 'photo-formula', 'formula', 2, 'प्रकाश संश्लेषण सूत्र',
     $j${"formula":"6CO₂ + 12H₂O + light → C₆H₁₂O₆ + 6O₂ + 6H₂O · Light: PSII → PSI → NADPH · Dark: Calvin cycle (RuBisCO)","explanation":"C3: 1st product 3-PGA · C4: 1st product OAA (4C) · CAM: night CO₂ uptake · RuBisCO = most abundant enzyme"}$j$),
    (906, 'medical', 'photo-example', 'example', 3, 'Medical application',
     $j${"question":"C4 plant का first product?","solution":"CO₂ + PEP → OAA (4 carbon)","answer":"Oxaloacetic acid (OAA, 4C)"}$j$),
    (906, 'medical', 'photo-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Most abundant enzyme on Earth?","options":["Amylase","RuBisCO","Catalase","Pepsin"],"answer":1,"explanation":"RuBisCO (CO₂ fixation)"},{"q":"Photolysis of water कहाँ?","options":["Stroma","Thylakoid (PSII)","Mitochondria","Nucleus"],"answer":1,"explanation":"PSII (thylakoid) — 2H₂O → 4H⁺ + 4e⁻ + O₂"}]}$j$),

    (907, 'medical', 'digest-concept', 'concept', 1, 'पाचन तंत्र — NEET',
     $j${"text":"Digestive system: mouth (salivary amylase — starch), stomach (pepsin, HCl — protein), small intestine (major absorption — villi, microvilli), large intestine (water absorption)। Enzymes: amylase (starch→maltose), pepsin (protein→peptides), trypsin (protein→peptides), lipase (fat→fatty acid+glycerol)। Liver (bile — fat emulsification), pancreas (trypsin, lipase, amylase)।","note":"NEET में digestive enzymes और उनके substrates/products पूछे जाते हैं।"}$j$),
    (907, 'medical', 'digest-formula', 'formula', 2, 'पाचन सूत्र',
     $j${"formula":"Salivary amylase: starch → maltose (mouth, pH 6.8) · Pepsin: protein → peptide (stomach, pH 1.5-3.5) · Trypsin: protein → peptides (SI, pH 8) · Lipase: fat → fatty acid + glycerol","explanation":"Bile: emulsification (no enzyme) · Villi = absorption · Gastric juice = HCl + pepsinogen + mucus + intrinsic factor"}$j$),
    (907, 'medical', 'digest-example', 'example', 3, 'Medical application',
     $j${"question":"Protein digestion stomach में किस enzyme?","solution":"Pepsin (HCl activates pepsinogen → pepsin)","answer":"Pepsin"}$j$),
    (907, 'medical', 'digest-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Fat digestion में bile का role?","options":["Enzyme","Emulsification","Absorption","Storage"],"answer":1,"explanation":"Bile = emulsification (fat → small droplets)"},{"q":"Stomach का pH?","options":["6.8","7.4","1.5-3.5","8.0"],"answer":2,"explanation":"HCl से stomach pH = 1.5-3.5"}]}$j$),

    (909, 'medical', 'circ-concept', 'concept', 1, 'परिसंचरण तंत्र — NEET',
     $j${"text":"Circulatory System: heart (4 chambers), double circulation (pulmonary + systemic), blood vessels (artery, vein, capillary)। Heart rate ≈ 72/min, cardiac output = 5 L/min, stroke volume ≈ 70 mL। Blood: plasma (55%) + cells (RBC, WBC, platelets)। RBC: biconcave, no nucleus (mature), life 120 days, Hb 13-17 g/dL। Cardiac cycle: systole + diastole ≈ 0.8 sec।","note":"NEET में cardiac cycle, blood cells, और ECG पूछे जाते हैं।"}$j$),
    (909, 'medical', 'circ-formula', 'formula', 2, 'परिसंचरण तथ्य',
     $j${"formula":"Cardiac output = HR × SV = 72 × 70 ≈ 5 L/min · BP = 120/80 mmHg · RBC life = 120 days · Normal Hb = 13-17 g/dL","explanation":"Double circulation: right side → lungs (pulmonary), left side → body (systemic) · Cardiac cycle = 0.8 s (systole 0.3, diastole 0.5)"}$j$),
    (909, 'medical', 'circ-example', 'example', 3, 'Medical application',
     $j${"question":"HR 75/min, SV 70 mL। Cardiac output?","solution":"CO = 75 × 70 = 5250 mL/min","answer":"≈ 5.25 L/min"}$j$),
    (909, 'medical', 'circ-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Normal cardiac output?","options":["2 L/min","5 L/min","10 L/min","15 L/min"],"answer":1,"explanation":"≈ 5 L/min (HR × SV)"},{"q":"Mature RBC में nucleus?","options":["हाँ","नहीं","कभी-कभी","कोई नहीं"],"answer":1,"explanation":"Mature mammalian RBC = anucleate"}]}$j$),

    (910, 'medical', 'trans-concept', 'concept', 1, 'पादप परिवहन — NEET',
     $j${"text":"Plant Transport: xylem (water + minerals, upward — root→leaf) and phloem (food/sugars, bidirectional — source→sink)। Transpiration pull, cohesion-tension theory for water ascent। Root pressure, guttation। Stomata: guard cells, K⁺ influx → stomata open। Cohesion, adhesion, surface tension — water column।","note":"NEET में transpiration, xylem/phloem transport, और stomatal mechanism पूछे जाते हैं।"}$j$),
    (910, 'medical', 'trans-formula', 'formula', 2, 'परिवहन तथ्य',
     $j${"formula":"Xylem: water + minerals (unidirectional, upward) · Phloem: sugars + amino acids (bidirectional, source→sink)","explanation":"Transpiration pull = main force for water ascent · Stomata open: K⁺ in → water in → turgid guard cells"}$j$),
    (910, 'medical', 'trans-example', 'example', 3, 'Medical application',
     $j${"question":"Stomata कब खुलते हैं?","solution":"Day time (light → K⁺ influx → water → turgid guard cells)","answer":"दिन में (photosynthesis के लिए CO₂ चाहिए)"}$j$),
    (910, 'medical', 'trans-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Phloem में transport?","options":["केवल ऊपर","केवल नीचे","दोनों दिशाओं में","कोई नहीं"],"answer":2,"explanation":"Phloem bidirectional (source→sink)"},{"q":"Water ascent का main force?","options":["Root pressure","Transpiration pull","Capillarity","Gravity"],"answer":1,"explanation":"Cohesion-tension theory (transpiration pull)"}]}$j$),

    (911, 'medical', 'exc-concept', 'concept', 1, 'उत्सर्जन — NEET',
     $j${"text":"Excretion: kidney (main), skin, lungs, liver। Nephron = functional unit। Urine formation: filtration (glomerulus), reabsorption (PCT), secretion (DCT), concentration (Loop of Henle + collecting duct)। GFR ≈ 125 mL/min, urine ≈ 1.5 L/day। Kidney hormones: renin (BP), erythropoietin (RBC), calcitriol (Vit D)। Disorders: uremia, kidney stones, dialysis।","note":"NEET में nephron, GFR, और kidney functions पूछे जाते हैं।"}$j$),
    (911, 'medical', 'exc-formula', 'formula', 2, 'उत्सर्जन तथ्य',
     $j${"formula":"GFR ≈ 125 mL/min · Urine output ≈ 1.5 L/day · Nephron = ~1 million per kidney","explanation":"Filtration: glomerulus → Bowman's capsule · Reabsorption: PCT (glucose, water, ions) · Loop of Henle: counter-current"}$j$),
    (911, 'medical', 'exc-example', 'example', 3, 'Medical application',
     $j${"question":"1 din में GFR से कितना filtrate?","solution":"125 mL/min × 1440 min/day = 180 L/day","answer":"≈ 180 L/day (99% reabsorbed)"}$j$),
    (911, 'medical', 'exc-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Kidney का functional unit?","options":["Neuron","Nephron","Alveolus","Villus"],"answer":1,"explanation":"Nephron = kidney's functional unit"},{"q":"Erythropoietin कहाँ से?","options":["Liver","Kidney","Bone marrow","Spleen"],"answer":1,"explanation":"Kidney (peritubular cells) → RBC production"}]}$j$),

    (912, 'medical', 'nerve-concept', 'concept', 1, 'तंत्रिका तंत्र — NEET',
     $j${"text":"Nervous System: CNS (brain + spinal cord) + PNS (somatic + autonomic)। Neuron: cell body, dendrites, axon, myelin sheath (Schwann cells)। Resting potential -70 mV (Na⁺ out, K⁺ in), action potential +30 mV। Synapse: neurotransmitter (ACh) release → next neuron। Brain parts: cerebrum (thinking), cerebellum (balance), medulla (breathing, heart rate), hypothalamus (temperature, hunger)।","note":"NEET में action potential, synapse, और brain parts पूछे जाते हैं।"}$j$),
    (912, 'medical', 'nerve-formula', 'formula', 2, 'तंत्रिका तथ्य',
     $j${"formula":"Resting potential: -70 mV · Action potential: +30 mV · Depolarization: Na⁺ in · Repolarization: K⁺ out","explanation":"Myelinated neurons: 120 m/s · Unmyelinated: 1 m/s · Saltatory conduction (node of Ranvier)"}$j$),
    (912, 'medical', 'nerve-example', 'example', 3, 'Medical application',
     $j${"question":"Resting से action potential change?","solution":"-70 mV → +30 mV = 100 mV change","answer":"100 mV depolarization"}$j$),
    (912, 'medical', 'nerve-mcq', 'mcq', 4, 'NEET MCQs',
     $j${"questions":[{"q":"Resting potential में dominant ion outside?","options":["K⁺","Na⁺","Cl⁻","Ca²⁺"],"answer":1,"explanation":"Na⁺ outside, K⁺ inside"},{"q":"Balance का center?","options":["Cerebrum","Cerebellum","Medulla","Hypothalamus"],"answer":1,"explanation":"Cerebellum = balance + coordination"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[], 'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY: select chapter_id, count(*) from mtb.atoms where chapter_id in (902,903,904,905,906,907,909,910,911,912) and level_id='medical' and status='published' and not archived group by 1 order by 1;  -- expect 4 each
