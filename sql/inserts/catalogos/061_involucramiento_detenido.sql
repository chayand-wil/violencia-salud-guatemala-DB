SET NAMES UTF8;

INSERT INTO involucramiento (nombre, descripcion)
SELECT 'Detenido', 'Rol para fuente PNC detenidos 2023' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Detenido'));

COMMIT;