-- 0031 Chapter notes: Motion (topic 871 'phy-motion', General Science). Additive. Same body shape as Force (0029).
-- govt_technical = SSC JE / RRB JE depth; govt_basic = RRB NTPC depth; one shared diagram (level_id null).

with ch as (select id from mtb.topics where slug = 'phy-motion' limit 1)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang)
select ch.id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb, 'hi' from ch, (values
 ('govt_technical','phy-motion-concept','concept',1,'गति, चाल और वेग — SSC JE / RRB JE',
  $j${"text":"वस्तु की स्थिति समय के साथ बदले तो वह गति में है। चाल (speed) = दूरी / समय, सिर्फ मान (scalar)। वेग (velocity) = विस्थापन / समय, मान और दिशा दोनों (vector)। SI मात्रक m/s। त्वरण = वेग में बदलाव / समय, मात्रक m/s²।","note":"JE में चाल बनाम वेग का फर्क और वेग का विमीय सूत्र [LT⁻¹] अक्सर पूछा जाता है।"}$j$),
 ('govt_technical','phy-motion-formula','formula',2,'गति का पहला समीकरण',
  $j${"formula":"v = u + a \\times t","explanation":"u = प्रारंभिक वेग (m/s), v = अंतिम वेग (m/s), a = त्वरण (m/s²), t = समय (s) · वेग का विमीय सूत्र [LT⁻¹]"}$j$),
 ('govt_technical','phy-motion-example','example',3,'Numerical (JE style)',
  $j${"question":"एक गाड़ी 10 m/s से चल रही है और 5 s में 20 m/s हो जाती है। उसका त्वरण क्या है?","solution":"a = (v − u)/t = (20 − 10)/5 = 2 m/s²","answer":"2 m/s²"}$j$),
 ('govt_technical','phy-motion-mcq','mcq',4,'JE MCQs',
  $j${"questions":[{"q":"वेग का विमीय सूत्र क्या है?","options":["[LT⁻¹]","[LT⁻²]","[LT]","[MLT⁻¹]"],"answer":0,"explanation":"वेग = दूरी / समय = [L] / [T] = [LT⁻¹]"},{"q":"स्थिर वेग से चलती वस्तु का त्वरण कितना होता है?","options":["0","1 m/s²","9.8 m/s²","वेग के बराबर"],"answer":0,"explanation":"वेग नहीं बदलता, इसलिए त्वरण शून्य है।"}]}$j$),
 (null,'phy-motion-diagram','svg',5,'वेग और त्वरण की दिशा',
  $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='40' y='50' width='70' height='36' fill='#60a5fa' rx='8'/><circle cx='65' cy='90' r='8' fill='#0f172a'/><circle cx='95' cy='90' r='8' fill='#0f172a'/><line x1='120' y1='68' x2='200' y2='68' stroke='#14b8a6' stroke-width='3'/><polygon points='200,68 190,63 190,73' fill='#14b8a6'/><text x='160' y='58' text-anchor='middle' fill='#14b8a6' font-size='13' font-weight='bold'>v</text><text x='150' y='112' text-anchor='middle' fill='#64748b' font-size='12'>वेग = दूरी / समय</text></svg>","caption":"वेग की दिशा वस्तु की गति की दिशा में होती है"}$j$),
 ('govt_basic','phy-motion-concept','concept',1,'गति, चाल और वेग',
  $j${"text":"वस्तु की जगह समय के साथ बदले तो वह गति में है। चाल वह है जितनी तेज़ वस्तु चल रही है (सिर्फ मान)। वेग में मान के साथ दिशा भी होती है। यूनिट m/s।","note":"परीक्षा में चाल और वेग का फर्क सबसे ज़्यादा पूछा जाता है।"}$j$),
 ('govt_basic','phy-motion-formula','formula',2,'गति का पहला समीकरण',
  $j${"formula":"v = u + a \\times t","explanation":"u = शुरुआती वेग, v = अंतिम वेग, a = त्वरण, t = समय"}$j$),
 ('govt_basic','phy-motion-example','example',3,'उदाहरण',
  $j${"question":"एक गाड़ी रुकी हुई है (u = 0) और 4 s में 8 m/s पर पहुँचती है। त्वरण कितना है?","solution":"a = (v − u)/t = (8 − 0)/4 = 2 m/s²","answer":"2 m/s²"}$j$),
 ('govt_basic','phy-motion-mcq','mcq',4,'अभ्यास प्रश्न',
  $j${"questions":[{"q":"वेग का SI मात्रक क्या है?","options":["m/s","m/s²","m","kg"],"answer":0,"explanation":"वेग का SI मात्रक m/s है।"},{"q":"जिस राशि में मान और दिशा दोनों हों, वह क्या है?","options":["चाल","वेग","दूरी","द्रव्यमान"],"answer":1,"explanation":"वेग एक सदिश राशि है, यानी मान और दिशा दोनों।"}]}$j$)
) as v(level_id, atom_key, atom_type, atom_order, title, body)
on conflict do nothing;
