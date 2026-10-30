"""Build book.html: the owner's physics reader with every data block replaced by server data (mtb.get_chapter_books).
Rendering code, CSS and markup are kept byte-for-byte; only data definitions and data-transform IIFEs are swapped."""
import sys
src, out = sys.argv[1], sys.argv[2]
L = open(src, encoding='utf-8').read().split('\n')
def ln(n): return L[n-1]
def expect(n, start):
    assert ln(n).startswith(start), (n, ln(n)[:80], start)

# sanity checks on the boundaries this build relies on
expect(451, '<script type="application/json" id="extraChapters">')
expect(452, '<script>'); expect(463, 'const CH2 = {'); expect(7103, 'function _dl')
expect(7140, 'const DEMOS = {};'); expect(7281, 'const CHS = ')
expect(7288, 'const FORMULA_GROUPS = {'); expect(7299, '};'); expect(7300, 'function formulaCardsFor')
expect(7319, '</script>'); expect(7320, '<script>')
expect(7604, 'const FIG = {'); expect(7640, '};')
expect(7645, 'const teachData = {'); expect(8516, '};'); expect(8517, '')
expect(8519, '/* Language correctness'); expect(8520, '(function(){'); expect(8532, '})();'); expect(8534, 'function renderTeachUI')
expect(8563, 'const chapterData = {'); expect(9089, '};')
expect(9094, 'const formulaData = ['); expect(9130, '];')
expect(9132, 'const FORMULA_CATS = {'); expect(9137, '};')
expect(9263, '(function init() {'); expect(9268, '})();'); expect(9269, '</script>')
expect(9271, '<script type="text/plain" id="vec3dSrc">'); expect(9458, '</script>')
assert ln(9459).strip() == '</body>' and ln(9460).strip() == '</html>'

LOADER = r'''<div id="bookLoading" style="position:fixed;inset:0;z-index:9999;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:12px;background:#0f172a;color:#e2e8f0;font-family:'Inter','Noto Sans Devanagari',sans-serif;text-align:center;padding:24px">
  <div style="width:34px;height:34px;border:3px solid rgba(94,234,212,.25);border-top-color:#5eead4;border-radius:50%;animation:bkspin .8s linear infinite"></div>
  <div id="bookLoadingMsg">किताब लोड हो रही है… / Loading book…</div>
</div>
<style>@keyframes bkspin{to{transform:rotate(360deg)}}</style>
<script>
/* Diploma Boy: load this book from the server, then run the reader code unchanged. */
(async function bookLoad(){
  const SB = {url:'https://wobmtlcpszcntczkebtt.supabase.co', key:'sb_publishable_7ZZEUDULfYaMHSeLIxfluQ_fZWSCi8R'}; // publishable key
  const q = new URLSearchParams(location.search);
  const book = q.get('b') || 'physics-baseline';
  const msg = t => { const m = document.getElementById('bookLoadingMsg'); if (m) m.innerHTML = t; };
  try {
    const r = await fetch(SB.url + '/rest/v1/rpc/get_chapter_books?p_book=' + encodeURIComponent(book),   /* GET: cached by sw.js for offline */
      {headers:{apikey:SB.key, Authorization:'Bearer ' + SB.key, 'Accept-Profile':'mtb'}});
    if (!r.ok) throw new Error('HTTP ' + r.status);
    const rows = await r.json();
    const one = rows.find(x => x.ch_no === 1);
    if (!rows.length || !one) throw new Error('empty');
    const B = {ch1: one.data, ch: {}, demos: {}, groups: {}};
    rows.filter(x => x.ch_no > 1).forEach(x => {
      const d = x.data;
      B.ch[x.ch_no] = {n: x.ch_no, titles: d.titles, notesEN: d.notes_en, formulas: d.formulas, teach: d.teach};
      B.demos[x.ch_no] = d.demo_html; B.groups[x.ch_no] = d.formula_groups || [];
    });
    window.__BOOK = B;
    document.getElementById('extraChapters').textContent = JSON.stringify({
      chapters: rows.filter(x => x.ch_no > 1).map(x => ({n: x.ch_no, hi: x.title_hi, en: x.title_en, html: x.data.notes_hi})),
      meta: rows.map(x => ({n: x.ch_no, sh: [x.short_hi, x.short_en]}))});
    document.getElementById('vec3dSrc').textContent = one.data.demo_html;
    document.querySelectorAll('script[type="text/plain"][data-code]').forEach(s => {
      const x = document.createElement('script'); x.textContent = s.textContent; document.body.appendChild(x); });
    __bookInit(q);
    document.getElementById('bookLoading').remove();
  } catch (e) {
    msg('किताब लोड नहीं हुई। इंटरनेट जाँचें। / Could not load the book. Check your internet.<br><button onclick="location.reload()" style="margin-top:12px;padding:10px 18px;border-radius:10px;border:1px solid #5eead4;background:none;color:#5eead4;font:inherit;cursor:pointer">फिर कोशिश करें / Retry</button>');
    console.error('book load failed', e);
  }
})();
</script>'''

