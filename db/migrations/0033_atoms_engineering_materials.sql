-- 0033 Chapter notes: Engineering Materials (topic 432 'engineering-materials', Mechanical Engineering). Additive. Same body shape as Force (0029).
-- govt_technical = SSC JE / RRB JE depth; govt_basic = RRB NTPC depth; one shared diagram (level_id null).

with ch as (select id from mtb.topics where slug = 'engineering-materials' limit 1)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang)
select ch.id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb, 'hi' from ch, (values
 ('govt_technical','mat-concept','concept',1,'इंजीनियरिंग मटेरियल — SSC JE / RRB JE',
  $j${"text":"इंजीनियरिंग मटेरियल को मोटे तौर पर धातु (लोहा, तांबा, एल्युमिनियम) और अधातु में बाँटा जाता है। स्टील लोहा और कार्बन का मिश्रण है, जिसमें कार्बन लगभग 0.02% से 2% तक होता है। कार्बन बढ़ने से कठोरता बढ़ती है, पर लचीलापन घटता है।","note":"JE में कार्बन स्टील के प्रकार और उनके गुण (कठोरता बनाम लचीलापन) अक्सर पूछे जाते हैं।"}$j$),
 ('govt_technical','mat-formula','formula',2,'यंग मापांक का सूत्र',
  $j${"formula":"E = σ / ε","explanation":"σ = प्रतिबल (N/m² या Pa), ε = विकृति (बिना मात्रक, ΔL / L), E = यंग मापांक (Pa) · E का विमीय सूत्र [ML⁻¹T⁻²]"}$j$),
 ('govt_technical','mat-example','example',3,'Numerical (JE style)',
  $j${"question":"एक तार पर 100 N का बल लगता है और उसका अनुप्रस्थ क्षेत्रफल 1 mm² (यानी 1×10⁻⁶ m²) है। प्रतिबल कितना होगा?","solution":"σ = F / A = 100 / (1×10⁻⁶) = 1×10⁸ N/m²","answer":"1×10⁸ N/m² (Pa)"}$j$),
 ('govt_technical','mat-mcq','mcq',4,'JE MCQs',
  $j${"questions":[{"q":"स्टील में कार्बन की मात्रा लगभग कितनी होती है?","options":["0.02% से 2%","10% से 20%","50%","0%"],"answer":0,"explanation":"स्टील लोहे और कार्बन (लगभग 0.02% से 2%) का मिश्रण है।"},{"q":"कठोर पर झटके से जल्दी टूटने वाला पदार्थ कौन सा है?","options":["रबर","कच्चा लोहा (cast iron)","तांबा","एल्युमिनियम"],"answer":1,"explanation":"कच्चा लोहा कठोर है, पर भंगुर (brittle) है, यानी झटके से जल्दी टूटता है।"}]}$j$),
 (null,'mat-diagram','svg',5,'खिंचाव से तार में विकृति',
  $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='40' y='50' width='30' height='20' fill='#60a5fa' rx='3'/><rect x='200' y='50' width='30' height='20' fill='#60a5fa' rx='3'/><line x1='70' y1='60' x2='200' y2='60' stroke='#64748b' stroke-width='3'/><line x1='20' y1='60' x2='40' y2='60' stroke='#14b8a6' stroke-width='3'/><polygon points='40,60 32,55 32,65' fill='#14b8a6'/><line x1='250' y1='60' x2='280' y2='60' stroke='#14b8a6' stroke-width='3'/><polygon points='250,60 258,55 258,65' fill='#14b8a6'/><text x='150' y='100' text-anchor='middle' fill='#64748b' font-size='12'>F खिंचाव → तार लंबा होता है</text></svg>","caption":"बल लगाने पर तार थोड़ा लंबा हो जाता है, इसे विकृति कहते हैं"}$j$),
 ('govt_basic','mat-concept','concept',1,'इंजीनियरिंग मटेरियल',
  $j${"text":"मटेरियल मुख्य रूप से धातु (लोहा, तांबा, एल्युमिनियम) और अधातु होते हैं। स्टील लोहा और कार्बन का मिश्रण है। पीतल तांबा और जस्ता का मिश्रण है।","note":"परीक्षा में स्टील, पीतल और कच्चे लोहे के मुख्य तत्व पूछे जाते हैं।"}$j$),
 ('govt_basic','mat-formula','formula',2,'यंग मापांक',
  $j${"formula":"E = σ / ε","explanation":"E = यंग मापांक, σ = प्रतिबल, ε = विकृति। प्रतिबल = बल / क्षेत्रफल"}$j$),
 ('govt_basic','mat-example','example',3,'उदाहरण',
  $j${"question":"एक तार पर 10 N का बल है और उसका क्षेत्रफल 2 m² है। प्रतिबल कितना है?","solution":"σ = F / A = 10 / 2 = 5 N/m²","answer":"5 N/m²"}$j$),
 ('govt_basic','mat-mcq','mcq',4,'अभ्यास प्रश्न',
  $j${"questions":[{"q":"पीतल (Brass) कौन सी धातुओं का मिश्रण है?","options":["तांबा और जस्ता","लोहा और कार्बन","तांबा और टिन","एल्युमिनियम और तांबा"],"answer":0,"explanation":"पीतल तांबा और जस्ता (Zinc) का मिश्रण है।"},{"q":"स्टील का मुख्य तत्व कौन सा है?","options":["लोहा","सोना","चाँदी","सल्फर"],"answer":0,"explanation":"स्टील का मुख्य तत्व लोहा (Iron) है, जिसमें थोड़ा कार्बन मिला होता है।"}]}$j$)
) as v(level_id, atom_key, atom_type, atom_order, title, body)
on conflict do nothing;
