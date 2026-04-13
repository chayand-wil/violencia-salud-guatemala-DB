# Descripcion del modelo y mapeo de fuentes

## Fuentes adicionales de Hechos-Delicitivos
fuentes_adicionales_hechos_delictivos(
	agraviados
	pnc_victimas
	pnc_detenidos
	sentenciados
	medicos_inacif
	exhumaciones
	necropsias
	sindicados
);

## Lectura para 3FN con las fuentes de Hechos-Delictivos
- Estas fuentes no deben mezclarse todas en una sola tabla porque cada una describe un tipo de evento distinto.
- La forma normalizada es mantener catalogos comunes y luego una tabla fact por evento.
- Los datos de fecha, sexo, edad, ubicacion y delito se repiten entre archivos, pero eso no significa que deban duplicarse en las tablas finales; deben salir de una entidad evento concreta.

## Mapeo por fuente

### 1) agraviados
- Encaje principal:
  - hecho
  - denuncia
  - victima_hecho
  - hecho_delito
- Campos fuertes:
  - ano_denuncia, Reg_mes, dia_denuncia -> fecha_denuncia
  - ano_hecho, mes_hecho, dia_hecho -> fecha_hecho
  - depto_ocu_hecho, mupio_ocu_hecho, zona_ocu_hecho -> ubicacion
  - sexo_agraviados -> genero
  - edad_agrav -> dato temporal de staging
  - est_conyugal -> estado_civil
  - delito_com -> delito
  - principales_delitos -> clasificacion_delito

### 2) pnc_victimas
- Encaje principal:
  - hecho
  - victima_hecho
  - hecho_delito
- Campos fuertes:
  - ano_ocu, mes_ocu, dia_ocu -> fecha_hecho
  - area_geo_ocu, depto_ocu, mupio_ocu, zona_ocu -> ubicacion
  - sexo_per -> genero
  - edad_per -> dato temporal de staging
  - delito_com -> delito
  - g_delitos -> clasificacion_delito

### 3) pnc_detenidos
- Encaje principal:
  - hecho
  - persona
  - hecho_delito
- Campos fuertes:
  - ano_ocu, mes_ocu, dia_ocu -> fecha_hecho
  - area_geo_ocu, depto_ocu, mupio_ocu, zona_ocu -> ubicacion
  - sexo_per -> genero
  - edad_per -> dato temporal de staging
  - delito_com -> delito
  - g_delitos -> clasificacion_delito
- Observacion:
  - hace falta una tabla fact especifica de detencion si quieres conservar el evento como tal y no solo la persona.

### 4) sentenciados
- Encaje principal:
  - sentencia
  - persona
  - delito_cometido
  - ubicacion
- Campos fuertes:
  - ano_reg, mes_reg -> fecha_registro
  - men_may -> menor_mayor
  - sexo -> genero
  - nacionalidad -> pais
  - Involucramiento -> rol procesal
  - tip_fallo -> resultado de sentencia
  - depto_reg -> ubicacion de registro
  - delito_cod -> delito
  - tip_ley, titulo, capitulo -> clasificacion juridica complementaria
- Observacion:
  - conviene una tabla sentencia para no forzar este archivo dentro de hecho o falta.

### 5) medicos_inacif
- Encaje principal:
  - evaluacion_medica_inacif
  - persona
  - ubicacion
- Campos fuertes:
  - ano_ocu, mes_ocu, dia_ocu -> fecha_evaluacion
  - depto_ocu -> ubicacion
  - edad_per -> dato temporal de staging
  - menor_mayor -> clasificacion etaria
  - sexo_per -> genero
  - clasif_eval -> tipo de evaluacion

### 6) exhumaciones
- Encaje principal:
  - exhumacion
  - ubicacion
- Campos fuertes:
  - ano_ocu, mes_ocu, dia_ocu -> fecha_exhumacion
  - depto_ocu -> ubicacion
- Observacion:
  - esta fuente necesita su propia tabla fact porque no describe una denuncia ni una victima directa.

