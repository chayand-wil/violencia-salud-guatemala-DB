#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path

import pandas as pd

SRC = Path("datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx")
DEFAULT_CACHE_PICKLE = Path("tmp/cache/agraviados_sheet1.pkl")


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
    "OCTUBRE": 10,
    "NOVIEMBRE": 11,
    "DICIEMBRE": 12,
}

FIRST_NAMES_F = [
    "Maria", "Ana", "Carmen", "Luisa", "Sofia", "Daniela", "Gabriela", "Patricia", "Andrea", "Paola",
    "Carolina", "Valeria", "Monica", "Rosa", "Claudia", "Elena", "Fernanda", "Veronica", "Marta", "Ximena",
]

FIRST_NAMES_M = [
    "Juan", "Carlos", "Jose", "Luis", "Miguel", "Jorge", "Mario", "Pedro", "Ricardo", "Fernando",
    "Oscar", "Rafael", "Alejandro", "Hector", "Roberto", "David", "Edgar", "Manuel", "Diego", "Victor",
]

SURNAMES = [
    "Garcia", "Lopez", "Hernandez", "Martinez", "Gonzalez", "Perez", "Rodriguez", "Ramirez", "Sanchez", "Cruz",
    "Morales", "Diaz", "Castillo", "Vasquez", "Reyes", "Mendez", "Torres", "Flores", "Ruiz", "Chavez",
    "Pineda", "Herrera", "Mendoza", "Aguilar", "Fuentes", "Cabrera", "Guzman", "Cortes", "Escobar", "Ortiz",
]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate staging SQL for Agraviados batches")
    parser.add_argument("--batch", type=int, required=True)
    parser.add_argument("--run-id", type=int, required=True)
    parser.add_argument("--start-index", type=int, required=True)
    parser.add_argument("--row-limit", type=int, default=2000)
    parser.add_argument("--source", type=Path, default=SRC)
    parser.add_argument("--output-root", type=Path, default=Path("."))
    parser.add_argument("--cache-pickle", type=Path, default=DEFAULT_CACHE_PICKLE)
    parser.add_argument("--no-cache", action="store_true")
    return parser.parse_args()


def clean(value) -> str:
    if pd.isna(value):
        return ""
    return str(value).strip()


def norm(value: str) -> str:
    text = clean(value).upper()
    for source, target in (("Á", "A"), ("É", "E"), ("Í", "I"), ("Ó", "O"), ("Ú", "U"), ("Ü", "U"), ("Ñ", "N")):
        text = text.replace(source, target)
    return " ".join(text.split())


def sqlq(value: str) -> str:
    return "'" + str(value).replace("'", "''") + "'"


def safe_int(value, default=0):
    try:
        return int(float(value))
    except Exception:
        return default


def parse_date(year_value, month_value, day_value):
    year = safe_int(year_value, 2023)
    day = max(1, min(28, safe_int(day_value, 1)))
    month_text = norm(month_value)
    if month_text.isdigit():
        month = max(1, min(12, int(month_text)))
    else:
        month = MONTH_MAP.get(month_text, 1)
    return f"{year:04d}-{month:02d}-{day:02d}"


def synth_person_name(corr: int, sex_raw: str) -> tuple[str, str]:
    # Deterministic synthetic names to keep idempotent reruns stable.
    pool = FIRST_NAMES_F if sex_raw.startswith("M") else FIRST_NAMES_M if sex_raw.startswith("H") else FIRST_NAMES_F + FIRST_NAMES_M
    n = max(0, corr - 1)

    i1 = n % len(pool)
    n //= len(pool)
    i2 = n % len(pool)
    n //= len(pool)
    s1 = n % len(SURNAMES)
    n //= len(SURNAMES)
    s2 = n % len(SURNAMES)

    nombres = f"{pool[i1]} {pool[i2]}"
    apellidos = f"{SURNAMES[s1]} {SURNAMES[s2]}"
    return nombres, apellidos


