# Electricity — needs_review (book format)
review_ready = all automatic checks passed; NOT published; owner review needed.

- resolve: done (attempts 0, calls 0)
- reference: done (attempts 0, calls 0)
- outcomes: done (attempts 1, calls 1)
- plan: done (attempts 1, calls 1)
- concepts: done (attempts 0, calls 5)
- extras: done (attempts 1, calls 1)
- questions: done (attempts 0, calls 20)
- teach: done (attempts 0, calls 4)
- hinglish: done (attempts 0, calls 4)
- demo: done (attempts 4, calls 4)
- correction: pending (attempts 0, calls 13)

## Checks
```
{
 "notes_words": {
  "hi": 4263,
  "en": 3751
 },
 "teach_words": {
  "hindi": 2524,
  "english": 2134
 },
 "panels": 20,
 "teach_sections": 17,
 "diagrams": 6,
 "scope": [
  {
   "id": "current_pd",
   "covered": true
  },
  {
   "id": "ohm",
   "covered": true
  },
  {
   "id": "resistance",
   "covered": true
  },
  {
   "id": "combos",
   "covered": true
  },
  {
   "id": "heating",
   "covered": true
  },
  {
   "id": "power",
   "covered": true
  }
 ],
 "coverage": {
  "outcomes": [
   {
    "id": "o1",
    "questions": 8,
    "concept": true
   },
   {
    "id": "o2",
    "questions": 6,
    "concept": true
   },
   {
    "id": "o3",
    "questions": 8,
    "concept": true
   },
   {
    "id": "o4",
    "questions": 6,
    "concept": true
   },
   {
    "id": "o5",
    "questions": 5,
    "concept": true
   },
   {
    "id": "o6",
    "questions": 7,
    "concept": true
   },
   {
    "id": "o7",
    "questions": 5,
    "concept": true
   },
   {
    "id": "o8",
    "questions": 7,
    "concept": true
   },
   {
    "id": "o9",
    "questions": 6,
    "concept": true
   }
  ],
  "bloom_in_questions": [
   "analyze",
   "apply",
   "evaluate",
   "remember",
   "understand"
  ],
  "types": {
   "mcq": 14,
   "true_false": 2,
   "fill_blank": 2,
   "vsa": 7,
   "sa": 10,
   "la": 4,
   "numerical": 6,
   "assertion_reason": 4,
   "case_based": 5,
   "hots": 4
  },
  "bands": {
   "knowledge_understanding": 0.431,
   "application": 0.379,
   "higher_order": 0.19,
   "competency": 0.655
  }
 },
 "copyright": {
  "overlap": 0.1847,
  "threshold": 0.2,
  "longest_copied_run_words": 16,
  "run_text": "the potential difference across a conductor is directly proportional to the electric current flowing through it",
  "max_run_words": 8,
  "note": "automatic metric, not legal clearance"
 },
 "terms": {
  "pairs": 647,
  "missing_hindi_term": {
   "potential difference": 1,
   "circuit": 1,
   "series": 1,
   "conductor": 1
  },
  "banned_form": {},
  "number_mismatch_pairs": 1,
  "glossary_verified": false,
  "bad_pairs": [
   {
    "pair": [
     "चालक (conductor)",
     "1.68 × 10^-8"
    ],
    "why": [
     "Hindi and English must carry the same numbers and formulas (Hindi has [], English has ['1.68', '10', '8'])"
    ]
   },
   {
    "pair": [
     "ग्राफ का ढाल ΔV/ΔI = (3.6 V‑1.2 V)/(0.6 A‑0.2 A) = 2.4 V/0.4 A = 6 Ω, इसलिए प्रतिरोध R = 6 Ω। अनुप्रस्थ काट A = 0.5 mm² = 0.5×10⁻⁶ m²। ρ = R·A/L = 6 Ω·0.5×10⁻⁶ m² / 1.2 m = 2.5×10⁻⁶ Ω·m। एमीटर को धारा के प्रवाह के क्रम में (सिर्‍स में) जोड़ा जाता है, जबकि वोल्टमीटर को मापे जाने वाले घटक के दोनों सिरों पर समानांतर (पार्श्वक्रम) में जोड़ा जाता है।",
     "Slope = ΔV/ΔI = (3.6 V‑1.2 V)/(0.6 A‑0.2 A) = 2.4 V/0.4 A = 6 Ω, so R = 6 Ω. Area A = 0.5 mm² = 0.5×10⁻⁶ m². ρ = R·A/L = 6 Ω·0.5×10⁻⁶ m² / 1.2 m = 2.5×10⁻⁶ Ω·m. The ammeter is placed in series with the circuit so that the same current passes through it, whereas the voltmeter is connected across the component (parallel) to measure the potential difference."
    ],
    "why": [
     "'potential difference' must be 'विभवांतर' in Hindi",
     "'circuit' must be 'परिपथ' in Hindi",
     "'series' must be 'श्रेणीक्रम' in Hindi"
    ]
   },
   {
    "pair": [
     "ओम का नियम कहता है कि धारा (I) और विभवांतर (V) के बीच प्रतिरोध (R) का अनुपात स्थिर रहता है: V = I × R।",
     "Ohm's law states that the ratio between voltage and current is constant for a conductor: V = I × R."
    ],
    "why": [
     "'conductor' must be 'चालक' in Hindi"
    ]
   }
  ]
 },
 "key_balance": {
  "positions": [
   5,
   5,
   3,
   1
  ],
  "max_share": 0.357
 },
 "blind": {
  "n": 18,
  "passes": [
   {
    "provider": "openrouter",
    "model": "nvidia/nemotron-3-ultra-550b-a55b:free",
    "answered": 18
   },
   {
    "provider": "openrouter",
    "model": "nvidia/nemotron-3-ultra-550b-a55b:free",
    "answered": 18
   }
  ],
  "disagree": [
   {
    "q": 2,
    "pass": 1,
    "key": 1,
    "solver": 3
   },
   {
    "q": 8,
    "pass": 1,
    "key": 0,
    
```

