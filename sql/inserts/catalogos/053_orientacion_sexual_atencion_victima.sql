SET NAMES UTF8;

INSERT INTO orientacion_sexual (nombre, descripcion) SELECT 'ASEXUAL', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) = UPPER('ASEXUAL'));
INSERT INTO orientacion_sexual (nombre, descripcion) SELECT 'BISEXUAL', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) = UPPER('BISEXUAL'));
INSERT INTO orientacion_sexual (nombre, descripcion) SELECT 'HETEROSEXUAL', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) = UPPER('HETEROSEXUAL'));
INSERT INTO orientacion_sexual (nombre, descripcion) SELECT 'LESBIANA / HOMOSEXUAL', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) = UPPER('LESBIANA / HOMOSEXUAL'));
INSERT INTO orientacion_sexual (nombre, descripcion) SELECT 'SD', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) = UPPER('SD'));

COMMIT;