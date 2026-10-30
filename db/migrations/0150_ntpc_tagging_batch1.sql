-- Migration 0150: NTPC tagging batch 1 — 39 reviewed, non-flagged questions from P5 sample (docs/review/P5_ntpc_sample_50.csv).
-- Moves each question from the NTPC inbox topic 1028 to its chapter (topic_id = chapter_id, matching the convention elsewhere).
-- status is NOT changed. Only rows still on topic 1028 are touched. Rows are copied to the backup schema first.
create table if not exists backup_2026_10_30_v3.ntpc_batch1_before as
  select * from mtb.questions where id in (6091,6104,6111,6117,6120,6129,6133,6134,6136,6143,6145,6182,6193,6221,6246,6250,6257,6274,6291,6309,6332,6338,6351,6358,6388,6410,6424,6435,6448,6450,6459,6467,6487,6490,6515,6526,6547,6548,6554);
revoke all on backup_2026_10_30_v3.ntpc_batch1_before from public, anon, authenticated;

with m(id, ch) as (values
  (6091, 1),
  (6104, 429),
  (6111, 429),
  (6117, 14),
  (6120, 423),
  (6129, 429),
  (6133, 12),
  (6134, 1),
  (6136, 426),
  (6143, 421),
  (6145, 12),
  (6182, 418),
  (6193, 19),
  (6221, 18),
  (6246, 416),
  (6250, 429),
  (6257, 416),
  (6274, 416),
  (6291, 38),
  (6309, 419),
  (6332, 419),
  (6338, 429),
  (6351, 426),
  (6358, 429),
  (6388, 416),
  (6410, 14),
  (6424, 416),
  (6435, 418),
  (6448, 416),
  (6450, 429),
  (6459, 426),
  (6467, 423),
  (6487, 419),
  (6490, 429),
  (6515, 423),
  (6526, 10),
  (6547, 18),
  (6548, 429),
  (6554, 416)
)
update mtb.questions q
set topic_id = m.ch, chapter_id = m.ch, updated_at = now()
from m
where q.id = m.id and q.topic_id = 1028;
