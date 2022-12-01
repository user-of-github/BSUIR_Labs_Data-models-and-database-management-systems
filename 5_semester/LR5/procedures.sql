CREATE OR REPLACE PROCEDURE add_room(new_room_number INTEGER, new_possible_people_count INTEGER)
LANGUAGE SQL
AS $$

INSERT 
INTO rooms (room_id, number, possible_people_count) 
VALUES ((SELECT MAX(room_id) FROM rooms) + 1, new_room_number, new_possible_people_count)
ON CONFLICT DO NOTHING;

$$;

CALL add_room(200, 1);



CREATE OR REPLACE PROCEDURE change_room_people_count(room_number INTEGER, new_possible_people_count INTEGER)
LANGUAGE SQL
AS $$

UPDATE rooms 
SET possible_people_count = new_possible_people_count
WHERE room_id = (SELECT room_id FROM rooms WHERE number = room_number);

$$;

CALL change_room_people_count(200, 3);