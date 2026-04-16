SET NAMES UTF8;

INSERT INTO continente (nombre, descripcion) SELECT 'America', 'Carga base Guatemala' FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM continente WHERE UPPER(nombre)=UPPER('America'));

COMMIT;
