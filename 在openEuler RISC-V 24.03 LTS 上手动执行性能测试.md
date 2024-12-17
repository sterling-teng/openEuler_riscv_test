在openEuler RISC-V 24.03 LTS 上手动执行性能测试

#### 1. unixbench

gcc安装编译

````
$ yum install -y git gcc make
$ git clone https://github.com/kdlucas/byte-unixbench.git
$ cd byte-unixbench/UnixBench
$ make
````

clang安装编译

````
$ yum install -y git clang make
$ git clone https://github.com/kdlucas/byte-unixbench.git
$ cd byte-unixbench/UnixBench
$ yum install clang
$ sed -i 's/CC=gcc/CC=clang/g' Makefile    //将Makefile文件中第58行的CC=gcc改成CC=clang
$ make
````

执行测试

````
./Run -c 1 -c $(nproc)    //表示执行2次，第一次执行单任务，第二次并行执行和当前进程可用的cpu数目相等数量任务
````

测试结果

````
$ ./Run -c 1 -c $(nproc)
make all
make[1]: Entering directory '/root/byte-unixbench/UnixBench'
make distr
make[2]: Entering directory '/root/byte-unixbench/UnixBench'
Checking distribution of files
./pgms  exists
./src  exists
./testdir  exists
./tmp  exists
./results  exists
make[2]: Leaving directory '/root/byte-unixbench/UnixBench'
make programs
make[2]: Entering directory '/root/byte-unixbench/UnixBench'
make[2]: Nothing to be done for 'programs'.
make[2]: Leaving directory '/root/byte-unixbench/UnixBench'
make[1]: Leaving directory '/root/byte-unixbench/UnixBench'
sh: line 1: 3dinfo: command not found

   #    #  #    #  #  #    #          #####   ######  #    #   ####   #    #
   #    #  ##   #  #   #  #           #    #  #       ##   #  #    #  #    #
   #    #  # #  #  #    ##            #####   #####   # #  #  #       ######
   #    #  #  # #  #    ##            #    #  #       #  # #  #       #    #
   #    #  #   ##  #   #  #           #    #  #       #   ##  #    #  #    #
    ####   #    #  #  #    #          #####   ######  #    #   ####   #    #

   Version 5.1.3                      Based on the Byte Magazine Unix Benchmark

   Multi-CPU version                  Version 5 revisions by Ian Smith,
                                      Sunnyvale, CA, USA
   January 13, 2011                   johantheghost at yahoo period com

------------------------------------------------------------------------------
   Use directories for:
      * File I/O tests (named fs***) = /root/byte-unixbench/UnixBench/tmp
      * Results                      = /root/byte-unixbench/UnixBench/results
------------------------------------------------------------------------------


1 x Dhrystone 2 using register variables  1 2 3 4 5 6 7 8 9 10

1 x Double-Precision Whetstone  1 2 3 4 5 6 7 8 9 10

1 x Execl Throughput  1 2 3

1 x File Copy 1024 bufsize 2000 maxblocks  1 2 3

1 x File Copy 256 bufsize 500 maxblocks  1 2 3

1 x File Copy 4096 bufsize 8000 maxblocks  1 2 3

1 x Pipe Throughput  1 2 3 4 5 6 7 8 9 10

1 x Pipe-based Context Switching  1 2 3 4 5 6 7 8 9 10

1 x Process Creation  1 2 3

1 x System Call Overhead  1 2 3 4 5 6 7 8 9 10

1 x Shell Scripts (1 concurrent)  1 2 3

1 x Shell Scripts (8 concurrent)  1 2 3

8 x Dhrystone 2 using register variables  1 2 3 4 5 6 7 8 9 10

8 x Double-Precision Whetstone  1 2 3 4 5 6 7 8 9 10

8 x Execl Throughput  1 2 3

8 x File Copy 1024 bufsize 2000 maxblocks  1 2 3

8 x File Copy 256 bufsize 500 maxblocks  1 2 3

8 x File Copy 4096 bufsize 8000 maxblocks  1 2 3

8 x Pipe Throughput  1 2 3 4 5 6 7 8 9 10

8 x Pipe-based Context Switching  1 2 3 4 5 6 7 8 9 10

8 x Process Creation  1 2 3

8 x System Call Overhead  1 2 3 4 5 6 7 8 9 10

8 x Shell Scripts (1 concurrent)  1 2 3

8 x Shell Scripts (8 concurrent)  1 2 3

========================================================================
   BYTE UNIX Benchmarks (Version 5.1.3)

   System: openeuler-riscv64: GNU/Linux
   OS: GNU/Linux -- 6.6.0-22.0.0.25.mg2403.riscv64 -- #1 SMP Thu Apr 25 04:14:07 UTC 2024
   Machine: riscv64 (riscv64)
   Language: en_US.utf8 (charmap="UTF-8", collate="UTF-8")
   19:32:08 up  1:49,  0 user,  load average: 0.47, 1.99, 7.01; runlevel 2024-05-11

------------------------------------------------------------------------
Benchmark Run: Sat May 11 2024 19:32:08 - 20:01:04
8 CPUs in system; running 1 parallel copy of tests

