import pandas as pd
import os
import glob

# Carpetas a procesar
carpetas = [
    "datos_base/Salud/ Morbilidad Grupo Materno Infantil",
    "datos_base/Salud/Desnutricion",
    "datos_base/Salud/Enfermedades transmitidas por vectores",
    "datos_base/Salud/Enfermedades_Cronicas_2020-2024"
]

# Campos posibles para cada dato
campos_cie10 = ["CIE-10", "CIE10", "cie10", "cie-10"]
campos_diag = ["Diagnóstico", "Diagnostico", "diagnóstico", "diagnostico"]
campos_tipo = ["tipo_diagnostico", "id_tipo_diagnostico"]

registros = []
archivos_faltantes = []

for carpeta in carpetas:
    archivos = glob.glob(os.path.join(carpeta, "*.csv"))
    for archivo in archivos:
        # Detectar delimitador
        with open(archivo, 'r', encoding='utf-8') as f:
            primera_linea = f.readline()
            delimitador = ';' if ';' in primera_linea else ','
        df = pd.read_csv(archivo, delimiter=delimitador, dtype=str)
        # Buscar nombres de columnas
        col_cie10 = next((c for c in df.columns if c.strip() in campos_cie10), None)
        col_diag = next((c for c in df.columns if c.strip() in campos_diag), None)
        col_tipo = next((c for c in df.columns if c.strip() in campos_tipo), None)
        if not (col_cie10 and col_diag and col_tipo):
            archivos_faltantes.append((archivo, df.columns.tolist()))
            continue
        for _, row in df.iterrows():
            cie10 = str(row[col_cie10]).strip()
            diag = str(row[col_diag]).strip()
            tipo = str(row[col_tipo]).strip()
            if cie10 and diag and tipo:
                registros.append((diag, cie10, tipo))

# Eliminar duplicados
registros_unicos = list(set(registros))
registros_unicos.sort()

# Guardar catálogo
df_out = pd.DataFrame(registros_unicos, columns=["nombre", "CIE-10", "id_tipo_diagnostico"])
df_out.to_csv("catalogo_diagnosticos.csv", index=False, encoding='utf-8')

if archivos_faltantes:
    with open("catalogo_diagnosticos_faltantes.txt", "w", encoding="utf-8") as f:
        for archivo, cols in archivos_faltantes:
            f.write(f"{archivo}: {cols}\n")
    print(f"Algunos archivos no tienen los campos requeridos. Ver catalogo_diagnosticos_faltantes.txt")
else:
    print(f"Catálogo generado con {len(df_out)} registros únicos en catalogo_diagnosticos.csv")
