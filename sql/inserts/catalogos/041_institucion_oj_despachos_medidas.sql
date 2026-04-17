SET NAMES UTF8;

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE  PRIMERA INSTANCIA PENAL  NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE  PRIMERA INSTANCIA PENAL  NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA  PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA  PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA DE TRABAJO PREVISIÓN SOCIAL Y FAMILIA', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA DE TRABAJO PREVISIÓN SOCIAL Y FAMILIA')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA DE TRABAJO Y PREVISION SOCIAL Y DE FAMILIA DEL DEPARTAMENTO', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA DE TRABAJO Y PREVISION SOCIAL Y DE FAMILIA DEL DEPARTAMENTO')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA PENAL', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA PENAL')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA PENAL CON COMPETENCIA ESPECIALIZADA EN DELITOS DE TRATA DE PERSONAS', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA PENAL CON COMPETENCIA ESPECIALIZADA EN DELITOS DE TRATA DE PERSONAS')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL DEL DEPARTAMENTO', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL DEL DEPARTAMENTO')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DEVIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DEVIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD DE TURNO', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD DE TURNO')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE 24 HORAS', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE 24 HORAS')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE CIVIL LABORAL Y DE FAMILIA', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE CIVIL LABORAL Y DE FAMILIA')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE DE 24 HORAS', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE DE 24 HORAS')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE DEL MUNICIPIO MALACATA', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE DEL MUNICIPIO MALACATA')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE EN PROCESOS DE MAYOR RIESGO', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE EN PROCESOS DE MAYOR RIESGO')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE PRIMERA INSTANCIA PENAL Y DE NARCOACTIVIDAD', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE PRIMERA INSTANCIA PENAL Y DE NARCOACTIVIDAD')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE TURNO DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE TURNO DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE TURNO DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL -MAIMI-', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE TURNO DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL -MAIMI-')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DE TURNO DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL DEL MUNICIPIO Y DEP', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DE TURNO DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL DEL MUNICIPIO Y DEP')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO DÉCIMO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO DÉCIMO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO NOVENO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO NOVENO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA  DE TRABAJO PREVISIÓN SOCIAL Y FAMILIA', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA  DE TRABAJO PREVISIÓN SOCIAL Y FAMILIA')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA DE TRABAJO Y PREVISIÓN SOCIAL Y FAMILIA', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA DE TRABAJO Y PREVISIÓN SOCIAL Y FAMILIA')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA MIXTO', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA MIXTO')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL DE DELITOS DE EXTORSIÓN DEL DEPARTAMENTO', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL DE DELITOS DE EXTORSIÓN DEL DEPARTAMENTO')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL Y NARCOACTIVIDAD', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL Y NARCOACTIVIDAD')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO PRIMERO DE  PRIMERA INSTANCIA PENAL Y DE NARCOACTIVIDAD', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO PRIMERO DE  PRIMERA INSTANCIA PENAL Y DE NARCOACTIVIDAD')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO QUINTO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO QUINTO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO SEGUNDO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO SEGUNDO DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO SEGUNDO DE PRIMERA INSTANCIA PENAL Y DE NARCOACTIVIDAD', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO SEGUNDO DE PRIMERA INSTANCIA PENAL Y DE NARCOACTIVIDAD')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO SEGUNDO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO SEGUNDO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL DE DELITOS DE FEMICIDIO Y OTRAS FORMAS DE VIOLENCIA CONTRA LA MUJER Y VIOLENCIA SEXUAL')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO SEGUNDO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO SEGUNDO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'JUZGADO SEPTIMO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('JUZGADO SEPTIMO PLURIPERSONAL DE PRIMERA INSTANCIA PENAL NARCOACTIVIDAD Y DELITOS CONTRA EL AMBIENTE')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Cuarto De Paz Movil', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Cuarto De Paz Movil')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Cuarto De Paz Penal', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Cuarto De Paz Penal')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado De Guastatoya', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado De Guastatoya')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Decimo De Paz movil', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Decimo De Paz movil')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Decimo Primero De Paz Movil', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Decimo Primero De Paz Movil')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Decimo Segundo De Paz Movil', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Decimo Segundo De Paz Movil')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Noveno De Paz  Movil', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Noveno De Paz  Movil')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Noveno De Paz Movil', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Noveno De Paz Movil')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Octavo De Paz Movil', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Octavo De Paz Movil')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Primero De Paz', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Primero De Paz')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Primero De Paz Móvil', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Primero De Paz Móvil')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Primero de Paz', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Primero de Paz')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Primero de Paz Penal Civil Trabajo y Familia', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Primero de Paz Penal Civil Trabajo y Familia')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Segundo De Paz', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Segundo De Paz')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Segundo De Paz Movel', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Segundo De Paz Movel')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Segundo Pluripersonal De Paz  Penal', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Segundo Pluripersonal De Paz  Penal')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Segundo de Paz', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Segundo de Paz')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Segundo de Paz Penal Civil Trabajo y Familia', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Segundo de Paz Penal Civil Trabajo y Familia')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Segundode Paz Penal Civil Trabajo y Familia', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Segundode Paz Penal Civil Trabajo y Familia')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Sexto De Paz Movil', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Sexto De Paz Movil')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Séptimo De Paz  Penal', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Séptimo De Paz  Penal')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Séptimo De Paz Movil', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Séptimo De Paz Movil')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Tercero De Paz Movil', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Tercero De Paz Movil')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado Tercero De Paz Penal', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado Tercero De Paz Penal')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz   Civil Familia y Trabajo', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz   Civil Familia y Trabajo')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz   con competencia específica para la protección en materia de violencia intrafamiliar y de niñez y adolescencia amenazada o violada ', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz   con competencia específica para la protección en materia de violencia intrafamiliar y de niñez y adolescencia amenazada o violada ')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz  Del Ramo Civil Familia Y Trabajo', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz  Del Ramo Civil Familia Y Trabajo')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz  Mixto', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz  Mixto')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz  Penal', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz  Penal')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz  Penal 24  horas', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz  Penal 24  horas')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz  Penal 24 horas', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz  Penal 24 horas')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz Civil Familia y Trabajo', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz Civil Familia y Trabajo')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz Comunitario', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz Comunitario')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz Con Competencia Específica Para La Protección En Materia De Violencia Intrafamiliar Y De Niñez Y Adolescencia Amenazada O Violada En', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz Con Competencia Específica Para La Protección En Materia De Violencia Intrafamiliar Y De Niñez Y Adolescencia Amenazada O Violada En')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz Del Ramo Civil Familia Y Trabajo', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz Del Ramo Civil Familia Y Trabajo')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz Mixto', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz Mixto')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz Penal', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz Penal')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz Penal 24 Horas', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz Penal 24 Horas')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz Penal de Faltas', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz Penal de Faltas')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz Penal de Faltas 24 horas', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz Penal de Faltas 24 horas')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz Penal de Faltas de 24 Horas', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz Penal de Faltas de 24 Horas')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz Penal de Turno', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz Penal de Turno')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz civil trabajo y familia', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz civil trabajo y familia')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz comunitario', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz comunitario')
  );

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Juzgado de Paz con competencia específica para la protección en materia de violencia intrafamiliar y de niñez y adolescencia amenazada o violada en', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Organismo Judicial')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Juzgado de Paz con competencia específica para la protección en materia de violencia intrafamiliar y de niñez y adolescencia amenazada o violada en')
  );

COMMIT;