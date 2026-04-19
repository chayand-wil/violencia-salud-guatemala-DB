# Pendientes de carga

## Modo de carga rapida (seguro)
- Para Agraviados, usar el cargador [etl/load_agraviados_batch_fast.py](etl/load_agraviados_batch_fast.py) para ejecutar todos los chunks en una sola sesion de isql.
- En el primer batch del dia, ejecutar con catalogos incluidos usando la opcion --with-catalogs.
- En batches consecutivos sin cambios en catalogos, ejecutar sin --with-catalogs para evitar sobrecosto.
- Mantener validacion before/after e idempotencia del chunk final en cada batch.
- Plantilla actualizada a CHUNK_SIZE=500 en [etl/generate_agraviados_batch25_sql.py](etl/generate_agraviados_batch25_sql.py) para reducir numero de chunks por tramo.

## Batch 109 - PNC victimas
- Fuente: datos_base/Violencia/Hechos-Delicitivos/PNC -Victimas/pnc_victimas.xlsx
- Total filas fuente: 39968
- Rango cargado final: 1 a 39968
- Rango pendiente: ninguno
- Chunks generados para ejecucion segura: 25 (directorio: sql/inserts/transaccional/chunks_109_b2)
- Estado de ejecucion: completado (se retomaron y ejecutaron `chunks_109_b2` partes 14 a 25).
- Conteos antes/despues del cierre de este pendiente:
	- persona: 249575 -> 261543
	- hecho: 248582 -> 260550
	- involucrado_hecho: 243959 -> 255927
- Verificacion de cobertura de rango batch2:
	- min fila cargada: 15001
	- max fila cargada: 39968
	- total filas batch2 presentes: 24968
- Siguiente accion sugerida: continuar con Batch 110 (agraviados), pendiente desde fila 1001.

## Batch 110 - Agraviados (avance adicional)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Total filas fuente: 444513
- Estado anterior: parcial cargado 1 a 41000
- Estado actual: parcial cargado 1 a 43000
- Rango pendiente: 43001 a 444513
- SQL generado para este avance:
-	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch30_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b30/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: loader rapido en una sola sesion isql (sin catalogos, ya estables).
- Conteos antes/despues de este avance:
	- persona: 301534 -> 303534
	- hecho: 300541 -> 302541
	- involucrado_hecho: 295918 -> 297918
- Verificacion de rango cargado (41001..43000): 2000 registros presentes
- Idempotencia puntual: re-ejecutado `110_agraviados_part_04.sql` sin incremento (500 -> 500).
- Siguiente accion sugerida: generar/ejecutar Batch 110 siguiente tramo desde `START_INDEX = 43000`.

## Batch 110 - Agraviados (avance adicional 2)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 2000
- Estado actual: parcial cargado 1 a 3000
- Rango pendiente: 3001 a 444513
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch3_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b3/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b3` (01..04)
- Conteos antes/despues de este avance:
	- persona: 262543 -> 263543
	- hecho: 261550 -> 262550
	- involucrado_hecho: 256927 -> 257927
- Verificacion de rango cargado (2001..3000): 1000 registros presentes
- Idempotencia puntual: re-ejecutado `110_agraviados_part_04.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 3000`.

## Batch 110 - Agraviados (avance adicional 3)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 3000
- Estado actual: parcial cargado 1 a 4000
- Rango pendiente: 4001 a 444513
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch4_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b4/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b4` (01..04)
- Conteos antes/despues de este avance:
	- persona: 263543 -> 264543
	- hecho: 262550 -> 263550
	- involucrado_hecho: 257927 -> 258927
- Verificacion de rango cargado (3001..4000): 1000 registros presentes
- Idempotencia puntual: re-ejecutado `110_agraviados_part_01.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 4000`.

