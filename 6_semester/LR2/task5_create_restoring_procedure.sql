CREATE OR REPLACE PROCEDURE restore_students_table_state(starting_from_time TIMESTAMP) 
IS
CURSOR rows_logging IS 
SELECT * FROM logging_actions_on_students_table 
WHERE action_date > starting_from_time;
unknown_action_error EXCEPTION;
BEGIN  
    FOR log IN rows_logging LOOP
        DBMS_OUTPUT.PUT_LINE(log.action);
        IF log.action = 'INSERT' THEN
            DELETE FROM students WHERE id=log.modified_student_id;
        ELSIF log.action = 'DELETE' THEN
            INSERT INTO students(id, name, group_id) 
            VALUES(log.modified_student_id, log.modified_student_name, log.modified_student_group_id);
        ELSIF log.action = 'UPDATE' THEN
            UPDATE students 
            SET 
            students.name=log.modified_student_name,
            students.group_id=log.modified_student_group_id 
            WHERE students.id=log.modified_student_id;
        ELSE 
            RAISE unknown_action_error;
        END IF;
    END LOOP;
END;
/
SELECT * FROM logging_actions_on_students_table;
SELECT * FROM students;
/
EXEC restore_students_table_state(TO_TIMESTAMP('08-MAR-23 07.00.15.992826000 PM'));
/
SELECT * FROM logging_actions_on_students_table;
SELECT * FROM students;
/
DELETE FROM students WHERE id=70; -- refers to previous task where I inserted ids 60 & 70
