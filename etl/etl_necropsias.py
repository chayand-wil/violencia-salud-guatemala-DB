#!/usr/bin/env python3
"""ETL Necropsias.

Flow per source row:
UBICACION -> HECHO -> PERSONA -> NECROPSIA -> INVOLUCRADO_HECHO

Rules:
- HECHO.id_tipo_hecho = 1
- INVOLUCRADO_HECHO.id_tipo_involucramiento = 14
- FECHA_HECHO from anio_ing/mes_ing/dia_ing
- PERSONA.id_origen uses same UBICACION as HECHO.id_ubicacion
- PERSONA names generated with Faker
- area_geografica can be NULL
- missing optional fields can be NULL/empty
- NECROPSIA uses normalized id_causa_muerte
"""

from __future__ import annotations

import unicodedata
from dataclasses import dataclass
from datetime import date
from pathlib import Path
from random import randint
from typing import Dict, Iterable, List, Optional, Tuple

import pandas as pd
from faker import Faker
from firebird.driver import connect

BASE_DIR = Path(__file__).resolve().parent.parent
EXCEL_PATH = BASE_DIR / "datos_base" / "Violencia" / "Hechos-Delicitivos" / "Necropsias" / "necropsias.xlsx"
DB_DSN = f"localhost:{BASE_DIR / 'sql' / 'db' / 'violencia_guate.fdb'}"
DB_USER = "sysdba"
DB_PASSWORD = "masterkey"

TIPO_HECHO_NECROPSIA = 1
TIPO_INVOLUCRAMIENTO = 14

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


@dataclass
class DefaultsPersona:
    id_orientacion: Optional[int]
    id_grupo: Optional[int]
    id_estado_civil: Optional[int]
    id_alfabetica: Optional[int]
    id_escolaridad: Optional[int]


def normalize_text(value: object) -> str:
    if value is None:
        return ""
    text = str(value).strip()
    text = unicodedata.normalize("NFKD", text)
    text = "".join(ch for ch in text if not unicodedata.combining(ch))
    return " ".join(text.upper().split())


def clean_text(value: object) -> str:
    if value is None or (isinstance(value, float) and pd.isna(value)):
        return ""
    return " ".join(str(value).strip().split())


def safe_int(value: object) -> Optional[int]:
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
    year = safe_int(anio)
    if year is None or year < 1900 or year > 2100:
        return None

    month_text = normalize_text(mes)
    month = MONTH_MAP.get(month_text)
    if month is None:
        month_number = safe_int(mes)
        if month_number is None:
            return None
        month = max(1, min(12, month_number))

    day = safe_int(dia)
    if day is None:
        return None
    day = max(1, min(28, day))

    try:
        return date(year, month, day)
    except ValueError:
        return None


def detect_gender_id(raw: object, genero_by_name: Dict[str, int], id_ignorado: Optional[int]) -> Optional[int]:
    text = normalize_text(raw)
    if text.startswith("H") or "MASC" in text:
        return genero_by_name.get("HOMBRE", id_ignorado)
    if text.startswith("M") or "FEM" in text:
        return genero_by_name.get("MUJER", id_ignorado)
    return id_ignorado


def derive_birth_date(fecha_hecho: Optional[date], edad: Optional[int]) -> Optional[date]:
    if fecha_hecho is None or edad is None:
        return None
    edad = max(0, min(110, edad))
    year = fecha_hecho.year - edad
    try:
        return date(year, fecha_hecho.month, fecha_hecho.day)
    except ValueError:
        return date(year, 1, 1)


def get_max_id(cur, table: str, field: str) -> int:
    cur.execute(f"SELECT COALESCE(MAX({field}), 0) FROM {table}")
    return int(cur.fetchone()[0])


def get_unknown_or_first(cur, table: str, id_col: str, name_col: str, candidates: Iterable[str]) -> Optional[int]:
    for cand in candidates:
        cur.execute(
            f"SELECT {id_col} FROM {table} WHERE UPPER(TRIM({name_col})) = ? ROWS 1",
            (cand.upper(),),
        )
        row = cur.fetchone()
        if row:
            return int(row[0])
    cur.execute(f"SELECT {id_col} FROM {table} ORDER BY {id_col} ROWS 1")
    row = cur.fetchone()
    return int(row[0]) if row else None


