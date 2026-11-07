# -*- coding: utf-8 -*-
"""New systematic content for Class 10 Electricity (chapter 880), in the app's existing data format.
Each item is (hi, en). Notes: title, points, table, fig. Teach: heading, explain, example, fig.
Written in our own words; physics and numbers re-checked in check.py."""

NOTES = [
 dict(fig="F10_ampere",
  title=("1. विद्युत आवेश और विद्युत धारा", "1. Electric charge and electric current"),
  points=[
   ("📌 परिभाषा (exam line): किसी चालक के अनुप्रस्थ काट से प्रति सेकंड प्रवाहित होने वाले आवेश को विद्युत धारा कहते हैं। I = Q/t",
    "📌 Definition (exam line): the charge flowing through a cross-section of a conductor per second is called electric current. I = Q/t"),
   ("आवेश का SI मात्रक कूलॉम (C) है। एक इलेक्ट्रॉन का आवेश e = 1.6 × 10^(-19) C है, इसलिए 1 C में लगभग 6.25 × 10^18 इलेक्ट्रॉन होते हैं।",
    "The SI unit of charge is the coulomb (C). One electron carries e = 1.6 × 10^(-19) C, so 1 C is about 6.25 × 10^18 electrons."),
   ("1 ऐम्पियर (A): जब किसी चालक से 1 सेकंड में 1 कूलॉम आवेश प्रवाहित हो। छोटी धाराएँ: 1 mA = 10^(-3) A, 1 μA = 10^(-6) A।",
    "1 ampere (A): when 1 coulomb of charge flows through a conductor in 1 second. Small currents: 1 mA = 10^(-3) A, 1 μA = 10^(-6) A."),
   ("धातु के तार में धारा मुक्त इलेक्ट्रॉनों के बहाव से बनती है। इलेक्ट्रॉन धीरे खिसकते हैं, पर तार में पहले से भरे होने के कारण स्विच दबाते ही पूरे तार में एक साथ चलने लगते हैं, इसलिए बल्ब तुरंत जलता है।",
    "In a metal wire the current is a drift of free electrons. They drift slowly, but the wire is already full of them, so they all start moving together the moment the switch closes. That is why the bulb lights at once."),
   ("दिशा: परम्परागत धारा + से − की ओर मानी जाती है। इलेक्ट्रॉन वास्तव में − से + की ओर, यानी उल्टी दिशा में बहते हैं।",
    "Direction: conventional current is taken from + to −. Electrons actually move from − to +, the opposite way."),
   ("🧠 याद रखो: धारा = आवेश ÷ समय। Q = I × t और इलेक्ट्रॉनों की संख्या n = Q/e।",
    "🧠 Remember: current = charge ÷ time. Q = I × t and the number of electrons n = Q/e."),
  ],
  table=[[("राशि","Quantity"),("प्रतीक","Symbol"),("SI मात्रक","SI unit")],
         [("आवेश","Charge"),("Q","Q"),("कूलॉम (C)","coulomb (C)")],
         [("धारा","Current"),("I","I"),("ऐम्पियर (A)","ampere (A)")],
         [("समय","Time"),("t","t"),("सेकंड (s)","second (s)")]]),

 dict(fig="F1_current",
  title=("2. विद्युत विभव और विभवांतर", "2. Electric potential and potential difference"),
  points=[
   ("📌 परिभाषा (exam line): परिपथ में दो बिंदुओं के बीच एकांक धनावेश को पहुँचाने में जितना कार्य करना पड़े, वही उन बिंदुओं का विभवांतर है। V = W/Q",
    "📌 Definition (exam line): the work done to move a unit positive charge from one point of a circuit to another is the potential difference between those points. V = W/Q"),
   ("1 वोल्ट (V): जब 1 कूलॉम आवेश को दो बिंदुओं के बीच ले जाने में 1 जूल कार्य हो। 1 V = 1 J/C।",
    "1 volt (V): the potential difference between two points when carrying 1 coulomb across them takes 1 joule of work. 1 V = 1 J/C."),
   ("सेल या बैटरी अपने अंदर रासायनिक ऊर्जा से अपने सिरों के बीच विभवांतर बनाए रखती है। यही विभवांतर आवेश को परिपथ में चलाता है।",
    "A cell or battery uses its chemical energy to keep a potential difference between its terminals. This potential difference drives charge round the circuit."),
   ("विभवांतर ≠ धारा: विभवांतर प्रति कूलॉम ऊर्जा है, धारा प्रति सेकंड आवेश है।",
    "Potential difference ≠ current: potential difference is energy per coulomb, current is charge per second."),
   ("🧠 याद रखो: W = V × Q। 6 V की बैटरी हर कूलॉम को 6 J ऊर्जा देती है।",
    "🧠 Remember: W = V × Q. A 6 V battery gives 6 J of energy to every coulomb."),
  ]),

 dict(fig="F2_symbols",
  title=("3. परिपथ आरेख, एमीटर और वोल्टमीटर", "3. Circuit diagrams, ammeter and voltmeter"),
  points=[
   ("परिपथ आरेख में हर उपकरण का तय प्रतीक होता है। सेल की लंबी पतली रेखा + सिरा और छोटी मोटी रेखा − सिरा है।",
    "In a circuit diagram every device has a fixed symbol. In a cell the long thin line is + and the short thick line is −."),
   ("📌 एमीटर धारा मापता है और हमेशा श्रेणीक्रम में जोड़ा जाता है। इसका प्रतिरोध बहुत कम होता है।",
    "📌 An ammeter measures current and is always connected in series. Its resistance is very low."),
   ("📌 वोल्टमीटर विभवांतर मापता है और हमेशा उस उपकरण के पार्श्वक्रम में (दोनों सिरों के आर-पार) जोड़ा जाता है। इसका प्रतिरोध बहुत अधिक होता है।",
    "📌 A voltmeter measures potential difference and always goes in parallel: its two leads touch the two ends of the device. Its resistance is very high."),
   ("⚠️ वोल्टमीटर को श्रेणीक्रम में जोड़ने पर उसका बड़ा प्रतिरोध धारा को लगभग रोक देता है और बल्ब नहीं जलता।",
    "⚠️ A voltmeter put in series almost stops the current with its high resistance, so the bulb does not light."),
   ("खुला स्विच = परिपथ में खाली जगह = धारा शून्य। बंद स्विच = पूरा रास्ता।",
    "Open switch = a gap in the circuit = zero current. Closed switch = a complete path."),
  ],
  table=[[("यंत्र","Instrument"),("क्या मापता है","Measures"),("कैसे जुड़ता है","Connected"),("प्रतिरोध","Resistance")],
         [("एमीटर","Ammeter"),("धारा (A)","current (A)"),("श्रेणीक्रम","in series"),("बहुत कम","very low")],
         [("वोल्टमीटर","Voltmeter"),("विभवांतर (V)","potential difference (V)"),("पार्श्वक्रम","in parallel"),("बहुत अधिक","very high")]]),

 dict(fig="F4_vi",
  title=("4. ओम का नियम और V-I ग्राफ", "4. Ohm's law and the V-I graph"),
  points=[
   ("📌 ओम का नियम (exam line): ताप स्थिर रहने पर किसी चालक से प्रवाहित धारा उसके सिरों के विभवांतर के अनुक्रमानुपाती होती है। V ∝ I, यानी V = IR",
    "📌 Ohm's law (exam line): if the temperature stays fixed, the current in a conductor grows in step with the voltage applied across its two ends. V ∝ I, so V = IR"),
   ("R को चालक का प्रतिरोध कहते हैं। 1 ओम (Ω): जब 1 V विभवांतर पर 1 A धारा बहे। 1 Ω = 1 V/A।",
    "R is the resistance of the conductor. 1 ohm (Ω): when 1 V drives a current of 1 A. 1 Ω = 1 V/A."),
   ("V-I ग्राफ मूल बिंदु से जाने वाली सीधी रेखा है। जब V को y-अक्ष पर लें, तो रेखा का ढलान = V/I = R।",
    "Plotting V against I gives a straight line that starts at the origin. With V on the y-axis, the slope of the line = V/I = R."),
   ("दो प्रतिरोधकों के ग्राफ में ज़्यादा खड़ी (steep) रेखा वाले का प्रतिरोध ज़्यादा है।",
    "For two resistors, the steeper line has the larger resistance."),
   ("⚠️ यदि ग्राफ में I को y-अक्ष पर रखा हो, तो ढलान = 1/R होगा, R नहीं। पहले अक्ष देखो।",
    "⚠️ If I is on the y-axis, the slope is 1/R, not R. Check the axes first."),
  ]),

 dict(fig="F5_resistivity",
  title=("5. प्रतिरोध किन बातों पर निर्भर है", "5. What resistance depends on"),
  points=[
   ("चालक का प्रतिरोध (i) लंबाई के अनुक्रमानुपाती, (ii) अनुप्रस्थ काट के क्षेत्रफल के व्युत्क्रमानुपाती, और (iii) पदार्थ की प्रकृति तथा ताप पर निर्भर होता है।",
    "The resistance of a conductor is (i) proportional to its length, (ii) inversely proportional to its area of cross-section, and (iii) depends on the material and the temperature."),
   ("📌 सूत्र: R = ρL/A, जहाँ ρ (रो) प्रतिरोधकता है।",
    "📌 Formula: R = ρL/A, where ρ (rho) is the resistivity."),
   ("📌 प्रतिरोधकता (exam line): 1 m लंबे और 1 m² अनुप्रस्थ काट वाले चालक का प्रतिरोध। इसका SI मात्रक Ω m है। यह पदार्थ और ताप पर निर्भर है, लंबाई या मोटाई पर नहीं।",
    "📌 Resistivity (exam line): the resistance of a conductor 1 m long with a 1 m² cross-section. Its SI unit is Ω m. It depends on the material and temperature, not on length or thickness."),
   ("तार खींचकर दुगुना लंबा करने पर (आयतन वही) काट आधा हो जाता है, इसलिए R चार गुना। तार को आधा मोड़ने पर L आधी और A दुगुना, इसलिए R एक-चौथाई।",
    "Stretching a wire to double length (same volume) halves its cross-section, so R becomes 4 times. Folding it in half halves L and doubles A, so R becomes one quarter."),
   ("⚠️ मोटे तार में इलेक्ट्रॉन तेज़ नहीं चलते। मोटे तार में ज़्यादा इलेक्ट्रॉन एक साथ चलते हैं, इसलिए धारा ज़्यादा और प्रतिरोध कम।",
    "⚠️ Electrons do not move faster in a thick wire. More electrons move together, so the current is larger and the resistance smaller."),
  ]),

 dict(fig="F12_resistivity_chart",
  title=("6. प्रतिरोधकता: चालक, मिश्रधातु, विद्युतरोधी", "6. Resistivity: conductors, alloys, insulators"),
  points=[
   ("धातुओं की प्रतिरोधकता बहुत कम (10^(-8) Ω m के आसपास) होती है, इसलिए वे अच्छे चालक हैं। ताँबा और एल्युमिनियम बिजली के तारों में लगते हैं।",
    "Metals have very low resistivity (around 10^(-8) Ω m), so they are good conductors. Copper and aluminium are used in electric wires."),
   ("मिश्रधातुओं (जैसे नाइक्रोम) की प्रतिरोधकता उनकी धातुओं से कहीं अधिक होती है और वे ऊँचे ताप पर जल्दी ऑक्सीकृत (जलती) नहीं होतीं। इसलिए हीटर, प्रेस, टोस्टर के तत्व मिश्रधातु के बनते हैं।",
    "Alloys such as nichrome have much higher resistivity than their metals and do not oxidise (burn) easily at high temperature. That is why the elements of heaters, irons and toasters are made of alloys."),
   ("काँच, रबर जैसे विद्युतरोधियों की प्रतिरोधकता लगभग 10^10 से 10^16 Ω m तक होती है, इसलिए उनसे धारा लगभग नहीं बहती।",
    "Insulators such as glass and rubber have resistivity of about 10^10 to 10^16 Ω m, so almost no current flows through them."),
   ("🧠 याद रखो: तार में ताँबा (कम ρ, कम गर्मी), हीटर में नाइक्रोम (ज़्यादा ρ, ज़्यादा गर्मी), बल्ब में टंगस्टन (बहुत ऊँचा गलनांक)।",
    "🧠 Remember: copper in wires (low ρ, little heat), nichrome in heaters (high ρ, lots of heat), tungsten in bulbs (very high melting point)."),
  ],
  table=[[("पदार्थ","Material"),("ρ (Ω m, 20 °C)","ρ (Ω m, 20 °C)"),("उपयोग","Use")],
         [("ताँबा","Copper"),("1.7 × 10^(-8)","1.7 × 10^(-8)"),("घर की वायरिंग","house wiring")],
         [("एल्युमिनियम","Aluminium"),("2.6 × 10^(-8)","2.6 × 10^(-8)"),("बिजली की लाइनें","power lines")],
         [("टंगस्टन","Tungsten"),("5.2 × 10^(-8)","5.2 × 10^(-8)"),("बल्ब का तंतु","bulb filament")],
         [("नाइक्रोम","Nichrome"),("1.1 × 10^(-6)","1.1 × 10^(-6)"),("हीटर का तत्व","heating element")],
         [("काँच","Glass"),("10^10 से 10^14","10^10 to 10^14"),("विद्युतरोधी","insulator")]]),

 dict(fig="S_series_V",
  title=("7. प्रतिरोधकों का श्रेणीक्रम संयोजन", "7. Resistors in series"),
  points=[
   ("📌 श्रेणीक्रम: प्रतिरोधक एक के बाद एक जुड़े हों, धारा के लिए एक ही रास्ता।",
    "📌 Series: resistors joined end to end, giving one path for the current."),
   ("हर प्रतिरोधक से एक ही धारा बहती है। कुल विभवांतर बँट जाता है: V = V₁ + V₂ + V₃।",
    "The same current flows through every resistor. The total voltage divides: V = V₁ + V₂ + V₃."),
   ("📌 तुल्य प्रतिरोध: Rs = R₁ + R₂ + R₃। श्रेणीक्रम में कुल प्रतिरोध सबसे बड़े प्रतिरोध से भी अधिक होता है।",
    "📌 Equivalent resistance: Rs = R₁ + R₂ + R₃. In series the total is larger than even the largest resistor."),
   ("उदाहरण: 6 V पर 2 Ω और 4 Ω श्रेणी में → Rs = 6 Ω, I = 1 A, V₁ = 2 V, V₂ = 4 V। बड़े प्रतिरोध को बड़ा हिस्सा।",
    "Example: 2 Ω and 4 Ω in series on 6 V → Rs = 6 Ω, I = 1 A, V₁ = 2 V, V₂ = 4 V. The larger resistor gets the larger share."),
   ("कमी: एक बल्ब फ्यूज़ हो जाए तो पूरा रास्ता टूटता है और सभी बल्ब बुझ जाते हैं।",
    "Drawback: if one bulb fuses, the only path breaks and every bulb goes off."),
  ]),

 dict(fig="P_total",
  title=("8. प्रतिरोधकों का पार्श्वक्रम संयोजन और दैनिक उपयोग", "8. Resistors in parallel and daily use"),
  points=[
   ("📌 पार्श्वक्रम: सभी प्रतिरोधक एक ही दो बिंदुओं के बीच जुड़े हों, धारा के लिए कई रास्ते।",
    "📌 Parallel: all resistors joined between the same two points, giving several paths for the current."),
   ("हर प्रतिरोधक पर पूरा विभवांतर होता है। कुल धारा बँटती है: I = I₁ + I₂ + I₃।",
    "Every resistor has the full voltage across it. The total current divides: I = I₁ + I₂ + I₃."),
   ("📌 तुल्य प्रतिरोध: 1/Rp = 1/R₁ + 1/R₂ + 1/R₃। Rp सबसे छोटे प्रतिरोध से भी कम होता है।",
    "📌 Equivalent resistance: 1/Rp = 1/R₁ + 1/R₂ + 1/R₃. Rp is smaller than even the smallest resistor."),
   ("शॉर्टकट: दो प्रतिरोधों के लिए Rp = (R₁ × R₂)/(R₁ + R₂)। n बराबर प्रतिरोध R के लिए Rp = R/n।",
    "Shortcut: for two resistors Rp = (R₁ × R₂)/(R₁ + R₂). For n equal resistors R, Rp = R/n."),
   ("उदाहरण: 6 V पर 2 Ω और 4 Ω पार्श्वक्रम में → शाखा धाराएँ 3 A और 1.5 A, कुल 4.5 A, Rp = 4/3 Ω।",
    "Example: 2 Ω and 4 Ω in parallel on 6 V → branch currents 3 A and 1.5 A, total 4.5 A, Rp = 4/3 Ω."),
   ("📌 घर में उपकरण पार्श्वक्रम में जुड़ते हैं (exam line): ताकि हर उपकरण को पूरा 230 V मिले, हर एक को अलग से चालू-बंद किया जा सके, और एक के खराब होने पर बाकी चलते रहें।",
    "📌 Home appliances are connected in parallel (exam line): so each gets the full 230 V, each can be switched on or off on its own, and if one fails the others keep working."),
  ],
  table=[[("तुलना","Compare"),("श्रेणीक्रम","Series"),("पार्श्वक्रम","Parallel")],
         [("धारा","Current"),("सब में बराबर","same in all"),("बँटती है","divides")],
         [("विभवांतर","Voltage"),("बँटता है","divides"),("सब पर बराबर","same on all")],
         [("तुल्य प्रतिरोध","Equivalent R"),("R₁ + R₂ + …","R₁ + R₂ + …"),("1/Rp = 1/R₁ + 1/R₂ + …","1/Rp = 1/R₁ + 1/R₂ + …")],
         [("एक उपकरण टूटे तो","If one fails"),("सब बंद","all stop"),("बाकी चलें","others work")]]),

 dict(fig="M_mixed2",
  title=("9. मिश्रित परिपथ: कदम-दर-कदम हल", "9. Mixed circuits: solve step by step"),
  points=[
   ("नियम: पहले सबसे अंदर का पार्श्वक्रम भाग छोटा करो, फिर श्रेणीक्रम में जोड़ो, फिर I = V/R लगाओ।",
    "Rule: first collapse the innermost parallel part, then add in series, then use I = V/R."),
   ("उदाहरण: 2 Ω के बाद 4 Ω और 4 Ω पार्श्वक्रम में, 6 V पर। 4 ∥ 4 = 2 Ω → कुल 2 + 2 = 4 Ω → I = 6/4 = 1.5 A।",
    "Example: 2 Ω followed by 4 Ω and 4 Ω in parallel, on 6 V. 4 ∥ 4 = 2 Ω → total 2 + 2 = 4 Ω → I = 6/4 = 1.5 A."),
   ("अधिकतम और न्यूनतम प्रतिरोध: दिए प्रतिरोधों को सब श्रेणी में जोड़ो तो अधिकतम, सब पार्श्व में जोड़ो तो न्यूनतम।",
    "Maximum and minimum resistance: all in series gives the maximum, all in parallel gives the minimum."),
   ("⚠️ सबको श्रेणीक्रम की तरह जोड़ देना (2 + 4 + 4 = 10 Ω) सबसे आम गलती है।",
    "⚠️ Adding everything as if in series (2 + 4 + 4 = 10 Ω) is the most common mistake."),
  ]),

 dict(fig="F7_heating",
  title=("10. विद्युत धारा का तापीय प्रभाव (जूल का नियम)", "10. Heating effect of current (Joule's law)"),
  points=[
   ("📌 जूल का तापन नियम (exam line): किसी प्रतिरोधक में उत्पन्न ऊष्मा (i) धारा के वर्ग, (ii) प्रतिरोध और (iii) धारा बहने के समय के अनुक्रमानुपाती होती है। H = I²Rt",
    "📌 Joule's law of heating (exam line): the heat produced in a resistor is proportional to (i) the square of the current, (ii) the resistance and (iii) the time for which the current flows. H = I²Rt"),
   ("ये तीनों रूप सही हैं: H = I²Rt = VIt = (V²/R)t। जो मान दिए हों, वही रूप चुनो।",
    "All three forms are correct: H = I²Rt = VIt = (V²/R)t. Use the form that fits the given values."),
   ("धारा दुगुनी → ऊष्मा 4 गुना (I² के कारण)। प्रतिरोध या समय दुगुना → ऊष्मा 2 गुना।",
    "Double the current → 4 times the heat (because of I²). Double the resistance or the time → 2 times the heat."),
   ("हीटर की कुंडली और उसकी तार श्रेणीक्रम में हैं, इसलिए धारा बराबर है। कुंडली का R बहुत बड़ा है, इसलिए गर्मी वहीं बनती है और तार ठंडी रहती है।",
    "The heater coil and its cord are in series, so the current is the same. The coil's R is far larger, so the heat appears there and the cord stays cool."),
  ]),

 dict(fig="F13_fuse_filament",
  title=("11. तापीय प्रभाव के उपयोग: बल्ब, हीटर, फ्यूज़", "11. Uses of the heating effect: bulb, heater, fuse"),
  points=[
   ("हीटर, प्रेस, टोस्टर, गीज़र: मिश्रधातु का तत्व गर्म होता है।",
    "Heater, iron, toaster, geyser: an alloy element heats up."),
   ("📌 विद्युत बल्ब: तंतु टंगस्टन का होता है क्योंकि उसका गलनांक बहुत ऊँचा (लगभग 3380 °C) है और वह गर्म होकर चमकता है। बल्ब में नाइट्रोजन, आर्गन जैसी निष्क्रिय गैस भरी होती है ताकि तंतु ऑक्सीकृत न हो और ज़्यादा चले।",
    "📌 Electric bulb: the filament is tungsten because of its very high melting point (about 3380 °C), and it glows when hot. The bulb is filled with an inert gas such as nitrogen or argon so the filament does not oxidise and lasts longer."),
   ("📌 फ्यूज़ (exam line): कम गलनांक वाला पतला तार, जो परिपथ में श्रेणीक्रम में लगता है। धारा उसकी रेटिंग से अधिक होने पर तार गर्म होकर पिघल जाता है, परिपथ टूट जाता है और उपकरण तथा वायरिंग बच जाते हैं।",
    "📌 Fuse (exam line): a thin wire of low melting point connected in series in the circuit. If the current goes above its rating the wire heats up and melts, the circuit breaks, and the appliances and wiring are protected."),
   ("फ्यूज़ की रेटिंग सामान्य धारा से थोड़ी अधिक रखते हैं। जैसे 1 kW, 230 V के प्रेस में धारा ≈ 4.35 A, इसलिए 5 A का फ्यूज़।",
    "A fuse is rated a little above the normal current. A 1 kW, 230 V iron draws about 4.35 A, so it uses a 5 A fuse."),
  ]),

 dict(fig="F14_power_wheel",
  title=("12. विद्युत शक्ति: P, V, I, R का संबंध", "12. Electric power: how P, V, I and R are linked"),
  points=[
   ("📌 परिभाषा (exam line): विद्युत ऊर्जा के उपभोग की दर को विद्युत शक्ति कहते हैं। P = W/t = VI",
    "📌 Definition (exam line): the rate at which electrical energy is used is called electric power. P = W/t = VI"),
   ("1 वाट (W): जब 1 V पर 1 A धारा बहे, यानी 1 J प्रति सेकंड। 1 kW = 1000 W।",
    "1 watt (W): power when 1 A flows at 1 V, that is 1 J per second. 1 kW = 1000 W."),
   ("V = IR रखने पर: P = I²R = V²/R। जो दो राशियाँ पता हों, उसी रूप से हल करो।",
    "Using V = IR: P = I²R = V²/R. Solve with the form that uses the two values you know."),
   ("उपकरण की रेटिंग (जैसे 100 W, 230 V) से उसका प्रतिरोध निकलता है: R = V²/P = 230²/100 = 529 Ω।",
    "An appliance's rating (such as 100 W, 230 V) gives its resistance: R = V²/P = 230²/100 = 529 Ω."),
   ("📌 एक ही सप्लाई पर (पार्श्वक्रम) ज़्यादा वाट वाला बल्ब ज़्यादा चमकता है। श्रेणीक्रम में धारा बराबर होती है, इसलिए बड़े R वाला यानी कम वाट वाला बल्ब ज़्यादा चमकता है।",
    "📌 On the same supply (parallel) the higher-watt bulb glows more. In series the current is equal, so the bulb with larger R, the lower-watt one, glows more."),
   ("⚠️ स्थिर प्रतिरोध वाले उपकरण पर V दुगुना करने से P = V²/R के कारण शक्ति 4 गुना हो जाती है, दुगुनी नहीं।",
    "⚠️ For a fixed-resistance appliance, doubling V makes the power 4 times (P = V²/R), not 2 times."),
  ]),

 dict(fig="F8_bill",
  title=("13. विद्युत ऊर्जा का व्यावसायिक मात्रक (kWh) और बिल", "13. Commercial unit of energy (kWh) and the bill"),
  points=[
   ("ऊर्जा E = P × t। P वाट और t सेकंड में हों तो E जूल में।",
    "Energy E = P × t. With P in watts and t in seconds, E is in joules."),
   ("📌 1 kWh (1 यूनिट) (exam line): 1 kW शक्ति का उपकरण 1 घंटे चलने पर खर्च हुई ऊर्जा। 1 kWh = 1000 W × 3600 s = 3.6 × 10^6 J।",
    "📌 1 kWh (1 unit) (exam line): the energy used by a 1 kW appliance in 1 hour. 1 kWh = 1000 W × 3600 s = 3.6 × 10^6 J."),
   ("बिल का तरीका: यूनिट = (वाट ÷ 1000) × घंटे × दिन, फिर बिल = यूनिट × दर।",
    "Bill method: units = (watts ÷ 1000) × hours × days, then bill = units × rate."),
   ("उदाहरण: 1500 W का AC रोज़ 6 घंटे, 30 दिन, ₹7 प्रति यूनिट → 1.5 × 6 × 30 = 270 यूनिट → ₹1,890।",
    "Example: a 1500 W AC, 6 hours a day for 30 days at ₹7 per unit → 1.5 × 6 × 30 = 270 units → ₹1,890."),
   ("⚠️ W को kW में बदलना मत भूलो। kW शक्ति है, kWh ऊर्जा है।",
    "⚠️ Do not forget to change W to kW. kW is power, kWh is energy."),
  ]),

 dict(fig="F9_wiring",
  title=("14. (अतिरिक्त, पाठ्यक्रम से बाहर) घरेलू वायरिंग और सुरक्षा", "14. (Extra, beyond syllabus) Home wiring and safety"),
  points=[
   ("यह भाग वास्तविक जीवन के लिए है, इस अध्याय की परीक्षा के पाठ्यक्रम में नहीं।",
    "This part is for real life; it is not in this chapter's exam syllabus."),
   ("घर में लाइव, न्यूट्रल और अर्थ तार होते हैं। स्विच, फ्यूज़ और MCB हमेशा लाइव तार में लगते हैं।",
    "Homes have live, neutral and earth wires. Switches, fuses and the MCB always go in the live wire."),
   ("सभी उपकरण पार्श्वक्रम में हैं, इसलिए कुल धारा सबकी धाराओं का योग है। 230 V पर 2000 W + 1500 W + 1000 W = 4500 W → I ≈ 19.6 A, जो 16 A की लाइन से अधिक है, इसलिए MCB गिर जाता है।",
    "All appliances are in parallel, so the total current is the sum of their currents. At 230 V, 2000 W + 1500 W + 1000 W = 4500 W → I ≈ 19.6 A, more than a 16 A line, so the MCB trips."),
   ("अर्थ तार धातु के खोल से रिसी धारा को ज़मीन में भेजकर झटके से बचाता है।",
    "The earth wire carries leaked current from a metal body into the ground and prevents a shock."),
  ]),

 dict(fig=None,
  title=("15. सभी SI परिभाषाएँ एक जगह (परीक्षा के लिए)", "15. All SI definitions in one place (for the exam)"),
  points=[
   ("1 कूलॉम: 1 ऐम्पियर धारा द्वारा 1 सेकंड में प्रवाहित आवेश।", "1 coulomb: the charge carried by a current of 1 ampere in 1 second."),
   ("1 ऐम्पियर: 1 सेकंड में 1 कूलॉम आवेश का प्रवाह।", "1 ampere: a flow of 1 coulomb of charge in 1 second."),
   ("1 वोल्ट: 1 कूलॉम आवेश को ले जाने में 1 जूल कार्य।", "1 volt: carrying 1 coulomb across the two points takes 1 joule."),
   ("1 ओम: 1 वोल्ट विभवांतर पर 1 ऐम्पियर धारा बहे तो चालक का प्रतिरोध।", "1 ohm: the resistance of a conductor in which 1 volt drives 1 ampere."),
   ("1 वाट: 1 वोल्ट पर 1 ऐम्पियर धारा, यानी 1 जूल प्रति सेकंड।", "1 watt: 1 ampere at 1 volt, that is 1 joule per second."),
   ("1 kWh = 3.6 × 10^6 J।", "1 kWh = 3.6 × 10^6 J."),
  ],
  table=[[("राशि","Quantity"),("सूत्र","Formula"),("SI मात्रक","SI unit")],
         [("धारा","Current"),("I = Q/t","I = Q/t"),("A","A")],[("विभवांतर","Potential difference"),("V = W/Q","V = W/Q"),("V","V")],
         [("प्रतिरोध","Resistance"),("R = V/I","R = V/I"),("Ω","Ω")],[("प्रतिरोधकता","Resistivity"),("ρ = RA/L","ρ = RA/L"),("Ω m","Ω m")],
         [("ऊष्मा","Heat"),("H = I²Rt","H = I²Rt"),("J","J")],[("शक्ति","Power"),("P = VI","P = VI"),("W","W")]]),

 dict(fig=None,
  title=("16. सवालों के प्रकार और हल करने की चाल", "16. Question types and how to attack them"),
  points=[
   ("यह तालिका बताती है कि बोर्ड परीक्षा में इस अध्याय से कौन-कौन से numerical आते हैं और हर एक का सबसे तेज़ रास्ता क्या है।",
    "This table lists the numerical types this chapter gives in the board exam and the quickest route for each."),
  ],
  table=[[("प्रकार","Type"),("सूत्र","Formula"),("तेज़ चाल","Quick trick")],
         [("आवेश, धारा, समय","Charge, current, time"),("Q = It","Q = It"),("A × s = C","A × s = C")],
         [("इलेक्ट्रॉनों की संख्या","Number of electrons"),("n = Q/e","n = Q/e"),("1 C ≈ 6.25 × 10^18 e","1 C ≈ 6.25 × 10^18 e")],
         [("कार्य/ऊर्जा","Work/energy"),("W = VQ","W = VQ"),("V = J प्रति C","V = J per C")],
         [("ρ से प्रतिरोध","R from ρ"),("R = ρL/A","R = ρL/A"),("mm² = 10^(-6) m²","mm² = 10^(-6) m²")],
         [("खींचा/मोड़ा तार","Stretched/folded wire"),("R ∝ L/A","R ∝ L/A"),("खींचो ×n → R × n²","stretch ×n → R × n²")],
         [("श्रेणी/पार्श्व","Series/parallel"),("Rs, Rp","Rs, Rp"),("दो के लिए गुणा/जोड़","two: product/sum")],
         [("मिश्रित परिपथ","Mixed circuit"),("अंदर से बाहर","inside out"),("पार्श्व पहले","parallel first")],
         [("बल्बों की चमक","Bulb brightness"),("R = V²/P","R = V²/P"),("श्रेणी: कम वाट ज़्यादा चमके","series: lower watt glows more")],
         [("ऊष्मा","Heat"),("H = I²Rt","H = I²Rt"),("I दुगुना → H × 4","I × 2 → H × 4")],
         [("फ्यूज़ चुनना","Choosing a fuse"),("I = P/V","I = P/V"),("थोड़ा ऊपर की रेटिंग","next rating up")],
         [("बिजली बिल","Electricity bill"),("E = Pt","E = Pt"),("kW × घंटे = यूनिट","kW × hours = units")]]),
]

