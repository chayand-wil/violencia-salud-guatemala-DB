from pathlib import Path
import re

import pandas as pd

SRC = Path(
    "datos_base/Violencia/Violencia contra la mujer/Sentencias por delito/SENTENCIAS DEL Organismo Judicial POR EL DELITO DE Violencia contra la mujerCM 2008-2024.xlsx"
)
MUNI_FILE = Path("catalogos/municipios/municipios- depto.txt")
OUT_CAT_FALLO = Path("sql/inserts/catalogos/045_tipo_fallo_absolutoria.sql")
OUT_CAT_INST = Path("sql/inserts/catalogos/046_institucion_oj_sentencias.sql")
OUT_CAT_DELITO = Path("sql/inserts/catalogos/047_delito_oj_sentencias_vcm.sql")
OUT_TX = Path("sql/inserts/transaccional/105_vcm_sentencias_oj_batch1.sql")


MONTH_MAP = {
    "ENERO": "01",
    "FEBRERO": "02",
    "MARZO": "03",
    "ABRIL": "04",
    "MAYO": "05",
    "JUNIO": "06",
    "JULIO": "07",
    "AGOSTO": "08",
    "SEPTIEMBRE": "09",
    "OCTUBRE": "10",
    "NOVIEMBRE": "11",
    "DICIEMBRE": "12",
}


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
    for code, name in sorted(munis):
        d = code // 100
        if d not in first_muni_by_dept:
            first_muni_by_dept[d] = name

    dept_by_norm = {norm(name): (d, name) for d, name in dept.items()}
    return dept_by_norm, first_muni_by_dept


def build_catalogs(df: pd.DataFrame):
    # Tipo fallo faltante
    fallo_lines = [
        "SET NAMES UTF8;",
        "",
        "INSERT INTO tipo_fallo (nombre, descripcion)",
        "SELECT 'Absolutoria', 'Fuente Sentencias OJ VCM 2009-2024' FROM RDB$DATABASE",
        "WHERE NOT EXISTS (SELECT 1 FROM tipo_fallo WHERE UPPER(TRIM(nombre)) = UPPER('Absolutoria'));",
        "",
        "COMMIT;",
    ]
    OUT_CAT_FALLO.write_text("\n".join(fallo_lines), encoding="utf-8")

    # Instituciones OJ por DESPACHO
    despachos = sorted({cut_utf8(v, 150) for v in df["DESPACHO"].dropna().unique() if clean(v)})
    inst_lines = ["SET NAMES UTF8;", ""]
    for d in despachos:
        inst_lines.extend(
            [
                "INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)",
                f"SELECT {sqlq(d)}, ti.id_tipo_institucion",
                "FROM tipo_institucion ti",
                "WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')",
                "  AND NOT EXISTS (",
                "    SELECT 1 FROM institucion_organicacion io",
                f"    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER({sqlq(d)})",
                "  );",
                "",
            ]
        )
    inst_lines.append("COMMIT;")
    OUT_CAT_INST.write_text("\n".join(inst_lines), encoding="utf-8")

    # Delitos OJ por variante textual
    delitos_raw = sorted({clean(v) for v in df["DELITO"].dropna().unique() if clean(v)})
    mapping = {}
    delito_lines = ["SET NAMES UTF8;", ""]
    for i, d in enumerate(delitos_raw, start=1):
        code = f"OJS-VCM-DEL-{i:03d}"
        d150 = cut_utf8(d, 150)
        mapping[d] = code
        delito_lines.append(
            "INSERT INTO delito (codigo, nombre, bien_juridico, activo) "
            f"SELECT {sqlq(code)}, {sqlq(d150)}, 'Fuente Sentencias OJ VCM', 1 FROM RDB$DATABASE "
            f"WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo={sqlq(code)});"
        )
    delito_lines.extend(["", "COMMIT;"])
    OUT_CAT_DELITO.write_text("\n".join(delito_lines), encoding="utf-8")
    return mapping


