CREATE OR REPLACE PROCEDURE compare_schemas_by_tables(schema_1_name IN VARCHAR2, schema_2_name IN VARCHAR) 
AS
    CURSOR tables_from_1_schema IS SELECT table_name FROM all_tables WHERE owner = schema_1_name;
    CURSOR tables_from_2_schema IS SELECT table_name FROM all_tables WHERE owner = schema_2_name;

    table_name_1 all_tables.table_name%TYPE := NULL;
    table_name_2_temp all_tables.table_name%TYPE := NULL;

    found_table_flag BOOLEAN := false;
    sql_query_temp VARCHAR2(4000) := '';

    are_tables_equal BOOLEAN := NULL;
BEGIN
    FOR table_from_1_schema IN tables_from_1_schema LOOP
        table_name_1 := table_from_1_schema.table_name;

        sql_query_temp := 'SELECT COUNT(*) FROM ' || schema_1_name || '.' || table_name_1;
        --DBMS_OUTPUT.PUT_LINE(sql_query_temp);

        BEGIN
            EXECUTE IMMEDIATE sql_query_temp;
        EXCEPTION
            WHEN OTHERS THEN 
                CONTINUE; -- SELECT didn't work ===> Table does not exist in dev schema
        END;

        found_table_flag := false;

        -- going through all tables in 2 schema and looking for the one with same tableName
        FOR table_from_2_schema IN tables_from_2_schema LOOP
            table_name_2_temp := table_from_2_schema.table_name;

            IF table_name_1 = table_name_2_temp THEN -- Table exists in both schemas ===> compare table structure
                found_table_flag := true;

                are_tables_equal := compare_tables_from_two_shemas(table_name_1, schema_1_name, table_name_2_temp, schema_2_name);
                
                IF are_tables_equal = false THEN
                    DBMS_OUTPUT.PUT_LINE('[compare_schemas_by_tables()] Table ' || table_name_1 || ' exists in both schemas ' || schema_1_name || ' and ' || schema_2_name || ' , but has DIFFERENT structures');
                END IF;

                EXIT; -- found table with such name ===> no sense to go further
            END IF;
        END LOOP;

        IF found_table_flag = false THEN
            DBMS_OUTPUT.PUT_LINE('[compare_schemas_by_tables()] Table ' || table_name_1 || ' exists in ' || schema_1_name || ' , but not in ' || schema_2_name);
        END IF; 

    END LOOP;
END;    

