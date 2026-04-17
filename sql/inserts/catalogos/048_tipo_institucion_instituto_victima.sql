SET NAMES UTF8;

INSERT INTO tipo_institucion (nombre, descripcion)
SELECT 'Instituto de la Victima', 'Fuente Atenciones IV 2020-2023' FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM tipo_institucion WHERE UPPER(TRIM(nombre)) = UPPER('Instituto de la Victima'));

COMMIT;