// Every course, stage-wise (semester / year / class), subject by subject.
// Subject: [English, Hindi, kind?, map?, outline?]
//   kind: T theory (default) · E elective (theory, student picks one option) · L lab / practical · P project / internship
//   map:  'ch:433,439' exact chapter ids · 's:<subject>' whole subject · 's:<subject>:<unit>+<unit>' parts · '' none (locked)
//   outline: key in the outline catalog (default: slug of the English name). Theory and elective subjects must have one.
// Rules checked by the builder: a chapter id appears in at most ONE subject of a course (no book twice in two semesters),
// slugs are unique inside a stage, every theory / elective subject has a topic outline.
// Sources are the national model curricula; state boards / universities differ a little in names and order.

export const AICTE_DIP = 'AICTE model curriculum for diploma (2019/2022 revision) and NEP-aligned state schemes; state boards vary';
export const AICTE_UG = 'AICTE model curriculum for UG engineering (revised); universities vary';
const NCERT = 'NCERT / CBSE scheme of studies; state boards similar';
const UGC = 'UGC model curriculum (NEP-2020 framework); papers vary by university and combination';

// ---------- diploma (engineering) first year: same for every branch ----------
const DIP_Y1 = {
  '1': [['Mathematics-I', 'गणित-I'], ['Applied Physics-I', 'अनुप्रयुक्त भौतिकी-I'], ['Applied Chemistry', 'अनुप्रयुक्त रसायन'],
        ['Communication Skills in English', 'अंग्रेज़ी संचार कौशल'], ['Engineering Graphics', 'इंजीनियरिंग ग्राफ़िक्स', 'L'],
        ['Engineering Workshop Practice', 'इंजीनियरिंग वर्कशॉप अभ्यास', 'L'], ['Sports and Yoga', 'खेल और योग', 'L']],
  '2': [['Mathematics-II', 'गणित-II'], ['Applied Physics-II', 'अनुप्रयुक्त भौतिकी-II'], ['Introduction to IT Systems', 'आईटी सिस्टम का परिचय'],
        ['Fundamentals of Electrical & Electronics Engineering', 'विद्युत एवं इलेक्ट्रॉनिक्स इंजीनियरिंग के मूल सिद्धांत'],
        // AICTE: Engineering Mechanics is a common 2nd-semester subject of every engineering branch
        ['Engineering Mechanics', 'इंजीनियरिंग मैकेनिक्स', 'T', 'ch:433'], ['Environmental Science', 'पर्यावरण विज्ञान'],
        ['Engineering Workshop Practice-II', 'इंजीनियरिंग वर्कशॉप अभ्यास-II', 'L']],
};

export const C = {};
// Mechanical: every chapter of the mechanical subject appears exactly once, in the semester where it is taught.
C['diploma-mechanical'] = [AICTE_DIP, { ...DIP_Y1,
  '3': [['Strength of Materials', 'पदार्थों की सामर्थ्य', 'T', 'ch:439'],
        ['Thermal Engineering-I (Thermodynamics)', 'थर्मल इंजीनियरिंग-I (ऊष्मागतिकी)', 'T', 'ch:441'],
        ['Manufacturing Processes', 'विनिर्माण प्रक्रियाएँ', 'T', 'ch:436'],
        ['Engineering Materials & Metallurgy', 'इंजीनियरिंग सामग्री एवं धातुकर्म', 'T', 'ch:432'],
        ['Machine Drawing & CAD', 'मशीन ड्रॉइंग और CAD', 'L'], ['Basic Electrical & Electronics Lab', 'बेसिक इलेक्ट्रिकल एवं इलेक्ट्रॉनिक्स लैब', 'L']],
  '4': [['Theory of Machines', 'मशीनों का सिद्धांत', 'T', 'ch:440'],
        ['Fluid Mechanics & Hydraulic Machines', 'द्रव यांत्रिकी एवं हाइड्रॉलिक मशीनें', 'T', 'ch:434'],
        ['Thermal Engineering-II (Steam, Boilers, Turbines & Power Plants)', 'थर्मल इंजीनियरिंग-II (भाप, बॉयलर, टरबाइन और पावर प्लांट)', 'T', 'ch:438'],
        ['Production Technology (Machine Tools)', 'उत्पादन प्रौद्योगिकी (मशीन औज़ार)'],
        ['Metrology & Measurements', 'मापिकी और मापन', 'T', 'ch:1621'],
        ['Essence of Indian Knowledge & Tradition', 'भारतीय ज्ञान परंपरा का सार']],
  '5': [['Design of Machine Elements', 'मशीन अवयवों का डिज़ाइन', 'T', 'ch:1616'],
        ['Power Engineering (IC Engines, Air Compressors, Gas Turbines)', 'पावर इंजीनियरिंग (IC इंजन, वायु संपीडक, गैस टरबाइन)', 'T', 'ch:435,1618,1619'],
        ['Heat Transfer, Refrigeration & Air Conditioning', 'ऊष्मा-स्थानांतरण, प्रशीतन और वातानुकूलन', 'T', 'ch:1617,437'],
        ['Advanced Manufacturing Processes', 'उन्नत विनिर्माण प्रक्रियाएँ', 'T', 'ch:1622'],
        ['Elective-I: Automobile Engineering / Tool Engineering', 'ऐच्छिक-I: ऑटोमोबाइल इंजीनियरिंग / टूल इंजीनियरिंग', 'E'],
        ['Summer Internship', 'समर इंटर्नशिप', 'P']],
  '6': [['Industrial Engineering & Management', 'औद्योगिक अभियांत्रिकी एवं प्रबंधन', 'T', 'ch:1620'],
        ['CAD/CAM & Automation', 'CAD/CAM और ऑटोमेशन'],
        ['Maintenance & Plant Engineering', 'रखरखाव एवं संयंत्र इंजीनियरिंग'],
        ['Entrepreneurship & Start-ups', 'उद्यमिता और स्टार्ट-अप'],
        ['Elective-II: Mechatronics / Renewable Energy', 'ऐच्छिक-II: मेकाट्रॉनिक्स / नवीकरणीय ऊर्जा', 'E'],
        ['Major Project', 'मुख्य परियोजना', 'P'], ['Seminar', 'सेमिनार', 'P']]}];
C['diploma-automobile'] = [AICTE_DIP, { ...DIP_Y1,
  '3': [['Automobile Engines', 'ऑटोमोबाइल इंजन', 'T', 'ch:435'], ['Strength of Materials', 'पदार्थों की सामर्थ्य', 'T', 'ch:439'],
        ['Thermal Engineering (Thermodynamics)', 'थर्मल इंजीनियरिंग (ऊष्मागतिकी)', 'T', 'ch:441'], ['Manufacturing Processes', 'विनिर्माण प्रक्रियाएँ', 'T', 'ch:436'],
        ['Automobile Workshop Practice', 'ऑटोमोबाइल वर्कशॉप अभ्यास', 'L'], ['Machine Drawing & CAD', 'मशीन ड्रॉइंग और CAD', 'L']],
  '4': [['Automobile Chassis & Transmission', 'ऑटोमोबाइल चेसिस और ट्रांसमिशन'], ['Theory of Machines', 'मशीनों का सिद्धांत', 'T', 'ch:440'],
        ['Fluid Mechanics & Hydraulic Machines', 'द्रव यांत्रिकी एवं हाइड्रॉलिक मशीनें', 'T', 'ch:434'],
        ['Automobile Electrical & Electronics', 'ऑटोमोबाइल इलेक्ट्रिकल एवं इलेक्ट्रॉनिक्स'],
        ['Metrology & Measurements', 'मापिकी और मापन', 'T', 'ch:1621'], ['Engineering Materials & Metallurgy', 'इंजीनियरिंग सामग्री एवं धातुकर्म', 'T', 'ch:432']],
  '5': [['Vehicle Maintenance & Repair', 'वाहन रखरखाव और मरम्मत'], ['Design of Machine Elements', 'मशीन अवयवों का डिज़ाइन', 'T', 'ch:1616'],
        ['Two & Three Wheelers', 'दो और तीन पहिया वाहन'], ['Automotive Pollution & Control', 'वाहन प्रदूषण और नियंत्रण'],
        ['Elective-I: Vehicle Body Engineering / Tractors & Farm Equipment', 'ऐच्छिक-I: वाहन बॉडी इंजीनियरिंग / ट्रैक्टर एवं कृषि उपकरण', 'E'],
        ['Summer Internship', 'समर इंटर्नशिप', 'P']],
  '6': [['Industrial Management', 'औद्योगिक प्रबंधन', 'T', 'ch:1620'], ['Electric & Hybrid Vehicles', 'इलेक्ट्रिक और हाइब्रिड वाहन'],
        ['Automobile Air Conditioning', 'ऑटोमोबाइल वातानुकूलन', 'T', 'ch:437'], ['Alternative Fuels', 'वैकल्पिक ईंधन'],
        ['Transport Management & Motor Vehicle Act', 'परिवहन प्रबंधन और मोटर वाहन अधिनियम'],
        ['Major Project', 'मुख्य परियोजना', 'P']]}];
