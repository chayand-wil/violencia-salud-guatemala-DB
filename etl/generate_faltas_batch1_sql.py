from pathlib import Path
import re

import pandas as pd

SRC = Path("datos_base/Violencia/Faltas judiciales/20240524231759eHmz6DmFKboNQ5Y3OlqNkbi9izmXULaP.xlsx")
OUT = Path("sql/inserts/transaccional/101_faltas_judiciales_batch1.sql")


def clean(v) -> str:
    if pd.isna(v):
        return ""
    return str(v).strip()


def sql_quote(text: str) -> str:
    return "'" + text.replace("'", "''") + "'"


def norm_key(txt: str) -> str:
    t = txt.upper()
    for a, b in (("Á", "A"), ("É", "E"), ("Í", "I"), ("Ó", "O"), ("Ú", "U"), ("Ü", "U"), ("Ñ", "N")):
        t = t.replace(a, b)
    t = re.sub(r"\s+", " ", t).strip()
    return t


month_map = {
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

falta_map = {
    "CONTRA LAS PERSONAS": "Las personas",
    "CONTRA LA PROPIEDAD": "La propiedad",
    "CONTRA LAS BUENAS COSTUMBRES": "Las buenas costumbres",
    "CONTRA EL ORDEN PUBLICO": "Orden público",
    "OTRAS": "Otras",
}

genero_map = {"HOMBRES": "Hombre", "MUJERES": "Mujer"}
grupo_map = {"INDIGENA": "Indígena", "NO INDIGENA": "No indígena", "IGNORADO": "Ignorado"}
estado_map = {
    "SOLTERO(A)": "Soltero (a)",
    "CASADO(A)": "Casado (a)",
    "UNIDO(A)": "Unido (a)",
    "VIUDO(A)": "Viudo (a)",
    "DIVORCIADO(A)": "Divorciado (a)",
    "IGNORADO": "Ignorado",
}
area_map = {"URBANA": "Urbano", "RURAL": "Rural", "IGNORADA": "Ignorado", "IGNORADO": "Ignorado"}


def build_block(row: pd.Series) -> str:
    num = clean(row.get("Núm_corre"))
    depto = clean(row.get("Depto_boleta"))
    muni = clean(row.get("Muni_boleta"))
    mes = clean(row.get("Mes_boleta")).upper()
    anio = clean(row.get("Año_boleta"))
    falta_raw = clean(row.get("Falta_inf"))
    sexo_raw = clean(row.get("Sexo_inf"))
    edad_raw = clean(row.get("Edad_inf"))
    grupo_raw = clean(row.get("Grupo_étnico_inf"))
    eciv_raw = clean(row.get("Est_conyugal_inf"))
    alf_raw = clean(row.get("Cond_alfabetismo_inf"))
    nivel_raw = clean(row.get("Niv_escolaridad_inf"))
    area_raw = clean(row.get("Área_geo_inf"))

    falta_name = falta_map.get(norm_key(falta_raw), "Otras")
    genero_name = genero_map.get(norm_key(sexo_raw), "Ignorado")
    grupo_name = grupo_map.get(norm_key(grupo_raw), "Ignorado")
    eciv_name = estado_map.get(norm_key(eciv_raw), "Ignorado")
    area_name = area_map.get(norm_key(area_raw), "Ignorado")
    mes_num = month_map.get(norm_key(mes), "01")

    try:
        year_i = int(float(anio)) if anio else 2023
    except Exception:
        year_i = 2023
    if year_i < 2023 or year_i > 2023:
        year_i = 2023

    edad_val = None
    if edad_raw:
        try:
            edad_val = int(float(edad_raw))
            if edad_val < 0 or edad_val > 110:
                edad_val = None
        except Exception:
            edad_val = None

    if edad_val is None:
        fnac = f"{year_i - 30:04d}-06-15"
    else:
        fnac = f"{year_i - edad_val:04d}-06-15"

    fhecho = f"{year_i:04d}-{mes_num}-01"
    nombre_persona = f"FJ_INFRACTOR_{num if num else 'SN'}"
    apellido_persona = f"{depto if depto else 'SIN_DEPTO'}_{muni if muni else 'SIN_MUNI'}"

    nivel_name = nivel_raw if nivel_raw else "Ignorado"
    alf_name = alf_raw if alf_raw else "Ignorado"

    return f"""EXECUTE BLOCK AS
  DECLARE id_muni INTEGER;
  DECLARE id_depto INTEGER;
  DECLARE id_area INTEGER;
  DECLARE id_ubic INTEGER;
  DECLARE id_genero INTEGER;
  DECLARE id_grupo INTEGER;
  DECLARE id_eciv INTEGER;
  DECLARE id_alf INTEGER;
  DECLARE id_nivel INTEGER;
  DECLARE id_tipo_hecho INTEGER;
  DECLARE id_tipo_falta INTEGER;
  DECLARE id_invol INTEGER;
  DECLARE id_persona INTEGER;
  DECLARE id_hecho INTEGER;
BEGIN
  SELECT d.id_departamento
    FROM departamento d
   WHERE UPPER(TRIM(d.nombre)) = UPPER({sql_quote(depto)})
   ROWS 1
    INTO id_depto;

  IF (id_depto IS NOT NULL) THEN BEGIN
    SELECT m.id_municipio
      FROM municipio m
     WHERE m.id_departamento = :id_depto
       AND UPPER(TRIM(m.nombre)) = UPPER({sql_quote(muni)})
     ROWS 1
      INTO id_muni;

    IF (id_muni IS NULL) THEN
      SELECT m.id_municipio
        FROM municipio m
       WHERE m.id_departamento = :id_depto
       ORDER BY m.id_municipio
       ROWS 1
        INTO id_muni;
  END

  IF (id_muni IS NULL) THEN
    SELECT id_municipio FROM municipio ORDER BY id_municipio ROWS 1 INTO id_muni;

  SELECT id_area_geografica FROM area_geografica WHERE UPPER(TRIM(nombre)) = UPPER({sql_quote(area_name)}) ROWS 1 INTO id_area;
  IF (id_area IS NULL) THEN SELECT id_area_geografica FROM area_geografica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_area;

  SELECT id_ubicacion
    FROM ubicacion
   WHERE id_municipio = :id_muni
     AND COALESCE(id_area_geografica, -1) = COALESCE(:id_area, -1)
   ROWS 1
    INTO id_ubic;

  IF (id_ubic IS NULL) THEN
    INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia)
    VALUES (:id_muni, :id_area, NULL, NULL, NULL)
    RETURNING id_ubicacion INTO id_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER({sql_quote(genero_name)}) ROWS 1 INTO id_genero;
  IF (id_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_genero;

  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER({sql_quote(grupo_name)}) ROWS 1 INTO id_grupo;
  IF (id_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_grupo;

  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER({sql_quote(eciv_name)}) ROWS 1 INTO id_eciv;
  IF (id_eciv IS NULL) THEN SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_eciv;

  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER({sql_quote(alf_name)}) ROWS 1 INTO id_alf;
  IF (id_alf IS NULL) THEN SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_alf;

  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER({sql_quote(nivel_name)}) ROWS 1 INTO id_nivel;
  IF (id_nivel IS NULL) THEN SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_nivel;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('falta_judicial') ROWS 1 INTO id_tipo_hecho;
  SELECT id_tipo_falta FROM tipo_falta WHERE UPPER(TRIM(nombre)) = UPPER({sql_quote(falta_name)}) ROWS 1 INTO id_tipo_falta;
  IF (id_tipo_falta IS NULL) THEN SELECT id_tipo_falta FROM tipo_falta WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO id_tipo_falta;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Infractor') ROWS 1 INTO id_invol;

  SELECT p.id_persona, h.id_hecho
    FROM persona p
    JOIN involucrado_hecho ih ON ih.id_involucrado = p.id_persona
    JOIN hecho h ON h.id_hecho = ih.id_hecho
    JOIN falta f ON f.id_hecho = h.id_hecho
   WHERE p.nombres = {sql_quote(nombre_persona)}
     AND p.apellidos = {sql_quote(apellido_persona)}
     AND h.fecha_hecho = {sql_quote(fhecho)}
     AND f.id_tipo_falta = :id_tipo_falta
     AND ih.id_tipo_involucramiento = :id_invol
   ROWS 1
    INTO id_persona, id_hecho;

  IF (id_hecho IS NULL) THEN BEGIN
    INSERT INTO persona (
      nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico,
      id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero
    ) VALUES (
      {sql_quote(nombre_persona)}, {sql_quote(apellido_persona)}, {sql_quote(fnac)}, NULL, :id_genero,
      NULL, :id_grupo, :id_eciv, :id_alf, :id_nivel, :id_ubic, 0
    ) RETURNING id_persona INTO id_persona;

    INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
    VALUES (:id_tipo_hecho, :id_ubic, {sql_quote(fhecho)})
    RETURNING id_hecho INTO id_hecho;

    INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento)
    VALUES (:id_hecho, :id_persona, :id_invol);

    INSERT INTO falta (id_hecho, id_tipo_falta)
    VALUES (:id_hecho, :id_tipo_falta);
  END
END^"""


def main() -> None:
    df = pd.read_excel(SRC, sheet_name="Sheet1")

    lines = [
        "SET NAMES UTF8;",
        "SET TERM ^ ;",
        "",
        "-- Fuente: datos_base/Violencia/Faltas judiciales/20240524231759eHmz6DmFKboNQ5Y3OlqNkbi9izmXULaP.xlsx",
        "-- Carga transaccional idempotente: hecho -> persona -> involucrado_hecho -> falta",
        "-- Regla de involucramiento por defecto para faltas judiciales: Infractor",
        "",
    ]

    for _, row in df.iterrows():
        lines.append(build_block(row))
        lines.append("")

    lines.extend(["SET TERM ; ^", "COMMIT;"])
    OUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"Archivo generado: {OUT} | filas: {len(df)}")


if __name__ == "__main__":
    main()
