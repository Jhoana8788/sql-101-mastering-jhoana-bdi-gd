--INNER JOIN
--smart_healt.patients : Fk(document_type_id)
--smart_healt.document_types :PK(document_type_id)
--agregar funcion : COUNT


SELECT
    T2.type_name AS tipo_documeto,
    COUNT(*) AS total_documentos
FROM smart_health.patients T1
INNER JOIN smart_health.document_types T2
    ON T1.document_type_id = T2.document_type_id
GROUP BY T2.type_name
ORDER BY total_documentos DESC;

--                         tipo_documeto                            | total_documentos
---------------------------------------------------------------------+------------------
-- Cédula de Ciudadanía                                                |             7630
--Número Único de Identificación Personal (NUIP)                       |             7594
-- Registro Civil de Nacimiento                                        |             7490
-- Cédula de Extranjería / Identificación de Extranjería               |             7482
-- Tarjeta de Identidad                                                |             7481
-- Número de Identificación establecido por la Secretaría de Educación |             7457
-- Certificado Cabildo                                                 |             7450
-- Número de Identificación Personal (NIP)                             |             7416
--(8 filas)

-------------------------------------------------------------------------------------------------------------------


SELECT  
    birth_date,
    EXTRACT(YEAR FROM AGE(birth_date)) AS avg_years
FROM smart_health.patients;


--PROMEDIO
SELECT
    AVG(EXTRACT(YEAR FROM AGE(birth_date))) AS avg_years
FROM smart_health.patients;

-----------------------------------------------------------------------

--MINIMO,MAXIMO
SELECT
    T1.first_name||' '||COALESCE(T1.middle_name,'')||' '||T1.first_surname||' '||COALESCE(T1.second_surname,'') AS Paciente,
    T2.appointment_date AS FECHA_MIN

FROM smart_health.patients T1
INNER JOIN smart_health.appointments T2
    ON T1.patient_id = T2.patient_id
WHERE T2.appointment_date = (
    SELECT MIN(appointment_date) FROM smart_health.appointments
)
LIMIT 1;

SELECT
    T1.first_name||' '||COALESCE(T1.middle_name,'')||' '||T1.first_surname||' '||COALESCE(T1.second_surname,'') AS Paciente,
    T2.appointment_date AS FECHA_MAX

FROM smart_health.patients T1
INNER JOIN smart_health.appointments T2
    ON T1.patient_id = T2.patient_id
WHERE T2.appointment_date = (
    SELECT MAX(appointment_date) FROM smart_health.appointments
)
LIMIT 1;



-----------------------------------------------------------------------------


--DIFERENCIA DE LA EDAD 
SELECT 
    AGE(CURRENT_DATE, '2005-09-20');


---------------------------------------------------------------------------
--LOS PACIENTES MAS VIEJOS TOP 5

SELECT
    first_name||' '||COALESCE(middle_name, '')||' '||first_surname||' '||COALESCE(second_surname, '') AS nombre_completo,
    EXTRACT(YEAR FROM birth_date) AS age

FROM smart_health.patients
GROUP BY first_name, middle_name, first_surname, second_surname, birth_date
ORDER BY age DESC
LIMIT 5;

--           nombre_completo          | age
-- -----------------------------------+------
--  Carolina Del Pilar Rincón Ramírez | 2006
--  María Isabel Díaz León            | 2006
--  Rodrigo Carolina Martínez Torres  | 2006
--  Karen  Ortiz Pardo                | 2006
--  Tatiana Lucía Cabrera Ramírez     | 2006
-- (5 filas)


----------------------------------------------------------------------------------------------



-- 1. Contar cuántos pacientes están registrados por cada tipo de documento,
-- mostrando el nombre del tipo de documento y la cantidad total de pacientes,
-- ordenados por cantidad de mayor a menor.
-- Dificultad: BAJA

SELECT
    T2.type_name AS tipo_documeto,
    COUNT(*) AS total_documentos
FROM smart_health.patients T1
INNER JOIN smart_health.document_types T2
    ON T1.document_type_id = T2.document_type_id
GROUP BY T2.type_name
ORDER BY total_documentos DESC;


--                            tipo_documento                            | total_documentos
-- ---------------------------------------------------------------------+------------------
--  Cédula de Ciudadanía                                                |             7630
--  Número Único de Identificación Personal (NUIP)                      |             7594
--  Registro Civil de Nacimiento                                        |             7490
--  Cédula de Extranjería / Identificación de Extranjería               |             7482
--  Tarjeta de Identidad                                                |             7481
--  Número de Identificación establecido por la Secretaría de Educación |             7457
--  Certificado Cabildo                                                 |             7450
--  Número de Identificación Personal (NIP)                             |             7416
-- (8 filas)

----------------------------------------------------------------------------------------------------------------





-- 2. Mostrar el número de citas programadas por cada médico,
-- incluyendo el nombre completo del doctor y el total de citas,
-- ordenadas alfabéticamente por apellido del médico.
-- Dificultad: BAJA

SELECT
    T1.first_name||' '||T1.last_name AS doctor,
    COUNT(*) AS total_citas

FROM smart_health.doctors T1
INNER JOIN smart_health.appointments T2
    ON T1.doctor_id = T2.doctor_id
