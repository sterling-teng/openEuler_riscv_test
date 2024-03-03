在openEuler riscv64中执行 Jotai Benchmark 测试

#### 1.  Jotai 介绍

Jotai 是从开源存储库中挖掘的可执行基准的大型集合。每个基准测试都包含一个用 C 编写的函数，以及一个运行该函数的驱动程序。

Jotai 取自 [AnghaBench](http://cuda.dcc.ufmg.br/angha/home) 存储库，并通过代码进行了增强以为其生成输入。

#### 2. Jotai 使用方法

##### 2.1 安装

测试环境：使用 [openEuler riscv64 23.09](https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-23.09-V1-riscv64/QEMU/) 镜像的 QEMU

下载 Jotai 源码

````
$ git clone https://github.com/lac-dcc/jotai-benchmarks.git
````

安装测试所需软件包

````
$ yum install -y gcc
````

测试程序源码存放于两个文件夹中

anghaLeaves：不调用任何其他函数的基准函数

anghaMath：调用函数的基准函数 math.h

每一个测试程序由单个文件组成。该文件包含一个函数（我们称之为 benchmark）以及编译和运行该函数所需的所有内容：输入生成器、前向声明、函数`main`、生成随机数的内容等。

测试方法比较简单：编译并运行每一个测试文件，每个可执行程序接收一个参数：一个整数，指定将使用哪个输入来运行该程序。每个测试程序至少有输入 0，但通常他们有更多输入(1、2、...)。例如

````
$ cd benchmarks/anghaLeaves/
$ gcc extr_Arduinotestsdevicetest_libcmemmove1.c_mymemmove_Final.c -o a.out
$ ./a.out 0
````

要查看该测试程序可用的所有输入，只需要运行程序而不向其传递参数即可。

````
$ ./a.out
Usage:
    prog [OPTIONS] [ARGS]

    ARGS:
       0    big-arr
       1    big-arr-10x
````

为了提高测试效率，编写了自动化测试脚本 [jotai_run.sh](https://gitee.com/jean9823/openEuler_riscv_test/blob/master/openEuler_riscv_compiler_test/jotai/jotai_run.sh)，可以使用该自动化脚本执行测试

````
$ cd jotai-benchmarks
$ wget https://gitee.com/jean9823/openEuler_riscv_test/raw/master/openEuler_riscv_compiler_test/jotai/jotai_run.sh
$ bash ./jotai_run.sh | tee ../result.log
````

测试失败的 log 存放在当前 jotai-benchmarks 源码根目录下的 anghaLeaves_failure_log 和 anghaMath_failure_log 目录下，分别对应于anghaLeaves 和 anghaMath 目录下的测试程序



参考：

https://github.com/lac-dcc/jotai-benchmarks/tree/main
