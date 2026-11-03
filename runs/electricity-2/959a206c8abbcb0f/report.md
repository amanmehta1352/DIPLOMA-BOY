# Science (Class 10): chapter 11 Electricity  —  needs_review
Job 959a206c8abbcb0f · runs 2 · syllabus CBSE 2026-27 · source https://edustud.nic.in/edu/Syllabus_2026_27/10/10_Science_SYLLABUS_2026_27_EM.pdf
review_ready means: every automatic check ran and passed. It is NOT published and NOT proof of correctness; a human review is required.
Hindi chapter title status: third_party

## Syllabus coverage
Outcomes: Chapter-level outcomes are not printed in the source; the competency split for the paper is Knowledge/Understanding 50%, Application 30%, Analyse/Evaluate/Create 20%.

## Checks

## Check status (English attempt 2, then Hindi)
inconclusive = the check did not get a result in this run (job stopped first); skipped = an earlier gate failed.
- en structure: pass
- en scope: pass
- en units: pass
- en copyright: fail (26.3%)
- en fact_check_en: skipped: local gate failed
- en solve_mcq1: skipped: local gate failed
- en solve_mcq2: skipped: local gate failed
- en solve_mcq3: skipped: local gate failed
- hi local_hi: pending
- hi fact_check_hi: pending

## Stages
- resolve: done (attempts 0)
- blueprint: done (attempts 0)
- write_en: needs_review (attempts 3)
- translate_hi: pending (attempts 0)
- package: pending (attempts 0)

## Who did what (as returned by each provider)
- write_en / writer: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- write_en / fact_checker_en: gemini gemini-3.6-flash
- write_en / solver_mcq1: gemini gemini-3.6-flash
- write_en / solver_mcq2: gemini gemini-3.6-flash
- write_en / writer: openrouter nvidia/nemotron-3-ultra-550b-a55b:free
- write_en / writer: openrouter nvidia/nemotron-3-ultra-550b-a55b:free

## Provider calls (every HTTP try)
- openrouter nvidia/nemotron-3-ultra-550b-a55b:free: HTTP 200 ok (try 1, 33.92s)
- openrouter nvidia/nemotron-3-ultra-550b-a55b:free: HTTP 200 ok (try 1, 75.66s)

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
- reclassified: earlier final state "failed" was a provider outage misrecorded as a crash (fixed bug); now blocked
- checks_failed: English failed after 3 attempts: reply is not valid JSON: Invalid control character at: line 56 column 1118 (char 5170)
