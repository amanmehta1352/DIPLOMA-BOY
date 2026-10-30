-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261021183353  name: 0013_pattern_apply
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): 84cc37473ef2b3c600ff705c71adc526

create or replace function mtb.pattern_apply(p jsonb)
returns integer
language plpgsql
security definer
set search_path to 'mtb', 'public'
as $$
declare n integer;
begin
  update mtb.questions set pattern_id = null, pattern_n = null, pattern_rep = true where pattern_id is not null;
  update mtb.questions q set pattern_id = v.pid, pattern_n = v.n, pattern_rep = (q.id = v.pid)
    from jsonb_to_recordset(p) as v(id integer, pid integer, n integer)
    where q.id = v.id;
  get diagnostics n = row_count;
  return n;
end $$;
revoke all on function mtb.pattern_apply(jsonb) from public, anon, authenticated;
grant execute on function mtb.pattern_apply(jsonb) to service_role;
