-- 0168 formulas of the approved chapter books, in the same shape as mtb.get_level_formulas (which reads atoms).
-- Additive: one new read function. Used by the Formula tab after student setup.
create or replace function mtb.get_level_book_formulas(p_level text)
 returns jsonb language sql stable security definer set search_path to 'mtb', 'pg_catalog'
as $$
  select coalesce(jsonb_agg(jsonb_build_object('chapter', t.id, 'ch_hi', t.name_hi, 'ch_en', t.name_en, 'subject_hi', s.name_hi, 'subject_en', s.name_en,
           'title', f->>'title', 'formula', f->>'formula',
           'explanation', nullif(concat_ws(' · ', nullif(f->>'units', ''), nullif(nullif(f->>'note', ''), '—')), '—')) order by s.id, t.sort, t.id, ord), '[]'::jsonb)
  from mtb.chapter_drafts d join mtb.topics t on t.id = d.chapter_id join mtb.subjects s on s.id = t.subject_id
  cross join lateral jsonb_array_elements(coalesce(d.data->'formulas', '[]'::jsonb)) with ordinality as x(f, ord)
  where d.level_id = p_level and d.status = 'approved' and coalesce(f->>'formula', '') <> '';
$$;
grant execute on function mtb.get_level_book_formulas(text) to anon, authenticated;
