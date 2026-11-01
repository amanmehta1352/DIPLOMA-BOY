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
    await p.click('[data-go=robots]'); await p.waitForTimeout(150); o.robotBtns = await p.$$eval('a.btn', e => e.length); o.depts = (await p.innerText('#view')).includes('22 Departments');
    o.overflow = await p.evaluate(() => document.documentElement.scrollWidth > innerWidth);
    o.smallTap = await p.evaluate(() => [...document.querySelectorAll('button,a.btn,select')].filter(x => { const r = x.getBoundingClientRect(); return r.width && (r.height < 44 || r.width < 44); }).length);
    o.noHtmlInjection = !(await p.content()).includes('<img src=x');
    out.push(o); await p.close();
  }
  // report missing -> friendly message, no crash
  const p = await b.newPage({ viewport: { width: 360, height: 800 } }); p.on('pageerror', e => errs.push(e.message));
  await p.route('https://raw.githubusercontent.com/**', r => r.fulfill({ status: 404, headers: { 'access-control-allow-origin': '*' }, body: '' })); await p.goto(base); await p.waitForSelector('#view .card');
  out.push({ missing: (await p.innerText('#view')).includes('रिपोर्ट नहीं मिली') });

  // Command tab: login with code, form per robot, send, list with report, wrong code message; no overflow, big taps
  { const q = await b.newPage({ viewport: { width: 360, height: 800 }, isMobile: true }); q.on('pageerror', e => errs.push(e.message));
    q.on('console', m => { if (m.type() === 'error' && !/Failed to load resource/.test(m.text())) errs.push(m.text()); });
    const sent = [];
    await q.route('https://raw.githubusercontent.com/**', r => r.fulfill({ status: 200, contentType: 'application/json', headers: { 'access-control-allow-origin': '*' }, body: r.request().url().includes('history') ? fx('history.json') : fx('status_ok.json') }));
    await q.route('https://*.supabase.co/rest/v1/rpc/**', r => { const fn = r.request().url().split('/rpc/')[1], a = JSON.parse(r.request().postData() || '{}');
      const H = { 'access-control-allow-origin': '*', 'access-control-allow-headers': '*' };
      if (r.request().method() === 'OPTIONS') return r.fulfill({ status: 200, headers: H, body: '' });
      if (a.p_code !== 'GOODCODE') return r.fulfill({ status: 400, contentType: 'application/json', headers: H, body: '{"message":"bad code"}' });
      if (fn === 'cmd_submit') { sent.push(a); return r.fulfill({ status: 200, contentType: 'application/json', headers: H, body: '7' }); }
      if (fn === 'draft_review_list') return r.fulfill({ status: 200, contentType: 'application/json', headers: H, body: JSON.stringify([
        { level_id: 'class_9_10', chapter_id: 3, status: 'rejected', model: 'gemini', checks: { problems: ['second opinion disagrees on 4 of 10 answers'] } },
        { level_id: 'class_9_10', chapter_id: 4, status: 'approved', model: 'gemini', checks: {} }]) });
      if (fn === 'cmd_list') return r.fulfill({ status: 200, contentType: 'application/json', headers: H, body: JSON.stringify([
        { id: 7, robot: 'solver', args: { count: '5' }, status: 'queued', created_at: new Date().toISOString() },
        { id: 6, robot: 'writer', args: {}, status: 'done', created_at: new Date().toISOString(), finished_at: new Date().toISOString(), run_url: 'https://github.com/x/y/actions/runs/1', report: '<img src=x onerror=alert(1)> all checks passed' }]) });
      return r.fulfill({ status: 200, contentType: 'application/json', headers: H, body: 'true' }); });
    await q.goto(base); await q.waitForSelector('.banner'); await q.click('[data-go=command]'); await q.waitForSelector('#cCode');
    await q.fill('#cCode', 'WRONG'); await q.click('#cLogin'); await q.waitForSelector('.msg.bad'); const wrong = (await q.innerText('.msg.bad')).includes('गलत');
    await q.fill('#cCode', 'GOODCODE'); await q.click('#cLogin'); await q.waitForSelector('#cRobot');
    await q.selectOption('#cRobot', 'solver'); await q.fill('#ci_count', '9'); await q.click('#cSend'); await q.waitForSelector('.msg.ok');
    const o = { wrong, sentOk: sent.length === 1 && sent[0].p_robot === 'solver' && sent[0].p_args.count === 9,
      cards: await q.$$eval('#view .card', e => e.length), report: await q.$$eval('details.rep', e => e.length), cancel: await q.$$eval('[data-cancel]', e => e.length),
      overflow: await q.evaluate(() => document.documentElement.scrollWidth > innerWidth),
      smallTap: await q.evaluate(() => [...document.querySelectorAll('button,a.btn,select')].filter(x => { const r = x.getBoundingClientRect(); return r.width && (r.height < 44 || r.width < 44); }).length),
      noHtmlInjection: (await q.$$eval('#view img', e => e.length)) === 0,
      review: (await q.innerText('#view')).includes('Review queue') && (await q.innerText('#view')).includes('second opinion disagrees') };
    out.push({ command: o }); await q.close();
    if (!o.wrong || !o.sentOk || o.cards < 3 || !o.review || o.report !== 1 || o.cancel !== 1 || o.overflow || o.smallTap || !o.noHtmlInjection) errs.push('command tab: ' + JSON.stringify(o)); }
  await b.close(); srv.close(); console.log(JSON.stringify(out)); console.log('errors', errs);
  const bad = errs.length || out.slice(0, 3).some(o => !o.questions || !o.robots || !o.backup || o.overflow || o.smallTap || !o.noHtmlInjection || o.exams !== 2 || !o.spark || o.robotBtns < 1 || !o.depts) ||
    out[0].banner !== 'warn' || out[1].banner !== 'bad' || out[2].banner !== 'ok' || out[1].firstIsWorst !== '🔴' || !out[3].missing;
  process.exit(bad ? 1 : 0);
})();
