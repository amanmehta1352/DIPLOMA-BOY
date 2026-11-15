# 📚 Diploma Boy — पूरी किताब योजना (Book Plan)

> यह फ़ाइल `node tools/book-plan/build.mjs` से अपने-आप बनती है (2026-11-13)। ऐप में कोर्स या परीक्षा जुड़े तो स्क्रिप्ट दोबारा चलाएँ।
> AI एजेंट के लिए पूरा डेटा: [books.json](books.json) · शीट: [books.csv](books.csv) · लिखने के नियम: [AGENT_BRIEF.md](AGENT_BRIEF.md)

## 1. कुल गिनती

| क्या | संख्या |
|---|---|
| ऐप में कुल किताबें (हर विषय की एक जगह) | **865** |
| — कोर्स की किताबें (कोर्स → साल/सेमेस्टर → विषय) | 775 |
| — परीक्षा की किताबें (परीक्षा लेवल → विषय, कई परीक्षाएँ एक किताब शेयर करती हैं) | 90 |
| अलग-अलग लिखनी पड़ेंगी (एक जैसा सिलेबस एक बार लिखें, कई जगह लगाएँ) | **625** |
| पहला चरण: हर किताब का 1 संस्करण | 865 |
| पूरा सेट: सुझाए गए सभी संस्करण (शैली) | 2861 |
| कुल अध्याय (पहले संस्करण में) | 4075 |
| जिनके अध्याय अभी तय नहीं (एजेंट पहले अध्याय-सूची बनाएगा) | 140 |

**किताब बनाम संस्करण:** "किताब" = ऐप में विषय की एक जगह (जैसे डिप्लोमा मैकेनिकल · सेमेस्टर 3 · थर्मल इंजीनियरिंग)। "संस्करण" = उस किताब का एक लिखा हुआ रूप, किसी एक शैली में (पाठ्यपुस्तक, परीक्षा, रिवीजन…)। हर किताब में पहले 1 संस्करण बनाएँ, बाद में बाकी शैलियाँ।

### किस क्रम में बनाएँ

| चरण | क्या | किताबें | पहला संस्करण | पूरा सेट | अध्याय (पहला संस्करण) |
|---|---|---|---|---|---|
| 1 | डिप्लोमा (इंजीनियरिंग) + JE / तकनीकी और सामान्य सरकारी परीक्षाएँ | 259 | 259 | 921 | 1058 |
| 2 | स्कूल (कक्षा 6-12) + ITI + स्कूल-स्तर प्रवेश परीक्षाएँ | 124 | 124 | 427 | 665 |
| 3 | बी.टेक + बैंकिंग, रक्षा, सिविल सेवा | 162 | 162 | 602 | 920 |
| 4 | बाकी डिग्रियाँ और परीक्षाएँ (मेडिकल, कानून, कॉमर्स, कला, शोध) | 320 | 320 | 911 | 1432 |

## 2. लेवल के हिसाब से गिनती

| श्रेणी | कोर्स / परीक्षा लेवल | किताबें | थ्योरी | लैब | इलेक्टिव | प्रोजेक्ट | डिज़ाइन प्रोफ़ाइल | संस्करण (पूरा सेट) |
|---|---|---|---|---|---|---|---|---|
| स्कूल | कक्षा 6 | 7 | 6 | 1 | 0 | 0 | school-6-8, lab-manual | 20 |
| स्कूल | कक्षा 7 | 7 | 6 | 1 | 0 | 0 | school-6-8, lab-manual | 20 |
| स्कूल | कक्षा 8 | 7 | 6 | 1 | 0 | 0 | school-6-8, lab-manual | 20 |
| स्कूल | कक्षा 9 | 7 | 5 | 1 | 1 | 0 | school-9-10, lab-manual | 26 |
| स्कूल | कक्षा 10 | 7 | 5 | 1 | 1 | 0 | school-9-10, lab-manual | 26 |
| स्कूल | कक्षा 11-12 विज्ञान (PCM) | 12 | 8 | 2 | 2 | 0 | school-11-12, lab-manual | 44 |
| स्कूल | कक्षा 11-12 विज्ञान (PCB) | 12 | 8 | 2 | 2 | 0 | school-11-12, lab-manual | 44 |
| स्कूल | कक्षा 11-12 कॉमर्स | 12 | 10 | 0 | 2 | 0 | school-11-12 | 48 |
| स्कूल | कक्षा 11-12 कला | 16 | 16 | 0 | 0 | 0 | school-11-12 | 64 |
| आईटीआई | आईटीआई — फ़िटर / टर्नर / मशीनिस्ट / वेल्डर / मैकेनिक (डीज़ल, मोटर व्हीकल) | 10 | 6 | 4 | 0 | 0 | iti-trade, lab-manual | 26 |
| आईटीआई | आईटीआई — इलेक्ट्रीशियन / वायरमैन / इलेक्ट्रॉनिक्स मैकेनिक | 10 | 6 | 4 | 0 | 0 | iti-trade, lab-manual | 26 |
| आईटीआई | आईटीआई — कोपा (कंप्यूटर ऑपरेटर) | 4 | 3 | 1 | 0 | 0 | iti-trade, lab-manual | 11 |
| डिप्लोमा | डिप्लोमा इन मैकेनिकल इंजीनियरिंग | 39 | 28 | 6 | 2 | 3 | diploma-theory, lab-manual, project-guide | 135 |
| डिप्लोमा | डिप्लोमा इन सिविल इंजीनियरिंग | 41 | 29 | 8 | 2 | 2 | diploma-theory, lab-manual, project-guide | 142 |
| डिप्लोमा | डिप्लोमा इन इलेक्ट्रिकल इंजीनियरिंग | 37 | 28 | 6 | 1 | 2 | diploma-theory, lab-manual, project-guide | 130 |
| डिप्लोमा | डिप्लोमा इन इलेक्ट्रॉनिक्स एवं संचार इंजीनियरिंग | 37 | 28 | 6 | 1 | 2 | diploma-theory, lab-manual, project-guide | 130 |
| डिप्लोमा | डिप्लोमा इन कंप्यूटर साइंस इंजीनियरिंग | 36 | 27 | 6 | 1 | 2 | diploma-theory, lab-manual, project-guide | 126 |
| डिप्लोमा | डिप्लोमा इन ऑटोमोबाइल इंजीनियरिंग | 38 | 29 | 6 | 1 | 2 | diploma-theory, lab-manual, project-guide | 134 |
| डिप्लोमा | डी.फ़ार्मा (डिप्लोमा इन फ़ार्मेसी) | 13 | 11 | 1 | 0 | 1 | medical, lab-manual, project-guide | 36 |
| डिप्लोमा | जीएनएम (जनरल नर्सिंग एवं मिडवाइफ़री) | 19 | 16 | 2 | 0 | 1 | medical, lab-manual, project-guide | 53 |
| डिप्लोमा | डी.एल.एड. (प्राथमिक शिक्षक डिप्लोमा) | 13 | 12 | 0 | 0 | 1 | education, project-guide | 37 |
| स्नातक (ग्रेजुएशन) | बी.टेक / बी.ई. (मैकेनिकल इंजीनियरिंग) | 30 | 26 | 2 | 1 | 1 | btech-theory, lab-manual, project-guide | 113 |
| स्नातक (ग्रेजुएशन) | बी.टेक / बी.ई. (सिविल इंजीनियरिंग) | 28 | 24 | 2 | 1 | 1 | btech-theory, lab-manual, project-guide | 105 |
| स्नातक (ग्रेजुएशन) | बी.टेक / बी.ई. (इलेक्ट्रिकल इंजीनियरिंग) | 29 | 25 | 2 | 1 | 1 | btech-theory, lab-manual, project-guide | 109 |
| स्नातक (ग्रेजुएशन) | बी.टेक / बी.ई. (इलेक्ट्रॉनिक्स एवं संचार) | 27 | 23 | 2 | 1 | 1 | btech-theory, lab-manual, project-guide | 101 |
| स्नातक (ग्रेजुएशन) | बी.टेक / बी.ई. (कंप्यूटर साइंस) | 27 | 23 | 2 | 1 | 1 | btech-theory, lab-manual, project-guide | 101 |
| स्नातक (ग्रेजुएशन) | बी.एससी. (विज्ञान स्नातक) | 18 | 14 | 2 | 1 | 1 | ug-science, lab-manual, project-guide | 50 |
| स्नातक (ग्रेजुएशन) | बी.कॉम. (वाणिज्य स्नातक) | 18 | 18 | 0 | 0 | 0 | ug-commerce | 54 |
| स्नातक (ग्रेजुएशन) | बी.ए. (कला स्नातक) | 13 | 11 | 0 | 1 | 1 | ug-arts, project-guide | 37 |
| स्नातक (ग्रेजुएशन) | बी.एड. (शिक्षा स्नातक) | 16 | 11 | 4 | 0 | 1 | education, lab-manual, project-guide | 42 |
| स्नातक (ग्रेजुएशन) | बी.एससी. नर्सिंग | 25 | 24 | 0 | 0 | 1 | medical, project-guide | 73 |
| स्नातक (ग्रेजुएशन) | बी.फ़ार्मा (फ़ार्मेसी स्नातक) | 33 | 31 | 0 | 1 | 1 | medical, project-guide | 97 |
| स्नातक (ग्रेजुएशन) | एमबीबीएस | 20 | 18 | 0 | 0 | 2 | medical, project-guide | 56 |
| स्नातक (ग्रेजुएशन) | एलएल.बी. (विधि स्नातक) | 26 | 23 | 1 | 0 | 2 | law, lab-manual, project-guide | 73 |
| स्नातक (ग्रेजुएशन) | बी.सी.ए. (कंप्यूटर एप्लिकेशन) | 15 | 14 | 0 | 0 | 1 | ug-science, project-guide | 43 |
| स्नातक (ग्रेजुएशन) | बी.बी.ए. (व्यवसाय प्रशासन) | 16 | 15 | 0 | 0 | 1 | ug-commerce, project-guide | 46 |
| स्नातक (ग्रेजुएशन) | बी.एससी. कृषि | 24 | 21 | 0 | 1 | 2 | ug-science, project-guide | 68 |
| स्नातकोत्तर | एम.बी.ए. | 14 | 11 | 0 | 1 | 2 | ug-commerce, project-guide | 38 |
| स्नातकोत्तर | एम.सी.ए. | 12 | 11 | 0 | 0 | 1 | ug-science, project-guide | 34 |
| प्रतियोगी परीक्षा | उच्च शोध | 4 | — | — | — | — | exam-research | 8 |
| प्रतियोगी परीक्षा | बैंकिंग | 6 | — | — | — | — | exam-banking | 18 |
| प्रतियोगी परीक्षा | कक्षा 11-12 विज्ञान | 4 | — | — | — | — | exam-entrance | 16 |
| प्रतियोगी परीक्षा | कक्षा 6-8 | 4 | — | — | — | — | exam-entrance | 16 |
| प्रतियोगी परीक्षा | कक्षा 9-10 | 3 | — | — | — | — | exam-entrance | 12 |
| प्रतियोगी परीक्षा | इंजीनियरिंग | 2 | — | — | — | — | exam-entrance | 8 |
| प्रतियोगी परीक्षा | सरकारी (सामान्य) | 9 | — | — | — | — | exam-basic | 36 |
| प्रतियोगी परीक्षा | रक्षा | 5 | — | — | — | — | exam-defence | 15 |
| प्रतियोगी परीक्षा | सरकारी (तकनीकी) | 22 | — | — | — | — | exam-technical | 88 |
| प्रतियोगी परीक्षा | स्नातक विज्ञान | 4 | — | — | — | — | exam-banking | 12 |
| प्रतियोगी परीक्षा | कानून / प्रबंधन | 9 | — | — | — | — | exam-law-mgmt | 27 |
| प्रतियोगी परीक्षा | मेडिकल | 8 | — | — | — | — | exam-entrance, exam-health | 27 |
| प्रतियोगी परीक्षा | राज्य PSC | 5 | — | — | — | — | exam-civil-services | 20 |
| प्रतियोगी परीक्षा | UPSC सिविल | 5 | — | — | — | — | exam-civil-services | 20 |

## 3. हर लेवल किताब कैसे डिज़ाइन हो (प्रोफ़ाइल)

| प्रोफ़ाइल | किसके लिए | पढ़ने वाला | भाषा | अध्याय की लंबाई और बनावट | संस्करण (क्रम से) |
|---|---|---|---|---|---|
| `school-6-8` | कक्षा 6-8 (मिडिल स्कूल) | age 11-14, first contact with the subject; many read Hindi better than English | very simple Hindi first (class-6 vocabulary), English beside it; short sentences (max ~15 words); define every new word | 900-1500 words. h → story/observation opener → 3-5 concept sections (h + p + key) → "करके देखें" activity (note tip) → summary key list → exercise | 📗 पाठ्यपुस्तक → 🔢 अभ्यास → ⚡ रिवीजन |
| `school-9-10` | कक्षा 9-10 (बोर्ड परीक्षा) | age 14-16 preparing for the state / CBSE board exam; also polytechnic entrance | simple standard Hindi + English, board-exam terms in both languages (e.g. "अपवर्तन (Refraction)") | 1800-3000 words. intro → topic sections (h, p, key, formula) → in-text questions (ex) after each section → solved numericals → chapter summary → board-style exercise (1/2/3/5-mark) | 📗 पाठ्यपुस्तक → 🎯 परीक्षा → 🔢 अभ्यास → ⚡ रिवीजन |
| `school-11-12` | कक्षा 11-12 (विज्ञान / कॉमर्स / कला) | age 16-18; board exam plus entrance exams (JEE / NEET / CUET) | standard Hindi + English, technical words always in both; formulas in standard notation | 2500-4000 words. concept sections with derivation/explanation → solved examples (easy→hard) → "entrance corner" note(exam) → summary → exercise | 📗 पाठ्यपुस्तक → 🎯 परीक्षा → 🔢 अभ्यास → 📚 संदर्भ |
| `iti-trade` | ITI ट्रेड | 10th-pass trainee learning a trade by hand; reads Hindi first | plain workshop Hindi with the English trade name of every tool / part (as said on the shop floor) | 1000-1800 words. safety first (note warn) → tool/part description (table of parts) → step-by-step procedure (numbered p) → precautions → trade theory MCQ | 📗 पाठ्यपुस्तक → 🔢 अभ्यास → ⚡ रिवीजन |
| `diploma-theory` | डिप्लोमा (पॉलिटेक्निक) थ्योरी | 10th/12th-pass polytechnic student, semester exam + later JE exams | Hindi + English side by side; every technical term in English as written in the question paper | 2000-3500 words per unit. learning outcomes (key) → topics as h → principle/construction/working → solved numericals → comparison table → semester questions (2/5/10 mark) → JE corner MCQ | 📗 पाठ्यपुस्तक → 🧑‍🏫 शिक्षक → 🎯 परीक्षा → ⚡ रिवीजन |
| `btech-theory` | बी.टेक / बी.ई. थ्योरी | engineering undergraduate; university exam + GATE / ESE / PSU | English-first technical writing with Hindi explanation; standard symbols and notation | 3000-5000 words per unit. objectives → theory with derivations → worked problems (graded) → design notes → summary of equations → university questions → GATE-level MCQ/NAT | 📗 पाठ्यपुस्तक → 📚 संदर्भ → 🎯 परीक्षा → 🔢 अभ्यास |
| `lab-manual` | लैब / प्रैक्टिकल / ड्रॉइंग | student doing the practical in the lab or drawing hall | instructions in Hindi + English, short imperative steps | 700-1200 words per experiment. aim (key) → apparatus (table) → theory (p + formula) → procedure (numbered p) → observation table (table with empty rows) → sample calculation (ex) → result → precautions (note warn) → viva voce (mcq) | 📗 पाठ्यपुस्तक → 🔢 अभ्यास |
| `project-guide` | प्रोजेक्ट / इंटर्नशिप / सेमिनार | student who must plan, do and report a project or internship | Hindi + English, checklist style | 6-8 chapters: choosing a topic → planning & timeline (table) → doing the work / diary → report format → presentation → viva → 20 sample ideas | 🧑‍🏫 शिक्षक |
| `ug-science` | स्नातक विज्ञान / BCA / MCA / कृषि | graduate student; university exam + later NET / govt exams | English-first academic writing with Hindi explanation | 2500-4500 words per unit. objectives → theory → worked examples → summary → university questions → MCQ | 📗 पाठ्यपुस्तक → 📚 संदर्भ → 🎯 परीक्षा |
| `ug-commerce` | B.Com / BBA / MBA | commerce / management student | Hindi + English; accounting and business terms in English as used in practice | 2500-4000 words. concept → format (table) → solved illustration (ex) → case study (note) → summary → questions | 📗 पाठ्यपुस्तक → 🔢 अभ्यास → 🎯 परीक्षा |
| `ug-arts` | B.A. / कला | humanities student; university exam + civil-services foundation | clear Hindi first, English terms in brackets | 2500-4000 words. background → main themes (h + p) → timeline/comparison table → analysis → summary → long-answer questions | 📗 पाठ्यपुस्तक → 📚 संदर्भ → ⚡ रिवीजन |
| `law` | LL.B. / कानून | law student; semester exam + judiciary / CLAT-PG | English legal terms with clear Hindi explanation; section numbers stated, never bare-act text copied | 3000-4500 words. introduction → provisions explained → essentials (key) → illustrations (ex, invented facts) → comparison table → problem questions | 📗 पाठ्यपुस्तक → 🎯 परीक्षा → ⚡ रिवीजन |
| `medical` | MBBS / नर्सिंग / फ़ार्मेसी | health-science student; university exam + NEET PG / NORCET / GPAT | English medical terms (standard spelling) with Hindi explanation | 3000-5000 words. objectives → topic sections → clinical note (note exam) → comparison tables → summary → MCQ (clinical vignette style, invented patients) | 📗 पाठ्यपुस्तक → 🎯 परीक्षा → ⚡ रिवीजन |
| `education` | D.El.Ed. / B.Ed. | teacher trainee; course exam + CTET / TET | Hindi first, English terms in brackets | 2000-3500 words. concept → theorist ideas in own words → classroom example (ex) → table → summary → CTET-style MCQ | 📗 पाठ्यपुस्तक → 🎯 परीक्षा → ⚡ रिवीजन |
| `exam-basic` | सरकारी परीक्षा — सामान्य स्तर (SSC, रेलवे, पुलिस, TET) | 10th/12th/graduate aspirant; speed + accuracy in a CBT | Hindi + English (papers are bilingual); short crisp points | 1500-2500 words. concept → formula/rule list → trick notes → 8-10 solved examples → 20 practice MCQ with explanation | 🎯 परीक्षा → 🔢 अभ्यास → ⚡ रिवीजन → 🧑‍🏫 शिक्षक |
| `exam-technical` | तकनीकी परीक्षा (JE, ALP, Technician, PSU, GATE/ESE) | diploma / B.Tech / ITI candidate for a technical post | English technical terms with Hindi explanation; standard symbols | 2000-3000 words. concept recap → formula sheet (formula blocks) → standard data table → 10 solved problems → 25 MCQ | 🎯 परीक्षा → 🔢 अभ्यास → ⚡ रिवीजन → 📗 पाठ्यपुस्तक |
| `exam-banking` | बैंकिंग / बीमा | graduate aspirant; very time-bound prelims + mains | English-first (banking papers) with Hindi help | 1500-2500 words. method → shortcuts → solved sets → 20 practice MCQ with time target | 🎯 परीक्षा → 🔢 अभ्यास → ⚡ रिवीजन |
| `exam-defence` | रक्षा (NDA, CDS, AFCAT, अग्निवीर) | 12th-pass / graduate defence aspirant | Hindi + English | 1800-2800 words. concept → formulas → solved examples → 20 MCQ | 🎯 परीक्षा → 🔢 अभ्यास → ⚡ रिवीजन |
| `exam-civil-services` | सिविल सेवा (UPSC, राज्य PSC) | graduate aspirant; prelims MCQ + mains answer writing | Hindi + English, analytical tone | 3000-4500 words. background → core concepts → linkages (note) → tables/timelines → 15 multi-statement MCQ → 2 model mains answers (ex) | 📗 पाठ्यपुस्तक → 🎯 परीक्षा → ⚡ रिवीजन → 📚 संदर्भ |
| `exam-entrance` | प्रवेश परीक्षा (JEE, NEET, CUET, पॉलिटेक्निक, सैनिक स्कूल) | school student aiming for admission | Hindi + English; formulas standard | 2500-4000 words. concept recap → formulas → graded solved problems → 25 MCQ / numerical | 🎯 परीक्षा → 🔢 अभ्यास → 📗 पाठ्यपुस्तक → ⚡ रिवीजन |
| `exam-health` | स्वास्थ्य भर्ती (NORCET, फ़ार्मासिस्ट, NEET PG, GPAT) | nursing / pharmacy / MBBS graduate | English medical terms with Hindi help | 2000-3000 words. high-yield points → tables → 25 MCQ with explanation | 🎯 परीक्षा → ⚡ रिवीजन → 🔢 अभ्यास |
| `exam-law-mgmt` | लॉ / मैनेजमेंट प्रवेश और न्यायिक सेवा (CLAT, CAT, Judiciary) | 12th-pass / graduate aspirant | English-first with Hindi help | 2000-3000 words. method → solved passages → 20 practice questions | 🎯 परीक्षा → 🔢 अभ्यास → ⚡ रिवीजन |
| `exam-research` | शोध / NET | post-graduate candidate (UGC NET, CSIR NET) | English-first academic | 3000-4500 words. concepts → frameworks (table) → 20 MCQ | 📗 पाठ्यपुस्तक → 🎯 परीक्षा |

## 4. पूरी सूची — कोर्स की किताबें

### स्कूल

