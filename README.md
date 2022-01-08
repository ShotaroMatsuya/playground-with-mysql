# Require

mysql v8.0.27

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

# 外部キー制約無効化

- 無効にする
  ```sql
  SET FOREIGN_KEY_CHECKS = 0;
  ```
- 有効に戻す
  ```sql
  SET FOREIGN_KEY_CHECKS = 1;
  ```

# Spotting Query Problems

1. time consuming query トップ 10

- `use performance_shema;`

- `select \* from events_statements_summary_by_digest order by sum_timer_wait desc limit 10 \G`

```sql
SELECT (100 * SUM_TIMER_WAIT / sum(SUM_TIMER_WAIT)
            OVER ()) percent,
            SUM_TIMER_WAIT AS total,
            COUNT_STAR AS calls,
            AVG_TIMER_WAIT AS mean,
            substring(DIGEST_TEXT, 1, 75)
  FROM  performance_schema.events_statements_summary_by_digest
            ORDER BY SUM_TIMER_WAIT DESC
            LIMIT 10;
```

\*each row shows the response time as a total and as percent of the overal response time.

\*mean は平均実行時間

\*`SUM_ROWS_EXAMINED` が SUM_ROWS_SENT よりも相対的に高いときは、index による filtering が機能していないかもしれない

\*`SUM_SELECT_FULL_JOIN` が高いときは、Join コンディションに index が必要か、joint condition が存在しないかのどちらか

\*`SUM_SELECT_RANGE_CHECK` が大きいときは index を変更する目安になる  
これは片方のテーブルで全件、もう片方のテーブルで範囲検索を行って JOIN した回数。

\*`SUM_SELECT_RANGE_CHECK` は INDEX が貼られてないカラムで JOIN された回数。  
INDEX が足りていないので 0 で無いときは INDEX の利用を検討

\*`SUM_CREATED_TMP_DISK_TABLE` はディスク上にテンポラリーテーブルが作成された回数

**temporary table**
メモリ上に作成されるテーブル。tmp_table_size を超える場合は、「created_tmp_disk_tables」としてディスク上に作成
**temp file**
ファイルソート時に、sort_buffer_size に設定のメモリ領域では足りずに、ディスク上の tmep 領域に出力されるファイル

\*`SUM_SORT_MERGE_PASSES` はフィアルを利用したマージソートのパス数。  
カウントされている場合は、sort_buffer_size が不足しファイルアクセスされていることなので、sort_buffer_size を増やすことを検討

2. high loaded schema table
   フル テーブル スキャンが行われたテーブルを調べる

```sql
select * from schema_tables_with_full_table_scans;
```

フルテーブルスキャンが行われたクエリを調べる

```sql
select * from statements_with_full_table_scans order by no_index_used_count desc\G
```

3. Table I/O と File I/O

- for select  
  world という db 名の city テーブルの Table I/O

```sql
SELECT OBJECT_TYPE, OBJECT_SCHEMA, OBJECT_NAME, INDEX_NAME, COUNT_STAR FROM performance_schema.table_io_waits_summary_buy_index_usage WHERE OBJECT_SCHEMA = 'world' AND OBJECT_NAME = 'city'\G
```

\*index が使われないと COUNT_STAR が高くなる

- for update/delete

\*index が使われてないと、COUNT_READ と COUNT_FETCH が高くなる

4. Error Summary tables

- dead lock が何回起きているか見たいとき

```sql
select * from events_errors_summary_by_account_by_error where error_name = "er_lock_deadlock"\G
```

# Analyzing Queries

- Is the runtime shown justified for the given Query?
- If the Query is slow , where does the runtime jumps?

\*if there is a big difference between Estimated cost and Actual cost, optimizer will make poor decision.

## 統計データの更新

```sql
ANALYZE TABLE <tbl_name>;
```

# Configurations

- 1 回につき 1 箇所の変更、相対的に小さい変化量、side effect を意識
- Buffer/Sort と Buffer/Join が十分確保されているからと言ってクエリが早くなるとは限らない。join が実行される回数だけメモリ割り当てのオーバーヘッドが生じるリスクが高まる
- 一方、buffer_pool へのアロケーションは mysql が立ち上がるときに行われるのでオーバーヘッドにはなりえない
- buffer_pool、red_logs、table_caches がしばしば変更の対象となりうる

## BufferPool

- Buffer Pool は２つの領域に分けられる
- 一つは「old block sublist」、２つ目は「new block sublist」
- データは常にページ全体の古いブロックの先頭または先頭に読み込まれる
- 同じページが必要となった場合には old block sublist から new block sublist へ移動(昇格)される
- ２つの sublist は LRU(Least Recently Used)というコンセプトに基づいている
  新しいページ用のスペースが確保したくなったら、LRU に基づいて、最も古いものから追放される

### size の変更

- default は 128MiB
- Buffer Pool がどれだけ活用されているかをみるためには Hit Rate をみるのがよい

計算式

```
100 - (100 * Innodb_pages_read/Innodb_buffer_pool_read_requests)
```

クエリ

```sql
SELECT Variable_name, Variable_value FROM sys.metrics WHERE Variable_name IN ('Innodb_pages_read',Innodb_buffer_pool_read_requests)\G
```

