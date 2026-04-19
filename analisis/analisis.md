continente(
	nombre
	descripcion
);
pais(
	id_continente -- continente
	codigo
	nombre
);
departamento(
	id_pais -- pais
	codigo
	nombre
);
municipio(
	id_departamento -- departamento
	codigo
	nombre
);
area_geografica(
	nombre
	descripcion
);

genero(
	nombre
	descripcion
);
orientacion_sexual(
	nombre
	descripcion
);
grupo_etnico(
	nombre
	descripcion
);
estado_civil(
	nombre
	descripcion
);
profesion(
	nombre
	descripcion
);
tipo_fallo(
	nombre
	descripcion
);

tipo_discriminacion(
	nombre
	descripcion
);

 
nivel_escolaridad(
	nombre
	orden
);
condicion_alfabetica(
	nombre
	descripcion
);
involucramiento(
	nombre
	descripcion
);

idioma_lengua(
	nombre
	familia_linguistica
);

estado_ebriedad(
	nombre
	descripcion
);

tipo_hecho(
	nombre
	descripcion
);
tipo_institucion(
	nombre
	descripcion
);

tipo_sentencia(
	nombre
	descripcion
);

institucion_organicacion(
	nombre_institucion
	id_tipo_institucion -- tipo_institucion
);

tipo_falta(
	codigo
	nombre
	descripcion
	activo
);
delito(
	codigo
	nombre
	bien_juridico
	activo
);
clasificacion_delito(
	codigo
	nombre
	descripcion
	activo
);

delito_cometido(
	id_tipo_delito -- delito
	id_clasificacion_delito -- clasificacion_delito
);

ocupacion(
	nombre_ocupacion
	descripcion
	id_ocupacion_clasificacion -- ocupacion_clasificacion
);

ocupacion_clasificacion(
    nombre_clasificacion
    observaciones
);

persona_ocupacion(
	id_persona -- persona
	id_ocupacion -- ocupacion
	fecha_inicio
	fecha_fin
	fuente
);

tipo_residencia(
	nombre
	descripcion
);


ubicacion(
	id_municipio -- municipio
	id_area_geografica -- area_geografica
	ciudad
	zona
	direccion_referencia
);

residencia_persona(
	id_persona -- persona
	id_ubicacion -- ubicacion
	id_tipo_residencia -- tipo_residencia
	fecha_inicio
	fecha_fin
);

persona(
	Nombres
	apellidos
	fecha_nacimiento
	cui
	id_genero -- genero
	id_orientacion_sexual -- orientacion_sexual
	id_grupo_etnico -- grupo_etnico
	id_estado_civil -- estado_civil
	id_condicion_alfabetica -- condicion_alfabetica
	id_nivel_escolaridad  -- nivel_escolaridad
	id_origen -- ubicacion
	es_extranjero
);

idioma_persona(
	id_persona -- persona
	id_lengua -- idioma_lengua
);

hecho(
	id_tipo_hecho -- tipo_hecho
	id_ubicacion -- ubicacion
	fecha_hecho
);

falta(
	id_hecho -- hecho
	id_tipo_falta -- tipo_falta
);

hecho_delictivo( 
	id_hecho -- hecho
	id_delito -- delito_cometido
);

involucrado_hecho(
	id_hecho -- hecho
	id_involucrado -- persona
	id_tipo_involucramiento -- involucramiento
);

estado_denuncia(
	nombre
	descripcion
	es_procesada
);

denuncia(
	id_hecho -- hecho
	fecha_denuncia
	id_estado_denuncia -- estado_denuncia
	id_entididad_denuncia -- institucion_organicacion
);

denuncia_estado_historial(
	id_denuncia -- denuncia
	id_estado_denuncia -- estado_denuncia
	fecha_estado
	observaciones
);


clasificacion_evaluacion(
	nombre
	descripcion
);

evaluacion_medica_inacif(
	id_hecho -- hecho
	id_persona -- persona
	id_clasificacion_evaluacion -- clasificacion_evaluacion
);


causa_muerte(
	nombre 
	descripcion
);

necropsia(
	id_hecho -- hecho
	id_persona -- persona
	id_causa_muerte -- causa_muerte
);	

sentencia(
	fecha_sentencia
	id_institucion_organicacion -- institucion_organicacion
	id_persona -- persona
	id_tipo_fallo -- tipo_fallo
	id_delito -- delito
	id_involucramiento -- involucramiento
	id_tipo_sentencia -- tipo_sentencia
);

