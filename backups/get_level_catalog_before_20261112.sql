-- mtb.get_level_catalog as it was before 2026-11-12 (chapter 'n' = published atom count only)
CREATE OR REPLACE FUNCTION mtb.get_level_catalog(p_level text)
 RETURNS jsonb LANGUAGE sql STABLE SECURITY DEFINER SET search_path TO 'mtb', 'pg_catalog'
AS $function$
  with live as (
    select a.chapter_id, a.atom_type from mtb.atoms a
    where a.level_id = p_level and a.status = 'published' and not coalesce(a.archived, false)),
  cnt as (select chapter_id, count(*) n, jsonb_agg(distinct atom_type) types from live group by chapter_id),
  subj as (select distinct t.subject_id from live join mtb.topics t on t.id = live.chapter_id)
  select coalesce(jsonb_agg(jsonb_build_object(
      'id', s.id, 'slug', s.slug, 'hi', s.name_hi, 'en', s.name_en,
      'chapters', (select jsonb_agg(jsonb_build_object('id', t.id, 'slug', t.slug, 'hi', t.name_hi, 'en', t.name_en,
                      'n', coalesce(c.n, 0), 'types', coalesce(c.types, '[]'::jsonb)) order by t.sort, t.id)
                   from mtb.topics t left join cnt c on c.chapter_id = t.id
                   where t.subject_id = s.id and t.is_chapter))
    order by s.id), '[]'::jsonb)
  from mtb.subjects s where s.id in (select subject_id from subj);
$function$;
