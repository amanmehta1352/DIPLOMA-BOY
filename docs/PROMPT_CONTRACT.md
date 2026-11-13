# Prompt Contract · Deterministic Content Path (v2)

यह दस्तावेज़ तय करता है कि **कोई भी AI model** (Gemini, Llama, DeepSeek, GPT, Claude…) इस पाइपलाइन में कैसे बँधा रहेगा।

---

## 1. "Deterministic" का ईमानदार अर्थ
कोई भी LLM हर बार अक्षरशः एक-से शब्द नहीं देता, और दो अलग models तो बिल्कुल नहीं। इसलिए यहाँ तीन चीज़ें तय (deterministic) हैं:

| तय क्या है | कैसे |
|---|---|
| 🟦 **Input** | context-pack शुद्ध function से बनता है; उसका `sha256` draft में दर्ज |
| 🟩 **Output का ढाँचा** | `schema/chapter.v2.json`; ढाँचे से बाहर = reject, model कोई भी हो |
| 🟧 **फ़ैसले** | layout चयन, auto-fix, numeric checks, gate — सब code; AI सिर्फ़ लिखता/राय देता है |

AI जो अलग देता है (शब्द-चयन, उदाहरण), वह reviewers और owner की जाँच से गुज़रता है। Temperature: Writer 0.3, Reviewers 0।

## 2. हर prompt फ़ाइल का ढाँचा (`prompts/<stage>.v<N>.md`)
हर prompt इन्हीं 7 हिस्सों में, इसी क्रम में:

```
### ROLE          — एक पंक्ति: तुम कौन हो
### INPUT         — {{context_pack}} (JSON, जैसा का तैसा)
### TASK          — इस stage का एक काम
### RULES         — STYLE_GUIDE के नियम, ID के साथ (S1.2, S5.2 …)
### OUTPUT SCHEMA — schema का हिस्सा, जैसा का तैसा
### SELF-CHECK    — लौटाने से पहले जाँचने की सूची
### FORMAT        — "सिर्फ़ एक JSON object; उसके बाहर कुछ नहीं"
```

Placeholders सिर्फ़ `{{name}}` रूप में; `prompts/render.py` इन्हें भरता है और कोई placeholder बचा = error।

## 3. Stages और उनके prompts
| Stage | फ़ाइल | Model भूमिका | Output |
|---|---|---|---|
| Plan | `plan.v2.md` | Writer | sections की सूची, archetype संकेत, figures की ज़रूरत |
| Write | `write.v2.md` | Writer | पूरा chapter (schema v2) |
| Visual plan | `visual.v2.md` | Writer | `figures[]` + `teach_board` के `draw/anim_graph/cut_section` spec |
| Review-A | `review_accuracy.v2.md` | अलग company | `issues[]` (path, severity, claim, fix, basis) |
| Review-B | `review_format.v2.md` | अलग model | `issues[]` (path, rule_id, fix) |
| Repair | `repair.v2.md` | Writer | सिर्फ़ दिए गए `path` का नया JSON |
| Blind solve | `solve.v2.md` | अलग company | `{answers: [...]}` उत्तर देखे बिना |

## 4. Schema v2 (सार; पूरा `schema/chapter.v2.json` में)
```
id, schema_version, prompt_version, level, chapter, lang
book:        { hook, sections[{no, title, paras[], side[], figure_ids[], examples[]}], summary[] }
notes:       [{ kind: definition|types|application|figure|mistake|formula|insight, title, points[], table? }]
teach_board: [{ title, board: chalkboard|blueprint|whiteboard,
                steps[{ type: say|write|draw|anim_graph|proof|cut_section|ask|your_turn, ... }] }]
formulas:    [{ cat, title, formula, symbols, units, when, example }]
solved:      [{ question, steps[], answer, check{expr, value, tol} }]
practice:    [{ q, options[4], answer 0-3, explanation, check? }]
figures:     [{ id, tier: A|B|C, purpose, caption, alt, svg? , prompt }]
mistakes[], revision[]
refs:        [{ source_id, where }]          ← sources/registry.json से ही
insights:    [{ text, basis }]
verify:      [{ path, what_to_check }]
```

## 5. Validation क्रम (code; हर model पर एक-सा)
1. JSON parse → 2. schema v2 → 3. auto-fix (`*`→`×`, duplicate options, अंतिम "उत्तर =" पंक्ति, खाली strings) → 4. गिनती → 5. notation/HTML/LaTeX → 6. हिंदी बहुमत → 7. numeric `check` safe-eval → 8. practice explanation सही option तक → 9. blind solve तुलना → 10. Review-A/B issues → 11. copyright → 12. refs IDs मौजूद → 13. layout fingerprint।
हर चरण का परिणाम `checks.<step>` में; पहला critical fail = आगे के AI चरण नहीं चलते (पैसा/समय बचे)।

## 6. Error handling नियम
| स्थिति | कदम |
|---|---|
| JSON parse नहीं हुआ | वही prompt + parse error के साथ 1 retry; फिर अगला provider |
| Schema fail | `repair.v2.md` में सिर्फ़ fail paths; ≤2 round |
| Output कटा (`finish_reason=length`) | अगला provider (मौजूदा व्यवहार) |
| 429/5xx/timeout | मौजूदा backoff; budget खत्म = कुछ save नहीं, `checks.error` |
| Reviewer उपलब्ध नहीं | draft `held` — owner तक "review missing" निशान के साथ; कभी approved नहीं |
| Critical issue बचा | `rejected` + कारण; attempts < 3 तो अगले run में फिर |
| कोई भी exception | status नहीं बदलता; reject गिनती नहीं बढ़ती |

## 7. Versioning
- Prompt/schema में कोई भी बदलाव = नया version (`v2` → `v3`), पुराना फ़ाइल रहता है।
- `prompts/CHANGELOG.md`: क्या बदला, क्यों, किस owner टिप्पणी से।
- हर draft में `prompt_version`, `schema_version`, `pack_sha256`, `content_hash`।
- Golden tests: `tests/fixtures/chapter_v2_*.json` पर validation + layout fingerprint; बदलाव PR में दिखे।

## 8. Owner feedback loop
Owner की `changes_requested` टिप्पणी → `mtb.draft_notes` → अगले run के context-pack में "owner notes" हिस्सा → repair/rewrite।
एक ही तरह की टिप्पणी 3 बार आए → STYLE_GUIDE/prompt में नया नियम का प्रस्ताव (PR, owner मंज़ूरी से)।
