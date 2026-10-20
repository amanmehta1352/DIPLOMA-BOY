const { chromium } = require('playwright');
(async()=>{const b=await chromium.launch({executablePath:'/opt/pw-browsers/chromium'});
const out=[]; const errs=[];
async function run(w,scheme){
const p=await b.newPage({viewport:{width:w,height:800},isMobile:w<700,colorScheme:scheme});p.on('pageerror',e=>errs.push(w+':'+e.message));p.on('console',m=>{if(m.type()==='error')errs.push(w+':console:'+m.text())});
await p.goto(''+require('path').resolve(__dirname,'../index.html').replace(/^/,'file://')+'');await p.waitForTimeout(2500);
await p.screenshot({path:__dirname+`/shots/s_branch_${w}.png`});
await p.click('[data-a=branch][data-id=mechanical]');await p.waitForTimeout(300);
await p.screenshot({path:__dirname+`/shots/s_today_${w}_${scheme}.png`,fullPage:true});
const sw1=await p.evaluate(()=>document.documentElement.scrollWidth);
// practice via today start button
await p.click('[data-a=exam][data-id=ssc-je-paper1]');
await p.click('[data-a=tab][data-id=practice]');
await p.click('[data-a=open-subj][data-subj=mechanical-engineering]');
await p.screenshot({path:__dirname+`/shots/s_topics_${w}.png`});
await p.click('[data-a=start]:not([data-topic])');
await p.waitForSelector('[data-a=pick]',{timeout:20000});
for(let k=0;k<3;k++){ await p.click('[data-a=pick][data-i="0"]'); if(k==0) await p.screenshot({path:__dirname+`/shots/s_q_${w}_${scheme}.png`}); await p.click('[data-a=next]'); }
await p.click('[data-a=close]');
await p.click('[data-a=tab][data-id=mistakes]');
const mis=await p.textContent('#app');
await p.screenshot({path:__dirname+`/shots/s_mis_${w}.png`});
// mock
await p.click('[data-a=tab][data-id=mock]');
await p.click('[data-a=exam][data-id=rrb-je-cbt1]');
await p.click('[data-a=mock-ask]');
await p.click('[data-a=mock-go]');
await p.waitForSelector('#tmr',{timeout:30000});
const nq=await p.evaluate(()=>V.sheet.list.length);
await p.click('[data-a=pick][data-i="1"]'); await p.click('[data-a=m-next]'); await p.click('[data-a=pick][data-i="2"]'); await p.click('[data-a=m-mark]');
await p.screenshot({path:__dirname+`/shots/s_mock_${w}_${scheme}.png`});
await p.click('[data-a=palette]'); await p.screenshot({path:__dirname+`/shots/s_pal_${w}.png`});
await p.click('[data-a=m-submit-ask]'); await p.click('[data-a=m-submit]');
await p.waitForTimeout(300); await p.screenshot({path:__dirname+`/shots/s_res_${w}_${scheme}.png`,fullPage:false});
const res=await p.textContent('#layer');
await p.click('[data-a=m-review]'); await p.click('[data-a=next]'); 
await p.click('[data-a=close]');
await p.click('[data-a=tab][data-id=me]'); await p.screenshot({path:__dirname+`/shots/s_me_${w}.png`,fullPage:true});
const sw2=await p.evaluate(()=>document.documentElement.scrollWidth);
// small tap targets
const small=await p.evaluate(()=>[...document.querySelectorAll('button')].filter(b=>{const r=b.getBoundingClientRect();return r.width&&r.height<36}).map(b=>b.textContent.trim().slice(0,20)));
out.push({w,scheme,sw1,sw2,misHas:/गलती|Mistake/.test(mis), nq, resHas:/अंक|marks/.test(res), small});
await p.close();}
await run(390,'light'); await run(360,'dark'); await run(820,'light');
console.log(JSON.stringify(out,null,0)); console.log('errors',errs);
await b.close();})();
