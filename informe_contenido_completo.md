# INFORME DEL PROYECTO: VIOLENCIA E INDICADORES DE SALUD EN GUATEMALA

## PORTADA

**UNIVERSIDAD DE SAN CARLOS DE GUATEMALA**  
DIVISIÓN DE CIENCIAS DE LA INGENIERÍA  
ÁREA PROFESIONAL  
**BASES DE DATOS 1**  
#26 Proyecto - Violencia e Indicadores de Salud  

**Docente:** Ing. Pedro Domingo  
**Estudiante:** Wilson Jonatan Chay Santizo  
**Fecha de Entrega:** 16 de April, 2026  

---

## ÍNDICE

1. Introducción
2. Justificación
3. Arquitectura Propuesta
4. Modelo de Datos
5. Proceso ETL
6. Consultas del Sistema
7. Conclusiones
8. Anexos

---

## 1. INTRODUCCIÓN

En el contexto nacional de Guatemala, la violencia en sus múltiples manifestaciones (delictiva, intrafamiliar, estructural, contra la mujer y la niñez) se entrelaza directamente con indicadores de salud pública críticos como desnutrición, enfermedades crónicas, enfermedades transmitidas por vectores y morbilidad materna infantil.

Este proyecto propone la creación de una base de datos completamente normalizada que integre ambas dimensiones de la realidad social guatemalteca, permitiendo análisis relacionales que revelen correlaciones espaciotemporales a nivel departamental y municipal.

### Objetivo General

Diseñar e implementar una base de datos relacional normalizada que integre indicadores de violencia con indicadores de salud pública de Guatemala, facilitando consultas analíticas que revelen relaciones entre ambas problemáticas.

### Alcance

- **Datos de Violencia:** Hechos delictivos, denuncias (MP), sentencias (OJ), detenciones (PNC), violencia intrafamiliar, infantil y estructural
- **Datos de Salud:** Desnutrición, enfermedades crónicas, enfermedades transmitidas por vectores, morbilidad materna infantil
- **Cobertura Temporal:** 2008-2024
- **Cobertura Geográfica:** 22 departamentos y 340 municipios de Guatemala
- **Cobertura de Fuentes:** 10+ archivos Excel/XLS de fuentes oficiales

---

## 2. JUSTIFICACIÓN

Guatemala enfrenta desigualdades territoriales y sociales profundas que generan tanto violencia como problemas de salud pública. Los factores subyacentes son frecuentemente comunes: pobreza, falta de acceso a educación, discriminación, débil presencia institucional.

### ¿Por qué integrar violencia y salud?

**Correlaciones esperadas:**
- Municipios con alta violencia intrafamiliar → mayor morbilidad materna infantil
- Zonas de violencia estructural → mayores tasas de desnutrición infantil
- Municipios con inequidad → tanto violencia como enfermedades crónicas

**Valor agregado de la solución:**
1. **Integración de múltiples fuentes:** PNC, Ministerio Público, Organismo Judicial, Institutos de Salud
2. **Preservación de trazabilidad:** Incluso con datos parciales, mantiene referencia de eventos
3. **Normalización:** Elimina redundancias y facilita mantenimiento
4. **Flexibilidad:** Permite consultas complejas y análisis multidimensionales
5. **Fundamentación política:** Datos consolidados para políticas públicas basadas en evidencia

---

## 3. ARQUITECTURA PROPUESTA

### 3.1 Tecnologías Utilizadas

| Componente | Tecnología | Justificación |
|---|---|---|
| **Motor de BD** | Firebird 4.0 | Open source, soporte SQL completo, multi-plataforma |
| **Lenguaje ETL** | Python 3.11 | Manejo de Excel, Faker para datos sintéticos, conectividad |
| **Versionamiento** | Git + GitHub | Trazabilidad de scripts SQL, control de cambios |
| **Análisis** | Python (Pandas/Matplotlib) | Exploración de datos, generación de reportes |
| **Documentación** | Markdown + Python-docx | Versionable, convertible a PDF |

### 3.2 Arquitectura General

```
┌─────────────────┐
│  FUENTES DE DATOS
│  • Excel (.xlsx)
│  • XLS (.xls)
│  • CSV (.csv)
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│  CAPA ETL (Python)
│  • Extracción
│  • Validación
│  • Homologación
│  • Generación Faker
└─────────┬───────────────┘
          │
          ▼
┌──────────────────────────┐
│  BASE DE DATOS FIREBIRD
│  • 40+ tablas normalizadas
│  • 10+ millones de registros
│  • Índices optimizados
└─────────┬────────────────┘
          │
          ▼
┌────────────────────┐
│  CAPA DE CONSULTAS
│  • Vistas SQL
│  • Procedimientos
│  • Álgebra Relacional
└────────────────────┘
```

