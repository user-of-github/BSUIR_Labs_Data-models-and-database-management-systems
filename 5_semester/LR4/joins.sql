--JOIN QUERIES OF DIFFERENT TYPES

-- currently resting people
SELECT * FROM vacationers 
INNER JOIN abstract_users ON vacationers.id = abstract_users.user_id
WHERE vacationers.rests_to >= Now(); 


-- procedure and according to this procedure job title
SELECT medical_jobs.job_title AS "Profession", procedures.title AS "Procedure" FROM procedures
INNER JOIN serviced_procedures ON procedures.procedure_id = serviced_procedures.procedure_id
INNER JOIN medical_employees ON medical_employees.id = serviced_procedures.medical_id
INNER JOIN medical_jobs ON medical_jobs.medical_job_id = medical_employees.job;


-- procedure and according to this procedure doctor's name
SELECT procedures.title AS "Procedure", CONCAT(abstract_users.surname, ' ', abstract_users.name) AS "Doctor" FROM procedures
INNER JOIN serviced_procedures ON procedures.procedure_id = serviced_procedures.procedure_id
INNER JOIN medical_employees ON medical_employees.id = serviced_procedures.medical_id
INNER JOIN abstract_users ON abstract_users.user_id = medical_employees.id
ORDER BY procedures.title;


-- ALL co-workers of Sanatorium and room numbers
(SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "User", rooms.number AS "Room" FROM administrators
LEFT JOIN rooms ON administrators.room = rooms.room_id
INNER JOIN abstract_users ON abstract_users.user_id = administrators.id)
UNION
(SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "User", rooms.number AS "Room" FROM medical_employees
LEFT JOIN rooms ON medical_employees.room = rooms.room_id
INNER JOIN abstract_users ON abstract_users.user_id = medical_employees.id);


-- ALL users and room numbers
((SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "User", 'Admin' AS "Duty", rooms.number AS "Room" FROM administrators
LEFT JOIN rooms ON administrators.room = rooms.room_id
INNER JOIN abstract_users ON abstract_users.user_id = administrators.id)
UNION
(SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "User", 'Doctor' AS "Duty", rooms.number AS "Room" FROM medical_employees
LEFT JOIN rooms ON medical_employees.room = rooms.room_id
INNER JOIN abstract_users ON abstract_users.user_id = medical_employees.id)
UNION
(SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "User", 'Vacationer' AS "Duty", rooms.number AS "Room" FROM vacationers
LEFT JOIN rooms ON vacationers.room = rooms.room_id
INNER JOIN abstract_users ON abstract_users.user_id = vacationers.id))
ORDER BY "Duty";

-- All  vacatiners who live in the rooms more than room with ID 1
-- SELF JOIN
SELECT a.number FROM rooms a, rooms b 
WHERE a.number > b.number AND b.room_id = 1;

-- room number of a vacationer person
SELECT rooms.number FROM abstract_users  
INNER JOIN vacationers ON vacationers.id = abstract_users.user_id 
INNER JOIN rooms ON rooms.room_id = vacationers.room 
WHERE abstract_users.surname = 'Smith' AND abstract_users.name = 'Daniel'
LIMIT 1;


-- get nearest neighbours of person
DROP VIEW IF EXISTS persons_room;
CREATE VIEW persons_room AS (SELECT rooms.number FROM abstract_users  
INNER JOIN vacationers ON vacationers.id = abstract_users.user_id 
INNER JOIN rooms ON rooms.room_id = vacationers.room 
WHERE abstract_users.surname = 'Smith' AND abstract_users.name = 'Daniel'
LIMIT 1);

SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "Vacationer", rooms.number AS "Room number" FROM rooms 
INNER JOIN vacationers ON vacationers.room = rooms.room_id
INNER JOIN abstract_users ON abstract_users.user_id = vacationers.id
WHERE (rooms.number > ((SELECT * FROM persons_room) - 10)) AND (rooms.number < ((SELECT * FROM persons_room) + 10));


EXPLAIN (ANALYZE) SELECT * FROM rooms;