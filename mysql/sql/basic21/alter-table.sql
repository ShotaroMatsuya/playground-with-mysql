SELECT DATABASE();

show tables;

ALTER TABLE users 
RENAME TO users_table;

DESC users_table;

ALTER TABLE users_table 
DROP COLUMN message;

ALTER TABLE users_table
ADD post_code CHAR(8);

ALTER TABLE users_table
ADD gender CHAR(1) AFTER age;

ALTER TABLE users_table
ADD new_id INT FIRST;

ALTER TABLE users_table
DROP COLUMN new_id;

ALTER TABLE users_table
MODIFY name VARCHAR(50);

ALTER TABLE users_table
CHANGE COLUMN name 名前 VARCHAR(50);

ALTER TABLE users_table
CHANGE COLUMN gender gender CHAR(1) AFTER post_code;

DESC users_table;

ALTER TABLE users_table
DROP PRIMARY KEY;
