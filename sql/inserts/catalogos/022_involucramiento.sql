SET NAMES UTF8;

INSERT INTO involucramiento (nombre, descripcion) SELECT 'Agresor', 'Catalogo involucramiento.txt codigo=1' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Agresor'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Denunciado', 'Catalogo involucramiento.txt codigo=2' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Denunciado'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'En contra', 'Catalogo involucramiento.txt codigo=3' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('En contra'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Procesado', 'Catalogo involucramiento.txt codigo=4' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Procesado'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Querellado', 'Catalogo involucramiento.txt codigo=5' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Querellado'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Demandado', 'Catalogo involucramiento.txt codigo=6' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Demandado'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Imputado', 'Catalogo involucramiento.txt codigo=7' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Imputado'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Acusado', 'Catalogo involucramiento.txt codigo=8' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Acusado'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Sindicado', 'Catalogo involucramiento.txt codigo=9' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Sindicado'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Condenado', 'Catalogo involucramiento.txt codigo=10' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Condenado'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Adolescente en conflicto', 'Catalogo involucramiento.txt codigo=11' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Adolescente en conflicto'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Adolescente en conflicto con la Ley Penal', 'Catalogo involucramiento.txt codigo=12' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Adolescente en conflicto con la Ley Penal'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Incidente', 'Catalogo involucramiento.txt codigo=13' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Incidente'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Victimario', 'Catalogo involucramiento.txt codigo=14' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Victimario'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Interponente/sindicado', 'Catalogo involucramiento.txt codigo=15' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Interponente/sindicado'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Recurrido', 'Catalogo involucramiento.txt codigo=16' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Recurrido'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'A favor', 'Catalogo involucramiento.txt codigo=17' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('A favor'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Actor civil', 'Catalogo involucramiento.txt codigo=18' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Actor civil'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Agraviado', 'Catalogo involucramiento.txt codigo=19' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Agraviado'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Denunciante', 'Catalogo involucramiento.txt codigo=20' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Denunciante'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Querellante adhesivo', 'Catalogo involucramiento.txt codigo=21' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Querellante adhesivo'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Solicitante', 'Catalogo involucramiento.txt codigo=22' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Solicitante'));
INSERT INTO involucramiento (nombre, descripcion) SELECT 'Ignorado', 'Catalogo involucramiento.txt codigo=99' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Ignorado'));

COMMIT;
