from collections import Counter
from pathlib import Path
import re

import pandas as pd


SRC = Path("datos_base/Violencia/Violencia estructural/CASOS DISCRIMINACIÓN 2016-2023.xls")
MUNI_FILE = Path("catalogos/municipios/municipios- depto.txt")

OUT_CAT_TIPO = Path("sql/inserts/catalogos/054_tipo_discriminacion_violencia_estructural.sql")
OUT_CAT_IDIOMA = Path("sql/inserts/catalogos/055_idioma_lengua_violencia_estructural.sql")
OUT_CAT_GRUPO = Path("sql/inserts/catalogos/056_grupo_etnico_violencia_estructural.sql")
OUT_TX = Path("sql/inserts/transaccional/107_violencia_estructural_batch1.sql")


def clean(value) -> str:
    if pd.isna(value):
        return ""
    return str(value).strip()


def norm(value: str) -> str:
    text = clean(value).upper()
    for source, target in (("Á", "A"), ("É", "E"), ("Í", "I"), ("Ó", "O"), ("Ú", "U"), ("Ü", "U"), ("Ñ", "N")):
        text = text.replace(source, target)
    text = re.sub(r"\s+", " ", text)
    text = text.replace("´", "'").replace("`", "'")
    return text


def sqlq(value: str) -> str:
    return "'" + str(value).replace("'", "''") + "'"


def cut_utf8(value: str, max_bytes: int) -> str:
    text = clean(value)
    if len(text.encode("utf-8")) <= max_bytes:
        return text
    raw = text.encode("utf-8")[:max_bytes]
    while True:
        try:
            return raw.decode("utf-8")
        except UnicodeDecodeError:
            raw = raw[:-1]


def parse_municipios(path: Path):
    lines = path.read_text(encoding="utf-8", errors="ignore").splitlines()
    mode = None
    departments = {}
    municipalities = []
    for line in lines:
        stripped = line.strip()
        if not stripped:
            continue
        lower = stripped.lower()
        if "departamentos" in lower:
            mode = "dept"
            continue
        if "municipios" in lower:
            mode = "muni"
            continue
        match = re.match(r"^(\d+)\t(.+)$", stripped)
        if not match:
            continue
        code = int(match.group(1))
        name = match.group(2).strip()
        if mode == "dept":
            departments[code] = name
        elif mode == "muni":
            municipalities.append((code, name))

    dept_by_norm = {norm(name): (code, name) for code, name in departments.items()}
    muni_by_norm = {}
    first_muni_by_dept = {}
    for code, name in sorted(municipalities):
        dept_code = code // 100
        first_muni_by_dept.setdefault(dept_code, name)
        muni_by_norm.setdefault(norm(name), []).append((dept_code, name))
    return dept_by_norm, muni_by_norm, first_muni_by_dept


def canonical_tipo(raw: str) -> str | None:
    value = norm(raw)
    if not value:
        return None
    if value in {"ETNICA", "RACIAL"}:
        return "Étnica" if value == "ETNICA" else "Racial"
    if value in {"RACIAL Y ETNICA", "ETNICA Y RACIAL"}:
        return "Racial y Étnica"
    if value in {"ETNICA/ GENERO", "ETNICA / GENERO", "ETNICA GENERO"}:
        return "Étnica/ Género"
    if value in {"DISCRIMINACION", "DISCRIMINACION ", "DISCRIMINACION  "}:
        return "Discriminación"
    if value in {"DISCRIMINACION ETNICA", "DISCRIMINACION ETNICA ", "DISCRIMINACION ETNICA."}:
        return "Discriminación Étnica"
    if value in {"ETNICA LABORAL"}:
        return "Étnica laboral"
    if value in {"ETNICA RACIAL"}:
        return "Étnica racial"
    return clean(raw).title() if clean(raw) else None


