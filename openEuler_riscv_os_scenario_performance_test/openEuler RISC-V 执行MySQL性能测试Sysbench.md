## openEuler RISC-V 执行 Sysbench 测试

### 1. Sysbench 介绍

Sysbench 是一个广泛使用的开源基准测试工具，旨在对数据库系统和其他性能敏感的应用程序进行基准测试和负载测试。Sysbench 支持多种数据库（如 MySQL、PostgreSQL、SQLite 等），并且能够模拟多种类型的工作负载，例如 OLTP（在线事务处理）和 OLAP（在线分析处理）。

Sysbench 的主要特点：

多种工作负载：Sysbench 可以配置多种类型的工作负载，包括读取、写入、混合和事务处理等。

多线程支持：能够模拟高并发用户的访问情况，使得测试更加贴近实际使用场景。

可扩展性：可以根据需要自定义和扩展测试参数，如表结构、数据行数、线程数等。

数据库独立性：支持 SQLite、MySQL、PostgreSQL 和其他数据库的基准测试。

易于使用：命令行界面友好，提供丰富的选项。

Sysbench 支持以下几种测试模式：

- cpu性能
- 磁盘io性能
- 调度程序性能
- 内存分配及传输速度
- POSIX线程性能
- 数据库性能(OLTP基准测试)

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

创建数据库并切换到所创建的数据库，然后退出

