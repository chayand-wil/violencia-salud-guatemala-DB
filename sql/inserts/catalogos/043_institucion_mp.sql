SET NAMES UTF8;

INSERT INTO institucion_organicacion (nombre_institucion, id_tipo_institucion)
SELECT 'Ministerio Publico', ti.id_tipo_institucion
FROM tipo_institucion ti
WHERE UPPER(TRIM(ti.nombre)) = UPPER('Ministerio Publico')
  AND NOT EXISTS (
    SELECT 1 FROM institucion_organicacion io
    WHERE UPPER(TRIM(io.nombre_institucion)) = UPPER('Ministerio Publico')
  );

COMMIT;
