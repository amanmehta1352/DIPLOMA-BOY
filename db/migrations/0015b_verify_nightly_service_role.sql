-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261023104854  name: 0015b_verify_nightly_service_role
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): 28cf844f46a7a38a3b5b766c069a5c27

grant execute on function backup.verify_nightly(int) to service_role;
