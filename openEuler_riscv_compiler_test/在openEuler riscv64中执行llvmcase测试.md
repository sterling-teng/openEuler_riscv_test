在openEuler riscv64中执行编译器llvmcase测试

#### 1. llvmcase  测试目的

用 gcc 编译器编译 llvm 编译器源码

#### 2. llvmcase 测试方法

##### 2.1 安装

测试环境：安装了 [openEuler riscv64 23.09](https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-23.09-V1-riscv64/QEMU/) 镜像的 sg2042

安装编译所需软件包

````
$ yum install -y gcc gcc-g++ gcc-gfortran cmake ninja-build
````

下载 llvm 源码

````
$ git clone https://github.com/llvm/llvm-project.git
$ cd llvm-project
````

编译 llvm

````
$ mkdir build && cd build
$ cmake -DLLVM_PARALLEL_LINK_JOBS=3 -DLLVM_ENABLE_PROJECTS="clang" -DLLVM_TARGETS_TO_BUILD="RISCV" -DCMAKE_BUILD_TYPE="Release" -G Ninja ../llvm
$ ninja
````

验证 llvm

````
$ bin/clang -v
clang version 19.0.0git (https://github.com/llvm/llvm-project.git 5784bf85bc5143266565586ece0113cd773a8616)
Target: riscv64-unknown-linux-gnu
Thread model: posix
InstalledDir: /root/llvm-project/build/bin
````



参考

https://llvm.org/docs/CMake.html



























