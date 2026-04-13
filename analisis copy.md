continente();
pais(
	nombre
	es_extrangero
);
departamento();
municipio();
area_geografica();

genero();
grupo_etnico();
estado_civil();
profesion();
clasificacion_ocupacion(); 
nivel_escolaridad();
condicion_alfabetica();
idiomas_lenguas();
estado_ebriedad();

tipo_hecho();
tipo_falta();
delito();
clasificacion_delito();
delito_cometido(
	id_tipo_delito -- delito
	id_clasificacion_delito -- clasificacion_delito
);

ocupacion(
	id_G_primarios --clasificacion_ocupacion
	id_Subg_principales -- clasificacion_ocupacion
	id_Gran_grupos -- clasificacion_ocupacion
);

ubicacion(
	id_municipio -- municipio
	id_area_geografica -- area_geografica
	zona
	direccion_referencia
);




persona(
	Nombres
	apellidos
	fecha_nacimiento
	genero
	grupo_etnico
	estado_civil
	condicion_alfabetica
	nivel_escolaridad
	id_ubicacion -- ubicacion
	id_origen -- ubicacion
	id_nacionalidad -- pais pte

);

hecho(
	id_tipo_hecho -- tipo_hecho
	id_ubicacion -- ubicacion
	fecha_hecho
);

falta(
	id_persona -- persona
	id_tipo_falta -- tipo_falta
	id_ubicacion -- ubicacion
	fecha_boleta
);

tipo_hecho_falta(
	id_tipo_hecho -- tipo_hecho
	id_falta -- falta
);

hecho_delito(
	id_hecho -- hecho
	id_delito -- delito_cometido
);

victima_hecho(
	id_hecho -- hecho
	id_victima -- persona
);

denuncia(
	fecha_denuncia
	id_hecho -- hecho
);

detencion(
	id_hecho -- hecho
	id_detenido -- persona
);

sindicado(
	id_hecho -- hecho
	id_sindicado -- persona
);

evaluacion_medica_inacif(
	id_hecho -- hecho
	id_persona -- persona
	clasificacion_evaluacion
);

exhumacion(
	id_hecho -- hecho
);

necropsia(
	id_hecho -- hecho
	id_persona -- persona
	causa_muerte
);

sentencia(
	fecha_sentencia
	id_persona -- persona
	tipo_fallo
	involucramiento
);

sentencia_hecho(
	id_sentencia -- sentencia
	id_hecho -- hecho
);

atencion_victima(
	id_hecho -- hecho
	id_ubicacion_sede -- ubicacion
	id_ubicacion_procedencia -- ubicacion
	tipo_delito_atendido
	atencion_brindada
	orientacion_sexual
	valor
);

denuncia_registrada_vcm(
	id_denuncia -- denuncia
	rango_edad
	escolaridad
	pueblo_pertenencia
	orientacion_sexual
	estado_caso
	valor
);

delito_vida_feminicidio(
	id_hecho -- hecho
	estado_caso
	valor
);

hecho_delictivo_vcm(
	id_hecho -- hecho
	hecho_delictivo
	valor
);

medida_seguridad(
	id_hecho -- hecho
	despacho
	valor
);

sentencia_oj(
	id_sentencia -- sentencia
	despacho
	valor
);

sentencia_mp(
	id_sentencia -- sentencia
	indicador
	valor
);

		