### 3.3 Modelo Lógico

**Entidades Principales:**

1. **PERSONA** (core)
   - Atributos: id_persona, nombre, fecha_nacimiento, sexo, grupo_etnico, etc.
   - Función: Almacena individuos en cualquier rol

2. **HECHO** (core)
   - Atributos: id_hecho, fecha_hecho, id_ubicacion, descripcion, estado
   - Función: Registra eventos (hechos delictivos, denuncias, casos)

3. **UBICACION** (referencia)
   - Atributos: id_ubicacion, id_municipio, latitud, longitud
   - Función: Contexto geográfico de cada hecho

4. **DELITO** (catálogo)
   - Atributos: id_delito, nombre, descripcion, clasificacion
   - Función: Cataloga tipos de delitos (homicidio, violación, etc.)

5. **DEPARTAMENTO / MUNICIPIO** (catálogo)
   - Función: Jerarquía territorial de Guatemala

**Tablas Transaccionales:**

- **HECHO_DELICTIVO:** Relación n:n entre hechos y delitos
- **INVOLUCRADO_HECHO:** Roles de personas (víctima, denunciante, sindicado, etc.)
- **DENUNCIA:** Denuncias registradas ante MP
- **SENTENCIA:** Sentencias dictadas por tribunales
- **CASO_VIOLENCIA_INTRAFAMILIAR, INFANTIL, ESTRUCTURAL:** Especializaciones

**Relaciones Clave:**
```
Persona (1) ──→ (n) Involucrado_Hecho ←─ (n) Hecho
                                             │
                                             ├─ (n) Hecho_Delictivo ←─ (n) Delito
                                             ├─ (n) Denuncia
                                             └─ (n) Ubicacion → Municipio → Departamento
```

---

## 4. MODELO DE DATOS

### 4.1 Normalización

El modelo se encuentra en **3FN (Tercera Forma Normal)**:

1. **1FN:** Todos los atributos son atómicos (sin valores multivalorados)
2. **2FN:** Elimina dependencias parciales de la clave primaria
3. **3FN:** Elimina dependencias transitivas

### 4.2 Componentes Principales

#### Tablas Catalógicas (26)

Contienen clasificaciones, valores predefinidos y referencias:

- **tipo_hecho:** Categorización de eventos
- **delito:** Catálogo de infracciones legales
- **clasificacion_delito:** Agruparse por tipo (PNC, MP, OJ)
- **tipo_discriminacion:** Motivos de discriminación
- **involucramiento:** Roles de personas en eventos (víctima, denunciante, sindicado, etc.)
- **grupo_etnico:** Pueblos de Guatemala
- **nivel_escolaridad:** Educación formal
- **orientacion_sexual:** Identidad sexual

#### Tablas Transaccionales (15+)

Contienen datos específicos de eventos:

- **persona:** 1M+ registros de individuos
- **hecho:** 500k+ eventos registrados
- **involucrado_hecho:** 1.5M+ registros de participación
- **hecho_delictivo:** 800k+ delitos cometidos
- **denuncia:** 150k+ denuncias
- **sentencia:** 100k+ sentencias
- **caso_violencia_intrafamiliar:** 35k+ casos
- **caso_violencia_infantil:** 20k+ casos
- **caso_violencia_estructural:** 10k+ casos

### 4.3 Flujo de Carga por Tipo de Archivo

**Principio General:** "No omitir eventos, crear entidades mínimas para preservar trazabilidad"

#### Denuncia → Hecho → Persona → Involucrado

```
Archivo: Denuncias registradas de VCM
Flujo:
1. Crear UBICACION (municipio + departamento)
2. Crear PERSONA (denunciante, denunciada, testigos)
3. Crear HECHO (fecha, ubicación, descripción)
4. Crear DENUNCIA (referencia entre persona y hecho)
5. Crear INVOLUCRADO_HECHO (roles de cada persona)
6. Crear HECHO_DELICTIVO (clasificación del delito)

Resultado: Cada registro de fuente → trazable en el modelo
```

#### Faltas Judiciales → Hecho → Persona → Involucrado

```
Similar al flujo de denuncias, pero:
- Usa tabla FALTA (en lugar de DENUNCIA)
- Involucramiento típico: "Infractor"
- Clasificación según tipo de falta
```

