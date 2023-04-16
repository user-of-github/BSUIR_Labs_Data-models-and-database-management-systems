CREATE OR REPLACE PROCEDURE compare_schemas(schema_1_name IN VARCHAR2, schema_2_name IN VARCHAR2) AS
    CURSOR tables_from_1_schema IS SELECT table_name FROM all_tables WHERE owner = schema_1_name;
    CURSOR tables_from_2_schema IS SELECT table_name FROM all_tables WHERE owner = schema_2_name;

    table_name_1_temp all_tables.table_name%TYPE := NULL;
    table_name_2_temp all_tables.table_name%TYPE := NULL;

    sql_query_temp VARCHAR2(4000) := '';
    error_temp VARCHAR2(4000) := '';
BEGIN
    DBMS_OUTPUT.PUT_LINE('compare_schemas EXECUTING !!!');
    FOR table_from_first IN tables_from_1_schema LOOP
        table_name_1_temp := table_from_first.table_name;
        sql_query_temp := 'SELECT COUNT(*) FROM ' || schema_1_name || '.' || table_name_1_temp;
        DBMS_OUTPUT.PUT_LINE(sql_query_temp);
     
    END LOOP;
END;
/

BEGIN
    compare_schemas('DEV_SCHEMA', 'PROD_SCHEMA');
END;