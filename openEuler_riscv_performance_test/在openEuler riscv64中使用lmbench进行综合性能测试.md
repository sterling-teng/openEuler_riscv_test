### 在openEuler riscv64中使用lmbench进行综合性能测试

#### 1. lmbench介绍

lmbench 是一款评价系统综合性能的多平台开源工具，它简易、可移植性强。lmbench 主要对文件读写、进程创建销毁开销、网络建立、内存操作等性能进行测试。它主要衡量系统的两个关键特征，分别为反应时间和带宽。

lmbench主要功能：

带宽测评，包括读取缓存文件，拷贝内存，读内存，写内存，管道，TCP

反应时间测评，包括上下文切换，网络，文件系统的建立和删除，进程创建，信号处理，上层的系统调用，内存读入反应时间，处理器时钟比率计算

#### 2. lmbench编译和测试

测试环境：D1开发板烧入openEuler riscv64 22.03 v2 版本 [https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-22.03-V2-riscv64/D1/](https://gitee.com/link?target=https%3A%2F%2Frepo.tarsier-infra.com%2FopenEuler-RISC-V%2Fpreview%2FopenEuler-22.03-V2-riscv64%2FD1%2F)

下载lmbench源码并解压

````
$ wget https://sourceforge.net/projects/lmbench/files/development/lmbench-3.0-a9/lmbench-3.0-a9.tgz
$ tar xzvf lmbench-3.0-a9.tgz
$ cd lmbench-3.0-a9
````

安装编译所需依赖包

````
$ yum install libtirpc-devel mailx postfix automake -y
````

修改lmbench源码根目录下scripts/build文件，在文件末尾添加以下内容

````
LDLIBS="${LDLIBS} -ltirpc"
CFLAGS="${CFLAGS} -I/usr/include/tirpc"

# now go ahead and build everything!
${MAKE} OS="${OS}" CC="${CC}" CFLAGS="${CFLAGS}" LDLIBS="${LDLIBS}" O="${BINDIR}" $*
````

用automake下的config.guess替换scripts/gnu-os

````
$ cp /usr/share/automake-1.16/config.guess scripts/gnu-os
````

执行命令进行编译，配置，并测试

````
$ make results
````

编译完成后会有以下选项提示需要设置

MULTIPLE COPIES [default 1]: 设置同时运行lmbench的份数，份数多会使lmbench运行缓慢，默认是1，这里设置为默认值1

````
=====================================================================

If you are running on an MP machine and you want to try running
multiple copies of lmbench in parallel, you can specify how many here.

Using this option will make the benchmark run 100x slower (sorry).

NOTE:  WARNING! This feature is experimental and many results are 
	known to be incorrect or random!

MULTIPLE COPIES [default 1]: 1
=====================================================================
````

Job placement selection [default 1]: 作业调度控制方法，默认值是1，表示允许作业调度，这里设置为默认值

````
=====================================================================

Options to control job placement
1) Allow scheduler to place jobs
2) Assign each benchmark process with any attendent child processes
   to its own processor
3) Assign each benchmark process with any attendent child processes
   to its own processor, except that it will be as far as possible
   from other processes
4) Assign each benchmark and attendent processes to their own
   processors
5) Assign each benchmark and attendent processes to their own
   processors, except that they will be as far as possible from
   each other and other processes
6) Custom placement: you assign each benchmark process with attendent
   child processes to processors
7) Custom placement: you assign each benchmark and attendent
   processes to processors

Note: some benchmarks, such as bw_pipe, create attendent child
processes for each benchmark process.  For example, bw_pipe
needs a second process to send data down the pipe to be read
by the benchmark process.  If you have three copies of the
benchmark process running, then you actually have six processes;
three attendent child processes sending data down the pipes and 
three benchmark processes reading data and doing the measurements.

Job placement selection [default 1]: 1
=====================================================================
````

