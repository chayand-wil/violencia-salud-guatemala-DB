SET NAMES UTF8;

INSERT INTO involucramiento (nombre, descripcion)
SELECT 'Agraviado', 'Rol para fuente PNC victimas 2023' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(TRIM(nombre)) = UPPER('Agraviado'));

COMMIT;