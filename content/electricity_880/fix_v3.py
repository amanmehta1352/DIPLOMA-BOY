# -*- coding: utf-8 -*-
"""v3 content-only fixes for Electricity (ch 880): full steps for 37 one-step solved items, real explanations for
12 practice items, Exam Tips + Quick Check teach sections, and a Hinglish teach set. Keys = index in data['solved'] /
data['practice'] (same index in data['en'])."""

# index: ([hi steps], [en steps], hi answer, en answer)
SOLVED = {
15: (["दिया है: Q = 12 C, t = 4 s", "सूत्र: I = Q/t", "I = 12/4", "I = 3 A"],
     ["Given: Q = 12 C, t = 4 s", "Formula: I = Q/t", "I = 12/4", "I = 3 A"], "I = 3 A", "I = 3 A"),
16: (["V-I ग्राफ सीधी रेखा है, इसलिए R = V/I किसी भी बिंदु से।", "पहला बिंदु: R = 2/0.5 = 4 Ω", "दूसरा बिंदु: R = 8/2 = 4 Ω (जाँच)", "दोनों बराबर, इसलिए R = 4 Ω"],
     ["The plotted points lie on one straight line, so any point gives R = V/I.", "First point: R = 2/0.5 = 4 Ω", "Second point: R = 8/2 = 4 Ω (check)", "Both agree, so R = 4 Ω"], "R = 4 Ω", "R = 4 Ω"),
17: (["दिया है: ρ = 1.68 × 10^(-8) Ω m, L = 2 m, A = 1.0 × 10^(-6) m²", "सूत्र: R = ρL/A", "R = (1.68 × 10^(-8) × 2) ÷ (1.0 × 10^(-6))", "R = 3.36 × 10^(-2) Ω = 0.0336 Ω"],
     ["Given: ρ = 1.68 × 10^(-8) Ω m, L = 2 m, A = 1.0 × 10^(-6) m²", "Formula: R = ρL/A", "R = (1.68 × 10^(-8) × 2) ÷ (1.0 × 10^(-6))", "R = 3.36 × 10^(-2) Ω = 0.0336 Ω"], "R = 0.0336 Ω", "R = 0.0336 Ω"),
18: (["सूत्र: 1/Rp = 1/R1 + 1/R2 + 1/R3", "1/Rp = 1/2 + 1/3 + 1/6", "हर (LCM) 6 लेकर: 3/6 + 2/6 + 1/6 = 6/6 = 1", "Rp = 1 Ω (सबसे छोटे 2 Ω से भी कम, सही)"],
     ["Formula: 1/Rp = 1/R1 + 1/R2 + 1/R3", "1/Rp = 1/2 + 1/3 + 1/6", "Over 6: 3/6 + 2/6 + 1/6 = 6/6 = 1", "Rp = 1 Ω (below the smallest, 2 Ω, as expected)"], "Rp = 1 Ω", "Rp = 1 Ω"),
19: (["दिया है: R = 10 Ω, I = 5 A, t = 2 मिनट = 120 s", "सूत्र: H = I²Rt", "H = 5² × 10 × 120 = 25 × 1200", "H = 30000 J = 30 kJ"],
     ["Given: R = 10 Ω, I = 5 A, t = 2 min = 120 s", "Formula: H = I²Rt", "H = 5² × 10 × 120 = 25 × 1200", "H = 30000 J = 30 kJ"], "H = 30000 J", "H = 30000 J"),
20: (["P = 60 W = 60/1000 kW = 0.06 kW", "t = 5 h", "E = P × t = 0.06 × 5", "E = 0.3 kWh"],
     ["P = 60 W = 60/1000 kW = 0.06 kW", "t = 5 h", "E = P × t = 0.06 × 5", "E = 0.3 kWh"], "E = 0.3 kWh", "E = 0.3 kWh"),
28: (["दिया है: Q = 0.5 C, W = 30 J (समय 2 s इस प्रश्न में ज़रूरी नहीं)", "सूत्र: V = W/Q", "V = 30/0.5", "V = 60 V"],
     ["Given: Q = 0.5 C, W = 30 J (the time 2 s is not needed here)", "Formula: V = W/Q", "V = 30/0.5", "V = 60 V"], "V = 60 V", "V = 60 V"),
30: (["R = ρL/A से देखो।", "L ऊपर (अंश में) है, इसलिए R ∝ L।", "A नीचे (हर में) है, इसलिए R ∝ 1/A।"],
     ["Look at R = ρL/A.", "L is on top, so R ∝ L.", "A is at the bottom, so R ∝ 1/A."], "लंबाई; अनुप्रस्थ काट का क्षेत्रफल", "length; area of cross-section"),
31: (["शक्ति = ऊर्जा की दर = W/t", "W = VQ और Q/t = I", "इसलिए P = V × I (और P = I²R = V²/R)"],
     ["Power = rate of energy = W/t", "W = VQ and Q/t = I", "So P = V × I (also P = I²R = V²/R)"], "P = V × I", "P = V × I"),
33: (["एमीटर: धारा (A में) मापता है।", "एमीटर श्रेणीक्रम में, धारा के रास्ते में; इसका प्रतिरोध बहुत कम।", "वोल्टमीटर: विभवांतर (V में) मापता है।", "वोल्टमीटर पार्श्वक्रम में, उपकरण के दोनों सिरों के आर-पार; इसका प्रतिरोध बहुत अधिक।"],
     ["Ammeter: measures current (in A).", "Ammeter goes in series, in the current's path; its resistance is very low.", "Voltmeter: measures potential difference (in V).", "Voltmeter is joined in parallel: one lead on each end of the device; its resistance is very high."],
     "एमीटर श्रेणी में, वोल्टमीटर पार्श्व में", "Ammeter in series, voltmeter in parallel"),
34: (["शर्त: ताप (और अन्य भौतिक स्थितियाँ) स्थिर रहें।", "तब चालक के सिरों का विभवांतर V उसमें बहती धारा I के अनुक्रमानुपाती होता है: V ∝ I।", "अनुपात V/I = R स्थिर रहता है, इसलिए V = IR।"],
     ["Condition: temperature (and other physical conditions) stay fixed.", "Then the potential difference V across a conductor is proportional to the current I in it: V ∝ I.", "The ratio V/I = R stays constant, so V = IR."], "V = IR (ताप स्थिर रहने पर)", "V = IR (at constant temperature)"),
36: (["R = ρL/A से ρ = RA/L", "मात्रक: Ω × m² ÷ m", "= Ω m"],
     ["From R = ρL/A, ρ = RA/L", "Unit: Ω × m² ÷ m", "= Ω m"], "ओम मीटर (Ω m)", "ohm metre (Ω m)"),
37: (["हर उपकरण को पूरा विभवांतर (230 V) मिलता है।", "एक उपकरण खराब हो तो बाकी चलते रहते हैं।", "हर उपकरण को अलग स्विच से चालू/बंद कर सकते हैं।", "कुल प्रतिरोध कम होता है, इसलिए हर उपकरण अपनी ज़रूरत की धारा ले पाता है।"],
     ["Every appliance gets the full potential difference (230 V).", "If one appliance fails, the others keep working.", "Each appliance has its own switch.", "The total resistance is low, so each appliance can draw the current it needs."],
     "पूरा वोल्टेज, स्वतंत्र कार्य, अलग स्विच", "Full voltage, independent working, separate switches"),
39: (["दिया है: Q = 6 C, t = 2 s", "सूत्र: I = Q/t", "I = 6/2", "I = 3 A"],
     ["Given: Q = 6 C, t = 2 s", "Formula: I = Q/t", "I = 6/2", "I = 3 A"], "I = 3 A", "I = 3 A"),
40: (["एकांक धनावेश को दो बिंदुओं के बीच पहुँचाने में किया गया कार्य = विभवांतर।", "सूत्र: V = W/Q", "मात्रक: जूल प्रति कूलॉम = वोल्ट (1 V = 1 J/C)"],
     ["Work done per unit positive charge carried between two points = potential difference.", "Formula: V = W/Q", "Unit: joule per coulomb = volt (1 V = 1 J/C)"], "V = W/Q", "V = W/Q"),
41: (["एमीटर धारा मापता है।", "धारा को उसके अंदर से गुज़रना होता है, इसलिए श्रेणीक्रम में जोड़ते हैं।", "इसका प्रतिरोध बहुत कम होता है ताकि परिपथ की धारा न बदले।", "+ सिरा बैटरी के + की ओर।"],
     ["An ammeter measures current.", "The current must pass through it, so it is joined in series.", "Its resistance is very low so the circuit current does not change.", "Its + terminal faces the battery's + side."], "श्रेणीक्रम में", "In series"),
42: (["वोल्टमीटर विभवांतर मापता है।", "इसे जिस उपकरण का विभवांतर चाहिए उसके दोनों सिरों के आर-पार, यानी पार्श्वक्रम में जोड़ते हैं।", "इसका प्रतिरोध बहुत अधिक होता है ताकि यह लगभग कोई धारा न ले।"],
     ["A voltmeter measures potential difference.", "It is joined across the two ends of the device, that is in parallel.", "Its resistance is very high so it draws almost no current."], "पार्श्वक्रम में", "In parallel"),
44: (["दिया है: R = 5 Ω, L = 2 m, A = 0.5 × 10^(-6) m²", "सूत्र: ρ = RA/L", "ρ = (5 × 0.5 × 10^(-6)) ÷ 2 = 2.5 × 10^(-6) ÷ 2", "ρ = 1.25 × 10^(-6) Ω m"],
     ["Given: R = 5 Ω, L = 2 m, A = 0.5 × 10^(-6) m²", "Formula: ρ = RA/L", "ρ = (5 × 0.5 × 10^(-6)) ÷ 2 = 2.5 × 10^(-6) ÷ 2", "ρ = 1.25 × 10^(-6) Ω m"], "ρ = 1.25 × 10^(-6) Ω m", "ρ = 1.25 × 10^(-6) Ω m"),
45: (["श्रेणीक्रम: Rs = R1 + R2 + R3", "Rs = 2 + 3 + 5", "Rs = 10 Ω"],
     ["Series: Rs = R1 + R2 + R3", "Rs = 2 + 3 + 5", "Rs = 10 Ω"], "Rs = 10 Ω", "Rs = 10 Ω"),
46: (["पार्श्वक्रम: हर शाखा पर पूरे 12 V", "I1 = V/R1 = 12/4 = 3 A", "I2 = V/R2 = 12/6 = 2 A", "कुल धारा = 3 + 2 = 5 A (जाँच: Rp = 24/10 = 2.4 Ω, 12/2.4 = 5 A)"],
     ["Parallel: each branch has the full 12 V", "I1 = V/R1 = 12/4 = 3 A", "I2 = V/R2 = 12/6 = 2 A", "Total = 3 + 2 = 5 A (check: Rp = 24/10 = 2.4 Ω, 12/2.4 = 5 A)"], "I1 = 3 A, I2 = 2 A", "I1 = 3 A, I2 = 2 A"),
47: (["दिया है: I = 2 A, R = 10 Ω, t = 5 s", "सूत्र: H = I²Rt", "H = 2² × 10 × 5 = 4 × 50", "H = 200 J"],
     ["Given: I = 2 A, R = 10 Ω, t = 5 s", "Formula: H = I²Rt", "H = 2² × 10 × 5 = 4 × 50", "H = 200 J"], "H = 200 J", "H = 200 J"),
48: (["P = 60 W = 0.06 kW", "t = 5 h", "E = 0.06 × 5", "E = 0.3 kWh"],
     ["P = 60 W = 0.06 kW", "t = 5 h", "E = 0.06 × 5", "E = 0.3 kWh"], "E = 0.3 kWh", "E = 0.3 kWh"),
53: (["एमीटर: श्रेणीक्रम में, क्योंकि धारा उसके अंदर से जानी चाहिए।", "वोल्टमीटर: पार्श्वक्रम में, क्योंकि उसे दो बिंदुओं का अंतर नापना है।"],
     ["Ammeter: in series, because the current must pass through it.", "Voltmeter: in parallel, because it compares two points."], "एमीटर श्रेणी में, वोल्टमीटर पार्श्व में", "Ammeter in series, voltmeter in parallel"),
54: (["लंबाई L: R ∝ L", "अनुप्रस्थ काट A: R ∝ 1/A", "पदार्थ की प्रकृति (प्रतिरोधकता ρ)", "ताप: धातुओं में ताप बढ़ने पर R बढ़ता है"],
     ["Length L: R ∝ L", "Cross-section A: R ∝ 1/A", "Nature of the material (resistivity ρ)", "Temperature: for metals R rises with temperature"], "L, A, पदार्थ और ताप", "L, A, material and temperature"),
55: (["हर उपकरण को पूरा 230 V मिलता है।", "एक खराब हो तो बाकी चलते रहते हैं।", "हर उपकरण का अलग स्विच होता है।"],
     ["Each appliance gets the full 230 V.", "If one fails, the rest keep working.", "Each appliance has its own switch."], "पूरा वोल्टेज और स्वतंत्र संचालन", "Full voltage and independent working"),
56: (["तंतु को लगभग 2500 °C तक गर्म होकर चमकना होता है।", "टंगस्टन का गलनांक बहुत ऊँचा (≈ 3380 °C) है, इसलिए वह पिघलता नहीं।", "इसकी प्रतिरोधकता भी ताँबे से अधिक है, इसलिए गर्मी और प्रकाश अच्छे से बनते हैं।"],
     ["The filament must glow at about 2500 °C.", "Tungsten melts only at about 3380 °C, so it does not melt.", "Its resistivity is also higher than copper's, so it produces heat and light well."], "बहुत ऊँचा गलनांक", "Very high melting point"),
57: (["गलनांक कम होना चाहिए, ताकि अधिक धारा पर जल्दी पिघले।", "उचित प्रतिरोध (परिपथ के तारों से अधिक), ताकि गर्मी उसी में बने।", "यह परिपथ में श्रेणीक्रम में लगता है।"],
     ["Low melting point, so it melts quickly at excess current.", "Suitable resistance (more than the circuit wires), so the heat appears in it.", "It is placed in series in the circuit."], "कम गलनांक और उचित प्रतिरोध", "Low melting point and suitable resistance"),
58: (["1 kWh = 1 kW × 1 h", "= 1000 W × 3600 s", "= 3.6 × 10^6 J"],
     ["1 kWh = 1 kW × 1 h", "= 1000 W × 3600 s", "= 3.6 × 10^6 J"], "1 kWh = 3.6 × 10^6 J", "1 kWh = 3.6 × 10^6 J"),
59: (["R = ρL/A, यहाँ मोटाई (A) वही है।", "R ∝ L, इसलिए L दुगुनी → R दुगुना।", "नया प्रतिरोध = 2R। (ध्यान: तार खींचने पर A भी घटता है, तब 4R।)"],
     ["R = ρL/A, with the same thickness (A).", "R ∝ L, so double L → double R.", "New resistance = 2R. (Note: if the wire is stretched, A also falls and R becomes 4R.)"], "2R", "2R"),
60: (["नाइक्रोम की प्रतिरोधकता अधिक है, इसलिए उसी धारा में ज़्यादा ऊष्मा बनती है।", "इसका गलनांक ऊँचा है।", "ऊँचे ताप पर यह आसानी से ऑक्सीकृत (जलता) नहीं।"],
     ["Nichrome has high resistivity, so the same current produces more heat.", "Its melting point is high.", "It does not oxidise (burn) easily at high temperature."], "अधिक प्रतिरोधकता और ऊँचे ताप पर न जलना", "High resistivity and no burning at high temperature"),
64: (["दिया है: V = 10 V, R = 5 Ω", "ओम का नियम: I = V/R", "I = 10/5 = 2 A"],
     ["Given: V = 10 V, R = 5 Ω", "Ohm's law: I = V/R", "I = 10/5 = 2 A"], "I = 2 A", "I = 2 A"),
65: (["दिया है: Q = 5 C, t = 10 s", "सूत्र: I = Q/t", "I = 5/10 = 0.5 A"],
     ["Given: Q = 5 C, t = 10 s", "Formula: I = Q/t", "I = 5/10 = 0.5 A"], "I = 0.5 A", "I = 0.5 A"),
66: (["दिया है: V = 24 V, R = 6 Ω", "ओम का नियम: I = V/R", "I = 24/6 = 4 A"],
     ["Given: V = 24 V, R = 6 Ω", "Ohm's law: I = V/R", "I = 24/6 = 4 A"], "I = 4 A", "I = 4 A"),
68: (["दिया है: I = 3 A, R = 5 Ω, t = 2 s", "सूत्र: H = I²Rt", "H = 3² × 5 × 2 = 9 × 10", "H = 90 J"],
     ["Given: I = 3 A, R = 5 Ω, t = 2 s", "Formula: H = I²Rt", "H = 3² × 5 × 2 = 9 × 10", "H = 90 J"], "H = 90 J", "H = 90 J"),
70: (["I = Q/t, यानी कूलॉम प्रति सेकंड", "1 C/s = 1 ऐम्पियर", "मात्रक: ऐम्पियर (A)"],
     ["I = Q/t, that is coulomb per second", "1 C/s = 1 ampere", "Unit: ampere (A)"], "ऐम्पियर (A)", "ampere (A)"),
71: (["V = W/Q, यानी जूल प्रति कूलॉम", "1 J/C = 1 वोल्ट", "मात्रक: वोल्ट (V)"],
     ["V = W/Q, that is joule per coulomb", "1 J/C = 1 volt", "Unit: volt (V)"], "वोल्ट (V)", "volt (V)"),
72: (["1 kWh = 1000 W × 1 h", "1 h = 3600 s", "1 kWh = 1000 × 3600 J = 3.6 × 10^6 J"],
     ["1 kWh = 1000 W × 1 h", "1 h = 3600 s", "1 kWh = 1000 × 3600 J = 3.6 × 10^6 J"], "3.6 × 10^6 J", "3.6 × 10^6 J"),
}

