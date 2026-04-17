SET NAMES UTF8;

INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Racial y Étnica', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(TRIM(nombre)) = UPPER('Racial y Étnica'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Discriminación', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(TRIM(nombre)) = UPPER('Discriminación'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Discriminación Étnica', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(TRIM(nombre)) = UPPER('Discriminación Étnica'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Étnica laboral', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(TRIM(nombre)) = UPPER('Étnica laboral'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Étnica racial', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(TRIM(nombre)) = UPPER('Étnica racial'));

COMMIT;