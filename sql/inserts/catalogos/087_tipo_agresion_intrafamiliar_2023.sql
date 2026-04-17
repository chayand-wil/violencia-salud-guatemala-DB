SET NAMES UTF8;

INSERT INTO tipo_agresion_intrafamiliar (nombre, descripcion) SELECT 'TIPAGRE_1112', 'Fuente VIF 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1112'));
INSERT INTO tipo_agresion_intrafamiliar (nombre, descripcion) SELECT 'TIPAGRE_1121', 'Fuente VIF 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1121'));
INSERT INTO tipo_agresion_intrafamiliar (nombre, descripcion) SELECT 'TIPAGRE_1122', 'Fuente VIF 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1122'));
INSERT INTO tipo_agresion_intrafamiliar (nombre, descripcion) SELECT 'TIPAGRE_1222', 'Fuente VIF 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_1222'));
INSERT INTO tipo_agresion_intrafamiliar (nombre, descripcion) SELECT 'TIPAGRE_2111', 'Fuente VIF 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2111'));
INSERT INTO tipo_agresion_intrafamiliar (nombre, descripcion) SELECT 'TIPAGRE_2112', 'Fuente VIF 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2112'));
INSERT INTO tipo_agresion_intrafamiliar (nombre, descripcion) SELECT 'TIPAGRE_2121', 'Fuente VIF 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2121'));
INSERT INTO tipo_agresion_intrafamiliar (nombre, descripcion) SELECT 'TIPAGRE_2122', 'Fuente VIF 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2122'));
INSERT INTO tipo_agresion_intrafamiliar (nombre, descripcion) SELECT 'TIPAGRE_2212', 'Fuente VIF 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2212'));
INSERT INTO tipo_agresion_intrafamiliar (nombre, descripcion) SELECT 'TIPAGRE_2221', 'Fuente VIF 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_agresion_intrafamiliar WHERE UPPER(TRIM(nombre)) = UPPER('TIPAGRE_2221'));

COMMIT;