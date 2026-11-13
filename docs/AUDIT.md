# DIPLOMA-BOY · Audit 1 (12 Nov 2026)

स्रोत: GitHub `amanmehta1352/DIPLOMA-BOY` का `main` snapshot (zip, 12 Nov 2026 17:30 UTC push), repo की फ़ाइलें, और GitHub पर 71 Writer + Solver robot reports (issues)।
**नहीं जाँचा गया:** Supabase database की असली rows (draft/approved गिनती) — service key नहीं है; robot self-tests इस मशीन पर नहीं चले (अनुमति नहीं मिली); app का browser test नहीं चला।

---

## 🟦 1. अभी क्या मौजूद है (अच्छी नींव)

| हिस्सा | फ़ाइल | क्या करता है |
|---|---|---|
| Syllabus पेड़ | `robots/writer/chapters.json` (956 chapters, 18 levels), `content/course-syllabus/syllabus.json`, `db/migrations/0001,0007,0171` | exam → paper → branch → subject → topic; `govt_technical` (Diploma/JE) में 113 chapters |
| Writer robot | `robots/writer/writer.py` + `prompt.txt` | Gemini से chapter JSON (notes/teach/formulas/solved/practice/mistakes/revision); Groq/SambaNova/Cloudflare backup |
| Code checks | `check_structure`, `hindi_ok`, `copyright_score` (NCERT 3-gram fingerprints) | गिनती, 4 options, HTML/LaTeX नहीं, `×` न कि `*`, हिंदी बहुमत, नकल ≤20% |
| दूसरी राय | `second_opinion` (OpenRouter, दूसरी कंपनी) | 10 practice सवाल बिना उत्तर देखे हल; >2 असहमति = reject |
| Solver robot | `robots/solver/*` | masterclass हल; Llama (OpenRouter) से अलग जाँच |
| Draft gate | `mtb.chapter_drafts` (0156), review code preview (0157), `get_chapter_book` सिर्फ़ `approved` (0159) | छात्र सिर्फ़ approved पढ़ते हैं |
| Style guide | `robots/STYLE.md` | Book/Notes/Teach/Formula/Diagram/Masterclass का उद्देश्य, notebook-step हल |
| Control Room | `control/*`, `robots/dispatcher/*` | owner robots चला सकता है |
| CI | `.github/workflows/tests.yml` + 24 workflows | Playwright (360/390/820, light/dark) + सभी robot self-tests |
| Rollback-जैसा | `backups/`, `daily-backup.yml`, migrations "additive only" | पुरानी HTML प्रतियाँ, रोज़ backup |

**निष्कर्ष:** आपकी माँगी पाइपलाइन का ~60% पहले से बना है। नया सिस्टम शुरू से नहीं बनाना; इसी को मज़बूत करना है।

---

## 🟥 2. Critical कमियाँ (आपकी माँग से सीधा टकराव)

