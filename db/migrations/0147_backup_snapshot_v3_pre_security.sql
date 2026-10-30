-- Migration 0147: full in-DB snapshot of every mtb base table before security fixes.
-- Non-destructive: only creates a new schema and copies. No API access for anon/authenticated.
create schema if not exists backup_2026_10_30_v3;
revoke all on schema backup_2026_10_30_v3 from public, anon, authenticated;
do $$
declare r record;
begin
  for r in select tablename from pg_tables where schemaname = 'mtb' order by tablename loop
    execute format('create table if not exists backup_2026_10_30_v3.%I as table mtb.%I', r.tablename, r.tablename);
    execute format('revoke all on backup_2026_10_30_v3.%I from public, anon, authenticated', r.tablename);
  end loop;
end $$;
