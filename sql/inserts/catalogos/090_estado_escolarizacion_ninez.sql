SET NAMES UTF8;

INSERT INTO estado_escolarizacion (nombre, descripcion, es_escolarizado) SELECT 'Escolarizada', 'Fuente Quejas Mineduc', 1 FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM estado_escolarizacion WHERE UPPER(TRIM(nombre)) = UPPER('Escolarizada'));
INSERT INTO tipo_hecho (nombre, descripcion) SELECT 'violencia_contra_la_ninez', 'Fuente Quejas Mineduc' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_contra_la_ninez'));

COMMIT;