CREATE OR REPLACE FUNCTION generate_code(schema_name VARCHAR2, obj_type VARCHAR2, obj_name VARCHAR2)
RETURN NCLOB
IS
    procedure_code NCLOB;
BEGIN
    SELECT listagg(text, '') within GROUP (ORDER BY line) INTO procedure_code FROM ALL_SOURCE WHERE owner = schema_name AND TYPE = obj_type AND NAME = obj_name GROUP BY obj_name;
    
    procedure_code := CONCAT('CREATE OR REPLACE ', procedure_code);
    
    RETURN procedure_code;
END;

/

CREATE OR REPLACE FUNCTION remove_indexes_from_second_schema(schema_1_name VARCHAR2, schema_2_name VARCHAR2)
RETURN NCLOB
IS
    CURSOR cursor_schema_1 IS SELECT owner, index_name, table_name, uniqueness FROM all_indexes WHERE owner = schema_1_name;
    
    CURSOR cursor_schema_2 IS SELECT owner, index_name, table_name, uniqueness FROM all_indexes WHERE owner=schema_2_name;

    schema_1_row cursor_schema_1%ROWTYPE := NULL;
    schema_2_row cursor_schema_2%ROWTYPE := NULL;

    lv_result NCLOB := NULL;
    is_found BOOLEAN := NULL;

BEGIN
    FOR  schema_2_row IN cursor_schema_2 LOOP        
         is_found := FALSE;

         FOR schema_1_row IN cursor_schema_1 LOOP
            IF  schema_2_row.index_name=schema_1_row.index_name AND
                schema_2_row.table_name=schema_1_row.table_name  THEN
                is_found :=  TRUE;
            END IF;
            
            END LOOP;
            
            IF is_found = FALSE AND substr(schema_2_row.index_name,1,3) != 'SYS' THEN   
                lv_result :=  CONCAT(lv_result, chr(10) || utl_lms.format_message('DROP INDEX %s.%s;', schema_2_name, schema_2_row.index_name));              
            END IF;
    END LOOP;  

    RETURN lv_result;
END;

/



CREATE OR REPLACE FUNCTION generare_create_or_update_missing_indexes(schema_1_name VARCHAR2, schema_2_name VARCHAR2)
RETURN NCLOB
IS 
    lv_result NCLOB := NULL;
    is_found BOOLEAN := NULL;

    CURSOR cursor_schema_1 IS SELECT owner, index_name, table_name, uniqueness FROM ALL_INDEXES WHERE owner=schema_1_name;

    CURSOR cursor_schema_2 IS SELECT owner, index_name, table_name, uniqueness FROM ALL_INDEXES WHERE owner=schema_2_name;
   
    schema_1_row cursor_schema_1%ROWTYPE := NULL;
    schema_2_row cursor_schema_2%ROWTYPE := NULL;

BEGIN
    FOR schema_1_row IN cursor_schema_1 LOOP
        is_found := FALSE;
        
         FOR schema_2_row IN cursor_schema_2 LOOP
            
            IF  schema_2_row.index_name=schema_1_row.index_name AND
                schema_2_row.table_name=schema_1_row.table_name THEN
                is_found := true;
                IF are_indexes_from_schemas_equal(schema_1_name, schema_1_row.table_name, schema_1_row.index_name, schema_2_name, schema_2_row.table_name, schema_2_row.index_name) THEN
                    lv_result :=  CONCAT(lv_result, chr(10) || 
                    utl_lms.format_message('DROP INDEX %s.%s;', schema_2_name, schema_2_row.index_name));
                    lv_result := CONCAT(lv_result, chr(10) || 
                    utl_lms.format_message('CREATE INDEX %s ON %s.%s (%s);',
                    schema_1_row.index_name, schema_2_name, schema_1_row.TABLE_NAME, TO_NCHAR(substr(get_index_columns(schema_1_name, schema_1_row.table_name, schema_1_row.index_name),1,32766))));   
                END IF;
            END IF;
                
            END LOOP;  

            IF is_found=false AND substr(schema_1_row.index_name,1,3) != 'SYS' THEN
                    lv_result := CONCAT(lv_result, chr(10) || utl_lms.format_message('CREATE INDEX %s ON %s.%s (%s);', schema_1_row.index_name, schema_2_name, schema_1_row.TABLE_NAME, TO_NCHAR(substr(get_index_columns(schema_1_name, schema_1_row.table_name, schema_1_row.index_name),1,32766))));   
            END IF;
        END LOOP;
        
    RETURN lv_result;
END;
/

CREATE OR REPLACE FUNCTION get_index_columns(scheme VARCHAR2, table_nm VARCHAR2, index_nm VARCHAR2)
RETURN NCLOB
IS 
    lv_col_index_list NCLOB := NULL;   
BEGIN

    SELECT LISTAGG(COLUMN_name, ', ') WITHIN GROUP (ORDER BY column_position) list_index INTO lv_col_index_list
    FROM DBA_IND_COLUMNS
    WHERE table_name=table_nm AND index_owner=scheme AND index_name=index_nm
    GROUP BY index_name
    ORDER BY list_index;
    
    RETURN lv_col_index_list;
END;

/

CREATE OR REPLACE FUNCTION are_indexes_from_schemas_equal(schema_1_name IN VARCHAR2, table_1 IN VARCHAR2, index_1 IN VARCHAR2, schema_2_name VARCHAR2, table_2 VARCHAR2, index_2 VARCHAR2)
RETURN BOOLEAN
IS 
    lv_col_prod_index NCLOB := NULL;
    lv_col_dev_index NCLOB := NULL;

    is_equal BOOLEAN := false; 

