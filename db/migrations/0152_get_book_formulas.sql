-- Migration 0152: light read path for the app's Formula screen: only titles + formula cards of a book,
-- not the full notes/teach/3D payload. SECURITY DEFINER, published rows only (same pattern as 0151).
create or replace function mtb.get_book_formulas(p_book text default 'physics-baseline')
returns jsonb language sql stable security definer set search_path = mtb, public as $$
  select coalesce(jsonb_agg(jsonb_build_object(
           'ch_no', b.ch_no, 'topic_id', b.topic_id, 'title_hi', b.title_hi, 'title_en', b.title_en,
           'short_hi', b.short_hi, 'short_en', b.short_en,
           'formulas', coalesce(b.data->'formulas', '[]'::jsonb))
         order by b.ch_no), '[]'::jsonb)
  from mtb.chapter_books b
  where b.status = 'published' and b.book_slug = p_book;
$$;
notify pgrst, 'reload schema';
