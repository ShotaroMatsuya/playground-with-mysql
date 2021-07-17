CREATE TABLE customers(
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100)
);
CREATE TABLE orders(
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    amount DECIMAL(8, 2),
    customer_id INT,
    FOREIGN KEY(customer_id) REFERENCES customers(id)
);
INSERT INTO customers(first_name, last_name, email)
VALUES ('Boy', 'George', 'george@gmail.com'),
    ('George', 'Michael', 'gm@gmail.com'),
    ('David', 'Bowie', 'david@gmail.com'),
    ('Blue', 'Steele', 'blue@gmail.com'),
    ('Bette', 'Davis', 'bette@aol.com');
INSERT INTO orders(order_date, amount, customer_id)
VALUES('2016/02/10', 99.99, 1),
    ('2017/11/11', 35.50, 1),
    ('2014/12/12', 800.67, 2),
    ('2015/01/03', 12.50, 2),
    ('1999/04/11', 450.25, 5);
INSERT INTO orders(order_date, amount, customer_id)
VALUES('2014/02/02', 45.67, 98);
SELECT *
FROM orders
WHERE customer_id = (
        SELECT id
        FROM customers
        WHERE last_name = 'George'
    );
-- closs joins
SELECT *
FROM customers,
    orders;
-- IMPLICIT INNER JOIN
SELECT *
FROM customers,
    orders
WHERE customers.id = orders.customer_id;
-- EXPLICIT INNER JOIN
SELECT *
FROM customers
    JOIN orders ON customers.id = orders.customer_id;
-- group by に含まれていないカラムがselectにある場合はエラーになる
-- SELECT first_name,
--     last_name,
--     SUM(amount) AS total_spent
-- FROM customers
--     JOIN orders ON customers.id = orders.customer_id
-- GROUP BY customers.id
-- ORDER BY total_spent DESC;
-- LEFT JOIN 
SELECT *
FROM customers
    LEFT JOIN orders ON customers.id = orders.customer_id;
SELECT first_name,
    last_name,
    SUM(amount)
FROM customers
    LEFT JOIN orders ON customers.id = orders.customer_id
GROUP BY customers.id;
SELECT first_name,
    last_name,
    IFNULL(SUM(amount), 0) AS total_spent
FROM customers
    LEFT JOIN orders ON customers.id = orders.customer_id
GROUP BY customers.id
ORDER BY total_spent;
CREATE TABLE customers(
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100)
);
CREATE TABLE orders(
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    amount DECIMAL(8, 2),
    customer_id INT
);
INSERT INTO customers(first_name, last_name, email)
VALUES ('Boy', 'George', 'george@gmail.com'),
    ('George', 'Michael', 'gm@gmail.com'),
    ('David', 'Bowie', 'david@gmail.com'),
    ('Blue', 'Steele', 'blue@gmail.com'),
    ('Bette', 'Davis', 'bette@aol.com');
INSERT INTO orders(order_date, amount, customer_id)
VALUES('2016/02/10', 99.99, 1),
    ('2017/11/11', 35.50, 1),
    ('2014/12/12', 800.67, 2),
    ('2015/01/03', 12.50, 2),
    ('1999/04/11', 450.25, 5);
INSERT INTO orders(order_date, amount, customer_id)
VALUES('2014/02/02', 45.67, 98);
INSERT INTO orders (order_date, amount, customer_id)
VALUES ('2017/11/05', 23.45, 45),
    (CURDATE(), 777.77, 109);
-- INNERJOIN
SELECT first_name,
    last_name,
    order_date,
    amount
FROM customers
    JOIN orders ON customers.id = orders.customer_id;
-- LEFT JOIN
SELECT first_name,
    last_name,
    order_date,
    amount
FROM customers
    LEFT JOIN orders ON customers.id = orders.customer_id;
-- RIGHT JOIN
SELECT IFNULL(first_name, 'MISSING') AS first,
    IFNULL(last_name, 'MISSING') AS last,
    SUM(amount)
FROM customers
    RIGHT JOIN orders ON customers.id = orders.customer_id
GROUP BY customer_id
ORDER BY first_name;
SELECT IFNULL(first_name, 'MISSING') AS first,
    IFNULL(last_name, 'MISSING') AS last,
    SUM(amount)
FROM customers
    RIGHT JOIN orders ON customers.id = orders.customer_id
GROUP BY first_name,
    last_name
ORDER BY first_name;
-- ON DELETE CASCADE
CREATE TABLE customers(
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100)
);
-- DELETE CASCADEを指定するとcustomerを削除したときにそれに従属するordersのrecordも一緒に削除してくれる
CREATE TABLE orders(
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    amount DECIMAL(8, 2),
    customer_id INT,
    FOREIGN KEY(customer_id) REFERENCES customers(id) ON DELETE CASCADE
);
INSERT INTO customers(first_name, last_name, email)
VALUES ('Boy', 'George', 'george@gmail.com'),
    ('George', 'Michael', 'gm@gmail.com'),
    ('David', 'Bowie', 'david@gmail.com'),
    ('Blue', 'Steele', 'blue@gmail.com'),
    ('Bette', 'Davis', 'bette@aol.com');
INSERT INTO orders(order_date, amount, customer_id)
VALUES('2016/02/10', 99.99, 1),
    ('2017/11/11', 35.50, 1),
    ('2014/12/12', 800.67, 2),
    ('2015/01/03', 12.50, 2),
    ('1999/04/11', 450.25, 5);