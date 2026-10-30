-- 0054: banking seed — anchor topic 1 (Percentage). 5 level-specific atoms, no exam tags (ibps/sbi not in mtb.exams yet).

with src as (
  select v.chapter_id, v.level_id, v.atom_key, v.atom_type, v.atom_order, v.title, v.body::jsonb as body
  from (values
  (1,'banking','bank-pct-concept','concept',1,'प्रतिशत — बैंकिंग',$j${"note":"IBPS और SBI में प्रतिशत परिवर्तन और छूट के प्रश्न सबसे अधिक आते हैं।","text":"प्रतिशत का अर्थ है 100 में से कितने भाग। किसी संख्या का x% = संख्या × x/100। प्रतिशत वृद्धि या कमी को मूल मान के सापेक्ष मापा जाता है।"}$j$),
  (1,'banking','bank-pct-formula','formula',2,'प्रतिशत परिवर्तन',$j${"formula":"प्रतिशत परिवर्तन = (नया − पुराना) / पुराना × 100","explanation":"वृद्धि में धनात्मक और कमी में ऋणात्मक मान आता है"}$j$),
  (1,'banking','bank-pct-example','example',3,'Numerical (Banking style)',$j${"question":"एक वस्तु का मूल्य ₹800 से बढ़कर ₹1000 हो गया। प्रतिशत वृद्धि कितनी है?","solution":"(1000 − 800) / 800 × 100 = 25%","answer":"25%"}$j$),
  (1,'banking','bank-pct-mcq','mcq',4,'अभ्यास प्रश्न',$j${"questions":[{"q":"किसी संख्या का 20% ज्ञात करें, यदि संख्या 450 है।","options":["90","45","180","225"],"answer":0,"explanation":"450 × 20/100 = 90।"},{"q":"यदि मूल्य 200 से घटकर 150 हो जाए, तो प्रतिशत कमी क्या होगी?","options":["25%","50%","20%","30%"],"answer":0,"explanation":"(200 − 150)/200 × 100 = 25%।"}]}$j$),
  (1,'banking','bank-pct-diagram','svg',5,'प्रतिशत बार चार्ट',$j${"svg":"<svg viewBox='0 0 300 120' xmlns='http://www.w3.org/2000/svg'><rect x='30' y='70' width='40' height='40' fill='#60a5fa'/><rect x='100' y='40' width='40' height='70' fill='#34d399'/><rect x='170' y='20' width='40' height='90' fill='#f59e0b'/><text x='150' y='118' text-anchor='middle' font-size='11' fill='#64748b'>तुलना के लिए बार चार्ट</text></svg>","caption":"बार चार्ट से विभिन्न वर्षों के प्रतिशत की तुलना"}$j$)
  ) as v(chapter_id, level_id, atom_key, atom_type, atom_order, title, body)
)
insert into mtb.atoms (chapter_id, level_id, atom_key, atom_type, atom_order, title, body, lang, exam_tags, class_tags, subject_tag, difficulty, content_hash)
select s.chapter_id, s.level_id, s.atom_key, s.atom_type, s.atom_order, s.title, s.body, 'hi', '{}'::text[], '{}'::text[],
  'maths', 'medium', md5(s.body::text)
from src s
on conflict do nothing;