def canonical_language(raw: str) -> str | None:
    value = norm(raw)
    if not value or value in {"X", "0", "1", "NO INDICA"}:
        return None
    mappings = {
        "* IDIOMA GARIFUNA": "Garífuna",
        "GARIFUNA": "Garífuna",
        "KAQCHIKEL": "Kaqchikel",
        "KICHE": "K'iche'",
        "KI CHE": "K'iche'",
        "K'ICHE'": "K'iche'",
        "K`ICHE`": "K'iche'",
        "K´ICHE´": "K'iche'",
        "Q'EQCHI'": "Q'eqchi'",
        "Q`EQCHI`": "Q'eqchi'",
        "Q´EQCHI´": "Q'eqchi'",
        "MAM": "Mam",
        "IXIL": "Ixil",
        "TZ'UTUJIL": "Tz'utujil",
        "TZ´UTUJIL": "Tz'utujil",
        "CHORTI": "Ch'orti'",
        "Q'ANJOB'AL": "Q'anjob'al",
        "JAKALTEKA": "Jakalteka",
        "POQOMCH'": "Poqomch'",
        "NAHUATL": "Náhuatl",
        "XINCA": "Xinka",
    }
    return mappings.get(value, clean(raw))


def canonical_group(raw: str | None) -> str | None:
    value = norm(raw)
    if not value or value in {"NO INDICA", "X", "0", "1"}:
        return None
    if value in {"MAYA", "MAYA "}:
        return "Maya"
    if value in {"GARIFUNA"}:
        return "Garífuna"
    if value in {"XINKA"}:
        return "Xinka"
    return clean(raw).title() if clean(raw) else None


def resolve_location(raw_place: str, dept_by_norm, muni_by_norm, first_muni_by_dept):
    place = clean(raw_place)
    if not place or norm(place) in {"NO INDICA"}:
        return "Guatemala", first_muni_by_dept.get(next(iter(sorted(first_muni_by_dept))), "Guatemala")

    place_norm = norm(place)
    if place_norm in dept_by_norm:
        dept_code, dept_name = dept_by_norm[place_norm]
        return dept_name, first_muni_by_dept.get(dept_code, dept_name)

    if place_norm in muni_by_norm:
        dept_code, muni_name = muni_by_norm[place_norm][0]
        dept_name = dept_by_norm.get(next((k for k, v in dept_by_norm.items() if v[0] == dept_code), None), (dept_code, "Guatemala"))[1]
        return dept_name, muni_name

    fallback = {
        "QUICHE": "Quiché",
        "QUETZALTENANGO": "Quetzaltenango",
        "SACATEPEQUEZ": "Sacatepéquez",
        "TOTONICAPAN": "Totonicapán",
        "HUEHUETENANGO": "Huehuetenango",
        "ALTA VERAPAZ": "Alta Verapaz",
        "IZABAL": "Izabal",
        "GUATEMALA": "Guatemala",
        "CHIQUIMULA": "Chiquimula",
        "SOLOLA": "Sololá",
        "SAN MARCOS": "San Marcos",
    }
    if place_norm in fallback:
        dept_name = fallback[place_norm]
        dept_code, _ = dept_by_norm.get(norm(dept_name), (0, dept_name))
        return dept_name, first_muni_by_dept.get(dept_code, dept_name)

    return "Guatemala", first_muni_by_dept.get(next(iter(sorted(first_muni_by_dept))), "Guatemala")


def parse_age(raw_age) -> int:
    text = clean(raw_age)
    if not text:
        return 30
    if "-" in text:
        parts = [p.strip() for p in text.split("-") if p.strip().isdigit()]
        if len(parts) == 2:
            return max(1, int((int(parts[0]) + int(parts[1])) / 2))
    try:
        return max(1, int(float(text)))
    except Exception:
        return 30


def detect_case_rows(df: pd.DataFrame, sheet_name: str):
    for _, row in df.iterrows():
        values = row.tolist()
        first = clean(values[0])
        if not first.isdigit():
            continue
        if sheet_name in {"2016", "2017", "2018", "2019"}:
            nonempty = sum(1 for value in values[1:] if clean(value))
            if nonempty < 5:
                continue
            yield values
        else:
            markers = [clean(values[index]) if index < len(values) else "" for index in (4, 5, 6)]
            if not any(markers):
                continue
            if len(values) < 10 or not clean(values[8]) or not clean(values[9]):
                continue
            yield values


