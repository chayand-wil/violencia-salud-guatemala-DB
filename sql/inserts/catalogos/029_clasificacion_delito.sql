SET NAMES UTF8;

INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo) SELECT 'PNC-GRUPO-1', 'Homicidios', 'Catalogo causas_pnc grupo de causas', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE codigo='PNC-GRUPO-1' OR UPPER(nombre)=UPPER('Homicidios'));
INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo) SELECT 'PNC-GRUPO-2', 'Lesiones', 'Catalogo causas_pnc grupo de causas', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE codigo='PNC-GRUPO-2' OR UPPER(nombre)=UPPER('Lesiones'));
INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo) SELECT 'PNC-GRUPO-3', 'Contra el Patrimonio', 'Catalogo causas_pnc grupo de causas', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE codigo='PNC-GRUPO-3' OR UPPER(nombre)=UPPER('Contra el Patrimonio'));
INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo) SELECT 'PNC-GRUPO-5', 'Contra la Libertad', 'Catalogo causas_pnc grupo de causas', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE codigo='PNC-GRUPO-5' OR UPPER(nombre)=UPPER('Contra la Libertad'));
INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo) SELECT 'PNC-GRUPO-6', 'Extorsión y chantaje', 'Catalogo causas_pnc grupo de causas', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE codigo='PNC-GRUPO-6' OR UPPER(nombre)=UPPER('Extorsión y chantaje'));
INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo) SELECT 'PNC-GRUPO-7', 'Otras causas', 'Catalogo causas_pnc grupo de causas', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE codigo='PNC-GRUPO-7' OR UPPER(nombre)=UPPER('Otras causas'));

COMMIT;
