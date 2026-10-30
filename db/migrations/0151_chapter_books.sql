-- Migration 0151: server storage for rich chapter books (Notes / Teach / Formula / 3D), first used by the
-- baseline Physics book (11 chapters). Additive only.
create table if not exists mtb.chapter_books (
  book_slug   text not null,                       -- e.g. 'physics-baseline'
  ch_no       integer not null,                    -- chapter number inside the book
  topic_id    integer references mtb.topics(id),   -- app chapter this book chapter belongs to
  title_hi    text not null,
  title_en    text not null,
  short_hi    text,
  short_en    text,
  data        jsonb not null,                      -- notes_hi, notes_en, teach{hindi,english,bilingual,hinglish}, formulas, formula_groups, demo
  status      text not null default 'published' check (status in ('draft','published','hidden')),
  content_hash text,
  source_note text,
  updated_at  timestamptz not null default now(),
  primary key (book_slug, ch_no)
);
create index if not exists chapter_books_topic on mtb.chapter_books(topic_id);
alter table mtb.chapter_books enable row level security;
drop policy if exists read_published_books on mtb.chapter_books;
create policy read_published_books on mtb.chapter_books for select to anon, authenticated using (status = 'published');
grant select on mtb.chapter_books to anon, authenticated;
grant all on mtb.chapter_books to service_role;

-- One-time-token import, same pattern as mtb.import_pyq / mtb.import_practice.
create or replace function mtb.import_chapter_books(tok text, rows jsonb)
returns jsonb language plpgsql security definer set search_path = mtb, public as $$
declare r jsonb; n int := 0;
begin
  if not exists (select 1 from mtb.import_tokens where token = tok and not used and expires_at > now()) then
    raise exception 'bad token';
  end if;
  for r in select * from jsonb_array_elements(rows) loop
    insert into mtb.chapter_books(book_slug, ch_no, topic_id, title_hi, title_en, short_hi, short_en, data, status, content_hash, source_note, updated_at)
    values (r->>'book_slug', (r->>'ch_no')::int, nullif(r->>'topic_id','')::int, r->>'title_hi', r->>'title_en', r->>'short_hi', r->>'short_en',
            r->'data', coalesce(r->>'status','published'), md5((r->'data')::text), r->>'source_note', now())
    on conflict (book_slug, ch_no) do update set topic_id = excluded.topic_id, title_hi = excluded.title_hi, title_en = excluded.title_en,
      short_hi = excluded.short_hi, short_en = excluded.short_en, data = excluded.data, status = excluded.status,
      content_hash = excluded.content_hash, source_note = excluded.source_note, updated_at = now();
    n := n + 1;
  end loop;
  return jsonb_build_object('upserted', n, 'total', (select count(*) from mtb.chapter_books));
end $$;
revoke all on function mtb.import_chapter_books(text, jsonb) from public;
grant execute on function mtb.import_chapter_books(text, jsonb) to anon;
notify pgrst, 'reload schema';
