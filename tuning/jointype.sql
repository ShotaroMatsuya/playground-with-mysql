SELECT * FROM customers C 
INNER JOIN prefectures P
ON C.prefecture_code = P.prefecture_code;

-- NLJ
-- 1. outer > inner is best case
-- 2. index on inner is best case

EXPLAIN ANALYZE SELECT * FROM customers C 
INNER JOIN prefectures P
ON C.prefecture_code = P.prefecture_code;



-- Hash Join
-- 1. need large amount of memory for hash table
-- 2. only used in '=' comparison
-- 3. no need for index
EXPLAIN ANALYZE /*+ NO_INDEX(pr) */ 
SELECT * FROM customers ct
INNER JOIN prefectures pr
ON ct.prefecture_code = pr.prefecture_code;
--SMJ
-- 1. no limitation of comparison operator (incl <, <=, >=, >)
-- 2. (step 1: sort by targeted column
--    (step 2: merge sorted tables with comparison execution

