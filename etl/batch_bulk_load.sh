#!/bin/bash
# Bulk load batches of Agraviados using the new generic generator strategy.

set -euo pipefail

START_BATCH="${1:-46}"
END_BATCH="${2:-100}"
CHUNK_SIZE="${3:-1000}"
PY=".venv/bin/python"

echo "Generating and loading batches $START_BATCH-$END_BATCH..."
echo "Strategy: generic generator (no sed/copy per batch) + fast loader"
echo "Chunk size: $CHUNK_SIZE"

for BATCH in $(seq $START_BATCH $END_BATCH); do
  BATCH_START=$(date +%s)

  # Generate batch using helper
  $PY etl/quick_batch_gen.py "$BATCH" "$CHUNK_SIZE"

  # Load batch
  LOAD_OUT=$($PY etl/load_agraviados_batch_fast.py --chunks-dir "sql/inserts/transaccional/chunks_110_b${BATCH}" 2>&1)
  echo "$LOAD_OUT" | tee -a /tmp/batch_loader.log >/dev/null
  echo "$LOAD_OUT" | grep "Tiempo total"

  # Progress indicator
  BATCHES_DONE=$((BATCH - START_BATCH + 1))
  BATCH_ELAPSED=$(( $(date +%s) - BATCH_START ))
  echo "[$(date +%H:%M:%S)] Completed: B${BATCH} (${BATCHES_DONE}/$((END_BATCH - START_BATCH + 1))) in ${BATCH_ELAPSED}s"
done

echo "✓ Batches $START_BATCH-$END_BATCH complete!"
