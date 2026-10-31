// Diploma Boy v4: Dashboard file is the app; the student picks a level and sees only that level's content. Run: node tests/app.test.js
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

  // First run: the level picker opens; nothing level-specific is shown before a choice
  check('first run asks for the level', await p.isVisible('#qualModal.active'));
  const qItems = await p.$$eval('.qual-item', e => e.map(x => x.dataset.q));
  check('picker lists all school, job, entrance and higher levels', qItems.length >= 28 && qItems.includes('exam:class-10') && qItems.includes('exam:neet-ug') && qItems.includes('level:advanced_research'));
  check('Diploma (Polytechnic) is a choice', qItems.includes('exam:diploma-polytechnic'));
  check('picker cannot be closed before a choice', !(await p.isVisible('#qualClose')));
  await p.screenshot({ path: path.join(SHOTS, 'v4-0-level-picker.png') });
  await p.click('.qual-item[data-q="exam:ssc-je"]'); await p.waitForTimeout(3500);
  check('SSC JE maps to govt_technical', await p.evaluate(() => DB.level === 'govt_technical'));

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
  check('SSC JE library: Physics book first + 7 subjects', books.length === 8 && /भौतिकी/.test(books[0]) && books.some(x => /सिविल/.test(x)));
  check('11 chapters badge', (await p.textContent('#appGrid .badge')).trim() === '11');
  check('library lists 11 chapters', (await p.$$eval('#chapterList [data-ch]', e => e.length)) === 11);
  await p.screenshot({ path: path.join(SHOTS, 'v4-2-library.png') });
  await p.evaluate(() => document.getElementById('chapterList').scrollIntoView()); await p.waitForTimeout(300);
  await p.screenshot({ path: path.join(SHOTS, 'v4-2b-chapters.png') });

  // Open book: original physics reader in the frame, data from the server
  await p.click('#chapterList [data-ch="1"]'); await p.waitForTimeout(4000);
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
  check('formulas: 104 from the Physics book + this level\'s own', nF >= 104 + 100);
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

  // Cloud backup (server mocked: nothing is written to the real database during tests)
  const store = {}; let saved = null;
  await p.route('**/rest/v1/rpc/progress_save', async r => { const b = JSON.parse(r.request().postData()); saved = b; store[b.p_code.replace(/[^A-Z0-9]/gi, '').toUpperCase()] = b.p_data;
    await r.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify(new Date().toISOString()) }); });
  await p.route('**/rest/v1/rpc/progress_load', async r => { const b = JSON.parse(r.request().postData()); const d = store[b.p_code];
    await r.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify(d ? { data: d, updated_at: new Date().toISOString() } : null) }); });
  await p.click('#settingsBtn'); await p.waitForTimeout(400);
  check('backup off by default', await p.isVisible('[data-bk=on]'));
  await p.click('[data-bk=on]'); await p.waitForTimeout(800);
  const code = (await p.textContent('#bkCode')).trim();
  check('backup code shown (20 chars)', /^[A-Z2-9]{4}(-[A-Z2-9]{4}){4}$/.test(code));
  check('backup sent without the name', !!saved && !('name' in saved.p_data) && !!saved.p_data.chapters['physics-baseline:1']);
  await p.evaluate(() => document.getElementById('backupBox').scrollIntoView()); await p.waitForTimeout(300);
  await p.screenshot({ path: path.join(SHOTS, 'v4-12-backup.png') });
  await p.click('[data-bk=erase]'); await p.click('[data-bk=erase2]'); await p.waitForTimeout(600);
  check('erase clears this phone', await p.evaluate(() => Object.keys(DB.chapters).length === 0 && DB.name === ''));
  await p.click('[data-bk=restore]'); await p.fill('#bkInput', code.toLowerCase()); await p.click('[data-bk=find]'); await p.waitForTimeout(500);
  await p.click('[data-bk=apply]'); await p.waitForTimeout(1200);
  check('restore brings progress back', await p.evaluate(() => !!(DB.chapters['physics-baseline:1'] || {}).read && DB.quiz['physics-baseline:1'].c === 1));
  await p.click('#settingsClose'); await p.waitForTimeout(300);

  // ---- Level filter: Class 10 sees only Class 9-10 content (no Physics book, no engineering, no PhD) ----
  await p.click('#settingsBtn'); await p.waitForTimeout(300); await p.click('#qualOpenBtn'); await p.waitForTimeout(800);
  check('picker can be closed once a level exists', await p.isVisible('#qualClose'));
  await p.click('.qual-item[data-q="exam:class-10"]'); await p.waitForTimeout(3500);
  await p.click('.nav-item[data-view=library]'); await p.waitForTimeout(800);
  const b10 = await p.$$eval('#appGrid .app-icon', e => e.map(x => x.textContent.trim()));
  check('Class 10: 3 subjects, no Physics book, no engineering', b10.length === 3 && !b10.some(x => /Physics|भौतिकी|Engineering|इंजीनियरिंग/.test(x)));
  check('Class 10: every book is class_9_10', await p.evaluate(() => BOOKS.every(b => b.level === 'class_9_10' && b.kind === 'atoms')));
  check('Class 10: ghost list does not carry SSC JE chapters', await p.evaluate(() => buildState().forgetting.length === 0));
  await p.screenshot({ path: path.join(SHOTS, 'v4-13-library-class10.png') });
  const before = reqs.length;
  await p.click('#chapterList [data-ch] >> nth=0'); await p.waitForTimeout(4500);
  const lf = p.frame({ url: /level-book\.html/ });
  check('chapter opens in the book reader (same look as the Physics book)', !!lf);
  if (lf) {
    await lf.waitForSelector('#readerContent .teach-theme', { timeout: 15000 }).catch(() => {});
    const teach = await lf.innerText('#readerContent');
    check('Lecture = Teach tab: concept, formula, example and questions', /समझो|Concept|💡/.test(teach) && /✏️/.test(teach) && /🧮/.test(teach) && /अब तुम बताओ|Your turn/.test(teach));
    check('chapter atoms requested only for class_9_10', reqs.slice(before).filter(u => /get_chapter_atoms/.test(u)).every(u => /p_level=class_9_10/.test(u)) && reqs.slice(before).some(u => /get_chapter_atoms/.test(u)));
    await p.screenshot({ path: path.join(SHOTS, 'v4-14-chapter-lecture.png') });
    await lf.click('.lb-mcq .lb-opt >> nth=0'); await p.waitForTimeout(400);
    check('check question answered and counted in the app', await p.evaluate(() => Object.keys(DB.quiz).some(k => k.startsWith('s:class_9_10:') && DB.quiz[k].t === 1)));
    await p.click('#modeReader'); await p.waitForTimeout(1500);
    check('Reader = Notes tab (notebook paper)', await lf.$('#readerContent .notes-paper') !== null);
    check('fractions are drawn stacked (25/100 style)', (await lf.$$eval('#readerContent .frac', e => e.length)) > 0);
    await p.screenshot({ path: path.join(SHOTS, 'v4-15-chapter-reader.png') });
    for (const t of ['book', 'formula', 'diagram']) { await lf.click(`.nav-btn[data-tab="${t}"]`); await p.waitForTimeout(900); }
    check('book, formula and diagram tabs render', /book-chaps|fcard|lb-fig|notes-paper/.test(await lf.innerHTML('#readerContent')));
    await lf.click('.nav-btn[data-tab="book"]'); await p.waitForTimeout(900);
    // same controls as the Physics book: language buttons, Book contents list, Teach language buttons, formula filter
    check('level book has the hi / EN / both language buttons', (await lf.$$eval('.lang-toggle .lang-btn', e => e.map(x => x.dataset.lang).join())) === 'hi,en,both');
    check('Book tab lists notes and lessons that jump into the tab', (await lf.$$eval('.book-list .book-item', e => e.length)) >= 2);
    await lf.click('.nav-btn[data-tab="notes"]'); await p.waitForTimeout(900);
    await lf.click('.lang-toggle .lang-btn[data-lang="en"]'); await p.waitForTimeout(1200);
    check('EN button switches the book and shows the Hindi-only note', await lf.evaluate(() => document.body.dataset.lang === 'en') && await lf.evaluate(() => !!document.querySelector('.lang-pending')));
    await lf.click('.lang-toggle .lang-btn[data-lang="hi"]'); await p.waitForTimeout(1200);
    await lf.click('.nav-btn[data-tab="teach"]'); await p.waitForTimeout(900);
    check('Teach tab has Hindi / English / Bilingual / Hinglish buttons', (await lf.$$eval('.lang-switcher .lang-btn', e => e.length)) === 4);
    await lf.click('.nav-btn[data-tab="formula"]'); await p.waitForTimeout(900);
    check('Formula tab has filter chips', (await lf.$$eval('#formulaChips .filter-chip', e => e.length)) >= 1);
    await lf.click('.nav-btn[data-tab="book"]'); await p.waitForTimeout(900);
    await p.screenshot({ path: path.join(SHOTS, 'v4-15b-chapter-book.png') });
    const second = await p.evaluate(() => { const b = BOOKS.find(x => x.id === bookState.bookId); return b.chapters.filter(avail)[1].n; });
    await lf.evaluate(id => setChapter(id), second); await p.waitForTimeout(1500);
    check('chapter bar moves to the next chapter', await lf.evaluate(() => __curCh()) === second);
  }
  await p.click('#backToLib'); await p.waitForTimeout(600);
  await p.click('.nav-item[data-view=formulas]'); await p.waitForTimeout(3000);
  check('Class 10 formulas: only this level (74), no Physics book formulas', (await p.$$eval('#formulaBox .card', e => e.length)) === 74 && !/dyne/.test(await p.innerText('#formulaBox')));
  // PhD level: only its own 3 chapters
  await p.evaluate(() => openQual()); await p.waitForTimeout(800);
  await p.click('.qual-item[data-q="level:advanced_research"]'); await p.waitForTimeout(3500);
  check('PhD: only advanced_research content (3 ready chapters)', await p.evaluate(() => BOOKS.length > 0 && BOOKS.every(b => b.level === 'advanced_research') && allChapters().length === 3));
  await p.click('.nav-item[data-view=library]'); await p.waitForTimeout(600);
  const phdTxt = await p.innerText('#library-view');
  check('PhD library shows no class content', !/कक्षा 9|Class 9|प्रतिशत/.test(phdTxt.replace(/आज का विचार[\s\S]*?—[^\n]*/, '')));
  await p.screenshot({ path: path.join(SHOTS, 'v4-16-library-phd.png') });

  // Old question bank never requested
  check('no question-bank requests', !reqs.some(u => /\/rest\/v1\/(atoms|questions|pyq|practice|mock|papers)/.test(u)));
  check('no horizontal overflow', !(await p.evaluate(() => document.documentElement.scrollWidth > innerWidth)));
  check('no page errors', errs.length === 0);

  // Robot drafts: a wrong review code shows nothing (drafts are only for the owner)
  const pr = await ctx.newPage(); await pr.goto(URL + 'level-book.html?l=govt_technical&s=maths&ch=1&review=WRONGCODEWRONGCODEWRONG'); await pr.waitForTimeout(4000);
  check('wrong review code shows no draft', (await pr.$$eval('.lb-review', e => e.length)) === 0 && (await pr.$$eval('.lb-mcq', e => e.length)) === 0);
  await pr.close();
  // Step-by-step solutions page (owner's masterclass format) from server data; unsafe html is removed
  const B2 = (e, h) => ({en: e, hi: h}), stp = h => ({en: 'Step.', hi: 'कदम।', html: h});
  const sol = {topic: {key: 'e', ...B2('Election', 'चुनाव')}, type: {key: 't', ...B2('Two', 'दो')}, q: B2('Q 60%', 'सवाल 60%'),
    methods: [{key: 'a', primary: true, name: B2('Base-100', 'Base-100'), steps: [stp('<div class="arr">➔</div> 20% <img src=x onerror="window.HACK=1">'), stp('<span class="rough-circle">6000</span>')], answer: {...B2('6000', '6000'), value: 6000}},
              {key: 'b', primary: true, name: B2('Fraction', 'भिन्न'), steps: [stp('1/5'), stp('<span class="rough-circle">6000</span>')], answer: {...B2('6000', '6000'), value: 6000}}],
    quiz: {q: B2('q', 'q'), options: [B2('a', 'क'), B2('b', 'ख'), B2('c', 'ग')], answer: 1}};
  const ps = await ctx.newPage(); const serr = []; ps.on('pageerror', e => serr.push(e.message));
  await ps.route('**/rest/v1/rpc/get_chapter_solutions', r => r.fulfill({json: [{slot: 1, data: sol}]}));
  await ps.goto(URL + 'solve.html?l=govt_technical&ch=1'); await ps.waitForTimeout(1500);
  check('solutions page: 2 method tabs', (await ps.$$eval('.m-tab', e => e.length)) === 2);
  await ps.click('#next-btn'); await ps.click('#next-btn'); await ps.waitForTimeout(400);
  check('solutions page: steps reveal one by one, answer shown', (await ps.$$eval('.math-step.visible', e => e.length)) === 2 && await ps.isVisible('#ans-box'));
  check('solutions page: unsafe html removed', (await ps.$$eval('.math-step img', e => e.length)) === 0 && !(await ps.evaluate(() => window.HACK)) && serr.length === 0);
  await ps.close();
  await b.close(); srv.close();
  console.log('PASS', ok.length, ok.join(' | '));
  if (bad.length) { console.log('FAIL', bad.length, bad.join(' | ')); if (errs.length) console.log('errors:', errs); process.exit(1); }
})().catch(e => { console.error(e); process.exit(1); });
