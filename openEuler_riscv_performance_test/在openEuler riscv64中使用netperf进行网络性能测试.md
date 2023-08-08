### 在openEuler riscv64中使用netperf进行网络性能测试

#### 1. netperf介绍

netperf是一种网络性能的测量工具，主要针对基于TCP或UDP的传输。Netperf根据应用的不同，可以进行不同模式的网络性能测试，即批量数据传输（bulk data transfer）模式和请求/应答（request/reponse）模式。Netperf测试结果所反映的是一个系统能够以多快的速度向另外一个系统发送数据，以及另外一个系统能够以多快的速度接收数据。

netperf工具以client/server方式工作。server端是netserver，用来侦听来自client端的连接，client端是netperf，用来向server发起网络测试。在client与server之间，首先建立一个控制连接，传递有关测试配置的信息，以及测试的结果；在控制连接建立并传递了测试配置信息以后，client与server之间会再建立一个测试连接，用来来回传递着特殊的流量模式，以测试网络的性能。

nerperf可以模拟三种TCP的流量模式和两种UDP的流量模式：

TCP:

1）单个TCP连接，批量（bulk）传输大量数据

2）单个TCP连接，client请求/server应答的交易（transaction）方式

3）多个TCP连接，每个连接中一对请求/应答的交易方式

UDP:

1）从client到server的单向批量传输

2）请求/应答的交易方式

#### 2. 编译安装

从github获取源码

````
$ git clone https://github.com/HewlettPackard/netperf.git
$ cd netperf
````

安装automake软件包，将netperf源码中config.guess，config.sub用automake软件包中的config.guess，config.sub替换

````
$ yum install automake
$ cp /usr/share/automake-1.16/config.guess .
$ cp /usr/share/automake-1.16/config.sub .
````

运行autogen.sh生成configure文件

````
$ ./autogen.sh
````

编译安装netperf

````
$ ./configure
$ make CFLAGS=-fcommon
$ make install
````

确认是否安装成功

````
$ netperf -V
Netperf version 2.7.1
````

#### 3. 执行测试

##### 3.1 测试环境

由于netperf工具以client/server方式工作，所以执行测试需要2台设备，待测设备作为client, 另一台设备作为server。这两台设备在一个局域网中，可以相互ping通过

client : 烧录openEuler riscv64 22.03 v2 版本镜像的D1

server：x86 ubuntu 22.04

在用做server的设备上一样需要编译安装netperf, 在x86 ubuntu 22.04编译安装的方式与在openEuler riscv64中大致相同，步骤相对比较少，具体如下：

````
$ git clone https://github.com/HewlettPackard/netperf.git
$ cd netperf
$ sudo apt install automake texinfo
$ ./autogen.sh
$ ./configure
$ make CFLAGS=-fcommon
$ make install
````

##### 3.2 执行测试命令

在server端执行命令运行netserver

````
$ netserver -p 10000
Starting netserver with host 'IN(6)ADDR_ANY' port '10000' and family AF_UNSPEC
````

命令中用-p指定监听端口为10000

如果不指定监听端口，会将监听端口设为预设端口12865

````
$ netserver
Starting netserver with host 'IN(6)ADDR_ANY' port '12865' and family AF_UNSPEC
````

###### 3.2.1 TCP批量数据传输测试

````
$ netperf -t TCP_STREAM -H 192.168.0.104 -p 10000 -l 60
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.0.104 () port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

131072  16384  16384    60.08      66.29   
````

参数说明：

-t：指定测试类型，如果不指定，预设值是TCP_STREAM

-H：指定运行netserver的server端IP地址

-p：指定监听端口，和netserver端保持一致，如果不指定，预设值是12865

-l：指定测试时间长度，单位：秒，如果不指定，预设值是10秒

测试结果：

第一列为server端接收包的Socket缓冲区大小，这里是131072

第二列为client端发送数据的Socket缓冲区大小，这里为16384

第三列为client端发送的数据包的大小，这里为默认值16384，即client端所使用的Socket缓冲区大小，这个值可以通过在命令中设置-m来指定

第四列为测试时长

第五列为吞吐量，这里是 66.29Mbits/sec

设置client端发送数据包大小为10240

````
[root@openEuler-riscv64 ~]# netperf -H 192.168.0.104 -p 10000 -- -m 10240
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.0.104 () port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

131072  16384  10240    10.19      58.65 
````

###### 3.2.2 UDP批量数据传输测试

````
$ netperf -t UDP_STREAM  -H 192.168.0.104 -p 10000 -l 30
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.0.104 () port 0 AF_INET
Socket  Message  Elapsed      Messages                
Size    Size     Time         Okay Errors   Throughput
bytes   bytes    secs            #      #   10^6bits/sec

