#!/bin/bash

DB="localhost:/Users/wilsonjonatan/Documents/bases 1 2026/violencia guate/sql/db/violencia_guate.fdb"
ISQL="/Library/Frameworks/Firebird.framework/Resources/bin/isql"
PY="/Users/wilsonjonatan/Documents/bases 1 2026/violencia guate/.venv/bin/python"
ROOT="/Users/wilsonjonatan/Documents/bases 1 2026/violencia guate"

cd "$ROOT" || exit 1

echo "[$(date '+%F %T')] INICIO staging load B58-B120"

# Ensure staging table exists (ignore error if already created)
"$ISQL" -user sysdba -password masterkey "$DB" -q -i "$ROOT/sql/ddl/007_staging_agraviados.sql" || true

# Ensure catalogs are loaded once
"$ISQL" -user sysdba -password masterkey "$DB" -q -i "$ROOT/sql/inserts/catalogos/066_clasificacion_delito_agraviados.sql" || true
"$ISQL" -user sysdba -password masterkey "$DB" -q -i "$ROOT/sql/inserts/catalogos/067_delito_agraviados.sql" || true
"$ISQL" -user sysdba -password masterkey "$DB" -q -i "$ROOT/sql/inserts/catalogos/068_delito_cometido_agraviados.sql" || true

for B in $(seq 58 120); do
  RUN_ID=$B
  START_IDX=$((61000 + (B - 41) * 2000))
  STG_SQL="$ROOT/sql/inserts/transaccional/staging/110_agraviados_stg_batch$(printf '%03d' "$B").sql"
  MERGE_TM="/tmp/110_agr_merge_run_${RUN_ID}.sql"

  echo "=== STAGING B${B} run_id=${RUN_ID} start=${START_IDX} ==="

  "$PY" etl/generate_agraviados_staging_batch_sql.py \
    --batch "$B" \
    --run-id "$RUN_ID" \
    --start-index "$START_IDX" \
    --row-limit 2000 \
    --output-root "$ROOT"

  "$ISQL" -user sysdba -password masterkey "$DB" -q -i "$STG_SQL"

  sed "s/__RUN_ID__/${RUN_ID}/g" "$ROOT/sql/inserts/transaccional/110_agraviados_merge_from_staging.sql" > "$MERGE_TM"
  "$ISQL" -user sysdba -password masterkey "$DB" -q -i "$MERGE_TM"

  if (( B % 5 == 0 )); then
    "$ISQL" -user sysdba -password masterkey "$DB" -q <<'SQL'
SET HEADING OFF;
SET LIST ON;
SELECT 'AGR_MAX' AS K, MAX(CAST(SUBSTRING(nombres FROM 10 FOR 6) AS INTEGER)) AS VAL
FROM persona
WHERE nombres STARTING WITH 'AGR_2023_';
SQL
  fi

done

echo "[$(date '+%F %T')] FIN staging load B58-B120"
