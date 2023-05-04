
-- MAIN FUNCTION BELOW (entry point)
-- Here in DECLARE --> query variable you can define some JSON with query
-- and in main block (BEGIN - END) get its parsed command, execute it
-- and get output for SELECT queries as well (In cursor-view due to lab task statements)
DECLARE
    query VARCHAR2(4000) := '
{
            "queryType": "SELECT",
            "columnsNames": ["*"],
            "tablesNames": ["T1"],
            "where": [
                                    {
                    "in": {
                        "columnName": "id",
                        "subquerySelect": {
                            "queryType": "SELECT",
                            "columnsNames": ["id"],
                            "tablesNames": ["T2"],
                            "where": [
                                {
                                "usualCondition": "name LIKE ''%name%''",
                                "separator": "AND"
                                },
                                {
                                    "usualCondition": "val BETWEEN 1 AND 2",
                                    "separator": "AND"
                                }
                            ]
                    }
                    },
                    "separator": "OR"
                }
            ]
        }
';

    parsed_document JSON_OBJECT_T := NULL;
    
    result_response_query_string VARCHAR2(4096) := NULL;
    response_for_select_query_cursor SYS_REFCURSOR := null;

    -- (2) SAME COLUMNS AS IN QUERY !!! (TO DEMONSTRATE) // enable only when testing select
    --id_temp table1.id%TYPE := NULL;
    col1_temp T1.id%TYPE := NULL;
    col2_temp T1.name%TYPE := NULL;
    name_temp T1.val%TYPE := NULL;
BEGIN
    parsed_document := JSON_OBJECT_T.parse(query); 

    -- (1) TEST JUST PRINTING USUAL QUERY (AND EXECUTING WITHOUT OUTPUT)
    --result_response_query_string := build_generic_query(parsed_document);
    --DBMS_OUTPUT.PUT_LINE('[main] ' || result_response_query_string);
    --EXECUTE IMMEDIATE result_response_query_string;

    -- (2) TEST SELECT CURSOR:  
    response_for_select_query_cursor := get_cursor_from_select_query(parsed_document);
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('[main] PRINTING VALUES FROM CURSOR FROM SELECT QUERY'); -- IMPORTANT TO FETCH THE SAME VARS !!!
    LOOP
        FETCH response_for_select_query_cursor INTO col1_temp, col2_temp, name_temp;
        EXIT WHEN response_for_select_query_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('  ROW:  ( '  || ' , ' || col1_temp || ' , ' || col2_temp || ' , ' || name_temp || ' )');
    END LOOP;
    CLOSE response_for_select_query_cursor;
END;

/

--SELECT * FROM table1;

SELECT * FROM T1;
SELECT * FROM T2;