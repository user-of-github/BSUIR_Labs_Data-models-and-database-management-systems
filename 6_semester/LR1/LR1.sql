SET SERVEROUTPUT ON SIZE UNLIMITED;

-- Task 1
DROP TABLE MyTable;
CREATE TABLE MyTable(
    id NUMBER PRIMARY KEY,
    val NUMBER NOT NULL
);

-- Task 2
DECLARE
insert_count NUMBER := 10000;
BEGIN
    FOR i IN 1 .. insert_count LOOP
        INSERT INTO MyTable values (i, ROUND(dbms_random.value(1,1000)));
    END LOOP;
END;


SET SERVEROUTPUT ON SIZE UNLIMITED;

-- Task 1
DROP TABLE MyTable;
CREATE TABLE MyTable(
    id NUMBER PRIMARY KEY,
    val NUMBER NOT NULL
);

-- Task 2
DECLARE
insert_count NUMBER := 10000;
BEGIN
    FOR i IN 1 .. insert_count LOOP
        INSERT INTO MyTable values (i, ROUND(dbms_random.value(1,1000)));
    END LOOP;
END;


CREATE OR REPLACE PROCEDURE print_odd_even_accordance
IS
    CURSOR row_cursor IS SELECT  * FROM MyTable;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test');
END;

