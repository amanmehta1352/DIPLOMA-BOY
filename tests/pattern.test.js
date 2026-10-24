// Same-type questions: chapter list shows one question per pattern with a chip; the chip opens the whole pattern (all exams).
const { chromium } = require('playwright');
const path=require('path'); const URL='file://'+path.resolve(__dirname,'../index.html');
(async()=>{const b=await chromium.launch(process.env.PW_CHROMIUM?{executablePath:process.env.PW_CHROMIUM}:{}); const errs=[]; const out=[];
 for(const [w,scheme] of [[390,'light'],[360,'dark']]){
 const p=await b.newPage({viewport:{width:w,height:800},isMobile:true,colorScheme:scheme}); p.on('pageerror',e=>errs.push(e.message));
 await p.goto(URL); await p.waitForTimeout(2500); await p.click('[data-a=onb-go]'); await p.click('[data-a=branch][data-id=mechanical]');
 const r=await p.evaluate(async()=>{
   const rows=await sb('questions?select=id,pattern_id,pattern_n,pattern_rep,chapter_id&pattern_id=not.is.null&order=id&limit=2000');
   const reps=rows.filter(x=>x.pattern_rep), by={}; rows.forEach(x=>(by[x.pattern_id]=by[x.pattern_id]||[]).push(x));
   const sizeOk=Object.values(by).every(g=>g.length===g[0].pattern_n && g.filter(x=>x.pattern_rep).length===1 && g.every(x=>x.chapter_id===g[0].chapter_id));
   const lead=reps.find(x=>x.pattern_n>=5); const q=(await fetchIds([lead.id]))[0];
   V.sheet={mode:'practice',title:'T',list:[q],i:0,pick:null,c:0,seen:0,meta:{}}; rSheet();
   const chip=document.querySelector('.pat'); const hasChip=!!chip, h=chip?chip.getBoundingClientRect().height:0;
   chip.click(); await new Promise(r=>setTimeout(r,2500));
   const all=[...V.sheet.meta.kinds.exact,...V.sheet.meta.kinds.same,...V.sheet.meta.kinds.related]; const n=all.length, inner=document.querySelectorAll('.pat').length, exams=new Set(all.map(x=>x.src&&x.src.exam)).size;
   const ch=await fetchChapter(lead.chapter_id&&byId(DATA.subjects,R.topics[lead.chapter_id].subject)?R.topics[lead.chapter_id].subject:null,lead.chapter_id,'pyq');
   return {patterns:reps.length,sizeOk,hasChip,tapH:h,opened:n,expect:lead.pattern_n-1,chipInsidePattern:inner,examsInPattern:exams,chapterShowsMembers:ch.some(x=>x.pat && x.id!==x.pat)};});
 out.push({w,scheme,...r}); await p.close(); }
 console.log(JSON.stringify(out)); console.log('errors',errs); await b.close();
 const bad=out.some(o=>!o.sizeOk||!o.hasChip||o.tapH<44||o.opened!==o.expect||o.chipInsidePattern!==0||!o.chapterShowsMembers); process.exit(errs.length||bad?1:0);})();
