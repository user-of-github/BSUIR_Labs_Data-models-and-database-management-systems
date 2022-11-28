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

-- people and their procedures has or no procedures ?
-- SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "Vacationer", 
-- COUNT(procedures.title) AS "Procedures count" 
-- CASE
--     WHEN COUNT(procedures.title) > 0 THEN 'Cured'
--     ELSE 'Not cured'
-- FROM used_procedures
-- INNER JOIN abstract_users ON abstract_users.user_id = vacationer_id
-- INNER JOIN procedures ON procedures.procedure_id = used_procedures.procedure_id 
-- GROUP BY "Vacationer";


-- people and campus  
SELECT CONCAT(abstract_users.name, ' ', abstract_users.surname) AS "Guest",
CASE 
    WHEN rooms.number IN (108, 120, 122) THEN 'Yes'
    ELSE 'No'
END AS "Is 2 campus"
FROM vacationers
JOIN abstract_users ON abstract_users.user_id = vacationers.id
JOIN rooms ON vacationers.room = rooms.room_id;