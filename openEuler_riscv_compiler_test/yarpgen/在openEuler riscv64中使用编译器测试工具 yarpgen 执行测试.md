在openEuler riscv64中使用编译器测试工具 yarpgen 执行测试

#### 1.  yarpgen 介绍

yarpgen 是一个随机程序生成器，它生成正确的可运行的C/C++和DPC++（这项工作处于早期阶段）程序。该生成器专门设计用于触发编译器优化错误，并用于编译器测试。

生成的随机程序保证是静态和动态正确的程序。每个生成的程序都由多个文件组成，编译运行后会产生一个十进制数，它是所有程序全局变量值的哈希值。对于所有编译器和优化级别来说，这个数字应该是相同的。如果不同编译器和/或优化级别的输出不同，应该是遇到了编译器错误。

#### 2. yarpgen 使用方法

##### 2.1 安装

测试环境：使用 [openEuler riscv64 23.09](https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-23.09-V1-riscv64/QEMU/) 镜像的 QEMU

下载 yarpgen 源码

````
$ git clone https://github.com/intel/yarpgen.git
````

安装测试所需软件包

````
$ yum install -y cmake gcc gcc-g++ clang
````

编译 yarpgen

````
$ mkdir build
$ cd build
$ cmake ..
$ make
````

编译完成后，build目录下会有 yarpgen 的同名可执行文件。执行该文件即可随机生成测试程序

````
$ mkdir test
$ cd test
$ ../yarpgen
/*SEED 3844364075*/
$ ls
driver.cpp  func.cpp  init.h
````

可以看到生成三个文件: init.h，func.cpp，driver.cpp

init.h：声明了测试用例中的全局变量和数据结构

func.cpp：包含了真正的测试代码，并在注释中标注了生成该用例时的 yarpgen 版本、生成时间、种子和生成命令

driver.cpp：对全局变量进行初始化，main函数调用测试函数并计算测试结果的校验和

执行测试前，先将这三个文件合并成一个文件

````
$ cat init.h func.cpp driver.cpp > random.cpp
````

使用 gcc 编译器编译该文件，并执行该文件

````
$ g++ random.cpp -o gcc.out
$ ./gcc.out
175247766531
````

使用 llvm 编译器编译该文件，并执行该文件

````
$ clang++ random.cpp -o clang.out
$ ./clang.out
175247766531
````

对于随机生成的同一个测试程序来说，不论使用哪种编译器，设置哪种优化等级，编译运行后生成的十进制数都是相同的。

为了提高测试效率，编写了自动化脚本 [run_yarpgen.sh](https://gitee.com/jean9823/openEuler_riscv_test/blob/master/openEuler_riscv_compiler_test/yarpgen/run_yarpgen.sh) 来执行测试，在编译目录 build 下，执行

````
$ bash run_yarpgen.sh 100 | tee ./result.txt
````

100 表示随机生成的测试程序程序数量，可以根据自己的需求来输入。

测试失败的log存放在编译目录 build 下的 yarpgen_failure_log 目录下

````
$ ls yarpgen_failure_log/
seed_3105299915
$ ls yarpgen_failure_log/seed_3105299915
driver.cpp  func.cpp  init.h  log.txt  test_random.cpp 
````



参考：

https://github.com/intel/yarpgen

https://blog.csdn.net/ClarkCC/article/details/128526091

[测试能力执行指南](https://gitee.com/openeuler/QA/blob/master/openEuler%E7%A4%BE%E5%8C%BA%E6%B5%8B%E8%AF%95%E8%83%BD%E5%8A%9B%E6%89%A7%E8%A1%8C%E6%8C%87%E5%8D%97/openEuler%E7%A4%BE%E5%8C%BA%E6%B5%8B%E8%AF%95%E8%83%BD%E5%8A%9B%E6%89%A7%E8%A1%8C%E6%8C%87%E5%8D%97.md#106yarpgen)

