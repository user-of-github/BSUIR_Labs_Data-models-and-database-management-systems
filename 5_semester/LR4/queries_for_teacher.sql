-- SELECT get_rooms_with_free_places();


-- DROP FUNCTION does_room_have_free_places(INT);
-- CREATE OR REPLACE FUNCTION does_room_have_free_places(id INT)
-- RETURNS INTEGER
-- LANGUAGE SQL
-- AS $$

-- (SELECT COUNT(*) FROM (SELECT room_id FROM get_rooms_with_free_places()) AS "Free_rooms"
-- WHERE room_id = id);

-- $$;


-- SELECT room_idd FROM get_room_by_number(122) LIMIT 1; --2
-- SELECT * FROM does_room_have_free_places(2); -- 0 => no, it doesn't

--SELECT vacationers.id FROM 

DROP VIEW tempp;
CREATE OR REPLACE VIEW tempp AS (SELECT rooms.number, rooms.room_id, rooms.possible_people_count - TEMP.places_left AS livers_count FROM get_rooms_with_free_places() AS TEMP
INNER JOIN rooms ON rooms.room_id = TEMP.room_idd
FULL JOIN vacationers ON rooms.room_id = vacationers.room
WHERE rooms.possible_people_count - TEMP.places_left >= 2);

(
SELECT abstract_users.surname, administrators.room FROM administrators
INNER JOIN abstract_users ON abstract_users.user_id = administrators.id
 WHERE administrators.room IN (SELECT room_id FROM tempp)
)
 
UNION
 
 (
SELECT abstract_users.surname, medical_employees.room FROM medical_employees
INNER JOIN abstract_users ON abstract_users.user_id = medical_employees.id
 WHERE medical_employees.room IN (SELECT room_id FROM tempp) 
 );
--(SELECT room_id FROM tempp);