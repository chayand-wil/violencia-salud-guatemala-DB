from pathlib import Path
import re

import pandas as pd

SRC = Path("datos_base/Violencia/Hechos-Delicitivos/Exhumaciones/exhumaciones.xlsx")
MUNI_FILE = Path("catalogos/municipios/municipios- depto.txt")
START_INDEX = 0
ROW_LIMIT = 60
CHUNK_SIZE = 20

OUT_CAT_CLASS = Path("sql/inserts/catalogos/076_clasificacion_delito_exhumaciones.sql")
OUT_CAT_DEL = Path("sql/inserts/catalogos/077_delito_exhumaciones.sql")
OUT_CAT_DEL_COM = Path("sql/inserts/catalogos/078_delito_cometido_exhumaciones.sql")
OUT_TX = Path("sql/inserts/transaccional/113_exhumaciones_batch1_parcial.sql")
OUT_TX_CHUNKS_DIR = Path("sql/inserts/transaccional/chunks_113")
OUT_PENDING = Path("docs/pendientes_carga.md")

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
    first_muni_by_dept = {}
    for code, name in sorted(municipalities):
        dept_code = code // 100
        first_muni_by_dept.setdefault(dept_code, name)
    return dept_by_norm, first_muni_by_dept


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


def build_catalogs():
    class_name = "Exhumacion"
    delito_name = "Exhumacion"
    delito_code = "EXH-DEL-001"

    OUT_CAT_CLASS.write_text(
        "\n".join(
            [
                "SET NAMES UTF8;",
                "",
                "INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo)",
                f"SELECT NULL, {sqlq(class_name)}, 'Fuente Exhumaciones 2023', 1 FROM RDB$DATABASE",
                f"WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(class_name)}));",
                "",
                "COMMIT;",
            ]
        ),
        encoding="utf-8",
    )

    OUT_CAT_DEL.write_text(
        "\n".join(
            [
                "SET NAMES UTF8;",
                "",
                "INSERT INTO delito (codigo, nombre, bien_juridico, activo)",
                f"SELECT {sqlq(delito_code)}, {sqlq(delito_name)}, 'Fuente Exhumaciones 2023', 1 FROM RDB$DATABASE",
                f"WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = {sqlq(delito_code)});",
                "",
                "COMMIT;",
            ]
        ),
        encoding="utf-8",
    )

    OUT_CAT_DEL_COM.write_text(
        "\n".join(
            [
                "SET NAMES UTF8;",
                "",
                "INSERT INTO delito_cometido (id_tipo_delito, id_clasificacion_delito)",
                "SELECT d.id_delito, c.id_clasificacion_delito",
                "FROM delito d JOIN clasificacion_delito c ON 1=1",
                f"WHERE d.codigo = {sqlq(delito_code)}",
                f"  AND UPPER(TRIM(c.nombre)) = UPPER({sqlq(class_name)})",
                "  AND NOT EXISTS (",
                "    SELECT 1 FROM delito_cometido dc",
                "    WHERE dc.id_tipo_delito = d.id_delito AND dc.id_clasificacion_delito = c.id_clasificacion_delito",
                "  );",
                "",
                "COMMIT;",
            ]
        ),
        encoding="utf-8",
    )

    return class_name, delito_code


