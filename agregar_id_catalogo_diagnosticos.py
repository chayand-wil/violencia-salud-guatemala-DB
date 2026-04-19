import pandas as pd

# Leer el catálogo existente
archivo = "catalogo_diagnosticos.csv"
df = pd.read_csv(archivo)

# Agregar columna id (1, 2, 3, ...)
df.insert(0, 'id', range(1, len(df) + 1))

# Guardar el archivo actualizado
nuevo_archivo = "catalogo_diagnosticos.csv"
df.to_csv(nuevo_archivo, index=False, encoding='utf-8')
print(f"Campo 'id' agregado y guardado en {nuevo_archivo}")
