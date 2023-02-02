

/* 演習問題1-①：複数列の最大値(p23) */

CREATE TABLE Greatests
(string VARCHAR(32) PRIMARY KEY,
 x   INTEGER NOT NULL,
 y   INTEGER NOT NULL,
 z   INTEGER NOT NULL);

INSERT INTO Greatests VALUES('A', 1, 2, 3);
INSERT INTO Greatests VALUES('B', 5, 5, 2);
INSERT INTO Greatests VALUES('C', 4, 7, 1);
INSERT INTO Greatests VALUES('D', 3, 3, 8);


-- xとyのうち最大となる方を抽出
SELECT string,
  MAX(CASE WHEN x > y THEN x ELSE y END) AS max
FROM Greatests
GROUP BY string;



-- xとyとzの最大値
SELECT string,
  MAX(CASE WHEN x >= y THEN 
    CASE WHEN x >= z THEN x ELSE z END
  ELSE 
    CASE WHEN y >= z  THEN y ELSE z END
  END) AS max
FROM Greatests
GROUP BY string;


-- Oracle、MySQL、PostgreSQL(Build-In関数の使用例)
SELECT string, GREATEST(GREATEST(x,y), z) AS greatest
  FROM Greatests;



/* 演習問題1-②：合計と再掲を表頭に出力する行列変換(p24) */


CREATE TABLE PopTbl2
(pref_name VARCHAR(32),
 sex CHAR(1) NOT NULL,
 population INTEGER NOT NULL,
    PRIMARY KEY(pref_name, sex));

INSERT INTO PopTbl2 VALUES('徳島', '1',	60 );
INSERT INTO PopTbl2 VALUES('徳島', '2',	40 );
INSERT INTO PopTbl2 VALUES('香川', '1',	100);
INSERT INTO PopTbl2 VALUES('香川', '2',	100);
INSERT INTO PopTbl2 VALUES('愛媛', '1',	100);
INSERT INTO PopTbl2 VALUES('愛媛', '2',	50 );
INSERT INTO PopTbl2 VALUES('高知', '1',	100);
INSERT INTO PopTbl2 VALUES('高知', '2',	100);
INSERT INTO PopTbl2 VALUES('福岡', '1',	100);
INSERT INTO PopTbl2 VALUES('福岡', '2',	200);
INSERT INTO PopTbl2 VALUES('佐賀', '1',	20 );
INSERT INTO PopTbl2 VALUES('佐賀', '2',	80 );
INSERT INTO PopTbl2 VALUES('長崎', '1',	125);
INSERT INTO PopTbl2 VALUES('長崎', '2',	125);
INSERT INTO PopTbl2 VALUES('東京', '1',	250);
INSERT INTO PopTbl2 VALUES('東京', '2',	150);

--  列もちから行持ちに変換
SELECT sex,
  SUM(population) AS "全国",
  SUM(CASE WHEN pref_name = '徳島' THEN population ELSE 0 END) AS "徳島",
  SUM(CASE WHEN pref_name = '香川' THEN population ELSE 0 END) AS "香川",
  SUM(CASE WHEN pref_name = '愛媛' THEN population ELSE 0 END) AS "愛媛", 
  SUM(CASE WHEN pref_name = '高知' THEN population ELSE 0 END) AS "高知", 
  SUM(CASE WHEN pref_name IN ('徳島', '香川', '愛媛', '高知') THEN population ELSE 0 END) AS "四国"
FROM PopTbl2
GROUP BY sex;


/* 演習問題1-③：ORDER BYでソート列を作る(p25) */

SELECT string ,  
  CASE string WHEN 'B' THEN 1 
              WHEN 'A' THEN 2 
              WHEN 'D' THEN 3
              WHEN 'C' THEN 4
  ELSE NULL END AS 'num'
FROM Greatests 
ORDER BY num ;

