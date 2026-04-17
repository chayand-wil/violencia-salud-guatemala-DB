SET NAMES UTF8;

/*
  Consultas analiticas propuestas (30) sobre el esquema Firebird actual.
  Notas:
  - Las consultas marcadas como PARCIAL dependen de cobertura de datos en carga.
  - Las consultas marcadas como BLOQUEADA requieren tablas/campos no presentes.
*/

/* 1) LISTA: Cantidad de homicidios por anio y departamento */
SELECT
    EXTRACT(YEAR FROM h.fecha_hecho) AS anio,
    d.nombre AS departamento,
    COUNT(*) AS total_homicidios
FROM hecho_delictivo hd
JOIN hecho h ON h.id_hecho = hd.id_hecho
JOIN ubicacion u ON u.id_ubicacion = h.id_ubicacion
JOIN municipio m ON m.id_municipio = u.id_municipio
JOIN departamento d ON d.id_departamento = m.id_departamento
JOIN delito_cometido dc ON dc.id_delito_cometido = hd.id_delito
JOIN delito de ON de.id_delito = dc.id_tipo_delito
WHERE de.nombre CONTAINING 'HOMICIDIO'
GROUP BY 1, 2
ORDER BY 1, 2;

/* 2) LISTA/PARCIAL: Denuncias por violencia contra la mujer por municipio */
SELECT
    d.nombre AS departamento,
    m.nombre AS municipio,
    COUNT(*) AS total_denuncias
FROM denuncia dn
JOIN hecho h ON h.id_hecho = dn.id_hecho
JOIN tipo_hecho th ON th.id_tipo_hecho = h.id_tipo_hecho
JOIN ubicacion u ON u.id_ubicacion = h.id_ubicacion
JOIN municipio m ON m.id_municipio = u.id_municipio
JOIN departamento d ON d.id_departamento = m.id_departamento
WHERE th.nombre CONTAINING 'MUJER'
   OR th.nombre CONTAINING 'VIOLENCIA CONTRA LA MUJER'
   OR th.nombre CONTAINING 'VCM'
GROUP BY 1, 2
ORDER BY total_denuncias DESC;

/* 3) LISTA: Top 5 tipos de hechos delictivos en ultimos 5 anios */
SELECT FIRST 5
    cd.nombre AS clasificacion_delito,
    COUNT(*) AS total_casos
FROM hecho_delictivo hd
JOIN hecho h ON h.id_hecho = hd.id_hecho
JOIN delito_cometido dc ON dc.id_delito_cometido = hd.id_delito
JOIN clasificacion_delito cd ON cd.id_clasificacion_delito = dc.id_clasificacion_delito
WHERE h.fecha_hecho >= DATEADD(-5 YEAR TO CURRENT_DATE)
GROUP BY 1
ORDER BY total_casos DESC;

/* 4) LISTA: Sentencias dictadas por tipo de delito y anio */
SELECT
    EXTRACT(YEAR FROM s.fecha_sentencia) AS anio,
    de.nombre AS delito,
    COUNT(*) AS total_sentencias
FROM sentencia s
LEFT JOIN delito de ON de.id_delito = s.id_delito
GROUP BY 1, 2
ORDER BY 1, total_sentencias DESC;

/* 5) PARCIAL: Promedio de edad de victimas de violencia intrafamiliar */
SELECT
    AVG(CAST(DATEDIFF(YEAR FROM p.fecha_nacimiento TO h.fecha_hecho) AS DECIMAL(10,2))) AS promedio_edad_victima
FROM caso_violencia_intrafamiliar cvi
JOIN hecho h ON h.id_hecho = cvi.id_hecho
JOIN persona p ON p.id_persona = cvi.id_victima
WHERE p.fecha_nacimiento IS NOT NULL
  AND h.fecha_hecho IS NOT NULL;

/* 6) PARCIAL: Distribucion de embarazos adolescentes por region */
SELECT
    d.nombre AS departamento,
    m.nombre AS municipio,
    COUNT(*) AS total_embarazos_adolescentes