### C1 · बिना आपकी मंज़ूरी के publish हो रहा है
- `robots/ecosystem/config.json`: `"auto_approve": true` (1 Nov 2026 से)।
- Writer: 2 chapters auto-approved (reports में दर्ज)।
- **Solver: हर "all checks passed" item सीधे छात्रों को** (`0163_solution_auto_approve.sql`; Solver report #199 में कई `auto: approved`)।
- आपकी नई माँग: "कोई भी आउटपुट सीधे publish न हो"। → **fix:** `auto_approve: false` + Solver में भी वही gate।

### C2 · Owner के लिए "Approve" का रास्ता repo में नहीं है
- Drafts देखने का RPC है (`draft_review_list/get`), पर approve/reject/comment करने का कोई RPC या UI repo में नहीं मिला (शायद हाथ से SQL)।
- → **fix:** `draft_decide(level, chapter, decision, note, code)` RPC + Control Room में "Review Queue" स्क्रीन (preview + ✅ Approve / ✏️ Changes / ❌ Reject + टिप्पणी)।

### C3 · हर chapter एक ही ढाँचे में (fixed template)
- `tools/build_level_book.py`: "every chapter of every level looks like the Physics book" — एक ही CSS, एक ही क्रम।
- Writer JSON में कोई `layout`/design field नहीं; सबका ढाँचा एक।
- आपकी माँग: content के हिसाब से हर chapter/page अलग, साफ़, पढ़ने में आसान। → **fix:** Rendering Engine (स्तंभ 3)।

---

## 🟧 3. High कमियाँ (गुणवत्ता)

### H1 · 32% drafts reject — मुख्य कारण गणना/फ़ॉर्मेट (193 chapter-runs से)
| कारण | बार |
|---|---|
| practice का हल सही option तक नहीं पहुँचता | 41 |
| solved में question/steps/answer अधूरा | 24 |
| बहुत छोटा (<6000 अक्षर) | 21 |
| `*` का प्रयोग (`×` चाहिए) | 16 |
| दूसरी AI >2 उत्तरों पर असहमत | 11 |
| duplicate options | 7 |

Model-वार: Gemini 3.5 Flash 116 में 15 reject (13%) · **Groq gpt-oss-120b 54 में 38 reject (70%)** · Cloudflare Llama 4/4 reject।
→ **fix:** (a) `*`→`×`, duplicate options जैसी चीज़ें code से अपने-आप ठीक (AI से दोबारा न लिखवाएँ); (b) reject पर पूरा chapter दोबारा लिखने की जगह सिर्फ़ ग़लत section का "repair prompt"; (c) Groq/Cloudflare को writer नहीं, सिर्फ़ checker बनाएँ।

### H2 · दूसरी राय सिर्फ़ MCQ उत्तर देखती है
- Notes, Teach, Formulas, Solved की **तथ्य-सटीकता** कोई दूसरी AI नहीं जाँचती; formula/unit पर कोई code check नहीं।
- → **fix:** Reviewer-A (सटीकता: हर formula, unit, solved का दोबारा हल) + numeric `check` field (Python में मूल्यांकन) — universal-notebook-builder के `validate.js` वाला तरीका।

### H3 · स्रोत/संदर्भ नहीं
- Writer JSON में `sources` नहीं; "प्रमाणित पुस्तकों" से जुड़ाव नहीं। Copyright जाँच सिर्फ़ Class 9-10 NCERT science पर।
- → **fix:** `sources/registry.json` (official syllabus PDFs — `robots/syllabus/official_pdfs.json` पहले से है — + मानक पुस्तकें), हर chapter में `refs` और `VERIFY` सूची।

### H4 · आरेख / interactive / Teaching board नहीं
- Writer JSON में figure/diagram field नहीं; Teach = सिर्फ़ `heading/explain/example`।
- → **fix:** `figures[]` (Tier A/B/C + generation prompt), `board[]` steps (step-by-step reveal, animated graph spec, proof lines, cut-section)।

### H5 · Prompt versioned नहीं, temperature 0.4
- `prompt.txt` बिना version; draft में यह दर्ज नहीं कि किस prompt-version से बना। Writer temperature 0.4।
- → **fix:** `prompts/writer.v2.md` + draft के `checks.prompt_version` + `content_hash`; JSON schema फ़ाइल (`schema/chapter.v2.json`) जिससे code जाँचे।

---

## 🟨 4. Medium कमियाँ

- **M1** Diploma branches अधूरे: `govt_technical` में Civil 12, Mechanical 10, Electrical 6 chapters; Electronics/Computer नहीं। (General Science 48 सबसे ज़्यादा।)
- **M2** सिर्फ़ 2 levels लिखे गए (`govt_technical` 161 runs, `class_9_10` 32)। govt_technical queue खाली (#201, #202: "queue left 0")।
- **M3** हर run पर एक नया GitHub issue (70+ खुले issues) — शोर; एक pinned issue/summary बेहतर।
- **M4** Rollback: migrations additive हैं पर chapter draft का पुराना version नहीं रखा जाता (`draft_save` overwrite करता है) → `chapter_draft_versions` table।
- **M5** `backups/*.html` repo में (हर ~160 KB) — git history पहले से backup है; बाद में हटाना/archive।
- **M6** Book/Notes/Teach के लिए अलग style guide नहीं; `STYLE.md` एक ही पन्ने में सब।

---

## 🟩 5. क्रियान्वयन योजना (प्राथमिकता क्रम)

| # | काम | फ़ाइलें | कमी |
|---|---|---|---|
| 1 | Auto-publish बंद (Writer + Solver) | `robots/ecosystem/config.json`, `robots/solver/solver.py` | C1 |
| 2 | Review Queue: approve/reject/comment RPC + Control Room स्क्रीन | `db/migrations/0173_owner_review.sql`, `control/*` | C2 |
| 3 | Draft versions + rollback RPC | `0174_draft_versions.sql` | M4 |
| 4 | Schema v2 (sources, figures, board, layout hints, numeric checks) + versioned prompts | `schema/chapter.v2.json`, `prompts/*.v2.md` | H2–H5 |
| 5 | Auto-fix + section-repair loop; Groq सिर्फ़ checker | `robots/writer/writer.py`, `robots/writer/fix.py` | H1 |
| 6 | Reviewer-A (सटीकता) + Reviewer-B (फ़ॉर्मेट/style) | `robots/review/*` | H2 |
| 7 | Rendering engine: content-features → layout recipe (deterministic) | `tools/level_book_body.html`, `tools/layouts.py` | C3 |
| 8 | Book / Notebook / Teach-board style guides | `docs/STYLE_GUIDE.md` (STYLE.md को बढ़ाकर) | M6, H4 |
| 9 | Diploma branches पूरे (Electronics, Computer, Electrical) | `chapters.json`, syllabus | M1 |
| 10 | Pilot: 1 कमज़ोर diploma chapter पूरे चक्र से → आपकी मंज़ूरी | — | सभी |

## सीमाएँ / अगले audit में
- DB की असली स्थिति (कितने approved/draft/rejected) — service key से या आपकी review code से Control Room में।
- Self-tests और Playwright tests इस मशीन पर नहीं चले।
- `index.html` (169 KB) का UI audit नहीं किया।
- इस मशीन पर `git` नहीं है → बदलाव GitHub तक भेजने के लिए git install या GitHub login चाहिए।
