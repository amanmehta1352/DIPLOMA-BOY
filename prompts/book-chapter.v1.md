# Book Chapter Prompt v1 — किसी भी AI में चिपकाएँ

इस्तेमाल: नीचे "PROMPT शुरू" से "PROMPT खत्म" तक पूरा copy करें → सबसे ऊपर का INPUT भरें → किसी भी AI (ChatGPT, Gemini, Claude…) में चिपकाएँ → जो HTML मिले उसे `.html` फ़ाइल में save करके browser में खोलें।
हर बार यही prompt दें; बदलें सिर्फ़ INPUT। इससे हर AI से हर अध्याय एक जैसे design में आएगा।

---

PROMPT शुरू
```
तुम एक अनुभवी भारतीय पाठ्यपुस्तक लेखक और HTML designer हो। नीचे दिए INPUT के लिए
छपी हुई पाठ्यपुस्तक जैसा एक पूरा अध्याय, एक अकेली HTML फ़ाइल में बनाओ।

=============== INPUT (सिर्फ़ यही भरें) ===============
विषय (Subject)          : भौतिकी
कक्षा / Level           : कक्षा 10            (उदाहरण: कक्षा 6-8 / कक्षा 9-10 / कक्षा 11-12 / Diploma / JE / SSC / स्नातक)
अध्याय संख्या           : 4
अध्याय का नाम           : विद्युत धारा और ओम का नियम
भाषा                    : हिंदी + English technical terms   (या: English)
Board / Exam (वैकल्पिक) : Bihar Board
खास निर्देश (वैकल्पिक)  : —
======================================================

-------- नियम 1: सामग्री (CONTENT) --------
1. सब कुछ अपने शब्दों में लिखो। किसी किताब, वेबसाइट या प्रकाशक के वाक्य, पैराग्राफ, उदाहरण,
   सवाल या चित्र कॉपी मत करो, शब्द बदलकर भी नहीं। किसी प्रकाशक या लेखक का नाम मत लिखो।
2. Topics सिलेबस और मानक ज्ञान से लो; गहराई ठीक INPUT के level जितनी हो।
3. भाषा: सरल हिंदी; हर तकनीकी शब्द पहली बार कोष्ठक में English में, जैसे: वेग (velocity)।
   हिंदी वाक्य के अंत में पूर्णविराम "।"।
4. हर सूत्र, हर मान, हर उत्तर दोबारा गणना करके जाँचो। इकाई (SI unit) हमेशा लिखो।
5. जो बात पक्की न हो, उसे मत गढ़ो; उसके आगे [VERIFY] लिखो।
6. गणित plain Unicode में: ×, ÷, ², ³, √, ⁻¹, ρ, Ω। LaTeX ($, \frac) और Markdown (**, #) बिल्कुल नहीं।
   भिन्न के लिए नीचे दिया <span class="frac"> ढाँचा इस्तेमाल करो।

-------- नियम 2: अध्याय का क्रम (यही क्रम, कुछ छोड़ना नहीं) --------
A. अध्याय-शीर्ष: अध्याय संख्या, नाम (हिंदी + English), 3-4 वाक्य की असली जीवन से शुरुआत,
   "इस अध्याय में आप सीखेंगे" (3-5 बिंदु), "पहले से आना चाहिए" (1-3 बिंदु)।
B. 4 से 7 खंड, क्रमांक N.1, N.2 … (N = अध्याय संख्या)। हर खंड में इसी क्रम से:
   परिचय → परिभाषा box → समझाना (क्यों/कैसे) → चित्र (अगर ज़रूरी) → सूत्र box (अगर हो)
   → कम से कम 1 हल किया उदाहरण → "स्वयं जाँचें" (1-2 प्रश्न, उत्तर छिपा)।
C. पूरे अध्याय में कम से कम: 3 चित्र, 4 हल किए उदाहरण, 1 क्रियाकलाप, 1 "क्या आप जानते हैं?"।
D. "सावधान! आम गलतियाँ": 3-5 (गलत बात → सही बात)।
E. "सारांश": 6-10 एक-पंक्ति बिंदु, खंडों के क्रम में।
F. "अभ्यास": क. बहुविकल्पी (5) · ख. अति लघु उत्तरीय (4) · ग. लघु उत्तरीय (3)
   · घ. दीर्घ उत्तरीय (2) · ङ. आंकिक प्रश्न (4, अगर विषय में गणना हो) — आसान से कठिन।
G. "उत्तरमाला": सभी बहुविकल्पी के उत्तर + सभी आंकिक प्रश्नों के पूरे हल।
क्रमांक: चित्र N.1, उदाहरण N.1, सारणी N.1, क्रियाकलाप N.1।

हल किए उदाहरण का ढाँचा हमेशा यही:
  प्रश्न → दिया है → ज्ञात करना है → सूत्र → मान रखने पर (हर step अलग पंक्ति में, असली संख्याओं के साथ)
  → उत्तर (इकाई सहित)।

-------- नियम 3: चित्र (FIGURES) --------
1. हर चित्र inline <svg> में बनाओ (बाहरी image नहीं)। viewBox दो, width="100%"।
2. हर <svg> में <title> हो; लेबल साफ़ और पढ़ने योग्य (font-size ≥ 13)।
3. चित्र सही हो: circuit में सही polarity और meter की सही जगह; graph में दोनों अक्ष, नाम और इकाई;
   बल/वेग के तीर सही दिशा में। सुंदर पर गलत चित्र कभी नहीं।
4. हर चित्र के नीचे <figcaption>: "चित्र N.M — विवरण"।

-------- नियम 4: DESIGN (बदलना मना) --------
1. Output = एक पूरी HTML फ़ाइल: <!doctype html> से </html> तक। कोई बाहरी CSS, font, script या CDN नहीं।
2. नीचे दी गई <style> को अक्षरशः (बिना बदले) <head> में रखो। अपनी तरफ़ से नई CSS मत जोड़ो।
   सिर्फ़ :root का --accent level के हिसाब से चुनो:
     कक्षा 6-10 → #047857 · कक्षा 11-12/NEET/JEE → #1d4ed8 · Diploma/JE/SSC/नौकरी → #b45309 · स्नातक और ऊपर → #6d28d9
3. सामग्री सिर्फ़ नीचे दिए HTML ढाँचे के class नामों से बनाओ (नए class नहीं)।
4. JavaScript नहीं चाहिए; छिपे उत्तर <details><summary> से।

<style>
:root{--accent:#b45309;--ink:#18212b;--muted:#4b5866;--paper:#fffdf8;--line:#d4dce2}
*{box-sizing:border-box}
body{margin:0;background:#eef1f4;color:var(--ink);font:17px/1.75 "Noto Sans Devanagari","Nirmala UI","Mangal",system-ui,sans-serif}
.page{max-width:820px;margin:0 auto;background:var(--paper);padding:28px 20px 48px}
@media(min-width:860px){.page{margin:24px auto;padding:48px 64px;border:1px solid var(--line);border-radius:6px}}
.running{display:flex;justify-content:space-between;font-size:13px;color:var(--muted);border-bottom:1px solid var(--line);padding-bottom:6px;margin-bottom:24px}
h1,h2,h3{font-family:"Noto Serif Devanagari","Nirmala UI","Mangal",serif;line-height:1.35;color:var(--ink)}
.ch-head{border-left:6px solid var(--accent);padding:4px 0 4px 16px;margin-bottom:20px}
.ch-no{font-size:15px;font-weight:700;color:var(--accent);letter-spacing:.04em}
.ch-head h1{font-size:30px;margin:4px 0}.ch-head .en{font-size:17px;color:var(--muted)}
.intro{font-size:18px}
.learn{display:grid;gap:12px;margin:16px 0 28px}@media(min-width:640px){.learn{grid-template-columns:1fr 1fr}}
.learn div{border:1px solid var(--line);border-radius:10px;padding:10px 14px}.learn b{color:var(--accent)}
h2{font-size:23px;margin:40px 0 10px;padding-bottom:6px;border-bottom:2px solid var(--accent)}
h2 .no{color:var(--accent);margin-right:8px}
h3{font-size:19px;margin:24px 0 8px}
p{margin:0 0 14px}ul,ol{padding-left:24px;margin:0 0 14px}
.box{border:2px solid;border-radius:12px;margin:18px 0;overflow:hidden;break-inside:avoid}
.box>.bh{font-weight:700;padding:7px 14px;border-bottom:2px solid;font-size:15px}
.box>.bb{padding:10px 14px}.box>.bb>:last-child{margin-bottom:0}
.defn{border-color:#3b82f6}.defn>.bh{background:#eff6ff;color:#1d4ed8;border-color:#3b82f6}
.formula{border-color:#f59e0b}.formula>.bh{background:#fde68a;color:#0f172a;border-color:#f59e0b}
.example{border-color:#f59e0b}.example>.bh{background:#fffbeb;color:#b45309;border-color:#f59e0b}
.activity{border-color:#10b981}.activity>.bh{background:#ecfdf5;color:#047857;border-color:#10b981}
.know{border-color:#14b8a6}.know>.bh{background:#f0fdfa;color:#0f766e;border-color:#14b8a6}
.mistakes{border-color:#ef4444}.mistakes>.bh{background:#fef2f2;color:#b91c1c;border-color:#ef4444}
.summary{border-color:#10b981}.summary>.bh{background:#ecfdf5;color:#047857;border-color:#10b981}
.eq{font:600 20px/1.6 "Cambria Math","Times New Roman",serif;text-align:center;margin:8px 0}
.frac{display:inline-flex;flex-direction:column;vertical-align:middle;text-align:center;margin:0 3px;line-height:1.15}
.frac>span:first-child{border-bottom:1.5px solid currentColor;padding:0 4px}
.sym{font-size:15px;color:var(--muted)}
.step{margin:0 0 6px;padding-left:12px;border-left:3px solid #fde68a}
.ans{display:inline-block;border:2px solid #b45309;border-radius:999px;padding:2px 14px;font-weight:700;color:#b45309;margin-top:6px}
figure{margin:20px 0;text-align:center;break-inside:avoid}figure svg{max-width:100%;height:auto}
figcaption{font-size:14px;color:var(--muted);margin-top:6px}
table{border-collapse:collapse;width:100%;margin:12px 0;font-size:15px}th,td{border:1px solid var(--line);padding:7px 9px;text-align:center}th{background:#f3f5f6}
.tw{overflow-x:auto}
details.check{border:1px dashed var(--accent);border-radius:10px;padding:8px 14px;margin:14px 0}
details summary{cursor:pointer;font-weight:700;color:var(--accent);min-height:32px}
.exercise h3{color:var(--accent)}.exercise ol{margin-bottom:18px}
.opts{display:grid;grid-template-columns:1fr 1fr;gap:2px 16px;list-style:none;padding-left:0;margin:4px 0 12px}
@media print{body{background:#fff}.page{border:0;margin:0;max-width:none;padding:0}@page{size:A4;margin:16mm}h2{break-after:avoid}details{display:block}details>*{display:block}}
</style>

HTML ढाँचा (class नाम यही रखो; [...] की जगह सामग्री):
<body><main class="page">
 <div class="running"><span>[विषय] · [कक्षा/Level]</span><span>अध्याय [N]</span></div>
 <header class="ch-head"><div class="ch-no">अध्याय [N]</div><h1>[नाम]</h1><div class="en">[English नाम]</div></header>
 <p class="intro">[शुरुआत]</p>
 <div class="learn"><div><b>इस अध्याय में आप सीखेंगे</b><ul>[li…]</ul></div><div><b>पहले से आना चाहिए</b><ul>[li…]</ul></div></div>

 <section id="s[N]-1"><h2><span class="no">[N].1</span>[खंड का नाम]</h2>
  <p>[परिचय]</p>
  <div class="box defn"><div class="bh">परिभाषा</div><div class="bb"><p>[एक वाक्य]</p></div></div>
  <p>[समझाना]</p>
  <figure><svg viewBox="0 0 W H" width="100%" role="img"><title>[चित्र का नाम]</title>[…]</svg><figcaption>चित्र [N].1 — [विवरण]</figcaption></figure>
  <div class="box formula"><div class="bh">सूत्र</div><div class="bb"><div class="eq">I = <span class="frac"><span>Q</span><span>t</span></span></div><p class="sym">[symbols का अर्थ, SI इकाई, शर्त]</p></div></div>
  <div class="box example"><div class="bh">उदाहरण [N].1</div><div class="bb"><p><b>[प्रश्न]</b></p>
   <p class="step">दिया है: …</p><p class="step">ज्ञात करना है: …</p><p class="step">सूत्र: …</p><p class="step">मान रखने पर: …</p>
   <span class="ans">उत्तर: … [इकाई]</span></div></div>
  <details class="check"><summary>स्वयं जाँचें</summary><p>[प्रश्न] — उत्तर: […]</p></details>
 </section>
 [बाकी खंड इसी तरह; बीच में जहाँ ठीक हो:]
  <div class="box activity"><div class="bh">क्रियाकलाप [N].1</div><div class="bb"><p><b>सामग्री:</b> …</p><ol>[विधि]</ol><div class="tw"><table>[अवलोकन]</table></div><p><b>निष्कर्ष:</b> …</p></div></div>
  <div class="box know"><div class="bh">क्या आप जानते हैं?</div><div class="bb"><p>…</p></div></div>

 <div class="box mistakes"><div class="bh">सावधान! आम गलतियाँ</div><div class="bb"><ul><li><b>गलत:</b> … → <b>सही:</b> …</li></ul></div></div>
 <div class="box summary"><div class="bh">सारांश</div><div class="bb"><ul>[li…]</ul></div></div>
 <section class="exercise"><h2>अभ्यास</h2>
  <h3>क. बहुविकल्पी प्रश्न</h3><ol><li>[प्रश्न]<ul class="opts"><li>(a) …</li><li>(b) …</li><li>(c) …</li><li>(d) …</li></ul></li></ol>
  <h3>ख. अति लघु उत्तरीय प्रश्न</h3><ol>…</ol>
  <h3>ग. लघु उत्तरीय प्रश्न</h3><ol>…</ol>
  <h3>घ. दीर्घ उत्तरीय प्रश्न</h3><ol>…</ol>
  <h3>ङ. आंकिक प्रश्न</h3><ol>…</ol>
 </section>
 <section><h2>उत्तरमाला</h2>[बहुविकल्पी उत्तर; आंकिक के पूरे हल, उदाहरण वाले step-ढाँचे में]</section>
</main></body>

-------- नियम 5: जवाब देने से पहले खुद जाँचो --------
[ ] HTML पूरा है (<!doctype html> से </html> तक) और कुछ बीच में कटा नहीं।
[ ] <style> अक्षरशः वही है; सिर्फ़ --accent बदला; कोई बाहरी link/script नहीं।
[ ] क्रम A→G पूरा; गिनतियाँ (खंड, चित्र, उदाहरण, अभ्यास) पूरी।
[ ] हर उदाहरण और आंकिक का उत्तर दोबारा गणना से सही; इकाई लिखी।
[ ] हर चित्र में <title>, लेबल, figcaption; चित्र वैज्ञानिक रूप से सही।
[ ] कोई Markdown (**, #, ```), LaTeX ($, \frac) नहीं।
[ ] किसी किताब/प्रकाशक की नक़ल या नाम नहीं।
[ ] अनिश्चित बातें [VERIFY] से चिह्नित।

-------- OUTPUT --------
सिर्फ़ एक ```html code block दो, जिसमें पूरी HTML फ़ाइल हो। उसके पहले या बाद कोई बात मत लिखो।
अगर जवाब लंबा होने से कट जाए, तो मेरे "जारी रखो" कहने पर ठीक वहीं से आगे लिखना।
```
PROMPT खत्म

---

## इस्तेमाल के सुझाव
- **लंबाई:** पूरा अध्याय लंबा होता है। कोई AI बीच में रुक जाए तो "जारी रखो" लिखें; फिर दोनों हिस्से जोड़कर एक फ़ाइल बनाएँ।
- **जाँच:** HTML खोलकर देखें — सूत्र, उत्तर, चित्र। गलती मिले तो उसी chat में लिखें: "उदाहरण 4.3 का उत्तर दोबारा जाँचो और पूरी HTML फिर दो"।
- **एक-सा design:** `<style>` कभी न बदलें। अलग level के लिए सिर्फ़ INPUT का "कक्षा / Level" बदलें; रंग prompt अपने-आप चुनवा देता है।
- **बनावट के नियम** विस्तार से: [`docs/BOOK_ANATOMY.md`](../docs/BOOK_ANATOMY.md)।