def ensure_schema(cur) -> None:
    cur.execute(
        "SELECT COUNT(*) FROM rdb$relations WHERE rdb$system_flag = 0 AND TRIM(rdb$relation_name) = 'CAUSA_MUERTE'"
    )
    if int(cur.fetchone()[0]) == 0:
        cur.execute(
            """
            CREATE TABLE CAUSA_MUERTE (
                ID_CAUSA_MUERTE INTEGER NOT NULL,
                NOMBRE VARCHAR(255) NOT NULL,
                DESCRIPCION VARCHAR(255),
                CONSTRAINT PK_CAUSA_MUERTE PRIMARY KEY (ID_CAUSA_MUERTE)
            )
            """
        )

    cur.execute(
        """
        SELECT COUNT(*)
        FROM rdb$relation_fields
        WHERE TRIM(rdb$relation_name) = 'NECROPSIA'
          AND TRIM(rdb$field_name) = 'ID_CAUSA_MUERTE'
        """
    )
    if int(cur.fetchone()[0]) == 0:
        cur.execute("ALTER TABLE NECROPSIA ADD ID_CAUSA_MUERTE INTEGER")

    cur.execute(
        """
        SELECT COUNT(*)
        FROM rdb$relation_constraints
        WHERE TRIM(rdb$constraint_name) = 'FK_NECROPSIA_CAUSA_MUERTE'
        """
    )
    if int(cur.fetchone()[0]) == 0:
        cur.execute(
            "ALTER TABLE NECROPSIA ADD CONSTRAINT FK_NECROPSIA_CAUSA_MUERTE FOREIGN KEY (ID_CAUSA_MUERTE) REFERENCES CAUSA_MUERTE (ID_CAUSA_MUERTE)"
        )

    cur.execute("SELECT COUNT(*) FROM rdb$indices WHERE TRIM(rdb$index_name) = 'IDX_CAUSA_MUERTE_NOMBRE'")
    if int(cur.fetchone()[0]) == 0:
        cur.execute("CREATE INDEX IDX_CAUSA_MUERTE_NOMBRE ON CAUSA_MUERTE (NOMBRE)")

    cur.execute("SELECT COUNT(*) FROM rdb$indices WHERE TRIM(rdb$index_name) = 'IDX_NECROPSIA_CAUSA_MUERTE'")
    if int(cur.fetchone()[0]) == 0:
        cur.execute("CREATE INDEX IDX_NECROPSIA_CAUSA_MUERTE ON NECROPSIA (ID_CAUSA_MUERTE)")


def load_municipios(cur) -> Tuple[Dict[Tuple[str, str], int], Dict[str, int]]:
    cur.execute(
        """
        SELECT d.nombre, m.nombre, m.id_municipio
        FROM departamento d
        JOIN municipio m ON m.id_departamento = d.id_departamento
        ORDER BY d.id_departamento, m.id_municipio
        """
    )
    by_pair: Dict[Tuple[str, str], int] = {}
    first_by_dep: Dict[str, int] = {}
    for dep, muni, id_muni in cur.fetchall():
        dep_k = normalize_text(dep)
        muni_k = normalize_text(muni)
        by_pair[(dep_k, muni_k)] = int(id_muni)
        if dep_k not in first_by_dep:
            first_by_dep[dep_k] = int(id_muni)
    return by_pair, first_by_dep


def load_generos(cur) -> Tuple[Dict[str, int], Optional[int]]:
    cur.execute("SELECT id_genero, nombre FROM genero")
    by_name: Dict[str, int] = {}
    for id_genero, nombre in cur.fetchall():
        by_name[normalize_text(nombre)] = int(id_genero)
    id_ignorado = by_name.get("IGNORADO")
    if id_ignorado is None and by_name:
        id_ignorado = sorted(by_name.values())[0]
    return by_name, id_ignorado


def load_existing_causas(cur) -> Dict[str, int]:
    cur.execute("SELECT id_causa_muerte, nombre FROM causa_muerte")
    result: Dict[str, int] = {}
    for id_causa, nombre in cur.fetchall():
        result[normalize_text(nombre)] = int(id_causa)
    return result


