-- currently resting people
SELECT abstract_users.surname FROM vacationers 
JOIN abstract_users ON vacationers.id = abstract_users.user_id
WHERE vacationers.rests_to >= Now(); 

-- users and their rooms
SELECT abstract_users.surname, vacationers.room FROM vacationers
JOIN abstract_users ON vacationers.id = abstract_users.user_id;

-- with regex // slowly
SELECT surname FROM abstract_users WHERE surname ~ 'S[a-z]*';


SELECT * from procedures;