FROM embarazo_adolescente ea
JOIN hecho h ON h.id_hecho = ea.id_hecho
JOIN ubicacion u ON u.id_ubicacion = h.id_ubicacion
JOIN municipio m ON m.id_municipio = u.id_municipio
JOIN departamento d ON d.id_departamento = m.id_departamento
WHERE ea.edad_gestante < 19
GROUP BY 1, 2
ORDER BY total_embarazos_adolescentes DESC;

/* 7) PARCIAL: Casos de violencia infantil relacionados con trabajo infantil */
SELECT
    EXTRACT(YEAR FROM h.fecha_hecho) AS anio,
    d.nombre AS departamento,
    COUNT(*) AS total_casos
FROM caso_violencia_ninez cvn
JOIN hecho h ON h.id_hecho = cvn.id_hecho
JOIN ubicacion u ON u.id_ubicacion = h.id_ubicacion
JOIN municipio m ON m.id_municipio = u.id_municipio
JOIN departamento d ON d.id_departamento = m.id_departamento
LEFT JOIN caso_ninez_trabajo_infantil cnti
       ON cnti.id_caso_violencia_ninez = cvn.id_caso_violencia_ninez
WHERE COALESCE(cvn.relacionado_trabajo_infantil, 0) = 1
   OR cnti.id_caso_ninez_trabajo_infantil IS NOT NULL
GROUP BY 1, 2
ORDER BY 1, total_casos DESC;

/* 8) LISTA: Porcentaje de denuncias por discriminacion segun etnia */
SELECT
    ge.nombre AS grupo_etnico,
    COUNT(*) AS total_casos,
    ROUND(100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM violencia_estructural), 0), 2) AS porcentaje
FROM violencia_estructural ve
JOIN persona p ON p.id_persona = ve.id_victima
LEFT JOIN grupo_etnico ge ON ge.id_grupo_etnico = p.id_grupo_etnico
GROUP BY 1
ORDER BY total_casos DESC;

/* 9) LISTA/PARCIAL: Comparativa escolaridad vs tipo de falta judicial */
SELECT
    ne.nombre AS nivel_escolaridad,
    tf.nombre AS tipo_falta,
    COUNT(*) AS total_casos
FROM falta f
JOIN hecho h ON h.id_hecho = f.id_hecho
JOIN tipo_falta tf ON tf.id_tipo_falta = f.id_tipo_falta
JOIN involucrado_hecho ih ON ih.id_hecho = h.id_hecho
JOIN persona p ON p.id_persona = ih.id_involucrado
LEFT JOIN nivel_escolaridad ne ON ne.id_nivel_escolaridad = p.id_nivel_escolaridad
GROUP BY 1, 2
ORDER BY total_casos DESC;

/* 10) LISTA: Numero de necropsias por anio */
SELECT
    EXTRACT(YEAR FROM h.fecha_hecho) AS anio,
    COUNT(*) AS total_necropsias
FROM necropsia n
JOIN hecho h ON h.id_hecho = n.id_hecho
GROUP BY 1
ORDER BY 1;

/* 11) LISTA: Tasa de violencia estructural procesadas vs no procesadas */
SELECT
    CASE COALESCE(vp.es_procesada, 0)
        WHEN 1 THEN 'PROCESADA'
        ELSE 'NO_PROCESADA'
    END AS estado_proceso,
    COUNT(*) AS total,
    ROUND(100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM vw_violencia_estructural_proceso), 0), 2) AS porcentaje
FROM vw_violencia_estructural_proceso vp
GROUP BY 1
ORDER BY total DESC;

/* 12) PARCIAL: Relacion tipo de empleo y ocurrencia de hechos delictivos */
SELECT
    o.nombre_ocupacion AS ocupacion,
    COUNT(DISTINCT ih.id_hecho) AS total_hechos
FROM involucrado_hecho ih
JOIN persona_ocupacion po ON po.id_persona = ih.id_involucrado
JOIN ocupacion o ON o.id_ocupacion = po.id_ocupacion
GROUP BY 1
ORDER BY total_hechos DESC;

