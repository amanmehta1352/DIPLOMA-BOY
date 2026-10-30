-- STATUS (2026-10-30 audit): APPLIED LIVE via SQL editor, not via the migration tool, so it has no row in supabase_migrations.
-- Its effects exist (mtb.atoms.archived column). DO NOT RE-RUN.
-- 0040 Fix + metadata backfill (applied live as the same statements).
-- 1) Slug collision: topic slug 'strength-of-materials' exists on civil (410) and mechanical (439).
--    The 0039 insert joined by slug and wrote mechanical SOM atoms onto civil 410.
--    Not deleted (delete was blocked); hidden + archived instead, so the app (status = 'published') never shows them.
-- 2) Backfill metadata on every row that still has nulls. Existing values are kept (COALESCE).
--    exam_tags use real exam slugs from mtb.exams.content_level, not placeholder names.

ALTER TABLE mtb.atoms ADD COLUMN IF NOT EXISTS archived BOOLEAN DEFAULT false;

UPDATE mtb.atoms SET status = 'hidden', archived = true
WHERE chapter_id = 410 AND atom_key LIKE 'som-%';

UPDATE mtb.atoms a SET
  content_hash = COALESCE(a.content_hash, md5(a.body::text)),
  subject_tag  = COALESCE(a.subject_tag, s.slug),
  exam_tags    = COALESCE(a.exam_tags, (SELECT COALESCE(array_agg(e.slug ORDER BY e.slug), '{}') FROM mtb.exams e WHERE e.content_level = a.level_id)),
  difficulty   = COALESCE(a.difficulty, 'medium')
FROM mtb.topics t LEFT JOIN mtb.subjects s ON s.id = t.subject_id
WHERE t.id = a.chapter_id
  AND (a.content_hash IS NULL OR a.subject_tag IS NULL OR a.exam_tags IS NULL OR a.difficulty IS NULL);
