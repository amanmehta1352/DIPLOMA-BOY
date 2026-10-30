-- Migration 0111: fix conceptual error in atom 2053 (acid-def-example, chlorine neutralization)
-- Old: answer "Alkaline solution (soda lime)" mixed a solid absorbent with a reducing agent.
-- New: clearly separates solid absorbent (soda lime) and liquid neutralizer (sodium thiosulfate).
update mtb.atoms a
set body = v.b::jsonb,
    content_hash = md5((v.b::jsonb)::text),
    updated_at = now()
from (values
  (2053, $j${"question":"Chlorine gas को neutralize करने के लिए क्या use होता है?","solution":"दो तरीके: (1) Soda lime (CaO+NaOH) — gas mask में solid absorbent, (2) Sodium thiosulfate (Na₂S₂O₃) solution — liquid neutralizer","answer":"Soda lime (solid) या Na₂S₂O₃ solution (liquid)"}$j$)
) as v(id, b)
where a.id = v.id;
