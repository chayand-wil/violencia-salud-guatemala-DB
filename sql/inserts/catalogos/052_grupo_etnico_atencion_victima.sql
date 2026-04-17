SET NAMES UTF8;

INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'LADINO Y/O MESTIZO', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('LADINO Y/O MESTIZO'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'MAYA', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('MAYA'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'MAYA - ACHÍ', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('MAYA - ACHÍ'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'MAYA - AKATEKO', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('MAYA - AKATEKO'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'MAYA - AWAKATEKO', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('MAYA - AWAKATEKO'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'MAYA - K''ICHE''', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('MAYA - K''ICHE'''));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'MAYA - KAQCHIKEL', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('MAYA - KAQCHIKEL'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'MAYA - MAM', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('MAYA - MAM'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'MAYA - POQOMCHI''', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('MAYA - POQOMCHI'''));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'MAYA - Q''EQCHI''', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('MAYA - Q''EQCHI'''));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'MAYA - TZ''UTUJIL', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('MAYA - TZ''UTUJIL'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'OTRO', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('OTRO'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'SD', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('SD'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'XINCA', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('XINCA'));

COMMIT;