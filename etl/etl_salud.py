#!/usr/bin/env python3
"""ETL para cargar catálogos y hechos de salud en Firebird.

Este script está diseñado para:
- leer CSV con csv.DictReader de forma agnóstica al orden de columnas,
- cargar en memoria los catálogos de referencia existentes,
- insertar datos de `tipo_diagnostico`, `diagnostico` y `persona_diagnostico`,
- usar batches de 10.000 filas para inserciones masivas,
- mantener el control manual del ID de la tabla de hechos y sincronizar el generador.
"""

from __future__ import annotations

import csv
import difflib
import logging
import random
import re
import unicodedata
from collections import Counter, defaultdict
from datetime import datetime, date
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional, Tuple

from firebird.driver import connect as fb_connect

BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "datos_base" / "Salud"
DB_PATH = BASE_DIR / "sql" / "db" / "violencia_guate.fdb"
DSN = f"localhost:{DB_PATH}"
BATCH_SIZE = 10_000

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)
logger = logging.getLogger(__name__)


def normalize_text(value: Optional[str]) -> str:
    if value is None:
        return ""
    text = str(value).strip()
    text = unicodedata.normalize("NFKD", text)
    text = "".join(ch for ch in text if not unicodedata.combining(ch))
    return text.upper().replace("\r", "").replace("\n", "").strip()


def simplify_name(value: Optional[str]) -> str:
    base = normalize_text(value)
    base = re.sub(r"[^A-Z0-9]+", " ", base)
    tokens = [token for token in base.split() if token not in {"DE", "DEL", "LA", "LAS", "LOS", "EL", "Y", "EN", "AL"}]
    return " ".join(tokens)


def detect_csv_dialect(path: Path) -> csv.Dialect:
    with path.open("r", newline="", encoding="utf-8-sig") as handle:
        sample = handle.read(4096)
        if not sample:
            raise ValueError(f"CSV file {path} está vacío")
        try:
            dialect = csv.Sniffer().sniff(sample, delimiters=",;\t")
        except csv.Error:
            dialect = csv.get_dialect("excel")
        return dialect


def iterate_csv_rows(path: Path) -> Iterable[Dict[str, str]]:
    dialect = detect_csv_dialect(path)
    with path.open("r", newline="", encoding="utf-8-sig") as handle:
        reader = csv.DictReader(handle, dialect=dialect)
        for row in reader:
            yield {normalize_text(k): (v or "").strip() for k, v in row.items()}


def connect_db() -> Any:
    return fb_connect(database=DSN, user="sysdba", password="masterkey")


def load_reference_maps(cursor: Any) -> Tuple[
    Dict[str, int],
    Dict[str, int],
    Dict[Tuple[str, str], int],
    Dict[Tuple[str, str], int],
    Dict[str, List[Tuple[str, int]]],
    Dict[str, List[int]],
    Dict[str, int],
]:
    genero_map = {}
    for row in cursor.execute("SELECT id_genero, nombre FROM genero"):
        genero_map[normalize_text(row[1])] = int(row[0])

    area_geo_map = {}
    for row in cursor.execute("SELECT id_area_geografica, nombre FROM area_geografica"):
        area_geo_map[normalize_text(row[1])] = int(row[0])

    departamento_names: Dict[int, str] = {}
    for row in cursor.execute("SELECT id_departamento, nombre FROM departamento"):
        departamento_names[int(row[0])] = normalize_text(row[1])

    municipio_map: Dict[Tuple[str, str], int] = {}
    municipio_simple_map: Dict[Tuple[str, str], int] = {}
    dept_muni_list: Dict[str, List[Tuple[str, int]]] = defaultdict(list)
    muni_only_map: Dict[str, List[int]] = defaultdict(list)
    for row in cursor.execute(
        "SELECT m.id_municipio, m.nombre, d.nombre FROM municipio m JOIN departamento d ON m.id_departamento = d.id_departamento"
    ):
        dept = normalize_text(row[2])
        muni = normalize_text(row[1])
        key = (dept, muni)
        municipio_map[key] = int(row[0])
        simplified = simplify_name(muni)
        if simplified:
            municipio_simple_map[(dept, simplified)] = int(row[0])
            dept_muni_list[dept].append((simplified, int(row[0])))
            muni_only_map[simplified].append(int(row[0]))

    return (
        genero_map,
        area_geo_map,
        municipio_map,
        municipio_simple_map,
        dept_muni_list,
        muni_only_map,
        departamento_names,
    )


