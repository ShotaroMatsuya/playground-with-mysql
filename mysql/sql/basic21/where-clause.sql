SELECT * FROM users WHERE name ="奥村 成美";

SELECT * FROM users WHERE birth_place<>"日本" ORDER BY age LIMIT 10;

SELECT * FROM users WHERE age<50 LIMIT 10;

SELECT * FROM users WHERE birth_day >= "2011-04-03";

SELECT * FROM users WHERE is_admin = 0;

UPDATE users SET name="奥山 成美" WHERE id =1;

SELECT * FROM users WHERE id =1;

SELECT * FROM users ORDER BY id DESC LIMIT 1;

DELETE FROM users WHERE id=200;

SELECT * FROM customers WHERE name IS NULL;

SELECT * FROM customers WHERE name IS NOT NULL;

SELECT * FROM prefectures WHERE name IS NULL; # null (使うべきではない)

SELECT * FROM prefectures WHERE name = ''; # empty

SELECT * FROM users WHERE age NOT BETWEEN 5 AND 10;

SELECT * FROM users WHERE name LIKE "村%";

SELECT * FROM users WHERE name LIKE "%a%";

SELECT * FROM prefectures WHERE name LIKE "福_県";

SELECT * FROM users WHERE age IN (12,24,36);
SELECT * FROM users WHERE birth_place NOT IN("France", "Germany", "Italy");

SELECT * FROM customers WHERE id IN (SELECT customer_id FROM receipts WHERE id<10);

SELECT * FROM users WHERE age > ALL(SELECT age FROM employees WHERE salary > 5000000);
SELECT * FROM users WHERE age > ANY(SELECT age FROM employees WHERE salary > 5000000);