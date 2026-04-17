SET NAMES UTF8;

INSERT INTO delito (codigo, nombre, bien_juridico, activo)
SELECT 'EXH-DEL-001', 'Exhumacion', 'Fuente Exhumaciones 2023', 1 FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'EXH-DEL-001');

COMMIT;