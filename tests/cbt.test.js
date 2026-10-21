// Diploma Boy phase 3: CBT room — sections, 5-state palette, confidence, rough pad, timer hide, pause/resume, result.
const { chromium } = require('playwright');
const path = require('path'); const URL = 'file://' + path.resolve(__dirname, '../index.html');
(async () => {
  const b = await chromium.launch(process.env.PW_CHROMIUM ? { executablePath: process.env.PW_CHROMIUM } : {});
  const all = [], errs = [];
  for (const [w, scheme] of [[390, 'light'], [360, 'dark']]) {
    const ctx = await b.newContext({ viewport: { width: w, height: 800 }, isMobile: true, hasTouch: true, colorScheme: scheme });
    const p = await ctx.newPage(); const o = { w, scheme };
    p.on('pageerror', e => errs.push(w + ':' + e.message));
    await p.goto(URL); await p.waitForTimeout(2500);
    await p.click('[data-a=onb-go]'); await p.click('[data-a=branch][data-id=mechanical]');
    await p.click('[data-a=tab][data-id=pyq]'); await p.click('[data-a=exam][data-id=ssc-je-paper1]');
    await p.click('[data-a=open-paper]'); await p.click('[data-a=mock-ask]'); await p.click('[data-a=mock-go]');
    await p.waitForSelector('#tmr', { timeout: 30000 });
    o.sections = await p.$$eval('.secbar [data-a=sec-go]', e => e.length);
    await p.click('[data-a=pick][data-i="1"]'); await p.click('[data-a=m-conf][data-id=sure]');
    o.confOn = await p.getAttribute('[data-a=m-conf][data-id=sure]', 'aria-pressed') === 'true';
    await p.click('[data-a=m-next]'); await p.click('[data-a=pick][data-i="2"]'); await p.click('[data-a=m-conf][data-id=guess]'); await p.click('[data-a=m-mark]');
    await p.click('.secbar [data-a=sec-go] >> nth=1'); o.secJump = await p.evaluate(() => V.sheet.i > 1);
    await p.click('[data-a=pad]'); await p.waitForSelector('#pad');
    const bx = await p.$eval('#pad', c => { const r = c.getBoundingClientRect(); return [r.left, r.top]; });
    await p.mouse.move(bx[0] + 30, bx[1] + 30); await p.mouse.down(); await p.mouse.move(bx[0] + 120, bx[1] + 90, { steps: 5 }); await p.mouse.up();
    await p.click('.box [data-a=pad-close]'); o.padSaved = await p.evaluate(() => !!V.sheet.pad[V.sheet.i]);
    await p.click('[data-a=t-hide]'); o.timerHidden = /समय देखें/.test(await p.textContent('#tmr'));
    await p.click('[data-a=palette]');
    o.legend5 = await p.$$eval('.legend span', e => e.length) === 5;
    o.amState = await p.$$eval('.pal button.am', e => e.length) === 1;
    o.overflow = await p.evaluate(() => document.documentElement.scrollWidth > innerWidth);
    o.smallTaps = await p.evaluate(() => [...document.querySelectorAll('#layer button')].filter(x => { const r = x.getBoundingClientRect(); return r.width && r.height < 44; }).length);
    await p.screenshot({ path: path.join(__dirname, 'shots', `cbt_palette_${w}_${scheme}.png`) });
    await p.click('.box [data-a=modal-close]'); await p.screenshot({ path: path.join(__dirname, 'shots', `cbt_q_${w}_${scheme}.png`) });
    // app closed and reopened mid-test
    await p.reload(); await p.waitForTimeout(2500);
    o.resumeCard = !!(await p.$('[data-a=m-resume]'));
    await p.click('[data-a=m-resume]'); await p.waitForSelector('#tmr');
    o.resumed = await p.evaluate(() => V.sheet.ans.filter(x => x != null).length === 2 && V.sheet.conf.includes('guess') && V.sheet.mark.some(Boolean));
    await p.click('[data-a=palette]'); await p.click('[data-a=m-submit-ask]'); await p.click('[data-a=m-submit]'); await p.waitForTimeout(200);
    const res = await p.textContent('#layer');
    o.result = /कितने पक्के/.test(res) && /सेक्शन के अनुसार/.test(res) && /कुल समय/.test(res) && /पहला मॉक|पिछले मॉक/.test(res);
    await p.screenshot({ path: path.join(__dirname, 'shots', `cbt_result_${w}_${scheme}.png`), fullPage: true });
    o.cleared = await p.evaluate(() => !localStorage.getItem('diploma-boy-mock'));
    all.push(o); await ctx.close();
  }
  await b.close();
  console.log(JSON.stringify(all)); console.log('errors', errs);
  const ok = all.every(o => o.sections === 3 && o.confOn && o.secJump && o.padSaved && o.timerHidden && o.legend5 && o.amState && !o.overflow && !o.smallTaps && o.resumeCard && o.resumed && o.result && o.cleared);
  process.exit(ok && !errs.length ? 0 : 1);
})();