/* 13) LISTA/PARCIAL: Casos VCM con sentencia firme */
SELECT
    EXTRACT(YEAR FROM s.fecha_sentencia) AS anio,
    COUNT(*) AS total_casos
FROM sentencia s
LEFT JOIN tipo_fallo tf ON tf.id_tipo_fallo = s.id_tipo_fallo
LEFT JOIN tipo_sentencia ts ON ts.id_tipo_sentencia = s.id_tipo_sentencia
WHERE (tf.nombre CONTAINING 'CONDEN' OR tf.nombre CONTAINING 'FIRME')
  AND (ts.nombre CONTAINING 'MUJER' OR ts.nombre CONTAINING 'VCM')
GROUP BY 1
ORDER BY 1;

/* 14) PARCIAL: Idiomas hablados por victimas de discriminacion */
SELECT
    il.nombre AS idioma,
    COUNT(*) AS total_victimas
FROM violencia_estructural ve
JOIN idioma_persona ip ON ip.id_persona = ve.id_victima
JOIN idioma_lengua il ON il.id_lengua = ip.id_lengua
GROUP BY 1
ORDER BY total_victimas DESC;

/* 15) PARCIAL: Numero de personas por hogar en casos VIF */
SELECT
    AVG(CAST(t.total_personas_hogar AS DECIMAL(10,2))) AS promedio_personas_por_hogar
FROM (
    SELECT
        cvh.id_caso_violencia_intrafamiliar,
        cvh.id_hogar,
        COUNT(DISTINCT ph.id_persona) AS total_personas_hogar
    FROM caso_vif_hogar cvh
    LEFT JOIN persona_hogar ph ON ph.id_hogar = cvh.id_hogar
    GROUP BY cvh.id_caso_violencia_intrafamiliar, cvh.id_hogar
) t;

/* 16) PARCIAL: Tasa de violencia infantil escolarizada vs no escolarizada */
SELECT
    CASE COALESCE(ee.es_escolarizado, 0)
        WHEN 1 THEN 'ESCOLARIZADA'
        ELSE 'NO_ESCOLARIZADA'
    END AS condicion_escolar,
    COUNT(*) AS total_casos,
    ROUND(100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM caso_violencia_ninez), 0), 2) AS porcentaje
FROM caso_violencia_ninez cvn
LEFT JOIN estado_escolarizacion ee ON ee.id_estado_escolarizacion = cvn.id_estado_escolarizacion
GROUP BY 1
ORDER BY total_casos DESC;

/* 17) PARCIAL: Casos de trabajo infantil por sector economico */
SELECT
    se.nombre AS sector_economico,
    COUNT(*) AS total_casos
FROM caso_ninez_trabajo_infantil cnti
LEFT JOIN sector_economico se ON se.id_sector_economico = cnti.id_sector_economico
GROUP BY 1
ORDER BY total_casos DESC;

