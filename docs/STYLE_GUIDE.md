# Style Guide · Diploma Boy (v2)

हर robot, हर reviewer और render engine यही नियम मानते हैं। जो नियम code से जाँचा जाता है उस पर **[code]** लिखा है; बाकी Reviewer-B जाँचता है **[AI]**।
पुराना सार: `robots/STYLE.md` (v1) — यह दस्तावेज़ उसे बढ़ाता है, बदलता नहीं।

---

## 1. सबके लिए एक-से नियम

### 1.1 भाषा
- सरल हिंदी; तकनीकी शब्द पहली बार कोष्ठक में English: `वेग (velocity)` **[AI]**।
- हर teaching section में देवनागरी बहुमत **[code: `hindi_ok`]**।
- वाक्य छोटे: औसतन ≤20 शब्द। पूर्णविराम `।`।
- "Correct!", "सही उत्तर" जैसे शब्द नहीं; app खुद सही option गोल करता है।

### 1.2 गणित notation **[code]**
| लिखो | app दिखाएगा | मना |
|---|---|---|
| `a/b`, `(a + b)/(c - d)` | खड़ी भिन्न | `\frac`, `$$`, HTML |
| `×` | × | `*` |
| `x^2`, `(1 + R/100)^n` | घात | `x**2` |
| `sqrt(x)` | √x | `\sqrt` |
| `m/s`, `kN/m^2` | इकाई साथ में | इकाई छोड़ना |

### 1.3 हल का एक ही रूप (notebook steps) **[code + AI]**
- हर step एक पंक्ति, असली संख्याओं के साथ: `माना मूलधन = 100`, `SI = 5200 - 4000 = 1200`।
- क्रम: दिया है → ज्ञात करना है → इकाई बदलो → सूत्र → मान रखो → उत्तर (इकाई + सार्थक अंक) → जाँच (क्या उत्तर समझ में आता है)।
- आखिरी step वही मान निकाले जो `answer` / सही option में है **[code]**।
- हर solved में `check: {expr, value, tol}` **[code: safe-eval]**।

### 1.4 सच्चाई
- कोई formula, मान, स्रोत, exam-weightage गढ़ा नहीं जाएगा।
- अनिश्चित = `verify[]` में, साथ में क्या जाँचना है।
- स्रोत सिर्फ़ `sources/registry.json` के IDs से **[code]**।
- स्रोत के 8+ लगातार शब्द नहीं; copyright overlap ≤20% **[code: `copyright_score`]**।

---

## 2. रंग-प्रणाली (color coding)

### 2.1 अर्थ-रंग — पूरे app में स्थिर
रंग अकेला अर्थ नहीं देता; हर block के साथ icon + शीर्षक भी होता है।

| अर्थ | Block | Icon | Header पाठ | Header पृष्ठ | Border |
|---|---|---|---|---|---|
| 🟦 परिचय / परिभाषा | `definition` | 📘 | `#1d4ed8` | `#eff6ff` | `#3b82f6` |
| 🟩 प्रकार / नियम / सुधार | `types`, `rule` | 🧩 | `#047857` | `#ecfdf5` | `#10b981` |
| 🟧 अनुप्रयोग / रूपांतरण / उदाहरण | `application`, `example` | ⚙️ | `#b45309` | `#fffbeb` | `#f59e0b` |
| 🟪 आरेख / व्युत्पत्ति / प्रमाण | `figure`, `derivation`, `proof` | 📐 | `#6d28d9` | `#f5f3ff` | `#8b5cf6` |
| 🟥 आम गलतियाँ / सावधानी / अभ्यास | `mistake`, `caution`, `practice` | ⚠️ | `#b91c1c` | `#fef2f2` | `#ef4444` |
| 🟨 सूत्र / याद रखो | `formula`, `remember` | ✳️ | `#0f172a` | `#fde68a` | `#f59e0b` |
| ⬜ Insight (हटकर बात) | `insight` | 💡 | `#0f766e` | `#f0fdfa` | `#14b8a6` |

