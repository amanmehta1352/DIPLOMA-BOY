// Same Pattern clip: (a) current question is never in its own clip, count + title match; (b) return works from index 5;
// (c) nothing else in the pattern -> no empty clip, student goes back. Run: node tests/pattern_return.test.js
const { chromium } = require('playwright');
const path = require('path'); const URL = 'file://' + path.resolve(__dirname, '../index.html');
const wait = ms => new Promise(r => setTimeout(r, ms));
(async () => {
  const b = await chromium.launch(process.env.PW_CHROMIUM ? { executablePath: process.env.PW_CHROMIUM } : {});
  const errs = []; const p = await b.newPage({ viewport: { width: 390, height: 844 }, isMobile: true });
  p.on('pageerror', e => errs.push(e.message));
  await p.goto(URL); await p.waitForTimeout(1500);
  await p.click('[data-a=onb-go]'); await p.click('[data-a=branch][data-id=mechanical]');
  const res = await p.evaluate(async () => {
    const wait = ms => new Promise(r => setTimeout(r, ms));
    const rows = await sb('questions?status=eq.published&pattern_n=gt.2&select=*&limit=1');
    if (!rows.length) return { skipped: true };
    const q = norm(rows[0]);
    const filler = norm(rows[0]);
    // (a) current at index 0 of a 1-item practice list
    V.sheet = { mode: 'practice', title: 'T', list: [q], i: 0, pick: null, c: 0, seen: 0, loading: false, meta: { subj: q.subj }, again: null };
    await startPattern(q.pat, q.patn); await wait(200);
    const all = [...V.sheet.meta.kinds.exact, ...V.sheet.meta.kinds.same, ...V.sheet.meta.kinds.related];
    const a = { clip: !!V.sheet.clip, title: V.sheet.title, count: all.length, currentInside: all.some(x => x.id === q.id), dupes: all.length - new Set(all.map(x => x.id)).size, expectCount: q.patn - 1 };
    document.querySelector('[data-a=close]').click(); await wait(150);
    // (b) current at index 5 of a 6-item list: return to index 5
    V.sheet = { mode: 'practice', title: 'T6', list: [filler, filler, filler, filler, filler, q], i: 5, pick: null, c: 0, seen: 0, loading: false, meta: { subj: q.subj }, again: null };
    await startPattern(q.pat, q.patn); await wait(200);
    const clipOpen = V.sheet.meta.pat === q.pat;
    document.querySelector('[data-a=close]').click(); await wait(150);
    const b2 = { clipOpen, returnedTitle: V.sheet.title, returnedIndex: V.sheet.i, returnedLen: V.sheet.list.length };
    // (c) fake pattern with only the current question -> no empty clip, back to the set
    const realFetch = fetchPattern;
    fetchPattern = async () => [q];
    V.sheet = { mode: 'practice', title: 'T1', list: [q], i: 0, pick: null, c: 0, seen: 0, loading: false, meta: { subj: q.subj }, again: null };
    await startPattern(q.pat, q.patn); await wait(200);
    const c = { backToSet: V.sheet.title === 'T1', emptyClip: !!(V.sheet.meta && V.sheet.meta.pat) };
    fetchPattern = realFetch;
    return { skipped: false, a, b: b2, c };
  });
  console.log(JSON.stringify(res)); console.log('errors', errs);
  await b.close();
  if (res.skipped) process.exit(1);
  const ok = res.a.clip && res.a.count === res.a.expectCount && !res.a.currentInside && res.a.dupes === 0
    && res.b.clipOpen && res.b.returnedTitle === 'T6' && res.b.returnedIndex === 5 && res.b.returnedLen === 6
    && res.c.backToSet && !res.c.emptyClip && errs.length === 0;
  process.exit(ok ? 0 : 1);
})();
