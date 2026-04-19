#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
from pathlib import Path

import pandas as pd

SRC = Path("datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx")
MUNI_FILE = Path("catalogos/municipios/municipios- depto.txt")
OUT_CAT_CLASS = Path("sql/inserts/catalogos/066_clasificacion_delito_agraviados.sql")
OUT_CAT_DEL = Path("sql/inserts/catalogos/067_delito_agraviados.sql")
OUT_CAT_DEL_COM = Path("sql/inserts/catalogos/068_delito_cometido_agraviados.sql")
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
    parser = argparse.ArgumentParser(description="Genera SQL de Agraviados por lote.")
    parser.add_argument("--batch", type=int, required=True, help="Numero de lote, por ejemplo 41")
    parser.add_argument("--start-index", type=int, required=True, help="Indice inicial 0-based en el XLSX")
    parser.add_argument("--row-limit", type=int, default=2000, help="Cantidad de filas por lote")
    parser.add_argument("--chunk-size", type=int, default=500, help="Filas por chunk transaccional")
    parser.add_argument("--source", type=Path, default=SRC, help="Archivo XLSX de origen")
    parser.add_argument("--municipios", type=Path, default=MUNI_FILE, help="Catalogo de municipios")
    parser.add_argument("--output-root", type=Path, default=Path("."), help="Raiz del proyecto")
    parser.add_argument(
        "--cache-pickle",
        type=Path,
        default=DEFAULT_CACHE_PICKLE,
        help="Ruta (relativa a output-root) para cache pickle del Sheet1",
    )
    parser.add_argument(
        "--no-cache",
        action="store_true",
        help="Desactiva lectura/escritura de cache",
    )
    return parser.parse_args()


def clean(value) -> str:
    if pd.isna(value):
        return ""
    return str(value).strip()


def norm(value: str) -> str:
    text = clean(value).upper()
    for source, target in (("Á", "A"), ("É", "E"), ("Í", "I"), ("Ó", "O"), ("Ú", "U"), ("Ü", "U"), ("Ñ", "N")):
        text = text.replace(source, target)
    text = text.replace("´", "'").replace("`", "'")
    return re.sub(r"\s+", " ", text)


def sqlq(value: str) -> str:
    return "'" + str(value).replace("'", "''") + "'"


def cut_utf8(value: str, max_bytes: int) -> str:
    text = clean(value)
    raw = text.encode("utf-8")
    if len(raw) <= max_bytes:
        return text
    raw = raw[:max_bytes]
    while True:
        try:
            return raw.decode("utf-8")
        except UnicodeDecodeError:
            raw = raw[:-1]


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
    return year, month, day, f"{year:04d}-{month:02d}-{day:02d}"


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


def parse_municipios(path: Path):
    lines = path.read_text(encoding="utf-8", errors="ignore").splitlines()
    mode = None
    departments = {}
    municipalities = []
    for line in lines:
        stripped = line.strip()
        if not stripped:
            continue
        low = stripped.lower()
        if "departamentos" in low:
            mode = "d"
            continue
        if "municipios" in low:
            mode = "m"
            continue
        match = re.match(r"^(\d+)\t(.+)$", stripped)
        if not match:
            continue
        code = int(match.group(1))
        name = match.group(2).strip()
        if mode == "d":
            departments[code] = name
        elif mode == "m":
            municipalities.append((code, name))

    dept_by_norm = {norm(name): (code, name) for code, name in departments.items()}
    muni_by_norm = {}
    first_muni_by_dept = {}
    for code, name in sorted(municipalities):
        dept_code = code // 100
        first_muni_by_dept.setdefault(dept_code, name)
        muni_by_norm.setdefault(norm(name), []).append((dept_code, name))
    return dept_by_norm, muni_by_norm, first_muni_by_dept


def resolve_location(dept_raw: str, muni_raw: str, dept_by_norm, muni_by_norm, first_muni_by_dept):
    dept_key = norm(dept_raw)
    muni_key = norm(muni_raw)
    if dept_key not in dept_by_norm:
        return None, None
    dept_code, dept_name = dept_by_norm[dept_key]
    muni_name = first_muni_by_dept.get(dept_code)
    if muni_key in muni_by_norm:
        matches = muni_by_norm[muni_key]
        exact = [muni for code, muni in matches if code == dept_code]
        if exact:
            muni_name = exact[0]
        elif matches:
            muni_name = matches[0][1]
    return dept_name, muni_name


