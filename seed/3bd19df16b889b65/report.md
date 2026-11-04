# Electricity — failed (book format)
review_ready = all automatic checks passed; NOT published; owner review needed.

- resolve: done (attempts 0, calls 0)
- reference: done (attempts 0, calls 0)
- outcomes: done (attempts 1, calls 1)
- plan: done (attempts 1, calls 1)
- concepts: done (attempts 0, calls 5)
- extras: done (attempts 1, calls 1)
- questions: running (attempts 0, calls 10)

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

