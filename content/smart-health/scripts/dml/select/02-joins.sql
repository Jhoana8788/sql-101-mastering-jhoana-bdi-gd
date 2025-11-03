
--5.  Mostrar los datos(primer nombre,genero,correo,numero de telefono)
-- del numero de telefono, para los siguientes pacientes.
--Filtrar por el campo numero_documento.

--['30451580',
--'1006631391',
--'1009149871',
--'1298083',
--'1004928596',
--'1008188849',
--'1607132',
--'30470003']

----INNER JOIN(muestra la interccion entre las dos tablas)

--FROM pacientes -> smart_health.patients : patients_id(PK)
--FROM pacientes -> smart_health.patient_phones  : patient_id(FK)

SELECT
    A.first_name AS primer_nombre,
    A.gender AS genero,
    A.email AS correo,
    B.phone_number AS numero_telefono

FROM smart_health.patients A
INNER JOIN smart_health.patient_phones B 
    ON A.patient_id =B.patient_id
WHERE A.document_number IN
(
'30451580',
'1006631391',
'1009149871',
'1298083',
'1004928596',
'1008188849',
'1607132',
'30470003' 
);


----------------------------------------------------------------------------------------

--5.  Mostrar los datos(primer nombre,genero,correo,numero de telefono) del numero de telefono, para los siguientes pacientes.
--Filtrar por el campo numero_documento.
--tengan o no tengan un numero asociado

--['30451580',
--'1006631391',
--'1009149871',
--'1298083',
--'1004928596',
--'1008188849',
--'1607132',
--'30470003']

----RIGHT JOIN(va todo lo de la derecha con la interccion)

--FROM pacientes -> smart_health.patients : patients_id(PK)
--FROM pacientes -> smart_health.patient_phones  : patient_id(FK)


SELECT
    B.first_name AS primer_nombre,
    B.gender AS genero,
    B.email AS correo,
    A.phone_number AS numero_telefono

FROM smart_health.patient_phones A
RIGHT JOIN smart_health.patients B 
    ON A.patient_id =B.patient_id
WHERE B.document_number IN
(
'30451580',
'1006631391',
'1009149871',
'1298083',
'1004928596',
'1008188849',
'1607132',
'30470003' 
);

------------------------------------------------------------------------------------------------------

--6)  vamos a conar cuales son los medicos que no tienen una direccion asociada 

-- asociada
--FROM pacientes -> smart_health.doctors : doctor_id(PK)
--FROM pacientes -> smart_health.doctor_addresses  : doctor_id(FK)

SELECT 
    COUNT(*) AS total_doctores_sin_direccion
FROM smart_health.doctors A 
LEFT JOIN smart_health.doctor_addresses B
    ON A.doctor_id = B.doctor_id
WHERE B.doctor_id IS NULL;



------------------------------------------------------------------------------------------------


--mostrar el nombre completo del paciente, 
--el genero, tipo de sangre, direccion,ciudad y departamento 
--de los pacientes que viven en pamplona norte de santander 
--ordenar por el primer nombre de forma alfabetica.
--mostrar los primeros 5 resultados

--RIGHT JOIN

SELECT
    T1.first_name||' '||COALESCE(T1.middle_name, '')||' '||
    T1.first_surname||' '||COALESCE(T1.second_surname, '') AS paciente,
    T1.gender AS genero,
    T1.blood_type AS tipo_sangre,
    T2.address_type AS tipo_direccion,
    T3.address_line AS direccion,
    T3.postal_code AS codigo_postal,
    T4.municipality_name AS ciudad,
    T5.department_name AS departamento

FROM smart_health.patients T1
INNER JOIN smart_health.patient_addresses T2
    ON T1.patient_id = T2.patient_id
INNER JOIN smart_health.addresses T3
    ON T3.address_id = T2.address_id
INNER JOIN smart_health.municipalities T4
    ON T4.municipality_code = T3.municipality_code
INNER JOIN smart_health.departments T5
    ON T5.department_code = T4.department_code
WHERE T4.municipality_name LIKE '%PAMPLONA%'
ORDER BY T1.first_name
LIMIT 5;


-------------------------------------------------------------------------------------
--1. Obtener los nombres, apellidos y 
--número de documento de los pacientes junto con 
--el nombre del tipo de documento al que pertenecen.



SELECT
    T1.first_name||' '||COALESCE(T1.middle_name, '')||' '||
    T1.first_surname||' '||COALESCE(T1.second_surname, '') AS paciente,

FROM smart_health.patients T1
INNER JOIN smart_health.patient_addresses T2
    ON T1.patient_id = T2.patient_id
INNER JOIN smart_health.addresses T3
    ON T3.patient_id = T2.patient_id
INNER JOIN smart_health.patient_phones T4
    ON T4.patient_id = T3.patient_id
INNER JOIN smart_health.patient_documents T5
    ON T5.patient_id = T4.patient_id
LIMIT 5;