def build_catalog_scripts(df: pd.DataFrame, root: Path):
    cat_class_path = root / OUT_CAT_CLASS
    cat_del_path = root / OUT_CAT_DEL
    cat_del_com_path = root / OUT_CAT_DEL_COM

    cat_class_path.parent.mkdir(parents=True, exist_ok=True)
    cat_del_path.parent.mkdir(parents=True, exist_ok=True)
    cat_del_com_path.parent.mkdir(parents=True, exist_ok=True)

    classes = sorted({cut_utf8(clean(v), 150) for v in df["principales_delitos"].dropna().unique() if clean(v)})
    delicts = sorted({cut_utf8(clean(v), 150) for v in df["delito_com"].dropna().unique() if clean(v)})

    class_lines = ["SET NAMES UTF8;", ""]
    for value in classes:
        class_lines.append(
            "INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo) "
            f"SELECT NULL, {sqlq(value)}, 'Fuente Agraviados 2023', 1 FROM RDB$DATABASE "
            f"WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(value)}));"
        )
    class_lines.extend(["", "COMMIT;"])
    cat_class_path.write_text("\n".join(class_lines), encoding="utf-8")

    delito_code = {}
    del_lines = ["SET NAMES UTF8;", ""]
    for idx, value in enumerate(delicts, start=1):
        code = f"AGR-DEL-{idx:03d}"
        delito_code[value] = code
        del_lines.append(
            "INSERT INTO delito (codigo, nombre, bien_juridico, activo) "
            f"SELECT {sqlq(code)}, {sqlq(value)}, 'Fuente Agraviados 2023', 1 FROM RDB$DATABASE "
            f"WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = {sqlq(code)});"
        )
    del_lines.extend(["", "COMMIT;"])
    cat_del_path.write_text("\n".join(del_lines), encoding="utf-8")

    pair_lines = ["SET NAMES UTF8;", ""]
    pairs = sorted({(cut_utf8(clean(a), 150), cut_utf8(clean(b), 150)) for a, b in zip(df["delito_com"], df["principales_delitos"]) if clean(a) and clean(b)})
    for delito_name, class_name in pairs:
        code = delito_code[delito_name]
        pair_lines.append(
            "INSERT INTO delito_cometido (id_tipo_delito, id_clasificacion_delito) "
            "SELECT d.id_delito, c.id_clasificacion_delito "
            "FROM delito d JOIN clasificacion_delito c ON 1=1 "
            f"WHERE d.codigo = {sqlq(code)} AND UPPER(TRIM(c.nombre)) = UPPER({sqlq(class_name)}) "
            "AND NOT EXISTS ("
            "SELECT 1 FROM delito_cometido dc "
            "WHERE dc.id_tipo_delito = d.id_delito AND dc.id_clasificacion_delito = c.id_clasificacion_delito"
            ");"
        )
    pair_lines.extend(["", "COMMIT;"])
    cat_del_com_path.write_text("\n".join(pair_lines), encoding="utf-8")

    return delito_code


