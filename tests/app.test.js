// Diploma Boy v4: Dashboard file is the app, Physics book from the server. Run: node tests/app.test.js
const { chromium } = require('playwright');
const http = require('http'), fs = require('fs'), path = require('path');
const ROOT = path.resolve(__dirname, '..'), SHOTS = path.join(__dirname, 'shots');
const TYPES = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript', '.json': 'application/json', '.webmanifest': 'application/manifest+json', '.svg': 'image/svg+xml', '.png': 'image/png' };
const srv = http.createServer((q, r) => {
  let f = path.join(ROOT, decodeURIComponent(q.url.split('?')[0])); if (f.endsWith('/')) f += 'index.html';
  fs.readFile(f, (e, d) => { if (e) { r.writeHead(404); return r.end(); } r.writeHead(200, { 'Content-Type': TYPES[path.extname(f)] || 'application/octet-stream' }); r.end(d); });
});
const ok = [], bad = [];
const check = (name, v) => (v ? ok : bad).push(name);
(async () => {
  await new Promise(r => srv.listen(0, r)); const URL = 'http://127.0.0.1:' + srv.address().port + '/';
  fs.mkdirSync(SHOTS, { recursive: true });
  const b = await chromium.launch(process.env.PW_CHROMIUM ? { executablePath: process.env.PW_CHROMIUM } : {});
  const ctx = await b.newContext({ viewport: { width: 390, height: 844 }, isMobile: true, hasTouch: true, deviceScaleFactor: 2 });
  const p = await ctx.newPage(); const errs = [], reqs = [];
  p.on('pageerror', e => errs.push(e.message)); p.on('request', q => reqs.push(q.url()));
  await p.goto(URL); await p.waitForFunction(() => window.BOOKS === undefined ? false : true).catch(() => {});
  await p.waitForTimeout(3500);

  // Dashboard: no invented numbers, no buddies / peers / toppers
  const dash = await p.textContent('#dashboard-view');
  check('dashboard renders (Hindi by default)', /मिशन कंट्रोल/.test(dash));
  check('Hindi mode: no English on dashboard', !/[A-Za-z]{3,}/.test(await p.innerText('#dashboard-view')));
  check('mission card comes before the time card', dash.indexOf('आज का मिशन') > -1 && dash.indexOf('आज का मिशन') < dash.indexOf('आईना →'));
  check('no dummy name', !/Rahul|Aman|Priya|Topper|buddy|Buddies|rank #/i.test(dash));
  check('real status bar', !/9:41/.test(await p.content()));
  check('fresh user starts at zero XP', /⭐ 0/.test(dash));
  await p.screenshot({ path: path.join(SHOTS, 'v4-1-dashboard.png') });

  // Library: Physics from the server
  await p.click('.nav-item[data-view=library]'); await p.waitForTimeout(800);
  const books = await p.$$eval('#appGrid .app-icon', e => e.map(x => x.textContent.trim()));
  check('library shows the Physics book', books.length === 1 && /Physics|भौतिकी/.test(books[0]));
  check('11 chapters badge', (await p.textContent('#appGrid .badge')).trim() === '11');
  check('library lists 11 chapters', (await p.$$eval('#chapterList [data-ch]', e => e.length)) === 11);
  await p.screenshot({ path: path.join(SHOTS, 'v4-2-library.png') });
  await p.evaluate(() => document.getElementById('chapterList').scrollIntoView()); await p.waitForTimeout(300);
  await p.screenshot({ path: path.join(SHOTS, 'v4-2b-chapters.png') });

  // Open book: original physics reader in the frame, data from the server
  await p.click('#appGrid .app-icon'); await p.waitForTimeout(4000);
  const fr = p.frame({ url: /book\.html/ });
  check('book frame loaded', !!fr);
  if (fr) {
    check('book has chapter content', (await fr.evaluate(() => document.body.innerText.length)) > 2000);
    check('book chapter is 1', await fr.evaluate(() => window.__curCh() === 1));
  }
  await p.screenshot({ path: path.join(SHOTS, 'v4-3-book-lecture.png') });
  await p.click('#modeReader'); await p.waitForTimeout(1200);
  await p.screenshot({ path: path.join(SHOTS, 'v4-4-book-reader.png') });
  await p.click('#backToLib'); await p.waitForTimeout(800);
  check('back returns to library', await p.isVisible('#library-view.active'));

  // Formulas from the server
  await p.click('.nav-item[data-view=formulas]'); await p.waitForTimeout(3000);
  const nF = await p.$$eval('#formulaBox .card', e => e.length);
  check('104 formulas', nF === 104);
  await p.fill('#formulaSearch', 'dyne'); await p.waitForTimeout(300);
  check('formula search filters', (await p.$$eval('#formulaBox .card', e => e.length)) >= 1 && (await p.$$eval('#formulaBox .card', e => e.length)) < 10);
  await p.fill('#formulaSearch', ''); await p.waitForTimeout(300);
  await p.screenshot({ path: path.join(SHOTS, 'v4-5-formulas.png') });

  // Ghost: empty until a chapter is read; then a check built from the book's own formulas
  await p.click('.nav-item[data-view=ghost]'); await p.waitForTimeout(500);
  check('ghost empty for new user', /कोई भूत नहीं|No ghosts/.test(await p.textContent('#ghostList')));
  await p.evaluate(() => { DB.chapters['physics-baseline:1'] = { secs: 300, first: Date.now() - 864e6, last: Date.now() - 864e6, read: true, lastRev: Date.now() - 864e6 };
    DB.days[ymd()] = { t: { book: 1500, focus: 600, idle: 300, dashboard: 120 }, fs: 1, qc: 0, qt: 0 }; saveState(); renderGhost(); });
  check('read chapter becomes a ghost', (await p.$$eval('.ghost-item', e => e.length)) === 1);
  await p.screenshot({ path: path.join(SHOTS, 'v4-6-ghost.png') });
  await p.click('.ghost-item .btn'); await p.waitForTimeout(1500);
  const opts = await p.$$eval('#quizOptions .quiz-opt', e => e.length);
  check('quiz has 4 options from formulas', opts === 4);
  await p.screenshot({ path: path.join(SHOTS, 'v4-7-quiz.png') });
  const ans = await p.evaluate(() => quizItem && quizItem.q.answer);
  await p.click(`#quizOptions .quiz-opt >> nth=${ans}`); await p.waitForTimeout(1800);
  check('correct answer counts', await p.evaluate(() => DB.quiz['physics-baseline:1'].c === 1 && DB.chapters['physics-baseline:1'].rev === 1));

  // Mirror + dashboard with real numbers
  await p.click('.nav-item[data-view=mirror]'); await p.waitForTimeout(500);
  check('mirror study = book + focus', (await p.textContent('#mirrorStudy')).trim() === '35 मि.');
  await p.screenshot({ path: path.join(SHOTS, 'v4-8-mirror.png') });
  await p.click('.nav-item[data-view=dashboard]'); await p.waitForTimeout(800);
  check('dashboard XP real (35 + 20)', /⭐ 55/.test(await p.textContent('#dashboard-view')));
  await p.evaluate(() => document.querySelectorAll('.reveal').forEach(e => e.classList.add('visible'))); await p.waitForTimeout(900);
  await p.screenshot({ path: path.join(SHOTS, 'v4-9-dashboard-used.png'), fullPage: true });

  // Settings profile
  await p.click('#settingsBtn'); await p.waitForTimeout(400);
  await p.fill('#profName', 'Aman'); await p.dispatchEvent('#profName', 'change');
  await p.fill('#profExam', '2027-03-01'); await p.dispatchEvent('#profExam', 'change');
  await p.screenshot({ path: path.join(SHOTS, 'v4-10-settings.png') });
  await p.click('#settingsClose'); await p.waitForTimeout(400);
  check('name + exam date used', /Aman/.test(await p.textContent('#dashboard-view .dash-header')) && /परीक्षा में \d+ दिन|days to exam/.test(await p.textContent('#dashboard-view .dash-header')));

  // English mode: whole interface English; the book keeps its own language buttons
  await p.evaluate(() => { Settings.lang = 'en'; Settings.save(); applySettings(); rerenderAll(); }); await p.waitForTimeout(500);
  const enText = await p.innerText('#dashboard-view');
  check('English mode: no Hindi on dashboard', !/[\u0900-\u097F]/.test(enText) && /MISSION CONTROL/.test(enText));
  check('English mode: nav in English', /Library/.test(await p.innerText('#bottomNav')));
  check('only two interface languages', (await p.$$eval('.lang-opt', e => e.map(x => x.dataset.lang).join())) === 'hi,en');
  await p.screenshot({ path: path.join(SHOTS, 'v4-11-dashboard-english.png') });

  // Old question bank never requested
  check('no question-bank requests', !reqs.some(u => /\/rest\/v1\/(atoms|questions|pyq|practice|mock|papers)/.test(u)));
  check('no horizontal overflow', !(await p.evaluate(() => document.documentElement.scrollWidth > innerWidth)));
  check('no page errors', errs.length === 0);

  await b.close(); srv.close();
  console.log('PASS', ok.length, ok.join(' | '));
  if (bad.length) { console.log('FAIL', bad.length, bad.join(' | ')); if (errs.length) console.log('errors:', errs); process.exit(1); }
})().catch(e => { console.error(e); process.exit(1); });
