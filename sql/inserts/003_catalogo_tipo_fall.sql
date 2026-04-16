-- Carga de catalogo tipo_fall.txt
SET NAMES UTF8;

INSERT INTO tipo_fallo (nombre, descripcion)
SELECT 'Absolutoria', 'Catalogo tipo_fall.txt codigo=1' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM tipo_fallo WHERE UPPER(nombre)=UPPER('Absolutoria'));

INSERT INTO tipo_fallo (nombre, descripcion)
SELECT 'Condenatoria', 'Catalogo tipo_fall.txt codigo=3' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM tipo_fallo WHERE UPPER(nombre)=UPPER('Condenatoria'));

COMMIT;