// Civil: the civil subject's 12 chapters, each in its own semester (they were never mapped before)
C['diploma-civil'] = [AICTE_DIP, { ...DIP_Y1,
  '3': [['Building Materials', 'भवन सामग्री', 'T', 'ch:401'], ['Building Construction', 'भवन निर्माण'],
        ['Surveying-I', 'सर्वेक्षण-I', 'T', 'ch:411'], ['Mechanics of Materials', 'पदार्थों की यांत्रिकी', 'T', 'ch:410'],
        ['Concrete Technology', 'कंक्रीट प्रौद्योगिकी', 'T', 'ch:402'], ['Hydraulics', 'हाइड्रॉलिक्स', 'T', 'ch:405'],
        ['Surveying Practice-I', 'सर्वेक्षण अभ्यास-I', 'L']],
  '4': [['Surveying-II', 'सर्वेक्षण-II'], ['Theory of Structures', 'संरचनाओं का सिद्धांत'],
        ['Highway Engineering', 'राजमार्ग इंजीनियरिंग', 'T', 'ch:412'], ['Irrigation Engineering', 'सिंचाई इंजीनियरिंग', 'T', 'ch:406'],
        ['Soil Mechanics & Foundation', 'मृदा यांत्रिकी और नींव', 'T', 'ch:408'],
        ['Building Planning & Drawing', 'भवन योजना और ड्रॉइंग', 'L'], ['Surveying Practice-II', 'सर्वेक्षण अभ्यास-II', 'L']],
  '5': [['Design of RCC Structures', 'RCC संरचनाओं का डिज़ाइन', 'T', 'ch:407'], ['Estimating & Costing', 'आकलन और लागत', 'T', 'ch:404'],
        ['Water Supply & Sanitary Engineering', 'जल आपूर्ति और स्वच्छता इंजीनियरिंग', 'T', 'ch:403'],
        ['Railway, Bridge & Tunnel Engineering', 'रेलवे, पुल और सुरंग इंजीनियरिंग'],
        ['Elective-I: Earthquake Resistant Construction / Green Building', 'ऐच्छिक-I: भूकंपरोधी निर्माण / ग्रीन बिल्डिंग', 'E'],
        ['Advanced Surveying (Total Station, GPS)', 'उन्नत सर्वेक्षण (टोटल स्टेशन, GPS)', 'L'], ['Summer Internship', 'समर इंटर्नशिप', 'P']],
  '6': [['Design of Steel Structures', 'स्टील संरचनाओं का डिज़ाइन', 'T', 'ch:409'], ['Construction Management', 'निर्माण प्रबंधन'],
        ['Quantity Surveying & Valuation', 'मात्रा सर्वेक्षण और मूल्यांकन'], ['Advanced Construction Technology', 'उन्नत निर्माण प्रौद्योगिकी'],
        ['Elective-II: Repair & Rehabilitation of Structures / Solid Waste Management', 'ऐच्छिक-II: संरचनाओं की मरम्मत एवं पुनर्वास / ठोस अपशिष्ट प्रबंधन', 'E'],
        ['Major Project', 'मुख्य परियोजना', 'P']]}];
// Electrical: the electrical subject's 6 chapters (never mapped before)
C['diploma-electrical'] = [AICTE_DIP, { ...DIP_Y1,
  '3': [['Electrical Circuits', 'विद्युत परिपथ', 'T', 'ch:442'], ['Electrical & Electronic Measurements', 'विद्युत एवं इलेक्ट्रॉनिक मापन', 'T', 'ch:445'],
        ['Electrical Power Generation', 'विद्युत शक्ति उत्पादन'], ['Basic Electronics', 'बेसिक इलेक्ट्रॉनिक्स', 'T', 'ch:443'],
        ['Electrical Engineering Materials', 'विद्युत इंजीनियरिंग सामग्री'], ['Electrical Workshop', 'इलेक्ट्रिकल वर्कशॉप', 'L']],
  '4': [['Electrical Machines-I (DC Machines & Transformers)', 'विद्युत मशीनें-I (DC मशीन और ट्रांसफ़ॉर्मर)', 'T', 'ch:444'],
        ['Transmission & Distribution', 'संचरण और वितरण', 'T', 'ch:446'], ['Digital Electronics', 'डिजिटल इलेक्ट्रॉनिक्स'],
        ['Power Electronics', 'पावर इलेक्ट्रॉनिक्स'], ['Electrical Drawing & CAD', 'इलेक्ट्रिकल ड्रॉइंग और CAD', 'L']],
  '5': [['Electrical Machines-II (AC Machines)', 'विद्युत मशीनें-II (AC मशीनें)'], ['Switchgear & Protection', 'स्विचगियर और सुरक्षा'],
        ['Utilisation of Electrical Energy', 'विद्युत ऊर्जा का उपयोग'], ['Microcontrollers & PLC', 'माइक्रोकंट्रोलर और PLC'],
        ['Industrial Drives', 'औद्योगिक ड्राइव'], ['Summer Internship', 'समर इंटर्नशिप', 'P']],
  '6': [['Electrical Installation, Estimating & Costing', 'विद्युत संस्थापन, आकलन और लागत', 'T', 'ch:447'],
        ['Renewable Energy & Energy Conservation', 'नवीकरणीय ऊर्जा और ऊर्जा संरक्षण'],
        ['Electric Traction & Electric Vehicles', 'विद्युत कर्षण और इलेक्ट्रिक वाहन'],
        ['Elective: Control Systems / Industrial Automation & SCADA', 'ऐच्छिक: नियंत्रण प्रणाली / औद्योगिक ऑटोमेशन एवं SCADA', 'E'],
        ['Entrepreneurship & Start-ups', 'उद्यमिता और स्टार्ट-अप'], ['Major Project', 'मुख्य परियोजना', 'P']]}];
C['diploma-electronics'] = [AICTE_DIP, { ...DIP_Y1,
  '3': [['Electronic Devices & Circuits', 'इलेक्ट्रॉनिक उपकरण और परिपथ'], ['Digital Electronics', 'डिजिटल इलेक्ट्रॉनिक्स'],
        ['Electric Circuits & Networks', 'विद्युत परिपथ और नेटवर्क'], ['Electronic Measurements & Instrumentation', 'इलेक्ट्रॉनिक मापन और उपकरण'],
        ['Principles of Electronic Communication', 'इलेक्ट्रॉनिक संचार के सिद्धांत'], ['Electronics Workshop', 'इलेक्ट्रॉनिक्स वर्कशॉप', 'L']],
  '4': [['Linear Integrated Circuits', 'रैखिक एकीकृत परिपथ'], ['Microcontrollers', 'माइक्रोकंट्रोलर'], ['Analog Communication', 'एनालॉग संचार'],
        ['Consumer Electronics', 'उपभोक्ता इलेक्ट्रॉनिक्स'], ['Electronic Circuit Design & Simulation', 'इलेक्ट्रॉनिक परिपथ डिज़ाइन और सिमुलेशन', 'L']],
  '5': [['Digital Communication', 'डिजिटल संचार'], ['Embedded Systems', 'एम्बेडेड सिस्टम'], ['Optical Fibre Communication', 'ऑप्टिकल फ़ाइबर संचार'],
        ['Industrial Electronics', 'औद्योगिक इलेक्ट्रॉनिक्स'], ['Microwave & Radar', 'माइक्रोवेव और रडार'], ['Summer Internship', 'समर इंटर्नशिप', 'P']],
  '6': [['Mobile & Wireless Communication', 'मोबाइल और वायरलेस संचार'], ['Computer Networks', 'कंप्यूटर नेटवर्क'],
        ['Basics of VLSI', 'VLSI के मूल सिद्धांत'], ['Elective: Internet of Things / Biomedical Electronics', 'ऐच्छिक: इंटरनेट ऑफ़ थिंग्स / बायोमेडिकल इलेक्ट्रॉनिक्स', 'E'],
        ['Entrepreneurship & Start-ups', 'उद्यमिता और स्टार्ट-अप'], ['Major Project', 'मुख्य परियोजना', 'P']]}];
