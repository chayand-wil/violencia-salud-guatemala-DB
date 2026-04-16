SET NAMES UTF8;

-- Extension semantica para faltas judiciales
INSERT INTO involucramiento (nombre, descripcion)
SELECT 'Infractor', 'Extension para mapeo de faltas judiciales'
FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM involucramiento WHERE UPPER(nombre)=UPPER('Infractor'));

COMMIT;
