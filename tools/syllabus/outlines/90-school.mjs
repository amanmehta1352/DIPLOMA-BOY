// School: class 6–12 (NCERT / CBSE themes; units are syllabus themes, not book chapter titles, so state-board books fit too).
const lang = (en, hi, gram, write) => [
  [`${en} Prose (Reader)`, `${hi} गद्य (पाठ्यपुस्तक)`, 'Prescribed prose lessons; Comprehension questions; Vocabulary from lessons'],
  [`${en} Poetry`, `${hi} कविता`, 'Prescribed poems; Central idea; Poetic devices and appreciation'],
  ['Grammar', 'व्याकरण', gram],
  ['Writing Skills', 'लेखन कौशल', write],
  ['Reading (Unseen)', 'अपठित', 'Unseen passage; Unseen poem / note making']];
const hindi = (gram, write) => [
  ['गद्य खंड (Prose)', 'गद्य खंड', 'निर्धारित पाठ; पाठ आधारित प्रश्न; शब्दार्थ'],
  ['पद्य खंड (Poetry)', 'पद्य खंड', 'निर्धारित कविताएँ; भावार्थ; काव्य सौंदर्य'],
  ['व्याकरण (Grammar)', 'व्याकरण', gram],
  ['रचना (Writing)', 'रचना', write],
  ['अपठित (Unseen)', 'अपठित', 'अपठित गद्यांश; अपठित काव्यांश']];
const sanskrit = g => [
  ['पठनम् (Reading)', 'पठनम्', 'निर्धारित पाठ; अनुवाद; प्रश्नोत्तर'],
  ['व्याकरणम् (Grammar)', 'व्याकरणम्', g],
  ['रचना (Composition)', 'रचना', 'चित्र वर्णन; अनुच्छेद लेखन; पत्र लेखन']];
const sci = (c, u) => u.map(([en, hi, t]) => [en, hi, t]);

