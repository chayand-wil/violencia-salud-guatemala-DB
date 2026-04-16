SET NAMES UTF8;

INSERT INTO pais (id_continente, codigo, nombre) SELECT c.id_continente, 'GT', 'Guatemala' FROM continente c WHERE UPPER(c.nombre)=UPPER('America') AND NOT EXISTS (SELECT 1 FROM pais p WHERE UPPER(p.nombre)=UPPER('Guatemala'));

COMMIT;
