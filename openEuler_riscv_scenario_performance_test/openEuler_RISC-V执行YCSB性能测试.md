## openEuler RISC-V 执行 YCSB 性能测试

### 1. YCSB 介绍

YCSB（全称Yahoo！Cloud Serving Benchmark）是雅虎开发的用来对云服务进行基础测试的工具，其内部涵盖了常见的NoSQL数据库产品，如Cassandra、MongoDB、HBase、Redis等。在运行YCSB的时候，可以配置不同的workload和DB，也可以指定线程数和并发数等其他参数。

### 2. 安装配置

安装 redis 数据库

````
$ yum install -y redis
````

启动 redis 服务

````
$ systemctl start redis
$ systemctl status redis
````

安装依赖包

````
$ yum install -y java maven python3
$ ln -s /usr/bin/python3 /usr/bin/python
````

下载 YCSB，并执行构建

````
$ git clone https://github.com/brianfrankcooper/YCSB.git
$ cd YCSB
$ mvn -pl site.ycsb:redis-binding -am clean package
````

主要目录说明：

- bin：目录下有个可执行的YCSB文件，是用户操作的命令行接口。YCSB主逻辑是：解析命令行、设置Java环境、加载Java-libs、封装成可以执行的Java命令，并执行。
- workloads：目录下有各种workload的模板，可以基于workload模板进行自定义修改。

默认的6种测试场景如下：

- workloada：读写均衡型，50%/50%，Reads/Writes，混合负载，读写比例为50/50
- workloadb：读多写少型，95%/5%，Reads/Writes，读为主的负载，读写比例为95/5
- workloadc：只读型，100%，Reads，100%只读负载
- workloadd：读最近写入记录型，95%/5%，Reads/insert，读取最近的数据负载
- workloade：扫描小区间型，95%/5%，scan/insert，小范围的查询负载
- workloadf：读写入记录均衡型，50%/50%，Reads/insert，读修改写负载
- workload_template：参数列表模板

### 3. 执行测试

ycsb命令参数说明：

**ycsb [command] [database] [options]**

- command选项：

  load：载入测试数据。

  run：执行测试过程。

  shell：交互模式。

- **database选项：**指定测试的数据库场景，例如mongodb、cassandra、memcached等。

- **options选项：**

  -P file ：指定workload文件，相对路径或者绝对路径。

  -cp path ：指定额外的Java classpath。

  -jvm-args args ：指定额外的JVM参数。

  -p key=value ：设置ycsb配置项，会覆盖workload文件的配置项。

  -s ：运行时的中间状态打印到stderr中。

  -target n ：表示1s中总共的操作次数。

  -threads n ：设置ycsb client的并发测试线程数，默认是1，单线程。

选择对应的场景，编写对应的配置文件，下面以读写测试为例，进行说明。

进行读写测试，需要修改 workloads/workloada，添加了 redis.host 和 redis.port，redis.host 为 redis 服务器地址，redis.port 为 redis 服务器端口

````
# Yahoo! Cloud System Benchmark
# Workload A: Update heavy workload
#   Application example: Session store recording recent actions
#
#   Read/update ratio: 50/50
#   Default data size: 1 KB records (10 fields, 100 bytes each, plus key)
#   Request distribution: zipfian

recordcount=1000
operationcount=1000
workload=site.ycsb.workloads.CoreWorkload

readallfields=true

readproportion=0.5
updateproportion=0.5
scanproportion=0
insertproportion=0

requestdistribution=zipfian
redis.host=127.0.0.1
redis.port=6379
````

配置文件具体参数如下：

| 参数项              | 参数具体含义                                       |
| ------------------- | -------------------------------------------------- |
| recordcount         | YCSB load阶段加载的记录条数                        |
| operationcount      | YCSB run阶段执行的操作总数                         |
| workload            | workload实现类                                     |
| readallfields       | 查询时是否读取记录的所有字段                       |
| readproportion      | 读操作的百分比                                     |
| updateproportion    | 更新操作的百分比                                   |
| scanproportion      | 插入操作的百分比                                   |
| requestdistribution | 请求分布模式，uniform、zipfian和latest三种分布模式 |
| redis.host          | 待测试redis实例的连接地址（此项为添加项）          |
| redis.port          | 待测试redis实例的连接端口（此项为添加项）          |

加载数据

````
$ bin/ycsb load redis -threads 100 -P workloads/workloada
````

返回字段 **Return=OK**，则表示数据导入成功