PRACTICE = {
0: ("I = Q/t = 12/4 = 3 A। (4 A, Q और t को उलझाने से; 6 A या 2 A गलत भाग से।)", "I = Q/t = 12/4 = 3 A. (4 A or 2 A come from mixing up Q and t or dividing wrongly.)"),
4: ("R = V/I। (0.5 A, 2.5 V) से R = 2.5/0.5 = 5 Ω; (1.5 A, 7.5 V) से भी 7.5/1.5 = 5 Ω। 0.2 Ω, I/V लेने से आता है।", "R = V/I. From (0.5 A, 2.5 V), R = 2.5/0.5 = 5 Ω; from (1.5 A, 7.5 V) also 7.5/1.5 = 5 Ω. 0.2 Ω comes from taking I/V."),
5: ("R = V/I = 24/3 = 8 Ω। जाँच: 3 A × 8 Ω = 24 V।", "R = V/I = 24/3 = 8 Ω. Check: 3 A × 8 Ω = 24 V."),
6: ("R = ρL/A: प्रतिरोध लंबाई, अनुप्रस्थ काट, पदार्थ और ताप पर निर्भर है। तार का रंग किसी पर असर नहीं डालता।", "R = ρL/A: resistance depends on length, cross-section, material and temperature. The colour of a wire affects none of these."),
7: ("R = ρL/A = (1.6 × 10^(-8) × 50) ÷ (2 × 10^(-6)) = (8 × 10^(-7)) ÷ (2 × 10^(-6)) = 0.4 Ω।", "R = ρL/A = (1.6 × 10^(-8) × 50) ÷ (2 × 10^(-6)) = (8 × 10^(-7)) ÷ (2 × 10^(-6)) = 0.4 Ω."),
9: ("दो के लिए Rp = (4 × 12)/(4 + 12) = 48/16 = 3 Ω। Rp हमेशा सबसे छोटे (4 Ω) से कम होता है, इसलिए 6, 8 या 12 Ω नहीं हो सकता।", "For two, Rp = (4 × 12)/(4 + 12) = 48/16 = 3 Ω. Rp is always below the smallest (4 Ω), so it cannot be 6, 8 or 12 Ω."),
11: ("H = I²Rt = 2² × 5 × 10 = 4 × 50 = 200 J। 100 J, I का वर्ग भूलने से आता है।", "H = I²Rt = 2² × 5 × 10 = 4 × 50 = 200 J. 100 J comes from forgetting to square I."),
13: ("E = (60/1000) kW × 5 h = 0.06 × 5 = 0.3 kWh। W को kW में बदलना (÷ 1000) सबसे ज़रूरी कदम है।", "E = (60/1000) kW × 5 h = 0.06 × 5 = 0.3 kWh. Changing W to kW (÷ 1000) is the key step."),
15: ("धातु को गर्म करने पर उसकी प्रतिरोधकता बढ़ती है, इसलिए ताँबे का प्रतिरोध बढ़ता है, घटता नहीं। अतः A गलत, R सही।", "Heating a metal raises its resistivity, so copper's resistance rises, not falls. So A is false and R is true."),
18: ("गलत। ओम का नियम तभी लागू होता है जब ताप (और अन्य भौतिक स्थितियाँ) स्थिर रहें; बल्ब के तंतु जैसे गर्म होते चालकों में V-I ग्राफ सीधा नहीं रहता।", "False. Ohm's law holds only when temperature (and other physical conditions) stay fixed; in conductors that heat up, like a bulb filament, the V-I graph is not straight."),
19: ("गलत। पार्श्वक्रम में कुल प्रतिरोध सबसे छोटे प्रतिरोध से भी कम होता है, क्योंकि धारा के लिए ज़्यादा रास्ते बन जाते हैं।", "False. In parallel the total resistance is smaller than even the smallest one, because the current gets more paths."),
26: ("I = Q/t = 2/0.5 = 4 A। 1 A, Q × t लेने से और 0.25 A, t/Q लेने से आता है।", "I = Q/t = 2/0.5 = 4 A. 1 A comes from Q × t and 0.25 A from t/Q."),
}

