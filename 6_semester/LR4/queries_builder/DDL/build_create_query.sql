CREATE OR REPLACE FUNCTION build_create_table_query(parsed_json_object IN JSON_OBJECT_T)
RETURN VARCHAR2
IS
    query_table_name_key CONSTANT VARCHAR2(50) := 'tableName';
    query_created_fields_key CONSTANT VARCHAR2(50) := 'fields';
    query_created_fields JSON_ARRAY_T := NULL;

    response VARCHAR2(4096) := '';
BEGIN
    response := 'CREATE TABLE ' || parsed_json_object.GET_STRING(query_table_name_key) || ' (';

    query_created_fields := parsed_json_object.GET_ARRAY(query_created_fields_key);

    FOR field IN 0..query_created_fields.GET_SIZE-1 LOOP
        response := response || query_created_fields.GET_STRING(field);
        
        IF field < query_created_fields.GET_SIZE - 1 THEN
            response := response || ', ';
        END IF;
    END LOOP;

    response := response || ')';

    RETURN response;    
END;