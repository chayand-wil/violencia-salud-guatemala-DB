from pathlib import Path
import pandas as pd

SRC = Path(
    "datos_base/Violencia/Violencia contra la mujer/Sentencias por delito/Sentencias del Ministerio Publico por el delito de Violencia Contra la Mujer.xlsx"
)
OUT = Path("sql/inserts/transaccional/104_vcm_sentencias_mp_batch1.sql")


def sqlq(v: str) -> str:
    return "'" + str(v).replace("'", "''") + "'"


def main() -> None:
    df = pd.read_excel(SRC, sheet_name="Sentencias 2008-2024")

    lines = [
        "SET NAMES UTF8;",
        "SET TERM ^ ;",
        "",
        "-- Fuente: Sentencias del Ministerio Publico por el delito de Violencia Contra la Mujer.xlsx",
        "-- Flujo: persona -> hecho -> involucrado_hecho -> sentencia -> sentencia_hecho",
        "",
    ]

    for i, row in df.iterrows():
        fecha_raw = row.get("Fecha")
        indicador = str(row.get("Indicador") or "").strip().upper()
        try:
            valor = int(float(row.get("Valor") or 0))
        except Exception:
            valor = 0

        if pd.isna(fecha_raw) or valor <= 0:
            continue

        fecha = pd.to_datetime(fecha_raw).date().isoformat()
        yy = int(str(fecha)[:4])
        nacimiento = f"{yy-30:04d}-01-15"

        # id estable por fila para idempotencia
        base = f"SMPVCM_{i+1:05d}"
        apellido = indicador[:140] if indicador else "SENTENCIA CONDENATORIA"

        block = f"""EXECUTE BLOCK AS
  DECLARE id_inst INTEGER;
  DECLARE id_tipo_fallo INTEGER;
  DECLARE id_tipo_sent INTEGER;
  DECLARE id_delito INTEGER;
  DECLARE id_invol INTEGER;
  DECLARE id_muni INTEGER;
  DECLARE id_ubic INTEGER;
  DECLARE id_genero INTEGER;
  DECLARE id_grupo INTEGER;
  DECLARE id_eciv INTEGER;
  DECLARE id_alf INTEGER;
  DECLARE id_nivel INTEGER;
  DECLARE id_tipo_hecho INTEGER;
  DECLARE id_persona INTEGER;
  DECLARE id_hecho INTEGER;
  DECLARE id_sentencia INTEGER;
  DECLARE cnt_exist INTEGER;
  DECLARE seq_no INTEGER;
  DECLARE target_cnt INTEGER;
  DECLARE pnombre VARCHAR(150);
BEGIN
  target_cnt = {valor};

  SELECT id_institucion_organicacion
    FROM institucion_organicacion
   WHERE UPPER(TRIM(nombre_institucion)) = UPPER('Ministerio Publico')
   ROWS 1 INTO id_inst;

  SELECT id_tipo_fallo FROM tipo_fallo WHERE UPPER(TRIM(nombre)) = UPPER('Condenatoria') ROWS 1 INTO id_tipo_fallo;
  SELECT id_tipo_sentencia FROM tipo_sentencia WHERE UPPER(TRIM(nombre)) = UPPER('Violencia contra la mujer') ROWS 1 INTO id_tipo_sent;
  SELECT id_delito FROM delito WHERE UPPER(TRIM(nombre)) = UPPER('Violencia contra la mujer') ROWS 1 INTO id_delito;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO id_invol;
  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO id_tipo_hecho;

  IF (id_inst IS NULL OR id_tipo_fallo IS NULL OR id_tipo_sent IS NULL OR id_delito IS NULL OR id_invol IS NULL OR id_tipo_hecho IS NULL) THEN
    EXIT;

  SELECT id_municipio FROM municipio m
  JOIN departamento d ON d.id_departamento = m.id_departamento
  WHERE UPPER(TRIM(d.nombre)) = UPPER('Guatemala')
    AND UPPER(TRIM(m.nombre)) = UPPER('Guatemala')
  ROWS 1 INTO id_muni;

  IF (id_muni IS NULL) THEN SELECT id_municipio FROM municipio ORDER BY id_municipio ROWS 1 INTO id_muni;

  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :id_muni ROWS 1 INTO id_ubic;
  IF (id_ubic IS NULL) THEN
    INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia)
    VALUES (:id_muni, NULL, NULL, NULL, NULL)
    RETURNING id_ubicacion INTO id_ubic;

  SELECT COUNT(*)
    FROM sentencia s
    JOIN persona p ON p.id_persona = s.id_persona
   WHERE p.nombres STARTING WITH {sqlq(base + '_')}
     AND s.fecha_sentencia = {sqlq(fecha)}
     AND s.id_institucion_organicacion = :id_inst
     AND s.id_tipo_fallo = :id_tipo_fallo
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
      :pnombre, {sqlq(apellido)}, {sqlq(nacimiento)}, NULL,
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
      {sqlq(fecha)}, :id_inst, :id_persona, :id_tipo_fallo,
      :id_delito, :id_invol, :id_tipo_sent
    ) RETURNING id_sentencia INTO id_sentencia;

    INSERT INTO sentencia_hecho (id_sentencia, id_hecho)
    VALUES (:id_sentencia, :id_hecho);

    seq_no = seq_no + 1;
  END
END^"""

        lines.append(block)
        lines.append("")

    lines.extend(["SET TERM ; ^", "COMMIT;"])
    OUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"Archivo generado: {OUT} | filas fuente: {len(df)}")


if __name__ == "__main__":
    main()