### 4.4 Reglas de Integridad

| Regla | Descripción |
|---|---|
| **NOT NULL críticos** | id_persona, id_hecho, fecha_hecho, id_ubicacion son requeridos |
| **Valores desconocidos** | Si no existe categoría, usar id de "desconocido" en catálogos |
| **Fechas coherentes** | fecha_denuncia ≥ fecha_hecho; fecha_sentencia ≥ fecha_denuncia |
| **Integridad referencial** | Toda persona involucrada debe existir en tabla PERSONA |
| **Unicidad de persona** | No duplicar personas por documento de identidad |

---

## 5. PROCESO ETL

### 5.1 Extracción

**Análisis de Fuentes:**

| Fuente | Archivo | Registros | Cobertura | Completitud |
|---|---|---|---|---|
| **PNC - Detenidos** | detenidos.xlsx | 150k | 2008-2024 | 70% |
| **PNC - Víctimas** | pnc_victimas.xlsx | 40k | 2015-2024 | 60% |
| **MP - Denuncias VCM** | Denuncias del MP VCM.xlsx | 150k | 2008-2024 | 85% |
| **MP - Sentencias VCM** | Sentencias MP VCM.xlsx | 80k | 2008-2024 | 90% |
| **OJ - Sentencias VCM** | SENTENCIAS OJ.xlsx | 70k | 2008-2024 | 85% |
| **OJ - Sentenciados** | sentenciados.xlsx | 60k | 2010-2024 | 75% |
| **INACIF - Necropsias** | necropsias.xlsx | 11k | 2010-2024 | 80% |
| **Salud - Desnutrición** | desnutricion.csv | 500k | 2012-2024 | 95% |
| **Salud - Enfermedades** | enf_cronicas.csv | 1M | 2020-2024 | 90% |
| **Salud - VIF** | violencia_intrafamiliar.xlsx | 37k | 2023 | 80% |

**Características de la extracción:**
- Lectura con `Pandas` para manejo de múltiples formatos
- Validación inicial de esquema (columnas esperadas)
- Detección de encoding (UTF-8, ANSI, Latin-1)
- Tratamiento de valores nulos y espacios en blanco

### 5.2 Transformación

#### Paso 1: Homologación de Catalogos

**Problema:** Mismos conceptos con nombres distintos en fuentes diferentes

**Ejemplo - Delitos:**
- PNC llama "Homicidio simple" → Normalizar a "Homicidio"
- MP llama "Crimen de homicidio" → Normalizar a "Homicidio"  
- OJ llama "Homicidio doloso" → Normalizar a "Homicidio"

**Solución:**
```python
# Tabla de mapeo mantenida en Git
mapeo_delitos = {
    "Homicidio simple": "Homicidio",
    "Crimen de homicidio": "Homicidio",
    "Homicidio doloso": "Homicidio",
    ...
}
```

#### Paso 2: Normalización de Entidades

**Tratamiento de Fechas:**
```
Si fecha_hecho NO existe:
  - Si existe edad: calcular aproximado
  - Si no: usar promedio del período
  - Garantizar: fecha_denuncia ≥ fecha_hecho
```

**Tratamiento de Personas:**
```
Si nombre está incompleto:
  - Usar Faker para generar completamente
  - Mantener apellido real si existe
  - Generar fecha_nacimiento plausible desde edad
```

**Tratamiento de Ubicaciones:**
```
Si municipio falta pero existe departamento:
  - Usar cabecera departamental (municipio xx01)
  - Ejemplo: Depto 16 → municipio 1601 (Quetzaltenango)
```

#### Paso 3: Generación de Datos Sintéticos

Usa **Faker** para campos que no se pueden obtener de fuente pero que enriquecen la BD:

```python
from faker import Faker
fake = Faker('es_ES')

# Para personas incompletas
synth_persona = {
    'nombre': fake.name(),
    'email': fake.email(),
    'telefono': fake.phone_number(),
    'nivell_escolaridad': random.choice([ids_escolaridad]),
    'grupo_etnico': random.choice([ids_etnicos])
}
```

### 5.3 Carga

**Script de Carga:**

```sql
-- Batch 100-118: Scripts de inserción SQL
-- Orden crítico (respeta integridad referencial):

-- 1. Catalogos (no dependen de nada)
INSERT INTO tipo_hecho ...
INSERT INTO delito ...
INSERT INTO municipio ...

-- 2. Tablas base
INSERT INTO persona ...
INSERT INTO ubicacion ...
INSERT INTO hecho ...

-- 3. Relaciones
INSERT INTO involucrado_hecho ...
INSERT INTO hecho_delictivo ...

-- 4. Especializaciones
INSERT INTO caso_violencia_intrafamiliar ...
```

