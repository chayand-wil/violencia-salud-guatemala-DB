SET NAMES UTF8;

INSERT INTO area_geografica (nombre, descripcion) SELECT 'Urbano', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM area_geografica WHERE UPPER(nombre)=UPPER('Urbano'));
INSERT INTO area_geografica (nombre, descripcion) SELECT 'Rural', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM area_geografica WHERE UPPER(nombre)=UPPER('Rural'));
INSERT INTO area_geografica (nombre, descripcion) SELECT 'Ignorado', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM area_geografica WHERE UPPER(nombre)=UPPER('Ignorado'));

COMMIT;
