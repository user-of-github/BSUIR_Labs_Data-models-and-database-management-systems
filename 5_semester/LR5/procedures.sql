CREATE OR REPLACE PROCEDURE add_room(new_room_number INTEGER, new_possible_people_count INTEGER)
LANGUAGE SQL
AS $$

INSERT 
INTO rooms (room_id, number, possible_people_count) 
VALUES ((SELECT MAX(room_id) FROM rooms) + 1, new_room_number, new_possible_people_count)
ON CONFLICT DO NOTHING;

$$;

DELETE FROM rooms WHERE rooms.number = 200;
CALL add_room(200, 1);



CREATE OR REPLACE PROCEDURE change_room_people_count(room_number INTEGER, new_possible_people_count INTEGER)
LANGUAGE SQL
AS $$

UPDATE rooms 
SET possible_people_count = new_possible_people_count
WHERE room_id = (SELECT room_id FROM rooms WHERE number = room_number);

$$;

--CALL change_room_people_count(200, 3);



DROP FUNCTION get_room_by_number(INTEGER);
CREATE OR REPLACE FUNCTION get_room_by_number(room_number INTEGER) 
RETURNS TABLE (room_id INT, number INT, possible_people_count INT) 
LANGUAGE SQL 
AS $$
SELECT * FROM rooms WHERE rooms.number = room_number;
$$;

SELECT get_room_by_number(108);




--DROP FUNCTION get_room_livers_count(INTEGER);
CREATE OR REPLACE FUNCTION get_room_livers_count(room_id INTEGER) 
RETURNS INTEGER
LANGUAGE SQL
AS $$

SELECT COUNT(id) FROM 
(
    SELECT vacationers.id FROM vacationers
    WHERE vacationers.room = room_id
    UNION
    SELECT administrators.id FROM administrators
    WHERE administrators.room = room_id
    UNION
    SELECT medical_employees.id FROM medical_employees
    WHERE medical_employees.room = room_id
) AS "all_livers_from_this_room";

$$;




DROP FUNCTION get_rooms_with_free_places();
CREATE OR REPLACE FUNCTION get_rooms_with_free_places() 
RETURNS TABLE (room_id INT, number INT, places_left INT)
LANGUAGE SQL
AS $$

SELECT rooms.room_id AS "room_id", rooms.number AS "number", rooms.possible_people_count - get_room_livers_count(rooms.room_id) AS "Places_left" FROM rooms
WHERE rooms.possible_people_count > get_room_livers_count(rooms.room_id);

$$;

SELECT get_rooms_with_free_places();


DROP FUNCTION does_room_have_free_places(INT);
CREATE OR REPLACE FUNCTION does_room_have_free_places(id INT)
RETURNS INTEGER
LANGUAGE SQL
AS $$
(SELECT COUNT(*) FROM (SELECT room_id FROM get_rooms_with_free_places()) AS "Free_rooms"
WHERE room_id = id);
$$;


SELECT room_id FROM get_room_by_number(122) LIMIT 1; --2
SELECT * FROM does_room_have_free_places(2); -- 0 => no, it doesn't
