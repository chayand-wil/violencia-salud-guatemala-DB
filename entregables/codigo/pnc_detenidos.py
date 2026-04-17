from pathlib import Path
import re

import pandas as pd

SRC = Path("datos_base/Violencia/Hechos-Delicitivos/PNC - Detenciados/detenidos.xlsx")
MUNI_FILE = Path("catalogos/municipios/municipios- depto.txt")

OUT_CAT_INV = Path("sql/inserts/catalogos/061_involucramiento_detenido.sql")
OUT_CAT_CLASS = Path("sql/inserts/catalogos/058_clasificacion_delito_pnc_detenidos.sql")
OUT_CAT_DEL = Path("sql/inserts/catalogos/059_delito_pnc_detenidos.sql")
OUT_CAT_DEL_COM = Path("sql/inserts/catalogos/060_delito_cometido_pnc_detenidos.sql")
OUT_TX = Path("sql/inserts/transaccional/108_pnc_detenidos_batch1.sql")


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



def clean(v) -> str:
    if pd.isna(v):
        return ""
    return str(v).strip()



def norm(v: str) -> str:
    t = clean(v).upper()
    for a, b in (("Á", "A"), ("É", "E"), ("Í", "I"), ("Ó", "O"), ("Ú", "U"), ("Ü", "U"), ("Ñ", "N")):
        t = t.replace(a, b)
    t = t.replace("´", "'").replace("`", "'")
    t = re.sub(r"\s+", " ", t)
    return t



def sqlq(v: str) -> str:
    return "'" + str(v).replace("'", "''") + "'"



def cut_utf8(v: str, max_bytes: int) -> str:
    s = clean(v)
    b = s.encode("utf-8")
    if len(b) <= max_bytes:
        return s
    cut = b[:max_bytes]
    while True:
        try:
            return cut.decode("utf-8")
        except UnicodeDecodeError:
            cut = cut[:-1]



def parse_municipios(path: Path):
    lines = path.read_text(encoding="utf-8", errors="ignore").splitlines()
    mode = None
    departments = {}
    municipalities = []

    for line in lines:
        s = line.strip()
        if not s:
            continue
        low = s.lower()
        if "departamentos" in low:
            mode = "d"
            continue
        if "municipios" in low:
            mode = "m"
            continue
        m = re.match(r"^(\d+)\t(.+)$", s)
        if not m:
            continue
        code = int(m.group(1))
        name = m.group(2).strip()
        if mode == "d":
            departments[code] = name
        elif mode == "m":
            municipalities.append((code, name))

    dept_by_norm = {norm(name): (code, name) for code, name in departments.items()}
    muni_by_norm = {}
    first_muni_by_dept = {}
    for code, name in sorted(municipalities):
        d = code // 100
        first_muni_by_dept.setdefault(d, name)
        muni_by_norm.setdefault(norm(name), []).append((d, name))
    return dept_by_norm, muni_by_norm, first_muni_by_dept



def resolve_location(dep_raw: str, muni_raw: str, dept_by_norm, muni_by_norm, first_muni_by_dept):
    dep_n = norm(dep_raw)
    muni_n = norm(muni_raw)

    if dep_n not in dept_by_norm:
        return None, None

    d_code, d_name = dept_by_norm[dep_n]
    muni_name = first_muni_by_dept.get(d_code)

    if muni_n in muni_by_norm:
        opts = muni_by_norm[muni_n]
        exact = [mn for dc, mn in opts if dc == d_code]
        if exact:
            muni_name = exact[0]
        elif opts:
            muni_name = opts[0][1]

    return d_name, muni_name



def safe_int(v, default=0):
    try:
        return int(float(v))
    except Exception:
        return default



def build_catalogs(df: pd.DataFrame):
    # Involucramiento: Detenido
    OUT_CAT_INV.write_text(
        "\n".join(
            [
                "SET NAMES UTF8;",
                "",
                "INSERT INTO involucramiento (nombre, descripcion)",
                "SELECT 'Detenido', 'Rol para fuente PNC detenidos 2023' FROM RDB$DATABASE",
                "WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Detenido'));",
                "",
                "COMMIT;",
            ]
        ),
        encoding="utf-8",
    )

    classes = sorted({cut_utf8(clean(v), 150) for v in df["g_delitos"].dropna().unique() if clean(v)})
    class_lines = ["SET NAMES UTF8;", ""]
    for c in classes:
        class_lines.append(
            "INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo) "
            f"SELECT NULL, {sqlq(c)}, 'Fuente PNC detenidos 2023', 1 FROM RDB$DATABASE "
            f"WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(c)}));"
        )
    class_lines.extend(["", "COMMIT;"])
    OUT_CAT_CLASS.write_text("\n".join(class_lines), encoding="utf-8")

    delitos = sorted({cut_utf8(clean(v), 150) for v in df["delito_com"].dropna().unique() if clean(v)})
    delito_code = {}
    del_lines = ["SET NAMES UTF8;", ""]
    for i, d in enumerate(delitos, start=1):
        code = f"PNCD-DEL-{i:03d}"
        delito_code[d] = code
        del_lines.append(
            "INSERT INTO delito (codigo, nombre, bien_juridico, activo) "
            f"SELECT {sqlq(code)}, {sqlq(d)}, 'Fuente PNC detenidos 2023', 1 FROM RDB$DATABASE "
            f"WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = {sqlq(code)});"
        )
    del_lines.extend(["", "COMMIT;"])
    OUT_CAT_DEL.write_text("\n".join(del_lines), encoding="utf-8")

    pairs = sorted(
        {
            (cut_utf8(clean(a), 150), cut_utf8(clean(b), 150))
            for a, b in zip(df["delito_com"], df["g_delitos"])
            if clean(a) and clean(b)
        }
    )
    pair_lines = ["SET NAMES UTF8;", ""]
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
    OUT_CAT_DEL_COM.write_text("\n".join(pair_lines), encoding="utf-8")

    return delito_code



