# Architecture · Master Content Agent (v2)

स्थिति: **Draft** · लक्ष्य और माप: [PRD.md](PRD.md) · मौजूदा स्थिति: [AUDIT.md](AUDIT.md)

सिद्धांत: **AI सिर्फ़ लिखता और राय देता है; फ़ैसले code और owner लेते हैं।** हर चरण अपनी स्थिति DB में लिखता है, इसलिए कोई चरण fail हो तो वहीं रुकता है और आधा कुछ publish नहीं होता।

---

## Data flow

```
 syllabus.json ─┐                                   ┌─ prompts/*.vN.md (versioned)
 chapters.json ─┼─► [1] Context Manager ─ context-pack ─► [2a] Writer (model W)
 owner notes  ──┘        (pack.py)                          │ JSON
                                                            ▼
                                     code: schema v2 + auto-fix (fix.py)
                                                            │
                          ┌─────────── [2b] Reviewer-A (सटीकता, model ≠ W)
                          ├─────────── [2c] Reviewer-B (फ़ॉर्मेट/style, model ≠ W)
                          ▼
                 problems? ── हाँ ─► section-repair (≤2 round) ─► फिर भी? ─► rejected
                          │ नहीं
                          ▼
                 code: numeric checks · Hindi · copyright · counts
                          ▼
                 [3] Render engine ─ layout recipe ─► preview HTML
                          ▼
                 [4] chapter_drafts.status = awaiting_owner  (+ version row)
                          ▼
          Control Room Review Queue ── owner ──► approved ─► app (get_chapter_book)
                                          ├──► changes_requested ─► owner note ─► context-pack में वापस
                                          └──► rejected
```

---

## 🟦 स्तंभ 1 · Context Manager
**उद्देश्य:** model को हर बार पूरा, एक-सा संदर्भ मिले; कुछ भी "याद" पर निर्भर न रहे।

| भाग | कहाँ | स्थिति |
|---|---|---|
| Topic पेड़ | `robots/writer/chapters.json` (`l, c, s, se, h, e`), `content/course-syllabus/syllabus.json` (752 subjects), `mtb.course_subjects` | ✅ मौजूद |
| Level depth | `robots/writer/levels.json` | ✅ मौजूद |
| Topic data model | `schema/topic.v1.json` — `id, unit, prerequisites[], outcomes[], key_formulas[], required_figures[], refs[]` | 🆕 |
| Context-pack | `robots/context/pack.py <level> <chapter>` → JSON | 🆕 |

Context-pack में (हमेशा इसी क्रम में): topic · parent subject/unit · prerequisites के शीर्षक · level depth · mode-नियम (STYLE_GUIDE से) · पिछले 3 chapters के `layout` fingerprints · इस chapter पर owner की टिप्पणियाँ · स्रोत सूची।
**Determinism:** pack.py शुद्ध function है — एक ही input, बाइट-दर-बाइट वही pack (`sort_keys`, कोई समय/random नहीं)। Pack का `sha256` draft में दर्ज।

## 🟩 स्तंभ 2 · Multi-Model Validation Loop
| भूमिका | Model (डिफ़ॉल्ट) | काम | Output |
|---|---|---|---|
| Writer | Gemini 3.5 Flash (backup: SambaNova Llama) | schema v2 JSON लिखना | chapter JSON |
| Reviewer-A सटीकता | OpenRouter (DeepSeek/Llama — Writer से अलग family) | हर formula, unit, तथ्य, solved/practice दोबारा हल | `{issues:[{path, severity, claim, fix}]}` |
| Reviewer-B फ़ॉर्मेट | Gemini Flash-Lite या Groq | STYLE_GUIDE नियम, भाषा, गिनती, notation | वही ढाँचा |
| Repair | Writer model | सिर्फ़ उन `path` को दोबारा लिखना | patch JSON |

नियम:
- **Groq gpt-oss-120b और Cloudflare Llama को Writer नहीं** (audit: 70% और 100% reject) — सिर्फ़ Reviewer।
- Reviewer को उत्तर नहीं दिखाया जाता (blind solve), फिर code तुलना करता है।
- `severity = critical` (ग़लत तथ्य/सूत्र/इकाई/उत्तर) एक भी बचा = draft owner तक नहीं जाता।
- Numeric checks code में: हर `solved[].check = {expr, value, tol}` और practice का सही option Python में safe-eval से मिलाया जाता है (universal-notebook-builder `validate.js` §7 वाला तरीका)।
- **Research & Verification:** `sources/registry.json` — official syllabus PDFs (`robots/syllabus/official_pdfs.json`) + मानक पुस्तकें (शीर्षक, लेखक, संस्करण, ISBN — सिर्फ़ वही जो सचमुच जाँची गई)। Chapter के `refs[]` इन्हीं IDs से; बाकी हर अनिश्चित दावा `verify[]` में।
- **Insights ("out-of-the-box" बिंदु):** अलग `insights[]` block; हर एक के साथ `basis` (तर्क/स्रोत)। Reviewer-A इन्हें भी जाँचता है।
- **Visual planner:** हर section पर `figures[]` — `tier` (A सटीक SVG / B योजनाबद्ध + expert check / C लेबल वाला खाली फ्रेम), `purpose`, `prompt` (image/SVG बनाने का निर्देश), `alt`।
- अभी के keys: `GEMINI_API_KEY`, `OPENROUTER_API_KEY`, `GROQ_API_KEY`, … (GitHub secrets, पहले से)। नया provider = `robots/models/providers.json` में एक पंक्ति।

