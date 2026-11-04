// Opens the real book.html with this chapter added as an extra chapter (no database write) and screenshots every tab.
// usage: node preview_book.js <book.html> <row.json> <out_dir> [live|offline]
const { chromium } = require('playwright'); const fs = require('fs'); const path = require('path');
(async () => {
  const [bookHtml, rowFile, outDir, mode] = process.argv.slice(2);
  const row = JSON.parse(fs.readFileSync(rowFile, 'utf8')); const CH = 2;   // book.html renders chapters 2-11 fully: the preview takes chapter 2's place
  const mine = {book_slug: 'preview', ch_no: CH, topic_id: row.topic_id, title_hi: row.title_hi, title_en: row.title_en,
                short_hi: row.short_hi, short_en: row.short_en, data: row.data};
  const b = await chromium.launch(); const ctx = await b.newContext({viewport: {width: 390, height: 844}, deviceScaleFactor: 2});
  const p = await ctx.newPage(); const errs = []; p.on('pageerror', e => errs.push(e.message)); p.on('console', m => { if (m.type() === 'error') errs.push('console: ' + m.text()); });
  await p.route('**/rest/v1/rpc/get_chapter_books*', async r => {
    let rows = [];
    if (mode === 'live') { const res = await r.fetch(); rows = (await res.json()).filter(x => x.ch_no !== CH); }
    else rows = [{...mine, ch_no: 1}];
    rows.push(mine); rows.sort((a, b) => a.ch_no - b.ch_no); await r.fulfill({status: 200, contentType: 'application/json', body: JSON.stringify(rows)});
  });
  await p.route('https://app.test/**', r => r.fulfill({status: 200, contentType: 'text/html', body: fs.readFileSync(bookHtml, 'utf8')}));
  const shots = [];
  for (const [tab, lang] of [['book', 'hi'], ['notes', 'hi'], ['notes', 'en'], ['teach', 'hi'], ['formula', 'hi'], ['3d', 'hi']]) {
    await p.goto(`https://app.test/book.html?b=physics-baseline&ch=${CH}&tab=${tab}&lang=${lang}`, {waitUntil: 'domcontentloaded'});
    await p.waitForSelector('#bookLoading', {state: 'detached', timeout: 30000}).catch(() => {});
    await p.waitForTimeout(tab === '3d' ? 4000 : 1500);
    const f = path.join(outDir, `app_${tab}_${lang}.png`); await p.screenshot({path: f}); shots.push(f);
  }
  fs.writeFileSync(path.join(outDir, 'app_preview_errors.json'), JSON.stringify(errs.slice(0, 20), null, 1));
  console.log(JSON.stringify({shots, errors: errs.length}));
  await b.close();
})();
