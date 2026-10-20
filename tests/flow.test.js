// Diploma Boy end-to-end check. Run: mkdir -p tests/shots && node tests/flow.test.js
const { chromium } = require('playwright');
const path=require('path'); const URL='file://'+path.resolve(__dirname,'../index.html'); const SHOT=n=>path.join(__dirname,'shots',n);
(async()=>{const b=await chromium.launch({executablePath:'/opt/pw-browsers/chromium'}); const out=[]; const errs=[];
async function run(w,scheme){
 const p=await b.newPage({viewport:{width:w,height:800},isMobile:w<700,colorScheme:scheme});
 p.on('pageerror',e=>errs.push(w+':'+e.message)); p.on('console',m=>{if(m.type()==='error')errs.push(w+':console:'+m.text())});
 await p.goto(URL); await p.waitForTimeout(2500);
 await p.click('[data-a=branch][data-id=mechanical]'); await p.waitForTimeout(200); await p.screenshot({path:SHOT(`today_${w}_${scheme}.png`),fullPage:true});
 // 1) विषय: science → chapter → mixed set
 await p.click('[data-a=tab][data-id=learn]'); await p.screenshot({path:SHOT(`learn_${w}.png`)});
 await p.click('[data-a=open-subj][data-subj=general-science]'); await p.screenshot({path:SHOT(`chapters_${w}.png`),fullPage:true});
 await p.click('[data-a=open-ch]'); await p.screenshot({path:SHOT(`chapter_${w}.png`)});
 await p.click('[data-a=start-ch]:not([data-kind])'); await p.waitForSelector('[data-a=pick]',{timeout:20000});
 const learnTags=await p.$$eval('.qmeta .tag',e=>e.map(x=>x.textContent));
 for(let k=0;k<3;k++){ await p.click('[data-a=pick][data-i="0"]'); if(k===0) await p.screenshot({path:SHOT(`q_${w}_${scheme}.png`)}); await p.click('[data-a=next]'); }
 await p.click('[data-a=close]');
 // 2) Practice
 await p.click('[data-a=tab][data-id=practice]'); await p.click('[data-a=open-psubj][data-subj=general-science]');
 await p.click('[data-a=start-ch][data-kind=practice][data-ch]'); await p.waitForSelector('[data-a=pick]',{timeout:20000});
 const prTag=await p.textContent('.qmeta .tag'); await p.click('[data-a=pick][data-i="1"]'); await p.screenshot({path:SHOT(`practice_${w}.png`)}); await p.click('[data-a=close]');
 // 3) PYQ: SSC → paper → mock
 await p.click('[data-a=tab][data-id=pyq]'); await p.click('[data-a=exam][data-id=ssc-je-paper1]'); await p.screenshot({path:SHOT(`pyq_${w}.png`),fullPage:true});
 await p.click('[data-a=open-paper]'); await p.click('[data-a=mock-ask]'); await p.click('[data-a=mock-go]'); await p.waitForSelector('#tmr',{timeout:30000});
 const nq=await p.evaluate(()=>V.sheet.list.length);
 await p.click('[data-a=pick][data-i="1"]'); await p.click('[data-a=m-next]'); await p.click('[data-a=m-mark]'); await p.click('[data-a=palette]');
 await p.click('[data-a=m-submit-ask]'); await p.click('[data-a=m-submit]'); await p.waitForTimeout(200); const res=await p.textContent('#layer');
 await p.click('[data-a=m-review]'); await p.click('[data-a=next]'); await p.click('[data-a=close]');
 // 4) PYQ by exam subject, mistakes, me
 await p.click('[data-a=back-pyq]'); await p.click('[data-a=start-exsub][data-subj=mechanical-engineering]'); await p.waitForSelector('[data-a=pick]',{timeout:20000}); const exTags=await p.$$eval('.qmeta .tag',e=>e.map(x=>x.textContent)); await p.click('[data-a=close]');
 await p.click('[data-a=tab][data-id=today]'); await p.click('[data-a=open-mis]'); const mis=await p.textContent('#app');
 await p.click('[data-a=tab][data-id=me]'); await p.screenshot({path:SHOT(`me_${w}.png`),fullPage:true});
 const sw=await p.evaluate(()=>document.documentElement.scrollWidth);
 const small=await p.evaluate(()=>[...document.querySelectorAll('button')].filter(x=>{const r=x.getBoundingClientRect();return r.width&&r.height<36}).length);
 out.push({w,scheme,ok_learn:learnTags.length>0,practiceTag:prTag,mockQ:nq,result:/अंक|marks/.test(res),examPYQ:exTags.every(t=>t==='PYQ'),mistakes:/गलती|Mistake/.test(mis),overflow:sw>w,smallButtons:small});
 await p.close(); }
await run(390,'light'); await run(360,'dark'); await run(820,'light');
console.log(JSON.stringify(out)); console.log('errors',errs); await b.close(); process.exit(errs.length?1:0);})();
