
-- MAIN FUNCTION BELOW 
DECLARE
    query VARCHAR2(4000) := '
{
    "queryType": "INSERT",
    "intoTable": "table1", 
    "columns": ["id", "col1", "col2"],
    "value": "11, 11, 11"
}
';

    parsed_document JSON_OBJECT_T := NULL;
    
    result_response_query_string VARCHAR2(4096) := NULL;
    response_for_select_query_cursor SYS_REFCURSOR := null;

    -- SAME COLUMNS AS IN QUERY !!! (TO DEMONSTRATE)
    id_temp table1.id%TYPE := NULL;
    col1_temp table1.col1%TYPE := NULL;
    col2_temp table1.col2%TYPE := NULL;
    name_temp table3.name%TYPE := NULL;
BEGIN
    parsed_document := JSON_OBJECT_T.parse(query); 

    -- TEST JUST PRINTING USUAL QUERY (AND EXECUTING WITHOUT OUTPUT)
    result_response_query_string := build_generic_query(parsed_document);
    DBMS_OUTPUT.PUT_LINE('[main] ' || result_response_query_string);


    -- TEST SELECT CURSOR:  
    --response_for_select_query_cursor := get_cursor_from_select_query(parsed_document);
    --DBMS_OUTPUT.PUT_LINE(' ');
    --DBMS_OUTPUT.PUT_LINE('[main] PRINTING VALUES FROM CURSOR FROM SELECT QUERY'); -- IMPORTANT TO FETCH THE SAME VARS !!!
    --LOOP
    --    FETCH response_for_select_query_cursor INTO id_temp, col1_temp, col2_temp, name_temp;
    --    EXIT WHEN response_for_select_query_cursor%NOTFOUND;
    --    DBMS_OUTPUT.PUT_LINE('  ROW:  ( ' || id_temp || ' , ' || col1_temp || ' , ' || col2_temp || ' , ' || name_temp || ' )');
    --END LOOP;
    --CLOSE response_for_select_query_cursor;
END;

/