def main():
    full_df = pd.read_excel(SRC, sheet_name="Sheet1")
    total = len(full_df)
    end_idx = min(total, START_INDEX + ROW_LIMIT)
    df = full_df.iloc[START_INDEX:end_idx].copy()

    dept_by_norm, first_muni_by_dept = parse_municipios(MUNI_FILE)
    class_name, delito_code = build_catalogs()

    tx_blocks = []
    skipped = 0
    for _, row in df.iterrows():
        corr = safe_int(row.get("núm_corre"), 0)
        if corr <= 0:
            skipped += 1
            continue

        _, _, _, fecha = parse_date(row.get("año_ocu"), row.get("mes_ocu"), row.get("día_ocu"))
        dept_raw = clean(row.get("depto_ocu"))
        dept_key = norm(dept_raw)
        if dept_key not in dept_by_norm:
            skipped += 1
            continue

        dept_code, dept_name = dept_by_norm[dept_key]
        muni_name = first_muni_by_dept.get(dept_code)
        if not muni_name:
            skipped += 1
            continue

        pcode = f"EXH_{safe_int(row.get('año_ocu'), 2023)}_{corr:06d}"

        tx_blocks.append(
            f"EXECUTE BLOCK AS\n"
            f"  DECLARE v_dep INTEGER;\n"
            f"  DECLARE v_muni INTEGER;\n"
            f"  DECLARE v_ubic INTEGER;\n"
            f"  DECLARE v_genero INTEGER;\n"
            f"  DECLARE v_orient INTEGER;\n"
            f"  DECLARE v_grupo INTEGER;\n"
            f"  DECLARE v_eciv INTEGER;\n"
            f"  DECLARE v_alf INTEGER;\n"
            f"  DECLARE v_nivel INTEGER;\n"
            f"  DECLARE v_persona INTEGER;\n"
            f"  DECLARE v_hecho INTEGER;\n"
            f"  DECLARE v_tipo_hecho INTEGER;\n"
            f"  DECLARE v_inv INTEGER;\n"
            f"  DECLARE v_delito_com INTEGER;\n"
            f"BEGIN\n"
            f"  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = {sqlq(pcode)} AND p.apellidos = 'EXHUMACIONES')) THEN EXIT;\n"
            f"\n"
            f"  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(dept_name)}) ROWS 1 INTO v_dep;\n"
            f"  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER({sqlq(muni_name)}) ROWS 1 INTO v_muni;\n"
            f"  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;\n"
            f"  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;\n"
            f"  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;\n"
            f"\n"
            f"  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;\n"
            f"  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;\n"
            f"  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;\n"
            f"  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;\n"
            f"  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;\n"
            f"  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;\n"
            f"  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;\n"
            f"  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;\n"
            f"\n"
            f"  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)\n"
            f"  VALUES ({sqlq(pcode)}, 'EXHUMACIONES', '1990-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)\n"
            f"  RETURNING id_persona INTO v_persona;\n"
            f"\n"
            f"  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;\n"
            f"  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, {sqlq(fecha)}) RETURNING id_hecho INTO v_hecho;\n"
            f"\n"
            f"  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;\n"
            f"  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;\n"
            f"  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);\n"
            f"\n"
            f"  SELECT dc.id_delito_cometido\n"
            f"    FROM delito_cometido dc\n"
            f"    JOIN delito d ON d.id_delito = dc.id_tipo_delito\n"
            f"    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito\n"
            f"   WHERE d.codigo = {sqlq(delito_code)} AND UPPER(TRIM(c.nombre)) = UPPER({sqlq(class_name)})\n"
            f"   ROWS 1 INTO v_delito_com;\n"
            f"\n"
            f"  IF (v_delito_com IS NOT NULL) THEN\n"
            f"    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);\n"
            f"END^"
        )

    tx_header = [
        "SET NAMES UTF8;",
        "SET TERM ^ ;",
        "",
        "-- Fuente: Exhumaciones 2023 (carga parcial)",
        "-- Flujo: catalogos -> ubicacion -> persona -> hecho -> involucrado_hecho(Agraviado) -> hecho_delictivo",
        "",
    ]
    tx_tail = ["SET TERM ; ^", "COMMIT;"]

    OUT_TX_CHUNKS_DIR.mkdir(parents=True, exist_ok=True)
    for old in OUT_TX_CHUNKS_DIR.glob("113_exhumaciones_part_*.sql"):
        old.unlink()

    chunk_count = 0
    for i in range(0, len(tx_blocks), CHUNK_SIZE):
        chunk_count += 1
        block_slice = tx_blocks[i:i + CHUNK_SIZE]
        chunk_lines = tx_header + [blk for b in block_slice for blk in (b, "")] + tx_tail
        (OUT_TX_CHUNKS_DIR / f"113_exhumaciones_part_{chunk_count:02d}.sql").write_text("\n".join(chunk_lines), encoding="utf-8")

    OUT_TX.write_text("\n".join(tx_header + [blk for b in tx_blocks for blk in (b, "")] + tx_tail), encoding="utf-8")

    pending_lines = [
        "# Pendientes de carga",
        "",
        "## Batch 109 - PNC victimas",
        "- Fuente: datos_base/Violencia/Hechos-Delicitivos/PNC -Victimas/pnc_victimas.xlsx",
        "- Total filas fuente: 39968",
        "- Rango cargado en parcial: 1 a 15000",
        "- Rango pendiente: 15001 a 39968",
        "- Chunks generados para ejecucion segura: 15 (directorio: sql/inserts/transaccional/chunks_109)",
        "- Siguiente accion sugerida: generar `109_pnc_victimas_batch2_parcial.sql` empezando en `START_INDEX = 15000`.",
        "",
        "## Batch 110 - Agraviados",
        "- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx",
        "- Total filas fuente: 444513",
        "- Rango cargado en parcial: 1 a 1000",
        "- Rango pendiente: 1001 a 444513",
        "- Chunks generados para ejecucion segura: 4 (directorio: sql/inserts/transaccional/chunks_110)",
        "- Siguiente accion sugerida: generar `110_agraviados_batch2_parcial.sql` empezando en `START_INDEX = 1000`.",
        "",
        "## Batch 111 - Sindicados",
        "- Fuente: datos_base/Violencia/Hechos-Delicitivos/Sindicatos/sindicados.xlsx",
        "- Total filas fuente: 362321",
        "- Rango cargado en parcial: 1 a 1000",
        "- Rango pendiente: 1001 a 362321",
        "- Chunks generados para ejecucion segura: 4 (directorio: sql/inserts/transaccional/chunks_111)",
        "- Siguiente accion sugerida: generar `111_sindicados_batch2_parcial.sql` empezando en `START_INDEX = 1000`.",
        "",
        "## Batch 112 - Necropsias",
        "- Fuente: datos_base/Violencia/Hechos-Delicitivos/Necropsias/necropsias.xlsx",
        "- Total filas fuente: 11038",
        "- Rango cargado en parcial: 1 a 1000",
        "- Rango pendiente: 1001 a 11038",
        "- Chunks generados para ejecucion segura: 4 (directorio: sql/inserts/transaccional/chunks_112)",
        "- Siguiente accion sugerida: generar `112_necropsias_batch2_parcial.sql` empezando en `START_INDEX = 1000`.",
        "",
        "## Batch 113 - Exhumaciones",
        f"- Fuente: {SRC}",
        f"- Total filas fuente: {total}",
        f"- Rango cargado en parcial: {START_INDEX + 1} a {end_idx}",
        f"- Rango pendiente: {end_idx + 1} a {total}",
        f"- Chunks generados para ejecucion segura: {chunk_count} (directorio: {OUT_TX_CHUNKS_DIR})",
        "- Siguiente accion sugerida: generar `113_exhumaciones_batch2_parcial.sql` empezando en `START_INDEX = " + str(end_idx) + "`.",
        "",
    ]
    OUT_PENDING.write_text("\n".join(pending_lines), encoding="utf-8")

    print(f"filas fuente total: {total}")
    print(f"rango cargado parcial: {START_INDEX + 1}..{end_idx}")
    print(f"omitidas en este parcial: {skipped}")
    print(f"chunks transaccional: {chunk_count}")
    print(f"catalogos: {OUT_CAT_CLASS.name}, {OUT_CAT_DEL.name}, {OUT_CAT_DEL_COM.name}")
    print(f"transaccional: {OUT_TX}")
    print(f"chunks_dir: {OUT_TX_CHUNKS_DIR}")
    print(f"pendiente: {OUT_PENDING}")


if __name__ == "__main__":
    main()
