CREATE OR REPLACE PROCEDURE compare_schemas_by_functions (procedure_or_function IN VARCHAR2, schema_1_name IN VARCHAR2, schema_2_name IN VARCHAR2)
AS
    CURSOR functions_from_schema_1 IS
        SELECT object_name
        FROM ALL_PROCEDURES
        WHERE owner = schema_1_name AND object_type = procedure_or_function;
        
    CURSOR functions_from_schema_2 IS
        SELECT object_name
        FROM ALL_PROCEDURES
        WHERE owner = schema_2_name AND object_type = procedure_or_function;

    function_from_schema_1 functions_from_schema_1%ROWTYPE;
    function_from_schema_2 functions_from_schema_2%ROWTYPE;

    found_function_with_such_name BOOLEAN := false;
    functions_equal_flag BOOLEAN := false;
BEGIN
    -- Loop through the functions/procs in the 1st schema
    FOR function_from_schema_1 IN functions_from_schema_1 LOOP
        --DBMS_OUTPUT.PUT_LINE('[compare_schemas_by_functions()]' || 'LOOKING FOR ' || function_from_schema_1.object_name);
        -- Look for the same function/proc in the 2nd schema
        found_function_with_such_name := false;
        functions_equal_flag := false;

        FOR function_from_schema_2 IN functions_from_schema_2 LOOP
            IF function_from_schema_1.object_name = function_from_schema_2.object_name THEN
                found_function_with_such_name := true;
                DBMS_OUTPUT.PUT_LINE('[compare_schemas_by_functions()] ' || procedure_or_function || ' ' || function_from_schema_1.object_name || ' exists both in ' || schema_1_name || ' and ' || schema_2_name);
                functions_equal_flag := are_functions_equal(procedure_or_function, schema_1_name, function_from_schema_1.object_name, schema_2_name, function_from_schema_2.object_name);
                
                IF functions_equal_flag = false THEN
                     DBMS_OUTPUT.PUT_LINE('[compare_schemas_by_functions()] ' || procedure_or_function || ' ' || function_from_schema_1.object_name || ' is different in these schemas');
                END IF;

                EXIT;
            END IF;
        END LOOP;

        IF found_function_with_such_name = false THEN
            DBMS_OUTPUT.PUT_LINE('[compare_schemas_by_functions()] ' || procedure_or_function || ' ' || function_from_schema_1.object_name || ' exists in ' || schema_1_name || ' , but not in ' || schema_2_name);
        END IF;

    END LOOP;


    FOR function_from_schema_2 IN functions_from_schema_2 LOOP
        -- Look for the same function/proc in the 2nd schema
        found_function_with_such_name := false;
        functions_equal_flag := false;
        FOR function_from_schema_1 IN functions_from_schema_1 LOOP
            IF function_from_schema_1.object_name = function_from_schema_2.object_name THEN
                found_function_with_such_name := true;
                DBMS_OUTPUT.PUT_LINE('[compare_schemas_by_functions()] ' || procedure_or_function || ' ' || function_from_schema_1.object_name || ' exists both in ' || schema_2_name || ' and ' || schema_1_name);
                functions_equal_flag := are_functions_equal(procedure_or_function, schema_1_name, function_from_schema_1.object_name, schema_2_name, function_from_schema_2.object_name);
                
                IF functions_equal_flag = false THEN
                     DBMS_OUTPUT.PUT_LINE('[compare_schemas_by_functions()] ' || procedure_or_function || ' ' || function_from_schema_2.object_name || ' is different in these schemas');
                END IF;
                
                EXIT;
            END IF;
        END LOOP;

        IF found_function_with_such_name = false THEN
            DBMS_OUTPUT.PUT_LINE('[compare_schemas_by_functions()] ' || procedure_or_function || ' ' || function_from_schema_2.object_name || ' exists in ' || schema_2_name || ' , but not in ' || schema_1_name);
        END IF;
    -- Loop through the functions in the 2nd schema
    END LOOP;
END;

/

CREATE OR REPLACE FUNCTION are_functions_equal(procedure_or_function IN VARCHAR2, schema_1_name IN VARCHAR2, function_1_name IN VARCHAR2, schema_2_name IN VARCHAR2, function_2_name IN VARCHAR2) 
RETURN BOOLEAN
IS
    CURSOR compare_functions_body_line_by_line_cursor IS 
    SELECT *
    FROM 
        (SELECT TEXT as text1, LINE as line1 FROM ALL_SOURCE WHERE NAME = function_1_name AND TYPE = procedure_or_function AND OWNER = schema_1_name) t1
        JOIN
        (SELECT TEXT as text2, LINE as line2 FROM ALL_SOURCE WHERE NAME = function_2_name AND TYPE = procedure_or_function AND OWNER = schema_2_name) t2
        ON (t1.line1 = t2.line2);

    one_code_line_from_2_functions compare_functions_body_line_by_line_cursor%ROWTYPE := NULL;

BEGIN
    FOR one_code_line_from_2_functions IN compare_functions_body_line_by_line_cursor LOOP
        IF one_code_line_from_2_functions.text1 != one_code_line_from_2_functions.text2 THEN
            RETURN false;
        END IF;
    END LOOP;
    
    RETURN true;
END;

