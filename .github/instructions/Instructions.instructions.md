---
description: Describe when these instructions should be loaded by the agent based on task context
# applyTo: 'Describe when these instructions should be loaded by the agent based on task context' # when provided, instructions will automatically be added to the request context when the pattern matches an attached file
---

<!-- Tip: Use /create-instructions in chat to generate content with agent assistance -->

Instrucciones del proyecto para generacion, extraccion y carga de datos.

## Contexto General

- Tomar en cuenta el archivo enunciado_proyecto.txt.
- Gestor de base de datos: Firebird.
- Pais de referencia: Guatemala.

## Reglas Generales de Carga

- Si un campo no esta disponible, dejarlo en blanco.
- Si falta un id de catalogo, usar el id correspondiente a desconocido.
- Se puede usar Faker para crear datos sinteticos cuando aplique.
- Si no se incluye municipio, elegir cualquiera del catalogo del departamento informado.

## Flujo de Modelado por Tipo de Archivo

- Este flujo es el patron oficial de la logica del proyecto para integrar fuentes con datos incompletos.
- Cuando un archivo no traiga toda la informacion, no se debe omitir el evento: se deben crear las entidades minimas del flujo para preservar la trazabilidad.
- En la mayoria de archivos no se cuenta con todos los datos, por lo que se debe seguir el flujo del modelo segun el tipo de archivo fuente.
- Ejemplo denuncia: crear hecho, denuncia, persona e involucramiento segun corresponda, aunque algunos atributos queden en blanco o como desconocido.
- Ejemplo sindicados: crear persona involucrada, asociarla al hecho y al hecho delictivo segun el flujo definido en el modelo.
- Regla general: crear las entidades relacionadas necesarias para mantener trazabilidad del evento.

### Criterio de Decision para Datos Incompletos

- Prioridad 1: crear el hecho/evento y su contexto de ubicacion y fecha.
- Prioridad 2: crear la persona involucrada aunque sus atributos vengan parciales.
- Prioridad 3: registrar la relacion persona-hecho y el tipo de involucramiento.
- Prioridad 4: asociar clasificaciones del evento (tipo de hecho, delito, estado) usando homologacion y valores desconocido cuando aplique.
- Resultado esperado: cada registro de fuente debe quedar representado en el modelo, aun con atributos faltantes.

## Reglas de Fechas

- Cuando sea necesario inventar una fecha, debe quedar dentro de los limites temporales de los datos fuente utilizados.
- Las fechas deben tener logica entre si, especialmente en pares de inicio y fin.
- Evitar fechas contradictorias con la cronologia del evento.

## Normalizacion y Homologacion de Catalogos

- Normalizar catalogos que traen variantes como desconocido, ignorado u otros equivalentes.
- Los delitos pueden venir clasificados distinto en PNC, MP y OJ.
- Conservar el dato original de la fuente y homologarlo a una tabla o catalogo comun del modelo.

### Regla Territorial desde Catalogo de Municipios

- En catalogos/municipios/municipios- depto.txt, el prefijo numerico del codigo de municipio determina su departamento (ejemplo: 1601 pertenece al departamento 16).
- Para fuentes con solo departamento, usar como municipio por defecto la primera cabecera disponible del departamento segun ese catalogo (generalmente xx01).

## Reglas Especificas por Fuente: Denuncias MP (VCM)

- Para archivos de Denuncias registradas del MP, seguir este flujo de carga: ubicacion -> persona -> hecho -> denuncia -> involucrado_hecho -> hecho_delictivo.
- En este flujo, el tipo de hecho debe mapearse al valor correspondiente a hecho_delictivo del catalogo tipo_hecho.
- En hecho_delictivo, mapear el delito al valor homologado de VCM en la tabla comun de delitos del modelo.
- En involucrado_hecho, mapear el tipo de involucramiento al valor Denunciante.

### Campos y Reglas Minimas para MP VCM

- Fecha: usar fecha_hecho y fecha_denuncia con coherencia cronologica.
- Municipio: priorizar municipio del hecho; si falta, usar municipio de origen de la persona; si aun falta, aplicar regla general de municipio por departamento.
- Edad: derivar de fecha_nacimiento.
- Escolaridad: mapear a nivel_escolaridad.
- Pueblo de pertenencia: mapear a grupo_etnico homologado.
- Orientacion sexual: mapear a orientacion_sexual.
- Estado de caso: mapear a estado_denuncia.

### Valores por Defecto en MP VCM

- Si no hay dato de estado civil o condicion alfabetica, usar desconocido.
- Si no hay nombres u otros datos de identidad, se permite completar con Faker segun reglas generales.
- Si no hay fecha de nacimiento, generar una fecha plausible dentro del rango de datos y consistente con la edad objetivo definida para la fuente.

## Continuidad Entre Chats

- Si el chat se corta, continuar desde el ultimo archivo del orden de insercion sin reiniciar cargas ya aplicadas.
- Antes de cada nuevo lote, validar conteos por tabla para confirmar estado real de la DB.
- Mantener idempotencia: todos los scripts de carga deben usar validaciones NOT EXISTS o reglas equivalentes para evitar duplicados.

### Estado Operativo de Referencia

- La tabla tipo_falta ya tiene carga de catalogo.
- La tabla falta (transaccional) ya cuenta con carga inicial del archivo fuente 20240524231759eHmz6DmFKboNQ5Y3OlqNkbi9izmXULaP.xlsx (batch 101).
- El involucramiento recomendado para faltas judiciales es Infractor (si la fuente no indica otro rol especifico).

### Entregables Obligatorios

