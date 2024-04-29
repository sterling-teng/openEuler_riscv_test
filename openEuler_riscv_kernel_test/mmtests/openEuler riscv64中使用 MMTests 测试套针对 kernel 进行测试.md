### openEuler riscv64中使用 MMTests 测试套针对 kernel 进行测试

#### 1. MMTests 介绍

MMTests是一套用于Linux内核的基准测试组件，主要用于测试计算机系统在不同条件下的性能差异。

MMTests是一个可配置的测试套件，允许开发者进行常规测试。它可以与其他测试工具如LTP和xfstests结合使用，以实现自动化测试。测试套件中的run-mmtests.sh脚本用于运行测试，它会读取配置文件以确定测试的参数和内核配置。每种测试都有对应的配置文件，这些文件位于configs目录下。

#### 2. 在openEuler RISC-V中使用MMTests

硬件环境：D1开发板烧入openEuler riscv64 22.03 v2 版本 https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-22.03-V2-riscv64/D1/

##### 2.1 编译并安装所需软件包

安装依赖包

````
$ yum install -y git expect tar make pcre-devel bzip2-devel xz-devel libcurl-devel libcurl texinfo gcc-gfortran java-1.8.0-openjdk-devel gnuplot wget libXt-devel readline-devel glibc-headers gcc-c++ zlib zlib-devel
````

下载并编译安装R包

```
$ wget https://mirror.lzu.edu.cn/CRAN/src/base/R-3/R-4.4.0.tar.gz
$ R_dir=$(pwd)/R-4.4.0.tar.gz
$ mkdir -p /usr/local/R
$ cp -r $R_dir /opt/ && cd /opt/
$ tar -zxf R-4.4.0.tar.gz
$ cd R-4.4.0
$ ./configure --enable-R-shlib=yes --with-tcltk --prefix=/usr/local/R
$ make
$ make install
$ ln -s /usr/local/R/bin/R /usr/bin/R
$ ln -s /usr/local/R/bin/Rscript /usr/bin/Rscript
```

下载并编译安装List-BinarySearch：

````
$ git clone https://github.com/daoswald/List-BinarySearch.git
$ LBS_dir=$(pwd)/List-BinarySearch
$ cp $LBS_dir /opt/ && cd /opt/
$ cd List-BinarySearch
$ echo y|perl Makefile.PL
$ make
$ make test
$ make install
````

下载并编译安装File-Slurp

````
$ wget https://cpan.metacpan.org/authors/id/C/CA/CAPOEIRAB/File-Slurp-9999.32.tar.gz
$ FS_dir=$(pwd)/File-Slurp-9999.32.tar.gz
$ cp $FS_dir /opt/ && cd /opt/
$ tar -zxf File-Slurp-9999.32.tar.gz
$ cd File-Slurp-9999.32
$ perl Makefile.PL -y
$ make
$ make test
$ make install
````

##### 2.2 执行测试

安装测试所需依赖包

````
$ yum install -y zlib zlib-devel bc httpd net-tools gcc-c++ m4 flex byacc bison keyutils-libs-devel lksctp-tools-devel xfsprogs-devel libacl-devel openssl-devel numactl-devel libaio-devel glibc-devel libcap-devel findutils libtirpc libtirpc-devel kernel-headers glibc-headers hwloc-devel patch numactl tar automake cmake time psmisc git expect fio sysstat  popt-devel libstdc++ libstdc++-static openssl elfutils-libelf-devel slang-devel libbabeltrace-devel zstd-devel gtk2-devel systemtap libtool rpcgen vim
````

下载  mmtests 测试套

````
$ cd /opt
$ git clone https://github.com/gormanm/mmtests.git
$ cd mmtests
````

run-mmtests.sh是运行测试的脚本，这个脚本会读取config文件，config 文件在 configs 目录下，每一种测试都有对应的 config 文件，运行命令参数如下所示

````
NAME
    run-mmtests.sh - Install and execute a set of tests as specified by a configuration file

SYNOPSIS
    run-mmtests [options] test-name

     Options:
     -m, --run-monitors     Run with monitors enabled as specified by the configuration
     -n, --no-monitor       Only execute the benchmark, do not monitor it
     -p, --performance      Set the performance cpufreq governor before starting
     -c, --config           Configuration file to read (default: config)
     -b, --build-only       Only build the benchmark, do not execute it
         --mount-only       Only mount test disk
         --no-mount         Don't mount test disk
     -h, --help             Print this help