````
[OVERALL], Throughput(ops/sec), 105.40739959945188
[TOTAL_GCS_Copy], Count, 5
[TOTAL_GC_TIME_Copy], Time(ms), 82
[TOTAL_GC_TIME_%_Copy], Time(%), 0.8643406767155054
[TOTAL_GCS_MarkSweepCompact], Count, 1
[TOTAL_GC_TIME_MarkSweepCompact], Time(ms), 24
[TOTAL_GC_TIME_%_MarkSweepCompact], Time(%), 0.2529777590386845
[TOTAL_GCs], Count, 6
[TOTAL_GC_TIME], Time(ms), 106
[TOTAL_GC_TIME_%], Time(%), 1.1173184357541899
[CLEANUP], Operations, 2
[CLEANUP], AverageLatency(us), 4384.5
[CLEANUP], MinLatency(us), 631
[CLEANUP], MaxLatency(us), 8139
[CLEANUP], 95thPercentileLatency(us), 8139
[CLEANUP], 99thPercentileLatency(us), 8139
[INSERT], Operations, 1000
[INSERT], AverageLatency(us), 15695.496
[INSERT], MinLatency(us), 13912
[INSERT], MaxLatency(us), 184319
[INSERT], 95thPercentileLatency(us), 17887
[INSERT], 99thPercentileLatency(us), 24127
[INSERT], Return=OK, 1000
````

执行测试

````
$ bin/ycsb run redis -threads 100 -P workloads/workloada
````

测试结果：

````
YCSB Client 0.18.0-SNAPSHOT

Loading workload...
Starting test.
DBWrapper: report latency for each error is false and specific error codes to track for latency are: []
[OVERALL], RunTime(ms), 3767    # 测试过程耗时（毫秒）
[OVERALL], Throughput(ops/sec), 265.4632333421821    # 测试过程中的吞吐量（ops/sec）
[TOTAL_GCS_Copy], Count, 2
[TOTAL_GC_TIME_Copy], Time(ms), 59
[TOTAL_GC_TIME_%_Copy], Time(%), 1.5662330767188746
[TOTAL_GCS_MarkSweepCompact], Count, 1
[TOTAL_GC_TIME_MarkSweepCompact], Time(ms), 40
[TOTAL_GC_TIME_%_MarkSweepCompact], Time(%), 1.0618529333687283
[TOTAL_GCs], Count, 3
[TOTAL_GC_TIME], Time(ms), 99
[TOTAL_GC_TIME_%], Time(%), 2.628086010087603
[READ], Operations, 516    # 执行read操作的总数
[READ], AverageLatency(us), 6267.205426356589   # 每次read操作的平均时延（微秒）
[READ], MinLatency(us), 5208    # 每次read操作的最小时延（微秒）
[READ], MaxLatency(us), 245247    # 每次read操作的最大时延（微秒）
[READ], 95thPercentileLatency(us), 6431    # 95% read操作的时延在6431微秒以内
[READ], 99thPercentileLatency(us), 8171    # 99% read操作的时延在8171微秒以内
[READ], Return=OK, 516    # 返回成功，操作数516
[CLEANUP], Operations, 2
[CLEANUP], AverageLatency(us), 4585.5
[CLEANUP], MinLatency(us), 719
[CLEANUP], MaxLatency(us), 8455
[CLEANUP], 95thPercentileLatency(us), 8455
[CLEANUP], 99thPercentileLatency(us), 8455
[UPDATE], Operations, 484    # 执行update操作的总数
[UPDATE], AverageLatency(us), 3579.7954545454545    # 每次update操作平均时延（微秒）
[UPDATE], MinLatency(us), 2462    # 每次update操作平均时延（微秒）
[UPDATE], MaxLatency(us), 103167    # 每次update操作的最大时延（微秒）
[UPDATE], 95thPercentileLatency(us), 5051    # 95% update操作的时延在5051微秒以内
[UPDATE], 99thPercentileLatency(us), 6967    # 99% update操作的时延在6967微秒以内
[UPDATE], Return=OK, 484     # 返回成功，操作数4980
````

返回字段**Return=OK**，则表示测试完成，取“[OVERALL],Throughput”值作为测试指标。

其余场景类似，这里就不再赘述。





参考：

https://github.com/brianfrankcooper/YCSB

https://www.hikunpeng.com/document/detail/zh/kunpengdbs/testguide/tstg/kunpengycsbformong_11_0003.html

https://blog.csdn.net/jackgo73/article/details/115959961

https://cloud.tencent.com/developer/article/2001006