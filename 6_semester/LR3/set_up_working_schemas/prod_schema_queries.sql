-- drop tables if exist
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE movies';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE entertainment_corporations';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE differ_table_example';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX index_for_table1_which_is_only_in_prod';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
-- create tables
/

CREATE TABLE entertainment_corporations( 
  corporation_id NUMBER NOT NULL PRIMARY KEY,
  corporation_name VARCHAR2(50) NOT NULL
);

CREATE TABLE movies(
  movie_id NUMBER NOT NULL PRIMARY KEY,
  movie_title VARCHAR2(50) NOT NULL,
  entertainment_corporation_id NUMBER,
  box_office NUMBER,
  CONSTRAINT foreign_key_entertainment_corporation
    FOREIGN KEY (entertainment_corporation_id)
    REFERENCES entertainment_corporations(corporation_id)
    ON DELETE CASCADE
);

CREATE TABLE differ_table_example(
  table_id NUMBER NOT NULL PRIMARY KEY,
  value NUMBER NOT NULL
);


ALTER TABLE table1 DROP COLUMN reference_to_table2;
ALTER TABLE table2 DROP COLUMN reference_to_table1;


DROP TABLE table1;
DROP TABLE table2;

CREATE TABLE table1 (
    table1_id INTEGER NOT NULL PRIMARY KEY,
    field1 VARCHAR(50),
    reference_to_table2 INTEGER 
);

CREATE TABLE table2 (
    table2_id INTEGER NOT NULL PRIMARY KEY,
    field2 VARCHAR(50),
    reference_to_table1 INTEGER 
);


ALTER TABLE table1 ADD CONSTRAINT fk_to_table2 FOREIGN KEY(reference_to_table2) REFERENCES table2(table2_id);
ALTER TABLE table2 ADD CONSTRAINT fk_to_table1 FOREIGN KEY(reference_to_table1) REFERENCES table1(table1_id);


DROP INDEX index_for_table1_which_is_only_in_prod;
CREATE INDEX index_for_table1_which_is_only_in_prod on table1(field1);

/

CREATE OR REPLACE FUNCTION test_function
RETURN BOOLEAN
IS
BEGIN
  RETURN false;
END;

/

CREATE OR REPLACE FUNCTION test_function_only_in_prod
RETURN BOOLEAN
IS
BEGIN
  RETURN false;
END;