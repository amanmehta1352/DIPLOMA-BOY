-- 0175_book_editions: one subject, many books ("editions"), each in its own teaching style.
-- Library: course -> stage -> group -> subject -> EDITION -> chapter -> blocks.
-- The app's own book (atoms) is always the first, built-in edition; the owner adds more with "+" and designs
-- every chapter in edition.html (blocks: heading, text, key point, formula, example, MCQ, table, note, image).
-- All content is original, written in a style (textbook / teacher / exam ...), never a copy of a published book.
-- Owner = holder of a review code (mtb._review_ok, same code as Control Room -> Review). Students see only 'published'.
-- Additive only: new tables + functions, nothing dropped or deleted.

create table if not exists mtb.book_editions (
  id         bigint generated always as identity primary key,
  book_key   text not null check (length(book_key) between 3 and 200),   -- the app's book id: c:<qual>:<stage>:<slug> / s:<level>:<subject>
  style      text not null check (style in ('textbook','teacher','exam','practice','revision','reference')),
  title_en   text not null default '' check (length(title_en) <= 120),
  title_hi   text not null default '' check (length(title_hi) <= 120),
  about_en   text not null default '' check (length(about_en) <= 400),
  about_hi   text not null default '' check (length(about_hi) <= 400),
  sort       integer not null default 100,
  status     text not null default 'draft' check (status in ('draft','published','hidden')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists book_editions_key_idx on mtb.book_editions (book_key, sort, id);
alter table mtb.book_editions enable row level security;   -- no policies: only the functions below touch it

create table if not exists mtb.edition_chapters (
  edition_id bigint not null references mtb.book_editions(id),
  ch_no      integer not null check (ch_no between 1 and 400),
  title_en   text not null default '' check (length(title_en) <= 200),
  title_hi   text not null default '' check (length(title_hi) <= 200),
  blocks     jsonb not null default '[]'::jsonb check (jsonb_typeof(blocks) = 'array' and pg_column_size(blocks) < 400000),
  status     text not null default 'draft' check (status in ('draft','published')),
  updated_at timestamptz not null default now(),
  primary key (edition_id, ch_no)
);
alter table mtb.edition_chapters enable row level security;

-- every replaced copy is kept, so the owner can always go back
create table if not exists mtb.edition_versions (
  id         bigint generated always as identity primary key,
  edition_id bigint not null,
  ch_no      integer not null,
  title_en   text, title_hi text, blocks jsonb, status text,
  saved_at   timestamptz not null default now()
);
create index if not exists edition_versions_idx on mtb.edition_versions (edition_id, ch_no, id desc);
alter table mtb.edition_versions enable row level security;

create or replace function mtb._keep_edition_version()
returns trigger language plpgsql security definer set search_path = mtb, pg_temp as $$
begin
  if tg_op = 'DELETE' or old.blocks is distinct from new.blocks or old.title_en is distinct from new.title_en
     or old.title_hi is distinct from new.title_hi or old.status is distinct from new.status then
    insert into mtb.edition_versions (edition_id, ch_no, title_en, title_hi, blocks, status)
    values (old.edition_id, old.ch_no, old.title_en, old.title_hi, old.blocks, old.status);
  end if;
  return case when tg_op = 'DELETE' then old else new end;
end $$;
drop trigger if exists keep_edition_version on mtb.edition_chapters;   -- re-runnable; removes only this trigger
create trigger keep_edition_version before update or delete on mtb.edition_chapters
  for each row execute function mtb._keep_edition_version();

-- ---------- students (anon) ----------
-- published editions of these books, with their published chapter list (no content)
create or replace function mtb.get_book_editions(p_keys text[])
returns jsonb language sql stable security definer set search_path = mtb, pg_catalog as $$
  select coalesce(jsonb_agg(jsonb_build_object(
           'id', e.id, 'key', e.book_key, 'style', e.style, 'en', e.title_en, 'hi', e.title_hi,
           'about_en', e.about_en, 'about_hi', e.about_hi,
           'chapters', (select coalesce(jsonb_agg(jsonb_build_object('n', c.ch_no, 'en', c.title_en, 'hi', c.title_hi) order by c.ch_no), '[]'::jsonb)
                          from mtb.edition_chapters c where c.edition_id = e.id and c.status = 'published'))
         order by e.book_key, e.sort, e.id), '[]'::jsonb)
  from mtb.book_editions e
  where e.book_key = any ((coalesce(p_keys, '{}'::text[]))[1:300]) and e.status = 'published';
$$;
grant execute on function mtb.get_book_editions(text[]) to anon, authenticated;

create or replace function mtb.get_edition_chapter(p_edition bigint, p_ch integer)
returns jsonb language sql stable security definer set search_path = mtb, pg_catalog as $$
  select jsonb_build_object('edition', jsonb_build_object('id', e.id, 'key', e.book_key, 'style', e.style, 'en', e.title_en, 'hi', e.title_hi),
           'n', c.ch_no, 'en', c.title_en, 'hi', c.title_hi, 'blocks', c.blocks,
           'all', (select jsonb_agg(jsonb_build_object('n', x.ch_no, 'en', x.title_en, 'hi', x.title_hi) order by x.ch_no)
                     from mtb.edition_chapters x where x.edition_id = e.id and x.status = 'published'))
  from mtb.book_editions e join mtb.edition_chapters c on c.edition_id = e.id
  where e.id = p_edition and c.ch_no = p_ch and e.status = 'published' and c.status = 'published';
$$;
grant execute on function mtb.get_edition_chapter(bigint, integer) to anon, authenticated;

-- ---------- owner (review code) ----------
create or replace function mtb.owner_ok(p_code text)
returns boolean language sql stable security definer set search_path = mtb, pg_temp as $$ select mtb._review_ok(p_code); $$;
grant execute on function mtb.owner_ok(text) to anon, authenticated;

-- every edition (any status) of these books, with every chapter's status
create or replace function mtb.edition_owner_list(p_code text, p_keys text[])
returns jsonb language plpgsql stable security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  return (select coalesce(jsonb_agg(jsonb_build_object(
            'id', e.id, 'key', e.book_key, 'style', e.style, 'en', e.title_en, 'hi', e.title_hi,
            'about_en', e.about_en, 'about_hi', e.about_hi, 'sort', e.sort, 'status', e.status,
            'chapters', (select coalesce(jsonb_agg(jsonb_build_object('n', c.ch_no, 'en', c.title_en, 'hi', c.title_hi,
                                   'status', c.status, 'blocks', jsonb_array_length(c.blocks)) order by c.ch_no), '[]'::jsonb)
                           from mtb.edition_chapters c where c.edition_id = e.id))
          order by e.book_key, e.sort, e.id), '[]'::jsonb)
          from mtb.book_editions e where e.book_key = any ((coalesce(p_keys, '{}'::text[]))[1:300]));
end $$;
grant execute on function mtb.edition_owner_list(text, text[]) to anon, authenticated;

-- create (no id) or change an edition; returns its id
create or replace function mtb.edition_save(p_code text, p jsonb)
returns bigint language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
declare v_id bigint;
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  if (p->>'id') is null then
    insert into mtb.book_editions (book_key, style, title_en, title_hi, about_en, about_hi, sort, status)
    values (p->>'key', coalesce(p->>'style','textbook'), coalesce(p->>'en',''), coalesce(p->>'hi',''),
            coalesce(p->>'about_en',''), coalesce(p->>'about_hi',''), coalesce((p->>'sort')::int, 100), 'draft')
    returning id into v_id;
  else
    update mtb.book_editions set
      style    = coalesce(p->>'style', style),
      title_en = coalesce(p->>'en', title_en),       title_hi = coalesce(p->>'hi', title_hi),
      about_en = coalesce(p->>'about_en', about_en), about_hi = coalesce(p->>'about_hi', about_hi),
      sort     = coalesce((p->>'sort')::int, sort),  status   = coalesce(p->>'status', status),
      updated_at = now()
    where id = (p->>'id')::bigint returning id into v_id;
    if v_id is null then raise exception 'no edition'; end if;
  end if;
  return v_id;
end $$;
grant execute on function mtb.edition_save(text, jsonb) to anon, authenticated;

create or replace function mtb.edition_chapter_get(p_code text, p_edition bigint, p_ch integer)
returns jsonb language plpgsql stable security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  return (select jsonb_build_object('n', c.ch_no, 'en', c.title_en, 'hi', c.title_hi, 'blocks', c.blocks, 'status', c.status, 'updated_at', c.updated_at)
          from mtb.edition_chapters c where c.edition_id = p_edition and c.ch_no = p_ch);
end $$;
grant execute on function mtb.edition_chapter_get(text, bigint, integer) to anon, authenticated;

-- save one chapter (title / blocks / status); p.delete = true removes it (a copy stays in edition_versions)
create or replace function mtb.edition_chapter_save(p_code text, p_edition bigint, p_ch integer, p jsonb)
returns text language plpgsql volatile security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._review_ok(p_code) then raise exception 'bad code'; end if;
  if not exists (select 1 from mtb.book_editions where id = p_edition) then raise exception 'no edition'; end if;
  if coalesce((p->>'delete')::boolean, false) then
    delete from mtb.edition_chapters where edition_id = p_edition and ch_no = p_ch;
    return 'deleted';
  end if;
  insert into mtb.edition_chapters as c (edition_id, ch_no, title_en, title_hi, blocks, status)
  values (p_edition, p_ch, coalesce(p->>'en',''), coalesce(p->>'hi',''), coalesce(p->'blocks','[]'::jsonb), coalesce(p->>'status','draft'))
  on conflict (edition_id, ch_no) do update set
    title_en = coalesce(p->>'en', c.title_en), title_hi = coalesce(p->>'hi', c.title_hi),
    blocks   = coalesce(p->'blocks', c.blocks), status  = coalesce(p->>'status', c.status), updated_at = now();
  update mtb.book_editions set updated_at = now() where id = p_edition;
  return 'saved';
end $$;
grant execute on function mtb.edition_chapter_save(text, bigint, integer, jsonb) to anon, authenticated;
