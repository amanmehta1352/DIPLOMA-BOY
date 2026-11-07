# Export static SVG figures (white card background) from the approved demos, for notes/teach `fig` fields.
import asyncio, json
from playwright.async_api import async_playwright
OUT={'hi':{},'en':{}}
async def main():
  for LG in ('hi','en'):
    async with async_playwright() as p:
        b=await p.chromium.launch(); pg=await b.new_page(viewport={'width':420,'height':900})
        async def grab(name, sel='#sec .card svg'):
            s=await pg.locator(sel).first.evaluate('e=>e.outerHTML'); OUT[LG][name]=s
        # demo 2 figures, Hindi
        await pg.goto('file:///home/claude/demos/demo2_electricity_figures.html')
        if LG=='en': await pg.click('#lang')
        names=['F2_symbols','F3_meters','F4_vi','F5_resistivity','F6_series_parallel','F7_heating','F8_bill','F9_wiring']
        for i,n in enumerate(names):
            if n=='F6_series_parallel': await pg.click('#f6n button >> nth=1')
            await grab(n); await pg.click('#nx')
        # demo 3 figures
        await pg.goto('file:///home/claude/demos/demo3_teach_series_parallel.html')
        if LG=='en': await pg.click('#lang')
        js='(k)=>{const f=BEATS[k].fig(); const d=document.createElement("div"); d.innerHTML=f.html; return d.querySelector("svg").outerHTML;}'
        await pg.evaluate('()=>{answered={1:2,2:1,3:1,4:1,5:2,6:1,7:3,8:1,9:2};}')
        for k,n in [(1,'S_series_req'),(3,'S_series_V'),(4,'S_series_broken'),(6,'P_branch'),(7,'P_total')]:
            OUT[LG][n]=await pg.evaluate(js,k)
        await pg.evaluate('()=>{st.b=1}'); OUT[LG]['B_bulbs_series']=await pg.evaluate(js,8)
        await pg.evaluate('()=>{st.m=0}'); OUT[LG]['M_mixed0']=await pg.evaluate(js,9)
        await pg.evaluate('()=>{st.m=2}'); OUT[LG]['M_mixed2']=await pg.evaluate(js,9)
        await b.close()
asyncio.run(main())
def card(s):
    # make standalone: xmlns, white rounded background, font
    import re
    vb=re.search(r'viewBox="0 0 (\d+) (\d+)"',s); w,h=vb.group(1),vb.group(2)
    s=s.replace('<svg ','<svg xmlns="http://www.w3.org/2000/svg" font-family="Noto Sans Devanagari, system-ui, sans-serif" ',1)
    s=re.sub(r'(<svg[^>]*>)',r'\1'+f'<rect x="0" y="0" width="{w}" height="{h}" rx="14" fill="#ffffff"/>',s,count=1)
    s=s.replace(' role="img"','')
    return s
json.dump({lg:{k:card(v) for k,v in o.items()} for lg,o in OUT.items()},open('/home/claude/build/figs.json','w'),ensure_ascii=False)
print({lg:len(o) for lg,o in OUT.items()})
