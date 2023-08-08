### openEuler riscv64中使用Unixbench进行综合性能测试

#### 1. unixbench介绍

unixbench是一个用于测试unix性能的开源工具，也是一个比较通用的benchmark, 测试包含了系统调用、读写、进程、管道、运算、C库等系统基本性能，以及一些简单的2D，3D图形测试。

##### 1.1 系统测试项目

| 测试项目                                                  | 项目说明                                                     |
| --------------------------------------------------------- | ------------------------------------------------------------ |
| Dhrystone测试                                             | 测试聚焦在字符串处理，没有浮点运算操作。这个测试用于测试链接器编译、代码优化、内存缓存、等待状态、整数数据类型等，硬件和软件设计都会非常大的影响测试结果。 |
| Whetstone测试                                             | 这项测试项目用于测试浮点运算效率和速度。这项测试项目包含若干个科学计算的典型性能模块，包含大量的C语言函数,sin cos sqrt exp和日志以及使用整数和浮点的数学操作。包含数组访问、条件分支和过程调用。 |
| Execl Throughput测试                                      | 这项测试测试每秒execl函数调用次数。execl是 exec函数家族的一部分，使用新的图形处理代替当前的图形处理。有许多命令和前端的execve()函数命令非常相似。（execl 吞吐，这里的execl是类unix系统非常重要的函数，非办公软件的excel） |
| File Copy测试                                             | 这项测试衡量文件数据从一个文件被传输到另外一个，使用大量的缓存。包括文件的读、写、复制测试，测试指标是一定时间内（默认是10秒）被重写、读、复制的字符数量。 |
| Pipe Throughput（管道吞吐）测试                           | pipe是简单的进程之间的通讯。管道吞吐测试是测试在一秒钟一个进程写512比特到一个管道中并且读回来的次数。管道吞吐测试和实际编程有差距。 |
| Pipe-based Context Switching （基于管道的上下文交互）测试 | 这项测试衡量两个进程通过管道交换和整数倍的增加吞吐的次数。基于管道的上下文切换和真实程序很类似。测试程序产生一个双向管道通讯的子线程。 |
| Process Creation(进程创建)测试                            | 这项测试衡量一个进程能产生子线程并且立即退出的次数。新进程真的创建进程阻塞和内存占用，所以测试程序直接使用内存带宽。这项测试用于典型的比较大量的操作系统进程创建操作。 |
| Shell Scripts测试                                         | shell脚本测试用于衡量在一分钟内，一个进程可以启动并停止shell脚本的次数，通常会测试1，2， 3， 4， 8 个shell脚本的共同拷贝，shell脚本是一套转化数据文件的脚本。 |
| System Call Overhead （系统调用消耗）测试                 | 这项测试衡量进入和离开系统内核的消耗，例如，系统调用的消耗。程序简单重复的执行getpid调用（返回调用的进程id）。消耗的指标是调用进入和离开内核的执行时间。 |
| Graphical Tests（图形）测试                               | 由”ubgears”程序组成，测试非常粗的2D和3D图形性能，尤其是3D测试非常有限。测试结果和硬件，系统合适的驱动关系很大。 |

##### 1.2 图像测试

由”ubgears”程序组成，提供了2D和3D图形测试，测试非常粗的2D和3D图形性能，尤其是3D测试非常有限。这些测试的目的是为系统的2D和3D图形性能提供一个非常粗略的概念。测试结果和硬件，系统合适的驱动关系很大。

#### 2. 在openEuler riscv64中使用Unixbench

执行unixbench的环境是D1开发板烧入openEuler riscv64 22.03 v2 xfce版本 https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-22.03-V2-riscv64/D1/ ，由于需要测试图形化性能，所以需要xfce版本

##### 2.1 安装编译

查看D1 CPU信息

````
$ cat /proc/cpuinfo
processor   : 0
hart        : 0
isa     : rv64imafdc
mmu     : sv39
uarch       : thead,c906
````

