TRUNCATE TABLE movies;
TRUNCATE TABLE cinematic_universes;
TRUNCATE TABLE entertainment_corporations;


INSERT INTO entertainment_corporations VALUES (1, 'Disney', 'Robert Iger');
INSERT INTO entertainment_corporations VALUES (2, 'Warner Bros.', 'David Zaslav');
INSERT INTO entertainment_corporations VALUES (3, 'Sony Pictures', 'Tony Vinciquerra');


INSERT INTO cinematic_universes VALUES (1, 'Marvel Cinematic Universe', 1);
INSERT INTO cinematic_universes VALUES (2, 'DC Extended Universe', 2);
INSERT INTO cinematic_universes VALUES (3, 'DC Studios', 2);
INSERT INTO cinematic_universes VALUES (4, 'SpiderVerse', 3);


INSERT INTO movies VALUES (1, 'Avengers: Infinity War', TO_DATE('2018/05/03', 'yyyy/mm/dd'), 1);
INSERT INTO movies VALUES (2, 'Avengers: End Game', TO_DATE('2019/04/29', 'yyyy/mm/dd'), 1);
INSERT INTO movies VALUES (3, 'Captain America: Civil War', TO_DATE('2016/05/05', 'yyyy/mm/dd'), 1);
INSERT INTO movies VALUES (4, 'Batman vs Superman', TO_DATE('2016/03/24', 'yyyy/mm/dd'), 2);
INSERT INTO movies VALUES (5, 'Justice League', TO_DATE('2017/11/17', 'yyyy/mm/dd'), 2);
INSERT INTO movies VALUES (6, 'Spider-Man: Into the Spider-Verse', TO_DATE('2018/12/14', 'yyyy/mm/dd'), 3);

DELETE FROM movies;