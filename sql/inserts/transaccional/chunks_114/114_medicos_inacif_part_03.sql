SET NAMES UTF8;
SET TERM ^ ;

-- Fuente: Evaluacion Medicos INACIF 2023 (carga parcial)
-- Flujo: catalogos -> ubicacion -> persona -> hecho -> involucrado_hecho(Agraviado) -> hecho_delictivo

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000501' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chimaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chimaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000501', 'MEDICOS INACIF', '1997-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000502' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chimaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chimaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000502', 'MEDICOS INACIF', '2008-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000503' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000503', 'MEDICOS INACIF', '2010-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-26') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000504' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000504', 'MEDICOS INACIF', '2010-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000505' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000505', 'MEDICOS INACIF', '2009-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000506' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000506', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000507' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000507', 'MEDICOS INACIF', '2010-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-012' AND UPPER(TRIM(c.nombre)) = UPPER('Reconocimiento médico para determinar estado de salud')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000508' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000508', 'MEDICOS INACIF', '2010-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000509' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000509', 'MEDICOS INACIF', '2000-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000510' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000510', 'MEDICOS INACIF', '1991-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000511' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000511', 'MEDICOS INACIF', '2016-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000512' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000512', 'MEDICOS INACIF', '1984-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000513' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000513', 'MEDICOS INACIF', '1989-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000514' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000514', 'MEDICOS INACIF', '1977-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000515' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000515', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-001' AND UPPER(TRIM(c.nombre)) = UPPER('Aborto')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000516' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000516', 'MEDICOS INACIF', '2009-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000517' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000517', 'MEDICOS INACIF', '2001-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma blanca')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000518' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000518', 'MEDICOS INACIF', '2004-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000519' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000519', 'MEDICOS INACIF', '2014-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000520' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000520', 'MEDICOS INACIF', '2013-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000521' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000521', 'MEDICOS INACIF', '2021-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-012' AND UPPER(TRIM(c.nombre)) = UPPER('Reconocimiento médico para determinar estado de salud')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000522' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000522', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-22') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000523' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000523', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-22') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000524' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000524', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-21') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000525' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000525', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-21') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000526' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000526', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-22') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000527' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000527', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-22') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000528' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000528', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-22') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000529' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000529', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-22') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000530' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000530', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-22') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000531' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000531', 'MEDICOS INACIF', '2009-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-012' AND UPPER(TRIM(c.nombre)) = UPPER('Reconocimiento médico para determinar estado de salud')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000532' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000532', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000533' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000533', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000534' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000534', 'MEDICOS INACIF', '1995-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000535' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000535', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000536' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000536', 'MEDICOS INACIF', '1994-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000537' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000537', 'MEDICOS INACIF', '1998-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma blanca')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000538' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000538', 'MEDICOS INACIF', '2008-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000539' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000539', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-012' AND UPPER(TRIM(c.nombre)) = UPPER('Reconocimiento médico para determinar estado de salud')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000540' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000540', 'MEDICOS INACIF', '2008-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000541' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000541', 'MEDICOS INACIF', '1991-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-04') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000542' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000542', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000543' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000543', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000544' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000544', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000545' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000545', 'MEDICOS INACIF', '1976-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-04') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000546' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000546', 'MEDICOS INACIF', '1983-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-04') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000547' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000547', 'MEDICOS INACIF', '1983-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000548' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000548', 'MEDICOS INACIF', '2008-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000549' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000549', 'MEDICOS INACIF', '2012-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-01') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-012' AND UPPER(TRIM(c.nombre)) = UPPER('Reconocimiento médico para determinar estado de salud')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000550' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000550', 'MEDICOS INACIF', '1999-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-01') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-012' AND UPPER(TRIM(c.nombre)) = UPPER('Reconocimiento médico para determinar estado de salud')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000551' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000551', 'MEDICOS INACIF', '2005-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-02') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000552' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000552', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-02') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000553' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000553', 'MEDICOS INACIF', '2021-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-02') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000554' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000554', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-01') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000555' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000555', 'MEDICOS INACIF', '2009-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-02') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000556' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000556', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-02') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000557' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000557', 'MEDICOS INACIF', '1979-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma blanca')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000558' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000558', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-11') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma blanca')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000559' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000559', 'MEDICOS INACIF', '1981-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-11') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000560' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000560', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-09') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000561' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000561', 'MEDICOS INACIF', '2020-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-09') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-012' AND UPPER(TRIM(c.nombre)) = UPPER('Reconocimiento médico para determinar estado de salud')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000562' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000562', 'MEDICOS INACIF', '1994-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-09') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000563' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000563', 'MEDICOS INACIF', '1998-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-09') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000564' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000564', 'MEDICOS INACIF', '2004-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-07') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000565' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000565', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-09') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000566' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000566', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-09') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000567' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000567', 'MEDICOS INACIF', '2018-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-08') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000568' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000568', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000569' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000569', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000570' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000570', 'MEDICOS INACIF', '1983-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-06') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma blanca')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000571' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000571', 'MEDICOS INACIF', '1978-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-06') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000572' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000572', 'MEDICOS INACIF', '1983-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000573' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000573', 'MEDICOS INACIF', '2009-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000574' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000574', 'MEDICOS INACIF', '1984-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-002' AND UPPER(TRIM(c.nombre)) = UPPER('Determinación de uso de drogas, fármacos o estupefacientes')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000575' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000575', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000576' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000576', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000577' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000577', 'MEDICOS INACIF', '2006-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-008' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma de fuego')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000578' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000578', 'MEDICOS INACIF', '1983-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-12') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma blanca')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000579' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000579', 'MEDICOS INACIF', '1995-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-12') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000580' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000580', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-12') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000581' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000581', 'MEDICOS INACIF', '1986-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-12') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000582' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000582', 'MEDICOS INACIF', '1974-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-12') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000583' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000583', 'MEDICOS INACIF', '1971-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-11') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000584' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000584', 'MEDICOS INACIF', '2020-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000585' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000585', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000586' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000586', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-004' AND UPPER(TRIM(c.nombre)) = UPPER('Embarazo')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000587' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000587', 'MEDICOS INACIF', '2009-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-004' AND UPPER(TRIM(c.nombre)) = UPPER('Embarazo')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000588' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000588', 'MEDICOS INACIF', '2000-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma blanca')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000589' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000589', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-14') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000590' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000590', 'MEDICOS INACIF', '1961-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-14') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000591' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000591', 'MEDICOS INACIF', '2007-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-16') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma blanca')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000592' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000592', 'MEDICOS INACIF', '2009-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000593' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000593', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000594' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000594', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000595' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000595', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000596' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000596', 'MEDICOS INACIF', '1985-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-16') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma blanca')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000597' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000597', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000598' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000598', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000599' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000599', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000600' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000600', 'MEDICOS INACIF', '1977-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-16') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-008' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma de fuego')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000601' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000601', 'MEDICOS INACIF', '2001-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-20') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000602' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000602', 'MEDICOS INACIF', '2019-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-20') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000603' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000603', 'MEDICOS INACIF', '2000-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-20') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000604' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000604', 'MEDICOS INACIF', '1990-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-20') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma blanca')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000605' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000605', 'MEDICOS INACIF', '1972-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-21') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000606' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000606', 'MEDICOS INACIF', '1980-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-21') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000607' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000607', 'MEDICOS INACIF', '2004-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-19') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000608' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000608', 'MEDICOS INACIF', '2013-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-20') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000609' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000609', 'MEDICOS INACIF', '1974-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-19') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000610' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000610', 'MEDICOS INACIF', '1985-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-18') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-012' AND UPPER(TRIM(c.nombre)) = UPPER('Reconocimiento médico para determinar estado de salud')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000611' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000611', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-18') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-012' AND UPPER(TRIM(c.nombre)) = UPPER('Reconocimiento médico para determinar estado de salud')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000612' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000612', 'MEDICOS INACIF', '2010-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-18') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-004' AND UPPER(TRIM(c.nombre)) = UPPER('Embarazo')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000613' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000613', 'MEDICOS INACIF', '2010-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-17') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000614' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000614', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-17') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000615' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000615', 'MEDICOS INACIF', '1947-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-17') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000616' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000616', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000617' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000617', 'MEDICOS INACIF', '2008-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-008' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma de fuego')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000618' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000618', 'MEDICOS INACIF', '1987-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-008' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma de fuego')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000619' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000619', 'MEDICOS INACIF', '2006-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000620' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000620', 'MEDICOS INACIF', '1977-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000621' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000621', 'MEDICOS INACIF', '2007-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000622' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000622', 'MEDICOS INACIF', '1994-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000623' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000623', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000624' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000624', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000625' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000625', 'MEDICOS INACIF', '1984-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-012' AND UPPER(TRIM(c.nombre)) = UPPER('Reconocimiento médico para determinar estado de salud')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000626' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000626', 'MEDICOS INACIF', '2002-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma blanca')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000627' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000627', 'MEDICOS INACIF', '1967-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000628' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000628', 'MEDICOS INACIF', '2002-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000629' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000629', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000630' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000630', 'MEDICOS INACIF', '1979-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000631' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000631', 'MEDICOS INACIF', '1992-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-008' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma de fuego')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000632' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000632', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000633' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000633', 'MEDICOS INACIF', '1995-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000634' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000634', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-27') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000635' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000635', 'MEDICOS INACIF', '2001-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-27') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000636' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000636', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-012' AND UPPER(TRIM(c.nombre)) = UPPER('Reconocimiento médico para determinar estado de salud')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000637' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000637', 'MEDICOS INACIF', '1997-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-27') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000638' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000638', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-27') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000639' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000639', 'MEDICOS INACIF', '2012-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000640' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000640', 'MEDICOS INACIF', '2001-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000641' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000641', 'MEDICOS INACIF', '1973-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000642' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000642', 'MEDICOS INACIF', '2001-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000643' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000643', 'MEDICOS INACIF', '2008-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000644' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000644', 'MEDICOS INACIF', '1966-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-04') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-012' AND UPPER(TRIM(c.nombre)) = UPPER('Reconocimiento médico para determinar estado de salud')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000645' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000645', 'MEDICOS INACIF', '1979-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-04') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-012' AND UPPER(TRIM(c.nombre)) = UPPER('Reconocimiento médico para determinar estado de salud')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000646' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000646', 'MEDICOS INACIF', '2000-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-06') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000647' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000647', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-09') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000648' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000648', 'MEDICOS INACIF', '1992-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-09') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000649' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000649', 'MEDICOS INACIF', '2008-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-16') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000650' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000650', 'MEDICOS INACIF', '1992-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-16') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000651' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000651', 'MEDICOS INACIF', '1987-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000652' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000652', 'MEDICOS INACIF', '1989-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-17') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000653' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000653', 'MEDICOS INACIF', '1986-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-18') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000654' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000654', 'MEDICOS INACIF', '1995-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-20') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000655' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000655', 'MEDICOS INACIF', '2001-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-27') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000656' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000656', 'MEDICOS INACIF', '2013-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000657' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000657', 'MEDICOS INACIF', '2002-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000658' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000658', 'MEDICOS INACIF', '2008-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000659' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000659', 'MEDICOS INACIF', '2007-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000660' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000660', 'MEDICOS INACIF', '2000-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000661' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cuilapa') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000661', 'MEDICOS INACIF', '2003-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-008' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma de fuego')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000662' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000662', 'MEDICOS INACIF', '1996-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000663' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000663', 'MEDICOS INACIF', '1999-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000664' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000664', 'MEDICOS INACIF', '2006-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000665' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000665', 'MEDICOS INACIF', '1971-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000666' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000666', 'MEDICOS INACIF', '1989-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000667' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000667', 'MEDICOS INACIF', '1987-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000668' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000668', 'MEDICOS INACIF', '1992-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000669' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000669', 'MEDICOS INACIF', '2018-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-22') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000670' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000670', 'MEDICOS INACIF', '2022-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-22') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000671' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000671', 'MEDICOS INACIF', '1984-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-21') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000672' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000672', 'MEDICOS INACIF', '2017-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-21') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000673' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000673', 'MEDICOS INACIF', '1994-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-21') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000674' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000674', 'MEDICOS INACIF', '2021-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000675' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000675', 'MEDICOS INACIF', '2006-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000676' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000676', 'MEDICOS INACIF', '2010-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000677' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000677', 'MEDICOS INACIF', '1970-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000678' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000678', 'MEDICOS INACIF', '1990-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Embriaguez')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000679' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000679', 'MEDICOS INACIF', '2009-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma blanca')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000680' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000680', 'MEDICOS INACIF', '1991-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000681' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000681', 'MEDICOS INACIF', '2009-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000682' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000682', 'MEDICOS INACIF', '1979-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000683' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000683', 'MEDICOS INACIF', '2007-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-004' AND UPPER(TRIM(c.nombre)) = UPPER('Embarazo')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000684' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000684', 'MEDICOS INACIF', '1987-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000685' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000685', 'MEDICOS INACIF', '1987-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-008' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma de fuego')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000686' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000686', 'MEDICOS INACIF', '1982-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000687' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000687', 'MEDICOS INACIF', '1982-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000688' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000688', 'MEDICOS INACIF', '1980-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000689' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000689', 'MEDICOS INACIF', '1999-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-04') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-012' AND UPPER(TRIM(c.nombre)) = UPPER('Reconocimiento médico para determinar estado de salud')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000690' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000690', 'MEDICOS INACIF', '1977-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-04') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000691' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000691', 'MEDICOS INACIF', '2000-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-04') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma blanca')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000692' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000692', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-04') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000693' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000693', 'MEDICOS INACIF', '1987-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-04') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000694' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000694', 'MEDICOS INACIF', '2007-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-04') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000695' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000695', 'MEDICOS INACIF', '1991-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000696' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000696', 'MEDICOS INACIF', '2002-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000697' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000697', 'MEDICOS INACIF', '2009-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000698' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000698', 'MEDICOS INACIF', '1986-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-012' AND UPPER(TRIM(c.nombre)) = UPPER('Reconocimiento médico para determinar estado de salud')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000699' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000699', 'MEDICOS INACIF', '2006-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000700' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000700', 'MEDICOS INACIF', '1998-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000701' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000701', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-01') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000702' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000702', 'MEDICOS INACIF', '1960-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-01') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000703' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000703', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-09') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000704' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000704', 'MEDICOS INACIF', '2007-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-06') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000705' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000705', 'MEDICOS INACIF', '1999-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-06') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000706' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000706', 'MEDICOS INACIF', '1994-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-06') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000707' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000707', 'MEDICOS INACIF', '1997-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-06') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000708' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000708', 'MEDICOS INACIF', '1992-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-07') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000709' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000709', 'MEDICOS INACIF', '1990-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-06') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000710' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000710', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000711' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000711', 'MEDICOS INACIF', '2019-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000712' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000712', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000713' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000713', 'MEDICOS INACIF', '2007-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-09') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000714' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000714', 'MEDICOS INACIF', '2009-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-09') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000715' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000715', 'MEDICOS INACIF', '1995-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-10') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000716' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000716', 'MEDICOS INACIF', '1995-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-10') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000717' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000717', 'MEDICOS INACIF', '1955-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-10') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000718' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000718', 'MEDICOS INACIF', '1979-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-10') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000719' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000719', 'MEDICOS INACIF', '1980-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-10') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000720' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000720', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-11') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000721' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000721', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-11') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000722' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000722', 'MEDICOS INACIF', '1979-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-12') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000723' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000723', 'MEDICOS INACIF', '1999-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-11') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000724' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000724', 'MEDICOS INACIF', '1996-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-11') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000725' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000725', 'MEDICOS INACIF', '2002-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-11') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000726' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000726', 'MEDICOS INACIF', '1971-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-11') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma blanca')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000727' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000727', 'MEDICOS INACIF', '2005-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-12') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000728' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000728', 'MEDICOS INACIF', '1983-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-12') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000729' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000729', 'MEDICOS INACIF', '1981-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-16') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000730' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000730', 'MEDICOS INACIF', '1984-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-16') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000731' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000731', 'MEDICOS INACIF', '1989-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-16') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000732' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000732', 'MEDICOS INACIF', '1960-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-16') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000733' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000733', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Toma de muestras')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000734' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000734', 'MEDICOS INACIF', '2012-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-19') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000735' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000735', 'MEDICOS INACIF', '1991-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-20') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000736' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000736', 'MEDICOS INACIF', '1981-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-20') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000737' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000737', 'MEDICOS INACIF', '1984-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-20') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000738' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000738', 'MEDICOS INACIF', '2009-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-20') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000739' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000739', 'MEDICOS INACIF', '1998-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-18') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000740' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000740', 'MEDICOS INACIF', '2006-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-18') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000741' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000741', 'MEDICOS INACIF', '1997-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-17') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000742' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000742', 'MEDICOS INACIF', '1969-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000743' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000743', 'MEDICOS INACIF', '1993-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-008' AND UPPER(TRIM(c.nombre)) = UPPER('Herida por arma de fuego')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000744' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000744', 'MEDICOS INACIF', '1984-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000745' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000745', 'MEDICOS INACIF', '1985-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000746' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000746', 'MEDICOS INACIF', '1991-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000747' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000747', 'MEDICOS INACIF', '2005-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000748' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000748', 'MEDICOS INACIF', '1972-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000749' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000749', 'MEDICOS INACIF', '1955-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Otros')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