TEACH_END = [
 dict(heading=("Exam Tips: क्या याद रखें, क्या न करें", "Exam tips: what to remember, what to avoid"),
  explain=("✅ हर numerical में पहले 'दिया है', फिर सूत्र, फिर मात्रक के साथ उत्तर लिखो।\n"
           "✅ परिभाषा वाले प्रश्न में 'ताप स्थिर रहने पर' जैसी शर्त ज़रूर लिखो (ओम का नियम)।\n"
           "✅ परिपथ आरेख में सेल का + सिरा (लंबी रेखा), एमीटर श्रेणी में और वोल्टमीटर पार्श्व में साफ़ दिखाओ।\n"
           "✅ mA → A (÷ 1000), mm² → m² (× 10^(-6)), मिनट → सेकंड (× 60), W → kW (÷ 1000) पहले बदलो।\n"
           "❌ पार्श्वक्रम में 1/Rp निकालकर उलटना (reciprocal) मत भूलो।\n"
           "❌ H = I²Rt में I का वर्ग मत भूलो।\n"
           "❌ श्रेणी में 'ज़्यादा वाट = ज़्यादा चमक' मत लिखो; श्रेणी में कम वाट वाला ज़्यादा चमकता है।",
           "✅ In every numerical write 'Given', then the formula, then the answer with its unit.\n"
           "✅ In definitions add conditions such as 'at constant temperature' (Ohm's law).\n"
           "✅ In circuit diagrams show the cell's + side (long line), the ammeter in series and the voltmeter in parallel.\n"
           "✅ Convert first: mA → A (÷ 1000), mm² → m² (× 10^(-6)), minutes → seconds (× 60), W → kW (÷ 1000).\n"
           "❌ In parallel, do not forget to take the reciprocal of 1/Rp.\n"
           "❌ In H = I²Rt, do not forget to square I.\n"
           "❌ Do not write 'more watts = brighter' for series; in series the lower-watt bulb glows more."),
  example=("बोर्ड में अक्सर: 'दो बल्ब श्रेणी में, कौन ज़्यादा चमकेगा?', 'तार खींचने पर R', 'बिजली का बिल', 'घर में पार्श्वक्रम क्यों'।",
           "Often in the board exam: 'two bulbs in series, which glows more?', 'R of a stretched wire', 'the electricity bill', 'why parallel at home'.")),
 dict(heading=("Quick Check: 2 मिनट की जाँच", "Quick check: a 2-minute test"),
  explain=("1. 1 ऐम्पियर किसे कहते हैं? → 1 सेकंड में 1 कूलॉम आवेश का प्रवाह।\n"
           "2. 9 V की बैटरी हर कूलॉम को कितनी ऊर्जा देती है? → 9 J।\n"
           "3. वोल्टमीटर का प्रतिरोध कैसा होता है? → बहुत अधिक।\n"
           "4. 3 Ω और 6 Ω पार्श्वक्रम में? → (3 × 6)/(3 + 6) = 2 Ω।\n"
           "5. तार आधा मोड़ने पर 8 Ω का प्रतिरोध? → 8 ÷ 4 = 2 Ω।\n"
           "6. धारा तीन गुना, ऊष्मा? → 9 गुना।\n"
           "7. 2 kW का गीज़र 30 मिनट रोज़, 30 दिन? → 2 × 0.5 × 30 = 30 यूनिट।",
           "1. What is 1 ampere? → a flow of 1 coulomb in 1 second.\n"
           "2. How much energy does a 9 V battery give each coulomb? → 9 J.\n"
           "3. What is a voltmeter's resistance like? → very high.\n"
           "4. 3 Ω and 6 Ω in parallel? → (3 × 6)/(3 + 6) = 2 Ω.\n"
           "5. An 8 Ω wire folded in half? → 8 ÷ 4 = 2 Ω.\n"
           "6. Current tripled, heat? → 9 times.\n"
           "7. A 2 kW geyser for 30 minutes a day, 30 days? → 2 × 0.5 × 30 = 30 units."),
  example=("सब सही? अब 'अब तुम बताओ' के सवाल करो। कोई गलत? उसी पाठ पर लौटो।",
           "All right? Now try 'Your turn'. Any wrong? Go back to that lesson.")),
]

