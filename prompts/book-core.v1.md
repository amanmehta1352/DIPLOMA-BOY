तुम एक अनुभवी भारतीय पाठ्यपुस्तक लेखक हो। नीचे दिए अध्याय का "अध्याय-core" लिखो: एक JSON object (schema book.core.v1)।
इसी core से code अलग-अलग शैलियों (सरल, अभ्यास …) की किताब बनाता है, इसलिए तुम सिर्फ़ सामग्री दो, design नहीं।

=============== अध्याय ===============
id            : {id}
विषय          : {subject_hi} ({subject_en})
कक्षा / Level : {level_hi}
अध्याय        : {no}. {title_hi} ({title_en})
level_family  : {level_family}
किन topics को ज़रूर लेना है: {topics}
======================================

-------- नियम: सामग्री --------
1. सब कुछ अपने शब्दों में। किसी किताब, वेबसाइट या प्रकाशक के वाक्य, उदाहरण, सवाल या चित्र कॉपी मत करो, शब्द बदलकर भी नहीं।
   किसी प्रकाशक या लेखक का नाम मत लिखो।
2. गहराई ठीक इसी level जितनी। भाषा सरल हिंदी; हर तकनीकी शब्द पहली बार कोष्ठक में English में, जैसे: वेग (velocity)।
3. हर सूत्र, मान और उत्तर दोबारा गणना करके जाँचो। SI इकाई हमेशा लिखो।
4. जो बात पक्की न हो उसे मत गढ़ो; उसके आगे [VERIFY] लिखो।
5. Plain text: गणित Unicode में (×, ÷, ², ³, √, ⁻¹, ρ, Ω)। भिन्न इस तरह: [[ऊपर|नीचे]], जैसे I = [[Q|t]]।
   LaTeX ($, \frac), Markdown (**, #, ```) और HTML बिल्कुल नहीं (सिर्फ़ figures के svg में SVG)।

-------- JSON की बनावट (keys ठीक यही) --------
{
 "schema": "book.core.v1", "id": "{id}", "level_family": "{level_family}",
 "subject": {"hi": "{subject_hi}", "en": "{subject_en}"}, "level_hi": "{level_hi}",
 "no": {no}, "title_hi": "{title_hi}", "title_en": "{title_en}",
 "intro": "3-4 वाक्य, असली जीवन से शुरुआत",
 "learn": ["3-6 बिंदु: इस अध्याय में आप सीखेंगे"],
 "prereq": ["1-3 बिंदु: पहले से आना चाहिए"],
 "figures": {
   "<key>": {"caption": "चित्र का विवरण", "svg": "<svg viewBox=\"0 0 W H\" width=\"100%\" role=\"img\"><title>नाम</title>…</svg>"}
 },
 "sections": [
  {"key": "छोटा-अंग्रेज़ी-key", "title": "खंड का नाम", "intro": "परिचय", "defn": "एक वाक्य की परिभाषा",
   "explain": [{"depth": "core", "text": "मुख्य समझ"}, {"depth": "extra", "text": "गहराई वाली बात (वैकल्पिक)"}],
   "figure": "<figures की key, अगर इस खंड में चित्र है>",
   "formula": {"eq": "V = I × R", "symbols": "V = विभवांतर, …", "unit": "Ω = V/A", "when": "शर्त"},
   "examples": [
     {"level": 1, "q": "प्रश्न", "given": "दिया है", "find": "ज्ञात करना है", "formula": "I = [[V|R]]",
      "steps": ["I = [[12|4]]", "I = 3 A"], "answer": "3 A", "calc": "12/4", "value": 3}
   ],
   "checks": [{"q": "स्वयं जाँचें प्रश्न", "a": "उत्तर"}],
   "activity": {"title": "…", "material": "…", "steps": ["…"], "table": [["शीर्षक", "…"], ["…", "…"]], "result": "निष्कर्ष"},
   "know": "क्या आप जानते हैं? (वैकल्पिक)",
   "table": {"caption": "सारणी का नाम", "rows": [["शीर्षक", "…"], ["…", "…"]]}
  }
 ],
 "mistakes": [{"wrong": "गलत बात", "right": "सही बात"}],
 "summary": ["एक-पंक्ति बिंदु"],
 "questions": [
  {"type": "mcq", "level": 1, "section": "<section key>", "q": "…", "options": ["…", "…", "…", "…"], "answer": 1},
  {"type": "vshort", "level": 1, "section": "…", "q": "…", "answer": "…"},
  {"type": "short", "level": 2, "section": "…", "q": "…", "answer": "…"},
  {"type": "long", "level": 3, "section": "…", "q": "…", "answer": "…"},
  {"type": "numeric", "level": 2, "section": "…", "q": "…", "solution": ["step", "step"], "calc": "3*120", "value": 360, "unit": "C"}
 ]
}

-------- गिनती (कम से कम) --------
- 4 से 7 sections; हर section में 2-3 examples (level 1 → 2 → 3 के क्रम में) और 1-2 checks।
- पूरे अध्याय में: 3 figures, 1 activity, 1 know, 3-5 mistakes, 6-10 summary।
- questions: mcq 8, vshort 6, short 4, long 3, numeric 8 (अगर विषय में गणना हो)। हर question का "section" किसी section की key हो।

-------- calc और value (code इन्हें दोबारा गणना करके मिलाता है) --------
- हर example और हर numeric question में "calc" = सिर्फ़ सादा अंकगणित: अंक, + - * / ( ) . और e (जैसे 6.67e-11)।
  कोई अक्षर, ×, ^, √, इकाई नहीं। घात के लिए गुणा लिखो: 3² → 3*3; √ के लिए पहले ही मान निकालो।
- "value" = calc का सही परिणाम (संख्या)। answer की संख्या value से मेल खाए।
- steps में असली संख्याएँ, हर step अलग पंक्ति; आख़िरी step उत्तर तक पहुँचे।

-------- figures --------
- SVG सही हो: circuit में सही polarity और meter की जगह; graph में दोनों अक्ष, नाम और इकाई; तीर सही दिशा में।
- हर svg में <title>, लेबल font-size ≥ 13; कोई script, onclick, href, बाहरी image नहीं।

-------- MCQ --------
- 4 अलग-अलग विकल्प, "answer" = सही विकल्प का index (0-3)। एक ही सही उत्तर।

-------- OUTPUT --------
सिर्फ़ JSON object दो। उसके पहले या बाद कोई बात, Markdown या code block नहीं।
