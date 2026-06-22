import pandas as pd

# Leer el catálogo existente
archivo = "../datos_base/Salud/catalogo_diagnosticos.csv"
df = pd.read_csv(archivo)

df.insert(0, 'id', range(1, len(df) + 1))

nuevo_archivo = "../datos_base/Salud/catalogo_diagnosticos.csv"
df.to_csv(nuevo_archivo, index=False, encoding='utf-8')
print(f"Campo 'id' agregado y guardado en {nuevo_archivo}")
