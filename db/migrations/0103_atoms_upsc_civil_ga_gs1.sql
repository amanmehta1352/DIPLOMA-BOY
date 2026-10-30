with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ UPSC GA (8 chapters) ═══
    (415, 'upsc_civil', 'comp-upsc-concept', 'concept', 1, 'कंप्यूटर — UPSC CSE',
     $j${"text":"UPSC computer awareness: e-governance (Digital India 2015, DBT, Aadhaar, UPI), cybersecurity (NCIIPC, CERT-In), AI policy, data protection bill, digital divide, MeitY functions। Cyber attacks: malware, phishing, ransomware, state-sponsored। Emerging: quantum computing, blockchain for land records।","note":"UPSC में policy angle और social impact पूछते हैं — केवल technical facts नहीं।"}$j$),
    (415, 'upsc_civil', 'comp-upsc-formula', 'formula', 2, 'कंप्यूटर governance framework',
     $j${"formula":"Digital India (2015): broadband, e-gov, digital literacy · DBT: 40+ schemes · UPI: NPCI · Data Protection: DPDP Act 2023","explanation":"CERT-In: cyber incidents · NCIIPC: critical infrastructure · IT Act 2000 (amended 2008)"}$j$),
    (415, 'upsc_civil', 'comp-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Digital divide address करने के लिए government schemes?","solution":"BharatNet (rural broadband), CSC (Common Service Centres), PMGDISHA (digital literacy)","answer":"BharatNet + CSC + PMGDISHA"}$j$),
    (415, 'upsc_civil', 'comp-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"DPDP Act (Data Protection) किस वर्ष?","options":["2019","2021","2023","2024"],"answer":2,"explanation":"Digital Personal Data Protection Act 2023"},{"q":"Critical infrastructure cyber security agency?","options":["NIA","NCIIPC","CBI","RAW"],"answer":1,"explanation":"NCIIPC (under NTRO)"}]}$j$),

    (417, 'upsc_civil', 'eco-upsc-concept', 'concept', 1, 'अर्थव्यवस्था — UPSC CSE',
     $j${"text":"UPSC economy: GDP/GNP, fiscal deficit (target 3.5% FRBM), monetary policy (repo, CRR, SLR, MSF), inflation types (demand-pull, cost-push, imported), Balance of Payments (current + capital account), FDI vs FPI, GST (2017, one nation one tax), disinvestment, PLI schemes, RBI functions (money supply, bank regulation, forex)۔","note":"UPSC में cause-effect और policy analysis पूछते हैं — formula-based questions कम।"}$j$),
    (417, 'upsc_civil', 'eco-upsc-formula', 'formula', 2, 'अर्थव्यवस्था framework',
     $j${"formula":"Fiscal deficit = Total expenditure - Total receipts (excluding borrowings) · Repo: RBI lends · Reverse repo: RBI borrows","explanation":"FRBM Act 2003: deficit targets · Inflation: WPI (wholesale) vs CPI (retail, consumer)"}$j$),
    (417, 'upsc_civil', 'eco-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"महंगाई बढ़ने पर RBI क्या करता है?","solution":"Inflation ↑ → RBI ↑ repo rate → loans costly → demand ↓ → inflation ↓","answer":"Contractionary policy (repo ↑)"}$j$),
    (417, 'upsc_civil', 'eco-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Fiscal deficit में शामिल नहीं?","options":["Revenue exp","Capital exp","Borrowings","Interest"],"answer":2,"explanation":"Borrowings deficit finance करती हैं, deficit में नहीं"},{"q":"GST लागू?","options":["1 Apr 2017","1 Jul 2017","1 Apr 2018","1 Jul 2018"],"answer":1,"explanation":"1 July 2017"}]}$j$),

    (418, 'upsc_civil', 'geo2-upsc-concept', 'concept', 1, 'भूगोल — UPSC CSE',
     $j${"text":"UPSC geography: physical (monsoon, Himalayan orography, ocean currents, climate zones), Indian geography (rivers, soil types, agro-climatic zones, mineral belts), human (population distribution, urbanisation, migration)। Climate change: glaciers retreat, sea-level rise, monsoon variability। Disaster vulnerability: cyclone (east coast), earthquake (Himalaya, zone 4-5), flood, drought।","note":"UPSC में map-based और cause-effect geography पूछते हैं।"}$j$),
    (418, 'upsc_civil', 'geo2-upsc-formula', 'formula', 2, 'भूगोल framework',
     $j${"formula":"Monsoon: SW (Jun-Sep) + NE (Oct-Dec) · Soils: alluvial (plains), black (Deccan), red, laterite · Seismic zones: 2 (low), 3, 4, 5 (highest)","explanation":"Cyclone: Bay of Bengal > Arabian Sea · Retreating monsoon: Tamil Nadu rainfall"}$j$),
    (418, 'upsc_civil', 'geo2-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Himalaya climate पर प्रभाव?","solution":"Barrier → monsoon (rain on south, dry Tibet), temperature drop, glacier source","answer":"Orographic barrier (monsoon + temp)"}$j$),
    (418, 'upsc_civil', 'geo2-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Highest seismic zone?","options":["2","3","4","5"],"answer":3,"explanation":"Zone 5 (highest, e.g. NE India, Kutch)"},{"q":"Black soil main crop?","options":["Rice","Wheat","Cotton","Tea"],"answer":2,"explanation":"Cotton (regur soil)"}]}$j$),

    (419, 'upsc_civil', 'hist-upsc-concept', 'concept', 1, 'इतिहास — UPSC CSE',
     $j${"text":"UPSC history: ancient (Indus, Vedic, Maurya, Gupta — art, culture, administration), medieval (Delhi Sultanate, Vijayanagara, Mughal — syncretism), modern (1857, INC 1885, Gandhi era, independence 1947)। Art & architecture evolution (temple styles: Nagara, Dravida, Vesara)। Freedom struggle phases: moderate, extremist, Gandhian।","note":"UPSC में source-based (inscriptions, coins) और historiographical angles पूछते हैं।"}$j$),
    (419, 'upsc_civil', 'hist-upsc-formula', 'formula', 2, 'इतिहास framework',
     $j${"formula":"Temple styles: Nagara (North, curvilinear), Dravida (South, gopuram), Vesara (hybrid) · Freedom: 1857→1885→1920→1930→1942→1947","explanation":"Maurya: Arthashastra (Kautilya) · Gupta: golden age (Kalidasa, Aryabhata) · Chola: bronze sculpture"}$j$),
    (419, 'upsc_civil', 'hist-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Gandhi के असहयोग आंदोलन का significance?","solution":"Mass movement started (1920) — Hindu-Muslim unity, swadeshi, non-cooperation","answer":"First mass movement (1920)"}$j$),
    (419, 'upsc_civil', 'hist-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Nagara temple style?","options":["North India","South India","Deccan","East"],"answer":0,"explanation":"Nagara = North (curvilinear shikhara)"},{"q":"INC founded?","options":["1885","1857","1905","1919"],"answer":0,"explanation":"1885 (A.O. Hume)"}]}$j$),

    (421, 'upsc_civil', 'pol-upsc-concept', 'concept', 1, 'राजव्यवस्था — UPSC CSE',
     $j${"text":"UPSC polity: Constitution (26 Jan 1950), Preamble (sovereign, socialist, secular, democratic, republic), Fundamental Rights (Part III, Art 12-35), DPSP (Part IV, 36-51), Fundamental Duties (Part IVA, 51A)। Federal structure: Union + State + Local, Centre-State relations (legislative, administrative, financial)। Parliament: LS + RS. President, PM, Council of Ministers। Judiciary: SC (Art 32), HC, district. Emergency (352, 356, 360)। Amendments: simple, special, ratification.","note":"UPSC में Articles और case laws दोनों पूछते हैं।"}$j$),
    (421, 'upsc_civil', 'pol-upsc-formula', 'formula', 2, 'राजव्यवस्था framework',
     $j${"formula":"Fundamental Rights: Art 12-35 (Part III) · DPSP: Art 36-51 (Part IV) · Fundamental Duties: Art 51A (Part IVA, 42nd Amendment 1976)","explanation":"Emergency: 352 (national), 356 (state), 360 (financial) · Amendment: Art 368"}$j$),
    (421, 'upsc_civil', 'pol-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Art 32 को 'heart and soul' किसने कहा?","solution":"Dr. Ambedkar (constitutional remedies)","answer":"Dr. B.R. Ambedkar"}$j$),
    (421, 'upsc_civil', 'pol-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Fundamental Duties कौन से amendment?","options":["42nd (1976)","44th (1978)","52nd (1985)","73rd (1992)"],"answer":0,"explanation":"42nd Amendment 1976"},{"q":"Art 356?","options":["National emergency","State emergency","Financial emergency","Fundamental rights"],"answer":1,"explanation":"Art 356 = President's rule (state emergency)"}]}$j$),

    (422, 'upsc_civil', 'sgk-upsc-concept', 'concept', 1, 'स्थिर GK — UPSC CSE',
     $j${"text":"UPSC static GK: national symbols (bird=peacock, animal=tiger, flower=lotus, tree=banyan, fruit=mango, sport=hockey), important days (26 Jan, 15 Aug, 2 Oct, 5 Sep), awards (Bharat Ratna, Padma, gallantry awards), institutions (RBI, SEBI, NITI Aayog, CAG, UPSC, Election Commission), international organisations (UN, WTO, IMF, World Bank, BRICS, G20)।","note":"UPSC में awards/days के साथ context और recent events जोड़ते हैं।"}$j$),
    (422, 'upsc_civil', 'sgk-upsc-formula', 'formula', 2, 'स्थिर GK framework',
     $j${"formula":"National: bird=मोर, animal=बाघ, flower=कमल, tree=बरगद, sport=हॉकी · Awards: Bharat Ratna (highest civilian), PVC (highest military)","explanation":"Institutions: RBI (1935), SEBI (1988/1992), NITI Aayog (2015), CAG (Art 148)"}$j$),
    (422, 'upsc_civil', 'sgk-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"NITI Aayog vs Planning Commission?","solution":"NITI: think tank (2015), cooperative federalism; PC: centralized planning (1950-2014)","answer":"NITI = advisory, PC = directive"}$j$),
    (422, 'upsc_civil', 'sgk-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"NITI Aayog कब स्थापित?","options":["2014","2015","2016","2017"],"answer":1,"explanation":"1 Jan 2015"},{"q":"CAG किस Article?","options":["148","280","324","315"],"answer":0,"explanation":"Art 148 (CAG)"}]}$j$),

    (38, 'upsc_civil', 'cult-upsc-concept', 'concept', 1, 'कला-संस्कृति — UPSC CSE',
     $j${"text":"UPSC art & culture: classical dances (8: Bharatnatyam, Kathak, Kathakali, Kuchipudi, Odissi, Manipuri, Mohiniyattam, Sattriya), music (Hindustani, Carnatic), painting schools (Mughal, Rajput, Madhubani, Warli, Pattachitra, Kalamkari), architecture (temple, Indo-Islamic, colonial), UNESCO sites (40+ in India), GI tags।","note":"UPSC में art को history/geography के साथ link करते हैं।"}$j$),
    (38, 'upsc_civil', 'cult-upsc-formula', 'formula', 2, 'कला-संस्कृति framework',
     $j${"formula":"8 classical dances: Bharatnatyam-TN, Kathak-UP, Kathakali-Kerala, Kuchipudi-AP, Odissi-Odisha, Manipuri, Mohiniyattam, Sattriya","explanation":"Painting: Madhubani (Bihar), Warli (Maharashtra), Pattachitra (Odisha), Kalamkari (AP)"}$j$),
    (38, 'upsc_civil', 'cult-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"GI tag क्या है और क्यों?","solution":"Geographical Indication — regional product protection (Basmati, Darjeeling tea)","answer":"Geographical Indication (regional identity)"}$j$),
    (38, 'upsc_civil', 'cult-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Pattachitra किस state?","options":["Bihar","Odisha","AP","TN"],"answer":1,"explanation":"Odisha (cloth-based scroll)"},{"q":"Sattriya dance?","options":["Assam","Manipur","Kerala","Odisha"],"answer":0,"explanation":"Assam (Vaishnava monasteries)"}]}$j$),

    (40, 'upsc_civil', 'sci-upsc-concept', 'concept', 1, 'विज्ञान-प्रौद्योगिकी — UPSC CSE',
     $j${"text":"UPSC science & tech: space (ISRO — Chandrayaan, Mangalyaan, Aditya-L1, Gaganyaan), nuclear (Kudankulam, PFBR), missiles (Agni, BrahMos, Prithvi), biotech (vaccines, genomics, gene editing), IT (AI, quantum, 5G), defence (Tejas, Arjun, Arihant), energy (solar, hydrogen)। Ethics of tech: AI bias, data privacy।","note":"UPSC में technology + policy + ethics एक साथ पूछते हैं।"}$j$),
    (40, 'upsc_civil', 'sci-upsc-formula', 'formula', 2, 'विज्ञान-प्रौद्योगिकी framework',
     $j${"formula":"ISRO: Chandrayaan (moon), Mangalyaan (Mars), Aditya-L1 (sun), Gaganyaan (human)","explanation":"AI ethics: bias, transparency, accountability · Quantum: qubits, superposition"}$j$),
    (40, 'upsc_civil', 'sci-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Chandrayaan-3 की success का significance?","solution":"South pole landing (first), ISRO capability, space economy","answer":"First south pole landing (2023)"}$j$),
    (40, 'upsc_civil', 'sci-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Chandrayaan-3 landing year?","options":["2021","2022","2023","2024"],"answer":2,"explanation":"23 Aug 2023"},{"q":"PFBR कहाँ?","options":["Kalpakkam","Tarapur","Kudankulam","Rawatbhata"],"answer":0,"explanation":"Prototype Fast Breeder Reactor, Kalpakkam"}]}$j$),

    -- ═══ UPSC GS (12 chapters) ═══
    (870, 'upsc_civil', 'meas-upsc-concept', 'concept', 1, 'मापन — UPSC CSE',
     $j${"text":"Measurement in science: SI units (7 base: m, kg, s, A, K, mol, cd), derived units, dimensional analysis। Precision vs accuracy। Significant figures। Instrument precision (vernier 0.1 mm, screw gauge 0.01 mm)। Error propagation। Calibration।","note":"UPSC में basic science concepts + applications पूछते हैं।"}$j$),
    (870, 'upsc_civil', 'meas-upsc-formula', 'formula', 2, 'मापन framework',
     $j${"formula":"[Force]=MLT⁻² · [Energy]=ML²T⁻² · [Pressure]=ML⁻¹T⁻² · 1 N=10⁵ dyne","explanation":"Precision: repeatability · Accuracy: closeness to true value"}$j$),
    (870, 'upsc_civil', 'meas-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"GPS में precision क्यों important?","solution":"Atomic clocks (nanosecond precision) → position accuracy (~meters)","answer":"Atomic clock precision (ns → m)"}$j$),
    (870, 'upsc_civil', 'meas-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Force dimension?","options":["MLT⁻¹","MLT⁻²","ML²T⁻²","ML⁻¹T⁻²"],"answer":1,"explanation":"[MLT⁻²]"},{"q":"Vernier least count?","options":["0.01 mm","0.1 mm","1 mm","0.001 mm"],"answer":1,"explanation":"0.1 mm"}]}$j$),

    (871, 'upsc_civil', 'motion-upsc-concept', 'concept', 1, 'गति — UPSC CSE',
     $j${"text":"Motion: kinematics (v=u+at, s=ut+½at², v²=u²+2as), projectile, circular motion (angular velocity, centripetal)। Applications: satellite orbits, missile trajectory, vehicle safety, sports physics। Newton's laws and conservation principles।","note":"UPSC में physics concepts को real-world applications से जोड़ते हैं।"}$j$),
    (871, 'upsc_civil', 'motion-upsc-formula', 'formula', 2, 'गति framework',
     $j${"formula":"v = u+at · s = ut+½at² · v² = u²+2as · Projectile R = u²sin2θ/g","explanation":"Circular: v = rω, centripetal a = v²/r = rω²"}$j$),
    (871, 'upsc_civil', 'motion-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Satellite orbital velocity क्यों ज़रूरी?","solution":"v_o = √(gR) ≈ 7.9 km/s — below → falls, above → escapes","answer":"7.9 km/s (Earth orbit)"}$j$),
    (871, 'upsc_civil', 'motion-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Centripetal force?","options":["mv²/r","mv/r","mr/v","mvr"],"answer":0,"explanation":"mv²/r"},{"q":"Max projectile range angle?","options":["30°","45°","60°","90°"],"answer":1,"explanation":"45°"}]}$j$),

    (872, 'upsc_civil', 'force-upsc-concept', 'concept', 1, 'बल — UPSC CSE',
     $j${"text":"Force: Newton's laws, momentum, impulse, friction। Applications: vehicle safety (airbags, seat belts — impulse), rocket propulsion (momentum conservation), sport biomechanics। Rotational: torque, angular momentum (satellite, gyroscope)। Gravity and normal force। Tension, friction (static vs kinetic)।","note":"UPSC में force concepts को daily-life और technology से जोड़ते हैं।"}$j$),
    (872, 'upsc_civil', 'force-upsc-formula', 'formula', 2, 'बल framework',
     $j${"formula":"F = ma · p = mv · Impulse = F·t = Δp · Friction f ≤ μN","explanation":"Conservation of momentum: Σmv = const (no external force)"}$j$),
    (872, 'upsc_civil', 'force-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Airbag कैसे बचाता है?","solution":"Extends time of impact → impulse (F·t) same, F ↓ → less injury","answer":"Extends collision time (impulse principle)"}$j$),
    (872, 'upsc_civil', 'force-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Rocket किस principle?","options":["F=ma","Momentum conservation","Energy","Impulse only"],"answer":1,"explanation":"Momentum conservation (action-reaction)"},{"q":"Momentum unit?","options":["kg·m/s","N","J","Pa"],"answer":0,"explanation":"kg·m/s"}]}$j$),

    (873, 'upsc_civil', 'work-upsc-concept', 'concept', 1, 'कार्य-ऊर्जा — UPSC CSE',
     $j${"text":"Work, energy, power। KE=½mv², PE=mgh. Work-Energy theorem: W=ΔKE। Conservation of energy। Power P=W/t। Energy sources: renewable (solar, wind, hydro), non-renewable (coal, oil, nuclear)। Energy efficiency। kWh commercial unit।","note":"UPSC में energy policy और sustainability angle पूछते हैं।"}$j$),
    (873, 'upsc_civil', 'work-upsc-formula', 'formula', 2, 'कार्य-ऊर्जा framework',
     $j${"formula":"W = Fd cosθ · KE = ½mv² · PE = mgh · P = W/t · 1 kWh = 3.6×10⁶ J","explanation":"Efficiency = useful output/total input × 100% · Energy cannot be created/destroyed"}$j$),
    (873, 'upsc_civil', 'work-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Renewable energy के benefits?","solution":"Low carbon, sustainable, energy security; challenges: intermittency, storage cost","answer":"Sustainability vs intermittency challenge"}$j$),
    (873, 'upsc_civil', 'work-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"1 kWh = ? J","options":["3.6×10³","3.6×10⁶","3.6×10⁹","1000"],"answer":1,"explanation":"3.6×10⁶ J"},{"q":"KE ∝?","options":["v","v²","√v","1/v"],"answer":1,"explanation":"KE = ½mv² → ∝ v²"}]}$j$),

    (874, 'upsc_civil', 'grav-upsc-concept', 'concept', 1, 'गुरुत्वाकर्षण — UPSC CSE',
     $j${"text":"Gravitation: Newton's law F=Gm₁m₂/r², g=9.8 m/s² (Earth surface)। Variation with height/depth। Escape velocity v_e=11.2 km/s। Orbital velocity v_o=7.9 km/s। Kepler's laws. Satellites (GPS, remote sensing, communication)। Weightlessness, tides (moon+sun)।","note":"UPSC में satellite applications और space missions पूछते हैं।"}$j$),
    (874, 'upsc_civil', 'grav-upsc-formula', 'formula', 2, 'गुरुत्व framework',
     $j${"formula":"F = Gm₁m₂/r² · g = GM/R² = 9.8 m/s² · v_e = 11.2 km/s · v_o = 7.9 km/s","explanation":"G = 6.67×10⁻¹¹ · Kepler: T² ∝ r³ · Weightlessness: free fall"}$j$),
    (874, 'upsc_civil', 'grav-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"GPS satellite कैसे काम करता है?","solution":"4+ satellites, atomic clock signals, triangulation → position","answer":"Triangulation using satellite signals"}$j$),
    (874, 'upsc_civil', 'grav-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Escape velocity Earth?","options":["7.9 km/s","11.2 km/s","2.4 km/s","18 km/s"],"answer":1,"explanation":"11.2 km/s"},{"q":"Tides किसका effect?","options":["Sun only","Moon only","Both Moon+Sun","Earth only"],"answer":2,"explanation":"Moon (primary) + Sun (secondary)"}]}$j$),

    (885, 'upsc_civil', 'matter-upsc-concept', 'concept', 1, 'पदार्थ — UPSC CSE',
     $j${"text":"States of matter: solid, liquid, gas, plasma, BEC (Bose-Einstein condensate)। Ideal gas PV=nRT. Phase changes: melting, boiling, sublimation। Superconductors (zero resistance below critical temp)। Applications: cryogenics, MRI, quantum computing।","note":"UPSC में new materials और technology applications पूछते हैं।"}$j$),
    (885, 'upsc_civil', 'matter-upsc-formula', 'formula', 2, 'पदार्थ framework',
     $j${"formula":"PV = nRT · R = 8.314 J/mol·K · v_rms = √(3RT/M) · Superconductor: T < Tc (zero R)","explanation":"States: solid, liquid, gas, plasma, BEC (near 0 K)"}$j$),
    (885, 'upsc_civil', 'matter-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Superconductor applications?","solution":"MRI (magnetic coils), maglev trains, particle accelerators, power grids","answer":"MRI + maglev + accelerators"}$j$),
    (885, 'upsc_civil', 'matter-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Superconductor property?","options":["High R","Zero R below Tc","Infinite R","Positive R only"],"answer":1,"explanation":"Zero resistance below Tc"},{"q":"BEC state?","options":["High T","Near absolute zero","Liquid N₂","Plasma"],"answer":1,"explanation":"Near absolute zero (~nK)"}]}$j$),

    (886, 'upsc_civil', 'atom-upsc-concept', 'concept', 1, 'परमाणु संरचना — UPSC CSE',
     $j${"text":"Atomic structure: nucleus (proton + neutron), electron shells। Isotopes (same Z, different A)। Radioactivity: α, β, γ decay। Half-life. Applications: nuclear medicine (Tc-99m, I-131), radiocarbon dating (C-14, t½ 5730y), nuclear power, radiation therapy, food irradiation। Radiation safety: units (Bq, Gy, Sv)।","note":"UPSC में isotopes और applications दोनों पूछते हैं।"}$j$),
    (886, 'upsc_civil', 'atom-upsc-formula', 'formula', 2, 'परमाणु framework',
     $j${"formula":"Z = protons · A = p+n · N = N₀(1/2)^(t/t½) · E=mc²","explanation":"α: ⁴₂He · β: e⁻ · γ: photon · C-14 half-life 5730 years · Tc-99m 6 hours"}$j$),
    (886, 'upsc_civil', 'atom-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"C-14 dating कैसे काम करता है?","solution":"Living organisms C-14 absorb; after death, decays (t½=5730y) → date by remaining C-14","answer":"Decay-based dating (t½ 5730y)"}$j$),
    (886, 'upsc_civil', 'atom-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"C-14 half-life?","options":["5730y","573y","57000y","57y"],"answer":0,"explanation":"5730 years"},{"q":"γ radiation?","options":["He nucleus","Electron","Photon","Neutron"],"answer":2,"explanation":"γ = high-energy photon"}]}$j$),

    (887, 'upsc_civil', 'periodic-upsc-concept', 'concept', 1, 'आवर्त सारणी — UPSC CSE',
     $j${"text":"Periodic table: periods (7), groups (18)। Elements: metals (75%), non-metals, metalloids. Trends: atomic radius, ionization energy, electronegativity, metallic character. Critical minerals: rare earths (electronics, defence, EVs), lithium (batteries), cobalt (batteries)। India's mineral strategy।","note":"UPSC में critical minerals और strategic resources का geopolitical angle पूछते हैं।"}$j$),
    (887, 'upsc_civil', 'periodic-upsc-formula', 'formula', 2, 'आवर्त framework',
     $j${"formula":"Atomic radius: ↓ across, ↑ down · IE: ↑ across, ↓ down · EN: ↑ across, ↓ down (F=4.0)","explanation":"Rare earths: 17 elements (lanthanides + Sc + Y) · Lithium: EV batteries"}$j$),
    (887, 'upsc_civil', 'periodic-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Rare earths क्यों strategic?","solution":"Electronics, magnets (defence, wind turbines, EVs); China dominance in supply","answer":"Strategic (China supply dominance)"}$j$),
    (887, 'upsc_civil', 'periodic-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Rare earth elements?","options":["17","10","5","20"],"answer":0,"explanation":"17 (lanthanides + Sc + Y)"},{"q":"Highest EN element?","options":["O","F","Cl","N"],"answer":1,"explanation":"F = 4.0"}]}$j$),

    (888, 'upsc_civil', 'bond-upsc-concept', 'concept', 1, 'आबंधन — UPSC CSE',
     $j${"text":"Chemical bonds: ionic (metal+nonmetal), covalent (sharing), metallic, H-bond, van der Waals. VSEPR shapes. Materials: polymers (biodegradable, conductive), nanomaterials, carbon fiber, graphene। Applications: semiconductors, superconductors, MOFs (gas storage)।","note":"UPSC में materials science और technology पूछते हैं।"}$j$),
    (888, 'upsc_civil', 'bond-upsc-formula', 'formula', 2, 'आबंधन framework',
     $j${"formula":"Ionic: NaCl · Covalent: H₂O · Metallic: Cu · H-bond: DNA (A=T, G≡C)","explanation":"Graphene: 1-atom carbon sheet, 200× steel strength · Semiconductor: Si, GaAs"}$j$),
    (888, 'upsc_civil', 'bond-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Graphene के applications?","solution":"Electronics (faster), batteries, water filtration, composites","answer":"Electronics + batteries + filtration"}$j$),
    (888, 'upsc_civil', 'bond-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Graphene structure?","options":["1D","2D (single atom thick)","3D","4D"],"answer":1,"explanation":"2D carbon sheet (1 atom thick)"},{"q":"DNA में G-C H-bonds?","options":["1","2","3","4"],"answer":2,"explanation":"3 H-bonds"}]}$j$),

    (889, 'upsc_civil', 'react-upsc-concept', 'concept', 1, 'अभिक्रियाएँ — UPSC CSE',
     $j${"text":"Chemical reactions: types (combination, decomposition, displacement, double, redox)। Balancing equations। Exothermic vs endothermic। Catalysis. Green chemistry (atom economy, renewable feedstock)। Environmental chemistry: acid rain (SO₂, NOₓ), greenhouse gases, ozone depletion (CFCs)।","note":"UPSC में green chemistry और environmental impact पूछते हैं।"}$j$),
    (889, 'upsc_civil', 'react-upsc-formula', 'formula', 2, 'अभिक्रिया framework',
     $j${"formula":"Exothermic: releases heat (combustion) · Endothermic: absorbs heat · Atom economy = (desired product/total reactant) × 100","explanation":"Acid rain: SO₂ + NOₓ + H₂O → H₂SO₄, HNO₃ (pH < 5.6) · Ozone: CFCs → Cl radicals"}$j$),
    (889, 'upsc_civil', 'react-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"Green chemistry के principles?","solution":"Atom economy, less hazardous synthesis, renewable feedstock, catalysis, real-time analysis","answer":"12 principles (atom economy, less waste)"}$j$),
    (889, 'upsc_civil', 'react-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Atom economy highest?","options":["Substitution","Addition","Elimination","Oxidation"],"answer":1,"explanation":"Addition (100% for simple addition)"},{"q":"Acid rain pH?","options":["<7","<5.6","<3","<1"],"answer":1,"explanation":"Below 5.6 (normal rain 5.6)"}]}$j$),

    (901, 'upsc_civil', 'cell-upsc-concept', 'concept', 1, 'कोशिका — UPSC CSE',
     $j${"text":"Cell: basic unit of life. Prokaryotic (bacteria, no nucleus) vs eukaryotic (nucleus, organelles)। Organelles: nucleus (control), mitochondria (ATP), ribosome (protein), ER (transport), Golgi (packaging), lysosome (digestion)। Cell cycle: interphase + M phase। Stem cells (regenerative medicine)। Gene editing (CRISPR)।","note":"UPSC में biology + technology interface पूछते हैं।"}$j$),
    (901, 'upsc_civil', 'cell-upsc-formula', 'formula', 2, 'कोशिका framework',
     $j${"formula":"Mitochondria: ATP (powerhouse) · Ribosome: protein synthesis · Nucleus: control","explanation":"Cell cycle: G1→S→G2→M · Stem cells: pluripotent (can become any cell type)"}$j$),
    (901, 'upsc_civil', 'cell-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"CRISPR applications?","solution":"Gene therapy (sickle cell), agriculture (drought-resistant crops), disease resistance","answer":"Gene therapy + agriculture"}$j$),
    (901, 'upsc_civil', 'cell-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"CRISPR क्या है?","options":["Gene editing","Cloning","DNA sequencing","Vaccine"],"answer":0,"explanation":"Gene editing (Cas9)"},{"q":"Powerhouse of cell?","options":["Nucleus","Mitochondria","Ribosome","Golgi"],"answer":1,"explanation":"ATP production"}]}$j$),

    (902, 'upsc_civil', 'tissue-upsc-concept', 'concept', 1, 'ऊतक — UPSC CSE',
     $j${"text":"Tissues: plant (meristematic, parenchyma, xylem, phloem) vs animal (epithelial, connective, muscular, nervous)। Stem cells, tissue engineering (artificial organs, 3D bioprinting)। Bone marrow transplant (leukemia)। Blood transfusion (ABO + Rh)। Organs: heart, kidney, liver (transplants)।","note":"UPSC में tissue engineering और medical technology पूछते हैं।"}$j$),
    (902, 'upsc_civil', 'tissue-upsc-formula', 'formula', 2, 'ऊतक framework',
     $j${"formula":"Plant: xylem (water up), phloem (food) · Animal: epithelial, connective, muscular, nervous","explanation":"Stem cells: embryonic (pluripotent), adult (multipotent) · Blood: O− universal donor"}$j$),
    (902, 'upsc_civil', 'tissue-upsc-example', 'example', 3, 'UPSC case study',
     $j${"question":"3D bioprinting क्या है?","solution":"Living cells + biomaterials printed layer-by-layer to create tissues/organs","answer":"Layer-by-layer organ printing"}$j$),
    (902, 'upsc_civil', 'tissue-upsc-mcq', 'mcq', 4, 'UPSC MCQs',
     $j${"questions":[{"q":"Universal donor?","options":["A+","B+","AB+","O−"],"answer":3,"explanation":"O− (no antigens)"},{"q":"Blood tissue type?","options":["Epithelial","Connective","Muscular","Nervous"],"answer":1,"explanation":"Fluid connective"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[], '{}'::text[],
  case when s.chapter_id < 100 then 'general-awareness' 
       else 'general-science' end,
  'hard', md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select chapter_id, count(*) from mtb.atoms 
-- where chapter_id in (415,417,418,419,421,422,38,40,870,871,872,873,874,885,886,887,888,889,901,902) 
--   and level_id='upsc_civil' and status='published' and not archived 
-- group by 1 order by 1;
-- Expected: 418 = 7 (3 pre-existing + 4 new), others = 4
-- Total delta: 80 new atoms

-- Total:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: ~2620 + 80 = ~2700
