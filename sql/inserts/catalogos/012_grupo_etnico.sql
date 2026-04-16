SET NAMES UTF8;

INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'Indígena', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(nombre)=UPPER('Indígena'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'No indígena', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(nombre)=UPPER('No indígena'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'Ignorado', 'Diccionario Faltas Judiciales' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(nombre)=UPPER('Ignorado'));

COMMIT;
