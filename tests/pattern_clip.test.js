// Pattern Clip end-to-end: clip → kinds → solve → back to clip → refresh → main question.
// Runs against the live read-only publishable key (same as the other tests). Read-only: no writes.
const { chromium } = require('playwright');
const path = require('path');
const URL = 'file://' + path.resolve(__dirname, '../index.html');
const SB = 'https://wobmtlcpszcntczkebtt.supabase.co/rest/v1/';
const KEY = 'sb_publishable_7ZZEUDULfYaMHSeLIxfluQ_fZWSCi8R';

async function findPattern() {
  const r = await fetch(SB + 'questions?select=id,pattern_id,pattern_n&pattern_n=gte.3&pattern_rep=eq.true&order=id&limit=1', { headers: { apikey: KEY, 'Accept-Profile': 'mtb' } });
  const [lead] = await r.json();
  const m = await fetch(SB + `questions?select=id,pattern_id,pattern_n&pattern_id=eq.${lead.pattern_id}&order=id&limit=50`, { headers: { apikey: KEY, 'Accept-Profile': 'mtb' } });
  const members = await m.json();
  return { pid: lead.pattern_id, n: lead.pattern_n, members: members.map(x => x.id) };
}

(async () => {
  const errs = [], out = [];
  const pat = await findPattern();
  const b = await chromium.launch(process.env.PW_CHROMIUM ? { executablePath: process.env.PW_CHROMIUM } : {});
  for (const [w, scheme] of [[360, 'dark'], [390, 'light']]) {
    const ctx = await b.newContext({ viewport: { width: w, height: 800 }, isMobile: true, colorScheme: scheme });
    const p = await ctx.newPage(); p.on('pageerror', e => errs.push(e.message));
    await p.goto(URL); await p.waitForTimeout(2500);
    await p.click('[data-a=onb-go]'); await p.click('[data-a=branch][data-id=mechanical]');
    await p.evaluate(async (pid) => {
      const rows = await sb(`questions?select=${QSEL}&pattern_id=eq.${pid}&order=id&limit=50`);
      const cur = rows.map(norm)[0];
      V.sheet = { mode: 'practice', title: 'MAIN', list: [cur], i: 0, pick: null, c: 0, seen: 0, meta: { subj: null } };
      rSheet(true);
    }, pat.pid);
    await p.click('.pat'); await p.waitForTimeout(2200);
    const clip = await p.evaluate(() => ({ clip: !!V.sheet.clip, exact: V.sheet.meta.kinds.exact.length, same: V.sheet.meta.kinds.same.length, related: V.sheet.meta.kinds.related.length, mainId: V.sheet.meta.back.list[0].id }));
    const tapH = await p.evaluate(() => { const b = document.querySelector('[data-a=pat-kind]'); return b ? b.getBoundingClientRect().height : 0; });
    // open same pattern, answer and move on until the clip comes back
    await p.click('[data-a=pat-kind][data-k=same]'); await p.waitForTimeout(300);
    const inQ = await p.evaluate(() => ({ view: !V.sheet.clip, hasInfo: !!document.querySelector('.sheet-body .panel b') }));
    let steps = 0;
    while (steps < 60) {
      const st = await p.evaluate(() => V.sheet.clip);
      if (st) break;
      if (await p.$('[data-a=pick]')) { await p.click('[data-a=pick]'); }
      await p.click('[data-a=next], [data-a=skip]'); await p.waitForTimeout(60); steps++;
    }
    const back = await p.evaluate(() => ({ clip: V.sheet.clip, solvedSame: (V.sheet.meta.doneK.same || []).length }));
    // refresh mid-clip: the home card must bring back the same clip and the main question
    await p.reload(); await p.waitForTimeout(2200);
    const resumeCard = await p.evaluate(() => !!document.querySelector('[data-a=pat-resume]'));
    if (resumeCard) await p.click('[data-a=pat-resume]'); await p.waitForTimeout(2000);
    const restored = await p.evaluate(() => ({ clip: V.sheet.clip, solvedSame: (V.sheet.meta.doneK.same || []).length, mainId: V.sheet.meta.back && V.sheet.meta.back.list[0] && V.sheet.meta.back.list[0].id }));
    // back to the main question
    await p.click('[data-a=close]'); await p.waitForTimeout(300);
    const main = await p.evaluate(() => ({ title: V.sheet && V.sheet.title, listLen: V.sheet && V.sheet.list.length, pat: !!(V.sheet && V.sheet.meta && V.sheet.meta.pat) }));
    const overflow = await p.evaluate(() => document.documentElement.scrollWidth > window.innerWidth);
    out.push({ w, scheme, ...clip, inQ, back, resumeCard, restored, main, overflow, tapH, expectMembers: pat.n - 1, membersTotal: clip.exact + clip.same + clip.related });
    await ctx.close();
  }
  // Synthetic logic check (test-only rows, never shown to students): exact vs same vs related are independent.
  const ctxL = await b.newContext(); const pl = await ctxL.newPage(); await pl.goto(URL); await pl.waitForTimeout(1500);
  const logic = await pl.evaluate(() => {
    const mk = (id, en, opts) => ({ id, stem: { en }, opts: opts || ['a', 'b'] });
    const cur = mk(1, 'Find x if 2x = 10');
    const sp = patSplit(cur, [cur, mk(2, 'find x if 2x = 10'), mk(3, 'Find x if 3x = 12'), mk(4, 'Find x if 2x = 10', ['a', 'c'])]);
    return { exact: sp.exact.map(x => x.id), same: sp.same.map(x => x.id), related: sp.related.length };
  });
  await ctxL.close();
  const logicOk = JSON.stringify(logic.exact) === '[2]' && JSON.stringify(logic.same) === '[3,4]' && logic.related === 0;
  console.log('synthetic classification', JSON.stringify(logic), logicOk ? 'OK' : 'FAIL');
  await b.close();
  console.log(JSON.stringify(out, null, 1)); console.log('errors', errs);
  const bad = out.some(o => !o.clip || o.membersTotal !== o.expectMembers || o.related !== 0 || !o.resumeCard || !o.restored.clip || o.restored.mainId == null || o.restored.mainId !== o.mainId || o.restored.solvedSame !== o.back.solvedSame || o.overflow || o.tapH < 44 || o.main.pat);
  process.exit(errs.length || bad || !logicOk ? 1 : 0);
})();
