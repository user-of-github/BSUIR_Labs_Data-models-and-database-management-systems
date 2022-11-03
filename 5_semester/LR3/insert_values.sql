INSERT 
INTO medical_jobs(medical_job_id, job_title) 
VALUES (1, 'massage therapist'), (2, 'coach'), (3, 'pediatrician'), (4, 'nurse')
ON CONFLICT DO NOTHING;

INSERT 
INTO entertainments(entertainment_id, title, description, price) 
VALUES 
(1, 'table tennis', 'a table and stuff to spend time with pleasure playing ping-pong. Price is set per hour', 5), 
(2, 'volleyball', 'a field with sand coverage to play beach volley there', 0), 
(3, 'basketball', 'a field with solid coverage to play basketball there', 0),  
(4, 'snooker', 'table for professional snooker with necessary balls and stuff. Price is set per hour', 8)
ON CONFLICT DO NOTHING;

INSERT 
INTO extra_events(event_id, title, description, price, date) 
VALUES 
(1, 'laser tag', 'price is set for one game with duration of 60 minutes', 10, '2021-08-13'),
(2, 'excursion to the forest', 'A good way to discover great forest around our sanatorium resort', 0, '2022-08-13')
ON CONFLICT DO NOTHING;


INSERT 
INTO procedures(procedure_id, title, description, price) 
VALUES 
(1, 'manual massage', 'price is set for one session with duration of 40 minutes', 10),
(2, 'auto massage', 'price is set for one session with duration of 40 minutes', 4),
(3, 'speleotherapy', 'possibility to sit in salt-cage. Price is set for one session with duration of 1 hour', 2)
ON CONFLICT DO NOTHING;


INSERT 
INTO rooms(room_id, number, possible_people_count) 
VALUES (1, 108, 2), (2, 122, 2), (3, 105, 1), (4, 120, 4), (5, 322, 5), (6, 320, 7), (7, 323, 2), (8, 324, 3)
ON CONFLICT DO NOTHING;


INSERT 
INTO abstract_users(user_id, email, password, name, surname) 
VALUES
(1, 'email1@gmail.com', crypt('new password', gen_salt('bf')), 'Andrey', 'Ostapenko'),
(2, 'email2@gmail.com', crypt('new password2', gen_salt('md5')), 'Polina', 'Unknown'),
(3, 'email3@gmail.com', crypt('new password3', gen_salt('md5')), 'Roma', 'Noumow'),
(4, 'email4@gmail.com', crypt('new password4', gen_salt('md5')), 'Pavel', 'Leschinka'),
(5, 'email5@gmail.com', crypt('new password5', gen_salt('md5')), 'Ali', 'Abdullov'),
(6, 'email6@gmail.com', crypt('new password6', gen_salt('md5')), 'Vodim', 'Garkeen'),
(7, 'email7@gmail.com', crypt('new password7', gen_salt('md5')), 'Nina', 'Petrovna'), -- admin
(8, 'email8@gmail.com', crypt('new password8', gen_salt('md5')), 'Petrovich', 'Petrovich'), -- admin
(9, 'email9@gmail.com', crypt('new password9', gen_salt('md5')), 'Anthony', 'Stark'), -- medical employee
(10, 'email10@gmail.com', crypt('new password10', gen_salt('md5')), 'Peter', 'Parker') -- medical employee
ON CONFLICT DO NOTHING;


INSERT 
INTO vacationers(id, rests_from, rests_to, room) 
VALUES
(1, '2022-08-03', '2022-08-22', 2),
(2, '2022-08-04', '2022-08-23', 1),
(3, '2022-08-04', '2022-08-23', 2),
(4, '2022-08-04', '2022-08-23', 2),
(5, '2022-08-04', '2022-08-23', 3),
(6, '2022-08-04', '2022-08-23', 3)
ON CONFLICT DO NOTHING;


INSERT 
INTO administrators(id, room) 
VALUES (7, 6), (8, 6)
ON CONFLICT DO NOTHING;

INSERT 
INTO medical_employees(id, job, cabinet, room) 
VALUES (9, 1, 4, 8), (10, 2, 5, 8)
ON CONFLICT DO NOTHING;


INSERT 
INTO visited_events(vacationer_id, extra_event_id)
VALUES (1, 1), (1, 2), (3, 1), (4, 2)
ON CONFLICT DO NOTHING;

INSERT 
INTO used_entertainments(vacationer_id, entertainment_id)
VALUES (1, 1), (1, 2), (1, 3), (5, 1)
ON CONFLICT DO NOTHING;


INSERT 
INTO used_procedures(vacationer_id, procedure_id)
VALUES (1, 1), (2, 2), (3, 3), (1, 3), (1, 2)
ON CONFLICT DO NOTHING;


INSERT 
INTO serviced_procedures(medical_id, procedure_id)
VALUES (9, 1), (9, 2), (9, 3), (10, 1), (10, 1)
ON CONFLICT DO NOTHING;


INSERT INTO logging(log_id, user_id, description, datetime)
VALUES 
(1, 1, 'Authorized', '2022-11-03')
ON CONFLICT DO NOTHING;