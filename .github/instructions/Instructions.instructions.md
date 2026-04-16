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
- La tabla falta (transaccional) no debe asumirse cargada hasta ejecutar un archivo fuente transaccional de faltas judiciales.
- El involucramiento recomendado para faltas judiciales es Infractor (si la fuente no indica otro rol especifico).

### Entregables Obligatorios

- Entregar un archivo de insercion por cada catalogo o tabla destino.
- Organizar catalogos en sql/inserts/catalogos y transaccionales en sql/inserts/transaccional.
- Para lotes grandes, dividir en batches numerados por fuente (ejemplo: 100_, 101_, 102_).

### Orden de Insercion para Retomar

- 1) Catalogos base y geografia.
- 2) Catalogos de delitos y homologacion entre fuentes.
- 3) Carga transaccional por archivo fuente siguiendo su flujo de modelo.
- 4) Al terminar cada archivo: validacion de conteos y registro de tablas afectadas.


