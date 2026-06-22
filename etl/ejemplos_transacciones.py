"""
Ejemplos de transacciones en Python con bases de datos (nivel básico a avanzado)
"""

import sqlite3

# -----------------------------
# Ejemplo 1: Transacción básica
# -----------------------------
def ejemplo_basico():
    conn = sqlite3.connect(':memory:')
    cursor = conn.cursor()
    cursor.execute('CREATE TABLE demo (id INTEGER, valor TEXT)')
    try:
        cursor.execute('INSERT INTO demo VALUES (?, ?)', (1, 'A'))
        cursor.execute('INSERT INTO demo VALUES (?, ?)', (2, 'B'))
        conn.commit()  # Confirma la transacción
        print('Transacción exitosa')
    except Exception as e:
        conn.rollback()  # Revierte si hay error
        print('Error:', e)
    finally:
        conn.close()

# --------------------------------------
# Ejemplo 2: Rollback por error
# --------------------------------------
def ejemplo_rollback():
    conn = sqlite3.connect(':memory:')
    cursor = conn.cursor()
    cursor.execute('CREATE TABLE demo (id INTEGER PRIMARY KEY, valor TEXT)')
    try:
        cursor.execute('INSERT INTO demo VALUES (?, ?)', (1, 'A'))
        cursor.execute('INSERT INTO demo VALUES (?, ?)', (1, 'B'))  # Error: id duplicado
        conn.commit()
    except Exception as e:
        conn.rollback()
        print('Rollback ejecutado por error:', e)
    finally:
        conn.close()

# ---------------------------------------------------
# Ejemplo 3: Transacciones anidadas (SAVEPOINT)
# ---------------------------------------------------
def ejemplo_savepoint():
    conn = sqlite3.connect(':memory:')
    cursor = conn.cursor()
    cursor.execute('CREATE TABLE demo (id INTEGER, valor TEXT)')
    try:
        cursor.execute('BEGIN')
        cursor.execute('INSERT INTO demo VALUES (?, ?)', (1, 'A'))
        cursor.execute('SAVEPOINT punto1')
        cursor.execute('INSERT INTO demo VALUES (?, ?)', (2, 'B'))
        cursor.execute('ROLLBACK TO punto1')  # Revierte solo hasta el savepoint
        conn.commit()
        print('Solo la primera inserción fue confirmada')
    except Exception as e:
        conn.rollback()
        print('Error:', e)
    finally:
        conn.close()

# ---------------------------------------------------
# Ejemplo 4: Uso en contexto real (Firebird, ver etl/etl_salud.py)
# ---------------------------------------------------
# En tu proyecto, el patrón es similar pero usando firebird.driver:
#
# from firebird.driver import connect as fb_connect
# conn = fb_connect(dsn=DSN, user=USER, password=PASS)
# cursor = conn.cursor()
# try:
#     # operaciones
#     conn.commit()
# except Exception:
#     conn.rollback()
# finally:
#     conn.close()

if __name__ == "__main__":
    print('Ejemplo básico:')
    ejemplo_basico()
    print('\nEjemplo con rollback:')
    ejemplo_rollback()
    print('\nEjemplo con savepoint:')
    ejemplo_savepoint()
