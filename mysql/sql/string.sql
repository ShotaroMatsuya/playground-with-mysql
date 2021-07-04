-- SELECT CONCAT(SUBSTRING(title, 1, 10), '...') AS 'short title'
-- FROM books;
SELECT SUBSTRING(REPLACE(title, 'e', '3'), 1, 10)
FROM books;
SELECT CONCAT(author_fname, REVERSE(author_fname))
FROM books;
SELECT CONCAT(
        author_lname,
        ' is ',
        CHAR_LENGTH(author_lname),
        ' characters long'
    )
FROM books;
SELECT CONCAT('MY FAVORITE BOOK IS ', LOWER(title))
FROM books;