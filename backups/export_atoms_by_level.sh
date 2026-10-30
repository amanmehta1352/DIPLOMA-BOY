#!/usr/bin/env bash
# Export published, non-archived atoms into one JSON file per level (19 files incl. shared).
# Usage: DB_URL='postgresql://...' ./backups/export_atoms_by_level.sh
set -euo pipefail
: "${DB_URL:?set DB_URL to the Supabase Postgres connection string}"
DATE=2026-10-30
DIR="$(cd "$(dirname "$0")" && pwd)"

LEVELS=$(psql "$DB_URL" -At -c "SELECT id FROM mtb.content_levels ORDER BY sort;")
for L in $LEVELS; do
  psql "$DB_URL" -At -c "SELECT COALESCE(json_agg(row_to_json(a) ORDER BY a.id), '[]'::json) FROM mtb.atoms a WHERE a.level_id = '$L' AND a.status='published' AND NOT a.archived;" > "$DIR/atoms_${L}_${DATE}.json"
done

psql "$DB_URL" -At -c "SELECT COALESCE(json_agg(row_to_json(a) ORDER BY a.id), '[]'::json) FROM mtb.atoms a WHERE a.level_id IS NULL AND a.status='published' AND NOT a.archived;" > "$DIR/atoms_shared_${DATE}.json"

TOTAL=0
for f in "$DIR"/atoms_*_${DATE}.json; do
  n=$(python3 -I -c "import json,sys; print(len(json.load(open(sys.argv[1]))))" "$f")
  TOTAL=$((TOTAL + n))
  echo "$(basename "$f"): $n atoms"
done
echo "TOTAL atoms: $TOTAL (expected 3071)"