Memory: 设置测试内存大小，默认是$MB, 即为程序计算出来的最大可测试内存，也可以手动定义测试值，这里设置为默认值（最大可测试内存）

````
=====================================================================

Several benchmarks operate on a range of memory.  This memory should be
sized such that it is at least 4 times as big as the external cache[s]
on your system.   It should be no more than 80% of your physical memory.

The bigger the range, the more accurate the results, but larger sizes
take somewhat longer to run the benchmark.

MB [default 686]: 686
Checking to see if you have 686 MB; please wait for a moment...
686MB OK
686MB OK
686MB OK
Hang on, we are calculating your cache line size.
OK, it looks like your cache line is 64 bytes.

=====================================================================
````

SUBSET (ALL|HARWARE|OS|DEVELOPMENT) [default all]: 要运行的测试集，包含ALL/HARWARE/OS/DEVELOPMENT，默认选all，这里选all

````
=====================================================================

lmbench measures a wide variety of system performance, and the full suite
of benchmarks can take a long time on some platforms.  Consequently, we
offer the capability to run only predefined subsets of benchmarks, one
for operating system specific benchmarks and one for hardware specific
benchmarks.  We also offer the option of running only selected benchmarks
which is useful during operating system development.

Please remember that if you intend to publish the results you either need
to do a full run or one of the predefined OS or hardware subsets.

SUBSET (ALL|HARWARE|OS|DEVELOPMENT) [default all]: all
=====================================================================
````

FASTMEM [default no]: 内存latency测试，如果跳过该测试，则设置为yes，如果不跳过则设置为no，默认是no，这里设置为默认值

````
=====================================================================

This benchmark measures, by default, memory latency for a number of
different strides.  That can take a long time and is most useful if you
are trying to figure out your cache line size or if your cache line size
is greater than 128 bytes.

If you are planning on sending in these results, please don't do a fast
run.

Answering yes means that we measure memory latency with a 128 byte stride.  

FASTMEM [default no]: no
=====================================================================
````

SLOWFS [default no]: 文件系统latency测试，如果跳过值设置为yes，不跳过设置为no，默认no，这里设置为默认值

````
=====================================================================

This benchmark measures, by default, file system latency.  That can
take a long time on systems with old style file systems (i.e., UFS,
FFS, etc.).  Linux' ext2fs and Sun's tmpfs are fast enough that this
test is not painful.

If you are planning on sending in these results, please don't do a fast
run.

If you want to skip the file system latency tests, answer "yes" below.

SLOWFS [default no]: no
=====================================================================
````

DISKS [default none]: 硬盘带宽和seek time，需要设置测试硬盘的盘符，例如/dev/sda，默认不测试(默认none)，这里设置为默认值

````
=====================================================================

This benchmark can measure disk zone bandwidths and seek times.  These can
be turned into whizzy graphs that pretty much tell you everything you might
need to know about the performance of your disk.  

This takes a while and requires read access to a disk drive.  
Write is not measured, see disk.c to see how if you want to do so.

If you want to skip the disk tests, hit return below.

If you want to include disk tests, then specify the path to the disk
device, such as /dev/sda.  For each disk that is readable, you'll be
prompted for a one line description of the drive, i.e., 

	Iomega IDE ZIP
or
	HP C3725S 2GB on 10MB/sec NCR SCSI bus

DISKS [default none]: 
=====================================================================
````

REMOTE [default none]: 网络测试，需要2台机器并设置rsh，是测试机器能rsh访问另一台，默认不测试(默认none)，这里设置为默认值

````
=====================================================================

If you are running on an idle network and there are other, identically
configured systems, on the same wire (no gateway between you and them),
and you have rsh access to them, then you should run the network part
of the benchmarks to them.  Please specify any such systems as a space
separated list such as: ether-host fddi-host hippi-host.

REMOTE [default none]: 
=====================================================================
````

Processor mhz [default 999 MHz, 1.0010 nanosec clock]: 测试cpu，默认$MHZ，即为程序判断出的频率，也可以根据情况自己设定，例如3500，单位MHz，这里设置为默认值

