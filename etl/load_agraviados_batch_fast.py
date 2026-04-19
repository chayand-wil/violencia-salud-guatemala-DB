from __future__ import annotations

import argparse
import subprocess
import tempfile
import time
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Carga rapida de chunks Agraviados en una sola sesion isql."
    )
    parser.add_argument(
        "--chunks-dir",
        required=True,
        help="Directorio con archivos 110_agraviados_part_*.sql",
    )
    parser.add_argument(
        "--db",
        default="localhost:/Users/wilsonjonatan/Documents/bases 1 2026/violencia guate/sql/db/violencia_guate.fdb",
        help="Cadena de conexion Firebird",
    )
    parser.add_argument(
        "--isql",
        default="/Library/Frameworks/Firebird.framework/Resources/bin/isql",
        help="Ruta del ejecutable isql",
    )
    parser.add_argument("--user", default="sysdba", help="Usuario Firebird")
    parser.add_argument("--password", default="masterkey", help="Password Firebird")
    parser.add_argument(
        "--with-catalogs",
        action="store_true",
        help="Incluye scripts de catalogo 066/067/068 antes de los chunks",
    )
    parser.add_argument(
        "--root",
        default="/Users/wilsonjonatan/Documents/bases 1 2026/violencia guate",
        help="Raiz del repositorio para ubicar catalogos por defecto",
    )
    return parser.parse_args()


def build_script(chunks_dir: Path, with_catalogs: bool, root: Path) -> str:
    chunk_files = sorted(chunks_dir.glob("110_agraviados_part_*.sql"))
    if not chunk_files:
        raise FileNotFoundError(f"No se encontraron chunks en {chunks_dir}")

    lines = ["SET ECHO OFF;"]
    if with_catalogs:
        lines.extend(
            [
                f"INPUT '{(root / 'sql/inserts/catalogos/066_clasificacion_delito_agraviados.sql').as_posix()}';",
                f"INPUT '{(root / 'sql/inserts/catalogos/067_delito_agraviados.sql').as_posix()}';",
                f"INPUT '{(root / 'sql/inserts/catalogos/068_delito_cometido_agraviados.sql').as_posix()}';",
            ]
        )

    for chunk in chunk_files:
        lines.append(f"INPUT '{chunk.as_posix()}';")

    lines.append("QUIT;")
    return "\n".join(lines) + "\n"


def main() -> int:
    args = parse_args()
    chunks_dir = Path(args.chunks_dir).expanduser().resolve()
    root = Path(args.root).expanduser().resolve()

    script_content = build_script(chunks_dir, args.with_catalogs, root)
    with tempfile.NamedTemporaryFile(mode="w", suffix="_agr_fast.sql", delete=False, encoding="utf-8") as tmp:
        tmp.write(script_content)
        tmp_path = Path(tmp.name)

    cmd = [
        args.isql,
        "-user",
        args.user,
        "-password",
        args.password,
        args.db,
        "-q",
        "-i",
        str(tmp_path),
    ]

    started = time.perf_counter()
    try:
        print(f"Cargando desde: {chunks_dir}")
        print(f"Catalogos incluidos: {'si' if args.with_catalogs else 'no'}")
        result = subprocess.run(cmd, check=False)
        elapsed = time.perf_counter() - started
        print(f"Tiempo total: {elapsed:.2f}s")
        return result.returncode
    finally:
        try:
            tmp_path.unlink(missing_ok=True)
        except Exception:
            pass


if __name__ == "__main__":
    raise SystemExit(main())
