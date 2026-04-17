# Resumen de campos abstraidos y uso en cargas

Bitacora breve de los campos principales detectados en cada fuente y de las tablas destino que se alimentaron.

## Reglas de modelado usadas (cuando faltan datos)
- Objetivo: que cada registro fuente quede representado en el modelo relacional, aunque la fuente venga incompleta.
- Orden base de creacion: ubicacion -> catalogos de referencia -> persona (si aplica) -> hecho -> tabla transaccional especifica de la fuente.
- Si no hay municipio exacto: se usa un municipio valido del departamento segun catalogo territorial.
- Si no hay atributos completos de persona: se crea persona sintetica con valores controlados (ej. estado/alfabetismo/escolaridad ignorado) para mantener trazabilidad.
- Si la fuente viene agregada por conteo (`valor`): se generan tantos eventos/personas sinteticas como indique el conteo.
- Idempotencia: los scripts validan existencia previa (claves sinteticas o `NOT EXISTS`) antes de insertar.

## Como leer el flujo por fuente
- `flujo`: orden de insercion logica para esa fuente.
- `minimo que se garantiza`: entidades que siempre se crean para que el dato tenga sentido analitico.
- `cuando falta data`: decision aplicada para no romper relaciones.

## Batch 101 - Faltas judiciales
- Campos clave: fecha, departamento/municipio, tipo de falta, ley, titulo, capitulo, descripcion, personas involucradas.
- Uso principal: `falta`, `hecho`, `persona`, `involucrado_hecho` y catalogos derivados de faltas.
- Flujo: catalogos falta -> ubicacion -> persona -> hecho -> involucramiento -> falta.
- Minimo que se garantiza: cada fila termina representada en `hecho` y `falta`.
- Cuando falta data: se conserva la relacion con persona sintetica y valores desconocido donde aplica.

## Batch 102 - Hechos delictivos VCM
- Campos clave: fecha, lugar del hecho, clasificacion del delito, delito observado, delito homologado, persona victima, involucramiento.
- Uso principal: `hecho_delictivo`, `hecho`, `persona`, `involucrado_hecho` y catalogos de clasificacion/delito.
- Flujo: clasificacion/delito -> ubicacion -> persona -> hecho -> involucrado_hecho -> hecho_delictivo.
- Minimo que se garantiza: existe un `hecho` y su clasificacion delictiva homologada.
- Cuando falta data: se completa identidad parcial de persona con defaults para preservar relacion hecho-persona.

## Batch 103 - Medidas de seguridad
- Campos clave: fecha, institucion, despacho, ubicacion territorial, tipo de medida, registro de caso.
- Uso principal: `medida_seguridad`, `hecho`, `sede`, `institucion_organicacion` y catalogos de institucion/despacho.
- Flujo: tipo_institucion/institucion/sede -> ubicacion -> hecho -> medida_seguridad.
- Minimo que se garantiza: cada registro de fuente produce un `hecho` ligado a institucion/sede.
- Cuando falta data: despacho o descripcion se normaliza/trunca a limites de Firebird sin perder llave de relacion.

## Batch 104 - Sentencias MP VCM
- Campos clave: fecha, fiscalia/institucion, tipo de sentencia, resultado, delito, lugar y conteo por fila.
- Uso principal: `sentencia_mp`, `hecho`, `persona`, `institucion_mp` y `tipo_sentencia_vcm`.
- Flujo: catalogos MP (institucion/tipo sentencia/delito) -> ubicacion -> persona -> hecho -> sentencia_mp.
- Minimo que se garantiza: siempre hay `hecho` y sentencia asociados.
- Cuando falta data: en filas agregadas se sintetizan personas/eventos segun conteo.

## Batch 105 - Sentencias OJ VCM
- Campos clave: fecha, organo judicial, despacho, tipo de fallo, delito, ubicacion y conteo por fila.
- Uso principal: `sentencia_oj`, `hecho`, `persona`, `institucion_oj`, `tipo_fallo_absolutoria` y catalogos de delito.
- Flujo: catalogos OJ (institucion/fallo/delito) -> ubicacion -> persona -> hecho -> sentencia_oj.
- Minimo que se garantiza: registro de sentencia con delito y hecho vinculado.
- Cuando falta data: despacho o delito se homologa a catalogo y el evento no se descarta.

