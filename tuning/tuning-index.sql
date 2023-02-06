EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name = "Olivia";

/*
-> Filter: (customers.first_name = 'Olivia')  (cost=49325.70 rows=48597) (actual time=0.060..224.016 rows=503 loops=1)
    -> Table scan on customers  (cost=49325.70 rows=485967) (actual time=0.056..190.044 rows=500000 loops=1)
*/

-- index作成
CREATE INDEX idx_customers_first_name ON customers(first_name);
CREATE INDEX idx_customers_age ON customers(age);

EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name = "Olivia" AND age = 42;
/*
-> Filter: ((customers.age = 42) and (customers.first_name = 'Olivia'))  (cost=35.56 rows=10) (actual time=0.244..3.495 rows=10 loops=1)
    -> Intersect rows sorted by row ID  (cost=35.56 rows=10) (actual time=0.241..3.475 rows=10 loops=1)
        -> Index range scan on customers using idx_customers_first_name over (first_name = 'Olivia')  (cost=24.90 rows=503) (actual time=0.035..0.289 rows=503 loops=1)
        -> Index range scan on customers using idx_customers_age over (age = 42)  (cost=7.15 rows=10086) (actual time=0.011..2.665 rows=10082 loops=1)

*/

EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name = "Olivia" OR age = 42;
/*
-> Filter: ((customers.first_name = 'Olivia') or (customers.age = 42))  (cost=4416.56 rows=10579) (actual time=0.065..24.866 rows=10579 loops=1)
    -> Deduplicate rows sorted by row ID  (cost=4416.56 rows=10579) (actual time=0.063..23.278 rows=10579 loops=1)
        -> Index range scan on customers using idx_customers_first_name over (first_name = 'Olivia')  (cost=75.21 rows=503) (actual time=0.038..0.260 rows=503 loops=1)
        -> Index range scan on customers using idx_customers_age over (age = 42)  (cost=1015.76 rows=10086) (actual time=0.012..3.029 rows=10086 loops=1)

*/

-- 複合index(first_name, age)

DROP INDEX idx_customers_first_name ON customers;
DROP INDEX idx_customers_age ON customers;

CREATE INDEX idx_customers_first_name_age ON customers(first_name, age);

-- ageだけはフルスキャン
EXPLAIN ANALYZE SELECT * FROM customers WHERE age=51;
/*
-> Filter: (customers.age = 51)  (cost=49325.70 rows=48597) (actual time=0.050..210.148 rows=10175 loops=1)
    -> Table scan on customers  (cost=49325.70 rows=485967) (actual time=0.045..189.971 rows=500000 loops=1)

*/
-- orもフルスキャン
EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name = "Olivia" OR age = 42;

/*
-> Filter: ((customers.first_name = 'Olivia') or (customers.age = 42))  (cost=49325.70 rows=49249) (actual time=0.058..242.839 rows=10579 loops=1)
    -> Table scan on customers  (cost=49325.70 rows=485967) (actual time=0.054..193.159 rows=500000 loops=1)
*/

-- ORDER BY, GROUP BYでindex
DROP INDEX idx_customers_first_name_age ON customers;

-- indexなし
EXPLAIN ANALYZE SELECT * FROM customers ORDER BY first_name;
/*
-> Sort: customers.first_name  (cost=49325.70 rows=485967) (actual time=854.666..916.979 rows=500000 loops=1)
    -> Table scan on customers  (cost=49325.70 rows=485967) (actual time=0.053..208.548 rows=500000 loops=1)
*/

-- idnexをつける
CREATE INDEX idx_customers_first_name ON customers(first_name);

-- しかしindex使われない（遅い）
EXPLAIN ANALYZE SELECT * FROM customers ORDER BY first_name;
/*
-> Sort: customers.first_name  (cost=49325.70 rows=485967) (actual time=621.031..675.495 rows=500000 loops=1)
    -> Table scan on customers  (cost=49325.70 rows=485967) (actual time=0.089..199.274 rows=500000 loops=1)
*/

-- 一位のカラムにたいしてORDER BYかけるとindex使われる（早い）
EXPLAIN ANALYZE SELECT * FROM customers ORDER BY id;

/*
-> Index scan on customers using PRIMARY  (cost=49325.70 rows=485967) (actual time=0.101..193.119 rows=500000 loops=1)
*/

