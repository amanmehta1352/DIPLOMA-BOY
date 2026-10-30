-- 0034 Chapter notes: Engineering Mechanics (topic 433 'engineering-mechanics', Mechanical Engineering). Additive. Same body shape as Force (0029).
-- govt_technical = SSC JE / RRB JE depth; govt_basic = RRB NTPC depth; one shared diagram (level_id null).

with ch as (select id from mtb.topics where slug = 'engineering-mechanics' limit 1)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang)
select ch.id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb, 'hi' from ch, (values
 ('govt_technical','em-concept','concept',1,'बल का परिणामी और संतुलन — SSC JE / RRB JE',
  $j${"text":"बल एक सदिश राशि है, जिसका मान और दिशा दोनों होते हैं। कई बल मिलकर जो एक बल देते हैं उसे परिणामी (resultant) कहते हैं। वस्तु संतुलन में तब होती है जब सभी बलों का योग शून्य हो (ΣF = 0) और किसी बिंदु के सापेक्ष बलों-आघूर्णों का योग भी शून्य हो (ΣM = 0)।","note":"JE में संतुलन की दोनों शर्तें (ΣF = 0 और ΣM = 0) और दो बलों के बीच कोण से परिणामी निकालना अक्सर पूछा जाता है।"}$j$),
 ('govt_technical','em-formula','formula',2,'दो बलों का परिणामी',
  $j${"formula":"R = √(P² + Q² + 2PQ cosθ)","explanation":"P, Q = दो बल (N), θ = दोनों बलों के बीच कोण · θ = 90° पर R = √(P² + Q²) · R = परिणामी बल (N)"}$j$),
 ('govt_technical','em-example','example',3,'Numerical (JE style)',
  $j${"question":"दो बल 3 N और 4 N एक-दूसरे पर 90° के कोण पर लगते हैं। परिणामी बल कितना है?","solution":"R = √(3² + 4²) = √(9 + 16) = √25 = 5 N","answer":"5 N"}$j$),
 ('govt_technical','em-mcq','mcq',4,'JE MCQs',
  $j${"questions":[{"q":"दो बल 3 N और 4 N 90° पर लगें, तो परिणामी बल कितना होगा?","options":["7 N","1 N","5 N","12 N"],"answer":2,"explanation":"R = √(3² + 4²) = 5 N"},{"q":"किसी वस्तु के संतुलन की शर्त क्या है?","options":["ΣF = 0 और ΣM = 0","केवल ΣM = 0","F = mg","F = ma"],"answer":0,"explanation":"संतुलन के लिए बलों का योग और आघूर्णों का योग दोनों शून्य होने चाहिए।"}]}$j$),
 (null,'em-diagram','svg',5,'दो बलों का परिणामी',
  $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><circle cx='150' cy='65' r='6' fill='#0f172a'/><line x1='150' y1='65' x2='70' y2='65' stroke='#14b8a6' stroke-width='3'/><polygon points='70,65 80,60 80,70' fill='#14b8a6'/><text x='100' y='57' text-anchor='middle' fill='#14b8a6' font-size='12' font-weight='bold'>P</text><line x1='150' y1='65' x2='150' y2='15' stroke='#f59e0b' stroke-width='3'/><polygon points='150,15 145,25 155,25' fill='#f59e0b'/><text x='168' y='40' fill='#f59e0b' font-size='12' font-weight='bold'>Q</text><line x1='150' y1='65' x2='230' y2='15' stroke='#60a5fa' stroke-width='3' stroke-dasharray='5,3'/><polygon points='230,15 221,19 225,27' fill='#60a5fa'/><text x='205' y='32' fill='#60a5fa' font-size='12' font-weight='bold'>R</text><text x='150' y='110' text-anchor='middle' fill='#64748b' font-size='12'>R = परिणामी बल</text></svg>","caption":"दो बलों का परिणामी उनके सदिश योग से मिलता है"}$j$),
 ('govt_basic','em-concept','concept',1,'बल और संतुलन',
  $j${"text":"बल की दिशा भी होती है, इसलिए वह सदिश है। दो बल एक ही दिशा में हों तो उनका परिणामी उनका जोड़ होता है। वस्तु संतुलन में तब रहती है जब सारे बलों का योग शून्य हो।","note":"परीक्षा में बराबर और विपरीत बलों का परिणामी शून्य होता है, यह सबसे ज़्यादा पूछा जाता है।"}$j$),
 ('govt_basic','em-formula','formula',2,'90° पर दो बलों का परिणामी',
  $j${"formula":"R = √(P² + Q²)","explanation":"P, Q = दो बल (N), R = परिणामी बल (N), जब दोनों बल एक-दूसरे पर 90° पर हों"}$j$),
 ('govt_basic','em-example','example',3,'उदाहरण',
  $j${"question":"2 N और 2 N के दो बल एक ही दिशा में लगते हैं। परिणामी बल कितना है?","solution":"R = 2 + 2 = 4 N (एक ही दिशा में बल जुड़ते हैं)","answer":"4 N"}$j$),
 ('govt_basic','em-mcq','mcq',4,'अभ्यास प्रश्न',
  $j${"questions":[{"q":"दो बराबर और विपरीत दिशा के बल लगें, तो परिणामी बल कितना होगा?","options":["0","2P","P²","P/2"],"answer":0,"explanation":"बराबर और विपरीत बल एक-दूसरे को काट देते हैं, परिणामी शून्य होता है।"},{"q":"इनमें से कौन सी सदिश राशि है?","options":["चाल","द्रव्यमान","बल","दूरी"],"answer":2,"explanation":"बल की दिशा और मान दोनों होते हैं, इसलिए वह सदिश है।"}]}$j$)
) as v(level_id, atom_key, atom_type, atom_order, title, body)
on conflict do nothing;
