#!/bin/bash
# Monitor bulk loading progress in real-time

LOG="/tmp/batch_load_progress.log"
echo "Monitoring batch loading progress..."
echo "Log file: $LOG"
echo ""

tail -f $LOG | grep -E "Completed|Tiempo|Created" | while read line; do
  echo "[$(date +%H:%M:%S)] $line"
done