## Batch 110 - Agraviados (avance adicional 4)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 4000
- Estado actual: parcial cargado 1 a 5000
- Rango pendiente: 5001 a 444513
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch5_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b5/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b5` (01..04)
- Conteos antes/despues de este avance:
	- persona: 264543 -> 265543
	- hecho: 263550 -> 264550
	- involucrado_hecho: 258927 -> 259927
- Verificacion de rango cargado (4001..5000): 1000 registros presentes
- Idempotencia puntual: re-ejecutado `110_agraviados_part_04.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 5000`.

## Batch 110 - Agraviados (avance adicional 5)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 5000
- Estado actual: parcial cargado 1 a 6000
- Rango pendiente: 6001 a 444513
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch6_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b6/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b6` (01..04)
- Conteos antes/despues de este avance:
	- persona: 265543 -> 266543
	- hecho: 264550 -> 265550
	- involucrado_hecho: 259927 -> 260927
- Verificacion de rango cargado (5001..6000): 1000 registros presentes
- Idempotencia puntual: re-ejecutado `110_agraviados_part_01.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 6000`.

## Batch 110 - Agraviados (avance adicional 6)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 6000
- Estado actual: parcial cargado 1 a 7000
- Rango pendiente: 7001 a 444513
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch7_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b7/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b7` (01..04)
- Conteos antes/despues de este avance:
	- persona: 266543 -> 267543
	- hecho: 265550 -> 266550
	- involucrado_hecho: 260927 -> 261927
- Verificacion de rango cargado (6001..7000): 1000 registros presentes
- Idempotencia puntual: re-ejecutado `110_agraviados_part_04.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 7000`.

## Batch 110 - Agraviados (avance adicional 7)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 7000
- Estado actual: parcial cargado 1 a 8000
- Rango pendiente: 8001 a 444513
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch8_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b8/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b8` (01..04)
- Conteos antes/despues de este avance:
	- persona: 267793 -> 268543
	- hecho: 266800 -> 267550
	- involucrado_hecho: 262177 -> 262927
- Verificacion de rango cargado (7001..8000): 1000 registros presentes
- Idempotencia puntual: re-ejecutado `110_agraviados_part_04.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 8000`.

## Batch 110 - Agraviados (avance adicional 8)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 8000
- Estado actual: parcial cargado 1 a 9000
- Rango pendiente: 9001 a 444513
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch9_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b9/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b9` (01..04)
- Conteos antes/despues de este avance:
	- persona: 268543 -> 269543
	- hecho: 267550 -> 268550
	- involucrado_hecho: 262927 -> 263927
- Verificacion de rango cargado (8001..9000): 1000 registros presentes
- Idempotencia puntual: re-ejecutado `110_agraviados_part_04.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 9000`.

## Batch 110 - Agraviados (avance adicional 9)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 9000
- Estado actual: parcial cargado 1 a 10000
- Rango pendiente: 10001 a 444513
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch10_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b10/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b10` (01..04)
- Conteos antes/despues de este avance:
	- persona: 269543 -> 270543
	- hecho: 268550 -> 269550
	- involucrado_hecho: 263927 -> 264927
- Verificacion de rango cargado (9001..10000): 1000 registros presentes
- Idempotencia puntual: re-ejecutado `110_agraviados_part_04.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 10000`.

## Batch 110 - Agraviados (avance adicional 10)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 10000
- Estado actual: parcial cargado 1 a 11000
- Rango pendiente: 11001 a 444513
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch11_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b11/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b11` (01..04)
- Conteos antes/despues de este avance:
	- persona: 270543 -> 271542
	- hecho: 269550 -> 270549
	- involucrado_hecho: 264927 -> 265926
- Verificacion de rango cargado (10001..11000): 999 registros presentes
- Observacion: el generador reporto 1 fila omitida en este tramo; se conserva la trazabilidad del rango y no se detecto duplicacion en la reejecucion.
- Idempotencia puntual: re-ejecutado `110_agraviados_part_04.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 11000`.

## Batch 110 - Agraviados (avance adicional 11)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 11000
- Estado actual: parcial cargado 1 a 12000
- Rango pendiente: 12001 a 444513
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch12_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b12/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b12` (01..04)
- Conteos antes/despues de este avance:
	- persona: 271542 -> 272542
	- hecho: 270549 -> 271549
	- involucrado_hecho: 265926 -> 266926
- Verificacion de rango cargado (11001..12000): 1000 registros presentes
- Idempotencia puntual: re-ejecutado `110_agraviados_part_04.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 12000`.