def table_is_empty(cursor: Any, table_name: str) -> bool:
    cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
    return int(cursor.fetchone()[0]) == 0


def insert_tipo_diagnostico(cursor: Any) -> None:
    path = DATA_DIR / "tipo_diagnostico.csv"
    rows = []
    seen_ids = set()
    for row in iterate_csv_rows(path):
        tipo_id = int(row.get("ID", row.get("ID_TIPO_DIAGNOSTICO", "0")) or "0")
        if tipo_id <= 0:
            continue
        seen_ids.add(tipo_id)
        rows.append((tipo_id, row.get("NOMBRE", ""), row.get("DESCRIPCION", "")))

    if not rows:
        logger.warning("No se encontraron filas en %s", path)
        return

    if table_is_empty(cursor, "TIPO_DIAGNOSTICO"):
        cursor.executemany(
            "INSERT INTO TIPO_DIAGNOSTICO (ID_TIPO_DIAGNOSTICO, NOMBRE, DESCRIPCION) VALUES (?, ?, ?)",
            rows,
        )
        logger.info("Insertados %d filas en TIPO_DIAGNOSTICO", len(rows))
    else:
        logger.info("TIPO_DIAGNOSTICO ya tiene datos, se omite la carga inicial")

    # Verificar tipos faltantes que aparecen en catalogo_diagnosticos.csv.
    expected_tipos = set()
    for row in iterate_csv_rows(DATA_DIR / "catalogo_diagnosticos.csv"):
        tipo_id = int(row.get("ID_TIPO_DIAGNOSTICO", "0") or "0")
        if tipo_id > 0:
            expected_tipos.add(tipo_id)

    missing = expected_tipos - seen_ids
    if missing:
        placeholder_rows = [
            (tipo_id, f"TIPO_DIAGNOSTICO_{tipo_id}", "CARGA PLACEHOLDER DESDE catalogo_diagnosticos.csv")
            for tipo_id in sorted(missing)
        ]
        cursor.executemany(
            "INSERT INTO TIPO_DIAGNOSTICO (ID_TIPO_DIAGNOSTICO, NOMBRE, DESCRIPCION) VALUES (?, ?, ?)",
            placeholder_rows,
        )
        logger.warning("Insertados %d tipos de diagnóstico faltantes como placeholders: %s", len(placeholder_rows), sorted(missing))


def insert_diagnostico(cursor: Any) -> None:
    path = DATA_DIR / "catalogo_diagnosticos.csv"
    rows = []
    for row in iterate_csv_rows(path):
        diag_id = int(row.get("ID", "0") or "0")
        if diag_id <= 0:
            continue
        rows.append(
            (
                diag_id,
                row.get("NOMBRE", ""),
                row.get("CIE-10", row.get("CIE_10", "")),
                int(row.get("ID_TIPO_DIAGNOSTICO", "0") or "0"),
            )
        )

    if not rows:
        logger.warning("No se encontraron filas en %s", path)
        return

    if table_is_empty(cursor, "DIAGNOSTICO"):
        cursor.executemany(
            "INSERT INTO DIAGNOSTICO (ID_DIAGNOSTICO, NOMBRE, CIE_10, ID_TIPO_DIAGNOSTICO) VALUES (?, ?, ?, ?)",
            rows,
        )
        logger.info("Insertados %d filas en DIAGNOSTICO", len(rows))
    else:
        logger.info("DIAGNOSTICO ya tiene datos, se omite la carga inicial")


def load_diagnostico_lookup(cursor: Any) -> Tuple[Dict[str, int], Dict[str, int]]:
    cie_map = {}
    name_map = {}
    for row in cursor.execute("SELECT id_diagnostico, cie_10, nombre FROM diagnostico"):
        diag_id = int(row[0])
        cie_key = normalize_text(row[1])
        name_key = normalize_text(row[2])
        if cie_key:
            cie_map[cie_key] = diag_id
        if name_key:
            name_map[name_key] = diag_id
    return cie_map, name_map


def resolve_genero(gender_value: str, genero_map: Dict[str, int]) -> int:
    value = normalize_text(gender_value)
    if not value:
        return genero_map.get("IGNORADO", 3)
    if value in {"M", "H", "HOMBRE", "MASCULINO"}:
        return genero_map.get("HOMBRE", genero_map.get("1", 1))
    if value in {"F", "MUJER", "FEMENINO", "FEMININO"}:
        return genero_map.get("MUJER", genero_map.get("2", 2))
    return genero_map.get(value, genero_map.get("IGNORADO", 3))


