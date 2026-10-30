-- RECONSTRUCTED from supabase_migrations.schema_migrations
-- version: 20261024031556  name: 0022_filter_questions
-- ALREADY APPLIED IN PRODUCTION — DO NOT RE-RUN. Kept for history only.
-- md5 of original statements (joined with ';\n'): 7296b7c4d6851a8b8f15524f64c58fee

create or replace function mtb.filter_questions(p jsonb default '{}', p_limit int default 500)
returns jsonb language plpgsql stable security definer set search_path = mtb, public as $$
declare ids bigint[]; total int; lim int := least(greatest(coalesce(p_limit,500),1),2000); f record; base text := 'select question_id from question_attributes where true';
begin
  -- default: only published questions, unless caller asks for another status
  if not (p ? 'status') then p := p || jsonb_build_object('status', 'published'); end if;
  -- each key = AND condition; value may be a string or an array (OR inside a key)
  with conds as (
    select key, array_agg(v) vals from (
      select e.key, jsonb_array_elements_text(case when jsonb_typeof(e.value)='array' then e.value else jsonb_build_array(e.value) end) v
      from jsonb_each(p) e) x group by key)
  select array_agg(question_id order by question_id) into ids from (
    select question_id from question_attributes qa join conds c on c.key=qa.key and qa.value = any(c.vals)
    group by question_id having count(distinct qa.key) = (select count(*) from conds)
  ) m;
  ids := coalesce(ids, '{}');
  total := cardinality(ids);
  return jsonb_build_object('count', total, 'ids', to_jsonb(ids[1:lim]), 'returned', least(total, lim), 'filter', p);
end $$;
revoke all on function mtb.filter_questions(jsonb,int) from public, anon, authenticated;
grant execute on function mtb.filter_questions(jsonb,int) to service_role;
