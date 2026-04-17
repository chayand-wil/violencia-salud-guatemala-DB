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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000303' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000303', 'VICTIMA', '1963-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000303', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-06-02') RETURNING id_hecho INTO v_hecho;

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
      '50',
      :v_hecho,
      '2023-06-02',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000304' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000304', 'VICTIMA', '1978-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000304', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-10') RETURNING id_hecho INTO v_hecho;

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
      '2023-07-11',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '2',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000305' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000305', 'VICTIMA', '1980-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000305', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-09-13') RETURNING id_hecho INTO v_hecho;

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
      '151',
      :v_hecho,
      '2023-09-15',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000306' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000306', 'VICTIMA', '1996-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000306', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-10-19') RETURNING id_hecho INTO v_hecho;

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
      '95',
      :v_hecho,
      '2023-10-19',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000307' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000307', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000307', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-24') RETURNING id_hecho INTO v_hecho;

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
      '9',
      :v_hecho,
      '2023-12-24',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000308' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sacatepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Bartolomé Milpas Altas') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000308', 'VICTIMA', '1988-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000308', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-16') RETURNING id_hecho INTO v_hecho;

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
      '78',
      :v_hecho,
      '2023-01-19',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000309' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Sacatepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Lucas Sacatepéquez') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000309', 'VICTIMA', '1955-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000309', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-09') RETURNING id_hecho INTO v_hecho;

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
      '71',
      :v_hecho,
      '2023-02-10',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000310' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000310', 'VICTIMA', '1988-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000310', 'AGRESOR', '2004-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2022-02-17') RETURNING id_hecho INTO v_hecho;

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
      '123',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000311' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000311', 'VICTIMA', '1982-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000311', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-05-16') RETURNING id_hecho INTO v_hecho;

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
      '9',
      :v_hecho,
      '2023-05-17',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      3,
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000312' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000312', 'VICTIMA', '1952-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000312', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-11-15') RETURNING id_hecho INTO v_hecho;

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
      '92',
      :v_hecho,
      '2023-11-16',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000313' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000313', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000313', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-15') RETURNING id_hecho INTO v_hecho;

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
      '69',
      :v_hecho,
      '2023-01-15',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000314' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('El Progreso') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Sansare') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000314', 'VICTIMA', '2003-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000314', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-03-15') RETURNING id_hecho INTO v_hecho;

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
      '48',
      :v_hecho,
      '2023-03-15',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000315' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000315', 'VICTIMA', '1980-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000315', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-05-05') RETURNING id_hecho INTO v_hecho;

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
      '98',
      :v_hecho,
      '2023-05-06',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000316' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000316', 'VICTIMA', '1975-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000316', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-09-13') RETURNING id_hecho INTO v_hecho;

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
      '42',
      :v_hecho,
      '2023-09-13',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000317' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000317', 'VICTIMA', '2000-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000317', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
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
      '32',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000318' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000318', 'VICTIMA', '2000-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000318', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-28') RETURNING id_hecho INTO v_hecho;

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
      '42',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000319' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000319', 'VICTIMA', '1980-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000319', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-28') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2221') ROWS 1 INTO v_tipo_agre;

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
      '577',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000320' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000320', 'VICTIMA', '1986-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000320', 'AGRESOR', '2004-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2022-12-16') RETURNING id_hecho INTO v_hecho;

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
      '648',
      :v_hecho,
      '2023-03-16',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '9',
      99,
      4,
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000321' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000321', 'VICTIMA', '1986-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000321', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-03-20') RETURNING id_hecho INTO v_hecho;

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
      '769',
      :v_hecho,
      '2023-03-21',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000322' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000322', 'VICTIMA', '1939-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000322', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-09') RETURNING id_hecho INTO v_hecho;

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
      '461',
      :v_hecho,
      '2023-04-10',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
      2,
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000323' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000323', 'VICTIMA', '1990-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000323', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-02') RETURNING id_hecho INTO v_hecho;

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
      '595',
      :v_hecho,
      '2023-04-03',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000324' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000324', 'VICTIMA', '1977-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000324', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-05-04') RETURNING id_hecho INTO v_hecho;

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
      '820',
      :v_hecho,
      '2023-05-04',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      3,
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000325' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000325', 'VICTIMA', '1997-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000325', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-06-08') RETURNING id_hecho INTO v_hecho;

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
      '558',
      :v_hecho,
      '2023-06-14',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '2',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000326' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pedro Ayampuc') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000326', 'VICTIMA', '1984-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000326', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-02') RETURNING id_hecho INTO v_hecho;

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
      '503',
      :v_hecho,
      '2023-07-02',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000327' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Palencia') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000327', 'VICTIMA', '1968-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000327', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-08-27') RETURNING id_hecho INTO v_hecho;

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
      '516',
      :v_hecho,
      '2023-08-27',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000328' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Fraijanes') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000328', 'VICTIMA', '1991-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000328', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-08-26') RETURNING id_hecho INTO v_hecho;

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
      '2',
      :v_hecho,
      '2023-09-13',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000329' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000329', 'VICTIMA', '1970-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000329', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-09-17') RETURNING id_hecho INTO v_hecho;

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
      '415',
      :v_hecho,
      '2023-09-18',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000330' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000330', 'VICTIMA', '1924-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000330', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-09-17') RETURNING id_hecho INTO v_hecho;

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
      '747',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000331' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San José Pinula') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000331', 'VICTIMA', '1986-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000331', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-11-03') RETURNING id_hecho INTO v_hecho;

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
      '441',
      :v_hecho,
      '2023-11-03',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000332' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000332', 'VICTIMA', '1992-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000332', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-04') RETURNING id_hecho INTO v_hecho;

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
      '7',
      :v_hecho,
      '2023-12-05',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000333' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000333', 'VICTIMA', '2002-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000333', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-09') RETURNING id_hecho INTO v_hecho;

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
      '415',
      :v_hecho,
      '2023-12-09',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000334' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cobán') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000334', 'VICTIMA', '1999-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000334', 'AGRESOR', '2008-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2026-12-28') RETURNING id_hecho INTO v_hecho;

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
      '1083',
      :v_hecho,
      '2023-04-27',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000335' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000335', 'VICTIMA', '1975-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000335', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-26') RETURNING id_hecho INTO v_hecho;

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
      '3040',
      :v_hecho,
      '2023-04-26',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000336' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pedro Carchá') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000336', 'VICTIMA', '1992-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000336', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-20') RETURNING id_hecho INTO v_hecho;

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
      '9002',
      :v_hecho,
      '2023-12-21',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000337' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000337', 'VICTIMA', '1975-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000337', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-04') RETURNING id_hecho INTO v_hecho;

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
      '95',
      :v_hecho,
      '2023-02-07',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000338' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('El Progreso') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Morazán') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000338', 'VICTIMA', '1981-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000338', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-11-02') RETURNING id_hecho INTO v_hecho;

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
      '9',
      :v_hecho,
      '2023-11-03',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000339' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Juan Sacatepéquez') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000339', 'VICTIMA', '2000-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000339', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-06-28') RETURNING id_hecho INTO v_hecho;

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
      '639',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000341' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Moyuta') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000341', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000341', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-09-06') RETURNING id_hecho INTO v_hecho;

  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima') ROWS 1 INTO v_inv_vic;
  SELECT id_involucramiento FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor') ROWS 1 INTO v_inv_agr;
  IF (v_inv_vic IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_victima, :v_inv_vic);
  IF (v_inv_agr IS NOT NULL) THEN INSERT INTO involucrado_hecho (id_hecho, id_involucrado, id_tipo_involucramiento) VALUES (:v_hecho, :v_agresor, :v_inv_agr);

  SELECT id_tipo_agresion_intrafamiliar FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2221') ROWS 1 INTO v_tipo_agre;

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
      '2023-09-16',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000342' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Moyuta') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000342', 'VICTIMA', '2006-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000342', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-10-22') RETURNING id_hecho INTO v_hecho;

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
      '2023-10-23',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000343' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('El Progreso') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000343', 'VICTIMA', '1999-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000343', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-10-22') RETURNING id_hecho INTO v_hecho;

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
      '50',
      :v_hecho,
      '2023-10-27',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000344' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Jutiapa') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Moyuta') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000344', 'VICTIMA', '2003-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000344', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-16') RETURNING id_hecho INTO v_hecho;

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
      '23',
      :v_hecho,
      '2023-12-16',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000345' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000345', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000345', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-01') RETURNING id_hecho INTO v_hecho;

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
      '2023-01-03',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000346' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000346', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000346', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-26') RETURNING id_hecho INTO v_hecho;

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
      '19',
      :v_hecho,
      '2023-07-27',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000347' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Izabal') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Morales') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000347', 'VICTIMA', '1984-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000347', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
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
      '53',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000348' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Izabal') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Puerto Barrios') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000348', 'VICTIMA', '2002-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000348', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-03-02') RETURNING id_hecho INTO v_hecho;

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
      '11',
      :v_hecho,
      '2023-03-03',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000349' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000349', 'VICTIMA', '2006-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000349', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-24') RETURNING id_hecho INTO v_hecho;

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
      '51',
      :v_hecho,
      '2023-12-24',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000350' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000350', 'VICTIMA', '1978-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000350', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-03') RETURNING id_hecho INTO v_hecho;

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
      '3008',
      :v_hecho,
      '2023-01-03',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000351' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cobán') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000351', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000351', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-01') RETURNING id_hecho INTO v_hecho;

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
      '1020',
      :v_hecho,
      '2023-01-02',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000352' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santa Catalina la Tinta') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000352', 'VICTIMA', '2008-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000352', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-04') RETURNING id_hecho INTO v_hecho;

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
      '16003',
      :v_hecho,
      '2023-01-04',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000353' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000353', 'VICTIMA', '1997-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000353', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-08') RETURNING id_hecho INTO v_hecho;

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
      '3010',
      :v_hecho,
      '2023-02-08',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000354' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santa Catalina la Tinta') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000354', 'VICTIMA', '1980-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000354', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-24') RETURNING id_hecho INTO v_hecho;

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
      '16034',
      :v_hecho,
      '2023-02-27',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000355' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000355', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000355', 'AGRESOR', '2004-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2022-12-04') RETURNING id_hecho INTO v_hecho;

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
      '3003',
      :v_hecho,
      '2023-03-06',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000356' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santa Catalina la Tinta') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000356', 'VICTIMA', '2008-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000356', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-03-19') RETURNING id_hecho INTO v_hecho;

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
      '16026',
      :v_hecho,
      '2023-03-19',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000357' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Juan Chamelco') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000357', 'VICTIMA', '2007-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000357', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-18') RETURNING id_hecho INTO v_hecho;

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
      '1008',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000358' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Panzós') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000358', 'VICTIMA', '2000-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000358', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-08') RETURNING id_hecho INTO v_hecho;

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
      '7022',
      :v_hecho,
      '2023-04-08',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      1,
      3,
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000359' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Raxruhá') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000359', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000359', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-04-01') RETURNING id_hecho INTO v_hecho;

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
      '17003',
      :v_hecho,
      '2023-04-10',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000360' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Juan Chamelco') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000360', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000360', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-05-02') RETURNING id_hecho INTO v_hecho;

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
      '10003',
      :v_hecho,
      '2023-05-03',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000361' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cobán') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000361', 'VICTIMA', '1991-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000361', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-06-28') RETURNING id_hecho INTO v_hecho;

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
      '1095',
      :v_hecho,
      '2023-06-28',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000362' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000362', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000362', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-06-12') RETURNING id_hecho INTO v_hecho;

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
      '3016',
      :v_hecho,
      '2023-06-12',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000363' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santa Catalina la Tinta') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000363', 'VICTIMA', '1999-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000363', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-06-25') RETURNING id_hecho INTO v_hecho;

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
      '16028',
      :v_hecho,
      '2023-06-25',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000364' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santa Catalina la Tinta') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000364', 'VICTIMA', '2006-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000364', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-06-26') RETURNING id_hecho INTO v_hecho;

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
      '16031',
      :v_hecho,
      '2023-06-26',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000365' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santa Cruz Verapaz') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000365', 'VICTIMA', '1993-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000365', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-20') RETURNING id_hecho INTO v_hecho;

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
      '2018',
      :v_hecho,
      '2023-07-21',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      3,
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000366' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000366', 'VICTIMA', '2006-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000366', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-02') RETURNING id_hecho INTO v_hecho;

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
      '3003',
      :v_hecho,
      '2023-07-03',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000367' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pedro Carchá') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000367', 'VICTIMA', '1991-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000367', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-08-14') RETURNING id_hecho INTO v_hecho;

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
      '9013',
      :v_hecho,
      '2023-08-14',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000368' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Chisec') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000368', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000368', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-08-15') RETURNING id_hecho INTO v_hecho;

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
      '13014',
      :v_hecho,
      '2023-08-15',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      2,
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000369' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Fray Bartolomé de Las Casas') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000369', 'VICTIMA', '2000-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000369', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-08-20') RETURNING id_hecho INTO v_hecho;

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
      '15010',
      :v_hecho,
      '2023-08-23',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000370' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santa Catalina la Tinta') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000370', 'VICTIMA', '2006-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000370', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-08-15') RETURNING id_hecho INTO v_hecho;

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
      '16019',
      :v_hecho,
      '2023-08-15',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000371' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Lanquín') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000371', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000371', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-09-09') RETURNING id_hecho INTO v_hecho;

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
      '11009',
      :v_hecho,
      '2023-09-09',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000372' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Lanquín') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000372', 'VICTIMA', '1991-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000372', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-11-21') RETURNING id_hecho INTO v_hecho;

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
      '11011',
      :v_hecho,
      '2023-11-22',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000373' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pedro Carchá') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000373', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000373', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-11-09') RETURNING id_hecho INTO v_hecho;

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
      '15015',
      :v_hecho,
      '2023-11-10',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000374' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Fray Bartolomé de Las Casas') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000374', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000374', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
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
      '15024',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000375' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santa Catalina la Tinta') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000375', 'VICTIMA', '2002-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000375', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-11-02') RETURNING id_hecho INTO v_hecho;

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
      '16008',
      :v_hecho,
      '2023-11-02',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000376' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cobán') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000376', 'VICTIMA', '1961-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000376', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-12') RETURNING id_hecho INTO v_hecho;

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
      '1034',
      :v_hecho,
      '2023-12-12',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000377' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Cobán') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000377', 'VICTIMA', '2002-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000377', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-22') RETURNING id_hecho INTO v_hecho;

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
      '1053',
      :v_hecho,
      '2023-12-22',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000378' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Fray Bartolomé de Las Casas') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000378', 'VICTIMA', '1970-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000378', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-28') RETURNING id_hecho INTO v_hecho;

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
      '15039',
      :v_hecho,
      '2023-12-28',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000379' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Alta Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Santa Catalina la Tinta') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000379', 'VICTIMA', '1999-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000379', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-28') RETURNING id_hecho INTO v_hecho;

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
      '16030',
      :v_hecho,
      '2023-12-28',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000380' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000380', 'VICTIMA', '1969-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000380', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

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
      '106',
      :v_hecho,
      '2023-02-01',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000381' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Baja Verapaz') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('El Chol') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000381', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000381', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-15') RETURNING id_hecho INTO v_hecho;

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
      '603',
      :v_hecho,
      '2023-07-15',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000382' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000382', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000382', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-03') RETURNING id_hecho INTO v_hecho;

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
      '816',
      :v_hecho,
      '2023-07-03',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000383' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000383', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000383', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
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
      '806',
      :v_hecho,
      '2023-10-28',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000384' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quiché') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Joyabaj') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000384', 'VICTIMA', '2006-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000384', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-03-28') RETURNING id_hecho INTO v_hecho;

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
      '2023-03-28',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000385' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quiché') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Nebaj') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000385', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000385', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-03-09') RETURNING id_hecho INTO v_hecho;

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
      '38',
      :v_hecho,
      '2023-03-13',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      0,
      2,
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000386' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000386', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000386', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-05-09') RETURNING id_hecho INTO v_hecho;

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
      '120',
      :v_hecho,
      '2023-05-09',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000387' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Suchitepéquez') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Pablo Jocopilas') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000387', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000387', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-05') RETURNING id_hecho INTO v_hecho;

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
      '2023-01-06',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000388' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000388', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000388', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-09-06') RETURNING id_hecho INTO v_hecho;

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
      '2023-09-06',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000389' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000389', 'VICTIMA', '2004-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000389', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-11-04') RETURNING id_hecho INTO v_hecho;

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
      '46',
      :v_hecho,
      '2023-11-05',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000390' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Quetzaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Mateo') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000390', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000390', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-15') RETURNING id_hecho INTO v_hecho;

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
      '136',
      :v_hecho,
      '2023-12-15',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000391' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Totonicapán') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('San Cristóbal Totonicapán') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000391', 'VICTIMA', '1985-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000391', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-07-04') RETURNING id_hecho INTO v_hecho;

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
      '22',
      :v_hecho,
      '2023-07-04',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000392' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Totonicapán') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Totonicapán') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000392', 'VICTIMA', '1999-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000392', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-11-25') RETURNING id_hecho INTO v_hecho;

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
      '13',
      :v_hecho,
      '2023-11-25',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000393' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000393', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000393', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-02-06') RETURNING id_hecho INTO v_hecho;

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
      '150',
      :v_hecho,
      '2023-02-06',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000394' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000394', 'VICTIMA', '1980-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000394', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
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
      '151',
      :v_hecho,
      '2023-02-15',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000395' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000395', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000395', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
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
      '152',
      :v_hecho,
      '2023-02-12',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000396' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Nueva Concepción') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000396', 'VICTIMA', '2001-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000396', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-03-01') RETURNING id_hecho INTO v_hecho;

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
      '128',
      :v_hecho,
      '2023-03-01',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000397' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Nueva Concepción') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000397', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000397', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-05-18') RETURNING id_hecho INTO v_hecho;

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
      '133',
      :v_hecho,
      '2023-05-18',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000398' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Escuintla') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('Siquinalá') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000398', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000398', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-06-02') RETURNING id_hecho INTO v_hecho;

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
      '60',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000399' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000399', 'VICTIMA', '2007-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000399', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-01-22') RETURNING id_hecho INTO v_hecho;

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
      '2023-01-23',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000400' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Mujer') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000400', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000400', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-03-05') RETURNING id_hecho INTO v_hecho;

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
      '74',
      :v_hecho,
      '2023-03-20',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000401' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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
  VALUES ('VIF23V_000401', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000401', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-08-21') RETURNING id_hecho INTO v_hecho;

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
      '58',
      :v_hecho,
      '2023-08-22',
      :v_tipo_agre,
      :v_victima,
      :v_agresor,
      '1',
      99,
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000402' AND p.apellidos = 'VICTIMA')) THEN EXIT;

  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Chimaltenango') ROWS 1 INTO v_dep;
  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dep AND UPPER(TRIM(nombre)) = UPPER('El Tejar') ROWS 1 INTO v_muni;
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
  VALUES ('VIF23V_000402', 'VICTIMA', '2003-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000402', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-10-01') RETURNING id_hecho INTO v_hecho;

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
      '157',
      :v_hecho,
      '2023-10-01',
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
  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = 'VIF23V_000403' AND p.apellidos = 'VICTIMA')) THEN EXIT;

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

  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_vic;
  IF (v_gen_vic IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_vic;
  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Hombre') ROWS 1 INTO v_gen_agr;
  IF (v_gen_agr IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_gen_agr;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23V_000403', 'VICTIMA', '2005-06-15', NULL, :v_gen_vic, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_victima;

  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)
  VALUES ('VIF23A_000403', 'AGRESOR', '2005-06-15', NULL, :v_gen_agr, :v_orient, :v_grupo, :v_eciv, :v_alf, :v_nivel, :v_ubic, 0)
  RETURNING id_persona INTO v_agresor;

  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_intrafamiliar') ROWS 1 INTO v_tipo_hecho;
  IF (v_tipo_hecho IS NULL) THEN SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('hecho_delictivo') ROWS 1 INTO v_tipo_hecho;
  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, '2023-12-10') RETURNING id_hecho INTO v_hecho;

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
      '26',
      :v_hecho,
      '2023-12-10',
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

SET TERM ; ^
COMMIT;
