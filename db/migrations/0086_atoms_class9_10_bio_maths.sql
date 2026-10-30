with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ CLASS 9-10 BIOLOGY (907-920) ═══
    (907, 'class_9_10', 'digest-910-concept', 'concept', 1, 'पाचन तंत्र — Class 9-10',
     $j${"text":"Digestive system: mouth (teeth + saliva) → esophagus → stomach → small intestine → large intestine → anus। Saliva (amylase) starch digest करता है। Stomach में HCl + pepsin protein digest। Small intestine में complete digestion + absorption (villi)। Large intestine water absorb। Liver bile बनाता है (fat digestion)।","note":"Board में digestive parts और enzymes ज़रूरी हैं।"}$j$),
    (907, 'class_9_10', 'digest-910-formula', 'formula', 2, 'पाचन तथ्य',
     $j${"formula":"Mouth: starch → maltose (amylase) · Stomach: protein → peptides (pepsin) · Small intestine: complete digestion + absorption","explanation":"Bile (liver) = fat emulsification · Villi = absorption surface · Peristalsis = food movement"}$j$),
    (907, 'class_9_10', 'digest-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Protein digestion stomach में किस enzyme से?","solution":"Pepsin (HCl activates pepsinogen)","answer":"Pepsin"}$j$),
    (907, 'class_9_10', 'digest-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Starch digestion कहाँ शुरू?","options":["Stomach","Mouth","Small intestine","Large intestine"],"answer":1,"explanation":"Mouth - salivary amylase"},{"q":"Bile कहाँ से?","options":["Stomach","Liver","Pancreas","Small intestine"],"answer":1,"explanation":"Bile produced in liver"}]}$j$),

    (908, 'class_9_10', 'resp-910-concept', 'concept', 1, 'श्वसन — Class 9-10',
     $j${"text":"Respiration: food से energy release। Types: aerobic (O₂ के साथ — CO₂ + H₂O + 38 ATP) vs anaerobic (बिना O₂ — lactic acid/ethanol + 2 ATP)। Human respiratory system: nose → trachea → bronchi → bronchioles → alveoli (gas exchange)। Diaphragm + ribs breathing में help करते हैं।","note":"Board में aerobic vs anaerobic और respiratory parts ज़रूरी हैं।"}$j$),
    (908, 'class_9_10', 'resp-910-formula', 'formula', 2, 'श्वसन सूत्र',
     $j${"formula":"Aerobic: C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + 38 ATP · Anaerobic (muscle): glucose → lactic acid + 2 ATP","explanation":"Yeast (fermentation): glucose → ethanol + CO₂ + 2 ATP · Alveoli = gas exchange site"}$j$),
    (908, 'class_9_10', 'resp-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Aerobic respiration में कितने ATP?","solution":"Complete glucose oxidation = 38 ATP","answer":"38 ATP"}$j$),
    (908, 'class_9_10', 'resp-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Gas exchange कहाँ?","options":["Trachea","Bronchi","Alveoli","Nose"],"answer":2,"explanation":"Alveoli = tiny air sacs for gas exchange"},{"q":"Anaerobic में muscle में क्या बनता?","options":["CO₂","Lactic acid","Ethanol","Water"],"answer":1,"explanation":"Muscle anaerobic → lactic acid"}]}$j$),

    (909, 'class_9_10', 'circ-910-concept', 'concept', 1, 'परिसंचरण — Class 9-10',
     $j${"text":"Circulatory system: heart + blood vessels + blood। Heart 4 chambers: right atrium/ventricle, left atrium/ventricle। Double circulation (pulmonary + systemic)। Blood: plasma + RBC (O₂ transport, Hb) + WBC (immunity) + platelets (clotting)। Arteries (away from heart), veins (towards heart), capillaries (exchange)।","note":"Board में heart chambers और blood components ज़रूरी हैं।"}$j$),
    (909, 'class_9_10', 'circ-910-formula', 'formula', 2, 'परिसंचरण तथ्य',
     $j${"formula":"Heart 4 chambers: RA, RV, LA, LV · Double circulation: pulmonary (right→lungs→left) + systemic (left→body→right)","explanation":"RBC = O₂ transport (Hb), life 120 days · WBC = immunity · Platelets = clotting · Normal BP 120/80 mmHg"}$j$),
    (909, 'class_9_10', 'circ-910-example', 'example', 3, 'Board numerical',
     $j${"question":"O₂ transport कौन करता है?","solution":"RBC में hemoglobin","answer":"Red Blood Cells (RBC)"}$j$),
    (909, 'class_9_10', 'circ-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Heart में chambers?","options":["2","3","4","5"],"answer":2,"explanation":"4 chambers (2 atria + 2 ventricles)"},{"q":"Blood clotting में?","options":["RBC","WBC","Platelets","Plasma"],"answer":2,"explanation":"Platelets = clotting"}]}$j$),

    (910, 'class_9_10', 'trans-910-concept', 'concept', 1, 'पादप परिवहन — Class 9-10',
     $j${"text":"Plant transport: xylem (water + minerals, ऊपर) + phloem (food, नीचे/ऊपर)। Root hairs absorb water। Transpiration: leaves से water loss (stomata) → water pull। Translocation: phloem से food transport (source → sink)।","note":"Board में xylem/phloem और transpiration ज़रूरी हैं।"}$j$),
    (910, 'class_9_10', 'trans-910-formula', 'formula', 2, 'परिवहन तथ्य',
     $j${"formula":"Xylem: water + minerals (root → leaf, upward) · Phloem: food (source → sink, both directions)","explanation":"Transpiration = water loss via stomata · Translocation = food transport via phloem"}$j$),
    (910, 'class_9_10', 'trans-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Water transport किस tissue से?","solution":"Xylem (dead cells, water column)","answer":"Xylem"}$j$),
    (910, 'class_9_10', 'trans-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Food transport किससे?","options":["Xylem","Phloem","Root","Leaf"],"answer":1,"explanation":"Phloem = food (source → sink)"},{"q":"Transpiration कहाँ से?","options":["Root","Stem","Leaf (stomata)","Flower"],"answer":2,"explanation":"Leaves (via stomata)"}]}$j$),

    (911, 'class_9_10', 'exc-910-concept', 'concept', 1, 'उत्सर्जन — Class 9-10',
     $j${"text":"Excretion: waste removal। Human: kidney (main), skin (sweat), lungs (CO₂), liver (bile pigments)। Nephron = functional unit of kidney। Urine formation: filtration → reabsorption → secretion। Plant excretion: O₂, CO₂, excess water, resins, gums।","note":"Board में kidney structure और plant excretion ज़रूरी हैं।"}$j$),
    (911, 'class_9_10', 'exc-910-formula', 'formula', 2, 'उत्सर्जन तथ्य',
     $j${"formula":"Kidney: blood → urine (nephron units) · Skin: sweat (water + salts + urea) · Lungs: CO₂","explanation":"Nephron: filtration (glomerulus) → reabsorption (tubules) → urine · Plant: resins, gums, excess water"}$j$),
    (911, 'class_9_10', 'exc-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Kidney का functional unit?","solution":"Nephron","answer":"Nephron"}$j$),
    (911, 'class_9_10', 'exc-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Main excretory organ?","options":["Skin","Lungs","Kidney","Liver"],"answer":2,"explanation":"Kidney = main excretory organ"},{"q":"Sweat में?","options":["Water + salts + urea","Only water","Only salts","CO₂"],"answer":0,"explanation":"Sweat = water + salts + urea"}]}$j$),

    (912, 'class_9_10', 'nerve-910-concept', 'concept', 1, 'तंत्रिका तंत्र — Class 9-10',
     $j${"text":"Nervous system: control + coordination। CNS (brain + spinal cord) + PNS (nerves)। Neuron = structural unit (cell body, dendrites, axon)। Brain: cerebrum (thinking), cerebellum (balance), medulla (involuntary — breathing, heartbeat)। Reflex action: quick, involuntary response (spinal cord)।","note":"Board में brain parts और reflex action ज़रूरी हैं।"}$j$),
    (912, 'class_9_10', 'nerve-910-formula', 'formula', 2, 'तंत्रिका तथ्य',
     $j${"formula":"CNS = brain + spinal cord · PNS = nerves · Neuron = structural unit","explanation":"Cerebrum = thinking · Cerebellum = balance · Medulla = involuntary actions (breathing, heart rate) · Reflex arc: receptor → sensory → spinal cord → motor → muscle"}$j$),
    (912, 'class_9_10', 'nerve-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Balance का center?","solution":"Cerebellum","answer":"Cerebellum"}$j$),
    (912, 'class_9_10', 'nerve-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Thinking का center?","options":["Cerebellum","Cerebrum","Medulla","Spinal cord"],"answer":1,"explanation":"Cerebrum = thinking, memory"},{"q":"Reflex action का center?","options":["Brain","Spinal cord","Heart","Lungs"],"answer":1,"explanation":"Spinal cord (reflex arc)"}]}$j$),

    (913, 'class_9_10', 'hormones-910-concept', 'concept', 1, 'हार्मोन — Class 9-10',
     $j${"text":"Hormones: chemical messengers (endocrine glands से)। Pituitary = master gland। Thyroid (thyroxine — metabolism)। Pancreas (insulin — blood sugar)। Adrenal (adrenaline — fight/flight)। Gonads (testosterone, estrogen)। Deficiency: diabetes (insulin), goiter (iodine), dwarfism (GH)।","note":"Board में hormone-gland pairs और disorders ज़रूरी हैं।"}$j$),
    (913, 'class_9_10', 'hormones-910-formula', 'formula', 2, 'हार्मोन तथ्य',
     $j${"formula":"Pituitary (master) → Thyroid (thyroxine, metabolism) → Pancreas (insulin, sugar) → Adrenal (adrenaline) → Gonads","explanation":"Diabetes = insulin deficiency · Goiter = iodine deficiency (thyroid) · Dwarfism/gigantism = GH"}$j$),
    (913, 'class_9_10', 'hormones-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Insulin कहाँ से?","solution":"Pancreas (β-cells)","answer":"Pancreas"}$j$),
    (913, 'class_9_10', 'hormones-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Master gland?","options":["Thyroid","Pituitary","Pancreas","Adrenal"],"answer":1,"explanation":"Pituitary = master gland"},{"q":"Diabetes में deficiency?","options":["Thyroxine","Insulin","Adrenaline","Estrogen"],"answer":1,"explanation":"Insulin deficiency → diabetes"}]}$j$),

    (914, 'class_9_10', 'skeletal-910-concept', 'concept', 1, 'कंकाल-पेशी — Class 9-10',
     $j${"text":"Skeletal system: 206 bones (adult)। Functions: support, protection, movement, mineral storage, blood cell production। Types: long (femur), short (wrist), flat (skull), irregular (vertebra)। Joints: immovable (skull), slightly movable (spine), freely movable (knee, elbow)। Muscles: 3 types — skeletal, smooth, cardiac।","note":"Board में bones count, joints, और muscle types ज़रूरी हैं।"}$j$),
    (914, 'class_9_10', 'skeletal-910-formula', 'formula', 2, 'कंकाल तथ्य',
     $j${"formula":"206 bones (adult) · Longest: femur · Smallest: stapes (ear) · Joints: immovable, slightly, freely movable","explanation":"Skeletal muscle: voluntary, striated · Smooth: involuntary, non-striated · Cardiac: involuntary, striated"}$j$),
    (914, 'class_9_10', 'skeletal-910-example', 'example', 3, 'Board numerical',
     $j${"question":"सबसे लंबी हड्डी?","solution":"Femur (thigh bone)","answer":"Femur"}$j$),
    (914, 'class_9_10', 'skeletal-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Adult में कुल bones?","options":["106","206","306","406"],"answer":1,"explanation":"206 bones (adult)"},{"q":"Heart muscle type?","options":["Skeletal","Smooth","Cardiac","Mixed"],"answer":2,"explanation":"Cardiac muscle (involuntary, striated)"}]}$j$),

    (915, 'class_9_10', 'repro-910-concept', 'concept', 1, 'जनन — Class 9-10',
     $j${"text":"Reproduction: organisms अपनी तरह के नए जीव बनाते हैं। Types: asexual (single parent — binary fission, budding, fragmentation) vs sexual (two parents — gametes fuse)। Human: male (testes → sperm) + female (ovary → egg)। Fertilization → zygote → embryo → foetus → baby।","note":"Board में asexual vs sexual और human reproduction ज़रूरी हैं।"}$j$),
    (915, 'class_9_10', 'repro-910-formula', 'formula', 2, 'जनन तथ्य',
     $j${"formula":"Asexual: binary fission (amoeba), budding (yeast), fragmentation (spirogyra) · Sexual: gamete fusion → zygote","explanation":"Male gamete: sperm · Female gamete: egg · Fertilization → zygote (2n) · Gestation ≈ 9 months in humans"}$j$),
    (915, 'class_9_10', 'repro-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Amoeba कैसे reproduce करता है?","solution":"Binary fission (one cell → two)","answer":"Binary fission (asexual)"}$j$),
    (915, 'class_9_10', 'repro-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Yeast कैसे reproduce?","options":["Binary fission","Budding","Fragmentation","Sexual"],"answer":1,"explanation":"Yeast = budding"},{"q":"Male gamete?","options":["Egg","Sperm","Zygote","Embryo"],"answer":1,"explanation":"Sperm = male gamete"}]}$j$),

    (916, 'class_9_10', 'genetics-910-concept', 'concept', 1, 'आनुवंशिकी — Class 9-10',
     $j${"text":"Heredity: parents से offspring में traits transfer। Gene = trait का unit। Chromosomes: 46 in humans (23 pairs)। Dominant vs recessive traits। Mendel's laws: segregation, independent assortment। Genotype (genetic makeup) vs phenotype (visible trait)। Sex determination: XX (female), XY (male)।","note":"Board में genes, chromosomes, और Mendel ज़रूरी हैं।"}$j$),
    (916, 'class_9_10', 'genetics-910-formula', 'formula', 2, 'आनुवंशिकी तथ्य',
     $j${"formula":"Human chromosomes: 46 (23 pairs) · Sex: XX (female), XY (male) · Monohybrid: 3:1 phenotype","explanation":"Dominant (T) masks recessive (t) · TT/Tt = tall, tt = short · Genotype ≠ phenotype"}$j$),
    (916, 'class_9_10', 'genetics-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Male chromosomes?","solution":"XY (one X + one Y)","answer":"XY"}$j$),
    (916, 'class_9_10', 'genetics-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Human chromosomes?","options":["23","44","46","48"],"answer":2,"explanation":"46 (23 pairs)"},{"q":"Female sex chromosomes?","options":["XX","XY","YY","XO"],"answer":0,"explanation":"XX = female"}]}$j$),

    (917, 'class_9_10', 'evol-910-concept', 'concept', 1, 'विकास — Class 9-10',
     $j${"text":"Evolution: species का time के साथ change। Darwin: natural selection (survival of the fittest)। Evidence: fossils, homologous organs (same structure — forelimb of man/whale), analogous organs (same function — wings of bird/insect)। Speciation: new species formation (geographic isolation)।","note":"Board में Darwin, homologous vs analogous organs ज़रूरी हैं।"}$j$),
    (917, 'class_9_10', 'evol-910-formula', 'formula', 2, 'विकास तथ्य',
     $j${"formula":"Darwin: natural selection (fittest survive) · Homologous: same structure, different function · Analogous: different structure, same function","explanation":"Fossils = evidence · Speciation = new species via isolation · Human evolution: Homo habilis → erectus → sapiens"}$j$),
    (917, 'class_9_10', 'evol-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Bird wing + insect wing कौन सा?","solution":"Different structure, same function (flight)","answer":"Analogous organs"}$j$),
    (917, 'class_9_10', 'evol-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Natural selection किसने?","options":["Lamarck","Darwin","Mendel","Pasteur"],"answer":1,"explanation":"Darwin (natural selection)"},{"q":"Homologous organs?","options":["Same structure","Same function","Same species","Same size"],"answer":0,"explanation":"Homologous = same origin/structure, different function"}]}$j$),

    (918, 'class_9_10', 'disease-910-concept', 'concept', 1, 'रोग-प्रतिरक्षा — Class 9-10',
     $j${"text":"Diseases: infectious (pathogens — bacteria, virus, fungi, protozoa) vs non-infectious (deficiency, genetic)। Transmission: air, water, food, contact, vectors। Examples: malaria (Plasmodium, mosquito), TB (bacteria, air), polio (virus), typhoid (bacteria, water)। Immunity: body's defense। Vaccine: weakened pathogen → antibodies।","note":"Board में disease-pathogen-vector combinations ज़रूरी हैं।"}$j$),
    (918, 'class_9_10', 'disease-910-formula', 'formula', 2, 'रोग तथ्य',
     $j${"formula":"Malaria: Plasmodium (mosquito) · TB: bacteria (air) · Polio: virus · Typhoid: bacteria (water/food)","explanation":"Vaccine = weakened/killed pathogen → immune memory · Antibiotics = against bacteria (not viruses)"}$j$),
    (918, 'class_9_10', 'disease-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Malaria किससे फैलता है?","solution":"Plasmodium (protozoan) via female Anopheles mosquito","answer":"Plasmodium (via mosquito bite)"}$j$),
    (918, 'class_9_10', 'disease-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Malaria का pathogen?","options":["Virus","Bacteria","Plasmodium","Fungi"],"answer":2,"explanation":"Plasmodium (protozoa)"},{"q":"Vaccine क्या करता है?","options":["Cure","Prevent","Spread","Nothing"],"answer":1,"explanation":"Vaccine = prevention (immunity)"}]}$j$),

    (920, 'class_9_10', 'env-910-concept', 'concept', 1, 'पर्यावरण — Class 9-10',
     $j${"text":"Environment: biotic (living) + abiotic (non-living) components। Ecosystem: interaction between them। Food chain: producer → consumer (herbivore → carnivore)। Food web: interconnected chains। Pollution: air (smoke, gases), water (sewage, chemicals), soil (pesticides)। Ozone layer: UV protection (CFCs damage)।","note":"Board में food chain और pollution types ज़रूरी हैं।"}$j$),
    (920, 'class_9_10', 'env-910-formula', 'formula', 2, 'पर्यावरण तथ्य',
     $j${"formula":"Food chain: producer → primary → secondary → tertiary consumer · 10% energy transfer at each level","explanation":"Pollution: air (SO₂, NOₓ, CO), water (BOD), soil (pesticides) · Ozone (O₃) protects from UV"}$j$),
    (920, 'class_9_10', 'env-910-example', 'example', 3, 'Board numerical',
     $j${"question":"Food chain का पहला level?","solution":"Producers (green plants)","answer":"Producer (plants)"}$j$),
    (920, 'class_9_10', 'env-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"Food chain में energy transfer?","options":["50%","25%","10%","100%"],"answer":2,"explanation":"10% law (Lindeman)"},{"q":"Ozone layer क्या protect करता?","options":["Heat","UV rays","Rain","Wind"],"answer":1,"explanation":"Ozone protects from UV rays"}]}$j$),

    -- ═══ CLASS 9-10 MATHS (1-6) ═══
    (1, 'class_9_10', 'pct-910-concept', 'concept', 1, 'प्रतिशत — Class 9-10',
     $j${"text":"Percentage: 'per 100'। 25% = 25/100 = 1/4। Percentage to fraction: /100, simplify। Fraction to %: ×100। Applications: marks percentage, price change, profit-loss। Formula: % = (part/whole) × 100।","note":"Board में % ↔ fraction conversions और simple applications ज़रूरी हैं।"}$j$),
    (1, 'class_9_10', 'pct-910-formula', 'formula', 2, 'प्रतिशत सूत्र',
     $j${"formula":"% = (part/whole) × 100 · Fraction → %: × 100 · % → fraction: /100","explanation":"25% = 1/4 · 50% = 1/2 · 20% = 1/5 · 10% = 1/10 · Common conversions याद रखो"}$j$),
    (1, 'class_9_10', 'pct-910-example', 'example', 3, 'Board numerical',
     $j${"question":"500 में से 400 अंक। %?","solution":"(400/500) × 100","answer":"80%"}$j$),
    (1, 'class_9_10', 'pct-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"25% को fraction में?","options":["1/2","1/4","1/5","1/10"],"answer":1,"explanation":"25/100 = 1/4"},{"q":"50 का 20%?","options":["5","10","15","20"],"answer":1,"explanation":"50 × 0.2 = 10"}]}$j$),

    (2, 'class_9_10', 'pl-910-concept', 'concept', 1, 'लाभ-हानि — Class 9-10',
     $j${"text":"Cost Price (CP): जिस कीमत पर खरीदा। Selling Price (SP): जिस पर बेचा। SP > CP = profit, SP < CP = loss। Profit% = (profit/CP) × 100। Loss% = (loss/CP) × 100।","note":"Board में profit/loss calculations और CP-SP relations ज़रूरी हैं।"}$j$),
    (2, 'class_9_10', 'pl-910-formula', 'formula', 2, 'लाभ-हानि सूत्र',
     $j${"formula":"Profit = SP - CP · Loss = CP - SP · Profit% = (Profit/CP) × 100 · SP = CP × (100+P)/100","explanation":"Loss% = (Loss/CP) × 100 · CP = SP × 100/(100+P)"}$j$),
    (2, 'class_9_10', 'pl-910-example', 'example', 3, 'Board numerical',
     $j${"question":"CP=₹200, SP=₹250। Profit%?","solution":"Profit = 50, % = 50/200 × 100","answer":"25%"}$j$),
    (2, 'class_9_10', 'pl-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"CP=₹100, SP=₹80। Loss%?","options":["10%","15%","20%","25%"],"answer":2,"explanation":"Loss = 20, % = 20/100 × 100 = 20%"},{"q":"Profit% किस पर?","options":["SP","CP","MP","Discount"],"answer":1,"explanation":"Profit% हमेशा CP पर"}]}$j$),

    (3, 'class_9_10', 'si-910-concept', 'concept', 1, 'ब्याज — Class 9-10',
     $j${"text":"Simple Interest (SI) = P×R×T/100। P = principal, R = rate, T = time। Amount = P + SI। CI basics: interest on interest। SI fixed रहता है, CI बढ़ता जाता है।","note":"Board में SI formula और amount ज़रूरी हैं।"}$j$),
    (3, 'class_9_10', 'si-910-formula', 'formula', 2, 'ब्याज सूत्र',
     $j${"formula":"SI = P×R×T/100 · Amount A = P + SI · CI (2yr) ≈ 2×SI + interest on 1st year SI","explanation":"P = principal, R = rate/year, T = time in years · For CI formula: A = P(1+R/100)^T"}$j$),
    (3, 'class_9_10', 'si-910-example', 'example', 3, 'Board numerical',
     $j${"question":"₹1000, 10%, 2 साल। SI?","solution":"SI = 1000 × 10 × 2 / 100","answer":"₹200 (Amount = ₹1200)"}$j$),
    (3, 'class_9_10', 'si-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"SI formula?","options":["PRT","PRT/100","P/RT","P+R+T"],"answer":1,"explanation":"SI = PRT/100"},{"q":"₹500, 5%, 2 साल SI?","options":["₹25","₹50","₹75","₹100"],"answer":1,"explanation":"500×5×2/100 = 50"}]}$j$),

    (4, 'class_9_10', 'ratio-910-concept', 'concept', 1, 'अनुपात — Class 9-10',
     $j${"text":"Ratio: comparison of two quantities (a:b = a/b)। Proportion: a:b = c:d → ad = bc। Ratio should be in same units। Dividing money in ratio a:b → parts = total/(a+b), shares = part × a, part × b।","note":"Board में ratio simplification और division ज़रूरी हैं।"}$j$),
    (4, 'class_9_10', 'ratio-910-formula', 'formula', 2, 'अनुपात सूत्र',
     $j${"formula":"a:b = a/b · Proportion: a/b = c/d → ad = bc · Divide N in a:b: shares = Na/(a+b), Nb/(a+b)","explanation":"Simplify ratio: HCF से divide करो (e.g., 4:6 = 2:3)"}$j$),
    (4, 'class_9_10', 'ratio-910-example', 'example', 3, 'Board numerical',
     $j${"question":"₹600 को 2:3 में बाँटो।","solution":"Parts = 5, shares = 600×2/5, 600×3/5","answer":"₹240 और ₹360"}$j$),
    (4, 'class_9_10', 'ratio-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"4:6 को simplify?","options":["1:2","2:3","3:4","4:6"],"answer":1,"explanation":"HCF=2 → 2:3"},{"q":"a:b=2:3, b:c=4:5। a:c?","options":["8:15","2:5","3:4","4:5"],"answer":0,"explanation":"a:b:c = 8:12:15 → a:c = 8:15"}]}$j$),

    (5, 'class_9_10', 'avg-910-concept', 'concept', 1, 'औसत — Class 9-10',
     $j${"text":"Average = sum of all values / count। जब एक value जोड़ो या हटाओ, average बदलता है। Average of consecutive numbers = middle value। Average speed = total distance/total time।","note":"Board में average calculation और simple applications ज़रूरी हैं।"}$j$),
    (5, 'class_9_10', 'avg-910-formula', 'formula', 2, 'औसत सूत्र',
     $j${"formula":"Average = Σx/n · Sum = Average × n · Average of 1st n naturals = (n+1)/2","explanation":"Consecutive numbers: average = (first + last)/2 · Add 1 element: new average shifts"}$j$),
    (5, 'class_9_10', 'avg-910-example', 'example', 3, 'Board numerical',
     $j${"question":"5, 10, 15, 20, 25 का average?","solution":"Sum = 75, count = 5","answer":"15"}$j$),
    (5, 'class_9_10', 'avg-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"1-10 का average?","options":["4.5","5","5.5","6"],"answer":2,"explanation":"(1+10)/2 = 5.5"},{"q":"4 numbers का average 10। Sum?","options":["20","30","40","50"],"answer":2,"explanation":"Sum = 10 × 4 = 40"}]}$j$),

    (6, 'class_9_10', 'age-910-concept', 'concept', 1, 'आयु — Class 9-10',
     $j${"text":"Age problems: present, past, future आयु। अगर present age = x, n साल बाद x+n, n साल पहले x-n। Ratio equations बनाओ और solve करो।","note":"Board में simple age equations ज़रूरी हैं।"}$j$),
    (6, 'class_9_10', 'age-910-formula', 'formula', 2, 'आयु सूत्र',
     $j${"formula":"Present = x · Future (n years) = x + n · Past (n years) = x - n","explanation":"Ratio condition: (x+n)/(y+n) = a/b → solve for x,y"}$j$),
    (6, 'class_9_10', 'age-910-example', 'example', 3, 'Board numerical',
     $j${"question":"A 30, B 10। 10 साल बाद उम्र?","solution":"A = 40, B = 20","answer":"A=40, B=20"}$j$),
    (6, 'class_9_10', 'age-910-mcq', 'mcq', 4, 'Board MCQs',
     $j${"questions":[{"q":"B 15, 5 साल पहले कितना?","options":["8","10","12","15"],"answer":1,"explanation":"15-5 = 10"},{"q":"A 20, B 10। A = 2B कब?","solution":"20+n = 2(10+n) → 20+n=20+2n → n=0","options":["अभी","5 साल बाद","10 साल बाद","कभी नहीं"],"answer":0,"explanation":"अभी 20 = 2×10"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], array['class_9', 'class_10']::text[],
  case when s.chapter_id < 20 then 'maths' else 'general-science' end,
  'easy', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, count(*) from mtb.atoms 
-- where chapter_id in (907,908,909,910,911,912,913,914,915,916,917,918,920,1,2,3,4,5,6) 
--   and level_id='class_9_10' and status='published' and not archived 
-- group by 1 order by 1;
-- Expected: each chapter = 4

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: 1379 + 80 = 1459