sentencia_hecho(
	id_sentencia -- sentencia
	id_hecho -- hecho
);

sede(
	id_institucion_organicacion -- institucion_organicacion
	descripcion
	id_ubicacion -- municipio
);

tipo_atencion(
	nombre
	descripcion
);

atencion_victima(
	id_hecho -- hecho
	id_sede -- sede
	id_victima -- persona
	id_tipo_delito_atendido -- delito
	id_atencion_brindada -- tipo_atencion
);


estado_caso(
	nombre
	descripcion
);

caso_mp(
	id_estado_caso -- estado_caso
	id_delito_cometido -- delito_cometido
);

medida_seguridad(
	id_hecho -- hecho
	id_institucion_organicacion -- institucion_organicacion
);

violencia_estructural(
	id_hecho -- hecho
	id_victima -- persona
	id_tipo_discriminacion -- tipo_discriminacion
);
 








tipo_agresion_ninez(
	nombre
	descripcion
);

estado_escolarizacion(
	nombre
	descripcion
	es_escolarizado
);

sector_economico(
	nombre
	descripcion
);

tipo_trabajo_infantil(
	nombre
	descripcion
);

caso_violencia_ninez(
	id_hecho -- hecho
	id_victima -- persona
	id_tipo_agresion_ninez -- tipo_agresion_ninez
	id_estado_escolarizacion -- estado_escolarizacion
	relacionado_trabajo_infantil
);

caso_ninez_trabajo_infantil(
	id_caso_violencia_ninez -- caso_violencia_ninez
	id_sector_economico -- sector_economico
	id_tipo_trabajo_infantil -- tipo_trabajo_infantil
	horas_semanales
);

embarazo_adolescente(
	id_hecho -- hecho
	id_persona -- persona
	edad_gestante
	semana_gestacion
);


queja_agresion_ninez(
	id_departamento_registro -- departamento
	id_tipo_agresion -- tipo_agresion_ninez
);






tipo_agresion_intrafamiliar(
	nombre
	descripcion
);

tipo_medida_seguridad(
	nombre
	descripcion
);
articulo_legal(
	codigo
	nombre
	ambito_legal
	descripcion
	activo
);

caso_violencia_intrafamiliar(
	numero_boleta
	id_hecho -- hecho
	fecha_emision
	id_tipo_agresion_intrafamiliar -- tipo_agresion_intrafamiliar
	id_victima -- persona
	id_agresor_principal -- persona
	quien_reporta
	otras_victimas_total
	agresores_otros_total
	organismo_jurisdiccional
	conducente
	ley_aplicable
	id_institucion_organicacion -- institucion_organicacion
);

caso_vif_articulo_legal(
	id_caso_violencia_intrafamiliar -- caso_violencia_intrafamiliar
	id_articulo_legal -- articulo_legal
);

caso_vif_medida_seguridad(
	id_caso_violencia_intrafamiliar -- caso_violencia_intrafamiliar
	id_tipo_medida_seguridad -- tipo_medida_seguridad
);

hogar(
	id_ubicacion -- ubicacion
	tipo_hogar
	descripcion
);

persona_hogar(
	id_persona -- persona
	id_hogar -- hogar
	fecha_inicio
	fecha_fin
	parentesco_referencia
);

caso_vif_hogar(
	id_caso_violencia_intrafamiliar -- caso_violencia_intrafamiliar
	id_hogar -- hogar
);






tipo_diagnostico(
	nombre
	descripcion
);


diagnostico(
	nombre	
	CIE-10
	id_tipo_diagnostico -- tipo_diagnostico
);

 
 persona_diagnostico(
	id_diagnostico -- diagnostico
	id_genero -- genero	
	id_municipio -- municipio
	id_area_geografica -- area_geografica
	cantidad
	edad
	fecha_diagnostico
);



<!-- fuente_salud(
	nombre
	descripcion
);
grupo_etario_salud(
	nombre
	orden
);

denominador_poblacional(
	id_ubicacion -- ubicacion
	anio_referencia
	id_grupo_etario_salud -- grupo_etario_salud
	id_genero -- genero
	total_poblacion
	fuente
);

condicion_salud(
	codigo_cie10
	nombre
);

registro_salud(
	id_fuente_salud -- fuente_salud
	id_ubicacion -- ubicacion
	anio_registro
	id_grupo_etario_salud -- grupo_etario_salud
	id_genero -- genero
	id_condicion_salud -- condicion_salud
	casos
); -->

		