C['diploma-computer'] = [AICTE_DIP, { ...DIP_Y1,
  '3': [['Data Structures', 'डेटा संरचना'], ['Object Oriented Programming with C++', 'C++ के साथ ऑब्जेक्ट ओरिएंटेड प्रोग्रामिंग'],
        ['Digital Electronics', 'डिजिटल इलेक्ट्रॉनिक्स'], ['Database Management Systems', 'डेटाबेस प्रबंधन प्रणाली'],
        ['Computer System Organisation', 'कंप्यूटर सिस्टम संगठन'], ['Programming Lab (C++ & DBMS)', 'प्रोग्रामिंग लैब (C++ एवं DBMS)', 'L']],
  '4': [['Java Programming', 'जावा प्रोग्रामिंग'], ['Operating Systems', 'ऑपरेटिंग सिस्टम'], ['Computer Networks', 'कंप्यूटर नेटवर्क'],
        ['Software Engineering', 'सॉफ़्टवेयर इंजीनियरिंग'], ['Web Technologies', 'वेब तकनीकें', 'L']],
  '5': [['Python Programming', 'पायथन प्रोग्रामिंग'], ['Advanced Web Development', 'उन्नत वेब विकास'], ['Cloud Computing', 'क्लाउड कंप्यूटिंग'],
        ['Information Security', 'सूचना सुरक्षा'], ['Summer Internship', 'समर इंटर्नशिप', 'P']],
  '6': [['Mobile Application Development', 'मोबाइल ऐप विकास'], ['Basics of AI & Machine Learning', 'AI और मशीन लर्निंग के मूल सिद्धांत'],
        ['Network Security', 'नेटवर्क सुरक्षा'], ['Elective: Internet of Things / Data Analytics', 'ऐच्छिक: इंटरनेट ऑफ़ थिंग्स / डेटा एनालिटिक्स', 'E'],
        ['Entrepreneurship & Start-ups', 'उद्यमिता और स्टार्ट-अप'], ['Major Project', 'मुख्य परियोजना', 'P']]}];

// ---------- health / teaching diplomas ----------
C['diploma-pharmacy'] = ['PCI Education Regulations 2020 (D.Pharm)', {
  '1': [['Pharmaceutics', 'फ़ार्मास्युटिक्स'], ['Pharmaceutical Chemistry', 'फ़ार्मास्युटिकल रसायन'], ['Pharmacognosy', 'फ़ार्माकोग्नॉसी'],
        ['Human Anatomy & Physiology', 'मानव शरीर रचना एवं क्रिया विज्ञान'], ['Social Pharmacy', 'सामाजिक फ़ार्मेसी'],
        ['First-year Practicals', 'प्रथम वर्ष प्रायोगिक', 'L']],
  '2': [['Pharmacology', 'फ़ार्माकोलॉजी'], ['Community Pharmacy & Management', 'सामुदायिक फ़ार्मेसी एवं प्रबंधन'],
        ['Biochemistry & Clinical Pathology', 'जैव रसायन एवं क्लिनिकल पैथोलॉजी'], ['Pharmacotherapeutics', 'फ़ार्माकोथेरेप्यूटिक्स'],
        ['Hospital & Clinical Pharmacy', 'अस्पताल एवं क्लिनिकल फ़ार्मेसी'], ['Pharmacy Law & Ethics', 'फ़ार्मेसी कानून एवं नैतिकता'],
        ['Practical Training (500 hours)', 'व्यावहारिक प्रशिक्षण (500 घंटे)', 'P']]}];
C['diploma-nursing'] = ['Indian Nursing Council GNM syllabus', {
  '1': [['Biological Sciences (Anatomy, Physiology, Microbiology)', 'जैविक विज्ञान (शरीर रचना, क्रिया विज्ञान, सूक्ष्मजीव विज्ञान)'],
        ['Behavioural Sciences (Psychology, Sociology)', 'व्यवहार विज्ञान (मनोविज्ञान, समाजशास्त्र)'], ['Fundamentals of Nursing', 'नर्सिंग के मूल सिद्धांत'],
        ['Community Health Nursing-I', 'सामुदायिक स्वास्थ्य नर्सिंग-I'], ['English', 'अंग्रेज़ी', 'T', '', 'nursing-english'],
        ['Computer Education', 'कंप्यूटर शिक्षा'], ['Clinical Practice-I', 'क्लिनिकल अभ्यास-I', 'L']],
  '2': [['Medical Surgical Nursing-I', 'मेडिकल सर्जिकल नर्सिंग-I'], ['Medical Surgical Nursing-II', 'मेडिकल सर्जिकल नर्सिंग-II'],
        ['Mental Health Nursing', 'मानसिक स्वास्थ्य नर्सिंग'], ['Child Health Nursing', 'बाल स्वास्थ्य नर्सिंग'], ['Clinical Practice-II', 'क्लिनिकल अभ्यास-II', 'L']],
  '3': [['Midwifery & Gynaecological Nursing', 'मिडवाइफ़री एवं स्त्री रोग नर्सिंग'], ['Community Health Nursing-II', 'सामुदायिक स्वास्थ्य नर्सिंग-II'],
        ['Nursing Education', 'नर्सिंग शिक्षा'], ['Introduction to Research & Statistics', 'शोध एवं सांख्यिकी का परिचय'],
        ['Professional Trends & Adjustment', 'व्यावसायिक प्रवृत्तियाँ एवं समायोजन'], ['Nursing Administration & Ward Management', 'नर्सिंग प्रशासन एवं वार्ड प्रबंधन'],
        ['Internship (Integrated Practice)', 'इंटर्नशिप (एकीकृत अभ्यास)', 'P']]}];
C['diploma-deled'] = ['NCTE D.El.Ed framework (NIOS / state SCERT schemes)', {
  '1': [['Childhood & Development of Children', 'बचपन और बच्चों का विकास', 'T', 's:child-development-pedagogy'], ['Contemporary Indian Society', 'समकालीन भारतीय समाज'],
        ['Education in India: Status, Problems & Issues', 'भारत में शिक्षा: स्थिति, समस्याएँ और मुद्दे'], ['Language Proficiency (Hindi / English)', 'भाषा दक्षता (हिंदी / अंग्रेज़ी)'],
        ['Pedagogy of Mathematics (Primary)', 'गणित का शिक्षणशास्त्र (प्राथमिक)'], ['Pedagogy of Environmental Studies', 'पर्यावरण अध्ययन का शिक्षणशास्त्र'],
        ['Understanding ICT in Education', 'शिक्षा में ICT की समझ']],
  '2': [['Cognition, Learning & the Socio-Cultural Context', 'संज्ञान, अधिगम और सामाजिक-सांस्कृतिक संदर्भ'], ['School Culture, Leadership & Change', 'विद्यालय संस्कृति, नेतृत्व और परिवर्तन'],
        ['Pedagogy of Language', 'भाषा का शिक्षणशास्त्र'], ['Pedagogy of Science / Social Science (Upper Primary)', 'विज्ञान / सामाजिक विज्ञान का शिक्षणशास्त्र (उच्च प्राथमिक)'],
        ['Diversity, Gender & Inclusive Education', 'विविधता, जेंडर और समावेशी शिक्षा'], ['School Internship', 'विद्यालय इंटर्नशिप', 'P']]}];

// ---------- ITI ----------
const iti = (en, hi, ok, part) => [
  [`Trade Theory${part} (${en})`, `ट्रेड थ्योरी${part} (${hi})`, 'T', 's:trade-theory', ok],
  [`Trade Practical${part} (${en})`, `ट्रेड प्रैक्टिकल${part} (${hi})`, 'L'],
  ['Workshop Calculation & Science', 'वर्कशॉप गणना एवं विज्ञान', 'T', '', 'iti-workshop-calculation-science' + (part ? '-ii' : '')],
  ['Engineering Drawing', 'इंजीनियरिंग ड्रॉइंग', 'L'],
  ['Employability Skills', 'रोज़गार कौशल', 'T', '', 'iti-employability-skills' + (part ? '-ii' : '')]];
C['iti-mechanical'] = ['NCVT / DGT CTS syllabus (Fitter, Turner, Machinist, Welder, Mechanic Diesel / Motor Vehicle)', {
  '1': iti('Fitter / Mechanical trades', 'फ़िटर / मैकेनिकल ट्रेड', 'iti-mech-trade-theory-1', ''),
  '2': iti('Fitter / Mechanical trades', 'फ़िटर / मैकेनिकल ट्रेड', 'iti-mech-trade-theory-2', ' - II')}];
C['iti-electrical'] = ['NCVT / DGT CTS syllabus (Electrician, Wireman, Electronics Mechanic)', {
  '1': iti('Electrician / Electrical trades', 'इलेक्ट्रीशियन / इलेक्ट्रिकल ट्रेड', 'iti-elec-trade-theory-1', ''),
  '2': iti('Electrician / Electrical trades', 'इलेक्ट्रीशियन / इलेक्ट्रिकल ट्रेड', 'iti-elec-trade-theory-2', ' - II')}];
