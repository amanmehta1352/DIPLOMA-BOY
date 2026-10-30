-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261023102157  name: 0014b_publish_problems_array_fix
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): 64dd2a681caa27e941856886740bfb28

create or replace function mtb.publish_problems(q mtb.questions) returns text[]
language plpgsql stable set search_path = mtb, public as $$
declare p text[] := '{}'; en text; hi text; other int; latin int; exam int; has_img boolean;
begin
  has_img := (q.stem ? 'img') and coalesce(q.stem->>'img','') <> '';
  if q.answer is null or q.answer < 0 or q.answer > 3 then p := array_append(p, 'answer'); end if;
  if jsonb_typeof(q.options) <> 'array' or jsonb_array_length(q.options) <> 4 then p := array_append(p, 'options'); end if;
  if q.source_id is null and q.kind = 'pyq' then p := array_append(p, 'source'); end if;
  en := coalesce(q.stem->>'en', ''); hi := coalesce(q.stem->>'hi', '');
  if not has_img and btrim(en) = '' then p := array_append(p, 'english_missing'); end if;
  if en <> '' then
    other := length(regexp_replace(en, '[^ऀ-෿]', '', 'g'));
    latin := length(regexp_replace(en, '[^A-Za-z]', '', 'g'));
    if other > 10 and other > latin then p := array_append(p, 'english_wrong_language'); end if;
  end if;
  if btrim(hi) = '' and coalesce(q.stem->>'img_hi', '') = '' then p := array_append(p, 'hindi_missing'); end if;
  if has_img and coalesce(q.stem->'checks'->>'fig_ok', '') <> 'true' then p := array_append(p, 'figure_not_reviewed'); end if;
  if q.source_id is not null and q.content_hash is not null then
    select s.exam_id into exam from mtb.sources s where s.id = q.source_id;
    if exists (select 1 from mtb.questions o join mtb.sources os on os.id = o.source_id
               where o.content_hash = q.content_hash and o.id <> q.id and o.status = 'published' and os.exam_id = exam
                 and (select paper_date from mtb.sources where id = o.source_id) is not distinct from (select paper_date from mtb.sources where id = q.source_id)
                 and o.source_id <> q.source_id) then
      p := array_append(p, 'duplicate_in_exam');
    end if;
  end if;
  return p;
end $$;
