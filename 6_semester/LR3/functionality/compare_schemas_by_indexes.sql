CREATE OR REPLACE PROCEDURE compare_schemas_by_indexes (schema_1_name IN VARCHAR2, schema_2_name IN VARCHAR2)
AS
    CURSOR indexes_from_schema_1_cursor IS
        SELECT index_name, table_name, column_name FROM all_ind_columns WHERE index_owner = schema_1_name
        ORDER BY table_name, index_name, column_position;

    CURSOR indexes_from_schema_2_cursor IS
        SELECT index_name, table_name, column_name FROM all_ind_columns WHERE index_owner = schema_2_name
        ORDER BY table_name, index_name, column_position;

    single_index_from_schema_1_record indexes_from_schema_1_cursor%ROWTYPE := NULL;
    single_index_from_schema_2_record indexes_from_schema_2_cursor%ROWTYPE := NULL;

    response_rows_count NUMBER := 0;
BEGIN
    -- Loop through the indexes in the 1st schema
    FOR single_index_from_schema_1_record IN indexes_from_schema_1_cursor LOOP
        --DBMS_OUTPUT.PUT_LINE(single_index_from_schema_1_record.table_name);
        
        IF single_index_from_schema_1_record.table_name LIKE '%BIN%' THEN -- some system tables
            CONTINUE;
        END IF;
        --DBMS_OUTPUT.PUT_LINE(single_index_from_schema_1_record.index_name);
        -- Look for the same index in the 2nd schema
        SELECT COUNT(*)
        INTO response_rows_count
        FROM all_ind_columns
        WHERE all_ind_columns.index_owner = schema_2_name
            AND all_ind_columns.table_name = single_index_from_schema_1_record.table_name
            AND all_ind_columns.column_name = single_index_from_schema_1_record.column_name;
    

        IF response_rows_count = 0 THEN
             DBMS_OUTPUT.PUT_LINE(
                '[compare_schemas_by_indexes()] Index ' 
                || single_index_from_schema_1_record.index_name 
                || ' on table ' || single_index_from_schema_1_record.table_name 
                || ' does not exist in the ' || schema_2_name ||  ' schema'
                );
        END IF;
    END LOOP;
    -- some comment

    DBMS_OUTPUT.PUT_LINE('______________________');

    -- now the same for 2nd schema
    FOR single_index_from_schema_2_record IN indexes_from_schema_2_cursor LOOP
         IF single_index_from_schema_2_record.table_name LIKE '%BIN%' THEN -- some system tables
            CONTINUE;
        END IF;
        
        -- Look for the same index in the 1st schema
        SELECT COUNT(*)
        INTO response_rows_count
        FROM all_ind_columns
        WHERE all_ind_columns.index_owner = schema_1_name
            AND all_ind_columns.table_name = single_index_from_schema_2_record.table_name
            AND all_ind_columns.column_name = single_index_from_schema_2_record.column_name;
    

        IF response_rows_count = 0 THEN
             DBMS_OUTPUT.PUT_LINE(
                '[compare_schemas_by_indexes()] Index ' 
                || single_index_from_schema_2_record.index_name 
                || ' on table ' || single_index_from_schema_2_record.table_name 
                || ' does not exist in the ' || schema_1_name ||  ' schema'
                );
        END IF;
    END LOOP;

END;