TEACH = [
 dict(fig="F10_ampere",
  heading=("पाठ 1: धारा, यानी हर सेकंड कितना आवेश", "Lesson 1: Current, the charge passing each second"),
  explain=("❓ सोचो ज़रा: स्विच दबाते ही बल्ब तुरंत जल जाता है, जबकि तार में इलेक्ट्रॉन बहुत धीरे खिसकते हैं। यह कैसे?\n"
           "तार में मुक्त इलेक्ट्रॉन पहले से हर जगह भरे हैं। बैटरी जुड़ते ही पूरे तार के इलेक्ट्रॉन एक साथ खिसकने लगते हैं, इसलिए बल्ब तक ऊर्जा तुरंत पहुँचती है।\n"
           "धारा बताती है कि तार के किसी काट से हर सेकंड कितना आवेश पार हुआ: I = Q/t। 1 सेकंड में 1 कूलॉम पार हो तो धारा 1 ऐम्पियर।\n"
           "दिशा याद रखो: परम्परागत धारा + से −, इलेक्ट्रॉन − से +।",
           "❓ Think: the bulb lights the moment you press the switch, yet electrons drift very slowly in the wire. How?\n"
           "Free electrons are already everywhere in the wire. When the battery is connected they all start drifting together, so energy reaches the bulb at once.\n"
           "Current tells how much charge crosses a section of the wire each second: I = Q/t. If 1 coulomb crosses in 1 second, the current is 1 ampere.\n"
           "Remember the direction: conventional current from + to −, electrons from − to +."),
  example=("समझो ऐसे: मोबाइल चार्जर से 2 A धारा 30 मिनट बहे तो आवेश Q = 2 × 1800 = 3600 C। इतने आवेश में 3600 ÷ (1.6 × 10^(-19)) ≈ 2.25 × 10^22 इलेक्ट्रॉन हैं।",
           "Picture it: a phone charger passing 2 A for 30 minutes moves Q = 2 × 1800 = 3600 C. That is 3600 ÷ (1.6 × 10^(-19)) ≈ 2.25 × 10^22 electrons.")),

 dict(fig="F1_current",
  heading=("पाठ 2: विभवांतर, आवेश को धकेलने वाली ऊर्जा", "Lesson 2: Potential difference, the energy that pushes charge"),
  explain=("❓ सोचो ज़रा: 1.5 V का सेल और 9 V की बैटरी, दोनों में अंतर क्या है?\n"
           "विभवांतर बताता है कि हर कूलॉम आवेश को कितनी ऊर्जा मिलती है: V = W/Q। 9 V की बैटरी हर कूलॉम को 9 J देती है, 1.5 V का सेल सिर्फ़ 1.5 J।\n"
           "धारा और विभवांतर अलग हैं: धारा = प्रति सेकंड आवेश, विभवांतर = प्रति कूलॉम ऊर्जा।",
           "❓ Think: what is the difference between a 1.5 V cell and a 9 V battery?\n"
           "Potential difference tells how much energy each coulomb of charge receives: V = W/Q. A 9 V battery gives every coulomb 9 J, a 1.5 V cell only 1.5 J.\n"
           "Current and potential difference are different: current = charge per second, potential difference = energy per coulomb."),
  example=("समझो ऐसे: 12 V की बैटरी 5 C आवेश को परिपथ में घुमाए तो कार्य W = V × Q = 12 × 5 = 60 J।",
           "Picture it: a 12 V battery pushing 5 C of charge round the circuit does W = V × Q = 12 × 5 = 60 J of work.")),

 dict(fig="F3_meters",
  heading=("पाठ 3: परिपथ आरेख और मीटर कहाँ लगें", "Lesson 3: Circuit diagrams and where the meters go"),
  explain=("❓ सोचो ज़रा: बल्ब की धारा नापनी है। एमीटर को बल्ब के बगल में (आर-पार) लगाएँ या रास्ते में?\n"
           "धारा को एमीटर के अंदर से होकर जाना होगा, इसलिए एमीटर श्रेणीक्रम में, उसी रास्ते में। उसका प्रतिरोध बहुत कम होता है ताकि धारा न घटे।\n"
           "वोल्टमीटर उपकरण के दोनों सिरों के आर-पार, यानी पार्श्वक्रम में लगता है। उसका प्रतिरोध बहुत अधिक होता है ताकि वह खुद धारा न ले।\n"
           "उल्टा जोड़ दिया तो: वोल्टमीटर श्रेणी में धारा रोक देगा और एमीटर पार्श्व में बड़ी धारा लेकर खराब हो सकता है।",
           "❓ Think: to measure a bulb's current, do you put the ammeter across the bulb or in its path?\n"
           "The current must pass through the ammeter, so it goes in series, in the same path. Its resistance is very low so the current does not drop.\n"
           "The voltmeter goes across the two ends of the device, in parallel. Its resistance is very high so it takes almost no current itself.\n"
           "If they are swapped: the voltmeter in series stops the current, and the ammeter in parallel draws a large current and can be damaged."),
  example=("समझो ऐसे: एमीटर पानी की पाइप में लगे मीटर जैसा है (पानी उसके अंदर से जाए), वोल्टमीटर दो टंकियों के पानी के स्तर का अंतर देखने जैसा है।",
           "Picture it: an ammeter is like a meter fitted inside a water pipe (the water must go through it); a voltmeter is like comparing the water levels of two tanks.")),

 dict(fig="F4_vi",
  heading=("पाठ 4: ओम का नियम और V-I ग्राफ पढ़ना", "Lesson 4: Ohm's law and reading the V-I graph"),
  explain=("❓ सोचो ज़रा: एक ही 6 V पर किसी तार से 3 A बहती है और किसी से 1 A। फ़र्क किसका है?\n"
           "फ़र्क प्रतिरोध का है। ताप स्थिर रहे तो V ∝ I, यानी V = IR। R जितना बड़ा, उतने ही V पर धारा उतनी कम।\n"
           "प्रयोग: बैटरी, एमीटर, प्रतिरोधक, वोल्टमीटर और परिवर्ती प्रतिरोध (rheostat) जोड़ो। rheostat से धारा बदलो और हर बार V और I लिखो। हर बार V/I लगभग बराबर आता है। यही R है।\n"
           "V-I ग्राफ मूल बिंदु से सीधी रेखा बनता है। V ऊपर (y-अक्ष) हो तो ढलान = R।",
           "❓ Think: on the same 6 V, one wire passes 3 A and another 1 A. What makes the difference?\n"
           "Resistance. At constant temperature V ∝ I, that is V = IR. The bigger R, the smaller the current at the same V.\n"
           "Experiment: connect a battery, ammeter, resistor, voltmeter and a rheostat. Change the current with the rheostat and note V and I each time. V/I comes out nearly the same every time. That is R.\n"
           "Plotting V against I gives a straight line starting at the origin. With V on the y-axis, slope = R."),
  example=("समझो ऐसे: प्रयोग में (1 V, 0.25 A), (2 V, 0.5 A), (3 V, 0.75 A) मिले। हर बार V/I = 4 Ω। ग्राफ सीधी रेखा, ढलान 4 Ω।",
           "Picture it: the experiment gives (1 V, 0.25 A), (2 V, 0.5 A), (3 V, 0.75 A). Each time V/I = 4 Ω. Straight line, slope 4 Ω.")),

 dict(fig="F5_resistivity",
  heading=("पाठ 5: प्रतिरोध किस पर निर्भर है", "Lesson 5: What resistance depends on"),
  explain=("❓ सोचो ज़रा: हीटर में पतला लंबा तार क्यों, और घर की वायरिंग में मोटा ताँबा क्यों?\n"
           "R = ρL/A। लंबाई बढ़ाओ तो R बढ़ता है (इलेक्ट्रॉनों को ज़्यादा टक्करें)। मोटाई बढ़ाओ तो R घटता है (चलने के ज़्यादा रास्ते)।\n"
           "ρ पदार्थ की पहचान है: ताँबे का बहुत कम, नाइक्रोम का लगभग 65 गुना ज़्यादा। इसलिए वायरिंग ताँबे की (कम गर्मी) और हीटर नाइक्रोम का (ज़्यादा गर्मी)।\n"
           "मिश्रधातु इसलिए भी चुनी जाती है क्योंकि ऊँचे ताप पर वह आसानी से नहीं जलती।",
           "❓ Think: why does a heater use thin long wire, and house wiring thick copper?\n"
           "R = ρL/A. A longer wire has more R (more collisions for electrons). A thicker wire has less R (more paths).\n"
           "ρ is a property of the material: very low for copper, about 65 times higher for nichrome. So wiring is copper (little heat) and the heater is nichrome (lots of heat).\n"
           "Alloys are also chosen because they do not burn easily at high temperature."),
  example=("समझो ऐसे: 4 Ω का तार खींचकर दुगुना लंबा किया (आयतन वही) → L दुगुनी, A आधा → R = 4 × 2 × 2 = 16 Ω। वही तार आधा मोड़ा → L आधी, A दुगुना → R = 4 ÷ 4 = 1 Ω।",
           "Picture it: a 4 Ω wire stretched to double length (same volume) → L doubles, A halves → R = 4 × 2 × 2 = 16 Ω. The same wire folded in half → L halves, A doubles → R = 4 ÷ 4 = 1 Ω.")),

 dict(fig="S_series_req",
  heading=("पाठ 6: श्रेणीक्रम: एक रास्ता, एक धारा", "Lesson 6: Series: one path, one current"),
  explain=("❓ सोचो ज़रा: 6 V की बैटरी से 2 Ω और 4 Ω एक के बाद एक जुड़े हैं। 2 Ω वाले से कितनी धारा जाएगी?\n"
           "पहले कुल प्रतिरोध: Rs = 2 + 4 = 6 Ω। फिर I = 6/6 = 1 A। श्रेणीक्रम में यही 1 A दोनों से गुज़रती है।\n"
           "वोल्टेज बँटता है: V₁ = 1 × 2 = 2 V, V₂ = 1 × 4 = 4 V, जोड़ 6 V। बड़े प्रतिरोध को बड़ा हिस्सा।\n"
           "एक बल्ब फ्यूज़ हो तो रास्ता टूटता है और सब बुझ जाते हैं। (नीचे 'चलो हल करें' में यही कदम-दर-कदम है।)",
           "❓ Think: 2 Ω and 4 Ω are joined one after another to a 6 V battery. How much current goes through the 2 Ω?\n"
           "First the total: Rs = 2 + 4 = 6 Ω. Then I = 6/6 = 1 A. In series this same 1 A passes through both.\n"
           "The voltage divides: V₁ = 1 × 2 = 2 V, V₂ = 1 × 4 = 4 V, sum 6 V. The larger resistor gets the larger share.\n"
           "If one bulb fuses, the path breaks and all go off. (The same steps are solved below under 'Let us solve'.)"),
  example=("⚠️ जाल: 3 A का उत्तर तब आता है जब पूरे 6 V को सिर्फ़ 2 Ω पर लगा दें। श्रेणीक्रम में 2 Ω को पूरे 6 V नहीं मिलते।",
           "⚠️ Trap: 3 A comes from putting all 6 V across the 2 Ω alone. In series the 2 Ω does not get the full 6 V.")),

 dict(fig="P_branch",
  heading=("पाठ 7: पार्श्वक्रम: हर शाखा को पूरा वोल्टेज", "Lesson 7: Parallel: full voltage on every branch"),
  explain=("❓ सोचो ज़रा: वही 2 Ω और 4 Ω अब दोनों सिरे सीधे बैटरी से जुड़े हैं। कुल धारा बढ़ेगी या घटेगी?\n"
           "हर शाखा पर पूरे 6 V: I₁ = 6/2 = 3 A, I₂ = 6/4 = 1.5 A। कुल धारा = 4.5 A, जो श्रेणी के 1 A से कहीं ज़्यादा है।\n"
           "तुल्य प्रतिरोध: 1/Rp = 1/2 + 1/4 = 3/4, इसलिए Rp = 4/3 Ω। यह सबसे छोटे प्रतिरोध 2 Ω से भी कम है। जाँच: 6 ÷ (4/3) = 4.5 A।\n"
           "इसीलिए घर में उपकरण पार्श्वक्रम में जुड़ते हैं: हर एक को पूरा 230 V मिलता है और हर एक अलग से चालू-बंद होता है।",
           "❓ Think: the same 2 Ω and 4 Ω now have both ends joined straight to the battery. Does the total current rise or fall?\n"
           "Each branch has the full 6 V: I₁ = 6/2 = 3 A, I₂ = 6/4 = 1.5 A. Total = 4.5 A, far more than the 1 A in series.\n"
           "Equivalent resistance: 1/Rp = 1/2 + 1/4 = 3/4, so Rp = 4/3 Ω, smaller than even the smallest, 2 Ω. Check: 6 ÷ (4/3) = 4.5 A.\n"
           "That is why home appliances are in parallel: each gets the full 230 V and each switches on and off on its own."),
  example=("⚠️ जाल: 'प्रतिरोध जोड़ने से धारा हमेशा घटती है' गलत है। पार्श्वक्रम में प्रतिरोध जोड़ने से कुल प्रतिरोध घटता है और कुल धारा बढ़ती है।",
           "⚠️ Trap: 'adding a resistor always lowers the current' is wrong. Adding one in parallel lowers the total resistance and raises the total current.")),

 dict(fig="B_bulbs_series",
  heading=("पाठ 8: 60 W बनाम 100 W, चौंकाने वाला नतीजा", "Lesson 8: 60 W vs 100 W, a surprising result"),
  explain=("❓ सोचो ज़रा: 60 W और 100 W के बल्ब 230 V पर श्रेणीक्रम में जोड़े। कौन ज़्यादा चमकेगा?\n"
           "पहले प्रतिरोध: R = V²/P। R₆₀ = 230²/60 ≈ 882 Ω, R₁₀₀ = 230²/100 = 529 Ω। कम वाट वाले का प्रतिरोध बड़ा है।\n"
           "श्रेणीक्रम में धारा बराबर: I = 230 ÷ (882 + 529) ≈ 0.163 A। अब P = I²R: P₆₀ ≈ 23.4 W, P₁₀₀ ≈ 14.1 W। यानी 60 W वाला ज़्यादा चमकता है।\n"
           "पार्श्वक्रम (घर) में दोनों को पूरे 230 V मिलते हैं, तब 100 W वाला ज़्यादा चमकता है।",
           "❓ Think: a 60 W and a 100 W bulb are joined in series on 230 V. Which glows more?\n"
           "First the resistances: R = V²/P. R₆₀ = 230²/60 ≈ 882 Ω, R₁₀₀ = 230²/100 = 529 Ω. The lower-watt bulb has the larger resistance.\n"
           "In series the current is equal: I = 230 ÷ (882 + 529) ≈ 0.163 A. Now P = I²R: P₆₀ ≈ 23.4 W, P₁₀₀ ≈ 14.1 W. So the 60 W bulb glows more.\n"
           "In parallel (at home) both get the full 230 V, and then the 100 W bulb glows more."),
  example=("🧠 याद रखो: पार्श्वक्रम में ज़्यादा वाट ज़्यादा चमके; श्रेणीक्रम में कम वाट (बड़ा R) ज़्यादा चमके।",
           "🧠 Remember: in parallel the higher watt glows more; in series the lower watt (larger R) glows more.")),

 dict(fig="M_mixed0",
  heading=("पाठ 9: मिश्रित परिपथ अंदर से बाहर हल करो", "Lesson 9: Solve a mixed circuit from the inside out"),
  explain=("❓ सोचो ज़रा: 2 Ω के बाद 4 Ω और 4 Ω पार्श्वक्रम में, 6 V पर। कुल धारा कितनी?\n"
           "कदम 1: अंदर का पार्श्व भाग। दो बराबर 4 Ω पार्श्व में = 4/2 = 2 Ω।\n"
           "कदम 2: अब वह 2 Ω और पहला 2 Ω श्रेणी में: 2 + 2 = 4 Ω।\n"
           "कदम 3: I = V/R = 6/4 = 1.5 A। हर 4 Ω शाखा में आधी, यानी 0.75 A।",
           "❓ Think: 2 Ω followed by 4 Ω and 4 Ω in parallel, on 6 V. What is the total current?\n"
           "Step 1: the inner parallel part. Two equal 4 Ω in parallel = 4/2 = 2 Ω.\n"
           "Step 2: that 2 Ω and the first 2 Ω are in series: 2 + 2 = 4 Ω.\n"
           "Step 3: I = V/R = 6/4 = 1.5 A. Each 4 Ω branch carries half, 0.75 A."),
  example=("⚠️ जाल: 0.6 A तब आता है जब सबको श्रेणी में जोड़ दें (2 + 4 + 4 = 10 Ω)।",
           "⚠️ Trap: 0.6 A comes from adding everything in series (2 + 4 + 4 = 10 Ω).")),

 dict(fig="F7_heating",
  heading=("पाठ 10: धारा से गर्मी: जूल का नियम", "Lesson 10: Heat from current: Joule's law"),
  explain=("❓ सोचो ज़रा: हीटर की कुंडली लाल हो जाती है, पर उसकी तार ठंडी क्यों रहती है?\n"
           "धारा बहने पर विद्युत ऊर्जा ऊष्मा बनती है: H = I²Rt (या VIt, या V²t/R)।\n"
           "कुंडली और तार श्रेणी में हैं, धारा बराबर है। 1000 W, 230 V के हीटर में I ≈ 4.35 A। कुंडली का R ≈ 52.9 Ω है, इसलिए वहाँ हर सेकंड ≈ 1000 J ऊष्मा बनती है। तार का R ≈ 0.1 Ω है, वहाँ सिर्फ़ ≈ 1.9 J।\n"
           "I² के कारण धारा दुगुनी करने पर ऊष्मा 4 गुना होती है।",
           "❓ Think: the heater coil glows red, so why does its cord stay cool?\n"
           "When current flows, electrical energy becomes heat: H = I²Rt (or VIt, or V²t/R).\n"
           "Coil and cord are in series, so the current is equal. A 1000 W, 230 V heater draws I ≈ 4.35 A. The coil's R ≈ 52.9 Ω, so about 1000 J of heat appears there every second. The cord's R ≈ 0.1 Ω gives only about 1.9 J.\n"
           "Because of I², doubling the current makes 4 times the heat."),
  example=("समझो ऐसे: 3 Ω के प्रतिरोधक में 2 A धारा 5 s बहे तो H = 2² × 3 × 5 = 60 J।",
           "Picture it: 2 A through a 3 Ω resistor for 5 s gives H = 2² × 3 × 5 = 60 J.")),

 dict(fig="F13_fuse_filament",
  heading=("पाठ 11: बल्ब और फ्यूज़ कैसे काम करते हैं", "Lesson 11: How a bulb and a fuse work"),
  explain=("❓ सोचो ज़रा: बल्ब का तंतु इतना गर्म होकर भी पिघलता क्यों नहीं, और फ्यूज़ का तार जल्दी क्यों पिघल जाता है?\n"
           "बल्ब: टंगस्टन का गलनांक बहुत ऊँचा (≈ 3380 °C) है, इसलिए वह सफ़ेद-गर्म होकर चमकता है पर पिघलता नहीं। बल्ब में निष्क्रिय गैस भरी होती है ताकि तंतु ऑक्सीकृत न हो।\n"
           "फ्यूज़: कम गलनांक वाला पतला तार, परिपथ में श्रेणीक्रम में। धारा रेटिंग से ऊपर जाए तो H = I²Rt से जल्दी गर्म होकर पिघलता है और परिपथ तोड़ देता है।\n"
           "रेटिंग चुनना: I = P/V निकालो और उससे थोड़ा ऊपर की रेटिंग लो।",
           "❓ Think: why does a bulb filament not melt even when white-hot, while a fuse wire melts easily?\n"
           "Bulb: tungsten has a very high melting point (≈ 3380 °C), so it glows white-hot without melting. The bulb holds an inert gas so the filament does not oxidise.\n"
           "Fuse: a thin wire of low melting point, in series in the circuit. If the current goes above the rating it heats up fast (H = I²Rt), melts, and breaks the circuit.\n"
           "Choosing the rating: find I = P/V and pick the next rating above it."),
  example=("समझो ऐसे: 2 kW, 230 V के गीज़र में I = 2000/230 ≈ 8.7 A। 5 A का फ्यूज़ बार-बार उड़ेगा, 10 A का सही है।",
           "Picture it: a 2 kW, 230 V geyser draws I = 2000/230 ≈ 8.7 A. A 5 A fuse would keep blowing; 10 A is right.")),

 dict(fig="F14_power_wheel",
  heading=("पाठ 12: विद्युत शक्ति: P = VI = I²R = V²/R", "Lesson 12: Electric power: P = VI = I²R = V²/R"),
  explain=("❓ सोचो ज़रा: 230 V के हीटर को 115 V पर चलाएँ तो शक्ति आधी होगी या उससे भी कम?\n"
           "शक्ति = ऊर्जा खर्च होने की दर: P = VI। V = IR रखने पर P = I²R = V²/R।\n"
           "हीटर का R स्थिर है, इसलिए P = V²/R से V आधा करने पर शक्ति एक-चौथाई हो जाती है, आधी नहीं।\n"
           "रेटिंग 1000 W, 230 V से R = 230²/1000 = 52.9 Ω निकलता है।",
           "❓ Think: run a 230 V heater on 115 V. Is the power halved, or less than that?\n"
           "Power = rate of using energy: P = VI. With V = IR, P = I²R = V²/R.\n"
           "The heater's R is fixed, so with P = V²/R halving V makes the power one quarter, not half.\n"
           "The rating 1000 W, 230 V gives R = 230²/1000 = 52.9 Ω."),
  example=("समझो ऐसे: 1000 W का हीटर 115 V पर: P = 115²/52.9 = 250 W, यानी 1000 W का एक-चौथाई।",
           "Picture it: the 1000 W heater on 115 V: P = 115²/52.9 = 250 W, one quarter of 1000 W.")),

 dict(fig="F8_bill",
  heading=("पाठ 13: बिजली का बिल: kWh यानी यूनिट", "Lesson 13: The electricity bill: kWh, the unit"),
  explain=("❓ सोचो ज़रा: गर्मियों में बिजली का बिल अचानक क्यों बढ़ जाता है?\n"
           "ऊर्जा = शक्ति × समय। बिल में ऊर्जा kWh (यूनिट) में गिनी जाती है: 1 kW का उपकरण 1 घंटा = 1 यूनिट = 3.6 × 10^6 J।\n"
           "तरीका: वाट को 1000 से भाग देकर kW बनाओ, घंटों और दिनों से गुणा करो, फिर दर से।\n"
           "1500 W का AC रोज़ 6 घंटे = 9 यूनिट, जबकि 10 W की LED रोज़ 6 घंटे = सिर्फ़ 0.06 यूनिट। इसलिए AC चलते ही बिल बढ़ता है।",
           "❓ Think: why does the electricity bill jump in summer?\n"
           "Energy = power × time. The bill counts energy in kWh (units): a 1 kW appliance for 1 hour = 1 unit = 3.6 × 10^6 J.\n"
           "Method: divide watts by 1000 to get kW, multiply by hours and days, then by the rate.\n"
           "A 1500 W AC for 6 hours a day = 9 units, while a 10 W LED for 6 hours = only 0.06 unit. That is why the bill jumps once the AC runs."),
  example=("समझो ऐसे: 1500 W का AC, रोज़ 6 घंटे, 30 दिन, ₹7/यूनिट → 1.5 × 6 × 30 = 270 यूनिट → 270 × 7 = ₹1,890।",
           "Picture it: a 1500 W AC, 6 hours a day, 30 days, ₹7 per unit → 1.5 × 6 × 30 = 270 units → 270 × 7 = ₹1,890.")),
]

