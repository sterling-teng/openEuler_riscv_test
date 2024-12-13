

## openEuler RISC-V 执行 BenchmarkSQL 测试

### 1. BenchmarkSQL 介绍

BenchmarkSQL是一款经典的开源数据库测试工具，内嵌了TPC-C（Transaction Processing Performance Council - C）测试脚本，可以对PostgreSQL、MySQL、Oracle以及SQL Server等数据库直接进行测试。它通过JDBC测试OLTP（联机事务处理，Online Transaction Processing）的TPC-C。

TPC（Transaction Processing-Performance Council）是事务处理性能委员会的缩写。该组织的主要功能是指定商用应用基准程序 (Benchmark) 的标准规范、性能和价格度量，并管理测试结果的发布。
其中 TPC-C 是在线事务处理（OLTP）的基准程序。TPC-C 会模拟一个批发商的货物管理环境，旨在模拟仓储、订单、配送等 OLTP 业务的过程。通过模拟这套复杂的业务流程，收集测试中的指标，从而得出最终的 TpmC 值，即每分钟可处理的事务数。

### 2.  安装配置MySQL

安装 mysql 并启动 mysql 服务

````
$ yum install -y mysql-server
$ systemctl start mysqld.service
$ systemctl status mysqld.service
````

查看登录 mysql 数据账号 root 的密码

```
$ cat /var/log/mysql/mysqld.log | grep password
2024-12-09T13:22:13.151154Z 6 [Warning] [MY-010453] [Server] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecur
e option.
```

从查询结果可以看出没有密码

登录 mysql

````
[root@openeuler-riscv64 ~]# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 8.0.40 Source distribution

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
````

设置数据库 root 账号登录密码为 123456

````
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
````

创建数据库 tpcc 并切换到所创建的数据库，然后退出

