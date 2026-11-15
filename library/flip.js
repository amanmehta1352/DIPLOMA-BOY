/* Diploma Boy · Book mode reader (library/reader.html).
   Page-by-page book reader: shows one fixed-layout page at a time, fitted to the screen.
   Swipe left/right (or the small ‹ › buttons) turns the page. Double-tap zooms in, double-tap again to fit.
   Applied at runtime to a chapter document; the chapter file itself is not changed. */
function dbFlip(doc,win,meta){ meta=meta||{};
  const W=1055,H=1491, pages=[...doc.querySelectorAll('section.pw')]; if(!pages.length) return;
  const st=doc.createElement('style');
  st.textContent=`html,body{margin:0!important;padding:0!important;width:100%;height:100%;overflow:hidden!important;background:#0a1f14!important;overscroll-behavior:none;touch-action:none}
section.pw{position:fixed!important;left:0;top:0;margin:0!important;width:${W}px!important;height:${H}px;zoom:1!important;transform-origin:0 0;will-change:transform;transition:transform .38s cubic-bezier(.22,.7,.2,1),opacity .38s;backface-visibility:hidden}
section.pw.off{visibility:hidden}
.fl-bar{position:fixed;left:0;right:0;z-index:8;background:rgba(13,36,25,.97);color:#e8e4d0;display:flex;align-items:center;justify-content:center;font-family:NSD,'Noto Sans Devanagari',system-ui,sans-serif;overflow:hidden}
.fl-top{top:0;padding:env(safe-area-inset-top) 12px 0 12px;justify-content:space-between;gap:8px;border-bottom:1px solid rgba(168,213,186,.2)}
.fl-top b{flex:1;min-width:0;text-align:center;font-family:'Kalam',cursive;font-size:14px;font-weight:700;color:#f5f0d4;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.fl-back{flex:none;padding:7px 12px;border-radius:100px;background:rgba(168,213,186,.12);border:1px solid rgba(168,213,186,.3);color:#a8d5ba;font:700 11.5px 'Kalam',cursive;cursor:pointer}
.fl-top i{font-style:normal;flex:none;font:700 11px 'Kalam',cursive;background:#f4d35e;color:#0d2419;border-radius:100px;padding:5px 10px}
.fl-bot{bottom:0;border-top:1px solid rgba(168,213,186,.2);padding-bottom:env(safe-area-inset-bottom)}
.fl-prog{position:absolute;left:0;top:-1px;height:2px;background:#f4d35e;transition:width .35s}
.fl-nav{position:fixed;bottom:calc(var(--bb,40px)/2 - 18px + env(safe-area-inset-bottom)/2);width:36px;height:36px;border-radius:50%;border:1px solid rgba(168,213,186,.3);background:rgba(168,213,186,.12);color:#a8d5ba;font:600 22px/33px system-ui,sans-serif;text-align:center;z-index:9;backdrop-filter:blur(6px);-webkit-backdrop-filter:blur(6px);opacity:.85;transition:opacity .2s;padding:0;cursor:pointer;user-select:none;-webkit-user-select:none}
.fl-nav:active{opacity:.95}.fl-nav[disabled]{opacity:0;pointer-events:none}
.fl-prev{left:14px}.fl-next{right:14px}
.fl-hint{position:absolute;left:50%;transform:translateX(-50%);font:700 11.5px 'Kalam',cursive;color:#8fb89c;white-space:nowrap}
.fl-num{display:none;position:fixed;bottom:calc(var(--bb,40px)/2 - 11px + env(safe-area-inset-bottom)/2);left:50%;transform:translateX(-50%);padding:3px 11px;border-radius:20px;background:rgba(16,24,40,.45);color:#fff;font:600 12px system-ui,sans-serif;z-index:9;backdrop-filter:blur(6px);-webkit-backdrop-filter:blur(6px);pointer-events:none;transition:opacity .4s}
.fl-fs{display:none;position:fixed;top:calc(var(--tb,40px)/2 - 17px + env(safe-area-inset-top)/2);right:10px;width:34px;height:34px;border-radius:50%;border:1px solid rgba(255,255,255,.18);background:rgba(16,24,40,.32);color:#fff;font:16px/32px system-ui;text-align:center;z-index:9;opacity:.8;padding:0;cursor:pointer}`;
  doc.head.appendChild(st);
  const mk=(c,t,lbl)=>{ const b=doc.createElement('button'); b.className=c; b.innerHTML=t; b.setAttribute('aria-label',lbl); doc.body.appendChild(b); return b; };
  const prev=mk('fl-nav fl-prev','‹','Previous page'), next=mk('fl-nav fl-next','›','Next page'), fs=mk('fl-fs','⛶','Full screen');
  const num=doc.createElement('div'); num.className='fl-num'; doc.body.appendChild(num);
  const top=doc.createElement('div'); top.className='fl-bar fl-top'; top.innerHTML=(meta.back?'<button class="fl-back">‹ '+meta.back+'</button>':'')+'<b></b><i></i>'; doc.body.appendChild(top);
  const bot=doc.createElement('div'); bot.className='fl-bar fl-bot'; bot.innerHTML='<span class="fl-prog"></span><span class="fl-hint"></span>'; doc.body.appendChild(bot);
  top.querySelector('b').textContent=meta.title||doc.title||'';
  const bk=top.querySelector('.fl-back'); if(bk) bk.addEventListener('click',e=>{ e.stopPropagation(); if(meta.onBack) meta.onBack(); });
  let cur=0, zoom=1, px=0, py=0, dx=0, kx=1, ky=1, ox=0, oy=0;
  try{ const h=parseInt((win.location.hash||'').replace('#p',''),10); if(h>0&&h<=pages.length) cur=h-1; }catch(e){}
  function fit(){ const vw=win.innerWidth, vh=win.innerHeight, minBar=34;
    kx=vw/W; ky=Math.min(kx*1.10,(vh-2*minBar)/H); if(ky<kx){ ky=(vh-2*minBar)/H; kx=Math.min(kx,ky); }   // true shape; at most 10% taller
    ox=(vw-W*kx)/2; const ph=H*ky, gap=vh-ph; oy=Math.round(gap*0.45);
    top.style.height=oy+'px'; bot.style.height=(vh-oy-ph)+'px'; doc.documentElement.style.setProperty('--tb',oy+'px'); doc.documentElement.style.setProperty('--bb',(vh-oy-ph)+'px'); }
  function place(anim){
    const vw=win.innerWidth;
    pages.forEach((p,i)=>{
      const d=i-cur; p.classList.toggle('off',Math.abs(d)>1);
      p.style.transition=anim?'':'none';
      let x=ox+d*vw+dx, y=oy;
      if(d===0&&zoom>1){ x=px; y=py; }
      p.style.transform=`translate(${x}px,${y}px) scale(${kx*(d===0?zoom:1)},${ky*(d===0?zoom:1)})`;
      p.style.opacity=1;
    });
    prev.disabled=cur===0; next.disabled=cur===pages.length-1;
    num.textContent=(cur+1)+' / '+pages.length; top.querySelector('i').textContent='पृष्ठ '+(cur+1)+' / '+pages.length; bot.firstChild.style.width=((cur+1)/pages.length*100)+'%'; bot.querySelector('.fl-hint').textContent=cur===0?'← स्वाइप करें · पेज पलटें →':'📖 किताब';
    try{ win.history.replaceState(null,'','#p'+(cur+1)); }catch(e){}
    try{ win.parent&&win.parent.postMessage({dbPage:cur+1,of:pages.length},'*'); }catch(e){}
  }
  function go(n){ n=Math.max(0,Math.min(pages.length-1,n)); if(n===cur){ dx=0; place(true); return; } cur=n; zoom=1; px=py=0; dx=0; place(true); }
  const tapOn=(b,f)=>{ b.addEventListener('pointerup',e=>{ e.stopPropagation(); e.preventDefault(); if(!b.disabled) f(); }); b.addEventListener('touchend',e=>e.stopPropagation()); };
  tapOn(prev,()=>go(cur-1)); tapOn(next,()=>go(cur+1));
  fs.onclick=e=>{ e.stopPropagation(); const el=doc.documentElement; try{ if(doc.fullscreenElement) doc.exitFullscreen(); else (el.requestFullscreen||el.webkitRequestFullscreen).call(el); }catch(er){} };
  win.addEventListener('keydown',e=>{ if(e.key==='ArrowRight') go(cur+1); else if(e.key==='ArrowLeft') go(cur-1); });
  // touch: horizontal swipe turns the page; when zoomed, drag pans; double-tap toggles zoom
  let sx=0,sy=0,t0=0,mode='',lastTap=0,bx=0,by=0;
  doc.addEventListener('touchstart',e=>{ if(e.target.closest&&e.target.closest('button')) return; if(e.touches.length>1) return; const t=e.touches[0]; sx=t.clientX; sy=t.clientY; t0=Date.now(); mode=''; bx=px; by=py; },{passive:true});
  doc.addEventListener('touchmove',e=>{ if(e.touches.length>1) return; const t=e.touches[0], mx=t.clientX-sx, my=t.clientY-sy;
    if(zoom>1){ px=bx+mx; py=by+my; clamp(); place(false); return; }
    if(!mode) mode=Math.abs(mx)>Math.abs(my)?'h':'v';
    if(mode==='h'){ dx=mx*((cur===0&&mx>0)||(cur===pages.length-1&&mx<0)?.3:1); place(false); } },{passive:true});
  doc.addEventListener('touchend',e=>{ if(e.target.closest&&e.target.closest('button')) return; const now=Date.now(), dt=now-t0;
    if(zoom===1&&mode==='h'){ const v=dx/Math.max(dt,1); if(dx<-win.innerWidth*.18||v<-.45) go(cur+1); else if(dx>win.innerWidth*.18||v>.45) go(cur-1); else { dx=0; place(true); } return; }
    if(Math.abs((e.changedTouches[0]||{}).clientX-sx)<10&&dt<250){
      if(now-lastTap<300){ const t=e.changedTouches[0]; if(zoom>1){ zoom=1; px=py=0; } else { const rx=(t.clientX-ox)/(W*kx), ry=(t.clientY-oy)/(H*ky); zoom=2.2; px=t.clientX-rx*W*kx*zoom; py=t.clientY-ry*H*ky*zoom; clamp(); } place(true); lastTap=0; }
      else lastTap=now; } });
  function clamp(){ const vw=win.innerWidth, vh=win.innerHeight, pw=W*kx*zoom, ph=H*ky*zoom; px=Math.min(0,Math.max(vw-pw,px)); py=Math.min(0,Math.max(vh-ph,py)); }
  win.addEventListener('resize',()=>{ fit(); place(false); });
  fit(); place(false);
}
