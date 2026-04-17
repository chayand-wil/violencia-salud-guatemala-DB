SET NAMES UTF8;

INSERT INTO involucramiento (nombre, descripcion) SELECT 'Victima', 'Fuente VIF 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Victima'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Agresor', 'Fuente VIF 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor'));

COMMIT;