````
=====================================================================

Calculating mhz, please wait for a moment...
I think your CPU mhz is 

	999 MHz, 1.0010 nanosec clock
	
but I am frequently wrong.  If that is the wrong Mhz, type in your
best guess as to your processor speed.  It doesn't have to be exact,
but if you know it is around 800, say 800.  

Please note that some processors, such as the P4, have a core which
is double-clocked, so on those processors the reported clock speed
will be roughly double the advertised clock rate.  For example, a
1.8GHz P4 may be reported as a 3592MHz processor.

Processor mhz [default 999 MHz, 1.0010 nanosec clock]: 999
=====================================================================
````

FSDIR [default /usr/tmp]: 临时目录用来存放测试文件，可以自己设定，默认/usr/tmp，这里设置为默认值

````
=====================================================================

We need a place to store a 686 Mbyte file as well as create and delete a
large number of small files.  We default to /usr/tmp.  If /usr/tmp is a
memory resident file system (i.e., tmpfs), pick a different place.
Please specify a directory that has enough space and is a local file
system.

FSDIR [default /usr/tmp]: /usr/tmp
=====================================================================
````

Status output file [default /dev/tty]: 测试输出信息文件存放目录，可以自己设定，默认/dev/tty

````
=====================================================================

lmbench outputs status information as it runs various benchmarks.
By default this output is sent to /dev/tty, but you may redirect
it to any file you wish (such as /dev/null...).

Status output file [default /dev/tty]: /dev/tty
=====================================================================
````

Mail results [default yes]: 是否将测试结果邮件发出来，默认是yes，这里设置为no

````
=====================================================================

There is a database of benchmark results that is shipped with new
releases of lmbench.  Your results can be included in the database
if you wish.  The more results the better, especially if they include
remote networking.  If your results are interesting, i.e., for a new
fast box, they may be made available on the lmbench web page, which is

	http://www.bitmover.com/lmbench

Mail results [default yes]: no
OK, no results mailed.
=====================================================================
````

以上项目设置完成后，开始自动执行测试

````
=====================================================================

Confguration done, thanks.

There is a mailing list for discussing lmbench hosted at BitMover. 
Send mail to majordomo@bitmover.com to join the list.

Using config in CONFIG.openEuler-riscv64
Tue Mar 28 20:07:21 CST 2023
Latency measurements
Tue Mar 28 20:09:44 CST 2023
Calculating file system latency
Tue Mar 28 20:09:46 CST 2023
Local networking
[ 1855.323147] lat_rpc[5594]: unhandled signal 11 code 0x1 at 0x0000000000000001 in libc.so.6[3fb3ed8000+185000]
[ 1855.334176] CPU: 0 PID: 5594 Comm: lat_rpc Not tainted 6.1.0-0.rc3.8.oe2203.riscv64 #1
[ 1855.342384] Hardware name: Allwinner D1 Nezha (DT)
[ 1855.347451] epc : 0000003fb3f6bb88 ra : 0000003fb3f3cd40 sp : 0000003fffb58b40
[ 1855.355614]  gp : 0000000000018800 tp : 0000003fb3cb0c20 t0 : 0000003fffb58c50
[ 1855.363056]  t1 : 0000000000000000 t2 : 0000000000000000 s0 : 0000000000000000
[ 1855.370376]  s1 : 0000003fffb59108 a0 : 0000000000000001 a1 : 0000003fb3f3b970
[ 1855.381693]  a2 : 0000000000000020 a3 : 0000003fb4026078 a4 : 0000000000000053
[ 1855.389863]  a5 : 0000000000000001 a6 : 0000000000000000 a7 : ffffffffffffffff
[ 1855.397602]  s2 : 0000003fffb592c0 s3 : 0000003fb40936b8 s4 : 0000000000000000
[ 1855.405347]  s5 : 0000000000000bd0 s6 : 0000003fb40615e8 s7 : 0000003fb40936b8
[ 1855.413096]  s8 : 0000000000000000 s9 : 0000000000000000 s10: 0000003fb415fd08
[ 1855.420836]  s11: 0000000000000010 t3 : 0000000000000001 t4 : 0000003fffb58c28
[ 1855.428579]  t5 : 000000000000002a t6 : 0000000000000000
[ 1855.434471] status: 8000000200004020 badaddr: 0000000000000001 cause: 000000000000000d
Tue Mar 28 20:13:01 CST 2023
Bandwidth measurements
Tue Mar 28 20:17:36 CST 2023
Calculating context switch overhead
Tue Mar 28 20:17:52 CST 2023
Calculating effective TLB size
Tue Mar 28 20:17:53 CST 2023
Calculating memory load parallelism
Tue Mar 28 20:35:55 CST 2023
McCalpin's STREAM benchmark
Tue Mar 28 20:36:47 CST 2023
Calculating memory load latency
Tue Mar 28 20:53:16 CST 2023
make[1]: Leaving directory '/root/lmbench-3.0-a9/src'
````