### 2.2 Contrast (WCAG, गणना की गई 12 Nov 2026)
| जोड़ी | अभी | नया |
|---|---|---|
| Blue header | `#3b82f6` / `#eff6ff` = 3.38 ❌ | `#1d4ed8` = **6.16** ✅ |
| Green header | `#10b981` / `#ecfdf5` = 2.41 ❌ | `#047857` = **5.21** ✅ |
| Orange header | `#f59e0b` / `#fffbeb` = 2.07 ❌ | `#b45309` = **4.84** ✅ |
| Purple header | `#8b5cf6` / `#f5f3ff` = 3.86 ❌ | `#6d28d9` = **6.48** ✅ |
| Red header | `#ef4444` / `#fef2f2` = 3.44 ❌ | `#b91c1c` = **5.91** ✅ |
| Body `#e2e8f0` / bg `#0f172a` | 14.48 ✅ | वही |
| Muted `#94a3b8` / card `#1e293b` | 5.71 ✅ | वही |
| Accent `#5eead4` / bg | 12.07 ✅ | वही |

| Insight `#0f766e` / `#f0fdfa` | — | **5.25** ✅ |
| Formula `#0f172a` / `#fde68a` | — | **14.33** ✅ |

(पुराने हल्के रंग border के लिए ठीक हैं — graphic को 3:1 चाहिए; छोटा पाठ उनमें नहीं।) Render test में यही गणना code से दोहराई जाएगी।

### 2.3 Shell tokens (fixed, `book.html` से)
`--bg #0f172a` · `--card #1e293b` · `--card2 #243449` · `--heading #60a5fa` · `--accent #5eead4` · `--highlight #fde68a` · `--text #e2e8f0` · `--muted #94a3b8` · `--line #334155`।
Chapter अपना **accent** बदल सकता है (layout seed से), पर ऊपर के अर्थ-रंग नहीं।

### 2.4 Typography और आकार
- Font stack: `'Noto Sans Devanagari', 'Inter', system-ui, sans-serif` (offline fallback; बाहरी font नहीं)।
- Body ≥15px (Notes 15, Book 16, Board 17); caption/label ≥13px; line-height 1.6 (हिंदी के लिए)।
- 360px पर horizontal scroll नहीं; tables पतली स्क्रीन पर "card list" में बदलें।

---

## 3. Mode 1 · 📖 Book (किताब) — विस्तृत आख्यान
**उद्देश्य:** छपी पाठ्यपुस्तक जैसा पूरा अध्याय, जिसे शुरू से अंत तक पढ़ा जाए।

| तत्व | नियम |
|---|---|
| खुलना | 2–3 वाक्य का hook: रोज़ की ज़िंदगी या diploma workshop/site का सच्चा उदाहरण |
| क्रम | numbered sections `1.1, 1.2 …`: परिभाषा → नियम/सिद्धांत → कारण (क्यों) → छोटा उदाहरण → सीमाएँ |
| पैराग्राफ | 3–5 वाक्य; हर पैराग्राफ एक विचार |
| Side-notes | `remember` (🟨), `insight` (💡), `caution` (🟥) — मुख्य पाठ के बीच छोटे boxes |
| आरेख | हर section में ≥1 figure या `no_figure_reason` |
| Worked examples | section के अंत में, notebook steps (§1.3) |
| अंत | सार (5–8 बिंदु) + exercise (हल उत्तर देने के बाद खुले) |
| लंबाई | govt_technical: 2500–4500 शब्द प्रति chapter |

## 4. Mode 2 · 🗒️ Notebook (नोट्स) — संक्षिप्त, block-आधारित
**उद्देश्य:** परीक्षा से पहले 10 मिनट में revision।

| तत्व | नियम |
|---|---|
| इकाई | हर विषय एक रंगीन **block** (§2.1), शीर्षक + 3–6 बिंदु |
| बिंदु | ≤15 शब्द; पहले keyword **मोटा** (render से, Markdown नहीं) |
| तालिका | सिर्फ़ तुलना के लिए; पहली row शीर्षक; ≤4 columns |
| सूत्र | 🟨 formula box: सूत्र · इकाई · कब लगाएँ |
| अंत | 🟥 आम गलतियाँ (3–5) + एक-पंक्ति revision (6–10) |
| मना | लंबे पैराग्राफ, कहानी, दोहराव |

