from pathlib import Path
import re

import pandas as pd

SRC = Path(
    "datos_base/Violencia/Violencia contra la ninez/Quejas Mineduc/"
    "20240719123138C8M6SpIQkU1dO569us4WzmhiEojxPhwf.xlsx"
)
MUNI_FILE = Path("catalogos/municipios/municipios- depto.txt")

DEPT_LIMIT = 6
MAX_EVENTS = 250
CHUNK_SIZE = 60

OUT_CAT_AGR = Path("sql/inserts/catalogos/089_tipo_agresion_ninez_quejas_mineduc.sql")
OUT_CAT_ESC = Path("sql/inserts/catalogos/090_estado_escolarizacion_ninez.sql")
OUT_TX = Path("sql/inserts/transaccional/117_quejas_mineduc_batch1_parcial.sql")
OUT_TX_CHUNKS_DIR = Path("sql/inserts/transaccional/chunks_117")


def clean(value) -> str:
    if pd.isna(value):
        return ""
    return str(value).strip()


def sqlq(value: str) -> str:
    return "'" + str(value).replace("'", "''") + "'"


def norm(value: str) -> str:
    text = clean(value).upper()
    for source, target in (
        ("Á", "A"),
        ("É", "E"),
        ("Í", "I"),
        ("Ó", "O"),
        ("Ú", "U"),
        ("Ü", "U"),
        ("Ñ", "N"),
    ):
        text = text.replace(source, target)
    return re.sub(r"\s+", " ", text)


