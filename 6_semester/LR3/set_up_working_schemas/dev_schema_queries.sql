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

/
CREATE OR REPLACE FUNCTION test_function
RETURN BOOLEAN
IS
BEGIN
  RETURN false;
END;
/
CREATE OR REPLACE PROCEDURE test_proc_from_dev
AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Empty procedure');
END;
/
--DROP PACKAGE package_from_dev;
--CREATE OR REPLACE PACKAGE package_from_dev AS
--   PROCEDURE test_proc_from_dev;
--END package_from_dev;


CREATE TABLE t1(
  id NUMBER NOT NULL PRIMARY KEY,
  reference NUMBER
);

CREATE TABLE t2(
  id NUMBER NOT NULL PRIMARY KEY,
  reference NUMBER
);

CREATE TABLE t3(
  id NUMBER NOT NULL PRIMARY KEY,
  reference NUMBER
);

ALTER TABLE t2 ADD CONSTRAINT fk_to_t1 FOREIGN KEY(reference) REFERENCES t1(id);
ALTER TABLE t1 ADD CONSTRAINT fk_to_t3 FOREIGN KEY(reference) REFERENCES t3(id);