### 7) necropsias
- Encaje principal:
  - necropsia
  - persona
  - ubicacion
- Campos fuertes:
  - ano_ing, mes_ing, dia_ing -> fecha_ingreso
  - depto_ocu, mupio_ocu -> ubicacion
  - edad_per -> dato temporal de staging
  - sexo_per -> genero
  - causa_muerte -> causa o clasificacion de necropsia

### 8) sindicados
- Encaje principal:
  - sindicado
  - persona
  - hecho
  - hecho_delito
- Campos fuertes:
  - ano_denuncia, Reg_mes, dia_denuncia -> fecha_denuncia
  - ano_hecho, mes_hecho, dia_hecho -> fecha_hecho
  - depto_ocu_hecho, mupio_ocu_hecho, zona_ocu_hecho -> ubicacion
  - sexo_per -> genero
  - edad_sind -> dato temporal de staging
  - est_conyugal -> estado_civil
  - delito_com -> delito
  - principales_delitos -> clasificacion_delito

## Tablas fact nuevas sugeridas
- detencion
- sentencia
- evaluacion_medica_inacif
- exhumacion
- necropsia
- sindicado

## Regla de diseno para estas fuentes
- No forzar todos los archivos a hecho o denuncia.
- Si el archivo describe un evento distinto, la tabla final debe reflejar ese evento.
- Si un dato solo sirve para cargar o inferir, dejarlo en staging.
- Si una misma persona aparece en varios archivos, debe conservarse como la misma entidad persona y no duplicarse por fuente.

## Carpeta adicional: Violencia contra la mujer

### Fuentes analizadas
- Atencion brindada
- Delictos contra la vida y feminicidios
- Denuncias registradas
- Evaluaciones Inacif
- Hechos delictivos
- Medidas de seguridad
- Sentencias por delito (OJ)
- Sentencias por delito (MP)

### Encaje al modelo
- Atencion brindada -> atencion_victima + hecho + ubicacion
- Denuncias registradas -> denuncia_registrada_vcm + denuncia + hecho
- Delitos contra la vida y femicidios -> delito_vida_feminicidio + hecho
- Hechos delictivos -> hecho_delictivo_vcm + hecho
- Medidas de seguridad -> medida_seguridad + hecho
- Evaluaciones Inacif -> evaluacion_medica_inacif + hecho + persona
- Sentencias OJ -> sentencia + sentencia_oj + sentencia_hecho
- Sentencias MP -> sentencia + sentencia_mp + sentencia_hecho

### Nota de granularidad
- Varias fuentes traen la columna valor con filas agregadas (conteos), no registros individuales de persona.
- Por eso se modelan como tablas fact de indicadores, manteniendo el atributo valor para no perder la metrica original.

## Nueva cabecera analizada: Departamento registro x Tipo de agresion

### Estructura detectada
- Fila por departamento de registro.
- Columnas por tipo de agresion.
- Una columna Total y una fila Total de control.

### Encaje al modelo
- tipo_agresion_ninez: catalogo para los encabezados de agresion.
- queja_agresion_ninez: fact agregada con:
  - id_departamento_registro
  - id_tipo_agresion
  - valor

### Regla de transformacion (wide -> long)
- Convertir cada columna de agresion en filas (unpivot).
- No cargar la columna Total en la fact final.
- No cargar la fila Total como departamento.
- Convertir '-' a 0 antes de cargar valor.

## Carpeta adicional: Violencia estructural

### Fuente analizada
- CASOS DISCRIMINACION 2016-2023.xls

### Estructura detectada
- Una hoja por anio (2016 a 2023).
- Filas de casos con datos de victima y del hecho.
- Encabezado irregular por hoja, por lo que la fila de cabecera debe detectarse en ETL.

### Encaje al modelo
- caso_discriminacion_estructural -> hecho + persona + tipo_discriminacion.
- tipo_discriminacion -> catalogo para valores como etnica, racial, discriminacion, etc.
- idioma_comunidad -> referencia a idiomas_lenguas.
- anio_registro -> anio de la hoja para auditoria y trazabilidad.

