CREATE OR REPLACE FUNCTION build_select_query(parsed_json_object IN JSON_OBJECT_T)
RETURN VARCHAR2
IS
    response VARCHAR(4096) := '';

    -- TABLES VARS
    query_tables_key CONSTANT VARCHAR2(100) := 'tablesNames';
    query_tables JSON_ARRAY_T := NULL;
    
    -- COLUMNS VARS
    query_colums_key CONSTANT VARCHAR(100) := 'columnsNames';
    query_columns JSON_ARRAY_T := NULL;

    -- WHERE VARS
    query_where_key CONSTANT VARCHAR(100) := 'where';
    query_where_statements JSON_ARRAY_T := NULL;

    usual_condition_key CONSTANT VARCHAR2(100) := 'usualCondition';
    in_condition_key CONSTANT VARCHAR2(100) := 'in';
    not_in_condition_key CONSTANT VARCHAR2(100) := 'notIn';
    exists_condition_key CONSTANT VARCHAR2(100) := 'exists';
    not_exists_condition_key CONSTANT VARCHAR2(100) := 'notExists';

    separator_key CONSTANT VARCHAR2(100) := 'separator';
    sub_query_column_name_key CONSTANT VARCHAR2(100) := 'columnName';
    sub_query_select_key CONSTANT VARCHAR2(100) := 'subquerySelect';

    where_statements_count NUMBER := NULL;
    where_statement JSON_OBJECT_T := NULL;
    sub_query_object JSON_OBJECT_T := NULL;

    -- JOIN VARS
    query_join_key CONSTANT VARCHAR(100) := 'join';
    joins_array JSON_ARRAY_T := NULL;

BEGIN

    response := response || 'SELECT ';
    
    -- COLUMNS
    query_columns := parsed_json_object.GET_ARRAY(query_colums_key);
    response := response || build_columns_sequence_row(query_columns);


    -- TABLES
    response := response || 'FROM ';
    query_tables := parsed_json_object.GET_ARRAY(query_tables_key);
    response := response || build_tables_sequence_row(query_tables);

     -- JOINS
    IF parsed_json_object.HAS(query_join_key) THEN
        joins_array := parsed_json_object.GET_ARRAY(query_join_key);
        response := response || build_joins_row(joins_array);
    END IF;


    -- WHERE STATEMENTS // unable to put to separate function -- so coded here inline generating WHERE row
    IF parsed_json_object.HAS(query_where_key) THEN
        query_where_statements := parsed_json_object.GET_ARRAY(query_where_key);
        
        where_statements_count := query_where_statements.GET_SIZE;

        IF where_statements_count > 0 THEN
            response := response || 'WHERE ';

            FOR where_statement_number IN 0..where_statements_count-1 LOOP
                where_statement := TREAT(query_where_statements.GET(where_statement_number) AS JSON_OBJECT_T);

                IF where_statement.HAS(usual_condition_key) THEN
                    response := response || where_statement.GET_STRING(usual_condition_key);
                ELSIF where_statement.HAS(in_condition_key) THEN
                    sub_query_object := TREAT(where_statement.GET(in_condition_key) AS JSON_OBJECT_T);
                    response := response || sub_query_object.GET_STRING(sub_query_column_name_key) || ' IN (';
                    response := response || build_select_query(TREAT(sub_query_object.GET(sub_query_select_key) AS JSON_OBJECT_T));
                    response := response || ')';
                ELSIF where_statement.HAS(not_in_condition_key) THEN
                    sub_query_object := TREAT(where_statement.GET(not_in_condition_key) AS JSON_OBJECT_T);
                    response := response || sub_query_object.GET_STRING(sub_query_column_name_key) || ' NOT IN (';
                    response := response || build_select_query(TREAT(sub_query_object.GET(sub_query_select_key) AS JSON_OBJECT_T));
                    response := response || ')';
                ELSIF where_statement.HAS(exists_condition_key) THEN
                    sub_query_object := TREAT(where_statement.GET(exists_condition_key) AS JSON_OBJECT_T);
                    response := response || ' EXISTS (';
                    response := response || build_select_query(TREAT(sub_query_object.GET(sub_query_select_key) AS JSON_OBJECT_T));
                    response := response || ')';
                ELSIF where_statement.HAS(not_exists_condition_key) THEN
                    sub_query_object := TREAT(where_statement.GET(not_exists_condition_key) AS JSON_OBJECT_T);
                    response := response || ' NOT EXISTS (';
                    response := response || build_select_query(TREAT(sub_query_object.GET(sub_query_select_key) AS JSON_OBJECT_T));
                    response := response || ')';
                END IF;

                IF where_statement.HAS(separator_key) AND where_statement_number != where_statements_count-1 THEN
                    response := response || ' ' || where_statement.GET_STRING(separator_key);
                END IF;

                response := response || ' ';
            END LOOP;
        END IF;
    END IF;


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

CREATE OR REPLACE FUNCTION build_joins_row(joins_array IN JSON_ARRAY_T)
RETURN VARCHAR2
IS
    joins_count NUMBER := NULL;
    single_join_object JSON_OBJECT_T := NULL;

    join_type_key CONSTANT VARCHAR2(100) := 'joinType';
    join_type VARCHAR2(100) := NULL;

    join_table_key CONSTANT VARCHAR2(100) := 'joinTable';
    join_table VARCHAR2(100) := NULL;

    join_codition_key CONSTANT VARCHAR2(100) := 'onCondition';
    join_condition VARCHAR2(100) := NULL;

    response VARCHAR2(4096) := '';
BEGIN
    joins_count := joins_array.GET_SIZE;

    FOR join_number IN 0..joins_count-1 LOOP
        single_join_object := TREAT(joins_array.GET(join_number) AS JSON_OBJECT_T);

        join_type := single_join_object.GET_STRING(join_type_key);
        join_table := single_join_object.GET_STRING(join_table_key);
        join_condition := single_join_object.GET_STRING(join_codition_key);

        response := response || ' ' || join_type || ' ' || join_table || ' ON ' || join_condition || ' ';
    END LOOP;

    RETURN response;
END;



/



SET SQLBLANKLINES ON

/
CREATE OR REPLACE FUNCTION get_cursor_from_select_query(parsed_document IN JSON_OBJECT_T) 
RETURN SYS_REFCURSOR
IS
    result_select_query VARCHAR2(4096) := NULL;

    result_cursor SYS_REFCURSOR := NULL;
BEGIN

    result_select_query := build_generic_query(parsed_document);

    DBMS_OUTPUT.PUT_LINE('[get_cursor_from_select_query]: ' || result_select_query);

    OPEN result_cursor FOR result_select_query;

    RETURN result_cursor;
END;