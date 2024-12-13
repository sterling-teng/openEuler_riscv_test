## openEuler RISC-V 执行 TPC-H 测试

### 1. TPC-H 介绍

TPC-H（Transaction Processing Performance Council - H）是一个广泛使用的标准基准测试，旨在评估系统处理查询和数据提取能力的性能。它是由事务处理性能委员会（TPC）创建的，用于测量复杂查询的处理性能。与 TPC-C（主要用于在线事务处理的基准）不同，TPC-H 是针对 OLAP（在线分析处理）工作负载的。

TPC-H基准测试包括22个查询（Q1～Q22），其主要评价指标是各个查询的响应时间，即从提交查询到结果返回所需时间。TPC-H基准测试的度量单位是每小时执行的查询数（QphH@size），其中H表示每小时系统执行复杂查询的平均次数，size表示数据库规模的大小，它能够反映出系统在处理查询时的能力。

### 2. 安装配置

安装 sysbench

````
$ yum install -y sysbench
````

安装 mysql 并启动 mysql 服务

````
$ yum install -y mysql-server
$ systemctl start mysqld.service
$ systemctl status mysqld.service
````

查看登录 mysql 数据账号 root 的密码

```
$ cat /var/log/mysql/mysqld.log | grep password
2024-12-09T13:22:13.151154Z 6 [Warning] [MY-010453] [Server] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
```

从查询结果可以看出没有密码