## Who did what
- reference / researcher: groq openai/gpt-oss-120b
- outcomes / planner: gemini gemini-3.8-flash
- plan / planner: gemini gemini-3.6-flash
- concepts / writer: groq openai/gpt-oss-120b
- concepts / writer: gemini gemini-3.6-flash
- concepts / writer: gemini gemini-3.6-flash
- concepts / writer: groq openai/gpt-oss-120b
- concepts / writer: gemini gemini-3.6-flash
- extras / writer: gemini gemini-3.6-flash
- questions / writer: gemini gemini-3.6-flash
- questions / writer: gemini gemini-3.6-flash
- questions / writer: groq openai/gpt-oss-120b
- questions / writer: groq openai/gpt-oss-120b
- questions / writer: groq openai/gpt-oss-120b
- questions / writer: groq openai/gpt-oss-120b
- questions / writer: groq openai/gpt-oss-120b
- questions / writer: groq openai/gpt-oss-120b
- questions / writer: groq openai/gpt-oss-120b
- questions / writer: groq openai/gpt-oss-120b
- questions / writer: groq openai/gpt-oss-120b
- questions / writer: groq openai/gpt-oss-120b
- questions / writer: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- questions / writer: groq openai/gpt-oss-120b
- questions / writer: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- questions / writer: groq openai/gpt-oss-120b
- questions / writer: groq openai/gpt-oss-120b
- questions / writer: groq openai/gpt-oss-120b
- questions / writer: groq openai/gpt-oss-120b
- teach / teacher: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- teach / teacher: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- teach / teacher: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- teach / teacher: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- hinglish / transliterator: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- hinglish / transliterator: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- hinglish / transliterator: groq openai/gpt-oss-120b
- demo / demo_writer: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- demo / demo_writer: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- demo / demo_writer: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- questions / writer: groq openai/gpt-oss-120b
- demo / demo_writer: groq openai/gpt-oss-120b
- checks / blind_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / blind_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / numerical_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / fact_checker: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- correction / writer: groq openai/gpt-oss-120b
- correction / writer: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- checks / blind_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / blind_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / numerical_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / fact_checker: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / blind_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / blind_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / numerical_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / fact_checker: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- correction / writer: gemini gemini-3.6-flash
- correction / writer: groq openai/gpt-oss-120b
- correction / writer: gemini gemini-3.6-flash
- correction / writer: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- correction / writer: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- correction / writer: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- correction / writer: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- hinglish / transliterator: gemini gemini-3.6-flash
- checks / blind_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / blind_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / numerical_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / fact_checker: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- correction / writer: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- correction / writer: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- correction / writer: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- correction / writer: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- checks / blind_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / blind_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / numerical_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / fact_checker: openrouter nvidia/nemotron-3-ultra-550b-a55b:free