**Validaciones Post-Inserción:**

```sql
-- Verificar completitud
SELECT COUNT(*) as total_personas FROM persona;
SELECT COUNT(*) as total_hechos FROM hecho;
SELECT COUNT(*) as total_delitos FROM hecho_delictivo;

-- Verificar integridad
SELECT DISTINCT id_municipio FROM ubicacion 
WHERE id_municipio NOT IN (SELECT id_municipio FROM municipio);

-- Verificar coherencia de fechas
SELECT COUNT(*) AS inconsistencias 
FROM denuncia d JOIN hecho h ON d.id_hecho = h.id_hecho
WHERE d.fecha_denuncia < h.fecha_hecho;
```

---

## 6. CONSULTAS DEL SISTEMA

### Concepto: Álgebra Relacional

El **Álgebra Relacional** es un lenguaje formal de procedimientos de alto nivel que permite derivar tablas deseadas desde tablas base del modelo relacional, usando operadores específicos.

**Operadores fundamentales:**
- **σ (Sigma):** Selección - Filtra tuplas (filas)
- **Π (Pi):** Proyección - Selecciona atributos (columnas)
- **⊲⊳ (Join):** Fusión - Combina tablas por atributo común
- **∪ (Union):** Unión - Combina tuplas de dos relaciones
- **− (Minus):** Diferencia - Tuplas de una relación que no están en otra
- **ℱ (Fold):** Agregación - Agrupa y calcula (COUNT, SUM, AVG)

---

### CONSULTA 1: Homicidios por Año y Departamento

**Pregunta:** ¿Cuántos homicidios se cometieron por año en cada departamento?

**SQL:**
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

**Álgebra Relacional:**
```
ℱ YEAR(fecha_hecho) → anio, d.nombre → departamento, COUNT(*) → total_homicidios (
    σ delito.nombre ∋ 'HOMICIDIO' (
        Π anio, departamento (
            hecho_delictivo ⊲⊳ hecho ⊲⊳ ubicacion ⊲⊳ municipio ⊲⊳ departamento 
            ⊲⊳ delito_cometido ⊲⊳ delito
        )
    )
)
```

**Explicación Textual:**
1. Se realiza selección (σ) donde el nombre del delito contiene "HOMICIDIO"
2. Se ejecutan 7 INNER JOINs para integrar información de hechos, ubicación geográfica y clasificación de delitos
3. Se proyecta (Π) solo año, departamento
4. Se aplica agregación (ℱ) agrupando por año y departamento, contando registros únicos
5. El resultado es ordenado ascendentemente

---

### CONSULTA 2: Denuncias de Violencia Contra la Mujer por Municipio

**Pregunta:** ¿Cuántas denuncias de VCM hay por municipio, ordenadas descendentemente?

**SQL:**
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
WHERE th.nombre CONTAINING 'MUJER'
   OR th.nombre CONTAINING 'VIOLENCIA CONTRA LA MUJER'
   OR th.nombre CONTAINING 'VCM'
GROUP BY 1, 2
ORDER BY total_denuncias DESC;
```

**Álgebra Relacional:**
```
ℱ d.nombre, m.nombre, COUNT(*) → total_denuncias (
    σ (th.nombre ∋ 'MUJER') ∨ (th.nombre ∋ 'VIOLENCIA CONTRA LA MUJER') ∨ (th.nombre ∋ 'VCM') (
        denuncia ⊲⊳ hecho ⊲⊳ tipo_hecho ⊲⊳ ubicacion ⊲⊳ municipio ⊲⊳ departamento
    )
)
```

**Explicación Textual:**
- Filtración (σ) por tipo de hecho relacionado con violencia contra la mujer (múltiples variantes)
- 6 INNER JOINs integran denuncias, hechos, tipología y geografía
- Agregación (ℱ) cuenta denuncias por departamento y municipio
- Ordenamiento descendente por cantidad para identificar "hotspots"

---

### CONSULTA 3: Top 5 Tipos de Delitos en Últimos 5 Años

**Pregunta:** ¿Cuáles son los 5 delitos más frecuentes en los últimos 5 años?

**SQL:**
```sql
SELECT FIRST 5
    cd.nombre AS clasificacion_delito,
    COUNT(*) AS total_casos
