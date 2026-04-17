SET NAMES UTF8;

INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-001', 'Asfixia', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-001');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-002', 'Decapitación', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-002');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-003', 'Electrocución', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-003');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-004', 'Enfermedad vascular, no especificando si es hemorrágico, isquémico, trombótico y embólico', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-004');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-005', 'Evento cerebro vascular', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-005');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-006', 'Evento vascular/aneurisma o malformaciones arteriovenosas', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-006');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-007', 'Fibrosis y cirrosis del hígado', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-007');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-008', 'Hemorragias', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-008');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-009', 'Herida de arma blanca', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-009');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-010', 'Herida de arma de fuego', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-010');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-011', 'Indeterminada', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-011');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-012', 'Infarto', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-012');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-013', 'Intoxicación', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-013');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-014', 'Neumonía', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-014');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-015', 'Pancreatitis', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-015');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-016', 'Peritonitis', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-016');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-017', 'Prematurez', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-017');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-018', 'Quemadura', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-018');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-019', 'Sepsis', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-019');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-020', 'Traumatismo', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-020');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-021', 'Tromboembolia', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-021');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-022', 'Tuberculosis', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-022');
INSERT INTO delito (codigo, nombre, bien_juridico, activo) SELECT 'NEC-DEL-023', 'Úlcera gástrica perforada', 'Fuente Necropsias 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM delito WHERE codigo = 'NEC-DEL-023');

COMMIT;