# Teach "predict first, then reveal" beats (shown as step-reveal cards, placed before the existing solved list)
BEATS = [
 (("[पहले अंदाज़ा लगाओ] घर में दो बल्ब पूरे क्यों चमकते हैं? (a) श्रेणीक्रम में हैं (b) पार्श्वक्रम में हैं, हर बल्ब को पूरा वोल्टेज (c) फ़र्क नहीं पड़ता (d) फ्यूज़ के कारण",
   "[Predict first] Why do two bulbs at home both glow fully? (a) they are in series (b) they are in parallel, each gets the full voltage (c) it makes no difference (d) because of the fuse"),
  [("पार्श्वक्रम में हर बल्ब सीधे सप्लाई के दोनों सिरों से जुड़ा है।","In parallel each bulb connects straight across the supply."),
   ("इसलिए हर बल्ब पर पूरे 230 V।","So each bulb has the full 230 V."),
   ("एक बल्ब जोड़ने से दूसरे का वोल्टेज नहीं बदलता।","Adding one bulb does not change the other's voltage.")],
  ("(b) पार्श्वक्रम, हर बल्ब को पूरा वोल्टेज","(b) parallel, each gets the full voltage")),
 (("[पहले अंदाज़ा लगाओ] 6 V पर 2 Ω और 4 Ω श्रेणीक्रम में। 2 Ω से धारा? (a) 3 A (b) 1 A (c) 1.5 A (d) 4.5 A",
   "[Predict first] 2 Ω and 4 Ω in series on 6 V. How much current flows in the 2 Ω resistor? (a) 3 A (b) 1 A (c) 1.5 A (d) 4.5 A"),
  [("Rs = 2 + 4 = 6 Ω","Rs = 2 + 4 = 6 Ω"),("I = V/R = 6/6 = 1 A","I = V/R = 6/6 = 1 A"),
   ("श्रेणीक्रम में यही 1 A दोनों से गुज़रती है।","In series the same 1 A passes through both."),
   ("जाल: 3 A तब आता है जब 2 Ω पर पूरे 6 V मान लें।","Trap: 3 A comes from assuming the full 6 V across the 2 Ω.")],
  ("(b) 1 A","(b) 1 A")),
 (("[पहले अंदाज़ा लगाओ] उसी श्रेणी परिपथ में 2 Ω और 4 Ω पर वोल्टेज? (a) 3 V, 3 V (b) 2 V, 4 V (c) 4 V, 2 V (d) 6 V, 6 V",
   "[Predict first] In the same series circuit, voltage across 2 Ω and 4 Ω? (a) 3 V, 3 V (b) 2 V, 4 V (c) 4 V, 2 V (d) 6 V, 6 V"),
  [("V₁ = I × R₁ = 1 × 2 = 2 V","V₁ = I × R₁ = 1 × 2 = 2 V"),("V₂ = I × R₂ = 1 × 4 = 4 V","V₂ = I × R₂ = 1 × 4 = 4 V"),
   ("जाँच: 2 + 4 = 6 V, बैटरी के बराबर।","Check: 2 + 4 = 6 V, equal to the battery.")],
  ("(b) 2 V और 4 V","(b) 2 V and 4 V")),
 (("[पहले अंदाज़ा लगाओ] श्रेणीक्रम के दो बल्बों में से एक फ्यूज़ हो गया। दूसरा? (a) ज़्यादा चमकेगा (b) बुझ जाएगा (c) थोड़ा धीमा (d) कोई फ़र्क नहीं",
   "[Predict first] One of two bulbs in series fuses. The other? (a) glows brighter (b) goes off (c) slightly dimmer (d) no change"),
  [("श्रेणीक्रम में धारा का एक ही रास्ता है।","In series there is only one path."),("फ्यूज़ हुआ बल्ब = रास्ता टूटा।","A fused bulb = a broken path."),
   ("धारा शून्य, इसलिए दूसरा भी बुझ जाता है।","Current is zero, so the other goes off too.")],
  ("(b) बुझ जाएगा","(b) goes off")),
 (("[पहले अंदाज़ा लगाओ] 2 Ω और 4 Ω पार्श्वक्रम में। तुल्य प्रतिरोध? (a) 6 Ω (b) 3 Ω (c) 4/3 Ω (d) 8 Ω",
   "[Predict first] 2 Ω and 4 Ω in parallel. Equivalent resistance? (a) 6 Ω (b) 3 Ω (c) 4/3 Ω (d) 8 Ω"),
  [("तरीका A: 1/Rp = 1/2 + 1/4 = 3/4, Rp = 4/3 Ω","Method A: 1/Rp = 1/2 + 1/4 = 3/4, Rp = 4/3 Ω"),
   ("तरीका B: दो के लिए गुणा ÷ जोड़ = (2 × 4)/(2 + 4) = 8/6 = 4/3 Ω","Method B: for two, product ÷ sum = (2 × 4)/(2 + 4) = 8/6 = 4/3 Ω"),
   ("जाँच: 4/3 Ω सबसे छोटे (2 Ω) से भी कम है, जैसा पार्श्वक्रम में होना चाहिए।","Check: 4/3 Ω is below the smallest (2 Ω), as parallel requires.")],
  ("(c) 4/3 Ω ≈ 1.33 Ω","(c) 4/3 Ω ≈ 1.33 Ω")),
 (("[पहले अंदाज़ा लगाओ] 6 V पर 2 Ω और 4 Ω पार्श्वक्रम में। बैटरी से कुल धारा? (a) 1 A (b) 1.5 A (c) 3 A (d) 4.5 A",
   "[Predict first] 2 Ω and 4 Ω in parallel on 6 V. Total current from the battery? (a) 1 A (b) 1.5 A (c) 3 A (d) 4.5 A"),
  [("हर शाखा पर पूरे 6 V।","Each branch has the full 6 V."),("I₁ = 6/2 = 3 A, I₂ = 6/4 = 1.5 A","I₁ = 6/2 = 3 A, I₂ = 6/4 = 1.5 A"),
   ("कुल = 3 + 1.5 = 4.5 A। जाँच: 6 ÷ (4/3) = 4.5 A","Total = 3 + 1.5 = 4.5 A. Check: 6 ÷ (4/3) = 4.5 A")],
  ("(d) 4.5 A","(d) 4.5 A")),
 (("[पहले अंदाज़ा लगाओ] 60 W और 100 W के बल्ब 230 V पर श्रेणीक्रम में। कौन ज़्यादा चमकेगा? (a) 100 W (b) 60 W (c) बराबर (d) कोई नहीं",
   "[Predict first] A 60 W and a 100 W bulb in series on 230 V. Which glows more? (a) 100 W (b) 60 W (c) equal (d) neither"),
  [("R = V²/P: R₆₀ ≈ 882 Ω, R₁₀₀ = 529 Ω","R = V²/P: R₆₀ ≈ 882 Ω, R₁₀₀ = 529 Ω"),
   ("श्रेणी में धारा बराबर: I = 230 ÷ 1411 ≈ 0.163 A","Same current in series: I = 230 ÷ 1411 ≈ 0.163 A"),
   ("P = I²R: P₆₀ ≈ 23.4 W, P₁₀₀ ≈ 14.1 W","P = I²R: P₆₀ ≈ 23.4 W, P₁₀₀ ≈ 14.1 W"),
   ("बड़ा R यानी 60 W वाला ज़्यादा चमकता है।","The larger R, the 60 W bulb, glows more.")],
  ("(b) 60 W","(b) 60 W")),
 (("[पहले अंदाज़ा लगाओ] 2 Ω के बाद 4 Ω और 4 Ω पार्श्वक्रम में, 6 V पर। कुल धारा? (a) 0.6 A (b) 1 A (c) 1.5 A (d) 3 A",
   "[Predict first] 2 Ω followed by 4 Ω and 4 Ω in parallel, on 6 V. Total current? (a) 0.6 A (b) 1 A (c) 1.5 A (d) 3 A"),
  [("4 ∥ 4 = 4/2 = 2 Ω","4 ∥ 4 = 4/2 = 2 Ω"),("कुल R = 2 + 2 = 4 Ω","Total R = 2 + 2 = 4 Ω"),("I = 6/4 = 1.5 A","I = 6/4 = 1.5 A"),
   ("जाल: 0.6 A सबको श्रेणी में जोड़ने (10 Ω) से आता है।","Trap: 0.6 A comes from adding everything in series (10 Ω).")],
  ("(c) 1.5 A","(c) 1.5 A")),
 (("[पहले अंदाज़ा लगाओ] उसी प्रतिरोध में उतने ही समय धारा दुगुनी की। ऊष्मा? (a) वही (b) 2 गुना (c) 4 गुना (d) आधी",
   "[Predict first] Same resistor, same time, current doubled. Heat? (a) same (b) 2 times (c) 4 times (d) half"),
  [("H = I²Rt","H = I²Rt"),("नई ऊष्मा = (2I)²Rt = 4I²Rt","New heat = (2I)²Rt = 4I²Rt"),("तरीका B: 2² = 4 गुना","Method B: 2² = 4 times")],
  ("(c) 4 गुना","(c) 4 times")),
 (("[पहले अंदाज़ा लगाओ] 1500 W का AC रोज़ 6 घंटे, 30 दिन, ₹7/यूनिट। बिल? (a) ₹63 (b) ₹270 (c) ₹1,890 (d) ₹18,90,000",
   "[Predict first] A 1500 W AC, 6 h a day, 30 days, ₹7/unit. Bill? (a) ₹63 (b) ₹270 (c) ₹1,890 (d) ₹18,90,000"),
  [("P = 1500 W = 1.5 kW","P = 1500 W = 1.5 kW"),("रोज़: 1.5 × 6 = 9 यूनिट","Per day: 1.5 × 6 = 9 units"),
   ("30 दिन: 9 × 30 = 270 यूनिट","30 days: 9 × 30 = 270 units"),("बिल = 270 × 7 = ₹1,890","Bill = 270 × 7 = ₹1,890"),
   ("जाल: ₹18,90,000 W को kW न बनाने से आता है।","Trap: ₹18,90,000 comes from not converting W to kW.")],
  ("(c) ₹1,890","(c) ₹1,890")),
]

