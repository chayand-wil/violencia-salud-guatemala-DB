#!/bin/bash

DB="localhost:/Users/wilsonjonatan/Documents/bases 1 2026/violencia guate/sql/db/violencia_guate.fdb"
ISQL="/Library/Frameworks/Firebird.framework/Resources/bin/isql"
PY="/Users/wilsonjonatan/Documents/bases 1 2026/violencia guate/.venv/bin/python"
ROOT="/Users/wilsonjonatan/Documents/bases 1 2026/violencia guate"
RUN_ID=58
BATCH=58
START_IDX=$((61000 + (BATCH - 41) * 2000))
STG_SQL="$ROOT/sql/inserts/transaccional/staging/110_agraviados_stg_batch$(printf '%03d' "$BATCH").sql"

cd "$ROOT" || exit 1

echo "[$(date '+%F %T')] INICIO visible staging B${BATCH} run_id=${RUN_ID} start=${START_IDX}"

"$ISQL" -user sysdba -password masterkey "$DB" -q -i "$ROOT/sql/ddl/007_staging_agraviados.sql" || true
"$ISQL" -user sysdba -password masterkey "$DB" -q -i "$ROOT/sql/ddl/008_persona_nombre_apellidos_idx.sql" || true
"$ISQL" -user sysdba -password masterkey "$DB" -q -i "$ROOT/sql/inserts/catalogos/066_clasificacion_delito_agraviados.sql" || true
"$ISQL" -user sysdba -password masterkey "$DB" -q -i "$ROOT/sql/inserts/catalogos/067_delito_agraviados.sql" || true
"$ISQL" -user sysdba -password masterkey "$DB" -q -i "$ROOT/sql/inserts/catalogos/068_delito_cometido_agraviados.sql" || true

"$PY" etl/generate_agraviados_staging_batch_sql.py \
  --batch "$BATCH" \
  --run-id "$RUN_ID" \
  --start-index "$START_IDX" \
  --row-limit 2000 \
  --output-root "$ROOT"

"$ISQL" -user sysdba -password masterkey "$DB" -q -i "$STG_SQL"

for STEP in 1 2 3 4 5; do
  case "$STEP" in
    1) STEP_SQL="$ROOT/sql/inserts/transaccional/110_agraviados_merge_step1_ubicacion.sql" ;;
    2) STEP_SQL="$ROOT/sql/inserts/transaccional/110_agraviados_merge_step2_persona.sql" ;;
    3) STEP_SQL="$ROOT/sql/inserts/transaccional/110_agraviados_merge_step3_hecho.sql" ;;
    4) STEP_SQL="$ROOT/sql/inserts/transaccional/110_agraviados_merge_step4_involucrado_hecho.sql" ;;
    5) STEP_SQL="$ROOT/sql/inserts/transaccional/110_agraviados_merge_step5_hecho_delictivo.sql" ;;
  esac

  MERGE_TM="/tmp/110_agr_merge_step_${RUN_ID}_${STEP}.sql"
  echo "[$(date '+%F %T')] STEP ${STEP}/5 -> $(basename "$STEP_SQL")"
  sed "s/__RUN_ID__/${RUN_ID}/g" "$STEP_SQL" > "$MERGE_TM"
  "$ISQL" -user sysdba -password masterkey "$DB" -q -i "$MERGE_TM"

  "$ISQL" -user sysdba -password masterkey "$DB" -q <<'SQL'
SET HEADING OFF;
SET LIST ON;
SELECT 'AGR_MAX' AS K, COALESCE(MAX(CAST(SUBSTRING(nombres FROM 10 FOR 6) AS INTEGER)), 0) AS VAL
FROM persona
WHERE nombres STARTING WITH 'AGR_2023_';
SQL
done

echo "[$(date '+%F %T')] FIN visible staging B${BATCH} run_id=${RUN_ID}"