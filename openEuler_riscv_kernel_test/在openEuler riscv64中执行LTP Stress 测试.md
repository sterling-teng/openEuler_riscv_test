在openEuler riscv64中执行LTP Stress 测试

#### 1. LTP stress测试介绍

ltp stress 属于 LTP 测试套件的一部分，专门用来对 linux 系统进行压力测试，可以验证 linux 系统在系统高使用率时的健壮性。

它使用 LTP 测试套件对 Linux 操作系统进行超长时间的测试，重点在于 Linux 用户环境相关的工作负荷。而并不是致力于证明缺陷。压力测试是一种破坏性的测试，即系统在非正常的、超负荷的条件下的运行情况 。用来评估在超越最大负载的情况下系统将如何运行，是系统在正常的情况下对某种负载强度的承受能力的考验。

压力测试使用 ltpstress.sh 这个脚本来执行，这个脚本并行地运行相似的测试用例，串行地运行不同的测试用例，这样做是为了避免由于同时访问同一资源或者互相干扰而引起的间歇性故障。测试内容同runltp，不同点在于runltp可以指定测试项进行组合测试，而runalltests.sh则会全部执行。默认地，这个脚本执行：

\- NFS 压力测试。

\- 内存管理压力测试。

\- 文件系统压力测试。

\- 数学(浮点)测试。

\- 多线程压力测试。

\- 硬盘 I/O 测试。

\- IPC (pipeio, semaphore) 测试。

\- 系统调用功能的验证测试。

\- 网络压力测试。

由于在目前最新 ltp 中，ltpstress.sh 已经被删除，如果想使用该脚本执行测试，可以下载 [20180515](https://github.com/linux-test-project/ltp/archive/refs/tags/20180515.zip) 版本，这个版本中有脚本 ltpstress.sh

#### 2. LTP 编译安装

安装依赖包：

````
$ yum install -y git make automake gcc pkgconf autoconf bison flex m4 kernel-headers glibc-headers clang findutils libtirpc libtirpc-devel pkg-config sysstat
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

构建并安装ltp

```
$ cd ltp
$ make autotools
$ ./configure
$ make -j $(nproc)
$ make install
```

#### 3. 执行测试

执行7天*24小时的压力测试

````
$ cd /opt/ltp/testscripts
$ ./ltpstress.sh -n -m 512 -t 168
````

测试结果默认存储在 /tmp/ 目录下，还可以指定生成日志文件的格式和路径

````
$ mkdir -p /opt/ltp/output
$ ./ltpstress.sh -i 3600 -d /opt/ltp/output/ltpstress.data -I /opt/ltp/output/ltpstress.iodata -l /opt/ltp/output/ltpstress.log -n -p -S -m 512 -t 168
$ ./ltpstress.sh -i 10 -d /opt/ltp/output/ltpstress.data -I /opt/ltp/output/ltpstress.iodata -l /opt/ltp/output/ltpstress.log -n -p -S -m 512 -t 1
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



参考：

https://gitee.com/openeuler/test-tools/tree/master/kernel-testsuite/ltpstress

https://www.cnblogs.com/debruyne/p/9202250.html

https://code.osssc.ac.cn/oepkgs/mugen/-/blob/release-2024-05/testcases/reliability_test/ltp-stress-test/oe_test_ltp_stress.sh