GROUP BY T1.doctor_id, T1.first_name, T1.last_name
ORDER BY T1.last_name
LIMIT 5;

----------------------------------------------------------------------------------------------------------

-- 3. Calcular el promedio de edad de los pacientes agrupados por género,
-- mostrando el género y la edad promedio redondeada a dos decimales.
-- Dificultad: INTERMEDIA

SELECT
    gender,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(birth_date))),2) AS promedio_edad

FROM smart_health.patients
GROUP BY gender;
--  gender | promedio_edad
-- --------+-------
--  M      | 41.90
--  O      | 41.87
--  F      | 41.96
-- (3 filas)

---------------------------------------------------------------------------------------

-- 4. Obtener el número total de prescripciones realizadas por cada medicamento,
-- mostrando el nombre comercial del medicamento, el principio activo,
-- y la cantidad de veces que ha sido prescrito, solo para aquellos medicamentos
-- que tengan al menos 5 prescripciones.
-- Dificultad: INTERMEDIA

SELECT
    T2.commercial_name,
    T2.active_ingredient,
    COUNT(*) AS total_prescripciones

FROM smart_health.prescriptions T1
INNER JOIN smart_health.medications T2
    ON T1.medication_id = T2.medication_id
GROUP BY T2.commercial_name, T2.active_ingredient
HAVING COUNT(*) >= 5
ORDER BY total_prescripciones DESC;
LIMIT 5;


--   commercial_name  | active_ingredient | total_prescripciones
-- -------------------+-------------------+----------------------
--  OXIMETAZOLINA MK  | OXIMETAZOLINA     |                   77
--  METOCLOPRAMIDA MK | METOCLOPRAMIDA    |                   76
--  ACETILCISTEÍNA MK | ACETILCISTEÍNA    |                   72
--  DILTIAZEM MK      | DILTIAZEM         |                   64
--  DIGOXINA MK       | DIGOXINA          |                   63
-- (5 filas)

---------------------------------------------------------------------------------------------------------

-- 5. Listar el número de citas por estado y tipo de cita,
-- mostrando cuántas citas existen para cada combinación de estado y tipo,
-- ordenadas primero por estado y luego por la cantidad de citas de mayor a menor,
-- incluyendo solo aquellas combinaciones que tengan más de 3 citas.
-- Dificultad: INTERMEDIA-ALTA

SELECT
    status,
    appointment_type,
    COUNT(*) AS total_citas

FROM smart_health.appointments
GROUP BY status, appointment_type
HAVING COUNT(*) >= 3
ORDER BY status, 
total_citas DESC;
--LIMIT 5;

--   status  | appointment_type | total_citas
-- ----------+------------------+-------------
--  Attended | Examen Médico    |        2189
--  Attended | Consulta General |        2183
--  Attended | Nutrición        |        2162
--  Attended | Teleconsulta     |        2152
--  Attended | Control          |        2150
-- (5 filas)

------------------------------------------------------------------------------------------------------

--TOP 5 de personas con los nombres de mayor longitud.
SELECT
    first_name,
    LENGTH(first_name) AS total_length
FROM smart_health.patients
GROUP BY first_name
ORDER BY total_length DESC
LIMIT 5; 


SELECT AVG(LENGTH(first_name))

----------------------------------------------------------------------------------------------------------
--mostrar el top 10 de personas con el nombre mas largo por encima del promedio 
SELECT 
    first_name, 
    LENGTH(first_name) AS total_length
FROM smart_health.patients
WHERE LENGTH(first_name) > (
    SELECT AVG(LENGTH(first_name)) FROM smart_health.patients
)
ORDER BY total_length DESC
LIMIT 5;

------------------------------------------------------------------------------------------------------------------
SELECT 
    email,
    SPLIT_PART(email, '@' , 2) AS domain_email
FROM smart_health.patients
LIMIT 5;
---------------------------------------------------------------------------------------------------------
SELECT 
    SPLIT_PART(email, '@' , 2) AS domain,
    COUNT(*) AS total_emails
FROM smart_health.patients
GROUP BY domain
ORDER BY total_emails DESC;

---------------------------------------------------------------------------------------------------------
--GMAIL
--HOTMAIL
--YAHOO
( FROM
SELECT 
    SPLIT_PART(email, '@', 2) AS domain,
    COUNT(*) AS total_emails
FROM smart_health.patients
WHERE SPLIT_PART(email, '@', 2) IN ('gmail.com','yahoo.com','hotmail.com')
GROUP BY domain
ORDER BY total_emails DESC
) sq;


-------------------------------------------------------------------------------------------------------------
SELECT 
    CONCAT(SUBSTRING(SPLIT_PART('Astrid Jhoana Zambrano'),'',1),1,1),
    SUBSTRING(SPLIT_PART('Astrid Jhoana Zambrano','',2),1,1),
    SPLIT_PART('Astrid Jhoana Zambrano','' ,3) AS report_name;
--terminar 


---------------------------------------------------------------------------
SELECT 
    CONCAT(first_name, '' , middle_name)
FROM smart_health.patients
WHERE  CONCAT(first_name, '' , middle_name) LIKE '%Adriana%'
LIMIT 5;

----------------------------------------------------------------------------
SELECT DISTINCT
    