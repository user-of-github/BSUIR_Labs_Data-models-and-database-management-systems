CREATE OR REPLACE PROCEDURE task1(schema_1_name IN VARCHAR2, schema_2_name IN VARCHAR2) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('[task1()] Started executing');
    DBMS_OUTPUT.PUT_LINE(chr(10)); -- just empty line :)
    compare_schemas_by_tables(schema_1_name, schema_2_name);
    DBMS_OUTPUT.PUT_LINE(chr(10));
    --check_circular_foreign_key_references(schema_2_name);
    --check_circular_foreign_key_references(schema_1_name);
    --print_tables(schema_1_name);

    GET_TABLES_ORDER(schema_1_name);

    --FOR script IN (SELECT DDL_SCRIPT FROM DDL_TABLE ORDER BY PRIORITY desc )
    --    LOOP
    --DBMS_OUTPUT.PUT_LINE(script.DDL_SCRIPT);
    --END LOOP;


END;

/

BEGIN
    DBMS_OUTPUT.PUT_LINE('TASK 1');
    task1('DEV_SCHEMA', 'PROD_SCHEMA');   
END;