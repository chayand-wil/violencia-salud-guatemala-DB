SET NAMES UTF8;

INSERT INTO tipo_institucion (nombre, descripcion)
SELECT 'Organismo Judicial', 'Fuente Medidas de Seguridad 2014-2024' FROM RDB$DATABASE
WHERE NOT EXISTS (
  SELECT 1 FROM tipo_institucion WHERE UPPER(TRIM(nombre)) = UPPER('Organismo Judicial')
);

COMMIT;