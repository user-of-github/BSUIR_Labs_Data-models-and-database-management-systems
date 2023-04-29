CREATE OR REPLACE FUNCTION build_generic_query(parsed_json_object IN JSON_OBJECT_T) 
RETURN VARCHAR2
IS
    query_type_key CONSTANT VARCHAR2(100) := 'queryType';

    query_type VARCHAR2(100) := NULL;

    response VARCHAR2(4096) := '';

BEGIN
    query_type := parsed_json_object.GET_STRING(query_type_key);
    DBMS_OUTPUT.PUT_LINE('[build_generic_query] BUILDING QUERY ' || query_type);


    IF query_type = 'SELECT' THEN
        response := response || build_select_query(parsed_json_object);
    END IF;

    
    RETURN response;
END;