## 5. Mode 3 · 🧑‍🏫 Teach (क्लास) — Digital Board
**उद्देश्य:** जैसे शिक्षक board पर बोलते-लिखते समझाते हैं — एक-एक कदम।

### 5.1 Board का ढाँचा (`teach_board[]`)
हर lesson = steps की सूची; हर step एक tap पर खुलता है (✍️ reveal)।

| Step प्रकार | क्या दिखता है |
|---|---|
| `say` | शिक्षक की बोली (बोलचाल हिंदी, "देखो…", "अब सोचो…") |
| `write` | board पर लिखी पंक्ति (सूत्र/गणना), chalk-शैली |
| `draw` | आरेख का अगला हिस्सा (SVG layer क्रम से दिखे) |
| `anim_graph` | animated graph: `{x, y, expr या points, from, to, slider?}` — offline SVG |
| `proof` | व्युत्पत्ति की अगली पंक्ति + दाईं ओर कारण ("दोनों ओर t से भाग") |
| `cut_section` | वस्तु का काट-दृश्य: बाहरी रूप → काट-रेखा → भीतरी भाग लेबल सहित (जैसे beam, pipe, motor) |
| `ask` | "तुम बताओ" सवाल; उत्तर tap पर |
| `your_turn` | अंत में 3 सवाल (आसान → कठिन) |

### 5.2 नियम
- हर lesson: hook → 3–7 steps → analogy (साथ में उसकी सीमा) → board-सूत्र → check सवाल।
- Derivation/proof पूरा: कोई "सरल करने पर" छलाँग नहीं; हर पंक्ति का कारण।
- Animated graph तभी जब बदलाव दिखाना हो (जैसे v–t graph, stress–strain, V–I)।
- Cut-section तभी जब भीतरी रचना समझ के लिए ज़रूरी हो।
- Board शैली layout से: `chalkboard` (स्कूल/बुनियादी), `blueprint` (Civil/Mech drawing), `whiteboard` (Electrical/गणित)।

## 6. Formula (सूत्र) और Diagram (चित्र) tabs
- **Formula:** हर सूत्र: शीर्षक · सूत्र · symbols का अर्थ · इकाई · कब/कहाँ लगेगा · एक पंक्ति का उदाहरण; श्रेणी-वार।
- **Diagram:** हर figure: उद्देश्य (एक सीखने का काम) · caption · `<title>` · पढ़ने योग्य लेबल · Tier:
  - **A** सटीक SVG (code से बना) · **B** योजनाबद्ध + "expert check" निशान · **C** लेबल वाला खाली फ्रेम + generation prompt।
  - सुंदर पर ग़लत आरेख कभी नहीं।

## 7. Layout (हर chapter अलग, पर अनुशासित)
- Navigation, रंग-अर्थ, typography **fixed**; page-रचना content से (ARCHITECTURE §स्तंभ 3)।
- Archetypes: `formula-heavy`, `diagram-led`, `derivation`, `comparison`, `process-flow`, `fact-dense`, `numerical-drill`।
- स्वच्छता नियम: एक स्क्रीन पर ≤2 रंगीन blocks; हर section के ऊपर-नीचे साँस (≥16px); एक hero प्रति chapter।

## 8. Level के हिसाब से
| Level | भाषा | घनत्व | ज़ोर |
|---|---|---|---|
| `govt_technical` (Diploma/JE) | हिंदी + English terms | normal | इकाई, सूत्र, shortcut, exam-pattern MCQ, site/workshop उदाहरण |
| `govt_basic` | हिंदी | normal | tricks, PYQ-style |
| `class_6_8` / `class_9_10` | सरल हिंदी | airy | कहानी, रोज़ के उदाहरण, कम सूत्र |
| `graduation_*`, `advanced_research` | English-primary | dense | व्युत्पत्ति, कठोरता |

## 9. Reviewer-B checklist (हर draft)
1. भाषा §1.1 · 2. notation §1.2 · 3. हल-रूप §1.3 · 4. mode-नियम (§3/4/5) · 5. रंग-block सही अर्थ में · 6. गिनती · 7. figure या कारण · 8. insight के साथ basis · 9. कोई placeholder/TODO नहीं।
