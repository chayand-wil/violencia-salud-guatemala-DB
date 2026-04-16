SET NAMES UTF8;

INSERT INTO nivel_escolaridad (nombre, orden) SELECT 'Preprimaria', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM nivel_escolaridad WHERE UPPER(nombre)=UPPER('Preprimaria'));
INSERT INTO nivel_escolaridad (nombre, orden) SELECT 'Primaria', 2 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM nivel_escolaridad WHERE UPPER(nombre)=UPPER('Primaria'));
INSERT INTO nivel_escolaridad (nombre, orden) SELECT 'Básico', 3 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM nivel_escolaridad WHERE UPPER(nombre)=UPPER('Básico'));
INSERT INTO nivel_escolaridad (nombre, orden) SELECT 'Diversificado', 4 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM nivel_escolaridad WHERE UPPER(nombre)=UPPER('Diversificado'));
INSERT INTO nivel_escolaridad (nombre, orden) SELECT 'Superior', 5 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM nivel_escolaridad WHERE UPPER(nombre)=UPPER('Superior'));
INSERT INTO nivel_escolaridad (nombre, orden) SELECT 'Ninguno', 6 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM nivel_escolaridad WHERE UPPER(nombre)=UPPER('Ninguno'));
INSERT INTO nivel_escolaridad (nombre, orden) SELECT 'Ignorado', 9 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM nivel_escolaridad WHERE UPPER(nombre)=UPPER('Ignorado'));

COMMIT;
