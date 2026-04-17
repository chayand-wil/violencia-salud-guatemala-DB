SET NAMES UTF8;

INSERT INTO tipo_sentencia (nombre, descripcion)
SELECT 'Violencia contra la mujer', 'Fuente Sentencias MP VCM 2008-2024'
FROM RDB$DATABASE
WHERE NOT EXISTS (
  SELECT 1 FROM tipo_sentencia WHERE UPPER(TRIM(nombre)) = UPPER('Violencia contra la mujer')
);

COMMIT;