C['iti-copa'] = ['NCVT / DGT CTS syllabus (COPA, 1 year)', {
  '1': [['Trade Theory (COPA)', 'ट्रेड थ्योरी (कोपा)', 'T', 's:trade-theory', 'iti-copa-trade-theory'],
        ['Trade Practical (COPA: Office tools, Internet, Programming basics)', 'ट्रेड प्रैक्टिकल (कोपा: ऑफ़िस टूल, इंटरनेट, प्रोग्रामिंग)', 'L'],
        ['Computer Fundamentals', 'कंप्यूटर के मूल सिद्धांत', 'T', 's:computer-basics'],
        ['Employability Skills', 'रोज़गार कौशल', 'T', '', 'iti-employability-skills']]}];

// ---------- school (outline key = class + subject: the same name means different chapters in each class) ----------
const school = (c, extra) => [['Mathematics', 'गणित', 'T', '', `c${c}-maths`], ['Science', 'विज्ञान', 'T', '', `c${c}-science`],
  ['Social Science (History, Geography, Political Science, Economics)', 'सामाजिक विज्ञान (इतिहास, भूगोल, राजनीति विज्ञान, अर्थशास्त्र)', 'T', '', `c${c}-social-science`],
  ['Hindi', 'हिंदी', 'T', '', `c${c}-hindi`], ['English', 'अंग्रेज़ी', 'T', '', `c${c}-english`], ...extra(c)];
for (const c of ['6', '7', '8']) C['class-' + c] = [NCERT, { all: school(c, k => [['Sanskrit / Third Language', 'संस्कृत / तृतीय भाषा', 'T', '', `c${k}-sanskrit`],
  ['Art, Health & Physical Education', 'कला, स्वास्थ्य एवं शारीरिक शिक्षा', 'L']]) }];
for (const c of ['9', '10']) C['class-' + c] = [NCERT, { all: school(c, k => [['Information Technology / Skill subject (optional)', 'सूचना प्रौद्योगिकी / कौशल विषय (ऐच्छिक)', 'E', '', `c${k}-it`],
  ['Health & Physical Education', 'स्वास्थ्य एवं शारीरिक शिक्षा', 'L']]) }];
const sci = c => [['Physics', 'भौतिकी', 'T', '', `c${c}-physics`], ['Chemistry', 'रसायन विज्ञान', 'T', '', `c${c}-chemistry`]];
C['class-11-12-pcm'] = [NCERT, Object.fromEntries(['11', '12'].map(c => [c, [...sci(c), ['Mathematics', 'गणित', 'T', '', `c${c}-maths`],
  ['English (Core)', 'अंग्रेज़ी (कोर)', 'T', '', `c${c}-english`], ['Optional: Computer Science / Physical Education', 'ऐच्छिक: कंप्यूटर साइंस / शारीरिक शिक्षा', 'E', '', `c${c}-cs-pe`],
  ['Physics & Chemistry Practicals', 'भौतिकी और रसायन प्रायोगिक', 'L']]]))];
C['class-11-12-pcb'] = [NCERT, Object.fromEntries(['11', '12'].map(c => [c, [...sci(c), ['Biology', 'जीव विज्ञान', 'T', '', `c${c}-biology`],
  ['English (Core)', 'अंग्रेज़ी (कोर)', 'T', '', `c${c}-english`], ['Optional: Mathematics / Psychology / Physical Education', 'ऐच्छिक: गणित / मनोविज्ञान / शारीरिक शिक्षा', 'E', '', `c${c}-maths`],
  ['Physics, Chemistry & Biology Practicals', 'भौतिकी, रसायन और जीव विज्ञान प्रायोगिक', 'L']]]))];
C['class-11-12-commerce'] = [NCERT, Object.fromEntries(['11', '12'].map(c => [c, [['Accountancy', 'लेखाशास्त्र', 'T', 's:accountancy', `c${c}-accountancy`],
  ['Business Studies', 'व्यवसाय अध्ययन', 'T', 's:business-studies', `c${c}-business-studies`], ['Economics', 'अर्थशास्त्र', 'T', 's:economics-com', `c${c}-economics`],
  ['Mathematics / Applied Mathematics', 'गणित / अनुप्रयुक्त गणित', 'T', 's:maths-com', `c${c}-applied-maths`], ['English (Core)', 'अंग्रेज़ी (कोर)', 'T', '', `c${c}-english`],
  ['Optional: Informatics Practices / Physical Education', 'ऐच्छिक: इन्फ़ॉर्मेटिक्स प्रैक्टिसेज़ / शारीरिक शिक्षा', 'E', '', `c${c}-ip`]]]))];
C['class-11-12-arts'] = [NCERT, Object.fromEntries(['11', '12'].map(c => [c, [['History', 'इतिहास', 'T', 's:history', `c${c}-history`],
  ['Political Science', 'राजनीति विज्ञान', 'T', 's:political-science', `c${c}-political-science`], ['Geography', 'भूगोल', 'T', 's:geography-arts', `c${c}-geography`],
  ['Sociology', 'समाजशास्त्र', 'T', 's:sociology', `c${c}-sociology`], ['Psychology', 'मनोविज्ञान', 'T', 's:psychology', `c${c}-psychology`],
  ['Economics', 'अर्थशास्त्र', 'T', '', `c${c}-economics`], ['Hindi', 'हिंदी', 'T', '', `c${c}-hindi`], ['English (Core)', 'अंग्रेज़ी (कोर)', 'T', '', `c${c}-english`]]]))];

// ---------- B.Tech (year-wise) ----------
const BT_Y1 = [['Engineering Physics', 'इंजीनियरिंग भौतिकी'], ['Engineering Chemistry', 'इंजीनियरिंग रसायन'],
  ['Mathematics-I (Calculus & Linear Algebra)', 'गणित-I (कलन एवं रैखिक बीजगणित)'], ['Mathematics-II (Differential Equations & Complex Variables)', 'गणित-II (अवकल समीकरण एवं सम्मिश्र चर)'],
  ['Basic Electrical Engineering', 'बेसिक इलेक्ट्रिकल इंजीनियरिंग'], ['Programming for Problem Solving', 'समस्या समाधान के लिए प्रोग्रामिंग'],
  ['Engineering Graphics & Design', 'इंजीनियरिंग ग्राफ़िक्स एवं डिज़ाइन', 'L'], ['Workshop / Manufacturing Practices', 'वर्कशॉप / विनिर्माण अभ्यास', 'L'], ['English', 'अंग्रेज़ी', 'T', '', 'btech-english']];
C['btech-mechanical'] = [AICTE_UG, { '1': BT_Y1,
  '2': [['Engineering Mechanics', 'इंजीनियरिंग मैकेनिक्स', 'T', 'ch:433'], ['Thermodynamics', 'ऊष्मागतिकी', 'T', 'ch:441'], ['Strength of Materials', 'पदार्थों की सामर्थ्य', 'T', 'ch:439'],
        ['Fluid Mechanics & Machines', 'द्रव यांत्रिकी एवं मशीनें', 'T', 'ch:434'], ['Engineering Materials', 'इंजीनियरिंग सामग्री', 'T', 'ch:432'],
        ['Manufacturing Processes', 'विनिर्माण प्रक्रियाएँ', 'T', 'ch:436'], ['Mathematics-III (PDE, Probability & Statistics)', 'गणित-III (आंशिक अवकल समीकरण, प्रायिकता एवं सांख्यिकी)'],
        ['Basic Electronics', 'बेसिक इलेक्ट्रॉनिक्स', 'T', '', 'btech-basic-electronics']],
  '3': [['Applied Thermodynamics (IC Engines, Compressors, Gas Turbines)', 'अनुप्रयुक्त ऊष्मागतिकी (IC इंजन, संपीडक, गैस टरबाइन)', 'T', 'ch:435,1618,1619'],
        ['Heat Transfer', 'ऊष्मा-स्थानांतरण', 'T', 'ch:1617'], ['Kinematics & Dynamics of Machines', 'मशीनों की शुद्धगतिकी एवं गतिकी', 'T', 'ch:440'],
        ['Design of Machine Elements', 'मशीन अवयवों का डिज़ाइन', 'T', 'ch:1616'], ['Manufacturing Technology (Machining)', 'विनिर्माण प्रौद्योगिकी (मशीनिंग)'],
        ['Metrology & Measurements', 'मापिकी और मापन', 'T', 'ch:1621'], ['Industrial Engineering & Operations Management', 'औद्योगिक अभियांत्रिकी एवं संचालन प्रबंधन', 'T', 'ch:1620']],
  '4': [['Refrigeration & Air Conditioning', 'प्रशीतन और वातानुकूलन', 'T', 'ch:437'], ['Power Plant Engineering', 'पावर प्लांट इंजीनियरिंग', 'T', 'ch:438'],
        ['Advanced Manufacturing & CAD/CAM', 'उन्नत विनिर्माण एवं CAD/CAM', 'T', 'ch:1622'], ['Finite Element Analysis', 'परिमित अवयव विश्लेषण'],
        ['Elective: Automobile Engineering / Robotics', 'ऐच्छिक: ऑटोमोबाइल इंजीनियरिंग / रोबोटिक्स', 'E'], ['Project', 'परियोजना', 'P']]}];