#### 3. lmbench测试结果

执行命令查看运行结果

````
$ make see
cd results && make summary >summary.out 2>summary.errs 
cd results && make percent >percent.out 2>percent.errs 
````

运行结果输出到当前目录下的results/summary.out

````
$ cat results/summary.out
L M B E N C H  3 . 0   S U M M A R Y
                 ------------------------------------
		 (Alpha software, do not distribute)

Basic system parameters
------------------------------------------------------------------------------
Host                 OS Description              Mhz  tlb  cache  mem   scal
                                                     pages line   par   load
                                                           bytes  
--------- ------------- ----------------------- ---- ----- ----- ------ ----
openEuler Linux 6.1.0-0       riscv64-linux-gnu  999    10    64 4.8200    1

Processor, Processes - times in microseconds - smaller is better
------------------------------------------------------------------------------
Host                 OS  Mhz null null      open slct sig  sig  fork exec sh  
                             call  I/O stat clos TCP  inst hndl proc proc proc
--------- ------------- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
openEuler Linux 6.1.0-0  999 0.61 1.42 13.2 36.1 34.4 1.83 15.7 6569 31.K 49.K

Basic integer operations - times in nanoseconds - smaller is better
-------------------------------------------------------------------
Host                 OS  intgr intgr  intgr  intgr  intgr  
                          bit   add    mul    div    mod   
--------- ------------- ------ ------ ------ ------ ------ 
openEuler Linux 6.1.0-0 1.0000 1.1000 3.1400   12.0 3.0000

Basic uint64 operations - times in nanoseconds - smaller is better
------------------------------------------------------------------
Host                 OS int64  int64  int64  int64  int64  
                         bit    add    mul    div    mod   
--------- ------------- ------ ------ ------ ------ ------ 
openEuler Linux 6.1.0-0  1.000        6.1400   18.6 3.0100

Basic float operations - times in nanoseconds - smaller is better
-----------------------------------------------------------------
Host                 OS  float  float  float  float
                         add    mul    div    bogo
--------- ------------- ------ ------ ------ ------ 
openEuler Linux 6.1.0-0 3.9500 3.9700   18.9   27.0

Basic double operations - times in nanoseconds - smaller is better
------------------------------------------------------------------
Host                 OS  double double double double
                         add    mul    div    bogo
--------- ------------- ------  ------ ------ ------ 
openEuler Linux 6.1.0-0 4.9500 4.9600   33.9   44.0

Context switching - times in microseconds - smaller is better
-------------------------------------------------------------------------
Host                 OS  2p/0K 2p/16K 2p/64K 8p/16K 8p/64K 16p/16K 16p/64K
                         ctxsw  ctxsw  ctxsw ctxsw  ctxsw   ctxsw   ctxsw