## Batch 110 - Agraviados (avance adicional 12)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 12000
- Estado actual: parcial cargado 1 a 13000
- Rango pendiente: 13001 a 444513
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch13_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b13/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b13` (01..04)
- Conteos antes/despues de este avance:
	- persona: 272542 -> 273540
	- hecho: 271549 -> 272547
	- involucrado_hecho: 266926 -> 267924
- Verificacion de rango cargado (12001..13000): 998 registros presentes
- Observacion: el generador reporto 2 filas omitidas en este tramo; se conserva la trazabilidad del rango y no se detecto duplicacion en la reejecucion.
- Idempotencia puntual: re-ejecutado `110_agraviados_part_04.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 13000`.

## Batch 110 - Agraviados (avance adicional 13)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 13000
- Estado actual: parcial cargado 1 a 14000
- Rango pendiente: 14001 a 444513
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch14_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b14/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b14` (01..04)
- Conteos antes/despues de este avance:
	- persona: 273540 -> 274540
	- hecho: 272547 -> 273547
	- involucrado_hecho: 267924 -> 268924
- Verificacion de rango cargado (13001..14000): 1000 registros presentes
- Idempotencia puntual: re-ejecutado `110_agraviados_part_04.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 14000`.

## Batch 110 - Agraviados (avance adicional 14)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 14000
- Estado actual: parcial cargado 1 a 15000
- Rango pendiente: 15001 a 444513
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch15_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b15/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b15` (01..04)
- Conteos antes/despues de este avance:
	- persona: 274540 -> 275540
	- hecho: 273547 -> 274547
	- involucrado_hecho: 268924 -> 269924
- Verificacion de rango cargado (14001..15000): 1000 registros presentes
- Idempotencia puntual: re-ejecutado `110_agraviados_part_04.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 15000`.

## Batch 110 - Agraviados (avance adicional 15)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 15000
- Estado actual: parcial cargado 1 a 16000
- Rango pendiente: 16001 a 444513
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch16_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b16/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b16` (01..04)
- Conteos antes/despues de este avance:
	- persona: 275540 -> 276540
	- hecho: 274547 -> 275547
	- involucrado_hecho: 269924 -> 270924
- Verificacion de rango cargado (15001..16000): 1000 registros presentes
- Idempotencia puntual: re-ejecutado `110_agraviados_part_04.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 16000`.

## Batch 110 - Agraviados (avance adicional 16)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 16000
- Estado actual: parcial cargado 1 a 17000
- Rango pendiente: 17001 a 444513
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch17_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b17/110_agraviados_part_01.sql` a `..._04.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b17` (01..04)
- Conteos antes/despues de este avance:
	- persona: 276540 -> 277540
	- hecho: 275547 -> 276547
	- involucrado_hecho: 270924 -> 271924
- Verificacion de rango cargado (16001..17000): 1000 registros presentes
- Idempotencia puntual: re-ejecutado `110_agraviados_part_04.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 17000`.

## Batch 110 - Agraviados (avance adicional 17)
- Fuente: datos_base/Violencia/Hechos-Delicitivos/Agraviados/agraviados.xlsx
- Estado anterior: parcial cargado 1 a 17000
- Estado actual: parcial cargado 1 a 19000
- Rango pendiente: 19001 a 444513
- Tamaño de carga: 2000 filas candidatas
- SQL generado para este avance:
	- Transaccional: `sql/inserts/transaccional/110_agraviados_batch18_parcial.sql`
	- Chunks: `sql/inserts/transaccional/chunks_110_b18/110_agraviados_part_01.sql` a `..._08.sql`
- Ejecucion realizada: catalogos `066/067/068` + chunks `110_b18` (01..08)
- Conteos antes/despues de este avance:
	- persona: 277540 -> 279538
	- hecho: 276547 -> 278545
	- involucrado_hecho: 271924 -> 273922
- Verificacion de rango cargado (17001..19000): 1998 registros presentes
- Observacion: el generador reporto 2 filas omitidas en este tramo; se confirma que el lote mas grande funciona y sigue siendo idempotente.
- Idempotencia puntual: re-ejecutado `110_agraviados_part_08.sql` sin incremento.
- Siguiente accion sugerida: generar/ejecutar siguiente tramo desde `START_INDEX = 19000`.

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