- Entregar un archivo de insercion por cada catalogo o tabla destino.
- Organizar catalogos en sql/inserts/catalogos y transaccionales en sql/inserts/transaccional.
- Para lotes grandes, dividir en batches numerados por fuente (ejemplo: 100_, 101_, 102_).

### Orden de Insercion para Retomar (Con Carpeta/Archivo)

- [x] catalogos/tipo_fall.txt
- [x] catalogos/tipo_hechos.txt
- [x] catalogos/tipo_discriminacion.csv
- [x] catalogos/delitos/involucramiento.txt
- [x] catalogos/ley-titulo-capitulo.txt
- [x] catalogos/delitos/causas_pnc.txt
- [x] catalogos/delitos/causas_victimas_pnc.txt
- [x] catalogos/delitos/agraviados-sindicados.txt
- [x] catalogos/delitos/oj.txt
- [x] catalogos/municipios/municipios- depto
- [x] datos_base/Violencia/Faltas judiciales/Diccionario/20240524231842pWf6BcBWj8taVS3Q3mRKxgDsvwPejgH8.xlsx (solo catalogos derivados)
- [x] datos_base/Violencia/Violencia contra la mujer/Denuncias registradas/Denuncias del MP por el delito de VCM.xlsx (batch transaccional inicial)
- [x] datos_base/Violencia/Faltas judiciales/20240524231759eHmz6DmFKboNQ5Y3OlqNkbi9izmXULaP.xlsx (batch transaccional 101)
- [x] datos_base/Violencia/Violencia contra la mujer/Hechos delictivos/Hechos delictivos contra mujeres de 2008 al 2024.xlsx (batch transaccional 102)
- [x] datos_base/Violencia/Violencia contra la mujer/Medidas de seguridad/Medidas de Seguridad 2012-2024.xlsx (batch transaccional 103)
- [x] datos_base/Violencia/Violencia contra la mujer/Sentencias por delito/Sentencias del Ministerio Publico por el delito de Violencia Contra la Mujer.xlsx (batch transaccional 104)
- [x] datos_base/Violencia/Violencia contra la mujer/Sentencias por delito/SENTENCIAS DEL Organismo Judicial POR EL DELITO DE Violencia contra la mujerCM 2008-2024.xlsx (batch transaccional 105)
- [x] datos_base/Violencia/Violencia contra la mujer/Atencion brindada/Atenciones brindades por el Instituto de la Víctima 2020-2023(1).xlsx (batch transaccional 106)
- [x] datos_base/Violencia/Violencia estructural/CASOS DISCRIMINACIÓN 2016-2023.xls (batch transaccional 107)
- [x] datos_base/Violencia/Hechos-Delicitivos/PNC - Detenciados/detenidos.xlsx (batch transaccional 108)
- [ ] datos_base/Violencia/Hechos-Delicitivos/PNC -Victimas/pnc_victimas.xlsx (batch 109 parcial cargado: filas 1-15000; pendiente 15001-39968)
- [ ] datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx (batch 110 parcial cargado: filas 1-1000; pendiente 1001-444513)
- [ ] datos_base/Violencia/Hechos-Delicitivos/Sindicatos/sindicados.xlsx (batch 111 parcial cargado: filas 1-1000; pendiente 1001-362321)
- [ ] datos_base/Violencia/Hechos-Delicitivos/Necropsias/necropsias.xlsx (batch 112 parcial cargado: filas 1-1000; pendiente 1001-11038)
- [ ] datos_base/Violencia/Hechos-Delicitivos/Exhumaciones/exhumaciones.xlsx (batch 113 parcial cargado: filas 1-60; pendiente 61-118)
- [ ] datos_base/Violencia/Hechos-Delicitivos/Evaluacion Medicos - INACIF/medicos_inacif.xlsx (batch 114 parcial cargado: filas 1-1000; pendiente 1001-148537)
- [ ] datos_base/Violencia/Hechos-Delicitivos/Organismo judical - Sentenciados/sentenciados.xlsx (batch 115 parcial cargado: filas 1-1000; pendiente 1001-59812)
- [ ] datos_base/Violencia/Violencia contra la ninez/Quejas Mineduc/20240719123138C8M6SpIQkU1dO569us4WzmhiEojxPhwf.xlsx (batch 117 parcial cargado: 250 eventos sinteticos; pendiente completar departamentos y volumen)
- [ ] datos_base/Violencia/Violencia intrafamiliar/2023/Diccionario/2024052300613QDinUvuRa9GjopyXaTuNMXc3gd6Jq1Q1.xlsx (diccionario VIF 2023, analizado: referencia de codigos/etiquetas, sin carga transaccional directa)
- [ ] datos_base/Violencia/Violencia intrafamiliar/2023/violencia_intrafamiliar.xlsx (batch 116 parcial cargado: filas 1-500; pendiente 501-37348)
- [ ] datos_base/Violencia/Violencia intrafamiliar/2024/diccionario-de-variables-violencia-intrafamiliar.xlsx (diccionario VIF 2024, analizado: referencia de codigos/etiquetas, sin carga transaccional directa)
- [ ] datos_base/Violencia/Violencia intrafamiliar/2024/base-de-datos-violencia-intrafamiliar-ano-2024_v3.xlsx (batch 118 parcial cargado: filas 1-500; pendiente 501-36609)

### Validaciones Minimas por Paso

- Al terminar cada archivo, registrar conteos de tablas afectadas (antes/despues).
- Confirmar si el archivo fue carga de catalogo o transaccional.
- Si un archivo solo alimenta catalogos, marcarlo explicitamente como "solo catalogos".


