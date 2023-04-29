DROP TABLE table1;
DROP TABLE table2;


CREATE TABLE table1 (
    id NUMBER NOT NULL PRIMARY KEY,
    col1 NUMBER NOT NULL,
    col2 NUMBER NOT NULL
);

CREATE TABLE table2 (
    id NUMBER NOT NULL PRIMARY KEY,
    col1 NUMBER NOT NULL,
    col2 NUMBER NOT NULL
);

INSERT INTO table1 (id, col1, col2) VALUES (1, 1, 1);
INSERT INTO table1 (id, col1, col2) VALUES (2, 2, 2);
INSERT INTO table1 (id, col1, col2) VALUES (3, 3, 3);
INSERT INTO table1 (id, col1, col2) VALUES (4, 4, 4);


INSERT INTO table2 (id, col1, col2) VALUES (1, 1, 1);
INSERT INTO table2 (id, col1, col2) VALUES (2, 2, 2);
INSERT INTO table2 (id, col1, col2) VALUES (3, 3, 3);
INSERT INTO table2 (id, col1, col2) VALUES (4, 4, 4);