from pathlib import Path
import re

import pandas as pd

SRC = Path("datos_base/Violencia/Violencia intrafamiliar/2024/base-de-datos-violencia-intrafamiliar-ano-2024_v3.xlsx")
MUNI_FILE = Path("catalogos/municipios/municipios- depto.txt")
START_INDEX = 0
ROW_LIMIT = 500
CHUNK_SIZE = 100

OUT_CAT_AGR = Path("sql/inserts/catalogos/091_tipo_agresion_intrafamiliar_2024.sql")
OUT_TX = Path("sql/inserts/transaccional/118_vif_2024_batch1_parcial.sql")
OUT_TX_CHUNKS_DIR = Path("sql/inserts/transaccional/chunks_118")


def clean(value) -> str:
    if pd.isna(value):
        return ""
    return str(value).strip()


def norm(value: str) -> str:
    text = clean(value).upper()
    for source, target in (("Á", "A"), ("É", "E"), ("Í", "I"), ("Ó", "O"), ("Ú", "U"), ("Ü", "U"), ("Ñ", "N")):
        text = text.replace(source, target)
    text = text.replace("\u00b4", "'").replace("`", "'")
    return re.sub(r"\s+", " ", text)


def sqlq(value: str) -> str:
    return "'" + str(value).replace("'", "''") + "'"


def safe_int(value, default=0):
    try:
        return int(float(value))
    except Exception:
        return default


