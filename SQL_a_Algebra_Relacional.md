# SQL → ÁLGEBRA RELACIONAL
## Traducciones de Consultas SQL del Proyecto

---

## 📋 MAPEO DE OPERADORES

| SQL | Álgebra Relacional | Símbolo |
|-----|-------------------|---------|
| SELECT (columnas) | Proyección | Π |
| WHERE (condición) | Selección | σ |
| JOIN ... ON | Fusión/Join Natural | ⊲⊳ |
| UNION | Unión | ∪ |
| NOT IN / EXCEPT | Diferencia | − |
| COUNT, SUM, AVG | Agregación | 𝓕 |
| FROM tabla1, tabla2 | Producto Cartesiano | × |

---

## 🔍 CONSULTA 1: Homicidios por año y departamento

### SQL Original:
```sql
SELECT
    EXTRACT(YEAR FROM h.fecha_hecho) AS anio,
    d.nombre AS departamento,
    COUNT(*) AS total_homicidios
FROM hecho_delictivo hd
JOIN hecho h ON h.id_hecho = hd.id_hecho
JOIN ubicacion u ON u.id_ubicacion = h.id_ubicacion
JOIN municipio m ON m.id_municipio = u.id_municipio
JOIN departamento d ON d.id_departamento = m.id_departamento
JOIN delito_cometido dc ON dc.id_delito_cometido = hd.id_delito
JOIN delito de ON de.id_delito = dc.id_tipo_delito
WHERE de.nombre CONTAINING 'HOMICIDIO'
GROUP BY 1, 2
ORDER BY 1, 2;
```

### Expresión en Álgebra Relacional:

```
ℱ anio, departamento, COUNT(*) → total_homicidios (
    π anio, d.nombre, hd.* (
        σ de.nombre CONTAINING 'HOMICIDIO' (
            hecho_delictivo 
            ⊲⊳ hecho 
            ⊲⊳ ubicacion 
            ⊲⊳ municipio 
            ⊲⊳ departamento d
            ⊲⊳ delito_cometido 
            ⊲⊳ delito de
        )
    )
)
```

### Descomposición paso a paso:

1. **Selección (σ)**: Filtrar donde `delito.nombre` contiene 'HOMICIDIO'
2. **Fusiones (⊲⊳)**: Combinar todas las tablas relacionadas
3. **Proyección (π)**: Seleccionar año, departamento y conteos
4. **Agregación (ℱ)**: Contar registros agrupando por año y departamento

### Notación alternativa más legible:
```
ℱ YEAR(fecha_hecho) → anio, d.nombre → departamento, COUNT(*) → total_homicidios (
    σ delito.nombre LIKE '%HOMICIDIO%' (
        π delito_cometido.id_delito_cometido, delito.id_delito, 
          EXTRACT(YEAR FROM h.fecha_hecho), d.nombre (
            hecho_delictivo ⊲⊳_{hd.id_hecho=h.id_hecho} hecho h ⊲⊳_{h.id_ubicacion=u.id_ubicacion} 
            ubicacion u ⊲⊳_{u.id_municipio=m.id_municipio} municipio m ⊲⊳_{m.id_departamento=d.id_departamento} 
            departamento d ⊲⊳_{hd.id_delito=dc.id_delito_cometido} delito_cometido dc ⊲⊳_{dc.id_tipo_delito=de.id_delito} delito de
        )
    )
)
```

---

## 📊 CONSULTA 2: Denuncias VCM por municipio

### SQL:
```sql
SELECT
    d.nombre AS departamento,
    m.nombre AS municipio,
    COUNT(*) AS total_denuncias
FROM denuncia dn
JOIN hecho h ON h.id_hecho = dn.id_hecho
JOIN tipo_hecho th ON th.id_tipo_hecho = h.id_tipo_hecho
JOIN ubicacion u ON u.id_ubicacion = h.id_ubicacion
JOIN municipio m ON m.id_municipio = u.id_municipio
JOIN departamento d ON d.id_departamento = m.id_departamento
WHERE th.nombre CONTAINING 'MUJER' OR th.nombre CONTAINING 'VIOLENCIA CONTRA LA MUJER'
GROUP BY 1, 2
ORDER BY total_denuncias DESC;
```

### Álgebra Relacional:

```
ℱ d.nombre, m.nombre, COUNT(*) (
    σ (th.nombre ∋ 'MUJER') ∨ (th.nombre ∋ 'VIOLENCIA CONTRA LA MUJER') (
        π d.nombre, m.nombre (
            denuncia ⊲⊳_{dn.id_hecho=h.id_hecho} hecho h 
            ⊲⊳_{h.id_tipo_hecho=th.id_tipo_hecho} tipo_hecho th 
            ⊲⊳_{h.id_ubicacion=u.id_ubicacion} ubicacion u 
            ⊲⊳_{u.id_municipio=m.id_municipio} municipio m 
            ⊲⊳_{m.id_departamento=d.id_departamento} departamento d
        )
    )
)
```

---

## 🏆 CONSULTA 3: Top 5 tipos de delitos en últimos 5 años

### SQL:
```sql
SELECT FIRST 5
    cd.nombre AS clasificacion_delito,
    COUNT(*) AS total_casos
FROM hecho_delictivo hd
JOIN hecho h ON h.id_hecho = hd.id_hecho
JOIN delito_cometido dc ON dc.id_delito_cometido = hd.id_delito
JOIN clasificacion_delito cd ON cd.id_clasificacion_delito = dc.id_clasificacion_delito
WHERE h.fecha_hecho >= DATEADD(-5 YEAR TO CURRENT_DATE)
GROUP BY 1
ORDER BY total_casos DESC;
```

### Álgebra Relacional:

```
TOP(5) (
    ℱ cd.nombre, COUNT(*) → total_casos (
        σ h.fecha_hecho ≥ (TODAY() - 5 años) (
            π cd.nombre, hd.* (
                hecho_delictivo ⊲⊳_{hd.id_hecho=h.id_hecho} hecho h 
                ⊲⊳_{hd.id_delito=dc.id_delito_cometido} delito_cometido dc 
                ⊲⊳_{dc.id_clasificacion_delito=cd.id_clasificacion_delito} clasificacion_delito cd
            )
        )
    ) ordenado por total_casos DESC
)
```

---

## 📈 CONSULTA 4: Sentencias por tipo de delito y año

### SQL:
```sql
SELECT
    EXTRACT(YEAR FROM s.fecha_sentencia) AS anio,
    de.nombre AS delito,
    COUNT(*) AS total_sentencias
FROM sentencia s
LEFT JOIN delito de ON de.id_delito = s.id_delito
GROUP BY 1, 2
ORDER BY 1, total_sentencias DESC;
```

### Álgebra Relacional:

**Nota**: SQL usa `LEFT JOIN`, lo que incluye filas de `sentencia` sin delitos correspondientes.

```
ℱ EXTRACT(YEAR FROM s.fecha_sentencia) → anio, de.nombre, COUNT(*) → total_sentencias (
    sentencia s ⟕⊲⊳_{s.id_delito=de.id_delito} delito de
)
```

**Explicación**:
- `⟕⊲⊳` representa el **LEFT JOIN** (fusión externa izquierda)
- Conserva todos los registros de `sentencia` incluso sin `delito`
- Se agrupan por año y delito

---

## 👶 CONSULTA 5: Promedio edad víctimas VIF

### SQL:
```sql
SELECT
    AVG(DATEDIFF(YEAR FROM p.fecha_nacimiento TO h.fecha_hecho)) AS promedio_edad_victima
FROM caso_violencia_intrafamiliar cvi
JOIN hecho h ON h.id_hecho = cvi.id_hecho
JOIN persona p ON p.id_persona = cvi.id_victima
WHERE p.fecha_nacimiento IS NOT NULL
  AND h.fecha_hecho IS NOT NULL;
```

### Álgebra Relacional:

```
ℱ AVG(YEAR(h.fecha_hecho) - YEAR(p.fecha_nacimiento)) → promedio_edad_victima (
    σ p.fecha_nacimiento ≠ NULL ∧ h.fecha_hecho ≠ NULL (
        π cvi.*, h.*, p.* (
            caso_violencia_intrafamiliar cvi 
            ⊲⊳_{cvi.id_hecho=h.id_hecho} hecho h 
            ⊲⊳_{cvi.id_victima=p.id_persona} persona p
        )
    )
)
```

---

## 🌍 CONSULTA 6: Embarazos adolescentes por región

### SQL:
```sql
SELECT
    d.nombre AS departamento,
    m.nombre AS municipio,
    COUNT(*) AS total_embarazos_adolescentes
FROM embarazo_adolescente ea
JOIN hecho h ON h.id_hecho = ea.id_hecho
JOIN ubicacion u ON u.id_ubicacion = h.id_ubicacion
JOIN municipio m ON m.id_municipio = u.id_municipio
JOIN departamento d ON d.id_departamento = m.id_departamento
WHERE ea.edad_gestante < 19
GROUP BY 1, 2
ORDER BY total_embarazos_adolescentes DESC;
```

