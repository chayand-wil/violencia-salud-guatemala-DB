# 📚 GUÍA: Cómo Usar los Archivos Generados del Informe

## ✅ Lo que se ha creado

### 1. **Informe_Proyecto_Violencia_COMPLETO.docx** ⭐ PRINCIPAL
   - **Ubicación:** `entregables/Informe_Proyecto_Violencia_COMPLETO.docx`
   - **Contenido:** Documento Word profesional con:
     - Portada formateada
     - Índice automático
     - 7 Secciones completas
     - 7 Consultas SQL con Álgebra Relacional
     - Tablas de datos
     - Explicaciones detalladas
   - **Tamaño:** 45.9 KB
   - **Formato:** .docx (editable en Word, Google Docs, LibreOffice)

### 2. **docs/informe_contenido_completo.md** 
   - **Ubicación:** `docs/informe_contenido_completo.md`
   - **Contenido:** Versión en Markdown del informe completo
   - **Utilidad:** 
     - Fácil de versionear en Git
     - Editable en cualquier editor de texto
     - Fuente para regenerar .docx si necesitas cambios
   - **Ventaja:** Separación entre contenido y formato

### 3. **entregables/generar_docx_profesional.py**
   - **Ubicación:** `entregables/generar_docx_profesional.py`
   - **Función:** Script Python que convierte Markdown → Word profesional
   - **Uso:** Si necesitas actualizar contenido después:
      ```bash
      python3 entregables/generar_docx_profesional.py
      ```

### 4. **docs/SQL_a_Algebra_Relacional.md**
   - **Ubicación:** `docs/SQL_a_Algebra_Relacional.md` (generado en sesión anterior)
   - **Contenido:** Referencia detallada de conversión SQL → Álgebra Relacional
   - **Incluye:** Ejemplos visuales y explicaciones paso a paso

---

## 🚀 FLUJO DE USO

### Opción A: Solo editar en Word (RECOMENDADO PARA TI)
```
1. Abre: entregables/Informe_Proyecto_Violencia_COMPLETO.docx
2. Edita directamente en Word
3. Agrega/modifica contenido según necesites
4. Guarda como PDF: Archivo → Guardar Como → PDF
```

### Opción B: Editar Markdown y regenerar
```
1. Edita: docs/informe_contenido_completo.md
2. Ejecuta: python3 entregables/generar_docx_profesional.py
3. Se genera nuevo .docx automáticamente
4. Abre en Word para ajustes finos
```

### Opción C: Versionamiento Git
```
1. Commit Markdown:
    git add docs/informe_contenido_completo.md
    git commit -m "Actualización secciones del informe"
    
    git add entregables/Informe_Proyecto_Violencia_COMPLETO.docx
```

---

## 📋 CONTENIDO DEL DOCUMENTO

### Portada
- Encabezado institucional
- Título del proyecto
- Datos del estudiante y docente
- Fecha de entrega

### Índice
- 8 Secciones principales

### Secciones

1. **Introducción** (2 páginas)
   - Contexto nacional de violencia y salud
   - Objetivos del proyecto
   - Alcance temporal y geográfico

2. **Justificación** (1 página)
   - ¿Por qué integrar violencia y salud?
   - Correlaciones esperadas
   - Valor agregado

3. **Arquitectura Propuesta** (3 páginas)
   - Tecnologías utilizadas (tabla comparativa)
   - Diagrama general del sistema
   - Modelo lógico con entidades principales

4. **Modelo de Datos** (4 páginas)
   - Normalización (1FN, 2FN, 3FN)
   - Componentes: 26 tablas catalógicas + 15+ transaccionales
   - Relaciones entre entidades
   - Reglas de integridad

5. **Proceso ETL** (3 páginas)
   - Extracción (tabla de 10+ fuentes)
   - Transformación (homologación, normalización, Faker)
   - Carga (orden de inserción, validaciones)

6. **Consultas del Sistema** (8 páginas)
   - Teoría de Álgebra Relacional
   - **7 Consultas SQL con:**
     - SQL original
     - Expresión en Álgebra Relacional
     - Explicación textual de cada una

7. **Conclusiones** (1 página)
   - Logros alcanzados
   - Desafíos resueltos
   - Recomendaciones para continuidad

8. **Anexos** (1 página)
   - Estructura de directorios
   - Diccionario de datos
   - Referencias

---

## ✏️ CÓMO EDITAR EN WORD

