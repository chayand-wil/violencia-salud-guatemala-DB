SET NAMES UTF8;

/*
  Ajustes incrementales para soportar consultas analiticas no directas.
  No elimina objetos existentes.
*/

SET TERM ^ ;

EXECUTE BLOCK AS
BEGIN
  IF (NOT EXISTS(
      SELECT 1
      FROM RDB$RELATION_FIELDS
      WHERE TRIM(RDB$RELATION_NAME) = 'VIOLENCIA_ESTRUCTURAL'
        AND TRIM(RDB$FIELD_NAME) = 'ES_PROCESADA'
  )) THEN
    EXECUTE STATEMENT 'ALTER TABLE violencia_estructural ADD es_procesada SMALLINT DEFAULT 0';
END^

EXECUTE BLOCK AS
BEGIN
  IF (NOT EXISTS(
      SELECT 1
      FROM RDB$RELATION_FIELDS
      WHERE TRIM(RDB$RELATION_NAME) = 'VIOLENCIA_ESTRUCTURAL'
        AND TRIM(RDB$FIELD_NAME) = 'ID_ESTADO_DENUNCIA'
  )) THEN
    EXECUTE STATEMENT 'ALTER TABLE violencia_estructural ADD id_estado_denuncia INTEGER';
END^

EXECUTE BLOCK AS
BEGIN
  IF (NOT EXISTS(
      SELECT 1
      FROM RDB$RELATION_CONSTRAINTS rc
      WHERE TRIM(rc.RDB$RELATION_NAME) = 'VIOLENCIA_ESTRUCTURAL'
        AND TRIM(rc.RDB$CONSTRAINT_NAME) = 'FK_VESTR_ESTADO_DENUNCIA'
  )) THEN
    EXECUTE STATEMENT 'ALTER TABLE violencia_estructural ADD CONSTRAINT fk_vestr_estado_denuncia FOREIGN KEY (id_estado_denuncia) REFERENCES estado_denuncia (id_estado_denuncia)';
END^

EXECUTE BLOCK AS
BEGIN
  IF (NOT EXISTS(
      SELECT 1
      FROM RDB$RELATION_FIELDS
      WHERE TRIM(RDB$RELATION_NAME) = 'REGISTRO_SALUD'
        AND TRIM(RDB$FIELD_NAME) = 'INDICADOR_SALUD'
  )) THEN
    EXECUTE STATEMENT 'ALTER TABLE registro_salud ADD indicador_salud VARCHAR(80)';
END^

SET TERM ; ^

SET TERM ^ ;

EXECUTE BLOCK AS
BEGIN
  IF (NOT EXISTS(
      SELECT 1 FROM RDB$INDICES WHERE TRIM(RDB$INDEX_NAME) = 'IDX_VESTR_PROCESADA'
  )) THEN
    EXECUTE STATEMENT 'CREATE INDEX idx_vestr_procesada ON violencia_estructural (es_procesada)';
END^

EXECUTE BLOCK AS
BEGIN
  IF (NOT EXISTS(
      SELECT 1 FROM RDB$INDICES WHERE TRIM(RDB$INDEX_NAME) = 'IDX_REGSALUD_INDICADOR_ANIO'
  )) THEN
    EXECUTE STATEMENT 'CREATE INDEX idx_regsalud_indicador_anio ON registro_salud (indicador_salud, anio_registro)';
END^

SET TERM ; ^

CREATE OR ALTER VIEW vw_violencia_estructural_proceso AS
SELECT
  ve.id_violencia_estructural,
  EXTRACT(YEAR FROM h.fecha_hecho) AS anio,
  d.nombre AS departamento,
  m.nombre AS municipio,
  COALESCE(ve.es_procesada, COALESCE(ed.es_procesada, 0)) AS es_procesada,
  td.nombre AS tipo_discriminacion
FROM violencia_estructural ve
JOIN hecho h ON h.id_hecho = ve.id_hecho
JOIN ubicacion u ON u.id_ubicacion = h.id_ubicacion
JOIN municipio m ON m.id_municipio = u.id_municipio
JOIN departamento d ON d.id_departamento = m.id_departamento
LEFT JOIN estado_denuncia ed ON ed.id_estado_denuncia = ve.id_estado_denuncia
JOIN tipo_discriminacion td ON td.id_tipo_discriminacion = ve.id_tipo_discriminacion;

CREATE OR ALTER VIEW vw_registro_salud_territorial AS
SELECT
  rs.id_registro_salud,
  rs.anio_registro,
  d.nombre AS departamento,
  m.nombre AS municipio,
  COALESCE(rs.indicador_salud, cs.nombre) AS indicador_salud,
  cs.codigo_cie10,
  ges.nombre AS grupo_etario,
  g.nombre AS genero,
  rs.casos
FROM registro_salud rs
JOIN ubicacion u ON u.id_ubicacion = rs.id_ubicacion
JOIN municipio m ON m.id_municipio = u.id_municipio
JOIN departamento d ON d.id_departamento = m.id_departamento
LEFT JOIN condicion_salud cs ON cs.id_condicion_salud = rs.id_condicion_salud
LEFT JOIN grupo_etario_salud ges ON ges.id_grupo_etario_salud = rs.id_grupo_etario_salud
LEFT JOIN genero g ON g.id_genero = rs.id_genero;

COMMIT;
