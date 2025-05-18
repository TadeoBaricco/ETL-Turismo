/* Borro las tablas si existen */
DROP TABLE IF EXISTS public.turismo_residentes;
DROP TABLE IF EXISTS public.balanza_turistica;
DROP TABLE IF EXISTS public.turismo_no_residentes;
DROP TABLE IF EXISTS public.medio_transporte;
DROP TABLE IF EXISTS public.pais;

/* Creo las tablas para la base de datos definitiva, respetando todas las formas normales */
CREATE TABLE public.pais (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR UNIQUE
);

CREATE TABLE public.medio_transporte (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR UNIQUE
);

CREATE TABLE public.turismo_residentes (
  indice_tiempo DATE,
  id_medio_de_transporte INT,
  id_pais_destino INT,
  viajes_de_turistas_residentes INT,
  FOREIGN KEY (id_medio_de_transporte) REFERENCES medio_transporte(id),
  FOREIGN KEY (id_pais_destino) REFERENCES pais(id)
);

CREATE TABLE public.turismo_no_residentes (
  indice_tiempo DATE,
  id_medio_de_transporte INT,
  id_pais_origen INT,
  viajes_de_turistas_no_residentes INT,
  FOREIGN KEY (id_medio_de_transporte) REFERENCES medio_transporte(id),
  FOREIGN KEY (id_pais_origen) REFERENCES pais(id)
);

CREATE TABLE public.balanza_turistica (
  indice_tiempo DATE,
  id_medio_de_transporte INT,
  id_pais INT,
  balanza INT,
  FOREIGN KEY (id_medio_de_transporte) REFERENCES medio_transporte(id),
  FOREIGN KEY (id_pais) REFERENCES pais(id)
);

/* Creo las tablas temporales para cargar los datos desde CSV no normalizados */
CREATE TEMPORARY TABLE tmp_residentes (
  indice_tiempo DATE,
  medio_de_transporte VARCHAR,
  pais_destino VARCHAR,
  viajes_de_turistas_residentes INT
);

CREATE TEMPORARY TABLE tmp_no_residentes (
  indice_tiempo DATE,
  medio_de_transporte VARCHAR,
  pais_origen VARCHAR,
  viajes_de_turistas_no_residentes INT
);

CREATE TEMPORARY TABLE tmp_balanza (
  indice_tiempo DATE,
  medio_de_transporte VARCHAR,
  pais VARCHAR,
  balanza INT
);

/* Cargo los datos en las tablas temporales */
\copy tmp_residentes FROM '../DATOS/turistas-residentes-serie.csv' WITH (FORMAT csv, HEADER);
\copy tmp_no_residentes FROM '../DATOS/turistas-no-residentes-serie.csv' WITH (FORMAT csv, HEADER);
\copy tmp_balanza FROM '../DATOS/saldo-turistas-serie.csv' WITH (FORMAT csv, HEADER);

/* Cargo los datos en las tablas definitivas, asegurando integridad referencial */

-- Insertar medios de transporte únicos
INSERT INTO medio_transporte (nombre)
SELECT DISTINCT TRIM(medio_de_transporte)
FROM (
    SELECT medio_de_transporte FROM tmp_residentes
    UNION
    SELECT medio_de_transporte FROM tmp_no_residentes
    UNION
    SELECT medio_de_transporte FROM tmp_balanza
) AS t
WHERE TRIM(medio_de_transporte) NOT IN (SELECT nombre FROM medio_transporte);

-- Insertar países únicos
INSERT INTO pais (nombre)
SELECT DISTINCT TRIM(nombre)
FROM (
    SELECT pais_destino AS nombre FROM tmp_residentes
    UNION
    SELECT pais_origen AS nombre FROM tmp_no_residentes
    UNION
    SELECT pais AS nombre FROM tmp_balanza
) AS t
WHERE TRIM(nombre) NOT IN (SELECT nombre FROM pais);

INSERT INTO turismo_residentes ( indice_tiempo, id_medio_de_transporte, id_pais_destino, viajes_de_turistas_residentes )
SELECT
    r.indice_tiempo,
    (SELECT id FROM medio_transporte WHERE nombre = TRIM(r.medio_de_transporte)),
    (SELECT id FROM pais WHERE nombre = TRIM(r.pais_destino)),
    r.viajes_de_turistas_residentes
FROM tmp_residentes r;

INSERT INTO turismo_no_residentes ( indice_tiempo, id_medio_de_transporte, id_pais_origen, viajes_de_turistas_no_residentes )
SELECT
    nr.indice_tiempo,
    (SELECT id FROM medio_transporte WHERE nombre = TRIM(nr.medio_de_transporte)),
    (SELECT id FROM pais WHERE nombre = TRIM(nr.pais_origen)),
    nr.viajes_de_turistas_no_residentes
FROM tmp_no_residentes nr;

INSERT INTO balanza_turistica ( indice_tiempo, id_medio_de_transporte, id_pais, balanza )
SELECT
    b.indice_tiempo,
    (SELECT id FROM medio_transporte WHERE nombre = TRIM(b.medio_de_transporte)),
    (SELECT id FROM pais WHERE nombre = TRIM(b.pais)),
    b.balanza
FROM tmp_balanza b;
