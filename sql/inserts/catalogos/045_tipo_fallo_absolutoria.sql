SET NAMES UTF8;

INSERT INTO tipo_fallo (nombre, descripcion)
SELECT 'Absolutoria', 'Fuente Sentencias OJ VCM 2009-2024' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM tipo_fallo WHERE UPPER(TRIM(nombre)) = UPPER('Absolutoria'));

COMMIT;