-- 0175 book styles (docs/LIBRARY_ARCHITECTURE.md §2, §5).
-- Students pick HOW a book reads (5 generic styles), never a publisher or writer name.
-- 1. book_styles: the 5 styles (saral · vistar · abhyas · pariksha · chitra)
-- 2. official_books: links ONLY to the official free site of a board / council (we never store their files).
--    Starts empty: a row is added only after someone has opened the link and checked it (verified_at).
-- 3. profiles.book_style: the student's chosen style (null = use the default for their course)
-- 4. get_book_shelf(qual, subject): styles + default style + official links, for the Library screen
-- Additive only: no existing table, column or function changes behaviour.

create table if not exists mtb.book_styles (
  code      text primary key check (code ~ '^[a-z]{3,20}$'),
  name_hi   text not null,
  name_en   text not null,
  icon      text not null,
  blurb_hi  text not null,
  blurb_en  text not null,
  sort      int  not null default 0,
  active    boolean not null default true
);
alter table mtb.book_styles enable row level security;
drop policy if exists book_styles_read on mtb.book_styles;
create policy book_styles_read on mtb.book_styles for select to anon, authenticated using (active);
grant select on mtb.book_styles to anon, authenticated;

insert into mtb.book_styles (code, name_hi, name_en, icon, blurb_hi, blurb_en, sort) values
  ('saral',    'सरल पाठ्यपुस्तक', 'Simple textbook',   '📗', 'छोटे खंड, रोज़ के उदाहरण, क्रियाकलाप और बीच-बीच में प्रश्न',      'Short sections, everyday examples, activities and quick questions', 1),
  ('vistar',   'विस्तृत व्याख्या', 'Detailed explanation', '📘', 'पूरी व्युत्पत्ति, हर बात का "क्यों", ज़्यादा चित्र',              'Full derivations, the "why" behind each idea, more figures',        2),
  ('abhyas',   'अभ्यास-प्रधान',    'Practice first',    '📙', 'हर खंड के बाद हल किए उदाहरण और आसान से कठिन प्रश्न, पूरी उत्तरमाला', 'Solved examples after every section, graded questions, full answer key', 3),
  ('pariksha', 'परीक्षा-केंद्रित', 'Exam focused',      '📕', 'सूत्र-तालिका, shortcut, MCQ और समय बचाने के तरीके',                 'Formula tables, shortcuts, MCQs and time-saving methods',           4),
  ('chitra',   'चित्र-प्रधान',     'Picture first',     '📒', 'हर अवधारणा एक बड़े चित्र या flow से, कम पाठ',                       'Every idea through a large labelled figure or flow, less text',     5)
on conflict (code) do update set name_hi = excluded.name_hi, name_en = excluded.name_en, icon = excluded.icon,
  blurb_hi = excluded.blurb_hi, blurb_en = excluded.blurb_en, sort = excluded.sort;

-- ---------- official books: external links only ----------
create table if not exists mtb.official_books (
  id           bigint generated always as identity primary key,
  qual_slug    text not null references mtb.qualifications(slug) on delete cascade,
  subject_slug text not null,
  title_hi     text not null,
  title_en     text,
  issuer       text not null,                       -- e.g. the board / council that publishes it for free
  url          text not null check (url ~ '^https://'),
  verified_at  timestamptz,                         -- null = not checked yet, never shown
  active       boolean not null default true,
  unique (qual_slug, subject_slug, url)
);
alter table mtb.official_books enable row level security;
drop policy if exists official_books_read on mtb.official_books;
create policy official_books_read on mtb.official_books for select to anon, authenticated
  using (active and verified_at is not null);
grant select on mtb.official_books to anon, authenticated;

-- ---------- the student's choice ----------
alter table mtb.profiles add column if not exists book_style text references mtb.book_styles(code) on delete set null;

-- default style per course (LIBRARY_ARCHITECTURE §2)
create or replace function mtb.default_book_style(p_qual text)
 returns text language sql stable security definer set search_path to 'mtb', 'pg_catalog'
as $$
  select case
    when q.cat in ('diploma', 'iti') then 'abhyas'
    when q.cat in ('graduation', 'postgrad') then 'vistar'
    when q.slug like 'class-11-12%' or q.slug = 'class-12-pass' then 'vistar'
    else 'saral' end
  from mtb.qualifications q where q.slug = p_qual
$$;
grant execute on function mtb.default_book_style(text) to anon, authenticated;

-- Library screen: which styles, which one is pre-selected, which official links (subject optional)
create or replace function mtb.get_book_shelf(p_qual text, p_subject text default null)
 returns jsonb language sql stable security definer set search_path to 'mtb', 'pg_catalog'
as $$
  select jsonb_build_object(
    'styles', coalesce((select jsonb_agg(jsonb_build_object('code', s.code, 'hi', s.name_hi, 'en', s.name_en, 'icon', s.icon,
                         'blurb_hi', s.blurb_hi, 'blurb_en', s.blurb_en) order by s.sort)
                        from mtb.book_styles s where s.active), '[]'::jsonb),
    'default', coalesce((select p.book_style from mtb.profiles p where p.user_id = auth.uid()),
                        mtb.default_book_style(p_qual), 'saral'),
    'official', coalesce((select jsonb_agg(jsonb_build_object('subject', o.subject_slug, 'hi', o.title_hi, 'en', o.title_en,
                         'issuer', o.issuer, 'url', o.url) order by o.subject_slug, o.id)
                        from mtb.official_books o
                        where o.qual_slug = p_qual and o.active and o.verified_at is not null
                          and (p_subject is null or o.subject_slug = p_subject)), '[]'::jsonb));
$$;
grant execute on function mtb.get_book_shelf(text, text) to anon, authenticated;
