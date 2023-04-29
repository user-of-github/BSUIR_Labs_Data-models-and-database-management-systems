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

/

DECLARE
    query VARCHAR2(4000) := '
{
    "queryType": "SELECT",
    "columnsNames": ["*"],
    "tablesNames": ["table1"],
    "where": [
        {
            "usualCondition": "col1 > 2",
            "separator": "AND"
        },
        {
            "usualCondition": "col1 < 5"
        }
    ]
}
';

    parsed_document JSON_OBJECT_T := NULL;
    
    result_response_query_string VARCHAR2(4096) := NULL;
    response_for_select_query_cursor SYS_REFCURSOR := null;

    -- SAME COLUMNS AS IN QUERY !!! (TO DEMONSTRATE)
    id_temp table1.id%TYPE := NULL;
    col1_temp table1.col1%TYPE := NULL;
    col2_temp table1.col2%TYPE := NULL;
BEGIN
    parsed_document := JSON_OBJECT_T.parse(query); 

    --result_response_query_string := build_generic_query(parsed_document);
    response_for_select_query_cursor := get_cursor_from_select_query(parsed_document);
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('[main] PRINTING VALUES FROM CURSOR FROM SELECT QUERY');
    LOOP
        FETCH response_for_select_query_cursor INTO id_temp, col1_temp, col2_temp;
        EXIT WHEN response_for_select_query_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('  ROW:  ( ' || id_temp || ' , ' || col1_temp || ' , ' || col2_temp || ' )');
    END LOOP;

    CLOSE response_for_select_query_cursor;
END;

/