def main() -> int:
    args = parse_args()
    root = args.output_root.expanduser().resolve()
    source = (root / args.source).resolve() if not args.source.is_absolute() else args.source.resolve()
    cache_pickle = (root / args.cache_pickle).resolve() if not args.cache_pickle.is_absolute() else args.cache_pickle.resolve()

    if not args.no_cache and cache_pickle.exists():
        full_df = pd.read_pickle(cache_pickle)
        cache_state = f"hit ({cache_pickle})"
    else:
        full_df = pd.read_excel(source, sheet_name=0)
        if not args.no_cache:
            cache_pickle.parent.mkdir(parents=True, exist_ok=True)
            full_df.to_pickle(cache_pickle)
            cache_state = f"miss->saved ({cache_pickle})"
        else:
            cache_state = "disabled"

    start = max(0, args.start_index)
    end = min(len(full_df), start + args.row_limit)
    df = full_df.iloc[start:end].copy()

    out_dir = root / "sql/inserts/transaccional/staging"
    out_dir.mkdir(parents=True, exist_ok=True)
    out_file = out_dir / f"110_agraviados_stg_batch{args.batch:03d}.sql"

    lines = [
        "SET NAMES UTF8;",
        "",
        f"-- Agraviados staging batch {args.batch}",
        f"-- run_id={args.run_id}",
        f"DELETE FROM stg_agraviados WHERE run_id = {args.run_id};",
        "",
    ]

    inserted = 0
    skipped = 0

    for _, row in df.iterrows():
        corr = safe_int(row.get("núm_corre"), 0)
        if corr <= 0:
            skipped += 1
            continue

        fecha_hecho = parse_date(row.get("año_hecho"), row.get("mes_hecho"), row.get("día_hecho"))
        year_den = safe_int(row.get("año_denuncia"), 2023)
        sex_raw = clean(row.get("sexo_agraviados"))
        age = max(1, min(95, safe_int(row.get("edad_agrav"), 30)))
        birth_year = safe_int(row.get("año_hecho"), 2023) - age
        fecha_nacimiento = f"{birth_year:04d}-06-15"

        depto = clean(row.get("depto_ocu_hecho"))
        muni = clean(row.get("mupio_ocu_hecho"))
        if not depto or not muni:
            skipped += 1
            continue

        zona = clean(row.get("zona_ocu_hecho")) or "Ignorada"
        estado_civil = clean(row.get("est_conyugal")) or "Ignorado"
        delito = clean(row.get("delito_com"))
        clasificacion = clean(row.get("principales_delitos"))
        if not delito or not clasificacion:
            skipped += 1
            continue

        pcode = f"AGR_{year_den}_{corr:06d}"
        person_nombres, person_apellidos = synth_person_name(corr, norm(sex_raw))

        lines.append(
            "INSERT INTO stg_agraviados (run_id, batch_num, source_num_corre, pcode, nombres, apellidos, fecha_nacimiento, fecha_hecho, depto_nombre, muni_nombre, zona, sexo_nombre, estado_civil_nombre, delito_nombre, clasificacion_nombre) "
            "VALUES ("
            f"{args.run_id}, {args.batch}, {corr}, {sqlq(pcode)}, {sqlq(person_nombres)}, {sqlq(person_apellidos)}, {sqlq(fecha_nacimiento)}, {sqlq(fecha_hecho)}, "
            f"{sqlq(depto)}, {sqlq(muni)}, {sqlq(zona)}, {sqlq(sex_raw or 'Ignorado')}, {sqlq(estado_civil)}, {sqlq(delito)}, {sqlq(clasificacion)}"
            ");"
        )
        inserted += 1

    lines.extend(["", "COMMIT;", ""])
    out_file.write_text("\n".join(lines), encoding="utf-8")

    print(f"cache: {cache_state}")
    print(f"staging_file: {out_file}")
    print(f"rows_source: {len(df)}")
    print(f"rows_inserted_staging: {inserted}")
    print(f"rows_skipped: {skipped}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
