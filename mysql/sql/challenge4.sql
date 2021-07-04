CREATE TABLE inventory(
    item_name VARCHAR(50) NOT NULL,
    price DECIMAL(8, 2) NOT NULL,
    quantity INT
);
-- price is always < 1,000,000 == 999,999.99
-- print out current time
SELECT CURRENT_TIME;
SELECT CURTIME();
-- print out current date(but not time)
SELECT CURRENT_DATE;
SELECT CURDATE();
-- print out current day of the week(The Number)
SELECT DATE_FORMAT(NOW(), '%w');
-- %w (sunday:0)
SELECT DAYOFWEEK(CURDATE());
-- DAYOFWEEK (saturday:0)
-- print out current day of the week (The Day Name)
SELECT DATE_FORMAT(NOW(), '%W');
SELECT DAYNAME(CURDATE());
-- print out the current day and time using this format(mm/dd/yyyy)
SELECT DATE_FORMAT(NOW(), '%m/%d/%Y');
-- print out current day and time using this format(Jauary 2nd at 3:15 ,April 1st at 10:18)
SELECT DATE_FORMAT(NOW(), '%M %D at %h:%i');
CREATE TABLE tweets (
    content VARCHAR(255) NOT NULL,
    username VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);