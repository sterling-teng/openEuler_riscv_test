## openEuler RISC-V 执行 Redis 性能测试 redis-benchmark

### 1. redis-benchmark 介绍

redis-benchmark 是 Redis 自带的基准测试工具，它包含在 Redis 默认安装包中，用于测试 Redis 的性能

### 2. 安装

由于 redis-benchmark 在安装包内，所以直接安装 redis 即可

````
$ yum install -y redis
````

确认 redis-benchmark 是否已正确安装

````
$ redis-benchmark -h
````

该命令显示的是 redis-benchmark 的帮助信息

启动 redis 服务

````
$ systemctl start redis
$ systemctl status redis
````

### 3. 执行测试

redis-benchmark 的命令选项及其说明

| 序号 | 选项                   | 描述                                       | 默认值    |
| :--- | :--------------------- | :----------------------------------------- | :-------- |
| 1    | **-h**                 | 指定服务器主机名                           | 127.0.0.1 |
| 2    | **-p**                 | 指定服务器端口                             | 6379      |
| 3    | **-s**                 | 指定服务器 socket                          |           |
| 4    | **-c**                 | 指定并发连接数                             | 50        |
| 5    | **-n**                 | 指定请求数                                 | 10000     |
| 6    | **-d**                 | 以字节的形式指定 SET/GET 值的数据大小      | 2         |
| 7    | **-k**                 | 1=keep alive 0=reconnect                   | 1         |
| 8    | **-r**                 | SET/GET/INCR 使用随机 key, SADD 使用随机值 |           |
| 9    | **-P**                 | 通过管道传输 <numreq> 请求                 | 1         |
| 10   | **-q**                 | 强制退出 redis。仅显示 query/sec 值        |           |
| 11   | **--csv**              | 以 CSV 格式输出                            |           |
| 12   | **-l（L 的小写字母）** | 生成循环，永久执行测试                     |           |
| 13   | **-t**                 | 仅运行以逗号分隔的测试命令列表。           |           |
| 14   | **-I（i 的大写字母）** | Idle 模式。仅打开 N 个 idle 连接并等待。   |           |

执行命令测试

````
$ redis-benchmark -h 127.0.0.1 -p 6379 -c 100 -n 100000
````

-h 127.0.0.1：指定 Redis 服务器的主机地址为 127.0.0.1，即本地主机。

-p 6379：指定 Redis 服务器的端口号为 6379，默认情况下 Redis 使用 6379 端口。

-c 100：指定并发连接数为 100，即同时并发地执行操作。

-n 100000：指定执行操作的总次数为 100,000 次。

在使用 默认 redis 服务器地址和默认端口的情况下可以省略 -h 和 -p，即

````
$ redis-benchmark -c 100 -n 100000
````

测试结果主要包括三部分：主要参数配置，时延详细分布情况和每秒处理请求数

````
====== GET ======
  100000 requests completed in 1.57 seconds    //主要参数配置
  100 parallel clients                         //主要参数配置
  3 bytes payload                              //主要参数配置
  keep alive: 1                                //主要参数配置

98.53% <= 1 milliseconds                       //时延详细分布
99.97% <= 2 milliseconds                       //时延详细分布
100.00% <= 2 milliseconds                      //时延详细分布
63532.40 requests per second                    //每秒处理请求数
````

这是 get 命令的性能

100000 requests completed in 34.45 seconds ：表示34.45秒完成100000次请求

100 parallel clients：表示100个并发客户端

3 bytes payload：表示每次只获取3个字节

keep alive: 1：表示只有一台服务器来处理

2902.93 requests per second：每秒2902.93的吞吐量



也可以指定测试 redis 服务器上执行某一命令的性能，例如：

测试 set 命令的性能

````
$ redis-benchmark -c 100 -n 100000 -t set
````

测试 get 命令的性能

````
$ redis-benchmark -c 100 -n 100000 -t get
````

测试 ping 命令的性能

````
$ $ redis-benchmark -c 100 -n 100000 -t ping
````

如果想要输出每种请求类型的总体统计数据，只包含重要的性能指标，而不是详细的每个请求的输出结果，可以执行如下命令

````
$ redis-benchmark -n 100000 -q
````

其中：

-n 10000：表示发送的请求总数为100000

-q：表示以“安静模式”（quiet mode）运行，即输出每种请求类型的总体统计数据，而不是详细的每个请求的输出结果。这使得输出结果更加简洁，只包含重要的性能指标。

测试结果：

````
PING_INLINE: 83892.62 requests per second
PING_BULK: 72358.90 requests per second
SET: 65789.48 requests per second
GET: 64935.07 requests per second
INCR: 65487.89 requests per second
LPUSH: 66181.34 requests per second
RPUSH: 66313.00 requests per second
LPOP: 65019.51 requests per second
RPOP: 66137.57 requests per second
SADD: 67659.00 requests per second
HSET: 66269.05 requests per second
SPOP: 65832.78 requests per second
LPUSH (needed to benchmark LRANGE): 65746.22 requests per second
LRANGE_100 (first 100 elements): 49529.47 requests per second
LRANGE_300 (first 300 elements): 24975.02 requests per second
LRANGE_500 (first 450 elements): 19996.00 requests per second
LRANGE_600 (first 600 elements): 16337.20 requests per second
MSET (10 keys): 66006.60 requests per second
````



参考：

https://www.runoob.com/redis/redis-benchmarks.html

https://www.cnblogs.com/fulongyuanjushi/p/17773608.html

https://blog.csdn.net/Mint6/article/details/130660529

https://blog.51cto.com/u_16213404/9566451

https://www.hikunpeng.com.cn/doc_center/source/zh/kunpengdbs/testguide/tstg/kunpengredis-benchmark_02_0005.html
