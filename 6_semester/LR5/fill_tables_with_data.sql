TRUNCATE TABLE cinematic_universes;
TRUNCATE TABLE entertainment_corporations;

INSERT INTO entertainment_corporations VALUES (1, 'Disney', 'Robert Iger');
INSERT INTO entertainment_corporations VALUES (2, 'Warner Bros.', 'David Zaslav');
INSERT INTO entertainment_corporations VALUES (3, 'Sony Pictures', 'Tony Vinciquerra');

INSERT INTO cinematic_universes VALUES (1, 'Marvel Cinematic Universe', 1);
INSERT INTO cinematic_universes VALUES (2, 'DC Extended Universe', 2);
INSERT INTO cinematic_universes VALUES (3, 'DC Studios', 2);
INSERT INTO cinematic_universes VALUES (4, 'SpiderVerse', 3);