# Hinglish teach: same order as the 13 lessons + 2 end sections (Devanagari Hindi with English words)
HINGLISH = [
 ("पाठ 1: Current, यानी हर second कितना charge", "❓ सोचो: switch दबाते ही bulb तुरंत जल जाता है, पर wire में electrons बहुत slow चलते हैं। ऐसा कैसे?\nWire में free electrons पहले से हर जगह भरे हैं। Battery जुड़ते ही सारे electrons एक साथ खिसकने लगते हैं, इसलिए energy bulb तक तुरंत पहुँचती है।\nCurrent बताता है कि wire के किसी cross-section से हर second कितना charge निकला: I = Q/t। 1 second में 1 coulomb निकले तो current 1 ampere।\nDirection याद रखो: conventional current + से −, electrons − से +।", "Example: mobile charger 2 A current 30 minute दे तो Q = 2 × 1800 = 3600 C।"),
 ("पाठ 2: Potential difference, charge को धक्का देने वाली energy", "❓ सोचो: 1.5 V का cell और 9 V की battery, फ़र्क क्या है?\nPotential difference बताता है कि हर coulomb को कितनी energy मिली: V = W/Q। 9 V battery हर coulomb को 9 J देती है।\nCurrent = charge per second, voltage = energy per coulomb। दोनों अलग हैं।", "Example: 12 V battery 5 C charge घुमाए तो W = 12 × 5 = 60 J।"),
 ("पाठ 3: Circuit diagram और meters कहाँ लगें", "❓ सोचो: bulb का current नापना है, ammeter bulb के across लगाएँ या रास्ते में?\nCurrent को ammeter के अंदर से जाना है, इसलिए ammeter series में। इसका resistance बहुत कम।\nVoltmeter device के दोनों ends के across, यानी parallel में। इसका resistance बहुत ज़्यादा।\nउल्टा लगाया तो voltmeter current रोक देगा और ammeter खराब हो सकता है।", "Example: ammeter = pipe के अंदर लगा meter, voltmeter = दो tanks के water level का फ़र्क।"),
 ("पाठ 4: Ohm's law और V-I graph", "❓ सोचो: same 6 V पर किसी wire से 3 A और किसी से 1 A, क्यों?\nफ़र्क resistance का है। Temperature fixed हो तो V ∝ I, यानी V = IR।\nExperiment: battery, ammeter, resistor, voltmeter और rheostat जोड़ो। Rheostat से current बदलो, हर बार V/I लगभग same आता है। यही R है।\nV-I graph origin से straight line। V y-axis पर हो तो slope = R।", "Example: (1 V, 0.25 A), (2 V, 0.5 A), (3 V, 0.75 A), हर बार V/I = 4 Ω।"),
 ("पाठ 5: Resistance किस पर depend करता है", "❓ सोचो: heater में पतला लंबा wire क्यों, house wiring में मोटा copper क्यों?\nR = ρL/A। Length बढ़ाओ तो R बढ़ता है, thickness बढ़ाओ तो R घटता है।\nρ material की पहचान है: copper का बहुत कम, nichrome का लगभग 65 गुना ज़्यादा। इसलिए wiring copper की, heater nichrome का।", "Example: 4 Ω wire को stretch करके double length किया → R = 16 Ω; आधा fold किया → R = 1 Ω।"),
 ("पाठ 6: Series: एक रास्ता, एक current", "❓ सोचो: 6 V battery से 2 Ω और 4 Ω series में, 2 Ω से कितना current?\nRs = 2 + 4 = 6 Ω, I = 6/6 = 1 A। Series में यही 1 A दोनों से गुज़रता है।\nVoltage बँटता है: V1 = 2 V, V2 = 4 V। Bigger resistance को bigger share।\nएक bulb fuse हो तो रास्ता टूटता है और सब बंद।", "⚠️ Trap: 3 A तब आता है जब पूरे 6 V सिर्फ़ 2 Ω पर मान लो।"),
 ("पाठ 7: Parallel: हर branch को full voltage", "❓ सोचो: वही 2 Ω और 4 Ω अब parallel में, total current बढ़ेगा या घटेगा?\nहर branch पर full 6 V: I1 = 3 A, I2 = 1.5 A, total 4.5 A।\n1/Rp = 1/2 + 1/4 = 3/4, Rp = 4/3 Ω, smallest से भी कम।\nइसीलिए घर में appliances parallel में: हर एक को full 230 V और अलग switch।", "⚠️ Trap: 'resistor जोड़ो तो current हमेशा घटता है' गलत है। Parallel में total current बढ़ता है।"),
 ("पाठ 8: 60 W vs 100 W, surprise result", "❓ सोचो: 60 W और 100 W bulb 230 V पर series में, कौन ज़्यादा चमकेगा?\nR = V²/P: R60 ≈ 882 Ω, R100 = 529 Ω। Low watt वाले का R बड़ा।\nSeries में current same, I ≈ 0.163 A। P = I²R: P60 ≈ 23.4 W, P100 ≈ 14.1 W। 60 W वाला ज़्यादा चमकता है।\nParallel (घर) में दोनों को full 230 V, तब 100 W ज़्यादा चमकता है।", "🧠 Remember: parallel में high watt bright, series में low watt bright।"),
 ("पाठ 9: Mixed circuit अंदर से बाहर solve करो", "❓ सोचो: 2 Ω के बाद 4 Ω और 4 Ω parallel में, 6 V पर total current?\nStep 1: 4 ∥ 4 = 2 Ω।\nStep 2: 2 + 2 = 4 Ω।\nStep 3: I = 6/4 = 1.5 A, हर 4 Ω branch में 0.75 A।", "⚠️ Trap: 0.6 A तब आता है जब सबको series में जोड़ दो (10 Ω)।"),
 ("पाठ 10: Current से heat: Joule's law", "❓ सोचो: heater coil लाल हो जाती है, पर उसकी cord ठंडी क्यों?\nH = I²Rt (या VIt, या V²t/R)।\nCoil और cord series में, current same। 1000 W heater में I ≈ 4.35 A; coil R ≈ 52.9 Ω पर हर second ≈ 1000 J, cord R ≈ 0.1 Ω पर सिर्फ़ ≈ 1.9 J।\nCurrent double → heat 4 गुना।", "Example: 2 A, 3 Ω, 5 s → H = 2² × 3 × 5 = 60 J।"),
 ("पाठ 11: Bulb और fuse कैसे काम करते हैं", "❓ सोचो: bulb filament इतना गर्म होकर भी क्यों नहीं पिघलता, और fuse wire जल्दी क्यों पिघलता है?\nBulb: tungsten का melting point बहुत high (≈ 3380 °C); bulb में inert gas ताकि filament oxidise न हो।\nFuse: low melting point वाला पतला wire, series में। Current rating से ऊपर गया तो पिघलकर circuit तोड़ देता है।\nRating: I = P/V निकालो, उससे थोड़ा ऊपर का fuse लो।", "Example: 2 kW, 230 V geyser → I ≈ 8.7 A, 10 A fuse सही।"),
 ("पाठ 12: Electric power: P = VI = I²R = V²/R", "❓ सोचो: 230 V heater को 115 V पर चलाओ तो power आधी या उससे भी कम?\nPower = energy खर्च होने की rate: P = VI = I²R = V²/R।\nHeater का R fixed है, इसलिए V आधा → power एक-चौथाई।\n1000 W, 230 V rating से R = 52.9 Ω।", "Example: वही heater 115 V पर → P = 115²/52.9 = 250 W।"),
 ("पाठ 13: Electricity bill: kWh यानी unit", "❓ सोचो: गर्मियों में bill अचानक क्यों बढ़ता है?\nEnergy = power × time। 1 kW device 1 hour = 1 unit = 3.6 × 10^6 J।\nMethod: watt ÷ 1000 = kW, × hours × days, × rate।\n1500 W AC रोज़ 6 hour = 9 units, 10 W LED = सिर्फ़ 0.06 unit।", "Example: 1500 W AC, 6 h/day, 30 days, ₹7/unit → 270 units → ₹1,890।"),
 ("💡 Exam Tips", "✅ हर numerical में Given, formula, फिर unit के साथ answer।\n✅ Ohm's law में 'temperature constant' लिखना ज़रूरी।\n✅ mA → A, mm² → m², minute → second, W → kW पहले convert करो।\n❌ Parallel में 1/Rp का reciprocal लेना मत भूलो।\n❌ H = I²Rt में I का square मत भूलो।\n❌ Series में 'ज़्यादा watt = ज़्यादा bright' मत लिखो।", "Board में अक्सर: series bulbs, stretched wire, bill, घर में parallel क्यों।"),
 ("🎓 Quick Check", "1. 1 ampere? → 1 second में 1 coulomb।\n2. 9 V battery हर coulomb को? → 9 J।\n3. Voltmeter का resistance? → बहुत high।\n4. 3 Ω ∥ 6 Ω? → 2 Ω।\n5. 8 Ω wire आधा fold? → 2 Ω।\n6. Current 3 गुना, heat? → 9 गुना।\n7. 2 kW geyser 30 min/day, 30 days? → 30 units।", "सब सही? अब 'अब तुम बताओ' करो।"),
]
