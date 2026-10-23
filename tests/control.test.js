// Control Room: renders status.json (served from fixtures), phone sizes, no overflow, tap size, no console errors, app switcher.
const { chromium } = require('playwright'); const http = require('http'); const fs = require('fs'); const path = require('path');
const root = path.resolve(__dirname, '..'); const fx = n => fs.readFileSync(path.join(__dirname, 'fixtures', n), 'utf8');
const srv = http.createServer((q, r) => { let f = path.join(root, q.url.split('?')[0]); if (f.endsWith('/')) f += 'index.html'; if (!f.startsWith(root) || !fs.existsSync(f) || fs.statSync(f).isDirectory()) { r.writeHead(404); return r.end(); }
  r.writeHead(200, { 'content-type': f.endsWith('.json') ? 'application/json' : f.endsWith('.css') ? 'text/css' : f.endsWith('.js') ? 'text/javascript' : 'text/html' }); r.end(fs.readFileSync(f)); });
(async () => {
  await new Promise(r => srv.listen(0, r)); const base = 'http://127.0.0.1:' + srv.address().port + '/control/';
  const b = await chromium.launch(process.env.PW_CHROMIUM ? { executablePath: process.env.PW_CHROMIUM } : {}); const errs = [], out = [];
  for (const [w, scheme, file] of [[360, 'dark', 'status_warn.json'], [412, 'light', 'status_bad.json'], [390, 'light', 'status_ok.json']]) {
    const p = await b.newPage({ viewport: { width: w, height: 800 }, isMobile: true, colorScheme: scheme });
    p.on('pageerror', e => errs.push(e.message)); p.on('console', m => { if (m.type() === 'error' && !/Failed to load resource/.test(m.text())) errs.push(m.text()); });
    await p.route('https://raw.githubusercontent.com/**', route => { const u = route.request().url();
      if (u.includes('status.json')) route.fulfill({ status: 200, contentType: 'application/json', headers: { 'access-control-allow-origin': '*' }, body: fx(file) });
      else if (u.includes('history.json')) route.fulfill({ status: 200, contentType: 'application/json', headers: { 'access-control-allow-origin': '*' }, body: fx('history.json') });
      else route.fulfill({ status: 404, headers: { 'access-control-allow-origin': '*' }, body: '' }); });
    await p.goto(base); await p.waitForSelector('.banner');
    const o = { w, file };
    o.banner = (await p.getAttribute('.banner', 'class')).replace('banner ', '');
    o.checks = await p.$$eval('#view .card', e => e.length);
    o.firstIsWorst = await p.$eval('#view .card .dot', e => e.textContent);
    for (const go of ['questions', 'robots', 'backup']) { await p.click(`[data-go=${go}]`); await p.waitForTimeout(50); o[go] = (await p.$eval('#view', e => e.innerText.length)) > 20; }
    await p.click('[data-go=questions]'); o.exams = await p.$$eval('#view tbody tr', e => e.length); o.spark = (await p.$$eval('svg.spark polyline', e => e.length)) === 1;
    await p.click('[data-go=robots]'); o.robotBtns = await p.$$eval('a.btn', e => e.length);
    o.overflow = await p.evaluate(() => document.documentElement.scrollWidth > innerWidth);
    o.smallTap = await p.evaluate(() => [...document.querySelectorAll('button,a.btn,select')].filter(x => { const r = x.getBoundingClientRect(); return r.width && (r.height < 44 || r.width < 44); }).length);
    o.noHtmlInjection = !(await p.content()).includes('<img src=x');
    out.push(o); await p.close();
  }
  // report missing -> friendly message, no crash
  const p = await b.newPage({ viewport: { width: 360, height: 800 } }); p.on('pageerror', e => errs.push(e.message));
  await p.route('https://raw.githubusercontent.com/**', r => r.fulfill({ status: 404, headers: { 'access-control-allow-origin': '*' }, body: '' })); await p.goto(base); await p.waitForSelector('#view .card');
  out.push({ missing: (await p.innerText('#view')).includes('रिपोर्ट नहीं मिली') });
  await b.close(); srv.close(); console.log(JSON.stringify(out)); console.log('errors', errs);
  const bad = errs.length || out.slice(0, 3).some(o => !o.questions || !o.robots || !o.backup || o.overflow || o.smallTap || !o.noHtmlInjection || o.exams !== 2 || !o.spark || o.robotBtns < 1) ||
    out[0].banner !== 'warn' || out[1].banner !== 'bad' || out[2].banner !== 'ok' || out[1].firstIsWorst !== '🔴' || !out[3].missing;
  process.exit(bad ? 1 : 0);
})();
