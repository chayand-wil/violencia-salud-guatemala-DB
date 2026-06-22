# Mapeo inicial para terminar la DB (2 archivos)

## Fuentes usadas
- Hechos Delictivos - Agraviados:
  - Violencia/Hechos-Delicitivos/Agraviados/20240528163342pWf6BcBWj8taVS3Q3mRKxgDsvwPejgH8.xlsx
- Faltas judiciales:
  - Violencia/Faltas judiciales/20240524231759eHmz6DmFKboNQ5Y3OlqNkbi9izmXULaP.xlsx

## Entidades de tu modelo que ya se pueden poblar
- departamento
- municipio
- area_geografica
- genero
- grupo_etnico
- estado_civil
- clasificacion_ocupacion
- nivel_escolaridad
- condicion_alfabetica
- estado_ebriedad
- pais
- ubicacion
- persona
- tipo_hecho
- tipo_falta
- delito
- hecho
- falta
- denuncia

## Criterio de diseño
- La prioridad ahora es 3FN estricta.
- Eso implica no duplicar atributos derivables entre tablas.
- Si un dato se puede obtener por una relación ya existente, no debe repetirse en otra entidad final.
- Los valores usados solo para carga, limpieza o inferencia deben vivir en staging, no en el modelo final.

## Mapeo por fuente

### 1) Agraviados -> modelo
- hecho:
  - fecha_hecho <= ano_hecho + mes_hecho + dia_hecho (cuando sea válido)
  - id_ubicacion <= depto_ocu_hecho + mupio_ocu_hecho + zona_ocu_hecho
  - id_tipo_hecho <= valor fijo "hecho delictivo" (catálogo tipo_hecho)
- denuncia:
  - fecha_denuncia <= ano_denuncia + reg_mes + dia_denuncia
  - id_hecho <= hecho
- delito / delito_cometido:
  - delito_com -> delito.nombre
  - principales_delitos -> clasificacion de delito (si decides separar catálogo)
- persona (víctima):
  - sexo_agraviados -> genero
  - edad_agrav -> edad (temporal) o derivar fecha_nacimiento aproximada con año_hecho
  - est_conyugal -> estado_civil
  - otros campos no vienen directos (nombres/apellidos)

### 2) Faltas judiciales -> modelo
- falta:
  - fecha_boleta <= ano_boleta + mes_boleta + dia estimado (si no hay día, usar 01 y marcar aproximada)
  - id_tipo_falta <= falta_inf
  - id_ubicacion <= depto_boleta + muni_boleta
  - id_persona <= persona del infractor
- persona (infractor):
  - sexo_inf -> genero
  - grupo_etnico_inf -> grupo_etnico
  - est_conyugal_inf -> estado_civil
  - cond_alfabetismo_inf -> condicion_alfabetica
  - niv_escolaridad_inf -> nivel_escolaridad
  - nacionalidad_inf -> pais
  - nacimiento_inf / depto_nacimiento_inf -> id_origen (ubicacion)
- ocupacion:
  - g_primarios + subg_principales + gran_grupos -> clasificacion_ocupacion
- estado_ebriedad:
  - est_ebriedad_inf -> estado_ebriedad
- area_geografica:
  - area_geo_inf -> area_geografica

## Ajustes recomendados al modelo (antes de crear llaves foráneas finales)
1. delito_cometido:
   - Hoy tiene dos FK hacia delito.
   - Recomendación: crear tabla clasificacion_delito y dejar:
     - id_tipo_delito -> delito
     - id_clasificacion_delito -> clasificacion_delito

2. persona:
   - En estas fuentes no hay nombres ni apellidos reales.
   - Recomendación: dejar Nombres y apellidos como NULLABLE.

3. fecha_nacimiento en persona:
   - No viene directa, solo edad.
   - Recomendación: mantener fecha_nacimiento NULLABLE y guardar edad en campo temporal durante staging.

4. ubicacion:
   - En 3FN, `ubicacion` no debe repetir `id_departamento` si ese dato ya se obtiene por `municipio`.
   - La jerarquía geográfica final debe quedar así:
     - `departamento` -> catálogo padre.
     - `municipio` -> depende de `departamento`.
     - `ubicacion` -> depende de `municipio` y opcionalmente de `area_geografica`.
   - Por tanto, `id_departamento` debe eliminarse de `ubicacion` en el modelo final.
   - Si necesitas ese valor durante la carga, úsalo solo en una tabla staging o calculado en el ETL, pero no persistido en la tabla normalizada.
   - Esto evita anomalías de actualización y mantiene una sola fuente de verdad para la geografía.

5. denuncia y víctimas múltiples:
   - En hechos delictivos puede existir más de una víctima por hecho.
  - Si detectas varios registros de víctima asociados al mismo hecho, agrega tabla puente hecho_victima.
  - Si por ahora solo vas a manejar una víctima por denuncia, la tabla denuncia puede seguir apuntando a una sola persona, pero no asumas que esa restricción será suficiente para todos los archivos futuros.

## Orden de carga sugerido
1. Catálogos base (genero, estado_civil, grupo_etnico, etc.).
2. Geografía (departamento, municipio, area_geografica, ubicacion).
3. Persona.
4. Delito y tipo_falta/tipo_hecho.
5. Hecho y falta.
6. Denuncia y tablas puente.

## Regla clave para integración
- No usar num_corre como PK global entre fuentes.
- Usar llave técnica por tabla (id bigint identity).
- Mantener num_corre como campo de rastreo por fuente (source_record_id).
