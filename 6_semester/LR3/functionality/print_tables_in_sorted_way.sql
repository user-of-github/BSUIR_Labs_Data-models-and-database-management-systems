--get tables orders

CREATE TABLE ddl_table
(
    table_name VARCHAR2(100),
    ddl_script VARCHAR2(3000),
    type       VARCHAR2(100),
    priority   NUMBER(10) DEFAULT 100000
);

CREATE TABLE fk_table
(
    id     NUMBER,
    child  VARCHAR2(100),
    parent VARCHAR2(100)
);

CREATE TABLE DEV_SCHEMA.t1(
  id NUMBER NOT NULL PRIMARY KEY,
  reference NUMBER
);

CREATE TABLE DEV_SCHEMA.t2(
  id NUMBER NOT NULL PRIMARY KEY,
  reference NUMBER
);

CREATE TABLE DEV_SCHEMA.t3(
  id NUMBER NOT NULL PRIMARY KEY,
  reference NUMBER
);

ALTER TABLE DEV_SCHEMA.t2 ADD CONSTRAINT fk_to_t1 FOREIGN KEY(reference) REFERENCES DEV_SCHEMA.t1(id);
ALTER TABLE DEV_SCHEMA.t1 ADD CONSTRAINT fk_to_t3 FOREIGN KEY(reference) REFERENCES DEV_SCHEMA.t3(id);

/




create or replace procedure GET_TABLES_ORDER(schema_name in varchar2) as
begin
    EXECUTE IMMEDIATE 'TRUNCATE TABLE fk_table';
    dbms_output.put_line('Showing tables order in schema');

    FOR schema_table IN (SELECT tables1.table_name name
                         FROM all_tables tables1
                         WHERE OWNER = schema_name)
        LOOP

            INSERT INTO fk_table (child, parent)
            SELECT DISTINCT a.table_name, c_pk.table_name
            FROM all_cons_columns a
                     JOIN all_constraints c ON a.owner = c.owner AND a.constraint_name = c.constraint_name
                     JOIN all_constraints c_pk ON c.r_owner = c_pk.owner AND c.r_constraint_name = c_pk.constraint_name
            WHERE c.constraint_type = 'R'
            AND a.table_name = schema_table.name;

        END LOOP;

    FOR fk_cur IN (
        SELECT CHILD, PARENT, MAX(LEVEL_2) as level_3, MAX(CONNECT_BY_ISYCLE_2) as CONNECT_BY_ISYCLE_3
        FROM (SELECT CHILD, parent, CONNECT_BY_ISCYCLE as CONNECT_BY_ISYCLE_2, LEVEL as LEVEL_2
              FROM fk_table
              CONNECT BY NOCYCLE PRIOR PARENT = child) levels
        GROUP BY CHILD, PARENT
        ORDER BY level_3 DESC
        )
        LOOP
            IF fk_cur.CONNECT_BY_ISYCLE_3 = 0 THEN
                UPDATE DDL_TABLE
                SET PRIORITY = fk_cur.level_3
                WHERE DDL_TABLE.TABLE_NAME = fk_cur.CHILD;
            ELSE
                dbms_output.put_line('CYCLE IN TABLE' || fk_cur.CHILD);
            END IF;
        END LOOP;
        

end GET_TABLES_ORDER;

/

BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DDL_TABLE';
    GET_TABLE_ORDER('DEV_SCHEMA'); -- 


END;