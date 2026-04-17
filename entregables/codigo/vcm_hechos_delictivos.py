from pathlib import Path
from hashlib import md5
import re

import pandas as pd

SRC = Path(
    "datos_base/Violencia/Violencia contra la mujer/Hechos delictivos/Hechos delictivos contra mujeres de 2008 al 2024.xlsx"
)
MUNI_FILE = Path("catalogos/municipios/municipios- depto.txt")
OUT = Path("sql/inserts/transaccional/102_vcm_hechos_delictivos_batch1.sql")


DELITO_CODE = {
    "HOMICIDIO": "VCM-HD-DEL-001",
    "LESIONES": "VCM-HD-DEL-002",
    "DESAPARICIONES": "VCM-HD-DEL-003",
    "SECUESTROS": "VCM-HD-DEL-004",
    "VIOLENCIA": "VCM-HD-DEL-005",
    "OTROS": "VCM-HD-DEL-006",
}


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


def build_block(depto_name: str, default_muni: str, year_i: int, hecho: str, delito_code: str, valor: int) -> str:
    base = md5(f"{depto_name}|{year_i}|{hecho}|{delito_code}".encode("utf-8")).hexdigest()[:14].upper()
    fecha_hecho = f"{year_i:04d}-01-15"
    hecho_short = hecho[:120]

    return f"""EXECUTE BLOCK AS
  DECLARE id_depto INTEGER;
  DECLARE id_muni INTEGER;
  DECLARE id_ubic INTEGER;
  DECLARE id_genero INTEGER;
  DECLARE id_grupo INTEGER;
  DECLARE id_eciv INTEGER;
  DECLARE id_alf INTEGER;
  DECLARE id_nivel INTEGER;
  DECLARE id_tipo_hecho INTEGER;
  DECLARE id_invol INTEGER;
  DECLARE id_delito_cometido INTEGER;
  DECLARE id_persona INTEGER;
  DECLARE id_hecho INTEGER;
  DECLARE cnt_exist INTEGER;
  DECLARE seq_no INTEGER;
  DECLARE target_cnt INTEGER;
  DECLARE nombre_persona VARCHAR(150);
BEGIN
  target_cnt = {valor};

  SELECT id_departamento
    FROM departamento
   WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(depto_name)})
   ROWS 1
    INTO id_depto;

  IF (id_depto IS NULL) THEN
    SELECT id_departamento FROM departamento ORDER BY id_departamento ROWS 1 INTO id_depto;

  SELECT m.id_municipio
    FROM municipio m
   WHERE m.id_departamento = :id_depto
     AND UPPER(TRIM(m.nombre)) = UPPER({sqlq(default_muni)})
   ROWS 1
    INTO id_muni;

  IF (id_muni IS NULL) THEN
    SELECT id_municipio FROM municipio WHERE id_departamento = :id_depto ORDER BY id_municipio ROWS 1 INTO id_muni;

  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :id_muni ROWS 1 INTO id_ubic;
  IF (id_ubic IS NULL) THEN
    INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia)
    VALUES (:id_muni, NULL, NULL, NULL, NULL)
    RETURNING id_ubicacion INTO id_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO id_genero;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_nivel;
  IF (id_nivel IS NULL) THEN SELECT id_nivel_escolaridad FROM nivel_escolaridad ORDER BY id_nivel_escolaridad ROWS 1 INTO id_nivel;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO id_tipo_hecho;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO id_invol;
  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
   WHERE d.codigo = {sqlq(delito_code)}
   ROWS 1
    INTO id_delito_cometido;

  IF (id_tipo_hecho IS NULL OR id_invol IS NULL OR id_delito_cometido IS NULL) THEN
    EXIT;

  SELECT COUNT(*)
    FROM persona p
    JOIN involucrado_hecho ih ON ih.id_involucrado = p.id_persona
    JOIN hecho h ON h.id_hecho = ih.id_hecho
    JOIN hecho_delictivo hd ON hd.id_hecho = h.id_hecho
   WHERE p.nombres STARTING WITH {sqlq('HDVCM_' + base + '_')}
     AND p.apellidos = {sqlq(hecho_short)}
     AND h.fecha_hecho = {sqlq(fecha_hecho)}
     AND ih.id_tipo_involucramiento = :id_invol
     AND hd.id_delito = :id_delito_cometido
    INTO cnt_exist;

  seq_no = cnt_exist + 1;
  WHILE (seq_no <= target_cnt) DO BEGIN
    nombre_persona = 'HDVCM_{base}_' || CAST(seq_no AS VARCHAR(10));

    INSERT INTO persona (
      nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico,
      id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero
    ) VALUES (
      :nombre_persona, {sqlq(hecho_short)}, {sqlq(f"{year_i-30:04d}-01-15")}, NULL,
      :id_genero, NULL, :id_grupo, :id_eciv, :id_alf, :id_nivel, :id_ubic, 0
    ) RETURNING id_persona INTO id_persona;

    INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
    VALUES (:id_tipo_hecho, :id_ubic, {sqlq(fecha_hecho)})
    RETURNING id_hecho INTO id_hecho;

    INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento)
    VALUES (:id_hecho, :id_persona, :id_invol);

    INSERT INTO hecho_delictivo (id_hecho, id_delito)
    VALUES (:id_hecho, :id_delito_cometido);

    seq_no = seq_no + 1;
  END
END^"""


def main() -> None:
    df = pd.read_excel(SRC, sheet_name="Hchos delictivos 2008-2024")
    dept_map, first_muni_by_dept = parse_muni_file(MUNI_FILE)

    lines = [
        "SET NAMES UTF8;",
        "SET TERM ^ ;",
        "",
        "-- Fuente: Hechos delictivos contra mujeres de 2008 al 2024.xlsx",
        "-- Territorialidad basada en catalogos/municipios/municipios- depto.txt (prefijo numerico depto->municipio)",
        "",
    ]

    skipped = 0
    for _, row in df.iterrows():
        dept_raw = clean(row.get("DEPARTAMENTO"))
        year_raw = clean(row.get("AÑO"))
        hecho = clean(row.get("HECHO DELICTIVO"))
        delito = norm(clean(row.get("DELITO")))

        try:
            valor = int(float(row.get("VALOR")))
        except Exception:
            valor = 0

        if not dept_raw or not year_raw or not hecho or delito not in DELITO_CODE or valor <= 0:
            skipped += 1
            continue

        dept_key = norm(dept_raw)
        if dept_key not in dept_map:
            skipped += 1
            continue

        dept_id, dept_name = dept_map[dept_key]
        default_muni = first_muni_by_dept.get(dept_id, "")
        if not default_muni:
            skipped += 1
            continue

        try:
            year_i = int(float(year_raw))
        except Exception:
            skipped += 1
            continue

        if year_i < 2008:
            year_i = 2008
        if year_i > 2024:
            year_i = 2024

        lines.append(build_block(dept_name, default_muni, year_i, hecho, DELITO_CODE[delito], valor))
        lines.append("")

    lines.extend(["SET TERM ; ^", "COMMIT;"])
    OUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"Archivo generado: {OUT} | filas fuente: {len(df)} | omitidas: {skipped}")


if __name__ == "__main__":
    main()
