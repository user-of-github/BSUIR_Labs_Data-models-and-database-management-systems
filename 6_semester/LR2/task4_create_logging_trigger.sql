-- TASK 4

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE logging_actions_on_students_table';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

/
CREATE TABLE logging_actions_on_students_table(
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    action VARCHAR2(10) NOT NULL,
    action_date TIMESTAMP NOT NULL,
    modified_student_id NUMBER,
    modified_student_name VARCHAR2(100) NOT NULL,
    modified_student_group_id NUMBER
);

/
CREATE OR REPLACE TRIGGER log_actions_on_students_table
AFTER INSERT OR DELETE OR UPDATE
ON students FOR EACH ROW
DECLARE 
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    CASE
        WHEN inserting THEN
            INSERT INTO logging_actions_on_students_table(action, action_date, modified_student_id, modified_student_name, modified_student_group_id) 
            VALUES ('INSERT', CURRENT_TIMESTAMP, :NEW.id, :NEW.name, :NEW.group_id);
            
            COMMIT;

        WHEN updating THEN
            INSERT INTO logging_actions_on_students_table(action, action_date, modified_student_id, modified_student_name, modified_student_group_id) 
            VALUES ('UPDATE', CURRENT_TIMESTAMP, :OLD.id, :OLD.name, :OLD.group_id);
            
            COMMIT;

        WHEN deleting THEN
            INSERT INTO logging_actions_on_students_table(action, action_date, modified_student_id, modified_student_name, modified_student_group_id) 
            VALUES ('DELETE', CURRENT_TIMESTAMP, :OLD.id, :OLD.name, :OLD.group_id);
            
            COMMIT;
            
    END CASE;
END;
/
INSERT INTO students(id, name, group_id) VALUES(60, 'Dima', 1);
INSERT INTO students(id, name, group_id) VALUES(70, 'Roman', 1);
UPDATE students SET students.group_id=2 WHERE students.id=70;

DELETE FROM students WHERE id=60;
DELETE FROM students WHERE id=70;


SELECT * FROM logging_actions_on_students_table;