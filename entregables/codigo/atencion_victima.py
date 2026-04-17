from pathlib import Path
import re

import pandas as pd

SRC = Path(
    "datos_base/Violencia/Violencia contra la mujer/Atencion brindada/Atenciones brindades por el Instituto de la Víctima 2020-2023(1).xlsx"
)
MUNI_FILE = Path("catalogos/municipios/municipios- depto.txt")
OUT_CAT_TIPO_INST = Path("sql/inserts/catalogos/048_tipo_institucion_instituto_victima.sql")
OUT_CAT_INST = Path("sql/inserts/catalogos/049_institucion_instituto_victima.sql")
OUT_CAT_TIPO_AT = Path("sql/inserts/catalogos/050_tipo_atencion_instituto_victima.sql")
OUT_CAT_DEL = Path("sql/inserts/catalogos/051_delito_atencion_instituto_victima.sql")
OUT_CAT_GRUPO = Path("sql/inserts/catalogos/052_grupo_etnico_atencion_victima.sql")
OUT_CAT_ORIENT = Path("sql/inserts/catalogos/053_orientacion_sexual_atencion_victima.sql")
OUT_TX = Path("sql/inserts/transaccional/106_vcm_atencion_victima_batch1.sql")


def clean(v) -> str:
    if pd.isna(v):
        return ""
    return str(v).strip()


def norm(v: str) -> str:
    t = clean(v).upper()
    for a, b in (("Á", "A"), ("É", "E"), ("Í", "I"), ("Ó", "O"), ("Ú", "U"), ("Ü", "U"), ("Ñ", "N")):
        t = t.replace(a, b)
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


def parse_muni_file(path: Path):
    lines = path.read_text(encoding="utf-8", errors="ignore").splitlines()
    mode = None
    dept = {}
    munis = []

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
            dept[code] = name
        elif mode == "m":
            munis.append((code, name))

    first_muni_by_dept = {}
    muni_by_dept_norm = {}
    for code, name in sorted(munis):
        d = code // 100
        if d not in first_muni_by_dept:
            first_muni_by_dept[d] = name
        muni_by_dept_norm.setdefault(d, {})[norm(name)] = name

    dept_by_norm = {norm(name): (d, name) for d, name in dept.items()}
    return dept_by_norm, first_muni_by_dept, muni_by_dept_norm


