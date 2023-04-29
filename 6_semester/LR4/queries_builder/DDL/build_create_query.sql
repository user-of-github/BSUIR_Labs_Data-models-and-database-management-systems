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

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '[build_create_table_query] TRIGGER FOR TABLE: ');
    DBMS_OUTPUT.PUT_LINE(build_auto_incrementing_trigger_for_created_table(parsed_json_object.GET_STRING(query_table_name_key)));
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    
    RETURN response;    
END;

/

CREATE OR REPLACE FUNCTION build_auto_incrementing_trigger_for_created_table(table_name IN VARCHAR2)
RETURN VARCHAR2
IS
    sequence_name VARCHAR2(100) := '';
    response VARCHAR2(2000) := '';
BEGIN
    sequence_name := 'sequence_for_' || table_name;
    response := response || 'CREATE SEQUENCE ' || sequence_name || ';' || CHR(10);
    response := response || 'CREATE OR REPLACE TRIGGER ' || table_name || '_trigger_auto_index_inc BEFORE INSERT ON ' || table_name || ' FOR EACH ROW ' || CHR(10);
    response := response || 'BEGIN' || CHR(10) || ':new.id = ' || sequence_name || '.NEXTVAL;' || CHR(10) || 'END;';

    RETURN response;
END;