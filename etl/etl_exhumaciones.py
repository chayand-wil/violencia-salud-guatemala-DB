#!/usr/bin/env python3
"""Carga exhumaciones a UBICACION -> HECHO -> HECHO_DELICTIVO -> EXHUMACION.

Reglas aplicadas:
- HECHO.id_tipo_hecho = 3
- HECHO_DELICTIVO.id_delito = ID aleatorio existente en DELITO_COMETIDO
- UBICACION.id_municipio = primer municipio del departamento (min id_municipio)
- UBICACION.id_area_geografica = 3
- UBICACION.ciudad/zona/direccion_referencia = ''
"""

from __future__ import annotations

import random
import unicodedata
from datetime import date
from pathlib import Path
from typing import Dict, List, Tuple

import pandas as pd
from firebird.driver import connect

BASE_DIR = Path(__file__).resolve().parent.parent
EXCEL_PATH = BASE_DIR / "datos_base" / "Violencia" / "Hechos-Delicitivos" / "Exhumaciones" / "exhumaciones.xlsx"
DB_DSN = f"localhost:{BASE_DIR / 'sql' / 'db' / 'violencia_guate.fdb'}"

TIPO_HECHO_EXHUMACION = 3
AREA_GEOGRAFICA_IGNORADO = 3

MONTH_MAP = {
    "ENERO": 1,
    "FEBRERO": 2,
    "MARZO": 3,
    "ABRIL": 4,
    "MAYO": 5,
    "JUNIO": 6,
    "JULIO": 7,
    "AGOSTO": 8,
    "SEPTIEMBRE": 9,
    "SETIEMBRE": 9,
    "OCTUBRE": 10,
    "NOVIEMBRE": 11,
    "DICIEMBRE": 12,
}


def normalize_text(value: str) -> str:
    text = str(value).strip()
    text = unicodedata.normalize("NFKD", text)
    text = "".join(ch for ch in text if not unicodedata.combining(ch))
    return text.upper()


def parse_fecha(anio: object, mes: object, dia: object) -> date | None:
    try:
        y = int(anio)
    except (TypeError, ValueError):
        return None

    m = MONTH_MAP.get(normalize_text(mes))
    if m is None:
        return None

    try:
        d = int(dia)
    except (TypeError, ValueError):
        return None

    try:
        return date(y, m, d)
    except ValueError:
        return None


def get_first_municipio_by_departamento(cur) -> Dict[str, int]:
    query = """
        SELECT d.nombre, MIN(m.id_municipio) AS id_municipio
        FROM departamento d
        JOIN municipio m ON m.id_departamento = d.id_departamento
        GROUP BY d.nombre
    """
    mapping: Dict[str, int] = {}
    for dep_name, id_municipio in cur.execute(query):
        mapping[normalize_text(dep_name)] = int(id_municipio)
    return mapping


def get_random_delito_pool(cur) -> List[int]:
    ids = [int(row[0]) for row in cur.execute("SELECT id_delito_cometido FROM delito_cometido")]
    if not ids:
        raise RuntimeError("No hay IDs en DELITO_COMETIDO para asignar a HECHO_DELICTIVO")
    return ids


def next_id(cur, table: str, pk: str) -> int:
    cur.execute(f"SELECT COALESCE(MAX({pk}), 0) FROM {table}")
    return int(cur.fetchone()[0])


def main() -> None:
    xls = pd.ExcelFile(EXCEL_PATH)
    frames = []
    for sheet in xls.sheet_names:
        df = xls.parse(sheet)
        if df.empty:
            continue
        df = df.rename(columns={c: normalize_text(c) for c in df.columns})
        frames.append(df)

    if not frames:
        print("No hay datos para cargar en el archivo de exhumaciones.")
        return

    df_all = pd.concat(frames, ignore_index=True)

    with connect(database=DB_DSN, user="sysdba", password="masterkey") as con:
        cur = con.cursor()

        municipio_por_dep = get_first_municipio_by_departamento(cur)
        delito_pool = get_random_delito_pool(cur)

        id_ubicacion = next_id(cur, "UBICACION", "ID_UBICACION")
        id_hecho = next_id(cur, "HECHO", "ID_HECHO")
        id_hecho_delictivo = next_id(cur, "HECHO_DELICTIVO", "ID_HECHO_DELICTIVO")
        id_exhumacion = next_id(cur, "EXHUMACION", "ID_EXHUMACION")

        rows_ubicacion: List[Tuple[int, int, int, str, str, str]] = []
        rows_hecho: List[Tuple[int, int, int, date | None]] = []
        rows_hecho_delictivo: List[Tuple[int, int, int]] = []
        rows_exhumacion: List[Tuple[int, int]] = []

        skipped = 0

        for _, row in df_all.iterrows():
            dep_key = normalize_text(row.get("DEPTO_OCU", ""))
            id_municipio = municipio_por_dep.get(dep_key)
            if id_municipio is None:
                skipped += 1
                continue

            fecha = parse_fecha(row.get("ANO_OCU"), row.get("MES_OCU"), row.get("DIA_OCU"))
            if fecha is None:
                skipped += 1
                continue

            id_ubicacion += 1
            id_hecho += 1
            id_hecho_delictivo += 1
            id_exhumacion += 1

            rows_ubicacion.append(
                (
                    id_ubicacion,
                    id_municipio,
                    AREA_GEOGRAFICA_IGNORADO,
                    "",
                    "",
                    "",
                )
            )
            rows_hecho.append((id_hecho, TIPO_HECHO_EXHUMACION, id_ubicacion, fecha))
            rows_hecho_delictivo.append((id_hecho_delictivo, id_hecho, random.choice(delito_pool)))
            rows_exhumacion.append((id_exhumacion, id_hecho))

        cur.executemany(
            "INSERT INTO UBICACION (ID_UBICACION, ID_MUNICIPIO, ID_AREA_GEOGRAFICA, CIUDAD, ZONA, DIRECCION_REFERENCIA) VALUES (?, ?, ?, ?, ?, ?)",
            rows_ubicacion,
        )
        cur.executemany(
            "INSERT INTO HECHO (ID_HECHO, ID_TIPO_HECHO, ID_UBICACION, FECHA_HECHO) VALUES (?, ?, ?, ?)",
            rows_hecho,
        )
        cur.executemany(
            "INSERT INTO HECHO_DELICTIVO (ID_HECHO_DELICTIVO, ID_HECHO, ID_DELITO) VALUES (?, ?, ?)",
            rows_hecho_delictivo,
        )
        cur.executemany(
            "INSERT INTO EXHUMACION (ID_EXHUMACION, ID_HECHO) VALUES (?, ?)",
            rows_exhumacion,
        )

        con.commit()

    print(f"Filas fuente: {len(df_all)}")
    print(f"Filas cargadas: {len(rows_hecho)}")
    print(f"Filas omitidas: {skipped}")


if __name__ == "__main__":
    main()
