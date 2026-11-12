# PRD · Diploma Boy Autonomous Content Pipeline (v2)

स्थिति: **Draft — owner की मंज़ूरी बाकी** · आधार: [AUDIT.md](AUDIT.md) · साथी दस्तावेज़: [ARCHITECTURE.md](ARCHITECTURE.md), [STYLE_GUIDE.md](STYLE_GUIDE.md), [PROMPT_CONTRACT.md](PROMPT_CONTRACT.md)

---

## 🟦 1. समस्या
Writer/Solver robots सामग्री बना रहे हैं, पर:
1. कुछ सामग्री owner की मंज़ूरी के बिना छात्रों तक पहुँच रही है (`auto_approve: true`)।
2. हर chapter एक ही ढाँचे में दिखता है; content के हिसाब से layout नहीं बदलता।
3. सटीकता की जाँच सिर्फ़ MCQ उत्तरों तक है; formulas, units, notes, स्रोत अजाँचे।
4. 32% drafts reject होते हैं — ज़्यादातर गणना/फ़ॉर्मेट की ग़लतियों से, जिन्हें code ठीक कर सकता है।
5. Teaching mode सिर्फ़ टेक्स्ट है; आरेख, animated graph, प्रमाण, cut-section नहीं।

## 🟩 2. लक्ष्य (Goals)
| # | लक्ष्य | मापदंड |
|---|---|---|
| G1 | **कुछ भी बिना मंज़ूरी publish नहीं** | `approved` स्थिति सिर्फ़ owner के `draft_decide` से; robot के पास यह अधिकार नहीं (DB स्तर पर) |
| G2 | **सटीक सामग्री** | हर solved/practice का numeric `check` code से पास; Reviewer-A की 0 critical आपत्ति; हर तथ्य-दावे पर स्रोत या `VERIFY` |
| G3 | **एक-सा ढाँचा, अलग रूप** | हर output एक JSON schema में; layout content-features से deterministic नियमों द्वारा; दो अलग chapters का layout-fingerprint अलग |
| G4 | **तीन mode, तीन शैली** | Book = विस्तृत आख्यान · Notebook = संक्षिप्त color-coded blocks · Teach = Digital Board |
| G5 | **कम reject** | reject दर 32% → ≤10% (auto-fix + section-repair से) |
| G6 | **सुरक्षित बदलाव** | हर draft का पुराना version सुरक्षित; एक RPC से rollback; हर बदलाव GitHub में दर्ज |
| G7 | **Diploma पहले** | `govt_technical` + Diploma semester subjects (Civil, Mechanical, Electrical, Electronics, Computer) पूरे |

## 🟥 3. Non-goals (इस version में नहीं)
- Login, payments, guardian/teacher roles (FOUNDATION.md के अनुसार बाद में)।
- 3D models (सिर्फ़ जहाँ 2D से बात साफ़ न हो)।
- बाहरी CDN पर निर्भर UI (offline-first बना रहे)।
- "हर AI से अक्षरशः एक-सा output" — यह संभव नहीं; लक्ष्य **एक-सा ढाँचा और एक-सी जाँच** है (देखें PROMPT_CONTRACT §1)।

## 🟪 4. Users
| User | ज़रूरत |
|---|---|
| Diploma छात्र (Hindi-medium, फ़ोन 360–412px) | साफ़ हिंदी + English terms, जल्दी revision, step-by-step हल |
| JE aspirant (RRB/SSC) | exam-pattern MCQ, shortcuts, formulas एक जगह |
| Owner (आप) | हर draft का preview, एक tap में Approve/Changes/Reject, टिप्पणी जो अगले version में लागू हो |

## 🟧 5. Functional requirements
**FR1 Context** — हर generation को topic का पूरा context-pack मिले: course → semester → subject → unit → topic, prerequisites, level depth, पिछले chapters के layout (दोहराव से बचने को), owner की पिछली टिप्पणियाँ।
**FR2 Generate** — Writer schema v2 का JSON दे: `book`, `notes`, `teach_board`, `formulas`, `solved`, `practice`, `mistakes`, `revision`, `figures`, `refs`, `insights`, `verify`।
**FR3 Auto-fix (code, AI नहीं)** — `*`→`×`, duplicate option, अंतिम "उत्तर =" पंक्ति, spacing, गिनती की कमी पर सिर्फ़ उस section का repair।
**FR4 Review loop** — Reviewer-A (सटीकता) + Reviewer-B (फ़ॉर्मेट/style) — दोनों Writer से अलग कंपनी/family; अधिकतम 2 repair round; फिर भी fail = `rejected` + कारण।
**FR5 Visual plan** — हर section के लिए: आरेख चाहिए? (Tier A/B/C), animated graph, interactive; हर figure का generation prompt।
**FR6 Render** — schema v2 → layout recipe (deterministic) → HTML; Book/Notes/Teach/Formula/Diagram tabs; navigation fixed।
**FR7 Quality gate** — स्थिति-यंत्र: `queued → generated → auto_fixed → reviewed → validated → awaiting_owner → approved | changes_requested | rejected`। Robot अधिकतम `awaiting_owner` तक।
**FR8 Owner review** — Control Room "Review Queue": phone preview, checks का सार (हरा/पीला/लाल), Approve / Changes (टिप्पणी) / Reject।
**FR9 Versions & rollback** — हर save पर `chapter_draft_versions` में प्रति; `draft_rollback(level, chapter, version)`।
**FR10 Sync** — prompts, schema, layouts, style guide repo में versioned; हर draft में `prompt_version`, `schema_version`, `content_hash`; रोज़ एक summary issue (हर run का अलग issue नहीं)।

## ⬜ 6. Non-functional
- Mobile 360px पर horizontal scroll नहीं; contrast ≥4.5:1; body text ≥14px।
- Offline: बाहरी fonts/CDN नहीं (service worker cache)।
- Keys कभी print/commit नहीं; DB migrations additive only।
- मुफ़्त API limits में चले (Gemini free tier, OpenRouter free/कम खर्च)।

## 7. Release योजना
| चरण | क्या | Done का मतलब |
|---|---|---|
| R1 | Auto-publish बंद + Review Queue + versions | robot से कोई `approved` नहीं; owner approve कर सके |
| R2 | Schema v2 + versioned prompts + auto-fix | नया draft schema v2 में, reject दर मापी गई |
| R3 | Reviewer-A/B + numeric checks + refs | हर draft में review रिपोर्ट |
| R4 | Rendering engine + mode style guides | 3 pilot chapters, तीनों के layout अलग |
| R5 | Teach board (step reveal, animated graph) | 1 physics/electrical chapter पर चलता हुआ |
| R6 | Diploma branches पूरे | Electronics, Computer, Electrical chapters queue में |

## 8. जोखिम
| जोखिम | बचाव |
|---|---|
| Free API बंद/limit | कई providers (पहले से), state वहीं रुके, आधा कुछ publish नहीं |
| दोनों AI एक ही ग़लती करें | numeric check code से; स्रोत-आधारित Reviewer-A; अंतिम owner |
| Review queue बहुत लंबी | रोज़ अधिकतम N drafts; "सारी जाँच हरी" वाले ऊपर |
| Layout बहुत अलग-अलग → बिखराव | navigation, रंग-अर्थ और typography fixed; सिर्फ़ page-रचना बदले |