C['btech-civil'] = [AICTE_UG, { '1': BT_Y1,
  '2': [['Mechanics of Solids', 'ठोसों की यांत्रिकी', 'T', 'ch:410'], ['Fluid Mechanics', 'द्रव यांत्रिकी', 'T', 'ch:405', 'civil-fluid-mechanics'],
        ['Surveying & Geomatics', 'सर्वेक्षण एवं जियोमैटिक्स', 'T', 'ch:411'], ['Building Materials & Construction', 'भवन सामग्री एवं निर्माण', 'T', 'ch:401'],
        ['Engineering Geology', 'इंजीनियरिंग भूविज्ञान'], ['Concrete Technology', 'कंक्रीट प्रौद्योगिकी', 'T', 'ch:402'], ['Mathematics-III', 'गणित-III']],
  '3': [['Structural Analysis', 'संरचनात्मक विश्लेषण'], ['Geotechnical Engineering', 'भू-तकनीकी इंजीनियरिंग', 'T', 'ch:408'],
        ['Design of RCC Structures', 'RCC संरचनाओं का डिज़ाइन', 'T', 'ch:407'], ['Transportation Engineering', 'परिवहन इंजीनियरिंग', 'T', 'ch:412'],
        ['Hydrology & Water Resources Engineering', 'जल विज्ञान एवं जल संसाधन इंजीनियरिंग', 'T', 'ch:406'], ['Environmental Engineering', 'पर्यावरण इंजीनियरिंग', 'T', 'ch:403']],
  '4': [['Design of Steel Structures', 'स्टील संरचनाओं का डिज़ाइन', 'T', 'ch:409'], ['Estimation, Costing & Valuation', 'आकलन, लागत एवं मूल्यांकन', 'T', 'ch:404'],
        ['Construction Management', 'निर्माण प्रबंधन'], ['Foundation Engineering', 'नींव इंजीनियरिंग'],
        ['Elective: Earthquake Engineering / Bridge Engineering', 'ऐच्छिक: भूकंप इंजीनियरिंग / पुल इंजीनियरिंग', 'E'], ['Project', 'परियोजना', 'P']]}];
C['btech-electrical'] = [AICTE_UG, { '1': BT_Y1,
  '2': [['Electrical Circuit Analysis', 'विद्युत परिपथ विश्लेषण', 'T', 'ch:442'], ['Analog Electronic Circuits', 'एनालॉग इलेक्ट्रॉनिक परिपथ', 'T', 'ch:443'],
        ['Electrical Machines-I', 'विद्युत मशीनें-I', 'T', 'ch:444'], ['Electromagnetic Fields', 'विद्युत-चुंबकीय क्षेत्र'], ['Digital Electronics', 'डिजिटल इलेक्ट्रॉनिक्स'],
        ['Signals & Systems', 'सिग्नल एवं सिस्टम'], ['Mathematics-III', 'गणित-III']],
  '3': [['Electrical Machines-II', 'विद्युत मशीनें-II', 'T', '', 'electrical-machines-ii-ac-machines'], ['Power Systems-I', 'पावर सिस्टम-I', 'T', 'ch:446'], ['Control Systems', 'नियंत्रण प्रणाली'],
        ['Power Electronics', 'पावर इलेक्ट्रॉनिक्स'], ['Measurements & Instrumentation', 'मापन एवं उपकरण', 'T', 'ch:445'],
        ['Microprocessors & Microcontrollers', 'माइक्रोप्रोसेसर एवं माइक्रोकंट्रोलर']],
  '4': [['Power System Protection & Switchgear', 'पावर सिस्टम सुरक्षा एवं स्विचगियर'], ['Electric Drives', 'विद्युत ड्राइव'],
        ['Utilisation of Electrical Energy & Estimation', 'विद्युत ऊर्जा का उपयोग एवं आकलन', 'T', 'ch:447'], ['High Voltage Engineering', 'उच्च वोल्टेज इंजीनियरिंग'],
        ['Renewable Energy Systems', 'नवीकरणीय ऊर्जा प्रणाली'], ['Elective: HVDC & FACTS / Smart Grid', 'ऐच्छिक: HVDC एवं FACTS / स्मार्ट ग्रिड', 'E'], ['Project', 'परियोजना', 'P']]}];
C['btech-electronics'] = [AICTE_UG, { '1': BT_Y1,
  '2': [['Electronic Devices', 'इलेक्ट्रॉनिक उपकरण'], ['Digital System Design', 'डिजिटल सिस्टम डिज़ाइन'], ['Signals & Systems', 'सिग्नल एवं सिस्टम'],
        ['Network Theory', 'नेटवर्क सिद्धांत'], ['Analog Circuits', 'एनालॉग परिपथ'], ['Mathematics-III', 'गणित-III']],
  '3': [['Analog & Digital Communication', 'एनालॉग एवं डिजिटल संचार'], ['Microprocessors & Microcontrollers', 'माइक्रोप्रोसेसर एवं माइक्रोकंट्रोलर'],
        ['Electromagnetic Waves', 'विद्युत-चुंबकीय तरंगें'], ['Control Systems', 'नियंत्रण प्रणाली'], ['Digital Signal Processing', 'डिजिटल सिग्नल प्रोसेसिंग'],
        ['Computer Architecture', 'कंप्यूटर आर्किटेक्चर']],
  '4': [['VLSI Design', 'VLSI डिज़ाइन'], ['Wireless Communication', 'वायरलेस संचार'], ['Optical Communication', 'ऑप्टिकल संचार'], ['Embedded Systems', 'एम्बेडेड सिस्टम'],
        ['Elective: Internet of Things / Machine Learning for Signals', 'ऐच्छिक: इंटरनेट ऑफ़ थिंग्स / सिग्नल हेतु मशीन लर्निंग', 'E'], ['Project', 'परियोजना', 'P']]}];
C['btech-computer'] = [AICTE_UG, { '1': BT_Y1,
  '2': [['Data Structures & Algorithms', 'डेटा संरचना एवं एल्गोरिदम'], ['Discrete Mathematics', 'असतत गणित'], ['Digital Electronics', 'डिजिटल इलेक्ट्रॉनिक्स'],
        ['Computer Organisation & Architecture', 'कंप्यूटर संगठन एवं आर्किटेक्चर'], ['Object Oriented Programming', 'ऑब्जेक्ट ओरिएंटेड प्रोग्रामिंग'],
        ['Database Management Systems', 'डेटाबेस प्रबंधन प्रणाली']],
  '3': [['Operating Systems', 'ऑपरेटिंग सिस्टम'], ['Design & Analysis of Algorithms', 'एल्गोरिदम का डिज़ाइन एवं विश्लेषण'], ['Computer Networks', 'कंप्यूटर नेटवर्क'],
        ['Theory of Computation', 'संगणना का सिद्धांत'], ['Software Engineering', 'सॉफ़्टवेयर इंजीनियरिंग'], ['Compiler Design', 'कंपाइलर डिज़ाइन']],
  '4': [['Artificial Intelligence & Machine Learning', 'कृत्रिम बुद्धिमत्ता एवं मशीन लर्निंग'], ['Cloud Computing', 'क्लाउड कंप्यूटिंग'], ['Information Security', 'सूचना सुरक्षा'],
        ['Distributed Systems', 'वितरित प्रणाली'], ['Elective: Data Science / Blockchain', 'ऐच्छिक: डेटा साइंस / ब्लॉकचेन', 'E'], ['Project', 'परियोजना', 'P']]}];

