-- Finding 5 oldest users
SELECT *
FROM users
ORDER BY created_at
LIMIT 5;
-- Most Popular Registration Date
SELECT DATE_FORMAT(created_at, '%W') AS day,
    COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC;
SELECT DAYNAME(created_at) AS day,
    COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC;
-- Identify Inactive Users (users with no photos)
SELECT username
FROM users
    LEFT JOIN photos ON users.id = photos.user_id
WHERE photos.id IS NULL;
-- Identify most popular photo(and user who created it)
SELECT photos.id AS photo_id,
    image_url username,
    COUNT(*) AS total
FROM photos
    JOIN likes ON photos.id = likes.photo_id
    JOIN users ON photos.user_id = users.id
GROUP BY photos.id,
    username
ORDER BY total DESC
LIMIT 5;
-- Calculate avg number of photos per user
SELECT (
        SELECT COUNT(*)
        FROM photos
    ) / (
        SELECT COUNT(*)
        FROM users
    ) AS avg;
-- Five Most popular hashtags
SELECT tag_name,
    COUNT(*) AS total
FROM tags
    JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tag_name
ORDER BY total DESC
LIMIT 5;
-- Findihng Bots - users who have liked every single photo
SELECT users.username,
    COUNT(*) AS total_likes
FROM users
    JOIN likes ON users.id = likes.user_id
GROUP BY users.username
HAVING total_likes = (
        SELECT COUNT(*)
        FROM photos
    );