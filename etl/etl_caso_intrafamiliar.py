#!/usr/bin/env python3
"""Carga de violencia intrafamiliar (2023 + 2024) a CASO_INTRAFAMILIAR.

Campos fuente usados:
- HEC_DIA
- HEC_MES
- HEC_ANO
- HEC_DEPTOMCPIO
- VIC_SEXO
- VIC_EDAD
- TOTAL_HIJOS
"""

from __future__ import annotations

from datetime import date
from pathlib import Path
from typing import Dict, Optional, Tuple
import unicodedata

import pandas as pd
from firebird.driver import connect

BASE_DIR = Path(__file__).resolve().parent.parent
DB_DSN = f"localhost:{BASE_DIR / 'sql' / 'db' / 'violencia_guate.fdb'}"
DB_USER = "sysdba"
DB_PASSWORD = "masterkey"

FILES = [
    BASE_DIR / "datos_base" / "Violencia" / "Violencia intrafamiliar" / "2023" / "violencia_intrafamiliar.xlsx",
    BASE_DIR / "datos_base" / "Violencia" / "Violencia intrafamiliar" / "2024" / "base-de-datos-violencia-intrafamiliar-ano-2024_v3.xlsx",
]

MUNICIPIOS_DICC = (
    BASE_DIR
    / "datos_base"
    / "Violencia"
    / "Violencia intrafamiliar"
    / "2023"
    / "municipios_diccionario.txt"
)

SOURCE_COLS = [
    "HEC_DIA",
    "HEC_MES",
    "HEC_ANO",
    "HEC_DEPTOMCPIO",
    "VIC_SEXO",
    "VIC_EDAD",
    "TOTAL_HIJOS",
]


def norm(value: object) -> str:
    if value is None:
        return ""
    text = str(value).strip()
    text = unicodedata.normalize("NFKD", text)
    text = "".join(ch for ch in text if not unicodedata.combining(ch))
    return " ".join(text.upper().split())


def to_int(value: object) -> Optional[int]:
    if value is None:
        return None
    if isinstance(value, float) and pd.isna(value):
        return None
    text = str(value).strip()
    if not text:
        return None
    try:
        return int(float(text))
    except ValueError:
        return None


def parse_fecha(anio: object, mes: object, dia: object) -> Optional[date]:
    y = to_int(anio)
    m = to_int(mes)
    d = to_int(dia)
    if y is None or m is None or d is None:
        return None
    if y < 1900 or y > 2100 or m < 1 or m > 12 or d < 1 or d > 31:
        return None
    try:
        return date(y, m, d)
    except ValueError:
        return None


def parse_diccionario(path: Path) -> Dict[int, str]:
    mapping: Dict[int, str] = {}
    for line in path.read_text(encoding="utf-8", errors="ignore").splitlines():
        line = line.strip()
        if not line:
            continue
        parts = line.split("\t", 1)
        if len(parts) != 2:
            continue
        code = to_int(parts[0])
        if code is None:
            continue
        mapping[code] = parts[1].strip()
    return mapping


def resolve_genero_id(raw: object) -> Optional[int]:
    value = to_int(raw)
    if value in (1, 2):
        return value

    key = norm(raw)
    if key.startswith("H"):
        return 1
    if key.startswith("M"):
        return 2
    return None


def unknown_to_none(value: Optional[int]) -> Optional[int]:
    if value is None:
        return None
    if value in (99, 999, 9999):
        return None
    return value


def ensure_table(cur) -> None:
    cur.execute(
        "SELECT COUNT(*) FROM rdb$relations WHERE rdb$system_flag = 0 AND TRIM(rdb$relation_name) = 'CASO_INTRAFAMILIAR'"
    )
    exists = int(cur.fetchone()[0])
    if exists:
        return

    cur.execute(
        """
        CREATE TABLE CASO_INTRAFAMILIAR (
            ID_CASO_INTRAFAMILIAR INTEGER NOT NULL,
            ID_MUNICIPIO INTEGER NOT NULL,
            ID_GENERO INTEGER,
            FECHA DATE,
            CANTIDAD_PERSONAS_HOGAR INTEGER,
            EDAD INTEGER,
            CONSTRAINT PK_CASO_INTRAFAMILIAR PRIMARY KEY (ID_CASO_INTRAFAMILIAR),
            CONSTRAINT FK_CASO_INTRAFAMILIAR_MUNI FOREIGN KEY (ID_MUNICIPIO) REFERENCES MUNICIPIO (ID_MUNICIPIO),
            CONSTRAINT FK_CASO_INTRAFAMILIAR_GENERO FOREIGN KEY (ID_GENERO) REFERENCES GENERO (ID_GENERO)
        )
        """
    )


