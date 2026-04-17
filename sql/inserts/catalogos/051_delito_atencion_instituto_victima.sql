SET NAMES UTF8;

INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'IAV-DEL-001', 'VIOLENCIA CONTRA LA MUJER', 'Fuente Atenciones IV', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo='IAV-DEL-001');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'IAV-DEL-002', 'VIOLENCIA ECONÓMICA', 'Fuente Atenciones IV', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo='IAV-DEL-002');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'IAV-DEL-003', 'VIOLENCIA FISICA', 'Fuente Atenciones IV', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo='IAV-DEL-003');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'IAV-DEL-004', 'VIOLENCIA PSICOLÓGICA', 'Fuente Atenciones IV', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo='IAV-DEL-004');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'IAV-DEL-005', 'VIOLENCIA SEXUAL', 'Fuente Atenciones IV', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo='IAV-DEL-005');

COMMIT;