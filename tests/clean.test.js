// Every published question with a picture: the question and each option appear ONCE (text or picture, never both copies).
// Run: node tests/clean.test.js
const { chromium } = require('playwright');
const path=require('path'); const URL='file://'+path.resolve(__dirname,'../index.html');
(async()=>{const b=await chromium.launch(process.env.PW_CHROMIUM?{executablePath:process.env.PW_CHROMIUM}:{}); const errs=[];
 const p=await b.newPage({viewport:{width:390,height:844},isMobile:true}); p.on('pageerror',e=>errs.push(e.message));
 await p.goto(URL); await p.waitForTimeout(2500); await p.click('[data-a=onb-go]'); await p.click('[data-a=branch][data-id=mechanical]');
 const res=await p.evaluate(async()=>{
   const rows=await sb('questions?status=eq.published&or=(stem->>img.not.is.null,stem->>img_hi.not.is.null,options->0->>img.not.is.null,options->1->>img.not.is.null,options->2->>img.not.is.null,options->3->>img.not.is.null)&select=*');
   const bad=[]; let n=0;
   for(const lang of ['hi','en','both']){ S.lang=lang;
     for(const r of rows){ const q=norm(r); V.sheet={mode:'practice',title:'T',list:[q],i:0,pick:null,c:0,seen:0}; rSheet(); n++;
       const txt=!!document.querySelector('.qtext'), pics=document.querySelectorAll('.qimg').length;
       if(!txt&&!pics) bad.push([r.id,lang,'question missing']);
       if(txt&&pics&&q.stem.dup&&!q.stem.fig&&lang!=='en') bad.push([r.id,lang,'question twice']);
       document.querySelectorAll('.opt').forEach((o,k)=>{ const t=o.querySelector('.ot').textContent.trim(), im=o.querySelectorAll('img').length;
         if(!t&&!im) bad.push([r.id,lang,'option '+k+' empty']); if(t&&im) bad.push([r.id,lang,'option '+k+' twice']); }); } }
   return {checked:n, bad};});
 console.log(JSON.stringify(res)); console.log('errors',errs); await b.close();
 process.exit(errs.length||res.bad.length||!res.checked?1:0);})();
