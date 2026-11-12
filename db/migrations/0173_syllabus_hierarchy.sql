-- 0173 syllabus hierarchy: course → stage → group (theory / elective / lab / project) → subject → unit → topic.
-- 1. course_subjects: new kind 'elective'; 'outline' = key of the subject's unit/topic list in content/course-syllabus/outline.json
-- 2. course_syllabus_sync: the loader replaces a course's rows in one call (upsert + remove rows no longer in the file).
--    The old loader only upserted, so renamed / moved subjects stayed behind as duplicates. Removed rows are kept in a backup table.
-- 3. subject_units.mode: 'book' (each unit is its own book, e.g. Mechanical → SOM, TOM …) or 'section' (one book, units are
--    headed sections inside it). General Awareness becomes ONE book with 7 sections instead of a flat, unordered list.
-- Additive for the app: get_course_syllabus / get_setup_config only gain fields.

alter table mtb.course_subjects drop constraint if exists course_subjects_kind_check;
alter table mtb.course_subjects add constraint course_subjects_kind_check check (kind in ('theory','elective','lab','project'));
alter table mtb.course_subjects add column if not exists outline text;

create table if not exists mtb.bk_0173_course_subjects as select *, now() as removed_at from mtb.course_subjects with no data;
alter table mtb.bk_0173_course_subjects enable row level security;

create or replace function mtb.get_course_syllabus(p_qual text)
 returns jsonb language sql stable security definer set search_path to 'mtb', 'pg_catalog'
as $$
  select coalesce(jsonb_agg(jsonb_build_object('stage', c.stage, 'slug', c.slug, 'hi', c.name_hi, 'en', c.name_en, 'kind', c.kind,
           'outline', c.outline, 'subject', c.content_subject, 'units', to_jsonb(c.content_units), 'chapters', to_jsonb(c.content_chapters))
           order by case when c.stage ~ '^[0-9]+$' then c.stage::int else 0 end, c.sort, c.slug), '[]'::jsonb)
  from mtb.course_subjects c where c.qual_slug = p_qual;
$$;
grant execute on function mtb.get_course_syllabus(text) to anon, authenticated;

-- service role only: p = every row of ONE OR MORE whole courses; each course in p is replaced exactly
create or replace function mtb.course_syllabus_sync(p jsonb)
 returns jsonb language plpgsql security definer set search_path to 'mtb', 'pg_temp'
as $$
declare claims json := nullif(current_setting('request.jwt.claims', true), '')::json; n_up int; n_del int; quals text[];
begin
  if coalesce(claims->>'role', '') <> 'service_role' then raise exception 'not allowed'; end if;
  select array_agg(distinct r->>'qual') into quals from jsonb_array_elements(p) r
   where exists (select 1 from mtb.qualifications q where q.slug = r->>'qual');
  if quals is null then return jsonb_build_object('upserted', 0, 'removed', 0); end if;
  insert into mtb.course_subjects (qual_slug, stage, slug, sort, name_hi, name_en, kind, outline, content_subject, content_units, content_chapters, source)
  select r->>'qual', r->>'stage', r->>'slug', coalesce((r->>'sort')::int, 0), r->>'hi', r->>'en', coalesce(r->>'kind', 'theory'),
         nullif(r->>'outline', ''), nullif(r->>'subject', ''),
         case when jsonb_typeof(r->'units') = 'array' then array(select jsonb_array_elements_text(r->'units')) end,
         case when jsonb_typeof(r->'chapters') = 'array' then array(select (jsonb_array_elements_text(r->'chapters'))::int) end,
         r->>'source'
  from jsonb_array_elements(p) r where r->>'qual' = any(quals)
  on conflict (qual_slug, stage, slug) do update set sort = excluded.sort, name_hi = excluded.name_hi, name_en = excluded.name_en,
     kind = excluded.kind, outline = excluded.outline, content_subject = excluded.content_subject, content_units = excluded.content_units,
     content_chapters = excluded.content_chapters, source = excluded.source, updated_at = now();
  get diagnostics n_up = row_count;
  with gone as (
    delete from mtb.course_subjects c where c.qual_slug = any(quals)
      and not exists (select 1 from jsonb_array_elements(p) r where r->>'qual' = c.qual_slug and r->>'stage' = c.stage and r->>'slug' = c.slug)
    returning c.*)
  insert into mtb.bk_0173_course_subjects select g.*, now() from gone g;
  get diagnostics n_del = row_count;
  return jsonb_build_object('courses', cardinality(quals), 'upserted', n_up, 'removed', n_del);
end $$;
revoke all on function mtb.course_syllabus_sync(jsonb) from public, anon, authenticated;
grant execute on function mtb.course_syllabus_sync(jsonb) to service_role;

