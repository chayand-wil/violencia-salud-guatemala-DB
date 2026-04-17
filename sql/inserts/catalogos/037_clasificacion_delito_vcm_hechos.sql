SET NAMES UTF8;

INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo)
SELECT 'VCM-HD', 'Hechos delictivos VCM 2008-2024', 'Fuente: Hechos delictivos contra mujeres de 2008 al 2024', 1
FROM RDB$DATABASE
WHERE NOT EXISTS (
  SELECT 1 FROM clasificacion_delito WHERE UPPER(TRIM(codigo)) = UPPER('VCM-HD')
);

COMMIT;
