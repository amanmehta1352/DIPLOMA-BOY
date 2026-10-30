// "Report a mistake" button: shows after an answer, opens 5 reasons, sends ONE rpc call (mocked here, the live DB is never touched),
// shows thanks, remembers it, and is absent during a mock. Run: node tests/report.test.js
const { chromium } = require('playwright');
const path = require('path'); const URL = 'file://' + path.resolve(__dirname, '../index.html');
(async () => {
  const b = await chromium.launch(process.env.PW_CHROMIUM ? { executablePath: process.env.PW_CHROMIUM } : {});
  const errs = [], calls = []; const bad = [];
  const p = await b.newPage({ viewport: { width: 390, height: 800 }, isMobile: true });
  p.on('pageerror', e => errs.push(e.message));
  await p.route('**/rest/v1/rpc/report_question', async route => {
    const req = route.request(); calls.push({ method: req.method(), profile: req.headers()['content-profile'], body: JSON.parse(req.postData() || '{}') });
    await route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ ok: true, reports: 1, hidden: false }) });
  });
  await p.goto(URL); await p.waitForTimeout(2500);
  await p.click('[data-a=onb-go]'); await p.click('[data-a=branch][data-id=mechanical]');
  await p.click('[data-a=tab][data-id=learn]'); await p.click('[data-a=open-subj][data-subj=general-science]'); await p.click('[data-a=open-ch]');
  await p.click('[data-a=start-ch]:not([data-kind])'); await p.waitForSelector('[data-a=pick]', { timeout: 20000 });
  if (await p.$('[data-rep]')) bad.push('button before answering');
  await p.click('[data-a=pick][data-i="0"]');
  if (!(await p.$('[data-rep]'))) bad.push('no button after answering');
  await p.click('[data-rep]');
  const reasons = await p.$$eval('[data-a=rep-send]', e => e.map(x => x.dataset.r));
  if (reasons.join() !== 'answer,question,hindi,figure,other') bad.push('reasons ' + reasons.join());
  const qid = await p.evaluate(() => V.sheet.list[V.sheet.i].id);
  await p.click('[data-a=rep-send][data-r=hindi]'); await p.waitForSelector('.toast', { timeout: 5000 });
  await p.waitForSelector('[data-rep-done]', { timeout: 5000 });
  if (await p.$('[data-rep]')) bad.push('button still there after reporting');
  if (calls.length !== 1) bad.push('calls ' + calls.length);
  else {
    const c = calls[0];
    if (c.method !== 'POST' || c.profile !== 'mtb') bad.push('method/profile ' + c.method + c.profile);
    if (c.body.p_question !== qid || c.body.p_reason !== 'hindi' || !c.body.p_device || c.body.p_device.length < 8) bad.push('body ' + JSON.stringify(c.body));
  }
  // remembered after reload: same question still shows the thanks line, same device id
  const dev1 = await p.evaluate(() => JSON.parse(localStorage.getItem('diploma-boy-reports')).dev);
  await p.reload(); await p.waitForTimeout(1500);
  const dev2 = await p.evaluate(() => JSON.parse(localStorage.getItem('diploma-boy-reports')).dev);
  if (dev1 !== dev2) bad.push('device id changed');
  // no button inside a mock test (answers are hidden there)
  const mockHasBtn = await p.evaluate(() => { V.sheet = { mode: 'mock', title: 'T', list: [{ id: 1, kind: 'pyq', topic: {}, stem: { en: 'q', hi: 'q' }, opts: [{ en: 'a', hi: 'a' }, { en: 'b', hi: 'b' }], a: 0 }], i: 0, ans: [0], mark: [], vis: [], conf: [], ms: [], pad: [], left: 600, t0: Date.now() }; rSheet(); return !!document.querySelector('[data-rep]'); });
  if (mockHasBtn) bad.push('button visible in mock');
  console.log(JSON.stringify({ calls: calls.length, reasons: reasons.length, bad })); console.log('errors', errs);
  await b.close(); process.exit(errs.length || bad.length ? 1 : 0);
})();