BEGIN
    lv_col_prod_index := get_index_columns(schema_2_name, table_2, index_2);
    lv_col_dev_index := get_index_columns(schema_1_name, table_1, index_1);
     
    IF lv_col_prod_index= lv_col_dev_index THEN
        is_equal := true;
    END IF;
    
    RETURN is_equal;
END;



/

CREATE OR REPLACE FUNCTION are_objects_from_schemas_equal(schema_1_name VARCHAR2, schema_2_name VARCHAR2, type VARCHAR2, object_name VARCHAR2)
RETURN BOOLEAN    
IS
    obj_code_1 NCLOB := NULL;
    obj_code_2 NCLOB := NULL;
BEGIN
    obj_code_1 := generate_code(schema_1_name, type, object_name);
    obj_code_2 := generate_code(schema_2_name, type, object_name);
    
    IF obj_code_1 = obj_code_2 THEN
        RETURN false;
    END IF;
    
    RETURN true;
END;

/

CREATE OR REPLACE FUNCTION generate_objects_in_schema_2_prod(schema_1_name VARCHAR2, schema_2_name VARCHAR2, type VARCHAR2)
RETURN NCLOB
IS
    CURSOR cursor_schema_1 IS SELECT owner, object_name, object_type FROM all_objects WHERE owner=schema_1_name AND object_type=type ORDER BY object_name;
    
    CURSOR cursor_schema_2 IS SELECT owner, object_name, object_type FROM all_objects WHERE owner=schema_2_name AND object_type=type ORDER BY object_name;

    schema_1_col cursor_schema_1%ROWTYPE := NULL;
    schema_2_col cursor_schema_2%ROWTYPE := NULL;

    result NCLOB := NULL;
    is_found BOOLEAN := NULL;

BEGIN
    FOR  schema_1_col IN cursor_schema_1 LOOP        
         is_found := FALSE;

        FOR schema_2_col IN cursor_schema_2 LOOP
            IF schema_2_col.OBJECT_NAME=schema_1_col.OBJECT_NAME AND not are_objects_from_schemas_equal(schema_1_name, schema_2_name, type, schema_1_col.OBJECT_NAME) THEN
                is_found :=  TRUE;
            END IF;
            
        END LOOP;
            
        IF is_found=FALSE THEN   
            result := CONCAT(result, chr(10) || generate_code(schema_1_name, type, schema_1_col.OBJECT_NAME));
        END IF;
    END LOOP;   

    RETURN result;
END;

/

CREATE OR REPLACE FUNCTION remove_objects_in_prod(schema_1_name VARCHAR2, schema_2_name VARCHAR2, type VARCHAR2)
RETURN NCLOB
IS
    CURSOR cursor_schema_1 IS SELECT owner, object_name, object_type From all_objects  WHERE owner=schema_1_name AND object_type=type ORDER BY object_name;
    
    CURSOR cursor_schema_2 IS SELECT owner, object_name, object_type From all_objects  WHERE owner=schema_2_name AND object_type=type ORDER BY object_name;

    schema_1_col cursor_schema_1%ROWTYPE := NULL;
    schema_2_col cursor_schema_2%ROWTYPE := NULL;
    lv_result NCLOB := NULL;
    is_found BOOLEAN := NULL;

BEGIN
    FOR  schema_2_col IN cursor_schema_2 LOOP        
         is_found := FALSE;
         
         FOR schema_1_col IN cursor_schema_1 LOOP
            IF schema_2_col.OBJECT_NAME=schema_1_col.OBJECT_NAME THEN
                is_found :=  TRUE;
            END IF;
            
        END LOOP;
            
        IF is_found=FALSE THEN   
            lv_result := CONCAT(lv_result, chr(10) || 'DROP ' || type || ' ' || schema_2_col.OBJECT_NAME || ';');
        END IF;
    END LOOP;   

    RETURN lv_result;
END;

/

CREATE OR REPLACE FUNCTION generate_ddl_table(schema_1_name VARCHAR2, schema_2_name VARCHAR2, table_name VARCHAR2)
RETURN NCLOB
AS 
    lv_result NCLOB := NULL;
BEGIN
    SELECT DBMS_METADATA.GET_DDL('TABLE', table_name, schema_1_name) INTO lv_result FROM dual;
    lv_result := CONCAT(REGEXP_REPLACE(lv_result, upper(schema_1_name),upper(schema_2_name)), ';');
    
    RETURN lv_result;
END;

/


CREATE OR REPLACE FUNCTION remove_prod_tables(schema_1_name VARCHAR2, schema_2_name VARCHAR2)
RETURN NCLOB
IS
    CURSOR curr_dev_scheme IS SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = schema_1_name;

    CURSOR curr_prod_scheme IS SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = schema_2_name;

    is_found BOOLEAN := false;
    lv_result NCLOB := NULL;

BEGIN

    FOR schema_2_row IN curr_prod_scheme LOOP
        is_found := FALSE;
        
        FOR schema_1_row IN curr_dev_scheme LOOP
                IF schema_2_row.TABLE_NAME = schema_1_row.TABLE_NAME THEN
                    is_found := TRUE;        
                END IF;   
        END LOOP;    
            
        IF is_found = FALSE THEN          
            lv_result := CONCAT(lv_result, chr(10) || utl_lms.format_message('DROP TABLE %s.%s;', schema_2_name, schema_2_row.TABLE_NAME)); 
        END IF;
    END LOOP;
   
    RETURN lv_result;
END;