/* 18) PARCIAL: Relacion edad y tipo de violencia sufrida */
WITH edades AS (
    SELECT
        'VIF' AS tipo_violencia,
        tai.nombre AS subtipo_violencia,
        DATEDIFF(YEAR FROM p.fecha_nacimiento TO h.fecha_hecho) AS edad
    FROM caso_violencia_intrafamiliar cvi
    JOIN hecho h ON h.id_hecho = cvi.id_hecho
    JOIN persona p ON p.id_persona = cvi.id_victima
    LEFT JOIN tipo_agresion_intrafamiliar tai ON tai.id_tipo_agresion_intrafamiliar = cvi.id_tipo_agresion_intrafamiliar
    WHERE p.fecha_nacimiento IS NOT NULL AND h.fecha_hecho IS NOT NULL

    UNION ALL

    SELECT
        'NINEZ' AS tipo_violencia,
        tan.nombre AS subtipo_violencia,
        DATEDIFF(YEAR FROM p.fecha_nacimiento TO h.fecha_hecho) AS edad
    FROM caso_violencia_ninez cvn
    JOIN hecho h ON h.id_hecho = cvn.id_hecho
    JOIN persona p ON p.id_persona = cvn.id_victima
    LEFT JOIN tipo_agresion_ninez tan ON tan.id_tipo_agresion_ninez = cvn.id_tipo_agresion_ninez
    WHERE p.fecha_nacimiento IS NOT NULL AND h.fecha_hecho IS NOT NULL

    UNION ALL

    SELECT
        'ESTRUCTURAL' AS tipo_violencia,
        td.nombre AS subtipo_violencia,
        DATEDIFF(YEAR FROM p.fecha_nacimiento TO h.fecha_hecho) AS edad
    FROM violencia_estructural ve
    JOIN hecho h ON h.id_hecho = ve.id_hecho
    JOIN persona p ON p.id_persona = ve.id_victima
    LEFT JOIN tipo_discriminacion td ON td.id_tipo_discriminacion = ve.id_tipo_discriminacion
    WHERE p.fecha_nacimiento IS NOT NULL AND h.fecha_hecho IS NOT NULL
)
SELECT
    tipo_violencia,
    subtipo_violencia,
    AVG(CAST(edad AS DECIMAL(10,2))) AS edad_promedio,
    MIN(edad) AS edad_minima,
    MAX(edad) AS edad_maxima,
    COUNT(*) AS total_registros
FROM edades
GROUP BY 1, 2
ORDER BY tipo_violencia, total_registros DESC;

/* 19) PARCIAL: Desnutricion aguda por departamento, municipio y anio */
SELECT
    vt.anio_registro AS anio,
    vt.departamento,
    vt.municipio,
    SUM(vt.casos) AS total_casos
FROM vw_registro_salud_territorial vt
WHERE vt.indicador_salud CONTAINING 'DESNUTRICION AGUDA'
GROUP BY 1, 2, 3
ORDER BY 1, total_casos DESC;

/* 20) PARCIAL: Retardo en desarrollo por grupo etario, sexo y region */
SELECT
    vt.anio_registro AS anio,
    vt.departamento,
    vt.grupo_etario,
    vt.genero,
    SUM(vt.casos) AS total_casos
FROM vw_registro_salud_territorial vt
WHERE vt.indicador_salud CONTAINING 'RETARDO'
GROUP BY 1, 2, 3, 4
ORDER BY 1, total_casos DESC;

/* 21) PARCIAL: Incidencia cronicas por CIE-10 */
SELECT
    rs.anio_registro AS anio,
    cs.codigo_cie10,
    cs.nombre AS condicion,
    SUM(rs.casos) AS total_casos,
    SUM(dp.total_poblacion) AS total_poblacion,
    ROUND(100000.0 * SUM(rs.casos) / NULLIF(SUM(dp.total_poblacion), 0), 2) AS tasa_100k
FROM registro_salud rs
JOIN condicion_salud cs ON cs.id_condicion_salud = rs.id_condicion_salud
LEFT JOIN denominador_poblacional dp
       ON dp.id_ubicacion = rs.id_ubicacion
      AND dp.anio_referencia = rs.anio_registro
      AND (dp.id_grupo_etario_salud = rs.id_grupo_etario_salud OR dp.id_grupo_etario_salud IS NULL)
      AND (dp.id_genero = rs.id_genero OR dp.id_genero IS NULL)
WHERE rs.indicador_salud CONTAINING 'CRONICA'
   OR cs.nombre CONTAINING 'CRONICA'
GROUP BY 1, 2, 3
ORDER BY 1, total_casos DESC;

/* 22) PARCIAL: Evolucion dengue y dengue grave 2012-2024 */
SELECT
    vt.anio_registro AS anio,
    vt.indicador_salud,
    SUM(vt.casos) AS total_casos
FROM vw_registro_salud_territorial vt
WHERE vt.indicador_salud CONTAINING 'DENGUE'
GROUP BY 1, 2
ORDER BY 1, 2;

