# Library + Book Styles · Architecture (v1, draft)

लक्ष्य: छात्र अपनी कक्षा → विषय चुने, फिर **किताब की शैली** चुने — जैसी किताब उसे पसंद है — और पूरा अध्याय उसी शैली में पढ़े। Phone, laptop और desktop तीनों पर।
नमूना design: [`design/library.html`](../design/library.html) · किताब की बनावट: [BOOK_ANATOMY.md](BOOK_ANATOMY.md)

---

## 1. सबसे ज़रूरी फ़ैसला: "NCERT / लेखक 1 / लेखक 2" नाम से नहीं, **शैली (style)** से
| आपका विचार | क्या समस्या है | हम क्या करेंगे |
|---|---|---|
| "NCERT" बटन, अंदर NCERT जैसी किताब | NCERT की सामग्री और उसका नाम/रूप NCERT का है। हमारी लिखी किताब पर "NCERT" लिखना छात्र को गुमराह करेगा और नाम-चिह्न का दुरुपयोग होगा | **(क)** "आधिकारिक NCERT किताब" — सीधे NCERT की अपनी मुफ़्त वेबसाइट का link (हम copy नहीं रखते)। **(ख)** हमारी अपनी "सरल पाठ्यपुस्तक शैली" — वही आम बनावट (खंड, क्रियाकलाप, प्रश्न), हमारे शब्दों में |
| "लेखक 1, 2, 3…" — हर प्रसिद्ध लेखक जैसी किताब | किसी जीवित लेखक/प्रकाशक का नाम या हूबहू रूप लेना = उनकी पहचान की नक़ल; copyright-मुक्त "उसी जैसा" भी जोखिम है | लेखकों के नाम की जगह **शैली के नाम**, जो बताते हैं कि किताब *कैसी* है (नीचे 5 शैलियाँ)। छात्र अपनी पसंद का "तरीका" चुनता है, लेखक नहीं |

यह बात छात्र के लिए भी बेहतर है: "लेखक 3" से उसे कुछ पता नहीं चलता, "अभ्यास-प्रधान" से तुरंत पता चलता है कि किताब कैसी है।

## 2. पाँच शैलियाँ (हर level/विषय में यही 5; हर एक अलग पढ़ने का तरीका)
| कोड | नाम | किसके लिए | किताब में क्या ज़्यादा |
|---|---|---|---|
| `saral` | 📗 सरल पाठ्यपुस्तक | पहली बार पढ़ने वाला | छोटे खंड, रोज़मर्रा उदाहरण, क्रियाकलाप, बीच-बीच में प्रश्न |
| `vistar` | 📘 विस्तृत व्याख्या | गहराई से समझने वाला | पूरी व्युत्पत्ति, "क्यों", ज़्यादा चित्र, side-notes |
| `abhyas` | 📙 अभ्यास-प्रधान | board/परीक्षा की तैयारी | हर खंड के बाद हल किए उदाहरण + स्तर-वार प्रश्न (आसान→कठिन), पूरी उत्तरमाला |
| `pariksha` | 📕 परीक्षा-केंद्रित | JE/SSC/प्रतियोगी | सूत्र-तालिका, shortcut, PYQ-शैली MCQ, समय-बचत तरीके (PYQ सिर्फ़ हमारे official स्रोत से) |
| `chitra` | 📒 चित्र-प्रधान | देखकर समझने वाला | हर अवधारणा एक बड़े labelled चित्र/flow से, कम पाठ |

हर level-परिवार में डिफ़ॉल्ट: कक्षा 6-10 → `saral` · 11-12 → `vistar` · Diploma → `abhyas` · JE/SSC → `pariksha`।

## 3. मूल विचार: **एक सत्यापित सामग्री, कई शैलियाँ** (काम 5 गुना नहीं होता)
```
अध्याय-कोर (एक बार लिखा, जाँचा, approve)          ← तथ्य, परिभाषाएँ, सूत्र, चित्र, उदाहरण-बैंक, प्रश्न-बैंक
      │
      ├── शैली-परत saral   (क्रम + भाषा-स्तर + कौन-से उदाहरण/प्रश्न + क्रियाकलाप)
      ├── शैली-परत vistar  (+ व्युत्पत्ति, + "क्यों" पैराग्राफ)
      ├── शैली-परत abhyas  (+ प्रश्न-सीढ़ी, + उत्तरमाला)
      ├── शैली-परत pariksha(+ सूत्र-तालिका, + shortcut, + MCQ)
      └── शैली-परत chitra  (+ बड़े चित्र, पाठ छोटा)
```
- **कोर** में ग़लती = एक जगह ठीक, सब शैलियों में ठीक।
- शैली-परत ज़्यादातर **code से** बनती है (कौन-सा हिस्सा, किस क्रम में, कितना); AI सिर्फ़ शैली के लिए अतिरिक्त हिस्से लिखता है (जैसे `vistar` की व्युत्पत्ति, `pariksha` के shortcut)।
- Review: आप कोर को approve करते हैं (सबसे ज़रूरी), फिर हर शैली का छोटा अतिरिक्त हिस्सा।

