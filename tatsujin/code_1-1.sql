/* 既存のコード体系を新しい体系に変換して集計 */
CREATE TABLE PopTbl
(pref_name VARCHAR(32) PRIMARY KEY,
 population INTEGER NOT NULL);

INSERT INTO PopTbl VALUES('徳島', 100);
INSERT INTO PopTbl VALUES('香川', 200);
INSERT INTO PopTbl VALUES('愛媛', 150);
INSERT INTO PopTbl VALUES('高知', 200);
INSERT INTO PopTbl VALUES('福岡', 300);
INSERT INTO PopTbl VALUES('佐賀', 100);
INSERT INTO PopTbl VALUES('長崎', 200);
INSERT INTO PopTbl VALUES('東京', 400);
INSERT INTO PopTbl VALUES('群馬', 50);


-- 地方単位で人口を集計(p5)

SELECT 
  CASE WHEN pref_name = '徳島' THEN '四国'
       WHEN pref_name = '香川' THEN '四国'
       WHEN pref_name = '愛媛' THEN '四国'
       WHEN pref_name = '高知' THEN '四国'
       WHEN pref_name = '福岡' THEN '九州'
       WHEN pref_name = '佐賀' THEN '九州'
       WHEN pref_name = '長崎' THEN '九州'
       ELSE 'その他' END AS district,
  SUM(population)
FROM PopTbl
GROUP BY district
;


/* 異なる条件の集計を1つのSQLで行う */
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

-- 県ごとの男女人口を集計（p8）
SELECT
  pref_name,
  MAX(CASE WHEN sex = 1 THEN population ELSE 0 END) AS "男",
  MAX(CASE WHEN sex = 2 THEN population ELSE 0 END) AS "女"
FROM PopTbl2
GROUP BY pref_name;

