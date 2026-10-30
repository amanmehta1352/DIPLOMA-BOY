# P8 — Copyright / raw files in the public repo: list and safe migration plan (NOTHING MOVED YET)

Repo `amanmehta1352/DIPLOMA-BOY` is **public** (GitHub Pages on). All files below entered history in commit `009986b` (2026-10-24) and are public since then.

| File | Size | What it is | Risk |
|---|---|---|---|
| `robots/import/inputs/ssc-je-2023-10-11-mech-s2-en.pdf` | 5.1 MB | Copy of an SSC JE 2023 exam paper (English) | **High** — redistributing a full paper copy (possibly a third-party copy with its branding) |
| `robots/import/inputs/ssc-je-2023-10-11-mech-s2-hi.pdf` | 6.5 MB | Same paper, Hindi | **High** |
| `robots/import/inputs/ntpc_jobs.json` | 74 KB | 152 import jobs with third-party URLs (adda247.com paper compilations) | Medium — no paper text, but exposes third-party sourcing |
| `content/practice/science-{physics,chemistry,biology}.txt` | ~260 KB | Practice questions; README says written in own words | Low — keep, but spot-check a sample against common books |

Not files, but related: `mtb.sources` allows `kind = 'third_party_copy'`. Questions imported from third-party copies are a separate review (not in this step).

## Safe migration plan (needs your approval at steps 3 and 5)
1. **Mirror backup first:** `git clone --mirror` of the repo kept privately (local disk or a private repo). Nothing is lost if a later step goes wrong.
2. **Private storage:** create a **private** Supabase Storage bucket `raw-inputs` (no public access, service-role only) or a separate **private** GitHub repo `DIPLOMA-BOY-private`. Upload the 3 robot input files; verify SHA-256 matches.
3. **Stop publishing them (normal commit, reversible):** `git rm --cached` the 3 files, add `robots/import/inputs/` to `.gitignore`, point the importer to the private bucket. Site keeps working (these files are not used by `index.html`).
4. Check whether the importer (`robots/import/*.py`) reads local paths; switch it to download from the private bucket with the service key from env (never commit the key).
5. **History removal (destructive — only with explicit approval):**
   - Tool: `git filter-repo --invert-paths --path robots/import/inputs/ssc-je-2023-10-11-mech-s2-en.pdf --path robots/import/inputs/ssc-je-2023-10-11-mech-s2-hi.pdf --path robots/import/inputs/ntpc_jobs.json`
   - Then force-push **all** branches and tags.
   - Risks: every commit hash after `009986b` changes; open PRs and links to old commits break; anyone with an existing clone/fork still has the files; GitHub may keep cached views until you ask GitHub Support to purge; Pages rebuilds once.
   - Removal lowers exposure but cannot recall copies already downloaded since 2026-10-24.
6. Verify: `git log --all -- <paths>` returns nothing; repo size drops (~11.7 MB); site still loads; importer runs from private storage.

Recommendation: do steps 1–4 now (no history rewrite), and step 5 only after you confirm.
