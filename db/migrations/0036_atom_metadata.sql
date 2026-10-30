-- 0036 Atom metadata for future filtering (additive only, nothing dropped or renamed).
-- Live column names: level_id (not content_level), chapter_id (not topic_id), no is_shared (shared = level_id IS NULL).
-- difficulty is left NULL until a human decides the scale; exam_tags come from the exam→level mapping; class_tags left NULL for govt levels.

alter table mtb.atoms add column if not exists exam_tags text[];
alter table mtb.atoms add column if not exists class_tags text[];
alter table mtb.atoms add column if not exists subject_tag text;
alter table mtb.atoms add column if not exists difficulty text check (difficulty in ('easy','medium','hard'));
alter table mtb.atoms add column if not exists content_hash text;

update mtb.atoms a set subject_tag = s.slug
  from mtb.topics t join mtb.subjects s on s.id = t.subject_id
  where t.id = a.chapter_id and a.subject_tag is null;

update mtb.atoms a set exam_tags = (select array_agg(e.slug order by e.id) from mtb.exams e where e.content_level = a.level_id)
  where a.level_id is not null and a.exam_tags is null;

update mtb.atoms set content_hash = md5(body::text) where content_hash is null;
