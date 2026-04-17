SET NAMES UTF8;

/*
  Catalogo base de ocupaciones alineado a ocupacion_clasificacion.
  Inserciones idempotentes por nombre_ocupacion.
*/

INSERT INTO ocupacion (nombre_ocupacion, descripcion, id_ocupacion_clasificacion)
SELECT 'NO_ESPECIFICA', 'Valor por defecto para ocupacion no reportada', c.id_ocupacion_clasificacion
FROM ocupacion_clasificacion c
WHERE UPPER(c.nombre_clasificacion) = 'DESCONOCIDA'
  AND NOT EXISTS (
    SELECT 1 FROM ocupacion o WHERE UPPER(o.nombre_ocupacion) = 'NO_ESPECIFICA'
  );

INSERT INTO ocupacion (nombre_ocupacion, descripcion, id_ocupacion_clasificacion)
SELECT 'AGRICULTOR', 'Trabajo agricola', c.id_ocupacion_clasificacion
FROM ocupacion_clasificacion c
WHERE UPPER(c.nombre_clasificacion) = 'AGROPECUARIA'
  AND NOT EXISTS (
    SELECT 1 FROM ocupacion o WHERE UPPER(o.nombre_ocupacion) = 'AGRICULTOR'
  );

INSERT INTO ocupacion (nombre_ocupacion, descripcion, id_ocupacion_clasificacion)
SELECT 'GANADERO', 'Trabajo en actividades pecuarias', c.id_ocupacion_clasificacion
FROM ocupacion_clasificacion c
WHERE UPPER(c.nombre_clasificacion) = 'AGROPECUARIA'
  AND NOT EXISTS (
    SELECT 1 FROM ocupacion o WHERE UPPER(o.nombre_ocupacion) = 'GANADERO'
  );

INSERT INTO ocupacion (nombre_ocupacion, descripcion, id_ocupacion_clasificacion)
SELECT 'COMERCIANTE', 'Actividad comercial', c.id_ocupacion_clasificacion
FROM ocupacion_clasificacion c
WHERE UPPER(c.nombre_clasificacion) = 'COMERCIO_Y_SERVICIOS'
  AND NOT EXISTS (
    SELECT 1 FROM ocupacion o WHERE UPPER(o.nombre_ocupacion) = 'COMERCIANTE'
  );

INSERT INTO ocupacion (nombre_ocupacion, descripcion, id_ocupacion_clasificacion)
SELECT 'TRABAJADOR_DE_SERVICIOS', 'Servicios generales', c.id_ocupacion_clasificacion
FROM ocupacion_clasificacion c
WHERE UPPER(c.nombre_clasificacion) = 'COMERCIO_Y_SERVICIOS'
  AND NOT EXISTS (
    SELECT 1 FROM ocupacion o WHERE UPPER(o.nombre_ocupacion) = 'TRABAJADOR_DE_SERVICIOS'
  );

INSERT INTO ocupacion (nombre_ocupacion, descripcion, id_ocupacion_clasificacion)
SELECT 'AMA_DE_CASA', 'Trabajo domestico no remunerado', c.id_ocupacion_clasificacion
FROM ocupacion_clasificacion c
WHERE UPPER(c.nombre_clasificacion) = 'HOGAR_Y_CUIDADOS'
  AND NOT EXISTS (
    SELECT 1 FROM ocupacion o WHERE UPPER(o.nombre_ocupacion) = 'AMA_DE_CASA'
  );

INSERT INTO ocupacion (nombre_ocupacion, descripcion, id_ocupacion_clasificacion)
SELECT 'CUIDADOR', 'Trabajo de cuidado de personas', c.id_ocupacion_clasificacion
FROM ocupacion_clasificacion c
WHERE UPPER(c.nombre_clasificacion) = 'HOGAR_Y_CUIDADOS'
  AND NOT EXISTS (
    SELECT 1 FROM ocupacion o WHERE UPPER(o.nombre_ocupacion) = 'CUIDADOR'
  );

INSERT INTO ocupacion (nombre_ocupacion, descripcion, id_ocupacion_clasificacion)
SELECT 'ESTUDIANTE', 'Actividad principal estudio', c.id_ocupacion_clasificacion
FROM ocupacion_clasificacion c
WHERE UPPER(c.nombre_clasificacion) = 'ESTUDIANTE'
  AND NOT EXISTS (
    SELECT 1 FROM ocupacion o WHERE UPPER(o.nombre_ocupacion) = 'ESTUDIANTE'
  );

INSERT INTO ocupacion (nombre_ocupacion, descripcion, id_ocupacion_clasificacion)
SELECT 'ALBANIL', 'Oficio de construccion', c.id_ocupacion_clasificacion
FROM ocupacion_clasificacion c
WHERE UPPER(c.nombre_clasificacion) = 'OFICIOS'
  AND NOT EXISTS (
    SELECT 1 FROM ocupacion o WHERE UPPER(o.nombre_ocupacion) = 'ALBANIL'
  );

INSERT INTO ocupacion (nombre_ocupacion, descripcion, id_ocupacion_clasificacion)
SELECT 'MECANICO', 'Oficio de reparacion y mantenimiento', c.id_ocupacion_clasificacion
FROM ocupacion_clasificacion c
WHERE UPPER(c.nombre_clasificacion) = 'OFICIOS'
  AND NOT EXISTS (
    SELECT 1 FROM ocupacion o WHERE UPPER(o.nombre_ocupacion) = 'MECANICO'
  );

INSERT INTO ocupacion (nombre_ocupacion, descripcion, id_ocupacion_clasificacion)
SELECT 'MAESTRO', 'Docencia y formacion educativa', c.id_ocupacion_clasificacion
FROM ocupacion_clasificacion c
WHERE UPPER(c.nombre_clasificacion) = 'PROFESIONAL_TECNICA'
  AND NOT EXISTS (
    SELECT 1 FROM ocupacion o WHERE UPPER(o.nombre_ocupacion) = 'MAESTRO'
  );

INSERT INTO ocupacion (nombre_ocupacion, descripcion, id_ocupacion_clasificacion)
SELECT 'ENFERMERO', 'Atencion de salud', c.id_ocupacion_clasificacion
FROM ocupacion_clasificacion c
WHERE UPPER(c.nombre_clasificacion) = 'PROFESIONAL_TECNICA'
  AND NOT EXISTS (
    SELECT 1 FROM ocupacion o WHERE UPPER(o.nombre_ocupacion) = 'ENFERMERO'
  );

COMMIT;
