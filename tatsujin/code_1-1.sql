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


/* 条件を分岐させたUPDATE */
CREATE TABLE Salaries
(name VARCHAR(32) NOT NULL,
salary INTEGER NOT NULL);

INSERT INTO Salaries VALUES('相田', 300000);
INSERT INTO Salaries VALUES('神埼', 270000);
INSERT INTO Salaries VALUES('木村', 220000);
INSERT INTO Salaries VALUES('斎藤', 290000);
-- 1.現在の給料が30万以上の社員は、10%の減給
-- 2.現在の給料が25万以上の社員は28マン未満の社員は、20%の昇給 (p13)

UPDATE Salaries
  SET salary = 
    CASE WHEN salary >= 300000 THEN salary * 0.9
         WHEN salary >= 250000 AND salary < 280000 THEN salary * 1.2
    ELSE salary END;

/* 条件を分岐させたUPDATE2 */
CREATE TABLE SomeTable
(p_key CHAR(1) PRIMARY KEY,
 col_1 INTEGER NOT NULL, 
 col_2 CHAR(2) NOT NULL);

INSERT INTO SomeTable VALUES('a', 1, 'あ');
INSERT INTO SomeTable VALUES('b', 2, 'い');
INSERT INTO SomeTable VALUES('c', 3, 'う');

-- 主Key aとbを入れ替える
UPDATE SomeTable
  SET p_key = 
    CASE WHEN p_key = 'a' THEN 'b'
         WHEN p_key = 'b' THEN 'a'
    ELSE p_key END
WHERE p_key IN ('a', 'b'); -- mysqlではエラーになってしまう(主Keyじゃなければ有用なクエリ)

/* テーブル同士のマッチング */
CREATE TABLE CourseMaster
(course_id   INTEGER PRIMARY KEY,
 course_name VARCHAR(32) NOT NULL);

INSERT INTO CourseMaster VALUES(1, '経理入門');
INSERT INTO CourseMaster VALUES(2, '財務知識');
INSERT INTO CourseMaster VALUES(3, '簿記検定');
INSERT INTO CourseMaster VALUES(4, '税理士');

CREATE TABLE OpenCourses
(month       INTEGER ,
 course_id   INTEGER ,
    PRIMARY KEY(month, course_id));

INSERT INTO OpenCourses VALUES(201806, 1);
INSERT INTO OpenCourses VALUES(201806, 3);
INSERT INTO OpenCourses VALUES(201806, 4);
INSERT INTO OpenCourses VALUES(201807, 4);
INSERT INTO OpenCourses VALUES(201808, 2);
INSERT INTO OpenCourses VALUES(201808, 4);

--各月の開口状況をひと目で分かるクロス表を作成 (p16)
SELECT CM.course_name,
  CASE WHEN EXISTS (SELECT 'x' FROM OpenCourses OC WHERE OC.course_id = CM.course_id AND OC.month = 201806) THEN '○' ELSE '✗' END AS "6月",
  CASE WHEN EXISTS (SELECT 'x' FROM OpenCourses OC WHERE OC.course_id = CM.course_id AND OC.month = 201807) THEN '○' ELSE '✗' END AS "7月",
  CASE WHEN EXISTS (SELECT 'x' FROM OpenCourses OC WHERE OC.course_id = CM.course_id AND OC.month = 201808) THEN '○' ELSE '✗' END AS "8月"
FROM CourseMaster CM;

