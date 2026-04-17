SET NAMES UTF8;

INSERT INTO delito_cometido (id_tipo_delito, id_clasificacion_delito)
SELECT d.id_delito, c.id_clasificacion_delito
FROM delito d JOIN clasificacion_delito c ON 1=1
WHERE d.codigo = 'EXH-DEL-001'
  AND UPPER(TRIM(c.nombre)) = UPPER('Exhumacion')
  AND NOT EXISTS (
    SELECT 1 FROM delito_cometido dc
    WHERE dc.id_tipo_delito = d.id_delito AND dc.id_clasificacion_delito = c.id_clasificacion_delito
  );

COMMIT;