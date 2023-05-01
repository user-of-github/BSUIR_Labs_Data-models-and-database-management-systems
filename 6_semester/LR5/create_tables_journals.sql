DROP TABLE journal_entertainment_corporations;
DROP TABLE journal_cinematic_universes;
DROP TABLE journal_movies;


CREATE TABLE journal_entertainment_corporations(
    operation_id NUMBER NOT NULL PRIMARY KEY,
    operation VARCHAR2(100) NOT NULL,
    time_stamp DATE NOT NULL,

    -- fields from 'entertainment_corporations'
    id NUMBER NOT NULL,
    title VARCHAR2(100) NOT NULL,
    ceo VARCHAR2(100) NOT NULL
);


CREATE TABLE journal_cinematic_universes(
    operation_id NUMBER NOT NULL PRIMARY KEY,
    operation VARCHAR2(100) NOT NULL,
    time_stamp DATE NOT NULL,

    -- fields from 'cinematic_universes'
    id NUMBER NOT NULL,
    title VARCHAR2(100) NOT NULL,
    owning_corporation NUMBER
);

CREATE TABLE journal_movies(
    operation_id NUMBER NOT NULL PRIMARY KEY,
    operation VARCHAR2(100) NOT NULL,
    time_stamp DATE NOT NULL,

    -- fields from 'movies'
    id NUMBER NOT NULL,
    title VARCHAR2(100) NOT NULL,
    release_date DATE NOT NULL,
    cinematic_universe NUMBER
);