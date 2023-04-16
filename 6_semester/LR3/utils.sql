CREATE OR REPLACE FUNCTION compare_tables_from_two_shemas(table_1_name VARCHAR2, schema_1_name VARCHAR2,table_2_name VARCHAR2,schema_2_name VARCHAR2)
RETURN BOOLEAN
IS
    ddl_1 VARCHAR2(4096) := NULL;
    ddl_2 VARCHAR2(4096) := NULL;
BEGIN
    ddl_1 := REPLACE(DBMS_METADATA.get_ddl('TABLE', table_1_name, schema_1_name), ('"' || schema_1_name || '".'), '');
    ddl_2 := REPLACE(DBMS_METADATA.get_ddl('TABLE', table_2_name, schema_2_name), ('"' || schema_2_name || '".'), '');

    -- Compare DDL
    IF ddl_1 = ddl_2 THEN
        RETURN true;
    ELSE
        RETURN false;
    END IF;
END;