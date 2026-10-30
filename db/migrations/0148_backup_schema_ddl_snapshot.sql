-- Migration 0148: store a schema-only snapshot (tables, constraints, indexes, policies, full function definitions)
-- inside the private backup schema. Non-destructive.
create table if not exists backup_2026_10_30_v3._schema_ddl as
select now() as taken_at, kind, name, ddl from (
  select 'table' kind, c.relname::text name,
         format('create table mtb.%I (%s);', c.relname, string_agg(format('%I %s%s%s', a.attname, format_type(a.atttypid,a.atttypmod),
           case when a.attnotnull then ' not null' else '' end, coalesce(' default '||pg_get_expr(d.adbin,d.adrelid),'')), ', ' order by a.attnum)) ddl
  from pg_class c join pg_namespace n on n.oid=c.relnamespace
  join pg_attribute a on a.attrelid=c.oid and a.attnum>0 and not a.attisdropped
  left join pg_attrdef d on d.adrelid=c.oid and d.adnum=a.attnum
  where n.nspname='mtb' and c.relkind='r' group by c.relname
  union all
  select 'constraint', conname::text, format('alter table %s add constraint %I %s;', conrelid::regclass, conname, pg_get_constraintdef(oid))
  from pg_constraint where connamespace='mtb'::regnamespace and contype in ('p','u','f','c')
  union all
  select 'index', indexname::text, indexdef||';' from pg_indexes where schemaname='mtb'
  union all
  select 'policy', policyname::text, format('create policy %I on mtb.%I as %s for %s to %s using (%s) with check (%s);',
         policyname, tablename, permissive, cmd, array_to_string(roles,','), coalesce(qual,'true'), coalesce(with_check,'true'))
  from pg_policies where schemaname='mtb'
  union all
  select 'function', n.nspname||'.'||p.proname, pg_get_functiondef(p.oid)
  from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname in ('mtb','public') and p.prokind='f'
) s;
revoke all on backup_2026_10_30_v3._schema_ddl from public, anon, authenticated;
