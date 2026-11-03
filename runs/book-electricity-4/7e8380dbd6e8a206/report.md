# Electricity — needs_review (book format)
review_ready = all automatic checks passed; NOT published; owner review needed.

- resolve: done (attempts 0, calls 0)
- reference: done (attempts 0, calls 0)
- plan: done (attempts 1, calls 1)
- concepts: done (attempts 0, calls 11)
- extras: done (attempts 1, calls 1)
- teach: done (attempts 0, calls 3)
- hinglish: done (attempts 0, calls 3)
- demo: done (attempts 1, calls 1)
- correction: pending (attempts 0, calls 1)

## Checks
```
{
 "notes_words": {
  "hi": 3251,
  "en": 2931
 },
 "teach_words": {
  "hindi": 4817,
  "english": 4161
 },
 "panels": 20,
 "teach_sections": 15,
 "diagrams": 8,
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
 "copyright": {
  "overlap": 0.1246,
  "threshold": 0.2,
  "note": "automatic metric, not legal clearance"
 },
 "numericals": [
  {
   "n": 1,
   "stored": "Resistance R = 2 Ω",
   "solver": "2 Ω",
   "agree": true
  },
  {
   "n": 2,
   "stored": "Power P = 5290 W",
   "solver": "5290 W",
   "agree": true
  },
  {
   "n": 3,
   "stored": "Energy E = 0.3 kWh",
   "solver": "0.3 kWh",
   "agree": true
  },
  {
   "n": 4,
   "stored": "Parallel resistance R = 2 Ω",
   "solver": "2 Ω",
   "agree": true
  },
  {
   "n": 5,
   "stored": "Potential Difference V = 0.204 V",
   "solver": "0.204 V",
   "agree": true
  }
 ],
 "fact_check": {
  "correct": false,
  "reason": "In the 'Potential Difference' section, the definition 'Voltage is the ability to push electrons from one point to another' is misleading. Voltage (potential difference) is defined as the work done per unit charge (W/Q) to move a charge between two points, not a 'force' or 'ability to push'. The phrase 'ability to push electrons' describes electromotive force (EMF) or electric field conceptually, b"
 },
 "problems": [
  "fact check failed: In the 'Potential Difference' section, the definition 'Voltage is the ability to push electrons from one point to another' is misleading. Voltage (potential difference) is defined as the work done per unit charge (W/Q) to move a charge between two points, not a 'force' or 'ability to push'. The phrase 'ability to push electrons' describes electromotive force (EMF) or electric field conceptually, b"
 ]
}
```

## Who did what
- reference / researcher: groq openai/gpt-oss-120b
- plan / planner: groq openai/gpt-oss-120b
- concepts / writer: groq openai/gpt-oss-120b
- concepts / writer: groq openai/gpt-oss-120b
- concepts / writer: groq openai/gpt-oss-120b
- concepts / writer: groq openai/gpt-oss-120b
- concepts / writer: groq openai/gpt-oss-120b
- concepts / writer: groq openai/gpt-oss-120b
- concepts / writer: groq openai/gpt-oss-120b
- concepts / writer: groq openai/gpt-oss-120b
- concepts / writer: groq openai/gpt-oss-120b
- concepts / writer: groq openai/gpt-oss-120b
- concepts / writer: groq openai/gpt-oss-120b
- extras / writer: groq openai/gpt-oss-120b
- teach / teacher: groq openai/gpt-oss-120b
- teach / teacher: groq openai/gpt-oss-120b
- teach / teacher: groq openai/gpt-oss-120b
- hinglish / transliterator: cloudflare @cf/meta/llama-3.3-70b-instruct-fp8-fast
- hinglish / transliterator: groq openai/gpt-oss-120b
- hinglish / transliterator: groq openai/gpt-oss-120b
- demo / demo_writer: groq openai/gpt-oss-120b
- checks / numerical_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / fact_checker: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / numerical_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / fact_checker: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- correction / writer: groq openai/gpt-oss-120b
- checks / numerical_solver: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- checks / fact_checker: openrouter nvidia/nemotron-3-ultra-550b-a55b:free

## Issues
- checks_failed: concepts: c1: needs 3+ key-value items; c2: needs 3+ key-value items; c3: needs 3+ key-value items; c1: diagram missing or unsafe SVG; c2: diagram missing or unsafe SVG
- crash: too many values to unpack (expected 2) Traceback (most recent call last):
  File "/home/runner/work/DIPLOMA-BOY/DIPLOMA-BOY/chapter_job/book_robot.py", line 141, in run
    state = st_checks(job, r, P, refset)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/runner/work/DIPLOMA-BOY/DIPLOMA-BOY/chapter_job/book_robot.py", line 302, in st_checks
    ch = assemble(job); row = R.chapter_row(ch, os.environ.get('BOOK_SLUG', 'class10-science'), r['chapter_no'], r['app']['chapter_id'])
                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/runner/work/DIPLOMA-BOY/DIPLOMA-BOY/chapter_job/book_render.py", line 182, in chapter_row
    'notes_hi': notes_html(ch, 'hi'), 'notes_en': notes_html(ch, 'en')
- checks_failed: book checks: numerical 2: independent solver got a different answer; numerical 3: independent solver got a different answer; fact check failed: In the 'Heating Effect' section, the text states: 'Q = I²Rt, गर्मी का उत्पादन धारा, प्रतिरोध और समय पर निर्भर ... P = I²R, जहाँ P पावर (वॉट) है ... उच्च प्रतिरोध वाले हीटर कम धारा में अधिक गर्मी उत्पन्न करते हैं'. The claim that 'high resistance heaters produce more heat at low current' is misleading. For a fixed supply voltage (as in household heaters), heat/power P = V²/R, so lower resistance pr
- checks_failed: book checks: fact check failed: In the 'Potential Difference' section, the definition 'Voltage is the ability to push electrons from one point to another' is misleading. Voltage (potential difference) is defined as the work done per unit charge (W/Q) to move a charge between two points, not a 'force' or 'ability to push'. The phrase 'ability to push electrons' describes electromotive force (EMF) or electric field conceptually, b
