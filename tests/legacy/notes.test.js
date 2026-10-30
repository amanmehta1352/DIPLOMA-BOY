// Chapter notes (atoms) by exam level. Run: mkdir -p tests/shots && node tests/notes.test.js
// Same chapter (Force, topic 872) must show JE-depth notes for SSC JE and basic notes for RRB NTPC;
// a chapter with no notes must show "coming soon", never an empty screen.
const { chromium } = require('playwright');
const path=require('path'); const URL='file://'+path.resolve(__dirname,'../index.html'); const SHOT=n=>path.join(__dirname,'shots',n);
(async()=>{const b=await chromium.launch(process.env.PW_CHROMIUM?{executablePath:process.env.PW_CHROMIUM}:{}); const errs=[]; const out={};
 const p=await b.newPage({viewport:{width:390,height:800},isMobile:true});
 p.on('pageerror',e=>errs.push(e.message)); p.on('console',m=>{if(m.type()==='error')errs.push('console:'+m.text())});
 await p.goto(URL); await p.waitForTimeout(2500);
 await p.click('[data-a=onb-go]'); await p.click('[data-a=branch][data-id=mechanical]'); await p.waitForTimeout(200);
 async function force(exam){
  await p.click('[data-a=tab][data-id=pyq]'); await p.click(`[data-a=exam][data-id=${exam}]`);
  await p.click('[data-a=tab][data-id=learn]'); await p.click('[data-a=open-subj][data-subj=general-science]');
  const tagged=await p.$('[data-a=open-ch][data-ch="872"] .tag.notes');
  await p.click('[data-a=open-ch][data-ch="872"]'); await p.waitForSelector('.atom',{timeout:20000});
  const r={tagged:!!tagged,atoms:await p.$$eval('.atom',e=>e.length),titles:await p.$$eval('.atom h3',e=>e.map(x=>x.textContent)),formula:await p.textContent('.afx')};
  await p.screenshot({path:SHOT(`notes_${exam}.png`),fullPage:true}); return r; }
 out.je=await force('ssc-je-paper1');
 await p.click('[data-a=atom-pick][data-q="0"][data-i="1"]'); out.mcqRight=await p.$$eval('.aopt.right',e=>e.length); out.mcqExp=await p.$$eval('.aexp',e=>e.length);
 out.ntpc=await force('rrb-ntpc-ug-cbt-1');
 await p.click('[data-a=back-learn]'); const other=await p.$$eval('[data-a=open-ch]',e=>e.map(x=>x.dataset.ch).filter(c=>c!=='872')[0]);
 await p.click(`[data-a=open-ch][data-ch="${other}"]`); await p.waitForFunction(()=>/जल्द|coming soon/i.test(document.body.innerText),null,{timeout:20000});
 out.soon=await p.evaluate(()=>/🔒/.test(document.body.innerText)); out.startStillThere=!!(await p.$('[data-a=start-ch]'));
 const ok=out.je.atoms===5&&out.ntpc.atoms===5&&out.je.tagged&&out.ntpc.tagged&&out.je.titles[0]!==out.ntpc.titles[0]&&/MLT⁻²/.test(out.je.formula)&&!/MLT/.test(out.ntpc.formula)&&out.mcqRight===1&&out.mcqExp===1&&out.soon&&out.startStillThere;
 console.log(JSON.stringify(out)); console.log('errors',errs); await b.close(); process.exit(ok&&!errs.length?0:1);})();
