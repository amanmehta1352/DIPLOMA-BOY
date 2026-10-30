-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261023102415  name: 0014c_questions_hash_index
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): 6952ffb8241a68da75c02ae9d238aa42

create index if not exists questions_hash_idx on mtb.questions (content_hash);