def resolve_municipio(
    department: str,
    municipality: str,
    municipio_map: Dict[Tuple[str, str], int],
    municipio_simple_map: Dict[Tuple[str, str], int],
    dept_muni_list: Dict[str, List[Tuple[str, int]]],
    muni_only_map: Dict[str, List[int]],
) -> Optional[int]:
    dept_key = normalize_text(department)
    muni_key = normalize_text(municipality)
    if not muni_key:
        return None

    if dept_key and (dept_key, muni_key) in municipio_map:
        return municipio_map[(dept_key, muni_key)]

    simplified = simplify_name(muni_key)
    if dept_key and simplified and (dept_key, simplified) in municipio_simple_map:
        return municipio_simple_map[(dept_key, simplified)]

    if simplified and simplified in muni_only_map and len(muni_only_map[simplified]) == 1:
        return muni_only_map[simplified][0]

    if dept_key and simplified and dept_key in dept_muni_list:
        candidates = [name for name, _ in dept_muni_list[dept_key]]
        match = difflib.get_close_matches(simplified, candidates, n=1, cutoff=0.85)
        if match:
            return municipio_simple_map.get((dept_key, match[0]))

    if simplified:
        match = difflib.get_close_matches(simplified, list(muni_only_map.keys()), n=1, cutoff=0.9)
        if match and len(muni_only_map[match[0]]) == 1:
            return muni_only_map[match[0]][0]

    return None


def resolve_diagnostico(cie_value: str, name_value: str, cie_map: Dict[str, int], name_map: Dict[str, int]) -> Optional[int]:
    cie_key = normalize_text(cie_value)
    if cie_key and cie_key in cie_map:
        return cie_map[cie_key]
    name_key = normalize_text(name_value)
    if name_key and name_key in name_map:
        return name_map[name_key]
    return None


def parse_year_as_date(year_value: str) -> Optional[date]:
    year = normalize_text(year_value)
    if not year:
        return None
    if year.isdigit() and len(year) == 4:
        return date(int(year), 1, 1)
    try:
        return date(int(year[:4]), 1, 1)
    except ValueError:
        return None


def extract_year_value(row: Dict[str, str], path: Path) -> Optional[str]:
    for key in ("ANO", "ANIO", "YEAR"):
        value = row.get(key)
        if value:
            return value

    match = re.search(r"(19|20)\d{2}", path.name)
    if match:
        return match.group(0)
    return None


def build_fact_file_list() -> List[Path]:
    excluded = {"tipo_diagnostico.csv", "catalogo_diagnosticos.csv", "are_geografica.csv"}
    return sorted(
        [p for p in DATA_DIR.rglob("*.csv") if p.name not in excluded],
        key=lambda p: str(p).lower(),
    )


def insert_persona_diagnostico_rows(
    cursor: Any,
    rows: List[Tuple[int, int, int, int, int, Optional[int], str, Optional[date]]],
) -> None:
    cursor.executemany(
        "INSERT INTO PERSONA_DIAGNOSTICO (ID_PERSONA_DIAGNOSTICO, ID_DIAGNOSTICO, ID_GENERO, ID_MUNICIPIO, ID_AREA_GEOGRAFICA, CANTIDAD, GRUPO_ETARIO, FECHA_DIAGNOSTICO) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        rows,
    )


