SET NAMES UTF8;

INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'MED-DEL-001', 'Aborto', 'Fuente Medicos INACIF 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'MED-DEL-001');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'MED-DEL-002', 'Determinación de uso de drogas, fármacos o estupefacientes', 'Fuente Medicos INACIF 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'MED-DEL-002');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'MED-DEL-003', 'Edad cronológica', 'Fuente Medicos INACIF 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'MED-DEL-003');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'MED-DEL-004', 'Embarazo', 'Fuente Medicos INACIF 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'MED-DEL-004');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'MED-DEL-005', 'Embriaguez', 'Fuente Medicos INACIF 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'MED-DEL-005');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'MED-DEL-006', 'Enfermedad común', 'Fuente Medicos INACIF 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'MED-DEL-006');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'MED-DEL-007', 'Herida por arma blanca', 'Fuente Medicos INACIF 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'MED-DEL-007');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'MED-DEL-008', 'Herida por arma de fuego', 'Fuente Medicos INACIF 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'MED-DEL-008');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'MED-DEL-009', 'Intoxicación', 'Fuente Medicos INACIF 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'MED-DEL-009');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'MED-DEL-010', 'Lesiones', 'Fuente Medicos INACIF 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'MED-DEL-010');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'MED-DEL-011', 'Otros', 'Fuente Medicos INACIF 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'MED-DEL-011');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'MED-DEL-012', 'Reconocimiento médico para determinar estado de salud', 'Fuente Medicos INACIF 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'MED-DEL-012');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'MED-DEL-013', 'Toma de muestras', 'Fuente Medicos INACIF 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'MED-DEL-013');

COMMIT;