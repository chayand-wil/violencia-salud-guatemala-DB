SET NAMES UTF8;

INSERT INTO orientacion_sexual (nombre, descripcion) SELECT 'Bisexual', 'Denuncias MP VCM' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM orientacion_sexual WHERE UPPER(nombre)=UPPER('Bisexual'));
INSERT INTO orientacion_sexual (nombre, descripcion) SELECT 'Heterosexual', 'Denuncias MP VCM' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM orientacion_sexual WHERE UPPER(nombre)=UPPER('Heterosexual'));
INSERT INTO orientacion_sexual (nombre, descripcion) SELECT 'Lesbiana', 'Denuncias MP VCM' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM orientacion_sexual WHERE UPPER(nombre)=UPPER('Lesbiana'));
INSERT INTO orientacion_sexual (nombre, descripcion) SELECT 'Sin selección', 'Denuncias MP VCM' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM orientacion_sexual WHERE UPPER(nombre)=UPPER('Sin selección'));

COMMIT;
