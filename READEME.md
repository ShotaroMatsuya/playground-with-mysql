# mysql コマンド

### ログイン

```
mysql [-h machine] -u <user> -p [db_name]
```

### sql ファイルの実行

```
mysql -u [MySQLのユーザ名] -p db_name < /Users/user_name/Desktop/example.sql
```

例

```
mysql -u root -p world < /etc/mysql/sql/tuning-guide/world.sql
```

### mysql バージョン表示

```
mysql -V
```

# mysql 上で使うコマンド

### mysql の終了

```
mysql> exit
```

### アクティブプロセス一覧

```
mysql> show full processlist;
```

### ユーザー一覧を表示

```
mysql> select host,user from mysql.user;
```

### データベース一覧表示

```
mysql> SHOW DATABASES;
```

### 他のデータベースに接続

```
mysql> USE データベース名;
```

### データベース作成

```
mysql>create database (dbname);
```

### データベースの削除

```
mysql> drop database <データベース名>;
```

### 接続中のデータベースの情報を表示

```
mysql> SELECT database();
```

### テーブル一覧の表示

```
mysql> SHOW TABLES FROM データベース名;
```

### テーブル定義を確認

```
mysql> desc テーブル名;
```

```
mysql> SHOW COLUMNS FROM テーブル名;
```

### ファイルから実行

```
mysql> source /Users/user_name/Desktop/example.sql;
```

# バックアップとリストア

## 作成済 DB の作成用 SQL 出力(文字コードを確認)

```
mysql> show create database DB名;
```

## 作成済テーブルの作成用 SQL 出力(文字コードを確認)

```
mysql> show create table テーブル名;
```

## データベース単位のバックアップ

### 全 DB

- data & schema info

```
mysqldump -u’ユーザー名’ -p’パスワード’ –all-databases > backup.sql
```

- Only schema info

```
mysqldump -u’ユーザー名’ -p’パスワード’ -d –all-databases > backup.sql
```

### 特定 DB

- data & schema info

```
mysqldump -u’ユーザー名’ -p’パスワード’ DB名 > backup.sql
```

- Only schema info

```
mysqldump -u’ユーザー名’ -p’パスワード’ -d DB名 > backup.sql
```

### 実行時にエラーが出た場合

以下エラーが出た場合は my.cnf を修正 `「mysqldump: unknown variable ‘symbolic-links=0’」`

変更箇所

MySQL の設定ファイル「my.cnf」にて`「symbolic-links」`をコメントアウト

## リストア

- 全 DB のリストア

```
mysql -u’ユーザー名’ -p’パスワード’ < backup.sql
```

- 特定 DB のリストア

```
mysql -u’ユーザー名’ -p’パスワード’ DB名 < backup.sql
```

# 権限周り

## グローバルレベルの権限情報一覧

```

mysql> select * from information_schema.user_privileges;

```

## DB スキーマレベルの権限情報一覧

```

mysql> select * from information_schema.schema_privileges;

```

## テーブルレベルの権限情報一覧

```

mysql> select * from information_schema.table_privileges;

```

## カラムレベルの権限情報一覧

```

mysql> select * from information_schema.column_privileges;

```

## 簡単なユーザー操作方法

### ユーザー作成

```

mysql> create user ユーザー名@接続元ホスト IDENTIFIED BY パスワード;

```

全ホストへのアクセス許可は\*ではなく、%を使う

```

mysql> create user ‘ユーザー名’@’%’ IDENTIFIED BY ‘パスワード’;

```

### ユーザー削除

```

mysql> drop user ‘ユーザー名’@’接続元ホスト’;

```

### ユーザーごとの権限の確認

```

mysql> show grants for ‘ユーザー名’@’接続元ホスト’;

```

### ユーザーへの権限追加

```

GRANT 権限 ON DB 名.テーブル名 TO ユーザー名@ホスト名

```

例；アクセス許可

```bash
grant all privileges on . to ‘ユーザー名’@’ホスト名’ identified by ‘’ with grant option;
```

### ユーザーへの権限削除

```
REVOKE 権限 ON DB名.テーブル名 FROM ユーザー名@ホスト名;
```

例：

```
$ REVOKE ALL ON testdb.* FROM ‘testuser’@’testhost’;
```

_ユーザーの追加、削除、権限操作の後は必ず FLUSH PRIVILEGES で反映が必要。_

### ユーザー毎の権限情報確認

```
mysql> grant all privileges on [DB2名].[テーブル名] to ‘ユーザー名’@’接続元ホスト’ WITH GRANT OPTION;
```

簡単なやつ ↓

```
mysql> grant all on DB名.テーブル名 to ‘ユーザー名’;
```

---

# 統計情報の確認

```
mysql> show global status;
```

例：過去の最大コネクション数

```
mysql> show status like ‘%Max_used%’;
```

例：現在のコネクション数

```
mysql> show status like ‘%Threads_connected%’;
```

---

# 現在の INNODB の状態確認

```
mysql> show engine innodb status;
```

---

# パフォーマンス・チューニング

## テーブル最適化

```
mysql> analize table テーブル名;
```

---

# Migration

<!-- ## `docker network create postgres`

node アプリケーションと postgres を同じネットワーク内に配置する

## `docker-compose run --rm npm install node-pg-migrate pg`

node-pg-migrate と pg をインストール

## `postgres= create database socialnetwork`

postgres コンテナにログインして db を新たに作成

## `docker-compose run --rm npm run migrate create table comments`

comment table を作成
すると`migrations/1640106141898_table-comments.js`が生成

row SQL を記述

## `docker-compose run --rm npm run migrate up`

Migration の実行

## `docker-compose run --rm npm run migrate down`

Migration の rollback(1 回分) -->

---

# Web サーバー構築

<!-- ## `docker-compose run --rm npm init -y`

generate package.json

do this to add dependencies.

## `docker-compose run --rm npm install dedent express jest node-pg-migrate nodemon pg pg-format supertest` -->

---

# テスト実行

<!-- ## `docker-compose run --rm npm run test` -->

# スキーマの作成

<!-- ## test スキーマに users テーブルを作成

```
postgres=# CREATE SCHEMA test;
```

test スキーマに users テーブルを作成

```bash
CREATE TABLE test.users(
    id SERIAL PRIMARY KEY,
    username VARCHAR
);
```

## デフォルトスキーマの確認

```bash
SHOW search_path;
```

```bash
   search_path
-----------------
 "$user", public
(1 row)
```

## デフォルトスキーマの変更

```bash
SET search_path TO test, public;
```

## 作成済みスキーマの取得

### \dn コマンドから取得

```
postgres=# \dn
```

### システムカタログ **pg_namespace** から取得する

pg\_ で始まるスキーマは PostgreSQL のシステムが使用しているものです。また information_schema もシステムが使用するものです)。

```
select nspname, nspowner, nspacl from pg_namespace;
```

## スキーマの削除

```bash
DROP SCHEMA <スキーマ> CASCADE;
``` -->

# 外部キー制約無効化

- 無効にする
  ```
  SET FOREIGN_KEY_CHECKS = 0;
  ```
- 有効に戻す
  ```
  SET FOREIGN_KEY_CHECKS = 1;
  ```
