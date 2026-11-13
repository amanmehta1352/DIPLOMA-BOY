// Design profiles: HOW a book is written, decided by who reads it (level) and what it is for (course / exam / lab / project).
// Every book in books.json points to one profile id. The AI writer reads the profile before writing a single chapter.
// Fields: reader, language, depth, chapter (length + structure), blocks (minimum per chapter), questions, styles (editions to make, in order).

export const PROFILES = {
  // ---------------- school ----------------
  'school-6-8': {
    hi: 'कक्षा 6-8 (मिडिल स्कूल)', reader: 'age 11-14, first contact with the subject; many read Hindi better than English',
    language: 'very simple Hindi first (class-6 vocabulary), English beside it; short sentences (max ~15 words); define every new word',
    depth: 'concepts through daily-life things (kitchen, farm, bicycle, market); no derivations; numbers only for simple calculations',
    chapter: '900-1500 words. h → story/observation opener → 3-5 concept sections (h + p + key) → "करके देखें" activity (note tip) → summary key list → exercise',
    blocks: { h: 4, p: 6, key: 4, ex: 2, mcq: 8, note: 2, table: 1 },
    questions: '8 MCQ (one idea each), 4 fill-in/very-short in ex blocks, 1 activity; difficulty easy 70% / medium 30%',
    styles: ['textbook', 'practice', 'revision'],
  },
  'school-9-10': {
    hi: 'कक्षा 9-10 (बोर्ड परीक्षा)', reader: 'age 14-16 preparing for the state / CBSE board exam; also polytechnic entrance',
    language: 'simple standard Hindi + English, board-exam terms in both languages (e.g. "अपवर्तन (Refraction)")',
    depth: 'full board syllabus depth; definitions, laws, labelled-diagram descriptions, numericals with units; short derivations where the board asks them',
    chapter: '1800-3000 words. intro → topic sections (h, p, key, formula) → in-text questions (ex) after each section → solved numericals → chapter summary → board-style exercise (1/2/3/5-mark)',
    blocks: { h: 6, p: 10, key: 6, formula: 2, ex: 6, mcq: 12, note: 3, table: 1 },
    questions: '12 MCQ incl. assertion-reason, 6 solved examples, exercise with 1-mark, 2-mark, 3-mark, 5-mark items; easy 40 / medium 45 / hard 15',
    styles: ['textbook', 'exam', 'practice', 'revision'],
  },
  'school-11-12': {
    hi: 'कक्षा 11-12 (विज्ञान / कॉमर्स / कला)', reader: 'age 16-18; board exam plus entrance exams (JEE / NEET / CUET)',
    language: 'standard Hindi + English, technical words always in both; formulas in standard notation',
    depth: 'board depth plus entrance bridge: derivations, graphs, multi-step numericals (science); journal entries / case studies (commerce); source-based analysis (arts)',
    chapter: '2500-4000 words. concept sections with derivation/explanation → solved examples (easy→hard) → "entrance corner" note(exam) → summary → exercise',
    blocks: { h: 7, p: 12, key: 6, formula: 4, ex: 8, mcq: 15, note: 4, table: 2 },
    questions: '15 MCQ (incl. multi-concept), 8 solved examples, board-pattern long answers; easy 30 / medium 45 / hard 25',
    styles: ['textbook', 'exam', 'practice', 'reference'],
  },
  // ---------------- technical courses ----------------
  'iti-trade': {
    hi: 'ITI ट्रेड', reader: '10th-pass trainee learning a trade by hand; reads Hindi first',
    language: 'plain workshop Hindi with the English trade name of every tool / part (as said on the shop floor)',
    depth: 'what it is → how it works → how to use it safely → common faults; numbers only for measurement and simple trade calculation',
    chapter: '1000-1800 words. safety first (note warn) → tool/part description (table of parts) → step-by-step procedure (numbered p) → precautions → trade theory MCQ',
    blocks: { h: 4, p: 8, key: 4, table: 2, note: 3, ex: 2, mcq: 10 },
    questions: '10 MCQ in NCVT CBT style, 2 trade-calculation examples',
    styles: ['textbook', 'practice', 'revision'],
  },
  'diploma-theory': {
    hi: 'डिप्लोमा (पॉलिटेक्निक) थ्योरी', reader: '10th/12th-pass polytechnic student, semester exam + later JE exams',
    language: 'Hindi + English side by side; every technical term in English as written in the question paper',
    depth: 'AICTE outcome level: working principle, construction, diagram description, simple derivation, SI-unit numericals, applications, merits/demerits',
    chapter: '2000-3500 words per unit. learning outcomes (key) → topics as h → principle/construction/working → solved numericals → comparison table → semester questions (2/5/10 mark) → JE corner MCQ',
    blocks: { h: 6, p: 10, key: 5, formula: 3, ex: 5, mcq: 10, note: 3, table: 2 },
    questions: '5 solved numericals, semester-pattern short/long questions, 10 JE-style MCQ; easy 35 / medium 45 / hard 20',
    styles: ['textbook', 'teacher', 'exam', 'revision'],
  },
  'btech-theory': {
    hi: 'बी.टेक / बी.ई. थ्योरी', reader: 'engineering undergraduate; university exam + GATE / ESE / PSU',
    language: 'English-first technical writing with Hindi explanation; standard symbols and notation',
    depth: 'full derivations, design equations, assumptions and limitations, multi-step numericals, standard data tables',
    chapter: '3000-5000 words per unit. objectives → theory with derivations → worked problems (graded) → design notes → summary of equations → university questions → GATE-level MCQ/NAT',
    blocks: { h: 7, p: 12, key: 5, formula: 6, ex: 8, mcq: 12, note: 3, table: 2 },
    questions: '8 worked problems, 12 GATE-style MCQ/NAT; easy 20 / medium 50 / hard 30',
    styles: ['textbook', 'reference', 'exam', 'practice'],
  },
  'lab-manual': {
    hi: 'लैब / प्रैक्टिकल / ड्रॉइंग', reader: 'student doing the practical in the lab or drawing hall',
    language: 'instructions in Hindi + English, short imperative steps',
    depth: 'one chapter = one experiment / drawing sheet: aim, apparatus, theory (short), procedure, observation table, calculation, result, precautions, viva',
    chapter: '700-1200 words per experiment. aim (key) → apparatus (table) → theory (p + formula) → procedure (numbered p) → observation table (table with empty rows) → sample calculation (ex) → result → precautions (note warn) → viva voce (mcq)',
    blocks: { h: 1, key: 2, table: 2, p: 4, formula: 1, ex: 1, note: 1, mcq: 5 },
    questions: '5 viva MCQ per experiment',
    styles: ['textbook', 'practice'],
  },
  'project-guide': {
    hi: 'प्रोजेक्ट / इंटर्नशिप / सेमिनार', reader: 'student who must plan, do and report a project or internship',
    language: 'Hindi + English, checklist style',
    depth: 'how to choose a topic, plan, keep a diary, write the report, prepare slides, face the viva; sample (original) project ideas for the branch',
    chapter: '6-8 chapters: choosing a topic → planning & timeline (table) → doing the work / diary → report format → presentation → viva → 20 sample ideas',
    blocks: { h: 4, p: 6, key: 4, table: 2, note: 3, ex: 2 },
    questions: 'viva practice questions (ex blocks), no MCQ needed',
    styles: ['teacher'],
  },
  // ---------------- other degrees ----------------
  'ug-science': {
    hi: 'स्नातक विज्ञान / BCA / MCA / कृषि', reader: 'graduate student; university exam + later NET / govt exams',
    language: 'English-first academic writing with Hindi explanation',
    depth: 'university depth: theory, derivations or algorithms (code as plain text in p blocks), worked problems, diagrams described',
    chapter: '2500-4500 words per unit. objectives → theory → worked examples → summary → university questions → MCQ',
    blocks: { h: 6, p: 12, key: 5, formula: 3, ex: 6, mcq: 10, note: 2, table: 2 },
    questions: '6 worked examples, 10 MCQ; easy 25 / medium 50 / hard 25',
    styles: ['textbook', 'reference', 'exam'],
  },
  'ug-commerce': {
    hi: 'B.Com / BBA / MBA', reader: 'commerce / management student',
    language: 'Hindi + English; accounting and business terms in English as used in practice',
    depth: 'concepts + formats: journal/ledger/statements as table blocks, ratio formulas, case studies (original, invented companies)',
    chapter: '2500-4000 words. concept → format (table) → solved illustration (ex) → case study (note) → summary → questions',
    blocks: { h: 6, p: 10, key: 5, formula: 2, ex: 6, mcq: 10, note: 2, table: 4 },
    questions: '6 solved illustrations, 10 MCQ, 2 case questions',
    styles: ['textbook', 'practice', 'exam'],
  },
  'ug-arts': {
    hi: 'B.A. / कला', reader: 'humanities student; university exam + civil-services foundation',
    language: 'clear Hindi first, English terms in brackets',
    depth: 'themes, causes and effects, timelines (table), thinkers and their ideas in your own words, analytical answers',
    chapter: '2500-4000 words. background → main themes (h + p) → timeline/comparison table → analysis → summary → long-answer questions',
    blocks: { h: 6, p: 14, key: 5, ex: 4, mcq: 10, note: 2, table: 2 },
    questions: '10 MCQ, 4 model long answers (ex)',
    styles: ['textbook', 'reference', 'revision'],
  },
  'law': {
    hi: 'LL.B. / कानून', reader: 'law student; semester exam + judiciary / CLAT-PG',
    language: 'English legal terms with clear Hindi explanation; section numbers stated, never bare-act text copied',
    depth: 'provision → meaning in own words → essentials → exceptions → leading principles (case names may be cited, facts summarised in own words) → problem questions',
    chapter: '3000-4500 words. introduction → provisions explained → essentials (key) → illustrations (ex, invented facts) → comparison table → problem questions',
    blocks: { h: 6, p: 12, key: 6, ex: 6, mcq: 10, note: 3, table: 2 },
    questions: '6 problem illustrations, 10 MCQ',
    styles: ['textbook', 'exam', 'revision'],
  },
  'medical': {
    hi: 'MBBS / नर्सिंग / फ़ार्मेसी', reader: 'health-science student; university exam + NEET PG / NORCET / GPAT',
    language: 'English medical terms (standard spelling) with Hindi explanation',
    depth: 'structure/function, mechanism, clinical relevance, drug classes and doses as general education only; tables for comparisons; no treatment advice for real patients',
    chapter: '3000-5000 words. objectives → topic sections → clinical note (note exam) → comparison tables → summary → MCQ (clinical vignette style, invented patients)',
    blocks: { h: 7, p: 12, key: 6, ex: 4, mcq: 15, note: 3, table: 3 },
    questions: '15 MCQ incl. vignettes, 4 short-answer models',
    styles: ['textbook', 'exam', 'revision'],
  },
  'education': {
    hi: 'D.El.Ed. / B.Ed.', reader: 'teacher trainee; course exam + CTET / TET',
    language: 'Hindi first, English terms in brackets',
    depth: 'theories of learning and child development in own words, classroom examples, lesson-plan formats (table), assessment',
    chapter: '2000-3500 words. concept → theorist ideas in own words → classroom example (ex) → table → summary → CTET-style MCQ',
    blocks: { h: 6, p: 10, key: 5, ex: 4, mcq: 12, note: 2, table: 2 },
    questions: '12 CTET-pattern MCQ (pedagogy-based)',
    styles: ['textbook', 'exam', 'revision'],
  },
  // ---------------- competitive-exam shelves (shared by many exams of one level) ----------------
  'exam-basic': {
    hi: 'सरकारी परीक्षा — सामान्य स्तर (SSC, रेलवे, पुलिस, TET)', reader: '10th/12th/graduate aspirant; speed + accuracy in a CBT',
    language: 'Hindi + English (papers are bilingual); short crisp points',
    depth: 'concept in 1-2 paragraphs → rules/formulas → shortcut tricks → solved MCQs in exam pattern → common traps',
    chapter: '1500-2500 words. concept → formula/rule list → trick notes → 8-10 solved examples → 20 practice MCQ with explanation',
    blocks: { h: 4, p: 6, key: 6, formula: 3, ex: 8, mcq: 20, note: 3, table: 1 },
    questions: '20 MCQ (original, pattern-like, never copied PYQ text); easy 40 / medium 45 / hard 15',
    styles: ['exam', 'practice', 'revision', 'teacher'],
  },
  'exam-technical': {
    hi: 'तकनीकी परीक्षा (JE, ALP, Technician, PSU, GATE/ESE)', reader: 'diploma / B.Tech / ITI candidate for a technical post',
    language: 'English technical terms with Hindi explanation; standard symbols',
    depth: 'core concept → key formulas with units → standard values → solved numericals → conceptual MCQs; GATE/ESE books one notch deeper',
    chapter: '2000-3000 words. concept recap → formula sheet (formula blocks) → standard data table → 10 solved problems → 25 MCQ',
    blocks: { h: 5, p: 6, key: 6, formula: 6, ex: 10, mcq: 25, note: 3, table: 2 },
    questions: '25 MCQ (numerical + conceptual); easy 30 / medium 50 / hard 20',
    styles: ['exam', 'practice', 'revision', 'textbook'],
  },
  'exam-banking': {
    hi: 'बैंकिंग / बीमा', reader: 'graduate aspirant; very time-bound prelims + mains',
    language: 'English-first (banking papers) with Hindi help',
    depth: 'speed methods, data interpretation sets (table blocks), puzzles, banking awareness',
    chapter: '1500-2500 words. method → shortcuts → solved sets → 20 practice MCQ with time target',
    blocks: { h: 4, p: 5, key: 5, formula: 2, ex: 8, mcq: 20, note: 3, table: 3 },
    questions: '20 MCQ incl. DI / puzzle sets',
    styles: ['exam', 'practice', 'revision'],
  },
  'exam-defence': {
    hi: 'रक्षा (NDA, CDS, AFCAT, अग्निवीर)', reader: '12th-pass / graduate defence aspirant',
    language: 'Hindi + English',
    depth: 'NDA/CDS depth for maths & science (class 11-12 level), GK with defence focus',
    chapter: '1800-2800 words. concept → formulas → solved examples → 20 MCQ',
    blocks: { h: 5, p: 7, key: 5, formula: 3, ex: 6, mcq: 20, note: 2, table: 1 },
    questions: '20 MCQ; easy 30 / medium 50 / hard 20',
    styles: ['exam', 'practice', 'revision'],
  },
  'exam-civil-services': {
    hi: 'सिविल सेवा (UPSC, राज्य PSC)', reader: 'graduate aspirant; prelims MCQ + mains answer writing',
    language: 'Hindi + English, analytical tone',
    depth: 'concepts with background, linkages across topics, data tables, multi-statement MCQs, model mains answers',
    chapter: '3000-4500 words. background → core concepts → linkages (note) → tables/timelines → 15 multi-statement MCQ → 2 model mains answers (ex)',
    blocks: { h: 6, p: 14, key: 6, ex: 3, mcq: 15, note: 3, table: 3 },
    questions: '15 MCQ (statement-type), 2 mains model answers',
    styles: ['textbook', 'exam', 'revision', 'reference'],
  },
  'exam-entrance': {
    hi: 'प्रवेश परीक्षा (JEE, NEET, CUET, पॉलिटेक्निक, सैनिक स्कूल)', reader: 'school student aiming for admission',
    language: 'Hindi + English; formulas standard',
    depth: 'level of the entrance: polytechnic/sainik = class 9-10, CUET/NEET/JEE Main = class 11-12, JEE Advanced = multi-concept',
    chapter: '2500-4000 words. concept recap → formulas → graded solved problems → 25 MCQ / numerical',
    blocks: { h: 6, p: 8, key: 5, formula: 5, ex: 10, mcq: 25, note: 3, table: 1 },
    questions: '25 questions; easy 25 / medium 50 / hard 25',
    styles: ['exam', 'practice', 'textbook', 'revision'],
  },
  'exam-health': {
    hi: 'स्वास्थ्य भर्ती (NORCET, फ़ार्मासिस्ट, NEET PG, GPAT)', reader: 'nursing / pharmacy / MBBS graduate',
    language: 'English medical terms with Hindi help',
    depth: 'high-yield facts, tables, clinical vignette MCQs (invented patients)',
    chapter: '2000-3000 words. high-yield points → tables → 25 MCQ with explanation',
    blocks: { h: 5, p: 6, key: 8, ex: 3, mcq: 25, note: 3, table: 3 },
    questions: '25 MCQ',
    styles: ['exam', 'revision', 'practice'],
  },
  'exam-law-mgmt': {
    hi: 'लॉ / मैनेजमेंट प्रवेश और न्यायिक सेवा (CLAT, CAT, Judiciary)', reader: '12th-pass / graduate aspirant',
    language: 'English-first with Hindi help',
    depth: 'passage-based reasoning, legal principles applied to invented facts, quant shortcuts',
    chapter: '2000-3000 words. method → solved passages → 20 practice questions',
    blocks: { h: 4, p: 8, key: 5, ex: 6, mcq: 20, note: 2, table: 1 },
    questions: '20 passage-based MCQ',
    styles: ['exam', 'practice', 'revision'],
  },
  'exam-research': {
    hi: 'शोध / NET', reader: 'post-graduate candidate (UGC NET, CSIR NET)',
    language: 'English-first academic',
    depth: 'postgraduate depth; research aptitude, teaching aptitude, subject depth',
    chapter: '3000-4500 words. concepts → frameworks (table) → 20 MCQ',
    blocks: { h: 6, p: 12, key: 5, formula: 2, ex: 4, mcq: 20, note: 2, table: 2 },
    questions: '20 MCQ; medium 50 / hard 50',
    styles: ['textbook', 'exam'],
  },
};

