CREATE OR REPLACE PROCEDURE copy_item_from_schema_to_schema(item_type IN VARCHAR2, item_name IN VARCHAR2, schema_source_name IN VARCHAR2, schema_destionation_name IN VARCHAR2)
AS
    ddl_of_object VARCHAR2(10000) := NULL;
BEGIN
    DBMS_OUTPUT.PUT_LINE('[copy_item_from_schema_to_schema()] START' || item_type || ' ' || item_name || ' ' ||schema_source_name);
  -- Get the DDL for the table in the source schema
    ddl_of_object := DBMS_METADATA.GET_DDL(item_type, item_name, schema_source_name);
  
  -- Modify the DDL to specify the target schema
   -- ddl_of_object := REPLACE(ddl_of_object, schema_source_name, schema_destionation_name);
   -- DBMS_OUTPUT.PUT_LINE(ddl_of_object);
  -- Execute the modified DDL in the target schema
    --EXECUTE IMMEDIATE ddl_of_object;
  
    --DBMS_OUTPUT.PUT_LINE('[copy_item_from_schema_to_schema()] ' || item_type || ' ' || item_name || ' DDL are expected to be copied successfully.');
END;