// ---------- general degrees ----------
C['bsc'] = [UGC, {
  '1': [['Physics: Mechanics, Electricity & Magnetism', 'भौतिकी: यांत्रिकी, विद्युत एवं चुंबकत्व'], ['Chemistry: Inorganic & Organic Basics', 'रसायन: अकार्बनिक एवं कार्बनिक मूल'],
        ['Mathematics: Calculus & Algebra (PCM)', 'गणित: कलन एवं बीजगणित (PCM)'], ['Botany & Zoology: Diversity of Life (ZBC)', 'वनस्पति एवं प्राणी विज्ञान: जीवन की विविधता (ZBC)'],
        ['Environmental Studies', 'पर्यावरण अध्ययन'], ['Language: English / Hindi', 'भाषा: अंग्रेज़ी / हिंदी', 'T', '', 'ug-language'], ['Science Practicals-I', 'विज्ञान प्रायोगिक-I', 'L']],
  '2': [['Physics: Thermal Physics, Waves & Optics', 'भौतिकी: ऊष्मीय भौतिकी, तरंगें एवं प्रकाशिकी'], ['Chemistry: Physical Chemistry & Organic Reactions', 'रसायन: भौतिक रसायन एवं कार्बनिक अभिक्रियाएँ'],
        ['Mathematics: Differential Equations & Real Analysis (PCM)', 'गणित: अवकल समीकरण एवं वास्तविक विश्लेषण (PCM)'],
        ['Botany & Zoology: Physiology & Genetics (ZBC)', 'वनस्पति एवं प्राणी विज्ञान: शरीर क्रिया एवं आनुवंशिकी (ZBC)'],
        ['Skill Enhancement Course', 'कौशल संवर्धन पाठ्यक्रम', 'E', '', 'ug-skill-enhancement'], ['Science Practicals-II', 'विज्ञान प्रायोगिक-II', 'L']],
  '3': [['Physics: Modern Physics, Electronics & Quantum Mechanics', 'भौतिकी: आधुनिक भौतिकी, इलेक्ट्रॉनिक्स एवं क्वांटम यांत्रिकी'],
        ['Chemistry: Spectroscopy, Coordination & Industrial Chemistry', 'रसायन: स्पेक्ट्रोस्कोपी, उपसहसंयोजन एवं औद्योगिक रसायन'],
        ['Mathematics: Abstract Algebra, Complex Analysis & Numerical Methods (PCM)', 'गणित: अमूर्त बीजगणित, सम्मिश्र विश्लेषण एवं संख्यात्मक विधियाँ (PCM)'],
        ['Botany & Zoology: Ecology, Evolution & Biotechnology (ZBC)', 'वनस्पति एवं प्राणी विज्ञान: पारिस्थितिकी, विकास एवं जैव प्रौद्योगिकी (ZBC)'],
        ['Project / Dissertation', 'परियोजना / लघु शोध', 'P']]}];
C['bcom'] = [UGC, {
  '1': [['Financial Accounting', 'वित्तीय लेखांकन', 'T', 's:advanced-accountancy'], ['Business Organisation & Management', 'व्यावसायिक संगठन एवं प्रबंधन'],
        ['Business Law', 'व्यावसायिक विधि', 'T', 's:business-law'], ['Business Economics (Micro)', 'व्यावसायिक अर्थशास्त्र (व्यष्टि)'],
        ['Business Communication', 'व्यावसायिक संचार'], ['Environmental Studies', 'पर्यावरण अध्ययन']],
  '2': [['Corporate Accounting', 'निगमीय लेखांकन'], ['Income Tax Law & Practice', 'आयकर विधि एवं व्यवहार'], ['Cost Accounting', 'लागत लेखांकन', 'T', 's:cost-accounting'],
        ['Company Law', 'कंपनी विधि'], ['Business Statistics', 'व्यावसायिक सांख्यिकी'], ['Macro Economics', 'समष्टि अर्थशास्त्र']],
  '3': [['Auditing & Corporate Governance', 'अंकेक्षण एवं निगमीय शासन'], ['Management Accounting', 'प्रबंधन लेखांकन'], ['Goods & Services Tax', 'वस्तु एवं सेवा कर (GST)'],
        ['Financial Management', 'वित्तीय प्रबंधन'], ['Banking & Insurance', 'बैंकिंग एवं बीमा'], ['Entrepreneurship', 'उद्यमिता', 'T', '', 'entrepreneurship-start-ups']]}];
C['ba'] = [UGC, {
  '1': [['History: Ancient India', 'इतिहास: प्राचीन भारत', 'T', 's:advanced-history'], ['Political Science: Political Theory', 'राजनीति विज्ञान: राजनीतिक सिद्धांत', 'T', 's:advanced-polity'],
        ['Geography: Physical Geography', 'भूगोल: भौतिक भूगोल', 'T', 's:advanced-geography'], ['Language: Hindi / English', 'भाषा: हिंदी / अंग्रेज़ी', 'T', '', 'ug-language'],
        ['Environmental Studies', 'पर्यावरण अध्ययन']],
  '2': [['History: Medieval India', 'इतिहास: मध्यकालीन भारत', 'T', 's:advanced-history'], ['Political Science: Indian Government & Politics', 'राजनीति विज्ञान: भारतीय शासन एवं राजनीति', 'T', 's:advanced-polity'],
        ['Geography: Human & Economic Geography', 'भूगोल: मानव एवं आर्थिक भूगोल', 'T', 's:advanced-geography'], ['Skill Enhancement Course', 'कौशल संवर्धन पाठ्यक्रम', 'E', '', 'ug-skill-enhancement']],
  '3': [['History: Modern India & World History', 'इतिहास: आधुनिक भारत एवं विश्व इतिहास', 'T', 's:advanced-history'],
        ['Political Science: International Relations & Public Administration', 'राजनीति विज्ञान: अंतरराष्ट्रीय संबंध एवं लोक प्रशासन', 'T', 's:advanced-polity'],
        ['Geography: Geography of India & Practical', 'भूगोल: भारत का भूगोल एवं प्रायोगिक', 'T', 's:advanced-geography'], ['Project / Dissertation', 'परियोजना / लघु शोध', 'P']]}];
C['bed'] = ['NCTE B.Ed curriculum framework (2-year)', {
  '1': [['Childhood & Growing Up', 'बचपन और विकास', 'T', 's:child-development-pedagogy'], ['Contemporary India & Education', 'समकालीन भारत और शिक्षा'], ['Learning & Teaching', 'अधिगम और शिक्षण'],
        ['Language across the Curriculum', 'पाठ्यक्रम में भाषा'], ['Understanding Disciplines & Subjects', 'विषयों की समझ'], ['Pedagogy of a School Subject-I', 'विद्यालय विषय का शिक्षणशास्त्र-I'],
        ['Reading & Reflecting on Texts', 'पाठ पढ़ना और चिंतन', 'L'], ['Drama & Art in Education', 'शिक्षा में नाटक और कला', 'L']],
  '2': [['Knowledge & Curriculum', 'ज्ञान और पाठ्यक्रम'], ['Assessment for Learning', 'अधिगम के लिए आकलन'], ['Creating an Inclusive School', 'समावेशी विद्यालय का निर्माण'],
        ['Gender, School & Society', 'जेंडर, विद्यालय और समाज'], ['Pedagogy of a School Subject-II', 'विद्यालय विषय का शिक्षणशास्त्र-II'], ['Critical Understanding of ICT', 'ICT की आलोचनात्मक समझ', 'L'],
        ['Understanding the Self', 'स्व की समझ', 'L'], ['School Internship', 'विद्यालय इंटर्नशिप', 'P']]}];
C['bsc-nursing'] = ['Indian Nursing Council B.Sc Nursing syllabus (2021)', {
  '1': [['Communicative English', 'संप्रेषणात्मक अंग्रेज़ी'], ['Applied Anatomy', 'अनुप्रयुक्त शरीर रचना'], ['Applied Physiology', 'अनुप्रयुक्त शरीर क्रिया विज्ञान'],
        ['Applied Sociology', 'अनुप्रयुक्त समाजशास्त्र'], ['Applied Psychology', 'अनुप्रयुक्त मनोविज्ञान'], ['Nursing Foundation', 'नर्सिंग फ़ाउंडेशन'],
        ['Applied Biochemistry', 'अनुप्रयुक्त जैव रसायन'], ['Applied Nutrition & Dietetics', 'अनुप्रयुक्त पोषण एवं आहार विज्ञान'],
        ['Health / Nursing Informatics & Technology', 'स्वास्थ्य / नर्सिंग सूचना विज्ञान एवं तकनीक']],
  '2': [['Applied Microbiology & Infection Control', 'अनुप्रयुक्त सूक्ष्मजीव विज्ञान एवं संक्रमण नियंत्रण'], ['Pharmacology', 'फ़ार्माकोलॉजी', 'T', '', 'nursing-pharmacology'],
        ['Pathology & Genetics', 'पैथोलॉजी एवं आनुवंशिकी'], ['Adult Health (Medical Surgical) Nursing-I', 'वयस्क स्वास्थ्य (मेडिकल सर्जिकल) नर्सिंग-I'],
        ['Community Health Nursing-I', 'सामुदायिक स्वास्थ्य नर्सिंग-I'], ['Educational Technology / Nursing Education', 'शैक्षिक तकनीक / नर्सिंग शिक्षा', 'T', '', 'nursing-education']],
  '3': [['Adult Health (Medical Surgical) Nursing-II', 'वयस्क स्वास्थ्य (मेडिकल सर्जिकल) नर्सिंग-II'], ['Child Health Nursing', 'बाल स्वास्थ्य नर्सिंग'],
        ['Mental Health Nursing', 'मानसिक स्वास्थ्य नर्सिंग'], ['Professionalism, Ethics & Law', 'व्यावसायिकता, नैतिकता एवं कानून'],
        ['Nursing Research & Statistics', 'नर्सिंग शोध एवं सांख्यिकी', 'T', '', 'introduction-to-research-statistics'],
        ['Midwifery / Obstetrics & Gynaecology Nursing-I', 'मिडवाइफ़री / प्रसूति एवं स्त्री रोग नर्सिंग-I']],
  '4': [['Community Health Nursing-II', 'सामुदायिक स्वास्थ्य नर्सिंग-II'], ['Nursing Management & Leadership', 'नर्सिंग प्रबंधन एवं नेतृत्व', 'T', '', 'nursing-administration-ward-management'],
        ['Midwifery / Obstetrics & Gynaecology Nursing-II', 'मिडवाइफ़री / प्रसूति एवं स्त्री रोग नर्सिंग-II'], ['Internship', 'इंटर्नशिप', 'P']]}];