212992   65507   30.01        5511      0      96.24
212992           30.01         107              1.87
````

测试结果：

第一行是client端发送统计，第二行是server端接收统计

第一列为缓冲区大小

第二列为数据包大小

第三列为测试时间长度

第四列为每秒传输数据包数量

第五列为吞吐量，由于UDP协议的不可靠性，server端接收的吞吐量要远远小于client端发送出去的吞吐量

同样也可以使用-m指定数据包大小，但该值不得大于socket的发送与接收缓冲大小，否则会报错

````
$ netperf -t UDP_STREAM  -H 192.168.0.104 -p 10000 -- -m 220000
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.0.103 () port 0 AF_INET
send_data: data send error: Message too long (errno 90)
netperf: send_omni: send_data failed: Message too long
````

设置数据包大小为10240

````
$ netperf -t UDP_STREAM  -H 192.168.0.104 -p 10000 -- -m 10240
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.0.104 () port 0 AF_INET
Socket  Message  Elapsed      Messages                
Size    Size     Time         Okay Errors   Throughput
bytes   bytes    secs            #      #   10^6bits/sec

212992   10240   10.00       11750      0      96.25
212992           10.00         861              7.05
````

###### 3.2.3  TCP长连接请求应答模式测试

测试请求/应答（request/response)网络流量的性能，TCP_RR模式

TCP_RR方式的测试对象是多次TCP request和response的交易过程，但是它们发生在同一个TCP连接中，这种模式常常出现在数据库应用中。数据库的client程序与server程序建立一个TCP连接以后，就在这个连接中传送数据库的多次交易过程。

````
$ netperf -t TCP_RR -H 192.168.0.104 -p 10000 -l 30
MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.0.104 () port 0 AF_INET : first burst 0
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  131072 1        1       30.01     185.80   
16384  131072
````

测试结果：

第一行为client端的情况，第二行为server端的情况

第一列和第二列为缓冲区大小

第三列和第四列为请求包和返回包的大小，默认为1个字节，可以通过参数-r req,resp指定，

第五列为测试时长

第六列为平均交易率，这里是185.80次/秒

指定client端每次发送tcp数据256字节，server端每次回复2048字节

````
$ netperf -t TCP_RR -H 192.168.0.104 -p 10000 -l 30 -- -r 256,2048
MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.0.104 () port 0 AF_INET : first burst 0
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  131072 256      2048    30.00     139.68   
16384  131072
````

###### 3.2.4 TCP短连接请求应答模式测试

测试请求/应答（request/response)网络流量的性能，TCP_CRR模式

与TCP_RR不同，TCP_CRR为每次交易建立一个新的TCP连接。最典型的应用就是HTTP，每次HTTP交易是在一条单独的TCP连接中进行的。因此，由于需要不停地建立新的TCP连接，并且在交易结束后拆除TCP连接，交易率一定会受到很大的影响。

````
$ netperf -t TCP_CRR -H 192.168.0.104 -p 10000 -l 30
MIGRATED TCP Connect/Request/Response TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.0.104 () port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  131072 1        1       30.00      76.17   
16384  131072
````

测试结果各栏位表示的内容以及命令行参数同TCP_RR，从测试结果可以看出，平均交易率相较于TCP_RR有明显减小

通过-r req,resp指定client端每次发送tcp数据256字节，server端每次回复2048字节

````
$ netperf -t TCP_CRR -H 192.168.0.104 -p 10000 -l 30 -- -r 256,2048
MIGRATED TCP Connect/Request/Response TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.0.104 () port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  131072 256      2048    30.00      68.00   
16384  131072
````

###### 3.2.5 UDP连接请求应答模式测试

由于UDP协议的原因，UDP请求应答不分长短连接。只有UDP_RR一个测试项目，测试参数也类似TCP类的测试

UDP_RR方式使用UDP分组进行request/response的交易过程。由于没有TCP连接所带来的负担，所以我们推测交易率一定会有相应的提升。

````
$ netperf -t UDP_RR -H 192.168.0.104 -p 10000 -l 30
MIGRATED UDP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.0.104 () port 0 AF_INET : first burst 0
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

212992 212992 1        1       30.00     176.07   
212992 212992
````

测试结果各栏位表示的内容以及命令行参数同TCP_RR

通过-r req,resp指定client端每次发送tcp数据256字节，server端每次回复2048字节

````
$ netperf -t TCP_RR -H 192.168.0.104 -p 10000 -l 30 -- -r 256,2048
MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.0.104 () port 0 AF_INET : first burst 0
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  131072 256      2048    30.00     135.69   
16384  131072
````



参考：

https://hewlettpackard.github.io/netperf/

https://baike.baidu.com/item/netperf/11070957?fr=aladdin



