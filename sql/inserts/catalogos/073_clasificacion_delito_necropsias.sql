SET NAMES UTF8;

INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo)
SELECT NULL, 'Causa de muerte', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE UPPER(TRIM(nombre)) = UPPER('Causa de muerte'));

COMMIT;