## Issues
- diagram_dropped: c7: SVG failed the safety check
- diagram_dropped: c8: SVG failed the safety check
- checks_failed: questions group 0: q3: mcq options repeat; q4: mcq options repeat; q7: mcq answer text is not the keyed option
- checks_failed: questions group 1: q1: q/answer must be [hi,en]; q2: q/answer must be [hi,en]; q3: q/answer must be [hi,en]; q4: q/answer must be [hi,en]; q5: case_based needs a "case" passage (40+ words); q6: case_based needs a "case" passage (40+ words); q7: case_based needs a "case" passage (40+ words); q8: case_based needs a "case" passage (40+ words); q9: case_based needs a "case" passage (40+ words)
- crash: unhashable type: 'list' Traceback (most recent call last):
  File "/home/runner/work/DIPLOMA-BOY/DIPLOMA-BOY/chapter_job/book_robot.py", line 174, in run
    s = fn(job, r, P, depth, ref)
        ^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/runner/work/DIPLOMA-BOY/DIPLOMA-BOY/chapter_job/book_robot.py", line 411, in st_questions
    probs = question_problems(got, quota, ids)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/runner/work/DIPLOMA-BOY/DIPLOMA-BOY/chapter_job/book_robot.py", line 263, in question_problems
    if q.get('outcome') not in outcome_ids: p.append(f'q{i + 1}: unknown outcome {q.get("outcome")}')
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
TypeError: unhashable type: 'list'

- checks_failed: questions group 2: q1: case_based needs a "case" passage of 60-100 English words (yours has 29); write a real-life situation with every number the question needs; q3: case_based needs a "case" passage of 60-100 English words (yours has 27); write a real-life situation with every number the question needs; q4: case_based needs a "case" passage of 60-100 English words (yours has 37); write a real-life situation with every number the question needs; q5: case_based needs a "case" passage of 60-100 English words (yours has 21); write a real-life situation with every number the question needs
- checks_failed: questions group 2 (case_based): q3: case_based needs a "case" passage of 60-100 English words (yours has 32); write a real-life situation with every number the question needs; q4: case_based needs a "case" passage of 60-100 English words (yours has 22); write a real-life situation with every number the question needs; q5: case_based needs a "case" passage of 60-100 English words (yours has 34); write a real-life situation with every number the question needs
- checks_failed: demo: script error: cess/execution:451:12
    at [eval]-wrapper:6:24
    at runScriptInContext (node:internal/process/execution:449:60)
    at evalFunction (node:internal/process/execution:283:30)
    at evalTypeScript (node:internal/process/execution:295:3)
    at node:internal/main/eval_string:71:3

Node.js v24.22.2

- checks_failed: book checks: numerical 7: not code-verified (not verifiable: given symbol 'V1' not in registry); numerical 4: independent solver got a different answer; numerical 10: independent solver got a different answer; knowledge_understanding questions 38% (min 40%); copyright: 12 words in a row match a reference book: 'एकांक आवेश को एक बिंदु से दूसरे बिंदु तक ले जाने में'; question 4: answer-blind solver did not reach the key; question 19: answer-blind solver did not reach the key; question 24: answer-blind solver did not reach the key; Hindi term not the standard one for: resistor (2), charge (5), temperature (1), potential difference (2), filament (1), circuit (5), work (2), series (13), fuse (1), conductor (4
- correction_failed: pairs: JSONDecodeError: Extra data: line 11 column 4 (char 965)
- checks_failed: book checks: copyright: 16 words in a row match a reference book: 'the potential difference across a conductor is directly proportional to the elec'; question 2: answer-blind solver did not reach the key; question 8: answer-blind solver did not reach the key; Hindi term not the standard one for: potential difference (1), circuit (1), series (1), conductor (1); 1 Hindi/English pairs carry different numbers
