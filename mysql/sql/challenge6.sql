CREATE TABLE students(
    id INT AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    PRIMARY KEY(id)
);
CREATE TABLE papers (
    id INT AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    grade INT NOT NULL,
    student_id INT,
    PRIMARY KEY (id),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);
INSERT INTO students (first_name)
VALUES('Caleb'),
    ('Samantha'),
    ('Raj'),
    ('Carlos'),
    ('Lisa');
INSERT INTO papers (student_id, title, grade)
VALUES (1, 'My First Book Report', 60),
    (1, 'My Second Book Report', 75),
    (2, 'Russian lit Through The Ages', 94),
    (2, 'De Montaigne and The Art of The Essay', 98),
    (4, 'Borges and Magical Realism', 89);
SELECT first_name,
    title,
    grade
FROM students
    INNER JOIN papers ON students.id = papers.student_id
ORDER BY papers.grade DESC;
-- same result 
SELECT first_name,
    title,
    grade
FROM students
    RIGHT JOIN papers ON students.id = papers.student_id
ORDER BY papers.grade DESC;
SELECT first_name,
    title,
    grade
FROM students
    LEFT JOIN papers ON students.id = papers.student_id;
SELECT first_name,
    IFNULL(title, 'MISSING') AS title,
    IFNULL(grade, 0) AS grade
FROM students
    LEFT JOIN papers ON students.id = papers.student_id;
SELECT first_name,
    IFNULL(AVG(grade), 0) AS average
FROM students
    LEFT JOIN papers ON students.id = papers.student_id
GROUP BY first_name
ORDER BY average DESC;
SELECT first_name,
    IFNULL(AVG(grade), 0) AS average,
    CASE
        WHEN AVG(grade) IS NULL THEN 'FAILING'
        WHEN AVG(grade) >= 75 THEN 'PASSING'
        ELSE 'FAILING'
    END AS passing_status
FROM students
    LEFT JOIN papers ON students.id = papers.student_id
GROUP BY first_name
ORDER BY average DESC;