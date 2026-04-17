SET NAMES UTF8;

/*
  Catalogo base de clasificaciones de ocupacion.
  Inserciones idempotentes por nombre_clasificacion.
*/

INSERT INTO ocupacion_clasificacion (nombre_clasificacion, observaciones)
SELECT 'DESCONOCIDA', 'Valor por defecto cuando no se conoce la clasificacion'
FROM RDB$DATABASE
WHERE NOT EXISTS (
  SELECT 1 FROM ocupacion_clasificacion WHERE UPPER(nombre_clasificacion) = 'DESCONOCIDA'
);

INSERT INTO ocupacion_clasificacion (nombre_clasificacion, observaciones)
SELECT 'AGROPECUARIA', 'Actividades del sector primario'
FROM RDB$DATABASE
WHERE NOT EXISTS (
  SELECT 1 FROM ocupacion_clasificacion WHERE UPPER(nombre_clasificacion) = 'AGROPECUARIA'
);

INSERT INTO ocupacion_clasificacion (nombre_clasificacion, observaciones)
SELECT 'COMERCIO_Y_SERVICIOS', 'Comercio formal/informal y servicios'
FROM RDB$DATABASE
WHERE NOT EXISTS (
  SELECT 1 FROM ocupacion_clasificacion WHERE UPPER(nombre_clasificacion) = 'COMERCIO_Y_SERVICIOS'
);

INSERT INTO ocupacion_clasificacion (nombre_clasificacion, observaciones)
SELECT 'HOGAR_Y_CUIDADOS', 'Trabajo domestico y de cuidados'
FROM RDB$DATABASE
WHERE NOT EXISTS (
  SELECT 1 FROM ocupacion_clasificacion WHERE UPPER(nombre_clasificacion) = 'HOGAR_Y_CUIDADOS'
);

INSERT INTO ocupacion_clasificacion (nombre_clasificacion, observaciones)
SELECT 'ESTUDIANTE', 'Actividad principal de estudio'
FROM RDB$DATABASE
WHERE NOT EXISTS (
  SELECT 1 FROM ocupacion_clasificacion WHERE UPPER(nombre_clasificacion) = 'ESTUDIANTE'
);

INSERT INTO ocupacion_clasificacion (nombre_clasificacion, observaciones)
SELECT 'OFICIOS', 'Oficios tecnicos y operativos'
FROM RDB$DATABASE
WHERE NOT EXISTS (
  SELECT 1 FROM ocupacion_clasificacion WHERE UPPER(nombre_clasificacion) = 'OFICIOS'
);

INSERT INTO ocupacion_clasificacion (nombre_clasificacion, observaciones)
SELECT 'PROFESIONAL_TECNICA', 'Profesiones y tecnicos especializados'
FROM RDB$DATABASE
WHERE NOT EXISTS (
  SELECT 1 FROM ocupacion_clasificacion WHERE UPPER(nombre_clasificacion) = 'PROFESIONAL_TECNICA'
);

COMMIT;
