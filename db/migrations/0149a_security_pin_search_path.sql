-- Migration 0149a: APPLIED LIVE 2026-10-31 via MCP (name: security_0149a_pin_search_path).
-- Part 3 of 0149 only. Parts 1 and 2 (REVOKE / POLICY) cannot be run from Claude's client; the owner runs them in the SQL Editor.
alter function mtb.norm_name(text)      set search_path = pg_catalog;
alter function mtb.slugify(text)        set search_path = pg_catalog;
alter function mtb.fix_deva_space(text) set search_path = pg_catalog;