DESCRIPTION
    run-mmtests.sh is for test installation and execution. If monitors are enabled, they start monitoring after the benchmark has been installed and configured.

    The test-name can be anything and only specifies the name of the directory under work/log so uniquely identify the test. An obvious example is using the kernel name or the name of a patch. It could also be based on changing userspace packages, the benchmark configuration, system tuning or different machine names.

    The work/log/test-name directory will have all the raw logs of the benchmark itself, any monitoring and some basic information about the machine configuration for offline analysis.

EXAMPLE
    $ ./bin/autogen-configs

    $ ./run-mmtests.sh --no-monitor --config configs/config-pagealloc-performance 5.8-vanilla

    $ ./run-mmtests.sh --no-monitor --config configs/config-pagealloc-performance 5.9-vanilla

AUTHOR
    Mel Gorman <mgorman@techsingularity.net>

REPORTING BUGS
    Report bugs to the author.
````

使用 run-mmtests.sh 执行测试

````
$ ./run-mmtests.sh --no-monitor --config configs/config-buildtest-hpc-boost
````

可以将所要进行的测试的配置文件写在一个文件里，然后读取这个文件执行测试，例如写在cnf.txt文件里

````
cf=${1-cnf.txt}
configs=$(cat $cf|grep -v "#")
for cnf in ${configs[@]}
do
    bash run-mmtests.sh --no-monitor --config configs/$cnf $cnf 2>&1 | tee log/$cnf.log
done
````

测试结束后，测试结果存放在当前目录的 work/log 下

````
$ ls work/log/config-buildtest-hpc-blas/iter-0/ -l
total 208
drwxr-xr-x 3 root root  4096 Feb  4 18:07 blasbuild
-rw-r--r-- 1 root root 10477 Feb  4 18:07 cgroup-tree.txt.gz
-rw-r--r-- 1 root root   380 Feb  4 18:07 cpu-topology-mmtests.txt.gz
-rw-r--r-- 1 root root   102 Feb  4 18:07 cpuidle.txt.gz
-rw-r--r-- 1 root root   270 Feb  4 18:07 cpupower.txt.gz
-rw-r--r-- 1 root root     0 Feb  4 18:07 cstate-latencies-config-buildtest-hpc-blas.txt
-rwxr-xr-x 1 root root 58668 Feb  4 18:07 kconfig-6.1.61-4.oe2309.riscv64.txt.gz
-rw-r--r-- 1 root root  1497 Feb  4 18:07 kernel-tuning.txt.gz
-rw-r--r-- 1 root root   118 Feb  4 18:07 kernel.version
-rw-r--r-- 1 root root   177 Feb  4 18:07 lscpu.txt.gz
-rw-r--r-- 1 root root    84 Feb  4 18:07 lsscsi.txt.gz
-rw-r--r-- 1 root root 13163 Feb  4 18:07 lstopo.pdf.gz
-rw-r--r-- 1 root root  2550 Feb  4 18:07 lstopo.txt.gz
-rw-r--r-- 1 root root  7141 Feb  4 18:07 network-tuning.txt.gz
-rw-r--r-- 1 root root   294 Feb  4 18:07 numactl.txt.gz
-rw-r--r-- 1 root root  9527 Feb  4 18:07 sysctl-tuning.gz
-rw-r--r-- 1 root root 31727 Feb  4 18:07 systemctl-units.txt
-rw-r--r-- 1 root root   115 Feb  4 18:07 tests-activity
-rw-r--r-- 1 root root  7677 Feb  4 18:07 tests-sysstate
-rw-r--r-- 1 root root    20 Feb  4 18:07 tests-timestamp
-rw-r--r-- 1 root root    47 Feb  4 18:07 tuned-active-profile.txt
-rw-r--r-- 1 root root  2774 Feb  4 18:07 tuned-available-profile.txt
-rw-r--r-- 1 root root   563 Feb  4 18:07 vm-tuning.txt.gz
````

可以将以上所有步骤写成一个脚本，只要执行这个脚本就可以了