## 🟧 स्तंभ 3 · Template Rendering Engine
**Fixed (हर chapter में एक-सा):** top bar, chapter chips, bottom nav (Book/Notes/Teach/Formula/Diagram), हिं/EN toggle, stacked-fraction code (`fracify`), रंग-अर्थ (STYLE_GUIDE §2), typography।
**Variable (content से तय):** page-रचना, section का component, hero, घनत्व, board का प्रकार, कौन-से tabs दिखें।

Layout चयन (`tools/layouts.py`, शुद्ध function):
1. **Features निकालो:** formula-घनत्व, figures की संख्या/tier, derivation/proof steps, तुलना-tables, numerical अनुपात, शब्द-संख्या।
2. **Archetype नियम से:** `formula-heavy` · `diagram-led` · `derivation` · `comparison` · `process/flow` · `fact-dense` · `numerical-drill`।
3. **Recipe:** archetype → section components का क्रम (जैसे diagram-led: hero figure → labelled parts table → working steps → mistakes)।
4. **विविधता:** `seed = sha256(level|chapter)` से archetype के भीतर वैकल्पिक components/accent चुने → दोबारा चलाने पर वही, दो chapters में अलग।
5. **Distinctness check:** पिछले chapters के fingerprint से तुलना; बहुत समान = दूसरा विकल्प।

Output: `layout` block draft में (`archetype, recipe[], accent, board, density, fingerprint`) + `tools/level_book_body.html` इसे पढ़कर render करता है (fixed shell का CSS वही)।

## 🟥 स्तंभ 4 · Sync, Versions, Rollback, Quality Gate
**Quality gate — बन गया (`db/migrations/0173_owner_gate.sql`, `control/review.js`):**
- `auto_approve_draft` और `solution_auto_approve` हटाए नहीं (additive नियम), पर अब हमेशा `held` लौटाते हैं; `robots/ecosystem/config.json` में `auto_approve: false` (writer selftest इसे जाँचता है)।
- Status की पुरानी तीन values (`draft/rejected/approved`) ही रहीं; owner का फ़ैसला `checks.owner = {decision, note, at}` में।
- `draft_decide` / `solution_decide(code, …, approve|changes|reject|unpublish, note)` — `approved` का एकमात्र रास्ता। `changes` = rejected + attempts 0 + टिप्पणी → Writer `draft_owner_notes()` से टिप्पणी पढ़कर prompt में जोड़ता है। `reject` = attempts 99 (दोबारा नहीं लिखा जाता)। `unpublish` = approved → draft।
- Control Room → ✅ Review: जाँच बाकी / Auto से live / Live / रुके; draft color-coded blocks में; reject/unpublish/rollback पर दो बार दबाना।

**Versions — बन गया:** `mtb.content_versions` (chapter + solution) — trigger हर बदलाव से पहले पुरानी प्रति रखता है। `content_versions_list` + `content_rollback(code, version)` पुरानी प्रति को **draft** बनाकर लौटाता है (सीधे live नहीं)। `prompt_version/schema_version/content_hash` R2 (schema v2) में जुड़ेंगे।

**GitHub sync:**
- Prompts, schema, layouts, STYLE_GUIDE repo में; बदलाव PR से; `tests.yml` हर PR पर selftests + schema fixtures + golden layouts चलाए।
- Golden tests: `tests/fixtures/chapter_v2_*.json` → layout fingerprint और rendered HTML के मुख्य हिस्से तय; बदलाव = diff दिखे।
- रिपोर्ट: हर run का अलग issue नहीं; एक pinned "Content Pipeline Status" issue रोज़ update (Writer/Reviewer/rejects/queue)।

**Error handling (`docs/PROMPT_CONTRACT.md` §6):** invalid JSON → schema-error के साथ 1 retry · provider fail → अगला provider, फिर state वहीं · timeout → कुछ save नहीं · कोई भी exception → `checks.error`, reject गिनती नहीं बढ़ती (मौजूदा व्यवहार)।

---

## Open-source से लिए जाने वाले पैटर्न
> ये पैटर्न सामान्य जानकारी से हैं; इस session में इन repos का कोड नहीं खोला गया। कोड नकल नहीं, सिर्फ़ विचार।

| पैटर्न | किससे प्रेरित | कहाँ लगेगा |
|---|---|---|
| Content collections + schema से हर फ़ाइल की जाँच | Astro Starlight / Docusaurus | schema v2 + `selftest` |
| JSON Schema validator | Ajv / Python `jsonschema` | `robots/writer/schema_check.py` |
| Step-by-step animated scenes, code से परिभाषित | Manim / Motion Canvas | Teach board `steps[]` + `anim` spec |
| घोषणात्मक (declarative) गणितीय graph | Mafs / JSXGraph | `animGraph` block (offline SVG, अपना छोटा renderer) |
| Versioned changelog/release | changesets / semantic-release | `prompts/CHANGELOG.md`, prompt version tags |
| Golden/snapshot tests | Jest snapshots / Playwright screenshots | `tests/fixtures/chapter_v2_*` + मौजूदा shots |

## फ़ाइल नक्शा (नया 🆕 / बदलेगा ✏️)
- ✏️ `robots/ecosystem/config.json`, `robots/writer/writer.py`, `robots/solver/solver.py`, `robots/STYLE.md` → `docs/STYLE_GUIDE.md` का सार
- 🆕 `robots/context/pack.py`, `robots/review/{accuracy,format}.py`, `robots/writer/fix.py`, `robots/models/providers.json`
- 🆕 `schema/chapter.v2.json`, `schema/topic.v1.json`, `sources/registry.json`, `prompts/*.v2.md`
- 🆕 `db/migrations/0173_owner_review.sql`, `0174_draft_versions.sql`
- ✏️ `tools/level_book_body.html`, 🆕 `tools/layouts.py`, ✏️ `control/*` (Review Queue)