def load_defaults_persona(cur) -> DefaultsPersona:
    return DefaultsPersona(
        id_orientacion=get_unknown_or_first(cur, "orientacion_sexual", "id_orientacion_sexual", "nombre", ["IGNORADO", "SIN SELECCION", "SD"]),
        id_grupo=get_unknown_or_first(cur, "grupo_etnico", "id_grupo_etnico", "nombre", ["IGNORADO", "SIN SELECCION", "SD"]),
        id_estado_civil=get_unknown_or_first(cur, "estado_civil", "id_estado_civil", "nombre", ["IGNORADO"]),
        id_alfabetica=get_unknown_or_first(cur, "condicion_alfabetica", "id_condicion_alfabetica", "nombre", ["IGNORADO"]),
        id_escolaridad=get_unknown_or_first(cur, "nivel_escolaridad", "id_nivel_escolaridad", "nombre", ["IGNORADO", "NO REGISTRADO"]),
    )


def build_source_df() -> pd.DataFrame:
    xls = pd.ExcelFile(EXCEL_PATH)
    frames: List[pd.DataFrame] = []
    for sheet in xls.sheet_names:
        df = xls.parse(sheet)
        if df.empty:
            continue
        df = df.rename(columns=lambda c: normalize_text(c).replace(" ", "_"))
        frames.append(df)

    if not frames:
        return pd.DataFrame()
    return pd.concat(frames, ignore_index=True)


