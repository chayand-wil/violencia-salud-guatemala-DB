#!/usr/bin/env python3
from __future__ import annotations

import subprocess
import sys
from pathlib import Path


def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: quick_batch_gen.py BATCH_NUMBER")
        return 1

    batch_num = int(sys.argv[1])
    chunk_size = int(sys.argv[2]) if len(sys.argv) > 2 else 1000
    start_idx = 61000 + (batch_num - 41) * 2000
    root = Path(__file__).resolve().parent
    generator = root / "etl" / "generate_agraviados_batch.py"

    cmd = [
        sys.executable,
        str(generator),
        "--batch",
        str(batch_num),
        "--start-index",
        str(start_idx),
        "--chunk-size",
        str(chunk_size),
        "--output-root",
        str(root),
    ]
    subprocess.run(cmd, check=True)
    print(f"Generated batch {batch_num} with START_INDEX={start_idx} and CHUNK_SIZE={chunk_size}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
