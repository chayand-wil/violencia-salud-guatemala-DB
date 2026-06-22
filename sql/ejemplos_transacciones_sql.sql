-- Ejemplos de transacciones en SQL (nivel básico a avanzado)

-- -----------------------------
-- Ejemplo 1: Transacción básica
-- -----------------------------
BEGIN;
    INSERT INTO demo (id, valor) VALUES (1, 'A');
    INSERT INTO demo (id, valor) VALUES (2, 'B');
COMMIT;

-- Si ocurre un error, puedes revertir:
BEGIN;
    INSERT INTO demo (id, valor) VALUES (3, 'C');
    -- Supón que aquí ocurre un error
ROLLBACK;

-- --------------------------------------
-- Ejemplo 2: Uso de SAVEPOINT
-- --------------------------------------
BEGIN;
    INSERT INTO demo (id, valor) VALUES (4, 'D');
    SAVEPOINT punto1;
    INSERT INTO demo (id, valor) VALUES (5, 'E');
    -- Si hay un error aquí, puedes volver al savepoint
    ROLLBACK TO punto1;
    -- Solo se deshace la inserción de 'E', pero 'D' sigue
COMMIT;

-- --------------------------------------
-- Ejemplo 3: Transacción de actualización
-- --------------------------------------
BEGIN;
    UPDATE demo SET valor = 'Z' WHERE id = 1;
    DELETE FROM demo WHERE id = 2;
COMMIT;

-- --------------------------------------
-- Ejemplo 4: Transacción anidada (varía según motor)
-- --------------------------------------
-- Algunos motores permiten múltiples savepoints:
BEGIN;
    SAVEPOINT a;
    INSERT INTO demo (id, valor) VALUES (6, 'F');
    SAVEPOINT b;
    INSERT INTO demo (id, valor) VALUES (7, 'G');
    ROLLBACK TO b;
    -- Solo se deshace la inserción de 'G'
    COMMIT;


-- =============================
-- Comandos de transacciones en Firebird
-- =============================
-- SET TRANSACTION
--   Inicia una nueva transacción. Permite definir el aislamiento y otras opciones.
--   Ejemplo:
--     SET TRANSACTION;

-- COMMIT
--   Confirma la transacción, haciendo permanentes todos los cambios realizados.
--   Ejemplo:
--     COMMIT;

-- ROLLBACK
--   Revierte todos los cambios hechos en la transacción actual.
--   Ejemplo:
--     ROLLBACK;

-- SAVEPOINT nombre
--   Crea un punto de guardado dentro de la transacción.
--   Ejemplo:
--     SAVEPOINT punto1;

-- ROLLBACK TO nombre
--   Revierte los cambios hechos después del SAVEPOINT especificado.
--   Ejemplo:
--     ROLLBACK TO punto1;

-- RELEASE SAVEPOINT nombre
--   Elimina el savepoint, liberando recursos.
--   Ejemplo:
--     RELEASE SAVEPOINT punto1;