````
mysql> create database tpcc;
Query OK, 1 row affected (0.04 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |         |
| tpcc               |
+--------------------+
5 rows in set (0.06 sec)

mysql> use tpcc;
Database changed
mysql> show tables;
Empty set (0.01 sec)

mysql> quit
````

### 3. 配置 BenchmarkSQL 并执行测试

#### 3.1 测试 MySQL

安装依赖包 java

````
$ yum install -y java
````

下载 benchmarksql 并解压

````
$ wget https://mirrors.huaweicloud.com/kunpeng/archive/kunpeng_solution/database/patch/benchmarksql5.0-for-mysql.zip
$ unzip benchmarksql5.0-for-mysql.zip
````

进入 benchmarksql5.0-for-mysql/run 目录，根据实际情况修改配置文件

````
$ cd /root/benchmarksql5.0-for-mysql/run
$ cp props.conf mysql.properties
$ vi mysql.properties
````

````
b=mysql
driver=com.mysql.cj.jdbc.Driver
conn=jdbc:mysql://192.168.220.204:3306/tpcc?useSSL=false&useServerPrepStmts=truee
&useConfigs=maxPerformance&rewriteBatchedStatements=true
user=root
password=123456
profile=/etc/my.cnf
data=/data/mysql/data
backup=/data/mysql/backup

warehouses=1000
loadWorkers=100

terminals=150
//To run specified transactions per terminal- runMins must equal zero
runTxnsPerTerminal=0
//To run for specified minutes- runTxnsPerTerminal must equal zero
runMins=10
//Number of total transactions per minute
limitTxnsPerMin=1000000000

//Set to true to run in 4.x compatible mode. Set to false to use the
//entire configured database evenly.
terminalWarehouseFixed=true

//The following five values must add up to 100
//The default percentages of 45, 43, 4, 4 & 4 match the TPC-C spec
newOrderWeight=45
paymentWeight=43
orderStatusWeight=4
deliveryWeight=4
stockLevelWeight=4

// Directory name to create for collecting detailed result data.
// Comment this out to suppress.
resultDirectory=my_result_%tY-%tm-%td_%tH%tM%tS
//osCollectorScript=./misc/os_collector_linux.py
//osCollectorInterval=1
//osCollectorSSHAddr=user@dbhost
//osCollectorDevices=net_eth0 blk_sda
````

编辑配置文件时，主要修改以下部分，其余部分通常使用默认值即可：

conn：包括数据库服务器地址，端口以及数据库名称，根据自己的实际情况设置

user：登录数据库账号

password：登录数据库密码

导入数据参数：数据量warehouses，并发数loadWorkers。

导入数据参数：数据量warehouses，并发数loadWorkers。

runMins和runTxnsPerTerminal这两个参数指定了两种运行方式，前者是按照指定运行时间执行，以时间为标准；后者以指定每个终端的事务数为标准执行。两者不能同时生效，必须有一个设定为0。

参数说明

| 参数名称   | 参数值                                     | 说明                                                         |
| ---------- | ------------------------------------------ | ------------------------------------------------------------ |
| conn       | 192.168.222.120                            | 数据库服务器地址，以实际情况为准。                           |
| 3306       | MySQL数据库端口，以实际情况为准。          |                                                              |
| tpcc       | 数据库名称，以实际情况为准，本例中为tpcc。 |                                                              |
| user       | root                                       | 修改为创建数据库tpcc的账号。                                 |
| password   | 123456                                     | 修改为创建数据库tpcc的密码。                                 |
| warehouses | 1000                                       | 初始化加载数据时，需要创建多少仓库的数据。例如200，标识创建200个仓库数据，每一个数据仓库的数据量大概是76823.04KB，可有少量的上下浮动，因为测试过程中将会插入或删除现有记录。 |
| loadworker | 100                                        | 加载数据时，每次提交进程数。                                 |



| 参数名称               | 说明                                                         |
| ---------------------- | ------------------------------------------------------------ |
| terminals              | 终端数量，指同时有多少终端并发执行，表示并发程度。遍历值140，170，200。 |
| runTxnsPerTerminal     | 每分钟每个终端执行的事务数。                                 |
| runMins                | 执行多少分钟，例如15分钟。与terminals配合使用。              |
| limitTnxsPermin        | 每分钟执行的事务总数。                                       |
| terminalWarehouseFixed | 用于指定终端和仓库的绑定模式，设置为true时可以运行4.x兼容模式，意思为每个终端都有一个固定的仓库。设置为false时可以均匀的使用数据库整体配置。 |

编辑完成后保存退出

在 BenchmarkSQL/run 目录下执行如下命令给 shell 脚本文件赋予可执行权限

````
$ chmod +x *.sh
````

加载数据，创建表并初始化共9个表（bmsql_warehouse, bmsql_stock, bmsql_item, bmsql_order_line, bmsql_new_order, bmsql_history, bmsql_district, bmsql_customer,bmsql_oorder）以及1个配置表（bmsql_config）。

````
$ ./runDatabaseBuild.sh mysql.properties
````

测试结果：

````
20:00:16,387 [main] INFO   jTPCC : Term-00, +-------------------------------------------------------------+
20:00:16,388 [main] INFO   jTPCC : Term-00,  (c) 2003, Raul Barbosa
20:00:16,390 [main] INFO   jTPCC : Term-00,  (c) 2004-2016, Denis Lussier
20:00:16,413 [main] INFO   jTPCC : Term-00,  (c) 2016, Jan Wieck
20:00:16,414 [main] INFO   jTPCC : Term-00, +-------------------------------------------------------------+
20:00:16,415 [main] INFO   jTPCC : Term-00, 
20:00:16,418 [main] INFO   jTPCC : Term-00, db=mysql
20:00:16,419 [main] INFO   jTPCC : Term-00, driver=com.mysql.cj.jdbc.Driver
20:00:16,419 [main] INFO   jTPCC : Term-00, conn=jdbc:mysql://127.0.0.1:3306/tpcc?useSSL=false&useServerPrepStmts=true&useConfigs=maxPerformance&rewriteBatchedStatements=true
20:00:16,420 [main] INFO   jTPCC : Term-00, user=root
20:00:16,426 [main] INFO   jTPCC : Term-00, 
20:00:16,427 [main] INFO   jTPCC : Term-00, warehouses=5
20:00:16,430 [main] INFO   jTPCC : Term-00, terminals=2
20:00:16,460 [main] INFO   jTPCC : Term-00, runMins=10
20:00:16,461 [main] INFO   jTPCC : Term-00, limitTxnsPerMin=1000000000
20:00:16,462 [main] INFO   jTPCC : Term-00, terminalWarehouseFixed=true
20:00:16,463 [main] INFO   jTPCC : Term-00, 
20:00:16,464 [main] INFO   jTPCC : Term-00, newOrderWeight=45
20:00:16,464 [main] INFO   jTPCC : Term-00, paymentWeight=43
20:00:16,465 [main] INFO   jTPCC : Term-00, orderStatusWeight=4
20:00:16,477 [main] INFO   jTPCC : Term-00, deliveryWeight=4
20:00:16,478 [main] INFO   jTPCC : Term-00, stockLevelWeight=4
20:00:16,479 [main] INFO   jTPCC : Term-00, 
20:00:16,480 [main] INFO   jTPCC : Term-00, resultDirectory=my_result_%tY-%tm-%td_%tH%tM%tS
20:00:16,482 [main] INFO   jTPCC : Term-00, osCollectorScript=null
20:00:16,483 [main] INFO   jTPCC : Term-00, 
20:00:16,871 [main] INFO   jTPCC : Term-00, copied mysql.properties to my_result_2024-12-10_200016/run.properties
20:00:16,878 [main] INFO   jTPCC : Term-00, created my_result_2024-12-10_200016/data/runInfo.csv for runID 3
20:00:16,881 [main] INFO   jTPCC : Term-00, writing per transaction results to my_result_2024-12-10_200016/data/result.csv
20:00:16,882 [main] INFO   jTPCC : Term-00,
20:00:20,622 [main] INFO   jTPCC : Term-00, C value for C_LAST during load: 182
20:00:20,631 [main] INFO   jTPCC : Term-00, C value for C_LAST this run:    100
20:00:20,632 [main] INFO   jTPCC : Term-00, 
Term-00, Running Average tpmTOTAL: 1341.68    Current tpmTOTAL: 89976    Memory Usage: 68MB / 154MB          
20:10:21,448 [Thread-0] INFO   jTPCC : Term-00, 
20:10:21,493 [Thread-0] INFO   jTPCC : Term-00, 
20:10:21,498 [Thread-0] INFO   jTPCC : Term-00, Measured tpmC (NewOrders) = 592.71
20:10:21,499 [Thread-0] INFO   jTPCC : Term-00, Measured tpmTOTAL = 1341.37
20:10:21,500 [Thread-0] INFO   jTPCC : Term-00, Session Start     = 2024-12-10 20:00:21
20:10:21,506 [Thread-0] INFO   jTPCC : Term-00, Session End       = 2024-12-10 20:10:21
20:10:21,507 [Thread-0] INFO   jTPCC : Term-00, Transaction Count = 13417
````

Running Average tpmTOTAL: 每分钟平均执行事务数（所有事务）

Memory Usage：客户端内存使用情况 

Measured tpmC (NewOrders) ：每分钟执行的事务数（只统计NewOrders事务）

Transaction Count：执行的交易总数量

取 tpmC(NewOrders)的值作为测试指标，在数据库性能测试中，tpmC (NewOrders) 是一个常用的性能指标，它衡量了在每分钟创建订单的事务数。tpmC (NewOrders) 值越大，说明数据库服务器的交易处理能力越强，从而整体性能越高。

测试完成后删除数据库和数据

````
$ ./runDatabaseDestroy.sh mysql.properties
````

#### 3.2 测试 PostgreSQL

安装 postgresql

````
$ yum install -y postgresql-server
````

初始化并启动 postgresql 服务

````
$ /usr/bin/postgresql-setup initdb
$ systemctl start postgresql.service
$ systemctl status postgresql.service
````

切换到 postgres 用户

````
$ su - postgres
````

创建数据库 tpcc 并修改 postgres 账户密码后退出

````
$ psql
psql (15.9)
Type "help" for help.

postgres=# create database tpcc;
CREATE DATABASE
postgres=# \password
Enter new password for user "postgres": 
Enter it again: 
postgres=# \q
````

确认是否可以登录本地 PostgreSQL  

````
$ psql -U postgres -h localhost
````

如果提示 psql: error: connection to server at "localhost" (::1), port 5432 failed: FATAL:  Ident authentication failed for user "postgres" ，解决方法是修改 /var/lib/pgsql/data/pg_hba.conf 里的配置，将 host all all ::1/128 的 METHOD 和 host all all 127.0.0.1/32 的 METHOD 都从 ident 改为 trust

````
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 trust
````

修改完成后，退出 postgres 账号，回到 root 账号，重启 postgresql 服务

````
[postgres@openeuler-riscv64 ~]$ exit
logout
[root@openeuler-riscv64]# systemctl restart postgresql.service
[root@openeuler-riscv64]# systemctl status postgresql.service
````

下载 benchmarksql 并解压

````
$ wget https://mirrors.huaweicloud.com/kunpeng/archive/kunpeng_solution/database/patch/benchmarksql5.0-for-mysql.zip
$ unzip benchmarksql5.0-for-mysql.zip
````

进入 benchmarksql5.0-for-mysql/run 目录，根据实际情况修改配置文件

````
$ cd /root/benchmarksql5.0-for-mysql/run
$ cp props.conf postgres.properties
$ vi postgres.properties
````

````
db=postgres
driver=org.postgresql.Driver
conn=jdbc:postgresql://localhost:5432/tpcc
user=postgres
password=123456
profile=/etc/my.cnf
data=/data/mysql/data
backup=/data/mysql/backup

warehouses=1
loadWorkers=4

terminals=1
//To run specified transactions per terminal- runMins must equal zero
runTxnsPerTerminal=10
//To run for specified minutes- runTxnsPerTerminal must equal zero
runMins=0
//Number of total transactions per minute
limitTxnsPerMin=300

//Set to true to run in 4.x compatible mode. Set to false to use the
//entire configured database evenly.
terminalWarehouseFixed=true

//The following five values must add up to 100
//The default percentages of 45, 43, 4, 4 & 4 match the TPC-C spec
newOrderWeight=45
paymentWeight=43
orderStatusWeight=4
deliveryWeight=4
stockLevelWeight=4

// Directory name to create for collecting detailed result data.
// Comment this out to suppress.
resultDirectory=my_result_%tY-%tm-%td_%tH%tM%tS
//osCollectorScript=./misc/os_collector_linux.py
//osCollectorInterval=1
//osCollectorSSHAddr=user@dbhost
//osCollectorDevices=net_eth0 blk_sda
````

| 参数名称   | 参数值                                         | 参数说明                                                     |
| ---------- | ---------------------------------------------- | ------------------------------------------------------------ |
| conn       | localhost                                      | 表示数据库服务器地址，以实际情况为准。                       |
| 5432       | 表示PostgreSQL数据库端口，以实际情况为准。     |                                                              |
| postgres   | 表示数据库名称，以实际情况为准，本例中为tpcc。 |                                                              |
| user       | -                                              | 修改为创建数据库用户的账号，以实际情况为准。                 |
| password   | -                                              | 修改为创建数据库用户的密码，以实际情况为准。                 |
| warehouses | -                                              | 初始化加载数据时，需要创建多少仓库的数据。例如输入100，则创建100仓库数据，每一个数据仓库的数据量大概是76823.04KB，可有少量的上下浮动，因为测试过程中将会插入或删除现有记录。 |
| loadworker | -                                              | 表示加载数据时，每次提交进程数。                             |

| 参数名称               | 参数说明                                                     |
| ---------------------- | ------------------------------------------------------------ |
| terminals              | 终端数量，指同时有多少终端并发执行，表示并发程度。           |
| runTxnsPerTerminal     | 每分钟每个终端执行的事务数。                                 |
| runMins                | 执行多少分钟。                                               |
| limitTnxsPermin        | 每分钟执行的事务总数。                                       |
| terminalWarehouseFixed | 用于指定终端和仓库的绑定模式，设置为true时可以运行4.x兼容模式，意思为每个终端都有一个固定的仓库。设置为false时可以均匀的使用数据库整体配置。 |

runMins和runTxnsPerTerminal这两个参数指定了两种运行方式，前者是按照指定运行时间执行，以时间为标准；后者以指定每个终端的事务数为标准执行。两者不能同时生效，必须有一个设定为0。

在 benchmarksql5.0-for-mysql/run 目录下执行命令给 shell 脚本文件赋予可执行权限

```
$ chmod +x *.sh
```

加载数据，创建并初始化表9个表（分别为warehouse，Stock，Item，Order-Line，New-Order，History，District，Customer和Order）和1个配置表。

````
$ ./runDatabaseBuild.sh postgres.properties
````

如果遇到错误 ERROR: there is no unique constraint matching given keys for referenced table "bmsql_item"

````
references bmsql_oorder (o_w_id, o_d_id, o_id);
ERROR: there is no unique constraint matching given keys for referenced table "bmsql_oorder"
alter table bmsql_order_line add constraint ol_stock_fkey
foreign key (ol_supply_w_id, ol_i_id)
references bmsql_stock (s_w_id, s_i_id);
ERROR: there is no unique constraint matching given keys for referenced table "bmsql_stock"
alter table bmsql_stock add constraint s_warehouse_fkey
foreign key (s_w_id)
references bmsql_warehouse (w_id);
ERROR: there is no unique constraint matching given keys for referenced table "bmsql_warehouse"
alter table bmsql_stock add constraint s_item_fkey
foreign key (s_i_id)
references bmsql_item (i_id);
ERROR: there is no unique constraint matching given keys for referenced table "bmsql_item"
# ------------------------------------------------------------
# Loading SQL file ./sql.postgres/buildFinish.sql
# ------------------------------------------------------------
-- ----
-- Extra commands to run after the tables are created, loaded,
-- indexes built and extra's created.
-- PostgreSQL version.
-- ----
vacuum analyze;
````

runDatabaseBuild.sh文件中，默认注释掉第17行AFTER LOAD-"indexCreates foreignKeys buildFinish"，即禁止在数据加载完成后自动执行索引创建、外键约束创建等操作。如果需要在数据加载完成后执行这些操作，需要将这行注释取消掉。同时注释掉第18行AFTER LOAD-"foreignKeys buildFinish"，以禁止构建外键关系。可以通过修改runDatabaseBuild.sh文件来解决该问题

````
$ vi runDatabaseBuild.sh
````

将文件中的第17行前面的**#**号删除，并在第18行信息前面加上**#**号以注释掉该行内容

````
#!/bin/sh

if [ $# -lt 1 ] ; then
    echo "usage: $(basename $0) PROPS [OPT VAL [...]]" >&2
    exit 2
fi

PROPS="$1"
shift
if [ ! -f "${PROPS}" ] ; then
    echo "${PROPS}: no such file or directory" >&2
    exit 1
fi
DB="$(grep '^db=' $PROPS | sed -e 's/^db=//')"

BEFORE_LOAD="tableCreates"
AFTER_LOAD="indexCreates foreignKeys buildFinish"
#AFTER_LOAD="foreignKeys buildFinish"

for step in ${BEFORE_LOAD} ; do
    ./runSQL.sh "${PROPS}" $step
done

./runLoader.sh "${PROPS}" $*

for step in ${AFTER_LOAD} ; do
    ./runSQL.sh "${PROPS}" $step
done
````

修改完成后，最好删除原来tpcc数据库并再重新创建，之后再次执行 ./runDatabaseBuild.sh postgres.properties，否则在加载数据的时候可能会报错

````
./runDatabaseBuild.sh postgres.properties$ su - postgres
$ psql (15.9)
Type "help" for help.

postgres=# drop database tpcc;
DROP DATABASE
postgres=# create database tpcc;
CREATE DATABASE
postgres=# \q
$ exit
$ ./runDatabaseBuild.sh postgres.properties
````

执行测试

````
$ ./runBenchmark.sh postgres.properties
````

测试结果

````
15:50:19,021 [main] INFO   jTPCC : Term-00,  (c) 2003, Raul Barbosa
15:50:19,023 [main] INFO   jTPCC : Term-00,  (c) 2004-2016, Denis Lussier
15:50:19,051 [main] INFO   jTPCC : Term-00,  (c) 2016, Jan Wieck
15:50:19,053 [main] INFO   jTPCC : Term-00, +-------------------------------------------------------------+
15:50:19,055 [main] INFO   jTPCC : Term-00, 
15:50:19,057 [main] INFO   jTPCC : Term-00, db=postgres
15:50:19,059 [main] INFO   jTPCC : Term-00, driver=org.postgresql.Driver
15:50:19,060 [main] INFO   jTPCC : Term-00, conn=jdbc:postgresql://localhost:5432/tpcc
15:50:19,061 [main] INFO   jTPCC : Term-00, user=postgres
15:50:19,063 [main] INFO   jTPCC : Term-00, 
15:50:19,065 [main] INFO   jTPCC : Term-00, warehouses=1
15:50:19,066 [main] INFO   jTPCC : Term-00, terminals=1
15:50:19,091 [main] INFO   jTPCC : Term-00, runTxnsPerTerminal=10
15:50:19,094 [main] INFO   jTPCC : Term-00, limitTxnsPerMin=300
15:50:19,098 [main] INFO   jTPCC : Term-00, terminalWarehouseFixed=true
15:50:19,100 [main] INFO   jTPCC : Term-00, 
15:50:19,101 [main] INFO   jTPCC : Term-00, newOrderWeight=45
15:50:19,103 [main] INFO   jTPCC : Term-00, paymentWeight=43
15:50:19,104 [main] INFO   jTPCC : Term-00, orderStatusWeight=4
15:50:19,105 [main] INFO   jTPCC : Term-00, deliveryWeight=4
15:50:19,106 [main] INFO   jTPCC : Term-00, stockLevelWeight=4
15:50:19,108 [main] INFO   jTPCC : Term-00, 
15:50:19,109 [main] INFO   jTPCC : Term-00, resultDirectory=my_result_%tY-%tm-%td_%tH%tM%tS
15:50:19,117 [main] INFO   jTPCC : Term-00, osCollectorScript=null
15:50:19,121 [main] INFO   jTPCC : Term-00, 
15:50:19,447 [main] INFO   jTPCC : Term-00, copied postgres.properties to my_result_2024-12-11_155019/run.properties
15:50:19,453 [main] INFO   jTPCC : Term-00, created my_result_2024-12-11_155019/data/runInfo.csv for runID 3
15:50:19,456 [main] INFO   jTPCC : Term-00, writing per transaction results to my_result_2024-12-11_155019/data/result.csv
15:50:19,458 [main] INFO   jTPCC : Term-00,
15:50:20,688 [main] INFO   jTPCC : Term-00, C value for C_LAST during load: 24
15:50:20,694 [main] INFO   jTPCC : Term-00, C value for C_LAST this run:    134
15:50:20,695 [main] INFO   jTPCC : Term-00, 
Term-00, Running Average tpmTOTAL: 292.68    Current tpmTOTAL: 96    Memory Usage: 11MB / 128MB          
15:50:23,189 [Thread-0] INFO   jTPCC : Term-00, 
15:50:23,223 [Thread-0] INFO   jTPCC : Term-00, 
15:50:23,229 [Thread-0] INFO   jTPCC : Term-00, Measured tpmC (NewOrders) = 154.44
15:50:23,231 [Thread-0] INFO   jTPCC : Term-00, Measured tpmTOTAL = 283.14
15:50:23,231 [Thread-0] INFO   jTPCC : Term-00, Session Start     = 2024-12-11 15:50:20
15:50:23,232 [Thread-0] INFO   jTPCC : Term-00, Session End       = 2024-12-11 15:50:23
15:50:23,233 [Thread-0] INFO   jTPCC : Term-00, Transaction Count = 10
````

执行结束后，取 tpmC (NewOrders) 的值作为测试指标。在数据库性能测试中，tpmC (NewOrders) 是一个常用的性能指标，它衡量了在每分钟创建订单的事务数。tpmC (NewOrders) 值越大，说明数据库服务器的交易处理能力越强，从而整体性能越高。

删除数据库和数据

````
$ ./runDatabaseDestroy.sh postgres.properties
````



参考：

https://www.hikunpeng.com/document/detail/zh/kunpengdbs/testguide/tstg/kunpengbenchmarksql_06_0004.html

https://cloud.tencent.com/developer/article/1893777

https://cloud.tencent.com/developer/article/2274844

https://forum.openeuler.org/t/topic/882