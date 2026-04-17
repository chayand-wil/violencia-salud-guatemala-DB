SET NAMES UTF8;

INSERT INTO involucramiento (nombre, descripcion)
SELECT 'Sindicado', 'Rol para fuente Sindicados 2023' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Sindicado'));

COMMIT;