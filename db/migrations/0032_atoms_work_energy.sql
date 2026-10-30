-- 0032 Chapter notes: Work, Energy & Power (topic 873 'phy-work-energy', General Science). Additive. Same body shape as Force (0029).
-- govt_technical = SSC JE / RRB JE depth; govt_basic = RRB NTPC depth; one shared diagram (level_id null).

with ch as (select id from mtb.topics where slug = 'phy-work-energy' limit 1)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang)
select ch.id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb, 'hi' from ch, (values
 ('govt_technical','phy-work-concept','concept',1,'कार्य, ऊर्जा और शक्ति — SSC JE / RRB JE',
  $j${"text":"कार्य (W) तब होता है जब बल वस्तु को उसकी दिशा में विस्थापित करे। ऊर्जा वह क्षमता है जिससे कार्य हो सके। शक्ति (P) = कार्य / समय। मात्रक: कार्य और ऊर्जा का J (joule), शक्ति का W (watt)।","note":"JE में ऊर्जा और कार्य का विमीय सूत्र [ML²T⁻²] और 1 kW = 1000 W अक्सर पूछे जाते हैं।"}$j$),
 ('govt_technical','phy-work-formula','formula',2,'कार्य का सूत्र',
  $j${"formula":"W = F \\times s \\times \\cos\\theta","explanation":"F = बल (N), s = विस्थापन (m), θ = बल और विस्थापन के बीच कोण · मात्रक J, विमीय सूत्र [ML²T⁻²] · P = W / t, मात्रक W"}$j$),
 ('govt_technical','phy-work-example','example',3,'Numerical (JE style)',
  $j${"question":"2 kg की वस्तु 3 m/s से चल रही है। उसकी गतिज ऊर्जा (KE = ½mv²) कितनी है?","solution":"KE = ½ × 2 × 3² = 9 J","answer":"9 J"}$j$),
 ('govt_technical','phy-work-mcq','mcq',4,'JE MCQs',
  $j${"questions":[{"q":"ऊर्जा का विमीय सूत्र क्या है?","options":["[ML²T⁻²]","[MLT⁻²]","[ML²T⁻³]","[MLT⁻¹]"],"answer":0,"explanation":"ऊर्जा = बल × दूरी = [MLT⁻²][L] = [ML²T⁻²]"},{"q":"1 kW कितने W के बराबर है?","options":["10","100","1000","10000"],"answer":2,"explanation":"1 kilowatt = 1000 watt"}]}$j$),
 (null,'phy-work-diagram','svg',5,'बल से कार्य',
  $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='60' y='50' width='60' height='40' fill='#60a5fa' rx='6'/><line x1='20' y1='70' x2='55' y2='70' stroke='#14b8a6' stroke-width='3'/><polygon points='55,70 46,65 46,75' fill='#14b8a6'/><text x='35' y='62' text-anchor='middle' fill='#14b8a6' font-size='12' font-weight='bold'>F</text><line x1='130' y1='100' x2='240' y2='100' stroke='#f59e0b' stroke-width='3' stroke-dasharray='5,3'/><polygon points='240,100 230,95 230,105' fill='#f59e0b'/><text x='185' y='92' text-anchor='middle' fill='#f59e0b' font-size='12' font-weight='bold'>s</text><text x='150' y='118' text-anchor='middle' fill='#64748b' font-size='12'>W = F × s</text></svg>","caption":"बल की दिशा में विस्थापन हो तो कार्य होता है"}$j$),
 ('govt_basic','phy-work-concept','concept',1,'कार्य, ऊर्जा और शक्ति',
  $j${"text":"जब बल लगाने से वस्तु उसी दिशा में चलती है, तो कार्य होता है। ऊर्जा काम करने की क्षमता है। शक्ति बताती है कि कार्य कितनी जल्दी हुआ। कार्य का मात्रक J (joule), शक्ति का W (watt)।","note":"परीक्षा में कार्य का SI मात्रक और शक्ति का मात्रक सबसे ज़्यादा पूछे जाते हैं।"}$j$),
 ('govt_basic','phy-work-formula','formula',2,'कार्य का सूत्र',
  $j${"formula":"W = F \\times s","explanation":"जहाँ W = कार्य (J), F = बल (N), s = दूरी (m), जब बल और दूरी एक ही दिशा में हों"}$j$),
 ('govt_basic','phy-work-example','example',3,'उदाहरण',
  $j${"question":"10 N का बल लगाकर वस्तु को 5 m सरकाया जाता है। किया गया कार्य कितना है?","solution":"W = F × s = 10 × 5 = 50 J","answer":"50 J"}$j$),
 ('govt_basic','phy-work-mcq','mcq',4,'अभ्यास प्रश्न',
  $j${"questions":[{"q":"कार्य का SI मात्रक क्या है?","options":["Joule","Newton","Watt","Pascal"],"answer":0,"explanation":"कार्य का SI मात्रक Joule (J) है।"},{"q":"शक्ति (Power) का SI मात्रक क्या है?","options":["Joule","Watt","Newton","Pascal"],"answer":1,"explanation":"शक्ति का SI मात्रक Watt (W) है।"}]}$j$)
) as v(level_id, atom_key, atom_type, atom_order, title, body)
on conflict do nothing;
