SET NAMES UTF8;

INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Étnica o racial', 'Por origen o etnia' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(nombre)=UPPER('Étnica o racial'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Lingüística', 'Por idioma' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(nombre)=UPPER('Lingüística'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'De género', 'Por sexo o género' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(nombre)=UPPER('De género'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Orientación sexual', 'Por preferencia sexual' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(nombre)=UPPER('Orientación sexual'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Socioeconómica', 'Por nivel económico' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(nombre)=UPPER('Socioeconómica'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Discapacidad', 'Por condición física o mental' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(nombre)=UPPER('Discapacidad'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Edad', 'Por edad' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(nombre)=UPPER('Edad'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Religiosa', 'Por creencias' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(nombre)=UPPER('Religiosa'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Territorial', 'Por lugar de origen' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(nombre)=UPPER('Territorial'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Educativa', 'Por nivel académico' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(nombre)=UPPER('Educativa'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Cultural', 'Por tradiciones' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(nombre)=UPPER('Cultural'));
INSERT INTO tipo_discriminacion (nombre, descripcion) SELECT 'Institucional', 'Desde instituciones' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(nombre)=UPPER('Institucional'));

COMMIT;
