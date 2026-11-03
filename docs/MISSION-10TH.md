# MISSION: Class 10 पूरा automation (शुरू 2 Nov 2026)

**हर session यहीं से शुरू होगा।** पहले ये file पढ़ो, फिर "अभी कहाँ हैं" वाला पहला खुला [ ] काम उठाओ। काम पूरा करके [x] लगाओ, Progress log में एक line लिखो, फिर अगला काम।

## Motive (owner का असली मकसद)
Owner सिर्फ मालिक है, robots employees हैं। Owner phone से command देता है; robots खुद लिखते, जाँचते, अनुवाद करते, copyright check करते और publish करते हैं।
Student को अपने level का, भरोसेमंद, छपी किताब से बेहतर content मिले (Hindi + English), free AIs से, लगभग zero खर्च में।
एक line में: **owner न खुद लिखे, न खुद check करे, फिर भी student तक गलत content न पहुँचे।**

## भटकने से रोकने के नियम (हर session पर लागू)
1. एक समय पर एक ही phase। Phase पूरा होने से पहले अगले phase का काम नहीं।
2. Owner से document नहीं माँगना। Official source (cbseacademic.nic.in, ncert.nic.in) खुद ढूँढो। न मिले तो भरोसेमंद third-party source लो (owner की language policy इसकी इजाज़त देती है), और यहाँ लिख दो कि कौन सा source लिया।
3. छोटी अटकन पर काम नहीं रुकेगा। Blocker को नीचे "Owner के लिए सवाल" में लिखो और अगला काम करो।
4. Owner से सिर्फ वही पूछना जो सिर्फ owner दे सकता है (key, पैसा, या ऐसा फैसला जो वापस न हो सके)। सारे सवाल एक साथ, एक बार।
5. App की screens नहीं बदलनी, कुछ delete नहीं करना, हर बदलाव से पहले backup। DB में बदलाव सिर्फ नई additive migration से।
6. Robots/workflows `main` पर (PR + tests से), mission docs/content इस branch `content-fill-database` पर।
7. Copyright: किताब का text content में नहीं जाएगा। Copyright check पास किए बिना कुछ publish नहीं होगा।

## Phase 1: Audit (2 Nov 2026) ✅
- [x] Robots की हालत देखी
- [x] Class 9-10 content गिना
- [x] Report नीचे लिखी

**Audit report:**
- Health और Dispatcher robots हर 15 मिनट चल रहे हैं, सब success। Writer और Solver robots रोज़ success हैं।
- **Copyright Check workflow लगातार 3 बार fail** (1 Nov)। Log के मुताबिक `out/` folder बना ही नहीं, यानी checker output लिखने से पहले ही रुक गया। ये Phase 3 का पहला काम है।
- Class 9-10 level: 74 chapters, 296 atoms, यानी **हर chapter में सिर्फ 4 atoms** (target 8 या 10, नीचे वाला सवाल देखो)।
- Subjects सिर्फ तीन हैं: General Science (48 chapters), Maths (19), Reasoning (7)।
- **बड़ी कमी 1:** chapters NCERT वाले नहीं हैं। ये competitive exam वाले "General Science" topics हैं (जैसे "Skeletal & Muscular System", "Waves")। 10th का student NCERT के chapter ढूँढेगा (जैसे "Chemical Reactions and Equations", "Life Processes")।
- **बड़ी कमी 2:** Social Science, English, Hindi, Sanskrit बिल्कुल नहीं हैं। Reasoning 10th board का subject नहीं है।
- **बड़ी कमी 3:** सारा content सिर्फ Hindi (`lang=hi`) में है, English zero। Policy के मुताबिक 9-10 bilingual होना चाहिए, English primary।
- Drafts: class_9_10 में 2 approved (Percentage, Profit-Loss-Discount)।
- Class 9 Physics deep content (Force, Motion, Gravitation) `content/generated/` में तैयार है पर DB में नहीं है (HANDOVER-2026-11-02 देखो)।

## Phase 2: NCERT/CBSE Class 10 syllabus tree
- [ ] CBSE 2026-27 Class 10 curriculum official site से लेना (Science, Maths, Social Science, English, Hindi A/B, Sanskrit)
- [ ] हर subject के chapter नाम NCERT किताब के हिसाब से, Hindi + English दोनों में
- [ ] `mtb.topics` से mapping: जो पहले से है उसे जोड़ना, जो नहीं है उसे नई additive migration से जोड़ना
- [ ] पुराने General Science topics delete नहीं होंगे। वो competitive exams के लिए रहेंगे, 10th वाली list अलग बनेगी
- [ ] हर chapter का atom target तय करना

