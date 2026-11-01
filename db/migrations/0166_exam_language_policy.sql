-- 0166 Exam language policy (additive only). Schema only: NO seed rows.
-- One row per exam: which languages its papers are offered in, and which language the writer uses first.
-- Rows are inserted only after official-notification research and CEO approval.
-- Flow once approved: writer writes primary_lang, translator produces secondary_lang, QA checks both.

create table if not exists mtb.exam_language_policy (
  id bigint generated always as identity primary key,
  exam_slug text unique not null,                         -- matches mtb.exams.slug
  primary_lang text not null check (primary_lang in ('en','hi')),
  secondary_lang text check (secondary_lang in ('en','hi')),  -- null = single language only
  regional_langs text[] not null default '{}',            -- extra official medium options (state-wise where noted in reasoning)
  reasoning text,                                         -- why this policy, in plain words
  source_url text,                                        -- official notification / bulletin URL
  use_student_medium boolean not null default false,      -- future: filter content by student's chosen medium (off until 1000+ users)
  status text not null default 'proposed' check (status in ('proposed','approved','rejected')),
  decided_at timestamptz,
  approved_by text,
  created_at timestamptz not null default now(),
  check (secondary_lang is null or secondary_lang <> primary_lang)
);

-- Read-only for the app (same RLS style as reference data). Writes go through robots using the service role.
alter table mtb.exam_language_policy enable row level security;
drop policy if exists exam_language_policy_read on mtb.exam_language_policy;
create policy exam_language_policy_read on mtb.exam_language_policy for select using (true);
