SET NAMES UTF8;

INSERT INTO tipo_institucion (nombre, descripcion)
SELECT 'Ministerio Publico', 'Fuente Sentencias MP VCM 2008-2024'
FROM RDB$DATABASE
WHERE NOT EXISTS (
  SELECT 1 FROM tipo_institucion WHERE UPPER(TRIM(nombre)) = UPPER('Ministerio Publico')
);

COMMIT;
