CREATE OR REPLACE FUNCTION add_to_log() 
RETURNS TRIGGER AS $$
DECLARE
    log_message varchar(30);
    user_name varchar(100);
    full_message varchar(254);
BEGIN
    IF  TG_OP = 'INSERT' THEN
        user_name = NEW.name;
        log_message := 'Add new user ';
        full_message := CONCAT(log_message, user_name);
        INSERT INTO logging(log_id, user_id, description, datetime) values ((SELECT MAX(log_id) FROM logging) + 1, NEW.user_id, full_message, NOW());
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        user_name = NEW.name;
        log_message := 'Update user ';
        full_message := CONCAT(log_message, user_name);
        INSERT INTO logging(log_id, user_id, description, datetime) values ((SELECT MAX(log_id) FROM logging) + 1, NEW.user_id, full_message, NOW());
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        user_name = OLD.name;
        log_message := 'Remove user ';
        full_message := CONCAT(log_message, user_name);
        INSERT INTO logging(log_id, user_id, description, datetime) values ((SELECT MAX(log_id) FROM logging) + 1, NEW.user_id, full_message,NOW());
        RETURN OLD;
    END IF;
END;
$$
LANGUAGE plpgsql
;


CREATE OR REPLACE TRIGGER log_adding_user
AFTER INSERT OR UPDATE OR DELETE ON abstract_users 
FOR EACH ROW 
EXECUTE 
PROCEDURE add_to_log ();

-- test
INSERT 
INTO abstract_users(user_id, email, password, name, surname) 
VALUES
(15, 'email11155@gmail.com', crypt('new password4ddd', gen_salt('bf')), 'Aleasher', 'Tagirovichch')
ON CONFLICT DO NOTHING;