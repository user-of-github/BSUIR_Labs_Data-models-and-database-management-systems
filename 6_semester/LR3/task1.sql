CREATE OR REPLACE PROCEDURE task1(schema_1_name IN VARCHAR2, schema_2_name IN VARCHAR2) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('[task1()] Started executing');
    DBMS_OUTPUT.PUT_LINE(chr(10)); -- just empty line :)
    compare_schemas_by_tables(schema_1_name, schema_2_name);
    DBMS_OUTPUT.PUT_LINE(chr(10));
    check_circular_foreign_key_references(schema_2_name);
END;

/

BEGIN
    DBMS_OUTPUT.PUT_LINE('TASK 1');
    task1('DEV_SCHEMA', 'PROD_SCHEMA');   
END;