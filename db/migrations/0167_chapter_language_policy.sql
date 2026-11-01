-- 0167 Chapter-level language policy (additive only). Schema only: NO seed rows.
-- Used for school levels where the language depends on the subject (CEO decision, Nov 2026:
-- Science/Maths primary English, Social Science primary Hindi). Keyed by chapter + content level.

create table if not exists mtb.chapter_language_policy (
  id bigint generated always as identity primary key,
  chapter_id int not null references mtb.topics(id),
  subject text not null,                                  -- for example science, maths, social_science, english, hindi
  level_id text not null references mtb.content_levels(id),
  primary_lang text not null check (primary_lang in ('en','hi')),
  secondary_lang text check (secondary_lang in ('en','hi')),
  source text,                                            -- official circular URL, or 'CEO decision 2026-11'
  approved boolean not null default false,
  approved_by text,
  created_at timestamptz not null default now(),
  unique (chapter_id, level_id),
  check (secondary_lang is null or secondary_lang <> primary_lang)
);

alter table mtb.chapter_language_policy enable row level security;
drop policy if exists chapter_language_policy_read on mtb.chapter_language_policy;
create policy chapter_language_policy_read on mtb.chapter_language_policy for select using (true);