def build_catalogs(df: pd.DataFrame):
    # Tipo institucion + institucion
    OUT_CAT_TIPO_INST.write_text(
        "\n".join(
            [
                "SET NAMES UTF8;",
                "",
                "INSERT INTO tipo_institucion (nombre, descripcion)",
                "SELECT 'Instituto de la Victima', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE",
                "WHERE NOT EXISTS (SELECT 1 FROM tipo_institucion WHERE UPPER(TRIM(nombre)) = UPPER('Instituto de la Victima'));",
                "",
                "COMMIT;",
            ]
        ),
        encoding="utf-8",
    )

    OUT_CAT_INST.write_text(
        "\n".join(
            [
                "SET NAMES UTF8;",
                "",
                "INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)",
                "SELECT 'Instituto de la Victima', ti.id_tipo_institucion",
                "FROM tipo_institucion ti",
                "WHERE UPPER(TRIM(ti.nombre)) = UPPER('Instituto de la Victima')",
                "  AND NOT EXISTS (",
                "    SELECT 1 FROM institucion_organicacion io",
                "    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Instituto de la Victima')",
                "  );",
                "",
                "COMMIT;",
            ]
        ),
        encoding="utf-8",
    )

    # Tipo atencion
    tipos_at = sorted({cut_utf8(clean(v), 120) for v in df["Atención brindada"].dropna().unique() if clean(v)})
    ta_lines = ["SET NAMES UTF8;", ""]
    for t in tipos_at:
        ta_lines.append(
            "INSERT INTO tipo_atencion (nombre, descripcion) "
            f"SELECT {sqlq(t)}, 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE "
            f"WHERE NOT EXISTS (SELECT 1 FROM tipo_atencion WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(t)}));"
        )
    ta_lines.extend(["", "COMMIT;"])
    OUT_CAT_TIPO_AT.write_text("\n".join(ta_lines), encoding="utf-8")

    # Delitos
    delitos = sorted({clean(v) for v in df["Tipo del delito atendido"].dropna().unique() if clean(v)})
    delito_code = {}
    del_lines = ["SET NAMES UTF8;", ""]
    for i, d in enumerate(delitos, start=1):
        code = f"IAV-DEL-{i:03d}"
        d150 = cut_utf8(d, 150)
        delito_code[d] = code
        del_lines.append(
            "INSERT INTO delito (codigo, nombre, bien_juridico, activo) "
            f"SELECT {sqlq(code)}, {sqlq(d150)}, 'Fuente Atenciones IV', 1 FROM RDB$DATABASE "
            f"WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo={sqlq(code)});"
        )
    del_lines.extend(["", "COMMIT;"])
    OUT_CAT_DEL.write_text("\n".join(del_lines), encoding="utf-8")

    # Grupo etnico y orientacion sexual (solo enriquecer)
    grupos = sorted({clean(v) for v in df["Grupo étnico"].dropna().unique() if clean(v)})
    g_lines = ["SET NAMES UTF8;", ""]
    for g in grupos:
        g_lines.append(
            "INSERT INTO grupo_etnico (nombre, descripcion) "
            f"SELECT {sqlq(cut_utf8(g, 100))}, 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE "
            f"WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(cut_utf8(g, 100))}));"
        )
    g_lines.extend(["", "COMMIT;"])
    OUT_CAT_GRUPO.write_text("\n".join(g_lines), encoding="utf-8")

    orients = sorted({clean(v) for v in df["Orientación sexual"].dropna().unique() if clean(v)})
    o_lines = ["SET NAMES UTF8;", ""]
    for o in orients:
        o_lines.append(
            "INSERT INTO orientacion_sexual (nombre, descripcion) "
            f"SELECT {sqlq(cut_utf8(o, 100))}, 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE "
            f"WHERE NOT EXISTS (SELECT 1 FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(cut_utf8(o, 100))}));"
        )
    o_lines.extend(["", "COMMIT;"])
    OUT_CAT_ORIENT.write_text("\n".join(o_lines), encoding="utf-8")

    return delito_code


