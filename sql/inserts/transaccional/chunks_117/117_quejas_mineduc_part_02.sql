SET NAMES UTF8;
SET TERM ^ ;


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000061' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000061', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000062' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000062', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-02-06')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000063' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000063', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-03-07')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000064' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000064', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-04-08')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000065' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000065', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-05-09')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000066' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000066', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-06-10')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000067' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000067', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-07-11')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000068' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000068', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-08-12')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000069' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000069', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-09-13')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000070' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000070', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-10-14')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000071' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000071', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-11-15')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000072' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000072', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-12-16')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000073' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000073', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-01-17')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000074' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000074', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-02-18')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000075' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000075', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-03-19')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000076' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000076', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-04-20')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000077' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000077', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-05-21')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000078' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000078', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-06-22')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000079' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000079', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-07-23')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000080' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000080', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-08-24')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000081' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000081', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-09-25')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000082' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000082', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-10-26')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000083' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000083', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-11-27')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000084' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000084', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-12-28')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000085' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000085', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-01-01')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000086' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000086', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-02-02')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000087' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000087', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-03-03')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000088' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000088', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-04-04')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000089' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000089', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-05-05')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000090' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000090', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-06-06')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000091' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000091', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-07-07')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000092' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000092', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-08-08')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000093' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000093', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-09-09')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000094' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000094', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-10-10')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000095' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000095', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-11-11')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000096' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000096', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-12-12')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000097' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000097', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-01-13')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000098' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000098', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-02-14')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000099' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000099', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-03-15')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000100' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000100', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-04-16')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000101' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000101', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-05-17')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000102' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000102', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-06-18')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000103' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000103', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-07-19')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000104' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000104', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-08-20')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000105' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000105', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-09-21')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000106' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000106', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-10-22')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000107' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000107', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-11-23')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000108' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000108', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-12-24')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000109' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000109', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-01-25')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000110' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000110', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-02-26')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000111' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000111', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-03-27')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000112' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000112', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-04-28')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000113' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000113', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-05-01')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000114' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000114', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-06-02')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000115' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000115', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-07-03')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000116' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000116', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-08-04')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000117' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000117', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-09-05')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000118' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000118', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-10-06')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000119' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000119', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-11-07')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'QMN23V_000120' AND p.apellidos = 'NINEZ')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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
      'QMN23V_000120', 'NINEZ', '2010-06-15', NULL,
      :v_genero, :v_orient, :v_grupo,
      :v_eciv, :v_alf, :v_nivel,
      :v_ubic, 0
  ) RETURNING id_persona INTO v_victima;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;

  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho)
  VALUES (:v_tipo_hecho, :v_ubic, '2023-12-08')
  RETURNING id_hecho INTO v_hecho;

  SELECT id_tipo_agresion_ninez FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años') ROWS 1 INTO v_tipo_agre;
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
END^

SET TERM ; ^
COMMIT;
