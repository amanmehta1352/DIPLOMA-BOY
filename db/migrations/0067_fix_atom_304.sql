-- Fix atom 304: LPG/natural gas confusion
-- Question was ambiguous (asked both LPG AND natural gas, answer= methane)
-- Fix: restrict question to natural gas only

update mtb.atoms
set body = jsonb_build_object(
    'question', 'प्राकृतिक गैस का मुख्य घटक कौन सा है?',
    'solution', 'प्राकृतिक गैस का मुख्य घटक मेथेन (CH₄) है',
    'answer',   'मेथेन (CH₄)'
  ),
  content_hash = md5((jsonb_build_object(
    'question', 'प्राकृतिक गैस का मुख्य घटक कौन सा है?',
    'solution', 'प्राकृतिक गैस का मुख्य घटक मेथेन (CH₄) है',
    'answer',   'मेथेन (CH₄)'
  ))::text),
  updated_at = now()
where id = 304 and atom_key = 'carb-example';

-- VERIFY:
-- select id, body, content_hash from mtb.atoms where id = 304;
-- Expected: question mentions ONLY natural gas, content_hash updated