### Phase 2 progress: Science (subject code 086), 3 Nov 2026
Source: CBSE 2026-27 course structure, दो third-party copies (extramarks, schoolsuniverse) से मिलाया। ये repo के NCERT fingerprint की 13 files (jesc101-113) से भी मेल खाती है। Chapter 8 का नाम अब सिर्फ "Heredity" है।
(एक source में Periodic Classification, Sources of Energy और Sustainable Management भी थे। वो पुराना syllabus है और 13-file NCERT किताब में नहीं हैं, इसलिए नहीं लिए गए।)

| # | NCERT chapter (unit, marks) | DB में अभी का topic | हालत |
|---|---|---|---|
| 1 | Chemical Reactions and Equations (U1, 25) | 889 Chemical Reactions & Equations | मिलता है |
| 2 | Acids, Bases and Salts | 891 | मिलता है |
| 3 | Metals and Non-metals | 892 | मिलता है |
| 4 | Carbon and its Compounds | 893 | मिलता है |
| 5 | Life Processes (U2, 25) | Nutrition / Respiration / Circulatory में बिखरा है | नया topic चाहिए |
| 6 | Control and Coordination | Nervous System + Hormones में बिखरा है | नया topic चाहिए |
| 7 | How do Organisms Reproduce? | 915 Reproduction | मिलता है |
| 8 | Heredity | 917 Heredity & Evolution | मिलता है (Evolution वाला हिस्सा 10th में नहीं) |
| 9 | Light – Reflection and Refraction (U3, 12) | 879 Light & Optics | आंशिक |
| 10 | The Human Eye and the Colourful World | 879 में मिला हुआ | नया topic चाहिए |
| 11 | Electricity (U4, 13) | 880 | मिलता है |
| 12 | Magnetic Effects of Electric Current | 881 | मिलता है |
| 13 | Our Environment (U5, 5) | 920 Environment & Ecology | आंशिक |

अगला: Maths, फिर Social Science, English, Hindi की list। उसके बाद एक additive migration से "class 10 NCERT" list बनेगी (पुराने topics को छुए बिना)।

## Phase 3: Quality gates पक्के करना
- [ ] Copyright Check workflow ठीक करना
- [ ] Copyright check हर Writer draft पर अपने आप चले
- [ ] दूसरा AI हर MCQ का answer खुद निकाले; न मिले तो draft रुके (cross-check robot पहले से है, 10th पर लागू करना)
- [ ] Maths/numerical answers code से दोबारा हल करके मिलाना
- [ ] Rejected draft के atoms published न रहें (HANDOVER में बताया bug)
- [ ] शक वाले drafts review queue में जाएँ, जिसे owner phone पर देख सके

## Phase 4: Content उत्पादन (robots)
- [ ] Writer robot को class 10 की नई chapter list पर चलाना, English + Hindi दोनों
- [ ] हर chapter के samples owner को review page पर दिखाना
- [ ] भरोसा बनने के साथ sample review कम करना

## Phase 5: Student तक भरोसा
- [ ] Report बटन: 2-3 reports पर सवाल अपने आप छुपे, owner को alert जाए
- [ ] Correction log, और student को "सुधार दिया गया" वाला संदेश
- [ ] App में साफ लिखा हो कि content AI की मदद से बनता और check होता है

## Phase 6: फैलाव
- [ ] Class 10 की pipeline को 9th, फिर 11-12, फिर competitive exams पर चलाना

## Owner के लिए सवाल (सिर्फ जो owner ही तय कर सकता है)
1. Atom target में टकराव: `robots/planner/targets.json` कहता है class 9-10 = 8 atoms, पर 1 Nov की policy कहती है 10 (3 concept, 2 formula, 2 example, 3 MCQ)। जब तक जवाब न आए, **10 मानकर चलेंगे** (policy नई है)।
2. Publish में टकराव: HANDOVER कहता है "app में publish नहीं, सिर्फ drafts", पर `robots/ecosystem/config.json` में `auto_approve=true` है (1 Nov, full authority)। जब तक जवाब न आए, 10th का नया content **सिर्फ draft + review page** तक जाएगा।

## Progress log
- 2026-11-02: Mission file बनी। Phase 1 audit पूरा। अगला काम: Phase 2, CBSE Class 10 syllabus।
- 2026-11-03: Science की 13 chapters वाली list बनी और DB से मिलाई गई (8 मिलते, 2 आंशिक, 3 नए topics चाहिए)। अगला काम: Maths की list।
