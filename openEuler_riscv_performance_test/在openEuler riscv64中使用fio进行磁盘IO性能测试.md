

### 在openEuler riscv64中使用fio进行磁盘I/O性能测试

#### 1. fio介绍

FIO是Linux下开源的一款IOPS测试工具，主要用来对磁盘进行压力测试和性能验证。 它可以产生许多线程或进程来执行用户特定类型的I/O操作，相当于是一个多线程的IO生成工具，用于生成多种IO模式来测试硬盘设备的性能。

硬盘I/O测试主要有一下四个类型：随机读、随机写、顺序读、顺序写

#### 2. 在openEuler riscv64中使用fio

硬件环境：D1开发板烧入openEuler riscv64 22.03 v2 版本 https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-22.03-V2-riscv64/D1/

##### 2.1 安装编译

下载fio源码

````
$ git clone https://github.com/axboe/fio.git
````

安装依赖包

````
$ yum install libaio-devel
````

编译安装

````
$ ./configure --disable-shm
$ make && make install
````

##### 2.2 运行fio

随机读测试

````
$ fio -name=randread -direct=1 -iodepth=32 -rw=randread -ioengine=libaio -bs=4k -size=1G -numjobs=1 -runtime=600 -group_reporting -filename=/dev/sda
````

随机写测试

````
$ fio -name=randwrite -direct=1 -iodepth=32 -rw=randwrite -ioengine=libaio -bs=4k -size=1G -numjobs=1 -runtime=600 -group_reporting -filename=/dev/sda
````

顺序读测试

````
$ fio -name=read -direct=1 -iodepth=32 -rw=read -ioengine=libaio -bs=4k -size=1G -numjobs=1 -runtime=600 -group_reporting -filename=/dev/sda
````

顺序写测试

````
$ fio -name=write -direct=1 -iodepth=32 -rw=write -ioengine=libaio -bs=4k -size=1G -numjobs=1 -runtime=600 -group_reporting -filename=/dev/sda
````

参数说明：

-name: 表示测试任务名称，可以自定义

-direct: 设置为1表示使用direct I/O模式，跳过缓存，直接读写硬盘；设置为0表示不使用direct I/O模式，数据会先写到缓存里，再在后台写到硬盘，读取的时候也是优先从缓存读取。

-iodepth: I/O队列深度，例如-iodepth=32表示fio控制请求中的I/O最大个数为32，这里的队列深度是指每个线程的队列深度。

-rw: 读写策略，可以设置为randwrite(随机写)、randread(随机读)、write(顺序写)、read(顺序读)

-ioengine: I/O引擎，支持多种类型，通常使用异步I/O引擎libaio

-bs: 单次I/O块大小，默认是4KB

-size: 任务每个线程读写文件的大小，也可以将大小设置为百分比，例如-size=20%, fio将使用给定文件或者设备完整大小的20%

-numjobs: 任务并发线程数，默认值1

-runtime: 测试时间，即fio运行时长，上面的例子中设置的是600s，也可以设置为以分钟为单位，如2m。如果未指定该参数，fio会持续将size指定大小的文件，以每次bs值为块大小读写完

group_reporting: 测试结果显示模式，如果指定该参数，测试结果会汇总每个线程的统计信息

filename: 测试对象，可以是设备名称或者文件地址，例如 /dev/sda或者/root/test/openEuler-22.03-V2-base-d1-preview.img

##### 2.3 测试结果分析

这是一个IO模式为随机写的测试结果

