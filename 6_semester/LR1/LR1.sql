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
    max_value NUMBER := 2023;
BEGIN
    FOR i IN 1 .. insert_count LOOP
        INSERT INTO MyTable values (i, ROUND(dbms_random.value(1, max_value)));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Inserted ' || insert_count ||  ' rows');
END;
/

-- task 3
CREATE OR REPLACE FUNCTION get_accordance_of_even_and_odd_values
RETURN VARCHAR2
IS 
    even_count NUMBER := 0;
    odd_count NUMBER := 0;
    response VARCHAR(5) := 'NULL';
    CURSOR row_cursor IS SELECT val FROM MyTable;
BEGIN 
   FOR current_row IN row_cursor
    LOOP
        IF MOD (current_row.val, 2) = 0  THEN
            even_count := even_count + 1;
		ELSE
            odd_count := odd_count + 1;
		END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Even count: ' || even_count);
    DBMS_OUTPUT.PUT_LINE('Odd count: ' || odd_count);
    IF even_count > odd_count THEN
        response := 'TRUE';
    ELSIF even_count < odd_count THEN
        response := 'FALSE';
    END IF;
    
    RETURN response;
END; 

/
DECLARE
   functions_response VARCHAR2(5) := NULL; 
BEGIN
    functions_response := get_accordance_of_even_and_odd_values();
    DBMS_OUTPUT.PUT_LINE(functions_response);
END;

