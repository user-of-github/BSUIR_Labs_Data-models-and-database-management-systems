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
  EXECUTE IMMEDIATE 'DROP TABLE table_only_from_dev_schema';
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
  value VARCHAR2(50) NOT NULL
);

CREATE TABLE table_only_from_dev_schema(
  table_id NUMBER NOT NULL PRIMARY KEY,
  value VARCHAR2(42) NOT NULL
);

CREATE INDEX index_for_table_which_is_only_in_dev ON table_only_from_dev_schema(value);


CREATE OR REPLACE FUNCTION test_function
RETURN BOOLEAN
IS
BEGIN
  RETURN false;
END;