-- ---------- broad subjects as sections ----------
alter table mtb.subject_units add column if not exists mode text not null default 'book';
alter table mtb.subject_units drop constraint if exists subject_units_mode_check;
alter table mtb.subject_units add constraint subject_units_mode_check check (mode in ('book','section'));

insert into mtb.subject_units (subject_slug, slug, name_hi, name_en, sort, chapter_ids, mode)
select 'general-awareness', s.slug, s.hi, s.en, s.sort, s.ids, 'section'
from (values
  ('history-culture', 'इतिहास और संस्कृति', 'History & Culture', 1, array[419, 38]),
  ('geography', 'भूगोल', 'Geography', 2, array[418]),
  ('polity', 'राजव्यवस्था', 'Polity', 3, array[421]),
  ('economy', 'अर्थव्यवस्था', 'Economy', 4, array[417]),
  ('science-technology', 'विज्ञान और प्रौद्योगिकी', 'Science & Technology', 5, array[40, 415]),
  ('static-gk', 'स्थैतिक सामान्य ज्ञान', 'Static GK', 6, array[422]),
  ('current-affairs', 'समसामयिकी', 'Current Affairs', 7, array[416])
) as s(slug, hi, en, sort, ids)
-- only chapters that really belong to General Awareness
where (select count(*) from mtb.topics t join mtb.subjects sj on sj.id = t.subject_id
       where sj.slug = 'general-awareness' and t.id = any(s.ids)) = cardinality(s.ids)
on conflict (subject_slug, slug) do update set name_hi = excluded.name_hi, name_en = excluded.name_en, sort = excluded.sort,
  chapter_ids = excluded.chapter_ids, mode = excluded.mode;
-- General Science on exam shelves: one book with Physics / Chemistry / Biology / Environment sections (was 4 separate books)
update mtb.subject_units set mode = 'section' where subject_slug = 'general-science';

create or replace function mtb.get_setup_config()
 returns jsonb language sql stable security definer set search_path to 'mtb', 'pg_catalog'
as $$
  select jsonb_build_object(
    'quals', (select jsonb_agg(jsonb_build_object('slug', q.slug, 'cat', q.cat, 'hi', q.name_hi, 'en', q.name_en, 'level', q.level_id,
                'branch', q.branch, 'course', q.course, 'stages', q.stages, 'passed_ok', q.passed_ok,
                'exams', coalesce((select jsonb_agg(jsonb_build_object('target', x.target, 'status', x.status, 'hi', x.label_hi, 'en', x.label_en) order by x.sort, x.target)
                                   from mtb.qualification_exams x where x.qual_slug = q.slug and x.active), '[]'::jsonb)) order by q.sort)
              from mtb.qualifications q where q.active),
    'families', (select jsonb_object_agg(f.family_slug, f.j) from (
                   select e.family_slug, jsonb_build_object('hi', min(e.family_hi), 'en', min(e.family_en), 'level', min(e.content_level), 'cat', min(e.exam_cat),
                     'subjects', (select jsonb_agg(distinct sj) from (
                                    select unnest(x.subjects) sj from mtb.exams e2 join mtb.exam_sections x on x.exam_id = e2.id
                                     where e2.family_slug = e.family_slug and (e2.active or e2.setup_only)
                                    union
                                    select unnest(e2.setup_subjects) from mtb.exams e2
                                     where e2.family_slug = e.family_slug and (e2.active or e2.setup_only)) z)) j
                   from mtb.exams e where (e.active or e.setup_only) and e.family_slug is not null group by e.family_slug) f),
    'cats', (select jsonb_agg(jsonb_build_object('slug', c.slug, 'hi', c.name_hi, 'en', c.name_en, 'tech', c.tech) order by c.sort) from mtb.exam_cats c),
    'subjects', (select jsonb_object_agg(s.slug, jsonb_build_object('hi', s.name_hi, 'en', s.name_en)) from mtb.subjects s),
    'levels', (select jsonb_object_agg(l.id, jsonb_build_object('hi', l.name_hi, 'en', l.name_en)) from mtb.content_levels l),
    'branches', (select jsonb_object_agg(b.slug, b.name_en) from mtb.branches b),
    'units', (select jsonb_object_agg(u.subject_slug, u.list) from (
                select subject_slug, jsonb_agg(jsonb_build_object('slug', slug, 'hi', name_hi, 'en', name_en, 'ch', to_jsonb(chapter_ids), 'mode', mode) order by sort) list
                from mtb.subject_units group by subject_slug) u));
$$;
grant execute on function mtb.get_setup_config() to anon, authenticated;
