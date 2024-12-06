## openEuler RISC-V 执行 LTP功能测试

### 1. LTP 介绍

LTP {全称 Linux Test Project) 是一个开源的测试项目，旨在验证和测试 Linux 内核及其相关组件的稳定性和功能。LTP 提供了一整套测试用例，用于评估 Linux 系统的各个方面，包括系统调用、文件系统、网络、进程管理等。

官方地址：https://github.com/linux-test-project/ltp

源码目录结构：

| 名称          | 说明                                                     |
| ------------- | -------------------------------------------------------- |
| INSTALL       | LTP安装配置指导文档                                      |
| README        | LTP介绍                                                  |
| COPYING       | GNU公开许可证                                            |
| Makefile      | LTP顶层目录的Makefile，负责编译安装pan、testcases和tools |
| doc/*         | 工程文档包含工具和库函数使用手册，描述各种测试           |
| include/*     | 通用的头文件目录                                         |
| lib/*         | 通用的函数目录                                           |
| testcases/*   | 包含在LTP下运行和bin目录下的所有测试用例和链接           |
| testscripts/* | 存放分组的测试脚本                                       |
| runtest/*     | 为自动化测试提供命令列表                                 |
| pan/*         | 测试的驱动装置，具备随机和并行测试的能力                 |
| scratch/*     | 存放零碎测试                                             |
| tools/*       | 存放自动化测试脚本和辅助工具                             |

LTP测试套件内容如下：

````
$ ls ltp/testcases
Makefile  commands  cve  kdump  kernel  lib  misc  network  open_posix_testsuite  realtime
````

| 名称                 | 说明                                         |
| -------------------- | -------------------------------------------- |
| command              | 常用命令测试                                 |
| CVE                  | CVE漏洞检查测试                              |
| kdump                | 内核现崩溃转储测试                           |
| kernel               | 内核模块及其相关模块，如文件系统，磁盘读写等 |
| lib                  | 用于测试用例的公共函数                       |
| misc                 | 崩溃、核心转出、浮点运算等测试               |
| network              | 网络测试                                     |
| open_posix_testsuite | posix标准测试                                |
| realtime             | 系统实时性测试                               |

LTP测试框架不会直接调用testcase，而是通过一个中间包装脚本测试场景文件(test scenario files)来调用，放在runtest路径下面。一般一个testcase对应一个runtest文件。

默认运行哪些runtest在`scenario_groups/default`文件中定义：

````
syscalls
fs
fs_perms_simple
dio
mm
ipc
irq
sched
math
nptl
pty
containers
fs_bind
controllers
fcntl-locktests
power_management_tests
hugetlb
commands
hyperthreading
can
cpuhotplug
net.ipv6_lib
input
cve
crypto
kernel_misc
uevent
watchqueue
````

### 2. 编译安装

安装依赖包

````
$ yum install -y git make automake gcc clang pkgconf autoconf bison flex m4 kernel-headers glibc-headers clang findutils libtirpc libtirpc-devel pkg-config
````

下载源码，编译安装

````
$ git clone https://github.com/linux-test-project/ltp.git
$ cd ltp
$ make autotools
$ ./configure
$ make -j $(nproc)
$ make install
````

ltp 默认安装在 /opt/ltp 目录下

### 3. 执行测试

 进入安装目录执行默认测试

````
$ cd /opt/ltp;
$ ./runltp |tee ltp.log
````

测试结果存储在 LTP 安装目录下的 results 目录下，即 /opt/ltp/results

测试日志存储在 LTP 安装目录下的 output 目录下，即 /opt/ltp/output

测试结果的输出类型如下：

| 类型 | 描述                                 |
| ---- | ------------------------------------ |
| BROK | 程序执行中途发生错误而使测试遭到破坏 |
| CONF | 测试环境不满足而跳过执行             |
| WARN | 测试中途发生异常                     |
| INFO | 输出通用测试信息                     |
| PASS | 测试成功                             |
| FAIL | 测试失败                             |

在测试结果中过滤失败测试用例

```
$ grep -ir fail results/LTP*.log
```

重新执行失败测试用例

````
$ ./runltp -s case_name
````

case_name 是 上一步过滤出来得失败用例的名称

可以执行的测试集在 /opt/ltp/runtest/ 目录下，如果要执行某个测试集，需要用 -f 指定，例如测试 syscalls 测试集

````
$ ./runltp -f syscalls
````

如果要执行某个测试集中的测试用例，需要用 -s 指定，例如测试 syscalls 测试集里的 access01 测试用例

````
$ ./runltp -s access01
````

### 4. LTP CVE 漏洞检查

单独执行 CVE 漏洞检查测试套

````
$ ./runltp -f cve
````

### 5. LTP POSIX 标准测试

open_posix_testsuite 测试套是对 linux 系统 open_posix 符合性进行测试，测试内容如下：

| 测试内容 | 描述                         |
| -------- | ---------------------------- |
| AIO      | 执行异步 I/O 测试            |
| SIG      | 执行信号测试                 |
| SEM      | 执行信号测试                 |
| THR      | 执行线程测试                 |
| TMR      | 执行定时器和时钟测试         |
| MSG      | 执行消息队列测试             |
| TPS      | 执行线程和进程同步测试       |
| MEM      | 执行映射，处理和共享内存测试 |

ltp 默认没有编译 open_posix_testsuite 测试套，需要进入 ltp 安装目录下单独编译

````
$ cd /opt/ltp/testcases/open_posix_testsuite
$ ./configure
$ make all
````

编译完成后执行测试

````
$ cd bin
$ ./run-all-posix-option-group-tests.sh >posix_result.txt
````

测试结果有：PASSED，passed，skipped，FAILED

如果要统计测试项目通过和失败的测试用例数，可以执行以下命令

````
$ grep -o 'Test passed' posix_result.txt | wc -l
$ grep -o 'Test PASSED' posix_result.txt | wc -l
$ grep -o 'Test FAILED' posix_result.txt | wc -l
$ grep -o 'Test skipped' posix_result.txt | wc -l
````

如果需要单独测试某一项，可以使用 run-posix-option-group-test.sh 

````
$ ./run-posix-option-group-test.sh AIO
$ ./run-posix-option-group-test.sh MEM
$ ./run-posix-option-group-test.sh MSG
$ ./run-posix-option-group-test.sh SEM
$ ./run-posix-option-group-test.sh SIG
$ ./run-posix-option-group-test.sh THR
$ ./run-posix-option-group-test.sh TMR
$ ./run-posix-option-group-test.sh TPS
````

以上步骤可以直接使用自动化脚本 [ltp_posix_test.sh](./ltp_posix_test.sh)

````
$ bash ltp_posix_test.sh
````





参考：

https://www.cnblogs.com/pwl999/p/15535011.html

https://www.cnblogs.com/debruyne/p/9202250.html

https://jitwxs.cn/51dc9e04

https://blog.csdn.net/kernel_learner/article/details/8238974#_Toc311983322