Dhrystone 2 using register variables        2364572.6 lps   (10.1 s, 7 samples)
Double-Precision Whetstone                      604.1 MWIPS (10.3 s, 7 samples)
Execl Throughput                                 41.0 lps   (29.5 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks         65552.9 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks           18020.5 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks        205800.9 KBps  (30.0 s, 2 samples)
Pipe Throughput                               96236.3 lps   (10.1 s, 7 samples)
Pipe-based Context Switching                   5831.8 lps   (10.1 s, 7 samples)
Process Creation                                170.2 lps   (30.1 s, 2 samples)
Shell Scripts (1 concurrent)                    112.1 lpm   (60.5 s, 2 samples)
Shell Scripts (8 concurrent)                     67.1 lpm   (60.8 s, 2 samples)
System Call Overhead                         110279.4 lps   (10.1 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0    2364572.6    202.6
Double-Precision Whetstone                       55.0        604.1    109.8
Execl Throughput                                 43.0         41.0      9.5
File Copy 1024 bufsize 2000 maxblocks          3960.0      65552.9    165.5
File Copy 256 bufsize 500 maxblocks            1655.0      18020.5    108.9
File Copy 4096 bufsize 8000 maxblocks          5800.0     205800.9    354.8
Pipe Throughput                               12440.0      96236.3     77.4
Pipe-based Context Switching                   4000.0       5831.8     14.6
Process Creation                                126.0        170.2     13.5
Shell Scripts (1 concurrent)                     42.4        112.1     26.4
Shell Scripts (8 concurrent)                      6.0         67.1    111.8
System Call Overhead                          15000.0     110279.4     73.5
                                                                   ========
System Benchmarks Index Score                                          63.7

------------------------------------------------------------------------
Benchmark Run: Sat May 11 2024 20:01:04 - 20:30:29
8 CPUs in system; running 8 parallel copies of tests

Dhrystone 2 using register variables       16620635.5 lps   (10.2 s, 7 samples)
Double-Precision Whetstone                     4529.8 MWIPS (8.8 s, 7 samples)
Execl Throughput                                242.6 lps   (29.4 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        428874.7 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks          117083.9 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks       1442658.7 KBps  (30.0 s, 2 samples)
Pipe Throughput                              651922.0 lps   (10.2 s, 7 samples)
Pipe-based Context Switching                  35886.1 lps   (10.2 s, 7 samples)
Process Creation                               1189.0 lps   (30.2 s, 2 samples)
Shell Scripts (1 concurrent)                    603.1 lpm   (60.7 s, 2 samples)
Shell Scripts (8 concurrent)                     84.6 lpm   (62.0 s, 2 samples)
System Call Overhead                         570797.7 lps   (10.2 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0   16620635.5   1424.2
Double-Precision Whetstone                       55.0       4529.8    823.6
Execl Throughput                                 43.0        242.6     56.4
File Copy 1024 bufsize 2000 maxblocks          3960.0     428874.7   1083.0
File Copy 256 bufsize 500 maxblocks            1655.0     117083.9    707.5
File Copy 4096 bufsize 8000 maxblocks          5800.0    1442658.7   2487.3
Pipe Throughput                               12440.0     651922.0    524.1
Pipe-based Context Switching                   4000.0      35886.1     89.7
Process Creation                                126.0       1189.0     94.4
Shell Scripts (1 concurrent)                     42.4        603.1    142.2
Shell Scripts (8 concurrent)                      6.0         84.6    141.0
System Call Overhead                          15000.0     570797.7    380.5
                                                                   ========
System Benchmarks Index Score                                         356.9
````

所有执行结果存放在unixbench根目录下的results目录下

#### 2. nmap

安装

````
$ yum install nmap
````

执行测试

````
$ nmap -sS -sU -oN /root/nmap/nmap.txt 127.0.0.1
````

测试结果

````
$ nmap -sS -sU -oN /root/nmap/nmap.txt 127.0.0.1
Starting Nmap 7.94 ( https://nmap.org ) at 2024-05-11 20:36 CST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00025s latency).
Not shown: 998 closed udp ports (port-unreach), 998 closed tcp ports (reset)
PORT    STATE         SERVICE
22/tcp  open          ssh
111/tcp open          rpcbind
68/udp  open|filtered dhcpc
111/udp open          rpcbind

Nmap done: 1 IP address (1 host up) scanned in 4.25 seconds
````

输出结果用 -oN 参数指定存储在 /root/nmap/nmap.txt 里

#### 3. lmbench

下载 lmbench 源码，并解压

````
$ wget https://sourceforge.net/projects/lmbench/files/development/lmbench-3.0-a9/lmbench-3.0-a9.tgz
$ tar xzvf lmbench-3.0-a9.tgz
$ cd lmbench-3.0-a9
````

修改 lmbench 源码根目录下 scripts/build 文件，在 LDLIBS=-lm 下面添加以下内容

````
LDLIBS="${LDLIBS} -ltirpc"
CFLAGS="${CFLAGS} -I /usr/include/tirpc -Wno-error=implicit-int"
````

因为scripts/gnu-os比较旧，不支持riscv，需要用新的config.guess替换scripts/gnu-os

````
$ wget https://git.savannah.gnu.org/cgit/config.git/plain/config.guess
$ cp -f config.guess scripts/gnu-os
````

gcc编译并执行测试

````
$ yum install -y libtirpc-devel gcc make
$ make results
````

clang 编译并执行测试

````
$ yum install -y libtirpc-devel clang make
$ make CC=clang results
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

Memory: 设置测试内存大小，默认是$MB, 即为程序计算出来的最大可测试内存，也可以手动定义测试值，这里设置为4096

````
=====================================================================

Hang on, we are calculating your timing granularity.
OK, it looks like you can time stuff down to 50000 usec resolution.

Hang on, we are calculating your timing overhead.
OK, it looks like your gettimeofday() costs 0 usecs.

Hang on, we are calculating your loop overhead.
OK, it looks like your benchmark loop costs 0.00000000 usecs.

=====================================================================

Several benchmarks operate on a range of memory.  This memory should be
sized such that it is at least 4 times as big as the external cache[s]
on your system.   It should be no more than 80% of your physical memory.

The bigger the range, the more accurate the results, but larger sizes
take somewhat longer to run the benchmark.

MB [default 5548]: 4096
Checking to see if you have 5548 MB; please wait for a moment...
4096MB OK
4096MB OK
4096MB OK
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

        3210 MHz, 0.3115 nanosec clock

but I am frequently wrong.  If that is the wrong Mhz, type in your
best guess as to your processor speed.  It doesn't have to be exact,
but if you know it is around 800, say 800.  

Please note that some processors, such as the P4, have a core which
is double-clocked, so on those processors the reported clock speed
will be roughly double the advertised clock rate.  For example, a
1.8GHz P4 may be reported as a 3592MHz processor.

Processor mhz [default 3210 MHz, 0.3115 nanosec clock]: 3210
=====================================================================
````

FSDIR [default /usr/tmp]: 临时目录用来存放测试文件，可以自己设定，默认/usr/tmp，这里设置为默认值

````
=====================================================================

We need a place to store a 5548 Mbyte file as well as create and delete a
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

Confguration done, thanks.

There is a mailing list for discussing lmbench hosted at BitMover. 
Send mail to majordomo@bitmover.com to join the list.

Using config in CONFIG.openeuler-riscv64
Sun May 12 08:42:09 PM CST 2024
Latency measurements
Sun May 12 08:43:35 PM CST 2024
Calculating file system latency
Sun May 12 08:43:37 PM CST 2024
Local networking
Sun May 12 08:44:58 PM CST 2024
Bandwidth measurements
Sun May 12 08:48:05 PM CST 2024
Calculating context switch overhead
Sun May 12 08:48:25 PM CST 2024
Calculating effective TLB size
Sun May 12 08:48:29 PM CST 2024
Calculating memory load parallelism
Sun May 12 08:51:29 PM CST 2024
McCalpin's STREAM benchmark
Sun May 12 08:51:56 PM CST 2024
Calculating memory load latency
Sun May 12 09:04:25 PM CST 2024
make[1]: Leaving directory '/root/lmbench-3.0-a9/src'
````

执行命令查看运行结果

````
$ make see
cd results && make summary >summary.out 2>summary.errs 
cd results && make percent >percent.out 2>percent.errs
````

运行结果输出到当前目录下的 results/summary.out

````
$ cat results/summary.out
make[1]: Entering directory '/root/lmbench-3.0-a9/results'

                 L M B E N C H  3 . 0   S U M M A R Y
                 ------------------------------------
                 (Alpha software, do not distribute)

Basic system parameters
------------------------------------------------------------------------------
Host                 OS Description              Mhz  tlb  cache  mem   scal
                                                     pages line   par   load
                                                           bytes
--------- ------------- ----------------------- ---- ----- ----- ------ ----
openeuler Linux 6.6.0-1       riscv64-linux-gnu 1996          64 6.9500    1
openeuler Linux 6.6.0-1       riscv64-linux-gnu 1996    16    64 6.9700    1

Processor, Processes - times in microseconds - smaller is better
------------------------------------------------------------------------------
Host                 OS  Mhz null null      open slct sig  sig  fork exec sh
                             call  I/O stat clos TCP  inst hndl proc proc proc
--------- ------------- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
openeuler Linux 6.6.0-1 1996 0.36 0.70 8.38 18.0 14.9 0.86 7.06 3531 11.K 17.K
openeuler Linux 6.6.0-1 1996 0.35 0.70 8.12 18.1 11.6 0.86 6.98 3620 11.K 16.K

Basic integer operations - times in nanoseconds - smaller is better
-------------------------------------------------------------------
Host                 OS  intgr intgr  intgr  intgr  intgr
                          bit   add    mul    div    mod
--------- ------------- ------ ------ ------ ------ ------
openeuler Linux 6.6.0-1 0.4200 0.5100 2.0200 3.0300 3.1100
openeuler Linux 6.6.0-1 0.3800 0.5000 2.0200 3.0100 3.1300

Basic uint64 operations - times in nanoseconds - smaller is better
------------------------------------------------------------------
Host                 OS int64  int64  int64  int64  int64
                         bit    add    mul    div    mod
--------- ------------- ------ ------ ------ ------ ------
openeuler Linux 6.6.0-1  0.390        2.0300 3.0200 3.1300
openeuler Linux 6.6.0-1  0.390        2.0200 3.0200 3.1300

Basic float operations - times in nanoseconds - smaller is better
-----------------------------------------------------------------
Host                 OS  float  float  float  float
                         add    mul    div    bogo
--------- ------------- ------ ------ ------ ------
openeuler Linux 6.6.0-1 1.5100 2.0100 7.0300 6.0700
openeuler Linux 6.6.0-1 1.5000 2.0100 7.0300 6.0400

Basic double operations - times in nanoseconds - smaller is better
------------------------------------------------------------------
Host                 OS  double double double double
                         add    mul    div    bogo
--------- ------------- ------  ------ ------ ------
openeuler Linux 6.6.0-1 1.5000 2.0100   10.5 9.5800
openeuler Linux 6.6.0-1 1.5100 2.0100   10.6 9.5900

Context switching - times in microseconds - smaller is better
-------------------------------------------------------------------------
Host                 OS  2p/0K 2p/16K 2p/64K 8p/16K 8p/64K 16p/16K 16p/64K
                         ctxsw  ctxsw  ctxsw ctxsw  ctxsw   ctxsw   ctxsw
--------- ------------- ------ ------ ------ ------ ------ ------- -------
openeuler Linux 6.6.0-1   23.2   22.2   24.3   11.2   11.5    12.3    18.6
openeuler Linux 6.6.0-1   23.0   20.9   22.0   13.6   10.1    10.2    13.7

*Local* Communication latencies in microseconds - smaller is better
---------------------------------------------------------------------
Host                 OS 2p/0K  Pipe AF     UDP  RPC/   TCP  RPC/ TCP
                        ctxsw       UNIX         UDP         TCP conn
--------- ------------- ----- ----- ---- ----- ----- ----- ----- ----
openeuler Linux 6.6.0-1  23.2  53.3 92.0 105.8 127.7 131.5 154.8 295.
openeuler Linux 6.6.0-1  23.0  53.5 94.9 112.1 139.4 123.6 160.3 306.

*Remote* Communication latencies in microseconds - smaller is better
---------------------------------------------------------------------
Host                 OS   UDP  RPC/  TCP   RPC/ TCP
                               UDP         TCP  conn
--------- ------------- ----- ----- ----- ----- ----
openeuler Linux 6.6.0-1
openeuler Linux 6.6.0-1

File & VM system latencies in microseconds - smaller is better
-------------------------------------------------------------------------------
Host                 OS   0K File      10K File     Mmap    Prot   Page   100fd
                        Create Delete Create Delete Latency Fault  Fault  selct
--------- ------------- ------ ------ ------ ------ ------- ----- ------- -----
openeuler Linux 6.6.0-1   79.0   61.2  157.4   91.9         0.866         5.259
openeuler Linux 6.6.0-1   76.9   60.1  148.0   89.6   15.1K 1.085 1.24430 5.265

*Local* Communication bandwidths in MB/s - bigger is better
-----------------------------------------------------------------------------
Host                OS  Pipe AF    TCP  File   Mmap  Bcopy  Bcopy  Mem   Mem
                             UNIX      reread reread (libc) (hand) read write
--------- ------------- ---- ---- ---- ------ ------ ------ ------ ---- -----
openeuler Linux 6.6.0-1 743. 1632 701. 2078.9 5691.3 3204.6 3169.7 6299 3014.
openeuler Linux 6.6.0-1 725. 1530 741. 2142.3 5508.9 3406.5 3564.4 6340 3039.

Memory latencies in nanoseconds - smaller is better
    (WARNING - may not be correct, check graphs)
------------------------------------------------------------------------------
Host                 OS   Mhz   L1 $   L2 $    Main mem    Rand mem    Guesses
--------- -------------   ---   ----   ----    --------    --------    -------
openeuler Linux 6.6.0-1  1996     -      -           -    Bad mhz?
openeuler Linux 6.6.0-1  1996 1.5040 6.5540        24.1       188.1
make[1]: Leaving directory '/root/lmbench-3.0-a9/results'
````

#### 4. stream

下载源码

````
$ wget https://www.cs.virginia.edu/stream/FTP/Code/stream.c
````

gcc 编译

````
$ yum install -y gcc
$ gcc -O3 -fopenmp -DSTREAM_ARRAY_SIZE=35000000 -DNTIMES=50 stream.c -o stream_o3
````

clang 编译

````
$ yum install -y clang
$ clang -O3 -fopenmp -DSTREAM_ARRAY_SIZE=35000000 -DNTIMES=50 stream.c -o stream_o3
````

执行测试

````
$ ./stream_o3
````

测试结果

````
$ ./stream_o3 
-------------------------------------------------------------
STREAM version $Revision: 5.10 $
-------------------------------------------------------------
This system uses 8 bytes per array element.
-------------------------------------------------------------
Array size = 35000000 (elements), Offset = 0 (elements)
Memory per array = 267.0 MiB (= 0.3 GiB).
Total memory required = 801.1 MiB (= 0.8 GiB).
Each kernel will be executed 50 times.
 The *best* time for each kernel (excluding the first iteration)
 will be used to compute the reported bandwidth.
-------------------------------------------------------------
Number of Threads requested = 8
Number of Threads counted = 8
-------------------------------------------------------------
Your clock granularity/precision appears to be 1 microseconds.
Each test below will take on the order of 122285 microseconds.
   (= 122285 clock ticks)
Increase the size of the arrays if this shows that
you are not getting at least 20 clock ticks per test.
-------------------------------------------------------------
WARNING -- The above is only a rough guideline.
For best results, please be sure you know the
precision of your system timer.
-------------------------------------------------------------
Function    Best Rate MB/s  Avg time     Min time     Max time
Copy:           42061.0     0.019890     0.013314     0.026418
Scale:          13360.4     0.071510     0.041915     0.116255
Add:            17766.8     0.085299     0.047279     0.153221
Triad:          12140.1     0.111079     0.069192     0.183258
-------------------------------------------------------------
Solution Validates: avg error less than 1.000000e-13 on all three arrays
-------------------------------------------------------------
````

#### 5. ltp stress

安装依赖包

````
$ yum install -y git make automake gcc clang pkgconf autoconf bison flex m4 kernel-headers glibc-headers clang findutils libtirpc libtirpc-devel pkg-config sysstat
````

下载 ltp

````
$ git clone https://github.com/linux-test-project/ltp.git
````

获取 ltpstress.sh，并将相关文件复制到 ltp 相应目录下

````
$ wget https://github.com/linux-test-project/ltp/archive/refs/tags/20180515.zip
$ unzip 20180515.zip
$ cp ltp-20180515/testscripts/ltpstress.sh ltp/testscripts/
$ cp ltp-20180515/runtest/stress.part* ltp/runtest/
````

gcc 编译安装

````
$ cd ltp
$ make autotools
$ ./configure
$ make -j $(nproc)
$ make install
````

clang编译安装

````
$ cd ltp
$ export CFLAGS="-Wno-error=implicit-function-declaration"
$ make autotools
$ CC=clang ./configure
$ make -j $(nproc)
$ make install
````

执行测试

执行7天*24小时的压力测试

````
$ cd /opt/ltp/testscripts
$ ./ltpstress.sh -n -m 512 -t 168
````

测试结果默认存储在 /tmp/ 目录下，还可以指定生成日志文件的格式和路径

````
$ mkdir -p /opt/ltp/output
$ ./ltpstress.sh -i 3600 -d /opt/ltp/output/ltpstress.data -I /opt/ltp/output/ltpstress.iodata -l /opt/ltp/output/ltpstress.log -n -p -S -m 512 -t 168
````

参数:

-n：不对网络进行压力测试

-p：人为指定日志格式,保证日志为可读格式

-S：用sar捕捉数据

-m：指定最小的内存使用

-t：指定测试时间，单位是小时，最小值1

-d：指定 sar 记录的文件目录(/opt/ltp/output/ltpstress.data)

-i：使用 sar 记录系统活动的时间间隔，默认10s，即每10s记录一次系统活动

-I：记录 "iostat" 结果到指定文件iofile(/opt/ltp/output/ltpstress.iodata)

-l：记录测试结果到指定文件(/opt/ltp/output/ltpstress.log)

具体参数说明可以参看 ltpstress.sh 内容

````
usage()
{

	cat <<-END >&2
    usage: ${0##*/} [ -d datafile ] [ -i # (in seconds) ] [ -I iofile ] [ -l logfile ] [ -m # (in Mb) ]
    [ -n ] [ -p ] [ -q ] [ -t duration ] [ -x TMPDIR ] [-b DEVICE] [-B LTP_DEV_FS_TYPE] [ [-S]|[-T] ]

    -d datafile     Data file for 'sar' or 'top' to log to. Default is "/tmp/ltpstress.data".
    -i # (in sec)   Interval that 'sar' or 'top' should take snapshots. Default is 10 seconds.
    -I iofile       Log results of 'iostat' to a file every interval. Default is "/tmp/ltpstress.iodata".
    -l logfile      Log results of test in a logfile. Default is "/tmp/ltpstress.log"
    -m # (in Mb)    Specify the _minimum_ memory load of # megabytes in background. Default is all the RAM + 1/2 swap.
    -n              Disable networking stress.
    -p              Human readable format logfiles.
    -q              Print less verbose output to the output files.
    -S              Use 'sar' to measure data.
    -T              Use LTP's modified 'top' tool to measure data.
    -t duration     Execute the testsuite for given duration in hours. Default is 24.
    -x TMPDIR       Directory where temporary files will be created.
    -b DEVICE       Some tests require an unmounted block device
                    to run correctly. If DEVICE is not set, a loop device is
                    created and used automatically.
    -B LTP_DEV_FS_TYPE The file system of DEVICE.

	example: ${0##*/} -d /tmp/sardata -l /tmp/ltplog.$$ -m 128 -t 24 -S
	END
exit
}
````

测试完成后，测试结果在 ltp 目录下的 output 目录下

ltpstress.log：记录相关日志信息，主要是测试是否通过(pass or fail)

ltpstress.data：sar工具记录的日志文件，包括cpu,memory,i/o等

要查看 ltpstress.data，要在测试设备上安装 sysstat后，执行 sar 命令查看

````
$ yum install sysstat
$ sar -u -f ltpstress.data     //cpu平均使用率
$ sar -r -f ltpstress.data     //memory平均使用率
````

如果要将 ltpstress.log 里所有 FAIL 过滤出来，得到完整的所有 FAIL 的 testcases，用 sort 把 FAIL 的项排序，再用uniq排除重复项输出到一个文件就可以了

````
$ grep FAIL ltpstress.log | sort | uniq >failcase.txt
````

这样得到的 failcase.txt 为所有 FAIL 的 testcases 名字

#### 6. iozone

从 [iozone 官网](https://gitee.com/link?target=https%3A%2F%2Fwww.iozone.org%2F)下载源码

````
$ wget https://www.iozone.org/src/current/iozone3_506.tar
$ tar -xvf iozone3_506.tar
$ cd iozone3_506/src/current
````

gcc 编译并安装

````
$ make clean && make CFLAGS=-fcommon linux
````

clang编译并安装

````
$ make clean && make CC=clang CFLAGS=-fcommon linux
````

执行测试

````
$ ./iozone -Rab iozone-output.xls
````

-a：执行全面测试

-R：产生execl格式的输出日志

-b：指定输出到指定文件上

#### 7. libmicro

下载 libmicro 源码，并解压

````
$ wget https://github.com/redhat-performance/libMicro/archive/refs/heads/0.4.0-rh.zip   //下载0.4.0-rh分支
$ unzip 0.4.0-rh.zip
$ cd libMicro-0.4.0-rh
````

gcc 编译

````
$ make
````

clang 编译

````
$ make CC=clang CFLAGS="-Wno-error=implicit-function-declaration"
````

执行测试

````
$ ./bench | tee output.log
````

或者

````
$ sh bench.sh | tee output.log
````

#### 8. fio

安装 fio

````
$ yum install -y fio
````

下载 LLVM 平行宇宙项目 preview 版本 iso 镜像作为测试文件

````
$ wget https://repo.openeuler.org/openEuler-preview/openEuler-24.03-LLVM-Preview/ISO/riscv64/openEuler-24.03-LLVM-riscv64-dvd.iso
````

创建 fio-test.sh 测试脚本

````
#!/bin/bash

filename=openEuler-24.03-LLVM-riscv64-dvd.iso
numjobs=10
iodepth=10
for rw in read write randread randwrite randrw;do
    for bs in 4 16 32 64 128 256 512 1024;do
        if [ ${rw} == "randrw" ];then
            fio -filename=${filename} -direct=1 -iodepth ${iodepth} -thread -rw=${rw} -rwmixread=70 -ioengine=libaio -bs=${bs}k -size=1G -numjobs=${numjobs} -runtime=30 -group_reporting -name=${rw}-${bs}k
        else
            fio -filename=${filename} -direct=1 -iodepth ${iodepth} -thread -rw=${rw} -ioengine=libaio -bs=${bs}k -size=1G -numjobs=${numjobs} -runtime=30 -group_reporting -name=${rw}-${bs}k
        fi
        sleep 5
    done
done
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

filename: 测试对象，可以是设备名称或者文件地址，例如 /dev/sda或者/root/test/openEuler-24.03-LLVM-riscv64-dvd.iso

运行该脚本执行测试

````
$ bash fio-test.sh | tee fio-test.log
````

#### 9. netperf

需要处在同一网络中的两台设备，分别作为 server 和 client

##### 9.1 server 端

安装 netperf

````
$ yum install -y netperf
````

在server端执行命令运行netserver，命令中用-p指定监听端口为10000

````
$ netserver -p 10000
Starting netserver with host 'IN(6)ADDR_ANY' port '10000' and family AF_UNSPEC
````

##### 9.2 client 端

安装 netperf

````
$ yum install -y netperf
````

创建 netperf-test.sh 测试脚本

````
#!/bin/bash

host_ip=$1
port=$2
for i in 1 64 512 65536;do
    netperf -t TCP_STREAM -H $host_ip -p $port -l 60 -- -m $i
done

for i in 1 64 128 256 512 32768;do
    netperf -t UDP_STREAM -H $host_ip -p $port -l 60 -- -m $i
done

netperf -t TCP_RR -H $host_ip -p $port
netperf -t TCP_CRR -H $host_ip -p $port
netperf -t UDP_RR -H $host_ip -p $port
````

参数说明：

-t：指定测试类型，如果不指定，预设值是TCP_STREAM

-H：指定运行netserver的server端IP地址

-p：指定监听端口，和netserver端保持一致，如果不指定，预设值是12865

-l：指定测试时间长度，单位：秒，如果不指定，预设值是10秒

-m：发送消息大小，单位为bytes

运行该脚本执行测试

````
$ bash netperf-test.sh ${server_ip} ${server_port} | tee netperf.log
````

`${server_ip}` 和 `${server_port}` 分别是 server 端的 ip 和 port，例如 bash netperf-test.sh 10.0.0.2 10000 | tee netperf.log

#### 10. Trinity

##### 10.1 安装编译所需依赖包

````
$ yum install -y gcc make
````

##### 10.2 下载 trinity 源码

````
$ git clone https://github.com/kernelslacker/trinity.git
$ cd trinity
````

##### 10.3 编译安装

###### 10.3.1 gcc 编译安装

````
$ ./configure
$ make
$ make install
````

###### 10.3.2 clang 编译安装

修改 Makefile：

将第8行 CC := gcc 改为 CC := clang

在第33行后面增加一行 CFLAGS += "-Wno-error=implicit-function-declaration"

````
VERSION="2023.01"

INSTALL_PREFIX ?= $(DESTDIR)
INSTALL_PREFIX ?= $(HOME)
NR_CPUS := $(shell grep -c ^processor /proc/cpuinfo)

ifeq ($(CC),"")
CC := clang
endif
CC := $(CROSS_COMPILE)$(CC)
LD := $(CROSS_COMPILE)$(LD)

CFLAGS ?= -g -O2 -D_FORTIFY_SOURCE=2
CFLAGS += -Wall -Wextra -I. -Iinclude/ -include config.h -Wimplicit -D_GNU_SOURCE -D__linux__

CCSTD := $(shell if $(CC) -std=gnu11 -S -o /dev/null -xc /dev/null >/dev/null 2>&1; then echo "-std=gnu11"; else echo "-std=gnu99"; fi)
CFLAGS += $(CCSTD)

ifneq ($(SYSROOT),)
CFLAGS += --sysroot=$(SYSROOT)
endif
#CFLAGS += $(shell if $(CC) -m32 -S -o /dev/null -xc /dev/null >/dev/null 2>&1; then echo "-m32"; fi)
CFLAGS += -Wformat=2
CFLAGS += -Winit-self
CFLAGS += -Wnested-externs
CFLAGS += -Wpacked
CFLAGS += -Wshadow
CFLAGS += -Wswitch-enum
CFLAGS += -Wundef
CFLAGS += -Wwrite-strings
CFLAGS += -Wno-format-nonliteral
CFLAGS += -Wstrict-prototypes -Wmissing-prototypes
CFLAGS += -fsigned-char
CFLAGS += "-Wno-error=implicit-function-declaration"
# BPF spew.
CFLAGS += -Wno-missing-field-initializers

# needed for show_backtrace() to work correctly.
LDFLAGS += -rdynamic

# glibc versions before 2.17 for clock_gettime
LDLIBS += -lrt

# gcc only.
ifneq ($(shell $(CC) -v 2>&1 | grep -c "clang"), 1)
CFLAGS += -Wlogical-op
CFLAGS += -Wstrict-aliasing=3
endif

# Sometimes useful for debugging. more useful with clang than gcc.
#CFLAGS += -fsanitize=address

V	= @
Q	= $(V:1=)
QUIET_CC = $(Q:@=@echo    '  CC	'$@;)


all: trinity

test:
	@if [ ! -f config.h ]; then  echo "[1;31mRun configure.sh first.[0m" ; exit; fi


MACHINE		:= $(shell $(CC) -dumpmachine)
SYSCALLS_ARCH	:= $(shell case "$(MACHINE)" in \
		   (sh*) echo syscalls/sh/*.c ;; \
		   (ia64*) echo syscalls/ia64/*.c ;; \
		   (ppc*|powerpc*) echo syscalls/ppc/*.c ;; \
		   (sparc*) echo syscalls/sparc/*.c ;; \
		   (x86_64*) echo syscalls/x86/*.c \
				  syscalls/x86/i386/*.c \
				  syscalls/x86/x86_64/*.c;; \
		   (i?86*) echo syscalls/x86/*.c \
				syscalls/x86/i386/*.c;; \
		   (s390x*) echo syscalls/s390x/*.c ;; \
		   esac)

VERSION_H	:= include/version.h

HEADERS		:= $(patsubst %.h,%.h,$(wildcard *.h)) $(patsubst %.h,%.h,$(wildcard syscalls/*.h)) $(patsubst %.h,%.h,$(wildcard ioctls/*.h))

SRCS		:= $(wildcard *.c) \
		   $(wildcard fds/*.c) \
		   $(wildcard ioctls/*.c) \
		   $(wildcard mm/*.c) \
		   $(wildcard net/*.c) \
		   $(wildcard rand/*.c) \
		   $(wildcard syscalls/*.c) \
		   $(SYSCALLS_ARCH)

OBJS		:= $(sort $(patsubst %.c,%.o,$(wildcard *.c))) \
		   $(sort $(patsubst %.c,%.o,$(wildcard fds/*.c))) \
		   $(sort $(patsubst %.c,%.o,$(wildcard ioctls/*.c))) \
		   $(sort $(patsubst %.c,%.o,$(wildcard mm/*.c))) \
		   $(sort $(patsubst %.c,%.o,$(wildcard net/*.c))) \
		   $(sort $(patsubst %.c,%.o,$(wildcard rand/*.c))) \
		   $(sort $(patsubst %.c,%.o,$(wildcard syscalls/*.c))) \
		   $(sort $(patsubst %.c,%.o,$(SYSCALLS_ARCH)))

DEPDIR= .deps

-include $(SRCS:%.c=$(DEPDIR)/%.d)

$(VERSION_H): scripts/gen-versionh.sh Makefile $(wildcard .git)
	@scripts/gen-versionh.sh

trinity: test $(OBJS) $(HEADERS)
	$(QUIET_CC)$(CC) $(CFLAGS) $(LDFLAGS) -o trinity $(OBJS) $(LDLIBS)
	@mkdir -p tmp

df = $(DEPDIR)/$(*D)/$(*F)

%.o : %.c | $(VERSION_H)
	$(QUIET_CC)$(CC) $(CFLAGS) -o $@ -c $<
	@mkdir -p $(DEPDIR)/$(*D)
	@$(CC) -MM $(CFLAGS) $*.c > $(df).d
	@mv -f $(df).d $(df).d.tmp
	@sed -e 's|.*:|$*.o:|' <$(df).d.tmp > $(df).d
	@sed -e 's/.*://' -e 's/\\$$//' < $(df).d.tmp | fmt -1 | \
	  sed -e 's/^ *//' -e 's/$$/:/' >> $(df).d
	@rm -f $(df).d.tmp

clean:
	@rm -f $(OBJS)
	@rm -f core.*
	@rm -f trinity
	@rm -f tags
	@rm -rf $(DEPDIR)/*
	@rm -rf trinity-coverity.tar.xz cov-int
	@rm -f $(VERSION_H)

tag:
	@git tag -a v$(VERSION) -m "$(VERSION) release."

tarball:
	@git archive --format=tar --prefix=trinity-$(VERSION)/ HEAD > trinity-$(VERSION).tar
	@xz -9 trinity-$(VERSION).tar

install: trinity
	install -d -m 755 $(INSTALL_PREFIX)/bin
	install trinity $(INSTALL_PREFIX)/bin

tags:	$(SRCS)
	@ctags -R --exclude=tmp

scan:
	@scan-build --use-analyzer=/usr/bin/clang make -j $(NR_CPUS)

coverity:
	@rm -rf cov-int trinity-coverity.tar.xz
	@cov-build --dir cov-int make -j $(NR_CPUS)
	@tar cJvf trinity-coverity.tar.xz cov-int

cppcheck:
	@scripts/cppcheck.sh
````

编译并安装

````
$ ./configure
$ make
$ make install
````

##### 10.4 执行测试

设置 trinity 文件夹及其下所有文件和子目录权限为 777

````
$ cd ..
$ chmod 777 -R trinity
````

由于 Trinity 不能以 root 身份运行，所以需要创建一个非root的新用户

````
$ useradd test    //创建用户test
$ passwd test     //设置用户test密码
$ su test         //切换到用户test
````

执行测试，命令参数

````
$ ./trinity --help
Trinity 2023.01  Dave Jones <davej@codemonkey.org.uk>
shm:0x3fa3efd000-0x3fb0ad9d08 (4 pages)
./trinity
 --arch, -a: selects syscalls for the specified architecture (32 or 64). Both by default.
 --bdev, -b <node>:  Add /dev node to list of block devices to use for destructive tests..
 --children,-C: specify number of child processes
 --debug,-D: enable debug
 --dropprivs, -X: if run as root, switch to nobody [EXPERIMENTAL]
 --exclude,-x: don't call a specific syscall
 --enable-fds/--disable-fds= {sockets,pipes,perf,epoll,eventfd,pseudo,timerfd,testfile,memfd,drm}
 --ftrace-dump-file: specify file that ftrace buffer gets dumped to if kernel becomes tainted.
 --group,-g = {vfs,vm}: only run syscalls from a certain group.
 --ioctls,-I: list all ioctls.
 --kernel_taint, -T: controls which kernel taint flags should be considered, for more details refer to README file. 
 --list,-L: list all syscalls known on this architecture.
 --logging,-l [off, <dir>, <hostname>] : disable logging to files, log to a directory, or log over udp to a remote trinity server.
 --domain,-P: specify specific network domain for sockets.
 --no_domain,-E: specify network domains to be excluded from testing.
 --quiet,-q: less output.
 --random,-r#: pick N syscalls at random and just fuzz those
 --stats: show errno distribution per syscall before exiting
 --syslog,-S: log important info to syslog. (useful if syslog is remote)
 --verbose,-v: increase output verbosity.
 --victims,-V: path to victim files.

 -c#,@: target specific syscall (takes syscall name as parameter and optionally 32 or 64 as bit-width. Default:both).
 -N#: do # syscalls then exit.
 -s#: use # as random seed.
````

执行测试，设置测试时内存限制为10GB

````
$ ./trinity -N 10000 | tee output.log
````











