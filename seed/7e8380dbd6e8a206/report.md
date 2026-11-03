# Electricity — failed (book format)
review_ready = all automatic checks passed; NOT published; owner review needed.

- resolve: done (attempts 0, calls 0)
- reference: done (attempts 0, calls 0)
- plan: done (attempts 1, calls 1)
- concepts: done (attempts 0, calls 11)
- extras: done (attempts 1, calls 1)
- teach: done (attempts 0, calls 3)
- hinglish: done (attempts 0, calls 3)
- demo: done (attempts 1, calls 1)

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