def generate_batch_sql(df: pd.DataFrame, total_rows: int, batch_num: int, start_index: int, chunk_size: int, root: Path, dept_by_norm, muni_by_norm, first_muni_by_dept, delito_code):
    tx_statements = []
    skipped = 0

    for _, row in df.iterrows():
        corr = safe_int(row.get("núm_corre"), 0)
        if corr <= 0:
            skipped += 1
            continue

        year_hecho, month_hecho, day_hecho, fecha_hecho = parse_date(row.get("año_hecho"), row.get("mes_hecho"), row.get("día_hecho"))
        year_den, month_den, day_den, _ = parse_date(row.get("año_denuncia"), row.get("Reg_mes"), row.get("día_denuncia"))
        dept_raw = clean(row.get("depto_ocu_hecho"))
        muni_raw = clean(row.get("mupio_ocu_hecho"))
        zone_raw = cut_utf8(clean(row.get("zona_ocu_hecho")), 30)
        sex_raw = norm(row.get("sexo_agraviados"))
        age = safe_int(row.get("edad_agrav"), 30)
        civil = cut_utf8(clean(row.get("est_conyugal")), 60)
        delito_raw = cut_utf8(clean(row.get("delito_com")), 150)
        class_raw = cut_utf8(clean(row.get("principales_delitos")), 150)

        if not dept_raw or not muni_raw or not delito_raw or not class_raw:
            skipped += 1
            continue

        dept_name, muni_name = resolve_location(dept_raw, muni_raw, dept_by_norm, muni_by_norm, first_muni_by_dept)
        if not dept_name or not muni_name:
            skipped += 1
            continue

        dcode = delito_code.get(delito_raw)
        if not dcode:
            skipped += 1
            continue

        gender = "Mujer" if sex_raw.startswith("M") else "Hombre" if sex_raw.startswith("H") else "Ignorado"
        age = max(0, min(95, age))
        birth_year = year_hecho - max(1, age)
        birth_date = f"{birth_year:04d}-06-15"
        pcode = f"AGR_{year_den}_{corr:06d}"
        person_nombres, person_apellidos = synth_person_name(corr, sex_raw)

        tx_statements.append(
            "INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) "
            "SELECT m.id_municipio, NULL, NULL, "
            f"{sqlq(zone_raw)}, NULL "
            "FROM departamento d "
            "JOIN municipio m ON m.id_departamento = d.id_departamento "
            f"WHERE UPPER(TRIM(d.nombre)) = UPPER({sqlq(dept_name)}) "
            f"  AND UPPER(TRIM(m.nombre)) = UPPER({sqlq(muni_name)}) "
            "  AND NOT EXISTS ("
            "SELECT 1 FROM ubicacion u "
            "WHERE u.id_municipio = m.id_municipio AND COALESCE(u.zona, '') = "
            f"{sqlq(zone_raw)}"
            ");"
        )

        tx_statements.append(
            "INSERT INTO persona ("
            "nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, "
            "id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero"
            ") "
            "SELECT "
            f"{sqlq(person_nombres)}, {sqlq(person_apellidos)}, {sqlq(birth_date)}, NULL, "
            "COALESCE((SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER(" + sqlq(gender) + ") ROWS 1), "
            "         (SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1)), "
            "COALESCE((SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO','SIN SELECCION','SD') ORDER BY id_orientacion_sexual ROWS 1), "
            "         (SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1)), "
            "COALESCE((SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO','SD') ORDER BY id_grupo_etnico ROWS 1), "
            "         (SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1)), "
            "COALESCE((SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER(" + sqlq(civil if civil else 'Ignorado') + ") ROWS 1), "
            "         (SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1)), "
            "(SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1), "
            "(SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1), "
            "(SELECT u.id_ubicacion FROM ubicacion u "
            " JOIN municipio m ON m.id_municipio = u.id_municipio "
            " JOIN departamento d ON d.id_departamento = m.id_departamento "
            " WHERE UPPER(TRIM(d.nombre)) = UPPER(" + sqlq(dept_name) + ") "
            "   AND UPPER(TRIM(m.nombre)) = UPPER(" + sqlq(muni_name) + ") "
            "   AND COALESCE(u.zona, '') = " + sqlq(zone_raw) + " "
            " ORDER BY u.id_ubicacion DESC ROWS 1), "
            "0 "
            "FROM RDB$DATABASE "
            f"WHERE NOT EXISTS (SELECT 1 FROM persona p WHERE p.nombres = {sqlq(person_nombres)} AND p.apellidos = {sqlq(person_apellidos)});"
        )

        hecho_id_expr = (
            "(SELECT h.id_hecho FROM hecho h "
            " WHERE h.id_ubicacion = p.id_origen "
            f"   AND h.fecha_hecho = {sqlq(fecha_hecho)} "
            " ORDER BY h.id_hecho DESC ROWS 1)"
        )

        tx_statements.append(
            "INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) "
            "SELECT "
            "(SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1), "
            f"p.id_origen, {sqlq(fecha_hecho)} "
            "FROM persona p "
            f"WHERE p.nombres = {sqlq(person_nombres)} AND p.apellidos = {sqlq(person_apellidos)} "
            "AND NOT EXISTS ("
            "SELECT 1 FROM hecho h "
            "JOIN involucrado_hecho ih ON ih.id_hecho = h.id_hecho "
            "WHERE ih.id_involucrado = p.id_persona "
            f"  AND h.fecha_hecho = {sqlq(fecha_hecho)}"
            ");"
        )

        tx_statements.append(
            "INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) "
            "SELECT "
            f"{hecho_id_expr}, "
            "p.id_persona, "
            "COALESCE((SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1), "
            "         (SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1)) "
            "FROM persona p "
            f"WHERE p.nombres = {sqlq(person_nombres)} AND p.apellidos = {sqlq(person_apellidos)} "
            "AND NOT EXISTS ("
            "SELECT 1 FROM involucrado_hecho ih "
            "WHERE ih.id_involucrado = p.id_persona "
            f"  AND ih.id_hecho = {hecho_id_expr}"
            ");"
        )

        tx_statements.append(
            "INSERT INTO hecho_delictivo (id_hecho, id_delito) "
            "SELECT "
            f"{hecho_id_expr}, "
            "dc.id_delito_cometido "
            "FROM persona p "
            "JOIN delito d ON d.codigo = " + sqlq(dcode) + " "
            "JOIN clasificacion_delito c ON UPPER(TRIM(c.nombre)) = UPPER(" + sqlq(class_raw) + ") "
            "JOIN delito_cometido dc ON dc.id_tipo_delito = d.id_delito AND dc.id_clasificacion_delito = c.id_clasificacion_delito "
            f"WHERE p.nombres = {sqlq(person_nombres)} AND p.apellidos = {sqlq(person_apellidos)} "
            "AND NOT EXISTS ("
            "SELECT 1 FROM hecho_delictivo hd "
            f"WHERE hd.id_hecho = {hecho_id_expr} "
            "  AND hd.id_delito = dc.id_delito_cometido"
            ");"
        )

    tx_header = [
        "SET NAMES UTF8;",
        "",
        f"-- Fuente: Agraviados 2023 (lote {batch_num})",
        "-- Estrategia: INSERTs directos en bloque (sin EXECUTE BLOCK por fila)",
        "-- Flujo: ubicacion -> persona -> hecho -> involucrado_hecho(Agraviado) -> hecho_delictivo",
        "",
    ]
    tx_tail = ["COMMIT;"]

    tx_chunks_dir = root / f"sql/inserts/transaccional/chunks_110_b{batch_num}"
    tx_file = root / f"sql/inserts/transaccional/110_agraviados_batch{batch_num}_parcial.sql"
    pending_file = root / f"docs/pendientes_carga_batch{batch_num}.md"

    tx_chunks_dir.mkdir(parents=True, exist_ok=True)
    tx_file.parent.mkdir(parents=True, exist_ok=True)
    pending_file.parent.mkdir(parents=True, exist_ok=True)
    for old in tx_chunks_dir.glob("110_agraviados_part_*.sql"):
        old.unlink()

    chunk_count = 0
    for i in range(0, len(tx_statements), chunk_size):
        chunk_count += 1
        block_slice = tx_statements[i:i + chunk_size]
        chunk_lines = tx_header + [stmt for s in block_slice for stmt in (s, "")] + tx_tail
        (tx_chunks_dir / f"110_agraviados_part_{chunk_count:02d}.sql").write_text("\n".join(chunk_lines), encoding="utf-8")

    tx_file.write_text("\n".join(tx_header + [stmt for s in tx_statements for stmt in (s, "")] + tx_tail), encoding="utf-8")

    pending_lines = [
        "# Pendientes de carga",
        "",
        "## Batch 110 - Agraviados",
        f"- Fuente: {SRC}",
        f"- Total filas fuente: {len(df)}",
        f"- Rango cargado en parcial: {start_index + 1} a {start_index + len(df)}",
        f"- Rango pendiente: {start_index + len(df) + 1} a {total_rows}",
        f"- Chunks generados para ejecucion segura: {chunk_count} (directorio: {tx_chunks_dir})",
        f"- Filas omitidas: {skipped}",
        f"- Siguiente accion sugerida: cargar con load_agraviados_batch_fast.py usando {tx_chunks_dir.name}",
        "",
    ]
    pending_file.write_text("\n".join(pending_lines), encoding="utf-8")

    print(f"filas fuente total: {len(df)}")
    print(f"rango cargado parcial: {start_index + 1}..{start_index + len(df)}")
    print(f"omitidas en este parcial: {skipped}")
    print(f"chunks transaccional: {chunk_count}")
    print(f"catalogos: {OUT_CAT_CLASS.name}, {OUT_CAT_DEL.name}, {OUT_CAT_DEL_COM.name}")
    print(f"transaccional: {tx_file}")
    print(f"chunks_dir: {tx_chunks_dir}")
    print(f"pendiente: {pending_file}")


