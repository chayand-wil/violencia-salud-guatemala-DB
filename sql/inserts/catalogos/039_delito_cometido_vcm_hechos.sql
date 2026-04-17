SET NAMES UTF8;

INSERT INTO delito_cometido (id_tipo_delito, id_clasificacion_delito)
SELECT d.id_delito, c.id_clasificacion_delito
FROM delito d
JOIN clasificacion_delito c ON UPPER(TRIM(c.codigo)) = UPPER('VCM-HD')
WHERE d.codigo='VCM-HD-DEL-001'
  AND NOT EXISTS (
    SELECT 1 FROM delito_cometido dc
    WHERE dc.id_tipo_delito = d.id_delito
      AND dc.id_clasificacion_delito = c.id_clasificacion_delito
  );

INSERT INTO delito_cometido (id_tipo_delito, id_clasificacion_delito)
SELECT d.id_delito, c.id_clasificacion_delito
FROM delito d
JOIN clasificacion_delito c ON UPPER(TRIM(c.codigo)) = UPPER('VCM-HD')
WHERE d.codigo='VCM-HD-DEL-002'
  AND NOT EXISTS (
    SELECT 1 FROM delito_cometido dc
    WHERE dc.id_tipo_delito = d.id_delito
      AND dc.id_clasificacion_delito = c.id_clasificacion_delito
  );

INSERT INTO delito_cometido (id_tipo_delito, id_clasificacion_delito)
SELECT d.id_delito, c.id_clasificacion_delito
FROM delito d
JOIN clasificacion_delito c ON UPPER(TRIM(c.codigo)) = UPPER('VCM-HD')
WHERE d.codigo='VCM-HD-DEL-003'
  AND NOT EXISTS (
    SELECT 1 FROM delito_cometido dc
    WHERE dc.id_tipo_delito = d.id_delito
      AND dc.id_clasificacion_delito = c.id_clasificacion_delito
  );

INSERT INTO delito_cometido (id_tipo_delito, id_clasificacion_delito)
SELECT d.id_delito, c.id_clasificacion_delito
FROM delito d
JOIN clasificacion_delito c ON UPPER(TRIM(c.codigo)) = UPPER('VCM-HD')
WHERE d.codigo='VCM-HD-DEL-004'
  AND NOT EXISTS (
    SELECT 1 FROM delito_cometido dc
    WHERE dc.id_tipo_delito = d.id_delito
      AND dc.id_clasificacion_delito = c.id_clasificacion_delito
  );

INSERT INTO delito_cometido (id_tipo_delito, id_clasificacion_delito)
SELECT d.id_delito, c.id_clasificacion_delito
FROM delito d
JOIN clasificacion_delito c ON UPPER(TRIM(c.codigo)) = UPPER('VCM-HD')
WHERE d.codigo='VCM-HD-DEL-005'
  AND NOT EXISTS (
    SELECT 1 FROM delito_cometido dc
    WHERE dc.id_tipo_delito = d.id_delito
      AND dc.id_clasificacion_delito = c.id_clasificacion_delito
  );

INSERT INTO delito_cometido (id_tipo_delito, id_clasificacion_delito)
SELECT d.id_delito, c.id_clasificacion_delito
FROM delito d
JOIN clasificacion_delito c ON UPPER(TRIM(c.codigo)) = UPPER('VCM-HD')
WHERE d.codigo='VCM-HD-DEL-006'
  AND NOT EXISTS (
    SELECT 1 FROM delito_cometido dc
    WHERE dc.id_tipo_delito = d.id_delito
      AND dc.id_clasificacion_delito = c.id_clasificacion_delito
  );

COMMIT;