## 4. Library का पेड़ (छात्र कैसे पहुँचता है)
```
Library
 └─ Level / Course       (कक्षा 10 · Diploma Mechanical · JE Civil …)      ← mtb.qualifications
     └─ Stage            (सेमेस्टर 3 · कक्षा 10)                           ← mtb.course_subjects.stage
         └─ विषय (Book)   (विज्ञान · Strength of Materials)                 ← course_subjects / subject_units (mode=book)
             ├─ आधिकारिक किताब   → बाहरी link (NCERT/बोर्ड की अपनी साइट)       ← नया: official_books
             └─ शैली चुनें        saral · vistar · abhyas · pariksha · chitra   ← नया: book_styles
                 └─ अध्याय-सूची → Reader (Book · Notes · Teach · Formula tabs)
```
छात्र की चुनी शैली याद रहती है (profiles में `book_style`); हर अध्याय में ऊपर से शैली बदल सकता है।

## 5. Data model (additive migrations)
| Table | मुख्य columns | काम |
|---|---|---|
| `book_styles` | `code` PK, `name_hi`, `name_en`, `icon`, `blurb`, `sort`, `active` | 5 शैलियों की सूची |
| `chapter_cores` | `chapter_id`, `level_family`, `data jsonb` (schema `book.core.v1`), `status`, `checks` | सत्यापित कोर (आज के `chapter_drafts` का अगला रूप) |
| `chapter_styles` | `chapter_id`, `level_family`, `style`, `data jsonb` (`book.style.v1`), `status`, `checks` | शैली-परत; `status = approved` होने पर ही दिखे |
| `official_books` | `qual_slug`, `subject_slug`, `publisher`, `title`, `url`, `verified_at` | सिर्फ़ आधिकारिक, मुफ़्त link — हम फ़ाइल नहीं रखते |
| `profiles.book_style` | text | छात्र की पसंद |
Owner gate (0173) वैसे ही: robot सिर्फ़ draft लिखता है; versions + rollback हर table पर।

## 6. Robot pipeline में बदलाव
1. Writer → `chapter_cores` (एक बार प्रति अध्याय-परिवार)।
2. Code checks + दूसरी AI (वैसे ही) → owner review (कोर)।
3. Style-builder → हर शैली का ढाँचा code से; सिर्फ़ ज़रूरी अतिरिक्त हिस्से AI से → छोटे checks → owner review (शैली)।
4. Renderer: `core + style` → HTML (हर शैली का अपना layout नियम, एक ही design system)।

## 7. Screens (desktop, laptop, phone)
| Screen | Desktop/Laptop (≥1024px) | Phone (360-412px) |
|---|---|---|
| Library home | बाईं sidebar (Library · मेरी किताबें · Practice · Progress) + ऊपर खोज + "पढ़ना जारी रखें" + level cards का grid | ऊपर खोज, cards एक कॉलम, नीचे tab bar |
| Level → विषय | breadcrumb + विषयों की cards (भराव % के साथ) | सूची |
| विषय → शैली | **शैली cards पर छोटा preview पन्ना** (असली नमूना), "आधिकारिक किताब" card अलग, बाहरी link चिह्न के साथ | cards एक कॉलम |
| Reader | **3 कॉलम**: बाएँ अध्याय/खंड-सूची · बीच में काग़ज़-पन्ना (≤ 72 अक्षर) · दाएँ सूत्र/याद रखें/progress; ऊपर tabs Book·Notes·Teach·Formula + शैली बदलने का menu | एक कॉलम; सूची और सूत्र नीचे से खुलने वाली sheets में |
App shell गहरा (मौजूदा aurora brand), पर **पढ़ने का पन्ना हमेशा काग़ज़-रंग** — लंबे समय पढ़ने में आँखों पर हल्का।

## 8. Visual जाँच (हर बदलाव पर)
- Playwright screenshots: 360 · 390 · 820 · 1280 · 1536 px, light/dark — मौजूदा `tests/` में जोड़ना।
- कोई horizontal scroll नहीं; बटन ≥ 44px; पन्ने का पाठ ≥ 16px; contrast ≥ 4.5:1 (code से)।
- Reader में keyboard: ←/→ अगला खंड, `/` खोज।

