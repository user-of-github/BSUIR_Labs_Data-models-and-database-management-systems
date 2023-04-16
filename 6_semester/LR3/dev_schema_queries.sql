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