値の変更

```sql
-- Set a global system variable
-- Set innodb_buffer_pool_size variable to 1 GB
SET GLOBAL innodb_buffer_pool_size = 1073741824;
-- Set a session system variable
SET SESSION innodb_buffer_pool_size = 1073741824;
-- Persist a global system variable to the mysqld-auto.cnf file( and set the runtime value)
SET PERSIST innodb_buffer_size = 1073741824;
```

### Instance の変更

- `innodb_buffer_pool_size` と `innodb_buffer_pool_instances` を変更
- デフォルトだと 1GB 以下の buffer pool につき 1 つの instance を持つという設定
- 最大 8 インスタンスまで

### dumping buffer_pool

シャットダウン時によく使う page は保持しておきたい
innodb_buffer_pool_dump_pct を増やすことでリスタート時のために保持されるデータ量を増やすことができる

## Redo Logs

- redo log は sequential IO であるため、パフォーマンスを上げるため、フロントで log buffer が存在する
- トランザクションの変化はメモリに保持され、buffer が満タンになるか、transaction がコミットされたときに flush される
- 書き込み時のデータフローではまずログバッファーに書き込み処理が走る。その後、redo logs への flush 処理が実行される
- この buffer size を規定しているのは、`innodb_log_buffer_size`。デフォだと 16MB。トランザクションが多い場合はこの値を上げると良い

- Redo Logs は１つ目のファイルがいっぱいになったら２つ目のファイルを作成、
  ファイル数の制限に達した場合は、再度 1 つめのファイルに戻り、上書きして行く
- Redo logs がいっぱいになったらそれが ターニングポイントになり bufferpool が tablespcaes への flush を行う
- redo logs ファイルを大きくすることでこの checkpoint を減らすことができる
- `innodb_log_file_size` を大きくすることでリカバリータイムが肥大化する可能性があるが、あまり心配する必要なし。自信をもって大きくして良い
- ログバッファーと同様に BufferPool にも変更は書き込まれる
  そして変更中のデータは tablespaces ファイルへ flush されるまでは dirty というマークが付与された状態で buffer_pool に保持される
- InnoDB では Doublewrite buffer を行っているので、crash などが起きた際にも上書き処理が成功したか失敗したかを検知できる
- buffer pool からの flush が成功したら redo logs では完了というマーキングに変わる
- クラッシュしてしまうともはや buffer pool は機能しなくなるので、redo logs から読み込まれることになる
- `innodb_io_capacity` はデフォルトでは 200 に設定されているが強力な disk であれば、増やしても良い  
  `innnodb_io_capacity_max` で flush させるのに秒単位でどの程度バックグラウンド処理を行うかに影響を与える
- この２つの option はどれくらい早く dirty page を tablespaces に flush させるかを決める値

## Transaction & Lock

- Lock の情報は Buffer pool に保持されている
- トランザクションがコミットされたとしても、undo logs を介してまだインパクトを残していることを忘れては行けない

### Undo Logs

`SHOW ENGINE INNODB STATUS\G`

- `history list length` はトランザクションの問題を示唆する指標となる
- commit されると自然に clean up される

以下のクエリでロックの及んでいるカラム数を調べられる

```sql
SELECT INDEX_NAME, LOCK_TYPE, COUNT(*) FROM performance_schema.data_locks WHERE OBJECT_SCHEMA = 'world' AND OBJECT_NAME = 'city' GROUP BY INDEX_NAME , LOCK_TYPE;
```

トランザクションについての詳細をしる

```sql
SELECT * FROM innodb_trx WHERE trx_started < now() - interval 1 minute ORDER BY trx_rows_locked DESC\G
```

ロックについての詳細を知る(各ロックのトランザクションの id の関係性をみる)

```sql
SELECT * FROM data_lock_waits\G
```

## index performance

### index の評価

- フル テーブル スキャンが行われたテーブルを調べる最も簡単な方法は、`sys.schema_tables_with_full_table_scans` ビューのクエリを行う

```sql
select * from schema_tables_with_full_table_scans\G
```

- 次に有用なのは `statements_with_full_table_scan`  
  インデックスが使われていない statement を表示するノーマライズされたもの

```sql
select * from statements_with_full_table_scan\G
```

- 使われていない index を探す

```sql
select * from schema_unused_indexes\G
```

- 冗長な index を探す

```sql
select * from schema_redundant_indexes\G
```

- 統計情報の精度は、persistent statistics か transient statistics のどちらが使われているかに依存する
  `innodb_stats_persistent_sample_pages`と`innodb_stats_transient_sample_pages`  
   これらの数値はテーブルごとに設定するのが推奨される
  ではどれくらいの数値が適当なのか
- 規則的な distribution であれば、基本的に低い数値
- 不規則的な distribution であれば、上げたほうが良い
- table サイズが大きければ、より多くの page 数を設定することで統計情報の精度が上がる
- テーブルの 10%の row に変更が起こったときに自動的に`ANALYZE TABLE`が実行されるようになっている
- table fragment を取り除くことで index を最適化したい場合は`OPTIMIZW TABLE name;`を実行
