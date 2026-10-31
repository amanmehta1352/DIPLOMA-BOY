-- Applied to the server (migration 0159_approved_chapter_books). Additive only.
-- Students read robot-written chapter books only after the owner approved them (status = 'approved').
create or replace function mtb.get_chapter_book(p_level text, p_chapter integer)
returns jsonb language sql stable security definer set search_path = mtb, pg_temp as $$
  select jsonb_build_object('data', d.data, 'status', d.status)
  from mtb.chapter_drafts d where d.level_id = p_level and d.chapter_id = p_chapter and d.status = 'approved';
$$;

create or replace function mtb.get_level_book_ids(p_level text)
returns jsonb language sql stable security definer set search_path = mtb, pg_temp as $$
  select coalesce(jsonb_agg(chapter_id order by chapter_id), '[]'::jsonb)
  from mtb.chapter_drafts where level_id = p_level and status = 'approved';
$$;
