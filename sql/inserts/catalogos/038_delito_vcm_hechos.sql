SET NAMES UTF8;

INSERT INTO delito (codigo, nombre, bien_juridico, activo)
SELECT 'VCM-HD-DEL-001', 'HOMICIDIO', 'Fuente VCM Hechos Delictivos', 1 FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo='VCM-HD-DEL-001');

INSERT INTO delito (codigo, nombre, bien_juridico, activo)
SELECT 'VCM-HD-DEL-002', 'LESIONES', 'Fuente VCM Hechos Delictivos', 1 FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo='VCM-HD-DEL-002');

INSERT INTO delito (codigo, nombre, bien_juridico, activo)
SELECT 'VCM-HD-DEL-003', 'DESAPARICIONES', 'Fuente VCM Hechos Delictivos', 1 FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo='VCM-HD-DEL-003');

INSERT INTO delito (codigo, nombre, bien_juridico, activo)
SELECT 'VCM-HD-DEL-004', 'SECUESTROS', 'Fuente VCM Hechos Delictivos', 1 FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo='VCM-HD-DEL-004');

INSERT INTO delito (codigo, nombre, bien_juridico, activo)
SELECT 'VCM-HD-DEL-005', 'VIOLENCIA', 'Fuente VCM Hechos Delictivos', 1 FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo='VCM-HD-DEL-005');

INSERT INTO delito (codigo, nombre, bien_juridico, activo)
SELECT 'VCM-HD-DEL-006', 'OTROS', 'Fuente VCM Hechos Delictivos', 1 FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo='VCM-HD-DEL-006');

COMMIT;
