SET NAMES UTF8;

INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'Extranjero', 'Denuncias MP VCM' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(nombre)=UPPER('Extranjero'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'Garinagu/Garífuna', 'Denuncias MP VCM' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(nombre)=UPPER('Garinagu/Garífuna'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'Ladino', 'Denuncias MP VCM' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(nombre)=UPPER('Ladino'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'Maya', 'Denuncias MP VCM' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(nombre)=UPPER('Maya'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'Mestizo', 'Denuncias MP VCM' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(nombre)=UPPER('Mestizo'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'Ninguno', 'Denuncias MP VCM' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(nombre)=UPPER('Ninguno'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'No Responde', 'Denuncias MP VCM' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(nombre)=UPPER('No Responde'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'No Sabe', 'Denuncias MP VCM' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(nombre)=UPPER('No Sabe'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'Sin selección', 'Denuncias MP VCM' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(nombre)=UPPER('Sin selección'));
INSERT INTO grupo_etnico (nombre, descripcion) SELECT 'Xinka', 'Denuncias MP VCM' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(nombre)=UPPER('Xinka'));

COMMIT;
