-- 0165: keep transport failures too (no HTTP status, only an error message from pg_net).
create or replace function mtb.cron_collect()
returns integer language plpgsql security definer set search_path = mtb, pg_temp as $$
declare n integer;
begin
  update mtb.cron_log l set http_status = coalesce(r.status_code, -1),
         status = case when r.status_code is null and r.error_msg is not null then 'error' else l.status end,
         detail = coalesce(l.detail, left(r.error_msg, 300))
  from net._http_response r
  where r.id = l.request_id and l.http_status is null and (r.status_code is not null or r.error_msg is not null);
  get diagnostics n = row_count;
  return n;
end $$;
revoke all on function mtb.cron_collect() from public, anon, authenticated;
