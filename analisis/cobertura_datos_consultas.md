# Analisis de cobertura de datos y consultas

Fecha de corte: 2026-04-16

## 1) Estado actual de cobertura de datos en DB

Conteos de referencia actuales:

- persona: 234339
- hecho: 234339
- hecho_delictivo: 163686
- denuncia: 1892
- sentencia: 43338
- violencia_estructural: 113
- caso_violencia_ninez: 0
- caso_ninez_trabajo_infantil: 0
- embarazo_adolescente: 0
- caso_violencia_intrafamiliar: 0
- registro_salud: 0
- fuente_salud: 0
- condicion_salud: 0
- grupo_etario_salud: 0

Conclusion rapida: el dominio de violencia general y sentencias ya permite consultas analiticas basicas, pero niñez, intrafamiliar y salud aun no tienen carga transaccional.

## 2) Archivos faltantes (pendientes) y lectura tecnica

Pendientes por checklist:

- Batch 109 PNC victimas: pendiente 15001-39968.
- Batch 110 Agraviados: pendiente 1001-444513.
- Batch 111 Sindicados: pendiente 1001-362321.
- Batch 112 Necropsias: pendiente 1001-11038.
- Batch 113 Exhumaciones: pendiente 61-118.
- Batch 114 Medicos INACIF: pendiente 1001-148537.
- Batch 115 Sentenciados: pendiente 1001-59812.
- Quejas Mineduc: no iniciado.
- VIF Diccionario 2023: no iniciado.

Perfilado de los dos no iniciados:

### 2.1 Quejas Mineduc

- Archivo: 20240719123138C8M6SpIQkU1dO569us4WzmhiEojxPhwf.xlsx
- Hojas: Indice, C1, C2, C3.
- C1 contiene datos agregados (crosstab) por departamento y tipo de agresion.
- C2 y C3 vacias.
- Implicacion ETL: requiere normalizacion de encabezados multinivel y expansion de medidas agregadas a eventos sinteticos (segun reglas del proyecto).

### 2.2 VIF Diccionario 2023

- Archivo: 2024052300613QDinUvuRa9GjopyXaTuNMXc3gd6Jq1Q1.xlsx
- Hoja: DICCIONARIO.2023VIF (1939 x 4).
- Contenido tipo diccionario de variables/valores, no transaccional directo.
- Implicacion ETL: alimenta catalogos y homologaciones para luego cargar hechos VIF (boletas/casos) desde fuentes transaccionales.

## 3) Interpretacion de consultas propuestas y factibilidad

Escala:

- LISTA: consulta ejecutable con modelo y datos actuales.
- PARCIAL: modelo soporta, pero falta carga de dominios o reglas.
- BLOQUEADA: requiere cambio de modelo o regla de negocio.

1. Homicidios por anio y departamento: LISTA (usando filtro de delito homologado a homicidio).
2. Denuncias VCM por municipio: LISTA.
3. Top 5 tipos de hechos delictivos ultimos 5 anios: LISTA.
4. Sentencias por tipo de delito y anio: LISTA.
5. Promedio de edad de victimas VIF: PARCIAL (sin casos VIF cargados).
6. Embarazos adolescentes por region: PARCIAL (tabla existe, sin carga).
7. Violencia infantil relacionada con trabajo infantil: PARCIAL (sin carga de niñez).
8. Porcentaje de discriminacion segun etnia: LISTA (muestra pequena actual).
9. Escolaridad vs tipo de falta judicial: LISTA/PARCIAL (depende del rol elegido en involucrado_hecho).
10. Necropsias por anio: LISTA.
11. Tasa de violencia estructural procesadas/no procesadas: BLOQUEADA sin atributo de proceso en violencia_estructural.
12. Tipo de empleo vs ocurrencia de hechos delictivos: PARCIAL (modelo soporta, falta densidad en persona_ocupacion).
13. Casos VCM con sentencia firme: LISTA (tipo_fallo condenatoria/firme segun catalogo).
14. Idiomas de victimas de discriminacion: PARCIAL (idioma_persona con baja cobertura).
15. Personas por hogar en casos VIF: PARCIAL (sin casos VIF cargados).
16. Tasa violencia infantil escolarizada vs no escolarizada: PARCIAL (sin carga niñez).
17. Trabajo infantil por sector economico: PARCIAL (sin carga niñez-trabajo).
18. Edad vs tipo de violencia sufrida: PARCIAL (faltan dominios niñez/vif).
19. Desnutricion aguda por territorio/anio: PARCIAL (salud sin carga).
20. Retardo desarrollo por grupo etario/sexo/region: PARCIAL (salud sin carga).
21. Incidencia cronicas por CIE-10: PARCIAL (salud sin carga).
22. Evolucion dengue/dengue grave 2012-2024: PARCIAL (salud sin carga).
23. Malaria por grupo etario y sexo municipal: PARCIAL (salud sin carga).
24. Desnutricion infantil vs VIF por departamento: PARCIAL (salud y VIF sin carga).
25. Top 5 municipios Chagas+Zika+Chikungunya: PARCIAL (salud sin carga).
26. Vectores vs urbanizacion por departamento: PARCIAL (salud sin carga y regla urbanizacion).
27. Tasa morbilidad materna infantil por anio/departamento: PARCIAL (salud sin carga y denominador).
28. Correlacion desnutricion vs hechos delictivos: PARCIAL (salud sin carga; requiere metrica estadistica).
29. Violencia estructural urbano vs rural: LISTA/PARCIAL (si area_geografica esta poblada consistentemente).
30. Frecuencia exhumaciones por tipo de delito: LISTA/PARCIAL (depende de calidad de delito en exhumacion).

## 4) Ajustes de modelo recomendados para cubrir consultas no directas

Para habilitar la consulta 11 sin forzar inferencias ambiguas, se agrega soporte directo en violencia_estructural:

- Campo es_procesada (0/1).
- Campo id_estado_denuncia (opcional, FK a estado_denuncia).

Para estandarizar consultas de salud heterogeneas (desnutricion, dengue, cronicas, etc.):

- Campo indicador_salud en registro_salud para agrupar condiciones de una misma familia analitica.

Estos cambios se aplican en DDL incremental no destructivo.

## 5) Estrategia de completitud antes de reporteria final

1. Terminar lotes pendientes 109-115 por continuidad (parciales sucesivos).
2. Procesar Quejas Mineduc como fuente agregada expandible a niñez.
3. Procesar diccionario VIF para consolidar catalogos y homologaciones.
4. Cargar transaccional VIF (si fuente transaccional disponible en carpeta VIF 2023).
5. Cargar modulo salud en registro_salud + denominador_poblacional.
6. Validar nuevamente matriz de consultas y marcar LISTA en las hoy PARCIAL.
