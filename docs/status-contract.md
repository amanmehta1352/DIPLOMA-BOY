# status.json contract (schema 1)
Written by robots/health/health.py to branch `status` (files status.json, history.json). COUNTS ONLY — the repo is public.

```
{ schema: 1, app: "diploma-boy", at: ISO, overall: "ok"|"warn"|"bad",
  checks: [ { id, label_hi, state: "ok"|"warn"|"bad", count: number|null, detail: string, link: url|null } ],
  robots: [ { id, label_hi, what_hi, last_run: ISO, result: "success"|"failure"|..., branch } ],
  numbers: { published, draft, hidden, total, by_exam: { <exam-slug>: { published, draft, hidden } } },
  backup_verify: { checked_at, slot, backup_rows, missing_in_live, changed_since } | null,
  site: { url, ok, ms, sw }, errors: { <source>: <error name> } }
```
Rules: a new robot only adds entries to `checks` / `robots`; the Control Room draws whatever list it gets, so no UI change is needed.
`overall` = worst check state. A failing data source becomes a red check, never a crash.
Control Room apps are listed in control/apps.json (one entry per app).