def clamp(value: int, lo: int, hi: int) -> int:
    return max(lo, min(hi, value))


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

    muni_by_code = {code: name for code, name in municipalities}
    first_muni_by_dept = {}
    for code, name in sorted(municipalities):
        first_muni_by_dept.setdefault(code // 100, (code, name))

    return departments, muni_by_code, first_muni_by_dept


def parse_date(y, m, d):
    yy = clamp(safe_int(y, 2024), 2008, 2026)
    mm = clamp(safe_int(m, 1), 1, 12)
    dd = clamp(safe_int(d, 15), 1, 28)
    return f"{yy:04d}-{mm:02d}-{dd:02d}", yy


def map_sex(raw: str) -> str:
    v = clean(raw)
    if v in ("1", "M", "H", "HOMBRE"):
        return "Hombre"
    if v in ("2", "F", "MUJER"):
        return "Mujer"
    return "Ignorado"


def map_tipo_agresion(raw: str):
    code = clean(raw)
    if not code:
        return "TIPAGRE_SD"
    code = re.sub(r"\D", "", code)
    if not code:
        code = "SD"
    return f"TIPAGRE_{code}"


def write_catalog(df: pd.DataFrame):
    tipos = sorted({map_tipo_agresion(v) for v in df["HEC_TIPAGRE"].dropna().unique()})
    if not tipos:
        tipos = ["TIPAGRE_SD"]

    lines = ["SET NAMES UTF8;", ""]
    for t in tipos:
        lines.append(
            "INSERT INTO tipo_agresion_intrafamiliar (nombre, descripcion) "
            f"SELECT {sqlq(t)}, 'Fuente VIF 2024' FROM RDB$DATABASE "
            f"WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(t)}));"
        )
    lines.extend(["", "COMMIT;"])
    OUT_CAT_AGR.write_text("\n".join(lines), encoding="utf-8")


def block_sql(token, dept_name, muni_name, fecha_hecho, fecha_emision, sexo_vic, sexo_agr, vic_birth, agr_birth, quien_reporta, boleta, otras_vic, otros_agr, tipo_agre):
    boleta_lit = sqlq(boleta) if boleta else "NULL"
    reporta = sqlq(quien_reporta) if quien_reporta else "NULL"

    return f"""EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_tipo_agre INTEGER;
  DECLARE v_inv_vic INTEGER;
  DECLARE v_inv_agr INTEGER;
  DECLARE v_gen_vic INTEGER;
  DECLARE v_gen_agr INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_victima INTEGER;
  DECLARE v_agresor INTEGER;
  DECLARE v_hecho INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF24V_{token}' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(dept_name)}) ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER({sqlq(muni_name)}) ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD', 'SIN SELECCION') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(sexo_vic)}) ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(sexo_agr)}) ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF24V_{token}', 'VICTIMA', {sqlq(vic_birth)}, NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF24A_{token}', 'AGRESOR', {sqlq(agr_birth)}, NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, {sqlq(fecha_hecho)}) RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(tipo_agre)}) ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta, id_hecho, fecha_emision, id_tipo_agresion_intrafamiliar,
      id_victima, id_agresor_principal, quien_reporta, otras_victimas_total,
      agresores_otros_total, organismo_jurisdiccional, conducente, ley_aplicable, id_institucion_organicacion
  ) VALUES (
      {boleta_lit}, :v_hecho, {sqlq(fecha_emision)}, :v_tipo_agre,
      :v_victima, :v_agresor, {reporta}, {otras_vic},
      {otros_agr}, NULL, NULL, NULL, NULL
  );
END^"""


def split_blocks(sql_text: str):
    blocks = []
    cur = []
    in_block = False
    for line in sql_text.splitlines():
        if line.strip().startswith("EXECUTE BLOCK AS"):
            in_block = True
            cur = [line]
            continue
        if in_block:
            cur.append(line)
            if line.strip() == "END^":
                blocks.append("\n".join(cur))
                cur = []
                in_block = False
    return blocks


def main():
    full_df = pd.read_excel(SRC, sheet_name="Sheet1")
    total = len(full_df)
    end_idx = min(total, START_INDEX + ROW_LIMIT)
    df = full_df.iloc[START_INDEX:end_idx].copy()

    departments, muni_by_code, first_muni_by_dept = parse_municipios(MUNI_FILE)
    write_catalog(df)

    blocks = []
    skipped = 0

    for idx, row in df.iterrows():
        token = f"{idx+1:06d}"

        fecha_hecho, y_hecho = parse_date(row.get("HEC_ANO"), row.get("HEC_MES"), row.get("HEC_DIA"))
        fecha_emision, _ = parse_date(row.get("ANO_EMISION"), row.get("MES_EMISION"), row.get("DIA_EMISION"))

        dep_code = safe_int(row.get("HEC_DEPTO"), 0)
        if dep_code <= 0:
            dep_code = safe_int(row.get("HEC_DEPTOMCPIO"), 0) // 100
        dept_name = departments.get(dep_code)
        if not dept_name:
            skipped += 1
            continue

        muni_code = safe_int(row.get("HEC_DEPTOMCPIO"), 0)
        muni_name = muni_by_code.get(muni_code)
        if not muni_name:
            fallback = first_muni_by_dept.get(dep_code)
            if not fallback:
                skipped += 1
                continue
            muni_name = fallback[1]

        sexo_vic = map_sex(clean(row.get("VIC_SEXO")))
        sexo_agr = map_sex(clean(row.get("AGR_SEXO")))

        vic_edad = clamp(safe_int(row.get("VIC_EDAD"), 30), 0, 100)
        agr_edad = clamp(safe_int(row.get("AGR_EDAD"), 35), 0, 100)
        vic_birth = f"{(y_hecho - vic_edad):04d}-06-15"
        agr_birth = f"{(y_hecho - agr_edad):04d}-06-15"

        tipo_agre = map_tipo_agresion(row.get("HEC_TIPAGRE"))

        blocks.append(
            block_sql(
                token=token,
                dept_name=dept_name,
                muni_name=muni_name,
                fecha_hecho=fecha_hecho,
                fecha_emision=fecha_emision,
                sexo_vic=sexo_vic,
                sexo_agr=sexo_agr,
                vic_birth=vic_birth,
                agr_birth=agr_birth,
                quien_reporta=clean(row.get("QUIEN_REPORTA")),
                boleta=clean(row.get("NUMERO_BOLETA")),
                otras_vic=safe_int(row.get("OTRAS_VICTIMAS"), 0),
                otros_agr=safe_int(row.get("AGRESORES_OTROS_TOTAL"), 0),
                tipo_agre=tipo_agre,
            )
        )

    sql_full = "\n".join([
        "SET NAMES UTF8;",
        "SET TERM ^ ;",
        "",
        "-- Fuente: Violencia intrafamiliar 2024 (carga parcial)",
        "-- Flujo: catalogos -> ubicacion -> personas -> hecho -> involucrado_hecho -> caso_violencia_intrafamiliar",
        "",
        "\n\n".join(blocks),
        "",
        "SET TERM ; ^",
        "COMMIT;",
        "",
    ])

    OUT_TX.write_text(sql_full, encoding="utf-8")

    OUT_TX_CHUNKS_DIR.mkdir(parents=True, exist_ok=True)
    for old in OUT_TX_CHUNKS_DIR.glob("118_vif_2024_part_*.sql"):
        old.unlink()

    split = split_blocks(sql_full)
    for i in range(0, len(split), CHUNK_SIZE):
        part_blocks = split[i : i + CHUNK_SIZE]
        chunk_sql = "\n".join([
            "SET NAMES UTF8;",
            "SET TERM ^ ;",
            "",
            "\n\n".join(part_blocks),
            "",
            "SET TERM ; ^",
            "COMMIT;",
            "",
        ])
        part = i // CHUNK_SIZE + 1
        out = OUT_TX_CHUNKS_DIR / f"118_vif_2024_part_{part:02d}.sql"
        out.write_text(chunk_sql, encoding="utf-8")

    print(f"Total fuente: {total}")
    print(f"Rango parcial preparado: {START_INDEX + 1}..{end_idx}")
    print(f"Pendiente: {end_idx + 1}..{total}")
    print(f"Registros omitidos en generacion: {skipped}")


if __name__ == "__main__":
    main()