````
mysql> create database sysbench;
Query OK, 1 row affected (0.15 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| sysbench           |
+--------------------+
5 rows in set (0.21 sec)

mysql> use sysbench;
Database changed
mysql> show tables;
Empty set (0.02 sec)

mysql> exit
````

### 3. 执行测试

sysbench 命令格式：sysbench [options]... [testname] [command]

- options 字段是以“--”开头的零个或多个命令行选项的列表，选项名称及其说明请参看下表
- testname 字段为内置的lua脚本名称（例如oltp_read_only），对应 /usr/share/sysbench/ 目录下的 lua 脚本
- command 字段用于指定Sysbench执行的命令，可选项包括 “prepare”、“run”、“cleanup” 和 “help”，分别表示准备（加载数据或创建必要的文件）、执行测试、清理数据和显示使用信息

sysbench 测试分为三步：prepare -> run -> cleanup

**测试准备**

测试之前，需要准备测试数据和表

````
$ sysbench --db-driver=mysql --mysql-host=127.0.0.1 --mysql-port=3306 --mysql-user=root --mysql-password=123456 --mysql-db=sysbench --table_size=10000000 --tables=64 --time=180 --threads=6 --report-interval=1 oltp_read_write prepare
````

**测试数据**

准备完成后，可以执行 OLTP 基准测试

````
$ sysbench --db-driver=mysql --mysql-host=127.0.0.1 --mysql-port=3306 --mysql-user=root --mysql-password=123456 --mysql-db=sysbench --table_size=10000000 --tables=64 --time=180 --threads=6 --report-interval=1 oltp_read_write run
````

options 参数说明：

| 选项名            | 描述                                                         | 默认值    |
| ----------------- | ------------------------------------------------------------ | --------- |
| --db-driver       | 使用到的数据库驱动                                           | mysql     |
| --mysql-host      | MySQL服务器主机名                                            | localhost |
| --mysql-port      | MySQL服务器端口                                              | 3306      |
| --mysql-user      | 用户名                                                       | sbtest    |
| --mysql-password  | 密码                                                         | ""        |
| --mysql-db        | 数据库名                                                     | sbtest    |
| --table_size      | 单表的大小                                                   | 10000     |
| --tables          | 表的数量                                                     | 1         |
| --time            | 测试执行的时间，单位为秒。值为 0 则表示无限制                | 10        |
| --threads         | 并发线程数。导入时，单表只能使用一个线程                     | 1         |
| --report-interval | 输出测试结果的时间间隔，单位为秒。值为 0 则表示禁用间隔时间报告功能。 | 0         |
| --events          | 最大总请求数。值为 0 则表示无限制。                          | 0         |

测试结果：

````
sysbench 1.0.20 (using system LuaJIT 2.1.ROLLING)

Running the test with following options:
Number of threads: 2
Report intermediate results every 10 second(s)
Initializing random number generator from current time


Initializing worker threads...

Threads started!

[ 10s ] thds: 2 tps: 46.76 qps: 940.56 (r/w/o: 658.81/46.86/234.89) lat (ms,95%): 52.89 err/s: 0.10 reconn/s: 0.00
[ 20s ] thds: 2 tps: 50.34 qps: 1005.05 (r/w/o: 703.32/50.44/251.29) lat (ms,95%): 51.02 err/s: 0.00 reconn/s: 0.00
[ 30s ] thds: 2 tps: 53.40 qps: 1068.56 (r/w/o: 748.27/53.70/266.59) lat (ms,95%): 44.98 err/s: 0.00 reconn/s: 0.00
[ 40s ] thds: 2 tps: 53.70 qps: 1074.44 (r/w/o: 752.12/54.30/268.01) lat (ms,95%): 44.17 err/s: 0.00 reconn/s: 0.00
[ 50s ] thds: 2 tps: 47.90 qps: 956.52 (r/w/o: 669.41/48.20/238.91) lat (ms,95%): 53.85 err/s: 0.00 reconn/s: 0.00
[ 60s ] thds: 2 tps: 52.00 qps: 1042.27 (r/w/o: 729.58/52.80/259.89) lat (ms,95%): 47.47 err/s: 0.00 reconn/s: 0.00
SQL statistics:
    queries performed:
        read:                            42616    
        write:                           3064    
        other:                           15198    
        total:                           60878    
    transactions:                        3043   (50.68 per sec.)    
    queries:                             60878  (1013.89 per sec.)  
    ignored errors:                      1      (0.02 per sec.)     
    reconnects:                          0      (0.00 per sec.)     

General statistics:
    total time:                          60.0404s    
    total number of events:              3043        

Latency (ms):
         min:                                   29.02    
         avg:                                   39.40    
         max:                                  146.94    
         95th percentile:                       50.11    
         sum:                               119899.05    

Threads fairness:
    events (avg/stddev):           1521.5000/6.50  
    execution time (avg/stddev):   59.9495/0.00    
````

测试结果说明：

参数信息

````
sysbench 1.0.20 (using system LuaJIT 2.1.ROLLING)

Running the test with following options:
Number of threads: 2
Report intermediate results every 10 second(s)
Initializing random number generator from current time
````

中间过程信息

````
[ 10s ] thds: 2 tps: 46.76 qps: 940.56 (r/w/o: 658.81/46.86/234.89) lat (ms,95%): 52.89 err/s: 0.10 reconn/s: 0.00
[ 10s ] thds: 2 tps: 46.76 qps: 940.56 (r/w/o: 658.81/46.86/234.89) lat (ms,95%): 52.89 err/s: 0.10 reconn/s: 0.00
[ 20s ] thds: 2 tps: 50.34 qps: 1005.05 (r/w/o: 703.32/50.44/251.29) lat (ms,95%): 51.02 err/s: 0.00 reconn/s: 0.00
[ 30s ] thds: 2 tps: 53.40 qps: 1068.56 (r/w/o: 748.27/53.70/266.59) lat (ms,95%): 44.98 err/s: 0.00 reconn/s: 0.00
[ 40s ] thds: 2 tps: 53.70 qps: 1074.44 (r/w/o: 752.12/54.30/268.01) lat (ms,95%): 44.17 err/s: 0.00 reconn/s: 0.00
[ 50s ] thds: 2 tps: 47.90 qps: 956.52 (r/w/o: 669.41/48.20/238.91) lat (ms,95%): 53.85 err/s: 0.00 reconn/s: 0.00
[ 60s ] thds: 2 tps: 52.00 qps: 1042.27 (r/w/o: 729.58/52.80/259.89) lat (ms,95%): 47.47 err/s: 0.00 reconn/s: 0.00
````

thds 是并发线程数。tps 是每秒事务数。qps 是每秒操作数，等于 r（读操作）加上 w（写操作）加上 o（其他操作，主要包括 BEGIN 和 COMMIT）。lat 是延迟，(ms,95%) 是 95% 的查询时间小于或等于该值，单位毫秒。err/s 是每秒错误数。reconn/s 是每秒重试的次数。

结果统计信息

````
SQL statistics:
    queries performed:
        read:                            42616    # 读操作的数量
        write:                           3064     # 写操作的数量
        other:                           15198    # 其它操作的数量
        total:                           60878    # 总的操作数量，total = read + write + other
    transactions:                        3043   (50.68 per sec.)    # 总的事务数（每秒事务数）
    queries:                             60878  (1013.89 per sec.)  # 总的操作数（每秒操作数）
    ignored errors:                      1      (0.02 per sec.)     # 忽略的错误数（每秒忽略的错误数）
    reconnects:                          0      (0.00 per sec.)     # 重试次数（每秒重试的次数）

General statistics:
    total time:                          60.0404s    # 总的执行时间
    total number of events:              3043        # 执行的 event 的数量，在 oltp_read_write 中，默认参数下，一个                                                          event 其实就是一个事务
Latency (ms):
         min:                                   29.02    # 最小耗时
         avg:                                   39.40    # 平均耗时
         max:                                  146.94    # 最大耗时
         95th percentile:                       50.11    # 95% event 的执行耗时
         sum:                               119899.05    # 总耗时

Threads fairness:
    events (avg/stddev):           1521.5000/6.50  # 平均每个线程执行event的数量，stddev是标准差，值越小，代表结果越稳定
    execution time (avg/stddev):   59.9495/0.00    # 平均每个线程的执行时间
````



TPS 和 QPS 反映了系统的吞吐量，越大越好。95% event 的执行耗时代表了事务的执行时长，越小越好。在一定范围内，并发线程数指定得越大，TPS 和 QPS 也会越高。

openEuler 取其中的 transactions 和 queries 作为测试指标，数值越大越好

transactions 表示每秒事务数 (TPS)

queries 表示每秒读写次数（QPS）

**清理测试数据**

````
$ $ sysbench --db-driver=mysql --mysql-host=127.0.0.1 --mysql-port=3306 --mysql-user=root --mysql-password=123456 --mysql-db=sysbench --table_size=10000000 --tables=64 --time=180 --threads=6 --report-interval=1 oltp_read_write cleanup
````







参考：

https://www.hikunpeng.com/document/detail/zh/kunpengdbs/testguide/tstg/kunpengsysbench_02_0016.html

https://www.cnblogs.com/ivictor/p/16955580.html

https://www.cnblogs.com/kismetv/p/7615738.html