从github上获取Unixbench源码, 并修改Makefile

````
$ git clone https://github.com/kdlucas/byte-unixbench.git
$ cd byte-unixbench/UnixBench
$ vim Makefile
````

将其中第98行 OPTON += -march=native -mtune=native 改为 OPTON += -march=rv64imafdc

````
## OS detection.  Comment out if gmake syntax not supported by other 'make'.
  OSNAME:=$(shell uname -s)
  ARCH := $(shell uname -p)
  ifeq ($(OSNAME),Linux)
    # Not all CPU architectures support "-march" or "-march=native".
    #   - Supported    : x86, x86_64, ARM, AARCH64, etc..
    #   - Not Supported: RISC-V, IBM Power, etc...
    ifneq ($(ARCH),$(filter $(ARCH),ppc64 ppc64le))
        OPTON += -march=rv64imafdc
    else
        OPTON += -mcpu=native -mtune=native
    endif
  endif
````

由于要测试图形性能，将其中第49行 # GRAPHIC_TESTS = defined 前面的 # 去掉，改成 GRAPHIC_TESTS = defined

````
# Comment the line out to disable these tests.
GRAPHIC_TESTS = defined
````

修改完成后保存退出，执行 make 编译

````
$ make
````

##### 2.2 执行测试

命令Run的用法

Run [ -q | -v ] [-i <n> ] [-c <n> [-c <n> ...]] [test ...]

-q 运行quiet模式，不显示测试过程

-v 运行vobose模式，显示测试过程

-i <count> 执行次数，最低3次，默认10次

-c <n> 每次测试并行n个copies(并行任务)

例如：./Run -c 1 -c 4 表示执行2次，第一次执行单任务，第二次并行执行4个任务

测试结果

````
------------------------------------------------------------------------
Benchmark Run: Fri Jan 02 1970 16:38:53 - 17:07:10
1 CPU in system; running 1 parallel copy of tests