INIT = '''/* Diploma Boy: lets the app shell read which chapter is open (read-only). */
window.__curCh = () => curCh;
/* INIT (Diploma Boy): runs after the book data has arrived from the server. URL: ?b=<book>&ch=<n>&tab=<tab>&lang=<hi|en|both> */
function __bookInit(q) {
  let saved = 'hi';
  try { saved = localStorage.getItem('phys_lang') || 'hi'; } catch(e){}
  const lang = q && q.get('lang'); setLang(['hi','en','both'].includes(lang) ? lang : saved);
  const ch = q ? parseInt(q.get('ch'), 10) : NaN; if (ch && EXTRA.meta.some(m => m.n === ch)) curCh = ch;
  const tab = q && q.get('tab'); switchTab(['book','notes','teach','formula','3d'].includes(tab) ? tab : 'notes');
}'''

o = []
o += L[0:450]                                                     # 1..450 head, CSS, markup
o.append('<script type="application/json" id="extraChapters"></script>')
o.append('<script type="text/plain" data-code="1">')
o.append('/* Chapter 2–11 data now comes from the server (mtb.chapter_books via mtb.get_chapter_books). */')
o += [f'const CH{n} = __BOOK.ch[{n}];' for n in range(2, 12)]
o += L[7102:7139]                                                 # 7103..7139 helpers (_dl, makeDemoDoc)
o.append('const DEMOS = __BOOK.demos;   /* 3D demo documents from the server */')
o += L[7279:7287]                                                 # 7280..7287
o.append('const FORMULA_GROUPS = __BOOK.groups;   /* from the server */')
o += L[7299:7318]                                                 # 7300..7318
o.append('</script>')
o.append('<script type="text/plain" data-code="2">')
o += L[7320:7603]                                                 # 7321..7603
o.append('const FIG = {};   /* teaching figures are already inside the server teach text */')
o += L[7640:7644]                                                 # 7641..7644
o.append('const teachData = __BOOK.ch1.teach;   /* from the server (already in final bilingual form) */')
o.append('/* (one-time caption/bilingual transform removed: server data is stored after that transform) */')
o += L[8532:8562]                                                 # 8533..8562
o.append('const chapterData = { notesHTML: __BOOK.ch1.notes_html };')
o += L[9089:9093]                                                 # 9090..9093
o.append('const formulaData = __BOOK.ch1.formulas;')
o += L[9130:9131]                                                 # 9131
o.append('const FORMULA_CATS = __BOOK.ch1.formula_cats;')
o += L[9137:9261]                                                 # 9138..9261  (keeps comment line 9262 below)
o += INIT.split('\n')
o.append('</script>')
o += L[9269:9270]                                                 # 9270
o.append('<script type="text/plain" id="vec3dSrc"></script>')
o += LOADER.split('\n')
o += L[9458:]                                                     # 9459.. </body></html>
open(out, 'w', encoding='utf-8').write('\n'.join(o))
print('lines', len(o), 'bytes', len('\n'.join(o).encode()))
