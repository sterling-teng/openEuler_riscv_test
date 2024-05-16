在openEuler riscv64中使用DejaGnu执行编译器测试

#### 1. DejaGnu 介绍

DejaGnu 是开源的 GNU 测试框架，为所有测试提供统一的前端。它是用 Expect 编写的，而Expect 又使用 Tcl (工具命令语言)。

DejaGnu 的优点：

- DejaGnu 框架的灵活性和一致性使得可以轻松地为任何程序（无论是面向批处理的程序还是交互式程序）编写测试
- DejaGnu 提供了一个抽象层，允许编写可移植到必须测试程序的任何主机或目标的测试。例如，测试`GDB`可以在任何受支持的目标系统上的任何受支持的主机系统上运行。DejaGnu 在许多单板计算机上运行测试，其操作软件范围从简单的启动监视器到实时操作系统。
- 所有测试都具有相同的输出格式。这使得将测试集成到其他软件开发过程变得很容易。DejaGnu 的输出被设计为可以被其他过滤脚本解析，并且也是人们可读的。
- 使用 Tcl 和 Expect，可以轻松地为现有测试套件创建包装器。通过合并 DejaGnu 下的现有测试，可以更轻松地拥有一组报告分析程序。

运行测试需要两件事：测试框架和测试套件本身。测试通常使用 Tcl 在 Expect 中编写，但也可以使用 Tcl 脚本来运行不基于 Expect 的测试套件。

#### 2. DejaGnu 安装和使用

##### 2.1 安装

安装环境：D1开发版烧入 openEuler riscv64 23.03 v1 版本 https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-23.03-V1-riscv64/

安装 dejagnu 有两种方式：

方式一：直接安装 dejagnu 软件包

````
$ yum install -y dejagnu
$ runtest --version    //查看 dejagnu 版本
````

方式二：从 dejagnu 源码编译并安装

下载 dejagnu 源码

````
$ git clone git://git.sv.gnu.org/dejagnu.git
````

编译并安装

````
$ yum install texinfo
$ mkdir install_runtest
$ cd dejagnu
$ ./configure --prefix=/root/install_runtest    //配置
$ make -j $(nproc)     //编译   
$ make -j -k check    //测试编译结果
$ make install        //安装
$ export PATH=/root/install_runtest/bin:$PATH         //将 dejagnu 设置到环境变量里
$ dejagnu --version          //查看 dejagnu 版本以确认其是否有安装成功
````

安装 gcc 相关软件包

````
$ yum install -y gcc gcc-g++ gcc-gfortran
````

获取测试套

````
$ git clone https://gitee.com/openeuler/gcc.git
$ cd gcc/gcc/testsuite/
````

##### 2.2 执行测试

运行gcc测试套

````
$ runtest --tool gcc
````

测试结果

````
	    === gcc Summary ===

# of expected passes		2570
# of unexpected failures	69994
# of unexpected successes	79
# of expected failures		449
# of unresolved testcases	20013
# of unsupported tests		4776
/usr/bin/gcc  version 10.3.1 (GCC) 
````

测试结果在当前目录下，gcc.log 是详细日志文件，gcc.sum 是摘要日志文件

gcc.log：显示测试用例生成的任何输出以及摘要输出

gcc.sum：此摘要列出了所有运行的测试文件的名称。对于每个测试文件，每个`pass`命令（显示状态 PASS或XPASS）或`fail`命令（状态 FAIL或XFAIL）的一行输出、统计通过和失败测试（预期和意外）的尾随摘要统计信息、测试工具的完整路径名，以及工具的版本号

运行 g++ 测试套

````
$ runtest --tool g++
````

测试结果

````
         === g++ Summary ===

# of expected passes            5207
# of unexpected failures        153216
# of unexpected successes       306
# of expected failures          628
# of unresolved testcases       19320
# of unsupported tests          11706
/usr/bin/c++  version 10.3.1 (GCC)
````

测试结果在当前目录下，g++.log 是详细日志文件，g++.sum 是摘要日志文件

运行 gfortran 测试套

````
$ runtest --tool gfortran
````

测试结果

````
		=== gfortran Summary ===

# of expected passes		102
# of unexpected failures	35335
# of expected failures		13
# of unresolved testcases	18269
# of untested testcases		1752
# of unsupported tests		977
/usr/bin/gfortran  version 10.3.1 (GCC)
````

测试结果在当前目录下，gfortran.log 是详细日志文件，gfortran.sum 是摘要日志文件



参考：

[dejagnu 官网](https://www.gnu.org/software/dejagnu/)

[openEuler社区测试能力执行指南](https://gitee.com/openeuler/QA/blob/master/openEuler%E7%A4%BE%E5%8C%BA%E6%B5%8B%E8%AF%95%E8%83%BD%E5%8A%9B%E6%89%A7%E8%A1%8C%E6%8C%87%E5%8D%97/openEuler%E7%A4%BE%E5%8C%BA%E6%B5%8B%E8%AF%95%E8%83%BD%E5%8A%9B%E6%89%A7%E8%A1%8C%E6%8C%87%E5%8D%97.md#101dejagnu)