-- GROUP BYでも同じことを行う(早い)
EXPLAIN ANALYZE SELECT first_name, COUNT(*) FROM customers GROUP BY first_name;
/*
-> Group aggregate: count(0)  (cost=97922.40 rows=677) (actual time=0.543..164.522 rows=690 loops=1)
    -> Covering index scan on customers using idx_customers_first_name  (cost=49325.70 rows=485967) (actual time=0.087..112.468 rows=500000 loops=1)
*/

-- ageにindexを貼ってGROUP BY
CREATE INDEX idx_customers_age ON customers(age);
EXPLAIN ANALYZE SELECT age, COUNT(*) FROM customers GROUP BY age;
/*
-> Group aggregate: count(0)  (cost=97922.40 rows=45) (actual time=2.539..99.770 rows=49 loops=1)
    -> Covering index scan on customers using idx_customers_age  (cost=49325.70 rows=485967) (actual time=0.067..80.212 rows=500000 loops=1)
*/

DROP INDEX idx_customers_first_name ON customers;
DROP INDEX idx_customers_age ON customers;

-- 複合indexでgroup by

CREATE INDEX idx_customers_first_name_age ON customers(first_name, age);

EXPLAIN ANALYZE SELECT first_name, age, COUNT(*) FROM customers GROUP BY first_name, age;

/*
-> Group aggregate: count(0)  (cost=97922.40 rows=34803) (actual time=0.098..161.298 rows=32369 loops=1)
    -> Covering index scan on customers using idx_customers_first_name_age  (cost=49325.70 rows=485967) (actual time=0.085..101.456 rows=500000 loops=1)
*/

DROP INDEX idx_customers_first_name_age ON customers;

-- 外部キーにindex
EXPLAIN ANALYZE SELECT * FROM prefectures P
INNER JOIN customers C
ON P.prefecture_code = C.prefecture_code AND P.name = "北海道";

/*
-> Nested loop inner join  (cost=219414.15 rows=48597) (actual time=1.292..822.066 rows=12321 loops=1)
    -> Filter: (C.prefecture_code is not null)  (cost=49325.70 rows=485967) (actual time=0.053..289.958 rows=500000 loops=1)
        -> Table scan on C  (cost=49325.70 rows=485967) (actual time=0.052..258.538 rows=500000 loops=1)
    -> Filter: (P.`name` = '北海道')  (cost=0.25 rows=0.1) (actual time=0.001..0.001 rows=0 loops=500000)
        -> Single-row index lookup on P using PRIMARY (prefecture_code=C.prefecture_code)  (cost=0.25 rows=1) (actual time=0.001..0.001 rows=1 loops=500000)
*/

-- Cへのtable scanがボトルネックなのでindex追加
CREATE INDEX idx_customers_prefecture_code ON customers(prefecture_code);

/*
-> Nested loop inner join  (cost=15722.05 rows=54382) (actual time=1.412..29.867 rows=12321 loops=1)
    -> Filter: (P.`name` = '北海道')  (cost=4.95 rows=5) (actual time=1.211..1.224 rows=1 loops=1)
        -> Table scan on P  (cost=4.95 rows=47) (actual time=1.203..1.209 rows=47 loops=1)
    -> Index lookup on C using idx_customers_prefecture_code (prefecture_code=P.prefecture_code)  (cost=2433.18 rows=11571) (actual time=0.199..28.158 rows=12321 loops=1)
  北海道に該当するprefecture tableを取得し、そのテーブルをindexを使ってjoinしているので早くなった
*/

DROP INDEX idx_customers_prefecture_code ON customers;


-- MAXとMIN(極地関数)にはindexを用いる
EXPLAIN ANALYZE SELECT MAX(age), MIN(age) FROM customers;

/*
-> Aggregate: max(customers.age), min(customers.age)  (cost=97922.40 rows=1) (actual time=124.253..124.253 rows=1 loops=1)
    -> Table scan on customers  (cost=49325.70 rows=485967) (actual time=0.035..87.511 rows=500000 loops=1)
*/

CREATE INDEX idx_customers_age ON customers(age);

/*
-> Rows fetched before execution  (cost=0.00..0.00 rows=1) (actual time=0.000..0.000 rows=1 loops=1)
*/

-- DISTINCTの代わりにEXISTSを利用
EXPLAIN ANALYZE 
SELECT DISTINCT name FROM prefectures P
INNER JOIN customers C
ON P.prefecture_code = C.prefecture_code;

