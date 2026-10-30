-- 0066: archive the duplicate shared SVG that 0050 inserted on chapter 871.
-- 0050 created atom_key 'c910-motion-diagram' (level_id null), duplicating existing 'phy-motion-diagram' at the same atom_order.
-- Soft-archive only (no DELETE), so a DB rebuild from migrations reproduces the current state.

UPDATE mtb.atoms
SET archived = true, status = 'hidden'
WHERE atom_key = 'c910-motion-diagram'
  AND chapter_id = 871
  AND status = 'published';
