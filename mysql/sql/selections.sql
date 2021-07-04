SELECT DISTINCT author_lname
FROM books;
SELECT CONCAT(author_fname, ' ', author_lname)
FROM books;
SELECT DISTINCT author_fname,
    author_lname
FROM books;
SELECT title,
    author_fname,
    author_lname
FROM books
ORDER BY 2;
SELECT author_fname,
    author_lname
FROM books
ORDER BY author_lname,
    author_fname;
SELECT title
FROM books
LIMIT 3;
SELECT title,
    released_year
FROM books
ORDER BY released_year DESC
LIMIT 14;
SELECT title,
    released_year
FROM books
ORDER BY released_year DESC
LIMIT 0, 5;
SELECT author_fname
FROM books
WHERE author_fname LIKE '%da%';
SELECT stock_quantity
FROM books
WHERE stock_quantity LIKE '____';
SELECT title
FROM books
WHERE title LIKE '%\%%';
SELECT title
FROM books
WHERE title LIKE '%\_%';