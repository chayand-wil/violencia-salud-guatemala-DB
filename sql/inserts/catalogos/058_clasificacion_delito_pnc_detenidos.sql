SET NAMES UTF8;

INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo) SELECT NULL, 'Contra el patrimonio', 'Fuente PNC detenidos 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE UPPER(TRIM(nombre)) = UPPER('Contra el patrimonio'));
INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo) SELECT NULL, 'Contra la libertad', 'Fuente PNC detenidos 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE UPPER(TRIM(nombre)) = UPPER('Contra la libertad'));
INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo) SELECT NULL, 'Extorsión', 'Fuente PNC detenidos 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE UPPER(TRIM(nombre)) = UPPER('Extorsión'));
INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo) SELECT NULL, 'Homicidios', 'Fuente PNC detenidos 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE UPPER(TRIM(nombre)) = UPPER('Homicidios'));
INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo) SELECT NULL, 'Lesiones', 'Fuente PNC detenidos 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE UPPER(TRIM(nombre)) = UPPER('Lesiones'));
INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo) SELECT NULL, 'Otras causas', 'Fuente PNC detenidos 2023', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE UPPER(TRIM(nombre)) = UPPER('Otras causas'));

COMMIT;