def main() -> None:
    df = pd.read_excel(SRC, sheet_name="2020-2023")
    dept_map, first_muni_by_dept, muni_by_dept_norm = parse_muni_file(MUNI_FILE)
    delito_code = build_catalogs(df)

    lines = [
        "SET NAMES UTF8;",
        "SET TERM ^ ;",
        "",
        "-- Fuente: Atenciones brindadas por el Instituto de la Victima 2020-2023",
        "-- Flujo: ubicaciones -> sede -> persona victima -> hecho -> atencion_victima",
        "",
    ]

    skipped = 0
    for i, row in df.iterrows():
        f_at = row.get("Fecha de atención")
        sede_desc = cut_utf8(clean(row.get("Sede de la atención")), 255)
        dep_sede_raw = clean(row.get("Depatamento de la sede"))
        muni_sede_raw = clean(row.get("Municipio de la sede"))
        delito_raw = clean(row.get("Tipo del delito atendido"))
        tipo_at = cut_utf8(clean(row.get("Atención brindada")), 120)
        dep_v_raw = clean(row.get("Departamento de procedencia de la víctima"))
        muni_v_raw = clean(row.get("Municipio de la procedencia de la víctima"))
        grupo_raw = cut_utf8(clean(row.get("Grupo étnico")), 100)
        orient_raw = cut_utf8(clean(row.get("Orientación sexual")), 100)

        edad_num = pd.to_numeric(pd.Series([row.get("Edad")]), errors="coerce").iloc[0]
        try:
            valor = int(float(row.get("Valor") or 0))
        except Exception:
            valor = 0

        if pd.isna(f_at) or not sede_desc or not dep_sede_raw or not delito_raw or not tipo_at or valor <= 0:
            skipped += 1
            continue

        # fecha
        fecha = pd.to_datetime(f_at).date().isoformat()
        year_i = int(fecha[:4])

        # depto/muni sede
        dep_s_key = norm(dep_sede_raw)
        if dep_s_key not in dept_map:
            skipped += 1
            continue
        dep_s_id, dep_s_name = dept_map[dep_s_key]
        muni_s_name = first_muni_by_dept.get(dep_s_id, "")
        if muni_sede_raw:
            mk = norm(muni_sede_raw)
            if mk in muni_by_dept_norm.get(dep_s_id, {}):
                muni_s_name = muni_by_dept_norm[dep_s_id][mk]
        if not muni_s_name:
            skipped += 1
            continue

        # depto/muni victima (fallback a sede si no existe o N/I)
        dep_v_name = dep_s_name
        muni_v_name = muni_s_name
        dep_v_key = norm(dep_v_raw)
        if dep_v_key in dept_map and dep_v_key != "N/I":
            dep_v_id, dep_v_name_real = dept_map[dep_v_key]
            dep_v_name = dep_v_name_real
            muni_v_name = first_muni_by_dept.get(dep_v_id, muni_s_name)
            if muni_v_raw:
                mvk = norm(muni_v_raw)
                if mvk in muni_by_dept_norm.get(dep_v_id, {}):
                    muni_v_name = muni_by_dept_norm[dep_v_id][mvk]

        edad_int = 30
        if pd.notna(edad_num):
            edad_int = int(max(10, min(90, int(edad_num))))
        fnac = f"{year_i-edad_int:04d}-06-15"

        dcode = delito_code.get(delito_raw)
        if not dcode:
            skipped += 1
            continue

        base = f"IAVCM_{i+1:05d}"

        block = f"""EXECUTE BLOCK AS
  DECLARE id_dep_s INTEGER;
  DECLARE id_muni_s INTEGER;
  DECLARE id_ubic_s INTEGER;
  DECLARE id_dep_v INTEGER;
  DECLARE id_muni_v INTEGER;
  DECLARE id_ubic_v INTEGER;
  DECLARE id_inst INTEGER;
  DECLARE id_sede INTEGER;
  DECLARE id_tipo_at INTEGER;
  DECLARE id_delito INTEGER;
  DECLARE id_genero INTEGER;
  DECLARE id_grupo INTEGER;
  DECLARE id_orient INTEGER;
  DECLARE id_eciv INTEGER;
  DECLARE id_alf INTEGER;
  DECLARE id_nivel INTEGER;
  DECLARE id_tipo_hecho INTEGER;
  DECLARE id_persona INTEGER;
  DECLARE id_hecho INTEGER;
  DECLARE cnt_exist INTEGER;
  DECLARE seq_no INTEGER;
  DECLARE target_cnt INTEGER;
  DECLARE pnombre VARCHAR(150);
BEGIN
  target_cnt = {valor};

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(dep_s_name)}) ROWS 1 INTO id_dep_s;
  SELECT id_municipio FROM municipio WHERE id_departamento = :id_dep_s AND UPPER(TRIM(nombre)) = UPPER({sqlq(muni_s_name)}) ROWS 1 INTO id_muni_s;
  IF (id_muni_s IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :id_dep_s ORDER BY id_municipio ROWS 1 INTO id_muni_s;

  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :id_muni_s ROWS 1 INTO id_ubic_s;
  IF (id_ubic_s IS NULL) THEN
    INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia)
    VALUES (:id_muni_s, NULL, NULL, NULL, NULL)
    RETURNING id_ubicacion INTO id_ubic_s;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(dep_v_name)}) ROWS 1 INTO id_dep_v;
  IF (id_dep_v IS NULL) THEN id_dep_v = id_dep_s;
  SELECT id_municipio FROM municipio WHERE id_departamento = :id_dep_v AND UPPER(TRIM(nombre)) = UPPER({sqlq(muni_v_name)}) ROWS 1 INTO id_muni_v;
  IF (id_muni_v IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :id_dep_v ORDER BY id_municipio ROWS 1 INTO id_muni_v;

  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :id_muni_v ROWS 1 INTO id_ubic_v;
  IF (id_ubic_v IS NULL) THEN
    INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia)
    VALUES (:id_muni_v, NULL, NULL, NULL, NULL)
    RETURNING id_ubicacion INTO id_ubic_v;

  SELECT id_institucion_organicacion FROM institucion_organicacion WHERE UPPER(TRIM(nombre_institucion)) = UPPER('Instituto de la Victima') ROWS 1 INTO id_inst;
  SELECT id_tipo_atencion FROM tipo_atencion WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(tipo_at)}) ROWS 1 INTO id_tipo_at;
  SELECT id_delito FROM delito WHERE codigo = {sqlq(dcode)} ROWS 1 INTO id_delito;
  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('atencion') ROWS 1 INTO id_tipo_hecho;

  IF (id_inst IS NULL OR id_tipo_at IS NULL OR id_delito IS NULL OR id_tipo_hecho IS NULL) THEN
    EXIT;

  SELECT id_sede FROM sede
   WHERE id_institucion_organicacion = :id_inst
     AND UPPER(TRIM(descripcion)) = UPPER({sqlq(sede_desc)})
     AND id_ubicacion = :id_ubic_s
   ROWS 1 INTO id_sede;

  IF (id_sede IS NULL) THEN
    INSERT INTO sede (id_institucion_organicacion, descripcion, id_ubicacion)
    VALUES (:id_inst, {sqlq(sede_desc)}, :id_ubic_s)
    RETURNING id_sede INTO id_sede;

  SELECT COUNT(*)
    FROM atencion_victima av
    JOIN hecho h ON h.id_hecho = av.id_hecho
    JOIN persona p ON p.id_persona = av.id_victima
   WHERE p.nombres STARTING WITH {sqlq(base + '_')}
     AND h.fecha_hecho = {sqlq(fecha)}
     AND av.id_sede = :id_sede
     AND av.id_tipo_delito_atendido = :id_delito
     AND av.id_atencion_brindada = :id_tipo_at
   INTO cnt_exist;

  seq_no = cnt_exist + 1;
  WHILE (seq_no <= target_cnt) DO BEGIN
    pnombre = '{base}_' || CAST(seq_no AS VARCHAR(10));

    SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO id_genero;
    SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(grupo_raw)}) ROWS 1 INTO id_grupo;
    IF (id_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_grupo;
    SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(orient_raw)}) ROWS 1 INTO id_orient;
    IF (id_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) = UPPER('Sin selección') ROWS 1 INTO id_orient;
    IF (id_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO id_orient;
    SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_eciv;
    SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_alf;
    SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_nivel;
    IF (id_nivel IS NULL) THEN SELECT id_nivel_escolaridad FROM nivel_escolaridad ORDER BY id_nivel_escolaridad ROWS 1 INTO id_nivel;

    INSERT INTO persona (
      nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico,
      id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero
    ) VALUES (
      :pnombre, {sqlq('ATENCION_IV')}, {sqlq(fnac)}, NULL,
      :id_genero, :id_orient, :id_grupo, :id_eciv, :id_alf, :id_nivel, :id_ubic_v, 0
    ) RETURNING id_persona INTO id_persona;

    INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
    VALUES (:id_tipo_hecho, :id_ubic_s, {sqlq(fecha)})
    RETURNING id_hecho INTO id_hecho;

    INSERT INTO atencion_victima (
      id_hecho, id_sede, id_victima, id_tipo_delito_atendido, id_atencion_brindada
    ) VALUES (
      :id_hecho, :id_sede, :id_persona, :id_delito, :id_tipo_at
    );

    seq_no = seq_no + 1;
  END
END^"""
        lines.append(block)
        lines.append("")

    lines.extend(["SET TERM ; ^", "COMMIT;"])
    OUT_TX.write_text("\n".join(lines), encoding="utf-8")

    print(
        f"Catalogos: {OUT_CAT_TIPO_INST.name}, {OUT_CAT_INST.name}, {OUT_CAT_TIPO_AT.name}, {OUT_CAT_DEL.name}, {OUT_CAT_GRUPO.name}, {OUT_CAT_ORIENT.name}"
    )
    print(f"Transaccional: {OUT_TX} | filas fuente: {len(df)} | omitidas: {skipped}")


if __name__ == "__main__":
    main()
