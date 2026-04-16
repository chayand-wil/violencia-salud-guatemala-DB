-- Carga de catalogo tipo_hechos.txt
SET NAMES UTF8;

INSERT INTO tipo_hecho (nombre, descripcion)
SELECT 'necropsias', 'Catalogo tipo_hechos.txt' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM tipo_hecho WHERE UPPER(nombre)=UPPER('necropsias'));

INSERT INTO tipo_hecho (nombre, descripcion)
SELECT 'evaluacion_inacif', 'Catalogo tipo_hechos.txt' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM tipo_hecho WHERE UPPER(nombre)=UPPER('evaluacion_inacif'));

INSERT INTO tipo_hecho (nombre, descripcion)
SELECT 'exhumanciones', 'Catalogo tipo_hechos.txt (sic)' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM tipo_hecho WHERE UPPER(nombre)=UPPER('exhumanciones'));

INSERT INTO tipo_hecho (nombre, descripcion)
SELECT 'falta_judicial', 'Catalogo tipo_hechos.txt' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM tipo_hecho WHERE UPPER(nombre)=UPPER('falta_judicial'));

INSERT INTO tipo_hecho (nombre, descripcion)
SELECT 'atencion', 'Catalogo tipo_hechos.txt' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM tipo_hecho WHERE UPPER(nombre)=UPPER('atencion'));

INSERT INTO tipo_hecho (nombre, descripcion)
SELECT 'violencia_intrafamiliar', 'Catalogo tipo_hechos.txt' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM tipo_hecho WHERE UPPER(nombre)=UPPER('violencia_intrafamiliar'));

INSERT INTO tipo_hecho (nombre, descripcion)
SELECT 'violencia_esctructural', 'Catalogo tipo_hechos.txt (sic)' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM tipo_hecho WHERE UPPER(nombre)=UPPER('violencia_esctructural'));

INSERT INTO tipo_hecho (nombre, descripcion)
SELECT 'violencia_contra_la_ninez', 'Catalogo tipo_hechos.txt' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM tipo_hecho WHERE UPPER(nombre)=UPPER('violencia_contra_la_ninez'));

INSERT INTO tipo_hecho (nombre, descripcion)
SELECT 'hecho_delictivo', 'Catalogo tipo_hechos.txt' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM tipo_hecho WHERE UPPER(nombre)=UPPER('hecho_delictivo'));

INSERT INTO tipo_hecho (nombre, descripcion)
SELECT 'detencion', 'Catalogo tipo_hechos.txt' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM tipo_hecho WHERE UPPER(nombre)=UPPER('detencion'));

INSERT INTO tipo_hecho (nombre, descripcion)
SELECT 'medida_seguridad', 'Catalogo tipo_hechos.txt' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM tipo_hecho WHERE UPPER(nombre)=UPPER('medida_seguridad'));

COMMIT;