## 9. क्रम (क्या पहले)
1. यह design (`design/library.html`) आप देखें, बदलाव बताएँ।
2. Migration: `book_styles`, `official_books`, `profiles.book_style`।
3. एक विषय (कक्षा 10 विज्ञान या Diploma Mechanical का एक विषय) पर 2 शैलियाँ (`saral`, `abhyas`) — pilot।
4. फिर बाकी शैलियाँ और विषय।

## 10. Pilot की स्थिति (2026-11-13)
- ✅ Migration 0175 live: `book_styles` (5), `official_books` (खाली), `profiles.book_style`, `get_book_shelf()`।
- ✅ कोर का ढाँचा: [`schema/book.core.v1.json`](../schema/book.core.v1.json)। पहला कोर: [`content/pilot/class-10-science-electricity.core.json`](../content/pilot/class-10-science-electricity.core.json) (6 खंड, 18 हल उदाहरण, 3 चित्र, 29 प्रश्न)।
- ✅ जाँच: `node tools/book/check.js <core>` — हर उदाहरण/आंकिक का उत्तर `calc` से दोबारा गणना, MCQ उत्तर, Markdown/LaTeX, चित्र-संदर्भ।
- ✅ शैली-परत code से: [`tools/book/styles.js`](../tools/book/styles.js) (saral, abhyas) + [`tools/book/render.js`](../tools/book/render.js) → `design/pilot/electricity-{saral,abhyas}.html`; एक ही input से हर बार हूबहू वही HTML।
- ✅ Migration 0176 live: `chapter_cores` (owner gate 0173 जैसा: robot सिर्फ़ draft, versions + rollback), RPCs `core_upsert` (service) · `core_review_list/get` · `core_decide` · `core_versions_list` · `core_rollback` (review code) · `list_chapter_cores` · `get_chapter_core` (छात्र, सिर्फ़ approved)। `chapter_styles` अभी नहीं: saral/abhyas पूरी तरह code से बनती हैं।
- ✅ Pilot कोर server पर **draft** (`tools/book/upload.js` से; md5 local फ़ाइल से मिलाया)।
- ✅ Owner review: Control Room → Review → **📚 किताब** (`control/books.js`): पन्ना वैसा ही जैसा छात्र देखेगा, शैली बदलकर; जाँच वहीं browser में दोबारा चलती है; गलती हो तो ✅ बटन नहीं।
- ✅ छात्र का Reader: [`book-reader.html`](../book-reader.html)`?q=class-10&s=science` — अध्याय + शैली चुनें, पसंद याद रहती है; सिर्फ़ approved core दिखता है।
- ✅ Book Core Writer robot: [`robots/book/core_writer.py`](../robots/book/core_writer.py) + prompt [`prompts/book-core.v1.md`](../prompts/book-core.v1.md) + सूची [`robots/book/queue.json`](../robots/book/queue.json)।
  - लिखता: free AI (Writer robot वाले ही providers)।
  - जाँच: `check.js`, दूसरी AI (MCQ + आंकिक बिना उत्तर देखे), हिंदी, copyright। फेल होने पर code की गलतियाँ लेकर एक बार फिर लिखता है।
  - फिर भी फेल: server पर कुछ नहीं जाता। पास: सिर्फ़ draft।
  - आप "बदलाव माँगो" दबाएँ तो आपकी टिप्पणी prompt में जाती है। Approved core को robot छू नहीं सकता।
  - चलाना: GitHub Actions → "Book Core Writer" (अभी सिर्फ़ हाथ से; पहले dry run)। Offline जाँच: `python robots/book/selftest.py` (Tests workflow में भी)।
- ✅ Migration 0177 `core_status()` (service-only): robot देखता है कौन-सा core पहले से है। जब तक यह नहीं लगी, robot सिर्फ़ `--only` वाले core लिखता है।
- ✅ App की Library: विषय खोलने पर, अगर उसका कोई core approved है, तो "📚 नई किताब: अपनी पसंद की शैली में पढ़ें" link (`book-reader.html?q=&s=`)। कोई approved नहीं तो link नहीं दिखता। Playwright जाँच `tests/app.test.js` में (नकली server जवाब से)।
- ⏳ बाकी: pilot कोर आप approve करें; robot का पहला dry run; बाकी शैलियाँ (vistar, pariksha, chitra); आधिकारिक किताबों के सत्यापित link।
