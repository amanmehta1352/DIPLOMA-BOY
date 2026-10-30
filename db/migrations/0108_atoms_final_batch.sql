with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
    -- ═══ CLASS 6-8 BIO (908-918, 920) ═══
    (908, 'class_6_8', 'resp-68-concept', 'concept', 1, 'श्वसन — Class 6-8',
     $j${"text":"श्वसन (Respiration) का मतलब साँस लेना। जब हम साँस लेते हैं, हवा में से ऑक्सीजन (O₂) शरीर में जाती है और कार्बन डाइऑक्साइड (CO₂) बाहर निकलती है। यह काम फेफड़े (lungs) करते हैं। साँस लेना ज़रूरी है — बिना ऑक्सीजन के हम ज़िंदा नहीं रह सकते।","note":"साँस = O₂ अंदर, CO₂ बाहर · फेफड़े से होता है"}$j$),
    (908, 'class_6_8', 'resp-68-formula', 'formula', 2, 'श्वसन — सरल बात',
     $j${"formula":"O₂ अंदर → शरीर में → CO₂ बाहर","explanation":"फेफड़े में यह काम होता है"}$j$),
    (908, 'class_6_8', 'resp-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"साँस लेने से क्या मिलता है?","solution":"ऑक्सीजन (O₂)","answer":"ऑक्सीजन (O₂)"}$j$),
    (908, 'class_6_8', 'resp-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"साँस में क्या लेते हैं?","options":["CO₂","O₂","N₂","H₂O"],"answer":1,"explanation":"ऑक्सीजन (O₂)"},{"q":"साँस कौन सा अंग करता है?","options":["दिल","फेफड़े","पेट","दिमाग"],"answer":1,"explanation":"फेफड़े (lungs)"}]}$j$),

    (909, 'class_6_8', 'circ-68-concept', 'concept', 1, 'परिसंचरण — Class 6-8',
     $j${"text":"हमारे शरीर में खून (blood) लगातार दौड़ता रहता है — इसे परिसंचरण (Circulation) कहते हैं। दिल (heart) खून को पंप करता है। खून से शरीर के सभी हिस्सों में ऑक्सीजन और खाना पहुँचता है। दिल दिन-रात धड़कता रहता है — बिना रुके।","note":"दिल = खून का पंप · खून = ऑक्सीजन और खाना ले जाता"}$j$),
    (909, 'class_6_8', 'circ-68-formula', 'formula', 2, 'परिसंचरण — सरल बात',
     $j${"formula":"दिल → खून पंप → शरीर में ऑक्सीजन/खाना → वापस दिल","explanation":"दिल दिन-रात धड़कता है"}$j$),
    (909, 'class_6_8', 'circ-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"खून क्या पहुँचाता है?","solution":"ऑक्सीजन और पोषण","answer":"ऑक्सीजन + खाना"}$j$),
    (909, 'class_6_8', 'circ-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"खून कौन पंप करता है?","options":["फेफड़े","दिल","पेट","दिमाग"],"answer":1,"explanation":"दिल (heart)"},{"q":"दिल दिन में कितनी बार धड़कता है?","options":["10 बार","100 बार","~100000 बार","10 लाख"],"answer":2,"explanation":"~72×60×24 ≈ 1 लाख+ बार"}]}$j$),

    (910, 'class_6_8', 'trans-68-concept', 'concept', 1, 'पौधों में परिवहन — Class 6-8',
     $j${"text":"पौधे को भी पानी और खाना चाहिए। जड़ (root) पानी सोखती है, और तना (stem) उसे पत्ती तक पहुँचाता है। पत्ती में खाना बनता है, जो पौधे के सभी हिस्सों में जाता है। यह काम पौधे के अंदर छोटी-छोटी नलियों (vessels) से होता है।","note":"जड़ → पानी · तना → पहुँचाता · पत्ती → खाना बनाती"}$j$),
    (910, 'class_6_8', 'trans-68-formula', 'formula', 2, 'पौधों में परिवहन',
     $j${"formula":"जड़ → तना → पत्ती (पानी ऊपर जाता है)","explanation":"पत्ती में खाना बनता, फिर सब जगह जाता"}$j$),
    (910, 'class_6_8', 'trans-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"पौधे को पानी कहाँ से मिलता है?","solution":"जड़ (root) से","answer":"जड़ (root)"}$j$),
    (910, 'class_6_8', 'trans-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"पानी कहाँ से?","options":["तना","जड़","पत्ती","फूल"],"answer":1,"explanation":"जड़"},{"q":"खाना कहाँ बनता?","options":["जड़","तना","पत्ती","फूल"],"answer":2,"explanation":"पत्ती"}]}$j$),

    (911, 'class_6_8', 'exc-68-concept', 'concept', 1, 'उत्सर्जन — Class 6-8',
     $j${"text":"हमारा शरीर खाना खाता है, लेकिन कुछ चीज़ें बेकार हो जाती हैं — जैसे पेशाब (urine) और पसीना (sweat)। इन्हें बाहर निकालना ज़रूरी है — इसे उत्सर्जन (Excretion) कहते हैं। किडनी (kidney) पेशाब बनाती है, और त्वचा से पसीना निकलता है।","note":"उत्सर्जन = बेकार चीज़ें बाहर निकालना · किडनी + त्वचा"}$j$),
    (911, 'class_6_8', 'exc-68-formula', 'formula', 2, 'उत्सर्जन — सरल बात',
     $j${"formula":"किडनी → पेशाब · त्वचा → पसीना","explanation":"बेकार चीज़ें बाहर निकलना = उत्सर्जन"}$j$),
    (911, 'class_6_8', 'exc-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"पेशाब कहाँ बनती है?","solution":"किडनी (kidney) में","answer":"किडनी (kidney)"}$j$),
    (911, 'class_6_8', 'exc-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"पेशाब कहाँ बनती?","options":["दिल","किडनी","फेफड़े","दिमाग"],"answer":1,"explanation":"किडनी"},{"q":"पसीना किससे?","options":["त्वचा","दिल","किडनी","फेफड़े"],"answer":0,"explanation":"त्वचा से"}]}$j$),

    (912, 'class_6_8', 'nerve-68-concept', 'concept', 1, 'तंत्रिका — Class 6-8',
     $j${"text":"हमारा दिमाग (brain) शरीर का बॉस है — वो सोचता है, याद रखता है, और शरीर को चलाता है। दिमाग से तार जैसी चीज़ें (nerves) पूरे शरीर में जाती हैं — इन्हीं से हमें दर्द, गर्मी, ठंडक महसूस होती है। जब हम कुछ छूते हैं, message दिमाग तक जाता है — बहुत तेज़ी से।","note":"दिमाग + nerves = तंत्रिका तंत्र"}$j$),
    (912, 'class_6_8', 'nerve-68-formula', 'formula', 2, 'तंत्रिका — सरल बात',
     $j${"formula":"दिमाग (brain) + nerves = शरीर का control","explanation":"दर्द, गर्मी, ठंडक — सब nerves से महसूस होती"}$j$),
    (912, 'class_6_8', 'nerve-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"सोचना कहाँ होता है?","solution":"दिमाग (brain) में","answer":"दिमाग (brain)"}$j$),
    (912, 'class_6_8', 'nerve-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"शरीर का बॉस?","options":["दिल","दिमाग","पेट","फेफड़े"],"answer":1,"explanation":"दिमाग (brain)"},{"q":"दर्द कैसे महसूस?","options":["दिल","nerves","पेट","त्वचा"],"answer":1,"explanation":"nerves (तंत्रिकाएँ)"}]}$j$),

    (913, 'class_6_8', 'hormones-68-concept', 'concept', 1, 'हार्मोन — Class 6-8',
     $j${"text":"हार्मोन (Hormones) शरीर में छोटे रसायन होते हैं जो बताते हैं शरीर को क्या करना है। जैसे बढ़ने का हार्मोन (growth hormone) बच्चों को लंबा करता है, इंसुलिन (insulin) खून में शुगर कंट्रोल करता है। जब हम डरते हैं, तो अड्रेनालिन (adrenaline) निकलता है — दिल तेज़ धड़कता है।","note":"हार्मोन = शरीर के chemical messenger"}$j$),
    (913, 'class_6_8', 'hormones-68-formula', 'formula', 2, 'हार्मोन — सरल बात',
     $j${"formula":"हार्मोन = शरीर का message · growth hormone → लंबा · insulin → शुगर कंट्रोल","explanation":"डर में adrenaline → दिल तेज़"}$j$),
    (913, 'class_6_8', 'hormones-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"डर में कौन सा हार्मोन?","solution":"Adrenaline","answer":"Adrenaline (डर का हार्मोन)"}$j$),
    (913, 'class_6_8', 'hormones-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"बढ़ने का हार्मोन?","options":["Insulin","Growth hormone","Adrenaline","Thyroxine"],"answer":1,"explanation":"Growth hormone"},{"q":"डर में कौन?","options":["Insulin","Adrenaline","Growth","Thyroxine"],"answer":1,"explanation":"Adrenaline"}]}$j$),

    (914, 'class_6_8', 'skeletal-68-concept', 'concept', 1, 'कंकाल-पेशी — Class 6-8',
     $j${"text":"हमारे शरीर में 206 हड्डियाँ (bones) हैं। ये मिलकर कंकाल (skeleton) बनाती हैं। हड्डियाँ शरीर को सहारा देती हैं, अंगों को बचाती हैं (जैसे खोपड़ी दिमाग को)। मांसपेशियाँ (muscles) हड्डियों से जुड़ी होती हैं — इनसे हम हिलते-डुलते हैं।","note":"206 हड्डियाँ · हड्डी सहारा, मांसपेशी हिलाती"}$j$),
    (914, 'class_6_8', 'skeletal-68-formula', 'formula', 2, 'कंकाल — सरल बात',
     $j${"formula":"206 हड्डियाँ · कंकाल = शरीर का ढाँचा","explanation":"हड्डी + मांसपेशी = हिलना-डुलना"}$j$),
    (914, 'class_6_8', 'skeletal-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"कितनी हड्डियाँ?","solution":"206 (बड़े इंसान में)","answer":"206"}$j$),
    (914, 'class_6_8', 'skeletal-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"कितनी हड्डियाँ?","options":["100","206","300","500"],"answer":1,"explanation":"206"},{"q":"कंकाल का काम?","options":["सोचना","सहारा","पचाना","साँस"],"answer":1,"explanation":"शरीर को सहारा"}]}$j$),

    (915, 'class_6_8', 'repro-68-concept', 'concept', 1, 'जनन — Class 6-8',
     $j${"text":"जनन (Reproduction) का मतलब नए जीव पैदा करना। पौधे बीज (seeds) से बढ़ते हैं। जानवर बच्चे देते हैं या अंडे देते हैं। हर जीव अपनी तरह के नए जीव बनाता है — इसी से दुनिया में जीव चलते रहते हैं।","note":"जनन = नए जीव · पौधे बीज से, जानवर बच्चे/अंडे से"}$j$),
    (915, 'class_6_8', 'repro-68-formula', 'formula', 2, 'जनन — सरल बात',
     $j${"formula":"पौधे → बीज → नया पौधा · जानवर → बच्चा/अंडा","explanation":"हर जीव अपनी तरह का नया जीव बनाता"}$j$),
    (915, 'class_6_8', 'repro-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"पौधे किससे बढ़ते हैं?","solution":"बीज (seed) से","answer":"बीज (seed)"}$j$),
    (915, 'class_6_8', 'repro-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"पौधे किससे बढ़ते?","options":["पत्ती","बीज","जड़","तना"],"answer":1,"explanation":"बीज (seed)"},{"q":"मुर्गी क्या देती?","options":["बच्चा","अंडा","दूध","बीज"],"answer":1,"explanation":"अंडा (egg)"}]}$j$),

    (916, 'class_6_8', 'genetics-68-concept', 'concept', 1, 'आनुवंशिकी — Class 6-8',
     $j${"text":"बच्चे अपने माता-पिता से मिलते-जुलते होते हैं — आँखों का रंग, बाल, कद। यह आनुवंशिकता (Heredity) है। यह जानकारी माता-पिता से बच्चों तक genes के ज़रिए जाती है। genes हमारे शरीर में छोटे निर्देश (instructions) होते हैं।","note":"genes = माता-पिता से मिली जानकारी"}$j$),
    (916, 'class_6_8', 'genetics-68-formula', 'formula', 2, 'आनुवंशिकी — सरल बात',
     $j${"formula":"माता-पिता → genes → बच्चे","explanation":"बच्चे माता-पिता से मिलते-जुलते — genes से"}$j$),
    (916, 'class_6_8', 'genetics-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"बच्चे माता-पिता से क्यों मिलते?","solution":"genes (आनुवंशिकता) से","answer":"genes (heredity)"}$j$),
    (916, 'class_6_8', 'genetics-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"बच्चे किससे मिलते?","options":["पड़ोसी","माता-पिता","दोस्त","कोई नहीं"],"answer":1,"explanation":"माता-पिता (genes)"},{"q":"genes क्या हैं?","options":["हड्डी","जानकारी","खून","मांसपेशी"],"answer":1,"explanation":"जानकारी (instructions)"}]}$j$),

    (917, 'class_6_8', 'evol-68-concept', 'concept', 1, 'विकास — Class 6-8',
     $j${"text":"बहुत पहले धरती पर अलग तरह के जीव थे — जैसे डायनासोर। अब वो नहीं हैं। जीव धीरे-धीरे बदलते रहते हैं — इसे विकास (Evolution) कहते हैं। कुछ जीव बदलाव के हिसाब से खुद को ढाल लेते हैं, तो कुछ नहीं कर पाते और खत्म हो जाते हैं।","note":"विकास = समय के साथ जीवों में बदलाव"}$j$),
    (917, 'class_6_8', 'evol-68-formula', 'formula', 2, 'विकास — सरल बात',
     $j${"formula":"समय + बदलाव = विकास","explanation":"डायनासोर थे, अब नहीं — बदलाव (evolution)"}$j$),
    (917, 'class_6_8', 'evol-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"डायनासोर अब क्यों नहीं?","solution":"समय के साथ खत्म हो गए (विकास में)","answer":"विकास (evolution) का हिस्सा"}$j$),
    (917, 'class_6_8', 'evol-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"विकास का मतलब?","options":["बढ़ना","समय के साथ बदलाव","दौड़ना","सोना"],"answer":1,"explanation":"समय के साथ बदलाव"},{"q":"डायनासोर अब?","options":["हैं","नहीं हैं","कुछ हैं","सब हैं"],"answer":1,"explanation":"अब नहीं हैं"}]}$j$),

    (918, 'class_6_8', 'disease-68-concept', 'concept', 1, 'रोग-प्रतिरक्षा — Class 6-8',
     $j${"text":"कुछ चीज़ें हमें बीमार कर देती हैं — जैसे सर्दी, बुखार, खाँसी। ये बीमारियाँ कीटाणुओं (germs) से फैलती हैं — छींक, गंदा पानी, गंदा खाना। हाथ धोना, साफ पानी पीना, टीका (vaccine) लगवाना — इनसे बचाव होता है।","note":"साफ रहो, हाथ धोओ, टीका लगवाओ"}$j$),
    (918, 'class_6_8', 'disease-68-formula', 'formula', 2, 'रोग — सरल बात',
     $j${"formula":"गंदगी → कीटाणु → बीमारी","explanation":"साफ-सफाई = बचाव"}$j$),
    (918, 'class_6_8', 'disease-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"बीमारी से बचने के लिए?","solution":"साफ-सफाई + टीका","answer":"साफ-सफाई + टीका (vaccine)"}$j$),
    (918, 'class_6_8', 'disease-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"बीमारी किससे फैलती?","options":["हवा","कीटाणु","पानी","मिट्टी"],"answer":1,"explanation":"कीटाणुओं (germs) से"},{"q":"बचाव कैसे?","options":["गंदगी","साफ-सफाई","थकान","भूख"],"answer":1,"explanation":"साफ-सफाई"}]}$j$),

    (920, 'class_6_8', 'env-68-concept', 'concept', 1, 'पर्यावरण — Class 6-8',
     $j${"text":"हमारे चारों तरफ जो कुछ है — पेड़, पानी, हवा, जानवर — सब पर्यावरण (Environment) है। सब एक-दूसरे से जुड़े हैं। पेड़ हमें ऑक्सीजन देते हैं, पानी ज़रूरी है, जानवर भी ज़रूरी हैं। पेड़ मत काटो, पानी बचाओ, कचरा सही जगह डालो।","note":"पर्यावरण = हमारे चारों तरफ की दुनिया"}$j$),
    (920, 'class_6_8', 'env-68-formula', 'formula', 2, 'पर्यावरण — सरल बात',
     $j${"formula":"पेड़ + पानी + हवा + जानवर = पर्यावरण","explanation":"सब जुड़े हैं — सब ज़रूरी हैं"}$j$),
    (920, 'class_6_8', 'env-68-example', 'example', 3, 'सरल उदाहरण',
     $j${"question":"पेड़ क्या देते हैं?","solution":"ऑक्सीजन (O₂) + छाया + फल","answer":"ऑक्सीजन (O₂)"}$j$),
    (920, 'class_6_8', 'env-68-mcq', 'mcq', 4, 'Class 6-8 MCQs',
     $j${"questions":[{"q":"पेड़ क्या देते?","options":["CO₂","O₂","पानी","मिट्टी"],"answer":1,"explanation":"ऑक्सीजन (O₂)"},{"q":"पर्यावरण में क्या?","options":["सिर्फ पेड़","सिर्फ पानी","पेड़+पानी+हवा+जानवर","कुछ नहीं"],"answer":2,"explanation":"सब कुछ (पूरा ecosystem)"}]}$j$),

    -- ═══ GRADUATION_SCI (870-873) ═══
    (870, 'graduation_sci', 'meas-grad-concept', 'concept', 1, 'मापन — B.Sc/B.Tech',
     $j${"text":"Measurement at graduate level: SI units, dimensional analysis, error propagation (Taylor series), least-squares fitting. Instrumentation: oscilloscope, spectrometer, interferometer. Precision vs accuracy, systematic vs random errors. Gaussian error distribution. Significant figures rules।","note":"Graduate level: calculus-based error analysis और statistics।"}$j$),
    (870, 'graduation_sci', 'meas-grad-formula', 'formula', 2, 'मापन सूत्र',
     $j${"formula":"[Force] = MLT⁻² · σ_z = √[(∂z/∂x)²σ_x² + (∂z/∂y)²σ_y²] (error propagation)","explanation":"Least squares: minimize Σ(yᵢ - f(xᵢ))² · Gaussian: P(x) ∝ exp(-(x-μ)²/2σ²)"}$j$),
    (870, 'graduation_sci', 'meas-grad-example', 'example', 3, 'Graduate numerical',
     $j${"question":"z = x²y, x=2±0.1, y=3±0.2। σ_z?","solution":"σ_z = z√[(2σx/x)² + (σy/y)²] = 12√[(0.1)² + (0.067)²] = 12√0.0144","answer":"σ_z ≈ 1.44"}$j$),
    (870, 'graduation_sci', 'meas-grad-mcq', 'mcq', 4, 'Graduate MCQs',
     $j${"questions":[{"q":"Error propagation z=x²y में σ_z/z = ?","options":["σx/x + σy/y","2σx/x + σy/y","σx/2x + σy/y","√(σx²+σy²)"],"answer":1,"explanation":"Power rule: 2σx/x + σy/y"},{"q":"Gaussian distribution parameters?","options":["μ, σ","a, b","x, y","m, c"],"answer":0,"explanation":"μ (mean), σ (SD)"}]}$j$),

    (871, 'graduation_sci', 'motion-grad-concept', 'concept', 1, 'गति — B.Sc/B.Tech',
     $j${"text":"Motion: kinematics with calculus (v = dx/dt, a = dv/dt = v dv/dx)। Non-uniform acceleration। Rotational motion (angular kinematics, ω, α)। Central force motion, effective potential. Lagrangian approach (L = T - V)। Kepler problem। Rocket equation (variable mass)।","note":"Graduate level: calculus-based derivations, Lagrangian शुरू।"}$j$),
    (871, 'graduation_sci', 'motion-grad-formula', 'formula', 2, 'गति सूत्र',
     $j${"formula":"v = dx/dt · a = dv/dt · Rocket: m dv/dt = -u dm/dt · Lagrangian: L = T - V","explanation":"Centripetal: a_c = v²/r = rω² · Rocket velocity: v = u ln(m₀/m)"}$j$),
    (871, 'graduation_sci', 'motion-grad-example', 'example', 3, 'Graduate numerical',
     $j${"question":"Rocket m₀=1000, m=200, u=2000 m/s। v?","solution":"v = u ln(m₀/m) = 2000 × ln(5)","answer":"≈ 3219 m/s"}$j$),
    (871, 'graduation_sci', 'motion-grad-mcq', 'mcq', 4, 'Graduate MCQs',
     $j${"questions":[{"q":"a = ?","options":["dx/dt","dv/dt","d²x/dt²","Both 2 and 3"],"answer":3,"explanation":"a = dv/dt = d²x/dt²"},{"q":"Rocket equation derived from?","options":["Energy","Momentum","Angular momentum","Charge"],"answer":1,"explanation":"Momentum conservation"}]}$j$),

    (872, 'graduation_sci', 'force-grad-concept', 'concept', 1, 'बल — B.Sc/B.Tech',
     $j${"text":"Forces: conservative (gravity, spring — F = -∇V) vs non-conservative (friction)। Central force F(r) r̂ (planetary orbits)। Fictitious forces (centrifugal, Coriolis — rotating frames)। Euler-Lagrange for generalized forces। Rotational dynamics: torque τ = Iα, angular momentum L = Iω (conservation)। Rigid body motion।","note":"Graduate: vector calculus + Lagrangian mechanics।"}$j$),
    (872, 'graduation_sci', 'force-grad-formula', 'formula', 2, 'बल सूत्र',
     $j${"formula":"F = -∇V · F = dp/dt · τ = Iα · L = Iω (conserved if τ_net = 0)","explanation":"Lagrangian: d/dt(∂L/∂q̇) - ∂L/∂q = 0 · Coriolis: F = -2m ω×v"}$j$),
    (872, 'graduation_sci', 'force-grad-example', 'example', 3, 'Graduate numerical',
     $j${"question":"Moment of inertia disk (M=2, R=0.5)। I?","solution":"I = ½MR² = ½ × 2 × 0.25","answer":"0.25 kg·m²"}$j$),
    (872, 'graduation_sci', 'force-grad-mcq', 'mcq', 4, 'Graduate MCQs',
     $j${"questions":[{"q":"Conservative force?","options":["F = -∇V","F = -kx only","Friction","Air resistance"],"answer":0,"explanation":"F = -∇V (from potential)"},{"q":"L conserved when?","options":["τ_net = 0","F_net = 0","p = 0","E = 0"],"answer":0,"explanation":"Angular momentum conserved if net torque zero"}]}$j$),

    (873, 'graduation_sci', 'work-grad-concept', 'concept', 1, 'कार्य-ऊर्जा — B.Sc/B.Tech',
     $j${"text":"Work-energy theorem generalized: W = ∫F·dr = ΔKE। Potential energy surfaces (energy landscapes)। Hamiltonian H = T + V (conserved for time-independent system)। Thermodynamic work (PV)। Power P = dW/dt। Energy in relativity (E = mc², K = (γ-1)mc²)।","note":"Graduate: calculus-based work, Hamiltonian mechanics।"}$j$),
    (873, 'graduation_sci', 'work-grad-formula', 'formula', 2, 'कार्य-ऊर्जा सूत्र',
     $j${"formula":"W = ∫F·dr · KE = ½mv² · H = T + V (Hamiltonian) · E = mc²","explanation":"Relativistic KE: K = (γ-1)mc², γ = 1/√(1-v²/c²)"}$j$),
    (873, 'graduation_sci', 'work-grad-example', 'example', 3, 'Graduate numerical',
     $j${"question":"Spring k=100 N/m, x=0.1m। PE?","solution":"PE = ½kx² = ½ × 100 × 0.01","answer":"0.5 J"}$j$),
    (873, 'graduation_sci', 'work-grad-mcq', 'mcq', 4, 'Graduate MCQs',
     $j${"questions":[{"q":"Hamiltonian H = ?","options":["T - V","T + V","T×V","V - T"],"answer":1,"explanation":"H = T + V"},{"q":"Relativistic KE?","options":["½mv²","(γ-1)mc²","mc²","mv²"],"answer":1,"explanation":"K = (γ-1)mc²"}]}$j$),

    -- ═══ ADVANCED_RESEARCH (872-873) ═══
    (872, 'advanced_research', 'force-adv-concept', 'concept', 1, 'बल — GATE/NET/PhD',
     $j${"text":"Advanced mechanics: Lagrangian/Hamiltonian formulation (generalized coordinates)। Poisson brackets, canonical transformations। Noether's theorem (symmetry → conservation law)। Gauge theories (electromagnetic, Yang-Mills)। Four-force in relativity F^μ = dp^μ/dτ। Constraint dynamics (holonomic, non-holonomic)। Phase space, Liouville's theorem।","note":"Advanced: mathematical physics, field theory शुरुआत।"}$j$),
    (872, 'advanced_research', 'force-adv-formula', 'formula', 2, 'बल सूत्र',
     $j${"formula":"Euler-Lagrange: d/dt(∂L/∂q̇) - ∂L/∂q = 0 · Hamilton: q̇ = ∂H/∂p, ṗ = -∂H/∂q","explanation":"Noether: symmetry → conserved current · 4-force: F^μ = dp^μ/dτ"}$j$),
    (872, 'advanced_research', 'force-adv-example', 'example', 3, 'Advanced numerical',
     $j${"question":"Free particle Lagrangian?","solution":"L = T - V = ½mẋ² - 0 = ½mẋ²","answer":"L = ½mẋ²"}$j$),
    (872, 'advanced_research', 'force-adv-mcq', 'mcq', 4, 'Advanced MCQs',
     $j${"questions":[{"q":"Noether's theorem?","options":["Symmetry → conservation","Force → mass","Energy → work","Mass → charge"],"answer":0,"explanation":"Continuous symmetry → conserved quantity"},{"q":"Hamilton equations involve?","options":["(q, q̇)","(q, p)","(x, t)","(E, m)"],"answer":1,"explanation":"Phase space (q, p)"}]}$j$),

    (873, 'advanced_research', 'work-adv-concept', 'concept', 1, 'कार्य-ऊर्जा — GATE/NET/PhD',
     $j${"text":"Advanced: relativistic energy-momentum E² = (pc)² + (mc²)²। Four-momentum p^μ = (E/c, p⃗)। Stress-energy tensor T^μν (field theory)। Quantum: Hamiltonian operator H = -ħ²/2m ∇² + V। Action principle S = ∫L dt (extremum)। Path integral formulation (Feynman)।","note":"Advanced: relativity + quantum mechanics integration।"}$j$),
    (873, 'advanced_research', 'work-adv-formula', 'formula', 2, 'कार्य-ऊर्जा सूत्र',
     $j${"formula":"E² = (pc)² + (mc²)² · S = ∫L dt (action) · Quantum H = -ħ²/2m ∇² + V","explanation":"Action principle: δS = 0 → equations of motion · Path integral: ∫exp(iS/ħ) D[q]"}$j$),
    (873, 'advanced_research', 'work-adv-example', 'example', 3, 'Advanced numerical',
     $j${"question":"Electron v=0.8c। Total energy? (m=0.511 MeV/c²)","solution":"γ = 1/√(1-0.64) = 1/0.6 = 1.667। E = γmc² = 1.667 × 0.511","answer":"≈ 0.852 MeV"}$j$),
    (873, 'advanced_research', 'work-adv-mcq', 'mcq', 4, 'Advanced MCQs',
     $j${"questions":[{"q":"Energy-momentum relation?","options":["E = pc","E²=(pc)²+(mc²)²","E=mc²","E=½mv²"],"answer":1,"explanation":"Relativistic energy-momentum"},{"q":"Action principle?","options":["δS = 0","S = 0","δS = max","S constant"],"answer":0,"explanation":"δS = 0 (extremum)"}]}$j$),

    -- ═══ LAW_MANAGEMENT (17-18) ═══
    (17, 'law_management', 'series-law-concept', 'concept', 1, 'श्रृंखला — CLAT/CAT',
     $j${"text":"Series in logical reasoning: number series (arithmetic, geometric, mixed), letter series, alphabet position. CLAT/CAT में pattern recognition और quick elimination ज़रूरी। Data interpretation में trend analysis series से जुड़ा।","note":"CLAT/CAT: quick pattern recognition, elimination techniques।"}$j$),
    (17, 'law_management', 'series-law-formula', 'formula', 2, 'Series shortcuts',
     $j${"formula":"+n: 2,4,6 · ×n: 2,4,8 · Square: 1,4,9 · Cube: 1,8,27","explanation":"Letter: A=1 to Z=26 · Alternate: odd/even positions separate"}$j$),
    (17, 'law_management', 'series-law-example', 'example', 3, 'CLAT numerical',
     $j${"question":"2, 6, 12, 20, 30, ?","solution":"Differ: 4,6,8,10 → next 12। 30+12","answer":"42"}$j$),
    (17, 'law_management', 'series-law-mcq', 'mcq', 4, 'CLAT MCQs',
     $j${"questions":[{"q":"1, 4, 9, 16, 25, ?","options":["30","36","42","49"],"answer":1,"explanation":"6² = 36"},{"q":"3, 5, 9, 17, ?","solution":"Differ: 2,4,8 (×2) → next 16 → 33","options":["25","29","33","37"],"answer":2,"explanation":"Differences double"}]}$j$),

    (18, 'law_management', 'analogy-law-concept', 'concept', 1, 'सादृश्यता — CLAT/CAT',
     $j${"text":"Analogy in legal reasoning: relationship patterns (cause:effect, part:whole, principle:application)। Legal analogies: precedent reasoning, case similarity, statutory interpretation। CAT: word analogies, number analogies।","note":"Legal analogy = precedent + case reasoning।"}$j$),
    (18, 'law_management', 'analogy-law-formula', 'formula', 2, 'Analogy types',
     $j${"formula":"Cause:Effect · Part:Whole · Worker:Place · Principle:Application · Precedent:Case","explanation":"Number: n:n², n:n³ · Word: synonym/antonym"}$j$),
    (18, 'law_management', 'analogy-law-example', 'example', 3, 'CLAT numerical',
     $j${"question":"Lawyer:Court :: Judge:?","solution":"Judge का workplace = court (same place, different role)","answer":"Courtroom"}$j$),
    (18, 'law_management', 'analogy-law-mcq', 'mcq', 4, 'CLAT MCQs',
     $j${"questions":[{"q":"Statute:Law :: Verdict:?","options":["Judge","Judgment","Court","Lawyer"],"answer":1,"explanation":"Statute is part of law, verdict is part of judgment"},{"q":"3:27 :: 4:?","options":["16","27","64","81"],"answer":2,"explanation":"3³=27, 4³=64"}]}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, status, archived, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', 'published', false,
  '{}'::text[],
  case when s.level_id = 'class_6_8' then array['class_6','class_7','class_8']::text[] else '{}'::text[] end,
  case when s.level_id = 'class_6_8' then 'general-science'
       when s.level_id = 'law_management' then 'reasoning'
       else 'general-science' end,
  case when s.level_id = 'class_6_8' then 'easy'
       when s.level_id = 'advanced_research' then 'hard'
       else 'hard' end,
  md5(s.body::text)
from src s
on conflict do nothing;

-- VERIFY:
-- select level_id, count(*) from mtb.atoms 
-- where chapter_id in (908,909,910,911,912,913,914,915,916,917,918,920,870,871,872,873,17,18) 
--   and status='published' and not archived 
--   and level_id in ('class_6_8','graduation_sci','advanced_research','law_management')
-- group by level_id;
-- Expected: class_6_8 = 48 (12 × 4), graduation_sci = 16 (4 × 4), advanced_research = 8 (2 × 4), law_management = 8 (2 × 4)
-- Total: 80 new atoms

-- FINAL TOTAL:
-- select count(*) from mtb.atoms where status='published' and not archived;
-- Expected: ~3020 + 80 = ~3100

