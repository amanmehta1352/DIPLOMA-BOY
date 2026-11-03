# Science (Class 10): chapter 11 Electricity  —  failed
Job 959a206c8abbcb0f · runs 1 · syllabus CBSE 2026-27 · source https://edustud.nic.in/edu/Syllabus_2026_27/10/10_Science_SYLLABUS_2026_27_EM.pdf
review_ready means: every automatic check ran and passed. It is NOT published and NOT proof of correctness; a human review is required.
Hindi chapter title status: third_party

## Syllabus coverage
Outcomes: Chapter-level outcomes are not printed in the source; the competency split for the paper is Knowledge/Understanding 50%, Application 30%, Analyse/Evaluate/Create 20%.

## Checks

## Stages
- resolve: done (attempts 0)
- blueprint: done (attempts 0)
- write_en: running (attempts 1)
- translate_hi: pending (attempts 0)
- package: pending (attempts 0)

## Who did what (as returned by each provider)
- write_en / writer: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- write_en / fact_checker_en: gemini gemini-3.6-flash
- write_en / solver_mcq1: gemini gemini-3.6-flash
- write_en / solver_mcq2: gemini gemini-3.6-flash

## Unresolved issues
- crash: groq: key missing or free tier not confirmed by owner Traceback (most recent call last):
  File "/home/runner/work/DIPLOMA-BOY/DIPLOMA-BOY/chapter_job/providers.py", line 95, in solve
    txt, prov, model = self._gemini(p, json_mode=False)
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/runner/work/DIPLOMA-BOY/DIPLOMA-BOY/chapter_job/providers.py", line 79, in _gemini
    raise ProviderUnavailable('gemini: ' + last)
job.ProviderUnavailable: gemini: gemini-3.8-flash: HTTP 503

During handling of the above exception, another exception occurred:

Traceback (most recent call 
