-- 0026 Pattern review gate (additive only: no DROP, no DELETE, no change to live pattern_id).
-- New matches from group.py land here as pending_review. They do not touch mtb.questions until a reviewer approves them.
-- Existing mtb.pattern_apply is left as it is for now.

create table if not exists mtb.pattern_candidates (
  id bigint generated always as identity primary key,
  question_id bigint not null references mtb.questions(id) on delete restrict,
  pattern_lead_id bigint not null references mtb.questions(id) on delete restrict,
  relation_type text not null check (relation_type in ('exact', 'same', 'related')),
  confidence real not null check (confidence >= 0 and confidence <= 1),
  evidence jsonb not null default '{}'::jsonb,
  algorithm_version int not null default 1,
  status text not null default 'pending_review' check (status in ('pending_review', 'approved', 'rejected')),
  reviewed_by uuid,
  reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  unique (question_id, pattern_lead_id, relation_type, algorithm_version),
  check (question_id <> pattern_lead_id)
);

create index if not exists pattern_candidates_status_idx on mtb.pattern_candidates(status, relation_type);
create index if not exists pattern_candidates_lead_idx on mtb.pattern_candidates(pattern_lead_id);

-- Only the service role (robots) and the owner may read or write this table; the public app never does.
alter table mtb.pattern_candidates enable row level security;
revoke all on mtb.pattern_candidates from public, anon, authenticated;

-- Robot entry point: stages candidates only. It never writes to mtb.questions.
create or replace function mtb.pattern_stage(p jsonb) returns integer
language plpgsql security definer set search_path to 'mtb', 'public'
as $$
declare n integer;
begin
  insert into mtb.pattern_candidates (question_id, pattern_lead_id, relation_type, confidence, evidence, algorithm_version)
  select v.question_id, v.pattern_lead_id, v.relation_type, v.confidence, coalesce(v.evidence, '{}'::jsonb), coalesce(v.algorithm_version, 1)
  from jsonb_to_recordset(p) as v(question_id bigint, pattern_lead_id bigint, relation_type text, confidence real, evidence jsonb, algorithm_version int)
  on conflict (question_id, pattern_lead_id, relation_type, algorithm_version) do nothing;
  get diagnostics n = row_count;
  return n;
end $$;

revoke all on function mtb.pattern_stage(jsonb) from public, anon, authenticated;
