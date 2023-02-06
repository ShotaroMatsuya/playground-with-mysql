-- 無駄なサブクエリをへらす

DROP INDEX idx_customers_age ON customers;

-- SELECT 内でのサブクエリを減らす

EXPLAIN ANALYZE 
SELECT *, (
  SELECT name FROM prefectures P WHERE P.prefecture_code = C.prefecture_code
)
FROM customers C;

/*
-> Table scan on C  (cost=49325.70 rows=485967) (actual time=0.054..203.681 rows=500000 loops=1)
-> Select #2 (subquery in projection; dependent)
    -> Single-row index lookup on P using PRIMARY (prefecture_code=C.prefecture_code)  (cost=1.10 rows=1) (actual time=0.001..0.001 rows=1 loops=500000)
*/

-- サブクエリをLEFT JOINに置き換える

EXPLAIN ANALYZE
SELECT 
*, P.name
FROM customers C
LEFT JOIN prefectures P
ON C.prefecture_code = P.prefecture_code;

/*
-> Nested loop left join  (cost=219414.15 rows=485967) (actual time=0.065..580.786 rows=500000 loops=1)
    -> Table scan on C  (cost=49325.70 rows=485967) (actual time=0.051..204.414 rows=500000 loops=1)
    -> Single-row index lookup on P using PRIMARY (prefecture_code=C.prefecture_code)  (cost=0.25 rows=1) (actual time=0.001..0.001 rows=1 loops=500000)
*/


-- WINDOW関数にする
-- 2016年度、2016年度の日ごとの集計カラムを追加
-- EXPLAIN ANALYZE 
SELECT sales_history.*, sales_summary.sales_daily_amount
FROM sales_history
LEFT JOIN
(SELECT sales_day, SUM(sales_amount)  AS sales_daily_amount
FROM sales_history 
WHERE sales_day BETWEEN '2016-01-01' AND '2016-12-31' 
GROUP BY sales_day) AS sales_summary
ON sales_history.sales_day = sales_summary.sales_day
WHERE sales_history.sales_day BETWEEN '2016-01-01' AND '2016-12-31' 
;

/*
-> Nested loop left join  (cost=945710.88 rows=0) (actual time=1417.619..2925.739 rows=312844 loops=1)
    -> Filter: (sales_history.sales_day between '2016-01-01' and '2016-12-31')  (cost=252775.17 rows=277172) (actual time=0.086..1274.411 rows=312844 loops=1)
        -> Table scan on sales_history  (cost=252775.17 rows=2494800) (actual time=0.083..673.304 rows=2500000 loops=1)
    -> Index lookup on sales_summary using <auto_key0> (sales_day=sales_history.sales_day)  (cost=0.25..2.50 rows=10) (actual time=0.005..0.005 rows=1 loops=312844)
        -> Materialize  (cost=0.00..0.00 rows=0) (actual time=1417.526..1417.526 rows=336 loops=1)
            -> Table scan on <temporary>  (actual time=1417.373..1417.395 rows=336 loops=1)
                -> Aggregate using temporary table  (actual time=1417.371..1417.371 rows=336 loops=1)
                    -> Filter: (sales_history.sales_day between '2016-01-01' and '2016-12-31')  (cost=252775.17 rows=277172) (actual time=0.017..1249.307 rows=312844 loops=1)
                        -> Table scan on sales_history  (cost=252775.17 rows=2494800) (actual time=0.016..609.885 rows=2500000 loops=1)
*/

-- WINDOW関数に置き換え
EXPLAIN ANALYZE
SELECT S.*, SUM(S.sales_amount) OVER(PARTITION BY S.sales_day)
FROM sales_history S
WHERE S.sales_day BETWEEN '2016-01-01' AND '2016-12-31' 
;
/*
-> Window aggregate with buffering: sum(sales_history.sales_amount) OVER (PARTITION BY S.sales_day )   (actual time=1416.371..1680.584 rows=312844 loops=1)
    -> Sort: S.sales_day  (cost=252493.68 rows=2494800) (actual time=1415.748..1439.342 rows=312844 loops=1)
        -> Filter: (S.sales_day between '2016-01-01' and '2016-12-31')  (cost=252493.68 rows=2494800) (actual time=0.086..1300.004 rows=312844 loops=1)
            -> Table scan on S  (cost=252493.68 rows=2494800) (actual time=0.084..699.466 rows=2500000 loops=1)
*/

-- IN vs EXISTS(ループされる側がouterとinnerで逆になる)
-- INのユースケース(outerのテーブル行数 > innerのテーブル行数)
-- EXISTSのユースケース(outerのテーブル行数 < innerのテーブル行数)

CREATE INDEX idx_customers_prefecture_code ON customers(prefecture_code);

-- prefectures < customers 
-- EXISTSの場合(good)
EXPLAIN ANALYZE 
SELECT * FROM prefectures P
WHERE EXISTS (SELECT 'x' FROM customers C WHERE P.prefecture_code = C.prefecture_code);

/*
-> Nested loop semijoin  (cost=59475.36 rows=585653) (actual time=0.091..1.037 rows=41 loops=1)
    -> Table scan on P  (cost=5.70 rows=47) (actual time=0.055..0.063 rows=47 loops=1)
    -> Covering index lookup on C using idx_customers_prefecture_code (prefecture_code=P.prefecture_code)  (cost=570135.32 rows=12461) (actual time=0.021..0.021 rows=1 loops=47)
*/