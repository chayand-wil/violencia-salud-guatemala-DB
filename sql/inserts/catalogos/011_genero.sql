SET NAMES UTF8;

INSERT INTO genero (nombre, descripcion) SELECT 'Hombre', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM genero WHERE UPPER(nombre)=UPPER('Hombre'));
INSERT INTO genero (nombre, descripcion) SELECT 'Mujer', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM genero WHERE UPPER(nombre)=UPPER('Mujer'));
INSERT INTO genero (nombre, descripcion) SELECT 'Ignorado', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM genero WHERE UPPER(nombre)=UPPER('Ignorado'));

COMMIT;
