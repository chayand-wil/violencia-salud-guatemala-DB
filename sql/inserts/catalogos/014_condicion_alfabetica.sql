SET NAMES UTF8;

INSERT INTO condicion_alfabetica (nombre, descripcion) SELECT 'Alfabeta', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM condicion_alfabetica WHERE UPPER(nombre)=UPPER('Alfabeta'));
INSERT INTO condicion_alfabetica (nombre, descripcion) SELECT 'Analfabeta', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM condicion_alfabetica WHERE UPPER(nombre)=UPPER('Analfabeta'));
INSERT INTO condicion_alfabetica (nombre, descripcion) SELECT 'Ignorado', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM condicion_alfabetica WHERE UPPER(nombre)=UPPER('Ignorado'));

COMMIT;
