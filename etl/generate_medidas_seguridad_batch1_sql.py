from pathlib import Path
from hashlib import md5
import re

import pandas as pd

SRC = Path(
    "datos_base/Violencia/Violencia contra la mujer/Medidas de seguridad/Medidas de Seguridad 2012-2024.xlsx"
)
MUNI_FILE = Path("catalogos/municipios/municipios- depto.txt")
OUT_CAT_TIPO = Path("sql/inserts/catalogos/040_tipo_institucion_oj.sql")
OUT_CAT_INST = Path("sql/inserts/catalogos/041_institucion_oj_despachos_medidas.sql")
OUT_TX = Path("sql/inserts/transaccional/103_vcm_medidas_seguridad_batch1.sql")


def clean(v) -> str:
    if pd.isna(v):
        return ""
    return str(v).strip()


def norm(v: str) -> str:
    t = v.upper().strip()
    for a, b in (("Á", "A"), ("É", "E"), ("Í", "I"), ("Ó", "O"), ("Ú", "U"), ("Ü", "U"), ("Ñ", "N")):
        t = t.replace(a, b)
    t = re.sub(r"\s+", " ", t)
    return t


def sqlq(v: str) -> str:
    return "'" + v.replace("'", "''") + "'"


def despacho_db(v: str) -> str:
    # nombre_institucion es VARCHAR(150); en UTF-8 conviene acotar por bytes.
    s = clean(v)
    b = s.encode("utf-8")
    if len(b) <= 150:
        return s
    cut = b[:150]
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
    muni_set_by_dept = {}
    for code, name in sorted(munis):
        d = code // 100
        if d not in first_muni_by_dept:
            first_muni_by_dept[d] = name
        muni_set_by_dept.setdefault(d, set()).add(norm(name))

    dept_by_norm = {norm(name): (d, name) for d, name in dept.items()}
    return dept_by_norm, first_muni_by_dept, muni_set_by_dept


def gen_catalog_scripts(df: pd.DataFrame) -> None:
    despachos = sorted({despacho_db(v) for v in df["DESPACHO"].dropna().unique() if clean(v)})

    tipo_lines = [
        "SET NAMES UTF8;",
        "",
        "INSERT INTO tipo_institucion (nombre, descripcion)",
        "SELECT 'Organismo Judicial', 'Fuente Medidas de Seguridad 2014-2024' FROM RDB$DATABASE",
        "WHERE NOT EXISTS (",
        "  SELECT 1 FROM tipo_institucion WHERE UPPER(TRIM(nombre)) = UPPER('Organismo Judicial')",
        ");",
        "",
        "COMMIT;",
    ]
    OUT_CAT_TIPO.write_text("\n".join(tipo_lines), encoding="utf-8")

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