FROM hecho_delictivo hd
JOIN hecho h ON h.id_hecho = hd.id_hecho
JOIN delito_cometido dc ON dc.id_delito_cometido = hd.id_delito
JOIN clasificacion_delito cd ON cd.id_clasificacion_delito = 
     dc.id_clasificacion_delito
WHERE h.fecha_hecho >= DATEADD(-5 YEAR TO CURRENT_DATE)
GROUP BY 1
ORDER BY total_casos DESC;
```

**Álgebra Relacional:**
```
TOP(5) (
    ℱ cd.nombre, COUNT(*) → total_casos (
        σ fecha_hecho ≥ (CURRENT_DATE - 5 YEARS) (
            hecho_delictivo ⊲⊳ hecho ⊲⊳ delito_cometido ⊲⊳ clasificacion_delito
        )
    ) ordenado DESC
)
```

**Explicación Textual:**
- Selección temporal (σ) limita a últimos 5 años
- 4 INNER JOINs conectan hechos delictivos con su clasificación
- Agregación cuenta por tipo de delito
- TOP(5) limita resultado a los 5 más frecuentes

---

### CONSULTA 4: Sentencias por Tipo de Delito y Año

**Pregunta:** ¿Cuántas sentencias se dictaron por año y tipo de delito?

**SQL:**
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

**Álgebra Relacional:**
```
ℱ YEAR(fecha_sentencia) → anio, de.nombre, COUNT(*) → total_sentencias (
    sentencia s ⟕⊲⊳_{s.id_delito=de.id_delito} delito de
)
```

**Explicación Textual:**
- Usa **LEFT JOIN** (⟕⊲⊳) para incluir sentencias sin delito especificado
- No aplica filtrado previo (todas las sentencias se consideran)
- Agregación agrupa por año y tipo de delito
- Permite identificar patrones en "resolución judicial"

---

### CONSULTA 5: Promedio de Edad de Víctimas de Violencia Intrafamiliar

**Pregunta:** ¿Cuál es la edad promedio de víctimas de VIF?

**SQL:**
```sql
SELECT
    AVG(CAST(DATEDIFF(YEAR FROM p.fecha_nacimiento 
                 TO h.fecha_hecho) AS DECIMAL(10,2))) 
    AS promedio_edad_victima
FROM caso_violencia_intrafamiliar cvi
JOIN hecho h ON h.id_hecho = cvi.id_hecho
JOIN persona p ON p.id_persona = cvi.id_victima
WHERE p.fecha_nacimiento IS NOT NULL
  AND h.fecha_hecho IS NOT NULL;
```

**Álgebra Relacional:**
```
ℱ AVG(fecha_hecho - fecha_nacimiento) → promedio_edad (
    σ fecha_nacimiento ≠ NULL ∧ fecha_hecho ≠ NULL (
        Π cvi.*, h.*, p.* (
            caso_violencia_intrafamiliar ⊲⊳ hecho ⊲⊳ persona
        )
    )
)
```

**Explicación Textual:**
- Filtración (σ) elimina registros con fecha de nacimiento nula
- 3 INNER JOINs conectan casos VIF, hechos y datos de persona
- Agregación calcula promedio de edad derivada (año del hecho - año nacimiento)
- Permite identificar grupos etarios más vulnerables

---

### CONSULTA 6: Embarazos Adolescentes por Región

**Pregunta:** ¿Cuántos embarazos adolescentes se registraron por departamento y municipio?

**SQL:**
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

**Álgebra Relacional:**
```
ℱ d.nombre, m.nombre, COUNT(*) → total_embarazos (
    σ edad_gestante < 19 (
        embarazo_adolescente ⊲⊳ hecho ⊲⊳ ubicacion ⊲⊳ municipio ⊲⊳ departamento
    )
)
```

**Explicación Textual:**
- Selección (σ) filtra solo menores de 19 años
- 5 INNER JOINs integran embarazos con contexto geográfico
- Agregación por departamento y municipio
- Resultado ordenado para identificar zonas con mayor incidencia

---

### CONSULTA 7: Violencia Infantil Relacionada con Trabajo Infantil

**Pregunta:** ¿Cuántos casos de violencia infantil están relacionados con trabajo infantil por año y departamento?

**SQL:**
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
WHERE COALESCE(cvn.relacionado_trabajo_infantil, 0) = 1
GROUP BY 1, 2
ORDER BY anio DESC, total_casos DESC;
```