--------- ------------- ------ ------ ------ ------ ------ ------- -------
openEuler Linux 6.1.0-0 8.3700   25.0   20.2   28.2   25.1    28.2    23.8

*Local* Communication latencies in microseconds - smaller is better
---------------------------------------------------------------------
Host                 OS 2p/0K  Pipe AF     UDP  RPC/   TCP  RPC/ TCP
                        ctxsw       UNIX         UDP         TCP conn
--------- ------------- ----- ----- ---- ----- ----- ----- ----- ----
openEuler Linux 6.1.0-0 8.370  37.7 101. 180.7       268.8       960.

*Remote* Communication latencies in microseconds - smaller is better
---------------------------------------------------------------------
Host                 OS   UDP  RPC/  TCP   RPC/ TCP
                               UDP         TCP  conn
--------- ------------- ----- ----- ----- ----- ----
openEuler Linux 6.1.0-0                             

File & VM system latencies in microseconds - smaller is better
-------------------------------------------------------------------------------
Host                 OS   0K File      10K File     Mmap    Prot   Page   100fd
                        Create Delete Create Delete Latency Fault  Fault  selct
--------- ------------- ------ ------ ------ ------ ------- ----- ------- -----
openEuler Linux 6.1.0-0  280.1  236.8 1941.7  523.8  106.9K 0.145 8.31210  14.2

*Local* Communication bandwidths in MB/s - bigger is better
-----------------------------------------------------------------------------
Host                OS  Pipe AF    TCP  File   Mmap  Bcopy  Bcopy  Mem   Mem
                             UNIX      reread reread (libc) (hand) read write
--------- ------------- ---- ---- ---- ------ ------ ------ ------ ---- -----
openEuler Linux 6.1.0-0 177. 174. 182.  447.0 2048.9 1282.0 1306.9 1200 1095.

Memory latencies in nanoseconds - smaller is better
    (WARNING - may not be correct, check graphs)
------------------------------------------------------------------------------
Host                 OS   Mhz   L1 $   L2 $    Main mem    Rand mem    Guesses
--------- -------------   ---   ----   ----    --------    --------    -------
openEuler Linux 6.1.0-0   999 2.2250   25.7        26.3       186.4    No L2 cache?
make[1]: Leaving directory '/root/lmbench-3.0-a9/results'
````

##### 3.1 系统基本信息

输出结果中最开始显示系统的基本参数信息

````
Basic system parameters
------------------------------------------------------------------------------
Host                 OS Description              Mhz  tlb  cache  mem   scal
                                                     pages line   par   load
                                                           bytes  
--------- ------------- ----------------------- ---- ----- ----- ------ ----
openEuler Linux 6.1.0-0       riscv64-linux-gnu  999    10    64 4.8200    1
````

tlb：表示转换后备缓存的页数；

cache line bytes：缓存行字节数

men par：存储器分层并行化；

scal load：并行执行的lmbench数目

##### 3.2 处理器Processor性能

````
Processor, Processes - times in microseconds - smaller is better
------------------------------------------------------------------------------
Host                 OS  Mhz null null      open slct sig  sig  fork exec sh  
                             call  I/O stat clos TCP  inst hndl proc proc proc
--------- ------------- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
openEuler Linux 6.1.0-0  999 0.61 1.42 13.2 36.1 34.4 1.83 15.7 6569 31.K 49.K
````

测试的是处理器、进程操作时间，测试结果的单位是us，数值越小表示性能越好

null call: 简单系统调用时间，即取进程号需要的时间

null I/O: 简单I/O操作-空读写时间，即从/dev/zero读取一个字节的时长t1，写一个字节到/dev/null的时长t2，t1、t2取平均值即为该项结果

stat：取文件状态的操作时长，即得到一个文件的信息所需时长

open clos：打开然后立即关闭文档操作所用时间

slct TCP：select设置所花得时间，通过TCP网络连接选择100个文件描述符所消耗的时间