````
#/usr/bin/bash
prepare_env(){
    dnf install -y git expect tar make pcre-devel bzip2-devel xz-devel libcurl-devel  libcurl texinfo gcc-gfortran java-1.8.0-openjdk-devel gnuplot wget libXt-devel readline-devel glibc-headers
    until (test -e "R-3.6.3.tar.gz")
    do
        wget https://mirror.lzu.edu.cn/CRAN/src/base/R-3/R-3.6.3.tar.gz
    done
    R_dir=$(pwd)/R-3.6.3.tar.gz
    until (test -e "List-BinarySearch")
    do
        git clone https://github.com/daoswald/List-BinarySearch.git
    done
    LBS_dir=$(pwd)/List-BinarySearch
    until (test -e "File-Slurp-9999.32.tar.gz")
    do
        wget https://cpan.metacpan.org/authors/id/C/CA/CAPOEIRAB/File-Slurp-9999.32.tar.gz
    done
    FS_dir=$(pwd)/File-Slurp-9999.32.tar.gz
    until (test -e "cnf.txt")
    do
        wget https://gitee.com/jean9823/openEuler_riscv_test/raw/master/openEuler_riscv_kernel_test/mmtests/cnf.txt
    done
    cnf_dir=$(pwd)/cnf.txt
    cd /opt
    until (test -e "mmtests")
    do
        git clone https://github.com/gormanm/mmtests.git
    done

    #install R
    mkdir -p /usr/local/R
    cp $R_dir /opt/ && cd /opt/
    ##wget https://mirror.lzu.edu.cn/CRAN/src/base/R-3/R-3.6.3.tar.gz
    [ -d R-3.6.3 ] && rm -rf R-3.6.3
    tar -zxf R-3.6.3.tar.gz
    cd R-3.6.3
    ./configure --enable-R-shlib=yes --with-tcltk --prefix=/usr/local/R
    make
    make install
    ln -s /usr/local/R/bin/R /usr/bin/R
    ln -s /usr/local/R/bin/Rscript /usr/bin/Rscript
    
    cp $LBS_dir /opt/ && cd /opt/
    ##git clone https://github.com/daoswald/List-BinarySearch.git
    [ -d List-BinarySearch ] && rm -rf List-BinarySearch
    # unzip List-BinarySearch-v0.25.zip
    cd List-BinarySearch
    echo y|perl Makefile.PL
    make
    make test
    make install
    
    cp $FS_dir /opt/ && cd /opt/
    ##wget https://cpan.metacpan.org/authors/id/C/CA/CAPOEIRAB/File-Slurp-9999.32.tar.gz
    [ -d File-Slurp-9999.32 ] && rm -rf File-Slurp-9999.32
    tar -zxf File-Slurp-9999.32.tar.gz
    cd File-Slurp-9999.32
    perl Makefile.PL -y
    make
    make test
    make install
}

run_mmtests(){
    yum install -y zlib zlib-devel bc httpd net-tools gcc-c++ m4 flex byacc bison keyutils-libs-devel lksctp-tools-devel xfsprogs-devel libacl-devel openssl-devel numactl-devel libaio-devel glibc-devel libcap-devel findutils libtirpc libtirpc-devel kernel-headers glibc-headers hwloc-devel patch numactl tar automake cmake time psmisc git expect fio sysstat  popt-devel libstdc++ libstdc++-static openssl elfutils-libelf-devel slang-devel libbabeltrace-devel zstd-devel gtk2-devel systemtap libtool rpcgen vim

    cp $cnf_dir /opt/mmtests
    cd /opt/mmtests
    [ -d log ] || mkdir log
    cf=${1-cnf.txt}
    configs=$(cat $cf|grep -v "#")
    for cnf in ${configs[@]}
    do
        echo "--------------   start run $cnf   `date +%Y%m%d-%H%M%S`------------------------------"
        rm -rf /opt/mmtests/work/testdisk/ 
        time timeout 7200 bash run-mmtests.sh --no-monitor --config configs/$cnf $cnf 2>&1 | tee log/$cnf.log
        df -h|grep openeuler.*-root
        echo "--------------   end run $cnf     `date +%Y%m%d-%H%M%S`------------------------------"
    done
}

prepare_env
run_mmtests
````

执行以上脚本执行测试，测试完成后，测试结果存放在 当前目录的 log 目录下，通过执行以下命令可以过滤出执行失败的测试

````
$ grep -iEl "test exit :: .* 0|143" log/*
log/config-buildtest-hpc-cmake.log
log/config-buildtest-hpc-fftw.log
log/config-buildtest-hpc-gmp.log
log/config-buildtest-hpc-metis.log
log/config-buildtest-hpc-revocap.log
log/config-db-sqlite-insert-small.log
log/config-functional-ltp-containers.log
````



参考：

https://github.com/gormanm/mmtests/tree/master

https://gitee.com/openeuler/test-tools/tree/master/kernel-testsuite/mmtests

