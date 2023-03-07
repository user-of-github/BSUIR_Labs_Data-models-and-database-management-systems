-- TASK 3

CREATE OR REPLACE TRIGGER delete_students_before_removing_group
BEFORE DELETE ON groups
FOR EACH ROW
DECLARE
    CURSOR students_cursor IS SELECT * FROM students WHERE group_id = :OLD.id;
BEGIN
    FOR removed_student IN students_cursor LOOP
        DELETE FROM students WHERE id = removed_student.id;
    END LOOP;
END;

/

SELECT * FROM students;
SELECT * FROM groups;

DELETE FROM groups WHERE groups.id = 1;

SELECT * FROM students;
SELECT * FROM groups;

DROP TRIGGER delete_students_before_removing_group;