def safe_int(value, default=0):
    try:
        return int(float(value))
    except Exception:
        return default


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

    dep_by_norm = {norm(name): (code, name) for code, name in departments.items()}
    first_muni_by_dept = {}
    for code, name in sorted(municipalities):
        first_muni_by_dept.setdefault(code // 100, name)

    return dep_by_norm, first_muni_by_dept


def load_source(path: Path):
    df = pd.read_excel(path, sheet_name="C1", header=2)
    # Row 0 after header is the subheader with names of aggressions.
    subheader = df.iloc[0]

    dep_col = "Departamento registro"
    data = df.iloc[1:].copy()
    data = data[data[dep_col].notna()]
    data[dep_col] = data[dep_col].astype(str).str.strip()
    data = data[data[dep_col].str.upper() != "TOTAL"]

    aggression_cols = []
    for col in data.columns[1:9]:
        label = clean(subheader[col])
        if not label:
            continue
        if label.lower() == "total":
            continue
        aggression_cols.append((col, label))

    return data, aggression_cols


def write_catalogs(aggressions):
    cat_lines = ["SET NAMES UTF8;", ""]
    for name in aggressions:
        cat_lines.append(
            "INSERT INTO tipo_agresion_ninez (nombre, descripcion) "
            f"SELECT {sqlq(name)}, 'Fuente Quejas Mineduc 2023' FROM RDB$DATABASE "
            f"WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(name)}));"
        )
    cat_lines.extend(["", "COMMIT;"])
    OUT_CAT_AGR.write_text("\n".join(cat_lines), encoding="utf-8")

    esc_lines = ["SET NAMES UTF8;", ""]
    esc_lines.append(
        "INSERT INTO estado_escolarizacion (nombre, descripcion, es_escolarizado) "
        "SELECT 'Escolarizada', 'Fuente Quejas Mineduc', 1 FROM RDB$DATABASE "
        "WHERE NOT EXISTS (SELECT 1 FROM estado_escolarizacion WHERE UPPER(TRIM(nombre)) = UPPER('Escolarizada'));"
    )
    esc_lines.append(
        "INSERT INTO tipo_hecho (nombre, descripcion) "
        "SELECT 'violencia_contra_la_ninez', 'Fuente Quejas Mineduc' FROM RDB$DATABASE "
        "WHERE NOT EXISTS (SELECT 1 FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez'));"
    )
    esc_lines.extend(["", "COMMIT;"])
    OUT_CAT_ESC.write_text("\n".join(esc_lines), encoding="utf-8")


def block_sql(token: str, dept_name: str, muni_name: str, agresion: str, fecha: str, edad: int):
    return f"""EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_tipo_agre INTEGER;
  DECLARE v_estado_esc INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_victima INTEGER;
  DECLARE v_hecho INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_{token}' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(dept_name)}) ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER({sqlq(muni_name)}) ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;

  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN
    INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia)
    VALUES (:v_muni, NULL, NULL, NULL, NULL)
    RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;

  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;

  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD', 'SIN SELECCION') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;

  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (
      nombres, apellidos, fecha_nacimiento, cui,
      id_genero, id_orientacion_sexual, id_grupo_etnico,
      id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad,
      id_origen, es_extranjero
  ) VALUES (
      'QMN23V_{token}', 'NINEZ', {sqlq(f"{2023 - edad:04d}-06-15")}, NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, {sqlq(fecha)})
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(agresion)}) ROWS 1 INTO v_tipo_agre;
  SELECT id_estado_escolarizacion FROM estado_escolarizacion WHERE UPPER(TRIM(nombre)) = UPPER('Escolarizada') ROWS 1 INTO v_estado_esc;

  INSERT INTO caso_violencia_ninez (
      id_hecho,
      id_victima,
      id_tipo_agresion_ninez,
      id_estado_escolarizacion,
      relacionado_trabajo_infantil
  ) VALUES (
      :v_hecho,
      :v_victima,
      :v_tipo_agre,
      :v_estado_esc,
      0
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
    data, aggression_cols = load_source(SRC)

    dep_by_norm, first_muni_by_dept = parse_municipios(MUNI_FILE)
    aggression_names = [label for _, label in aggression_cols]
    write_catalogs(aggression_names)

    selected_depts = data["Departamento registro"].head(DEPT_LIMIT).tolist()
    data = data[data["Departamento registro"].isin(selected_depts)].copy()

    blocks = []
    event_counter = 0

    for _, row in data.iterrows():
        dept = clean(row["Departamento registro"])
        dep_match = dep_by_norm.get(norm(dept))
        if not dep_match:
            continue

        dep_code, dep_name = dep_match
        muni_name = first_muni_by_dept.get(dep_code)
        if not muni_name:
            continue

        for col, aggr in aggression_cols:
            qty = safe_int(row.get(col), 0)
            if qty <= 0:
                continue

            for _ in range(qty):
                if event_counter >= MAX_EVENTS:
                    break
                event_counter += 1
                token = f"{event_counter:06d}"

                # Regla simple para mantener edades plausibles en niñez.
                if "menor de 14" in aggr.lower():
                    edad = 13
                else:
                    edad = 12

                month = ((event_counter - 1) % 12) + 1
                day = ((event_counter - 1) % 28) + 1
                fecha = f"2023-{month:02d}-{day:02d}"

                blocks.append(
                    block_sql(
                        token=token,
                        dept_name=dep_name,
                        muni_name=muni_name,
                        agresion=aggr,
                        fecha=fecha,
                        edad=edad,
                    )
                )
            if event_counter >= MAX_EVENTS:
                break
        if event_counter >= MAX_EVENTS:
            break

    sql_full = "\n".join([
        "SET NAMES UTF8;",
        "SET TERM ^ ;",
        "",
        "-- Fuente: Quejas Mineduc 2023 (carga parcial)",
        "-- Flujo: catalogos -> ubicacion -> persona -> hecho -> caso_violencia_ninez",
        "",
        "\n\n".join(blocks),
        "",
        "SET TERM ; ^",
        "COMMIT;",
        "",
    ])

    OUT_TX.write_text(sql_full, encoding="utf-8")

    OUT_TX_CHUNKS_DIR.mkdir(parents=True, exist_ok=True)
    for old in OUT_TX_CHUNKS_DIR.glob("117_quejas_mineduc_part_*.sql"):
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
        out = OUT_TX_CHUNKS_DIR / f"117_quejas_mineduc_part_{part:02d}.sql"
        out.write_text(chunk_sql, encoding="utf-8")

    print(f"Departamentos usados en parcial: {len(selected_depts)}")
    print(f"Eventos sinteticos generados: {event_counter}")
    print("Pendiente: continuar con departamentos restantes y/o mayor volumen por departamento")


if __name__ == "__main__":
    main()
