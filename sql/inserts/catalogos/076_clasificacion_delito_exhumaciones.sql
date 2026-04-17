SET NAMES UTF8;

INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo)
SELECT NULL, 'Exhumacion', 'Fuente Exhumaciones 2023', 1 FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE UPPER(TRIM(nombre)) = UPPER('Exhumacion'));

COMMIT;