#!/usr/bin/env python3
"""Perfilador de archivos Excel para análisis de normalización.

Uso rápido:
  python analisis_pandas_excel.py

Uso personalizado:
  python analisis_pandas_excel.py --files ruta1.xlsx ruta2.xlsx --output reportes
"""

from __future__ import annotations

import argparse
import json
import re
import unicodedata
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

import pandas as pd


DEFAULT_FILES = [
    Path(
        "Violencia/Hechos-Delicitivos/Agraviados/"
        "20240528163342pWf6BcBWj8taVS3Q3mRKxgDsvwPejgH8.xlsx"
    ),
    Path(
        "Violencia/Faltas judiciales/"
        "20240524231759eHmz6DmFKboNQ5Y3OlqNkbi9izmXULaP.xlsx"
    ),
]


@dataclass
class ColumnProfile:
    archivo: str
    hoja: str
    columna_original: str
    columna_normalizada: str
    dtype: str
    nulos: int
    porcentaje_nulos: float
    no_nulos: int
    distintos: int
    muestra_valores: str


def normalize_name(value: str) -> str:
    text = str(value).strip().lower()
    text = unicodedata.normalize("NFKD", text)
    text = "".join(ch for ch in text if not unicodedata.combining(ch))
    text = re.sub(r"[^a-z0-9]+", "_", text)
    text = re.sub(r"_+", "_", text)
    return text.strip("_")


def iter_sheets_with_data(xls_path: Path) -> Iterable[tuple[str, pd.DataFrame]]:
    workbook = pd.ExcelFile(xls_path)
    for sheet in workbook.sheet_names:
        df = pd.read_excel(xls_path, sheet_name=sheet)
        if df.empty and len(df.columns) == 0:
            continue
        yield sheet, df


def profile_dataframe(file_name: str, sheet: str, df: pd.DataFrame) -> list[ColumnProfile]:
    profiles: list[ColumnProfile] = []
    row_count = len(df)

    for col in df.columns:
        series = df[col]
        nulos = int(series.isna().sum())
        no_nulos = int(series.notna().sum())
        distintos = int(series.nunique(dropna=True))
        if no_nulos > 0:
            muestra = series.dropna().astype(str).head(5).tolist()
            muestra_txt = " | ".join(muestra)
        else:
            muestra_txt = ""

        profiles.append(
            ColumnProfile(
                archivo=file_name,
                hoja=sheet,
                columna_original=str(col),
                columna_normalizada=normalize_name(str(col)),
                dtype=str(series.dtype),
                nulos=nulos,
                porcentaje_nulos=(nulos / row_count * 100.0) if row_count else 0.0,
                no_nulos=no_nulos,
                distintos=distintos,
                muestra_valores=muestra_txt,
            )
        )
    return profiles


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Perfila archivos Excel con pandas y genera reportes de columnas, "
            "calidad de datos y comparación entre archivos."
        )
    )
    parser.add_argument(
        "--files",
        nargs="+",
        default=[str(path) for path in DEFAULT_FILES],
        help="Lista de archivos Excel a analizar.",
    )
    parser.add_argument(
        "--output",
        default="reportes_pandas",
        help="Carpeta donde se escribirán los reportes.",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    output_dir = Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)

    all_profiles: list[ColumnProfile] = []
    resumen_archivos: list[dict[str, object]] = []
    columnas_por_archivo: dict[str, set[str]] = {}

    for file_raw in args.files:
        xls_path = Path(file_raw)
        if not xls_path.exists():
            raise FileNotFoundError(f"No existe el archivo: {xls_path}")

        total_rows = 0
        total_columns = 0
        total_sheets_data = 0
        cols_norm_set: set[str] = set()

        for sheet_name, df in iter_sheets_with_data(xls_path):
            total_sheets_data += 1
            total_rows += len(df)
            total_columns += len(df.columns)
            profiles = profile_dataframe(xls_path.name, sheet_name, df)
            all_profiles.extend(profiles)
            cols_norm_set.update(p.columna_normalizada for p in profiles)

        resumen_archivos.append(
            {
                "archivo": xls_path.name,
                "ruta": str(xls_path),
                "hojas_con_datos": total_sheets_data,
                "filas_totales": total_rows,
                "columnas_totales_sumadas": total_columns,
                "columnas_normalizadas_unicas": len(cols_norm_set),
            }
        )
        columnas_por_archivo[xls_path.name] = cols_norm_set

    df_profiles = pd.DataFrame([p.__dict__ for p in all_profiles])
    df_resumen = pd.DataFrame(resumen_archivos)

    df_resumen.to_csv(output_dir / "resumen_archivos.csv", index=False)
    df_profiles.to_csv(output_dir / "perfil_columnas.csv", index=False)

    # Tabla pivot para comparar presencia de columnas (normalizadas) por archivo.
    comp_rows: list[dict[str, object]] = []
    all_columns = sorted(set().union(*columnas_por_archivo.values()))
    file_names = sorted(columnas_por_archivo.keys())

    for col in all_columns:
        row = {"columna_normalizada": col}
        for file_name in file_names:
            row[file_name] = int(col in columnas_por_archivo[file_name])
        comp_rows.append(row)

    df_comparacion = pd.DataFrame(comp_rows)
    df_comparacion.to_csv(output_dir / "comparacion_columnas.csv", index=False)

    resumen_json = {
        "archivos": resumen_archivos,
        "interseccion_columnas": sorted(
            set.intersection(*columnas_por_archivo.values())
            if columnas_por_archivo
            else set()
        ),
        "solo_por_archivo": {
            file_name: sorted(
                columnas_por_archivo[file_name]
                - set.union(
                    *[v for k, v in columnas_por_archivo.items() if k != file_name]
                )
            )
            for file_name in file_names
        },
    }

    with (output_dir / "resumen_comparativo.json").open("w", encoding="utf-8") as f:
        json.dump(resumen_json, f, ensure_ascii=False, indent=2)

    print("Reportes generados:")
    print(f" - {output_dir / 'resumen_archivos.csv'}")
    print(f" - {output_dir / 'perfil_columnas.csv'}")
    print(f" - {output_dir / 'comparacion_columnas.csv'}")
    print(f" - {output_dir / 'resumen_comparativo.json'}")


if __name__ == "__main__":
    main()
