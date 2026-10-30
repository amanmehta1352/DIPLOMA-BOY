-- 0037 Content fill, batch 1 of Phase 2 (Mechanical Engineering): ic-engines, production-engineering,
-- refrigeration-air-conditioning, steam-boilers-turbines-power-plants, strength-of-materials.
-- Same body shape as Force (0029). Per chapter: 4 govt_technical + 4 govt_basic + 1 shared diagram (level_id null).
-- Chapters are looked up by topic slug, never by hard-coded id. Additive: on conflict do nothing.

insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang)
select t.id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb, 'hi'
from (values
 ('ic-engines','govt_technical','ice-concept','concept',1,'IC इंजन — SSC JE / RRB JE',
  $j${"text":"पेट्रोल इंजन Otto चक्र और डीज़ल इंजन Diesel चक्र पर चलता है। 4-स्ट्रोक इंजन में हर दो घूर्णन पर एक power stroke होता है, 2-स्ट्रोक में हर घूर्णन पर।","note":"पेट्रोल में spark plug से ईंधन जलता है, डीज़ल में संपीड़न से गर्म हुई हवा से (compression ignition)।"}$j$),
 ('ic-engines','govt_technical','ice-formula','formula',2,'Otto चक्र की दक्षता',
  $j${"formula":"η = 1 − 1 / r^(γ−1)","explanation":"r = संपीड़न अनुपात, γ = 1.4 (हवा के लिए), η = दक्षता · r बढ़ने पर दक्षता बढ़ती है"}$j$),
 ('ic-engines','govt_technical','ice-example','example',3,'Numerical (JE style)',
  $j${"question":"संपीड़न अनुपात 8 और γ = 1.4 वाले Otto चक्र की दक्षता कितनी है?","solution":"η = 1 − 1/8^0.4 = 1 − 1/2.297 ≈ 0.565","answer":"लगभग 56.5%"}$j$),
 ('ic-engines','govt_technical','ice-mcq','mcq',4,'JE MCQs',
  $j${"questions":[{"q":"डीज़ल इंजन में ईंधन कैसे जलता है?","options":["Spark plug से","संपीड़न से गर्म हुई हवा से (compression ignition)","चिंगारी से","उत्प्रेरक से"],"answer":1,"explanation":"डीज़ल इंजन में हवा को इतना संपीड़ित किया जाता है कि ईंधन अपने-आप जल उठता है।"},{"q":"4-स्ट्रोक इंजन में एक power stroke कितने घूर्णन पर होता है?","options":["एक","दो","तीन","चार"],"answer":1,"explanation":"4-स्ट्रोक इंजन में चार स्ट्रोक दो घूर्णन में पूरे होते हैं, जिनमें एक power stroke है।"}]}$j$),
 ('ic-engines',null,'ice-diagram','svg',5,'पिस्टन और सिलेंडर',
  $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='100' y='15' width='100' height='90' fill='none' stroke='#64748b' stroke-width='3'/><rect x='110' y='55' width='80' height='20' fill='#60a5fa'/><line x1='150' y1='75' x2='150' y2='105' stroke='#14b8a6' stroke-width='4'/><text x='150' y='12' text-anchor='middle' fill='#64748b' font-size='11'>सिलेंडर और पिस्टन</text></svg>","caption":"पिस्टन सिलेंडर में ऊपर-नीचे चलकर ईंधन की ऊर्जा को यांत्रिक कार्य में बदलता है"}$j$),
 ('ic-engines','govt_basic','ice-concept','concept',1,'IC इंजन',
  $j${"text":"IC इंजन के अंदर ईंधन जलता है। पेट्रोल इंजन में चिंगारी से और डीज़ल इंजन में संपीड़न से ईंधन जलता है। 2-स्ट्रोक और 4-स्ट्रोक मुख्य प्रकार हैं।","note":"परीक्षा में पेट्रोल बनाम डीज़ल इंजन का फर्क (spark plug बनाम संपीड़न) सबसे ज़्यादा पूछा जाता है।"}$j$),
 ('ic-engines','govt_basic','ice-formula','formula',2,'संपीड़न अनुपात',
  $j${"formula":"r = V₁ / V₂","explanation":"r = संपीड़न अनुपात, V₁ = कुल सिलेंडर आयतन, V₂ = क्लीयरेंस आयतन"}$j$),
 ('ic-engines','govt_basic','ice-example','example',3,'उदाहरण',
  $j${"question":"कुल आयतन 400 cm³ और क्लीयरेंस आयतन 50 cm³ है। संपीड़न अनुपात कितना है?","solution":"r = 400 / 50 = 8","answer":"8"}$j$),
 ('ic-engines','govt_basic','ice-mcq','mcq',4,'अभ्यास प्रश्न',
  $j${"questions":[{"q":"पेट्रोल इंजन में ईंधन जलाने के लिए क्या लगाया जाता है?","options":["Spark plug","Radiator","Piston","Fuel tank"],"answer":0,"explanation":"पेट्रोल इंजन में spark plug से चिंगारी देकर ईंधन जलाया जाता है।"},{"q":"4-स्ट्रोक इंजन में कितने स्ट्रोक होते हैं?","options":["2","3","4","6"],"answer":2,"explanation":"सेवन, संपीड़न, कार्य और निकास, चार स्ट्रोक होते हैं।"}]}$j$)
 -- placeholder removed
) as v(slug, level_id, atom_key, atom_type, atom_order, title, body)
join mtb.topics t on t.slug = v.slug
on conflict do nothing;
