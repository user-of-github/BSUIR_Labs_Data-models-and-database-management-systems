CREATE OR REPLACE FUNCTION build_insert_query(parsed_json_object IN JSON_OBJECT_T)
RETURN VARCHAR2
IS
    response VARCHAR(4096) := '';

    -- TABLE VARS
    query_table_key CONSTANT VARCHAR2(100) := 'intoTable';
    query_table VARCHAR2(100) := NULL;

    -- COLUMNS VARS
    query_columns_key CONSTANT VARCHAR2(100) := 'columns';
    query_columns JSON_ARRAY_T := NULL;
    query_columns_count NUMBER := NULL;
    query_current_column VARCHAR2(100) := 'NULL';

    -- INSERTED VALS VARS
    query_values_key CONSTANT VARCHAR2(100) := 'value';
    query_value VARCHAR2(100) := NULL;

BEGIN
    query_table := parsed_json_object.GET_STRING(query_table_key);

    response := response || 'INSERT INTO ' || query_table;

    query_columns := parsed_json_object.GET_ARRAY(query_columns_key);
    query_columns_count := query_columns.GET_SIZE;

    response := response || '( ';

    FOR col_number IN 0..query_columns_count-1 LOOP
        query_current_column := query_columns.GET_STRING(col_number);


        response := response || query_current_column;

        if col_number < query_columns_count - 1 THEN
            response := response || ', ';
        END IF;
    END LOOP;

    response := response || ' )';

    response := response || ' VALUES ( ';
    query_value := parsed_json_object.GET_STRING(query_values_key);
    response := response || query_value || ' )';

    RETURN response;
END;