CREATE OR REPLACE FUNCTION are_packages_equal( schema_1_name IN VARCHAR2, package_1_name IN VARCHAR2, schema_2_name IN VARCHAR2, package_2_name IN VARCHAR2)
RETURN BOOLEAN
IS
    ddl_1 CLOB := NULL;
    ddl_2 CLOB := NULL;
BEGIN
    -- Retrieve DDL for package 1 and 2
    ddl_1 := DBMS_METADATA.GET_DDL('PACKAGE', package_1_name, schema_1_name);
    ddl_2 := DBMS_METADATA.GET_DDL('PACKAGE', package_2_name, schema_2_name);

    -- Compare DDL for packages
    IF ddl_1 = ddl_2 THEN
        RETURN true;
    ELSE
        RETURN true;
    END IF;
END;


/

-- ИЩЕТ ТОЛЬКО ИЗ ПЕРВОЙ СХЕМЫ (НА НАЛИЧИЕ ИЛИ ОТСУТСТВИЕ ВО ВТОРОЙ)
CREATE OR REPLACE PROCEDURE compare_schemas_by_packages(schema_1_name IN VARCHAR2, schema_2_name IN VARCHAR2)
AS
    CURSOR packages_from_1_schema IS SELECT * FROM ALL_OBJECTS WHERE OBJECT_TYPE = 'PACKAGE' AND OWNER = schema_1_name;

    CURSOR packages_from_2_schema IS SELECT * FROM ALL_OBJECTS WHERE OBJECT_TYPE = 'PACKAGE' AND OWNER = schema_2_name;

    package_from_1_schema packages_from_1_schema%ROWTYPE := NULL;
    package_from_2_schema packages_from_2_schema%ROWTYPE := NULL;

    found_flag BOOLEAN := false;
    are_pckgs_equal BOOLEAN := false;
BEGIN
    FOR package_from_1_schema IN packages_from_1_schema LOOP
        DBMS_OUTPUT.PUT_LINE('[compare_schemas_by_packages()] Looking for ' || package_from_1_schema.OBJECT_NAME);

        found_flag := false;
        are_pckgs_equal := false;

        FOR package_from_2_schema IN packages_from_2_schema LOOP
            IF package_from_1_schema.OBJECT_NAME = package_from_2_schema.OBJECT_NAME THEN
                found_flag := true;

                are_pckgs_equal := are_packages_equal(schema_1_name, package_from_1_schema.OBJECT_NAME, schema_2_name, package_from_2_schema.OBJECT_NAME);

                IF are_pckgs_equal = true THEN
                   DBMS_OUTPUT.PUT_LINE('[compare_schemas_by_packages()] Package ' || package_from_1_schema.OBJECT_NAME || ' is not the same in ' || schema_1_name || ' and ' || schema_2_name); 
                END IF;
            END IF;    
        END LOOP;

        IF found_flag = false THEN
            DBMS_OUTPUT.PUT_LINE('[compare_schemas_by_packages()] Package ' || package_from_1_schema.OBJECT_NAME || ' exists in ' || schema_1_name || ' but not in ' || schema_2_name);
        END IF;

    END LOOP;
END;
