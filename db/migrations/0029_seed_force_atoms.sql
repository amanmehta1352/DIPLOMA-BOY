-- 0029 Seed: Force chapter notes (topic slug 'phy-force', "Force & Laws of Motion"). Additive. Live: applied 2026-10-30.
-- govt_technical = SSC JE / RRB JE depth; govt_basic = RRB NTPC depth; one shared diagram (level_id null).
-- Re-runnable: unique (chapter_id, atom_key, level) + on conflict do nothing.

with ch as (select id from mtb.topics where slug = 'phy-force' limit 1)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang)
select ch.id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb, 'hi' from ch, (values
 ('govt_technical','phy-force-concept','concept',1,'बल (Force) — SSC JE / RRB JE',
  $j${"text":"बल: सदिश राशि। SI मात्रक Newton (N)। विमीय सूत्र [MLT⁻²]। 1 N = 10⁵ dyne। 1 kgf = 9.8 N।","note":"JE परीक्षा में dimensional formula और unit conversion ज़रूर पूछा जाता है।"}$j$),
 ('govt_technical','phy-force-formula','formula',2,'सूत्र + Units',
  $j${"formula":"F = m \\times a \\quad [MLT^{-2}]","explanation":"1 N = 10⁵ dyne · 1 kgf = 9.8 N · 1 N ≈ 0.102 kgf"}$j$),
 ('govt_technical','phy-force-example','example',3,'Numerical (JE style)',
  $j${"question":"10 kg द्रव्यमान पर 50 N बल लगाया जाता है। त्वरण क्या होगा?","solution":"a = F/m = 50/10 = 5 m/s²","answer":"5 m/s²"}$j$),
 ('govt_technical','phy-force-mcq','mcq',4,'JE MCQs',
  $j${"questions":[{"q":"बल का विमीय सूत्र क्या है?","options":["[MLT⁻¹]","[MLT⁻²]","[ML²T⁻²]","[ML⁻¹T⁻²]"],"answer":1,"explanation":"F = ma ⇒ [M][LT⁻²] = [MLT⁻²]"},{"q":"1 kgf कितने N के बराबर है?","options":["9.8 N","10 N","1 N","98 N"],"answer":0,"explanation":"1 kgf = 1 kg × 9.8 m/s² = 9.8 N"},{"q":"1 N = ? dyne","options":["10³","10⁵","10⁷","10"],"answer":1,"explanation":"1 N = 1 kg·m/s² = 1000 g × 100 cm/s² = 10⁵ dyne"}]}$j$),
 (null,'phy-force-diagram','svg',5,'बल और त्वरण',
  $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='40' y='50' width='60' height='40' fill='#60a5fa' rx='6'/><text x='70' y='75' text-anchor='middle' fill='#0f172a' font-size='14' font-weight='bold'>m</text><line x1='100' y1='70' x2='180' y2='70' stroke='#14b8a6' stroke-width='3'/><polygon points='180,70 170,65 170,75' fill='#14b8a6'/><text x='140' y='62' text-anchor='middle' fill='#14b8a6' font-size='13' font-weight='bold'>F</text><line x1='190' y1='70' x2='260' y2='70' stroke='#f59e0b' stroke-width='3' stroke-dasharray='5,3'/><polygon points='260,70 250,65 250,75' fill='#f59e0b'/><text x='225' y='62' text-anchor='middle' fill='#f59e0b' font-size='13' font-weight='bold'>a</text><text x='150' y='108' text-anchor='middle' fill='#64748b' font-size='12'>F = ma</text></svg>","caption":"बल लगाने से वस्तु में त्वरण उत्पन्न होता है"}$j$),
 ('govt_basic','phy-force-concept','concept',1,'बल क्या है?',
  $j${"text":"बल वह बाहरी कारण है जो किसी वस्तु की गति, दिशा या आकार बदलने की कोशिश करता है। बल एक सदिश राशि है — इसका परिमाण और दिशा दोनों होते हैं।","note":"SI मात्रक: Newton (N) · 1 N = 1 kg·m/s²"}$j$),
 ('govt_basic','phy-force-formula','formula',2,'बल का सूत्र',
  $j${"formula":"F = m \\times a","explanation":"जहाँ F = बल (N), m = द्रव्यमान (kg), a = त्वरण (m/s²)"}$j$),
 ('govt_basic','phy-force-example','example',3,'उदाहरण',
  $j${"question":"5 kg द्रव्यमान की वस्तु पर 20 N बल लगता है। त्वरण कितना होगा?","solution":"F = ma ⇒ a = F/m = 20/5 = 4 m/s²","answer":"4 m/s²"}$j$),
 ('govt_basic','phy-force-mcq','mcq',4,'अभ्यास प्रश्न',
  $j${"questions":[{"q":"बल का SI मात्रक क्या है?","options":["Joule","Newton","Watt","Pascal"],"answer":1,"explanation":"बल का SI मात्रक Newton (N) है।"},{"q":"1 Newton = ?","options":["1 kg·m/s","1 kg·m/s²","1 kg·m²/s","1 kg/s²"],"answer":1,"explanation":"1 N = 1 kg·m/s²"}]}$j$)
) as v(level_id, atom_key, atom_type, atom_order, title, body)
on conflict do nothing;