EXECUTE BLOCK AS
  DECLARE v_dep INTEGER;
  DECLARE v_muni INTEGER;
  DECLARE v_ubic INTEGER;
  DECLARE v_genero INTEGER;
  DECLARE v_orient INTEGER;
  DECLARE v_grupo INTEGER;
  DECLARE v_eciv INTEGER;
  DECLARE v_alf INTEGER;
  DECLARE v_nivel INTEGER;
  DECLARE v_persona INTEGER;
  DECLARE v_hecho INTEGER;
  DECLARE v_tipo_hecho INTEGER;
  DECLARE v_inv INTEGER;
  DECLARE v_delito_com INTEGER;
BEGIN
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'MED_2023_000750' AND p.apellidos = 'MEDICOS INACIF')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep ORDER BY id_municipio ROWS 1 INTO v_muni;
  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;
  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_genero;
  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;
  SELECT id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION', 'SD') ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  IF (v_orient IS NULL) THEN SELECT id_orientacion_sexual FROM orientacion_sexual ORDER BY id_orientacion_sexual ROWS 1 INTO v_orient;
  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SD') ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico ORDER BY id_grupo_etnico ROWS 1 INTO v_grupo;
  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_eciv;
  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_alf;
  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('MED_2023_000750', 'MEDICOS INACIF', '2014-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-27') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victimario') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'MED-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Lesiones')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

SET TERM ; ^
COMMIT;