sig inst：配置信号所耗时长

sig hndl：捕获处理信号所耗时长

fork proc：fork进程后直接退出所耗的时间

exec proc：fork进程后执行execve调用再退出所耗时间

sh proc：fork进程后执行shell再退出所耗时间

##### 3.3 数学运算

操作加、乘、除、取模等运算所花时间，值越小表示性能越好，单位是ns

###### 3.3.1 整型计算

````
Basic integer operations - times in nanoseconds - smaller is better
-------------------------------------------------------------------
Host                 OS  intgr intgr  intgr  intgr  intgr  
                          bit   add    mul    div    mod   
--------- ------------- ------ ------ ------ ------ ------ 
openEuler Linux 6.1.0-0 1.0000 1.1000 3.1400   12.0 3.0000
````

###### 3.3.2 无符号整型计算

````
Basic uint64 operations - times in nanoseconds - smaller is better
------------------------------------------------------------------
Host                 OS int64  int64  int64  int64  int64  
                         bit    add    mul    div    mod   
--------- ------------- ------ ------ ------ ------ ------ 
openEuler Linux 6.1.0-0  1.000        6.1400   18.6 3.0100
````

###### 3.3.3 浮点型计算

````
Basic float operations - times in nanoseconds - smaller is better
-----------------------------------------------------------------
Host                 OS  float  float  float  float
                         add    mul    div    bogo
--------- ------------- ------ ------ ------ ------ 
openEuler Linux 6.1.0-0 3.9500 3.9700   18.9   27.0
````

###### 3.3.4 双精度浮点型计算

````
Basic double operations - times in nanoseconds - smaller is better
------------------------------------------------------------------
Host                 OS  double double double double
                         add    mul    div    bogo
--------- ------------- ------  ------ ------ ------ 
openEuler Linux 6.1.0-0 4.9500 4.9600   33.9   44.0
````

##### 3.4 上下文切换

````
Context switching - times in microseconds - smaller is better
-------------------------------------------------------------------------
Host                 OS  2p/0K 2p/16K 2p/64K 8p/16K 8p/64K 16p/16K 16p/64K
                         ctxsw  ctxsw  ctxsw ctxsw  ctxsw   ctxsw   ctxsw
--------- ------------- ------ ------ ------ ------ ------ ------- -------
openEuler Linux 6.1.0-0 8.3700   25.0   20.2   28.2   25.1    28.2    23.8
````

测试结果单位是us，数值越小，表示性能越好，时间包括切换进程的时间，恢复进程所有状态的时间（包括恢复cache状态）

2p/0k：表示每个进程的大小为0(不执行任何任务)，进程数为2时上下文切换所消耗的时间

2p/16k：表示每个进程大小为16k(执行任务)，进程数为2时上下文切换所消耗的时间

之后的测试以此类推

##### 3.5 本地通讯时延

````
*Local* Communication latencies in microseconds - smaller is better
---------------------------------------------------------------------
Host                 OS 2p/0K  Pipe AF     UDP  RPC/   TCP  RPC/ TCP
                        ctxsw       UNIX         UDP         TCP conn
--------- ------------- ----- ----- ---- ----- ----- ----- ----- ----
openEuler Linux 6.1.0-0 8.370  37.7 101. 180.7       268.8       960.
````

测试结果单位是us，数值越小表示性能越好

2p/0k：表示每个进程的大小为0(不执行任何任务)，进程数为2时上下文切换所消耗的时间

Pipe：管道通信，两个没有具体任务的进程之间使用管道通信，一个token在两个进程间来回传递，传递一个来回所消耗时长的平均值

AF UNIX：同Pipe，但进程间通信使用的是socket通信

UDP：同Pipe，但进程间通信使用的是UDP/IP通信

RPC/UDP：同Pipe，但进程间通信使用的是Sun RPC通信，默认情况下，RPC采用UDP协议传输

TCP：同Pipe，但进程间通信使用的是TCP/IP通信

