CREATE OR REPLACE FUNCTION build_select_query(parsed_json_object IN JSON_OBJECT_T)
RETURN VARCHAR2
IS
    query_tables_key CONSTANT VARCHAR2(100) := 'tablesNames';
    query_tables JSON_ARRAY_T := NULL;
    
    query_colums_key CONSTANT VARCHAR(100) := 'columnsNames';
    query_columns JSON_ARRAY_T := NULL;

    query_where_key CONSTANT VARCHAR(100) := 'where';
    query_where_statements JSON_ARRAY_T := NULL;

    response VARCHAR(4096) := '';

BEGIN
    response := response || 'SELECT ';
    
    -- COLUMNS
    query_columns := parsed_json_object.GET_ARRAY(query_colums_key);
    response := response || build_columns_sequence_row(query_columns);

    response := response || 'FROM ';

    -- TABLES NAMES
    query_tables := parsed_json_object.GET_ARRAY(query_tables_key);
    response := response || build_tables_sequence_row(query_tables);

    -- WHERE STATEMENTS
    query_where_statements := parsed_json_object.GET_ARRAY(query_where_key);
    response := response || build_where_sequence_row(query_where_statements);


    RETURN response;
END;

/

CREATE OR REPLACE FUNCTION build_tables_sequence_row(query_tables IN JSON_ARRAY_T)
RETURN VARCHAR2
IS
    tables_count NUMBER := NULL;
    table_name VARCHAR2(100) := NULL;
    response VARCHAR2(4096) := '';
BEGIN
    tables_count := query_tables.GET_SIZE;

    FOR table_number IN 0..tables_count-1 LOOP
        table_name := query_tables.GET_STRING(table_number);
        
        response := response || table_name;
        
        IF table_number < tables_count - 1 THEN
            response := response || ',';
        END IF;

        response := response || ' ';
    END LOOP;

    RETURN response;
END;

/

CREATE OR REPLACE FUNCTION build_columns_sequence_row(query_columns IN JSON_ARRAY_T)
RETURN VARCHAR2
IS
    columns_count NUMBER := NULL;
    column_name VARCHAR2(100) := NULL;
    response VARCHAR2(4096) := '';
BEGIN
    columns_count := query_columns.GET_SIZE;

    FOR table_number IN 0..columns_count-1 LOOP
        column_name := query_columns.GET_STRING(table_number);
        
        response := response || column_name;
        
        IF table_number < columns_count - 1 THEN
            response := response || ',';
        END IF;

        response := response || ' ';
    END LOOP;

    RETURN response;
END;

/

CREATE OR REPLACE FUNCTION build_where_sequence_row(where_statements IN JSON_ARRAY_T)
RETURN VARCHAR2
IS
    where_statements_count NUMBER := NULL;
    where_statement JSON_OBJECT_T := NULL;
    response VARCHAR2(4096) := '';
BEGIN
    where_statements_count := where_statements.GET_SIZE;

    FOR where_statement_number IN 0..where_statements_count-1 LOOP
        response := response || ' ';
    END LOOP;

    RETURN response;
END;