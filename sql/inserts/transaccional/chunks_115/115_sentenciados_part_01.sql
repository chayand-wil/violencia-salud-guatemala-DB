SET NAMES UTF8;
SET TERM ^ ;

-- Fuente: Organismo judicial - Sentenciados 2023 (carga parcial)
-- Flujo: catalogos -> ubicacion -> persona -> hecho -> involucrado_hecho -> hecho_delictivo

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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000001' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000001', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000002' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000002', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000003' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000003', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000004' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000004', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000005' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000005', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000006' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000006', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000007' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000007', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000008' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000008', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000009' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000009', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000010' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000010', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000011' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000011', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000012' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000012', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000013' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000013', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000014' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000014', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000015' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000015', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-018' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Lesiones (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000016' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000016', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-024' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Armas y Municiones | Otros títulos | De la portación (Ley de Armas y Munciones)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000017' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000017', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-030' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Equipo Terminales Móviles | Otros títulos | Delitos, sanciones y prohibiciones (Ley de Equipos Terminales Móviles)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000018' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000018', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000019' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000019', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000020' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000020', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-025' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Armas y Municiones | Otros títulos | De la portación (Ley de Armas y Munciones)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000021' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000021', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000022' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000022', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000023' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000023', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000024' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000024', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000025' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000025', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000026' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000026', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000027' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000027', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000028' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000028', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-003' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios calificados (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000029' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000029', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000030' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000030', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-014' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Hurto (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000031' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000031', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-030' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Equipo Terminales Móviles | Otros títulos | Delitos, sanciones y prohibiciones (Ley de Equipos Terminales Móviles)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000032' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000032', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000033' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000033', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000034' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000034', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000035' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000035', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000036' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000036', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000037' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000037', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000038' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000038', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000039' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000039', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000040' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000040', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000041' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000041', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000042' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000042', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000043' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quiché') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santa Cruz del Quiché') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000043', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-024' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Armas y Municiones | Otros títulos | De la portación (Ley de Armas y Munciones)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000044' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000044', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Narcoactividad | Otros títulos | De los delitos y de sus penas (Ley contra la Narcoactividad)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000045' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000045', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000046' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000046', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000047' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000047', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000048' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000048', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-004' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Narcoactividad | Otros títulos | De los delitos y de sus penas (Ley contra la Narcoactividad)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000049' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000049', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-017' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Lesiones (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000050' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000050', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000051' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000051', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-022' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la libertad y seguridad de las personas | De los delitos contra la libertad individual (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000052' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000052', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Narcoactividad | Otros títulos | De los delitos y de sus penas (Ley contra la Narcoactividad)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000053' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000053', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000054' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000054', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-016' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra el Lavado de Dinero u Otros Activos | Otros títulos | Del delito, de los responsables y de las penas (Ley Contra el Lavado de Dinero u')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000055' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000055', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000056' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000056', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000057' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sololá') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Sololá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000057', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000058' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sololá') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Sololá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000058', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000059' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sololá') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Sololá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000059', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-031' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000060' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sololá') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Sololá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000060', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-031' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000061' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000061', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-026' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Narcoactividad | Otros títulos | De los delitos y de sus penas (Ley contra la Narcoactividad)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000062' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000062', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000063' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000063', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-017' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Lesiones (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000064' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000064', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000065' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000065', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-024' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Armas y Municiones | Otros títulos | De la portación (Ley de Armas y Munciones)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000066' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000066', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-026' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Narcoactividad | Otros títulos | De los delitos y de sus penas (Ley contra la Narcoactividad)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000067' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000067', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-024' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Armas y Municiones | Otros títulos | De la portación (Ley de Armas y Munciones)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000068' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000068', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-018' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Lesiones (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000069' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000069', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000070' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000070', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-011' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000071' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000071', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-024' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Armas y Municiones | Otros títulos | De la portación (Ley de Armas y Munciones)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000072' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000072', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000073' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000073', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-017' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Lesiones (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000074' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000074', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-018' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Lesiones (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000075' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000075', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-009' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la administración de justicia | Del encubrimiento (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000076' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000076', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-030' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Equipo Terminales Móviles | Otros títulos | Delitos, sanciones y prohibiciones (Ley de Equipos Terminales Móviles)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000077' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000077', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Narcoactividad | Otros títulos | De los delitos y de sus penas (Ley contra la Narcoactividad)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000078' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000078', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000079' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000079', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-024' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Armas y Municiones | Otros títulos | De la portación (Ley de Armas y Munciones)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000080' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000080', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-009' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la administración de justicia | Del encubrimiento (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000081' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000081', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-001' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Equipo Terminales Móviles | Otros títulos | Delitos, sanciones y prohibiciones (Ley de Equipos Terminales Móviles)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000082' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000082', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000083' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000083', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-025' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Armas y Municiones | Otros títulos | De la portación (Ley de Armas y Munciones)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000084' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000084', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000085' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000085', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-030' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Equipo Terminales Móviles | Otros títulos | Delitos, sanciones y prohibiciones (Ley de Equipos Terminales Móviles)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000086' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000086', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-007' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Narcoactividad | Otros títulos | De los delitos y de sus penas (Ley contra la Narcoactividad)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000087' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000087', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-031' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000088' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000088', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000089' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000089', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-031' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000090' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cobán') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000090', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000091' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cobán') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000091', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000092' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cobán') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000092', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000093' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cobán') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000093', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000094' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000094', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000095' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000095', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000096' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000096', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000097' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000097', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000098' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000098', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000099' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000099', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000100' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000100', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000101' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000101', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000102' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000102', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000103' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000103', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000104' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000104', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-018' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Lesiones (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000105' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000105', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-002' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la libertad y seguridad de las personas | De las coacciones y amenazas (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000106' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000106', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000107' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000107', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000108' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000108', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-002' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la libertad y seguridad de las personas | De las coacciones y amenazas (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000109' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000109', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000110' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Zacapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Zacapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000110', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000111' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Zacapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Zacapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000111', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000112' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Zacapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Zacapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000112', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000113' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Zacapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Zacapa') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000113', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000114' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000114', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000115' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000115', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000116' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000116', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000117' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000117', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000118' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000118', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000119' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000119', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000120' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000120', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000121' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000121', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000122' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000122', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-030' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Equipo Terminales Móviles | Otros títulos | Delitos, sanciones y prohibiciones (Ley de Equipos Terminales Móviles)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000123' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sacatepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Antigua Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000123', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000124' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sacatepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Antigua Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000124', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000125' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('El Progreso') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guastatoya') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000125', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000126' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('El Progreso') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guastatoya') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000126', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000127' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('El Progreso') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guastatoya') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000127', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000128' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000128', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000129' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000129', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-026' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Narcoactividad | Otros títulos | De los delitos y de sus penas (Ley contra la Narcoactividad)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000130' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000130', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000131' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000131', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000132' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000132', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000133' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000133', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000134' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000134', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000135' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000135', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000136' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000136', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000137' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000137', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000138' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000138', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-026' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Narcoactividad | Otros títulos | De los delitos y de sus penas (Ley contra la Narcoactividad)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000139' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000139', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000140' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000140', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-020' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000141' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000141', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000142' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000142', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000143' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000143', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-008' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000144' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000144', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000145' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000145', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000146' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000146', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000147' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000147', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000148' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000148', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-020' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000149' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000149', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000150' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000150', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000151' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000151', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-030' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Equipo Terminales Móviles | Otros títulos | Delitos, sanciones y prohibiciones (Ley de Equipos Terminales Móviles)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000152' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000152', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000153' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000153', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000154' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000154', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-020' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000155' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000155', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000156' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000156', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-020' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000157' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000157', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000158' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000158', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000159' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000159', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-031' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000160' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000160', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-033' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Armas y Municiones | Otros títulos | Sobre la tenencia y transporte (Ley de Armas y Munciones)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000161' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000161', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-020' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000162' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000162', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 1)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-005' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Delincuencia Organizada | Otros títulos | Delitos de la Delincuencia Organizada (Ley Contra la Delincuencia Organizada)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000163' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000163', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-009' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la administración de justicia | Del encubrimiento (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000164' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000164', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-009' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la administración de justicia | Del encubrimiento (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000165' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000165', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000166' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000166', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000167' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000167', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000168' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000168', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000169' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000169', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000170' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000170', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000171' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000171', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000172' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000172', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000173' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000173', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000174' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000174', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000175' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000175', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000176' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000176', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000177' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000177', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000178' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000178', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000179' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000179', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000180' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000180', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000181' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mazatenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000181', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000182' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Izabal') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Puerto Barrios') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000182', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000183' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Izabal') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Puerto Barrios') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000183', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000184' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000184', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000185' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Izabal') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Puerto Barrios') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000185', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000186' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000186', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000187' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000187', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-019' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Lesiones (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000188' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000188', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-003' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios calificados (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000189' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000189', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000190' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000190', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-026' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Narcoactividad | Otros títulos | De los delitos y de sus penas (Ley contra la Narcoactividad)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000191' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000191', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-022' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la libertad y seguridad de las personas | De los delitos contra la libertad individual (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000192' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000192', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000193' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000193', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-009' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la administración de justicia | Del encubrimiento (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000194' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000194', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-022' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la libertad y seguridad de las personas | De los delitos contra la libertad individual (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000195' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000195', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-027' AND UPPER(TRIM(c.nombre)) = UPPER('Ley Contra la Narcoactividad | Otros títulos | De los delitos y de sus penas (Ley contra la Narcoactividad)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000196' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000196', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000197' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000197', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000198' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000198', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-003' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios calificados (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000199' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000199', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000200' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000200', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000201' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Flores') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000201', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-009' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la administración de justicia | Del encubrimiento (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000202' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000202', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000203' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000203', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000204' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000204', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-024' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Armas y Municiones | Otros títulos | De la portación (Ley de Armas y Munciones)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000205' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000205', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-009' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la administración de justicia | Del encubrimiento (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000206' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000206', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-034' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Armas y Municiones | Otros títulos | De la portación (Ley de Armas y Munciones)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000207' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000207', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-024' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Armas y Municiones | Otros títulos | De la portación (Ley de Armas y Munciones)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000208' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000208', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000209' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000209', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-009' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la administración de justicia | Del encubrimiento (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000210' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000210', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-024' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Armas y Municiones | Otros títulos | De la portación (Ley de Armas y Munciones)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000211' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000211', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000212' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000212', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-009' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la administración de justicia | Del encubrimiento (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000213' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000213', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000214' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000214', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000215' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000215', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-010' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | De la extorsión y del chantaje (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000216' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000216', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000217' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000217', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-024' AND UPPER(TRIM(c.nombre)) = UPPER('Ley de Armas y Municiones | Otros títulos | De la portación (Ley de Armas y Munciones)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000218' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000218', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000219' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

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
  VALUES ('SEN_2023_000219', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000220' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000220', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000221' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000221', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000222' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000222', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-019' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Lesiones (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000223' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000223', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000224' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000224', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000225' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000225', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000226' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000226', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000227' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000227', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000228' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quiché') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santa Cruz del Quiché') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000228', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000229' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quiché') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santa Cruz del Quiché') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000229', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000230' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000230', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000231' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000231', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-022' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la libertad y seguridad de las personas | De los delitos contra la libertad individual (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000232' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000232', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000233' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000233', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-022' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la libertad y seguridad de las personas | De los delitos contra la libertad individual (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000234' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000234', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000235' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000235', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-013' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la vida y la integridad de la persona | Homicidios simples (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000236' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000236', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-022' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la libertad y seguridad de las personas | De los delitos contra la libertad individual (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000237' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000237', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000238' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000238', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000239' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000239', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-022' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la libertad y seguridad de las personas | De los delitos contra la libertad individual (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000240' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000240', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-022' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la libertad y seguridad de las personas | De los delitos contra la libertad individual (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000241' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000241', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-022' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la libertad y seguridad de las personas | De los delitos contra la libertad individual (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000242' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000242', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000243' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000243', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-022' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la libertad y seguridad de las personas | De los delitos contra la libertad individual (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000244' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000244', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000245' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000245', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000246' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000246', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000247' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000247', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-022' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra la libertad y seguridad de las personas | De los delitos contra la libertad individual (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000248' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000248', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000249' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000249', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-021' AND UPPER(TRIM(c.nombre)) = UPPER('Otras leyes | Otros títulos | Otros capítulos')
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'SEN_2023_000250' AND p.apellidos = 'SENTENCIADOS OJ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_muni;
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
  VALUES ('SEN_2023_000250', 'SENTENCIADOS OJ', '1988-06-15', NULL, :v_genero, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_persona;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado') ROWS 1 INTO v_inv;
  IF (v_inv IS NULL) THEN SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado') ROWS 1 INTO v_inv;
  INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_persona, :v_inv);

  SELECT dc.id_delito_cometido
    FROM delito_cometido dc
    JOIN delito d ON d.id_delito = dc.id_tipo_delito
    JOIN clasificacion_delito c ON c.id_clasificacion_delito = dc.id_clasificacion_delito
   WHERE d.codigo = 'SEN-DEL-029' AND UPPER(TRIM(c.nombre)) = UPPER('Ley del Ramo Penal | De los delitos contra el patrimonio | Robo (Código Penal)')
   ROWS 1 INTO v_delito_com;

  IF (v_delito_com IS NOT NULL) THEN
    INSERT INTO hecho_delictivo (id_hecho, id_delito) VALUES (:v_hecho, :v_delito_com);
END^

SET TERM ; ^
COMMIT;