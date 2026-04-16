import datetime as dt
from pathlib import Path

import pandas as pd

src = Path("datos_base/Violencia/Violencia contra la mujer/Denuncias registradas/Denuncias del MP por el delito de VCM.xlsx")
out = Path("sql/inserts/transaccional/100_vcm_denuncias_batch1.sql")
out.parent.mkdir(parents=True, exist_ok=True)


def esc(s):
    return s.replace("'", "''")


def norm(v):
    if pd.isna(v):
        return None
    s = str(v).strip()
    return s if s else None


def to_date(v):
    if pd.isna(v):
        return None
    if isinstance(v, pd.Timestamp):
        return v.date()
    if isinstance(v, dt.date):
        return v
    return None


def birth_from_age(fecha, edad):
    if fecha is None:
        return None
    try:
        e = int(str(edad))
    except Exception:
        return None
    if e < 0 or e > 100:
        return None
    return dt.date(fecha.year - e, 6, 15)


df = pd.read_excel(
    src,
    usecols=[
        "Fecha",
        "Departamento",
        "Municipio",
        "Edad",
        "Escolaridad",
        "Pueblo de Pertenencia",
        "Orientacion",
        "Estado Caso",
    ],
).head(2000)

lines = ["SET NAMES UTF8;", "SET TERM ^ ;", ""]

for i, r in df.iterrows():
    fecha = to_date(r["Fecha"])
    dep = norm(r["Departamento"])
    mun = norm(r["Municipio"])
    if not (fecha and dep and mun):
        continue

    escolaridad = norm(r["Escolaridad"]) or "No registrado"
    etnia = norm(r["Pueblo de Pertenencia"]) or "Sin seleccion"
    orient = norm(r["Orientacion"]) or "Sin seleccion"
    estado = norm(r["Estado Caso"]) or "Ignorado"
    fnac = birth_from_age(fecha, norm(r["Edad"]))

    fecha_sql = fecha.strftime("%Y-%m-%d")
    fnac_sql = f"'{fnac.strftime('%Y-%m-%d')}'" if fnac else "NULL"

    lines.extend(
        [
            "EXECUTE BLOCK AS",
            "  DECLARE id_muni INTEGER;",
            "  DECLARE id_ubic INTEGER;",
            "  DECLARE id_persona INTEGER;",
            "  DECLARE id_hecho INTEGER;",
            "  DECLARE id_denuncia INTEGER;",
            "  DECLARE id_genero INTEGER;",
            "  DECLARE id_orient INTEGER;",
            "  DECLARE id_grupo INTEGER;",
            "  DECLARE id_eciv INTEGER;",
            "  DECLARE id_alf INTEGER;",
            "  DECLARE id_nivel INTEGER;",
            "  DECLARE id_estado INTEGER;",
            "  DECLARE id_tipo_hecho INTEGER;",
            "  DECLARE id_invol INTEGER;",
            "  DECLARE id_inst INTEGER;",
            "  DECLARE id_del_comp INTEGER;",
            "BEGIN",
            f"  SELECT m.id_municipio FROM municipio m JOIN departamento d ON d.id_departamento=m.id_departamento WHERE UPPER(TRIM(d.nombre))=UPPER('{esc(dep)}') AND UPPER(TRIM(m.nombre))=UPPER('{esc(mun)}') ROWS 1 INTO id_muni;",
            "  IF (id_muni IS NOT NULL) THEN BEGIN",
            "    SELECT id_ubicacion FROM ubicacion WHERE id_municipio=:id_muni ROWS 1 INTO id_ubic;",
            "    IF (id_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:id_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO id_ubic;",
            "    SELECT id_genero FROM genero WHERE UPPER(nombre)=UPPER('Mujer') ROWS 1 INTO id_genero;",
            f"    SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(nombre)=UPPER('{esc(orient)}') ROWS 1 INTO id_orient;",
            "    IF (id_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(nombre)=UPPER('Sin seleccion') ROWS 1 INTO id_orient;",
            f"    SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(nombre)=UPPER('{esc(etnia)}') ROWS 1 INTO id_grupo;",
            "    IF (id_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(nombre)=UPPER('Sin seleccion') ROWS 1 INTO id_grupo;",
            "    SELECT id_estado_civil FROM estado_civil WHERE UPPER(nombre)=UPPER('Ignorado') ROWS 1 INTO id_eciv;",
            "    SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(nombre)=UPPER('Ignorado') ROWS 1 INTO id_alf;",
            f"    SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(nombre)=UPPER('{esc(escolaridad)}') ROWS 1 INTO id_nivel;",
            "    IF (id_nivel IS NULL) THEN SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(nombre)=UPPER('No registrado') ROWS 1 INTO id_nivel;",
            f"    INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero) VALUES ('Persona_{i+1}', 'VCM', {fnac_sql}, NULL, :id_genero, :id_orient, :id_grupo, :id_eciv, :id_alf, :id_nivel, :id_ubic, 0) RETURNING id_persona INTO id_persona;",
            "    SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(nombre)=UPPER('hecho_delictivo') ROWS 1 INTO id_tipo_hecho;",
            f"    INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:id_tipo_hecho, :id_ubic, '{fecha_sql}') RETURNING id_hecho INTO id_hecho;",
            f"    SELECT id_estado_denuncia FROM estado_denuncia WHERE UPPER(nombre)=UPPER('{esc(estado)}') ROWS 1 INTO id_estado;",
            "    IF (id_estado IS NULL) THEN SELECT id_estado_denuncia FROM estado_denuncia WHERE UPPER(nombre)=UPPER('Ignorado') ROWS 1 INTO id_estado;",
            "    SELECT i.id_institucion_organicacion FROM institucion_organicacion i WHERE UPPER(i.nombre_institucion)=UPPER('Ministerio Publico') ROWS 1 INTO id_inst;",
            f"    INSERT INTO denuncia (id_hecho, fecha_denuncia, id_estado_denuncia, id_entididad_denuncia) VALUES (:id_hecho, '{fecha_sql}', :id_estado, :id_inst) RETURNING id_denuncia INTO id_denuncia;",
            f"    INSERT INTO denuncia_estado_historial (id_denuncia, id_estado_denuncia, fecha_estado, observaciones) VALUES (:id_denuncia, :id_estado, '{fecha_sql}', 'Carga lote 1 Denuncias MP VCM');",
            "    SELECT id_involucramiento FROM involucramiento WHERE UPPER(nombre)=UPPER('Denunciante') ROWS 1 INTO id_invol;",
            "    INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:id_hecho, :id_persona, :id_invol);",
            "    SELECT dc.id_delito_cometido FROM delito_cometido dc JOIN delito d ON d.id_delito=dc.id_tipo_delito WHERE UPPER(d.nombre)=UPPER('Violencia contra la mujer') ROWS 1 INTO id_del_comp;",
            "    IF (id_del_comp IS NOT NULL) THEN INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:id_hecho, :id_del_comp);",
            "  END",
            "END^",
            "",
        ]
    )

lines.extend(["SET TERM ; ^", "COMMIT;"])
out.write_text("\n".join(lines), encoding="utf-8")
print(f"generated: {out}")
