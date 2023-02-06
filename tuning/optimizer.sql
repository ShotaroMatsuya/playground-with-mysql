-- check statistics info
SELECT * FROM mysql.innodb_table_stats
WHERE database_name = "mysql"
;

-- update stats info
ANALYZE TABLE prefectures;

-- displayed execution plan
EXPLAIN SELECT * FROM customers;
EXPLAIN ANALYZE SELECT * FROM customers;

-- scan type(table vs index unique vs index range)

EXPLAIN ANALYZE SELECT * FROM customers;

EXPLAIN ANALYZE SELECT * FROM customers WHERE id = 1;

EXPLAIN ANALYZE SELECT * FROM customers WHERE id < 10;



-- INDEXを付与

CREATE INDEX idx_customers_gender ON customers(gender);

-- 遅くなる(index range scan)
EXPLAIN ANALYZE SELECT * FROM customers WHERE gender = 'F';

-- ヒント句（使われないこともあるので非推奨）
EXPLAIN ANALYZE SELECT /*+ NO_INDEX(ct) */ * FROM customers AS ct WHERE ct.gender = "F";

-- INDEX削除
DROP INDEX idx_customers_gender ON customers;