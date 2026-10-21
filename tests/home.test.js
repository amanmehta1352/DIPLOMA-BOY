// Diploma Boy: student walk-through of the new Home, exam-wise subjects, resume, search.
const { chromium } = require('playwright');
const path = require('path'); const URL = 'file://' + path.resolve(__dirname, '../index.html');
const SHOT = n => path.join(__dirname, 'shots', n);
(async () => {
  const b = await chromium.launch(process.env.PW_CHROMIUM ? { executablePath: process.env.PW_CHROMIUM } : {});
  const errs = [], o = {};
  for (const [w, scheme] of [[360, 'dark'], [390, 'light']]) {
    const p = await b.newPage({ viewport: { width: w, height: 820 }, isMobile: true, colorScheme: scheme });
    p.on('pageerror', e => errs.push(w + ':' + e.message));
    await p.goto(URL); await p.waitForTimeout(2500);
    const k = `${w}_${scheme}_`;
    o[k + 'welcome'] = !!(await p.$('[data-a=onb-go]')); await p.screenshot({ path: SHOT(`home_welcome_${w}_${scheme}.png`) });
    await p.click('[data-a=onb-go]'); await p.click('[data-a=onb-fam][data-id=rrb-je]');
    await p.screenshot({ path: SHOT(`home_onboard_${w}_${scheme}.png`), fullPage: true });
    await p.click('[data-a=branch][data-id=mechanical]');
    const home = await p.textContent('#app');
    o[k + 'ctx'] = /आरआरबी जेई · मैकेनिकल/.test(home) && !/एसएससी/.test(home);
    o[k + 'onePrimary'] = (await p.$$('.pcard')).length === 1;
    await p.screenshot({ path: SHOT(`home_${w}_${scheme}.png`), fullPage: true });
    o[k + 'homeOverflow'] = await p.evaluate(() => document.documentElement.scrollWidth > innerWidth);
    o[k + 'homeSmall'] = await p.evaluate(() => [...document.querySelectorAll('#app button, header button')].filter(x => { const r = x.getBoundingClientRect(); return r.width && r.height < 44; }).length);
    // subjects arranged by exam stage
    await p.click('[data-a=tab][data-id=learn]');
    const subjAll = await p.$$eval('[data-a=open-subj]', e => e.map(x => x.dataset.subj));
    o[k + 'allHasMechTagCBT2'] = subjAll.includes('mechanical-engineering') && /सीबीटी-2/.test(await p.$eval('[data-a=open-subj][data-subj=mechanical-engineering]', e => e.textContent));
    await p.click('[data-a=stage-f][data-id=rrb-je-cbt1]');
    const s1 = await p.$$eval('[data-a=open-subj]', e => e.map(x => x.dataset.subj));
    o[k + 'cbt1NoMech'] = !s1.some(x => /engineering/.test(x)) && s1.join() === 'maths,reasoning,general-awareness,general-science';
    await p.click('[data-a=stage-f][data-id=rrb-je-cbt2]');
    const s2 = await p.$$eval('[data-a=open-subj]', e => e.map(x => x.dataset.subj));
    o[k + 'cbt2'] = s2.includes('mechanical-engineering') && s2.includes('computer-basics') && !s2.includes('maths');
    await p.screenshot({ path: SHOT(`subjects_cbt2_${w}_${scheme}.png`), fullPage: true });
    await p.click('[data-a=stage-f][data-id=all]');
    // practice, leave mid-set, resume from Home
    await p.click('[data-a=open-subj][data-subj=general-science]'); await p.click('[data-a=open-ch]');
    await p.click('[data-a=start-ch]:not([data-kind])'); await p.waitForSelector('[data-a=pick]', { timeout: 20000 });
    await p.click('[data-a=pick][data-i="0"]'); await p.click('[data-a=next]'); await p.click('[data-a=pick][data-i="1"]'); await p.click('[data-a=next]');
    await p.click('[data-a=close]'); await p.click('[data-a=tab][data-id=today]');
    o[k + 'continueCard'] = /प्रैक्टिस जारी रखें/.test(await p.textContent('.pcard')) && /सवाल 3 \/ \d+/.test(await p.textContent('.pcard'));
    await p.click('[data-a=last-resume]'); await p.waitForSelector('[data-a=pick]', { timeout: 20000 });
    o[k + 'resumedAt3'] = await p.evaluate(() => V.sheet.i === 2 && V.sheet.list.length > 2);
    await p.click('[data-a=close]');
    // search
    await p.click('[data-a=search]'); await p.fill('#qs', 'Light'); await p.waitForTimeout(100);
    o[k + 'search'] = (await p.$$('#qsr [data-a=open-ch]')).length > 0;
    await p.click('#qsr [data-a=open-ch]'); o[k + 'searchOpens'] = await p.evaluate(() => S.tab === 'learn' && !!(V.view && V.view.ch) && !V.modal);
    // two exams: tags show both
    await p.click('#avatar'); await p.click('[data-a=fam-toggle][data-id=ssc-je]');
    await p.click('[data-a=tab][data-id=learn]');
    o[k + 'twoExamsTags'] = /एसएससी जेई/.test(await p.$eval('[data-a=open-subj][data-subj=mechanical-engineering]', e => e.textContent));
    await p.screenshot({ path: SHOT(`subjects_two_${w}_${scheme}.png`), fullPage: true });
    await p.close();
  }
  // civil student, SSC only: civil engineering, never mechanical
  const p = await b.newPage({ viewport: { width: 390, height: 820 }, isMobile: true });
  await p.goto(URL); await p.waitForTimeout(2500);
  await p.click('[data-a=onb-go]'); await p.click('[data-a=onb-fam][data-id=ssc-je]'); await p.click('[data-a=branch][data-id=civil]');
  await p.click('[data-a=tab][data-id=learn]');
  const sc = await p.$$eval('[data-a=open-subj]', e => e.map(x => x.dataset.subj));
  o.civilSSC = sc.includes('civil-engineering') && !sc.includes('mechanical-engineering') && !sc.includes('maths');
  await b.close();
  console.log(JSON.stringify(o)); console.log('errors', errs);
  const bad = Object.entries(o).filter(([key, v]) => /Overflow$/.test(key) ? v : /Small$/.test(key) ? v > 0 : !v);
  if (bad.length) console.log('FAILED', JSON.stringify(bad));
  process.exit(bad.length || errs.length ? 1 : 0);
})();
