import datetime as dt
from pathlib import Path

import pandas as pd
import fdb

DB_PATH = "localhost:/Users/wilsonjonatan/Documents/bases 1 2026/violencia guate/sql/db/violencia_guate.fdb"
USER = "SYSDBA"
PASSWORD = "masterkey"
SRC_XLSX = Path("datos_base/Violencia/Violencia contra la mujer/Denuncias registradas/Denuncias del MP por el delito de VCM.xlsx")


def norm(v):
    if pd.isna(v):
        return None
    s = str(v).strip()
    return s if s else None


def pick_id(cur, table, candidates):
    for name in candidates:
        cur.execute(f"SELECT id_{table} FROM {table} WHERE UPPER(nombre)=UPPER(?) ROWS 1", (name,))
        row = cur.fetchone()
        if row:
            return row[0]
    return None


def ensure_named(cur, table, name, descripcion="Carga ETL"):
    id_col = f"id_{table}"
    cur.execute(f"SELECT {id_col} FROM {table} WHERE UPPER(nombre)=UPPER(?) ROWS 1", (name,))
    row = cur.fetchone()
    if row:
        return row[0]
    cur.execute(f"INSERT INTO {table} (nombre, descripcion) VALUES (?, ?) RETURNING {id_col}", (name, descripcion))
    return cur.fetchone()[0]


def ensure_tipo_institucion_mp(cur):
    cur.execute("SELECT id_tipo_institucion FROM tipo_institucion WHERE UPPER(nombre)=UPPER(?) ROWS 1", ("Ministerio Publico",))
    r = cur.fetchone()
    if r:
        return r[0]
    cur.execute(
        "INSERT INTO tipo_institucion (nombre, descripcion) VALUES (?, ?) RETURNING id_tipo_institucion",
        ("Ministerio Publico", "Catalogo base ETL"),
    )
    return cur.fetchone()[0]


def ensure_institucion_mp(cur, id_tipo_inst):
    cur.execute(
        "SELECT id_institucion_organicacion FROM institucion_organicacion WHERE UPPER(nombre_institucion)=UPPER(?) ROWS 1",
        ("Ministerio Publico",),
    )
    r = cur.fetchone()
    if r:
        return r[0]
    cur.execute(
        "INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion) VALUES (?, ?) RETURNING id_institucion_organicacion",
        ("Ministerio Publico", id_tipo_inst),
    )
    return cur.fetchone()[0]


def ensure_vcm_delito(cur):
    cur.execute("SELECT id_delito FROM delito WHERE UPPER(nombre)=UPPER(?) ROWS 1", ("Violencia contra la mujer",))
    r = cur.fetchone()
    if r:
        id_delito = r[0]
    else:
        cur.execute(
            "INSERT INTO delito (codigo, nombre, bien_juridico, activo) VALUES (?, ?, ?, 1) RETURNING id_delito",
            ("VCM-BASE", "Violencia contra la mujer", "VCM",),
        )
        id_delito = cur.fetchone()[0]

    cur.execute("SELECT id_clasificacion_delito FROM clasificacion_delito WHERE UPPER(nombre)=UPPER(?) ROWS 1", ("Violencia contra la mujer",))
    r = cur.fetchone()
    if r:
        id_cls = r[0]
    else:
        cur.execute(
            "INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo) VALUES (?, ?, ?, 1) RETURNING id_clasificacion_delito",
            ("VCM", "Violencia contra la mujer", "Clasificacion VCM"),
        )
        id_cls = cur.fetchone()[0]

    cur.execute(
        "SELECT id_delito_cometido FROM delito_cometido WHERE id_tipo_delito=? AND id_clasificacion_delito=? ROWS 1",
        (id_delito, id_cls),
    )
    r = cur.fetchone()
    if r:
        return r[0]

    cur.execute(
        "INSERT INTO delito_cometido (id_tipo_delito, id_clasificacion_delito) VALUES (?, ?) RETURNING id_delito_cometido",
        (id_delito, id_cls),
    )
    return cur.fetchone()[0]


def parse_birth(fecha, edad_raw):
    if not fecha:
        return None
    try:
        edad = int(edad_raw)
        if edad < 0 or edad > 100:
            return None
    except Exception:
        return None
    y = fecha.year - edad
    # day/month fixed para evitar fechas invalidas por febrero
    try:
        return dt.date(y, max(1, min(12, fecha.month)), min(15, fecha.day if fecha.day > 0 else 15))
    except Exception:
        return dt.date(y, 6, 15)