def process_fact_files(
    cursor: Any,
    genero_map: Dict[str, int],
    area_geo_map: Dict[str, int],
    municipio_map: Dict[Tuple[str, str], int],
    municipio_simple_map: Dict[Tuple[str, str], int],
    dept_muni_list: Dict[str, List[Tuple[str, int]]],
    muni_only_map: Dict[str, List[int]],
    cie_map: Dict[str, int],
    name_map: Dict[str, int],
) -> None:
    current_id = 0
    cursor.execute("SELECT MAX(id_persona_diagnostico) FROM persona_diagnostico")
    result = cursor.fetchone()
    if result and result[0] is not None:
        current_id = int(result[0])
    dataset_rows: List[Tuple[int, int, int, int, int, Optional[int], str, Optional[date]]] = []
    fact_files = build_fact_file_list()
    area_geo_ids = list(area_geo_map.values())
    if not area_geo_ids:
        raise RuntimeError("No hay IDs de area_geografica cargados en la base de datos")

    for path in fact_files:
        logger.info("Procesando archivo de hechos: %s", path)
        unresolved_diag_count = 0
        unresolved_diag_examples = set()
        unresolved_muni_count = 0
        unresolved_muni_examples = set()
        for row in iterate_csv_rows(path):
            current_id += 1
            id_diagnostico = resolve_diagnostico(
                row.get("CIE-10", ""),
                row.get("DIAGNOSTICO", ""),
                cie_map,
                name_map,
            )
            if id_diagnostico is None:
                unresolved_diag_count += 1
                if len(unresolved_diag_examples) < 5:
                    unresolved_diag_examples.add((row.get("CIE-10", ""), row.get("DIAGNOSTICO", "")))
                continue

            id_genero = resolve_genero(row.get("SEXO", row.get("SEX0", "")), genero_map)
            id_municipio = resolve_municipio(
                row.get("DEPARTAMENTO", ""),
                row.get("MUNICIPIO", ""),
                municipio_map,
                municipio_simple_map,
                dept_muni_list,
                muni_only_map,
            )
            if id_municipio is None:
                unresolved_muni_count += 1
                if len(unresolved_muni_examples) < 5:
                    unresolved_muni_examples.add((row.get("DEPARTAMENTO", ""), row.get("MUNICIPIO", "")))
                continue

            cantidad_txt = row.get("CASOS", row.get("CANTIDAD", "0"))
            cantidad = int(cantidad_txt) if cantidad_txt.isdigit() else None
            grupo_etario = row.get("GRUPO_ETARIO", row.get("GRUPO ETARIO", row.get("GRUPOETARIO", row.get("GRUPO_ETARIO", ""))))
            fecha_diagnostico = parse_year_as_date(extract_year_value(row, path) or "")

            dataset_rows.append(
                (
                    current_id,
                    id_diagnostico,
                    id_genero,
                    id_municipio,
                    random.choice(area_geo_ids),
                    cantidad,
                    grupo_etario,
                    fecha_diagnostico,
                )
            )

            if len(dataset_rows) >= BATCH_SIZE:
                insert_persona_diagnostico_rows(cursor, dataset_rows)
                cursor.connection.commit()
                logger.info("Insertados %d filas en PERSONA_DIAGNOSTICO", len(dataset_rows))
                dataset_rows.clear()

        if unresolved_diag_count:
            logger.warning(
                "Archivo %s: %d filas sin diagnostico mapeado. Ejemplos: %s",
                path.name,
                unresolved_diag_count,
                list(unresolved_diag_examples),
            )
        if unresolved_muni_count:
            logger.warning(
                "Archivo %s: %d filas sin municipio mapeado. Ejemplos: %s",
                path.name,
                unresolved_muni_count,
                list(unresolved_muni_examples),
            )

    if dataset_rows:
        insert_persona_diagnostico_rows(cursor, dataset_rows)
        cursor.connection.commit()
        logger.info("Insertados %d filas finales en PERSONA_DIAGNOSTICO", len(dataset_rows))

    if current_id > 0:
        last_id = current_id
        alter_sql = f"ALTER SEQUENCE GEN_PERSONA_DIAGNOSTICO RESTART WITH {last_id + 1}"
        cursor.execute(alter_sql)
        cursor.connection.commit()
        logger.info("Sincronizado generador GEN_PERSONA_DIAGNOSTICO con el último ID usado: %d", last_id)


def main() -> None:
    logger.info("Iniciando ETL de Salud")
    with connect_db() as connection:
        cursor = connection.cursor()
        insert_tipo_diagnostico(cursor)
        insert_diagnostico(cursor)
        connection.commit()

        (
            genero_map,
            area_geo_map,
            municipio_map,
            municipio_simple_map,
            dept_muni_list,
            muni_only_map,
            _,
        ) = load_reference_maps(cursor)
        cie_map, name_map = load_diagnostico_lookup(cursor)

        process_fact_files(
            cursor,
            genero_map,
            area_geo_map,
            municipio_map,
            municipio_simple_map,
            dept_muni_list,
            muni_only_map,
            cie_map,
            name_map,
        )

    logger.info("ETL finalizado")


if __name__ == "__main__":
    main()
