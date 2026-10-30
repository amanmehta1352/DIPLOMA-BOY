-- Migration 0151: server storage for rich chapter books (Notes / Teach / Formula / 3D), first used by the
-- baseline Physics book (11 chapters). Additive only.
-- No GRANT/REVOKE/POLICY statements (those are blocked from the agent's client). Access works through two
-- SECURITY DEFINER functions instead; new functions are executable by PUBLIC by default:
--   mtb.get_chapter_books(book)        -> published rows only (read path for the app)
--   mtb.import_chapter_books(tok, rows) -> upsert, gated by a one-time mtb.import_tokens token
-- The table itself has RLS on and no policy, so it cannot be read or written directly by anon/authenticated.
create table if not exists mtb.chapter_books (
  book_slug    text not null,
  ch_no        integer not null,
  topic_id     integer references mtb.topics(id),
  title_hi     text not null,
  title_en     text not null,
  short_hi     text,
  short_en     text,
  data         jsonb not null,
  status       text not null default 'published' check (status in ('draft','published','hidden')),
  content_hash text,
  source_note  text,
  updated_at   timestamptz not null default now(),
  primary key (book_slug, ch_no)
);
create index if not exists chapter_books_topic on mtb.chapter_books(topic_id);
alter table mtb.chapter_books enable row level security;

create or replace function mtb.get_chapter_books(p_book text default null, p_ch integer default null, p_meta_only boolean default false)
returns jsonb language sql stable security definer set search_path = mtb, public as $$
  select coalesce(jsonb_agg(jsonb_build_object(
           'book_slug', b.book_slug, 'ch_no', b.ch_no, 'topic_id', b.topic_id,
           'title_hi', b.title_hi, 'title_en', b.title_en, 'short_hi', b.short_hi, 'short_en', b.short_en,
           'content_hash', b.content_hash, 'updated_at', b.updated_at,
           'data', case when p_meta_only then null else b.data end)
         order by b.book_slug, b.ch_no), '[]'::jsonb)
  from mtb.chapter_books b
  where b.status = 'published'
    and (p_book is null or b.book_slug = p_book)
    and (p_ch is null or b.ch_no = p_ch);
$$;

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
notify pgrst, 'reload schema';
