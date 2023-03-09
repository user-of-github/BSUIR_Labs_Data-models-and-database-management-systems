CREATE OR REPLACE TRIGGER update_students_count_in_group
AFTER UPDATE OR INSERT OR DELETE ON students FOR EACH ROW
DECLARE
    temp_count NUMBER;
    PRAGMA autonomous_transaction;
BEGIN
    CASE
        WHEN inserting THEN
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM students WHERE group_id='||:NEW.group_id INTO temp_count;
            temp_count:=temp_count+1;
            EXECUTE IMMEDIATE 'UPDATE groups SET groups.students_count='|| temp_count || ' WHERE id='||:NEW.group_id;
        
            COMMIT;

        WHEN updating THEN
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM students WHERE group_id='||:OLD.group_id INTO temp_count;
            temp_count:=temp_count-1;
            EXECUTE IMMEDIATE 'UPDATE groups SET groups.students_count='|| temp_count || ' WHERE id='||:OLD.group_id;
        
            COMMIT;

            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM students WHERE group_id='||:NEW.group_id INTO temp_count;
            temp_count:=temp_count+1;
            EXECUTE IMMEDIATE 'UPDATE groups SET groups.students_count='|| temp_count || ' WHERE id='||:NEW.group_id;
        
            COMMIT;
            
        WHEN deleting THEN
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM students WHERE group_id='||:OLD.group_id INTO temp_count;
            temp_count:=temp_count-1;
            EXECUTE IMMEDIATE 'UPDATE groups SET groups.students_count='|| temp_count || ' WHERE id='||:OLD.group_id;
        
            COMMIT;
    END CASE;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Does the group exist ??');
END;
/
--DROP TRIGGER update_group_students_count;
/
SELECT * FROM students;
SELECT * FROM groups;
/

DELETE FROM students WHERE name='Anthony';
DELETE FROM students WHERE name='Scott';
DELETE FROM students WHERE name='Kang';
DELETE FROM students WHERE name='Kang Concurrerr';


SELECT * FROM students;
SELECT * FROM groups;


INSERT INTO students(name, group_id) VALUES('Anthony', 2);
INSERT INTO students(name, group_id) VALUES('Scott', 2);
INSERT INTO students(name, group_id) VALUES('Kang', 2);
INSERT INTO students(name, group_id) VALUES('Kang Concurrerr', 3);

SELECT * FROM students;
SELECT * FROM groups;

UPDATE students SET group_id=3 WHERE name='Kang';


SELECT * FROM students;
SELECT * FROM groups;