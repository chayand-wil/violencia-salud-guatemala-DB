SET NAMES UTF8;

INSERT INTO involucramiento (nombre, descripcion) SELECT 'Acusado', 'Fuente Sentenciados 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Acusado'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Adolescentes en conflicto', 'Fuente Sentenciados 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Adolescentes en conflicto'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Adolescentes en conflicto con la Ley Penal', 'Fuente Sentenciados 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Adolescentes en conflicto con la Ley Penal'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Agresor', 'Fuente Sentenciados 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agresor'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Condenado', 'Fuente Sentenciados 2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Condenado'));

COMMIT;