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
--SELECT * FROM logging_actions_on_students_table;
--SELECT * FROM students;
--/
--BEGIN
    -- проверить на примере  DELETE FROM students WHERE id=70; то есть первый запуск закомментирована функция, роман удалился, потом вторым запуском восстанавливаю
    --restore_students_table_state(TO_TIMESTAMP('21-MAR-23 10.46.41.160500000 AM')); -- поставить ранее чем был удален 
--END;

--SELECT * FROM logging_actions_on_students_table;
--SELECT * FROM students;

--DELETE FROM students WHERE id=70; -- refers to previous task where I inserted ids 60 & 70

--SELECT * FROM groups;
--SELECT * FROM students;

--DELETE FROM groups WHERE name = 'Group B';

--SELECT * FROM groups;
--SELECT * FROM students;



-- TO DEMONSTRATE TO TEACHER
--BEGIN
--    RESTORE_STUDENTS_TABLE_STATE(TO_TIMESTAMP('21-MAR-23 02.41.55.214798000 PM'));
--END;
--/
--SELECT * FROM LOGGING_ACTIONS_ON_STUDENTS_TABLE;

--SELECT * FROM students;