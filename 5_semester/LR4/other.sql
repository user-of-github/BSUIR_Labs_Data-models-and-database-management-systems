-- just procedures and users
SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "Vacationer", procedures.title FROM used_procedures
INNER JOIN abstract_users ON abstract_users.user_id = used_procedures.vacationer_id
INNER JOIN procedures ON procedures.procedure_id = used_procedures.procedure_id;


SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "Vacationer", COUNT(procedures.title) AS "Procedures count" FROM used_procedures
INNER JOIN abstract_users ON abstract_users.user_id = vacationer_id
INNER JOIN procedures ON procedures.procedure_id = used_procedures.procedure_id
GROUP BY "Vacationer";

-- person with max value of procedures count
SELECT MAX("Procedures count") AS "Recordsman of procedures count !" FROM (
SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "Vacationer", COUNT(procedures.title) AS "Procedures count" FROM used_procedures
INNER JOIN abstract_users ON abstract_users.user_id = vacationer_id
INNER JOIN procedures ON procedures.procedure_id = used_procedures.procedure_id  
GROUP BY "Vacationer"
) AS temp;



-- people with more than 2 procedures

SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "Vacationer", COUNT(procedures.title) AS "Procedures count" FROM used_procedures
INNER JOIN abstract_users ON abstract_users.user_id = vacationer_id
INNER JOIN procedures ON procedures.procedure_id = used_procedures.procedure_id 
GROUP BY "Vacationer" 
HAVING COUNT(procedures.title) > 2;



-- -- people and campus  
SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "Guest",
CASE 
    WHEN rooms.number IN (108, 120, 122) THEN 'Yes'
    ELSE 'No'
END AS "Is 2 campus"
FROM vacationers
JOIN abstract_users ON abstract_users.user_id = vacationers.id
JOIN rooms ON vacationers.room = rooms.room_id
ORDER BY abstract_users.name ASC;


-- -- SELECT vacationers.id, rooms.number FROM vacationers
-- -- RIGHT OUTER JOIN rooms ON vacationers.room = rooms.room_id;



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


INSERT 
INTO abstract_users(user_id, email, password, name, surname) 
VALUES
(200, 'email23@gmail.com', crypt('new password', gen_salt('bf')), 'Name2', 'Surname')
ON CONFLICT DO NOTHING;


INSERT 
INTO vacationers(id, rests_from, rests_to, room) 
VALUES
(200, '2022-12-01', '2022-12-22', 3)
ON CONFLICT DO NOTHING;

SELECT vacationers.id, rooms.number FROM vacationers
INNER JOIN rooms ON vacationers.room = rooms.room_id
WHERE rooms.number = 122;


-- ((SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "User", 'Admin' AS "Duty", rooms.number AS "Room" FROM administrators
-- LEFT JOIN rooms ON administrators.room = rooms.room_id
-- INNER JOIN abstract_users ON abstract_users.user_id = administrators.id
--  WHERE rooms.number = 122)
-- UNION
-- (SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "User", 'Doctor' AS "Duty", rooms.number AS "Room" FROM medical_employees
-- LEFT JOIN rooms ON medical_employees.room = rooms.room_id
-- INNER JOIN abstract_users ON abstract_users.user_id = medical_employees.id
-- WHERE rooms.number = 122)
-- UNION
-- (
--     SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "User", 'Vacationer' AS "Duty", rooms.number AS "Room" FROM vacationers
-- LEFT JOIN rooms ON vacationers.room = rooms.room_id
-- INNER JOIN abstract_users ON abstract_users.user_id = vacationers.id
-- WHERE rooms.number = 122
-- );

(SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "User", 'Vacationer' AS "Duty", rooms.number AS "Room" FROM vacationers
LEFT JOIN rooms ON vacationers.room = rooms.room_id
INNER JOIN abstract_users ON abstract_users.user_id = vacationers.id
WHERE rooms.number = 122)
UNION
(SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "User", 'Admin' AS "Duty", rooms.number AS "Room" FROM administrators
LEFT JOIN rooms ON administrators.room = rooms.room_id
INNER JOIN abstract_users ON abstract_users.user_id = administrators.id
WHERE rooms.number = 122)
UNION
(SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "User", 'Doctor' AS "Duty", rooms.number AS "Room" FROM medical_employees
LEFT JOIN rooms ON medical_employees.room = rooms.room_id
INNER JOIN abstract_users ON abstract_users.user_id = medical_employees.id
WHERE rooms.number = 122);