def main() -> None:
    df = build_source_df()
    if df.empty:
        print("No data found in necropsias workbook.")
        return

    faker = Faker("es_ES")
    Faker.seed(20260418)

    with connect(database=DB_DSN, user=DB_USER, password=DB_PASSWORD) as con:
        cur = con.cursor()

        ensure_schema(cur)
        con.commit()

        by_pair, first_by_dep = load_municipios(cur)
        genero_by_name, id_genero_default = load_generos(cur)
        defaults_persona = load_defaults_persona(cur)

        # Idempotency marker: synthetic CUI prefix for this ETL.
        cur.execute("SELECT cui FROM persona WHERE cui STARTING WITH 'NEC-'")
        existing_cui = {row[0] for row in cur.fetchall() if row[0]}

        causas_by_norm = load_existing_causas(cur)
        next_id_causa = get_max_id(cur, "CAUSA_MUERTE", "ID_CAUSA_MUERTE")

        next_id_ubicacion = get_max_id(cur, "UBICACION", "ID_UBICACION")
        next_id_hecho = get_max_id(cur, "HECHO", "ID_HECHO")
        next_id_persona = get_max_id(cur, "PERSONA", "ID_PERSONA")
        next_id_necropsia = get_max_id(cur, "NECROPSIA", "ID_NECROPSIA")
        next_id_involucrado_hecho = get_max_id(cur, "INVOLUCRADO_HECHO", "ID_INVOLUCRADO_HECHO")

        rows_ubicacion: List[Tuple[int, int, Optional[int], str, str, str]] = []
        rows_hecho: List[Tuple[int, int, int, Optional[date]]] = []
        rows_persona: List[Tuple[int, str, str, Optional[date], str, Optional[int], Optional[int], Optional[int], Optional[int], Optional[int], int, int]] = []
        rows_necropsia: List[Tuple[int, int, int, Optional[str], Optional[int]]] = []
        rows_involucrado: List[Tuple[int, int, int, int]] = []

        inserted_causas = 0
        skipped_no_location = 0
        skipped_no_date = 0
        skipped_existing = 0

        for _, row in df.iterrows():
            num_corre = safe_int(row.get("NUM_CORRE")) or safe_int(row.get("NUM_CORRE_")) or safe_int(row.get("NUM_CORREO"))
            if num_corre is None:
                continue

            anio = safe_int(row.get("ANO_ING"))
            if anio is None:
                anio = safe_int(row.get("A_O_ING"))
            fecha_hecho = parse_fecha(row.get("ANO_ING", row.get("A_O_ING")), row.get("MES_ING"), row.get("DIA_ING", row.get("D_A_ING")))
            if fecha_hecho is None:
                skipped_no_date += 1
                continue

            dep_key = normalize_text(row.get("DEPTO_OCU"))
            muni_key = normalize_text(row.get("MUPIO_OCU"))
            id_municipio = by_pair.get((dep_key, muni_key))
            if id_municipio is None and dep_key:
                id_municipio = first_by_dep.get(dep_key)
            if id_municipio is None:
                skipped_no_location += 1
                continue

            cui = f"NEC-{fecha_hecho.year}-{num_corre:07d}"
            if cui in existing_cui:
                skipped_existing += 1
                continue

            causa_raw = clean_text(row.get("CAUSA_MUERTE"))
            id_causa: Optional[int] = None
            if causa_raw:
                causa_norm = normalize_text(causa_raw)
                id_causa = causas_by_norm.get(causa_norm)
                if id_causa is None:
                    next_id_causa += 1
                    id_causa = next_id_causa
                    rows = (id_causa, causa_raw[:255], "Normalizado desde necropsias.xlsx")
                    cur.execute(
                        "INSERT INTO CAUSA_MUERTE (ID_CAUSA_MUERTE, NOMBRE, DESCRIPCION) VALUES (?, ?, ?)",
                        rows,
                    )
                    causas_by_norm[causa_norm] = id_causa
                    inserted_causas += 1

            id_genero = detect_gender_id(row.get("SEXO_PER"), genero_by_name, id_genero_default)
            edad = safe_int(row.get("EDAD_PER"))
            fecha_nacimiento = derive_birth_date(fecha_hecho, edad)

            nombres = faker.first_name()
            apellidos = faker.last_name()

            next_id_ubicacion += 1
            next_id_hecho += 1
            next_id_persona += 1
            next_id_necropsia += 1
            next_id_involucrado_hecho += 1

            rows_ubicacion.append((next_id_ubicacion, id_municipio, None, "", "", ""))
            rows_hecho.append((next_id_hecho, TIPO_HECHO_NECROPSIA, next_id_ubicacion, fecha_hecho))
            rows_persona.append(
                (
                    next_id_persona,
                    nombres,
                    apellidos,
                    fecha_nacimiento,
                    cui,
                    id_genero,
                    defaults_persona.id_orientacion,
                    defaults_persona.id_grupo,
                    defaults_persona.id_estado_civil,
                    defaults_persona.id_alfabetica,
                    defaults_persona.id_escolaridad,
                    next_id_ubicacion,
                    0,
                )
            )
            rows_necropsia.append((next_id_necropsia, next_id_hecho, next_id_persona, causa_raw or None, id_causa))
            rows_involucrado.append((next_id_involucrado_hecho, next_id_hecho, next_id_persona, TIPO_INVOLUCRAMIENTO))
            existing_cui.add(cui)

        if rows_ubicacion:
            cur.executemany(
                "INSERT INTO UBICACION (ID_UBICACION, ID_MUNICIPIO, ID_AREA_GEOGRAFICA, CIUDAD, ZONA, DIRECCION_REFERENCIA) VALUES (?, ?, ?, ?, ?, ?)",
                rows_ubicacion,
            )
            cur.executemany(
                "INSERT INTO HECHO (ID_HECHO, ID_TIPO_HECHO, ID_UBICACION, FECHA_HECHO) VALUES (?, ?, ?, ?)",
                rows_hecho,
            )
            cur.executemany(
                """
                INSERT INTO PERSONA (
                    ID_PERSONA, NOMBRES, APELLIDOS, FECHA_NACIMIENTO, CUI,
                    ID_GENERO, ID_ORIENTACION_SEXUAL, ID_GRUPO_ETNICO,
                    ID_ESTADO_CIVIL, ID_CONDICION_ALFABETICA, ID_NIVEL_ESCOLARIDAD,
                    ID_ORIGEN, ES_EXTRANJERO
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                rows_persona,
            )
            cur.executemany(
                "INSERT INTO NECROPSIA (ID_NECROPSIA, ID_HECHO, ID_PERSONA, CAUSA_MUERTE, ID_CAUSA_MUERTE) VALUES (?, ?, ?, ?, ?)",
                rows_necropsia,
            )
            cur.executemany(
                "INSERT INTO INVOLUCRADO_HECHO (ID_INVOLUCRADO_HECHO, ID_HECHO, ID_INVOLUCRADO, ID_TIPO_INVOLUCRAMIENTO) VALUES (?, ?, ?, ?)",
                rows_involucrado,
            )

        con.commit()

    print(f"source_rows={len(df)}")
    print(f"inserted_rows={len(rows_necropsia)}")
    print(f"inserted_causas={inserted_causas}")
    print(f"skipped_existing={skipped_existing}")
    print(f"skipped_no_location={skipped_no_location}")
    print(f"skipped_no_date={skipped_no_date}")


if __name__ == "__main__":
    main()
