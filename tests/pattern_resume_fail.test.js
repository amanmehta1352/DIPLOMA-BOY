// Failed resume must not destroy the saved clip. Network drops during resume → card and saved state stay;
// network back → resume restores the same main question. Read-only against live data.
const { chromium } = require('playwright');
const path = require('path');
const URL = 'file://' + path.resolve(__dirname, '../index.html');
const wait = ms => new Promise(r => setTimeout(r, ms));
(async () => {
  const b = await chromium.launch(process.env.PW_CHROMIUM ? { executablePath: process.env.PW_CHROMIUM } : {});
  const ctx = await b.newContext({ viewport: { width: 390, height: 844 }, isMobile: true });
  const p = await ctx.newPage(); const errs = []; p.on('pageerror', e => errs.push(e.message));
  await p.goto(URL); await wait(2000);
  await p.click('[data-a=onb-go]'); await p.click('[data-a=branch][data-id=mechanical]');
  await p.evaluate(async () => {
    const rows = (await sb(`questions?select=${QSEL}&pattern_id=eq.1&order=id&limit=50`)).map(norm);
    V.sheet = { mode: 'practice', title: 'MAIN', list: [rows[0]], i: 0, pick: null, c: 0, seen: 0, meta: { subj: null } }; rSheet(true);
    document.querySelector('.pat').click();
  });
  await wait(2200);
  const before = await p.evaluate(() => ({ hasList: V.sheet.list.length > 0, cur: V.sheet.meta.cur, pid: V.sheet.meta.pat, sameLen: V.sheet.meta.kinds.same.length }));
  await p.reload(); await wait(2000);
  // network goes down for the resume fetch
  await ctx.route('**/rest/v1/**', r => r.abort());
  const hasCard = await p.evaluate(() => !!document.querySelector('[data-a=pat-resume]'));
  if (hasCard) await p.click('[data-a=pat-resume]');
  await wait(1500);
  const afterFail = await p.evaluate(() => {
    const saved = JSON.parse(localStorage.getItem('diploma-boy-v2') || 'null') || {};
    return { card: !!document.querySelector('[data-a=pat-resume]'), savedPid: saved.pat && saved.pat.pid, savedCur: saved.pat && saved.pat.cur, sheetOpen: !!V.sheet, savedKindsSame: saved.pat && saved.pat.kinds.same.length };
  });
  // network back → card resumes the same clip and main question
  await ctx.unroute('**/rest/v1/**');
  await p.click('[data-a=pat-resume]');
  await p.waitForFunction(() => V.sheet && !V.sheet.loading && V.sheet.meta && V.sheet.meta.back, null, { timeout: 20000 });
  const restored = await p.evaluate(() => ({ hasList: V.sheet.list.length > 0, pid: V.sheet.meta.pat, cur: V.sheet.meta.cur, mainId: V.sheet.meta.back && V.sheet.meta.back.list[0] && V.sheet.meta.back.list[0].id }));
  const ok = hasCard && before.hasList && afterFail.card && afterFail.savedPid === before.pid && afterFail.savedCur === before.cur
    && afterFail.savedKindsSame === before.sameLen && !afterFail.sheetOpen
    && restored.hasList && restored.pid === before.pid && restored.cur === before.cur && restored.mainId === before.cur && errs.length === 0;
  console.log(JSON.stringify({ before, afterFail, restored, errs }));
  await b.close(); process.exit(ok ? 0 : 1);
})();