````
fio-3.33-130-g557c
Starting 2 threads
Jobs: 2 (f=2): [w(2)][100.0%][w=2242KiB/s][w=560 IOPS][eta 00m:00s]
randwrite: (groupid=0, jobs=2): err= 0: pid=6838: Mon Mar 13 19:26:31 2023
  write: IOPS=462, BW=1849KiB/s (1894kB/s)(325MiB/180006msec); 0 zone resets
    slat (usec): min=204, max=85459, avg=4269.83, stdev=4810.45
    clat (usec): min=1674, max=920294, avg=134112.63, stdev=88086.43
     lat (msec): min=3, max=940, avg=138.38, stdev=90.50
    clat percentiles (msec):
     |  1.00th=[   65],  5.00th=[  102], 10.00th=[  104], 20.00th=[  106],
     | 30.00th=[  107], 40.00th=[  109], 50.00th=[  110], 60.00th=[  111],
     | 70.00th=[  113], 80.00th=[  117], 90.00th=[  155], 95.00th=[  388],
     | 99.00th=[  506], 99.50th=[  701], 99.90th=[  835], 99.95th=[  860],
     | 99.99th=[  902]
   bw (  KiB/s): min=  184, max= 2704, per=99.88%, avg=1847.45, stdev=323.70, samples=718
   iops        : min=   46, max=  676, avg=461.66, stdev=80.99, samples=718
  lat (msec)   : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.02%
  lat (msec)   : 100=3.09%, 250=90.66%, 500=5.17%, 750=0.68%, 1000=0.35%
  cpu          : usr=1.48%, sys=2.81%, ctx=83345, majf=0, minf=2
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=99.9%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,83217,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=32

Run status group 0 (all jobs):
  WRITE: bw=1849KiB/s (1894kB/s), 1849KiB/s-1849KiB/s (1894kB/s-1894kB/s), io=325MiB (341MB), run=180006-180006msec

Disk stats (read/write):
  sda: ios=106/83214, merge=0/0, ticks=158/177610, in_queue=177768, util=100.00%
````

以上输出结果分为三部分：

从"Jobs: 2 (f=2): 到 latency   : target=0, window=0, percentile=100.00%, depth=32" 是第一部分，这是每个线程的输出

"Run status group 0 (all jobs):" 是第二部分，是group的输出（所有线程的统计输出）

"Disk stats (read/write):" 是第三部分，是磁盘的统计输出

重要指标：

IOPS: 每秒读/写次数

bw: 吞吐量，每秒读写数据量

lat(msec): 时延，提交I/O请求到I/O相应完成后返回的时长

| 参数           | 内容                                                         |
| -------------- | ------------------------------------------------------------ |
| iops           | IOPS，每秒读/写测试，单位为次                                |
| BW             | 平均I/O带宽，也叫吞吐量，每秒读写数量                        |
| slat           | 提交延迟，提交I/O请求到kernel所花的时间                      |
| clat           | 完成延迟, 提交I/O请求到kernel后，处理所花的时间              |
| lat            | I/O延时统计，包括fio提交I/O请求到I/O相应完成后返回的时间，等于slat+clat |
| bw             | I/O带宽统计                                                  |
| cpu            | CPU统计信息                                                  |
| IO depths      | 平均的I/O队列深度统计                                        |
| IO submit      | 发出的I/O请求中，不同的I/O块所占的比例                       |
| IO complete    | fio所完成的IO请求中，不同的I/O块所占的比例                   |
| IO issued rwts | 统计整个测试过程中，读写请求的次数，以及其中有多少是短请求或丢弃的 |
| IO laencies    | IO完成延迟的分布                                             |
| io             | 测试所完成的I/O数据量                                        |
| ios            | 所有组执行的I/O数                                            |
| merge          | 发送给当前磁盘的I/O请求中，在I/O调度层被合并的次数是多少。   |
| ticks          | 磁盘忙的滴答数                                               |
| in_queue       | 在磁盘队列中所花费的所有时间                                 |
| util           | 当前磁盘的利用率。如果该值为100%，表示磁盘时刻都在处理IO请求；如果该值为50%，表示磁盘有50%的时间处于空闲 |



参考：

https://github.com/axboe/fio

https://fio.readthedocs.io/en/latest/fio_doc.html

https://www.modb.pro/db/176690

https://blog.csdn.net/weixin_42241611/article/details/124367568





