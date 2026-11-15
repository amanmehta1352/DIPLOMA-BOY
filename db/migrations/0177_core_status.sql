-- 0177 core status for the Book Core Writer robot (robots/book/core_writer.py).
-- Service role only: which cores exist and in what state, so the robot writes only new cores
-- and cores the owner sent back with 'changes'. Read-only and additive.
create or replace function mtb.core_status()
returns table(core_id text, status text, attempts int, updated_at timestamptz)
language plpgsql stable security definer set search_path = mtb, pg_temp as $$
begin
  if not mtb._is_service() then raise exception 'not allowed'; end if;
  return query select c.core_id, c.status, c.attempts, c.updated_at from mtb.chapter_cores c;
end $$;
revoke all on function mtb.core_status() from public, anon, authenticated;
grant execute on function mtb.core_status() to service_role;
