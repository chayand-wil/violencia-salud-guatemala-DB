SET NAMES UTF8;

INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'Ch''orti''', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('Ch''orti'''));
INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'Garífuna', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('Garífuna'));
INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'Ixil', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('Ixil'));
INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'Jakalteka', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('Jakalteka'));
INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'K''iche''', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('K''iche'''));
INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'K''iché', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('K''iché'));
INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'Kaqchikel', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('Kaqchikel'));
INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'Ki''che''', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('Ki''che'''));
INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'K´iche', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('K´iche'));
INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'Mam', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('Mam'));
INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'Poqomch''', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('Poqomch'''));
INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'Q''anjob''al', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('Q''anjob''al'));
INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'Q''eqchi''', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('Q''eqchi'''));
INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'Q''qechi''', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('Q''qechi'''));
INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'Tz''utujil', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('Tz''utujil'));
INSERT INTO idioma_lengua (nombre, familia_linguistica) SELECT 'Xinka', NULL FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER('Xinka'));

COMMIT;