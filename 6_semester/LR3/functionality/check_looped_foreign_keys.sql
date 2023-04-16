--DROP PROCEDURE check_circular_foreign_key_references;
--DROP FUNCTION get_table_name_by_foreign_key_reference;
--DROP FUNCTION find_circullar_reference_recursively;
--DROP FUNCTION check_table_on_circular_references;


/

-- returns the name of the table that is referenced by the foreign key constraint specified by constr_nm.
CREATE OR REPLACE FUNCTION get_table_name_by_foreign_key_reference(schema_name VARCHAR2, constr_nm VARCHAR2)
RETURN VARCHAR2
IS
    lv_constr_nm VARCHAR2(30);    
    lv_table_nm VARCHAR2(30);

BEGIN
    SELECT r_constraint_name INTO lv_constr_nm
    FROM all_constraints
    WHERE r_owner = schema_name AND constraint_type = 'R' AND constraint_name=constr_nm;
    
    SELECT table_name INTO lv_table_nm 
    FROM all_constraints
    WHERE constraint_type in ('P', 'U') AND owner = schema_name and constraint_name=lv_constr_nm;
        
   return lv_table_nm;
   
   EXCEPTION
        WHEN NO_DATA_FOUND
    THEN
        RETURN 'null';
END;

/
CREATE OR REPLACE FUNCTION find_circullar_reference_recursively(schema_name VARCHAR2, table_name VARCHAR2, constr_nm VARCHAR2, old_name VARCHAR2, table_temp_name VARCHAR2)
RETURN VARCHAR2
IS
    lv_curr_table_name VARCHAR2(100);
    CURSOR curr_names_fk(tab_name VARCHAR2) IS SELECT * FROM all_constraints WHERE r_owner = schema_name AND constraint_type = 'R' AND table_name = tab_name
        AND r_constraint_name in (
            SELECT constraint_name from all_constraints
            WHERE constraint_type in ('P', 'U')
            AND owner = schema_name)
        ORDER BY table_name, constraint_name;
    
    lv_row curr_names_fk%ROWTYPE := NULL;
    lv_row_count NUMBER := 0;
    sql_stmt VARCHAR2(50) := NULL;

BEGIN
    lv_curr_table_name := get_table_name_by_foreign_key_reference(schema_name, constr_nm);
    EXECUTE IMMEDIATE  utl_lms.format_message('INSERT INTO %s(name) VALUES (%s)', table_temp_name, CONCAT('''', table_name||''''));
    
    IF table_name != 'null' THEN
        EXECUTE IMMEDIATE  utl_lms.format_message('select COUNT(name) from %s WHERE name=%s', table_temp_name, CONCAT('''', table_name || '''')) INTO lv_row_count;
    END IF; 

    WHILE lv_curr_table_name != 'null' AND lv_curr_table_name != old_name AND lv_row_count <= 1 LOOP
        OPEN curr_names_fk(lv_curr_table_name);
        LOOP
            FETCH curr_names_fk INTO lv_row;
            lv_curr_table_name := find_circullar_reference_recursively(schema_name , lv_curr_table_name, lv_row.constraint_name, old_name, table_temp_name);
  
            EXECUTE IMMEDIATE  utl_lms.format_message('INSERT INTO %s(name) VALUES (%s)', table_temp_name, CONCAT('''', lv_curr_table_name||''''));
            IF table_name != 'null' THEN
                EXECUTE IMMEDIATE  utl_lms.format_message('select COUNT(name) from %s WHERE name=%s', table_temp_name, CONCAT('''', lv_curr_table_name || '''')) INTO lv_row_count;
            END IF; 

            EXIT WHEN curr_names_fk%notfound OR lv_curr_table_name = old_name OR lv_curr_table_name='null' OR lv_row_count > 1;     
        END LOOP;

        CLOSE curr_names_fk;
    END LOOP;
    
    IF lv_curr_table_name = old_name THEN
        return lv_curr_table_name;
    END IF;
    IF lv_row_count > 1 THEN
        return old_name;
    END IF;
    
    return 'null';
END;

/

CREATE OR REPLACE FUNCTION check_table_on_circular_references(schema_name VARCHAR2, table_nm VARCHAR2)
RETURN BOOLEAN
IS
    CURSOR curr_constr IS
        SELECT * FROM all_constraints WHERE r_owner = schema_name AND constraint_type = 'R' AND table_name = table_nm
        AND r_constraint_name in (
            SELECT constraint_name from all_constraints
            WHERE constraint_type in ('P', 'U')
            AND owner = schema_name)
        ORDER BY table_name, constraint_name;

    lv_constr_row curr_constr%ROWTYPE;
    lv_table_name VARCHAR(50) := 'temp_table_which_will_be_deleted';
BEGIN
    FOR lv_constr_row IN curr_constr
    LOOP
     EXECUTE IMMEDIATE  utl_lms.format_message('CREATE TABLE %s (name VARCHAR2(100))', lv_table_name);
        IF find_circullar_reference_recursively(schema_name, table_nm, lv_constr_row.constraint_name, table_nm, lv_table_name) = table_nm THEN
            EXECUTE IMMEDIATE utl_lms.format_message('DROP TABLE %s', lv_table_name);
            RETURN true;
        ELSE
            EXECUTE IMMEDIATE utl_lms.format_message('DROP TABLE %s', lv_table_name);
        END IF;
    END LOOP;

    RETURN false;
END;

/

CREATE OR REPLACE PROCEDURE check_circular_foreign_key_references (schema_name IN VARCHAR2)
IS
    CURSOR tables_from_schema IS SELECT table_name FROM all_tables WHERE owner = schema_name;
    table_name VARCHAR(100) := NULL;
BEGIN
    FOR table_from_schema IN tables_from_schema LOOP
        table_name := table_from_schema.table_name;

        IF check_table_on_circular_references(schema_name,  table_name) THEN
            DBMS_OUTPUT.PUT_LINE('[check_circular_foreign_key_references()] CIRCULAR REFERENCE FOUND WHEN SCANNING TABLE ' || schema_name ||'.'|| table_name);
        END IF;

    END LOOP;
END;