def load(limit=10000):
    df = pd.read_excel(SRC_XLSX)
    if limit:
        df = df.head(limit)

    con = fdb.connect(dsn=DB_PATH, user=USER, password=PASSWORD, charset="UTF8")
    cur = con.cursor()

    # ids base
    id_genero = ensure_named(cur, "genero", "Mujer", "ETL VCM")
    id_orient_default = ensure_named(cur, "orientacion_sexual", "Sin seleccion", "ETL VCM")
    id_tipo_hecho = ensure_named(cur, "tipo_hecho", "hecho_delictivo", "ETL VCM")
    id_involucramiento = ensure_named(cur, "involucramiento", "Denunciante", "ETL VCM")

    id_tipo_inst = ensure_tipo_institucion_mp(cur)
    id_institucion_mp = ensure_institucion_mp(cur, id_tipo_inst)
    id_delito_cometido = ensure_vcm_delito(cur)

    # unknowns
    id_estado_civil = pick_id(cur, "estado_civil", ["Desconocido", "Ignorado", "Sin seleccion"]) or ensure_named(cur, "estado_civil", "Ignorado", "ETL")
    id_cond_alf = pick_id(cur, "condicion_alfabetica", ["Desconocido", "Ignorado", "No registrado"]) or ensure_named(cur, "condicion_alfabetica", "Ignorado", "ETL")
    id_grupo_default = pick_id(cur, "grupo_etnico", ["Sin seleccion", "Ignorado", "No indigena"]) or ensure_named(cur, "grupo_etnico", "Sin seleccion", "ETL")

    # municipios map (depto, muni)->id
    cur.execute(
        """
        SELECT UPPER(TRIM(d.nombre)) AS dep, UPPER(TRIM(m.nombre)) AS mun, m.id_municipio
        FROM municipio m
        JOIN departamento d ON d.id_departamento = m.id_departamento
        """
    )
    muni_map = {(r[0], r[1]): r[2] for r in cur.fetchall()}

    # area default
    cur.execute("SELECT id_area_geografica FROM area_geografica WHERE UPPER(nombre)=UPPER('Urbano') ROWS 1")
    r = cur.fetchone()
    id_area_default = r[0] if r else None

    ubic_cache = {}
    done = 0

    for i, row in df.iterrows():
        dep = norm(row.get("Departamento"))
        mun = norm(row.get("Municipio"))
        estado_caso = norm(row.get("Estado Caso")) or "Ignorado"
        orient = norm(row.get("Orientacion")) or "Sin seleccion"
        escolaridad = norm(row.get("Escolaridad")) or "No registrado"
        etnia = norm(row.get("Pueblo de Pertenencia")) or "Sin seleccion"
        fecha = row.get("Fecha")

        if pd.isna(fecha):
            continue
        if isinstance(fecha, pd.Timestamp):
            fecha = fecha.date()
        elif not isinstance(fecha, dt.date):
            continue

        key = (dep.upper() if dep else "", mun.upper() if mun else "")
        id_muni = muni_map.get(key)
        if not id_muni:
            continue

        # cat dinamicos
        id_orient = ensure_named(cur, "orientacion_sexual", orient, "ETL VCM")
        id_estado_den = ensure_named(cur, "estado_denuncia", estado_caso, "ETL VCM")
        cur.execute("SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(nombre)=UPPER(?) ROWS 1", (escolaridad,))
        rr = cur.fetchone()
        id_nivel = rr[0] if rr else ensure_named(cur, "nivel_escolaridad", escolaridad, "ETL VCM")
        cur.execute("SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(nombre)=UPPER(?) ROWS 1", (etnia,))
        rr = cur.fetchone()
        id_grupo = rr[0] if rr else ensure_named(cur, "grupo_etnico", etnia, "ETL VCM")

        # ubicacion (reuse by municipio)
        if id_muni in ubic_cache:
            id_ubic = ubic_cache[id_muni]
        else:
            cur.execute(
                "SELECT id_ubicacion FROM ubicacion WHERE id_municipio=? ROWS 1",
                (id_muni,),
            )
            rr = cur.fetchone()
            if rr:
                id_ubic = rr[0]
            else:
                cur.execute(
                    "INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (?, ?, NULL, NULL, NULL) RETURNING id_ubicacion",
                    (id_muni, id_area_default),
                )
                id_ubic = cur.fetchone()[0]
            ubic_cache[id_muni] = id_ubic

        # persona sintetica por fila
        edad = norm(row.get("Edad"))
        f_nac = parse_birth(fecha, edad)
        nombres = f"Persona_{i+1}"
        apellidos = "VCM"
        cur.execute(
            """
            INSERT INTO persona (
                nombres, apellidos, fecha_nacimiento, cui,
                id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil,
                id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero
            ) VALUES (?, ?, ?, NULL, ?, ?, ?, ?, ?, ?, ?, 0)
            RETURNING id_persona
            """,
            (
                nombres, apellidos, f_nac,
                id_genero, id_orient, id_grupo, id_estado_civil,
                id_cond_alf, id_nivel, id_ubic,
            ),
        )
        id_persona = cur.fetchone()[0]

        cur.execute(
            "INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (?, ?, ?) RETURNING id_hecho",
            (id_tipo_hecho, id_ubic, fecha),
        )
        id_hecho = cur.fetchone()[0]

        cur.execute(
            "INSERT INTO denuncia (id_hecho, fecha_denuncia, id_estado_denuncia, id_entididad_denuncia) VALUES (?, ?, ?, ?) RETURNING id_denuncia",
            (id_hecho, fecha, id_estado_den, id_institucion_mp),
        )
        id_denuncia = cur.fetchone()[0]

        cur.execute(
            "INSERT INTO denuncia_estado_historial (id_denuncia, id_estado_denuncia, fecha_estado, observaciones) VALUES (?, ?, ?, ?)",
            (id_denuncia, id_estado_den, fecha, "Carga ETL Denuncias MP VCM"),
        )

        cur.execute(
            "INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (?, ?, ?)",
            (id_hecho, id_persona, id_involucramiento),
        )

        cur.execute(
            "INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (?, ?)",
            (id_hecho, id_delito_cometido),
        )

        done += 1
        if done % 1000 == 0:
            con.commit()
            print(f"commit {done}")

    con.commit()
    con.close()
    print(f"loaded_rows={done}")


if __name__ == "__main__":
    # primera pasada controlada
    load(limit=10000)
