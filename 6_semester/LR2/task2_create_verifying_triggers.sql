-- TASK 2

DROP SEQUENCE group_id_generator;
CREATE SEQUENCE group_id_generator START WITH 4 INCREMENT BY 1 CACHE 100;
CREATE OR REPLACE TRIGGER generate_group_id
  BEFORE INSERT ON groups
  FOR EACH ROW
BEGIN
  :new.id := group_id_generator.nextval;
END;

/
DELETE FROM groups WHERE name='Group D' AND students_count=0;
DELETE FROM groups WHERE name='Group E' AND students_count=0;
DELETE FROM groups WHERE name='Group F' AND students_count=0;

INSERT INTO groups(name, students_count) VALUES ('Group D', 0);
INSERT INTO groups(name, students_count) VALUES ('Group E', 0);
INSERT INTO groups(name, students_count) VALUES ('Group F', 0);
SELECT * from groups;


/
-- Trigger to check unique of group name
CREATE OR REPLACE TRIGGER check_group_name
BEFORE UPDATE OR INSERT
ON groups FOR EACH ROW
DECLARE
   id_ NUMBER;
BEGIN
   SELECT groups.id INTO id_ FROM groups WHERE groups.name=:NEW.name;
   RAISE_APPLICATION_ERROR(-20000, 'Group with such name exists');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL;
END;
-- check this trigger
/

DELETE FROM groups WHERE name='Group K' AND students_count=0;

INSERT INTO groups(name, students_count) VALUES('Group A', 3);
INSERT INTO groups(name, students_count) VALUES('Group K', 0);

SELECT * FROM groups;

/
CREATE OR REPLACE TRIGGER check_group_id
BEFORE UPDATE OR INSERT
ON groups FOR EACH ROW
FOLLOWS check_group_name
DECLARE
   id_ NUMBER;
BEGIN
   SELECT groups.id INTO id_ FROM groups WHERE groups.id=:NEW.id;
   RAISE_APPLICATION_ERROR(-20000, 'Group with such id exists');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL;
END;

/
CREATE OR REPLACE TRIGGER check_student_id
BEFORE UPDATE OR INSERT
ON students FOR EACH ROW
DECLARE
   id_ NUMBER;
BEGIN
   SELECT students.id INTO id_ FROM students WHERE students.id=:NEW.id;
   RAISE_APPLICATION_ERROR(-20000, 'Student with such id exists');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL;
END;

/
DROP TRIGGER check_group_id;
DROP TRIGGER check_group_name;
DROP TRIGGER check_student_id;