--Mostrar el nombre completo, correo y el genero de los pacientes nacidas entre
--1990 y 1993. listar las 5 primeras personas, alfabeticamente por
--su primer nombre.

--FROM: pacientes -> smart_health.patients;
SELECT
    first_name || ' '||first_surname AS fullname,
    gender,
    email,
    birth_date 


FROM smart_health.patients
WHERE birth_date BETWEEN '1990-01-01' AND '1993-12-31'
ORDER BY first_name 
LIMIT 5;

-----------------------------------------------------------------------------------

--modificar consulta anterior personas nacidas entre 
--2005 y 2008 y qie el genero sea masculino o femenino
--ordenar desendentemente por primer apellido,mostrar los primeros 8 resultados 

--FROM: pacientes -> smart_health.patients;
SELECT
    first_name || ' '||first_surname AS fullname,
    gender,
    email,
    birth_date 


FROM smart_health.patients
WHERE birth_date BETWEEN '2005-01-01' AND '2008-12-31' AND gender = 'M'
ORDER BY first_surname DESC
LIMIT 8;

---------------------------------------------------------------------------------------------------------

--1. Mostrar los medicamentos, que tienen un ingrediente 
--activo como PARACETAMOL o IBUPROFENO.

--FROM medicamentos -> smart_health.medications;
SELECT*
   
FROM smart_health.medications
WHERE active_ingredient IN('PRACETAMOL','IBUPROFENO');

-- rta: ibuprofeno generico

----------------------------------------------------------------------------------------------------------

--2. Mostrar los primeros 5 medicos, que tienen 
--dominio institucional @hospitalcentral.com

--FROM  medicos -> smart_health.professional_email;
SELECT*
FROM smart_health.doctors
WHERE professional_email LIKE '@hospitalcentral.com'
LIMIT 5;

--rta: no hay

-------------------------------------------------------------------------------------------------------

--3). Mostrar nombre completo, genero, tipo identificacion, 
--numero de documento y la fecha de registro, 
--de los 5 pacientes mas jovenes, que tengan estado activo.

--FROM pacientes -> smart_health.patients;
SELECT
    first_name || ' '||first_surname AS fullname,
    gender,
    document_type_id,
    document_number,
    registration_date,
    birth_date 
FROM smart_health.patients
WHERE active=TRUE
ORDER BY birth_date DESC
LIMIT 5;

--rta:
--     fullname     | gender | document_type_id | document_number |     registration_date      | birth_date
------------------+--------+------------------+-----------------+----------------------------+------------
-- Julián León      | O      |                5 | 1000113733      | 2025-10-28 07:49:43.098855 | 2006-12-31
 --Daniela Lozano   | O      |                4 | 1005631401      | 2025-10-28 07:49:43.098855 | 2006-12-31
 --Javier Medina    | M      |                7 | 1091852         | 2025-10-28 07:49:43.098855 | 2006-12-31
 --Julián Cifuentes | M      |                2 | 30286805        | 2025-10-28 07:49:43.098855 | 2006-12-31
 --Mónica Ruiz      | F      |                7 | 1004032398      | 2025-10-28 07:49:43.098855 | 2006-12-30

----------------------------------------------------------------------------------------------------------

--4. Mostrar las 10 primeras citas, 
--que se hicieron entre el 25 de Febrero del 2025 
--y el 28 de Octubre del 2025.

--FROM pacientes -> smart_health.appointments;
SELECT *

FROM smart_health.appointments
WHERE appointment_date BETWEEN '2025-02-25' AND '2025-10-28'
ORDER BY appointment_date
LIMIT 10;

--rta
 --appointment_id | patient_id | doctor_id | room_id | appointment_date | start_time | end_time | appointment_type |  status   |                  reason                  |       creation_date
----------------+------------+-----------+---------+------------------+------------+----------+------------------+-----------+------------------------------------------+----------------------------
 --         21472 |      19961 |      3528 |      63 | 2025-02-25       | 16:15:00   | 17:00:00 | Consulta General | Confirmed | Dolor muscular persistente.              | 2025-10-28 07:50:09.034492
 --         11046 |      43838 |      1729 |     212 | 2025-02-25       | 16:15:00   | 17:00:00 | Examen Médico    | Scheduled | Consulta por síntomas respiratorios.     | 2025-10-28 07:50:09.034492
 --         12503 |       3042 |      6977 |     200 | 2025-02-25       | 11:45:00   | 12:30:00 | Vacunación       | Confirmed | Evaluación de resultados de laboratorio. | 2025-10-28 07:50:09.034492
 --         18724 |      17197 |      2134 |     147 | 2025-02-25       | 09:00:00   | 10:00:00 | Nutrición        | Confirmed | Atención por emergencia menor.           | 2025-10-28 07:50:09.034492
 --          4016 |      23447 |      1863 |      69 | 2025-02-25       | 15:15:00   | 16:00:00 | Nutrición        | Confirmed | Control de presión arterial.             | 2025-10-28 07:50:09.034492
 --          9669 |        403 |        49 |     210 | 2025-02-25       | 12:30:00   | 13:30:00 | Psicología       | Attended  | Consulta por síntomas respiratorios.     | 2025-10-28 07:50:09.034492
 --         8496 |       8854 |      3007 |      14 | 2025-02-25       | 14:30:00   | 14:45:00 | Psicología       | Confirmed | Evaluación de resultados de laboratorio. | 2025-10-28 07:50:09.034492
 --          9921 |      17688 |      3820 |     247 | 2025-02-25       | 07:00:00   | 07:30:00 | Consulta General | Confirmed | Consulta por síntomas respiratorios.     | 2025-10-28 07:50:09.034492
 --         17418 |      41100 |      7530 |     122 | 2025-02-25       | 11:15:00   | 11:30:00 | Control          | Cancelled | Seguimiento postoperatorio.              | 2025-10-28 07:50:09.034492
 --         21582 |      34046 |      1840 |     244 | 2025-02-25       | 15:45:00   | 16:30:00 | Consulta General | Scheduled | Asesoría nutricional.                    | 2025-10-28 07:50:09.034492
--(10 filas)

-------------------------------------------------------------------

--5.  Mostrar los datos del numero de telefono, para los siguientes pacientes.
--Filtrar por el campo numero_documento.
--JSON
--['30451580',
--'1006631391',
--'1009149871',
--'1298083',
--'1004928596',
--'1008188849',
--'1607132',
--'30470003']

----FROM pacientes -> smart_health.patients;