## Batch 106 - Atencion brindada Instituto de la Victima
- Campos clave: fecha de atencion, sede de la atencion, departamento y municipio de sede, tipo de delito atendido, atencion brindada, departamento/municipio de procedencia de la victima, edad, grupo etnico, orientacion sexual y valor.
- Uso principal: `atencion_victima`, `hecho`, `persona`, `sede`, `tipo_atencion`, `delito`, `grupo_etnico`, `orientacion_sexual`, `institucion_organicacion`.
- Observacion: el archivo alimenta 2020-2023 con estructura uniforme, pero ya se valido que la fuente de violencia estructural siguiente usa hojas heterogeneas y requiere lectura por hoja.
- Flujo: tipo_institucion/institucion -> sede -> tipo_atencion/delito -> ubicacion sede y origen -> persona -> hecho -> atencion_victima.
- Minimo que se garantiza: atencion registrada con victima y hecho asociados.
- Cuando falta data: origen de victima cae a sede/departamento disponible y se usan defaults de catalogos personales.

## Batch 107 - Violencia estructural
- Fuente: `CASOS DISCRIMINACIÓN 2016-2023.xls`.
- Encaje: `violencia_estructural -> hecho + persona + tipo_discriminacion`.
- Campos clave: sexo, edad, departamento/municipio del hecho, tipo de discriminacion, pueblo de pertenencia, comunidad linguistica y anio.
- Uso principal: `violencia_estructural`, `hecho`, `persona`, `idioma_persona`, `tipo_discriminacion`, `idioma_lengua`, `grupo_etnico`.
- Regla aplicada: hojas 2016-2019 con filas directas y hoja 2019 con una fila de 3 casos; hojas 2020-2023 con columnas marca para `Maya/Garifuna/Xinka`.
- Flujo: tipo_discriminacion/idioma_lengua/grupo_etnico -> ubicacion -> persona -> hecho -> violencia_estructural -> idioma_persona.
- Minimo que se garantiza: si hay caso valido, se crea persona y se crea hecho antes de `violencia_estructural`.
- Cuando falta data: si persona viene incompleta, se crea con atributos minimos y defaults; si fila trae conteo agregado, se expande a multiples personas/hechos.

## Batch 109 - PNC victimas (parcial)
- Fuente: `pnc_victimas.xlsx` (solo `Sheet1` con datos; `Sheet2` y `Sheet3` vacias).
- Campos clave: numero correlativo, anio/mes/dia del hecho, departamento/municipio, sexo, zona, edad, delito cometido y grupo delictivo.
- Uso principal: `persona`, `hecho`, `involucrado_hecho`, `hecho_delictivo`, `ubicacion`, y catalogos `clasificacion_delito`/`delito`/`delito_cometido`.
- Flujo: clasificacion/delito -> ubicacion -> persona sintetica -> hecho (`hecho_delictivo`) -> involucrado_hecho (`Agraviado`) -> hecho_delictivo.
- Minimo que se garantiza: por cada fila valida se crea una persona sintetica `PNCVIC_YYYY_NNNNNN` y un hecho asociado.
- Cuando falta data: municipio cae a cabecera del departamento (regla territorial); genero fuera de catalogo cae a `Ignorado`; dia se acota a 1..28 para fecha valida.
- Estrategia de tamano: se ejecuto carga parcial de 15000 filas y se generaron chunks transaccionales para ejecucion segura (`sql/inserts/transaccional/chunks_109`).

