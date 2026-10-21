// Same Pattern clip: closing the clip returns to the SAME question the student left. Run: node tests/pattern_return.test.js
const { chromium } = require('playwright');
const path = require('path'); const URL = 'file://' + path.resolve(__dirname, '../index.html');
(async () => {
  const b = await chromium.launch(process.env.PW_CHROMIUM ? { executablePath: process.env.PW_CHROMIUM } : {});
  const errs = []; const p = await b.newPage({ viewport: { width: 390, height: 844 }, isMobile: true });
  p.on('pageerror', e => errs.push(e.message));
  await p.goto(URL); await p.waitForTimeout(1500);
  await p.click('[data-a=onb-go]'); await p.click('[data-a=branch][data-id=mechanical]');
  // open a practice set from the chapter list through the real path: subject practice of the first pattern question
  const res = await p.evaluate(async () => {
    const rows = await sb('questions?status=eq.published&pattern_n=gt.1&select=*&limit=1');
    if (!rows.length) return { skipped: true };
    const q = norm(rows[0]);
    V.sheet = { mode: 'practice', title: 'T', list: [q, norm(rows[0])], i: 1, pick: null, c: 0, seen: 0, loading: false, meta: { subj: 'x' }, again: null };
    rSheet(true);
    const before = { i: V.sheet.i, title: V.sheet.title };
    startPattern(q.pat, q.patn);
    await new Promise(r => setTimeout(r, 900));
    const inPattern = !!(V.sheet && V.sheet.meta && V.sheet.meta.pat);
    document.querySelector('[data-a=close]').click();
    await new Promise(r => setTimeout(r, 200));
    return { before, inPattern, after: { i: V.sheet && V.sheet.i, title: V.sheet && V.sheet.title, list: V.sheet && V.sheet.list.length } };
  });
  console.log(JSON.stringify(res)); console.log('errors', errs);
  await b.close();
  const bad = !res.inPattern || res.skipped || res.after.i !== res.before.i || res.after.title !== res.before.title || errs.length;
  process.exit(bad ? 1 : 0);
})();