NEW_FORMULAS = [
 (("शक्ति (धारा और प्रतिरोध से)","Power (from current and resistance)"),"P = I^2 × R",("W (वाट)","W (watt)"),("जब I और R पता हों। श्रेणीक्रम में तुलना के लिए उपयोगी।","When I and R are known. Useful for comparing in series.")),
 (("शक्ति (वोल्टेज और प्रतिरोध से)","Power (from voltage and resistance)"),"P = V^2 / R",("W (वाट)","W (watt)"),("जब V और R पता हों। उपकरण की रेटिंग से R = V^2 / P।","When V and R are known. From a rating, R = V^2 / P.")),
 (("दो प्रतिरोध पार्श्वक्रम (शॉर्टकट)","Two resistors in parallel (shortcut)"),"Rp = (R1 × R2) / (R1 + R2)",("Ω (ओम)","Ω (ohm)"),("सिर्फ़ दो प्रतिरोधों के लिए। n बराबर R के लिए Rp = R / n।","Only for two resistors. For n equal R, Rp = R / n.")),
 (("इलेक्ट्रॉनों की संख्या","Number of electrons"),"n = Q / e",("संख्या (e = 1.6 × 10^-19 C)","a count (e = 1.6 × 10^-19 C)"),("आवेश से इलेक्ट्रॉन गिनने के लिए।","To count electrons from a charge.")),
 (("व्यावसायिक मात्रक","Commercial unit"),"1 kWh = 3.6 × 10^6 J",("kWh (यूनिट)","kWh (unit)"),("बिल में ऊर्जा यूनिट में गिनी जाती है।","The bill counts energy in units.")),
]
# better units/notes for the 9 existing formulas (same order as the app's list), keeping their titles and formulas
FORMULA_UNITS = [
 (("A (ऐम्पियर)","A (ampere)"),("Q कूलॉम में, t सेकंड में।","Q in coulombs, t in seconds.")),
 (("V (वोल्ट)","V (volt)"),("W जूल में, Q कूलॉम में। 1 V = 1 J/C।","W in joules, Q in coulombs. 1 V = 1 J/C.")),
 (("Ω (ओम)","Ω (ohm)"),("ताप स्थिर रहे तब। V-I ग्राफ का ढलान = R।","At constant temperature. Slope of the V-I graph = R.")),
 (("Ω m (ओम मीटर)","Ω m (ohm metre)"),("L मीटर में, A वर्ग मीटर में (1 mm² = 10^-6 m²)।","L in metres, A in square metres (1 mm² = 10^-6 m²).")),
 (("Ω (ओम)","Ω (ohm)"),("श्रेणीक्रम: धारा सब में बराबर।","Series: the same current in all.")),
 (("Ω (ओम)","Ω (ohm)"),("पार्श्वक्रम: वोल्टेज सब पर बराबर। अंत में व्युत्क्रम लेना न भूलें।","Parallel: the same voltage on all. Take the reciprocal at the end.")),
 (("J (जूल)","J (joule)"),("I दुगुना → H चार गुना।","I doubled → H four times.")),
 (("W (वाट)","W (watt)"),("P = VI = I^2 R = V^2 / R","P = VI = I^2 R = V^2 / R")),
 (("J या kWh","J or kWh"),("P वाट और t सेकंड → जूल; P kW और t घंटे → kWh।","P in W and t in s → joules; P in kW and t in h → kWh.")),
]

