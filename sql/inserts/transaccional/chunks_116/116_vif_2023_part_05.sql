SET NAMES UTF8;
SET TERM ^ ;


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000404' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mixco') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000404', 'VICTIMA', '1971-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000404', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '551',
      :v_hecho,
      '2023-01-28',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000405' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Petapa') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000405', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000405', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '748',
      :v_hecho,
      '2023-01-15',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000406' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Amatitlán') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000406', 'VICTIMA', '1997-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000406', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-11') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '596',
      :v_hecho,
      '2023-02-11',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000407' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000407', 'VICTIMA', '1948-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000407', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-06-27') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '68',
      :v_hecho,
      '2023-06-28',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000408' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000408', 'VICTIMA', '1998-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000408', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-21') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '341',
      :v_hecho,
      '2023-07-21',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000409' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mixco') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000409', 'VICTIMA', '1970-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000409', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-08') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '609',
      :v_hecho,
      '2023-07-12',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      1,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000410' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mixco') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000410', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000410', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-09-16') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '468',
      :v_hecho,
      '2023-09-16',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      1,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000411' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Amatitlán') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000411', 'VICTIMA', '1997-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000411', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-09-04') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '669',
      :v_hecho,
      '2023-09-06',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      2,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000412' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000412', 'VICTIMA', '1994-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000412', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-10-08') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '156',
      :v_hecho,
      '2023-10-08',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      7,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000413' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Villa Nueva') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000413', 'VICTIMA', '2000-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000413', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-10-08') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '515',
      :v_hecho,
      '2023-10-08',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000414' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mixco') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000414', 'VICTIMA', '2002-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000414', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '420',
      :v_hecho,
      '2023-12-28',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000415' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Mixco') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000415', 'VICTIMA', '1999-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000415', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-10') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '458',
      :v_hecho,
      '2023-12-12',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      1,
      1,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000416' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chiquimula') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Olopa') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000416', 'VICTIMA', '1954-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000416', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '27',
      :v_hecho,
      '2023-01-25',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000417' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Petén') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Poptún') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000417', 'VICTIMA', '2001-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000417', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-03-26') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '83',
      :v_hecho,
      '2023-03-27',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000418' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Senahú') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000418', 'VICTIMA', '2000-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000418', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-05-26') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '1096',
      :v_hecho,
      '2023-05-28',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000419' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Cristóbal Verapaz') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000419', 'VICTIMA', '2003-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000419', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-09-02') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '3003',
      :v_hecho,
      '2023-09-04',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000420' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chimaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chimaltenango') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000420', 'VICTIMA', '1997-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000420', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-09-17') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '37',
      :v_hecho,
      '2023-09-19',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      4,
      1,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000422' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jalapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pedro Pinula') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000422', 'VICTIMA', '2008-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000422', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-11-17') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '12',
      :v_hecho,
      '2023-11-22',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '3',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000423' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Zacapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Gualán') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000423', 'VICTIMA', '1987-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000423', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-10') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '24',
      :v_hecho,
      '2023-01-11',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000424' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Zacapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Teculután') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000424', 'VICTIMA', '2002-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000424', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-06-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '39',
      :v_hecho,
      '2023-06-23',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000425' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Zacapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Gualán') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000425', 'VICTIMA', '1970-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000425', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1222') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '46',
      :v_hecho,
      '2023-07-04',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000426' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Tactic') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000426', 'VICTIMA', '1999-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000426', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-03-06') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1222') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '4001',
      :v_hecho,
      '2023-03-06',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000427' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000427', 'VICTIMA', '1999-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000427', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '139',
      :v_hecho,
      '2023-01-28',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000428' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Granados') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000428', 'VICTIMA', '1994-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000428', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-07') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '501',
      :v_hecho,
      '2023-01-25',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000429' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Purulhá') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000429', 'VICTIMA', '1995-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000429', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-19') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '806',
      :v_hecho,
      '2023-04-19',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      2,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000430' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salamá') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000430', 'VICTIMA', '2006-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000430', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '145',
      :v_hecho,
      '2023-07-25',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      1,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000431' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cubulco') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000431', 'VICTIMA', '2001-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000431', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-18') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '404',
      :v_hecho,
      '2023-12-26',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '9',
      0,
      1,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000432' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Granados') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000432', 'VICTIMA', '1978-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000432', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '501',
      :v_hecho,
      '2023-12-25',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      1,
      1,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000433' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quiché') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Ixcán') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000433', 'VICTIMA', '2007-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000433', 'AGRESOR', '2004-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2022-11-07') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '85',
      :v_hecho,
      '2023-01-06',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '2',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000434' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Rafael La Independencia') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000434', 'VICTIMA', '2009-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000434', 'AGRESOR', '2004-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2022-03-09') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '65',
      :v_hecho,
      '2023-03-27',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000435' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chiantla') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000435', 'VICTIMA', '1949-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000435', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-11-11') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1222') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '11',
      :v_hecho,
      '2023-11-13',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000436' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Sebastián Huehuetenango') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000436', 'VICTIMA', '2007-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000436', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-11-21') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1121') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '64',
      :v_hecho,
      '2023-11-23',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000437' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Huehuetenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Rafael Petzal') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000437', 'VICTIMA', '2006-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000437', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-06') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1222') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '89',
      :v_hecho,
      '2023-12-07',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000438' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pedro Sacatepéquez') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000438', 'VICTIMA', '1993-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000438', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-19') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1222') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '19',
      :v_hecho,
      '2023-02-21',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      2,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000439' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Rafael Pie de La Cuesta') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000439', 'VICTIMA', '1943-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000439', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-19') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '61',
      :v_hecho,
      '2023-02-21',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000440' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pedro Sacatepéquez') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000440', 'VICTIMA', '2006-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000440', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-04') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1121') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '20',
      :v_hecho,
      '2023-04-05',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      1,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000441' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Miguel Ixtahuacán') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000441', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000441', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-09') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '37',
      :v_hecho,
      '2023-04-18',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000442' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Miguel Ixtahuacán') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000442', 'VICTIMA', '1986-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000442', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '40',
      :v_hecho,
      '2023-04-24',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      1,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000443' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Miguel Ixtahuacán') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000443', 'VICTIMA', '1971-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000443', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '41',
      :v_hecho,
      '2023-04-24',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      1,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000444' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Esquipulas Palo Gordo') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000444', 'VICTIMA', '2007-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000444', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-05-14') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1121') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '125',
      :v_hecho,
      '2023-05-15',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000445' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pedro Sacatepéquez') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000445', 'VICTIMA', '1980-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000445', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-09') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '37',
      :v_hecho,
      '2023-07-09',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000446' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Río Blanco') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000446', 'VICTIMA', '1977-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000446', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '178',
      :v_hecho,
      '2023-07-28',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000447' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pedro Sacatepéquez') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000447', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000447', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-09-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '45',
      :v_hecho,
      '2023-09-28',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000448' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Malacatán') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000448', 'VICTIMA', '2010-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000448', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-10-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2112') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '73',
      :v_hecho,
      '2023-10-06',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000449' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Malacatán') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000449', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000449', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-10-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2121') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '114',
      :v_hecho,
      '2023-10-20',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000450' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pedro Sacatepéquez') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000450', 'VICTIMA', '1975-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000450', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-11-06') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '37',
      :v_hecho,
      '2023-11-06',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000451' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pedro Sacatepéquez') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000451', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000451', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-11-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1222') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '72',
      :v_hecho,
      '2023-11-28',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000452' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Pajapita') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000452', 'VICTIMA', '2003-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000452', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-10-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '196',
      :v_hecho,
      '2023-11-02',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000453' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pedro Sacatepéquez') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000453', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000453', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '5',
      :v_hecho,
      '2023-12-03',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000454' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pedro Sacatepéquez') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000454', 'VICTIMA', '1990-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000454', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '13',
      :v_hecho,
      '2023-12-13',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      1,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000455' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pedro Sacatepéquez') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000455', 'VICTIMA', '1995-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000455', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-26') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '20',
      :v_hecho,
      '2023-12-27',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000456' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('San Marcos') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pedro Sacatepéquez') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000456', 'VICTIMA', '1988-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000456', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '51',
      :v_hecho,
      '2023-12-26',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000457' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000457', 'VICTIMA', '2007-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000457', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-18') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2112') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '13',
      :v_hecho,
      '2023-01-18',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '3',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000458' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000458', 'VICTIMA', '1974-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000458', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-02') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '41',
      :v_hecho,
      '2023-01-02',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '2',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000459' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000459', 'VICTIMA', '2007-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000459', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-20') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2112') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '33',
      :v_hecho,
      '2023-02-20',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '3',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000460' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Retalhuleu') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Champerico') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000460', 'VICTIMA', '1990-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000460', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-05-13') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '45',
      :v_hecho,
      '2023-05-14',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000461' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santa Bárbara') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000461', 'VICTIMA', '2001-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000461', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-03-12') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '101',
      :v_hecho,
      '2023-03-13',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000462' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Pueblo Nuevo') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000462', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000462', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-12') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2121') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '117',
      :v_hecho,
      '2023-04-13',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000463' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San José El Ídolo') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000463', 'VICTIMA', '1976-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000463', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-08-07') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '77',
      :v_hecho,
      '2023-08-17',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      1,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000464' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000464', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000464', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-08') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '53',
      :v_hecho,
      '2023-01-09',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000465' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salcajá') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000465', 'VICTIMA', '2006-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000465', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1222') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '59',
      :v_hecho,
      '2023-02-16',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000466' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salcajá') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000466', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000466', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-08-06') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1222') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '67',
      :v_hecho,
      '2023-08-07',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000467' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Salcajá') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000467', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000467', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-08-06') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1121') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '77',
      :v_hecho,
      '2023-08-07',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      2,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000468' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Olintepeque') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000468', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000468', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-09-19') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1222') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '71',
      :v_hecho,
      '2023-09-20',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000469' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sololá') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santa Catarina Ixtahuacán') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000469', 'VICTIMA', '1963-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000469', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-11') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1222') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '15',
      :v_hecho,
      '2023-02-14',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '2',
      1,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000470' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sololá') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Nahualá') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000470', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000470', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-11-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '19',
      :v_hecho,
      '2023-11-28',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      1,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000471' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sololá') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Juan La Laguna') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000471', 'VICTIMA', '1996-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000471', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-10') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '20',
      :v_hecho,
      '2023-12-11',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      1,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000472' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Barberena') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000472', 'VICTIMA', '2002-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000472', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '29',
      :v_hecho,
      '2023-04-03',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000473' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Barberena') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000473', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000473', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-04') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '33',
      :v_hecho,
      '2023-04-06',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000474' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Barberena') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000474', 'VICTIMA', '1996-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000474', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-05-18') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '27',
      :v_hecho,
      '2023-05-18',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000475' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Santa Rosa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guazacapán') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000475', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000475', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-05-19') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '62',
      :v_hecho,
      '2023-05-19',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000476' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000476', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000476', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-16') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '14',
      :v_hecho,
      '2023-01-18',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000477' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000477', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000477', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-20') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '45',
      :v_hecho,
      '2023-02-20',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000478' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guanagazapa') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000478', 'VICTIMA', '1998-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000478', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-10-05') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1222') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '79',
      :v_hecho,
      '2023-10-06',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000479' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chimaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Andrés Itzapa') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000479', 'VICTIMA', '1975-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000479', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-03-15') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '157',
      :v_hecho,
      '2023-03-16',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      1,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000480' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chimaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San José Poaquil') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000480', 'VICTIMA', '1970-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000480', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-03') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '64',
      :v_hecho,
      '2023-04-06',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      2,
      1,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000481' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chimaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Tecpán Guatemala') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000481', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000481', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-05-16') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '90',
      :v_hecho,
      '2023-05-18',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000482' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chimaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Zaragoza') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000482', 'VICTIMA', '1971-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000482', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-09-16') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '173',
      :v_hecho,
      '2023-09-19',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000483' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sacatepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santa María de Jesús') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000483', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000483', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-04') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '86',
      :v_hecho,
      '2023-02-06',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000484' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sacatepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Jocotenango') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000484', 'VICTIMA', '1972-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000484', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-23') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1222') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '26',
      :v_hecho,
      '2023-07-25',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000485' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sacatepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Ciudad Vieja') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000485', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000485', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-08-24') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '70',
      :v_hecho,
      '2023-08-24',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000486' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sacatepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Antonio Aguas Calientes') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000486', 'VICTIMA', '1991-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000486', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-11-06') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '101',
      :v_hecho,
      '2023-11-06',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000487' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sacatepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Sumpango') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000487', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000487', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2121') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '35',
      :v_hecho,
      '2023-12-27',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      4,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000488' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sacatepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santiago Sacatepéquez') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000488', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000488', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-27') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '37',
      :v_hecho,
      '2023-12-27',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000489' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('El Progreso') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('El Jícaro') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000489', 'VICTIMA', '2002-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000489', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-05-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '49',
      :v_hecho,
      '2023-05-25',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000490' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('El Progreso') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('El Jícaro') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000490', 'VICTIMA', '2002-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000490', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-05-26') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '56',
      :v_hecho,
      '2023-05-26',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000491' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('El Progreso') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('El Jícaro') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000491', 'VICTIMA', '1995-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000491', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-06-02') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '32',
      :v_hecho,
      '2023-06-02',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000492' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('El Progreso') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Sanarate') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000492', 'VICTIMA', '1992-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000492', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-16') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '63',
      :v_hecho,
      '2023-07-16',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      1,
      0,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000493' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('El Progreso') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Agustín Acasaguastlán') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000493', 'VICTIMA', '1924-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000493', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-10-07') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '18',
      :v_hecho,
      '2023-10-12',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000494' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000494', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000494', 'AGRESOR', '2008-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2026-12-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '174',
      :v_hecho,
      '2023-01-27',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      1,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000495' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Petapa') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000495', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000495', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '756',
      :v_hecho,
      '2023-01-28',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000496' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000496', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000496', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-07') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '54',
      :v_hecho,
      '2023-02-08',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000497' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000497', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000497', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-12') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '212',
      :v_hecho,
      '2023-04-12',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000498' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000498', 'VICTIMA', '2003-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000498', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '361',
      :v_hecho,
      '2023-04-26',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000499' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000499', 'VICTIMA', '2002-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000499', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-25') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '363',
      :v_hecho,
      '2023-04-26',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^


EXECUTE BLOCK AS
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000500' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Villa Nueva') ROWS 1 INTO v_muni;
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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000500', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000500', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-11') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122') ROWS 1 INTO v_tipo_agre;

  INSERT INTO caso_violencia_intrafamiliar (
      numero_boleta,
      id_hecho,
      fecha_emision,
      id_tipo_agresion_intrafamiliar,
      id_victima,
      id_agresor_principal,
      quien_reporta,
      otras_victimas_total,
      agresores_otros_total,
      organismo_jurisdiccional,
      conducente,
      ley_aplicable,
      id_institucion_organicacion
  ) VALUES (
      '638',
      :v_hecho,
      '2023-04-11',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      99,
      NULL,
      NULL,
      NULL,
      NULL
  );
END^

SET TERM ; ^
COMMIT;
