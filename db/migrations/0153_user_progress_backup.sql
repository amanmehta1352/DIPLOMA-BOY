-- 0153: opt-in progress backup. APPLIED LIVE 2026-10-31 (table + progress_save + progress_load).
-- Secret code is never stored: only sha256 of the normalised code. Name is never sent.
create table if not exists mtb.user_progress (
  code_hash text primary key, data jsonb not null, bytes int not null,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now());
alter table mtb.user_progress enable row level security;
-- progress_save(p_code text, p_data jsonb) and progress_load(p_code text): see the live functions (SECURITY DEFINER, no grants).