## Batch 110 - Agraviados (parcial)
- Fuente: `agraviados.xlsx` (solo `Sheet1` con datos; `Sheet2` y `Sheet3` vacias).
- Campos clave: fecha de denuncia y hecho, departamento/municipio del hecho, zona, edad, sexo, estado conyugal, delito cometido y clasificacion principal.
- Uso principal: `persona`, `hecho`, `involucrado_hecho`, `hecho_delictivo`, `ubicacion`, y catalogos `clasificacion_delito`/`delito`/`delito_cometido`.
- Flujo: clasificacion/delito -> ubicacion -> persona sintetica -> hecho -> involucrado_hecho (`Agraviado`) -> hecho_delictivo.
- Minimo que se garantiza: por cada fila valida del parcial se crea una persona sintetica `AGR_YYYY_NNNNNN` y un hecho asociado.
- Cuando falta data: municipio cae a cabecera del departamento; sexo fuera de catalogo cae a `Ignorado`; edad se acota para derivar fecha de nacimiento plausible.
- Estrategia de tamano: se ejecuto carga parcial de 1000 filas y se generaron chunks transaccionales para ejecucion segura (`sql/inserts/transaccional/chunks_110`).

## Batch 111 - Sindicados (parcial)
- Fuente: `sindicados.xlsx` (solo `Sheet1` con datos; `Sheet2` y `Sheet3` vacias).
- Campos clave: fecha de denuncia y hecho, departamento/municipio del hecho, zona, sexo, edad de sindicado, estado conyugal, delito cometido y clasificacion principal.
- Uso principal: `persona`, `hecho`, `involucrado_hecho`, `hecho_delictivo`, `ubicacion`, y catalogos `involucramiento`/`clasificacion_delito`/`delito`/`delito_cometido`.
- Flujo: catalogos -> ubicacion -> persona sintetica -> hecho -> involucrado_hecho (`Sindicado`) -> hecho_delictivo.
- Minimo que se garantiza: por cada fila valida del parcial se crea una persona sintetica `SIN_YYYY_NNNNNN` y un hecho asociado.
- Cuando falta data: municipio cae a cabecera del departamento; genero fuera de catalogo cae a `Ignorado`; estado civil sin match cae a `Ignorado`.
- Estrategia de tamano: se ejecuto carga parcial de 1000 filas y se generaron chunks transaccionales para ejecucion segura (`sql/inserts/transaccional/chunks_111`).

## Batch 112 - Necropsias (parcial)
- Fuente: `necropsias.xlsx` (solo `Sheet1` con datos; `Sheet2` y `Sheet3` vacias).
- Campos clave: fecha de ingreso, departamento/municipio, edad, sexo y causa de muerte.
- Uso principal: `persona`, `hecho`, `involucrado_hecho`, `hecho_delictivo`, `ubicacion`, y catalogos `clasificacion_delito`/`delito`/`delito_cometido` para causa de muerte.
- Flujo: catalogos (causa de muerte) -> ubicacion -> persona sintetica -> hecho -> involucrado_hecho (`Agraviado`) -> hecho_delictivo.
- Minimo que se garantiza: por cada fila valida del parcial se crea una persona sintetica `NEC_YYYY_NNNNNN` y un hecho asociado.
- Cuando falta data: municipio cae a cabecera del departamento; genero fuera de catalogo cae a `Ignorado`; edad se acota para derivar fecha de nacimiento plausible.
- Estrategia de tamano: se ejecuto carga parcial de 1000 filas y se generaron chunks transaccionales para ejecucion segura (`sql/inserts/transaccional/chunks_112`).

## Batch 113 - Exhumaciones (parcial)
- Fuente: `exhumaciones.xlsx` (solo `Sheet1` con datos; `Sheet2` y `Sheet3` vacias).
- Campos clave: anio/mes/dia de ocurrencia y departamento de ocurrencia.
- Uso principal: `persona`, `hecho`, `involucrado_hecho`, `hecho_delictivo`, `ubicacion`, y catalogos base para clasificar el evento de exhumacion.
- Flujo: catalogos (Exhumacion) -> ubicacion -> persona sintetica -> hecho -> involucrado_hecho (`Agraviado`) -> hecho_delictivo.
- Minimo que se garantiza: por cada fila valida del parcial se crea una persona sintetica `EXH_YYYY_NNNNNN` y un hecho asociado.
- Cuando falta data: municipio se resuelve con cabecera del departamento; atributos personales no presentes se normalizan a `Ignorado`.
- Estrategia de tamano: se ejecuto carga parcial de 60 filas y se generaron chunks transaccionales para ejecucion segura (`sql/inserts/transaccional/chunks_113`).

