在 openEuler RISC-V 24.03 LTS 镜像中执行 wrk 性能测试

#### 1. wrk 简介

wrk 是一款针对 HTTP 协议的基准测试工具，它能够在单机多核 CPU 的条件下，使用系统自带的高性能 I/O 机制，如 epoll，kqueue 等，通过多线程和事件模式，对目标机器产生大量的负载。

#### 2. wrk 测试

硬件：sg2042

镜像：openEuler RISC-V 24.03 LTS 镜像

##### 2.1 测试前准备

安装 wrk

````
$ yum install -y wrk
````

安装成功后，执行命令查看 wrk 版本以及 wrk 命令格式和参数

````
$ wrk -v
wrk 4.2.0 [epoll] Copyright (C) 2012 Will Glozer
Usage: wrk <options> <url>                            
  Options:                                            
    -c, --connections <N>  Connections to keep open   
    -d, --duration    <T>  Duration of test           
    -t, --threads     <N>  Number of threads to use   
                                                      
    -s, --script      <S>  Load Lua script file       
    -H, --header      <H>  Add header to request      
        --latency          Print latency statistics   
        --timeout     <T>  Socket/request timeout     
    -v, --version          Print version details      
                                                      
  Numeric arguments may include a SI unit (1k, 1M, 1G)
  Time arguments may include a time unit (2s, 2m, 2h)
````

wrk 命令格式：wrk \<options> \<url>

url：被测试的 http web server 地址

Options:

| 参数          | 简写 | 描述                                              |
| ------------- | ---- | ------------------------------------------------- |
| --connections | -c   | 和服务器建立并保持的TCP连接数量，                 |
| --duration    | -d   | 测试的时长，如2s，2m，2h                          |
| --threads     | -t   | 测试使用的线程数                                  |
| --script      | -s   | 指定要加载的 Lua 脚本文件路径，用于自定义测试行为 |
| --header      | -H   | 为每一个 HTTP 请求添加 HTTP 头                    |
| --latency     |      | 测试结束后，打印延迟统计信息                      |
| --timeout     |      | 超时时间，如果在此时间内没有收到响应，则记录超时  |
| --version     | -v   | 打印 wrk 版本详细信息                             |

\<N>代表数字参数，支持国际单位 (1k, 1M, 1G)
\<T>代表时间参数，支持时间单位 (2s, 2m, 2h)

测试时可以已有的 http web server，比如 www.baidu.com，如果需要本地搭建一个web server，可以用 nginx

安装 nginx，并启动 nginx 服务

````
$ yum install -y nginx 
$ systemctl start nginx
$ systemctl status nginx
````

##### 2.2 执行测试

测试的 web server 选择 www.baidu.com

````
$ wrk -t128 -c1023 -d60s --latency http://www.baidu.com
````

该命令的意思是 1023 个请求，分128个线程，压测 60s

-t 和 -c 设置为多少合适？

-t(线程数)：一般是CPU核数，最大不要超过 CPUx2 核数，否则会带来额外的上下文切换，将线程数设置为 CPU 核数主要是为了 WRK 能最大化利用 CPU，使结果更准确。CPU核数可以通过 cat /proc/cpuinfo 查到

-c(连接数)：可以理解为并发数，一般在测试过程中，这个值需要使用者不断向上调试，直至 QPS 达到一个临界点，便可认为此时的并发数为系统所能承受的最大并发量。

实际上，wrk 会为每个线程分配（c/t）个 socket 连接，每个连接会先执行请求动作，然后等待直到收到响应后才会再发送请求，所以每个时间点的并发数大致等于连接数（connection）

连接数（c）与 QPS（q），请求响应时间毫秒（t）的关系大概可理解为：q = 1000/t * c
RTT 为 1ms，如果 c（连接数）为 1，则理论上 QPS 接近 1000，如果 c（连接数）为 100，则 QPS 接近 10w
RTT 为 10ms，如果 c（连接数）为 1，则理论上 QPS 接近 100，如果 c（连接数）为 100，则 QPS 接近 1w

但是服务有自己的负载极限，并发数不能无限放大，这就能解释有的时候连接数越大，反而 QPS 越低，是因为并发数已经设的过高，导致待测系统已经超出自身能承受的负载

测试的 web server 是本地搭建的

````
$ wrk -t128 -c1023 -d60s --latency http://localhost:80
````

测试结果

````
$ wrk -t64 -c1023 -d60s --latency http://www.baidu.com
Running 1m test @ http://www.baidu.com
  64 threads and 1023 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   351.56ms  415.35ms   2.00s    85.28%
    Req/Sec    20.32     14.75   170.00     74.32%
  Latency Distribution
     50%  167.30ms
     75%  471.77ms
     90%  956.50ms
     99%    1.92s 
  41098 requests in 1.00m, 412.58MB read
  Socket errors: connect 3, read 7354, write 0, timeout 2631
Requests/sec:    683.75
Transfer/sec:      6.86MB
````

Latency(延迟)：Avg(平均值)，Stdev(标准差)，Max(最大值)，+/- Stdev(正负一个标准差所占比例)

Req/Sec(每秒请求数)：Avg(平均值)，Stdev(标准差)，Max(最大值)，+/- Stdev(正负一个标准差所占比例)

Latency Distribution(延迟分布)

整体情况：

41098 requests in 1.00m, 412.58MB read（在1m 内处理了41098 个请求，读取了412.58MB数据）

Socket errors: connect 3, read 7354, write 0, timeout 2631 （发生错误数）

Requests/sec:    683.75（QPS 683.75，即平均每秒处理请求数为 683.75）

Transfer/sec:     6.86MB（平均每秒读取数据 6.86MB）





参考：

https://github.com/wg/wrk

https://www.cnblogs.com/quanxiaoha/p/10661650.html

https://ken.io/note/http-benchmark-test-wrk-install-and-use

https://testerhome.com/topics/22601