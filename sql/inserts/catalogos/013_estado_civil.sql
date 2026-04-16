SET NAMES UTF8;

INSERT INTO estado_civil (nombre, descripcion) SELECT 'Soltero (a)', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM estado_civil WHERE UPPER(nombre)=UPPER('Soltero (a)'));
INSERT INTO estado_civil (nombre, descripcion) SELECT 'Casado (a)', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM estado_civil WHERE UPPER(nombre)=UPPER('Casado (a)'));
INSERT INTO estado_civil (nombre, descripcion) SELECT 'Unido (a)', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM estado_civil WHERE UPPER(nombre)=UPPER('Unido (a)'));
INSERT INTO estado_civil (nombre, descripcion) SELECT 'Viudo (a)', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM estado_civil WHERE UPPER(nombre)=UPPER('Viudo (a)'));
INSERT INTO estado_civil (nombre, descripcion) SELECT 'Divorciado (a)', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM estado_civil WHERE UPPER(nombre)=UPPER('Divorciado (a)'));
INSERT INTO estado_civil (nombre, descripcion) SELECT 'Ignorado', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM estado_civil WHERE UPPER(nombre)=UPPER('Ignorado'));

COMMIT;
