SET NAMES UTF8;

INSERT INTO estado_ebriedad (nombre, descripcion) SELECT 'Ebrio', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM estado_ebriedad WHERE UPPER(nombre)=UPPER('Ebrio'));
INSERT INTO estado_ebriedad (nombre, descripcion) SELECT 'No ebrio', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM estado_ebriedad WHERE UPPER(nombre)=UPPER('No ebrio'));
INSERT INTO estado_ebriedad (nombre, descripcion) SELECT 'Ignorado', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM estado_ebriedad WHERE UPPER(nombre)=UPPER('Ignorado'));
INSERT INTO estado_ebriedad (nombre, descripcion) SELECT 'Miembros del poder legislativo', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM estado_ebriedad WHERE UPPER(nombre)=UPPER('Miembros del poder legislativo'));

COMMIT;
