CREATE OR REPLACE PROCEDURE task2(schema_1_name IN VARCHAR2, schema_2_name IN VARCHAR2) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('[task2()] Started executing');
    DBMS_OUTPUT.PUT_LINE(chr(10)); -- just empty line :)
    --compare_schemas_by_tables(schema_1_name, schema_2_name);
    
    
    compare_schemas_by_indexes(schema_1_name, schema_2_name);
     DBMS_OUTPUT.PUT_LINE(chr(10)); -- just empty line :)
    compare_schemas_by_functions('FUNCTION', schema_1_name, schema_2_name);
     DBMS_OUTPUT.PUT_LINE(chr(10)); -- just empty line :)
    compare_schemas_by_packages(schema_1_name, schema_2_name);
END;

/

BEGIN
    DBMS_OUTPUT.PUT_LINE('TASK 2');
    task2('DEV_SCHEMA', 'PROD_SCHEMA');   
END;

/
--SELECT index_name, table_name, column_name FROM all_ind_columns WHERE index_owner = 'DEV_SCHEMA'
--ORDER BY table_name, index_name, column_position;