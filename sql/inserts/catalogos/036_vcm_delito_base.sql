SET NAMES UTF8;

INSERT INTO clasificacion_delito (codigo, nombre, descripcion, activo)
SELECT 'VCM', 'Violencia contra la mujer', 'Clasificacion base VCM', 1
FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM clasificacion_delito WHERE UPPER(nombre)=UPPER('Violencia contra la mujer'));

INSERT INTO delito (codigo, nombre, bien_juridico, activo)
SELECT 'VCM-BASE', 'Violencia contra la mujer', 'VCM', 1
FROM RDB$DATABASE
WHERE NOT EXISTS (SELECT 1 FROM delito WHERE UPPER(nombre)=UPPER('Violencia contra la mujer'));

INSERT INTO delito_cometido (id_tipo_delito, id_clasificacion_delito)
SELECT d.id_delito, c.id_clasificacion_delito
FROM delito d
JOIN clasificacion_delito c ON UPPER(c.nombre)=UPPER('Violencia contra la mujer')
WHERE UPPER(d.nombre)=UPPER('Violencia contra la mujer')
  AND NOT EXISTS (
    SELECT 1 FROM delito_cometido dc
    WHERE dc.id_tipo_delito = d.id_delito
      AND dc.id_clasificacion_delito = c.id_clasificacion_delito
  );

COMMIT;
