SET NAMES UTF8;

INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT '0', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(TRIM(nombre)) = UPPER('0'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT '1', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(TRIM(nombre)) = UPPER('1'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Racial', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(TRIM(nombre)) = UPPER('Racial'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'X', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(TRIM(nombre)) = UPPER('X'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Étnica', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(TRIM(nombre)) = UPPER('Étnica'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Étnica/ Género', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(TRIM(nombre)) = UPPER('Étnica/ Género'));

COMMIT;