/* 23) PARCIAL: Malaria por grupo etario y sexo municipal */
SELECT
    vt.anio_registro AS anio,
    vt.departamento,
    vt.municipio,
    vt.grupo_etario,
    vt.genero,
    SUM(vt.casos) AS total_casos
FROM vw_registro_salud_territorial vt
WHERE vt.indicador_salud CONTAINING 'MALARIA'
GROUP BY 1, 2, 3, 4, 5
ORDER BY 1, total_casos DESC;

/* 24) PARCIAL: Desnutricion infantil vs violencia intrafamiliar por departamento */
WITH desnutricion AS (
    SELECT
        vt.anio_registro AS anio,
        vt.departamento,
        SUM(vt.casos) AS casos_desnutricion
    FROM vw_registro_salud_territorial vt
    WHERE vt.indicador_salud CONTAINING 'DESNUTRICION'
    GROUP BY 1, 2
),
vif AS (
    SELECT
        EXTRACT(YEAR FROM h.fecha_hecho) AS anio,
        d.nombre AS departamento,
        COUNT(*) AS casos_vif
    FROM caso_violencia_intrafamiliar cvi
    JOIN hecho h ON h.id_hecho = cvi.id_hecho
    JOIN ubicacion u ON u.id_ubicacion = h.id_ubicacion
    JOIN municipio m ON m.id_municipio = u.id_municipio
    JOIN departamento d ON d.id_departamento = m.id_departamento
    GROUP BY 1, 2
)
SELECT
    COALESCE(d.anio, v.anio) AS anio,
    COALESCE(d.departamento, v.departamento) AS departamento,
    COALESCE(d.casos_desnutricion, 0) AS casos_desnutricion,
    COALESCE(v.casos_vif, 0) AS casos_vif
FROM desnutricion d
FULL JOIN vif v
  ON v.anio = d.anio
 AND v.departamento = d.departamento
ORDER BY 1, 2;

/* 25) PARCIAL: Top 5 municipios Chagas+Zika+Chikungunya combinados */
SELECT FIRST 5
    vt.departamento,
    vt.municipio,
    SUM(vt.casos) AS total_casos
FROM vw_registro_salud_territorial vt
WHERE vt.indicador_salud CONTAINING 'CHAGAS'
   OR vt.indicador_salud CONTAINING 'ZIKA'
   OR vt.indicador_salud CONTAINING 'CHIKUNGUNYA'
GROUP BY 1, 2
ORDER BY total_casos DESC;

/* 26) PARCIAL: Vectores vs urbanizacion por departamento */
SELECT
    vt.anio_registro AS anio,
    d.nombre AS departamento,
    ag.nombre AS area_geografica,
    SUM(rs.casos) AS total_casos
FROM registro_salud rs
JOIN ubicacion u ON u.id_ubicacion = rs.id_ubicacion
JOIN municipio m ON m.id_municipio = u.id_municipio
JOIN departamento d ON d.id_departamento = m.id_departamento
LEFT JOIN area_geografica ag ON ag.id_area_geografica = u.id_area_geografica
LEFT JOIN vw_registro_salud_territorial vt ON vt.id_registro_salud = rs.id_registro_salud
WHERE COALESCE(vt.indicador_salud, rs.indicador_salud) CONTAINING 'DENGUE'
   OR COALESCE(vt.indicador_salud, rs.indicador_salud) CONTAINING 'MALARIA'
   OR COALESCE(vt.indicador_salud, rs.indicador_salud) CONTAINING 'CHAGAS'
   OR COALESCE(vt.indicador_salud, rs.indicador_salud) CONTAINING 'CHIKUNGUNYA'
   OR COALESCE(vt.indicador_salud, rs.indicador_salud) CONTAINING 'ZIKA'
GROUP BY 1, 2, 3
ORDER BY 1, total_casos DESC;

