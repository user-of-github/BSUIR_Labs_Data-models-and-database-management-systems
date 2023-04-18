CREATE OR REPLACE PROCEDURE clear_schema_items(schema_name IN VARCHAR2) 
AS
BEGIN
    -- clear procedures
    FOR removed_procedure IN (SELECT object_name FROM ALL_OBJECTS WHERE object_type = 'PROCEDURE' AND owner = schema_name) LOOP
        EXECUTE IMMEDIATE 'DROP PROCEDURE ' || schema_name || '.' || removed_procedure.object_name;
    END LOOP;

    --clear functions
    FOR removed_procedure IN (SELECT object_name FROM ALL_OBJECTS WHERE object_type = 'FUNCTION' AND owner = schema_name) LOOP
        EXECUTE IMMEDIATE 'DROP FUNCTION ' || schema_name || '.' || removed_procedure.object_name;
    END LOOP;

    -- clear constraints
    FOR removed_constraint IN (SELECT constraint_name, table_name FROM ALL_CONSTRAINTS WHERE owner = schema_name AND NOT REGEXP_LIKE(constraint_name, '^BIN')) LOOP
        EXECUTE IMMEDIATE 'ALTER TABLE ' || schema_name || '.' || removed_constraint.table_name || ' DROP CONSTRAINT ' || removed_constraint.constraint_name;
    END LOOP;

    -- clear indexes
    FOR removed_index IN (SELECT index_name FROM ALL_INDEXES WHERE owner = schema_name) LOOP
        EXECUTE IMMEDIATE 'DROP INDEX ' || schema_name || '.' || removed_index.index_name;
    END LOOP;
    
    -- clear tables
    FOR removed_table IN (SELECT table_name FROM all_tables WHERE owner = schema_name) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE '|| schema_name || '.' || removed_table.table_name || ' CASCADE CONSTRAINTS ';
    END LOOP;

    -- clear packages
    -- clear procedures
    FOR removed_package IN (SELECT object_name FROM ALL_OBJECTS WHERE object_type = 'PACKAGE' AND owner = schema_name) LOOP
        EXECUTE IMMEDIATE 'DROP PACKAGE ' || schema_name || '.' || removed_package.object_name;
    END LOOP;
END;