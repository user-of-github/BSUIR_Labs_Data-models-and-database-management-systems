SET SERVEROUTPUT ON SIZE UNLIMITED;

-- TASK 1
DROP TABLE MyTable;
CREATE TABLE MyTable(
    id NUMBER PRIMARY KEY,
    val NUMBER NOT NULL
);


-- TASK 2
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


-- TASK 3
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


-- TASK 4
/
CREATE OR REPLACE FUNCTION generate_insert_query(id IN NUMBER, val IN NUMBER) 
RETURN VARCHAR2
IS
BEGIN
    RETURN utl_lms.format_message('INSERT INTO MyTable VALUES (%d, %d)', TO_CHAR(id), TO_CHAR(val));
END;

/
DECLARE
   functions_response VARCHAR2(100) := NULL; 
BEGIN
    functions_response := generate_insert_query(2023, 2023);
    DBMS_OUTPUT.PUT_LINE(functions_response);
END;


-- TASK 5
/
CREATE OR REPLACE PROCEDURE insert_operation(table_name VARCHAR2, id NUMBER, val NUMBER) 
IS
    command VARCHAR2(100) := '';
BEGIN
    command := utl_lms.format_message('INSERT INTO %s(id,val) VALUES (%d, %d)', table_name, TO_CHAR(id), TO_CHAR(val));
	EXECUTE IMMEDIATE command;
END;
/
BEGIN 
    insert_operation('MyTable', 10001, 13);
END;
/

CREATE OR REPLACE PROCEDURE perform_update(table_name VARCHAR2, id NUMBER, val NUMBER) 
IS
    command VARCHAR2(100) := '';
BEGIN
	command := utl_lms.format_message('UPDATE %s SET val=%d WHERE id=%d', table_name, TO_CHAR(val), TO_CHAR(id));
    EXECUTE IMMEDIATE command;
END;	
/
BEGIN
    perform_update('MyTable', 20232023, 2023);
END;

/
CREATE OR REPLACE PROCEDURE perform_delete(table_name VARCHAR2, id NUMBER) 
IS
     command VARCHAR2(100) := '';
BEGIN
	command := utl_lms.format_message('DELETE FROM %s WHERE id=%d', table_name, TO_CHAR(id));
    EXECUTE IMMEDIATE command;
END;
/
BEGIN
    perform_delete('MyTable', 20232023);
END;
/



-- TASK 6
/
CREATE OR REPLACE FUNCTION get_annual_full_salary(month_salary NUMBER, additional_percentage NUMBER)
RETURN REAL
IS 
    response REAL := 0.00;
    INVALID_PERCENTAGE_EXCEPTION EXCEPTION;
    INVALID_SALARY_EXCEPTION EXCEPTION;
BEGIN
    IF additional_percentage < 0 THEN
        RAISE INVALID_PERCENTAGE_EXCEPTION;
    END IF;

    IF month_salary <= 0 THEN
        RAISE INVALID_SALARY_EXCEPTION;
    END IF;

    response := (1 + additional_percentage / 100) * 12 * month_salary;

    RETURN response;

     EXCEPTION
        WHEN INVALID_NUMBER THEN
            DBMS_OUTPUT.PUT_LINE('Wrong input type');
            RETURN NULL;
        WHEN INVALID_PERCENTAGE_EXCEPTION THEN
            DBMS_OUTPUT.PUT_LINE('Invalid percent');
            RETURN NULL;
        WHEN INVALID_SALARY_EXCEPTION THEN
            DBMS_OUTPUT.PUT_LINE('Invalid salary');
            RETURN NULL;
        WHEN ZERO_DIVIDE THEN 
            DBMS_OUTPUT.PUT_LINE('Zero division forbidden');
            RETURN NULL;

END;

/

BEGIN
    DBMS_OUTPUT.PUT_LINE(get_annual_full_salary(12, 13));
    DBMS_OUTPUT.PUT_LINE(get_annual_full_salary(-12, 13));
END;