/* 27) PARCIAL: Tasa de morbilidad materna infantil por anio/departamento */
SELECT
    rs.anio_registro AS anio,
    d.nombre AS departamento,
    SUM(rs.casos) AS total_casos,
    SUM(dp.total_poblacion) AS total_poblacion,
    ROUND(100000.0 * SUM(rs.casos) / NULLIF(SUM(dp.total_poblacion), 0), 2) AS tasa_100k
FROM registro_salud rs
JOIN ubicacion u ON u.id_ubicacion = rs.id_ubicacion
JOIN municipio m ON m.id_municipio = u.id_municipio
JOIN departamento d ON d.id_departamento = m.id_departamento
LEFT JOIN denominador_poblacional dp
       ON dp.id_ubicacion = rs.id_ubicacion
      AND dp.anio_referencia = rs.anio_registro
WHERE rs.indicador_salud CONTAINING 'MATERNA'
   OR rs.indicador_salud CONTAINING 'MATERNO'
   OR rs.indicador_salud CONTAINING 'NEONATAL'
   OR rs.indicador_salud CONTAINING 'INFANTIL'
GROUP BY 1, 2
ORDER BY 1, total_casos DESC;

/* 28) PARCIAL: Correlacion desnutricion y hechos delictivos por municipio
   Esta salida deja la serie lista para calcular correlacion fuera de SQL.
*/
WITH salud AS (
    SELECT
        vt.anio_registro AS anio,
        vt.departamento,
        vt.municipio,
        SUM(vt.casos) AS casos_desnutricion
    FROM vw_registro_salud_territorial vt
    WHERE vt.indicador_salud CONTAINING 'DESNUTRICION'
    GROUP BY 1, 2, 3
),
delitos AS (
    SELECT
        EXTRACT(YEAR FROM h.fecha_hecho) AS anio,
        d.nombre AS departamento,
        m.nombre AS municipio,
        COUNT(*) AS hechos_delictivos
    FROM hecho_delictivo hd
    JOIN hecho h ON h.id_hecho = hd.id_hecho
    JOIN ubicacion u ON u.id_ubicacion = h.id_ubicacion
    JOIN municipio m ON m.id_municipio = u.id_municipio
    JOIN departamento d ON d.id_departamento = m.id_departamento
    GROUP BY 1, 2, 3
)
SELECT
    COALESCE(s.anio, d.anio) AS anio,
    COALESCE(s.departamento, d.departamento) AS departamento,
    COALESCE(s.municipio, d.municipio) AS municipio,
    COALESCE(s.casos_desnutricion, 0) AS casos_desnutricion,
    COALESCE(d.hechos_delictivos, 0) AS hechos_delictivos
FROM salud s
FULL JOIN delitos d
  ON d.anio = s.anio
 AND d.departamento = s.departamento
 AND d.municipio = s.municipio
ORDER BY 1, 2, 3;

/* 29) LISTA/PARCIAL: Violencia estructural urbano vs rural */
SELECT
    EXTRACT(YEAR FROM h.fecha_hecho) AS anio,
    COALESCE(ag.nombre, 'SIN_AREA') AS area_geografica,
    COUNT(*) AS total_casos
FROM violencia_estructural ve
JOIN hecho h ON h.id_hecho = ve.id_hecho
JOIN ubicacion u ON u.id_ubicacion = h.id_ubicacion
LEFT JOIN area_geografica ag ON ag.id_area_geografica = u.id_area_geografica
GROUP BY 1, 2
ORDER BY 1, total_casos DESC;

/* 30) LISTA/PARCIAL: Frecuencia de exhumaciones por tipo de delito relacionado */
SELECT
    de.nombre AS delito,
    COUNT(*) AS total_exhumaciones
FROM exhumacion ex
JOIN hecho h ON h.id_hecho = ex.id_hecho
LEFT JOIN hecho_delictivo hd ON hd.id_hecho = h.id_hecho
LEFT JOIN delito_cometido dc ON dc.id_delito_cometido = hd.id_delito
LEFT JOIN delito de ON de.id_delito = dc.id_tipo_delito
GROUP BY 1
ORDER BY total_exhumaciones DESC;
