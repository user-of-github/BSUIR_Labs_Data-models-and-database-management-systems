CREATE OR REPLACE FUNCTION build_drop_table_query(parsed_json_object IN JSON_OBJECT_T)
RETURN VARCHAR2
IS
    query_table_name_key CONSTANT VARCHAR2(50) := 'tableName';
BEGIN
    RETURN 'DROP TABLE ' || parsed_json_object.GET_STRING(query_table_name_key);
END;