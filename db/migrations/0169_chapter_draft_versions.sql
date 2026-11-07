-- Applied to the server 2026-11-07 (migration 0169_chapter_draft_versions). Additive only; nothing is deleted.
-- Keeps every earlier version of a chapter draft before it is replaced.
create table if not exists mtb.chapter_draft_versions (
  version_id bigserial primary key,
  draft_id bigint not null,
  level_id text not null,
  chapter_id integer not null,
  status text,
  data jsonb not null,
  checks jsonb,
  provider text,
  model text,
  saved_at timestamptz not null default now(),
  note text
);
alter table mtb.chapter_draft_versions enable row level security;
revoke all on mtb.chapter_draft_versions from anon, authenticated;
create index if not exists chapter_draft_versions_chapter on mtb.chapter_draft_versions (level_id, chapter_id, saved_at desc);
insert into mtb.chapter_draft_versions (draft_id, level_id, chapter_id, status, data, checks, provider, model, note)
select id, level_id, chapter_id, status, data, checks, provider, model,
       'v1 as live on 2026-11-07, saved before the v2 content redesign (owner request)'
from mtb.chapter_drafts where id = 72;