def case_multiplier(values, sheet_name: str) -> int:
    if sheet_name in {"2016", "2017", "2018", "2019"}:
        male = clean(values[1])
        female = clean(values[2])
        if not male and not female:
            return 0
        total = 0
        for marker in (male, female):
            if marker.isdigit():
                total += int(marker)
            elif marker:
                total += 1
        return total or 1
    return 1


def source_type_value(values, sheet_name: str) -> str:
    if sheet_name in {"2016", "2017", "2018", "2019"}:
        return values[5] if len(values) > 5 else ""
    return values[9] if len(values) > 9 else ""


def source_group_value(values, sheet_name: str) -> str | None:
    if sheet_name in {"2016", "2017", "2018", "2019"}:
        return values[6] if len(values) > 6 else ""
    for index, label in ((4, "Maya"), (5, "Garífuna"), (6, "Xinka")):
        if index < len(values) and clean(values[index]):
            return label
    return None


def build_catalogs(rows):
    tipo_values = sorted({canonical_tipo(source_type_value(item["values"], item["sheet"])) for item in rows if canonical_tipo(source_type_value(item["values"], item["sheet"]))})
    language_values = sorted({canonical_language(item["values"][7] if len(item["values"]) > 7 else "") for item in rows if canonical_language(item["values"][7] if len(item["values"]) > 7 else "")})
    group_values = sorted({canonical_group(source_group_value(item["values"], item["sheet"])) for item in rows if canonical_group(source_group_value(item["values"], item["sheet"]))})

    tipo_lines = ["SET NAMES UTF8;", ""]
    for value in tipo_values:
        tipo_lines.append(
            "INSERT INTO tipo_discriminacion (nombre, descripcion) "
            f"SELECT {sqlq(value)}, 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE "
            f"WHERE NOT EXISTS (SELECT 1 FROM tipo_discriminacion WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(value)}));"
        )
    tipo_lines.extend(["", "COMMIT;"])
    OUT_CAT_TIPO.write_text("\n".join(tipo_lines), encoding="utf-8")

    idioma_lines = ["SET NAMES UTF8;", ""]
    for value in language_values:
        idioma_lines.append(
            "INSERT INTO idioma_lengua (nombre, familia_linguistica) "
            f"SELECT {sqlq(value)}, NULL FROM RDB$DATABASE "
            f"WHERE NOT EXISTS (SELECT 1 FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(value)}));"
        )
    idioma_lines.extend(["", "COMMIT;"])
    OUT_CAT_IDIOMA.write_text("\n".join(idioma_lines), encoding="utf-8")

    grupo_lines = ["SET NAMES UTF8;", ""]
    for value in group_values:
        grupo_lines.append(
            "INSERT INTO grupo_etnico (nombre, descripcion) "
            f"SELECT {sqlq(value)}, 'Fuente CASOS DISCRIMINACION 2016-2023' FROM RDB$DATABASE "
            f"WHERE NOT EXISTS (SELECT 1 FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(value)}));"
        )
    grupo_lines.extend(["", "COMMIT;"])
    OUT_CAT_GRUPO.write_text("\n".join(grupo_lines), encoding="utf-8")

    return tipo_values, language_values, group_values


