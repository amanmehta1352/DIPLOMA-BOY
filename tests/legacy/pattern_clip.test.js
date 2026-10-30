// Pattern chip opens the same-type list directly; section tabs at the top; finish → back to main question.
// Also: refresh mid-list restores the same list, position and main question. Live read-only data.
const { chromium } = require('playwright');
const path = require('path');
const URL = 'file://' + path.resolve(__dirname, '../index.html');
const SB = 'https://wobmtlcpszcntczkebtt.supabase.co/rest/v1/';
const KEY = 'sb_publishable_7ZZEUDULfYaMHSeLIxfluQ_fZWSCi8R';
const wait = ms => new Promise(r => setTimeout(r, ms));

async function findPattern() {
  const h = { headers: { apikey: KEY, 'Accept-Profile': 'mtb' } };
  const [lead] = await (await fetch(SB + 'questions?select=id,pattern_id,pattern_n&pattern_n=gte.3&pattern_rep=eq.true&order=id&limit=1', h)).json();
  const members = await (await fetch(SB + `questions?select=id&pattern_id=eq.${lead.pattern_id}&order=id&limit=50`, h)).json();
  return { pid: lead.pattern_id, n: lead.pattern_n, members: members.map(x => x.id) };
}

(async () => {
  const errs = [], out = [];
  const pat = await findPattern();
  const b = await chromium.launch(process.env.PW_CHROMIUM ? { executablePath: process.env.PW_CHROMIUM } : {});
  for (const [w, scheme] of [[360, 'dark'], [390, 'light']]) {
    const ctx = await b.newContext({ viewport: { width: w, height: 800 }, isMobile: true, colorScheme: scheme });
    const p = await ctx.newPage(); p.on('pageerror', e => errs.push(e.message));
    await p.goto(URL); await wait(2500);
    await p.click('[data-a=onb-go]'); await p.click('[data-a=branch][data-id=mechanical]');
    await p.evaluate(async (pid) => {
      const rows = (await sb(`questions?select=${QSEL}&pattern_id=eq.${pid}&order=id&limit=50`)).map(norm);
      V.sheet = { mode: 'practice', title: 'MAIN', list: [rows[0]], i: 0, pick: null, c: 0, seen: 0, meta: { subj: null } };
      rSheet(true);
    }, pat.pid);
    await p.click('.pat'); await wait(2200);
    const opened = await p.evaluate(() => ({
      list: V.sheet.list.length, kind: V.sheet.meta.kind, mainId: V.sheet.meta.back.list[0].id,
      tabs: [...document.querySelectorAll('[data-a=pat-kind]')].map(x => ({ k: x.dataset.k, on: x.getAttribute('aria-pressed') === 'true', dis: x.disabled, h: x.getBoundingClientRect().height })),
      counts: { exact: V.sheet.meta.kinds.exact.length, same: V.sheet.meta.kinds.same.length, related: V.sheet.meta.kinds.related.length }
    }));
    // solve 3 questions, refresh, resume: same list, same position, same main question
    for (let k = 0; k < 3; k++) { await p.click('[data-a=pick]'); await p.click('[data-a=next]'); await wait(60); }
    const beforeRefresh = await p.evaluate(() => ({ i: V.sheet.i, kind: V.sheet.meta.kind, solved: (V.sheet.meta.doneK[V.sheet.meta.kind] || []).length }));
    await p.reload(); await wait(2000);
    await p.click('[data-a=pat-resume]');
    await p.waitForFunction(() => V.sheet && !V.sheet.loading && V.sheet.meta && V.sheet.meta.back, null, { timeout: 20000 });
    const restored = await p.evaluate(() => ({ i: V.sheet.i, kind: V.sheet.meta.kind, mainId: V.sheet.meta.back.list[0].id, solved: (V.sheet.meta.doneK[V.sheet.meta.kind] || []).length }));
    // finish the rest of the set: the section list ends, the set reports done
    let steps = 0;
    while (steps++ < 80) {
      if (await p.evaluate(() => V.sheet.done)) break;
      if (await p.$('[data-a=pick]')) await p.click('[data-a=pick]');
      await p.click('[data-a=next], [data-a=skip]'); await wait(40);
    }
    const finished = await p.evaluate(() => ({ done: !!V.sheet.done, solved: Object.values(V.sheet.meta.doneK).reduce((a, x) => a + x.length, 0) }));
    // main question comes back
    await p.click('[data-a=close]'); await wait(300);
    const main = await p.evaluate(() => ({ title: V.sheet && V.sheet.title, listLen: V.sheet && V.sheet.list.length, pat: !!(V.sheet && V.sheet.meta && V.sheet.meta.pat) }));
    const overflow = await p.evaluate(() => document.documentElement.scrollWidth > window.innerWidth);
    out.push({ w, scheme, opened, beforeRefresh, restored, finished, main, overflow, expectMembers: pat.n - 1 });
    await ctx.close();
  }
  await b.close();
  // Synthetic logic: exact vs same vs related stay independent (test rows only, never shown to students)
  const bl = await chromium.launch(); const pl = await bl.newPage(); await pl.goto(URL); await wait(1500);
  const logic = await pl.evaluate(() => {
    const mk = (id, en, opts) => ({ id, stem: { en }, opts: opts || ['a', 'b'] });
    const cur = mk(1, 'Find x if 2x = 10');
    const sp = patSplit(cur, [cur, mk(2, 'find x if 2x = 10'), mk(3, 'Find x if 3x = 12'), mk(4, 'Find x if 2x = 10', ['a', 'c'])]);
    return { exact: sp.exact.map(x => x.id), same: sp.same.map(x => x.id), related: sp.related.length };
  });
  await bl.close();
  const logicOk = JSON.stringify(logic.exact) === '[2]' && JSON.stringify(logic.same) === '[3,4]' && logic.related === 0;
  console.log(JSON.stringify(out, null, 1)); console.log('synthetic', JSON.stringify(logic), logicOk ? 'OK' : 'FAIL'); console.log('errors', errs);
  const total = o => o.opened.counts.exact + o.opened.counts.same + o.opened.counts.related;
  const bad = out.some(o => o.opened.list === 0 || o.opened.kind !== 'same' || o.opened.counts.same !== o.opened.list
    || o.opened.tabs.length !== 3 || o.opened.tabs.some(t => t.h < 44) || !o.opened.tabs.find(t => t.k === 'same').on
    || total(o) !== o.expectMembers || o.restored.i !== o.beforeRefresh.i || o.restored.kind !== o.beforeRefresh.kind
    || o.restored.mainId !== o.opened.mainId || !finishedOk(o) || o.main.pat || o.main.title !== 'MAIN' || o.overflow);
  function finishedOk(o) { return o.finished.done && o.finished.solved === o.opened.list; }
  process.exit(errs.length || bad || !logicOk ? 1 : 0);
})();
