-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261023110934  name: 0015d_verify_backup_wrapper
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): dd53e57cff594b35747129a5f8e00e56

create or replace function mtb.verify_backup(p_slot int default null) returns jsonb
language sql security definer set search_path = backup, mtb, public as $$ select backup.verify_nightly(p_slot) $$;
revoke all on function mtb.verify_backup(int) from public, anon, authenticated;
grant execute on function mtb.verify_backup(int) to service_role;
