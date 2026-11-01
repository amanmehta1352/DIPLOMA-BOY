-- 0168 Content policies (additive only). Schema only: NO seed rows.
-- Holds bilingual scope, depth and atom-count policies. Language policy has its own tables (0166, 0167).

CREATE TABLE IF NOT EXISTS mtb.content_policies (
  id BIGSERIAL PRIMARY KEY,
  policy_type TEXT NOT NULL CHECK (policy_type IN ('language','bilingual_scope','depth','atom_count')),
  level_id TEXT,
  subject TEXT,
  config JSONB NOT NULL,
  status TEXT NOT NULL DEFAULT 'proposed' CHECK (status IN ('proposed','approved','rejected')),
  source_url TEXT,
  approved_by TEXT,
  approved_at TIMESTAMPTZ,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_policies_type ON mtb.content_policies(policy_type, status);
CREATE INDEX IF NOT EXISTS idx_policies_level ON mtb.content_policies(level_id);

ALTER TABLE mtb.content_policies ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS content_policies_read ON mtb.content_policies;
CREATE POLICY content_policies_read ON mtb.content_policies FOR SELECT USING (true);
