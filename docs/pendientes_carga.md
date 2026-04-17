# Pendientes de carga

## Batch 109 - PNC victimas
- Fuente: datos_base/Violencia/Hechos-Delicitivos/PNC -Victimas/pnc_victimas.xlsx
- Total filas fuente: 39968
- Rango cargado en parcial: 15001 a 39968
- Rango pendiente: 39969 a 39968
- Chunks generados para ejecucion segura: 25 (directorio: sql/inserts/transaccional/chunks_109_b2)
- Siguiente accion sugerida: generar `109_pnc_victimas_batch2_parcial.sql` empezando en `START_INDEX = 39968`.

## Batch 116 - Violencia intrafamiliar 2023 (parcial cargado)
- Fuente: datos_base/Violencia/Violencia intrafamiliar/2023/violencia_intrafamiliar.xlsx
- Total filas fuente: 37348
- Rango cargado en parcial: 1 a 500
- Rango pendiente: 501 a 37348
- Archivos SQL generados:
	- Catalogos: `sql/inserts/catalogos/087_tipo_agresion_intrafamiliar_2023.sql`, `sql/inserts/catalogos/088_involucramiento_vif.sql`
	- Transaccional: `sql/inserts/transaccional/116_vif_2023_batch1_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_116/116_vif_2023_part_01.sql` a `..._05.sql`
- Estado de ejecucion: ejecutado por `isql` con DSN `localhost:/.../violencia_guate.fdb`.
- Conteos asociados tras carga: `caso_violencia_intrafamiliar` paso de 0 a 496 en este batch.
- Idempotencia: validada (re-ejecucion sin cambios).

## Batch 117 - Quejas Mineduc 2023 (parcial cargado)
- Fuente: datos_base/Violencia/Violencia contra la ninez/Quejas Mineduc/20240719123138C8M6SpIQkU1dO569us4WzmhiEojxPhwf.xlsx
- Tipo de fuente: agregada por departamento y tipo de agresion (hoja C1)
- Alcance parcial cargado: 6 departamentos y 250 eventos sinteticos
- Pendiente: completar departamentos restantes y/o ampliar volumen por departamento
- Archivos SQL generados:
	- Catalogos: `sql/inserts/catalogos/089_tipo_agresion_ninez_quejas_mineduc.sql`, `sql/inserts/catalogos/090_estado_escolarizacion_ninez.sql`
	- Transaccional: `sql/inserts/transaccional/117_quejas_mineduc_batch1_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_117/117_quejas_mineduc_part_01.sql` a `..._05.sql`
- Estado de ejecucion: ejecutado por `isql` con DSN `localhost:/.../violencia_guate.fdb`.
- Conteos asociados tras carga: `caso_violencia_ninez` paso de 0 a 250 en este batch.
- Idempotencia: validada (re-ejecucion sin cambios).

## Batch 118 - Violencia intrafamiliar 2024 (parcial cargado)
- Fuente: datos_base/Violencia/Violencia intrafamiliar/2024/base-de-datos-violencia-intrafamiliar-ano-2024_v3.xlsx
- Total filas fuente: 36609
- Rango cargado en parcial: 1 a 500
- Rango pendiente: 501 a 36609
- Archivos SQL generados:
	- Catalogo: `sql/inserts/catalogos/091_tipo_agresion_intrafamiliar_2024.sql`
	- Transaccional: `sql/inserts/transaccional/118_vif_2024_batch1_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_118/118_vif_2024_part_01.sql` a `..._05.sql`
- Estado de ejecucion: ejecutado por `isql` con DSN `localhost:/.../violencia_guate.fdb`.
- Conteos asociados tras carga: `caso_violencia_intrafamiliar` aumento de 496 a 993 en este batch.
- Idempotencia: validada (re-ejecucion sin cambios).

## Resumen de conteos despues de 116+117+118
- persona: 249575
- hecho: 248582
- involucrado_hecho: 243959
- caso_violencia_intrafamiliar: 993
- caso_violencia_ninez: 250
- tipo_agresion_intrafamiliar: 10
- tipo_agresion_ninez: 7
- estado_escolarizacion: 1

## Diccionarios VIF 2023/2024 (analizados)
- Fuentes:
	- datos_base/Violencia/Violencia intrafamiliar/2023/Diccionario/2024052300613QDinUvuRa9GjopyXaTuNMXc3gd6Jq1Q1.xlsx
	- datos_base/Violencia/Violencia intrafamiliar/2024/diccionario-de-variables-violencia-intrafamiliar.xlsx
- Hallazgo: ambos archivos son diccionarios de codigos/etiquetas y no contienen hechos transaccionales para insertar directamente.
- Uso: apoyo para homologacion y validacion semantica del mapeo de columnas/codigos en lotes VIF.
- Estado: sin carga SQL directa requerida en esta fase.
