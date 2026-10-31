-- 0160_planner_read_solutions: the Coverage Planner (Health Robot) counts approved solutions with the service role.
-- Additive only: one SELECT grant. Students still cannot read this table directly (their key has no grant; RLS unchanged).
grant select on mtb.solution_items to service_role;