def main():
    df = pd.read_excel(SRC, sheet_name="Sheet1")
    dept_by_norm, muni_by_norm, first_muni_by_dept = parse_municipios(MUNI_FILE)
    delito_code = build_catalogs(df)

    tx_lines = [
        "SET NAMES UTF8;",
        "SET TERM ^ ;",
        "",
        "-- Fuente: PNC detenidos 2023",
        "-- Flujo: ubicacion -> persona -> hecho(detencion) -> involucrado_hecho -> hecho_delictivo",
        "",
    ]

    skipped = 0
    for _, row in df.iterrows():
        corr = safe_int(row.get("núm_corre"), 0)
        year = safe_int(row.get("año_ocu"), 2023)
        month_name = norm(row.get("mes_ocu"))
        day = safe_int(row.get("día_ocu"), 1)
        dep_raw = clean(row.get("depto_ocu"))
        muni_raw = clean(row.get("mupio_ocu"))
        zona_raw = cut_utf8(clean(row.get("zona_ocu")), 30)
        sexo = norm(row.get("sexo_per"))
        edad = safe_int(row.get("edad_per"), 30)
        delito_raw = cut_utf8(clean(row.get("delito_com")), 150)
        class_raw = cut_utf8(clean(row.get("g_delitos")), 150)

        if corr <= 0 or not dep_raw or not delito_raw or not class_raw:
            skipped += 1
            continue

        if month_name not in MONTH_MAP:
            skipped += 1
            continue

        dep_name, muni_name = resolve_location(dep_raw, muni_raw, dept_by_norm, muni_by_norm, first_muni_by_dept)
        if not dep_name or not muni_name:
            skipped += 1
            continue

        month = MONTH_MAP[month_name]
        day = max(1, min(28, day))
        fecha = f"{year:04d}-{month:02d}-{day:02d}"

        genero = "Hombre" if sexo.startswith("H") else "Mujer" if sexo.startswith("M") else "Ignorado"
        edad = max(12, min(90, edad))
        fnac = f"{year - edad:04d}-06-15"

        pcode = f"PNCDET_{year}_{corr:06d}"
        dcode = delito_code.get(delito_raw)
        if not dcode:
            skipped += 1
            continue

        tx_lines.append(
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
            f"  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = {sqlq(pcode)} AND p.apellidos = 'PNC DETENIDOS')) THEN EXIT;\n"
            f"\n"
            f"  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(dep_name)}) ROWS 1 INTO v_dep;\n"
            f"  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER({sqlq(muni_name)}) ROWS 1 INTO v_muni;\n"
            f"  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;\n"
            f"\n"
            f"  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni AND COALESCE(zona, '') = {sqlq(zona_raw)} ROWS 1 INTO v_ubic;\n"
            f"  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, {sqlq(zona_raw)}, NULL) RETURNING id_ubicacion INTO v_ubic;\n"
            f"\n"
            f"  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(genero)}) ROWS 1 INTO v_genero;\n"
            f"  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;\n"
            f"  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;\n"
            f"  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;\n"
            f"  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;\n"
            f"  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;\n"
            f"  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;\n"
            f"  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;\n"
            f"  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;\n"
            f"\n"
            f"  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)\n"
            f"  VALUES ({sqlq(pcode)}, 'PNC DETENIDOS', {sqlq(fnac)}, NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)\n"
            f"  RETURNING id_persona INTO v_persona;\n"
            f"\n"
            f"  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('detencion') ROWS 1 INTO v_tipo_hecho;\n"
            f"  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, {sqlq(fecha)}) RETURNING id_hecho INTO v_hecho;\n"
            f"\n"
            f"  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Detenido') ROWS 1 INTO v_inv;\n"
            f"  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;\n"
            f"  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);\n"
            f"\n"
            f"  SELECT dc.id_delito_cometido\n"
            f"    FROM delito_cometido dc\n"
            f"    JOIN delito d ON d.id_delito = dc.id_tipo_delito\n"
            f"    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito\n"
            f"   WHERE d.codigo = {sqlq(dcode)} AND UPPER(TRIM(c.nombre)) = UPPER({sqlq(class_raw)})\n"
            f"   ROWS 1 INTO v_delito_com;\n"
            f"\n"
            f"  IF (v_delito_com IS NOT NULL) THEN\n"
            f"    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);\n"
            f"END^"
        )
        tx_lines.append("")

    tx_lines.extend(["SET TERM ; ^", "COMMIT;"])
    OUT_TX.write_text("\n".join(tx_lines), encoding="utf-8")

    print(f"filas fuente: {len(df)} | omitidas: {skipped}")
    print(f"catalogos: {OUT_CAT_INV.name}, {OUT_CAT_CLASS.name}, {OUT_CAT_DEL.name}, {OUT_CAT_DEL_COM.name}")
    print(f"transaccional: {OUT_TX}")


if __name__ == "__main__":
    main()
