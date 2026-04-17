# Consultas Propuestas Interpretadas

Fecha: 2026-04-16

## Convenciones

- Estado LISTA: se puede ejecutar hoy con datos existentes.
- Estado PARCIAL: modelo soporta, pero falta carga o normalizacion.
- Estado BLOQUEADA: requiere cambio de modelo o regla adicional.

## Matriz de interpretacion

1. Cantidad de homicidios por anio y departamento.
Interpretacion: contar hechos delictivos con delito homologado a homicidio.
Estado: LISTA.

2. Denuncias por violencia contra la mujer por municipio.
Interpretacion: denuncias de tipo_hecho hecho_delictivo, con foco en catalogo VCM.
Estado: LISTA.

3. Top 5 tipos de hechos delictivos en ultimos 5 anios.
Interpretacion: top por clasificacion_delito o delito, en ventana movil de 5 anios.
Estado: LISTA.

4. Sentencias dictadas por tipo de delito y anio.
Interpretacion: sentencia x anio(fecha_sentencia) x delito.
Estado: LISTA.

5. Promedio de edad de victimas de violencia intrafamiliar.
Interpretacion: edad al momento del hecho para id_victima en caso_violencia_intrafamiliar.
Estado: PARCIAL.

6. Distribucion de embarazos adolescentes por region.
Interpretacion: embarazo_adolescente donde edad_gestante < 19, agrupado por area_geografica/departamento.
Estado: PARCIAL.

7. Casos de violencia infantil relacionados con trabajo infantil.
Interpretacion: caso_violencia_ninez con relacionado_trabajo_infantil=1 o join a caso_ninez_trabajo_infantil.
Estado: PARCIAL.

8. Porcentaje de denuncias por discriminacion segun etnia.
Interpretacion: violencia_estructural por grupo_etnico, porcentaje del total.
Estado: LISTA.

9. Comparativa escolaridad vs tipo de falta judicial.
Interpretacion: nivel_escolaridad de persona involucrada (rol infractor) versus tipo_falta.
Estado: LISTA/PARCIAL.

10. Numero de necropsias por anio.
Interpretacion: conteo de necropsia por anio(fecha_hecho).
Estado: LISTA.

11. Tasa de violencia estructural procesadas vs no procesadas.
Interpretacion: porcentaje por bandera es_procesada o estado_denuncia asociado.
Estado: BLOQUEADA sin ajuste de modelo.

12. Relacion tipo de empleo y ocurrencia de hechos delictivos.
Interpretacion: cruces persona_ocupacion/ocupacion con hecho_delictivo via involucrado_hecho.
Estado: PARCIAL.

13. Casos VCM con sentencia firme.
Interpretacion: sentencias con tipo_fallo homologado a condenatoria/firme y tipo_sentencia VCM.
Estado: LISTA.

14. Idiomas hablados por victimas de discriminacion.
Interpretacion: idioma_persona de victimas en violencia_estructural.
Estado: PARCIAL.

15. Numero de personas por hogar en casos VIF.
Interpretacion: promedio o distribucion de miembros en hogar ligado a caso_vif_hogar.
Estado: PARCIAL.

16. Tasa de violencia infantil escolarizada vs no escolarizada.
Interpretacion: casos niñez por estado_escolarizacion(es_escolarizado) usando denominador apropiado.
Estado: PARCIAL.

17. Casos de trabajo infantil por sector economico.
Interpretacion: caso_ninez_trabajo_infantil por sector_economico.
Estado: PARCIAL.

18. Relacion edad y tipo de violencia sufrida.
Interpretacion: edad de victima en niñez/intrafamiliar/estructural.
Estado: PARCIAL.

19. Desnutricion aguda por departamento, municipio y anio.
Interpretacion: registro_salud indicador_salud='DESNUTRICION_AGUDA'.
Estado: PARCIAL.

20. Retardo en desarrollo por grupo etario, sexo y region.
Interpretacion: registro_salud indicador_salud='RETARDO_DESARROLLO'.
Estado: PARCIAL.

21. Incidencia cronicas por CIE-10.
Interpretacion: registro_salud + condicion_salud(codigo_cie10), tasa con denominador_poblacional.
Estado: PARCIAL.

22. Evolucion dengue y dengue grave 2012-2024.
Interpretacion: series temporales por indicador_salud in ('DENGUE','DENGUE_GRAVE').
Estado: PARCIAL.

23. Malaria por grupo etario y sexo municipal.
Interpretacion: registro_salud indicador_salud='MALARIA' cruzado con grupo_etario_salud y genero.
Estado: PARCIAL.

24. Desnutricion infantil vs violencia intrafamiliar por departamento.
Interpretacion: correlacion/interaccion entre salud(desnutricion) y VIF por departamento-anio.
Estado: PARCIAL.

25. Top 5 municipios Chagas+Zika+Chikungunya combinados.
Interpretacion: suma de casos para esos indicadores por municipio.
Estado: PARCIAL.

26. Vectores vs urbanizacion por departamento.
Interpretacion: casos de indicadores vectoriales versus area_geografica urbano/rural.
Estado: PARCIAL.

27. Tasa de morbilidad materna infantil por anio/departamento.
Interpretacion: casos materno-infantil / denominador_poblacional * 100000.
Estado: PARCIAL.

28. Correlacion desnutricion y hechos delictivos por municipio.
Interpretacion: matriz municipio-anio con casos_salud y hechos_delictivos para coeficiente estadistico.
Estado: PARCIAL.

29. Violencia estructural urbano vs rural.
Interpretacion: violencia_estructural por area_geografica.
Estado: LISTA/PARCIAL.

30. Frecuencia de exhumaciones por tipo de delito relacionado.
Interpretacion: exhumacion -> hecho -> hecho_delictivo -> delito.
Estado: LISTA/PARCIAL.