def build_municipio_map(cur, dicc: Dict[int, str]) -> Dict[int, int]:
    cur.execute(
        """
        SELECT m.id_municipio, m.nombre, d.id_departamento, m.codigo
        FROM municipio m
        JOIN departamento d ON d.id_departamento = m.id_departamento
        """
    )

    by_dep_name: Dict[Tuple[int, str], int] = {}
    by_name_only: Dict[str, int] = {}
    by_codigo: Dict[int, int] = {}
    for id_muni, nombre, id_depto, codigo in cur.fetchall():
        name_key = norm(nombre)
        by_dep_name[(int(id_depto), name_key)] = int(id_muni)
        by_name_only.setdefault(name_key, int(id_muni))
        code_int = to_int(codigo)
        if code_int is not None:
            by_codigo[code_int] = int(id_muni)

    code_to_db: Dict[int, int] = {}
    for code, name in dicc.items():
        id_muni = by_codigo.get(code)
        if id_muni is not None:
            code_to_db[code] = id_muni
            continue

        depto = code // 100
        key = norm(name)
        id_muni = by_dep_name.get((depto, key))
        if id_muni is None:
            id_muni = by_name_only.get(key)
        if id_muni is not None:
            code_to_db[code] = id_muni
    return code_to_db


def read_union_sources() -> pd.DataFrame:
    chunks = []
    for file_path in FILES:
        df = pd.read_excel(file_path, sheet_name=0, usecols=SOURCE_COLS)
        df["__source_file"] = file_path.name
        chunks.append(df)
    return pd.concat(chunks, ignore_index=True)


def main() -> None:
    df = read_union_sources()
    dicc = parse_diccionario(MUNICIPIOS_DICC)

    with connect(database=DB_DSN, user=DB_USER, password=DB_PASSWORD) as con:
        cur = con.cursor()

        ensure_table(cur)
        con.commit()

        municipio_code_to_id = build_municipio_map(cur, dicc)
        fallback_municipio_id = municipio_code_to_id.get(101)
        if fallback_municipio_id is None:
            cur.execute("SELECT ID_MUNICIPIO FROM MUNICIPIO ORDER BY ID_MUNICIPIO ROWS 1")
            row = cur.fetchone()
            fallback_municipio_id = int(row[0]) if row else None

        cur.execute("SELECT COALESCE(MAX(ID_CASO_INTRAFAMILIAR), 0) FROM CASO_INTRAFAMILIAR")
        next_id = int(cur.fetchone()[0])

        # Dedupe on reruns using the same tuple of business fields.
        cur.execute(
            "SELECT ID_MUNICIPIO, ID_GENERO, FECHA, CANTIDAD_PERSONAS_HOGAR, EDAD FROM CASO_INTRAFAMILIAR"
        )
        existing = set(cur.fetchall())

        rows = []
        skipped_muni = 0
        skipped_empty = 0
        skipped_existing = 0

        for _, r in df.iterrows():
            muni_code = to_int(r.get("HEC_DEPTOMCPIO"))
            if muni_code is None:
                skipped_empty += 1
                continue

            id_municipio = municipio_code_to_id.get(muni_code)
            if id_municipio is None and muni_code == 9999:
                id_municipio = fallback_municipio_id
            if id_municipio is None:
                skipped_muni += 1
                continue

            id_genero = resolve_genero_id(r.get("VIC_SEXO"))
            fecha = parse_fecha(r.get("HEC_ANO"), r.get("HEC_MES"), r.get("HEC_DIA"))
            edad = unknown_to_none(to_int(r.get("VIC_EDAD")))
            cant_hogar = unknown_to_none(to_int(r.get("TOTAL_HIJOS")))

            signature = (id_municipio, id_genero, fecha, cant_hogar, edad)
            if signature in existing:
                skipped_existing += 1
                continue

            next_id += 1
            rows.append((next_id, id_municipio, id_genero, fecha, cant_hogar, edad))
            existing.add(signature)

        if rows:
            cur.executemany(
                """
                INSERT INTO CASO_INTRAFAMILIAR (
                    ID_CASO_INTRAFAMILIAR,
                    ID_MUNICIPIO,
                    ID_GENERO,
                    FECHA,
                    CANTIDAD_PERSONAS_HOGAR,
                    EDAD
                ) VALUES (?, ?, ?, ?, ?, ?)
                """,
                rows,
            )
        con.commit()

    print(f"rows_source={len(df)}")
    print(f"rows_inserted={len(rows)}")
    print(f"skipped_existing={skipped_existing}")
    print(f"skipped_no_municipio={skipped_muni}")
    print(f"skipped_empty_code={skipped_empty}")


if __name__ == "__main__":
    main()
