-- 0051: class_11_12_sci seed — anchor topic 886 (Atomic Structure). 5 level-specific atoms, no exam tags.

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (886,'class_11_12_sci','c1112s-atom-concept','concept',1,'परमाणु संरचना — कक्षा 11-12',$j${"note":"बोर्ड परीक्षा में क्वांटम संख्याएँ और इलेक्ट्रॉनिक विन्यास अक्सर पूछे जाते हैं।","text":"परमाणु में नाभिक (प्रोटॉन और न्यूट्रॉन) और उसके चारों ओर इलेक्ट्रॉन होते हैं। परमाणु क्रमांक Z प्रोटॉन की संख्या है और द्रव्यमान संख्या A = प्रोटॉन + न्यूट्रॉन। बोर की व्याख्या में इलेक्ट्रॉन निश्चित कक्षों में घूमते हैं और ऊर्जा का अवशोषण या उत्सर्जन करते हैं।"}$j$),
  (886,'class_11_12_sci','c1112s-atom-formula','formula',2,'ऊर्जा और तरंगदैर्ध्य',$j${"formula":"Eₙ = −13.6 Z²/n² eV (हाइड्रोजन जैसे परमाणु)","explanation":"n मुख्य क्वांटम संख्या है; Z परमाणु क्रमांक"}$j$),
  (886,'class_11_12_sci','c1112s-atom-example','example',3,'Numerical',$j${"question":"हाइड्रोजन परमाणु की n = 1 अवस्था की ऊर्जा क्या है?","solution":"E₁ = −13.6 × 1² / 1² = −13.6 eV","answer":"−13.6 eV"}$j$),
  (886,'class_11_12_sci','c1112s-atom-mcq','mcq',4,'अभ्यास प्रश्न',$j${"questions":[{"q":"परमाणु का द्रव्यमान लगभग किसमें केंद्रित होता है?","options":["नाभिक","इलेक्ट्रॉन कक्षा","पूरे परमाणु में समान","इलेक्ट्रॉन बादल"],"answer":0,"explanation":"परमाणु का लगभग सारा द्रव्यमान नाभिक में होता है।"},{"q":"इलेक्ट्रॉनिक विन्यास में 'Aufbau' नियम किसके लिए है?","options":["कम ऊर्जा वाले कक्ष पहले भरे जाते हैं","अधिक ऊर्जा पहले","सभी कक्ष एक साथ","इनमें से कोई नहीं"],"answer":0,"explanation":"Aufbau सिद्धांत के अनुसार इलेक्ट्रॉन पहले निम्न ऊर्जा कक्ष में जाते हैं।"}]}$j$),
  (886,'class_11_12_sci','c1112s-atom-diagram','svg',5,'परमाणु मॉडल',$j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><circle cx='150' cy='60' r='12' fill='#f87171'/><circle cx='150' cy='60' r='45' fill='none' stroke='#64748b' stroke-dasharray='4 3'/><circle cx='150' cy='15' r='5' fill='#60a5fa'/><text x='150' y='115' text-anchor='middle' font-size='11' fill='#64748b'>नाभिक और इलेक्ट्रॉन कक्ष</text></svg>","caption":"बोर मॉडल: नाभिक के चारों ओर निश्चित कक्षों में इलेक्ट्रॉन"}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'general-science', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