### Reglas de limpieza
- Excluir filas de encabezado interno (por ejemplo: Departamento, DATOS DE LA VICTIMA).
- Excluir filas de resumen (por ejemplo: TOTAL).
- Normalizar sexo cuando venga en columnas separadas (M/F o M/H).
- Normalizar pueblo de pertenencia para mapearlo a grupo_etnico en persona.

## Carpeta adicional: Violencia intrafamiliar

### Fuentes analizadas
- 2023/violencia_intrafamiliar.xlsx
- 2024/base-de-datos-violencia-intrafamiliar-ano-2024_v3.xlsx
- Diccionarios 2023/2024 (misma estructura de hoja y codigos)

### Estructura detectada
- Registros individuales por boleta (no agregados).
- Variables de hecho, victima, agresor y juridicas en una sola fila.
- Existen campos multivalorados en columnas repetidas de articulos (ARTICULOVIF1..4, ARTICULOVCM1..4, ARTICULOCODPEN1..4, ARTICULOTRAS1..4).

### Encaje al modelo
- caso_violencia_intrafamiliar -> hecho + persona (victima/agresor principal) + tipo_agresion_intrafamiliar.
- caso_vif_articulo_legal -> puente de muchos-a-muchos entre caso y articulo_legal.
- caso_vif_medida_seguridad -> puente de muchos-a-muchos entre caso y tipo_medida_seguridad.

### Reglas de limpieza
- Tratar 99, 999 o equivalentes como no especificado en variables codificadas.
- Armar fecha_hecho con HEC_DIA, HEC_MES, HEC_ANO.
- Armar fecha_emision con DIA_EMISION, MES_EMISION, ANO_EMISION.
- Parsear columnas de articulos como lista y cargar solo codigos validos en la tabla puente.
- Si MEDIDAS_SEGURIDAD indica no aplica, no cargar filas en caso_vif_medida_seguridad.

## Carpeta adicional: Salud

### Fuentes analizadas
- Morbilidad Grupo Materno Infantil:
  - morbilidad-materna-2012-al-2024.csv
  - morbilidad-neonatal-2012-al-2024.csv
- Desnutricion:
  - morbilidad-desnutricion-aguda-departamento-municipio-2012-a-2024.csv
  - morbilidad-retardo-desarrollo-departamento-municipio-2012-2024.csv
- Enfermedades transmitidas por vectores:
  - chagas, chikungunya, dengue, dengue-grave, malaria, zika
- Enfermedades cronicas:
  - mec-2020 a mec-2024

### Estructura detectada
- Casi todos los archivos son series agregadas por anio, departamento, municipio, grupo etario, sexo y casos.
- Algunas fuentes incluyen CIE-10 y diagnostico; otras no y la condicion viene implicita en el nombre del archivo.
- Todos usan separador ;.
- El archivo mec-2024 tiene cabeceras con saltos de linea embebidos y requiere limpieza de nombres de columna.

### Encaje al modelo
- fuente_salud: catalogo de origen tematico (materna, neonatal, desnutricion, vectores, cronicas).
- grupo_etario_salud: catalogo de grupos etarios textuales de salud.
- condicion_salud: catalogo de condicion diagnostica (con o sin CIE-10).
- registro_salud: fact agregada con ubicacion, anio, grupo etario, genero, condicion y casos.

### Reglas de transformacion
- Leer CSV con sep=';'.
- Estandarizar columnas equivalentes:
  - grupo etario, Grupo Etario, GrupoEtario -> grupo_etario
  - sexo, Sexo -> sexo
  - casos, cantidad -> casos
- Normalizar encabezados con espacios/saltos de linea en archivos problematicos (ejemplo mec-2024).
- Cuando no exista CIE-10, registrar condicion_salud.nombre a partir de la fuente o del campo de enfermedad disponible.
- Si no hay sexo en una fuente especifica, permitir id_genero nulo en registro_salud.
