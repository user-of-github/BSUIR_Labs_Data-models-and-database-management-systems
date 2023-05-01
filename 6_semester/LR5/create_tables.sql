DROP TABLE movies;
DROP TABLE cinematic_universes;
DROP TABLE entertainment_corporations;


-- Disney, Warner Brothers, Sony ...
CREATE TABLE entertainment_corporations(
    id NUMBER NOT NULL PRIMARY KEY,
    title VARCHAR2(100) NOT NULL,
    ceo VARCHAR2(100) NOT NULL
);

-- MARVEL, DCEU, SpiderVerse (why not)
CREATE TABLE cinematic_universes(
    id NUMBER NOT NULL PRIMARY KEY,
    title VARCHAR2(100) NOT NULL,
    owning_corporation NUMBER DEFAULT NULL,
    
    CONSTRAINT foreign_key_universe_corporation 
        FOREIGN KEY (owning_corporation) 
        REFERENCES entertainment_corporations(id)
        ON DELETE SET NULL
);

-- Avengers: Infinity War, Justice League, Spider-Man: No Way Home ...
CREATE TABLE movies(
    id NUMBER NOT NULL PRIMARY KEY,
    title VARCHAR2(100) NOT NULL,
    release_date DATE NOT NULL,
    cinematic_universe NUMBER,

    CONSTRAINT foreign_key_movie_universe
        FOREIGN KEY (cinematic_universe)
        REFERENCES cinematic_universes(id)
        ON DELETE SET NULL
);