C['bpharm'] = ['PCI B.Pharm course regulations (2014, 8 semesters)', {
  '1': [['Human Anatomy & Physiology I & II', 'मानव शरीर रचना एवं क्रिया विज्ञान I एवं II'], ['Pharmaceutical Analysis I', 'फ़ार्मास्युटिकल विश्लेषण I'],
        ['Pharmaceutics I', 'फ़ार्मास्युटिक्स I'], ['Pharmaceutical Inorganic Chemistry', 'फ़ार्मास्युटिकल अकार्बनिक रसायन'],
        ['Pharmaceutical Organic Chemistry I', 'फ़ार्मास्युटिकल कार्बनिक रसायन I'], ['Biochemistry', 'जैव रसायन', 'T', '', 'pharm-biochemistry'], ['Pathophysiology', 'पैथोफ़िज़ियोलॉजी'],
        ['Computer Applications in Pharmacy', 'फ़ार्मेसी में कंप्यूटर अनुप्रयोग'], ['Environmental Sciences', 'पर्यावरण विज्ञान', 'T', '', 'environmental-studies'],
        ['Communication Skills', 'संचार कौशल', 'T', '', 'communication-skills-in-english']],
  '2': [['Pharmaceutical Organic Chemistry II & III', 'फ़ार्मास्युटिकल कार्बनिक रसायन II एवं III'], ['Physical Pharmaceutics I & II', 'भौतिक फ़ार्मास्युटिक्स I एवं II'],
        ['Pharmaceutical Microbiology', 'फ़ार्मास्युटिकल सूक्ष्मजीव विज्ञान'], ['Pharmaceutical Engineering', 'फ़ार्मास्युटिकल इंजीनियरिंग'],
        ['Medicinal Chemistry I', 'औषधीय रसायन I'], ['Pharmacology I', 'फ़ार्माकोलॉजी I'], ['Pharmacognosy & Phytochemistry I', 'फ़ार्माकोग्नॉसी एवं फ़ाइटोकेमिस्ट्री I']],
  '3': [['Medicinal Chemistry II & III', 'औषधीय रसायन II एवं III'], ['Industrial Pharmacy I & II', 'औद्योगिक फ़ार्मेसी I एवं II'], ['Pharmacology II & III', 'फ़ार्माकोलॉजी II एवं III'],
        ['Pharmacognosy & Phytochemistry II', 'फ़ार्माकोग्नॉसी एवं फ़ाइटोकेमिस्ट्री II'], ['Pharmaceutical Jurisprudence', 'फ़ार्मास्युटिकल विधिशास्त्र'],
        ['Herbal Drug Technology', 'हर्बल औषधि प्रौद्योगिकी'], ['Biopharmaceutics & Pharmacokinetics', 'बायोफ़ार्मास्युटिक्स एवं फ़ार्माकोकाइनेटिक्स'],
        ['Pharmaceutical Biotechnology', 'फ़ार्मास्युटिकल जैव प्रौद्योगिकी'], ['Quality Assurance', 'गुणवत्ता आश्वासन']],
  '4': [['Instrumental Methods of Analysis', 'विश्लेषण की उपकरणीय विधियाँ'], ['Novel Drug Delivery Systems', 'नवीन औषधि वितरण प्रणाली'], ['Pharmacy Practice', 'फ़ार्मेसी प्रैक्टिस'],
        ['Biostatistics & Research Methodology', 'जैव सांख्यिकी एवं शोध प्रविधि'], ['Social & Preventive Pharmacy', 'सामाजिक एवं निवारक फ़ार्मेसी'],
        ['Electives (Pharmacovigilance / Cosmetic Science / Pharma Marketing)', 'ऐच्छिक विषय (फ़ार्माकोविजिलेंस / कॉस्मेटिक विज्ञान / फ़ार्मा विपणन)', 'E', '', 'bpharm-electives'], ['Project', 'परियोजना', 'P']]}];
C['mbbs'] = ['NMC Competency Based Medical Education (CBME) curriculum', {
  '1': [['Anatomy', 'शरीर रचना विज्ञान'], ['Physiology', 'शरीर क्रिया विज्ञान'], ['Biochemistry', 'जैव रसायन', 'T', '', 'mbbs-biochemistry'],
        ['Foundation Course & Family Adoption Programme', 'फ़ाउंडेशन कोर्स एवं परिवार गोद कार्यक्रम', 'P']],
  '2': [['Pathology', 'पैथोलॉजी'], ['Pharmacology', 'फ़ार्माकोलॉजी', 'T', '', 'mbbs-pharmacology'], ['Microbiology', 'सूक्ष्मजीव विज्ञान'],
        ['Forensic Medicine & Toxicology', 'न्यायालयिक चिकित्सा एवं विष विज्ञान']],
  '3': [['Community Medicine', 'सामुदायिक चिकित्सा'], ['Otorhinolaryngology (ENT)', 'नाक-कान-गला (ENT)'], ['Ophthalmology', 'नेत्र विज्ञान']],
  '4': [['General Medicine', 'सामान्य चिकित्सा'], ['General Surgery', 'सामान्य शल्य चिकित्सा'], ['Obstetrics & Gynaecology', 'प्रसूति एवं स्त्री रोग'], ['Paediatrics', 'बाल रोग'],
        ['Orthopaedics', 'अस्थि रोग'], ['Dermatology', 'त्वचा रोग'], ['Psychiatry', 'मनोरोग'], ['Anaesthesiology', 'निश्चेतना विज्ञान']],
  '5': [['Compulsory Rotating Medical Internship', 'अनिवार्य रोटेटिंग मेडिकल इंटर्नशिप', 'P']]}];
C['llb'] = ['Bar Council of India Legal Education Rules (3-year LL.B.; 5-year adds a BA/BBA part)', {
  '1': [['Jurisprudence', 'विधिशास्त्र', 'T', 's:law'], ['Constitutional Law', 'संवैधानिक विधि', 'T', 's:law'], ['Law of Contract', 'संविदा विधि', 'T', 's:law'],
        ['Law of Torts & Consumer Protection', 'अपकृत्य विधि एवं उपभोक्ता संरक्षण', 'T', 's:law'], ['Family Law', 'कुटुंब विधि', 'T', 's:law'],
        ['Criminal Law (Bharatiya Nyaya Sanhita)', 'दंड विधि (भारतीय न्याय संहिता)', 'T', 's:law']],
  '2': [['Property Law', 'संपत्ति विधि', 'T', 's:law'], ['Administrative Law', 'प्रशासनिक विधि', 'T', 's:law'], ['Company Law', 'कंपनी विधि', 'T', 's:law', 'company-law'],
        ['Labour & Industrial Law', 'श्रम एवं औद्योगिक विधि', 'T', 's:law'], ['Environmental Law', 'पर्यावरण विधि', 'T', 's:law'], ['Public International Law', 'सार्वजनिक अंतरराष्ट्रीय विधि', 'T', 's:law']],
  '3': [['Civil Procedure Code & Limitation Act', 'सिविल प्रक्रिया संहिता एवं परिसीमा अधिनियम', 'T', 's:law'],
        ['Criminal Procedure (Bharatiya Nagarik Suraksha Sanhita)', 'दंड प्रक्रिया (भारतीय नागरिक सुरक्षा संहिता)', 'T', 's:law'],
        ['Law of Evidence (Bharatiya Sakshya Adhiniyam)', 'साक्ष्य विधि (भारतीय साक्ष्य अधिनियम)', 'T', 's:law'], ['Interpretation of Statutes', 'विधियों का निर्वचन', 'T', 's:law'],
        ['Professional Ethics', 'व्यावसायिक नैतिकता', 'T', 's:law'], ['Drafting, Pleading & Conveyancing', 'प्रारूपण, अभिवचन एवं हस्तांतरण लेख', 'L'],
        ['Moot Court & Internship', 'मूट कोर्ट एवं इंटर्नशिप', 'P']],
  '4': [['Taxation Law', 'कराधान विधि', 'T', 's:law'], ['Banking & Insurance Law', 'बैंकिंग एवं बीमा विधि', 'T', 's:law'], ['Intellectual Property Law', 'बौद्धिक संपदा विधि', 'T', 's:law'],
        ['Cyber Law', 'साइबर विधि', 'T', 's:law']],
  '5': [['Alternative Dispute Resolution', 'वैकल्पिक विवाद समाधान', 'T', 's:law'], ['Human Rights Law', 'मानवाधिकार विधि', 'T', 's:law'],
        ['Clinical Legal Education & Internship', 'क्लिनिकल विधिक शिक्षा एवं इंटर्नशिप', 'P']]}];