def main() -> int:
    args = parse_args()
    root = args.output_root.expanduser().resolve()
    source = args.source.expanduser().resolve()
    municipios = args.municipios.expanduser().resolve()
    cache_pickle = args.cache_pickle if args.cache_pickle.is_absolute() else (root / args.cache_pickle)

    if not source.exists():
        raise FileNotFoundError(source)
    if not municipios.exists():
        raise FileNotFoundError(municipios)

    full_df = None
    cache_used = False

    if not args.no_cache and cache_pickle.exists():
        full_df = pd.read_pickle(cache_pickle)
        cache_used = True

    if full_df is None:
        full_df = pd.read_excel(source, sheet_name="Sheet1")
        if not args.no_cache:
            cache_pickle.parent.mkdir(parents=True, exist_ok=True)
            full_df.to_pickle(cache_pickle)

    end_idx = min(len(full_df), args.start_index + args.row_limit)
    df = full_df.iloc[args.start_index:end_idx].copy()

    dept_by_norm, muni_by_norm, first_muni_by_dept = parse_municipios(municipios)
    delito_code = build_catalog_scripts(df, root)
    generate_batch_sql(
        df=df,
        total_rows=len(full_df),
        batch_num=args.batch,
        start_index=args.start_index,
        chunk_size=args.chunk_size,
        root=root,
        dept_by_norm=dept_by_norm,
        muni_by_norm=muni_by_norm,
        first_muni_by_dept=first_muni_by_dept,
        delito_code=delito_code,
    )
    print(f"cache: {'hit' if cache_used else 'miss'} ({cache_pickle})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