#### कक्षा 6 — Class 6 (7 किताबें · प्रोफ़ाइल: school-6-8, lab-manual)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | — | गणित (Mathematics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-6:all:mathematics` |
| 2 | — | विज्ञान (Science) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-6:all:science` |
| 3 | — | सामाजिक विज्ञान (इतिहास, भूगोल, राजनीति विज्ञान, अर्थशास्त्र) (Social Science (History, Geography, Political Science, Economics)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-6:all:social-science-history-geography-political-science-economics` |
| 4 | — | हिंदी (Hindi) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-6:all:hindi` |
| 5 | — | अंग्रेज़ी (English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-6:all:english` |
| 6 | — | संस्कृत / तृतीय भाषा (Sanskrit / Third Language) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:class-6:all:sanskrit-third-language` |
| 7 | — | कला, स्वास्थ्य एवं शारीरिक शिक्षा (Art, Health & Physical Education) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:class-6:all:art-health-physical-education` |

#### कक्षा 7 — Class 7 (7 किताबें · प्रोफ़ाइल: school-6-8, lab-manual)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | — | गणित (Mathematics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-7:all:mathematics` |
| 2 | — | विज्ञान (Science) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-7:all:science` |
| 3 | — | सामाजिक विज्ञान (इतिहास, भूगोल, राजनीति विज्ञान, अर्थशास्त्र) (Social Science (History, Geography, Political Science, Economics)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-7:all:social-science-history-geography-political-science-economics` |
| 4 | — | हिंदी (Hindi) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-7:all:hindi` |
| 5 | — | अंग्रेज़ी (English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-7:all:english` |
| 6 | — | संस्कृत / तृतीय भाषा (Sanskrit / Third Language) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:class-7:all:sanskrit-third-language` |
| 7 | — | कला, स्वास्थ्य एवं शारीरिक शिक्षा (Art, Health & Physical Education) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:class-7:all:art-health-physical-education` |

#### कक्षा 8 — Class 8 (7 किताबें · प्रोफ़ाइल: school-6-8, lab-manual)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | — | गणित (Mathematics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-8:all:mathematics` |
| 2 | — | विज्ञान (Science) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-8:all:science` |
| 3 | — | सामाजिक विज्ञान (इतिहास, भूगोल, राजनीति विज्ञान, अर्थशास्त्र) (Social Science (History, Geography, Political Science, Economics)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-8:all:social-science-history-geography-political-science-economics` |
| 4 | — | हिंदी (Hindi) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-8:all:hindi` |
| 5 | — | अंग्रेज़ी (English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-8:all:english` |
| 6 | — | संस्कृत / तृतीय भाषा (Sanskrit / Third Language) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:class-8:all:sanskrit-third-language` |
| 7 | — | कला, स्वास्थ्य एवं शारीरिक शिक्षा (Art, Health & Physical Education) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:class-8:all:art-health-physical-education` |