def main() -> None:
    workbook = pd.ExcelFile(SRC)
    dept_by_norm, muni_by_norm, first_muni_by_dept = parse_municipios(MUNI_FILE)
    all_rows = []
    sheet_rows = []
    for sheet_name in workbook.sheet_names:
        df = pd.read_excel(SRC, sheet_name=sheet_name, header=None)
        for values in detect_case_rows(df, sheet_name):
            row = {"sheet": sheet_name, "values": values}
            sheet_rows.append(row)
            all_rows.append(values)

    tipo_values, language_values, group_values = build_catalogs(all_rows)

    tx_lines = ["SET NAMES UTF8;", "SET TERM ^ ;", ""]
    total_cases = 0
    for item in sheet_rows:
        sheet_name = item["sheet"]
        values = item["values"]
        year = int(sheet_name)
        record_no = clean(values[0])
        multiplier = case_multiplier(values, sheet_name)
        if multiplier <= 0:
            continue

        if sheet_name in {"2016", "2017", "2018", "2019"}:
            sex_flag = "Hombre" if clean(values[1]) == "1" else "Mujer" if clean(values[2]) == "1" else "Ignorado"
            age_raw = values[3] if len(values) > 3 else ""
            place_raw = values[4] if len(values) > 4 else ""
            tipo_raw = canonical_tipo(values[5] if len(values) > 5 else "")
            group_raw = canonical_group(values[6] if len(values) > 6 else "")
            language_raw = canonical_language(values[7] if len(values) > 7 else "")
        else:
            sex_flag = "Mujer" if clean(values[1]) == "1" else "Hombre" if clean(values[2]) == "1" else "Ignorado"
            age_raw = values[3] if len(values) > 3 else ""
            if clean(values[4]):
                group_raw = "Maya"
            elif clean(values[5]):
                group_raw = "Garífuna"
            elif clean(values[6]):
                group_raw = "Xinka"
            else:
                group_raw = None
            language_raw = canonical_language(values[7] if len(values) > 7 else "")
            place_raw = values[8] if len(values) > 8 else ""
            tipo_raw = canonical_tipo(values[9] if len(values) > 9 else "")

        if not tipo_raw:
            continue

        dept_name, muni_name = resolve_location(place_raw, dept_by_norm, muni_by_norm, first_muni_by_dept)
        age = parse_age(age_raw)
        birth_year = year - age
        birth_date = f"{birth_year:04d}-06-15"
        fecha_evento = f"{year:04d}-06-15"

        for copy_no in range(1, multiplier + 1):
            synthetic_code = f"CDS_{year}_{int(record_no):03d}_{copy_no:02d}"
            tx_lines.append(
                f"EXECUTE BLOCK AS\n"
                f"  DECLARE v_dept INTEGER;\n"
                f"  DECLARE v_muni INTEGER;\n"
                f"  DECLARE v_ubic INTEGER;\n"
                f"  DECLARE v_genero INTEGER;\n"
                f"  DECLARE v_estado INTEGER;\n"
                f"  DECLARE v_condicion INTEGER;\n"
                f"  DECLARE v_nivel INTEGER;\n"
                f"  DECLARE v_grupo INTEGER;\n"
                f"  DECLARE v_lengua INTEGER;\n"
                f"  DECLARE v_tipo_hecho INTEGER;\n"
                f"  DECLARE v_tipo_discriminacion INTEGER;\n"
                f"  DECLARE v_persona INTEGER;\n"
                f"  DECLARE v_hecho INTEGER;\n"
                f"  DECLARE v_violencia INTEGER;\n"
                f"BEGIN\n"
                f"  IF (EXISTS(SELECT 1 FROM persona p WHERE p.nombres = {sqlq(synthetic_code)} AND p.apellidos = 'VIOLENCIA ESTRUCTURAL')) THEN EXIT;\n"
                f"\n"
                f"  SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(dept_name)}) ROWS 1 INTO v_dept;\n"
                f"  IF (v_dept IS NULL) THEN SELECT id_departamento FROM departamento WHERE UPPER(TRIM(nombre)) = UPPER('Guatemala') ROWS 1 INTO v_dept;\n"
                f"  SELECT id_municipio FROM municipio WHERE id_departamento = :v_dept AND UPPER(TRIM(nombre)) = UPPER({sqlq(muni_name)}) ROWS 1 INTO v_muni;\n"
                f"  IF (v_muni IS NULL) THEN SELECT id_municipio FROM municipio WHERE id_departamento = :v_dept ORDER BY id_municipio ROWS 1 INTO v_muni;\n"
                f"  SELECT id_ubicacion FROM ubicacion WHERE id_municipio = :v_muni ROWS 1 INTO v_ubic;\n"
                f"  IF (v_ubic IS NULL) THEN INSERT INTO ubicacion (id_municipio, id_area_geografica, ciudad, zona, direccion_referencia) VALUES (:v_muni, NULL, NULL, NULL, NULL) RETURNING id_ubicacion INTO v_ubic;\n"
                f"\n"
                f"  SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(sex_flag)}) ROWS 1 INTO v_genero;\n"
                f"  IF (v_genero IS NULL) THEN SELECT id_genero FROM genero WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_genero;\n"
                f"  SELECT id_estado_civil FROM estado_civil WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_estado;\n"
                f"  SELECT id_condicion_alfabetica FROM condicion_alfabetica WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_condicion;\n"
                f"  SELECT id_nivel_escolaridad FROM nivel_escolaridad WHERE UPPER(TRIM(nombre)) = UPPER('Ignorado') ROWS 1 INTO v_nivel;\n"
                f"  SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(group_raw or 'Maya')}) ROWS 1 INTO v_grupo;\n"
                f"  IF (v_grupo IS NULL) THEN SELECT id_grupo_etnico FROM grupo_etnico WHERE UPPER(TRIM(nombre)) = UPPER('Maya') ROWS 1 INTO v_grupo;\n"
                f"  SELECT id_lengua FROM idioma_lengua WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(language_raw or 'Kaqchikel')}) ROWS 1 INTO v_lengua;\n"
                f"  SELECT id_tipo_hecho FROM tipo_hecho WHERE UPPER(TRIM(nombre)) = UPPER('violencia_esctructural') ROWS 1 INTO v_tipo_hecho;\n"
                f"  SELECT id_tipo_discriminacion FROM tipo_discriminacion WHERE UPPER(TRIM(nombre)) = UPPER({sqlq(tipo_raw)}) ROWS 1 INTO v_tipo_discriminacion;\n"
                f"\n"
                f"  INSERT INTO persona (nombres, apellidos, fecha_nacimiento, cui, id_genero, id_orientacion_sexual, id_grupo_etnico, id_estado_civil, id_condicion_alfabetica, id_nivel_escolaridad, id_origen, es_extranjero)\n"
                f"  VALUES ({sqlq(synthetic_code)}, 'VIOLENCIA ESTRUCTURAL', {sqlq(birth_date)}, NULL, :v_genero, (SELECT FIRST 1 id_orientacion_sexual FROM orientacion_sexual WHERE UPPER(TRIM(nombre)) IN ('IGNORADO', 'SIN SELECCION') ORDER BY id_orientacion_sexual), :v_grupo, :v_estado, :v_condicion, :v_nivel, :v_ubic, 0)\n"
                f"  RETURNING id_persona INTO v_persona;\n"
                f"\n"
                f"  INSERT INTO hecho (id_tipo_hecho, id_ubicacion, fecha_hecho) VALUES (:v_tipo_hecho, :v_ubic, {sqlq(fecha_evento)}) RETURNING id_hecho INTO v_hecho;\n"
                f"\n"
                f"  INSERT INTO violencia_estructural (id_hecho, id_victima, id_tipo_discriminacion) VALUES (:v_hecho, :v_persona, :v_tipo_discriminacion) RETURNING id_violencia_estructural INTO v_violencia;\n"
                f"\n"
                f"  IF (v_lengua IS NOT NULL) THEN INSERT INTO idioma_persona (id_persona, id_lengua) VALUES (:v_persona, :v_lengua);\n"
                f"END^"
            )
            tx_lines.append("")
            total_cases += 1

    tx_lines.extend(["SET TERM ; ^", "COMMIT;"])
    OUT_TX.write_text("\n".join(tx_lines), encoding="utf-8")

    print(f"Casos detectados: {total_cases}")
    print(f"Catalogos: {OUT_CAT_TIPO.name}, {OUT_CAT_IDIOMA.name}, {OUT_CAT_GRUPO.name}")
    print(f"Transaccional: {OUT_TX}")


if __name__ == "__main__":
    main()