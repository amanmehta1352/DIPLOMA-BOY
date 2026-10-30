with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ DEFENCE PHYSICS (880-883) ═══
    (880, 'govt_defence', 'elec-def-concept', 'concept', 1, 'विद्युत — NDA/CDS',
     $j${"text":"Defence electricity: military radios (VHF/UHF), radar power, batteries (Li-ion, lead-acid), field generators, EMP (electromagnetic pulse from nuclear blast), electrical circuits in vehicles/aircraft। Ohm's law: V=IR. Power P=VI=I²R=V²/R।","note":"Defence में military batteries, EMP, और radio circuits ज़रूरी हैं।"}$j$),
    (880, 'govt_defence', 'elec-def-formula', 'formula', 2, 'विद्युत सूत्र',
     $j${"formula":"V = IR · P = VI = I²R = V²/R · Series: R = R₁+R₂ · Parallel: 1/R = 1/R₁+1/R₂","explanation":"Li-ion cell 3.7V, lead-acid 2V · EMP: nuclear blast → high E-field → destroys electronics"}$j$),
    (880, 'govt_defence', 'elec-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Radio 12V, 2A। Power?","solution":"P = 12 × 2","answer":"24 W"}$j$),
    (880, 'govt_defence', 'elec-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"EMP से क्या होता है?","options":["Sound","Electronic damage","Light","Heat only"],"answer":1,"explanation":"EMP destroys electronics (high E-field)"},{"q":"Ohm's law?","options":["V=IR","V=I/R","V=R/I","V=I+R"],"answer":0,"explanation":"V = IR"}]}$j$),

    (881, 'govt_defence', 'mag-def-concept', 'concept', 1, 'चुंबकत्व — NDA/CDS',
     $j${"text":"Defence magnetism: magnetic compass, degaussing (ship protection from magnetic mines), mines detection (magnetic anomaly), MRI (medical), radar magnetron। Earth's field ~50 μT. Electromagnetic pulse (EMP). Faraday's law: changing B → EMF।","note":"Defence में magnetic mines, degaussing, और radar magnetron ज़रूरी हैं।"}$j$),
    (881, 'govt_defence', 'mag-def-formula', 'formula', 2, 'चुंबकत्व सूत्र',
     $j${"formula":"F = qvBsinθ · B = μ₀I/2πr · Faraday: EMF = -dΦ/dt","explanation":"Degaussing: ship coils → cancel magnetic signature · Earth's field ≈ 50 μT · Radar magnetron: ~GHz output"}$j$),
    (881, 'govt_defence', 'mag-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Ship degaussing का उद्देश्य?","solution":"Cancel magnetic signature to avoid magnetic mines","answer":"Anti-mine protection (magnetic)"}$j$),
    (881, 'govt_defence', 'mag-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Degaussing क्या करता है?","options":["Increases magnetism","Cancels magnetic signature","Amplifies radar","Heats ship"],"answer":1,"explanation":"Cancels ship's magnetic field"},{"q":"Faraday law?","options":["EMF = -dΦ/dt","EMF = Φ/t","EMF = Φ×t","EMF = Φ+t"],"answer":0,"explanation":"EMF = -dΦ/dt (rate of flux change)"}]}$j$),

    (882, 'govt_defence', 'modern-def-concept', 'concept', 1, 'आधुनिक भौतिकी — NDA/CDS',
     $j${"text":"Defence modern physics: nuclear weapons (fission U-235/Pu-239, fusion D+T), radiation detection (Geiger, scintillation), X-rays (security scanning), radioisotopes, laser (range finder, targeting)। E=mc². Half-life. Radiation protection: distance, shielding, time।","note":"Defence में nuclear weapons, radiation detection, और laser ज़रूरी हैं।"}$j$),
    (882, 'govt_defence', 'modern-def-formula', 'formula', 2, 'आधुनिक भौतिकी सूत्र',
     $j${"formula":"E = mc² · Fission: ²³⁵U + n → Ba + Kr + 3n + 200 MeV · N = N₀(1/2)^(t/t½)","explanation":"Laser: hf, coherent · Radiation units: Gy (absorbed), Sv (equivalent), Bq (activity)"}$j$),
    (882, 'govt_defence', 'modern-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"1 kg U-235 fission energy?","solution":"~8×10¹³ J/kg (vs 4.2×10⁷ J/kg TNT)","answer":"≈ 8×10¹³ J"}$j$),
    (882, 'govt_defence', 'modern-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Fission में energy source?","options":["Chemical","Mass defect (E=mc²)","Gravity","Elastic"],"answer":1,"explanation":"Mass defect → E=mc²"},{"q":"Radiation dose unit?","options":["Bq","Gy","N","J"],"answer":1,"explanation":"Gy (Gray, absorbed dose)"}]}$j$),

    (883, 'govt_defence', 'mach-def-concept', 'concept', 1, 'मशीनें — NDA/CDS',
     $j${"text":"Defence machines: pulleys (lifting equipment), levers (catapult, weapon mechanisms), inclined planes (ramps in transport), gears (vehicle transmission), wheel-axle (vehicle suspension)। MA = Load/Effort। Efficiency = MA/VR। Reversible/irreversible।","note":"Defence में lifting equipment, gears, और vehicle mechanisms ज़रूरी हैं।"}$j$),
    (883, 'govt_defence', 'mach-def-formula', 'formula', 2, 'मशीन सूत्र',
     $j${"formula":"MA = Load/Effort · VR = effort distance/load distance · η = MA/VR × 100%","explanation":"Ideal: MA=VR (η=100%) · Gear ratio: N_driven/N_driver · Pulley n: MA = n"}$j$),
    (883, 'govt_defence', 'mach-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Crane lifts 500 kg with 100 kg effort। MA?","solution":"MA = 500/100","answer":"5"}$j$),
    (883, 'govt_defence', 'mach-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"MA का formula?","options":["Load/Effort","Effort/Load","Load×Effort","Load+Effort"],"answer":0,"explanation":"MA = Load/Effort"},{"q":"Efficiency?","options":["MA×VR","MA/VR","VR/MA","MA+VR"],"answer":1,"explanation":"η = MA/VR × 100%"}]}$j$),

    -- ═══ DEFENCE REASONING (426-429, 431) ═══
    (426, 'govt_defence', 'code-def-concept', 'concept', 1, 'कूट-लेखन — NDA/CDS',
     $j${"text":"Defence coding: military codes (NATO alphabet, Morse, ciphers), encrypted messages, Caesar cipher (+n shift), Vigenère, binary। Letters to positions (A=1). Simple substitution।","note":"Defence में military codes, ciphers, और NATO alphabet ज़रूरी हैं।"}$j$),
    (426, 'govt_defence', 'code-def-formula', 'formula', 2, 'Coding सूत्र',
     $j${"formula":"Caesar: A+n → letter · NATO: A=Alpha, B=Bravo... · Morse: dots and dashes","explanation":"Reverse: A↔Z (sum=27) · Position: A=1, B=2 ... Z=26"}$j$),
    (426, 'govt_defence', 'code-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"Caesar +3: 'CAT' → ?","solution":"C→F, A→D, T→W","answer":"FDW"}$j$),
    (426, 'govt_defence', 'code-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"NATO for 'A'?","options":["Alpha","Apple","Able","Ace"],"answer":0,"explanation":"A = Alpha"},{"q":"Caesar +1: 'Z' → ?","options":["A","B","Y","Z"],"answer":0,"explanation":"Z+1 wraps to A"}]}$j$),

    (427, 'govt_defence', 'dir-def-concept', 'concept', 1, 'दिशा ज्ञान — NDA/CDS',
     $j${"text":"Defence directions: map navigation, bearings (from North clockwise), compass reading, patrol routes. Right turn (clockwise), left turn (anti). Distance with bearing: use Pythagoras।","note":"Defence में bearings और map navigation ज़रूरी हैं।"}$j$),
    (427, 'govt_defence', 'dir-def-formula', 'formula', 2, 'दिशा सूत्र',
     $j${"formula":"Right: N→E→S→W · Left: N→W→S→E · Bearing: 0° (N) to 360° (N) · Distance = √(x²+y²)","explanation":"Bearing 090° = East · 180° = South · 270° = West"}$j$),
    (427, 'govt_defence', 'dir-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"3km N, 4km E। Bearing + distance?","solution":"√(9+16) = 5 km; angle from N = arctan(4/3) ≈ 53°","answer":"5 km, bearing 053°"}$j$),
    (427, 'govt_defence', 'dir-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"Bearing 090°?","options":["N","E","S","W"],"answer":1,"explanation":"090° = East"},{"q":"N→2 right turns?","options":["N","E","S","W"],"answer":2,"explanation":"N→E→S"}]}$j$),

    (428, 'govt_defence', 'op-def-concept', 'concept', 1, 'संक्रियाएँ — NDA/CDS',
     $j${"text":"Symbol replacement: military codes use symbol substitution. Apply new meaning, then BODMAS. Defense: coded transmissions।","note":"Defence में symbol decoding और BODMAS ज़रूरी हैं।"}$j$),
    (428, 'govt_defence', 'op-def-formula', 'formula', 2, 'संक्रिया सूत्र',
     $j${"formula":"Replace symbol meaning, then BODMAS · + → × means 4+3 = 12","explanation":"Order: bracket → order → ÷ → × → + → −"}$j$),
    (428, 'govt_defence', 'op-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"+ = ×, तो 6+7?","solution":"6×7","answer":"42"}$j$),
    (428, 'govt_defence', 'op-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"− = +, तो 9−4?","options":["5","13","36","0"],"answer":1,"explanation":"9+4 = 13"},{"q":"× = −, तो 8×3?","options":["24","5","11","0"],"answer":1,"explanation":"8-3 = 5"}]}$j$),

    (429, 'govt_defence', 'seat-def-concept', 'concept', 1, 'बैठक व्यवस्था — NDA/CDS',
     $j${"text":"Seating: military briefing layout, strategic positioning. Linear (row), circular (facing center/outside). Between = |pos1-pos2|-1. Fixed positions first।","note":"Defence में strategic positioning और arrangement ज़रूरी हैं।"}$j$),
    (429, 'govt_defence', 'seat-def-formula', 'formula', 2, 'Arrangement सूत्र',
     $j${"formula":"Between = |pos1 - pos2| - 1 · Circular (N): (N-1)! · Facing center: left=clockwise","explanation":"Linear: left-right from observer · Facing outside: left=anti-clockwise"}$j$),
    (429, 'govt_defence', 'seat-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"6 persons row। A 2nd left, B 5th left। Between?","solution":"|5-2|-1 = 2","answer":"2"}$j$),
    (429, 'govt_defence', 'seat-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"5 persons row। A 1st, B 5th। Between?","options":["2","3","4","5"],"answer":1,"explanation":"|5-1|-1 = 3"},{"q":"Circular 4 people arrangements?","options":["4!","3!","4²","4"],"answer":1,"explanation":"(N-1)! = 3!"}]}$j$),

    (431, 'govt_defence', 'syl-def-concept', 'concept', 1, 'न्याय निगमन — NDA/CDS',
     $j${"text":"Syllogism: Venn diagram method. All A are B (A⊂B), Some (overlap), No (disjoint). Valid only if true in all cases. Defense: intelligence analysis logic।","note":"Defence में logic और Venn method ज़रूरी हैं।"}$j$),
    (431, 'govt_defence', 'syl-def-formula', 'formula', 2, 'Syllogism सूत्र',
     $j${"formula":"All A are B + All B are C → All A are C · No A is B + All B are C → No A is C","explanation":"'Some' includes 'All' (logical) · Converse: All A are B → Some B are A"}$j$),
    (431, 'govt_defence', 'syl-def-example', 'example', 3, 'Defence numerical',
     $j${"question":"All missiles are weapons। Some weapons are tanks। Conclusion?","solution":"'Some missiles are tanks' not valid","answer":"Cannot determine"}$j$),
    (431, 'govt_defence', 'syl-def-mcq', 'mcq', 4, 'Defence MCQs',
     $j${"questions":[{"q":"All A are B। Some B are A?","options":["Valid","Invalid","Cannot determine","None"],"answer":0,"explanation":"Valid converse"},{"q":"No X is Y। No Y is X?","options":["Valid","Invalid","Cannot determine","Both"],"answer":0,"explanation":"Symmetric (No A is B → No B is A)"}]}$j$),

    -- ═══ STATE_PSC GA (8 chapters) ═══
    (415, 'state_psc', 'comp-psc-concept', 'concept', 1, 'कंप्यूटर — State PSC',
     $j${"text":"State PSC computers: e-governance, digital India, CSC (Common Service Centres), computer basics (hardware, software, memory), MS Office, internet, cybersecurity। Government schemes: Digital India (2015), Aadhaar, DBT (Direct Benefit Transfer)।","note":"State PSC में e-governance, Digital India, और schemes ज़रूरी हैं।"}$j$),
    (415, 'state_psc', 'comp-psc-formula', 'formula', 2, 'कंप्यूटर तथ्य',
     $j${"formula":"1 KB = 1024 bytes · 1 MB = 1024 KB · 1 GB = 1024 MB · 1 TB = 1024 GB","explanation":"Digital India: 2015 · DBT: subsidy direct to bank · CSC: rural internet access"}$j$),
    (415, 'state_psc', 'comp-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Digital India launch year?","solution":"2015","answer":"2015"}$j$),
    (415, 'state_psc', 'comp-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Digital India कब शुरू?","options":["2014","2015","2016","2017"],"answer":1,"explanation":"2015"},{"q":"CPU का function?","options":["Storage","Processing","Display","Network"],"answer":1,"explanation":"Processing (brain)"}]}$j$),

    (417, 'state_psc', 'eco-psc-concept', 'concept', 1, 'अर्थव्यवस्था — State PSC',
     $j${"text":"State economy: state GDP, budget, agriculture, industry, services। RBI monetary policy (repo, CRR, SLR), inflation, fiscal deficit। Central schemes (MGNREGA, PM-KISAN, Ayushman Bharat)। State-specific schemes। GST (2017)।","note":"State PSC में state economy, schemes, और GST ज़रूरी हैं।"}$j$),
    (417, 'state_psc', 'eco-psc-formula', 'formula', 2, 'अर्थव्यवस्था तथ्य',
     $j${"formula":"GDP = C+I+G+(X-M) · GST: 2017 (one nation one tax) · Repo: RBI lends to banks","explanation":"MGNREGA: 2005 (rural employment) · PM-KISAN: farmer income support · Ayushman Bharat: health insurance"}$j$),
    (417, 'state_psc', 'eco-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"GST कब लागू?","solution":"1 July 2017","answer":"2017"}$j$),
    (417, 'state_psc', 'eco-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"GST year?","options":["2015","2016","2017","2018"],"answer":2,"explanation":"2017 (1 July)"},{"q":"Repo rate?","options":["Bank→RBI","RBI→Bank","Both","None"],"answer":1,"explanation":"RBI lends to banks"}]}$j$),

    (418, 'state_psc', 'geo-psc-concept', 'concept', 1, 'भूगोल — State PSC',
     $j${"text":"State geography: state boundaries, rivers (major rivers originate/flow), mountains, climate zones, soils (alluvial, black, red, laterite), agriculture, minerals। India's states and capitals. Coastline, forests, wildlife sanctuaries।","note":"State PSC में rivers, soils, और state boundaries ज़रूरी हैं।"}$j$),
    (418, 'state_psc', 'geo-psc-formula', 'formula', 2, 'भूगोल तथ्य',
     $j${"formula":"Soils: alluvial (fertile, plains), black (cotton, Deccan), red (iron), laterite (leached)","explanation":"India: 28 states, 8 UTs · Longest river: Ganga (India) · Largest state: Rajasthan · Smallest: Goa"}$j$),
    (418, 'state_psc', 'geo-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Black soil किस फसल के लिए?","solution":"Cotton (Deccan)","answer":"Cotton"}$j$),
    (418, 'state_psc', 'geo-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Alluvial soil कहाँ?","options":["Deccan","Plains","Hills","Coast"],"answer":1,"explanation":"Plains (fertile, river-deposited)"},{"q":"Largest state (area)?","options":["MP","UP","Rajasthan","Maharashtra"],"answer":2,"explanation":"Rajasthan (area)"}]}$j$),

    (419, 'state_psc', 'hist-psc-concept', 'concept', 1, 'इतिहास — State PSC',
     $j${"text":"State history: ancient (Maurya, Gupta), medieval (Delhi Sultanate, Mughal), British colonial, freedom struggle (1857, Gandhi movements, 1947)। State-specific: local dynasties, regional movements। Monuments and heritage।","note":"State PSC में freedom struggle, local dynasties, और monuments ज़रूरी हैं।"}$j$),
    (419, 'state_psc', 'hist-psc-formula', 'formula', 2, 'इतिहास तथ्य',
     $j${"formula":"1857: first war of independence · 1885: INC founded · 1942: Quit India · 1947: Independence","explanation":"Gandhi movements: Non-cooperation (1920), Civil Disobedience (1930), Quit India (1942)"}$j$),
    (419, 'state_psc', 'hist-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"INC founded year?","solution":"1885","answer":"1885"}$j$),
    (419, 'state_psc', 'hist-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"1857 revolt?","options":["First war of independence","Freedom","Quit India","Dandi"],"answer":0,"explanation":"1857 = first war of independence"},{"q":"Quit India year?","options":["1930","1935","1942","1947"],"answer":2,"explanation":"1942"}]}$j$),

    (421, 'state_psc', 'pol-psc-concept', 'concept', 1, 'राजव्यवस्था — State PSC',
     $j${"text":"State polity: Constitution (1950), federal structure (Union + State + Local)। Governor (state head, appointed by President), Chief Minister (real power), State Legislature (Vidhan Sabha + Vidhan Parishad)। Panchayati Raj (73rd Amendment, 1992), Municipalities (74th)। Fundamental Rights (Part III), DPSP (Part IV)।","note":"State PSC में Constitution, Governor, और Panchayati Raj ज़रूरी हैं।"}$j$),
    (421, 'state_psc', 'pol-psc-formula', 'formula', 2, 'राजव्यवस्था तथ्य',
     $j${"formula":"Constitution: 26 Jan 1950 · 73rd Amendment: Panchayati Raj (1992) · 74th: Municipalities (1992)","explanation":"Governor: appointed by President, 5-year term · CM: real executive power · Vidhan Sabha: lower house (state)"}$j$),
    (421, 'state_psc', 'pol-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Panchayati Raj amendment?","solution":"73rd (1992)","answer":"73rd Amendment, 1992"}$j$),
    (421, 'state_psc', 'pol-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Governor कौन नियुक्त करता है?","options":["CM","President","PM","Parliament"],"answer":1,"explanation":"President appoints Governor"},{"q":"73rd Amendment?","options":["Municipalities","Panchayati Raj","GST","Reservation"],"answer":1,"explanation":"Panchayati Raj (rural local govt)"}]}$j$),

    (422, 'state_psc', 'sgk-psc-concept', 'concept', 1, 'स्थिर GK — State PSC',
     $j${"text":"Static GK: national symbols (bird=peacock, animal=tiger, flower=lotus, tree=banyan, fruit=mango, sport=hockey), important days (26 Jan, 15 Aug, 2 Oct), Indian culture, festivals, awards (Bharat Ratna, Padma, Param Vir Chakra)।","note":"State PSC में national symbols, days, और awards ज़रूरी हैं।"}$j$),
    (422, 'state_psc', 'sgk-psc-formula', 'formula', 2, 'स्थिर तथ्य',
     $j${"formula":"National: bird=मोर, animal=बाघ, flower=कमल, tree=बरगद, fruit=आम, sport=हॉकी","explanation":"Bharat Ratna (highest civilian), Padma Vibhushan, Padma Bhushan, Padma Shri"}$j$),
    (422, 'state_psc', 'sgk-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Highest civilian award?","solution":"Bharat Ratna","answer":"Bharat Ratna"}$j$),
    (422, 'state_psc', 'sgk-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"National bird?","options":["Parrot","Peacock","Sparrow","Eagle"],"answer":1,"explanation":"Peacock (मोर)"},{"q":"Highest civilian award?","options":["Padma Shri","Padma Bhushan","Padma Vibhushan","Bharat Ratna"],"answer":3,"explanation":"Bharat Ratna"}]}$j$),

    (38, 'state_psc', 'cult-psc-concept', 'concept', 1, 'कला-संस्कृति — State PSC',
     $j${"text":"Indian art & culture: classical dances (8), music (Hindustani, Carnatic), monuments (Taj Mahal, Qutub Minar, Konark), paintings (Madhubani, Warli, Pattachitra), festivals, UNESCO sites। State-specific culture।","note":"State PSC में dances, monuments, और UNESCO sites ज़रूरी हैं।"}$j$),
    (38, 'state_psc', 'cult-psc-formula', 'formula', 2, 'कला-संस्कृति तथ्य',
     $j${"formula":"Bharatnatyam-TN, Kathak-UP, Kathakali-Kerala, Kuchipudi-AP, Odissi-Odisha, Manipuri, Mohiniyattam, Sattriya","explanation":"UNESCO: Taj Mahal, Qutub Minar, Red Fort, Ajanta, Ellora, Konark, Hampi"}$j$),
    (38, 'state_psc', 'cult-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Madhubani painting कहाँ से?","solution":"Bihar (Mithila region)","answer":"Bihar"}$j$),
    (38, 'state_psc', 'cult-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Kathak dance किस state?","options":["TN","UP","Kerala","Odisha"],"answer":1,"explanation":"Kathak = UP"},{"q":"Madhubani painting?","options":["Bihar","UP","Kerala","TN"],"answer":0,"explanation":"Bihar (Mithila)"}]}$j$),

    (40, 'state_psc', 'scitech-psc-concept', 'concept', 1, 'विज्ञान-प्रौद्योगिकी — State PSC',
     $j${"text":"Science & tech for state exams: ISRO missions (Chandrayaan, Mangalyaan, Aditya-L1), DRDO missiles (Agni, Prithvi, BrahMos), nuclear (Kudankulam, Tarapur), IT (Digital India, Aadhaar), biotech (vaccines, genomics)। Nobel laureates।","note":"State PSC में ISRO, DRDO, और IT schemes ज़रूरी हैं।"}$j$),
    (40, 'state_psc', 'scitech-psc-formula', 'formula', 2, 'विज्ञान तथ्य',
     $j${"formula":"ISRO: Chandrayaan (moon), Mangalyaan (Mars), Aditya-L1 (sun) · DRDO: Agni, Prithvi, BrahMos","explanation":"Nuclear plants: Kudankulam (TN), Tarapur (MH), Rawatbhata (RJ), Kaiga (KA)"}$j$),
    (40, 'state_psc', 'scitech-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"India's Mars mission name?","solution":"Mangalyaan (Mars Orbiter Mission, 2013)","answer":"Mangalyaan"}$j$),
    (40, 'state_psc', 'scitech-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Mars mission?","options":["Chandrayaan","Mangalyaan","Aditya","Gaganyaan"],"answer":1,"explanation":"Mangalyaan (MOM)"},{"q":"BrahMos किस type?","options":["Ballistic","Cruise","SAM","Anti-tank"],"answer":1,"explanation":"Supersonic cruise"}]}$j$),

    -- ═══ STATE_PSC GS (870, 871, 872 start) ═══
    (870, 'state_psc', 'phy-meas-psc-concept', 'concept', 1, 'मापन — State PSC',
     $j${"text":"Measurement: SI units (7 base), derived units, dimensional formula. Significant figures. Errors (absolute, relative, percentage)। Instrument precision: vernier (0.1 mm), screw gauge (0.01 mm)। State PSC में dimensional analysis और units।","note":"State PSC में SI units और dimensional formula ज़रूरी हैं।"}$j$),
    (870, 'state_psc', 'phy-meas-psc-formula', 'formula', 2, 'मापन सूत्र',
     $j${"formula":"[Force] = MLT⁻² · [Energy] = ML²T⁻² · [Pressure] = ML⁻¹T⁻² · 1 N = 10⁵ dyne","explanation":"SI base: m, kg, s, A, K, mol, cd · 1 kgf = 9.8 N"}$j$),
    (870, 'state_psc', 'phy-meas-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"Force का dimension?","solution":"F=ma → MLT⁻²","answer":"MLT⁻²"}$j$),
    (870, 'state_psc', 'phy-meas-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Force SI unit?","options":["kg","m/s","N","J"],"answer":2,"explanation":"Newton (N)"},{"q":"1 N = ? dyne","options":["10³","10⁵","10⁷","10"],"answer":1,"explanation":"1 N = 10⁵ dyne"}]}$j$),

    (871, 'state_psc', 'phy-motion-psc-concept', 'concept', 1, 'गति — State PSC',
     $j${"text":"Motion: speed, velocity, acceleration. Equations: v=u+at, s=ut+½at², v²=u²+2as. Graph (x-t, v-t)। Average speed vs average velocity. Circular motion basics (angular velocity)। Projectile basics।","note":"State PSC में motion equations और graphs ज़रूरी हैं।"}$j$),
    (871, 'state_psc', 'phy-motion-psc-formula', 'formula', 2, 'गति सूत्र',
     $j${"formula":"v = u+at · s = ut+½at² · v² = u²+2as · Avg speed = total d/total t","explanation":"Graph: x-t slope = v, v-t slope = a, v-t area = s · 1 km/h = 5/18 m/s"}$j$),
    (871, 'state_psc', 'phy-motion-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"u=0, a=2 m/s², t=5s। v?","solution":"v = 0 + 2×5","answer":"10 m/s"}$j$),
    (871, 'state_psc', 'phy-motion-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"v-t graph area?","options":["a","v","Displacement","Jerk"],"answer":2,"explanation":"Area = displacement"},{"q":"36 km/h in m/s?","options":["5","10","12","15"],"answer":1,"explanation":"36 × 5/18 = 10"}]}$j$),

    (872, 'state_psc', 'phy-force-psc-concept', 'concept', 1, 'बल — State PSC',
     $j${"text":"Newton's laws, momentum (p=mv), impulse (F·t = Δp)। Conservation of momentum. Friction (static, kinetic)। Circular motion (centripetal F = mv²/r)। Applications: seat belts (impulse), rockets (momentum)।","note":"State PSC में Newton's laws, momentum, और circular motion ज़रूरी हैं।"}$j$),
    (872, 'state_psc', 'phy-force-psc-formula', 'formula', 2, 'बल सूत्र',
     $j${"formula":"F = ma · p = mv · Impulse = F·t = Δp · Centripetal F = mv²/r","explanation":"Momentum conserved: m₁v₁ + m₂v₂ = const · Friction: f ≤ μN"}$j$),
    (872, 'state_psc', 'phy-force-psc-example', 'example', 3, 'State PSC numerical',
     $j${"question":"5 kg at 10 m/s। Momentum?","solution":"p = 5 × 10","answer":"50 kg·m/s"}$j$),
    (872, 'state_psc', 'phy-force-psc-mcq', 'mcq', 4, 'State PSC MCQs',
     $j${"questions":[{"q":"Momentum unit?","options":["kg·m/s","N","J","kg"],"answer":0,"explanation":"kg·m/s (= N·s)"},{"q":"Centripetal force?","options":["mv²/r","mv/r","mr/v","mvr"],"answer":0,"explanation":"F = mv²/r"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[],
  case when s.chapter_id < 20 then 'maths' 
       when s.chapter_id >= 400 and s.chapter_id < 500 then 'reasoning' 
       when s.chapter_id >= 415 and s.chapter_id < 425 then 'general-awareness' 
       when s.chapter_id < 100 then 'general-awareness' 
       else 'general-science' end,
  'medium', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select level_id, count(*) from mtb.atoms 
-- where chapter_id in (880,881,882,883,426,427,428,429,431,415,417,418,419,421,422,38,40,870,871,872) 
--   and status='published' and not archived 
--   and level_id in ('govt_defence','state_psc')
-- group by level_id;
-- Expected: govt_defence=36 (9 chapters × 4), state_psc ≈ 44 (11 chapters × 4, minus any pre-existing conflicts at 421)

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: 2248 + ~80 = ~2328