// course book -> profile
export function courseProfile(q, kind) {
  if (kind === 'lab') return 'lab-manual';
  if (kind === 'project') return 'project-guide';
  const s = q.slug;
  if (/^class-(6|7|8)$/.test(s)) return 'school-6-8';
  if (/^class-(9|10)$/.test(s)) return 'school-9-10';
  if (/^class-11-12/.test(s)) return 'school-11-12';
  if (q.cat === 'iti') return 'iti-trade';
  if (/^diploma-(mechanical|civil|electrical|electronics|computer|automobile)$/.test(s)) return 'diploma-theory';
  if (/^btech-/.test(s)) return 'btech-theory';
  if (['diploma-pharmacy', 'diploma-nursing', 'bsc-nursing', 'bpharm', 'mbbs'].includes(s)) return 'medical';
  if (['diploma-deled', 'bed'].includes(s)) return 'education';
  if (s === 'llb') return 'law';
  if (['bcom', 'bba', 'mba'].includes(s)) return 'ug-commerce';
  if (s === 'ba') return 'ug-arts';
  return 'ug-science';   // bsc, bca, mca, bsc-agriculture
}

// exam shelf (level) -> profile
export function examProfile(level, cats) {
  if (level === 'govt_technical') return 'exam-technical';
  if (level === 'banking') return 'exam-banking';
  if (level === 'govt_defence') return 'exam-defence';
  if (level === 'state_psc' || level === 'upsc_civil') return 'exam-civil-services';
  if (level === 'medical') return cats.has('entrance') ? 'exam-entrance' : 'exam-health';   // NEET UG science vs NORCET / GPAT
  if (level === 'law_management') return 'exam-law-mgmt';
  if (level === 'advanced_research') return 'exam-research';
  if (['engineering', 'class_9_10', 'class_6_8', 'class_11_12_sci'].includes(level)) return 'exam-entrance';
  if (level === 'graduation_sci') return 'exam-banking';   // agriculture officer (IBPS AFO) papers
  return 'exam-basic';
}
