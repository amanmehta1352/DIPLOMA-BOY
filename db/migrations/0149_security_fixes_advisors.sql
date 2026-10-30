-- Migration 0149: Supabase security advisor fixes (no data change).
-- STATUS 2026-10-31: COMPLETE. Part 3 applied as 0149a; parts 1-2 run by the owner in the SQL Editor (verified: advisor warnings gone).
-- 1) public.rls_auto_enable() is an event-trigger helper; nobody should call it over the REST API.
revoke execute on function public.rls_auto_enable() from public, anon, authenticated;

-- 2) mtb.import_tokens: explicit no-access for anon/authenticated (service_role and owner unaffected;
--    the SECURITY DEFINER import RPCs run as owner and keep working).
revoke all on table mtb.import_tokens from anon, authenticated;
drop policy if exists import_tokens_no_client_access on mtb.import_tokens;
create policy import_tokens_no_client_access on mtb.import_tokens
  as restrictive for all to anon, authenticated using (false) with check (false);

-- 3) Pin search_path on helper functions (bodies use only pg_catalog built-ins).
alter function mtb.norm_name(text)      set search_path = pg_catalog;
alter function mtb.slugify(text)        set search_path = pg_catalog;
alter function mtb.fix_deva_space(text) set search_path = pg_catalog;