/*
-> Table scan on <temporary>  (cost=268010.86..274087.94 rows=485967) (actual time=716.776..716.778 rows=41 loops=1)
    -> Temporary table with deduplication  (cost=268010.85..268010.85 rows=485967) (actual time=716.770..716.770 rows=41 loops=1)
        -> Nested loop inner join  (cost=219414.15 rows=485967) (actual time=0.061..546.616 rows=500000 loops=1)
            -> Filter: (C.prefecture_code is not null)  (cost=49325.70 rows=485967) (actual time=0.043..150.280 rows=500000 loops=1)
                -> Table scan on C  (cost=49325.70 rows=485967) (actual time=0.042..124.442 rows=500000 loops=1)
            -> Single-row index lookup on P using PRIMARY (prefecture_code=C.prefecture_code)  (cost=0.25 rows=1) (actual time=0.001..0.001 rows=1 loops=500000)
*/

-- EXISTSに置き換え(JOIN→相関サブクエリ)
EXPLAIN ANALYZE
SELECT name FROM prefectures P
WHERE EXISTS (
  SELECT 'x' FROM customers C WHERE C.prefecture_code = P.prefecture_code
);

/*
-> Nested loop inner join  (cost=2284054.55 rows=22840449) (actual time=192.216..192.239 rows=41 loops=1)
    -> Table scan on P  (cost=4.95 rows=47) (actual time=0.031..0.036 rows=47 loops=1)
    -> Single-row index lookup on <subquery2> using <auto_distinct_key> (prefecture_code=P.prefecture_code)  (cost=97922.40..97922.40 rows=1) (actual time=4.089..4.089 rows=1 loops=47)
        -> Materialize with deduplication  (cost=97922.40..97922.40 rows=485967) (actual time=192.176..192.176 rows=41 loops=1)
            -> Filter: (C.prefecture_code is not null)  (cost=49325.70 rows=485967) (actual time=0.022..118.740 rows=500000 loops=1)
                -> Table scan on C  (cost=49325.70 rows=485967) (actual time=0.022..95.575 rows=500000 loops=1)
*/

-- UNIONをUNION ALLにする
EXPLAIN ANALYZE
SELECT * FROM customers WHERE age < 30
UNION
SELECT * FROM customers WHERE age > 50;

/*
-> Table scan on <union temporary>  (cost=139145.51..144209.75 rows=404941) (actual time=2740.337..2863.102 rows=286055 loops=1)
    -> Union materialize with deduplication  (cost=139145.50..139145.50 rows=404941) (actual time=2739.539..2739.539 rows=286055 loops=1)
        -> Filter: (customers.age < 30)  (cost=49325.70 rows=161958) (actual time=0.070..242.820 rows=82096 loops=1)
            -> Table scan on customers  (cost=49325.70 rows=485967) (actual time=0.066..217.629 rows=500000 loops=1)
        -> Filter: (customers.age > 50)  (cost=49325.70 rows=242983) (actual time=0.103..285.677 rows=203959 loops=1)
            -> Table scan on customers  (cost=49325.70 rows=485967) (actual time=0.101..249.296 rows=500000 loops=1)
*/

-- UNION ALL(重複がない場合はこっちを使うべし)
EXPLAIN ANALYZE
SELECT * FROM customers WHERE age < 30
UNION ALL
SELECT * FROM customers WHERE age > 50;

/*
-> Append  (actual time=2.830..869.601 rows=286055 loops=1)
    -> Stream results  (cost=50317.58 rows=161958) (actual time=2.830..552.434 rows=82096 loops=1)
        -> Filter: (customers.age < 30)  (cost=50317.58 rows=161958) (actual time=2.806..521.115 rows=82096 loops=1)
            -> Table scan on customers  (cost=50317.58 rows=485967) (actual time=2.800..499.530 rows=500000 loops=1)
    -> Stream results  (cost=50317.58 rows=242983) (actual time=0.097..305.378 rows=203959 loops=1)
        -> Filter: (customers.age > 50)  (cost=50317.58 rows=242983) (actual time=0.093..230.631 rows=203959 loops=1)
            -> Table scan on customers  (cost=50317.58 rows=485967) (actual time=0.091..205.135 rows=500000 loops=1)
*/