## Batch 114 - Evaluacion Medicos INACIF (parcial)
- Fuente: `medicos_inacif.xlsx` (solo `Sheet1` con datos; `Sheet2` y `Sheet3` vacias).
- Campos clave: anio/mes/dia de ocurrencia, departamento, edad, sexo y clasificacion de evaluacion (`clasif_eval`).
- Uso principal: `persona`, `hecho`, `involucrado_hecho`, `hecho_delictivo`, `ubicacion`, y catalogos `clasificacion_delito`/`delito`/`delito_cometido` derivados de `clasif_eval`.
- Flujo: catalogos de clasificacion -> ubicacion -> persona sintetica -> hecho -> involucrado_hecho (`Agraviado`) -> hecho_delictivo.
- Minimo que se garantiza: por cada fila valida del parcial se crea una persona sintetica `MED_YYYY_NNNNNN` y un hecho asociado.
- Cuando falta data: municipio se resuelve con cabecera del departamento; `clasif_eval` vacio cae a `Otros`; atributos faltantes de persona se normalizan a `Ignorado`.
- Estrategia de tamano: se ejecuto carga parcial de 1000 filas y se generaron chunks transaccionales para ejecucion segura (`sql/inserts/transaccional/chunks_114`).

## Batch 115 - Sentenciados OJ (parcial)
- Fuente: `sentenciados.xlsx` (solo `Sheet1` con datos; `Sheet2` y `Sheet3` vacias).
- Campos clave: numero correlativo, anio/mes de registro, mayoria de edad (`men_may`), sexo, nacionalidad, involucramiento, tipo de fallo, departamento, delito y jerarquia legal (`tip_ley`/`titulo`/`capitulo`).
- Uso principal: `persona`, `hecho`, `involucrado_hecho`, `hecho_delictivo`, `ubicacion`, y catalogos `clasificacion_delito`/`delito`/`delito_cometido` + extensiones de `involucramiento` y `tipo_fallo`.
- Flujo: catalogos (clasificacion/delito/involucramiento/fallo) -> ubicacion -> persona sintetica -> hecho -> involucrado_hecho (rol fuente) -> hecho_delictivo.
- Minimo que se garantiza: por cada fila valida del parcial se crea una persona sintetica `SEN_YYYY_NNNNNN` y un hecho asociado.
- Cuando falta data: municipio cae a cabecera del departamento; si nacionalidad no es guatemalteca se marca `es_extranjero = 1`; edad se aproxima con `men_may` para fecha de nacimiento plausible.
- Estrategia de tamano: se ejecuto carga parcial de 1000 filas y se generaron chunks transaccionales para ejecucion segura (`sql/inserts/transaccional/chunks_115`).

## Batch 116 - Violencia intrafamiliar 2023 (parcial cargado)
- Fuente: `violencia_intrafamiliar.xlsx` (hoja `Base VIF 2023`).
- Campos clave: fecha del hecho (`HEC_DIA/HEC_MES/HEC_ANO`), ubicacion (`HEC_DEPTO`/`HEC_DEPTOMCPIO`), tipo de agresion (`HEC_TIPAGRE`), boleta (`NUMERO_BOLETA`), fecha de emision, sexo/edad de victima y agresor, quien reporta y totales adicionales.
- Uso principal: `tipo_agresion_intrafamiliar`, `caso_violencia_intrafamiliar`, `hecho`, `persona`, `involucrado_hecho`, `ubicacion`.
- Flujo: catalogos VIF -> ubicacion -> victima/agresor sinteticos -> hecho (`violencia_intrafamiliar`) -> involucrado_hecho (Victima/Agresor) -> caso_violencia_intrafamiliar.
- Minimo que se garantiza: cada fila valida del parcial genera un hecho y un caso VIF con victima y agresor enlazados.
- Cuando falta data: municipio cae a cabecera del departamento; sexo fuera de catalogo cae a `Ignorado`; edades fuera de rango se acotan para fecha de nacimiento plausible.
- Estrategia de tamano: se cargo parcial de 500 filas con chunks (`sql/inserts/transaccional/chunks_116`).
- Idempotencia: re-ejecutado sin incremento de conteos.