#### कक्षा 9 — Class 9 (7 किताबें · प्रोफ़ाइल: school-9-10, lab-manual)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | — | गणित (Mathematics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-9:all:mathematics` |
| 2 | — | विज्ञान (Science) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-9:all:science` |
| 3 | — | सामाजिक विज्ञान (इतिहास, भूगोल, राजनीति विज्ञान, अर्थशास्त्र) (Social Science (History, Geography, Political Science, Economics)) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:class-9:all:social-science-history-geography-political-science-economics` |
| 4 | — | हिंदी (Hindi) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-9:all:hindi` |
| 5 | — | अंग्रेज़ी (English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-9:all:english` |
| 6 | — | सूचना प्रौद्योगिकी / कौशल विषय (ऐच्छिक) (Information Technology / Skill subject (optional)) | ऐच्छिक (इलेक्टिव) | 3 | 📗 पाठ्यपुस्तक | `c:class-9:all:information-technology-skill-subject-optional` |
| 7 | — | स्वास्थ्य एवं शारीरिक शिक्षा (Health & Physical Education) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:class-9:all:health-physical-education` |

#### कक्षा 10 — Class 10 (7 किताबें · प्रोफ़ाइल: school-9-10, lab-manual)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | — | गणित (Mathematics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-10:all:mathematics` |
| 2 | — | विज्ञान (Science) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-10:all:science` |
| 3 | — | सामाजिक विज्ञान (इतिहास, भूगोल, राजनीति विज्ञान, अर्थशास्त्र) (Social Science (History, Geography, Political Science, Economics)) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:class-10:all:social-science-history-geography-political-science-economics` |
| 4 | — | हिंदी (Hindi) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-10:all:hindi` |
| 5 | — | अंग्रेज़ी (English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-10:all:english` |
| 6 | — | सूचना प्रौद्योगिकी / कौशल विषय (ऐच्छिक) (Information Technology / Skill subject (optional)) | ऐच्छिक (इलेक्टिव) | 5 | 📗 पाठ्यपुस्तक | `c:class-10:all:information-technology-skill-subject-optional` |
| 7 | — | स्वास्थ्य एवं शारीरिक शिक्षा (Health & Physical Education) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:class-10:all:health-physical-education` |

#### कक्षा 11-12 विज्ञान (PCM) — Class 11-12 Science (PCM) (12 किताबें · प्रोफ़ाइल: school-11-12, lab-manual)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | कक्षा 11 | भौतिकी (Physics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcm:11:physics` |
| 2 | कक्षा 11 | रसायन विज्ञान (Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcm:11:chemistry` |
| 3 | कक्षा 11 | गणित (Mathematics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcm:11:mathematics` |
| 4 | कक्षा 11 | अंग्रेज़ी (कोर) (English (Core)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcm:11:english-core` |
| 5 | कक्षा 11 | ऐच्छिक: कंप्यूटर साइंस / शारीरिक शिक्षा (Optional: Computer Science / Physical Education) | ऐच्छिक (इलेक्टिव) | 4 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcm:11:optional-computer-science-physical-education` |
| 6 | कक्षा 11 | भौतिकी और रसायन प्रायोगिक (Physics & Chemistry Practicals) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:class-11-12-pcm:11:physics-chemistry-practicals` |
| 7 | कक्षा 12 | भौतिकी (Physics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcm:12:physics` |
| 8 | कक्षा 12 | रसायन विज्ञान (Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcm:12:chemistry` |
| 9 | कक्षा 12 | गणित (Mathematics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcm:12:mathematics` |
| 10 | कक्षा 12 | अंग्रेज़ी (कोर) (English (Core)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcm:12:english-core` |
| 11 | कक्षा 12 | ऐच्छिक: कंप्यूटर साइंस / शारीरिक शिक्षा (Optional: Computer Science / Physical Education) | ऐच्छिक (इलेक्टिव) | 4 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcm:12:optional-computer-science-physical-education` |
| 12 | कक्षा 12 | भौतिकी और रसायन प्रायोगिक (Physics & Chemistry Practicals) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:class-11-12-pcm:12:physics-chemistry-practicals` |

#### कक्षा 11-12 विज्ञान (PCB) — Class 11-12 Science (PCB) (12 किताबें · प्रोफ़ाइल: school-11-12, lab-manual)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | कक्षा 11 | भौतिकी (Physics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcb:11:physics` |
| 2 | कक्षा 11 | रसायन विज्ञान (Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcb:11:chemistry` |
| 3 | कक्षा 11 | जीव विज्ञान (Biology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcb:11:biology` |
| 4 | कक्षा 11 | अंग्रेज़ी (कोर) (English (Core)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcb:11:english-core` |
| 5 | कक्षा 11 | ऐच्छिक: गणित / मनोविज्ञान / शारीरिक शिक्षा (Optional: Mathematics / Psychology / Physical Education) | ऐच्छिक (इलेक्टिव) | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcb:11:optional-mathematics-psychology-physical-education` |
| 6 | कक्षा 11 | भौतिकी, रसायन और जीव विज्ञान प्रायोगिक (Physics, Chemistry & Biology Practicals) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:class-11-12-pcb:11:physics-chemistry-biology-practicals` |
| 7 | कक्षा 12 | भौतिकी (Physics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcb:12:physics` |
| 8 | कक्षा 12 | रसायन विज्ञान (Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcb:12:chemistry` |
| 9 | कक्षा 12 | जीव विज्ञान (Biology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcb:12:biology` |
| 10 | कक्षा 12 | अंग्रेज़ी (कोर) (English (Core)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcb:12:english-core` |
| 11 | कक्षा 12 | ऐच्छिक: गणित / मनोविज्ञान / शारीरिक शिक्षा (Optional: Mathematics / Psychology / Physical Education) | ऐच्छिक (इलेक्टिव) | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-pcb:12:optional-mathematics-psychology-physical-education` |
| 12 | कक्षा 12 | भौतिकी, रसायन और जीव विज्ञान प्रायोगिक (Physics, Chemistry & Biology Practicals) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:class-11-12-pcb:12:physics-chemistry-biology-practicals` |

#### कक्षा 11-12 कॉमर्स — Class 11-12 Commerce (12 किताबें · प्रोफ़ाइल: school-11-12)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | कक्षा 11 | लेखाशास्त्र (Accountancy) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-commerce:11:accountancy` |
| 2 | कक्षा 11 | व्यवसाय अध्ययन (Business Studies) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-commerce:11:business-studies` |
| 3 | कक्षा 11 | अर्थशास्त्र (Economics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-commerce:11:economics` |
| 4 | कक्षा 11 | गणित / अनुप्रयुक्त गणित (Mathematics / Applied Mathematics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-commerce:11:mathematics-applied-mathematics` |
| 5 | कक्षा 11 | अंग्रेज़ी (कोर) (English (Core)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-commerce:11:english-core` |
| 6 | कक्षा 11 | ऐच्छिक: इन्फ़ॉर्मेटिक्स प्रैक्टिसेज़ / शारीरिक शिक्षा (Optional: Informatics Practices / Physical Education) | ऐच्छिक (इलेक्टिव) | 4 | 📗 पाठ्यपुस्तक | `c:class-11-12-commerce:11:optional-informatics-practices-physical-education` |
| 7 | कक्षा 12 | लेखाशास्त्र (Accountancy) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-commerce:12:accountancy` |
| 8 | कक्षा 12 | व्यवसाय अध्ययन (Business Studies) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-commerce:12:business-studies` |
| 9 | कक्षा 12 | अर्थशास्त्र (Economics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-commerce:12:economics` |
| 10 | कक्षा 12 | गणित / अनुप्रयुक्त गणित (Mathematics / Applied Mathematics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-commerce:12:mathematics-applied-mathematics` |
| 11 | कक्षा 12 | अंग्रेज़ी (कोर) (English (Core)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-commerce:12:english-core` |
| 12 | कक्षा 12 | ऐच्छिक: इन्फ़ॉर्मेटिक्स प्रैक्टिसेज़ / शारीरिक शिक्षा (Optional: Informatics Practices / Physical Education) | ऐच्छिक (इलेक्टिव) | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-commerce:12:optional-informatics-practices-physical-education` |

#### कक्षा 11-12 कला — Class 11-12 Arts (16 किताबें · प्रोफ़ाइल: school-11-12)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | कक्षा 11 | इतिहास (History) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:11:history` |
| 2 | कक्षा 11 | राजनीति विज्ञान (Political Science) | थ्योरी | 2 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:11:political-science` |
| 3 | कक्षा 11 | भूगोल (Geography) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:11:geography` |
| 4 | कक्षा 11 | समाजशास्त्र (Sociology) | थ्योरी | 2 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:11:sociology` |
| 5 | कक्षा 11 | मनोविज्ञान (Psychology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:11:psychology` |
| 6 | कक्षा 11 | अर्थशास्त्र (Economics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:11:economics` |
| 7 | कक्षा 11 | हिंदी (Hindi) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:11:hindi` |
| 8 | कक्षा 11 | अंग्रेज़ी (कोर) (English (Core)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:11:english-core` |
| 9 | कक्षा 12 | इतिहास (History) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:12:history` |
| 10 | कक्षा 12 | राजनीति विज्ञान (Political Science) | थ्योरी | 2 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:12:political-science` |
| 11 | कक्षा 12 | भूगोल (Geography) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:12:geography` |
| 12 | कक्षा 12 | समाजशास्त्र (Sociology) | थ्योरी | 2 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:12:sociology` |
| 13 | कक्षा 12 | मनोविज्ञान (Psychology) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:12:psychology` |
| 14 | कक्षा 12 | अर्थशास्त्र (Economics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:12:economics` |
| 15 | कक्षा 12 | हिंदी (Hindi) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:12:hindi` |
| 16 | कक्षा 12 | अंग्रेज़ी (कोर) (English (Core)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:class-11-12-arts:12:english-core` |

### आईटीआई

#### आईटीआई — फ़िटर / टर्नर / मशीनिस्ट / वेल्डर / मैकेनिक (डीज़ल, मोटर व्हीकल) — ITI — Fitter / Turner / Machinist / Welder / Mechanic (Diesel, Motor Vehicle) (10 किताबें · प्रोफ़ाइल: iti-trade, lab-manual)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | ट्रेड थ्योरी (फ़िटर / मैकेनिकल ट्रेड) (Trade Theory (Fitter / Mechanical trades)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:iti-mechanical:1:trade-theory-fitter-mechanical-trades` |
| 2 | वर्ष 1 | ट्रेड प्रैक्टिकल (फ़िटर / मैकेनिकल ट्रेड) (Trade Practical (Fitter / Mechanical trades)) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:iti-mechanical:1:trade-practical-fitter-mechanical-trades` |
| 3 | वर्ष 1 | वर्कशॉप गणना एवं विज्ञान (Workshop Calculation & Science) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:iti-mechanical:1:workshop-calculation-science` |
| 4 | वर्ष 1 | इंजीनियरिंग ड्रॉइंग (Engineering Drawing) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:iti-mechanical:1:engineering-drawing` |
| 5 | वर्ष 1 | रोज़गार कौशल (Employability Skills) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:iti-mechanical:1:employability-skills` |
| 6 | वर्ष 2 | ट्रेड थ्योरी - II (फ़िटर / मैकेनिकल ट्रेड) (Trade Theory - II (Fitter / Mechanical trades)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:iti-mechanical:2:trade-theory-ii-fitter-mechanical-trades` |
| 7 | वर्ष 2 | ट्रेड प्रैक्टिकल - II (फ़िटर / मैकेनिकल ट्रेड) (Trade Practical - II (Fitter / Mechanical trades)) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:iti-mechanical:2:trade-practical-ii-fitter-mechanical-trades` |
| 8 | वर्ष 2 | वर्कशॉप गणना एवं विज्ञान (Workshop Calculation & Science) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:iti-mechanical:2:workshop-calculation-science` |
| 9 | वर्ष 2 | इंजीनियरिंग ड्रॉइंग (Engineering Drawing) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:iti-mechanical:2:engineering-drawing` |
| 10 | वर्ष 2 | रोज़गार कौशल (Employability Skills) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:iti-mechanical:2:employability-skills` |

#### आईटीआई — इलेक्ट्रीशियन / वायरमैन / इलेक्ट्रॉनिक्स मैकेनिक — ITI — Electrician / Wireman / Electronics Mechanic (10 किताबें · प्रोफ़ाइल: iti-trade, lab-manual)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | ट्रेड थ्योरी (इलेक्ट्रीशियन / इलेक्ट्रिकल ट्रेड) (Trade Theory (Electrician / Electrical trades)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:iti-electrical:1:trade-theory-electrician-electrical-trades` |
| 2 | वर्ष 1 | ट्रेड प्रैक्टिकल (इलेक्ट्रीशियन / इलेक्ट्रिकल ट्रेड) (Trade Practical (Electrician / Electrical trades)) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:iti-electrical:1:trade-practical-electrician-electrical-trades` |
| 3 | वर्ष 1 | वर्कशॉप गणना एवं विज्ञान (Workshop Calculation & Science) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:iti-electrical:1:workshop-calculation-science` |
| 4 | वर्ष 1 | इंजीनियरिंग ड्रॉइंग (Engineering Drawing) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:iti-electrical:1:engineering-drawing` |
| 5 | वर्ष 1 | रोज़गार कौशल (Employability Skills) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:iti-electrical:1:employability-skills` |
| 6 | वर्ष 2 | ट्रेड थ्योरी - II (इलेक्ट्रीशियन / इलेक्ट्रिकल ट्रेड) (Trade Theory - II (Electrician / Electrical trades)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:iti-electrical:2:trade-theory-ii-electrician-electrical-trades` |
| 7 | वर्ष 2 | ट्रेड प्रैक्टिकल - II (इलेक्ट्रीशियन / इलेक्ट्रिकल ट्रेड) (Trade Practical - II (Electrician / Electrical trades)) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:iti-electrical:2:trade-practical-ii-electrician-electrical-trades` |
| 8 | वर्ष 2 | वर्कशॉप गणना एवं विज्ञान (Workshop Calculation & Science) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:iti-electrical:2:workshop-calculation-science` |
| 9 | वर्ष 2 | इंजीनियरिंग ड्रॉइंग (Engineering Drawing) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:iti-electrical:2:engineering-drawing` |
| 10 | वर्ष 2 | रोज़गार कौशल (Employability Skills) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:iti-electrical:2:employability-skills` |

#### आईटीआई — कोपा (कंप्यूटर ऑपरेटर) — ITI — COPA (Computer Operator) (4 किताबें · प्रोफ़ाइल: iti-trade, lab-manual)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | ट्रेड थ्योरी (कोपा) (Trade Theory (COPA)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:iti-copa:1:trade-theory-copa` |
| 2 | वर्ष 1 | ट्रेड प्रैक्टिकल (कोपा: ऑफ़िस टूल, इंटरनेट, प्रोग्रामिंग) (Trade Practical (COPA: Office tools, Internet, Programming basics)) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:iti-copa:1:trade-practical-copa-office-tools-internet-programming-basic` |
| 3 | वर्ष 1 | कंप्यूटर के मूल सिद्धांत (Computer Fundamentals) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:iti-copa:1:computer-fundamentals` |
| 4 | वर्ष 1 | रोज़गार कौशल (Employability Skills) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:iti-copa:1:employability-skills` |

### डिप्लोमा

#### डिप्लोमा इन मैकेनिकल इंजीनियरिंग — Diploma in Mechanical Engineering (39 किताबें · प्रोफ़ाइल: diploma-theory, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | सेमेस्टर 1 | गणित-I (Mathematics-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:1:mathematics-i` |
| 2 | सेमेस्टर 1 | अनुप्रयुक्त भौतिकी-I (Applied Physics-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:1:applied-physics-i` |
| 3 | सेमेस्टर 1 | अनुप्रयुक्त रसायन (Applied Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:1:applied-chemistry` |
| 4 | सेमेस्टर 1 | अंग्रेज़ी संचार कौशल (Communication Skills in English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:1:communication-skills-in-english` |
| 5 | सेमेस्टर 1 | इंजीनियरिंग ग्राफ़िक्स (Engineering Graphics) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:1:engineering-graphics` |
| 6 | सेमेस्टर 1 | इंजीनियरिंग वर्कशॉप अभ्यास (Engineering Workshop Practice) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:1:engineering-workshop-practice` |
| 7 | सेमेस्टर 1 | खेल और योग (Sports and Yoga) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:1:sports-and-yoga` |
| 8 | सेमेस्टर 2 | गणित-II (Mathematics-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:2:mathematics-ii` |
| 9 | सेमेस्टर 2 | अनुप्रयुक्त भौतिकी-II (Applied Physics-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:2:applied-physics-ii` |
| 10 | सेमेस्टर 2 | आईटी सिस्टम का परिचय (Introduction to IT Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:2:introduction-to-it-systems` |
| 11 | सेमेस्टर 2 | विद्युत एवं इलेक्ट्रॉनिक्स इंजीनियरिंग के मूल सिद्धांत (Fundamentals of Electrical & Electronics Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:2:fundamentals-of-electrical-electronics-engineering` |
| 12 | सेमेस्टर 2 | इंजीनियरिंग मैकेनिक्स (Engineering Mechanics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:2:engineering-mechanics` |
| 13 | सेमेस्टर 2 | पर्यावरण विज्ञान (Environmental Science) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:2:environmental-science` |
| 14 | सेमेस्टर 2 | इंजीनियरिंग वर्कशॉप अभ्यास-II (Engineering Workshop Practice-II) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:2:engineering-workshop-practice-ii` |
| 15 | सेमेस्टर 3 | पदार्थों की सामर्थ्य (Strength of Materials) | थ्योरी | 6 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:3:strength-of-materials` |
| 16 | सेमेस्टर 3 | थर्मल इंजीनियरिंग-I (ऊष्मागतिकी) (Thermal Engineering-I (Thermodynamics)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:3:thermal-engineering-i-thermodynamics` |
| 17 | सेमेस्टर 3 | विनिर्माण प्रक्रियाएँ (Manufacturing Processes) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:3:manufacturing-processes` |
| 18 | सेमेस्टर 3 | इंजीनियरिंग सामग्री एवं धातुकर्म (Engineering Materials & Metallurgy) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:3:engineering-materials-metallurgy` |
| 19 | सेमेस्टर 3 | मशीन ड्रॉइंग और CAD (Machine Drawing & CAD) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:3:machine-drawing-cad` |
| 20 | सेमेस्टर 3 | बेसिक इलेक्ट्रिकल एवं इलेक्ट्रॉनिक्स लैब (Basic Electrical & Electronics Lab) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:3:basic-electrical-electronics-lab` |
| 21 | सेमेस्टर 4 | मशीनों का सिद्धांत (Theory of Machines) | थ्योरी | 6 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:4:theory-of-machines` |
| 22 | सेमेस्टर 4 | द्रव यांत्रिकी एवं हाइड्रॉलिक मशीनें (Fluid Mechanics & Hydraulic Machines) | थ्योरी | 6 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:4:fluid-mechanics-hydraulic-machines` |
| 23 | सेमेस्टर 4 | थर्मल इंजीनियरिंग-II (भाप, बॉयलर, टरबाइन और पावर प्लांट) (Thermal Engineering-II (Steam, Boilers, Turbines & Power Plants)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:4:thermal-engineering-ii-steam-boilers-turbines-power-plants` |
| 24 | सेमेस्टर 4 | उत्पादन प्रौद्योगिकी (मशीन औज़ार) (Production Technology (Machine Tools)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:4:production-technology-machine-tools` |
| 25 | सेमेस्टर 4 | मापिकी और मापन (Metrology & Measurements) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:4:metrology-measurements` |
| 26 | सेमेस्टर 4 | भारतीय ज्ञान परंपरा का सार (Essence of Indian Knowledge & Tradition) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:4:essence-of-indian-knowledge-tradition` |
| 27 | सेमेस्टर 5 | मशीन अवयवों का डिज़ाइन (Design of Machine Elements) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:5:design-of-machine-elements` |
| 28 | सेमेस्टर 5 | पावर इंजीनियरिंग (IC इंजन, वायु संपीडक, गैस टरबाइन) (Power Engineering (IC Engines, Air Compressors, Gas Turbines)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:5:power-engineering-ic-engines-air-compressors-gas-turbines` |
| 29 | सेमेस्टर 5 | ऊष्मा-स्थानांतरण, प्रशीतन और वातानुकूलन (Heat Transfer, Refrigeration & Air Conditioning) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:5:heat-transfer-refrigeration-air-conditioning` |
| 30 | सेमेस्टर 5 | उन्नत विनिर्माण प्रक्रियाएँ (Advanced Manufacturing Processes) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:5:advanced-manufacturing-processes` |
| 31 | सेमेस्टर 5 | ऐच्छिक-I: ऑटोमोबाइल इंजीनियरिंग / टूल इंजीनियरिंग (Elective-I: Automobile Engineering / Tool Engineering) | ऐच्छिक (इलेक्टिव) | 4 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:5:elective-i-automobile-engineering-tool-engineering` |
| 32 | सेमेस्टर 5 | समर इंटर्नशिप (Summer Internship) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-mechanical:5:summer-internship` |
| 33 | सेमेस्टर 6 | औद्योगिक अभियांत्रिकी एवं प्रबंधन (Industrial Engineering & Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:6:industrial-engineering-management` |
| 34 | सेमेस्टर 6 | CAD/CAM और ऑटोमेशन (CAD/CAM & Automation) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:6:cad-cam-automation` |
| 35 | सेमेस्टर 6 | रखरखाव एवं संयंत्र इंजीनियरिंग (Maintenance & Plant Engineering) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:6:maintenance-plant-engineering` |
| 36 | सेमेस्टर 6 | उद्यमिता और स्टार्ट-अप (Entrepreneurship & Start-ups) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:6:entrepreneurship-start-ups` |
| 37 | सेमेस्टर 6 | ऐच्छिक-II: मेकाट्रॉनिक्स / नवीकरणीय ऊर्जा (Elective-II: Mechatronics / Renewable Energy) | ऐच्छिक (इलेक्टिव) | 4 | 📗 पाठ्यपुस्तक | `c:diploma-mechanical:6:elective-ii-mechatronics-renewable-energy` |
| 38 | सेमेस्टर 6 | मुख्य परियोजना (Major Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-mechanical:6:major-project` |
| 39 | सेमेस्टर 6 | सेमिनार (Seminar) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-mechanical:6:seminar` |

#### डिप्लोमा इन सिविल इंजीनियरिंग — Diploma in Civil Engineering (41 किताबें · प्रोफ़ाइल: diploma-theory, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | सेमेस्टर 1 | गणित-I (Mathematics-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:1:mathematics-i` |
| 2 | सेमेस्टर 1 | अनुप्रयुक्त भौतिकी-I (Applied Physics-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:1:applied-physics-i` |
| 3 | सेमेस्टर 1 | अनुप्रयुक्त रसायन (Applied Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:1:applied-chemistry` |
| 4 | सेमेस्टर 1 | अंग्रेज़ी संचार कौशल (Communication Skills in English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:1:communication-skills-in-english` |
| 5 | सेमेस्टर 1 | इंजीनियरिंग ग्राफ़िक्स (Engineering Graphics) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-civil:1:engineering-graphics` |
| 6 | सेमेस्टर 1 | इंजीनियरिंग वर्कशॉप अभ्यास (Engineering Workshop Practice) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-civil:1:engineering-workshop-practice` |
| 7 | सेमेस्टर 1 | खेल और योग (Sports and Yoga) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-civil:1:sports-and-yoga` |
| 8 | सेमेस्टर 2 | गणित-II (Mathematics-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:2:mathematics-ii` |
| 9 | सेमेस्टर 2 | अनुप्रयुक्त भौतिकी-II (Applied Physics-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:2:applied-physics-ii` |
| 10 | सेमेस्टर 2 | आईटी सिस्टम का परिचय (Introduction to IT Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:2:introduction-to-it-systems` |
| 11 | सेमेस्टर 2 | विद्युत एवं इलेक्ट्रॉनिक्स इंजीनियरिंग के मूल सिद्धांत (Fundamentals of Electrical & Electronics Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:2:fundamentals-of-electrical-electronics-engineering` |
| 12 | सेमेस्टर 2 | इंजीनियरिंग मैकेनिक्स (Engineering Mechanics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:2:engineering-mechanics` |
| 13 | सेमेस्टर 2 | पर्यावरण विज्ञान (Environmental Science) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:2:environmental-science` |
| 14 | सेमेस्टर 2 | इंजीनियरिंग वर्कशॉप अभ्यास-II (Engineering Workshop Practice-II) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-civil:2:engineering-workshop-practice-ii` |
| 15 | सेमेस्टर 3 | भवन सामग्री (Building Materials) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:3:building-materials` |
| 16 | सेमेस्टर 3 | भवन निर्माण (Building Construction) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:3:building-construction` |
| 17 | सेमेस्टर 3 | सर्वेक्षण-I (Surveying-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:3:surveying-i` |
| 18 | सेमेस्टर 3 | पदार्थों की यांत्रिकी (Mechanics of Materials) | थ्योरी | 6 | 📗 पाठ्यपुस्तक | `c:diploma-civil:3:mechanics-of-materials` |
| 19 | सेमेस्टर 3 | कंक्रीट प्रौद्योगिकी (Concrete Technology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:3:concrete-technology` |
| 20 | सेमेस्टर 3 | हाइड्रॉलिक्स (Hydraulics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:3:hydraulics` |
| 21 | सेमेस्टर 3 | सर्वेक्षण अभ्यास-I (Surveying Practice-I) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-civil:3:surveying-practice-i` |
| 22 | सेमेस्टर 4 | सर्वेक्षण-II (Surveying-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:4:surveying-ii` |
| 23 | सेमेस्टर 4 | संरचनाओं का सिद्धांत (Theory of Structures) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:4:theory-of-structures` |
| 24 | सेमेस्टर 4 | राजमार्ग इंजीनियरिंग (Highway Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:4:highway-engineering` |
| 25 | सेमेस्टर 4 | सिंचाई इंजीनियरिंग (Irrigation Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:4:irrigation-engineering` |
| 26 | सेमेस्टर 4 | मृदा यांत्रिकी और नींव (Soil Mechanics & Foundation) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:4:soil-mechanics-foundation` |
| 27 | सेमेस्टर 4 | भवन योजना और ड्रॉइंग (Building Planning & Drawing) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-civil:4:building-planning-drawing` |
| 28 | सेमेस्टर 4 | सर्वेक्षण अभ्यास-II (Surveying Practice-II) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-civil:4:surveying-practice-ii` |
| 29 | सेमेस्टर 5 | RCC संरचनाओं का डिज़ाइन (Design of RCC Structures) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:5:design-of-rcc-structures` |
| 30 | सेमेस्टर 5 | आकलन और लागत (Estimating & Costing) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:5:estimating-costing` |
| 31 | सेमेस्टर 5 | जल आपूर्ति और स्वच्छता इंजीनियरिंग (Water Supply & Sanitary Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:5:water-supply-sanitary-engineering` |
| 32 | सेमेस्टर 5 | रेलवे, पुल और सुरंग इंजीनियरिंग (Railway, Bridge & Tunnel Engineering) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-civil:5:railway-bridge-tunnel-engineering` |
| 33 | सेमेस्टर 5 | ऐच्छिक-I: भूकंपरोधी निर्माण / ग्रीन बिल्डिंग (Elective-I: Earthquake Resistant Construction / Green Building) | ऐच्छिक (इलेक्टिव) | 3 | 📗 पाठ्यपुस्तक | `c:diploma-civil:5:elective-i-earthquake-resistant-construction-green-building` |
| 34 | सेमेस्टर 5 | उन्नत सर्वेक्षण (टोटल स्टेशन, GPS) (Advanced Surveying (Total Station, GPS)) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-civil:5:advanced-surveying-total-station-gps` |
| 35 | सेमेस्टर 5 | समर इंटर्नशिप (Summer Internship) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-civil:5:summer-internship` |
| 36 | सेमेस्टर 6 | स्टील संरचनाओं का डिज़ाइन (Design of Steel Structures) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:6:design-of-steel-structures` |
| 37 | सेमेस्टर 6 | निर्माण प्रबंधन (Construction Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-civil:6:construction-management` |
| 38 | सेमेस्टर 6 | मात्रा सर्वेक्षण और मूल्यांकन (Quantity Surveying & Valuation) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-civil:6:quantity-surveying-valuation` |
| 39 | सेमेस्टर 6 | उन्नत निर्माण प्रौद्योगिकी (Advanced Construction Technology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-civil:6:advanced-construction-technology` |
| 40 | सेमेस्टर 6 | ऐच्छिक-II: संरचनाओं की मरम्मत एवं पुनर्वास / ठोस अपशिष्ट प्रबंधन (Elective-II: Repair & Rehabilitation of Structures / Solid Waste Management) | ऐच्छिक (इलेक्टिव) | 3 | 📗 पाठ्यपुस्तक | `c:diploma-civil:6:elective-ii-repair-rehabilitation-of-structures-solid-waste` |
| 41 | सेमेस्टर 6 | मुख्य परियोजना (Major Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-civil:6:major-project` |

#### डिप्लोमा इन इलेक्ट्रिकल इंजीनियरिंग — Diploma in Electrical Engineering (37 किताबें · प्रोफ़ाइल: diploma-theory, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | सेमेस्टर 1 | गणित-I (Mathematics-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:1:mathematics-i` |
| 2 | सेमेस्टर 1 | अनुप्रयुक्त भौतिकी-I (Applied Physics-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:1:applied-physics-i` |
| 3 | सेमेस्टर 1 | अनुप्रयुक्त रसायन (Applied Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:1:applied-chemistry` |
| 4 | सेमेस्टर 1 | अंग्रेज़ी संचार कौशल (Communication Skills in English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:1:communication-skills-in-english` |
| 5 | सेमेस्टर 1 | इंजीनियरिंग ग्राफ़िक्स (Engineering Graphics) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-electrical:1:engineering-graphics` |
| 6 | सेमेस्टर 1 | इंजीनियरिंग वर्कशॉप अभ्यास (Engineering Workshop Practice) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-electrical:1:engineering-workshop-practice` |
| 7 | सेमेस्टर 1 | खेल और योग (Sports and Yoga) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-electrical:1:sports-and-yoga` |
| 8 | सेमेस्टर 2 | गणित-II (Mathematics-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:2:mathematics-ii` |
| 9 | सेमेस्टर 2 | अनुप्रयुक्त भौतिकी-II (Applied Physics-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:2:applied-physics-ii` |
| 10 | सेमेस्टर 2 | आईटी सिस्टम का परिचय (Introduction to IT Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:2:introduction-to-it-systems` |
| 11 | सेमेस्टर 2 | विद्युत एवं इलेक्ट्रॉनिक्स इंजीनियरिंग के मूल सिद्धांत (Fundamentals of Electrical & Electronics Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:2:fundamentals-of-electrical-electronics-engineering` |
| 12 | सेमेस्टर 2 | इंजीनियरिंग मैकेनिक्स (Engineering Mechanics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:2:engineering-mechanics` |
| 13 | सेमेस्टर 2 | पर्यावरण विज्ञान (Environmental Science) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:2:environmental-science` |
| 14 | सेमेस्टर 2 | इंजीनियरिंग वर्कशॉप अभ्यास-II (Engineering Workshop Practice-II) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-electrical:2:engineering-workshop-practice-ii` |
| 15 | सेमेस्टर 3 | विद्युत परिपथ (Electrical Circuits) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:3:electrical-circuits` |
| 16 | सेमेस्टर 3 | विद्युत एवं इलेक्ट्रॉनिक मापन (Electrical & Electronic Measurements) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:3:electrical-electronic-measurements` |
| 17 | सेमेस्टर 3 | विद्युत शक्ति उत्पादन (Electrical Power Generation) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:3:electrical-power-generation` |
| 18 | सेमेस्टर 3 | बेसिक इलेक्ट्रॉनिक्स (Basic Electronics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:3:basic-electronics` |
| 19 | सेमेस्टर 3 | विद्युत इंजीनियरिंग सामग्री (Electrical Engineering Materials) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:3:electrical-engineering-materials` |
| 20 | सेमेस्टर 3 | इलेक्ट्रिकल वर्कशॉप (Electrical Workshop) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-electrical:3:electrical-workshop` |
| 21 | सेमेस्टर 4 | विद्युत मशीनें-I (DC मशीन और ट्रांसफ़ॉर्मर) (Electrical Machines-I (DC Machines & Transformers)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:4:electrical-machines-i-dc-machines-transformers` |
| 22 | सेमेस्टर 4 | संचरण और वितरण (Transmission & Distribution) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:4:transmission-distribution` |
| 23 | सेमेस्टर 4 | डिजिटल इलेक्ट्रॉनिक्स (Digital Electronics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:4:digital-electronics` |
| 24 | सेमेस्टर 4 | पावर इलेक्ट्रॉनिक्स (Power Electronics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:4:power-electronics` |
| 25 | सेमेस्टर 4 | इलेक्ट्रिकल ड्रॉइंग और CAD (Electrical Drawing & CAD) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-electrical:4:electrical-drawing-cad` |
| 26 | सेमेस्टर 5 | विद्युत मशीनें-II (AC मशीनें) (Electrical Machines-II (AC Machines)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:5:electrical-machines-ii-ac-machines` |
| 27 | सेमेस्टर 5 | स्विचगियर और सुरक्षा (Switchgear & Protection) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:5:switchgear-protection` |
| 28 | सेमेस्टर 5 | विद्युत ऊर्जा का उपयोग (Utilisation of Electrical Energy) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:5:utilisation-of-electrical-energy` |
| 29 | सेमेस्टर 5 | माइक्रोकंट्रोलर और PLC (Microcontrollers & PLC) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:5:microcontrollers-plc` |
| 30 | सेमेस्टर 5 | औद्योगिक ड्राइव (Industrial Drives) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:5:industrial-drives` |
| 31 | सेमेस्टर 5 | समर इंटर्नशिप (Summer Internship) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-electrical:5:summer-internship` |
| 32 | सेमेस्टर 6 | विद्युत संस्थापन, आकलन और लागत (Electrical Installation, Estimating & Costing) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:6:electrical-installation-estimating-costing` |
| 33 | सेमेस्टर 6 | नवीकरणीय ऊर्जा और ऊर्जा संरक्षण (Renewable Energy & Energy Conservation) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:6:renewable-energy-energy-conservation` |
| 34 | सेमेस्टर 6 | विद्युत कर्षण और इलेक्ट्रिक वाहन (Electric Traction & Electric Vehicles) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:6:electric-traction-electric-vehicles` |
| 35 | सेमेस्टर 6 | ऐच्छिक: नियंत्रण प्रणाली / औद्योगिक ऑटोमेशन एवं SCADA (Elective: Control Systems / Industrial Automation & SCADA) | ऐच्छिक (इलेक्टिव) | 4 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:6:elective-control-systems-industrial-automation-scada` |
| 36 | सेमेस्टर 6 | उद्यमिता और स्टार्ट-अप (Entrepreneurship & Start-ups) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-electrical:6:entrepreneurship-start-ups` |
| 37 | सेमेस्टर 6 | मुख्य परियोजना (Major Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-electrical:6:major-project` |

#### डिप्लोमा इन इलेक्ट्रॉनिक्स एवं संचार इंजीनियरिंग — Diploma in Electronics & Communication Engineering (37 किताबें · प्रोफ़ाइल: diploma-theory, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | सेमेस्टर 1 | गणित-I (Mathematics-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:1:mathematics-i` |
| 2 | सेमेस्टर 1 | अनुप्रयुक्त भौतिकी-I (Applied Physics-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:1:applied-physics-i` |
| 3 | सेमेस्टर 1 | अनुप्रयुक्त रसायन (Applied Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:1:applied-chemistry` |
| 4 | सेमेस्टर 1 | अंग्रेज़ी संचार कौशल (Communication Skills in English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:1:communication-skills-in-english` |
| 5 | सेमेस्टर 1 | इंजीनियरिंग ग्राफ़िक्स (Engineering Graphics) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-electronics:1:engineering-graphics` |
| 6 | सेमेस्टर 1 | इंजीनियरिंग वर्कशॉप अभ्यास (Engineering Workshop Practice) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-electronics:1:engineering-workshop-practice` |
| 7 | सेमेस्टर 1 | खेल और योग (Sports and Yoga) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-electronics:1:sports-and-yoga` |
| 8 | सेमेस्टर 2 | गणित-II (Mathematics-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:2:mathematics-ii` |
| 9 | सेमेस्टर 2 | अनुप्रयुक्त भौतिकी-II (Applied Physics-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:2:applied-physics-ii` |
| 10 | सेमेस्टर 2 | आईटी सिस्टम का परिचय (Introduction to IT Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:2:introduction-to-it-systems` |
| 11 | सेमेस्टर 2 | विद्युत एवं इलेक्ट्रॉनिक्स इंजीनियरिंग के मूल सिद्धांत (Fundamentals of Electrical & Electronics Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:2:fundamentals-of-electrical-electronics-engineering` |
| 12 | सेमेस्टर 2 | इंजीनियरिंग मैकेनिक्स (Engineering Mechanics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:2:engineering-mechanics` |
| 13 | सेमेस्टर 2 | पर्यावरण विज्ञान (Environmental Science) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:2:environmental-science` |
| 14 | सेमेस्टर 2 | इंजीनियरिंग वर्कशॉप अभ्यास-II (Engineering Workshop Practice-II) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-electronics:2:engineering-workshop-practice-ii` |
| 15 | सेमेस्टर 3 | इलेक्ट्रॉनिक उपकरण और परिपथ (Electronic Devices & Circuits) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:3:electronic-devices-circuits` |
| 16 | सेमेस्टर 3 | डिजिटल इलेक्ट्रॉनिक्स (Digital Electronics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:3:digital-electronics` |
| 17 | सेमेस्टर 3 | विद्युत परिपथ और नेटवर्क (Electric Circuits & Networks) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:3:electric-circuits-networks` |
| 18 | सेमेस्टर 3 | इलेक्ट्रॉनिक मापन और उपकरण (Electronic Measurements & Instrumentation) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:3:electronic-measurements-instrumentation` |
| 19 | सेमेस्टर 3 | इलेक्ट्रॉनिक संचार के सिद्धांत (Principles of Electronic Communication) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:3:principles-of-electronic-communication` |
| 20 | सेमेस्टर 3 | इलेक्ट्रॉनिक्स वर्कशॉप (Electronics Workshop) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-electronics:3:electronics-workshop` |
| 21 | सेमेस्टर 4 | रैखिक एकीकृत परिपथ (Linear Integrated Circuits) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:4:linear-integrated-circuits` |
| 22 | सेमेस्टर 4 | माइक्रोकंट्रोलर (Microcontrollers) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:4:microcontrollers` |
| 23 | सेमेस्टर 4 | एनालॉग संचार (Analog Communication) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:4:analog-communication` |
| 24 | सेमेस्टर 4 | उपभोक्ता इलेक्ट्रॉनिक्स (Consumer Electronics) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:4:consumer-electronics` |
| 25 | सेमेस्टर 4 | इलेक्ट्रॉनिक परिपथ डिज़ाइन और सिमुलेशन (Electronic Circuit Design & Simulation) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-electronics:4:electronic-circuit-design-simulation` |
| 26 | सेमेस्टर 5 | डिजिटल संचार (Digital Communication) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:5:digital-communication` |
| 27 | सेमेस्टर 5 | एम्बेडेड सिस्टम (Embedded Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:5:embedded-systems` |
| 28 | सेमेस्टर 5 | ऑप्टिकल फ़ाइबर संचार (Optical Fibre Communication) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:5:optical-fibre-communication` |
| 29 | सेमेस्टर 5 | औद्योगिक इलेक्ट्रॉनिक्स (Industrial Electronics) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:5:industrial-electronics` |
| 30 | सेमेस्टर 5 | माइक्रोवेव और रडार (Microwave & Radar) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:5:microwave-radar` |
| 31 | सेमेस्टर 5 | समर इंटर्नशिप (Summer Internship) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-electronics:5:summer-internship` |
| 32 | सेमेस्टर 6 | मोबाइल और वायरलेस संचार (Mobile & Wireless Communication) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:6:mobile-wireless-communication` |
| 33 | सेमेस्टर 6 | कंप्यूटर नेटवर्क (Computer Networks) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:6:computer-networks` |
| 34 | सेमेस्टर 6 | VLSI के मूल सिद्धांत (Basics of VLSI) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:6:basics-of-vlsi` |
| 35 | सेमेस्टर 6 | ऐच्छिक: इंटरनेट ऑफ़ थिंग्स / बायोमेडिकल इलेक्ट्रॉनिक्स (Elective: Internet of Things / Biomedical Electronics) | ऐच्छिक (इलेक्टिव) | 4 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:6:elective-internet-of-things-biomedical-electronics` |
| 36 | सेमेस्टर 6 | उद्यमिता और स्टार्ट-अप (Entrepreneurship & Start-ups) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-electronics:6:entrepreneurship-start-ups` |
| 37 | सेमेस्टर 6 | मुख्य परियोजना (Major Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-electronics:6:major-project` |

#### डिप्लोमा इन कंप्यूटर साइंस इंजीनियरिंग — Diploma in Computer Science Engineering (36 किताबें · प्रोफ़ाइल: diploma-theory, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | सेमेस्टर 1 | गणित-I (Mathematics-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:1:mathematics-i` |
| 2 | सेमेस्टर 1 | अनुप्रयुक्त भौतिकी-I (Applied Physics-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:1:applied-physics-i` |
| 3 | सेमेस्टर 1 | अनुप्रयुक्त रसायन (Applied Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:1:applied-chemistry` |
| 4 | सेमेस्टर 1 | अंग्रेज़ी संचार कौशल (Communication Skills in English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:1:communication-skills-in-english` |
| 5 | सेमेस्टर 1 | इंजीनियरिंग ग्राफ़िक्स (Engineering Graphics) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-computer:1:engineering-graphics` |
| 6 | सेमेस्टर 1 | इंजीनियरिंग वर्कशॉप अभ्यास (Engineering Workshop Practice) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-computer:1:engineering-workshop-practice` |
| 7 | सेमेस्टर 1 | खेल और योग (Sports and Yoga) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-computer:1:sports-and-yoga` |
| 8 | सेमेस्टर 2 | गणित-II (Mathematics-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:2:mathematics-ii` |
| 9 | सेमेस्टर 2 | अनुप्रयुक्त भौतिकी-II (Applied Physics-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:2:applied-physics-ii` |
| 10 | सेमेस्टर 2 | आईटी सिस्टम का परिचय (Introduction to IT Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:2:introduction-to-it-systems` |
| 11 | सेमेस्टर 2 | विद्युत एवं इलेक्ट्रॉनिक्स इंजीनियरिंग के मूल सिद्धांत (Fundamentals of Electrical & Electronics Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:2:fundamentals-of-electrical-electronics-engineering` |
| 12 | सेमेस्टर 2 | इंजीनियरिंग मैकेनिक्स (Engineering Mechanics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:2:engineering-mechanics` |
| 13 | सेमेस्टर 2 | पर्यावरण विज्ञान (Environmental Science) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:2:environmental-science` |
| 14 | सेमेस्टर 2 | इंजीनियरिंग वर्कशॉप अभ्यास-II (Engineering Workshop Practice-II) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-computer:2:engineering-workshop-practice-ii` |
| 15 | सेमेस्टर 3 | डेटा संरचना (Data Structures) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:3:data-structures` |
| 16 | सेमेस्टर 3 | C++ के साथ ऑब्जेक्ट ओरिएंटेड प्रोग्रामिंग (Object Oriented Programming with C++) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:3:object-oriented-programming-with-c` |
| 17 | सेमेस्टर 3 | डिजिटल इलेक्ट्रॉनिक्स (Digital Electronics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:3:digital-electronics` |
| 18 | सेमेस्टर 3 | डेटाबेस प्रबंधन प्रणाली (Database Management Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:3:database-management-systems` |
| 19 | सेमेस्टर 3 | कंप्यूटर सिस्टम संगठन (Computer System Organisation) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:3:computer-system-organisation` |
| 20 | सेमेस्टर 3 | प्रोग्रामिंग लैब (C++ एवं DBMS) (Programming Lab (C++ & DBMS)) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-computer:3:programming-lab-c-dbms` |
| 21 | सेमेस्टर 4 | जावा प्रोग्रामिंग (Java Programming) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:4:java-programming` |
| 22 | सेमेस्टर 4 | ऑपरेटिंग सिस्टम (Operating Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:4:operating-systems` |
| 23 | सेमेस्टर 4 | कंप्यूटर नेटवर्क (Computer Networks) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:4:computer-networks` |
| 24 | सेमेस्टर 4 | सॉफ़्टवेयर इंजीनियरिंग (Software Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:4:software-engineering` |
| 25 | सेमेस्टर 4 | वेब तकनीकें (Web Technologies) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-computer:4:web-technologies` |
| 26 | सेमेस्टर 5 | पायथन प्रोग्रामिंग (Python Programming) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:5:python-programming` |
| 27 | सेमेस्टर 5 | उन्नत वेब विकास (Advanced Web Development) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-computer:5:advanced-web-development` |
| 28 | सेमेस्टर 5 | क्लाउड कंप्यूटिंग (Cloud Computing) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-computer:5:cloud-computing` |
| 29 | सेमेस्टर 5 | सूचना सुरक्षा (Information Security) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:5:information-security` |
| 30 | सेमेस्टर 5 | समर इंटर्नशिप (Summer Internship) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-computer:5:summer-internship` |
| 31 | सेमेस्टर 6 | मोबाइल ऐप विकास (Mobile Application Development) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:6:mobile-application-development` |
| 32 | सेमेस्टर 6 | AI और मशीन लर्निंग के मूल सिद्धांत (Basics of AI & Machine Learning) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-computer:6:basics-of-ai-machine-learning` |
| 33 | सेमेस्टर 6 | नेटवर्क सुरक्षा (Network Security) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-computer:6:network-security` |
| 34 | सेमेस्टर 6 | ऐच्छिक: इंटरनेट ऑफ़ थिंग्स / डेटा एनालिटिक्स (Elective: Internet of Things / Data Analytics) | ऐच्छिक (इलेक्टिव) | 4 | 📗 पाठ्यपुस्तक | `c:diploma-computer:6:elective-internet-of-things-data-analytics` |
| 35 | सेमेस्टर 6 | उद्यमिता और स्टार्ट-अप (Entrepreneurship & Start-ups) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-computer:6:entrepreneurship-start-ups` |
| 36 | सेमेस्टर 6 | मुख्य परियोजना (Major Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-computer:6:major-project` |

#### डिप्लोमा इन ऑटोमोबाइल इंजीनियरिंग — Diploma in Automobile Engineering (38 किताबें · प्रोफ़ाइल: diploma-theory, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | सेमेस्टर 1 | गणित-I (Mathematics-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:1:mathematics-i` |
| 2 | सेमेस्टर 1 | अनुप्रयुक्त भौतिकी-I (Applied Physics-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:1:applied-physics-i` |
| 3 | सेमेस्टर 1 | अनुप्रयुक्त रसायन (Applied Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:1:applied-chemistry` |
| 4 | सेमेस्टर 1 | अंग्रेज़ी संचार कौशल (Communication Skills in English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:1:communication-skills-in-english` |
| 5 | सेमेस्टर 1 | इंजीनियरिंग ग्राफ़िक्स (Engineering Graphics) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-automobile:1:engineering-graphics` |
| 6 | सेमेस्टर 1 | इंजीनियरिंग वर्कशॉप अभ्यास (Engineering Workshop Practice) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-automobile:1:engineering-workshop-practice` |
| 7 | सेमेस्टर 1 | खेल और योग (Sports and Yoga) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-automobile:1:sports-and-yoga` |
| 8 | सेमेस्टर 2 | गणित-II (Mathematics-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:2:mathematics-ii` |
| 9 | सेमेस्टर 2 | अनुप्रयुक्त भौतिकी-II (Applied Physics-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:2:applied-physics-ii` |
| 10 | सेमेस्टर 2 | आईटी सिस्टम का परिचय (Introduction to IT Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:2:introduction-to-it-systems` |
| 11 | सेमेस्टर 2 | विद्युत एवं इलेक्ट्रॉनिक्स इंजीनियरिंग के मूल सिद्धांत (Fundamentals of Electrical & Electronics Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:2:fundamentals-of-electrical-electronics-engineering` |
| 12 | सेमेस्टर 2 | इंजीनियरिंग मैकेनिक्स (Engineering Mechanics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:2:engineering-mechanics` |
| 13 | सेमेस्टर 2 | पर्यावरण विज्ञान (Environmental Science) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:2:environmental-science` |
| 14 | सेमेस्टर 2 | इंजीनियरिंग वर्कशॉप अभ्यास-II (Engineering Workshop Practice-II) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-automobile:2:engineering-workshop-practice-ii` |
| 15 | सेमेस्टर 3 | ऑटोमोबाइल इंजन (Automobile Engines) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:3:automobile-engines` |
| 16 | सेमेस्टर 3 | पदार्थों की सामर्थ्य (Strength of Materials) | थ्योरी | 6 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:3:strength-of-materials` |
| 17 | सेमेस्टर 3 | थर्मल इंजीनियरिंग (ऊष्मागतिकी) (Thermal Engineering (Thermodynamics)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:3:thermal-engineering-thermodynamics` |
| 18 | सेमेस्टर 3 | विनिर्माण प्रक्रियाएँ (Manufacturing Processes) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:3:manufacturing-processes` |
| 19 | सेमेस्टर 3 | ऑटोमोबाइल वर्कशॉप अभ्यास (Automobile Workshop Practice) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-automobile:3:automobile-workshop-practice` |
| 20 | सेमेस्टर 3 | मशीन ड्रॉइंग और CAD (Machine Drawing & CAD) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-automobile:3:machine-drawing-cad` |
| 21 | सेमेस्टर 4 | ऑटोमोबाइल चेसिस और ट्रांसमिशन (Automobile Chassis & Transmission) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:4:automobile-chassis-transmission` |
| 22 | सेमेस्टर 4 | मशीनों का सिद्धांत (Theory of Machines) | थ्योरी | 6 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:4:theory-of-machines` |
| 23 | सेमेस्टर 4 | द्रव यांत्रिकी एवं हाइड्रॉलिक मशीनें (Fluid Mechanics & Hydraulic Machines) | थ्योरी | 6 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:4:fluid-mechanics-hydraulic-machines` |
| 24 | सेमेस्टर 4 | ऑटोमोबाइल इलेक्ट्रिकल एवं इलेक्ट्रॉनिक्स (Automobile Electrical & Electronics) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:4:automobile-electrical-electronics` |
| 25 | सेमेस्टर 4 | मापिकी और मापन (Metrology & Measurements) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:4:metrology-measurements` |
| 26 | सेमेस्टर 4 | इंजीनियरिंग सामग्री एवं धातुकर्म (Engineering Materials & Metallurgy) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:4:engineering-materials-metallurgy` |
| 27 | सेमेस्टर 5 | वाहन रखरखाव और मरम्मत (Vehicle Maintenance & Repair) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:5:vehicle-maintenance-repair` |
| 28 | सेमेस्टर 5 | मशीन अवयवों का डिज़ाइन (Design of Machine Elements) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:5:design-of-machine-elements` |
| 29 | सेमेस्टर 5 | दो और तीन पहिया वाहन (Two & Three Wheelers) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:5:two-three-wheelers` |
| 30 | सेमेस्टर 5 | वाहन प्रदूषण और नियंत्रण (Automotive Pollution & Control) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:5:automotive-pollution-control` |
| 31 | सेमेस्टर 5 | ऐच्छिक-I: वाहन बॉडी इंजीनियरिंग / ट्रैक्टर एवं कृषि उपकरण (Elective-I: Vehicle Body Engineering / Tractors & Farm Equipment) | ऐच्छिक (इलेक्टिव) | 3 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:5:elective-i-vehicle-body-engineering-tractors-farm-equipment` |
| 32 | सेमेस्टर 5 | समर इंटर्नशिप (Summer Internship) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-automobile:5:summer-internship` |
| 33 | सेमेस्टर 6 | औद्योगिक प्रबंधन (Industrial Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:6:industrial-management` |
| 34 | सेमेस्टर 6 | इलेक्ट्रिक और हाइब्रिड वाहन (Electric & Hybrid Vehicles) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:6:electric-hybrid-vehicles` |
| 35 | सेमेस्टर 6 | ऑटोमोबाइल वातानुकूलन (Automobile Air Conditioning) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:6:automobile-air-conditioning` |
| 36 | सेमेस्टर 6 | वैकल्पिक ईंधन (Alternative Fuels) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:6:alternative-fuels` |
| 37 | सेमेस्टर 6 | परिवहन प्रबंधन और मोटर वाहन अधिनियम (Transport Management & Motor Vehicle Act) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-automobile:6:transport-management-motor-vehicle-act` |
| 38 | सेमेस्टर 6 | मुख्य परियोजना (Major Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-automobile:6:major-project` |

#### डी.फ़ार्मा (डिप्लोमा इन फ़ार्मेसी) — D.Pharm (Diploma in Pharmacy) (13 किताबें · प्रोफ़ाइल: medical, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | फ़ार्मास्युटिक्स (Pharmaceutics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-pharmacy:1:pharmaceutics` |
| 2 | वर्ष 1 | फ़ार्मास्युटिकल रसायन (Pharmaceutical Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-pharmacy:1:pharmaceutical-chemistry` |
| 3 | वर्ष 1 | फ़ार्माकोग्नॉसी (Pharmacognosy) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-pharmacy:1:pharmacognosy` |
| 4 | वर्ष 1 | मानव शरीर रचना एवं क्रिया विज्ञान (Human Anatomy & Physiology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-pharmacy:1:human-anatomy-physiology` |
| 5 | वर्ष 1 | सामाजिक फ़ार्मेसी (Social Pharmacy) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-pharmacy:1:social-pharmacy` |
| 6 | वर्ष 1 | प्रथम वर्ष प्रायोगिक (First-year Practicals) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-pharmacy:1:first-year-practicals` |
| 7 | वर्ष 2 | फ़ार्माकोलॉजी (Pharmacology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-pharmacy:2:pharmacology` |
| 8 | वर्ष 2 | सामुदायिक फ़ार्मेसी एवं प्रबंधन (Community Pharmacy & Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-pharmacy:2:community-pharmacy-management` |
| 9 | वर्ष 2 | जैव रसायन एवं क्लिनिकल पैथोलॉजी (Biochemistry & Clinical Pathology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-pharmacy:2:biochemistry-clinical-pathology` |
| 10 | वर्ष 2 | फ़ार्माकोथेरेप्यूटिक्स (Pharmacotherapeutics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-pharmacy:2:pharmacotherapeutics` |
| 11 | वर्ष 2 | अस्पताल एवं क्लिनिकल फ़ार्मेसी (Hospital & Clinical Pharmacy) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-pharmacy:2:hospital-clinical-pharmacy` |
| 12 | वर्ष 2 | फ़ार्मेसी कानून एवं नैतिकता (Pharmacy Law & Ethics) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-pharmacy:2:pharmacy-law-ethics` |
| 13 | वर्ष 2 | व्यावहारिक प्रशिक्षण (500 घंटे) (Practical Training (500 hours)) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-pharmacy:2:practical-training-500-hours` |

#### जीएनएम (जनरल नर्सिंग एवं मिडवाइफ़री) — GNM (General Nursing & Midwifery) (19 किताबें · प्रोफ़ाइल: medical, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | जैविक विज्ञान (शरीर रचना, क्रिया विज्ञान, सूक्ष्मजीव विज्ञान) (Biological Sciences (Anatomy, Physiology, Microbiology)) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:1:biological-sciences-anatomy-physiology-microbiology` |
| 2 | वर्ष 1 | व्यवहार विज्ञान (मनोविज्ञान, समाजशास्त्र) (Behavioural Sciences (Psychology, Sociology)) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:1:behavioural-sciences-psychology-sociology` |
| 3 | वर्ष 1 | नर्सिंग के मूल सिद्धांत (Fundamentals of Nursing) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:1:fundamentals-of-nursing` |
| 4 | वर्ष 1 | सामुदायिक स्वास्थ्य नर्सिंग-I (Community Health Nursing-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:1:community-health-nursing-i` |
| 5 | वर्ष 1 | अंग्रेज़ी (English) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:1:english` |
| 6 | वर्ष 1 | कंप्यूटर शिक्षा (Computer Education) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:1:computer-education` |
| 7 | वर्ष 1 | क्लिनिकल अभ्यास-I (Clinical Practice-I) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-nursing:1:clinical-practice-i` |
| 8 | वर्ष 2 | मेडिकल सर्जिकल नर्सिंग-I (Medical Surgical Nursing-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:2:medical-surgical-nursing-i` |
| 9 | वर्ष 2 | मेडिकल सर्जिकल नर्सिंग-II (Medical Surgical Nursing-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:2:medical-surgical-nursing-ii` |
| 10 | वर्ष 2 | मानसिक स्वास्थ्य नर्सिंग (Mental Health Nursing) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:2:mental-health-nursing` |
| 11 | वर्ष 2 | बाल स्वास्थ्य नर्सिंग (Child Health Nursing) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:2:child-health-nursing` |
| 12 | वर्ष 2 | क्लिनिकल अभ्यास-II (Clinical Practice-II) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:diploma-nursing:2:clinical-practice-ii` |
| 13 | वर्ष 3 | मिडवाइफ़री एवं स्त्री रोग नर्सिंग (Midwifery & Gynaecological Nursing) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:3:midwifery-gynaecological-nursing` |
| 14 | वर्ष 3 | सामुदायिक स्वास्थ्य नर्सिंग-II (Community Health Nursing-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:3:community-health-nursing-ii` |
| 15 | वर्ष 3 | नर्सिंग शिक्षा (Nursing Education) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:3:nursing-education` |
| 16 | वर्ष 3 | शोध एवं सांख्यिकी का परिचय (Introduction to Research & Statistics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:3:introduction-to-research-statistics` |
| 17 | वर्ष 3 | व्यावसायिक प्रवृत्तियाँ एवं समायोजन (Professional Trends & Adjustment) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:3:professional-trends-adjustment` |
| 18 | वर्ष 3 | नर्सिंग प्रशासन एवं वार्ड प्रबंधन (Nursing Administration & Ward Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:diploma-nursing:3:nursing-administration-ward-management` |
| 19 | वर्ष 3 | इंटर्नशिप (एकीकृत अभ्यास) (Internship (Integrated Practice)) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-nursing:3:internship-integrated-practice` |

#### डी.एल.एड. (प्राथमिक शिक्षक डिप्लोमा) — D.El.Ed. (Diploma in Elementary Education) (13 किताबें · प्रोफ़ाइल: education, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | बचपन और बच्चों का विकास (Childhood & Development of Children) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-deled:1:childhood-development-of-children` |
| 2 | वर्ष 1 | समकालीन भारतीय समाज (Contemporary Indian Society) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:diploma-deled:1:contemporary-indian-society` |
| 3 | वर्ष 1 | भारत में शिक्षा: स्थिति, समस्याएँ और मुद्दे (Education in India: Status, Problems & Issues) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-deled:1:education-in-india-status-problems-issues` |
| 4 | वर्ष 1 | भाषा दक्षता (हिंदी / अंग्रेज़ी) (Language Proficiency (Hindi / English)) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:diploma-deled:1:language-proficiency-hindi-english` |
| 5 | वर्ष 1 | गणित का शिक्षणशास्त्र (प्राथमिक) (Pedagogy of Mathematics (Primary)) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:diploma-deled:1:pedagogy-of-mathematics-primary` |
| 6 | वर्ष 1 | पर्यावरण अध्ययन का शिक्षणशास्त्र (Pedagogy of Environmental Studies) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:diploma-deled:1:pedagogy-of-environmental-studies` |
| 7 | वर्ष 1 | शिक्षा में ICT की समझ (Understanding ICT in Education) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:diploma-deled:1:understanding-ict-in-education` |
| 8 | वर्ष 2 | संज्ञान, अधिगम और सामाजिक-सांस्कृतिक संदर्भ (Cognition, Learning & the Socio-Cultural Context) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:diploma-deled:2:cognition-learning-the-socio-cultural-context` |
| 9 | वर्ष 2 | विद्यालय संस्कृति, नेतृत्व और परिवर्तन (School Culture, Leadership & Change) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:diploma-deled:2:school-culture-leadership-change` |
| 10 | वर्ष 2 | भाषा का शिक्षणशास्त्र (Pedagogy of Language) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:diploma-deled:2:pedagogy-of-language` |
| 11 | वर्ष 2 | विज्ञान / सामाजिक विज्ञान का शिक्षणशास्त्र (उच्च प्राथमिक) (Pedagogy of Science / Social Science (Upper Primary)) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:diploma-deled:2:pedagogy-of-science-social-science-upper-primary` |
| 12 | वर्ष 2 | विविधता, जेंडर और समावेशी शिक्षा (Diversity, Gender & Inclusive Education) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:diploma-deled:2:diversity-gender-inclusive-education` |
| 13 | वर्ष 2 | विद्यालय इंटर्नशिप (School Internship) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:diploma-deled:2:school-internship` |

### स्नातक (ग्रेजुएशन)

#### बी.टेक / बी.ई. (मैकेनिकल इंजीनियरिंग) — B.Tech / B.E. (Mechanical Engineering) (30 किताबें · प्रोफ़ाइल: btech-theory, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | इंजीनियरिंग भौतिकी (Engineering Physics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:1:engineering-physics` |
| 2 | वर्ष 1 | इंजीनियरिंग रसायन (Engineering Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:1:engineering-chemistry` |
| 3 | वर्ष 1 | गणित-I (कलन एवं रैखिक बीजगणित) (Mathematics-I (Calculus & Linear Algebra)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:1:mathematics-i-calculus-linear-algebra` |
| 4 | वर्ष 1 | गणित-II (अवकल समीकरण एवं सम्मिश्र चर) (Mathematics-II (Differential Equations & Complex Variables)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:1:mathematics-ii-differential-equations-complex-variables` |
| 5 | वर्ष 1 | बेसिक इलेक्ट्रिकल इंजीनियरिंग (Basic Electrical Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:1:basic-electrical-engineering` |
| 6 | वर्ष 1 | समस्या समाधान के लिए प्रोग्रामिंग (Programming for Problem Solving) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:1:programming-for-problem-solving` |
| 7 | वर्ष 1 | इंजीनियरिंग ग्राफ़िक्स एवं डिज़ाइन (Engineering Graphics & Design) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:btech-mechanical:1:engineering-graphics-design` |
| 8 | वर्ष 1 | वर्कशॉप / विनिर्माण अभ्यास (Workshop / Manufacturing Practices) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:btech-mechanical:1:workshop-manufacturing-practices` |
| 9 | वर्ष 1 | अंग्रेज़ी (English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:1:english` |
| 10 | वर्ष 2 | इंजीनियरिंग मैकेनिक्स (Engineering Mechanics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:2:engineering-mechanics` |
| 11 | वर्ष 2 | ऊष्मागतिकी (Thermodynamics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:2:thermodynamics` |
| 12 | वर्ष 2 | पदार्थों की सामर्थ्य (Strength of Materials) | थ्योरी | 6 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:2:strength-of-materials` |
| 13 | वर्ष 2 | द्रव यांत्रिकी एवं मशीनें (Fluid Mechanics & Machines) | थ्योरी | 6 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:2:fluid-mechanics-machines` |
| 14 | वर्ष 2 | इंजीनियरिंग सामग्री (Engineering Materials) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:2:engineering-materials` |
| 15 | वर्ष 2 | विनिर्माण प्रक्रियाएँ (Manufacturing Processes) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:2:manufacturing-processes` |
| 16 | वर्ष 2 | गणित-III (आंशिक अवकल समीकरण, प्रायिकता एवं सांख्यिकी) (Mathematics-III (PDE, Probability & Statistics)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:2:mathematics-iii-pde-probability-statistics` |
| 17 | वर्ष 2 | बेसिक इलेक्ट्रॉनिक्स (Basic Electronics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:2:basic-electronics` |
| 18 | वर्ष 3 | अनुप्रयुक्त ऊष्मागतिकी (IC इंजन, संपीडक, गैस टरबाइन) (Applied Thermodynamics (IC Engines, Compressors, Gas Turbines)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:3:applied-thermodynamics-ic-engines-compressors-gas-turbines` |
| 19 | वर्ष 3 | ऊष्मा-स्थानांतरण (Heat Transfer) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:3:heat-transfer` |
| 20 | वर्ष 3 | मशीनों की शुद्धगतिकी एवं गतिकी (Kinematics & Dynamics of Machines) | थ्योरी | 6 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:3:kinematics-dynamics-of-machines` |
| 21 | वर्ष 3 | मशीन अवयवों का डिज़ाइन (Design of Machine Elements) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:3:design-of-machine-elements` |
| 22 | वर्ष 3 | विनिर्माण प्रौद्योगिकी (मशीनिंग) (Manufacturing Technology (Machining)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:3:manufacturing-technology-machining` |
| 23 | वर्ष 3 | मापिकी और मापन (Metrology & Measurements) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:3:metrology-measurements` |
| 24 | वर्ष 3 | औद्योगिक अभियांत्रिकी एवं संचालन प्रबंधन (Industrial Engineering & Operations Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:3:industrial-engineering-operations-management` |
| 25 | वर्ष 4 | प्रशीतन और वातानुकूलन (Refrigeration & Air Conditioning) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:4:refrigeration-air-conditioning` |
| 26 | वर्ष 4 | पावर प्लांट इंजीनियरिंग (Power Plant Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:4:power-plant-engineering` |
| 27 | वर्ष 4 | उन्नत विनिर्माण एवं CAD/CAM (Advanced Manufacturing & CAD/CAM) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:4:advanced-manufacturing-cad-cam` |
| 28 | वर्ष 4 | परिमित अवयव विश्लेषण (Finite Element Analysis) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:4:finite-element-analysis` |
| 29 | वर्ष 4 | ऐच्छिक: ऑटोमोबाइल इंजीनियरिंग / रोबोटिक्स (Elective: Automobile Engineering / Robotics) | ऐच्छिक (इलेक्टिव) | 3 | 📗 पाठ्यपुस्तक | `c:btech-mechanical:4:elective-automobile-engineering-robotics` |
| 30 | वर्ष 4 | परियोजना (Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:btech-mechanical:4:project` |

#### बी.टेक / बी.ई. (सिविल इंजीनियरिंग) — B.Tech / B.E. (Civil Engineering) (28 किताबें · प्रोफ़ाइल: btech-theory, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | इंजीनियरिंग भौतिकी (Engineering Physics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:1:engineering-physics` |
| 2 | वर्ष 1 | इंजीनियरिंग रसायन (Engineering Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:1:engineering-chemistry` |
| 3 | वर्ष 1 | गणित-I (कलन एवं रैखिक बीजगणित) (Mathematics-I (Calculus & Linear Algebra)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:1:mathematics-i-calculus-linear-algebra` |
| 4 | वर्ष 1 | गणित-II (अवकल समीकरण एवं सम्मिश्र चर) (Mathematics-II (Differential Equations & Complex Variables)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:1:mathematics-ii-differential-equations-complex-variables` |
| 5 | वर्ष 1 | बेसिक इलेक्ट्रिकल इंजीनियरिंग (Basic Electrical Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:1:basic-electrical-engineering` |
| 6 | वर्ष 1 | समस्या समाधान के लिए प्रोग्रामिंग (Programming for Problem Solving) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:1:programming-for-problem-solving` |
| 7 | वर्ष 1 | इंजीनियरिंग ग्राफ़िक्स एवं डिज़ाइन (Engineering Graphics & Design) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:btech-civil:1:engineering-graphics-design` |
| 8 | वर्ष 1 | वर्कशॉप / विनिर्माण अभ्यास (Workshop / Manufacturing Practices) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:btech-civil:1:workshop-manufacturing-practices` |
| 9 | वर्ष 1 | अंग्रेज़ी (English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:1:english` |
| 10 | वर्ष 2 | ठोसों की यांत्रिकी (Mechanics of Solids) | थ्योरी | 6 | 📗 पाठ्यपुस्तक | `c:btech-civil:2:mechanics-of-solids` |
| 11 | वर्ष 2 | द्रव यांत्रिकी (Fluid Mechanics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:2:fluid-mechanics` |
| 12 | वर्ष 2 | सर्वेक्षण एवं जियोमैटिक्स (Surveying & Geomatics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:2:surveying-geomatics` |
| 13 | वर्ष 2 | भवन सामग्री एवं निर्माण (Building Materials & Construction) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:2:building-materials-construction` |
| 14 | वर्ष 2 | इंजीनियरिंग भूविज्ञान (Engineering Geology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:btech-civil:2:engineering-geology` |
| 15 | वर्ष 2 | कंक्रीट प्रौद्योगिकी (Concrete Technology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:2:concrete-technology` |
| 16 | वर्ष 2 | गणित-III (Mathematics-III) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:2:mathematics-iii` |
| 17 | वर्ष 3 | संरचनात्मक विश्लेषण (Structural Analysis) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:3:structural-analysis` |
| 18 | वर्ष 3 | भू-तकनीकी इंजीनियरिंग (Geotechnical Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:3:geotechnical-engineering` |
| 19 | वर्ष 3 | RCC संरचनाओं का डिज़ाइन (Design of RCC Structures) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:3:design-of-rcc-structures` |
| 20 | वर्ष 3 | परिवहन इंजीनियरिंग (Transportation Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:3:transportation-engineering` |
| 21 | वर्ष 3 | जल विज्ञान एवं जल संसाधन इंजीनियरिंग (Hydrology & Water Resources Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:3:hydrology-water-resources-engineering` |
| 22 | वर्ष 3 | पर्यावरण इंजीनियरिंग (Environmental Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:3:environmental-engineering` |
| 23 | वर्ष 4 | स्टील संरचनाओं का डिज़ाइन (Design of Steel Structures) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:4:design-of-steel-structures` |
| 24 | वर्ष 4 | आकलन, लागत एवं मूल्यांकन (Estimation, Costing & Valuation) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:4:estimation-costing-valuation` |
| 25 | वर्ष 4 | निर्माण प्रबंधन (Construction Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:4:construction-management` |
| 26 | वर्ष 4 | नींव इंजीनियरिंग (Foundation Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-civil:4:foundation-engineering` |
| 27 | वर्ष 4 | ऐच्छिक: भूकंप इंजीनियरिंग / पुल इंजीनियरिंग (Elective: Earthquake Engineering / Bridge Engineering) | ऐच्छिक (इलेक्टिव) | 3 | 📗 पाठ्यपुस्तक | `c:btech-civil:4:elective-earthquake-engineering-bridge-engineering` |
| 28 | वर्ष 4 | परियोजना (Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:btech-civil:4:project` |

#### बी.टेक / बी.ई. (इलेक्ट्रिकल इंजीनियरिंग) — B.Tech / B.E. (Electrical Engineering) (29 किताबें · प्रोफ़ाइल: btech-theory, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | इंजीनियरिंग भौतिकी (Engineering Physics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:1:engineering-physics` |
| 2 | वर्ष 1 | इंजीनियरिंग रसायन (Engineering Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:1:engineering-chemistry` |
| 3 | वर्ष 1 | गणित-I (कलन एवं रैखिक बीजगणित) (Mathematics-I (Calculus & Linear Algebra)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:1:mathematics-i-calculus-linear-algebra` |
| 4 | वर्ष 1 | गणित-II (अवकल समीकरण एवं सम्मिश्र चर) (Mathematics-II (Differential Equations & Complex Variables)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:1:mathematics-ii-differential-equations-complex-variables` |
| 5 | वर्ष 1 | बेसिक इलेक्ट्रिकल इंजीनियरिंग (Basic Electrical Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:1:basic-electrical-engineering` |
| 6 | वर्ष 1 | समस्या समाधान के लिए प्रोग्रामिंग (Programming for Problem Solving) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:1:programming-for-problem-solving` |
| 7 | वर्ष 1 | इंजीनियरिंग ग्राफ़िक्स एवं डिज़ाइन (Engineering Graphics & Design) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:btech-electrical:1:engineering-graphics-design` |
| 8 | वर्ष 1 | वर्कशॉप / विनिर्माण अभ्यास (Workshop / Manufacturing Practices) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:btech-electrical:1:workshop-manufacturing-practices` |
| 9 | वर्ष 1 | अंग्रेज़ी (English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:1:english` |
| 10 | वर्ष 2 | विद्युत परिपथ विश्लेषण (Electrical Circuit Analysis) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:2:electrical-circuit-analysis` |
| 11 | वर्ष 2 | एनालॉग इलेक्ट्रॉनिक परिपथ (Analog Electronic Circuits) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:2:analog-electronic-circuits` |
| 12 | वर्ष 2 | विद्युत मशीनें-I (Electrical Machines-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:2:electrical-machines-i` |
| 13 | वर्ष 2 | विद्युत-चुंबकीय क्षेत्र (Electromagnetic Fields) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:2:electromagnetic-fields` |
| 14 | वर्ष 2 | डिजिटल इलेक्ट्रॉनिक्स (Digital Electronics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:2:digital-electronics` |
| 15 | वर्ष 2 | सिग्नल एवं सिस्टम (Signals & Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:2:signals-systems` |
| 16 | वर्ष 2 | गणित-III (Mathematics-III) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:2:mathematics-iii` |
| 17 | वर्ष 3 | विद्युत मशीनें-II (Electrical Machines-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:3:electrical-machines-ii` |
| 18 | वर्ष 3 | पावर सिस्टम-I (Power Systems-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:3:power-systems-i` |
| 19 | वर्ष 3 | नियंत्रण प्रणाली (Control Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:3:control-systems` |
| 20 | वर्ष 3 | पावर इलेक्ट्रॉनिक्स (Power Electronics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:3:power-electronics` |
| 21 | वर्ष 3 | मापन एवं उपकरण (Measurements & Instrumentation) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:3:measurements-instrumentation` |
| 22 | वर्ष 3 | माइक्रोप्रोसेसर एवं माइक्रोकंट्रोलर (Microprocessors & Microcontrollers) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:3:microprocessors-microcontrollers` |
| 23 | वर्ष 4 | पावर सिस्टम सुरक्षा एवं स्विचगियर (Power System Protection & Switchgear) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:4:power-system-protection-switchgear` |
| 24 | वर्ष 4 | विद्युत ड्राइव (Electric Drives) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:btech-electrical:4:electric-drives` |
| 25 | वर्ष 4 | विद्युत ऊर्जा का उपयोग एवं आकलन (Utilisation of Electrical Energy & Estimation) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:4:utilisation-of-electrical-energy-estimation` |
| 26 | वर्ष 4 | उच्च वोल्टेज इंजीनियरिंग (High Voltage Engineering) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:btech-electrical:4:high-voltage-engineering` |
| 27 | वर्ष 4 | नवीकरणीय ऊर्जा प्रणाली (Renewable Energy Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electrical:4:renewable-energy-systems` |
| 28 | वर्ष 4 | ऐच्छिक: HVDC एवं FACTS / स्मार्ट ग्रिड (Elective: HVDC & FACTS / Smart Grid) | ऐच्छिक (इलेक्टिव) | 3 | 📗 पाठ्यपुस्तक | `c:btech-electrical:4:elective-hvdc-facts-smart-grid` |
| 29 | वर्ष 4 | परियोजना (Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:btech-electrical:4:project` |

#### बी.टेक / बी.ई. (इलेक्ट्रॉनिक्स एवं संचार) — B.Tech / B.E. (Electronics & Communication) (27 किताबें · प्रोफ़ाइल: btech-theory, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | इंजीनियरिंग भौतिकी (Engineering Physics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:1:engineering-physics` |
| 2 | वर्ष 1 | इंजीनियरिंग रसायन (Engineering Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:1:engineering-chemistry` |
| 3 | वर्ष 1 | गणित-I (कलन एवं रैखिक बीजगणित) (Mathematics-I (Calculus & Linear Algebra)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:1:mathematics-i-calculus-linear-algebra` |
| 4 | वर्ष 1 | गणित-II (अवकल समीकरण एवं सम्मिश्र चर) (Mathematics-II (Differential Equations & Complex Variables)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:1:mathematics-ii-differential-equations-complex-variables` |
| 5 | वर्ष 1 | बेसिक इलेक्ट्रिकल इंजीनियरिंग (Basic Electrical Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:1:basic-electrical-engineering` |
| 6 | वर्ष 1 | समस्या समाधान के लिए प्रोग्रामिंग (Programming for Problem Solving) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:1:programming-for-problem-solving` |
| 7 | वर्ष 1 | इंजीनियरिंग ग्राफ़िक्स एवं डिज़ाइन (Engineering Graphics & Design) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:btech-electronics:1:engineering-graphics-design` |
| 8 | वर्ष 1 | वर्कशॉप / विनिर्माण अभ्यास (Workshop / Manufacturing Practices) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:btech-electronics:1:workshop-manufacturing-practices` |
| 9 | वर्ष 1 | अंग्रेज़ी (English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:1:english` |
| 10 | वर्ष 2 | इलेक्ट्रॉनिक उपकरण (Electronic Devices) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:2:electronic-devices` |
| 11 | वर्ष 2 | डिजिटल सिस्टम डिज़ाइन (Digital System Design) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:2:digital-system-design` |
| 12 | वर्ष 2 | सिग्नल एवं सिस्टम (Signals & Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:2:signals-systems` |
| 13 | वर्ष 2 | नेटवर्क सिद्धांत (Network Theory) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:2:network-theory` |
| 14 | वर्ष 2 | एनालॉग परिपथ (Analog Circuits) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:2:analog-circuits` |
| 15 | वर्ष 2 | गणित-III (Mathematics-III) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:2:mathematics-iii` |
| 16 | वर्ष 3 | एनालॉग एवं डिजिटल संचार (Analog & Digital Communication) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:3:analog-digital-communication` |
| 17 | वर्ष 3 | माइक्रोप्रोसेसर एवं माइक्रोकंट्रोलर (Microprocessors & Microcontrollers) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:3:microprocessors-microcontrollers` |
| 18 | वर्ष 3 | विद्युत-चुंबकीय तरंगें (Electromagnetic Waves) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:3:electromagnetic-waves` |
| 19 | वर्ष 3 | नियंत्रण प्रणाली (Control Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:3:control-systems` |
| 20 | वर्ष 3 | डिजिटल सिग्नल प्रोसेसिंग (Digital Signal Processing) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:3:digital-signal-processing` |
| 21 | वर्ष 3 | कंप्यूटर आर्किटेक्चर (Computer Architecture) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:3:computer-architecture` |
| 22 | वर्ष 4 | VLSI डिज़ाइन (VLSI Design) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:4:vlsi-design` |
| 23 | वर्ष 4 | वायरलेस संचार (Wireless Communication) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:btech-electronics:4:wireless-communication` |
| 24 | वर्ष 4 | ऑप्टिकल संचार (Optical Communication) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:btech-electronics:4:optical-communication` |
| 25 | वर्ष 4 | एम्बेडेड सिस्टम (Embedded Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-electronics:4:embedded-systems` |
| 26 | वर्ष 4 | ऐच्छिक: इंटरनेट ऑफ़ थिंग्स / सिग्नल हेतु मशीन लर्निंग (Elective: Internet of Things / Machine Learning for Signals) | ऐच्छिक (इलेक्टिव) | 4 | 📗 पाठ्यपुस्तक | `c:btech-electronics:4:elective-internet-of-things-machine-learning-for-signals` |
| 27 | वर्ष 4 | परियोजना (Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:btech-electronics:4:project` |

#### बी.टेक / बी.ई. (कंप्यूटर साइंस) — B.Tech / B.E. (Computer Science) (27 किताबें · प्रोफ़ाइल: btech-theory, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | इंजीनियरिंग भौतिकी (Engineering Physics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:1:engineering-physics` |
| 2 | वर्ष 1 | इंजीनियरिंग रसायन (Engineering Chemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:1:engineering-chemistry` |
| 3 | वर्ष 1 | गणित-I (कलन एवं रैखिक बीजगणित) (Mathematics-I (Calculus & Linear Algebra)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:1:mathematics-i-calculus-linear-algebra` |
| 4 | वर्ष 1 | गणित-II (अवकल समीकरण एवं सम्मिश्र चर) (Mathematics-II (Differential Equations & Complex Variables)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:1:mathematics-ii-differential-equations-complex-variables` |
| 5 | वर्ष 1 | बेसिक इलेक्ट्रिकल इंजीनियरिंग (Basic Electrical Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:1:basic-electrical-engineering` |
| 6 | वर्ष 1 | समस्या समाधान के लिए प्रोग्रामिंग (Programming for Problem Solving) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:1:programming-for-problem-solving` |
| 7 | वर्ष 1 | इंजीनियरिंग ग्राफ़िक्स एवं डिज़ाइन (Engineering Graphics & Design) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:btech-computer:1:engineering-graphics-design` |
| 8 | वर्ष 1 | वर्कशॉप / विनिर्माण अभ्यास (Workshop / Manufacturing Practices) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:btech-computer:1:workshop-manufacturing-practices` |
| 9 | वर्ष 1 | अंग्रेज़ी (English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:1:english` |
| 10 | वर्ष 2 | डेटा संरचना एवं एल्गोरिदम (Data Structures & Algorithms) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:2:data-structures-algorithms` |
| 11 | वर्ष 2 | असतत गणित (Discrete Mathematics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:2:discrete-mathematics` |
| 12 | वर्ष 2 | डिजिटल इलेक्ट्रॉनिक्स (Digital Electronics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:2:digital-electronics` |
| 13 | वर्ष 2 | कंप्यूटर संगठन एवं आर्किटेक्चर (Computer Organisation & Architecture) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:2:computer-organisation-architecture` |
| 14 | वर्ष 2 | ऑब्जेक्ट ओरिएंटेड प्रोग्रामिंग (Object Oriented Programming) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:2:object-oriented-programming` |
| 15 | वर्ष 2 | डेटाबेस प्रबंधन प्रणाली (Database Management Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:2:database-management-systems` |
| 16 | वर्ष 3 | ऑपरेटिंग सिस्टम (Operating Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:3:operating-systems` |
| 17 | वर्ष 3 | एल्गोरिदम का डिज़ाइन एवं विश्लेषण (Design & Analysis of Algorithms) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:3:design-analysis-of-algorithms` |
| 18 | वर्ष 3 | कंप्यूटर नेटवर्क (Computer Networks) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:3:computer-networks` |
| 19 | वर्ष 3 | संगणना का सिद्धांत (Theory of Computation) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:3:theory-of-computation` |
| 20 | वर्ष 3 | सॉफ़्टवेयर इंजीनियरिंग (Software Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:3:software-engineering` |
| 21 | वर्ष 3 | कंपाइलर डिज़ाइन (Compiler Design) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:3:compiler-design` |
| 22 | वर्ष 4 | कृत्रिम बुद्धिमत्ता एवं मशीन लर्निंग (Artificial Intelligence & Machine Learning) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:4:artificial-intelligence-machine-learning` |
| 23 | वर्ष 4 | क्लाउड कंप्यूटिंग (Cloud Computing) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:btech-computer:4:cloud-computing` |
| 24 | वर्ष 4 | सूचना सुरक्षा (Information Security) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:btech-computer:4:information-security` |
| 25 | वर्ष 4 | वितरित प्रणाली (Distributed Systems) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:btech-computer:4:distributed-systems` |
| 26 | वर्ष 4 | ऐच्छिक: डेटा साइंस / ब्लॉकचेन (Elective: Data Science / Blockchain) | ऐच्छिक (इलेक्टिव) | 4 | 📗 पाठ्यपुस्तक | `c:btech-computer:4:elective-data-science-blockchain` |
| 27 | वर्ष 4 | परियोजना (Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:btech-computer:4:project` |

#### बी.एससी. (विज्ञान स्नातक) — B.Sc. (Bachelor of Science) (18 किताबें · प्रोफ़ाइल: ug-science, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | भौतिकी: यांत्रिकी, विद्युत एवं चुंबकत्व (Physics: Mechanics, Electricity & Magnetism) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc:1:physics-mechanics-electricity-magnetism` |
| 2 | वर्ष 1 | रसायन: अकार्बनिक एवं कार्बनिक मूल (Chemistry: Inorganic & Organic Basics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc:1:chemistry-inorganic-organic-basics` |
| 3 | वर्ष 1 | गणित: कलन एवं बीजगणित (PCM) (Mathematics: Calculus & Algebra (PCM)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc:1:mathematics-calculus-algebra-pcm` |
| 4 | वर्ष 1 | वनस्पति एवं प्राणी विज्ञान: जीवन की विविधता (ZBC) (Botany & Zoology: Diversity of Life (ZBC)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc:1:botany-zoology-diversity-of-life-zbc` |
| 5 | वर्ष 1 | पर्यावरण अध्ययन (Environmental Studies) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc:1:environmental-studies` |
| 6 | वर्ष 1 | भाषा: अंग्रेज़ी / हिंदी (Language: English / Hindi) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:bsc:1:language-english-hindi` |
| 7 | वर्ष 1 | विज्ञान प्रायोगिक-I (Science Practicals-I) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:bsc:1:science-practicals-i` |
| 8 | वर्ष 2 | भौतिकी: ऊष्मीय भौतिकी, तरंगें एवं प्रकाशिकी (Physics: Thermal Physics, Waves & Optics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc:2:physics-thermal-physics-waves-optics` |
| 9 | वर्ष 2 | रसायन: भौतिक रसायन एवं कार्बनिक अभिक्रियाएँ (Chemistry: Physical Chemistry & Organic Reactions) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc:2:chemistry-physical-chemistry-organic-reactions` |
| 10 | वर्ष 2 | गणित: अवकल समीकरण एवं वास्तविक विश्लेषण (PCM) (Mathematics: Differential Equations & Real Analysis (PCM)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc:2:mathematics-differential-equations-real-analysis-pcm` |
| 11 | वर्ष 2 | वनस्पति एवं प्राणी विज्ञान: शरीर क्रिया एवं आनुवंशिकी (ZBC) (Botany & Zoology: Physiology & Genetics (ZBC)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc:2:botany-zoology-physiology-genetics-zbc` |
| 12 | वर्ष 2 | कौशल संवर्धन पाठ्यक्रम (Skill Enhancement Course) | ऐच्छिक (इलेक्टिव) | 3 | 📗 पाठ्यपुस्तक | `c:bsc:2:skill-enhancement-course` |
| 13 | वर्ष 2 | विज्ञान प्रायोगिक-II (Science Practicals-II) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:bsc:2:science-practicals-ii` |
| 14 | वर्ष 3 | भौतिकी: आधुनिक भौतिकी, इलेक्ट्रॉनिक्स एवं क्वांटम यांत्रिकी (Physics: Modern Physics, Electronics & Quantum Mechanics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc:3:physics-modern-physics-electronics-quantum-mechanics` |
| 15 | वर्ष 3 | रसायन: स्पेक्ट्रोस्कोपी, उपसहसंयोजन एवं औद्योगिक रसायन (Chemistry: Spectroscopy, Coordination & Industrial Chemistry) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc:3:chemistry-spectroscopy-coordination-industrial-chemistry` |
| 16 | वर्ष 3 | गणित: अमूर्त बीजगणित, सम्मिश्र विश्लेषण एवं संख्यात्मक विधियाँ (PCM) (Mathematics: Abstract Algebra, Complex Analysis & Numerical Methods (PCM)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc:3:mathematics-abstract-algebra-complex-analysis-numerical-meth` |
| 17 | वर्ष 3 | वनस्पति एवं प्राणी विज्ञान: पारिस्थितिकी, विकास एवं जैव प्रौद्योगिकी (ZBC) (Botany & Zoology: Ecology, Evolution & Biotechnology (ZBC)) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc:3:botany-zoology-ecology-evolution-biotechnology-zbc` |
| 18 | वर्ष 3 | परियोजना / लघु शोध (Project / Dissertation) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:bsc:3:project-dissertation` |

#### बी.कॉम. (वाणिज्य स्नातक) — B.Com. (Bachelor of Commerce) (18 किताबें · प्रोफ़ाइल: ug-commerce)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | वित्तीय लेखांकन (Financial Accounting) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bcom:1:financial-accounting` |
| 2 | वर्ष 1 | व्यावसायिक संगठन एवं प्रबंधन (Business Organisation & Management) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bcom:1:business-organisation-management` |
| 3 | वर्ष 1 | व्यावसायिक विधि (Business Law) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bcom:1:business-law` |
| 4 | वर्ष 1 | व्यावसायिक अर्थशास्त्र (व्यष्टि) (Business Economics (Micro)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bcom:1:business-economics-micro` |
| 5 | वर्ष 1 | व्यावसायिक संचार (Business Communication) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bcom:1:business-communication` |
| 6 | वर्ष 1 | पर्यावरण अध्ययन (Environmental Studies) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bcom:1:environmental-studies` |
| 7 | वर्ष 2 | निगमीय लेखांकन (Corporate Accounting) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bcom:2:corporate-accounting` |
| 8 | वर्ष 2 | आयकर विधि एवं व्यवहार (Income Tax Law & Practice) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bcom:2:income-tax-law-practice` |
| 9 | वर्ष 2 | लागत लेखांकन (Cost Accounting) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bcom:2:cost-accounting` |
| 10 | वर्ष 2 | कंपनी विधि (Company Law) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bcom:2:company-law` |
| 11 | वर्ष 2 | व्यावसायिक सांख्यिकी (Business Statistics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bcom:2:business-statistics` |
| 12 | वर्ष 2 | समष्टि अर्थशास्त्र (Macro Economics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bcom:2:macro-economics` |
| 13 | वर्ष 3 | अंकेक्षण एवं निगमीय शासन (Auditing & Corporate Governance) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bcom:3:auditing-corporate-governance` |
| 14 | वर्ष 3 | प्रबंधन लेखांकन (Management Accounting) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bcom:3:management-accounting` |
| 15 | वर्ष 3 | वस्तु एवं सेवा कर (GST) (Goods & Services Tax) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bcom:3:goods-services-tax` |
| 16 | वर्ष 3 | वित्तीय प्रबंधन (Financial Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bcom:3:financial-management` |
| 17 | वर्ष 3 | बैंकिंग एवं बीमा (Banking & Insurance) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bcom:3:banking-insurance` |
| 18 | वर्ष 3 | उद्यमिता (Entrepreneurship) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bcom:3:entrepreneurship` |

#### बी.ए. (कला स्नातक) — B.A. (Bachelor of Arts) (13 किताबें · प्रोफ़ाइल: ug-arts, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | इतिहास: प्राचीन भारत (History: Ancient India) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:ba:1:history-ancient-india` |
| 2 | वर्ष 1 | राजनीति विज्ञान: राजनीतिक सिद्धांत (Political Science: Political Theory) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:ba:1:political-science-political-theory` |
| 3 | वर्ष 1 | भूगोल: भौतिक भूगोल (Geography: Physical Geography) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:ba:1:geography-physical-geography` |
| 4 | वर्ष 1 | भाषा: हिंदी / अंग्रेज़ी (Language: Hindi / English) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:ba:1:language-hindi-english` |
| 5 | वर्ष 1 | पर्यावरण अध्ययन (Environmental Studies) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:ba:1:environmental-studies` |
| 6 | वर्ष 2 | इतिहास: मध्यकालीन भारत (History: Medieval India) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:ba:2:history-medieval-india` |
| 7 | वर्ष 2 | राजनीति विज्ञान: भारतीय शासन एवं राजनीति (Political Science: Indian Government & Politics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:ba:2:political-science-indian-government-politics` |
| 8 | वर्ष 2 | भूगोल: मानव एवं आर्थिक भूगोल (Geography: Human & Economic Geography) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:ba:2:geography-human-economic-geography` |
| 9 | वर्ष 2 | कौशल संवर्धन पाठ्यक्रम (Skill Enhancement Course) | ऐच्छिक (इलेक्टिव) | 3 | 📗 पाठ्यपुस्तक | `c:ba:2:skill-enhancement-course` |
| 10 | वर्ष 3 | इतिहास: आधुनिक भारत एवं विश्व इतिहास (History: Modern India & World History) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:ba:3:history-modern-india-world-history` |
| 11 | वर्ष 3 | राजनीति विज्ञान: अंतरराष्ट्रीय संबंध एवं लोक प्रशासन (Political Science: International Relations & Public Administration) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:ba:3:political-science-international-relations-public-administrat` |
| 12 | वर्ष 3 | भूगोल: भारत का भूगोल एवं प्रायोगिक (Geography: Geography of India & Practical) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:ba:3:geography-geography-of-india-practical` |
| 13 | वर्ष 3 | परियोजना / लघु शोध (Project / Dissertation) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:ba:3:project-dissertation` |

#### बी.एड. (शिक्षा स्नातक) — B.Ed. (Bachelor of Education) (16 किताबें · प्रोफ़ाइल: education, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | बचपन और विकास (Childhood & Growing Up) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bed:1:childhood-growing-up` |
| 2 | वर्ष 1 | समकालीन भारत और शिक्षा (Contemporary India & Education) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:bed:1:contemporary-india-education` |
| 3 | वर्ष 1 | अधिगम और शिक्षण (Learning & Teaching) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:bed:1:learning-teaching` |
| 4 | वर्ष 1 | पाठ्यक्रम में भाषा (Language across the Curriculum) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:bed:1:language-across-the-curriculum` |
| 5 | वर्ष 1 | विषयों की समझ (Understanding Disciplines & Subjects) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:bed:1:understanding-disciplines-subjects` |
| 6 | वर्ष 1 | विद्यालय विषय का शिक्षणशास्त्र-I (Pedagogy of a School Subject-I) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:bed:1:pedagogy-of-a-school-subject-i` |
| 7 | वर्ष 1 | पाठ पढ़ना और चिंतन (Reading & Reflecting on Texts) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:bed:1:reading-reflecting-on-texts` |
| 8 | वर्ष 1 | शिक्षा में नाटक और कला (Drama & Art in Education) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:bed:1:drama-art-in-education` |
| 9 | वर्ष 2 | ज्ञान और पाठ्यक्रम (Knowledge & Curriculum) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:bed:2:knowledge-curriculum` |
| 10 | वर्ष 2 | अधिगम के लिए आकलन (Assessment for Learning) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:bed:2:assessment-for-learning` |
| 11 | वर्ष 2 | समावेशी विद्यालय का निर्माण (Creating an Inclusive School) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:bed:2:creating-an-inclusive-school` |
| 12 | वर्ष 2 | जेंडर, विद्यालय और समाज (Gender, School & Society) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:bed:2:gender-school-society` |
| 13 | वर्ष 2 | विद्यालय विषय का शिक्षणशास्त्र-II (Pedagogy of a School Subject-II) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:bed:2:pedagogy-of-a-school-subject-ii` |
| 14 | वर्ष 2 | ICT की आलोचनात्मक समझ (Critical Understanding of ICT) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:bed:2:critical-understanding-of-ict` |
| 15 | वर्ष 2 | स्व की समझ (Understanding the Self) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:bed:2:understanding-the-self` |
| 16 | वर्ष 2 | विद्यालय इंटर्नशिप (School Internship) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:bed:2:school-internship` |

#### बी.एससी. नर्सिंग — B.Sc. Nursing (25 किताबें · प्रोफ़ाइल: medical, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | संप्रेषणात्मक अंग्रेज़ी (Communicative English) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:1:communicative-english` |
| 2 | वर्ष 1 | अनुप्रयुक्त शरीर रचना (Applied Anatomy) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:1:applied-anatomy` |
| 3 | वर्ष 1 | अनुप्रयुक्त शरीर क्रिया विज्ञान (Applied Physiology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:1:applied-physiology` |
| 4 | वर्ष 1 | अनुप्रयुक्त समाजशास्त्र (Applied Sociology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:1:applied-sociology` |
| 5 | वर्ष 1 | अनुप्रयुक्त मनोविज्ञान (Applied Psychology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:1:applied-psychology` |
| 6 | वर्ष 1 | नर्सिंग फ़ाउंडेशन (Nursing Foundation) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:1:nursing-foundation` |
| 7 | वर्ष 1 | अनुप्रयुक्त जैव रसायन (Applied Biochemistry) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:1:applied-biochemistry` |
| 8 | वर्ष 1 | अनुप्रयुक्त पोषण एवं आहार विज्ञान (Applied Nutrition & Dietetics) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:1:applied-nutrition-dietetics` |
| 9 | वर्ष 1 | स्वास्थ्य / नर्सिंग सूचना विज्ञान एवं तकनीक (Health / Nursing Informatics & Technology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:1:health-nursing-informatics-technology` |
| 10 | वर्ष 2 | अनुप्रयुक्त सूक्ष्मजीव विज्ञान एवं संक्रमण नियंत्रण (Applied Microbiology & Infection Control) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:2:applied-microbiology-infection-control` |
| 11 | वर्ष 2 | फ़ार्माकोलॉजी (Pharmacology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:2:pharmacology` |
| 12 | वर्ष 2 | पैथोलॉजी एवं आनुवंशिकी (Pathology & Genetics) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:2:pathology-genetics` |
| 13 | वर्ष 2 | वयस्क स्वास्थ्य (मेडिकल सर्जिकल) नर्सिंग-I (Adult Health (Medical Surgical) Nursing-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:2:adult-health-medical-surgical-nursing-i` |
| 14 | वर्ष 2 | सामुदायिक स्वास्थ्य नर्सिंग-I (Community Health Nursing-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:2:community-health-nursing-i` |
| 15 | वर्ष 2 | शैक्षिक तकनीक / नर्सिंग शिक्षा (Educational Technology / Nursing Education) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:2:educational-technology-nursing-education` |
| 16 | वर्ष 3 | वयस्क स्वास्थ्य (मेडिकल सर्जिकल) नर्सिंग-II (Adult Health (Medical Surgical) Nursing-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:3:adult-health-medical-surgical-nursing-ii` |
| 17 | वर्ष 3 | बाल स्वास्थ्य नर्सिंग (Child Health Nursing) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:3:child-health-nursing` |
| 18 | वर्ष 3 | मानसिक स्वास्थ्य नर्सिंग (Mental Health Nursing) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:3:mental-health-nursing` |
| 19 | वर्ष 3 | व्यावसायिकता, नैतिकता एवं कानून (Professionalism, Ethics & Law) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:3:professionalism-ethics-law` |
| 20 | वर्ष 3 | नर्सिंग शोध एवं सांख्यिकी (Nursing Research & Statistics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:3:nursing-research-statistics` |
| 21 | वर्ष 3 | मिडवाइफ़री / प्रसूति एवं स्त्री रोग नर्सिंग-I (Midwifery / Obstetrics & Gynaecology Nursing-I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:3:midwifery-obstetrics-gynaecology-nursing-i` |
| 22 | वर्ष 4 | सामुदायिक स्वास्थ्य नर्सिंग-II (Community Health Nursing-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:4:community-health-nursing-ii` |
| 23 | वर्ष 4 | नर्सिंग प्रबंधन एवं नेतृत्व (Nursing Management & Leadership) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:4:nursing-management-leadership` |
| 24 | वर्ष 4 | मिडवाइफ़री / प्रसूति एवं स्त्री रोग नर्सिंग-II (Midwifery / Obstetrics & Gynaecology Nursing-II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc-nursing:4:midwifery-obstetrics-gynaecology-nursing-ii` |
| 25 | वर्ष 4 | इंटर्नशिप (Internship) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:bsc-nursing:4:internship` |

#### बी.फ़ार्मा (फ़ार्मेसी स्नातक) — B.Pharm (Bachelor of Pharmacy) (33 किताबें · प्रोफ़ाइल: medical, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | मानव शरीर रचना एवं क्रिया विज्ञान I एवं II (Human Anatomy & Physiology I & II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bpharm:1:human-anatomy-physiology-i-ii` |
| 2 | वर्ष 1 | फ़ार्मास्युटिकल विश्लेषण I (Pharmaceutical Analysis I) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:1:pharmaceutical-analysis-i` |
| 3 | वर्ष 1 | फ़ार्मास्युटिक्स I (Pharmaceutics I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bpharm:1:pharmaceutics-i` |
| 4 | वर्ष 1 | फ़ार्मास्युटिकल अकार्बनिक रसायन (Pharmaceutical Inorganic Chemistry) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:1:pharmaceutical-inorganic-chemistry` |
| 5 | वर्ष 1 | फ़ार्मास्युटिकल कार्बनिक रसायन I (Pharmaceutical Organic Chemistry I) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:1:pharmaceutical-organic-chemistry-i` |
| 6 | वर्ष 1 | जैव रसायन (Biochemistry) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:1:biochemistry` |
| 7 | वर्ष 1 | पैथोफ़िज़ियोलॉजी (Pathophysiology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bpharm:1:pathophysiology` |
| 8 | वर्ष 1 | फ़ार्मेसी में कंप्यूटर अनुप्रयोग (Computer Applications in Pharmacy) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:1:computer-applications-in-pharmacy` |
| 9 | वर्ष 1 | पर्यावरण विज्ञान (Environmental Sciences) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bpharm:1:environmental-sciences` |
| 10 | वर्ष 1 | संचार कौशल (Communication Skills) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bpharm:1:communication-skills` |
| 11 | वर्ष 2 | फ़ार्मास्युटिकल कार्बनिक रसायन II एवं III (Pharmaceutical Organic Chemistry II & III) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bpharm:2:pharmaceutical-organic-chemistry-ii-iii` |
| 12 | वर्ष 2 | भौतिक फ़ार्मास्युटिक्स I एवं II (Physical Pharmaceutics I & II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bpharm:2:physical-pharmaceutics-i-ii` |
| 13 | वर्ष 2 | फ़ार्मास्युटिकल सूक्ष्मजीव विज्ञान (Pharmaceutical Microbiology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:2:pharmaceutical-microbiology` |
| 14 | वर्ष 2 | फ़ार्मास्युटिकल इंजीनियरिंग (Pharmaceutical Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bpharm:2:pharmaceutical-engineering` |
| 15 | वर्ष 2 | औषधीय रसायन I (Medicinal Chemistry I) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:2:medicinal-chemistry-i` |
| 16 | वर्ष 2 | फ़ार्माकोलॉजी I (Pharmacology I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bpharm:2:pharmacology-i` |
| 17 | वर्ष 2 | फ़ार्माकोग्नॉसी एवं फ़ाइटोकेमिस्ट्री I (Pharmacognosy & Phytochemistry I) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bpharm:2:pharmacognosy-phytochemistry-i` |
| 18 | वर्ष 3 | औषधीय रसायन II एवं III (Medicinal Chemistry II & III) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bpharm:3:medicinal-chemistry-ii-iii` |
| 19 | वर्ष 3 | औद्योगिक फ़ार्मेसी I एवं II (Industrial Pharmacy I & II) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bpharm:3:industrial-pharmacy-i-ii` |
| 20 | वर्ष 3 | फ़ार्माकोलॉजी II एवं III (Pharmacology II & III) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bpharm:3:pharmacology-ii-iii` |
| 21 | वर्ष 3 | फ़ार्माकोग्नॉसी एवं फ़ाइटोकेमिस्ट्री II (Pharmacognosy & Phytochemistry II) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:3:pharmacognosy-phytochemistry-ii` |
| 22 | वर्ष 3 | फ़ार्मास्युटिकल विधिशास्त्र (Pharmaceutical Jurisprudence) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:3:pharmaceutical-jurisprudence` |
| 23 | वर्ष 3 | हर्बल औषधि प्रौद्योगिकी (Herbal Drug Technology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:3:herbal-drug-technology` |
| 24 | वर्ष 3 | बायोफ़ार्मास्युटिक्स एवं फ़ार्माकोकाइनेटिक्स (Biopharmaceutics & Pharmacokinetics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bpharm:3:biopharmaceutics-pharmacokinetics` |
| 25 | वर्ष 3 | फ़ार्मास्युटिकल जैव प्रौद्योगिकी (Pharmaceutical Biotechnology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:3:pharmaceutical-biotechnology` |
| 26 | वर्ष 3 | गुणवत्ता आश्वासन (Quality Assurance) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:3:quality-assurance` |
| 27 | वर्ष 4 | विश्लेषण की उपकरणीय विधियाँ (Instrumental Methods of Analysis) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:4:instrumental-methods-of-analysis` |
| 28 | वर्ष 4 | नवीन औषधि वितरण प्रणाली (Novel Drug Delivery Systems) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:4:novel-drug-delivery-systems` |
| 29 | वर्ष 4 | फ़ार्मेसी प्रैक्टिस (Pharmacy Practice) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:4:pharmacy-practice` |
| 30 | वर्ष 4 | जैव सांख्यिकी एवं शोध प्रविधि (Biostatistics & Research Methodology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bpharm:4:biostatistics-research-methodology` |
| 31 | वर्ष 4 | सामाजिक एवं निवारक फ़ार्मेसी (Social & Preventive Pharmacy) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bpharm:4:social-preventive-pharmacy` |
| 32 | वर्ष 4 | ऐच्छिक विषय (फ़ार्माकोविजिलेंस / कॉस्मेटिक विज्ञान / फ़ार्मा विपणन) (Electives (Pharmacovigilance / Cosmetic Science / Pharma Marketing)) | ऐच्छिक (इलेक्टिव) | 3 | 📗 पाठ्यपुस्तक | `c:bpharm:4:electives-pharmacovigilance-cosmetic-science-pharma-marketin` |
| 33 | वर्ष 4 | परियोजना (Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:bpharm:4:project` |

#### एमबीबीएस — MBBS (20 किताबें · प्रोफ़ाइल: medical, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | शरीर रचना विज्ञान (Anatomy) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mbbs:1:anatomy` |
| 2 | वर्ष 1 | शरीर क्रिया विज्ञान (Physiology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mbbs:1:physiology` |
| 3 | वर्ष 1 | जैव रसायन (Biochemistry) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mbbs:1:biochemistry` |
| 4 | वर्ष 1 | फ़ाउंडेशन कोर्स एवं परिवार गोद कार्यक्रम (Foundation Course & Family Adoption Programme) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:mbbs:1:foundation-course-family-adoption-programme` |
| 5 | वर्ष 2 | पैथोलॉजी (Pathology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mbbs:2:pathology` |
| 6 | वर्ष 2 | फ़ार्माकोलॉजी (Pharmacology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mbbs:2:pharmacology` |
| 7 | वर्ष 2 | सूक्ष्मजीव विज्ञान (Microbiology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mbbs:2:microbiology` |
| 8 | वर्ष 2 | न्यायालयिक चिकित्सा एवं विष विज्ञान (Forensic Medicine & Toxicology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mbbs:2:forensic-medicine-toxicology` |
| 9 | वर्ष 3 | सामुदायिक चिकित्सा (Community Medicine) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mbbs:3:community-medicine` |
| 10 | वर्ष 3 | नाक-कान-गला (ENT) (Otorhinolaryngology (ENT)) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:mbbs:3:otorhinolaryngology-ent` |
| 11 | वर्ष 3 | नेत्र विज्ञान (Ophthalmology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mbbs:3:ophthalmology` |
| 12 | वर्ष 4 | सामान्य चिकित्सा (General Medicine) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mbbs:4:general-medicine` |
| 13 | वर्ष 4 | सामान्य शल्य चिकित्सा (General Surgery) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mbbs:4:general-surgery` |
| 14 | वर्ष 4 | प्रसूति एवं स्त्री रोग (Obstetrics & Gynaecology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mbbs:4:obstetrics-gynaecology` |
| 15 | वर्ष 4 | बाल रोग (Paediatrics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mbbs:4:paediatrics` |
| 16 | वर्ष 4 | अस्थि रोग (Orthopaedics) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:mbbs:4:orthopaedics` |
| 17 | वर्ष 4 | त्वचा रोग (Dermatology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:mbbs:4:dermatology` |
| 18 | वर्ष 4 | मनोरोग (Psychiatry) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:mbbs:4:psychiatry` |
| 19 | वर्ष 4 | निश्चेतना विज्ञान (Anaesthesiology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:mbbs:4:anaesthesiology` |
| 20 | वर्ष 5 | अनिवार्य रोटेटिंग मेडिकल इंटर्नशिप (Compulsory Rotating Medical Internship) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:mbbs:5:compulsory-rotating-medical-internship` |

#### एलएल.बी. (विधि स्नातक) — LL.B. (Bachelor of Laws) (26 किताबें · प्रोफ़ाइल: law, lab-manual, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | विधिशास्त्र (Jurisprudence) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:llb:1:jurisprudence` |
| 2 | वर्ष 1 | संवैधानिक विधि (Constitutional Law) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:llb:1:constitutional-law` |
| 3 | वर्ष 1 | संविदा विधि (Law of Contract) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:llb:1:law-of-contract` |
| 4 | वर्ष 1 | अपकृत्य विधि एवं उपभोक्ता संरक्षण (Law of Torts & Consumer Protection) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:llb:1:law-of-torts-consumer-protection` |
| 5 | वर्ष 1 | कुटुंब विधि (Family Law) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:llb:1:family-law` |
| 6 | वर्ष 1 | दंड विधि (भारतीय न्याय संहिता) (Criminal Law (Bharatiya Nyaya Sanhita)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:llb:1:criminal-law-bharatiya-nyaya-sanhita` |
| 7 | वर्ष 2 | संपत्ति विधि (Property Law) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:llb:2:property-law` |
| 8 | वर्ष 2 | प्रशासनिक विधि (Administrative Law) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:llb:2:administrative-law` |
| 9 | वर्ष 2 | कंपनी विधि (Company Law) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:llb:2:company-law` |
| 10 | वर्ष 2 | श्रम एवं औद्योगिक विधि (Labour & Industrial Law) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:llb:2:labour-industrial-law` |
| 11 | वर्ष 2 | पर्यावरण विधि (Environmental Law) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:llb:2:environmental-law` |
| 12 | वर्ष 2 | सार्वजनिक अंतरराष्ट्रीय विधि (Public International Law) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:llb:2:public-international-law` |
| 13 | वर्ष 3 | सिविल प्रक्रिया संहिता एवं परिसीमा अधिनियम (Civil Procedure Code & Limitation Act) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:llb:3:civil-procedure-code-limitation-act` |
| 14 | वर्ष 3 | दंड प्रक्रिया (भारतीय नागरिक सुरक्षा संहिता) (Criminal Procedure (Bharatiya Nagarik Suraksha Sanhita)) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:llb:3:criminal-procedure-bharatiya-nagarik-suraksha-sanhita` |
| 15 | वर्ष 3 | साक्ष्य विधि (भारतीय साक्ष्य अधिनियम) (Law of Evidence (Bharatiya Sakshya Adhiniyam)) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:llb:3:law-of-evidence-bharatiya-sakshya-adhiniyam` |
| 16 | वर्ष 3 | विधियों का निर्वचन (Interpretation of Statutes) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:llb:3:interpretation-of-statutes` |
| 17 | वर्ष 3 | व्यावसायिक नैतिकता (Professional Ethics) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:llb:3:professional-ethics` |
| 18 | वर्ष 3 | प्रारूपण, अभिवचन एवं हस्तांतरण लेख (Drafting, Pleading & Conveyancing) | लैब/प्रैक्टिकल | तय करना | 📗 पाठ्यपुस्तक | `c:llb:3:drafting-pleading-conveyancing` |
| 19 | वर्ष 3 | मूट कोर्ट एवं इंटर्नशिप (Moot Court & Internship) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:llb:3:moot-court-internship` |
| 20 | वर्ष 4 | कराधान विधि (Taxation Law) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:llb:4:taxation-law` |
| 21 | वर्ष 4 | बैंकिंग एवं बीमा विधि (Banking & Insurance Law) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:llb:4:banking-insurance-law` |
| 22 | वर्ष 4 | बौद्धिक संपदा विधि (Intellectual Property Law) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:llb:4:intellectual-property-law` |
| 23 | वर्ष 4 | साइबर विधि (Cyber Law) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:llb:4:cyber-law` |
| 24 | वर्ष 5 | वैकल्पिक विवाद समाधान (Alternative Dispute Resolution) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:llb:5:alternative-dispute-resolution` |
| 25 | वर्ष 5 | मानवाधिकार विधि (Human Rights Law) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:llb:5:human-rights-law` |
| 26 | वर्ष 5 | क्लिनिकल विधिक शिक्षा एवं इंटर्नशिप (Clinical Legal Education & Internship) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:llb:5:clinical-legal-education-internship` |

#### बी.सी.ए. (कंप्यूटर एप्लिकेशन) — BCA (Bachelor of Computer Applications) (15 किताबें · प्रोफ़ाइल: ug-science, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | कंप्यूटर के मूल सिद्धांत (Computer Fundamentals) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bca:1:computer-fundamentals` |
| 2 | वर्ष 1 | C में प्रोग्रामिंग (Programming in C) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bca:1:programming-in-c` |
| 3 | वर्ष 1 | कंप्यूटिंग के लिए गणित (Mathematics for Computing) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bca:1:mathematics-for-computing` |
| 4 | वर्ष 1 | डिजिटल इलेक्ट्रॉनिक्स (Digital Electronics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bca:1:digital-electronics` |
| 5 | वर्ष 1 | संचार अंग्रेज़ी (Communication English) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bca:1:communication-english` |
| 6 | वर्ष 2 | डेटा संरचना (Data Structures) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bca:2:data-structures` |
| 7 | वर्ष 2 | C++ के साथ ऑब्जेक्ट ओरिएंटेड प्रोग्रामिंग (Object Oriented Programming with C++) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bca:2:object-oriented-programming-with-c` |
| 8 | वर्ष 2 | डेटाबेस प्रबंधन प्रणाली (Database Management Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bca:2:database-management-systems` |
| 9 | वर्ष 2 | ऑपरेटिंग सिस्टम (Operating Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bca:2:operating-systems` |
| 10 | वर्ष 2 | कंप्यूटर नेटवर्क (Computer Networks) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bca:2:computer-networks` |
| 11 | वर्ष 3 | जावा प्रोग्रामिंग (Java Programming) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bca:3:java-programming` |
| 12 | वर्ष 3 | वेब तकनीकें (Web Technologies) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bca:3:web-technologies` |
| 13 | वर्ष 3 | सॉफ़्टवेयर इंजीनियरिंग (Software Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bca:3:software-engineering` |
| 14 | वर्ष 3 | पायथन प्रोग्रामिंग (Python Programming) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bca:3:python-programming` |
| 15 | वर्ष 3 | परियोजना (Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:bca:3:project` |

#### बी.बी.ए. (व्यवसाय प्रशासन) — BBA (Bachelor of Business Administration) (16 किताबें · प्रोफ़ाइल: ug-commerce, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | प्रबंधन के सिद्धांत (Principles of Management) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bba:1:principles-of-management` |
| 2 | वर्ष 1 | व्यावसायिक अर्थशास्त्र (Business Economics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bba:1:business-economics` |
| 3 | वर्ष 1 | वित्तीय लेखांकन (Financial Accounting) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bba:1:financial-accounting` |
| 4 | वर्ष 1 | व्यावसायिक संचार (Business Communication) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bba:1:business-communication` |
| 5 | वर्ष 1 | व्यावसायिक गणित एवं सांख्यिकी (Business Mathematics & Statistics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bba:1:business-mathematics-statistics` |
| 6 | वर्ष 2 | संगठनात्मक व्यवहार (Organisational Behaviour) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bba:2:organisational-behaviour` |
| 7 | वर्ष 2 | विपणन प्रबंधन (Marketing Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bba:2:marketing-management` |
| 8 | वर्ष 2 | मानव संसाधन प्रबंधन (Human Resource Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bba:2:human-resource-management` |
| 9 | वर्ष 2 | लागत एवं प्रबंधन लेखांकन (Cost & Management Accounting) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bba:2:cost-management-accounting` |
| 10 | वर्ष 2 | व्यावसायिक विधि (Business Law) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bba:2:business-law` |
| 11 | वर्ष 3 | वित्तीय प्रबंधन (Financial Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bba:3:financial-management` |
| 12 | वर्ष 3 | उत्पादन एवं संचालन प्रबंधन (Production & Operations Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bba:3:production-operations-management` |
| 13 | वर्ष 3 | उद्यमिता विकास (Entrepreneurship Development) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bba:3:entrepreneurship-development` |
| 14 | वर्ष 3 | रणनीतिक प्रबंधन (Strategic Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bba:3:strategic-management` |
| 15 | वर्ष 3 | शोध प्रविधि (Research Methodology) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bba:3:research-methodology` |
| 16 | वर्ष 3 | परियोजना (Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:bba:3:project` |

#### बी.एससी. कृषि — B.Sc. Agriculture (24 किताबें · प्रोफ़ाइल: ug-science, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | शस्य विज्ञान के मूल सिद्धांत (Fundamentals of Agronomy) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:1:fundamentals-of-agronomy` |
| 2 | वर्ष 1 | मृदा विज्ञान के मूल सिद्धांत (Fundamentals of Soil Science) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:1:fundamentals-of-soil-science` |
| 3 | वर्ष 1 | उद्यानिकी के मूल सिद्धांत (Fundamentals of Horticulture) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:1:fundamentals-of-horticulture` |
| 4 | वर्ष 1 | आनुवंशिकी के मूल सिद्धांत (Fundamentals of Genetics) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:1:fundamentals-of-genetics` |
| 5 | वर्ष 1 | कृषि सूक्ष्मजीव विज्ञान (Agricultural Microbiology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:1:agricultural-microbiology` |
| 6 | वर्ष 1 | कीट विज्ञान के मूल सिद्धांत (Fundamentals of Entomology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:1:fundamentals-of-entomology` |
| 7 | वर्ष 1 | ग्रामीण समाजशास्त्र एवं शैक्षिक मनोविज्ञान (Rural Sociology & Educational Psychology) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:1:rural-sociology-educational-psychology` |
| 8 | वर्ष 2 | फसल उत्पादन (खरीफ़ एवं रबी फसलें) (Crop Production (Kharif & Rabi Crops)) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:2:crop-production-kharif-rabi-crops` |
| 9 | वर्ष 2 | पादप रोग विज्ञान के मूल सिद्धांत (Fundamentals of Plant Pathology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:2:fundamentals-of-plant-pathology` |
| 10 | वर्ष 2 | कृषि अर्थशास्त्र (Agricultural Economics) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:2:agricultural-economics` |
| 11 | वर्ष 2 | पादप प्रजनन के सिद्धांत (Principles of Plant Breeding) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:2:principles-of-plant-breeding` |
| 12 | वर्ष 2 | मृदा उर्वरता एवं पोषक प्रबंधन (Soil Fertility & Nutrient Management) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:2:soil-fertility-nutrient-management` |
| 13 | वर्ष 2 | पशुधन एवं कुक्कुट प्रबंधन (Livestock & Poultry Management) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:2:livestock-poultry-management` |
| 14 | वर्ष 2 | कृषि मशीनरी एवं शक्ति (Farm Machinery & Power) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:2:farm-machinery-power` |
| 15 | वर्ष 3 | कृषि विपणन एवं व्यापार (Agricultural Marketing & Trade) | थ्योरी | 3 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:3:agricultural-marketing-trade` |
| 16 | वर्ष 3 | फसलों एवं भंडारित अनाज के कीट (Pests of Crops & Stored Grain) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:3:pests-of-crops-stored-grain` |
| 17 | वर्ष 3 | खेत एवं उद्यानिकी फसलों के रोग (Diseases of Field & Horticultural Crops) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:3:diseases-of-field-horticultural-crops` |
| 18 | वर्ष 3 | बीज प्रौद्योगिकी के सिद्धांत (Principles of Seed Technology) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:3:principles-of-seed-technology` |
| 19 | वर्ष 3 | सिंचाई जल प्रबंधन (Irrigation Water Management) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:3:irrigation-water-management` |
| 20 | वर्ष 3 | कृषि प्रसार शिक्षा (Agricultural Extension Education) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:3:agricultural-extension-education` |
| 21 | वर्ष 3 | कटाई उपरांत प्रबंधन (Post-harvest Management) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:3:post-harvest-management` |
| 22 | वर्ष 4 | ग्रामीण कृषि कार्य अनुभव (RAWE) (Rural Agricultural Work Experience (RAWE)) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:bsc-agriculture:4:rural-agricultural-work-experience-rawe` |
| 23 | वर्ष 4 | अनुभवात्मक अधिगम कार्यक्रम (Experiential Learning Programme) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:bsc-agriculture:4:experiential-learning-programme` |
| 24 | वर्ष 4 | ऐच्छिक विषय (कृषि व्यवसाय / संरक्षित खेती / जैविक खेती) (Electives (Agri-business / Protected Cultivation / Organic Farming)) | ऐच्छिक (इलेक्टिव) | 3 | 📗 पाठ्यपुस्तक | `c:bsc-agriculture:4:electives-agri-business-protected-cultivation-organic-farmin` |

### स्नातकोत्तर

#### एम.बी.ए. — MBA (14 किताबें · प्रोफ़ाइल: ug-commerce, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | प्रबंधन सिद्धांत एवं संगठनात्मक व्यवहार (Management Principles & Organisational Behaviour) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:mba:1:management-principles-organisational-behaviour` |
| 2 | वर्ष 1 | प्रबंधकीय अर्थशास्त्र (Managerial Economics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mba:1:managerial-economics` |
| 3 | वर्ष 1 | प्रबंधकों के लिए लेखांकन (Accounting for Managers) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:mba:1:accounting-for-managers` |
| 4 | वर्ष 1 | विपणन प्रबंधन (Marketing Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mba:1:marketing-management` |
| 5 | वर्ष 1 | मानव संसाधन प्रबंधन (Human Resource Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mba:1:human-resource-management` |
| 6 | वर्ष 1 | व्यावसायिक सांख्यिकी एवं विश्लेषण (Business Statistics & Analytics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mba:1:business-statistics-analytics` |
| 7 | वर्ष 1 | वित्तीय प्रबंधन (Financial Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mba:1:financial-management` |
| 8 | वर्ष 1 | संचालन प्रबंधन (Operations Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mba:1:operations-management` |
| 9 | वर्ष 1 | व्यावसायिक संचार (Business Communication) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mba:1:business-communication` |
| 10 | वर्ष 2 | रणनीतिक प्रबंधन (Strategic Management) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mba:2:strategic-management` |
| 11 | वर्ष 2 | व्यावसायिक शोध विधियाँ (Business Research Methods) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mba:2:business-research-methods` |
| 12 | वर्ष 2 | विशेषज्ञता ऐच्छिक (विपणन / वित्त / HR / संचालन) (Specialisation Electives (Marketing / Finance / HR / Operations)) | ऐच्छिक (इलेक्टिव) | 4 | 📗 पाठ्यपुस्तक | `c:mba:2:specialisation-electives-marketing-finance-hr-operations` |
| 13 | वर्ष 2 | समर इंटर्नशिप परियोजना (Summer Internship Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:mba:2:summer-internship-project` |
| 14 | वर्ष 2 | अंतिम परियोजना (Final Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:mba:2:final-project` |

#### एम.सी.ए. — MCA (12 किताबें · प्रोफ़ाइल: ug-science, project-guide)

| # | साल/सेमेस्टर | विषय | प्रकार | अध्याय | पहला संस्करण | book_key |
|---|---|---|---|---|---|---|
| 1 | वर्ष 1 | डेटा संरचना एवं एल्गोरिदम (Data Structures & Algorithms) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mca:1:data-structures-algorithms` |
| 2 | वर्ष 1 | जावा के साथ ऑब्जेक्ट ओरिएंटेड प्रोग्रामिंग (Object Oriented Programming with Java) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mca:1:object-oriented-programming-with-java` |
| 3 | वर्ष 1 | डेटाबेस प्रबंधन प्रणाली (Database Management Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mca:1:database-management-systems` |
| 4 | वर्ष 1 | ऑपरेटिंग सिस्टम (Operating Systems) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mca:1:operating-systems` |
| 5 | वर्ष 1 | कंप्यूटर नेटवर्क (Computer Networks) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mca:1:computer-networks` |
| 6 | वर्ष 1 | असतत गणित (Discrete Mathematics) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mca:1:discrete-mathematics` |
| 7 | वर्ष 2 | सॉफ़्टवेयर इंजीनियरिंग (Software Engineering) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mca:2:software-engineering` |
| 8 | वर्ष 2 | वेब तकनीकें (Web Technologies) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mca:2:web-technologies` |
| 9 | वर्ष 2 | पायथन एवं डेटा साइंस (Python & Data Science) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:mca:2:python-data-science` |
| 10 | वर्ष 2 | क्लाउड कंप्यूटिंग (Cloud Computing) | थ्योरी | 4 | 📗 पाठ्यपुस्तक | `c:mca:2:cloud-computing` |
| 11 | वर्ष 2 | कृत्रिम बुद्धिमत्ता एवं मशीन लर्निंग (Artificial Intelligence & Machine Learning) | थ्योरी | 5 | 📗 पाठ्यपुस्तक | `c:mca:2:artificial-intelligence-machine-learning` |
| 12 | वर्ष 2 | परियोजना (Project) | प्रोजेक्ट/इंटर्नशिप | तय करना | 🧑‍🏫 शिक्षक | `c:mca:2:project` |

## 5. पूरी सूची — प्रतियोगी परीक्षा की किताबें

एक लेवल की सब परीक्षाएँ एक ही किताब पढ़ती हैं (जैसे SSC CGL, CHSL, RRB NTPC सब "सरकारी (सामान्य)" की गणित किताब)।

### उच्च शोध — Advanced Research (4 किताबें · प्रोफ़ाइल: exam-research)

| # | विषय | अध्याय | किन परीक्षाओं के लिए | पहला संस्करण | book_key |
|---|---|---|---|---|---|
| 1 | सामान्य विज्ञान (General Science) | 51 | CSIR NET | 📗 पाठ्यपुस्तक | `s:advanced_research:general-science` |
| 2 | गणित (Mathematics) | 16 | CSIR NET | 📗 पाठ्यपुस्तक | `s:advanced_research:maths` |
| 3 | रीज़निंग (Reasoning) | 12 | UGC NET, CSIR NET | 📗 पाठ्यपुस्तक | `s:advanced_research:reasoning` |
| 4 | शिक्षण एवं शोध अभिरुचि (Teaching & Research Aptitude) | तय करना | UGC NET | 📗 पाठ्यपुस्तक | `s:advanced_research:teaching-aptitude` |

### बैंकिंग — Banking (6 किताबें · प्रोफ़ाइल: exam-banking)

| # | विषय | अध्याय | किन परीक्षाओं के लिए | पहला संस्करण | book_key |
|---|---|---|---|---|---|
| 1 | कंप्यूटर की बुनियादी बातें (Basics of Computers) | तय करना | SBI PO, IBPS PO, IBPS RRB (Regional Rural Banks), SBI Clerk, IBPS Clerk, RBI Assistant | 🎯 परीक्षा | `s:banking:computer-basics` |
| 2 | अंग्रेज़ी भाषा (English Language) | तय करना | SBI PO, IBPS PO, LIC AAO, IBPS RRB (Regional Rural Banks), SBI Clerk, IBPS Clerk, RBI Grade B, RBI Assistant | 🎯 परीक्षा | `s:banking:english` |
| 3 | सामान्य जागरूकता (General Awareness) | 9 | SBI PO, IBPS PO, LIC AAO, IBPS RRB (Regional Rural Banks), SBI Clerk, IBPS Clerk, RBI Grade B, RBI Assistant | 🎯 परीक्षा | `s:banking:general-awareness` |
| 4 | हिंदी भाषा (Hindi Language) | तय करना | IBPS RRB (Regional Rural Banks) | 🎯 परीक्षा | `s:banking:hindi` |
| 5 | गणित (Mathematics) | 16 | SBI PO, IBPS PO, LIC AAO, IBPS RRB (Regional Rural Banks), SBI Clerk, IBPS Clerk, RBI Grade B, RBI Assistant | 🎯 परीक्षा | `s:banking:maths` |
| 6 | रीज़निंग (Reasoning) | 12 | SBI PO, IBPS PO, LIC AAO, IBPS RRB (Regional Rural Banks), SBI Clerk, IBPS Clerk, RBI Grade B, RBI Assistant | 🎯 परीक्षा | `s:banking:reasoning` |

### कक्षा 11-12 विज्ञान — Class 11-12 Science (4 किताबें · प्रोफ़ाइल: exam-entrance)

| # | विषय | अध्याय | किन परीक्षाओं के लिए | पहला संस्करण | book_key |
|---|---|---|---|---|---|
| 1 | अंग्रेज़ी भाषा (English Language) | तय करना | CUET UG | 🎯 परीक्षा | `s:class_11_12_sci:english` |
| 2 | सामान्य जागरूकता (General Awareness) | 9 | CUET UG | 🎯 परीक्षा | `s:class_11_12_sci:general-awareness` |
| 3 | गणित (Mathematics) | 16 | CUET UG | 🎯 परीक्षा | `s:class_11_12_sci:maths` |
| 4 | रीज़निंग (Reasoning) | 12 | CUET UG | 🎯 परीक्षा | `s:class_11_12_sci:reasoning` |

### कक्षा 6-8 — Class 6-8 (4 किताबें · प्रोफ़ाइल: exam-entrance)

| # | विषय | अध्याय | किन परीक्षाओं के लिए | पहला संस्करण | book_key |
|---|---|---|---|---|---|
| 1 | अंग्रेज़ी भाषा (English Language) | तय करना | Sainik School entrance (AISSEE) | 🎯 परीक्षा | `s:class_6_8:english` |
| 2 | सामान्य जागरूकता (General Awareness) | 9 | Sainik School entrance (AISSEE) | 🎯 परीक्षा | `s:class_6_8:general-awareness` |
| 3 | सामान्य विज्ञान (General Science) | 51 | Sainik School entrance (AISSEE) | 🎯 परीक्षा | `s:class_6_8:general-science` |
| 4 | गणित (Mathematics) | 16 | Sainik School entrance (AISSEE) | 🎯 परीक्षा | `s:class_6_8:maths` |

### कक्षा 9-10 — Class 9-10 (3 किताबें · प्रोफ़ाइल: exam-entrance)

| # | विषय | अध्याय | किन परीक्षाओं के लिए | पहला संस्करण | book_key |
|---|---|---|---|---|---|
| 1 | सामान्य विज्ञान (General Science) | 51 | Olympiad (Maths / Science), Polytechnic entrance (DCECE, JEECUP etc.) | 🎯 परीक्षा | `s:class_9_10:general-science` |
| 2 | गणित (Mathematics) | 16 | Olympiad (Maths / Science), Polytechnic entrance (DCECE, JEECUP etc.) | 🎯 परीक्षा | `s:class_9_10:maths` |
| 3 | रीज़निंग (Reasoning) | 12 | Olympiad (Maths / Science) | 🎯 परीक्षा | `s:class_9_10:reasoning` |

### इंजीनियरिंग — Engineering (2 किताबें · प्रोफ़ाइल: exam-entrance)

| # | विषय | अध्याय | किन परीक्षाओं के लिए | पहला संस्करण | book_key |
|---|---|---|---|---|---|
| 1 | सामान्य विज्ञान (General Science, only: physics + chemistry) | 31 | JEE Main, State engineering entrance (MHT CET, WBJEE, BCECE etc.), JEE Advanced | 🎯 परीक्षा | `s:engineering:general-science` |
| 2 | गणित (Mathematics) | 16 | JEE Main, State engineering entrance (MHT CET, WBJEE, BCECE etc.), JEE Advanced | 🎯 परीक्षा | `s:engineering:maths` |

### सरकारी (सामान्य) — Govt Basic (9 किताबें · प्रोफ़ाइल: exam-basic)

| # | विषय | अध्याय | किन परीक्षाओं के लिए | पहला संस्करण | book_key |
|---|---|---|---|---|---|
| 1 | बाल विकास एवं शिक्षाशास्त्र (Child Development & Pedagogy) | तय करना | CTET, KVS / NVS Teacher, State TET, State teacher recruitment (BPSC TRE, UP TGT/PGT, REET Mains etc.) | 🎯 परीक्षा | `s:govt_basic:child-development-pedagogy` |
| 2 | कंप्यूटर की बुनियादी बातें (Basics of Computers) | तय करना | KVS / NVS Teacher | 🎯 परीक्षा | `s:govt_basic:computer-basics` |
| 3 | अंग्रेज़ी भाषा (English Language) | तय करना | CTET, DSSSB (Delhi Subordinate Services), SSC GD Constable, KVS / NVS Teacher, SSC CGL, SSC CPO (SI in Delhi Police & CAPF), SSC MTS, SSC CHSL, SSC Stenographer, State TET, State teacher recruitment (BPSC TRE, UP TGT/PGT, REET Mains etc.), SSC Selection Post | 🎯 परीक्षा | `s:govt_basic:english` |
| 4 | पर्यावरण और प्रदूषण नियंत्रण (Environment & Pollution Control) | तय करना | CTET, State TET | 🎯 परीक्षा | `s:govt_basic:environment` |
| 5 | सामान्य जागरूकता (General Awareness) | 9 | DSSSB (Delhi Subordinate Services), RPF Sub-Inspector, SSC GD Constable, KVS / NVS Teacher, SSC CGL, SSC CPO (SI in Delhi Police & CAPF), SSC MTS, RRB NTPC, SSC CHSL, State Police Sub-Inspector (SI), SSC Stenographer, State SSC (BSSC, UPSSSC, HSSC, RSMSSB etc.), RRB Group D, RPF Constable, State teacher recruitment (BPSC TRE, UP TGT/PGT, REET Mains etc.), State Police Constable, SSC Selection Post | 🎯 परीक्षा | `s:govt_basic:general-awareness` |
| 6 | सामान्य विज्ञान (General Science) | 51 | CTET, RRB NTPC, State Police Sub-Inspector (SI), State SSC (BSSC, UPSSSC, HSSC, RSMSSB etc.), State TET, RRB Group D, State teacher recruitment (BPSC TRE, UP TGT/PGT, REET Mains etc.) | 🎯 परीक्षा | `s:govt_basic:general-science` |
| 7 | हिंदी भाषा (Hindi Language) | तय करना | CTET, DSSSB (Delhi Subordinate Services), SSC GD Constable, KVS / NVS Teacher, State Police Sub-Inspector (SI), State SSC (BSSC, UPSSSC, HSSC, RSMSSB etc.), State TET, State teacher recruitment (BPSC TRE, UP TGT/PGT, REET Mains etc.), State Police Constable | 🎯 परीक्षा | `s:govt_basic:hindi` |
| 8 | गणित (Mathematics) | 16 | CTET, DSSSB (Delhi Subordinate Services), RPF Sub-Inspector, SSC GD Constable, SSC CGL, SSC CPO (SI in Delhi Police & CAPF), SSC MTS, RRB NTPC, SSC CHSL, State Police Sub-Inspector (SI), State SSC (BSSC, UPSSSC, HSSC, RSMSSB etc.), State TET, RRB Group D, RPF Constable, State teacher recruitment (BPSC TRE, UP TGT/PGT, REET Mains etc.), State Police Constable, SSC Selection Post | 🎯 परीक्षा | `s:govt_basic:maths` |
| 9 | रीज़निंग (Reasoning) | 12 | DSSSB (Delhi Subordinate Services), RPF Sub-Inspector, SSC GD Constable, KVS / NVS Teacher, SSC CGL, SSC CPO (SI in Delhi Police & CAPF), SSC MTS, RRB NTPC, SSC CHSL, State Police Sub-Inspector (SI), SSC Stenographer, State SSC (BSSC, UPSSSC, HSSC, RSMSSB etc.), RRB Group D, RPF Constable, State Police Constable, SSC Selection Post | 🎯 परीक्षा | `s:govt_basic:reasoning` |

### रक्षा — Defence (5 किताबें · प्रोफ़ाइल: exam-defence)

| # | विषय | अध्याय | किन परीक्षाओं के लिए | पहला संस्करण | book_key |
|---|---|---|---|---|---|
| 1 | अंग्रेज़ी भाषा (English Language) | तय करना | CDS, NDA, AFCAT (Air Force officer), Army TES (10+2 Technical Entry), Agniveer (Navy), Agniveer Vayu (Air Force) | 🎯 परीक्षा | `s:govt_defence:english` |
| 2 | सामान्य जागरूकता (General Awareness) | 9 | CDS, NDA, AFCAT (Air Force officer), Agniveer (Army), Agniveer (Navy), Agniveer Vayu (Air Force) | 🎯 परीक्षा | `s:govt_defence:general-awareness` |
| 3 | सामान्य विज्ञान (General Science) | 51 | CDS, NDA, Army TES (10+2 Technical Entry), Agniveer (Army), Agniveer (Navy), Agniveer Vayu (Air Force) | 🎯 परीक्षा | `s:govt_defence:general-science` |
| 4 | गणित (Mathematics) | 16 | CDS, NDA, AFCAT (Air Force officer), Army TES (10+2 Technical Entry), Agniveer (Army), Agniveer (Navy), Agniveer Vayu (Air Force) | 🎯 परीक्षा | `s:govt_defence:maths` |
| 5 | रीज़निंग (Reasoning) | 12 | AFCAT (Air Force officer), Army TES (10+2 Technical Entry), Agniveer (Army), Agniveer Vayu (Air Force) | 🎯 परीक्षा | `s:govt_defence:reasoning` |

### सरकारी (तकनीकी) — Govt Technical (22 किताबें · प्रोफ़ाइल: exam-technical)

| # | विषय | अध्याय | किन परीक्षाओं के लिए | पहला संस्करण | book_key |
|---|---|---|---|---|---|
| 1 | सिविल इंजीनियरिंग (Civil Engineering) | 12 | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:civil-engineering` |
| 2 | कंप्यूटर की बुनियादी बातें (Basics of Computers) | तय करना | RRB JE | 🎯 परीक्षा | `s:govt_technical:computer-basics` |
| 3 | कंप्यूटर साइंस इंजीनियरिंग (Computer Science Engineering) | तय करना | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:computer-engineering` |
| 4 | इलेक्ट्रिकल इंजीनियरिंग (Electrical Engineering) | 6 | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:electrical-engineering` |
| 5 | इलेक्ट्रॉनिक्स एवं संचार इंजीनियरिंग (Electronics & Communication Engineering) | तय करना | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:electronics-engineering` |
| 6 | पर्यावरण और प्रदूषण नियंत्रण (Environment & Pollution Control) | तय करना | RRB JE | 🎯 परीक्षा | `s:govt_technical:environment` |
| 7 | सामान्य जागरूकता (General Awareness) | 9 | UPSC ESE (IES), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:general-awareness` |
| 8 | सामान्य विज्ञान (General Science) | 51 | RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), RRB Technician | 🎯 परीक्षा | `s:govt_technical:general-science` |
| 9 | गणित (Mathematics) | 16 | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician | 🎯 परीक्षा | `s:govt_technical:maths` |
| 10 | इंजीनियरिंग मैकेनिक्स (Engineering Mechanics) | 1 | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:mechanical-engineering~engineering-mechanics` |
| 11 | पदार्थों की सामर्थ्य (SOM) (Strength of Materials) | 1 | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:mechanical-engineering~strength-of-materials` |
| 12 | मशीनों का सिद्धांत (TOM) (Theory of Machines) | 1 | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:mechanical-engineering~theory-of-machines` |
| 13 | मशीन डिज़ाइन (Machine Design) | 1 | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:mechanical-engineering~machine-design` |
| 14 | इंजीनियरिंग सामग्री (Engineering Materials) | 1 | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:mechanical-engineering~engineering-materials` |
| 15 | थर्मल इंजीनियरिंग (Thermal Engineering) | 7 | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:mechanical-engineering~thermal-engineering` |
| 16 | द्रव यांत्रिकी और मशीनरी (Fluid Mechanics & Machinery) | 1 | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:mechanical-engineering~fluid-mechanics` |
| 17 | औद्योगिक अभियांत्रिकी (Industrial Engineering) | 1 | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:mechanical-engineering~industrial-engineering` |
| 18 | उत्पादन इंजीनियरिंग (Production Engineering) | 1 | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:mechanical-engineering~production-engineering` |
| 19 | मापिकी और मापन (Metrology & Measurement) | 1 | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:mechanical-engineering~metrology` |
| 20 | उन्नत विनिर्माण (Advanced Manufacturing) | 1 | UPSC ESE (IES), GATE, Lateral Entry B.Tech (LEET), RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State AE (Assistant Engineer), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:mechanical-engineering~advanced-manufacturing` |
| 21 | रीज़निंग (Reasoning) | 12 | UPSC ESE (IES), GATE, RRB JE, SSC JE, RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), State JE (BSSC, UPSSSC, MPESB etc.), RRB Technician, PSU Diploma Trainee (BHEL, NTPC, PGCIL, SAIL), ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:reasoning` |
| 22 | ट्रेड थ्योरी (ITI) (Trade Theory (ITI)) | तय करना | RRB ALP (Assistant Loco Pilot), Metro JE / Maintainer (DMRC etc.), RRB Technician, ISRO / DRDO Technician & Technical Assistant | 🎯 परीक्षा | `s:govt_technical:trade-theory` |

### स्नातक विज्ञान — Graduation Science (4 किताबें · प्रोफ़ाइल: exam-banking)

| # | विषय | अध्याय | किन परीक्षाओं के लिए | पहला संस्करण | book_key |
|---|---|---|---|---|---|
| 1 | अंग्रेज़ी भाषा (English Language) | तय करना | Agriculture Officer (IBPS AFO, State Agriculture Officer) | 🎯 परीक्षा | `s:graduation_sci:english` |
| 2 | सामान्य जागरूकता (General Awareness) | 9 | Agriculture Officer (IBPS AFO, State Agriculture Officer) | 🎯 परीक्षा | `s:graduation_sci:general-awareness` |
| 3 | सामान्य विज्ञान (General Science, only: biology + chemistry) | 35 | Agriculture Officer (IBPS AFO, State Agriculture Officer) | 🎯 परीक्षा | `s:graduation_sci:general-science` |
| 4 | रीज़निंग (Reasoning) | 12 | Agriculture Officer (IBPS AFO, State Agriculture Officer) | 🎯 परीक्षा | `s:graduation_sci:reasoning` |

### कानून / प्रबंधन — Law / Management (9 किताबें · प्रोफ़ाइल: exam-law-mgmt)

| # | विषय | अध्याय | किन परीक्षाओं के लिए | पहला संस्करण | book_key |
|---|---|---|---|---|---|
| 1 | अंग्रेज़ी भाषा (English Language) | तय करना | Judicial Services (Civil Judge) | 🎯 परीक्षा | `s:law_management:english` |
| 2 | अंग्रेज़ी (कानून) (English (Law)) | 4 | CAT / MBA entrance, CLAT | 🎯 परीक्षा | `s:law_management:english-law` |
| 3 | सामान्य जागरूकता (General Awareness) | 9 | CLAT, Judicial Services (Civil Judge) | 🎯 परीक्षा | `s:law_management:general-awareness` |
| 4 | हिंदी भाषा (Hindi Language) | तय करना | Judicial Services (Civil Judge) | 🎯 परीक्षा | `s:law_management:hindi` |
| 5 | विधि (कानून) विषय (Law Subjects) | तय करना | Judicial Services (Civil Judge) | 🎯 परीक्षा | `s:law_management:law` |
| 6 | विधिक योग्यता (Legal Aptitude) | 5 | CLAT | 🎯 परीक्षा | `s:law_management:legal-aptitude` |
| 7 | विधिक तर्क (Legal Reasoning) | 5 | CLAT | 🎯 परीक्षा | `s:law_management:legal-reasoning` |
| 8 | मात्रात्मक योग्यता (Quantitative Aptitude (Law)) | 4 | CAT / MBA entrance, CLAT | 🎯 परीक्षा | `s:law_management:quant-law` |
| 9 | रीज़निंग (Reasoning) | 12 | CAT / MBA entrance | 🎯 परीक्षा | `s:law_management:reasoning` |

### मेडिकल — Medical (8 किताबें · प्रोफ़ाइल: exam-entrance, exam-health)

| # | विषय | अध्याय | किन परीक्षाओं के लिए | पहला संस्करण | book_key |
|---|---|---|---|---|---|
| 1 | अंग्रेज़ी भाषा (English Language) | तय करना | Nursing entrance (B.Sc Nursing) | 🎯 परीक्षा | `s:medical:english` |
| 2 | सामान्य जागरूकता (General Awareness) | 9 | Pharmacist recruitment, Nursing Officer (AIIMS NORCET, State), RRB Paramedical (Staff Nurse, Pharmacist), Nursing entrance (B.Sc Nursing) | 🎯 परीक्षा | `s:medical:general-awareness` |
| 3 | सामान्य विज्ञान (General Science) | 51 | NEET UG, RRB Paramedical (Staff Nurse, Pharmacist), Nursing entrance (B.Sc Nursing) | 🎯 परीक्षा | `s:medical:general-science` |
| 4 | गणित (Mathematics) | 16 | RRB Paramedical (Staff Nurse, Pharmacist) | 🎯 परीक्षा | `s:medical:maths` |
| 5 | चिकित्सा विषय (MBBS) (Medical Subjects (MBBS)) | तय करना | NEET PG | 🎯 परीक्षा | `s:medical:medicine` |
| 6 | नर्सिंग (Nursing) | तय करना | Nursing Officer (AIIMS NORCET, State), RRB Paramedical (Staff Nurse, Pharmacist) | 🎯 परीक्षा | `s:medical:nursing` |
| 7 | फ़ार्मेसी (Pharmacy) | तय करना | GPAT, Pharmacist recruitment, RRB Paramedical (Staff Nurse, Pharmacist) | 🎯 परीक्षा | `s:medical:pharmacy` |
| 8 | रीज़निंग (Reasoning) | 12 | RRB Paramedical (Staff Nurse, Pharmacist) | 🎯 परीक्षा | `s:medical:reasoning` |

### राज्य PSC — State PSC (5 किताबें · प्रोफ़ाइल: exam-civil-services)

| # | विषय | अध्याय | किन परीक्षाओं के लिए | पहला संस्करण | book_key |
|---|---|---|---|---|---|
| 1 | सामान्य जागरूकता (General Awareness) | 9 | BPSC, MPPSC, UPPSC, RPSC RAS, Other State PSC (HPSC, JPSC, WBPSC, OPSC etc.) | 📗 पाठ्यपुस्तक | `s:state_psc:general-awareness` |
| 2 | सामान्य विज्ञान (General Science) | 51 | BPSC, MPPSC, UPPSC, RPSC RAS, Other State PSC (HPSC, JPSC, WBPSC, OPSC etc.) | 📗 पाठ्यपुस्तक | `s:state_psc:general-science` |
| 3 | हिंदी भाषा (Hindi Language) | तय करना | UPPSC | 📗 पाठ्यपुस्तक | `s:state_psc:hindi` |
| 4 | गणित (Mathematics) | 16 | BPSC, MPPSC, UPPSC, RPSC RAS, Other State PSC (HPSC, JPSC, WBPSC, OPSC etc.) | 📗 पाठ्यपुस्तक | `s:state_psc:maths` |
| 5 | रीज़निंग (Reasoning) | 12 | BPSC, MPPSC, UPPSC, RPSC RAS, Other State PSC (HPSC, JPSC, WBPSC, OPSC etc.) | 📗 पाठ्यपुस्तक | `s:state_psc:reasoning` |

### UPSC सिविल — UPSC Civil (5 किताबें · प्रोफ़ाइल: exam-civil-services)

| # | विषय | अध्याय | किन परीक्षाओं के लिए | पहला संस्करण | book_key |
|---|---|---|---|---|---|
| 1 | अंग्रेज़ी भाषा (English Language) | तय करना | UPSC CAPF (Assistant Commandant), UPSC CSE | 📗 पाठ्यपुस्तक | `s:upsc_civil:english` |
| 2 | सामान्य जागरूकता (General Awareness) | 9 | UPSC CAPF (Assistant Commandant), UPSC CSE | 📗 पाठ्यपुस्तक | `s:upsc_civil:general-awareness` |
| 3 | सामान्य विज्ञान (General Science) | 51 | UPSC CSE | 📗 पाठ्यपुस्तक | `s:upsc_civil:general-science` |
| 4 | गणित (Mathematics) | 16 | UPSC CAPF (Assistant Commandant), UPSC CSE | 📗 पाठ्यपुस्तक | `s:upsc_civil:maths` |
| 5 | रीज़निंग (Reasoning) | 12 | UPSC CAPF (Assistant Commandant), UPSC CSE | 📗 पाठ्यपुस्तक | `s:upsc_civil:reasoning` |