export const O = {
// ---------- class 6 ----------
'c6-maths': [
 ['Patterns and Numbers', 'पैटर्न और संख्याएँ', 'Number patterns; Large numbers and place value; Number play'],
 ['Prime Time', 'अभाज्य संख्याएँ', 'Factors and multiples; Prime and composite numbers; Divisibility rules; HCF and LCM'],
 ['Lines, Angles and Constructions', 'रेखाएँ, कोण और रचनाएँ', 'Points, lines, rays; Angles and their measure; Constructions with ruler and compass; Symmetry'],
 ['Fractions and Integers', 'भिन्न और पूर्णांक', 'Fractions and operations; Negative numbers (the other side of zero); Number line'],
 ['Perimeter, Area and Data', 'परिमाप, क्षेत्रफल और आँकड़े', 'Perimeter and area of rectangles and squares; Data collection; Pictographs and bar graphs']],
'c6-science': [
 ['World of Science and Living Things', 'विज्ञान की दुनिया और सजीव', 'Scientific method; Diversity in the living world; Characteristics of living creatures'],
 ['Food and Health', 'भोजन और स्वास्थ्य', 'Components of food; Balanced diet; Deficiency diseases'],
 ['Magnets, Motion and Measurement', 'चुंबक, गति और मापन', 'Magnets and their properties; Measurement of length; Types of motion'],
 ['Materials, Temperature and Water', 'पदार्थ, ताप और जल', 'Materials around us; Temperature and thermometers; States of water; Separation of mixtures'],
 ['Nature and Beyond Earth', 'प्रकृति और पृथ्वी से परे', 'Natural resources; Conservation; Stars, Sun, Moon and the solar system']],
'c6-social-science': [
 ['India and the World: Land and People', 'भारत और विश्व: भूमि और लोग', 'Locating places on Earth; Maps; Oceans and continents; Landforms'],
 ['Tapestry of the Past', 'अतीत का ताना-बाना', 'Sources of history; Early humans; Harappan civilisation; Early India'],
 ['Our Cultural Heritage', 'हमारी सांस्कृतिक विरासत', 'Diversity of India; Unity in diversity; Indian knowledge traditions'],
 ['Governance and Democracy', 'शासन और लोकतंत्र', 'What is government; Local government: panchayats and municipalities'],
 ['Economic Life Around Us', 'हमारे आस-पास का आर्थिक जीवन', 'Livelihoods; Economic activities; Markets']],
'c6-english': lang('English', 'अंग्रेज़ी', 'Nouns, pronouns, verbs; Adjectives and adverbs; Simple tenses; Punctuation', 'Paragraph writing; Informal letter; Notice; Story writing'),
'c6-hindi': hindi('संज्ञा, सर्वनाम, विशेषण, क्रिया; वचन और लिंग; विलोम और पर्यायवाची; वर्तनी', 'अनुच्छेद लेखन; अनौपचारिक पत्र; चित्र वर्णन; कहानी लेखन'),
'c6-sanskrit': sanskrit('वर्णमाला; शब्द रूप (अकारान्त); धातु रूप (लट् लकार); संख्या (1-50)'),
// ---------- class 7 ----------
'c7-maths': [
 ['Integers and Fractions', 'पूर्णांक और भिन्न', 'Operations on integers; Multiplication and division of fractions; Decimals'],
 ['Algebra', 'बीजगणित', 'Algebraic expressions; Simple equations; Exponents and powers'],
 ['Ratio, Percentage and Interest', 'अनुपात, प्रतिशत और ब्याज', 'Ratio and proportion; Percentage; Profit and loss; Simple interest'],
 ['Geometry', 'ज्यामिति', 'Lines and angles; Triangles and their properties; Congruence; Constructions; Symmetry'],
 ['Mensuration and Data', 'क्षेत्रमिति और आँकड़े', 'Perimeter and area; Circles; Mean, median, mode; Bar graphs; Probability basics']],
'c7-science': [
 ['Nutrition', 'पोषण', 'Nutrition in plants; Nutrition in animals; Digestive system'],
 ['Heat, Acids and Changes', 'ऊष्मा, अम्ल और परिवर्तन', 'Heat and temperature; Acids, bases and salts; Physical and chemical changes'],
 ['Weather, Soil and Respiration', 'मौसम, मिट्टी और श्वसन', 'Weather and climate; Soil; Respiration in organisms'],
 ['Transport, Reproduction and Motion', 'परिवहन, प्रजनन और गति', 'Transportation in plants and animals; Reproduction in plants; Motion and time'],
 ['Electricity, Light and Resources', 'विद्युत, प्रकाश और संसाधन', 'Electric current and circuits; Light and reflection; Water and forests']],
'c7-social-science': [
 ['Geography: Our Environment', 'भूगोल: हमारा पर्यावरण', 'Environment; Inside our earth; Air and water; Natural vegetation and wildlife'],
 ['History: Medieval India', 'इतिहास: मध्यकालीन भारत', 'New kings and kingdoms; Delhi Sultans; Mughal empire; Devotional paths'],
 ['Political Life', 'राजनीतिक जीवन', 'Equality in democracy; State government; Role of media'],
 ['Society and Gender', 'समाज और जेंडर', 'Growing up as boys and girls; Women’s work'],
 ['Markets and Economy', 'बाज़ार और अर्थव्यवस्था', 'Markets around us; A shirt in the market']],
'c7-english': lang('English', 'अंग्रेज़ी', 'Tenses; Active and passive voice basics; Modals; Prepositions and conjunctions', 'Paragraph; Formal and informal letters; Diary entry; Notice and message'),
'c7-hindi': hindi('संधि (परिचय); उपसर्ग और प्रत्यय; मुहावरे; काल; वाक्य', 'अनुच्छेद; पत्र लेखन; संवाद लेखन; विज्ञापन'),
'c7-sanskrit': sanskrit('शब्द रूप (आकारान्त, इकारान्त); धातु रूप (लृट्, लङ् लकार); सन्धि परिचय; संख्या (1-100)'),
// ---------- class 8 ----------
'c8-maths': [
 ['Rational Numbers and Powers', 'परिमेय संख्याएँ और घात', 'Rational numbers; Exponents; Squares and square roots; Cubes and cube roots'],
 ['Algebra', 'बीजगणित', 'Linear equations in one variable; Algebraic identities; Factorisation'],
 ['Commercial Maths', 'व्यावसायिक गणित', 'Percentage; Profit, loss and discount; Compound interest; Direct and inverse proportion'],
 ['Geometry', 'ज्यामिति', 'Quadrilaterals; Practical geometry; Visualising solid shapes'],
 ['Mensuration, Data and Graphs', 'क्षेत्रमिति, आँकड़े और ग्राफ़', 'Area of polygons; Surface area and volume; Data handling and pie charts; Introduction to graphs']],
'c8-science': [
 ['Crops and Microorganisms', 'फसल और सूक्ष्मजीव', 'Crop production and management; Microorganisms: friend and foe'],
 ['Materials', 'पदार्थ', 'Synthetic fibres and plastics; Metals and non-metals; Coal and petroleum; Combustion and flame'],
 ['Life Processes', 'जीवन प्रक्रियाएँ', 'Conservation of plants and animals; Cell structure; Reproduction; Adolescence'],
 ['Force and Pressure', 'बल और दाब', 'Force and pressure; Friction; Sound'],
 ['Electricity, Light and Natural Phenomena', 'विद्युत, प्रकाश और प्राकृतिक घटनाएँ', 'Chemical effects of current; Lightning and earthquakes; Light; Stars and the solar system']],
'c8-social-science': [
 ['Geography: Resources', 'भूगोल: संसाधन', 'Resources; Land, soil, water, vegetation; Mineral and power resources; Agriculture; Industries; Human resources'],
 ['History: Modern India', 'इतिहास: आधुनिक भारत', 'Company rule; Rural life and society; Revolt of 1857; National movement'],
 ['Constitution and Parliament', 'संविधान और संसद', 'Indian constitution; Secularism; Parliament and laws'],
 ['Judiciary and Social Justice', 'न्यायपालिका और सामाजिक न्याय', 'Judiciary; Criminal justice system; Marginalisation'],
 ['Economic Presence of Government', 'सरकार की आर्थिक भूमिका', 'Public facilities; Law and social justice']],
'c8-english': lang('English', 'अंग्रेज़ी', 'Tenses; Active and passive voice; Reported speech; Determiners; Subject-verb agreement', 'Formal letter; Article; Report; Notice; Story completion'),
'c8-hindi': hindi('संधि; समास; मुहावरे और लोकोक्तियाँ; वाच्य परिचय; अलंकार परिचय', 'निबंध; औपचारिक पत्र; संवाद लेखन; विज्ञापन लेखन'),
'c8-sanskrit': sanskrit('शब्द रूप (सर्वनाम); धातु रूप (लोट्, विधिलिङ्); सन्धि; प्रत्यय (क्त्वा, ल्यप्, तुमुन्)'),
// ---------- class 9 ----------
'c9-maths': [
 ['Number Systems and Polynomials', 'संख्या पद्धति और बहुपद', 'Real numbers and irrational numbers; Laws of exponents; Polynomials and factor theorem; Algebraic identities'],
 ['Coordinate Geometry and Linear Equations', 'निर्देशांक ज्यामिति और रैखिक समीकरण', 'Cartesian plane; Linear equations in two variables'],
 ['Geometry', 'ज्यामिति', 'Euclid’s geometry; Lines and angles; Triangles and congruence; Quadrilaterals; Circles'],
 ['Mensuration', 'क्षेत्रमिति', 'Heron’s formula; Surface areas and volumes'],
 ['Statistics', 'सांख्यिकी', 'Presentation of data; Bar graphs, histograms, frequency polygons']],
'c9-science': [
 ['Matter', 'पदार्थ', 'Matter in our surroundings; Is matter pure; Atoms and molecules; Structure of the atom'],
 ['Organisation in the Living World', 'सजीव जगत में संगठन', 'Cell; Tissues'],
 ['Motion, Force and Work', 'गति, बल और कार्य', 'Motion; Force and laws of motion; Gravitation; Work and energy'],
 ['Sound', 'ध्वनि', 'Nature and propagation of sound; Reflection; Range of hearing'],
 ['Food Production', 'खाद्य उत्पादन', 'Improvement in food resources']],
'c9-social-science': [
 ['History: India and the Contemporary World I', 'इतिहास: भारत और समकालीन विश्व I', 'French Revolution; Socialism and the Russian Revolution; Nazism; Forest society; Pastoralists'],
 ['Geography: Contemporary India I', 'भूगोल: समकालीन भारत I', 'India: size and location; Physical features; Drainage; Climate; Natural vegetation and wildlife; Population'],
 ['Political Science: Democratic Politics I', 'राजनीति विज्ञान: लोकतांत्रिक राजनीति I', 'What is democracy; Constitutional design; Electoral politics; Working of institutions; Democratic rights'],
 ['Economics', 'अर्थशास्त्र', 'Story of village Palampur; People as resource; Poverty; Food security in India']],
'c9-english': lang('English', 'अंग्रेज़ी', 'Tenses; Modals; Subject-verb concord; Reported speech; Determiners; Editing and omission', 'Descriptive paragraph; Story writing; Diary entry; Formal letter'),
'c9-hindi': hindi('शब्द निर्माण (उपसर्ग, प्रत्यय, समास); अर्थ के आधार पर वाक्य भेद; अलंकार; मुहावरे', 'अनुच्छेद; पत्र लेखन; संवाद; सूचना और विज्ञापन लेखन'),
'c9-it': [
 ['Employability Skills', 'रोज़गार कौशल', 'Communication; Self-management; ICT skills; Entrepreneurship; Green skills'],
 ['Introduction to IT and Office Tools', 'IT और ऑफ़िस टूल का परिचय', 'Computer basics; Word processing; Spreadsheets; Presentations'],
 ['Digital Documentation and Safety', 'डिजिटल दस्तावेज़ीकरण और सुरक्षा', 'Styles and templates; Internet safety; Cyber ethics']],
// ---------- class 10 ----------
'c10-maths': [
 ['Number Systems and Algebra', 'संख्या पद्धति और बीजगणित', 'Real numbers and fundamental theorem of arithmetic; Polynomials; Pair of linear equations; Quadratic equations; Arithmetic progressions'],
 ['Coordinate Geometry', 'निर्देशांक ज्यामिति', 'Distance formula; Section formula'],
 ['Geometry', 'ज्यामिति', 'Similar triangles and BPT; Tangents to a circle'],
 ['Trigonometry', 'त्रिकोणमिति', 'Trigonometric ratios; Identities; Heights and distances'],
 ['Mensuration, Statistics and Probability', 'क्षेत्रमिति, सांख्यिकी और प्रायिकता', 'Areas related to circles; Surface areas and volumes; Mean, median, mode of grouped data; Probability']],
'c10-science': [
 ['Chemical Substances', 'रासायनिक पदार्थ', 'Chemical reactions and equations; Acids, bases and salts; Metals and non-metals; Carbon and its compounds'],
 ['Life Processes', 'जैव प्रक्रम', 'Nutrition, respiration, transport, excretion; Control and coordination; Reproduction; Heredity'],
 ['Light', 'प्रकाश', 'Reflection and refraction; Lenses and mirrors; Human eye and colourful world'],
 ['Electricity and Magnetism', 'विद्युत और चुंबकत्व', 'Electric current, Ohm’s law, resistance; Heating effect; Magnetic effects of current; Electric motor and generator basics'],
 ['Natural Resources', 'प्राकृतिक संसाधन', 'Our environment; Ecosystem; Ozone depletion; Waste management']],
'c10-social-science': [
 ['History: India and the Contemporary World II', 'इतिहास: भारत और समकालीन विश्व II', 'Rise of nationalism in Europe; Nationalism in India; Making of a global world; Age of industrialisation; Print culture'],
 ['Geography: Contemporary India II', 'भूगोल: समकालीन भारत II', 'Resources and development; Forest and wildlife; Water resources; Agriculture; Minerals and energy; Manufacturing industries; Lifelines of economy'],
 ['Political Science: Democratic Politics II', 'राजनीति विज्ञान: लोकतांत्रिक राजनीति II', 'Power sharing; Federalism; Gender, religion and caste; Political parties; Outcomes of democracy'],
 ['Economics: Understanding Economic Development', 'अर्थशास्त्र: आर्थिक विकास की समझ', 'Development; Sectors of the economy; Money and credit; Globalisation; Consumer rights']],
'c10-english': lang('English', 'अंग्रेज़ी', 'Tenses; Modals; Subject-verb concord; Reported speech; Determiners; Gap filling and editing', 'Formal letter (complaint, enquiry, order); Analytical paragraph'),
'c10-hindi': hindi('रचना के आधार पर वाक्य भेद; वाच्य; पद परिचय; रस; मुहावरे', 'अनुच्छेद; औपचारिक पत्र; सूचना; विज्ञापन; ई-मेल लेखन; लघु कथा'),
'c10-it': [
 ['Employability Skills', 'रोज़गार कौशल', 'Communication; Self-management; ICT; Entrepreneurship; Green skills'],
 ['Digital Documentation (Advanced)', 'डिजिटल दस्तावेज़ीकरण (उन्नत)', 'Styles; Images; Templates; Table of contents; Mail merge'],
 ['Electronic Spreadsheet (Advanced)', 'इलेक्ट्रॉनिक स्प्रेडशीट (उन्नत)', 'Consolidation; Subtotals; What-if analysis; Macros'],
 ['Database Management', 'डेटाबेस प्रबंधन', 'Tables; Queries; Forms; Reports'],
 ['Web Applications and Security', 'वेब अनुप्रयोग और सुरक्षा', 'Networking; Instant messaging; Blogs; Online safety']],
// ---------- class 11 / 12 science ----------
'c11-physics': [
 ['Units, Measurement and Kinematics', 'मात्रक, मापन और शुद्धगतिकी', 'Units and dimensions; Errors; Motion in a straight line; Motion in a plane; Projectile motion'],
 ['Laws of Motion and Work-Energy', 'गति के नियम और कार्य-ऊर्जा', 'Newton’s laws; Friction; Circular motion; Work, energy and power'],
 ['Rotational Motion and Gravitation', 'घूर्णन गति और गुरुत्वाकर्षण', 'Centre of mass; Torque and angular momentum; Moment of inertia; Universal law of gravitation; Satellites'],
 ['Properties of Matter and Thermodynamics', 'द्रव्य के गुण और ऊष्मागतिकी', 'Elasticity; Fluid mechanics; Thermal properties; Laws of thermodynamics; Kinetic theory'],
 ['Oscillations and Waves', 'दोलन और तरंगें', 'SHM; Simple pendulum; Wave motion; Standing waves; Beats; Doppler effect']],
'c12-physics': [
 ['Electrostatics', 'स्थिरवैद्युतिकी', 'Electric charges and fields; Gauss’s law; Electric potential; Capacitance'],
 ['Current Electricity', 'धारा विद्युत', 'Ohm’s law; Kirchhoff’s laws; Wheatstone bridge; Potentiometer'],
 ['Magnetism and EMI', 'चुंबकत्व और विद्युत-चुंबकीय प्रेरण', 'Moving charges and magnetism; Magnetism and matter; Electromagnetic induction; Alternating current'],
 ['EM Waves and Optics', 'EM तरंगें और प्रकाशिकी', 'Electromagnetic waves; Ray optics and optical instruments; Wave optics'],
 ['Modern Physics and Electronics', 'आधुनिक भौतिकी और इलेक्ट्रॉनिक्स', 'Dual nature of radiation; Atoms; Nuclei; Semiconductor electronics']],
'c11-chemistry': [
 ['Basic Concepts and Atomic Structure', 'मूल अवधारणाएँ और परमाणु संरचना', 'Mole concept; Stoichiometry; Atomic models; Quantum numbers'],
 ['Periodicity and Bonding', 'आवर्तिता और बंधन', 'Periodic table and trends; Chemical bonding and molecular structure'],
 ['Thermodynamics and Equilibrium', 'ऊष्मागतिकी और साम्य', 'Chemical thermodynamics; Chemical and ionic equilibrium'],
 ['Redox Reactions', 'अपचयोपचय अभिक्रियाएँ', 'Oxidation number; Balancing redox reactions'],
 ['Organic Chemistry Basics and Hydrocarbons', 'कार्बनिक रसायन के मूल तत्व और हाइड्रोकार्बन', 'IUPAC nomenclature; Isomerism; Reaction mechanisms; Alkanes, alkenes, alkynes, aromatics']],
'c12-chemistry': [
 ['Solutions and Electrochemistry', 'विलयन और विद्युत रसायन', 'Concentration terms; Colligative properties; Electrochemical cells; Nernst equation; Conductance'],
 ['Chemical Kinetics', 'रासायनिक गतिकी', 'Rate of reaction; Order and molecularity; Arrhenius equation'],
 ['Inorganic Chemistry', 'अकार्बनिक रसायन', 'd- and f-block elements; Coordination compounds'],
 ['Organic Compounds with Functional Groups', 'क्रियात्मक समूह वाले कार्बनिक यौगिक', 'Haloalkanes and haloarenes; Alcohols, phenols and ethers; Aldehydes, ketones and carboxylic acids; Amines'],
 ['Biomolecules', 'जैव-अणु', 'Carbohydrates; Proteins; Vitamins; Nucleic acids']],
'c11-maths': [
 ['Sets, Relations and Functions', 'समुच्चय, संबंध और फलन', 'Sets; Relations and functions; Trigonometric functions'],
 ['Algebra', 'बीजगणित', 'Complex numbers and quadratic equations; Linear inequalities; Permutations and combinations; Binomial theorem; Sequences and series'],
 ['Coordinate Geometry', 'निर्देशांक ज्यामिति', 'Straight lines; Conic sections; Introduction to 3D geometry'],
 ['Calculus', 'कलन', 'Limits and derivatives'],
 ['Statistics and Probability', 'सांख्यिकी और प्रायिकता', 'Measures of dispersion; Probability']],
'c12-maths': [
 ['Relations, Functions and Inverse Trigonometry', 'संबंध, फलन और प्रतिलोम त्रिकोणमिति', 'Types of relations and functions; Inverse trigonometric functions'],
 ['Algebra', 'बीजगणित', 'Matrices; Determinants'],
 ['Calculus', 'कलन', 'Continuity and differentiability; Applications of derivatives; Integrals; Applications of integrals; Differential equations'],
 ['Vectors and 3D Geometry', 'सदिश और त्रि-आयामी ज्यामिति', 'Vector algebra; Lines in 3D'],
 ['Linear Programming and Probability', 'रैखिक प्रोग्रामन और प्रायिकता', 'LPP graphical method; Conditional probability; Bayes’ theorem; Random variables']],
'c11-biology': [
 ['Diversity of Living Organisms', 'जीवों में विविधता', 'The living world; Biological classification; Plant and animal kingdoms'],
 ['Structural Organisation', 'संरचनात्मक संगठन', 'Morphology and anatomy of flowering plants; Structural organisation in animals'],
 ['Cell: Structure and Function', 'कोशिका: संरचना और कार्य', 'Cell the unit of life; Biomolecules; Cell cycle and division'],
 ['Plant Physiology', 'पादप क्रिया विज्ञान', 'Photosynthesis; Respiration in plants; Plant growth and development'],
 ['Human Physiology', 'मानव क्रिया विज्ञान', 'Breathing; Body fluids and circulation; Excretion; Locomotion; Neural and chemical coordination']],
'c12-biology': [
 ['Reproduction', 'प्रजनन', 'Sexual reproduction in flowering plants; Human reproduction; Reproductive health'],
 ['Genetics and Evolution', 'आनुवंशिकी और विकास', 'Principles of inheritance; Molecular basis of inheritance; Evolution'],
 ['Biology and Human Welfare', 'जीव विज्ञान और मानव कल्याण', 'Human health and disease; Microbes in human welfare'],
 ['Biotechnology', 'जैव प्रौद्योगिकी', 'Principles and processes; Applications'],
 ['Ecology', 'पारिस्थितिकी', 'Organisms and populations; Ecosystem; Biodiversity and conservation']],
'c11-english': [
 ['Hornbill (Prose and Poetry)', 'हॉर्नबिल (गद्य और पद्य)', 'Prescribed prose; Prescribed poems; Theme and character'],
 ['Snapshots (Supplementary Reader)', 'स्नैपशॉट्स (पूरक पाठ)', 'Supplementary stories; Long answer questions'],
 ['Reading Skills', 'पठन कौशल', 'Unseen passages; Note making and summarising'],
 ['Writing Skills', 'लेखन कौशल', 'Notice; Poster; Speech; Debate'],
 ['Grammar', 'व्याकरण', 'Tenses; Clauses; Modals; Change of voice']],
'c12-english': [
 ['Flamingo (Prose and Poetry)', 'फ़्लेमिंगो (गद्य और पद्य)', 'Prescribed prose; Prescribed poems; Theme and character'],
 ['Vistas (Supplementary Reader)', 'विस्टास (पूरक पाठ)', 'Supplementary stories; Value-based questions'],
 ['Reading Skills', 'पठन कौशल', 'Unseen passages; Case-based passages'],
 ['Writing Skills', 'लेखन कौशल', 'Notice; Invitation and reply; Formal letter; Article; Report'],
 ['Grammar in Context', 'संदर्भ में व्याकरण', 'Integrated grammar in writing']],
'c11-cs-pe': [
 ['Computer Science: Computer Systems', 'कंप्यूटर साइंस: कंप्यूटर प्रणाली', 'Computer organisation; Number systems; Boolean logic'],
 ['Computer Science: Python Programming', 'कंप्यूटर साइंस: पायथन प्रोग्रामिंग', 'Python basics; Flow of control; Strings, lists, tuples, dictionaries'],
 ['Computer Science: Society and Ethics', 'कंप्यूटर साइंस: समाज और नैतिकता', 'Digital footprint; Cyber safety; IPR'],
 ['Physical Education', 'शारीरिक शिक्षा', 'Changing trends in physical education; Olympism; Yoga; Physical fitness and wellness; Sports psychology']],
'c12-cs-pe': [
 ['Computer Science: Python Revision and Functions', 'कंप्यूटर साइंस: पायथन और फ़ंक्शन', 'Functions; Exception handling; File handling'],
 ['Computer Science: Data Structures', 'कंप्यूटर साइंस: डेटा संरचनाएँ', 'Stack using lists'],
 ['Computer Science: Networks and Databases', 'कंप्यूटर साइंस: नेटवर्क और डेटाबेस', 'Computer networks; Database concepts; SQL; Python-MySQL connectivity'],
 ['Physical Education', 'शारीरिक शिक्षा', 'Management of sporting events; Children and women in sports; Yoga; Physiology and injuries; Training in sports']],
// ---------- class 11 / 12 commerce ----------
'c11-accountancy': [
 ['Theory Base of Accounting', 'लेखांकन का सैद्धांतिक आधार', 'Accounting concepts; GAAP; Bases of accounting'],
 ['Recording of Transactions', 'लेनदेन का अभिलेखन', 'Source documents; Journal; Ledger; Special purpose books; Cash book'],
 ['Bank Reconciliation and Trial Balance', 'बैंक समाधान और तलपट', 'BRS; Trial balance; Rectification of errors'],
 ['Depreciation, Provisions and Reserves', 'मूल्यह्रास, प्रावधान और संचय', 'Methods of depreciation; Provisions and reserves'],
 ['Financial Statements', 'वित्तीय विवरण', 'Trading and profit and loss account; Balance sheet; Adjustments; Computers in accounting']],
'c12-accountancy': [
 ['Partnership Fundamentals', 'साझेदारी के मूल तत्व', 'Partnership deed; Profit and loss appropriation; Goodwill'],
 ['Reconstitution of Partnership', 'साझेदारी का पुनर्गठन', 'Change in profit ratio; Admission; Retirement and death'],
 ['Dissolution of Partnership', 'साझेदारी का विघटन', 'Realisation account'],
 ['Company Accounts', 'कंपनी खाते', 'Issue of shares; Forfeiture; Issue and redemption of debentures'],
 ['Analysis of Financial Statements', 'वित्तीय विवरणों का विश्लेषण', 'Financial statements of a company; Ratio analysis; Cash flow statement']],
'c11-business-studies': [
 ['Business, Trade and Commerce', 'व्यवसाय, व्यापार और वाणिज्य', 'Nature of business; Classification of business activities'],
 ['Forms of Business Organisation', 'व्यावसायिक संगठन के स्वरूप', 'Sole proprietorship; Partnership; Company; Cooperative'],
 ['Public, Private and Global Enterprises', 'सार्वजनिक, निजी और वैश्विक उद्यम', 'Types of enterprises; Business services; Emerging modes of business'],
 ['Social Responsibility and Finance', 'सामाजिक उत्तरदायित्व और वित्त', 'Business ethics; Sources of business finance; Small business'],
 ['Internal and International Trade', 'आंतरिक और अंतरराष्ट्रीय व्यापार', 'Retail trade; GST; International business']],
'c12-business-studies': [
 ['Nature and Principles of Management', 'प्रबंधन की प्रकृति और सिद्धांत', 'Management functions; Fayol and Taylor'],
 ['Business Environment', 'व्यावसायिक पर्यावरण', 'Dimensions; Demonetisation and liberalisation'],
 ['Functions of Management', 'प्रबंधन के कार्य', 'Planning; Organising; Staffing; Directing; Controlling'],
 ['Financial Management and Markets', 'वित्तीय प्रबंधन और बाज़ार', 'Financial decisions; Capital structure; Money and capital markets; SEBI'],
 ['Marketing and Consumer Protection', 'विपणन और उपभोक्ता संरक्षण', 'Marketing mix; Consumer Protection Act']],
'c11-economics': [
 ['Statistics: Introduction and Data', 'सांख्यिकी: परिचय और आँकड़े', 'Collection of data; Organisation and presentation of data'],
 ['Statistics: Tools', 'सांख्यिकी: उपकरण', 'Measures of central tendency; Correlation; Index numbers'],
 ['Indian Economic Development I', 'भारतीय आर्थिक विकास I', 'Indian economy on the eve of independence; Indian economy 1950-1990; Liberalisation, privatisation, globalisation'],
 ['Indian Economic Development II', 'भारतीय आर्थिक विकास II', 'Poverty; Human capital formation; Rural development; Employment; Environment and sustainable development'],
 ['Comparative Development', 'तुलनात्मक विकास', 'India, China and Pakistan']],
'c12-economics': [
 ['Introductory Macroeconomics: National Income', 'समष्टि अर्थशास्त्र: राष्ट्रीय आय', 'Circular flow; Measurement of national income'],
 ['Money and Banking', 'मुद्रा और बैंकिंग', 'Money; Credit creation; Central bank'],
 ['Income Determination', 'आय निर्धारण', 'Aggregate demand and supply; Multiplier'],
 ['Government Budget and Balance of Payments', 'सरकारी बजट और भुगतान संतुलन', 'Budget; Deficits; Foreign exchange rate'],
 ['Introductory Microeconomics', 'व्यष्टि अर्थशास्त्र', 'Consumer equilibrium and demand; Producer behaviour and supply; Market forms and price determination']],
'c11-applied-maths': [
 ['Numbers and Quantification', 'संख्याएँ और परिमाणीकरण', 'Binary numbers; Logarithms; Indices; Ratio and mixtures'],
 ['Algebra', 'बीजगणित', 'Sets; Sequences and series; Permutations and combinations'],
 ['Calculus', 'कलन', 'Functions; Limits and continuity; Differentiation'],
 ['Probability and Statistics', 'प्रायिकता और सांख्यिकी', 'Probability; Descriptive statistics'],
 ['Financial Mathematics', 'वित्तीय गणित', 'Interest; Annuities; GST computation']],
'c12-applied-maths': [
 ['Numbers and Algebra', 'संख्याएँ और बीजगणित', 'Modulo arithmetic; Matrices and determinants'],
 ['Calculus', 'कलन', 'Applications of derivatives; Integration; Differential equations'],
 ['Probability Distributions and Inference', 'प्रायिकता वितरण और अनुमान', 'Binomial, Poisson, normal distributions; Hypothesis testing basics'],
 ['Time Series and Linear Programming', 'काल श्रेणी और रैखिक प्रोग्रामन', 'Trend analysis; LPP'],
 ['Financial Mathematics', 'वित्तीय गणित', 'Perpetuity and sinking fund; EMI; Depreciation; CAGR']],
'c11-ip': [
 ['Computer Basics', 'कंप्यूटर के मूल तत्व', 'Computer system; Memory; Software'],
 ['Python Programming', 'पायथन प्रोग्रामिंग', 'Basics; Lists and dictionaries; NumPy basics'],
 ['Database and SQL', 'डेटाबेस और SQL', 'Database concepts; SQL commands'],
 ['Physical Education (option)', 'शारीरिक शिक्षा (विकल्प)', 'Fitness; Yoga; Sports and nutrition']],
'c12-ip': [
 ['Data Handling with pandas', 'pandas से डेटा प्रबंधन', 'Series and DataFrames; Import and export of CSV; Data visualisation with Matplotlib'],
 ['Database Query using SQL', 'SQL से डेटाबेस क्वेरी', 'Functions; Group by; Joins'],
 ['Computer Networks', 'कंप्यूटर नेटवर्क', 'Network types; Internet and web'],
 ['Societal Impacts', 'सामाजिक प्रभाव', 'Digital footprint; Cyber crime; E-waste'],
 ['Physical Education (option)', 'शारीरिक शिक्षा (विकल्प)', 'Sports training; Physiology; Psychology']],
// ---------- class 11 / 12 humanities ----------
'c11-history': [
 ['Early Societies', 'प्रारंभिक समाज', 'From the beginning of time; Writing and city life'],
 ['Empires', 'साम्राज्य', 'An empire across three continents; Central Islamic lands; Nomadic empires'],
 ['Changing Traditions', 'बदलती परंपराएँ', 'Three orders; Changing cultural traditions; Confrontation of cultures'],
 ['Paths to Modernisation', 'आधुनिकीकरण के रास्ते', 'Industrial Revolution; Displacing indigenous peoples; Paths to modernisation']],
'c12-history': [
 ['Themes in Indian History I', 'भारतीय इतिहास के विषय I', 'Harappan civilisation; Kings, farmers and towns; Kinship, caste and class; Thinkers, beliefs and buildings'],
 ['Themes in Indian History II', 'भारतीय इतिहास के विषय II', 'Through the eyes of travellers; Bhakti-Sufi traditions; Vijayanagara; Peasants and the Mughal empire'],
 ['Themes in Indian History III', 'भारतीय इतिहास के विषय III', 'Colonialism and the countryside; Revolt of 1857; Mahatma Gandhi and the national movement; Framing the constitution']],
'c11-political-science': [
 ['Indian Constitution at Work', 'भारतीय संविधान व्यवहार में', 'Constitution: why and how; Rights; Election and representation; Executive; Legislature; Judiciary; Federalism; Local governments'],
 ['Political Theory', 'राजनीतिक सिद्धांत', 'Freedom; Equality; Social justice; Rights; Citizenship; Nationalism; Secularism']],
'c12-political-science': [
 ['Contemporary World Politics', 'समकालीन विश्व राजनीति', 'End of bipolarity; New centres of power; South Asia; International organisations; Security; Environment; Globalisation'],
 ['Politics in India since Independence', 'स्वतंत्रता के बाद भारत में राजनीति', 'Nation building; Planned development; Foreign policy; Congress system; Crisis of democratic order; Regional aspirations; Recent developments']],
'c11-geography': [
 ['Fundamentals of Physical Geography', 'भौतिक भूगोल के मूल सिद्धांत', 'Geography as a discipline; Earth and its interior; Landforms; Climate; Water (oceans); Life on earth'],
 ['India: Physical Environment', 'भारत: भौतिक पर्यावरण', 'Location; Structure and physiography; Drainage; Climate; Natural vegetation; Natural hazards'],
 ['Practical Work', 'प्रायोगिक कार्य', 'Maps and scale; Latitude and longitude; Map projections; Topographical maps']],
'c12-geography': [
 ['Fundamentals of Human Geography', 'मानव भूगोल के मूल सिद्धांत', 'Human geography; Population; Human development; Primary, secondary, tertiary activities; Transport and trade'],
 ['India: People and Economy', 'भारत: लोग और अर्थव्यवस्था', 'Population; Human settlements; Land and water resources; Minerals and energy; Planning; Transport; Geographical problems'],
 ['Practical Work', 'प्रायोगिक कार्य', 'Data sources; Data processing; Graphical representation; Spatial information technology']],
'c11-sociology': [
 ['Introducing Sociology', 'समाजशास्त्र का परिचय', 'Sociology and society; Terms and concepts; Social institutions; Culture'],
 ['Understanding Society', 'समाज की समझ', 'Social structure and stratification; Social change; Environment and society; Western and Indian sociologists']],
'c12-sociology': [
 ['Indian Society', 'भारतीय समाज', 'Demographic structure; Social institutions; Market as institution; Social inequality and exclusion; Cultural diversity'],
 ['Social Change and Development in India', 'भारत में सामाजिक परिवर्तन और विकास', 'Structural and cultural change; Democracy; Rural and industrial change; Globalisation; Social movements']],
'c11-psychology': [
 ['What is Psychology', 'मनोविज्ञान क्या है', 'Nature; Methods of enquiry'],
 ['Human Behaviour', 'मानव व्यवहार', 'Bases of behaviour; Human development'],
 ['Cognitive Processes', 'संज्ञानात्मक प्रक्रियाएँ', 'Sensation and perception; Learning; Memory; Thinking'],
 ['Motivation and Emotion', 'प्रेरणा और संवेग', 'Motives; Emotions']],
'c12-psychology': [
 ['Variations and Self', 'भिन्नताएँ और स्व', 'Intelligence; Self and personality'],
 ['Health and Disorders', 'स्वास्थ्य और विकार', 'Meeting life challenges; Psychological disorders; Therapeutic approaches'],
 ['Social Psychology', 'सामाजिक मनोविज्ञान', 'Attitude and social cognition; Social influence and groups']],
'c11-hindi': hindi('शब्द-भेद; वाक्य-संरचना; वर्तनी; मुहावरे', 'निबंध; औपचारिक पत्र; कार्यालयी हिंदी; जनसंचार माध्यम'),
'c12-hindi': hindi('रस; छंद; अलंकार; वाक्य शुद्धि', 'निबंध; पत्र; फ़ीचर लेखन; रिपोर्ट; नाटक और कहानी लेखन'),
// ---------- shared: COPA / BCA ----------
'computer-fundamentals': [
 ['Computer Basics', 'कंप्यूटर के मूल तत्व', 'History and generations; Block diagram; Hardware and software'],
 ['Number Systems and Logic', 'संख्या प्रणाली और तर्क', 'Binary, octal, hexadecimal; Logic gates'],
 ['Memory and Devices', 'मेमोरी और उपकरण', 'Primary and secondary memory; Input and output devices'],
 ['Software and OS', 'सॉफ़्टवेयर और OS', 'System and application software; Operating system functions'],
 ['Internet and Security', 'इंटरनेट और सुरक्षा', 'Networks; Internet services; Viruses and security']],
};