NEW_MISTAKES = [
 ("श्रेणीक्रम में 60 W और 100 W के बल्ब में 100 W को ज़्यादा चमकीला मानना। श्रेणी में धारा बराबर है, इसलिए बड़ा R (60 W) ज़्यादा चमकता है।",
  "Thinking the 100 W bulb is brighter when 60 W and 100 W are in series. The current is equal, so the larger R (60 W) glows more."),
 ("पार्श्वक्रम में प्रतिरोध जोड़ने पर कुल धारा घटना मान लेना। असल में कुल प्रतिरोध घटता है और कुल धारा बढ़ती है।",
  "Assuming that adding a resistor in parallel lowers the total current. In fact the total resistance falls and the total current rises."),
 ("H = VIt को गलत समझना। H = I²Rt = VIt = (V²/R)t तीनों सही हैं।",
  "Treating H = VIt as wrong. H = I²Rt = VIt = (V²/R)t are all correct."),
 ("स्थिर प्रतिरोध वाले उपकरण पर V दुगुना करने से शक्ति दुगुनी मानना। P = V²/R से यह 4 गुना होती है।",
  "Thinking doubling V doubles the power of a fixed-resistance appliance. By P = V²/R it becomes 4 times."),
 ("तार खींचकर दुगुना करने पर R दुगुना मानना। पतला भी होता है, इसलिए R चार गुना।",
  "Taking R as doubled when a wire is stretched to double length. It also gets thinner, so R becomes four times."),
]
NEW_REVISION = [
 ("SI परिभाषाएँ: 1 C = 1 A × 1 s; 1 V = 1 J/C; 1 Ω = 1 V/A; 1 W = 1 J/s = 1 V × 1 A; 1 kWh = 3.6 × 10^6 J।",
  "SI definitions: 1 C = 1 A × 1 s; 1 V = 1 J/C; 1 Ω = 1 V/A; 1 W = 1 J/s = 1 V × 1 A; 1 kWh = 3.6 × 10^6 J."),
 ("चमक का नियम: पार्श्वक्रम में ज़्यादा वाट ज़्यादा चमके; श्रेणीक्रम में कम वाट (बड़ा R) ज़्यादा चमके।",
  "Brightness rule: in parallel the higher watt glows more; in series the lower watt (larger R) glows more."),
 ("तार: खींचो n गुना → R × n²; आधा मोड़ो → R ÷ 4।", "Wire: stretch n times → R × n²; fold in half → R ÷ 4."),
]
NEW_PRACTICE = [
 (("एक तार को खींचकर तीन गुना लंबा किया गया (आयतन वही)। नया प्रतिरोध पुराने का कितना गुना?","A wire is stretched to three times its length (same volume). New resistance is how many times the old?"),
  [("3 गुना","3 times"),("6 गुना","6 times"),("9 गुना","9 times"),("1/3","1/3")],2,
  ("L तीन गुना और A एक-तिहाई, इसलिए R = 3 × 3 = 9 गुना।","L triples and A becomes one third, so R = 3 × 3 = 9 times.")),
 (("4 Ω के तीन बराबर प्रतिरोध पार्श्वक्रम में। तुल्य प्रतिरोध?","Three equal 4 Ω resistors in parallel. Equivalent resistance?"),
  [("12 Ω","12 Ω"),("4/3 Ω","4/3 Ω"),("3/4 Ω","3/4 Ω"),("4 Ω","4 Ω")],1,
  ("n बराबर R के लिए Rp = R/n = 4/3 Ω।","For n equal R, Rp = R/n = 4/3 Ω.")),
 (("1, 2 और 3 Ω के प्रतिरोधों से बन सकने वाला न्यूनतम प्रतिरोध?","The minimum resistance that can be made from 1, 2 and 3 Ω?"),
  [("6 Ω","6 Ω"),("6/11 Ω","6/11 Ω"),("11/6 Ω","11/6 Ω"),("1 Ω","1 Ω")],1,
  ("सब पार्श्वक्रम में: 1/R = 1 + 1/2 + 1/3 = 11/6, इसलिए R = 6/11 Ω।","All in parallel: 1/R = 1 + 1/2 + 1/3 = 11/6, so R = 6/11 Ω.")),
 (("100 W, 230 V वाले बल्ब का प्रतिरोध?","Resistance of a 100 W, 230 V bulb?"),
  [("2.3 Ω","2.3 Ω"),("23 Ω","23 Ω"),("529 Ω","529 Ω"),("23000 Ω","23000 Ω")],2,
  ("R = V²/P = 230 × 230 / 100 = 529 Ω।","R = V²/P = 230 × 230 / 100 = 529 Ω.")),
 (("कथन (A): घर के उपकरण पार्श्वक्रम में जुड़ते हैं। कारण (R): पार्श्वक्रम में हर उपकरण पर समान विभवांतर होता है।","Assertion (A): home appliances are connected in parallel. Reason (R): in parallel every appliance has the same potential difference."),
  [("A और R दोनों सही, R, A की सही व्याख्या है","Both A and R true, R explains A"),("A और R दोनों सही, पर R व्याख्या नहीं","Both true, but R does not explain A"),("A सही, R गलत","A true, R false"),("A गलत, R सही","A false, R true")],0,
  ("पार्श्वक्रम में हर उपकरण को पूरा 230 V मिलता है, यही कारण है।","In parallel each appliance gets the full 230 V; that is the reason.")),
 (("230 V पर 1 kW का प्रेस। सबसे उचित फ्यूज़?","A 1 kW iron on 230 V. Most suitable fuse?"),
  [("1 A","1 A"),("2 A","2 A"),("5 A","5 A"),("30 A","30 A")],2,
  ("I = 1000/230 ≈ 4.35 A, इसलिए थोड़ा ऊपर 5 A।","I = 1000/230 ≈ 4.35 A, so the next rating up, 5 A.")),
 (("2 C आवेश 0.5 s में प्रवाहित हो, तो धारा?","2 C of charge flows in 0.5 s. The current is?"),
  [("1 A","1 A"),("4 A","4 A"),("0.25 A","0.25 A"),("2.5 A","2.5 A")],1,
  ("I = Q/t = 2/0.5 = 4 A।","I = Q/t = 2/0.5 = 4 A.")),
 (("V-I ग्राफ (V, y-अक्ष पर) में तार A की रेखा तार B से अधिक खड़ी है। तो?","On a V-I graph (V on the y-axis) wire A's line is steeper than wire B's. So?"),
  [("A का प्रतिरोध अधिक","A has more resistance"),("B का प्रतिरोध अधिक","B has more resistance"),("दोनों बराबर","they are equal"),("कुछ नहीं कह सकते","cannot say")],0,
  ("V ऊपर होने पर ढलान = V/I = R, इसलिए अधिक खड़ी रेखा = अधिक R।","With V on the y-axis slope = V/I = R, so the steeper line has more R.")),
]
