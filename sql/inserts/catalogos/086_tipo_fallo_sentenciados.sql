SET NAMES UTF8;

INSERT INTO tipo_fallo (nombre, descripcion) SELECT 'Absolutoria', 'Fuente Sentenciados 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_fallo WHERE UPPER(TRIM(nombre)) = UPPER('Absolutoria'));
INSERT INTO tipo_fallo (nombre, descripcion) SELECT 'Condenatoria', 'Fuente Sentenciados 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_fallo WHERE UPPER(TRIM(nombre)) = UPPER('Condenatoria'));

COMMIT;