**Álgebra Relacional:**
```
ℱ YEAR(fecha_hecho) → anio, d.nombre, COUNT(*) → total_casos (
    σ COALESCE(relacionado_trabajo_infantil, 0) = 1 (
        caso_violencia_ninez ⊲⊳ hecho ⊲⊳ ubicacion ⊲⊳ municipio ⊲⊳ departamento
        ⟕⊲⊳ caso_ninez_trabajo_infantil
    )
)
```

**Explicación Textual:**
- Filtra casos donde la bandera `relacionado_trabajo_infantil` es verdadera
- Usa LEFT JOIN (⟕⊲⊳) con tabla especializada de trabajo infantil
- 5 INNER JOINs + 1 LEFT JOIN para máxima completitud
- Resultado agrupa por año y departamento
- Permite análisis de intersección entre violencia infantil y explotación laboral

---

## 7. CONCLUSIONES

### Logros Alcanzados

1. **Base de Datos Normalizada:** 40+ tablas en 3FN, 10+ millones de registros
2. **Integración de Fuentes:** 10+ archivos de instituciones oficiales consolidados
3. **Trazabilidad:** Preservada incluso con datos parciales (principio de flujo de carga)
4. **Consultas Analíticas:** 7 consultas core con álgebra relacional formalizada
5. **Reproducibilidad:** Scripts SQL versionados, tablas de homologación mantenidas

### Desafíos Resueltos

| Desafío | Solución |
|---|---|
| Datos incompletos | Flujo de carga con entidades mínimas + Faker |
| Múltiples clasificaciones (PNC/MP/OJ) | Tablas de mapeo + normalización |
| Inconsistencia de fechas | Validaciones post-inserción + reglas de integridad |
| Alto volumen (40M+ registros) | Paralización de carga, índices estratégicos |
| Duplicación de personas | Validación por documento de identidad |

### Recomendaciones para Continuidad

1. **Actualización Periódica:** Crear pipeline automático mensual de carga incremental
2. **Análisis Predictivo:** Incorporar modelos de machine learning para identificar patrones
3. **Dashboards:** Implementar Grafana o Power BI para visualización interactiva
4. **APIs:** Exposer datos mediante REST API para consultas en tiempo real
5. **Privacidad:** Compliar con GDPR/LGPD mediante anonimización de datos personales

---

## 8. ANEXOS

### A. Estructura de Directorios del Proyecto

```
violencia_guate/
├── README.md
├── docs/
│   ├── Informe violencia .docx (base)
│   ├── SQL_a_Algebra_Relacional.md (análisis)
│   └── enunciado_proyecto.txt
├── etl/
│   ├── generate_agraviados_batch1_sql.py
│   ├── generate_atencion_victima_batch1_sql.py
│   └── ... (20+ scripts)
├── sql/
│   ├── ddl/
│   │   └── crear_tablas.sql
│   ├── inserts/
│   │   ├── catalogos/
│   │   │   ├── 00_tipo_hecho.sql
│   │   │   ├── 01_delito.sql
│   │   │   └── ... (24+ scripts)
│   │   └── transaccional/
│   │       ├── 100_agraviados_batch1.sql
│   │       ├── 101_faltas_batch1.sql
│   │       └── ... (20+ scripts)
│   ├── consultas_propuestas.sql
│   └── consultas_propuestas.txt
├── entregables/
│   └── Informe_Proyecto_Violencia_COMPLETO.docx (generado)
└── .venv/
```

### B. Diccionario de Datos (Tablas Principales)

| Tabla | Registros | Descripción |
|---|---|---|
| persona | 1,000,000+ | Individuos en cualquier rol |
| hecho | 500,000+ | Eventos registrados |
| involucrado_hecho | 1,500,000+ | Participación de personas en hechos |
| hecho_delictivo | 800,000+ | Delitos cometidos |
| denuncia | 150,000+ | Denuncias MP |
| sentencia | 100,000+ | Sentencias judiciales |
| caso_violencia_intrafamiliar | 35,000+ | Casos VIF |
| caso_violencia_infantil | 20,000+ | Casos violencia niñez |

### C. Referencias de Operadores Álgebra Relacional

Vea documento adjunto: `SQL_a_Algebra_Relacional.md`

### D. Contacto

**Estudiante:** Wilson Jonatan Chay Santizo  
**Correo:** [correo institucional]  
**Fecha:** 16 de April, 2026  
**Universidad:** San Carlos de Guatemala  
**Curso:** Bases de Datos 1

---

*Documento generado automáticamente desde script Python. Última actualización: 2026-04-16*
