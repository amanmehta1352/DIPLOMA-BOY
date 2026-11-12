-- 0171 course syllabus: every subject of every course, stage-wise (semester / year / class), shown in the library.
-- Subjects with no content yet show locked; a subject can point to existing content (subject, its units, or chapter ids).
-- Additive: new table + one read function + one service-only loader. Data: content/course-syllabus/syllabus.json.
create table if not exists mtb.course_subjects (
  qual_slug  text not null references mtb.qualifications(slug),
  stage      text not null,                 -- '1'..'8' (semester / year), '11','12', or 'all'
  slug       text not null,
  sort       int  not null default 0,
  name_hi    text not null,
  name_en    text not null,
  kind       text not null default 'theory' check (kind in ('theory','lab','project')),
  content_subject  text,                    -- mtb.subjects.slug with content
  content_units    text[],                  -- mtb.subject_units slugs inside that subject
  content_chapters int[],                   -- exact chapter (topic) ids
  source     text,
  updated_at timestamptz not null default now(),
  primary key (qual_slug, stage, slug)
);
alter table mtb.course_subjects enable row level security;

create or replace function mtb.get_course_syllabus(p_qual text)
 returns jsonb language sql stable security definer set search_path to 'mtb', 'pg_catalog'
as $$
  select coalesce(jsonb_agg(jsonb_build_object('stage', c.stage, 'slug', c.slug, 'hi', c.name_hi, 'en', c.name_en, 'kind', c.kind,
           'subject', c.content_subject, 'units', to_jsonb(c.content_units), 'chapters', to_jsonb(c.content_chapters))
           order by case when c.stage ~ '^[0-9]+$' then c.stage::int else 0 end, c.sort, c.slug), '[]'::jsonb)
  from mtb.course_subjects c where c.qual_slug = p_qual;
$$;
grant execute on function mtb.get_course_syllabus(text) to anon, authenticated;

-- loader (service role only): upsert rows; never deletes
create or replace function mtb.course_syllabus_load(p jsonb)
 returns jsonb language plpgsql security definer set search_path to 'mtb', 'pg_temp'
as $$
declare claims json := nullif(current_setting('request.jwt.claims', true), '')::json; n int;
begin
  if coalesce(claims->>'role', '') <> 'service_role' then raise exception 'not allowed'; end if;
  insert into mtb.course_subjects (qual_slug, stage, slug, sort, name_hi, name_en, kind, content_subject, content_units, content_chapters, source)
  select r->>'qual', r->>'stage', r->>'slug', coalesce((r->>'sort')::int, 0), r->>'hi', r->>'en', coalesce(r->>'kind', 'theory'),
         nullif(r->>'subject', ''),
         case when jsonb_typeof(r->'units') = 'array' then array(select jsonb_array_elements_text(r->'units')) end,
         case when jsonb_typeof(r->'chapters') = 'array' then array(select (jsonb_array_elements_text(r->'chapters'))::int) end,
         r->>'source'
  from jsonb_array_elements(p) r
  where exists (select 1 from mtb.qualifications q where q.slug = r->>'qual')
  on conflict (qual_slug, stage, slug) do update set sort = excluded.sort, name_hi = excluded.name_hi, name_en = excluded.name_en,
     kind = excluded.kind, content_subject = excluded.content_subject, content_units = excluded.content_units,
     content_chapters = excluded.content_chapters, source = excluded.source, updated_at = now();
  get diagnostics n = row_count;
  return jsonb_build_object('upserted', n);
end $$;
revoke all on function mtb.course_syllabus_load(jsonb) from public, anon, authenticated;
grant execute on function mtb.course_syllabus_load(jsonb) to service_role;