## Batch 117 - Quejas Mineduc 2023 (parcial cargado)
- Fuente: `20240719123138C8M6SpIQkU1dO569us4WzmhiEojxPhwf.xlsx` (hoja `C1`).
- Estructura de fuente: tabla agregada por `Departamento registro` y tipo de agresion (no trae eventos individuales).
- Campos clave: departamento y conteos por tipo de agresion (`Embarazo en menor de 14 anios`, `Violencia fisica y psicologica`, `Acoso escolar`, `Acoso y hostigamiento sexual`, `Racismo y discriminacion`, `Violencia sexual`, `Abuso de autoridad`).
- Uso principal: `tipo_agresion_ninez`, `estado_escolarizacion`, `tipo_hecho`, `caso_violencia_ninez`, `hecho`, `persona`, `ubicacion`.
- Flujo: catalogos niñez -> ubicacion -> persona sintetica -> hecho -> caso_violencia_ninez.
- Minimo que se garantiza: cada evento sintetico parcial crea una victima y un caso de violencia niñez enlazado a hecho y ubicacion.
- Cuando falta data: si no hay municipio directo, se aplica cabecera municipal del departamento; edad sintetica controlada para mantener consistencia de niñez.
- Estrategia de tamano: se cargo parcial de 250 eventos sinteticos (6 departamentos) con chunks en `sql/inserts/transaccional/chunks_117`.
- Idempotencia: re-ejecutado sin incremento de conteos.

## Batch 118 - Violencia intrafamiliar 2024 (parcial cargado)
- Fuente: `base-de-datos-violencia-intrafamiliar-ano-2024_v3.xlsx` (hoja `Sheet1`).
- Campos clave: fecha del hecho (`HEC_DIA/HEC_MES/HEC_ANO`), ubicacion (`HEC_DEPTO`/`HEC_DEPTOMCPIO`), tipo de agresion (`HEC_TIPAGRE`), boleta (`NUMERO_BOLETA`), fecha de emision, sexo/edad de victima y agresor, quien reporta y totales adicionales.
- Uso principal: `tipo_agresion_intrafamiliar`, `caso_violencia_intrafamiliar`, `hecho`, `persona`, `involucrado_hecho`, `ubicacion`.
- Flujo: catalogos VIF -> ubicacion -> victima/agresor sinteticos -> hecho (`violencia_intrafamiliar`) -> involucrado_hecho (Victima/Agresor) -> caso_violencia_intrafamiliar.
- Minimo que se garantiza: por cada fila valida del parcial se crea un hecho y un caso VIF con victima y agresor enlazados.
- Cuando falta data: municipio cae a cabecera del departamento; sexo fuera de catalogo cae a `Ignorado`; edades fuera de rango se acotan para fecha de nacimiento plausible.
- Estrategia de tamano: se cargo parcial de 500 filas con chunks (`sql/inserts/transaccional/chunks_118`).
- Idempotencia: re-ejecutado sin incremento de conteos.

## Diccionarios VIF 2023/2024 (fuente de apoyo)
- Fuentes: `2024052300613QDinUvuRa9GjopyXaTuNMXc3gd6Jq1Q1.xlsx` y `diccionario-de-variables-violencia-intrafamiliar.xlsx`.
- Estructura detectada: columnas de `Codigo`, `Descripcion del codigo`, `Valor`, `Etiqueta`.
- Uso en ETL: referencia para interpretar codigos de VIF, no para insercion transaccional directa.