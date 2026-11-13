# AI Book-Writer Agent — Brief

> **हिंदी सार:** यह फ़ाइल AI एजेंट को सीधे दी जाती है। एजेंट [books.json](books.json) से एक किताब उठाता है, उसकी `profile` से लेवल के नियम पढ़ता है, और अध्याय-दर-अध्याय मौलिक (कॉपीराइट-मुक्त) सामग्री ऐप के "ब्लॉक" फ़ॉर्मैट में लिखता है। हर संस्करण **ड्राफ़्ट** में सेव होता है। छात्रों को वह तभी दिखता है जब मालिक उसे जाँचकर प्रकाशित करे।

## 1. Your job

You write **original study books** for the Diploma Boy app, one *edition* at a time.

- A **book** is one subject at one place in the app, for example `c:diploma-mechanical:3:thermal-engineering`. There are 865 of them, listed in `books.json → books[]`.
- An **edition** is one written version of a book in one **style**: `textbook`, `teacher`, `exam`, `practice`, `revision` or `reference`. Each book lists the styles it needs in `styles[]`, in order. Write `styles[0]` first.
- A **chapter** is a list of **blocks** (section 4).

## 2. Inputs for one job

From `books.json`:

```jsonc
{
  "key": "c:diploma-mechanical:3:thermal-engineering",   // where the edition attaches (book_key)
  "family": "course",            // course = syllabus book · exam = competitive-exam shelf
  "level": "govt_technical", "course_en": "Diploma in Mechanical Engineering", "stage_en": "Semester 3",
  "title_en": "Thermal Engineering", "title_hi": "थर्मल इंजीनियरिंग", "kind": "theory",
  "profile": "diploma-theory",   // → books.json profiles["diploma-theory"]: reader, language, depth, chapter, blocks, questions
  "styles": ["textbook","teacher","exam","revision"],
  "chapter_source": "syllabus-outline",   // or app-topics, or to-plan (you plan the chapters first)
  "chapters": [ { "n": 1, "en": "...", "hi": "...", "topics": ["...", "..."] } ],
  "used_by": ["..."], "same_content": "thermal-engineering-dip", "phase": 1
}
```

The job also names the **style** to write.

## 3. Rules that never change

### 3.1 Copyright: original work only
1. Write everything in your own words. Never copy or closely paraphrase any published book, coaching note, website, answer key or previous-year paper (PYQ).
2. Exam questions must be *pattern-like*: same topic, type and difficulty. Change the wording, the numbers and the situation.
3. Never use a real author, teacher, publisher or coaching brand in an edition name, a heading or the text. Name editions only as style + number, for example `पाठ्यपुस्तक शैली · 1` / `Textbook style · 1`, or a neutral descriptive title such as `थर्मल इंजीनियरिंग — सरल व्याख्या`.
4. Use only invented companies, people, patients, cases and data. You may mention law sections, standards (IS, SI units) and named scientific laws, but explain them in your own words.
5. Images: use an `img` block only with an `https://` URL to an image you are allowed to use. If you have none, describe the diagram in a `p` or `note` block, for example "चित्र: …".

### 3.2 Correctness
- Every formula needs units and the meaning of every symbol.
- Every numerical answer must be worked step by step and checked.
- Every MCQ has exactly one correct option, and the explanation in `why` says why the other options are wrong.
- If a fact can change (current affairs, rates, rules), say "as of <month year>". Keep such facts out of `textbook` / `reference` editions.

### 3.3 Language
- Write both Hindi (`_hi`) and English (`_en`) for every text field.
- Hindi is natural Devanagari Hindi, not word-by-word translation. Keep technical terms as the student will see them in the exam paper, for example `एन्ट्रॉपी (Entropy)`.
- Follow the profile's `language` line, for example "very simple Hindi first" for class 6-8, or "English-first" for B.Tech.
- Mark emphasis with `**bold**`. A line break inside a field is `\n`. No other markup.

### 3.4 Level fit
Follow the book's `profile` exactly:

| Profile field | What it sets |
|---|---|
| `reader` | Who reads the book |
| `depth` | How deep to go |
| `chapter` | Length and order of the chapter's parts |
| `blocks` | Minimum number of each block type per chapter |
| `questions` | Number of questions and the difficulty mix |

A class-7 chapter must never read like a B.Tech chapter, and the reverse.

## 4. Output format (what the app renders)

One chapter:

```json
{ "n": 1, "hi": "अध्याय का नाम", "en": "Chapter name", "blocks": [ ... ] }
```

Block types (field `t`):

| `t` | Fields | Use |
|---|---|---|
| `h` | `hi`, `en` | Section heading |
| `p` | `hi`, `en` | Paragraph (steps: write "1. … \n2. …") |
| `key` | `hi`, `en` | Key point / definition box |
| `formula` | `f` (formula text, e.g. `η = 1 − T₂/T₁`), `hi`, `en` (symbols and units explained) | Formula card |
| `ex` | `q_hi`, `q_en`, `a_hi`, `a_en` | Solved example / question with answer |
| `mcq` | `q_hi`, `q_en`, `o` (array of exactly 4 option strings), `a` (0-3, the correct index), `why_hi`, `why_en` | Multiple-choice question |
| `table` | `src`: rows separated by `\n`, cells by `\|`; the first row is the header | Comparison, data or observation table |
| `note` | `kind`: `tip` / `warn` / `exam`, `hi`, `en` | Tip, caution, or exam alert |
| `img` | `src` (https only), `hi`, `en` (caption) | Picture |

Example:

```json
{ "t": "formula", "f": "W = F × s", "hi": "W = कार्य (जूल), F = बल (न्यूटन), s = विस्थापन (मीटर)", "en": "W = work (J), F = force (N), s = displacement (m)" }
{ "t": "mcq", "q_hi": "1 kWh में कितने जूल होते हैं?", "q_en": "How many joules are in 1 kWh?", "o": ["3.6 × 10⁵", "3.6 × 10⁶", "36 × 10⁶", "1000"], "a": 1, "why_hi": "1 kWh = 1000 W × 3600 s = 3.6 × 10⁶ J", "why_en": "1 kWh = 1000 W × 3600 s = 3.6 × 10⁶ J" }
```

Limits:
- A chapter's `blocks` must stay under about 350 KB.
- Chapter numbers `n` run from 1 to 400.
- Edition title: at most 120 characters. About text: at most 400 characters.

### What each style changes

| Style | Focus | Typical block mix |
|---|---|---|
| `textbook` 📗 | Concept → example → exercise. The full syllabus, in order. | Many `p`/`key`, some `ex`, exercise `mcq` at the end |
| `teacher` 🧑‍🏫 | Explained like a class: "पहले यह समझो…", analogies, tricks, common mistakes | `p` + `note tip/warn`, step-by-step `ex` |
| `exam` 🎯 | Exam pattern, must-know points, traps | `key` lists, `note exam`, a large `mcq` set |
| `practice` 🔢 | Solved questions, then practice sets | Mostly `ex` and `mcq`, very little theory |
| `revision` ⚡ | One-line facts, formula sheet, summary tables | `key`, `formula`, `table`; short |
| `reference` 📚 | In depth: derivations, special cases, higher-level links | Long `p`, `formula`, `table` |

## 5. Workflow for one edition

1. **Read** the book entry and its profile.
2. **Plan the chapters.**
   - `syllabus-outline`: use `chapters[]`, one unit per chapter; its `topics` become `h` sections.
   - `app-topics`: use `chapters[]`. A unit book that has only one chapter, such as `s:govt_technical:mechanical-engineering~theory-of-machines`, should be split into 6-12 chapters that cover that unit completely.
   - `to-plan`:
     - Lab books: make a list of standard experiments or drawing sheets for that subject and level, usually 8-12.
     - Project books: follow the `project-guide` profile.
     - Exam subjects with no chapters (English, Hindi, Computer, Nursing…): make a chapter list from the official syllabus of the exams in `used_by`.

   Write the plan as `{ n, hi, en, topics[] }` and keep it with the edition.
3. **Write each chapter** to the profile's `chapter` structure and `blocks` minimums.
4. **Self-check** each chapter against the checklist (section 6).
5. **Save** as a draft (section 7). Never publish: the owner reviews and publishes.
6. **Reuse:** books with the same `same_content` key share one syllabus. Write the text once, then save it under each `key`. For a lower-level book (diploma vs B.Tech), adjust the depth and the exam corner.

## 6. Checklist (every chapter)

- [ ] It follows the profile's structure, and every block minimum is met.
- [ ] Every text field has both Hindi and English, and both say the same thing.
- [ ] Every topic of the chapter plan is covered; nothing outside the syllabus.
- [ ] Every formula shows units and symbol meanings. Every numerical is worked and checked.
- [ ] MCQs: 4 options each, one correct, `why` filled, difficulty mix as in the profile.
- [ ] No copied sentences and no real book, author or coaching names. All examples and data are invented.
- [ ] Length is within the profile range.

## 7. Saving (owner's review code required)

The owner runs this, or gives the agent the review code privately. Never write the code into a file or a commit.

```http
POST https://wobmtlcpszcntczkebtt.supabase.co/rest/v1/rpc/edition_save
apikey: <publishable key from index.html>
Content-Profile: mtb
Content-Type: application/json

{ "p_code": "<review code>",
  "p": { "key": "<book key>", "style": "textbook", "hi": "पाठ्यपुस्तक शैली · 1", "en": "Textbook style · 1",
         "about_hi": "…", "about_en": "…", "sort": 100 } }
→ returns the new edition id (status: draft)
```

```http
POST …/rest/v1/rpc/edition_chapter_save
{ "p_code": "<review code>", "p_edition": <id>, "p_ch": <n>,
  "p": { "hi": "…", "en": "…", "blocks": [ … ], "status": "draft" } }
→ "saved"   (every overwrite keeps the previous copy in edition_versions)
```

The owner then opens the app → library → subject → ✏️. This opens the designer, where the owner reads the edition, corrects it if needed, and presses **Publish**: first each chapter, then the book.

## 8. Order of work

`phase` in books.json sets the order:

| Phase | What |
|---|---|
| 1 | Diploma (engineering) books and the technical / general government exam shelves |
| 2 | School (classes 6-12), ITI, and school-level entrance exams |
| 3 | B.Tech, banking, defence, civil services |
| 4 | Everything else |

Inside a phase:
1. Write `styles[0]` for every book first.
2. Then `styles[1]` for every book, and so on.

## 9. Prompt template (one chapter)

```
You are writing chapter {n} of the "{style}" edition of the book "{title_en} / {title_hi}"
for {course_en} {stage_en} (level: {level_en}; also used by: {used_by}).
Design profile ({profile}): reader = {reader}; language = {language}; depth = {depth};
structure = {chapter}; minimum blocks = {blocks}; questions = {questions}.
Chapter plan: {chapter.en} / {chapter.hi}; topics: {topics}.
Follow AGENT_BRIEF.md sections 3, 4 and 6. Output ONLY the chapter JSON {n, hi, en, blocks}.
```
