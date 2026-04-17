SET NAMES UTF8;

INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'Garífuna', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('Garífuna'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'K''Iche''', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('K''Iche'''));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'Maya', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('Maya'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'Q''Qechi''', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('Q''Qechi'''));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'Xinca', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('Xinca'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'Xinka', 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('Xinka'));

COMMIT;