RCP/TCP：同Pipe，但进程间通信使用的是Sun RPC通信，默认情况下，RPC采用TCP协议传输

TCP conn：创建socket描述符和建立连接所需时间

##### 3.6 文件和内存延时

````
File & VM system latencies in microseconds - smaller is better
-------------------------------------------------------------------------------
Host                 OS   0K File      10K File     Mmap    Prot   Page   100fd
                        Create Delete Create Delete Latency Fault  Fault  selct
--------- ------------- ------ ------ ------ ------ ------- ----- ------- -----
openEuler Linux 6.1.0-0  280.1  236.8 1941.7  523.8  106.9K 0.145 8.31210  14.2
````

测试结果单位是us，数值越小表示性能越好

0K File Create：0K文件创建所用时间

0K File Delete：0K文件删除所用时间

10K File Create：10K文件创建所用时间

10K File Delete：10K文件删除所用时间

Mmap Latency：内存映射，将指定文件的开头n个字节mmap(分配)到内存，然后unmap(释放)，并记录每次mmap和unmap共消耗时间，取每次消耗时间的最大值

Port Fault：保护页延时时间

Page Fault：缺页延时时间

100fd selct：对100个文件描述符配置select的时间

##### 3.7 本地通信带宽

````
*Local* Communication bandwidths in MB/s - bigger is better
-----------------------------------------------------------------------------
Host                OS  Pipe AF    TCP  File   Mmap  Bcopy  Bcopy  Mem   Mem
                             UNIX      reread reread (libc) (hand) read write
--------- ------------- ---- ---- ---- ------ ------ ------ ------ ---- -----
openEuler Linux 6.1.0-0 177. 174. 182.  447.0 2048.9 1282.0 1306.9 1200 1095.
````

测试结果单位为MB/s，数值越大表示性能越好

Pipe：本地通信带宽方面管道操作速度，即在两个进程间建立一个unix pipe，pipe的每个chunk为64K，通过该管道移动50MB数据所用的时间

AF UNIX：两个进程之间建立一个unix stream socket，每个chunk为64K，通过该socket移动10MB数据所用时间

TCP：同Pipe，不同的是进程间通过TCP/IP socket通信，传输的数据为3MB

File reread：文件重复读取的速度

Mmap reread：内存映射重复读取的速度

Bcopy(libc)：从指定内存区拷贝指定数量的字节内容到另一个指定内存区域的速度

Bcopy(hand)：把数据从磁盘的一个位置拷贝到另一个位置所用的时间

Mem read：内存读取速度

Mem write：内存写入速度

##### 3.8 内存操作延时

````
Memory latencies in nanoseconds - smaller is better
    (WARNING - may not be correct, check graphs)
------------------------------------------------------------------------------
Host                 OS   Mhz   L1 $   L2 $    Main mem    Rand mem    Guesses
--------- -------------   ---   ----   ----    --------    --------    -------
openEuler Linux 6.1.0-0   999 2.2250   25.7        26.3       186.4    No L2 cache?
````

测试结果单位是ns，数值越小表示性能越好

L1：缓存1

L2：缓存2

Main mem：连续内存

Rand mem：内存随机访问延时

Guesses：判断前面得到的L1和L2值差值占其中最大值的百分比，如果L1和L2近似，会显示"No L1 cache?"；如果L2和Main mem近似，会显示"No L2 cache?"

对于各部分测试结果的评估，其中本地通讯带宽比较特殊，当它的测试结果值越大时，表示它的性能越好，其他部分的测试结果反之，即测试结果值越小，代表性能越好。

测试日志存放在 lmbench-3.0-a9/results/riscv64-linux-gnu/ 目录下



参考:

https://lmbench.sourceforge.net/

https://blog.csdn.net/qq_36393978/article/details/125989992

https://doc.wendoc.com/b9f6eee1312e9df3a1177a6446b9213e387b37296.html

