// Diploma Boy design foundation check (phase 1). Run: node tests/design.test.js
const { chromium } = require('playwright');
const path = require('path'); const URL = 'file://' + path.resolve(__dirname, '../index.html');
const lum = h => { const c = [1,3,5].map(i => parseInt(h.substr(i,2),16)/255).map(v => v<=0.03928? v/12.92 : Math.pow((v+0.055)/1.055,2.4)); return 0.2126*c[0]+0.7152*c[1]+0.0722*c[2]; };
const ratio = (a,b) => { const x=lum(a), y=lum(b); return (Math.max(x,y)+0.05)/(Math.min(x,y)+0.05); };
const PAIRS = [['ink','paper'],['ink2','paper'],['ink2','sheet'],['blue','sheet'],['bad','paper'],['ok','sheet']];
(async () => {
  const b = await chromium.launch(process.env.PW_CHROMIUM ? { executablePath: process.env.PW_CHROMIUM } : {});
  const out = [], errs = [];
  for (const [w, scheme] of [[360,'dark'],[390,'light'],[412,'light'],[820,'dark']]) {
    const p = await b.newPage({ viewport: { width: w, height: 800 }, isMobile: w < 700, colorScheme: scheme });
    p.on('pageerror', e => errs.push(w + ':' + e.message));
    await p.goto(URL); await p.waitForTimeout(1500);
    await p.click('[data-a=onb-go]'); await p.click('[data-a=branch][data-id=mechanical]'); await p.click('[data-a=tab][data-id=me]');
    await p.click('[data-a=open-gallery]'); await p.waitForSelector('.gal-sw');
    const vars = await p.evaluate(() => { const s = getComputedStyle(document.documentElement); const o = {}; ['ink','ink2','paper','sheet','blue','bad','ok'].forEach(k => o[k] = s.getPropertyValue('--' + k).trim()); return o; });
    const fails = PAIRS.filter(([a,c]) => ratio(vars[a], vars[c]) < 4.5).map(([a,c]) => a + '/' + c);
    const sw = await p.evaluate(() => document.documentElement.scrollWidth);
    const small = await p.evaluate(() => [...document.querySelectorAll('#app button')].filter(x => x.getBoundingClientRect().height < 44).length);
    out.push({ w, scheme, overflow: sw > w, smallTaps: small, contrastFails: fails });
    await p.screenshot({ path: path.join(__dirname, 'shots', `gallery_${w}_${scheme}.png`), fullPage: true });
    await p.close();
  }
  await b.close();
  const bad = out.filter(r => r.overflow || r.smallTaps || r.contrastFails.length);
  console.log(JSON.stringify(out)); console.log('errors', errs);
  process.exit(bad.length || errs.length ? 1 : 0);
})();
