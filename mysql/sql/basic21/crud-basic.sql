SELECT DATABASE();

CREATE TABLE people(
	id INT PRIMARY KEY,
	name VARCHAR(50),
	birth_day DATE DEFAULT "1900-01-01"
);

INSERT INTO people VALUES(1, "Taro", "2001-01-01");

SELECT * FROM people;

INSERT INTO people(id, name) VALUES(2, "Jiro");

INSERT INTO people(id, name) VALUES(3, 'Saburo');

INSERT INTO people(id, name, birth_day) VALUES(4, 'john''s son', '2021-01-01');

INSERT INTO people(id,name, birth_day) VALUES(5, "john""s father", '1950-01-01');

SELECT * FROM people;

SELECT * FROM people WHERE id <= 3;

UPDATE people SET birth_day="1900-01-01", name="";

UPDATE people SET name="Jiro", birth_day="2000-01-01" WHERE id > 4;

DELETE FROM people WHERE id > 4;
DELETE FROM people WHERE id < 2;

ALTER TABLE people ADD age INT AFTER name;

INSERT INTO people VALUES(1, "John", 18, "2003-01-01");
INSERT INTO people VALUES(2, "Alice", 12, "2001-01-01");
INSERT INTO people VALUES(3, "Oliver", 23, "2012-01-01");
INSERT INTO people VALUES(4, "Robelt", 45, "2000-01-01");
INSERT INTO people VALUES(5, "Steve", 33, "2002-01-01");
INSERT INTO people VALUES(6, "Tsuyoshi", 11, "2005-01-01");


SELECT * FROM people ORDER BY birth_day DESC , name DESC, age ASC;

SELECT DISTINCT birth_day FROM people ORDER BY birth_day;

SELECT DISTINCT name, birth_day FROM people;

SELECT id, name, age FROM people LIMIT 3;

SELECT * FROM people LIMIT 3,2;
SELECT * FROM people LIMIT 3 OFFSET 2;

TRUNCATE people;

SELECT * FROM people;

DESC people;