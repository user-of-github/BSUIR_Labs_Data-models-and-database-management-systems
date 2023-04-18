CREATE OR REPLACE PROCEDURE task3(schema_1_name IN VARCHAR2, schema_2_name IN VARCHAR2) 
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('[task3()] Started executing');
    DBMS_OUTPUT.PUT_LINE(chr(10)); -- just empty line :)
    -- clear prod schema
    clear_schema_items(schema_2_name);
    migrate_all_items_from_schema_to_schema(schema_1_name, schema_2_name);
END;

/

BEGIN
    DBMS_OUTPUT.PUT_LINE('TASK 3');
    task3('DEV_SCHEMA', 'PROD_SCHEMA');
    --DBMS_OUTPUT.PUT_LINE(DBMS_METADATA.GET_DDL('FUNCTION', 'TEST_FUNCTION', 'DEV_SCHEMA'));
END;
/

--SELECT * FROM all_constraints WHERE owner = 'PROD_SCHEMA' AND NOT REGEXP_LIKE(constraint_name, '^BIN');

--SELECT table_name FROM all_tables WHERE owner = 'DEV_SCHEMA'