-- 0035 Chapter notes: Fluid Mechanics & Machinery (topic 434 'fluid-mechanics-machinery', Mechanical Engineering). Additive. Same body shape as Force (0029).
-- govt_technical = SSC JE / RRB JE depth; govt_basic = RRB NTPC depth; one shared diagram (level_id null).

with ch as (select id from mtb.topics where slug = 'fluid-mechanics-machinery' limit 1)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang)
select ch.id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb, 'hi' from ch, (values
 ('govt_technical','fm-concept','concept',1,'द्रव दाब और पास्कल का नियम — SSC JE / RRB JE',
  $j${"text":"किसी द्रव में गहराई बढ़ने पर दाब बढ़ता है। दाब p = ρgh, जहाँ ρ द्रव का घनत्व है। बंद द्रव में लगाया गया दाब हर दिशा में बराबर फैलता है (पास्कल का नियम), और इसी पर हाइड्रॉलिक लिफ्ट और ब्रेक काम करते हैं।","note":"JE में पानी का घनत्व 1000 kg/m³ और दाब की इकाई Pa (N/m²) अक्सर पूछी जाती है।"}$j$),
 ('govt_technical','fm-formula','formula',2,'द्रव दाब का सूत्र',
  $j${"formula":"p = ρ × g × h","explanation":"p = दाब (Pa = N/m²), ρ = द्रव का घनत्व (kg/m³), g = गुरुत्वीय त्वरण (9.8 m/s²), h = गहराई (m) · दाब का विमीय सूत्र [ML⁻¹T⁻²]"}$j$),
 ('govt_technical','fm-example','example',3,'Numerical (JE style)',
  $j${"question":"पानी (ρ = 1000 kg/m³) में 2 m गहराई पर दाब कितना होगा? (g = 10 m/s² लें)","solution":"p = ρ × g × h = 1000 × 10 × 2 = 20000 Pa","answer":"20000 Pa (2×10⁴ Pa)"}$j$),
 ('govt_technical','fm-mcq','mcq',4,'JE MCQs',
  $j${"questions":[{"q":"दाब का SI मात्रक क्या है?","options":["Pascal (N/m²)","Newton","Joule","Watt"],"answer":0,"explanation":"दाब का SI मात्रक Pascal (Pa) यानी N/m² है।"},{"q":"पास्कल का नियम किससे संबंधित है?","options":["बंद द्रव में दाब सब दिशाओं में बराबर फैलता है","गुरुत्व बल","ऊष्मा का संचरण","प्रकाश का परावर्तन"],"answer":0,"explanation":"बंद द्रव में लगाया गया दाब हर दिशा में बराबर संचरित होता है।"}]}$j$),
 (null,'fm-diagram','svg',5,'गहराई के साथ दाब',
  $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='80' y='15' width='140' height='95' fill='#60a5fa' fill-opacity='0.25' stroke='#60a5fa' stroke-width='2'/><line x1='90' y1='40' x2='130' y2='40' stroke='#14b8a6' stroke-width='2'/><polygon points='130,40 122,36 122,44' fill='#14b8a6'/><line x1='90' y1='70' x2='150' y2='70' stroke='#14b8a6' stroke-width='3'/><polygon points='150,70 142,66 142,74' fill='#14b8a6'/><line x1='90' y1='100' x2='170' y2='100' stroke='#14b8a6' stroke-width='4'/><polygon points='170,100 162,96 162,104' fill='#14b8a6'/><text x='240' y='70' fill='#64748b' font-size='12'>गहराई ↑</text><text x='240' y='85' fill='#64748b' font-size='12'>दाब ↑</text></svg>","caption":"गहराई बढ़ने पर दाब बढ़ता है"}$j$),
 ('govt_basic','fm-concept','concept',1,'द्रव का दाब',
  $j${"text":"द्रव में गहराई बढ़ने पर दाब बढ़ता है। बंद द्रव में दाब हर दिशा में बराबर फैलता है (पास्कल का नियम)। दाब का मात्रक Pascal (N/m²) है।","note":"परीक्षा में दाब का SI मात्रक और पास्कल का नियम सबसे ज़्यादा पूछे जाते हैं।"}$j$),
 ('govt_basic','fm-formula','formula',2,'दाब का सूत्र',
  $j${"formula":"p = ρ × g × h","explanation":"p = दाब, ρ = घनत्व (kg/m³), g = गुरुत्वीय त्वरण, h = गहराई (m)"}$j$),
 ('govt_basic','fm-example','example',3,'उदाहरण',
  $j${"question":"पानी (ρ = 1000 kg/m³) में 1 m गहराई पर दाब कितना है? (g = 10 m/s² लें)","solution":"p = 1000 × 10 × 1 = 10000 Pa","answer":"10000 Pa"}$j$),
 ('govt_basic','fm-mcq','mcq',4,'अभ्यास प्रश्न',
  $j${"questions":[{"q":"दाब का SI मात्रक क्या है?","options":["Pascal","Newton","Joule","Watt"],"answer":0,"explanation":"दाब का SI मात्रक Pascal (Pa) है।"},{"q":"किसी वस्तु पर द्रव द्वारा लगने वाले ऊपर की ओर बल को क्या कहते हैं?","options":["उछाल बल (buoyancy)","विद्युत बल","ध्वनि बल","चुंबकीय बल"],"answer":0,"explanation":"द्रव में डूबी वस्तु पर ऊपर की ओर लगने वाले बल को उछाल बल (buoyant force) कहते हैं।"}]}$j$)
) as v(level_id, atom_key, atom_type, atom_order, title, body)
on conflict do nothing;