def build_block(depto_name: str, muni_name: str, despacho: str, year_i: int, valor: int) -> str:
    despacho = despacho_db(despacho)
    key = f"{depto_name}|{muni_name}|{despacho}|{year_i}|{valor}"
    base = md5(key.encode("utf-8")).hexdigest()[:16].upper()
    fecha_hecho = f"{year_i:04d}-01-15"
    persona_nombre = f"MS_VCM_{base}"
    persona_apellido = f"VALOR_{valor}"

    return f"""EXECUTE BLOCK AS
  DECLARE id_depto INTEGER;
  DECLARE id_muni INTEGER;
  DECLARE id_ubic INTEGER;
  DECLARE id_inst INTEGER;
  DECLARE id_genero INTEGER;
  DECLARE id_grupo INTEGER;
  DECLARE id_eciv INTEGER;
  DECLARE id_alf INTEGER;
  DECLARE id_nivel INTEGER;
  DECLARE id_tipo_hecho INTEGER;
  DECLARE id_invol INTEGER;
  DECLARE id_persona INTEGER;
  DECLARE id_hecho INTEGER;
BEGIN
  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(depto_name)}) ROWS 1 INTO id_depto;
  IF (id_depto IS NULL) THEN SELECT id_departamento FROM departamento ORDER BY id_departamento ROWS 1 INTO id_depto;

  SELECT m.id_municipio
    FROM municipio m
   WHERE m.id_departamento = :id_depto
     AND UPPER(TRIM(m.nombre)) = UPPER({sqlq(muni_name)})
   ROWS 1 INTO id_muni;

  IF (id_muni IS NULL) THEN
    SELECT id_municipio FROM municipio WHERE id_departamento = :id_depto ORDER BY id_municipio ROWS 1 INTO id_muni;

  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :id_muni ROWS 1 INTO id_ubic;
  IF (id_ubic IS NULL) THEN
    INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia)
    VALUES (:id_muni, NULL, NULL, NULL, NULL)
    RETURNING id_ubicacion INTO id_ubic;

  SELECT id_institucion_organicacion FROM institucion_organicacion WHERE UPPER(TRIM(nombre_institucion)) = UPPER({sqlq(despacho)}) ROWS 1 INTO id_inst;
  IF (id_inst IS NULL) THEN EXIT;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO id_tipo_hecho;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO id_invol;

  SELECT h.id_hecho
    FROM hecho h
    JOIN persona p ON p.id_origen = h.id_ubicacion
    JOIN medida_seguridad ms ON ms.id_hecho = h.id_hecho
   WHERE p.nombres = {sqlq(persona_nombre)}
     AND p.apellidos = {sqlq(persona_apellido)}
     AND h.fecha_hecho = {sqlq(fecha_hecho)}
     AND ms.id_institucion_organicacion = :id_inst
   ROWS 1 INTO id_hecho;

  IF (id_hecho IS NULL) THEN BEGIN
    SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO id_genero;
    SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_grupo;
    SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_eciv;
    SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_alf;
    SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_nivel;
    IF (id_nivel IS NULL) THEN SELECT id_nivel_escolaridad FROM nivel_escolaridad ORDER BY id_nivel_escolaridad ROWS 1 INTO id_nivel;

    INSERT INTO persona (
      nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico,
      id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero
    ) VALUES (
      {sqlq(persona_nombre)}, {sqlq(persona_apellido)}, {sqlq(f"{year_i-30:04d}-01-15")}, NULL,
      :id_genero, NULL, :id_grupo, :id_eciv, :id_alf, :id_nivel, :id_ubic, 0
    ) RETURNING id_persona INTO id_persona;

    INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
    VALUES (:id_tipo_hecho, :id_ubic, {sqlq(fecha_hecho)})
    RETURNING id_hecho INTO id_hecho;

    INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento)
    VALUES (:id_hecho, :id_persona, :id_invol);

    INSERT INTO medida_seguridad (id_hecho, id_institucion_organicacion)
    VALUES (:id_hecho, :id_inst);
  END
END^"""


def main() -> None:
    df = pd.read_excel(SRC, sheet_name="Medidas de seguridad")
    dept_map, first_muni_by_dept, muni_set_by_dept = parse_muni_file(MUNI_FILE)

    gen_catalog_scripts(df)

    lines = [
        "SET NAMES UTF8;",
        "SET TERM ^ ;",
        "",
        "-- Fuente: Medidas de Seguridad 2012-2024.xlsx",
        "-- Regla territorial: catalogos/municipios/municipios- depto.txt",
        "-- Modelo de representacion: 1 registro fuente agregado = 1 evento trazable (valor conservado en huella sintetica)",
        "",
    ]

    skipped = 0
    for _, row in df.iterrows():
        dept_raw = clean(row.get("Departamento"))
        muni_raw = clean(row.get("Municipio"))
        despacho = clean(row.get("DESPACHO"))
        year_raw = clean(row.get("Año"))

        try:
            valor = int(float(row.get("Valor")))
        except Exception:
            valor = 0

        if not dept_raw or not despacho or not year_raw or valor <= 0:
            skipped += 1
            continue

        dept_key = norm(dept_raw)
        if dept_key not in dept_map:
            skipped += 1
            continue

        dept_id, dept_name = dept_map[dept_key]

        muni_name = first_muni_by_dept.get(dept_id, "")
        if muni_raw:
            muni_key = norm(muni_raw)
            if muni_key in muni_set_by_dept.get(dept_id, set()):
                muni_name = muni_raw

        if not muni_name:
            skipped += 1
            continue

        try:
            year_i = int(float(year_raw))
        except Exception:
            skipped += 1
            continue

        if year_i < 2014:
            year_i = 2014
        if year_i > 2024:
            year_i = 2024

        lines.append(build_block(dept_name, muni_name, despacho, year_i, valor))
        lines.append("")

    lines.extend(["SET TERM ; ^", "COMMIT;"])
    OUT_TX.write_text("\n".join(lines), encoding="utf-8")
    print(f"Catalogos: {OUT_CAT_TIPO.name}, {OUT_CAT_INST.name}")
    print(f"Transaccional: {OUT_TX} | filas fuente: {len(df)} | omitidas: {skipped}")


if __name__ == "__main__":
    main()
