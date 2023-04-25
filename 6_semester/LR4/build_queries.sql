CREATE OR REPLACE FUNCTION build_select_query(parsed_json_object IN JSON_OBJECT_T)
RETURN VARCHAR2
IS
    query_tables_key CONSTANT VARCHAR2(100) := 'tablesNames';
    query_tables JSON_ARRAY_T := NULL;
    query_table_name VARCHAR2(100) := NULL;
    query_tables_count NUMBER := NULL;
    
    query_colums_key CONSTANT VARCHAR(100) := 'columnsNames';
    query_columns JSON_ARRAY_T := NULL;
    query_column_name VARCHAR2(100) := NULL;
    query_columns_count NUMBER := NULL;

    response VARCHAR(4096) := '';

BEGIN
    response := response || 'SELECT ';
    
    -- COLUMNS
    query_columns := parsed_json_object.GET_ARRAY(query_colums_key);
    query_columns_count := query_columns.GET_SIZE;

    FOR column_number IN 0..query_columns_count-1 LOOP
        query_column_name := query_columns.GET_STRING(column_number);
        
        response := response || query_column_name;
        
        IF column_number < query_columns_count - 1 THEN
            response := response || ',';
        END IF;

        response := response || ' ';
    END LOOP;

    response := response || 'FROM ';

    -- TABLES NAMES
    query_tables := parsed_json_object.GET_ARRAY(query_tables_key);
    query_tables_count := query_tables.GET_SIZE;

    FOR table_number IN 0..query_tables_count-1 LOOP
        query_table_name := query_tables.GET_STRING(table_number);
        
        response := response || query_table_name;
        
        IF table_number < query_tables_count - 1 THEN
            response := response || ',';
        END IF;

        response := response || ' ';
    END LOOP;



    RETURN response;
END;