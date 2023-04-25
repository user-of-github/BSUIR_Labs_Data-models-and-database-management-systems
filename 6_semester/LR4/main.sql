SET SQLBLANKLINES ON


CREATE OR REPLACE PROCEDURE parse_and_execute_query(json_sql_query IN NCLOB, should_execute IN BOOLEAN) 
AS
    query_type_key CONSTANT VARCHAR2(100) := 'queryType';

    query_type VARCHAR2(100) := NULL;
    parsed_document JSON_OBJECT_T := NULL;

    result_query VARCHAR2(4096) := NULL;
BEGIN
    --DBMS_OUTPUT.PUT_LINE(json_sql_query);
    parsed_document := JSON_OBJECT_T.parse(json_sql_query);
    query_type := parsed_document.get_string(query_type_key);
    DBMS_OUTPUT.PUT_LINE('[parse_query] PARSING QUERY ' || query_type);

    result_query := SYS.build_select_query(parsed_document);

    
    IF should_execute = FALSE THEN 
        DBMS_OUTPUT.PUT_LINE(result_query);
    ELSE
        EXECUTE IMMEDIATE result_query;
    END IF;
END;

/

DECLARE
    select_query VARCHAR2(4000) := '
    {
        "queryType": "SELECT",
        "columnsNames": ["*"],
        "tablesNames": ["table1"]
    }
    ';
BEGIN
    parse_and_execute_query(select_query, false);
END;
