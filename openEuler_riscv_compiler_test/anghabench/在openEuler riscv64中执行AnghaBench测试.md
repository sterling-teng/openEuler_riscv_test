在openEuler riscv64中执行 AnghaBench 测试

#### 1.  AnghaBench 介绍

AnghaBench 是一个包含 100 万个可编译 C 程序的基准套件，可用于对 C 编译器进行编译测试

#### 2. AnghaBench 使用方法

##### 2.1 安装

测试环境：使用 [openEuler riscv64 23.09](https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-23.09-V1-riscv64/QEMU/) 镜像的 QEMU

下载 AnghaBench 源码

````
$ git clone https://github.com/brenocfg/AnghaBench.git
````

安装 gcc

````
$ yum install -y gcc
````

##### 2.2 执行测试

执行测试就是将 AnghaBench 源码目录及其子目录下的 .c 文件 用 gcc 编译，将该步骤写成 shell 脚本，测试时直接执行该 shell 脚本即可

脚本存放在 [anghabench_run.sh](../../anghabench/anghabench_run.sh)

````
$ cd AnghaBench
$ wget https://gitee.com/jean9823/openEuler_riscv_test/raw/master/openEuler_riscv_compiler_test/AnghaBench/anghabench_run.sh
$ mkdir log
$ bash ./anghabench_run.sh | tee ../result.log
````

执行 anghabench_run.sh 后，所有 失败的 log 都存放在当前 AnghaBench 源码根目录下的 log_failure 目录下



参考：

[AnghaBench 官网](http://cuda.dcc.ufmg.br/angha/home)

[openEuler社区测试能力执行指南](https://gitee.com/openeuler/QA/blob/master/openEuler%E7%A4%BE%E5%8C%BA%E6%B5%8B%E8%AF%95%E8%83%BD%E5%8A%9B%E6%89%A7%E8%A1%8C%E6%8C%87%E5%8D%97/openEuler%E7%A4%BE%E5%8C%BA%E6%B5%8B%E8%AF%95%E8%83%BD%E5%8A%9B%E6%89%A7%E8%A1%8C%E6%8C%87%E5%8D%97.md#103anghabench)