Dhrystone 2 using register variables        3149359.5 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     1123.8 MWIPS (10.0 s, 7 samples)
Execl Throughput                                188.1 lps   (29.9 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks         47675.3 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks           13168.7 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks        126604.7 KBps  (30.0 s, 2 samples)
Pipe Throughput                              107557.3 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                  25552.5 lps   (10.0 s, 7 samples)
Process Creation                                466.2 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                    302.4 lpm   (60.1 s, 2 samples)
Shell Scripts (8 concurrent)                     40.4 lpm   (60.9 s, 2 samples)
System Call Overhead                         161768.6 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0    3149359.5    269.9
Double-Precision Whetstone                       55.0       1123.8    204.3
Execl Throughput                                 43.0        188.1     43.7
File Copy 1024 bufsize 2000 maxblocks          3960.0      47675.3    120.4
File Copy 256 bufsize 500 maxblocks            1655.0      13168.7     79.6
File Copy 4096 bufsize 8000 maxblocks          5800.0     126604.7    218.3
Pipe Throughput                               12440.0     107557.3     86.5
Pipe-based Context Switching                   4000.0      25552.5     63.9
Process Creation                                126.0        466.2     37.0
Shell Scripts (1 concurrent)                     42.4        302.4     71.3
Shell Scripts (8 concurrent)                      6.0         40.4     67.3
System Call Overhead                          15000.0     161768.6    107.8
                                                                   ========
System Benchmarks Index Score                                          94.9

------------------------------------------------------------------------
Benchmark Run: Fri Jan 02 1970 17:07:10 - 17:36:01
1 CPU in system; running 4 parallel copies of tests

Dhrystone 2 using register variables        3103564.9 lps   (10.2 s, 7 samples)
Double-Precision Whetstone                     1123.8 MWIPS (10.0 s, 7 samples)
Execl Throughput                                186.9 lps   (29.7 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks         46170.3 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks           12987.4 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks        127121.9 KBps  (30.0 s, 2 samples)
Pipe Throughput                              105791.1 lps   (10.1 s, 7 samples)
Pipe-based Context Switching                  16884.7 lps   (10.2 s, 7 samples)
Process Creation                                450.4 lps   (30.2 s, 2 samples)
Shell Scripts (1 concurrent)                    296.4 lpm   (60.7 s, 2 samples)
Shell Scripts (8 concurrent)                     37.3 lpm   (64.4 s, 2 samples)
System Call Overhead                         156047.6 lps   (10.1 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0    3103564.9    265.9
Double-Precision Whetstone                       55.0       1123.8    204.3
Execl Throughput                                 43.0        186.9     43.5
File Copy 1024 bufsize 2000 maxblocks          3960.0      46170.3    116.6
File Copy 256 bufsize 500 maxblocks            1655.0      12987.4     78.5
File Copy 4096 bufsize 8000 maxblocks          5800.0     127121.9    219.2
Pipe Throughput                               12440.0     105791.1     85.0
Pipe-based Context Switching                   4000.0      16884.7     42.2
Process Creation                                126.0        450.4     35.7
Shell Scripts (1 concurrent)                     42.4        296.4     69.9
Shell Scripts (8 concurrent)                      6.0         37.3     62.1
System Call Overhead                          15000.0     156047.6    104.0
                                                                   ========
System Benchmarks Index Score                                          89.8
````

执行系统测试

````
$ ./Run
````

测试结果

````
------------------------------------------------------------------------
Benchmark Run: Fri Jan 02 1970 18:15:33 - 18:43:50
1 CPU in system; running 1 parallel copy of tests

Dhrystone 2 using register variables        3154959.6 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     1124.3 MWIPS (10.0 s, 7 samples)
Execl Throughput                                187.7 lps   (29.9 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks         45339.3 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks           13099.9 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks        129634.1 KBps  (30.0 s, 2 samples)
Pipe Throughput                              109113.7 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                  25398.2 lps   (10.0 s, 7 samples)
Process Creation                                462.4 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                    302.1 lpm   (60.2 s, 2 samples)
Shell Scripts (8 concurrent)                     40.2 lpm   (61.1 s, 2 samples)
System Call Overhead                         162746.0 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0    3154959.6    270.3
Double-Precision Whetstone                       55.0       1124.3    204.4
Execl Throughput                                 43.0        187.7     43.7
File Copy 1024 bufsize 2000 maxblocks          3960.0      45339.3    114.5
File Copy 256 bufsize 500 maxblocks            1655.0      13099.9     79.2
File Copy 4096 bufsize 8000 maxblocks          5800.0     129634.1    223.5
Pipe Throughput                               12440.0     109113.7     87.7
Pipe-based Context Switching                   4000.0      25398.2     63.5
Process Creation                                126.0        462.4     36.7
Shell Scripts (1 concurrent)                     42.4        302.1     71.3
Shell Scripts (8 concurrent)                      6.0         40.2     67.1
System Call Overhead                          15000.0     162746.0    108.5
                                                                   ========
System Benchmarks Index Score                                          94.7
````

执行图形测试，执行图形测试必须从桌面登录后执行命令

````
$ ./Run graphics
````

测试结果

````
------------------------------------------------------------------------
Benchmark Run: Thu Mar 02 2023 21:03:50 - 21:23:38
1 CPU in system; running 1 parallel copy of tests

2D graphics: aa polygons                        394.0 score (61.0 s, 2 samples)
2D graphics: ellipses                            78.4 score (56.0 s, 2 samples)
2D graphics: images and blits                 16280.7 score (53.9 s, 2 samples)
2D graphics: rectangles                          57.6 score (58.2 s, 2 samples)
2D graphics: text                              4132.5 score (57.2 s, 2 samples)
2D graphics: windows                             19.9 score (56.4 s, 2 samples)
3D graphics: gears                               23.4 fps   (20.0 s, 2 samples)

3D Graphics Benchmarks Index Values          BASELINE       RESULT    INDEX
3D graphics: gears                               33.4         23.4      7.0
                                                                   ========
3D Graphics Benchmarks Index Score                                      7.0

2D Graphics Benchmarks Index Values          BASELINE       RESULT    INDEX
2D graphics: aa polygons                         15.0        394.0    262.7
2D graphics: ellipses                            15.0         78.4     52.3
2D graphics: images and blits                    15.0      16280.7  10853.8
2D graphics: rectangles                          15.0         57.6     38.4
2D graphics: text                                15.0       4132.5   2755.0
2D graphics: windows                             15.0         19.9     13.3
                                                                   ========
2D Graphics Benchmarks Index Score                                    243.6
````

执行系统和图形两项测试，从桌面登录后执行命令

````
$ ./Run gindex
````

测试结果

````
------------------------------------------------------------------------
Benchmark Run: Thu Mar 02 2023 21:30:35 - 22:18:36
1 CPU in system; running 1 parallel copy of tests

2D graphics: aa polygons                        393.2 score (60.0 s, 2 samples)
2D graphics: ellipses                            78.1 score (54.1 s, 2 samples)
2D graphics: images and blits                 16281.3 score (55.0 s, 2 samples)
2D graphics: rectangles                          57.6 score (59.2 s, 2 samples)
2D graphics: text                              4123.2 score (56.5 s, 2 samples)
2D graphics: windows                             19.9 score (56.1 s, 2 samples)
3D graphics: gears                               24.3 fps   (20.0 s, 2 samples)
Dhrystone 2 using register variables        3136383.5 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     1119.4 MWIPS (10.0 s, 7 samples)
Execl Throughput                                170.3 lps   (29.9 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks         44013.3 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks           12760.3 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks        117544.8 KBps  (30.0 s, 2 samples)
Pipe Throughput                              102211.4 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                  23595.7 lps   (10.0 s, 7 samples)
Process Creation                                422.4 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                    285.1 lpm   (60.1 s, 2 samples)
Shell Scripts (8 concurrent)                     37.3 lpm   (61.1 s, 2 samples)
System Call Overhead                         163822.5 lps   (10.0 s, 7 samples)

2D Graphics Benchmarks Index Values          BASELINE       RESULT    INDEX
2D graphics: aa polygons                         15.0        393.2    262.1
2D graphics: ellipses                            15.0         78.1     52.1
2D graphics: images and blits                    15.0      16281.3  10854.2
2D graphics: rectangles                          15.0         57.6     38.4
2D graphics: text                                15.0       4123.2   2748.8
2D graphics: windows                             15.0         19.9     13.3
                                                                   ========
2D Graphics Benchmarks Index Score                                    243.4

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0    3136383.5    268.8
Double-Precision Whetstone                       55.0       1119.4    203.5
Execl Throughput                                 43.0        170.3     39.6
File Copy 1024 bufsize 2000 maxblocks          3960.0      44013.3    111.1
File Copy 256 bufsize 500 maxblocks            1655.0      12760.3     77.1
File Copy 4096 bufsize 8000 maxblocks          5800.0     117544.8    202.7
Pipe Throughput                               12440.0     102211.4     82.2
Pipe-based Context Switching                   4000.0      23595.7     59.0
Process Creation                                126.0        422.4     33.5
Shell Scripts (1 concurrent)                     42.4        285.1     67.2
Shell Scripts (8 concurrent)                      6.0         37.3     62.2
System Call Overhead                          15000.0     163822.5    109.2
                                                                   ========
System Benchmarks Index Score                                          89.9

3D Graphics Benchmarks Index Values          BASELINE       RESULT    INDEX
3D graphics: gears                               33.4         24.3      7.3
                                                                   ========
3D Graphics Benchmarks Index Score                                      7.3
````

所有执行结果存放在unixbench根目录下的results目录下

参考 https://github.com/kdlucas/byte-unixbench/blob/master/UnixBench/USAGE