C['bca'] = [UGC, {
  '1': [['Computer Fundamentals', 'कंप्यूटर के मूल सिद्धांत', 'T', 's:computer-basics'], ['Programming in C', 'C में प्रोग्रामिंग'], ['Mathematics for Computing', 'कंप्यूटिंग के लिए गणित'],
        ['Digital Electronics', 'डिजिटल इलेक्ट्रॉनिक्स'], ['Communication English', 'संचार अंग्रेज़ी', 'T', '', 'communication-skills-in-english']],
  '2': [['Data Structures', 'डेटा संरचना'], ['Object Oriented Programming with C++', 'C++ के साथ ऑब्जेक्ट ओरिएंटेड प्रोग्रामिंग'], ['Database Management Systems', 'डेटाबेस प्रबंधन प्रणाली'],
        ['Operating Systems', 'ऑपरेटिंग सिस्टम'], ['Computer Networks', 'कंप्यूटर नेटवर्क']],
  '3': [['Java Programming', 'जावा प्रोग्रामिंग'], ['Web Technologies', 'वेब तकनीकें', 'T', '', 'web-technologies'], ['Software Engineering', 'सॉफ़्टवेयर इंजीनियरिंग'],
        ['Python Programming', 'पायथन प्रोग्रामिंग'], ['Project', 'परियोजना', 'P']]}];
C['bba'] = [UGC, {
  '1': [['Principles of Management', 'प्रबंधन के सिद्धांत', 'T', 's:business-studies'], ['Business Economics', 'व्यावसायिक अर्थशास्त्र', 'T', '', 'business-economics-micro'],
        ['Financial Accounting', 'वित्तीय लेखांकन'], ['Business Communication', 'व्यावसायिक संचार'], ['Business Mathematics & Statistics', 'व्यावसायिक गणित एवं सांख्यिकी']],
  '2': [['Organisational Behaviour', 'संगठनात्मक व्यवहार'], ['Marketing Management', 'विपणन प्रबंधन'], ['Human Resource Management', 'मानव संसाधन प्रबंधन'],
        ['Cost & Management Accounting', 'लागत एवं प्रबंधन लेखांकन'], ['Business Law', 'व्यावसायिक विधि', 'T', 's:business-law']],
  '3': [['Financial Management', 'वित्तीय प्रबंधन'], ['Production & Operations Management', 'उत्पादन एवं संचालन प्रबंधन', 'T', '', 'operations-management'],
        ['Entrepreneurship Development', 'उद्यमिता विकास', 'T', '', 'entrepreneurship-start-ups'], ['Strategic Management', 'रणनीतिक प्रबंधन'],
        ['Research Methodology', 'शोध प्रविधि', 'T', '', 'business-research-methods'], ['Project', 'परियोजना', 'P']]}];
C['bsc-agriculture'] = ['ICAR Fifth Deans Committee syllabus (B.Sc. Hons. Agriculture)', {
  '1': [['Fundamentals of Agronomy', 'शस्य विज्ञान के मूल सिद्धांत'], ['Fundamentals of Soil Science', 'मृदा विज्ञान के मूल सिद्धांत'], ['Fundamentals of Horticulture', 'उद्यानिकी के मूल सिद्धांत'],
        ['Fundamentals of Genetics', 'आनुवंशिकी के मूल सिद्धांत'], ['Agricultural Microbiology', 'कृषि सूक्ष्मजीव विज्ञान'], ['Fundamentals of Entomology', 'कीट विज्ञान के मूल सिद्धांत'],
        ['Rural Sociology & Educational Psychology', 'ग्रामीण समाजशास्त्र एवं शैक्षिक मनोविज्ञान']],
  '2': [['Crop Production (Kharif & Rabi Crops)', 'फसल उत्पादन (खरीफ़ एवं रबी फसलें)'], ['Fundamentals of Plant Pathology', 'पादप रोग विज्ञान के मूल सिद्धांत'],
        ['Agricultural Economics', 'कृषि अर्थशास्त्र'], ['Principles of Plant Breeding', 'पादप प्रजनन के सिद्धांत'], ['Soil Fertility & Nutrient Management', 'मृदा उर्वरता एवं पोषक प्रबंधन'],
        ['Livestock & Poultry Management', 'पशुधन एवं कुक्कुट प्रबंधन'], ['Farm Machinery & Power', 'कृषि मशीनरी एवं शक्ति']],
  '3': [['Agricultural Marketing & Trade', 'कृषि विपणन एवं व्यापार'], ['Pests of Crops & Stored Grain', 'फसलों एवं भंडारित अनाज के कीट'],
        ['Diseases of Field & Horticultural Crops', 'खेत एवं उद्यानिकी फसलों के रोग'], ['Principles of Seed Technology', 'बीज प्रौद्योगिकी के सिद्धांत'],
        ['Irrigation Water Management', 'सिंचाई जल प्रबंधन'], ['Agricultural Extension Education', 'कृषि प्रसार शिक्षा'], ['Post-harvest Management', 'कटाई उपरांत प्रबंधन']],
  '4': [['Rural Agricultural Work Experience (RAWE)', 'ग्रामीण कृषि कार्य अनुभव (RAWE)', 'P'], ['Experiential Learning Programme', 'अनुभवात्मक अधिगम कार्यक्रम', 'P'],
        ['Electives (Agri-business / Protected Cultivation / Organic Farming)', 'ऐच्छिक विषय (कृषि व्यवसाय / संरक्षित खेती / जैविक खेती)', 'E', '', 'agri-electives']]}];
C['mba'] = ['AICTE model curriculum for MBA', {
  '1': [['Management Principles & Organisational Behaviour', 'प्रबंधन सिद्धांत एवं संगठनात्मक व्यवहार'], ['Managerial Economics', 'प्रबंधकीय अर्थशास्त्र'],
        ['Accounting for Managers', 'प्रबंधकों के लिए लेखांकन'], ['Marketing Management', 'विपणन प्रबंधन'], ['Human Resource Management', 'मानव संसाधन प्रबंधन'],
        ['Business Statistics & Analytics', 'व्यावसायिक सांख्यिकी एवं विश्लेषण'], ['Financial Management', 'वित्तीय प्रबंधन'], ['Operations Management', 'संचालन प्रबंधन'],
        ['Business Communication', 'व्यावसायिक संचार']],
  '2': [['Strategic Management', 'रणनीतिक प्रबंधन'], ['Business Research Methods', 'व्यावसायिक शोध विधियाँ'],
        ['Specialisation Electives (Marketing / Finance / HR / Operations)', 'विशेषज्ञता ऐच्छिक (विपणन / वित्त / HR / संचालन)', 'E', '', 'mba-electives'],
        ['Summer Internship Project', 'समर इंटर्नशिप परियोजना', 'P'], ['Final Project', 'अंतिम परियोजना', 'P']]}];
C['mca'] = ['AICTE model curriculum for MCA', {
  '1': [['Data Structures & Algorithms', 'डेटा संरचना एवं एल्गोरिदम'], ['Object Oriented Programming with Java', 'जावा के साथ ऑब्जेक्ट ओरिएंटेड प्रोग्रामिंग', 'T', '', 'java-programming'],
        ['Database Management Systems', 'डेटाबेस प्रबंधन प्रणाली'], ['Operating Systems', 'ऑपरेटिंग सिस्टम'], ['Computer Networks', 'कंप्यूटर नेटवर्क'], ['Discrete Mathematics', 'असतत गणित']],
  '2': [['Software Engineering', 'सॉफ़्टवेयर इंजीनियरिंग'], ['Web Technologies', 'वेब तकनीकें', 'T', '', 'web-technologies'], ['Python & Data Science', 'पायथन एवं डेटा साइंस'],
        ['Cloud Computing', 'क्लाउड कंप्यूटिंग'], ['Artificial Intelligence & Machine Learning', 'कृत्रिम बुद्धिमत्ता एवं मशीन लर्निंग'], ['Project', 'परियोजना', 'P']]}];
