CREATE OR REPLACE FUNCTION build_delete_query(parsed_json_object IN JSON_OBJECT_T)
RETURN VARCHAR2
IS
    response VARCHAR(4096) := '';

    -- TABLE VARS
    query_table_key CONSTANT VARCHAR2(100) := 'tableName';
    query_table VARCHAR2(100) := NULL;
    
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

BEGIN

    response := response || 'DELETE ';

    -- TABLE
    response := response || 'FROM ';
    query_table := parsed_json_object.GET_STRING(query_table_key);
    response := response || query_table;


    -- WHERE STATEMENTS // unable to put to separate function -- so coded here inline generating WHERE row
    IF parsed_json_object.HAS(query_where_key) THEN
        query_where_statements := parsed_json_object.GET_ARRAY(query_where_key);
        
        where_statements_count := query_where_statements.GET_SIZE;

        IF where_statements_count > 0 THEN
            response := response || ' WHERE ';

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