def main() -> None:
    df = pd.read_excel(SRC, sheet_name="Sentencias 2008-2024")
    dept_map, first_muni_by_dept = parse_muni_file(MUNI_FILE)
    delito_map = build_catalogs(df)

    lines = [
        "SET NAMES UTF8;",
        "SET TERM ^ ;",
        "",
        "-- Fuente: SENTENCIAS DEL OJ POR EL DELITO DE VCM 2008-2024.xlsx",
        "-- Flujo: persona -> hecho -> involucrado_hecho -> sentencia -> sentencia_hecho",
        "",
    ]

    skipped = 0
    for idx, row in df.iterrows():
        dept_raw = clean(row.get("DEPARTAMENTO"))
        despacho_raw = clean(row.get("DESPACHO"))
        delito_raw = clean(row.get("DELITO"))
        fallo_raw = clean(row.get("TIPO FALLO"))
        mes_raw = clean(row.get("Mes"))
        year_raw = clean(row.get("Año"))
        try:
            valor = int(float(row.get("Valor") or 0))
        except Exception:
            valor = 0

        if not dept_raw or not despacho_raw or not delito_raw or not fallo_raw or not mes_raw or not year_raw or valor <= 0:
            skipped += 1
            continue

        dept_key = norm(dept_raw)
        if dept_key not in dept_map:
            skipped += 1
            continue
        dept_id, dept_name = dept_map[dept_key]
        muni_name = first_muni_by_dept.get(dept_id, "")
        if not muni_name:
            skipped += 1
            continue

        mes_num = MONTH_MAP.get(norm(mes_raw), "01")
        try:
            yy = int(float(year_raw))
        except Exception:
            skipped += 1
            continue
        if yy < 2009:
            yy = 2009
        if yy > 2024:
            yy = 2024

        fecha = f"{yy:04d}-{mes_num}-15"
        fnac = f"{yy-30:04d}-01-15"

        despacho = cut_utf8(despacho_raw, 150)
        delito_code = delito_map.get(delito_raw)
        if not delito_code:
            skipped += 1
            continue

        base = f"SOJVCM_{idx+1:05d}"
        apell = cut_utf8(delito_raw, 150)
        fallo = "Condenatoria" if norm(fallo_raw) == "CONDENATORIA" else "Absolutoria"

        block = f"""EXECUTE BLOCK AS
  DECLARE id_depto INTEGER;
  DECLARE id_muni INTEGER;
  DECLARE id_ubic INTEGER;
  DECLARE id_inst INTEGER;
  DECLARE id_fallo INTEGER;
  DECLARE id_tsent INTEGER;
  DECLARE id_delito INTEGER;
  DECLARE id_invol INTEGER;
  DECLARE id_tipo_hecho INTEGER;
  DECLARE id_genero INTEGER;
  DECLARE id_grupo INTEGER;
  DECLARE id_eciv INTEGER;
  DECLARE id_alf INTEGER;
  DECLARE id_nivel INTEGER;
  DECLARE id_persona INTEGER;
  DECLARE id_hecho INTEGER;
  DECLARE id_sentencia INTEGER;
  DECLARE cnt_exist INTEGER;
  DECLARE seq_no INTEGER;
  DECLARE target_cnt INTEGER;
  DECLARE pnombre VARCHAR(150);
BEGIN
  target_cnt = {valor};

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(dept_name)}) ROWS 1 INTO id_depto;
  IF (id_depto IS NULL) THEN SELECT id_departamento FROM departamento ORDER BY id_departamento ROWS 1 INTO id_depto;

  SELECT id_municipio FROM municipio WHERE id_departamento = :id_depto AND UPPER(TRIM(nombre)) = UPPER({sqlq(muni_name)}) ROWS 1 INTO id_muni;
  IF (id_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :id_depto ORDER BY id_municipio ROWS 1 INTO id_muni;

  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :id_muni ROWS 1 INTO id_ubic;
  IF (id_ubic IS NULL) THEN
    INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia)
    VALUES (:id_muni, NULL, NULL, NULL, NULL)
    RETURNING id_ubicacion INTO id_ubic;

  SELECT id_institucion_organicacion FROM institucion_organicacion WHERE UPPER(TRIM(nombre_institucion)) = UPPER({sqlq(despacho)}) ROWS 1 INTO id_inst;
  SELECT id_tipo_fallo FROM tipo_fallo WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(fallo)}) ROWS 1 INTO id_fallo;
  SELECT id_tipo_sentencia FROM tipo_sentencia WHERE UPPER(TRIM(nombre)) = UPPER('Violencia contra la mujer') ROWS 1 INTO id_tsent;
  SELECT id_delito FROM delito WHERE codigo = {sqlq(delito_code)} ROWS 1 INTO id_delito;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO id_invol;
  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO id_tipo_hecho;

  IF (id_inst IS NULL OR id_fallo IS NULL OR id_tsent IS NULL OR id_delito IS NULL OR id_invol IS NULL OR id_tipo_hecho IS NULL) THEN
    EXIT;

  SELECT COUNT(*)
    FROM sentencia s
    JOIN persona p ON p.id_persona = s.id_persona
   WHERE p.nombres STARTING WITH {sqlq(base + '_')}
     AND s.fecha_sentencia = {sqlq(fecha)}
     AND s.id_institucion_organicacion = :id_inst
     AND s.id_tipo_fallo = :id_fallo
     AND s.id_delito = :id_delito
   INTO cnt_exist;

  seq_no = cnt_exist + 1;
  WHILE (seq_no <= target_cnt) DO BEGIN
    pnombre = '{base}_' || CAST(seq_no AS VARCHAR(10));

    SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO id_genero;
    IF (id_genero IS NULL) THEN SELECT id_genero FROM genero ORDER BY id_genero ROWS 1 INTO id_genero;
    SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_grupo;
    SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_eciv;
    SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_alf;
    SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_nivel;
    IF (id_nivel IS NULL) THEN SELECT id_nivel_escolaridad FROM nivel_escolaridad ORDER BY id_nivel_escolaridad ROWS 1 INTO id_nivel;

    INSERT INTO persona (
      nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico,
      id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero
    ) VALUES (
      :pnombre, {sqlq(apell)}, {sqlq(fnac)}, NULL,
      :id_genero, NULL, :id_grupo, :id_eciv, :id_alf, :id_nivel, :id_ubic, 0
    ) RETURNING id_persona INTO id_persona;

    INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
    VALUES (:id_tipo_hecho, :id_ubic, {sqlq(fecha)})
    RETURNING id_hecho INTO id_hecho;

    INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento)
    VALUES (:id_hecho, :id_persona, :id_invol);

    INSERT INTO sentencia (
      fecha_sentencia, id_institucion_organicacion, id_persona, id_tipo_fallo,
      id_delito, id_involucramiento, id_tipo_sentencia
    ) VALUES (
      {sqlq(fecha)}, :id_inst, :id_persona, :id_fallo,
      :id_delito, :id_invol, :id_tsent
    ) RETURNING id_sentencia INTO id_sentencia;

    INSERT INTO sentencia_hecho (id_sentencia, id_hecho)
    VALUES (:id_sentencia, :id_hecho);

    seq_no = seq_no + 1;
  END
END^"""
        lines.append(block)
        lines.append("")

    lines.extend(["SET TERM ; ^", "COMMIT;"])
    OUT_TX.write_text("\n".join(lines), encoding="utf-8")
    print(f"Catalogos: {OUT_CAT_FALLO.name}, {OUT_CAT_INST.name}, {OUT_CAT_DELITO.name}")
    print(f"Transaccional: {OUT_TX} | filas fuente: {len(df)} | omitidas: {skipped}")


if __name__ == "__main__":
    main()