### Para agregar contenido:
1. Abre el archivo .docx
2. Coloca el cursor donde necesites
3. Escribe, agrega tablas, imágenes, etc.
4. Word mantiene automáticamente el formato

### Para cambiar estilos:
- **Títulos:** Están configurados en Heading 1, Heading 2, Heading 3
- **Texto normal:** Fuente Calibri 11pt
- **Tablas:** Estilo "Light Grid Accent 1" (editable)

### Para agregar gráficas:
1. Insertar → Gráfico
2. Reemplazar datos con tus propios números
3. Personalizar colores y estilos

### Para crear tabla de contenidos automática:
1. Referencias → Tabla de contenidos
2. Selecciona estilo
3. Word actualizará automáticamente

---

## 🔄 WORKFLOW RECOMENDADO

```
Session 1: Generación Inicial (YA HECHO ✅)
├─ Crear docs/informe_contenido_completo.md
├─ Ejecutar entregables/generar_docx_profesional.py
└─ Verificar entregables/Informe_Proyecto_Violencia_COMPLETO.docx

Session 2: Edición en Word (PRÓXIMO PASO)
├─ Abre .docx en Microsoft Word
├─ Ajusta márgenes, espaciado, colores
├─ Agrega gráficas con datos del proyecto
├─ Revisa ortografía y puntuación
└─ Guarda versión final

Session 3: Exportar PDF
├─ Archivo → Guardar Como
├─ Formato: PDF
├─ Nombre: Informe_Proyecto_Violencia_Final.pdf
└─ Listo para entregar
```

---

## 📊 DATOS QUE PUEDES AGREGAR

### Gráficas recomendadas:
1. **Top 5 Delitos por Frecuencia** (ejecutar consulta SQL)
2. **Homicidios por Año (línea temporal)**
3. **Mapa de Violencia por Departamento**
4. **Indicadores de Salud vs Violencia**
5. **Distribución por Tipo de Caso**

### Para generar datos:
```python
# Ejecutar consultas propuestas en:
# sql/consultas_propuestas.sql

# Exportar resultados a CSV:
# Luego importar en Excel para gráficas
```

---

## 🎯 PRÓXIMAS ACCIONES

1. ✅ **Ahora:** Abre `entregables/Informe_Proyecto_Violencia_COMPLETO.docx` en Word
2. 📝 **Luego:** Ajusta contenido según retroalimentación del docente
3. 📊 **Después:** Agrega gráficas con datos reales del proyecto
4. 🔍 **Antes de entregar:** Revisa ortografía, formato, márgenes
5. 📤 **Final:** Exporta a PDF y entrega

---

## ❓ PREGUNTAS FRECUENTES

### P: ¿Puedo editar directamente el .docx?
**R:** Sí, completamente. El archivo está optimizado para ello.

### P: ¿Pierdo cambios si regenero desde Markdown?
**R:** Solo si editas .docx directamente. Si actualizas en Markdown y regeneras, sobrescribe cambios en Word. Recommends editar en Markdown primero.

### P: ¿Cómo actualizo el Índice?
**R:** Referencias → Actualizar tabla. Word lo hace automáticamente.

### P: ¿Puedo convertir a PDF desde Word?
**R:** Sí: Archivo → Guardar Como → Formato PDF. Se mantiene todo el formato.

### P: ¿Y si quiero volver a regenerar todo?
**R:** Edita `docs/informe_contenido_completo.md` y ejecuta:
```bash
python3 entregables/generar_docx_profesional.py
```

---

## 📞 SOPORTE

- **Script breaks:** Revisa que `python-docx` esté instalado: `pip list | grep python-docx`
- **Encoding:** All files use UTF-8 encoding
- **Compatibilidad:** .docx funciona en: Word, Google Docs, LibreOffice

---

## 📦 ARCHIVOS GENERADOS

```
Proyecto/
├── entregables/
│   ├── Informe_Proyecto_Violencia_COMPLETO.docx ⭐ PRINCIPAL
│   ├── generar_docx_profesional.py (Script)
│   └── generar_informe_completo.py (Script)
│
├── docs/
│   ├── informe_contenido_completo.md (Markdown)
│   ├── SQL_a_Algebra_Relacional.md (Referencia)
│   └── README_Informe.md (Este archivo)
```

---

**¡Listo para trabajar! Abre Word y comienza a editar.** 🚀

*Documento generado: 16 de April, 2026*
