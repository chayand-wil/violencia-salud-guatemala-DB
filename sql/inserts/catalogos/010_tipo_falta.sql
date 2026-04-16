SET NAMES UTF8;

INSERT INTO tipo_falta (codigo, nombre, descripcion, activo) SELECT '1', 'Las personas', 'Diccionario Faltas Judiciales', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_falta WHERE codigo='1' OR UPPER(nombre)=UPPER('Las personas'));
INSERT INTO tipo_falta (codigo, nombre, descripcion, activo) SELECT '2', 'La propiedad', 'Diccionario Faltas Judiciales', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_falta WHERE codigo='2' OR UPPER(nombre)=UPPER('La propiedad'));
INSERT INTO tipo_falta (codigo, nombre, descripcion, activo) SELECT '3', 'Las buenas costumbres', 'Diccionario Faltas Judiciales', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_falta WHERE codigo='3' OR UPPER(nombre)=UPPER('Las buenas costumbres'));
INSERT INTO tipo_falta (codigo, nombre, descripcion, activo) SELECT '4', 'Orden público', 'Diccionario Faltas Judiciales', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_falta WHERE codigo='4' OR UPPER(nombre)=UPPER('Orden público'));
INSERT INTO tipo_falta (codigo, nombre, descripcion, activo) SELECT '5', 'Otras', 'Diccionario Faltas Judiciales', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_falta WHERE codigo='5' OR UPPER(nombre)=UPPER('Otras'));
INSERT INTO tipo_falta (codigo, nombre, descripcion, activo) SELECT '9', 'Ignorado', 'Diccionario Faltas Judiciales', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_falta WHERE codigo='9' OR UPPER(nombre)=UPPER('Ignorado'));

COMMIT;