从[TPC 官网](https://www.tpc.org/tpc_documents_current_versions/current_specifications5.asp)下载 TPC-H Tools，解压后，编辑文件 dbgen/makefile.suite 

````
$ cd /root/tpc-h_v3.0.1/dbgen
$ vi makefile.suite
````

````
################
## CHANGE NAME OF ANSI COMPILER HERE
################
CC      = gcc
# Current values for DATABASE are: INFORMIX, DB2, TDAT (Teradata)
#                                  SQLSERVER, SYBASE, ORACLE, VECTORWISE
# Current values for MACHINE are:  ATT, DOS, HP, IBM, ICL, MVS,
#                                  SGI, SUN, U2200, VMS, LINUX, WIN32
# Current values for WORKLOAD are:  TPCH
DATABASE= MYSQL
MACHINE = LINUX
WORKLOAD = TPCH
````

编辑完成后保存，再将文件名从makefile.suite更改为makefile

````
$ cp makefile.suite makefile
````

修改 dbgen/tpcd.h 文件，在文件最上方添加如下宏定义

````
#ifdef MYSQL
#define GEN_QUERY_PLAN ""
#define START_TRAN "START TRANSACTION"
#define END_TRAN "COMMIT"
#define SET_OUTPUT ""
#define SET_ROWCOUNT "limit %d;\n"
#define SET_DBASE "use %s;\n"
#endif
````

安装依赖包并编译 dbgen

````
$ yum install -y make gcc
$ make -f makefile.suite
````

在dbgen目录下，使用如下命令生成.tbl数据文件。数据量的大小对查询速度有直接影响，TPC-H 中使用 SF 描述数据量，1SF 对应 1GB 单位。1000SF 即 1TB。-s 表示 sf 值，-s 1表示生成1GB的数据。如果需要生成10GB的数据，将1改为10即可。

````
$ ./dbgen -s 1
````

执行上述命令后，dbgen工具将开始生成数据文件并保存在当前目录下。生成的数据文件包括8个表，分别是：supplier.tbl、region.tbl、part.tbl、partsupp.tbl、orders.tbl、nation.tbl、lineitem.tbl、customer.tbl。

dbgen 目录下包含两个脚本：dss.ddl 用于创建表，dss.ri 用于关联表中的主键和外键。这些脚本需要进行修改才能在MySQL中使用。

为了建立MySQL数据库连接，需要在dss.ddl的开头添加一些命令。在dss.ddl的最前面加上以下代码：

````
CREATE DATABASE tpch;
USE tpch;
````

考虑到TPC-H自带的测试用表名是小写的，而DSS.DDL中的表名是大写的，为了保持一致性，建议将表名改为小写。

打开dss.ddl

````
$ vi dss.ddl 
````

按“ESC”键进入命令行模式，输入以下命令将表名改为小写，按回车键完成输入

````
:%s/TABLE\(.*\)/TABLE\L\1
````

修改 dss.ri ，将其内容替换如下：

````
-- Sccsid:     @(#)dss.ri   2.1.8.1
-- tpch Benchmark Version 8.0

USE tpch;

-- ALTER TABLE tpch.region DROP PRIMARY KEY;
-- ALTER TABLE tpch.nation DROP PRIMARY KEY;
-- ALTER TABLE tpch.part DROP PRIMARY KEY;
-- ALTER TABLE tpch.supplier DROP PRIMARY KEY;
-- ALTER TABLE tpch.partsupp DROP PRIMARY KEY;
-- ALTER TABLE tpch.orders DROP PRIMARY KEY;
-- ALTER TABLE tpch.lineitem DROP PRIMARY KEY;
-- ALTER TABLE tpch.customer DROP PRIMARY KEY;


-- For table region
ALTER TABLE tpch.region
ADD PRIMARY KEY (R_REGIONKEY);

-- For table nation
ALTER TABLE tpch.nation
ADD PRIMARY KEY (N_NATIONKEY);

ALTER TABLE tpch.nation
ADD FOREIGN KEY NATION_FK1 (N_REGIONKEY) references
tpch.region(R_REGIONKEY);

COMMIT WORK;

-- For table part
ALTER TABLE tpch.part
ADD PRIMARY KEY (P_PARTKEY);

COMMIT WORK;

-- For table supplier
ALTER TABLE tpch.supplier
ADD PRIMARY KEY (S_SUPPKEY);
ALTER TABLE tpch.supplier
ADD FOREIGN KEY SUPPLIER_FK1 (S_NATIONKEY) references
tpch.nation(N_NATIONKEY);

COMMIT WORK;

-- For table partsupp
ALTER TABLE tpch.partsupp
ADD PRIMARY KEY (PS_PARTKEY,PS_SUPPKEY);

COMMIT WORK;

-- For table customer
ALTER TABLE tpch.customer
ADD PRIMARY KEY (C_CUSTKEY);

ALTER TABLE tpch.customer
ADD FOREIGN KEY CUSTOMER_FK1 (C_NATIONKEY) references
tpch.nation(N_NATIONKEY);

COMMIT WORK;

-- For table lineitem
ALTER TABLE tpch.lineitem
ADD PRIMARY KEY (L_ORDERKEY,L_LINENUMBER);

COMMIT WORK;

-- For table orders
ALTER TABLE tpch.orders
ADD PRIMARY KEY (O_ORDERKEY);

COMMIT WORK;

-- For table partsupp
ALTER TABLE tpch.partsupp
ADD FOREIGN KEY PARTSUPP_FK1 (PS_SUPPKEY) references
tpch.supplier(S_SUPPKEY);
COMMIT WORK;

ALTER TABLE tpch.partsupp
ADD FOREIGN KEY PARTSUPP_FK2 (PS_PARTKEY) references
tpch.part(P_PARTKEY);

COMMIT WORK;

-- For table orders
ALTER TABLE tpch.orders
ADD FOREIGN KEY ORDERS_FK1 (O_CUSTKEY) references
tpch.customer(C_CUSTKEY);

COMMIT WORK;

-- For table lineitem
ALTER TABLE tpch.lineitem
ADD FOREIGN KEY LINEITEM_FK1 (L_ORDERKEY) references
tpch.orders(O_ORDERKEY);

COMMIT WORK;

ALTER TABLE tpch.lineitem
ADD FOREIGN KEY LINEITEM_FK2 (L_PARTKEY,L_SUPPKEY) references
tpch.partsupp(PS_PARTKEY,PS_SUPPKEY);

COMMIT WORK;
````

登录 MySQL，执行以下命令，在MySQL数据库中执行 SQL 脚本文件 dss.ddl，创建tpch数据库和数据表

````
$ \. /root/tpc-h_v3.0.1/dbgen/dss.ddl
````

查看 tpch 数据库是否被成功创建

````
$ show databases;
````

在MySQL数据库中执行 SQL 脚本文件 dss.ri

````
$ \. /root/tpc-h_v3.0.1/dbgen/dss.ri
````

在 dbgen 目录下创建一个 load.sh 脚本，脚本内容如下，tpch为数据库名称

````
#!/bin/bash

write_to_file()
{
file="loaddata.sql"

if [ ! -f "$file" ] ; then
touch "$file"
fi

echo 'USE tpch;' >> $file
echo 'SET FOREIGN_KEY_CHECKS=0;' >> $file

DIR=`pwd`
for tbl in `ls *.tbl`; do
table=$(echo "${tbl%.*}")
echo "LOAD DATA LOCAL INFILE '$DIR/$tbl' INTO TABLE $table" >> $file
echo "FIELDS TERMINATED BY '|' LINES TERMINATED BY '|\n';" >> $file
done
echo 'SET FOREIGN_KEY_CHECKS=1;' >> $file
}

write_to_file
````

执行 load.sh 脚本，会在同目录下生成一个loaddata.sql文件，里面是从8个tbl里导入数据的SQL语句

````
$ bash load.sh
````

在将数据导入到数据库中

````
$ mysql --local-infile -u root -p -S /var/lib/mysql/mysql.sock < loaddata.sql
````

如果提示 ERROR 3948 (42000) at line 3: Loading local data is disabled; this must be enabled on both the client and server sides，解决方法是登录 mysql，查看 local_infile，如果显示 off，就将其 enable

````
$ mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 19
Server version: 8.0.40 Source distribution

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show global variables like 'local_infile';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| local_infile  | OFF   |
+---------------+-------+
1 row in set (0.02 sec)

mysql> set global local_infile=true;
Query OK, 0 rows affected (0.00 sec)

mysql> quit
````

再次执行 mysql --local-infile -u root -p -S /var/lib/mysql/mysql.sock < loaddata.sql，导入完成后登录数据库查看 8 个表，确认是否有数据，如果有数据，就表示导入成功了

````
mysql> use tpch;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+----------------+
| Tables_in_tpch |
+----------------+
| customer       |
| lineitem       |
| nation         |
| orders         |
| part           |
| partsupp       |
| region         |
| supplier       |
+----------------+
8 rows in set (0.02 sec)

mysql> DESCRIBE customer
+--------------+---------------+------+-----+---------+-------+
| Field        | Type          | Null | Key | Default | Extra |
+--------------+---------------+------+-----+---------+-------+
| c_custkey    | int           | NO   | PRI | NULL    |       |
| C_NAME       | varchar(25)   | NO   |     | NULL    |       |
| C_ADDRESS    | varchar(40)   | NO   |     | NULL    |       |
| C_NATIONKEY  | int           | NO   | MUL | NULL    |       |
| C_PHONE      | char(15)      | NO   |     | NULL    |       |
| C_ACCTBAL    | decimal(15,2) | NO   |     | NULL    |       |
| C_MKTSEGMENT | char(10)      | NO   |     | NULL    |       |
| C_COMMENT    | varchar(117)  | NO   |     | NULL    |       |
+--------------+---------------+------+-----+---------+-------+
8 rows in set (0.07 sec)
mysql> show columns from nation;
+-------------+--------------+------+-----+---------+-------+
| Field       | Type         | Null | Key | Default | Extra |
+-------------+--------------+------+-----+---------+-------+
| n_nationkey | int          | NO   | PRI | NULL    |       |
| N_NAME      | char(25)     | NO   |     | NULL    |       |
| N_REGIONKEY | int          | NO   | MUL | NULL    |       |
| N_COMMENT   | varchar(152) | YES  |     | NULL    |       |
+-------------+--------------+------+-----+---------+-------+
4 rows in set (0.02 sec)
````

将 qgen执行文件和 dists.dss 文件拷贝到 queries 模板目录中

````
$ cp qgen dists.dss queries/
````

在 dbgen 目录下创建 saveSql 文件夹

````
$ mkdir saveSql
````

在queries目录下生成查询SQL语句，如果需要生成22条SQL语句，执行如下命令

````
$ cd queries
$ for i in {1..22};do ./qgen -d ${i} > ../saveSql/${i}.sql;done
````

如果需要生成指定的 SQL 语句，就执行对应序号的命令，例如：需要生成1.sql的查询语句：

````
./qgen -d 1 > ../saveSql/1.sql
````

由于原生TPC-H原生没有适配MySQL，因此生成的SQL文件无法在MySQL上运行，需要到saveSql目录下打开生成的SQL文件，并按照x下表修改并保存，以适配MySQL。

| SQL文件名称                                                  | 对应修改说明                                                 |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1.sql                                                        | 删除day后面的**(3)**                                         |
| 1.sql、4.sql、5.sql、6.sql、7.sql、8.sql、9.sql、11.sql、12.sql、13.sql、14.sql、15.sql、16.sql、17.sql、19.sql、20.sql、22.sql、 | 删除最后一行的**limit -1;** <br>可以在saveSql目录下快速删除，输入命令：`**sed -i "s/limit\ -1;//g" \*.sql**` |
| 2.sql、3.sql、10.sql、18.sql、21.sql                         | 删除倒数第二行的分号                                         |

### 3. 执行测试

登录 MySQL，切换到数据库 tpch，依次执行 22 条查询语句 dbgen/saveSql/1.sql ~ dbgen/saveSql/22.sql ，例如执行 1.sql

````
$ mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 30
Server version: 8.0.40 Source distribution

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use tpch;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed 
mysql> \. /root/tpc-h_v3.0.1/dbgen/saveSql/1.sql
+--------------+--------------+-------------+-----------------+-------------------+---------------------+-----------+--------------+----------+-------------+
| l_returnflag | l_linestatus | sum_qty     | sum_base_price  | sum_disc_price    | sum_charge          | avg_qty   | avg_price    | avg_disc | count_order |
+--------------+--------------+-------------+-----------------+-------------------+---------------------+-----------+--------------+----------+-------------+
| A            | F            | 37734107.00 |  56586554400.73 |  53758257134.8700 |  55909065222.827692 | 25.522006 | 38273.129735 | 0.049985 |     1478493 |
| N            | F            |   991417.00 |   1487504710.38 |   1413082168.0541 |   1469649223.194375 | 25.516472 | 38284.467761 | 0.050093 |       38854 |
| N            | O            | 74476040.00 | 111701729697.74 | 106118230307.6056 | 110367043872.497010 | 25.502227 | 38249.117989 | 0.049997 |     2920374 |
| R            | F            | 37719753.00 |  56568041380.90 |  53741292684.6040 |  55889619119.831932 | 25.505794 | 38250.854626 | 0.050009 |     1478870 |
+--------------+--------------+-------------+-----------------+-------------------+---------------------+-----------+--------------+----------+-------------+
4 rows in set (4 min 31.17 sec)

mysql> 
````

查询结果最后一行中的 **4 min 31.17 sec** 表示该次查询所消耗的时间。



参考：

https://www.hikunpeng.com/document/detail/zh/kunpengdbs/testguide/tstg/kunpengtpch_02_0006.html
