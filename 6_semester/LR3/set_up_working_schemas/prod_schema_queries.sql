-- лучше сначала выполнить все запросы на удаление, потом уже оставшиеся


-- EXECUTE THIS PACK FIRST
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
  EXECUTE IMMEDIATE 'DROP INDEX index_for_table1_which_is_only_in_prod_index';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE table1 DROP CONSTRAINT fk_to_table2';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE table2 DROP CONSTRAINT fk_to_table1';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE table1';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE table2';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

/
BEGIN
  EXECUTE IMMEDIATE 'DROP FUNCTION test_function';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

/
BEGIN
  EXECUTE IMMEDIATE 'DROP FUNCTION test_function_only_in_prod';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
-- create tables
/

-- EXECUTE THIS PACK SECOND
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


-- EXECUTE THIS PACK THIRD
ALTER TABLE table1 ADD CONSTRAINT fk_to_table2 FOREIGN KEY(reference_to_table2) REFERENCES table2(table2_id);
ALTER TABLE table2 ADD CONSTRAINT fk_to_table1 FOREIGN KEY(reference_to_table1) REFERENCES table1(table1_id);


-- EXECUTE THIS PACK FOURTH
/
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX index_for_table1_which_is_only_in_prod_index on table1(field1)';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;

/
-- EXECUTE THIS PACK FIFTH
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