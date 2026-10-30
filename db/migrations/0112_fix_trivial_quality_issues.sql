-- Migration 0112: fix 5 trivial quality issues from the 20-atom audit.
--  1641: "Cal" -> "kcal" (unit)
--   648: explanation rewritten for alligation (was replacement text)
--  2283: "left turn (anti)" -> "left turn (anti-clockwise)"
--   718: SVG label "A" moved from x=75 to x=50 (onto the vertex side)
--  1946: Q1 wording clarified (age question)
update mtb.atoms a
set body = v.b::jsonb,
    content_hash = md5((v.b::jsonb)::text),
    updated_at = now()
from (values
  (1641, $j${"answer":"900 kcal","question":"Fat 100g से kcal?","solution":"100 × 9"}$j$),
  (648,  $j${"formula":"Quantity cheap : Quantity dear = (dear − mean) : (mean − cheap)","explanation":"Alligation: दो चीज़ों को मिलाकर बीच का mean (औसत) पाने का अनुपात। cheap : dear = (dear − mean) : (mean − cheap)। उदाहरण: ₹20 और ₹40 वाली चीज़ों से mean ₹30 चाहिए → (40−30):(30−20) = 10:10 = 1:1"}$j$),
  (2283, $j${"note":"Defence में bearings और map navigation ज़रूरी हैं।","text":"Defence directions: map navigation, bearings (from North clockwise), compass reading, patrol routes. Right turn (clockwise), left turn (anti-clockwise). Distance with bearing: use Pythagoras।"}$j$),
  (718,  $j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><polygon points='50,90 150,90 100,40' fill='#60a5fa' opacity='0.6'/><text x='50' y='85' fill='#0f172a' font-size='11' font-weight='bold'>A</text><text x='150' y='85' fill='#0f172a' font-size='11' font-weight='bold'>B</text><text x='100' y='35' fill='#0f172a' font-size='11' font-weight='bold'>C</text><text x='220' y='65' fill='#f59e0b' font-size='12'>∠A+∠B+∠C = 180°</text></svg>","caption":"त्रिभुज के तीनों कोणों का योग 180°"}$j$),
  (1946, $j${"questions":[{"q":"A की उम्र 40 साल और B की 20 साल है। कितने साल पहले A की उम्र B की उम्र की ठीक 3 गुना थी?","answer":1,"options":["5y ago","10y ago","15y ago","20y ago"],"solution":"40+n = 3(20+n) → 40+n=60+3n → -20=2n → negative. So past: 40-n=3(20-n) → 40-n=60-3n → 2n=20 → n=10","explanation":"10 years ago: A=30, B=10 (30=3×10)"},{"q":"A 32, B 8। जब A = 3B?","answer":1,"options":["2y","4y","6y","8y"],"solution":"32+n = 3(8+n) → 32+n=24+3n → 8=2n → n=4","explanation":"After 4 years: A=36, B=12 (36=3×12)"}]}$j$)
) as v(id, b)
where a.id = v.id;
