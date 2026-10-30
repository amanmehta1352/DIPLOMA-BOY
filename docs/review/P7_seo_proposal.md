# P7 — SEO: proposed changes (DIFF ONLY — nothing applied to index.html / site root)

Site: https://amanmehta1352.github.io/DIPLOMA-BOY/ (GitHub Pages project site).

## Important limitation
Crawlers read robots.txt **only at the domain root** (`amanmehta1352.github.io/robots.txt`), which belongs to a different repo (`amanmehta1352.github.io`). A robots.txt inside DIPLOMA-BOY has no effect. The sitemap still works if submitted in Google Search Console (URL-prefix property for `/DIPLOMA-BOY/`).

## What the diff does
1. `index.html` head: longer `<title>`, `canonical`, `og:url`, `og:type`, `og:locale`.
2. `index.html` body: static Hindi + English intro inside `<main id="app">`. The app replaces `#app` content on first render (lines 821/824), so users see the normal app; crawlers and no-JS visitors see the intro. No CSS/JS change.
3. New `sitemap.xml` (home, privacy, terms). New `robots.txt` (documentation only, see limitation).

## Shareable URL scheme (proposal)
- Today the app has **no routing** (no hash/query handling), so every screen shares one URL.
- Proposal: `?s=<subject-slug>&c=<chapter-slug>&lv=<level-id>` e.g. `/DIPLOMA-BOY/?s=maths&c=percentage&lv=banking`. Query URLs work on GitHub Pages without 404s; on load, the app reads them and opens Learn → that chapter.
- For real search indexing (one page per chapter), a later step can generate static `learn/<subject>/<chapter>/index.html` pages (title, intro, link into the app) and list them in the sitemap. Hash URLs (`#/…`) are not indexed separately, so they are not recommended.

## Diffs
```diff
--- a/index.html	2026-10-30 17:09:43.819848500 +0000
+++ b/index.html	2026-10-30 17:09:43.838143281 +0000
@@ -11,7 +11,11 @@
 <link rel="icon" href="icons/icon.svg" type="image/svg+xml">
 <link rel="icon" href="icons/icon-192.png" sizes="192x192" type="image/png">
 <link rel="apple-touch-icon" href="icons/apple-touch-icon.png">
-<title>Diploma Boy</title>
+<title>Diploma Boy — RRB JE, SSC JE और Diploma परीक्षा की तैयारी</title>
+<link rel="canonical" href="https://amanmehta1352.github.io/DIPLOMA-BOY/">
+<meta property="og:url" content="https://amanmehta1352.github.io/DIPLOMA-BOY/">
+<meta property="og:type" content="website">
+<meta property="og:locale" content="hi_IN">
 <link rel="preconnect" href="https://fonts.googleapis.com">
 <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
 <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Mukta:wght@400;500;600;700;800&display=swap">
@@ -244,7 +248,11 @@
   <div class="lang" role="group" aria-label="भाषा / Language"><button data-lang="hi">हिं</button><button data-lang="both">दोनों</button><button data-lang="en">EN</button></div>
   <button class="avatar hide" id="avatar" data-a="tab" data-id="me" aria-label="मैं / Me"></button>
 </div></header>
-<main class="wrap" id="app"></main>
+<main class="wrap" id="app"><section class="seo-intro" lang="hi">
+  <h1>Diploma Boy: Diploma और सरकारी परीक्षाओं की मुफ़्त तैयारी</h1>
+  <p>RRB JE, SSC JE, RRB NTPC और राज्य स्तरीय तकनीकी परीक्षाओं के लिए पिछले वर्षों के प्रश्न (PYQ), अध्यायवार प्रैक्टिस, मॉक टेस्ट और हिंदी में आसान नोट्स।</p>
+  <p lang="en">Free preparation for Diploma-level and government exams: previous year questions, chapter-wise practice, mock tests and simple notes in Hindi and English, for Maths, Reasoning, General Science, General Awareness and Civil, Mechanical and Electrical Engineering.</p>
+</section></main>
 <nav class="dock hide" id="dock"><div class="wrap" id="dockin"></div></nav>
 <div id="layer"></div>
 
--- /dev/null	2026-10-30 09:37:31.060963386 +0000
+++ b/sitemap.xml	2026-10-30 17:09:43.824312720 +0000
@@ -0,0 +1,6 @@
+<?xml version="1.0" encoding="UTF-8"?>
+<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
+  <url><loc>https://amanmehta1352.github.io/DIPLOMA-BOY/</loc><lastmod>2026-10-30</lastmod><changefreq>weekly</changefreq><priority>1.0</priority></url>
+  <url><loc>https://amanmehta1352.github.io/DIPLOMA-BOY/privacy.html</loc><lastmod>2026-10-30</lastmod><changefreq>yearly</changefreq><priority>0.2</priority></url>
+  <url><loc>https://amanmehta1352.github.io/DIPLOMA-BOY/terms.html</loc><lastmod>2026-10-30</lastmod><changefreq>yearly</changefreq><priority>0.2</priority></url>
+</urlset>
--- /dev/null	2026-10-30 09:37:31.060963386 +0000
+++ b/robots.txt	2026-10-30 17:09:43.822931525 +0000
@@ -0,0 +1,7 @@
+# Diploma Boy — https://amanmehta1352.github.io/DIPLOMA-BOY/
+# Note: crawlers read robots.txt only at the domain root (amanmehta1352.github.io/robots.txt).
+# This file documents intent; submit the sitemap in Google Search Console.
+User-agent: *
+Allow: /DIPLOMA-BOY/
+Disallow: /DIPLOMA-BOY/delete-data.html
+Sitemap: https://amanmehta1352.github.io/DIPLOMA-BOY/sitemap.xml
```