### Álgebra Relacional:

```
ℱ d.nombre, m.nombre, COUNT(*) → total_embarazos_adolescentes (
    σ ea.edad_gestante < 19 (
        π d.nombre, m.nombre (
            embarazo_adolescente ea 
            ⊲⊳_{ea.id_hecho=h.id_hecho} hecho h 
            ⊲⊳_{h.id_ubicacion=u.id_ubicacion} ubicacion u 
            ⊲⊳_{u.id_municipio=m.id_municipio} municipio m 
            ⊲⊳_{m.id_departamento=d.id_departamento} departamento d
        )
    )
)
```

---

## 👧 CONSULTA 7: Violencia infantil con trabajo infantil

### SQL:
```sql
SELECT
    EXTRACT(YEAR FROM h.fecha_hecho) AS anio,
    d.nombre AS departamento,
    COUNT(*) AS total_casos
FROM caso_violencia_ninez cvn
JOIN hecho h ON h.id_hecho = cvn.id_hecho
JOIN ubicacion u ON u.id_ubicacion = h.id_ubicacion
JOIN municipio m ON m.id_municipio = u.id_municipio
JOIN departamento d ON d.id_departamento = m.id_departamento
LEFT JOIN caso_ninez_trabajo_infantil cnti
       ON cnti.id_caso_violencia_ninez = cvn.id_caso_violencia_ninez
WHERE COALESCE(cvn.relacionado_trabajo_infantil, 0) = 1;
```

### Álgebra Relacional:

```
ℱ EXTRACT(YEAR FROM h.fecha_hecho) → anio, d.nombre, COUNT(*) → total_casos (
    σ COALESCE(cvn.relacionado_trabajo_infantil, 0) = 1 (
        π EXTRACT(YEAR FROM h.fecha_hecho), d.nombre (
            caso_violencia_ninez cvn 
            ⊲⊳_{cvn.id_hecho=h.id_hecho} hecho h 
            ⊲⊳_{h.id_ubicacion=u.id_ubicacion} ubicacion u 
            ⊲⊳_{u.id_municipio=m.id_municipio} municipio m 
            ⊲⊳_{m.id_departamento=d.id_departamento} departamento d
            ⟕⊲⊳_{cvn.id_caso_violencia_ninez=cnti.id_caso_violencia_ninez} caso_ninez_trabajo_infantil cnti
        )
    )
)
```

---

## 📌 GUÍA RÁPIDA DE TRADUCCIÓN

### Patrón General para JOINs múltiples:

**SQL:**
```sql
SELECT col1, col2
FROM tabla1 t1
JOIN tabla2 t2 ON t1.id = t2.id_t1
JOIN tabla3 t3 ON t2.id = t3.id_t2
WHERE condicion
GROUP BY col1, col2;
```

**Álgebra Relacional:**
```
ℱ col1, col2 (
    σ condicion (
        π col1, col2 (
            tabla1 t1 ⊲⊳ tabla2 t2 ⊲⊳ tabla3 t3
        )
    )
)
```

### Orden de operaciones:
1. **Fusiones (⊲⊳)** - Combinar tablas
2. **Selección (σ)** - Filtrar filas
3. **Proyección (π)** - Seleccionar columnas
4. **Agregación (ℱ)** - Agrupar y contar

---

## 🔗 REFERENCIAS DEL PDF

- **Selección (σ)**: Página 7 - extrae tuplas que cumplen condición (WHERE en SQL)
- **Proyección (Π)**: Página 9 - extrae atributos específicos (SELECT en SQL)
- **Fusión (⊲⊳)**: Página 30 - combina tuplas por atributo común (JOIN en SQL)
- **Agregación (ℱ)**: Conceptos de GROUP BY y funciones de agregación

---

## 💡 NOTAS IMPORTANTES

- **LEFT JOIN (⟕⊲⊳)**: Mantiene registros del lado izquierdo sin coincidencia
- **INNER JOIN (⊲⊳)**: Solo registros que coinciden en ambas tablas
- **GROUP BY + agregación**: Se representa con el operador ℱ (fold/agregación)
- **ORDER BY**: Se aplica después en la presentación, no en la notación pura

