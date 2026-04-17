SET NAMES UTF8;

INSERT INTO tipo_agresion_ninez (nombre, descripcion) SELECT 'Embarazo en menor de 14 años', 'Fuente Quejas Mineduc 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Embarazo en menor de 14 años'));
INSERT INTO tipo_agresion_ninez (nombre, descripcion) SELECT 'Violencia física y psicológica', 'Fuente Quejas Mineduc 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Violencia física y psicológica'));
INSERT INTO tipo_agresion_ninez (nombre, descripcion) SELECT 'Acoso escolar (bullying)', 'Fuente Quejas Mineduc 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Acoso escolar (bullying)'));
INSERT INTO tipo_agresion_ninez (nombre, descripcion) SELECT 'Acoso y hostigamiento sexual', 'Fuente Quejas Mineduc 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Acoso y hostigamiento sexual'));
INSERT INTO tipo_agresion_ninez (nombre, descripcion) SELECT 'Racismo y discriminación', 'Fuente Quejas Mineduc 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Racismo y discriminación'));
INSERT INTO tipo_agresion_ninez (nombre, descripcion) SELECT 'Violencia sexual', 'Fuente Quejas Mineduc 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Violencia sexual'));
INSERT INTO tipo_agresion_ninez (nombre, descripcion) SELECT 'Abuso de autoridad', 'Fuente Quejas Mineduc 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_ninez WHERE UPPER(TRIM(nombre)) = UPPER('Abuso de autoridad'));

COMMIT;